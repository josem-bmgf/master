using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Web.Services.Protocols;
using System.Xml;
using System.IO;
using System.Xml.XPath;
using System.Xml.Schema;

namespace ReportDeployer
{
    public class ReportDeployerCtrl
    {
        ReportDeployerClient _client;
        String _bmgfReportServer;

        public ReportDeployerCtrl()
        {
            _bmgfReportServer =  ReportDeployer.Properties.Settings.Default.BmgfReportServer;
        }
     

        public ReportModel loadReportMetadata(String reportMetadataFile, String reportMetadataSchema)
        {
            XmlDocument reportMetadataDoc = loadReportMetaDataXml(reportMetadataFile, reportMetadataSchema);

            ReportModel reportModel = buildReportingServiceObjectModel(reportMetadataDoc);

            return reportModel;
        }

       

        public void connect()
        {
            _client = new ReportDeployerClient();
        }


      

        public void cleanup()
        {
            _client.cleanup();
        }

        public void addItems(ReportModel reportModel)
        {
            List<Folder> folders = reportModel.getFolders();
            List<Datasource> ds = reportModel.getDatasources();

            _client.addDatasources(ds);
            _client.addFolders(folders); 
            _client.addPermissions(folders); 
            _client.addReports(folders); 
          
        }

        public void deleteItems(ReportModel reportModel)
        {
            List<Folder> folders = reportModel.getFolders();
            List<Datasource> datasources = reportModel.getDatasources();
            _client.deleteReports(folders);
            _client.deleteFolders(folders);
            _client.deleteDatasources(datasources);

        }

        public void loadBmgfReportDescriptions(ReportModel reportModel, String dwVersion)
        {
            
            List<Folder> folders = reportModel.getFolders();
            BmgfReport reportDesc = new BmgfReport(_bmgfReportServer, dwVersion);
  
            reportDesc.loadReportMetadata(folders);
        }

        private XmlDocument loadReportMetaDataXml(String reportMetadataFile, String reportMetadataSchema)
        {
            XmlReaderSettings settings = new XmlReaderSettings();
            settings.Schemas.Add("", reportMetadataSchema);
            settings.ValidationType = ValidationType.Schema;

            XmlReader reader = XmlReader.Create(reportMetadataFile, settings);
            XmlDocument reportMetadataDoc = new XmlDocument();
            reportMetadataDoc.Load(reader);

            ValidationEventHandler eventHandler = new ValidationEventHandler(ValidationEventHandler);

            // the following call to Validate succeeds.
            reportMetadataDoc.Validate(eventHandler);


            return reportMetadataDoc;
        }

        private ReportModel buildReportingServiceObjectModel(XmlDocument reportMetadataDoc)
        {
            List<Datasource> datasrouces = buildDatasources(reportMetadataDoc.GetElementsByTagName("DATASOURCE"));
            List<Folder> folders = buildFolders(reportMetadataDoc.GetElementsByTagName("FOLDER"), datasrouces);
            ReportModel reportMetadata = new ReportModel(datasrouces, folders);

            return reportMetadata;
        }

        private List<Folder> buildFolders(XmlNodeList folderNodeList, List<Datasource> datasrouces)
        {
            List<Folder> folders = new List<Folder>();
         

            foreach (XmlNode folderNode in folderNodeList)
            {
                //See if folder was added as a child
                int count = 0;
                Folder parentfolder = null;
                //search each root folder
                while (parentfolder == null && count < folders.Count)
                {
                    List<Folder> tmpFolders = new List<Folder>();
                    tmpFolders.Add(folders[count]);
                    parentfolder = findFolder(tmpFolders, folderNode.Attributes["path"].Value);
                    count++;
                }

                if (parentfolder == null)
                {
                    parentfolder = createFolder(folderNode, null);
                    folders.Add(parentfolder);
                }
               

                //CREATE SECURITY and REPORTS
                XmlNodeList children = folderNode.ChildNodes;
                foreach (XmlNode child in children)
                {
                    if ("SECURITY".Equals(child.Name))
                    {
                        Security security = createSecurity(child, parentfolder.getName());
                        parentfolder.addSecurity(security);
                    }
                    else if ("REPORT".Equals(child.Name))
                    {
                        Report report = createReport(child, parentfolder.getName(), datasrouces);
                        parentfolder.addReport(report);
                    }
                    else if ("FOLDER".Equals(child.Name))
                    {
                        createFolder(child, parentfolder);
                    } 
                }
                
            }
            return folders;
        }

        private List<Datasource> buildDatasources(XmlNodeList datasourceNodeList)
        {
             List<Datasource> datasources = new List<Datasource>();
             foreach (XmlNode dsNode in datasourceNodeList)
             {
                 String name = dsNode.Attributes["name"].Value;
                 String connection = dsNode.Attributes["connection"].Value;
                 String datasourceFolder = dsNode.Attributes["datasourceFolderPath"].Value;
                 String datasourceUserName = dsNode.Attributes["UserName"].Value;
                 String datasourceUserPass = dsNode.Attributes["UserPass"].Value;

                 String datasourceIsHiddenStr = dsNode.Attributes["isHidden"].Value;
                 Boolean datasourceIsHidden = convertStringToBool(datasourceIsHiddenStr, "isHidden", name);

                 String datasourceIsActiveStr = dsNode.Attributes["isActive"].Value;
                 Boolean datasourceIsActive = convertStringToBool(datasourceIsActiveStr, "isActive", name);

                 String datasourceIsDeletedStr = dsNode.Attributes["isDeleted"].Value;
                 Boolean datasourceIsDeleted = convertStringToBool(datasourceIsDeletedStr, "isDeleted", name);

                 String datasourceIsWinCredentialStr = dsNode.Attributes["isWinCredential"].Value;
                 Boolean datasourceIsWinCredential = convertStringToBool(datasourceIsWinCredentialStr, "isWinCredential", name);

                 Datasource ds = new Datasource(name, connection, datasourceFolder, datasourceIsDeleted, datasourceIsActive, datasourceIsHidden, datasourceUserName, datasourceUserPass, datasourceIsWinCredential);
                 datasources.Add(ds);
             }
             return datasources;
        }


        private Folder createFolder(XmlNode folderNode, Folder parentFolder)
        {
            //CREATE FOLDER
            String folderName = folderNode.Attributes["name"].Value;
            if (folderName == null)
                throw new ReportMetadataIllegalFormatException("A Folder's name attribute is null. Name is a required attribute. " +
                    "Please review the reportMetadata.xml file");

            String path = folderNode.Attributes["path"].Value;
            if (path == null)
                throw new ReportMetadataIllegalFormatException("Folder " + folderName + " has a null path attribute. Path is a required attribute. " +
                    "Please review the reportMetadata.xml file");

            String description = folderNode.Attributes["description"].Value;


            String isHiddenStr = folderNode.Attributes["isHidden"].Value;
            Boolean isHidden = convertStringToBool(isHiddenStr, "isHidden", folderName);

            String isDeletedStr = folderNode.Attributes["isDeleted"].Value;
            Boolean isDeleted = convertStringToBool(isDeletedStr, "isDeleted", folderName);

            String isActiveStr = folderNode.Attributes["isActive"].Value;
            Boolean isActive = convertStringToBool(isActiveStr, "isActive", folderName);

            String inheritSecurityStr = folderNode.Attributes["inheritSecurity"].Value;
            Boolean inheritSecurity = convertStringToBool(inheritSecurityStr, "inheritSecurity", folderName);

            Folder folder = new Folder(folderName, description, path, isHidden, isActive, isDeleted, parentFolder, inheritSecurity);
            if (parentFolder != null)
                parentFolder.addChild(folder);

            return folder;
        }

        private Report createReport(XmlNode reportNode, String parentFolder, List<Datasource> datasources)
        {
            String reportName = reportNode.Attributes["name"].Value;
            if (reportName == null)
                throw new ReportMetadataIllegalFormatException("A Report's name attribute is null for folder " + parentFolder +
                    ". Name is a required attribute. " +
                    "Please review the reportMetadata.xml file");


            String reportDescription = reportNode.Attributes["description"].Value;
            String technicalDescription = reportNode.Attributes["technicalDescription"].Value;

            String reportIsHiddenStr = reportNode.Attributes["isHidden"].Value;
            Boolean reportIsHidden = convertStringToBool(reportIsHiddenStr, "isHidden", reportName);

            String reportIsActiveStr = reportNode.Attributes["isActive"].Value;
            Boolean reportIsActive = convertStringToBool(reportIsActiveStr, "isActive", reportName);

            String reportIsDeletedStr = reportNode.Attributes["isDeleted"].Value;
            Boolean reportIsDeleted = convertStringToBool(reportIsDeletedStr, "isDeleted", reportName);

            Report report = new Report(reportName, reportDescription, 
                        technicalDescription, reportIsHidden, reportIsActive, reportIsDeleted);

            //associate datasource
            String datasourceName1 = reportNode.Attributes["datasourceName1"].Value;
            String datasourceName2 = reportNode.Attributes["datasourceName2"].Value;

            Datasource ds1 = datasources.Find(datasourceName(datasourceName1));
            Datasource ds2 = datasources.Find(datasourceName(datasourceName2));
            if (ds1 != null)
                report.addDataSources(ds1);
            if (ds2 != null)
                report.addDataSources(ds2);

            return report;
        }

        //used in find to find a datasource in the list by its name attribute
        private Predicate<Datasource> datasourceName(String name)
        {
            return delegate(Datasource ds)
            {
                return ds.getName().Equals(name);
            };
        }

        //delegate for schema validation
        private void ValidationEventHandler(object sender, ValidationEventArgs e)
        {
            switch (e.Severity)
            {
                case XmlSeverityType.Error:
                    throw new ReportMetadataIllegalFormatException("Error: {0} " +
                        "xml metadata configuration is not formatted correctly. " + e.Message);
                case XmlSeverityType.Warning:
                    Console.WriteLine("Warning {0}", e.Message);
                    break;
            }

        }


        private Security createSecurity(XmlNode securityNode, String parentFolder)
        {
            String role = securityNode.Attributes["role"].Value;
            String groupName = securityNode.Attributes["name"].Value;
            if (groupName != null && role == null)
                throw new ReportMetadataIllegalFormatException("The AD group " + groupName + " for folder " + parentFolder +
                    " has a null role. Role is required if an AD Group is defined for a folder. " +
                    "Please review the reportMetadata.xml file");

            Security security = new Security(groupName, role);

            return security;
        }


        private Boolean convertStringToBool(String value, String name, String tagName)
        {
            Boolean result = false;

            if (value != null)
            {

                if (value.ToLower().Equals("true"))
                {
                    result = true;
                }
            }
            else
            {
                Console.WriteLine("The " + name + " Attribute for " + tagName +
                                  " is not set. Setting " + tagName + " " + name + "=FALSE");
            }
            return result;
        }



        //find folder in object model
        private Folder findFolder(List<Folder> folders, String path)
        {
            foreach (Folder folder in folders)
            {
                if ((folder.getPath().Equals(path)))
                {
                    return folder;
                }
                else
                {
                    List<Folder> children = folder.getChildren();
                    return findFolder(children, path);
                }

                
            }
            return null;
        }
    }
}
