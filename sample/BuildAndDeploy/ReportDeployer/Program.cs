using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace ReportDeployer
{
    public class Program
    {
        public static int Main(string[] args)
        {
            int errorcode = 0;
            try
            {
                String reportMetadata = ReportDeployer.Properties.Settings.Default.ReportMetadata;
                String reportMetadataSchema = ReportDeployer.Properties.Settings.Default.ReportMetadataSchema;


                ReportDeployerCtrl ctrl = new ReportDeployerCtrl();
                ReportModel model = ctrl.loadReportMetadata(reportMetadata, reportMetadataSchema);
                ctrl.connect();
                ctrl.deleteItems(model);
                ctrl.addItems(model);
                ctrl.cleanup();

                String dwVersion = "DH2";
                if (args != null && args.Length > 0)
                    dwVersion = args[0];

                ctrl.loadBmgfReportDescriptions(model, dwVersion); //load table BmgfReport, this is a db connection not a webservice
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                errorcode = -1;
            }

            if (errorcode == 0)
                Console.WriteLine("SUCCESS");
            else
                Console.WriteLine("FAILED");

            return errorcode;
        
       
        }
    }
}
