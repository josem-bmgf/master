using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Xml;
using System.Data;

namespace ReportDeployer
{
    public class BmgfReport
    {
        private  const String _insertSqlDh2 = "INSERT INTO Consumer.metadata.BmgfReport " +
                            "(ReportName " +
                            ",ReportDescription " +
                            ",TechnicalDescription) " +
                        "VALUES " +
                            "(@reportName " +
                            ",@reportDescription " +
                            ",@technicalDescription)";


        private const String _insertSqlDh1 = "INSERT INTO BMGFReports.dbo.Reports " +
                            "(Name " +
                            ",Description " +
                            ",TechnicalDescription) " +
                           "VALUES " +
                            "(@reportName " +
                            ",@reportDescription " +
                            ",@technicalDescription)";

        private const String _updateSqlDh2 = "UPDATE Consumer.metadata.BmgfReport " +
                            "SET ReportDescription = @reportDescription " +
                            ",TechnicalDescription = @technicalDescription " +
                            "WHERE reportName = @reportName ";

        private const String _updateSqlDh1 = "UPDATE BMGFReports.dbo.Reports SET Description = @reportDescription " +
                                    " ,  TechnicalDescription = @technicalDescription " +
                                    "WHERE Name = @reportName ";

        private const String _findSqlReportDh1 = "SELECT * FROM BMGFReports.dbo.Reports WHERE Name = @reportName";
        private const String _findSqlReportDh2 = "SELECT * FROM Consumer.metadata.BmgfReport WHERE reportName = @reportName";


        private const String DH1 = "DH1";
        private const String DH2 = "DH2";
                           
        private SqlConnection _conn;

        private String _dwVersion;
        private SqlCommand _updateDh1;
        private SqlCommand _updateDh2;
        private SqlCommand _insertDh1;
        private SqlCommand _insertDh2;
        private SqlCommand _findReportDh1;
        private SqlCommand _findReportDh2;
       

        public BmgfReport(String bmgfReportServer, String dwVersion)
        {
            if (dwVersion == null)
                _dwVersion = DH2;
            else
                _dwVersion = dwVersion.ToUpper();

            if (!_dwVersion.ToUpper().Equals(DH1) && !_dwVersion.ToUpper().Equals(DH2))
            {
                throw new ArgumentException("data warehouse version is not correct. Must be either DH1 or DH2");
            }

            if (_dwVersion.ToUpper().Equals(DH2))
                _conn = new SqlConnection("Data Source=" + bmgfReportServer + "; Integrated Security=SSPI;" +
                                                "Initial Catalog=Consumer");

            if (_dwVersion.ToUpper().Equals(DH1))
                _conn = new SqlConnection("Data Source=" + bmgfReportServer + "; Integrated Security=SSPI;" +
                                                "Initial Catalog=BMGFReports");

            

            _updateDh1 = new SqlCommand(_updateSqlDh1, _conn);
            _updateDh1.Parameters.Add("@reportName", SqlDbType.VarChar, 150);
            _updateDh1.Parameters.Add("@reportDescription", SqlDbType.NVarChar, 512);
            _updateDh1.Parameters.Add("@technicalDescription", SqlDbType.Text, 8000);

            _insertDh1 = new SqlCommand(_insertSqlDh1, _conn);
            _insertDh1.Parameters.Add("@reportName", SqlDbType.VarChar, 150);
            _insertDh1.Parameters.Add("@reportDescription", SqlDbType.NVarChar, 512);
            _insertDh1.Parameters.Add("@technicalDescription", SqlDbType.Text, 8000);

            _updateDh2 = new SqlCommand(_updateSqlDh2, _conn);
            _updateDh2.Parameters.Add("@reportName", SqlDbType.NVarChar, 255);
            _updateDh2.Parameters.Add("@reportDescription", SqlDbType.NVarChar, 255);
            _updateDh2.Parameters.Add("@technicalDescription", SqlDbType.NVarChar, 4000);

            _insertDh2 = new SqlCommand(_insertSqlDh2, _conn);
            _insertDh2.Parameters.Add("@reportName", SqlDbType.NVarChar, 255);
            _insertDh2.Parameters.Add("@reportDescription", SqlDbType.NVarChar, 255);
            _insertDh2.Parameters.Add("@technicalDescription", SqlDbType.NVarChar, 4000);

            _findReportDh1 = new SqlCommand(_findSqlReportDh1, _conn);
            _findReportDh1.Parameters.Add("@reportName", SqlDbType.NVarChar, 255);

            _findReportDh2 = new SqlCommand(_findSqlReportDh2, _conn);
            _findReportDh2.Parameters.Add("@reportName", SqlDbType.NVarChar, 255);
        }

        public void loadReportMetadata(List<Folder> folders)
        {

            _conn.Open();

            loadMetadata(folders);
           
            _conn.Close();
        }

        private void loadMetadata(List<Folder> folders)
        {
            foreach (Folder folder in folders)
            {
                List<Report> reports = folder.getReports();
                foreach (Report report in reports)
                {
                    Boolean isActive = report.isActive();
                    if (isActive)
                    {
                        String name = report.getName();
                        String desc = report.getDescription();
                        String techDesc = report.getTechnicalDescription();

                        if (_dwVersion.Equals(DH1))
                        {
                            loadDh1(name, desc, techDesc);
                        }
                        else if (_dwVersion.Equals(DH2))
                        {
                            loadDh2(name, desc, techDesc);
                        }
                    }
                }
                List<Folder> children = folder.getChildren();
                if (children.Count() > 0)
                {
                    loadMetadata(children);
                }
            }
        }

       

        private void loadDh1(String name, String desc, String techDesc)
        {
            _findReportDh1.Parameters["@reportName"].Value = name;
            SqlDataReader reader = _findReportDh1.ExecuteReader();
            if (reader.HasRows)
            {
                reader.Close();
                updateReportDescriptionDh1(name, desc, techDesc);
            }
            else
            {
                reader.Close();
                insertReportDescriptionDh1(name, desc, techDesc);
            }

            reader.Close();
        }

        private void loadDh2(String name, String desc, String techDesc)
        {
            _findReportDh2.Parameters["@reportName"].Value = name;
            SqlDataReader reader = _findReportDh2.ExecuteReader();
            if (reader.HasRows)
            {
                reader.Close();
                updateReportDescriptionDh2(name, desc, techDesc);
            }
            else
            {
                reader.Close();
                insertReportDescriptionDh2(name, desc, techDesc);
            }
        }

        private void updateReportDescriptionDh1(String name, String desc, String techDesc)
        {
            _updateDh1.Parameters["@reportName"].Value = name;
            _updateDh1.Parameters["@reportDescription"].Value = desc;
            _updateDh1.Parameters["@technicalDescription"].Value = techDesc;

            _updateDh1.ExecuteNonQuery();
          
        }

        private void insertReportDescriptionDh1(String name, String desc, String techDesc)
        {
            _insertDh1.Parameters["@reportName"].Value = name;
            _insertDh1.Parameters["@reportDescription"].Value = desc;
            _insertDh1.Parameters["@technicalDescription"].Value = techDesc;

            _insertDh1.ExecuteNonQuery();

        }

        
        private void updateReportDescriptionDh2(String name, String desc, String techDesc)
        {
            _updateDh2.Parameters["@reportName"].Value = name;
            _updateDh2.Parameters["@reportDescription"].Value = desc;
            _updateDh2.Parameters["@technicalDescription"].Value = techDesc;

            _updateDh2.ExecuteNonQuery();
            
        }

        
        private void insertReportDescriptionDh2(String name, String desc, String techDesc)
        {
            _insertDh2.Parameters["@reportName"].Value = name;
            _insertDh2.Parameters["@reportDescription"].Value = desc;
            _insertDh2.Parameters["@technicalDescription"].Value = techDesc;

            _insertDh2.ExecuteNonQuery();
          
        }
    }
}
