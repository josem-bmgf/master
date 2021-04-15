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
    
    public partial class SysGroup
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public SysGroup()
        {
            this.Leaders = new HashSet<Leader>();
            this.Teams = new HashSet<Team>();
            this.SysGroupUserPrivileges = new HashSet<SysGroupUserPrivilege>();
        }
    
        public int Id { get; set; }
        public string GroupName { get; set; }
        public string GroupShortName { get; set; }
        public string GroupDescription { get; set; }
        public int GroupDisplaySortSequence { get; set; }
        public string FoundationDomainTeam { get; set; }
        public bool RequestingTeam { get; set; }
        public bool Status { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Leader> Leaders { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Team> Teams { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<SysGroupUserPrivilege> SysGroupUserPrivileges { get; set; }
    }
}