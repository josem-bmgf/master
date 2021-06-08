using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;


namespace WebFirst
{   
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string connectionString;
            SqlConnection cnn;
            SqlCommand sqlcomm;
            SqlDataReader datareader;
            String sqlstr;
            connectionString = @"Data Source=.\;Initial Catalog=MyDB;integrated security=true";
            cnn = new SqlConnection(connectionString);
            cnn.Open();
            txtInput.Text = "DBSuccess";
           
            sqlstr = "select * from address";
            sqlcomm = new SqlCommand(sqlstr, cnn);
            datareader = sqlcomm.ExecuteReader();
            DataTable dataTable = new DataTable();
            dataTable.Columns.Add("Id");
            dataTable.Columns.Add("HNumber");
            dataTable.Columns.Add("Street");
            dataTable.Columns.Add("Barangay");
            dataTable.Columns.Add("City");
            dataTable.Columns.Add("Province");

            while (datareader.Read())
            {
                DataRow row = dataTable.NewRow();
                row["Id"] = datareader["Id"];
                row["HNumber"] = datareader["hnumber"];
                row["Street"] = datareader["street"];
                row["Barangay"] = datareader["barangay"];
                row["City"] = datareader["city"];
                row["Province"] = datareader["province"];
                dataTable.Rows.Add(row);
            }
            GrdView.DataSource = dataTable;
            GrdView.DataBind();
            sqlcomm.Dispose();
            datareader.Close();
            cnn.Close();
            

        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {

            WebClass wc = new WebClass();
            GrdView.DataSource = wc.ConnectME();
            GrdView.DataBind();
        }
        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtInput.Text = "Input search key";

        }

        protected void GrdView_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    } 
}