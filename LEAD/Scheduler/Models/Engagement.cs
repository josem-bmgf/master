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
    
    public partial class Engagement
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Engagement()
        {
            this.EngagementCountries = new HashSet<EngagementCountry>();
            this.EngagementYearQuarters = new HashSet<EngagementYearQuarter>();
            this.Principals = new HashSet<Principal>();
            this.Schedules = new HashSet<Schedule>();
            this.Hst_Engagement = new HashSet<Hst_Engagement>();
            this.EngagementSysUsers = new HashSet<EngagementSysUser>();
        }
    
        public int Id { get; set; }
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
        public Nullable<System.DateTime> DateStart { get; set; }
        public Nullable<System.DateTime> DateEnd { get; set; }
        public int DivisionFk { get; set; }
        public int TeamFk { get; set; }
        public Nullable<int> StrategicPriorityFk { get; set; }
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
        public int StatusFk { get; set; }
        public string Location { get; set; }
    
        public virtual Division Division { get; set; }
        public virtual Duration Duration { get; set; }
        public virtual Leader ExecutiveSponsor { get; set; }
        public virtual Purpose Purpose { get; set; }
        public virtual Ranking PresidentRanking { get; set; }
        public virtual Ranking TeamRanking { get; set; }
        public virtual Region Region { get; set; }
        public virtual Status Status { get; set; }
        public virtual SysUser BriefOwner { get; set; }
        public virtual SysUser EntryBy { get; set; }
        public virtual SysUser ModifiedBy { get; set; }
        public virtual SysUser Staff { get; set; }
        public virtual Team Team { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<EngagementCountry> EngagementCountries { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<EngagementYearQuarter> EngagementYearQuarters { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Principal> Principals { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Schedule> Schedules { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Hst_Engagement> Hst_Engagement { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<EngagementSysUser> EngagementSysUsers { get; set; }
        public virtual Priority Priority { get; set; }
    }
}