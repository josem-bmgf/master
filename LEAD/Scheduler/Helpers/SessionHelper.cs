namespace Scheduler.Api.Helpers
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using System.Threading.Tasks;
    using System.Web;
    using Scheduler.Helpers;
    using Scheduler.Models;

    public static class SessionHelper
    {
        private static LeadershipEngagementPlannerEntities db = new LeadershipEngagementPlannerEntities();

        #region Properties

        public static SysUser SysUser
        {
            get
            {
                return GetSessionObject<SysUser>("SysUser");
            }

            set
            {
                SetSessionObject<SysUser>("SysUser", value);
            }
        }

        public static bool IsLeadAdmin
        {
            get
            {
                return GetSessionObject<bool>("IsLeadAdmin");
            }

            set
            {
                SetSessionObject<bool>("IsLeadAdmin", value);
            }
        }

        public static bool IsLeadAll
        {
            get
            {
                return GetSessionObject<bool>("IsLeadAll");
            }

            set
            {
                SetSessionObject<bool>("IsLeadAll", value);
            }
        }

        public static bool IsLeadApprover
        {
            get
            {
                return GetSessionObject<bool>("IsLeadApprover");
            }

            set
            {
                SetSessionObject<bool>("IsLeadApprover", value);
            }
        }

        public static bool IsLeadReportUser
        {
            get
            {
                return GetSessionObject<bool>("IsLeadReportUser");
            }

            set
            {
                SetSessionObject<bool>("IsLeadReportUser", value);
            }
        }

        public static bool IsLeadMultiDivisionUser
        {
            get
            {
                return GetSessionObject<bool>("IsLeadMultiDivisionUser");
            }

            set
            {
                SetSessionObject<bool>("IsLeadMultiDivisionUser", value);
            }
        }
        #endregion

        #region Session Methods
        public static T GetSessionObject<T>(string key)
        {
            if (HttpContext.Current != null && HttpContext.Current.Session != null && HttpContext.Current.Session[key] != null)
            {
                return (T)HttpContext.Current.Session[key];
            }

            return default(T);
        }

        public static bool SetSessionObject<T>(string key, T o)
        {
            if (HttpContext.Current != null && HttpContext.Current.Session != null)
            {
                HttpContext.Current.Session[key] = o;
                return true;
            }

            return false;
        }

        public static bool DeleteSessionObject(string key)
        {
            if (HttpContext.Current != null && HttpContext.Current.Session != null && HttpContext.Current.Session[key] != null)
            {
                HttpContext.Current.Session[key] = null;
                return true;
            }

            return false;
        }
        #endregion


        public static async Task ValidateUser(string username)
        {
            string leadAdminGroup = ConfigurationManager.AppSettings["LeadAdminDomainGroup"] != null ? ConfigurationManager.AppSettings["LeadAdminDomainGroup"].ToLower() : null;
            string leadAllGroup = ConfigurationManager.AppSettings["LeadAllDomainGroup"] != null ? ConfigurationManager.AppSettings["LeadAllDomainGroup"].ToLower() : null;
            string leadApproverGroup = ConfigurationManager.AppSettings["LeadApproverDomainGroup"] != null ? ConfigurationManager.AppSettings["LeadApproverDomainGroup"].ToLower() : null;
            string leadReportUserGroup = ConfigurationManager.AppSettings["LeadReportUserDomainGroup"] != null ? ConfigurationManager.AppSettings["LeadReportUserDomainGroup"].ToLower() : null;
            string leadMultiDivisionGroup = ConfigurationManager.AppSettings["LeadMultiDivisionGroup"] != null ? ConfigurationManager.AppSettings["LeadMultiDivisionGroup"].ToLower() : null;
            List<string> domaingroups = await GraphAADHelper.GetGroupsAssignedAsync();
            IsLeadAdmin = domaingroups.Exists(s => s == leadAdminGroup);
            IsLeadAll = domaingroups.Exists(s => s == leadAllGroup);
            IsLeadApprover = domaingroups.Exists(s => s == leadApproverGroup);
            IsLeadReportUser = domaingroups.Exists(s => s == leadReportUserGroup);
            IsLeadMultiDivisionUser = domaingroups.Exists(s => s == leadMultiDivisionGroup);

            SysUser = GetUser(username);
        }

        public static SysUser GetUser(string username)
        {
            SysUser = db.SysUsers.Where(u => u.Email == username).FirstOrDefault();
            if(SysUser == null)
            {
              SysUser = db.SysUsers.Where(u => u.ADUser == username).FirstOrDefault();
            }
             return SysUser;
        }

        public static void LogError(string errorMessage)
        {
            ErrorLog errorLog = new ErrorLog();
            errorLog.Details = errorMessage;
            errorLog.UserID = SysUser.Id;
            errorLog.RunDate = DateTime.Now;

            db.ErrorLogs.Add(errorLog);
            db.SaveChanges();
        }
    }
}