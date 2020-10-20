using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data; // provide DataSet
using System.Data.SqlClient; //provide SQL CMD
using System.Configuration; //provide COnfiguration Manager

namespace WebFirst
{
    public class WebClass
    {
        public string Showme()
        {
          return "Type Search Here";
        }
        public DataView ConnectME()
        {
            DataView source = new DataView();
            ConnectionStringSettings connectionInfo = ConfigurationManager.ConnectionStrings["myConnection"];
            SqlConnection Connect = new SqlConnection(connectionInfo.ConnectionString);
            try
            {
                Connect.Open();
                SqlCommand myCommand = new SqlCommand("select * from person", Connect);
                SqlDataAdapter myAdapter = new SqlDataAdapter(myCommand);
                DataSet DS = new DataSet();
                myAdapter.Fill(DS);
                source = new DataView(DS.Tables[0]);
                Connect.Close();
            }
            catch
            {
               // lblDisplay.Text = "Can't connect to the SQL Database";
            }
            Connect.Close();
            return source;
        }

    }

}