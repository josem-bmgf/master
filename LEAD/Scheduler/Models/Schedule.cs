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
    
    public partial class Schedule
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Schedule()
        {
            this.ScheduleSysUsers = new HashSet<ScheduleSysUser>();
        }
    
        public int Id { get; set; }
        public int EngagementFk { get; set; }
        public int LeaderFk { get; set; }
        public Nullable<System.DateTime> DateFrom { get; set; }
        public Nullable<System.DateTime> DateTo { get; set; }
        public int TripDirectorFk { get; set; }
        public int SpeechWriterFk { get; set; }
        public int CommunicationsLeadFk { get; set; }
        public Nullable<System.DateTime> BriefDueToGCEByDate { get; set; }
        public Nullable<System.DateTime> BriefDueToBGC3ByDate { get; set; }
        public string ScheduleComment { get; set; }
        public string ScheduleCommentRtf { get; set; }
        public int ScheduledByFk { get; set; }
        public Nullable<System.DateTime> ScheduledDate { get; set; }
        public string ApproveDecline { get; set; }
        public string ReviewComment { get; set; }
        public string ReviewCommentRtf { get; set; }
        public int ReviewCompletedByFk { get; set; }
        public Nullable<System.DateTime> ReviewCompletedDate { get; set; }
        public bool IsDeleted { get; set; }
    
        public virtual Leader Leader { get; set; }
        public virtual SysUser ReviewCompletedBy { get; set; }
        public virtual SysUser ScheduledBy { get; set; }
        public virtual SysUser CommunicationsLead { get; set; }
        public virtual SysUser SpeechWriter { get; set; }
        public virtual SysUser TripDirector { get; set; }
        public virtual Engagement Engagement { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ScheduleSysUser> ScheduleSysUsers { get; set; }
    }
}