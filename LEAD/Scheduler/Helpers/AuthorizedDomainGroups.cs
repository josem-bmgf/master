using System;
using System.Web.Mvc;
using Scheduler.Api.Helpers;

namespace Scheduler.Helpers
{
    public class AuthorizedDomainGroups : AuthorizeAttribute
    {
        /// <summary>
        /// Comma separated value of domain groups allowed to access a specific page
        /// </summary>
        public string DomainGroups { get; set; }

        public override void OnAuthorization(AuthorizationContext filterContext)
        {
            if (filterContext.HttpContext.Request.IsAuthenticated)
            {
                if (
                        !(((DomainGroups.Contains("IsLeadAll") || String.IsNullOrWhiteSpace(DomainGroups)) && SessionHelper.IsLeadAll) ||
                        (DomainGroups.Contains("IsLeadAdmin") && SessionHelper.IsLeadAdmin) ||
                        (DomainGroups.Contains("IsLeadApprover") && SessionHelper.IsLeadApprover) ||
                        (DomainGroups.Contains("IsLeadReportUser") && SessionHelper.IsLeadReportUser) ||
                        (DomainGroups.Contains("IsLeadMultiDivisionUser") && SessionHelper.IsLeadMultiDivisionUser))
                   )
                {
                    filterContext.Result = new RedirectResult("~/Home/AccessDenied?page=" + filterContext.ActionDescriptor.ActionName);
                }
            }
            else
            {
                filterContext.Result = new RedirectResult("~/Home/Logon");
            }

            return;
        }
    }
}