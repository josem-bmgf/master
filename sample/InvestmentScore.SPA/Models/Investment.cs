using System;
using System.Collections.Generic;

namespace InvestmentScore.Spa.Models
{
    public partial class Investment
    {
        public Investment()
        {
            Scores = new HashSet<Scores>();
            TaxonomyValues = new HashSet<TaxonomyValues>();
        }

        public int Id { get; set; }
        public string IdCombined { get; set; }
        public string InvGranteeVendorName { get; set; }
        public string InvType { get; set; }
        public string InvStatus { get; set; }
        public string InvTitle { get; set; }
        public string InvOwner { get; set; }
        public string InvManager { get; set; }
        public DateTime? InvStartDate { get; set; }
        public DateTime? InvEndDate { get; set; }
        public string InvLevelOfEngagement { get; set; }
        public decimal? TotalInvestmentAmount { get; set; }
        public decimal? AmtPaidToDate { get; set; }
        public string InvDescription { get; set; }
        public string ManagingTeamLevel1 { get; set; }
        public string ManagingTeamLevel2 { get; set; }
        public string ManagingTeamLevel3 { get; set; }
        public string ManagingTeamLevel4 { get; set; }
        public string PmtExpenditureType { get; set; }
        public string FundingType { get; set; }
        public int? OldInvestmentId { get; set; }
        public int? OldInvestmentIdMnf { get; set; }
        public DateTime? OppClosedDate { get; set; }
        public bool IsDeleted { get; set; }
        public bool IsExcludedFromTOI { get; set; }

        public virtual ICollection<Scores> Scores { get; set; }
        public virtual ICollection<TaxonomyValues> TaxonomyValues { get; set; }
    }
}
