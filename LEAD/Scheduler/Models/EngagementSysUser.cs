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
    
    public partial class EngagementSysUser
    {
        public int Id { get; set; }
        public int EngagementFk { get; set; }
        public int SysUserFk { get; set; }
        public int TypeFk { get; set; }
    
        public virtual Engagement Engagement { get; set; }
        public virtual SysUser SysUser { get; set; }
        public virtual SysUserType SysUserType { get; set; }
    }
}