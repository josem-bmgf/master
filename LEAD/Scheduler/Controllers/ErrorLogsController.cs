using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Http;
using Scheduler.Models;

namespace Scheduler.Controllers
{
    public class ErrorLogsController : ApiController
    {
        private LeadershipEngagementPlannerEntities db = new LeadershipEngagementPlannerEntities();
        // GET: ErrorLogs       

        public IHttpActionResult GetErrors()
        {
            List<ErrorLog> errorLogs = db.ErrorLogs.OrderByDescending(e => e.RunDate).ToList();

            return Ok(errorLogs.Select( 
                e => new {
                    e.LogID,
                    e.RunDate,
                    User = e.SysUser.FullName,
                    e.Details
                }
            ));
        }
    }
}