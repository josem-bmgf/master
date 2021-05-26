using System;
using System.Collections.Generic;

namespace InvestmentScore.Spa.Models.ScoringDetail
{
    public class Scores
    {
        public int id { get; set; }
        public string excludeFromScoring { get; set; }
        public string highestPerforming { get; set; }
        public string investment { get; set; }
        public string investmentId { get; set; }
        public string lowestPerforming { get; set; }
        public string objective { get; set; }
        public string performanceAgainstMilestones { get; set; }
        public string performanceAgainstStrategy { get; set; }
        public string rationale { get; set; }
        public string reinvestmentProspects { get; set; }
        public string scoreDate { get; set; }
        public string scoreDateUnformatted { get; set; }
        public string scoreYear { get; set; }
        public string user { get; set; }
        public string scoredById { get; set; }
        public string scoredBy { get; set; }
        public string createdOn { get; set; }
        public string createdById { get; set; }
        public string createdBy { get; set; }
        public string modifiedOn { get; set; }
        public string modifiedById { get; set; }
        public string modifiedBy { get; set; }
        public string relativeStrategicImportance { get; set; }
        public string keyResultsData { get; set; }
        public string fundingTeamInput { get; set; }
        public string isArchived { get; set; }
        public string isExcluded { get; set; }
    }
}
