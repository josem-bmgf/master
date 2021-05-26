using System;
using System.Collections.Generic;

namespace InvestmentScore.Spa.Models
{
    public partial class Scores
    {
        public int Id { get; set; }
        public string PerformanceAgainstMilestones { get; set; }
        public string PerformanceAgainstStrategy { get; set; }
        public string ReinvestmentProspects { get; set; }
        public string Rationale { get; set; }
        public bool HighestPerforming { get; set; }
        public bool LowestPerforming { get; set; }
        public bool ExcludeFromScoring { get; set; }
        public int? InvestmentId { get; set; }
        public DateTime? ScoreDate { get; set; }
        public int? ScoreYear { get; set; }
        public string User { get; set; }
        public string Objective { get; set; }
        public int? OldInvestmentId { get; set; }
        public int? OldInvestmentIdMnf { get; set; }
        public string ScoredById { get; set; }
        public DateTime? CreatedOn { get; set; }
        public string CreatedById { get; set; }
        public DateTime? ModifiedOn { get; set; }
        public string ModifiedById { get; set; }
        public string RelativeStrategicImportance { get; set; }
        public string KeyResultsData { get; set; }
        public string FundingTeamInput { get; set; }
        public bool? IsArchived { get; set; }
        public bool IsExcluded { get; set; }

        public virtual User CreatedBy { get; set; }
        public virtual Investment Investment { get; set; }
        public virtual User ModifiedBy { get; set; }
        public virtual User ScoredBy { get; set; }
    }
}
