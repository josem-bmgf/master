﻿//------------------------------------------------------------------------------
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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class LeadershipEngagementPlannerEntities : DbContext
    {
        public LeadershipEngagementPlannerEntities()
            : base("name=LeadershipEngagementPlannerEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<Country> Countries { get; set; }
        public virtual DbSet<Duration> Durations { get; set; }
        public virtual DbSet<Leader> Leaders { get; set; }
        public virtual DbSet<Purpose> Purposes { get; set; }
        public virtual DbSet<Ranking> Rankings { get; set; }
        public virtual DbSet<Region> Regions { get; set; }
        public virtual DbSet<Schedule> Schedules { get; set; }
        public virtual DbSet<SysUser> SysUsers { get; set; }
        public virtual DbSet<Team> Teams { get; set; }
        public virtual DbSet<YearQuarter> YearQuarters { get; set; }
        public virtual DbSet<SysGroup> SysGroups { get; set; }
        public virtual DbSet<SysGroupUserPrivilege> SysGroupUserPrivileges { get; set; }
        public virtual DbSet<EngagementYearQuarter> EngagementYearQuarters { get; set; }
        public virtual DbSet<Principal> Principals { get; set; }
        public virtual DbSet<PrincipalType> PrincipalTypes { get; set; }
        public virtual DbSet<Status> Status { get; set; }
        public virtual DbSet<Division> Divisions { get; set; }
        public virtual DbSet<EngagementCountry> EngagementCountries { get; set; }
        public virtual DbSet<Engagement> Engagements { get; set; }
        public virtual DbSet<Hst_Engagement> Hst_Engagement { get; set; }
        public virtual DbSet<ErrorLog> ErrorLogs { get; set; }
        public virtual DbSet<vEngagementLeaderSchedule> vEngagementLeaderSchedules { get; set; }
        public virtual DbSet<EngagementSysUser> EngagementSysUsers { get; set; }
        public virtual DbSet<ScheduleSysUser> ScheduleSysUsers { get; set; }
        public virtual DbSet<SysUserType> SysUserTypes { get; set; }
        public virtual DbSet<Priority> Priorities { get; set; }
    }
}
