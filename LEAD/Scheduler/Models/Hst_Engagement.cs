//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Scheduler.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class Hst_Engagement
    {
        public int Id { get; set; }
        public int IdFk { get; set; }
        public string Title { get; set; }
        public string Details { get; set; }
        public string DetailsRtf { get; set; }
        public string Objectives { get; set; }
        public string ObjectivesRtf { get; set; }
        public int ExecutiveSponsorFk { get; set; }
        public bool IsConfidential { get; set; }
        public bool IsExternal { get; set; }
        public int RegionFk { get; set; }
        public string City { get; set; }
        public int PurposeFk { get; set; }
        public int BriefOwnerFk { get; set; }
        public int StaffFk { get; set; }
        public int DurationFk { get; set; }
        public bool IsDateFlexible { get; set; }
        public System.DateTime DateStart { get; set; }
        public System.DateTime DateEnd { get; set; }
        public int DivisionFk { get; set; }
        public int TeamFk { get; set; }
        public int StrategicPriorityFk { get; set; }
        public int TeamRankingFk { get; set; }
        public int PresidentRankingFk { get; set; }
        public string PresidentComment { get; set; }
        public string PresidentCommentRtf { get; set; }
        public bool EntryCompleted { get; set; }
        public bool PresidentReviewCompleted { get; set; }
        public bool ScheduleCompleted { get; set; }
        public bool ScheduleReviewCompleted { get; set; }
        public System.DateTime EntryDate { get; set; }
        public int EntryByFk { get; set; }
        public System.DateTime ModifiedDate { get; set; }
        public int ModifiedByFk { get; set; }
        public bool IsDeleted { get; set; }
    
        public virtual Engagement Engagement { get; set; }
    }
}