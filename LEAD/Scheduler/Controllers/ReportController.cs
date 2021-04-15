using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using Scheduler.Models;
using System.Data.Entity.Migrations;
using Scheduler.Api.Helpers;

namespace Scheduler.Controllers
{
    public class ReportController : ApiController
    {
        private LeadershipEngagementPlannerEntities db = new LeadershipEngagementPlannerEntities();

        // GET: api/vEngagementLeaderSchedules
        public IQueryable<vEngagementLeaderSchedule> GetvEngagementLeaderSchedules()
        {
            return db.vEngagementLeaderSchedules;
        }

        // GET: api/vEngagementLeaderSchedules/5
        [ResponseType(typeof(vEngagementLeaderSchedule))]
        public IHttpActionResult GetvEngagementLeaderSchedule(int id)
        {
            vEngagementLeaderSchedule vEngagementLeaderSchedule = db.vEngagementLeaderSchedules.Find(id);
            if (vEngagementLeaderSchedule == null)
            {
                return NotFound();
            }

            return Ok(vEngagementLeaderSchedule);
        }

        // PUT: api/vEngagementLeaderSchedules/5
        [ResponseType(typeof(void))]
        public IHttpActionResult PutvEngagementLeaderSchedule(int id, vEngagementLeaderSchedule vEngagementLeaderSchedule)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != vEngagementLeaderSchedule.Id)
            {
                return BadRequest();
            }

            db.Entry(vEngagementLeaderSchedule).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!vEngagementLeaderScheduleExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return StatusCode(HttpStatusCode.NoContent);
        }

        // POST: api/vEngagementLeaderSchedules
        [ResponseType(typeof(vEngagementLeaderSchedule))]
        public IHttpActionResult PostvEngagementLeaderSchedule(vEngagementLeaderSchedule vEngagementLeaderSchedule)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.vEngagementLeaderSchedules.Add(vEngagementLeaderSchedule);

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateException)
            {
                if (vEngagementLeaderScheduleExists(vEngagementLeaderSchedule.Id))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtRoute("DefaultApi", new { id = vEngagementLeaderSchedule.Id }, vEngagementLeaderSchedule);
        }

        // DELETE: api/vEngagementLeaderSchedules/5
        [ResponseType(typeof(vEngagementLeaderSchedule))]
        public IHttpActionResult DeletevEngagementLeaderSchedule(int id)
        {
            vEngagementLeaderSchedule vEngagementLeaderSchedule = db.vEngagementLeaderSchedules.Find(id);
            if (vEngagementLeaderSchedule == null)
            {
                return NotFound();
            }

            db.vEngagementLeaderSchedules.Remove(vEngagementLeaderSchedule);
            db.SaveChanges();

            return Ok(vEngagementLeaderSchedule);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool vEngagementLeaderScheduleExists(int id)
        {
            return db.vEngagementLeaderSchedules.Count(e => e.Id == id) > 0;
        }
    }
}