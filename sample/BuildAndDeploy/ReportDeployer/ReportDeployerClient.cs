using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.SqlServer.ReportingServices2005;
using System.Web.Services.Protocols;
using System.IO;

namespace ReportDeployer
{
    public class ReportDeployerClient
    {
        SearchCondition _condition;
        Property[] _searches;
        ReportingService2005 _client;

        public ReportDeployerClient()
        {
            _condition = new SearchCondition();
            _condition.Condition = ConditionEnum.Contains;
            _condition.ConditionSpecified = true;
            _condition.Name = "Name";

            Property search = new Property();
            search.Name = "Resursive";
            search.Value = "True";
            _searches = new Property[1];
            _searches[0] = search;
            
            //connect to ReportServer
            _client = new ReportingService2005();
            _client.Url = ReportDeployer.Properties.Settings.Default.ReportService;
            _client.Credentials = System.Net.CredentialCache.DefaultCredentials;
            _client.Timeout = 1000000;

        }

        public void cleanup()
        {
            _client.Dispose();
        }


        public void addDatasources(List<Datasource> datasources)
        {
            foreach (Datasource ds in datasources)
            {
                String name = ds.getName();
                String connection = ds.getConnection();
                String dsFolderPath = ds.getDsFolderPath();
                String dsUserName = ds.getDsUserName();
                String dsUserPass = ds.getDsUserPass();
                Boolean isWinCredential = ds.isWinCredential();

                DataSourceDefinition dsDef = new DataSourceDefinition();
                dsDef.ConnectString = connection;
                if (!isWinCredential)
                {
                    dsDef.CredentialRetrieval = CredentialRetrievalEnum.Integrated;
                }
                else
                {
                    dsDef.CredentialRetrieval = CredentialRetrievalEnum.Store;
                    dsDef.UserName = dsUserName;
                    dsDef.Password = dsUserPass;
                }
               
                dsDef.Extension = "SQL";
                dsDef.WindowsCredentials = isWinCredential;


                Folder dsFolder = new Folder(dsFolderPath.Substring(1), "", dsFolderPath, false, true, false, null, true);

                try
                {
                    if (ds.isActive() && !ds.isDeleted())
                    {
                        if (!folderExists(dsFolder))
                        {
                             //set properties
                            Property isHiddenProp = new Property();
                            isHiddenProp.Name = "Hidden";
                            isHiddenProp.Value = dsFolder.isHidden().ToString();

                            Property descProp = new Property();
                            descProp.Name = "Description";
                            descProp.Value = dsFolder.getDescription();

                            Property[] props = new Property[2];
                            props[0] = isHiddenProp;
                            props[1] = descProp;

                            //assume datasource folders are created at root
                            _client.CreateFolder(dsFolder.getName(), "/", null);   
                        }

                        Property isHiddenDsProp = new Property();
                        isHiddenDsProp.Name = "Hidden";
                        isHiddenDsProp.Value = ds.isHidden().ToString();
                        Property[] dsProps = new Property[1];
                        dsProps[0] = isHiddenDsProp;

                        _client.CreateDataSource(name, dsFolderPath, true, dsDef, dsProps);
                     }
                }
                catch (SoapException e)
                {
                    Console.WriteLine("Cannot deploy datasource " + ds.getName() + " " + e.Message);
                }
            }
        }

        public void deleteDatasources(List<Datasource> datasources)
        {
            foreach (Datasource datasource in datasources)
            {
                if (datasource.isDeleted() && datasource.isActive())
                {
                    String error = "For datasource " + datasource.getName()
                            + " isDeleted = true and isActive = true. Cannot delete an active item";
                    Console.WriteLine(error);
                }
                if (datasource.isDeleted())
                    _client.DeleteItem(datasource.getDsFolderPath() + "/" + datasource.getName());

            }
        }

        public void addFolders(List<Folder> folders)
        {
            foreach (Folder folder in folders)
            {
                Boolean isActive = folder.isActive();
                Boolean isDeleted = folder.isDeleted();
                Boolean exists = folderExists(folder);

                String descVal = folder.getDescription();
                String name = folder.getName();
                String path = folder.getPath();

                Folder parent = folder.getParent();

                String parentFolderPath = "/";
                if (parent != null)
                    parentFolderPath = parent.getPath();

                String isHiddenVal = folder.isHidden().ToString();

                //set properties
                Property isHiddenProp = new Property();
                isHiddenProp.Name = "Hidden";
                isHiddenProp.Value = isHiddenVal;

                Property descProp = new Property();
                descProp.Name = "Description";
                descProp.Value = descVal;



                Property[] props = new Property[2];
                props[0] = isHiddenProp;
                props[1] = descProp;
                
                if (isActive && !isDeleted && !exists ) 
                {
                    _client.CreateFolder(name, parentFolderPath, props);
                }
                else if (isActive && !isDeleted && exists)
                {
                    //update properties
                    _client.SetProperties(path, props);
                }

                List<Folder> children = folder.getChildren();
                if (children.Count() > 0)
                {
                    addFolders(children);
                }
            }
        }

        public void addPermissions(List<Folder> folders)
        {
            foreach (Folder folder in folders)
            {
                Boolean isActive = folder.isActive();
                Boolean isDeleted = folder.isDeleted();
                Boolean inheritSecurity = folder.inheritSecurity();
                

                if (isActive && !isDeleted && folderExists(folder))
                {
                    List<Security> securities = folder.getSecurties();
                    List<Policy> policies = new List<Policy>();

                    String parentFolderPath = "/";
                    if (folder.getParent() != null)
                        parentFolderPath = folder.getParent().getPath();

                    Boolean tmp = false;
                    Policy[] parentPolicy = _client.GetPolicies(parentFolderPath, out tmp);

                    if (inheritSecurity)
                    {
                        for (int i = 0; i < parentPolicy.Length; i++)
                        {
                            String tmpName = parentPolicy[i].GroupUserName;
                            String policyName = tmpName.Substring(tmpName.IndexOf("\\") + 1);
                            
                            Security sec = securities.Find(securityName(policyName));
                            if (sec == null)
                            {
                                policies.Add(parentPolicy[i]);
                            }
                        }
                    }

                    //add securities groups from reportMetadata.xml file
                    foreach (Security security in securities)
                    {
                        Role role = new Role();
                        role.Name = security.getRole();
                        Role[] roles = new Role[1];
                        roles[0] = role;

                        Policy policy = new Policy();
                        policy.GroupUserName = security.getName();
                        policy.Roles = roles;

                        policies.Add(policy);
                        
                    }

                    _client.SetPolicies(folder.getPath(), policies.ToArray());
                }
                List<Folder> children = folder.getChildren();
                if (children.Count() > 0)
                {
                    addPermissions(children);
                }
            }
        }

        public void deleteFolders(List<Folder> folders)
        {
            foreach (Folder folder in folders)
            {
                Boolean isDeleted = folder.isDeleted();
                Boolean isActive = folder.isActive();
                String name = folder.getName();
                String folderPath = folder.getPath();

                if (isDeleted && isActive)
                {
                    String error = "ERROR: folder " + name + " cannot be removed. Invalid configuration isActive=True and isDeleted=True";
                    Console.WriteLine(error);
                }
                else if (isDeleted)
                {
                    try
                    {
                        _client.DeleteItem(folderPath);
                    }
                    catch (SoapException e)
                    {
                        Console.WriteLine("ERROR: Folder " + name + " cannot be removed. " + e.Message);
                    }
                }
            }
        }

        public void addReports(List<Folder> folders)
        {
            foreach (Folder folder in folders)
            {
                List<Report> reports = folder.getReports();
                foreach (Report report in reports)
                {
                    uploadReport(report, folder);
                }

                List<Folder> children = folder.getChildren();
                if (children.Count() > 0)
                {
                    addReports(children);
                }
               
            }
        }

        public void deleteReports(List<Folder> folders)
        {
            foreach (Folder folder in folders)
            {
                List<Report> reports = folder.getReports();
                foreach (Report report in reports)
                {
                    Boolean isDeleted = report.isDeleted();
                    Boolean isActive = report.isActive();
                    String name = report.getName();
                    String folderPath = folder.getPath();
                    String reportPath = folderPath + "/" + name;

                    if (isDeleted && isActive)
                    {
                        String error = "ERROR: Report " + name + " cannot be removed. Invalid configuration isActive=True and isDeleted=True";
                        Console.WriteLine(error);
                    }
                    else if (isDeleted)
                    {
                        try
                        {
                            _client.DeleteItem(reportPath);
                        }
                        catch (SoapException e)
                        {
                            Console.WriteLine("ERROR: Report " + name + " cannot be removed. " + e.Message);
                        }
                    }
                }

                List<Folder> children = folder.getChildren();
                if (children.Count() > 0)
                {
                    deleteReports(children);
                }
            }
        }

        private void uploadReport(Report report, Folder folder)
        {
            String rdlPath = ReportDeployer.Properties.Settings.Default.RdlPath;
                
            Boolean isActive = report.isActive();
            Boolean isDeleted = report.isDeleted();
                if (isActive && !isDeleted)
                {
                    String name = report.getName();

                    Property[] reportProps = new Property[2];

                    Boolean isHidden = report.isHidden();
                    Property isHiddenProp = new Property();
                    isHiddenProp.Name = "Hidden";
                    isHiddenProp.Value = isHidden.ToString();                    
                    reportProps[0] = isHiddenProp;

                    Property descriptionProp = new Property();
                    descriptionProp.Name = "Description";
                    descriptionProp.Value = report.getDescription();
                    reportProps[1] = descriptionProp;

                    String folderPath = folder.getPath();
                    try
                    {
                        //read in RDL
                        FileStream stream = File.OpenRead(rdlPath + "\\" + name + ".rdl");
                        Byte[] rdl = new Byte[stream.Length];
                        stream.Read(rdl, 0, (int)stream.Length);
                        stream.Close();
                                
                        Warning[] warnings = _client.CreateReport(name, folderPath, true, rdl, reportProps);
                        Console.WriteLine("DEBUG: " + _client.Url);

                        //associate datasources to report
                        List<Datasource> datasources = report.getDatasources();
                        List<DataSource> dss = new List<DataSource>();
                        foreach (Datasource datasource in datasources)
                        {
                            DataSourceReference reference = new DataSourceReference();
                            reference.Reference = datasource.getDsFolderPath() + "/" + datasource.getName();
                            DataSource ds = new DataSource();
                            ds.Item = reference;
                            ds.Name = datasource.getName();
                            dss.Add(ds);
                        }
                        _client.SetItemDataSources(folder.getPath() + "/" + report.getName(), dss.ToArray());

                        if (warnings != null)
                        {
                            foreach (Warning warning in warnings)
                            {
                                //if the warning is about data sources then skip because the report must be created first 
                                //before a data source can be associated to the report
                                String pattern = "refers to the shared data source";
                                if (!System.Text.RegularExpressions.Regex.IsMatch(warning.Message, pattern))
                                    Console.WriteLine("WARNING: Report " + name + ", " + warning.Message);
                            }
                        }
                    }
                    catch (SoapException e)
                    {
                        Console.WriteLine("ERROR: SoapException, " + e.Detail.InnerXml.ToString());
                        Console.WriteLine("ERROR HINT: If the soap error complains about datasource check reportMetadata.xml. " +
                                    " If a datasource reference is missconfigured in the REPORT tag a soap error will be thrown.");
                    }
                    catch (IOException e)
                    {
                        //if the io execption is missing rdl file, then make a warning 
                        String pattern = "Could not find file.*rdl";
                        if (System.Text.RegularExpressions.Regex.IsMatch(e.Message, pattern))
                            Console.WriteLine("WARNING: " + e.Message);
                        else
                            Console.WriteLine("ERROR: IOException " + e.Message);
                    }
                }
        }

        //used in find to find a datasource in the list by its name attribute
        private Predicate<Security> securityName(String name)
        {
           return delegate(Security sec)
            {
               return sec.getName().Equals(name);
            };
        }

        private Boolean findItem(String path, String name)
        {
            Boolean exists = false;

            _condition.Value = name;
            _condition.Condition = ConditionEnum.Equals;

            SearchCondition[] conditions = new SearchCondition[1];
            conditions[0] = _condition;

            CatalogItem[] items = _client.FindItems(path, BooleanOperatorEnum.Or, conditions);

            if (items != null && items.Length > 0)
            {
                exists = true;
            }

            return exists;
        }

        private Boolean folderExists(Folder folder)
        {
            Boolean exists = false;

            String folderName = folder.getName();

            String path = "";
            Folder parent = folder.getParent();
            if (parent == null)
                path = "/";
            else
                path = parent.getPath();
            
            _condition.Value = folderName;
            _condition.Condition = ConditionEnum.Equals;

            SearchCondition[] conditions = new SearchCondition[1];
            conditions[0] = _condition;

            CatalogItem[] items = _client.FindItems(path, BooleanOperatorEnum.Or, conditions);

            if (items != null && items.Length > 0)
            {
                exists = true;
            }

            return exists;
        }
    }
}
