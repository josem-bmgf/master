using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace InvestmentScore.Spa.Helpers
{
    public static class Constants
    {       
        public static string[] ContractClosedStatus = new string[] { "Closed", "Cancelled", "Inactive" };
        public static string[] OpportunityType = new string[] { "Grant", "Program Related Investment (PRI)" };
        public static string[] OpportunityClosedStatus = new string[] { "Closed" };      
    }

    public class DNSProperties
    {
        public List<DNSConfiguration> DNSConfiguration { get; set; }
    }

    public class DNSConfiguration
    {
        public string Placeholder { get; set; }
        public string Server { get; set; }
    }

    public class Division
    {
        public string[] Divisions { get; set; }
    }

    public class FISConfigurations
    {
        public Dictionary<string, int> FieldLength { get; set; }

        public string GuidanceURL { get; set; }

        public string PreviewDetailedSlideReportURL { get; set; }

        public string FraudulentActivityURL { get; set; }

        public string PrivacyAndCookiesURL { get; set; }

        public string TermsOfUseURL { get; set; }
    }

    public class MaintenanceNoticeConfiguration
    {
         public string MaintenanceNoticeHTML { get; set; }
    }

    public class DateReference
    {
        public string EndOfSeason { get; set; }
        public string EndOfSeasonFormat { get; set; }
        public string TestScoreYear { get; set; }
    }
}
