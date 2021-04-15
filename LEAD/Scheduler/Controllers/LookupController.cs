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
using Scheduler.Api.Helpers;

namespace Scheduler.Controllers
{
    public class LookupController : ApiController
    {
        private LeadershipEngagementPlannerEntities db = new LeadershipEngagementPlannerEntities();

        [HttpGet]
        public IHttpActionResult GetDivisions()
        {
            IEnumerable<Division> divisions = db.Divisions.Where(d => d.Id > 0 && d.Status).OrderBy(s => s.Name).ToArray();

            return Ok(divisions.Select(d => new
            {
                divisionId = d.Id,
                name = d.Name
            }).OrderBy(d => d.name));
        }

        [HttpGet]
        public IHttpActionResult GetTeams()
        {
            IEnumerable<Team> teams = db.Teams.Where(t => t.Id > 0 && t.Status).OrderBy(s => s.team).ToArray();

            return Ok(teams.Select(t => new
            {
                id = t.Id,
                team = t.team,
                divisionId = t.DivisionFk
            }));
        }

        [HttpGet]
        public IHttpActionResult GetLeaders()
        {
            IEnumerable<Leader> leaders = db.Leaders.Where(l => l.Id > 0 && l.Status).ToArray().OrderBy(l => l.FirstName);

            return Ok(leaders.Select(l => new
            {
                //id = l.FirstName + ' ' + l.LastName,
                leaderFk = l.Id,
                name = l.FirstName + ' ' + l.LastName,
            }));
        }

        [HttpGet]
        public IHttpActionResult GetExecutiveSponsors()
        {
            IEnumerable<Leader> leaders = db.Leaders.Where(l => l.Id > 0 && l.Status && l.IsExecutiveSponsor).ToArray().OrderBy(l => l.FirstName);
            return Ok(leaders.Select(l => new
            {
                leaderFk = l.Id,
                name = l.FirstName + ' ' + l.LastName,
            }));
        }
        [HttpGet]
        public IHttpActionResult GetAlternatePrincipals()
        {
            IEnumerable<Leader> leaders = db.Leaders.Where(l => l.Id > 0 && l.Status && l.IsAlternatePrincipal).ToArray().OrderBy(l => l.FirstName);
            return Ok(leaders.Select(l => new
            {
                leaderFk = l.Id,
                name = l.FirstName + ' ' + l.LastName,
            }));
        }
        [HttpGet]
        public IHttpActionResult GetRequiredPrincipals()
        {
            IEnumerable<Leader> leaders = db.Leaders.Where(l => l.Id > 0 && l.Status && l.IsRequiredPrincipal).ToArray().OrderBy(l => l.FirstName);
            return Ok(leaders.Select(l => new
            {
                leaderFk = l.Id,
                name = l.FirstName + ' ' + l.LastName,
            }));
        }
        [HttpGet]
        public IHttpActionResult GetStrategicPriorities()
        {
            IEnumerable<Priority> priorities = db.Priorities.Where(p => p.Id > 0 && p.Status).ToArray();

            return Ok(priorities.Select(p => new
            {
                id = p.Id,
                priority = p.priority

            }));
        }

        [HttpGet]
        public IHttpActionResult GetTeamRankings()
        {
            IEnumerable<Ranking> teamRankings = db.Rankings.Where(r => r.Id > 0 && r.Id != 1003).ToArray();

            return Ok(teamRankings.Select(r => new
            {
                id = r.Id,
                ranking = r.ranking,
                requesterInput = r.RequesterInput
            }).Where(r => r.requesterInput == true));
        }

        [HttpGet]
        public IHttpActionResult GetRegions()
        {
            IEnumerable<Region> regions = db.Regions.Where(r => r.Id > 0 && r.Status).ToArray();

            return Ok(regions.Select(r => new
            {
                regionId = r.Id,
                regionName = r.regionName
            })
            .OrderBy(c => c.regionName));
        }

        [HttpGet]
        public IHttpActionResult GetCountries()
        {
            IEnumerable<Country> countries = db.Countries.Where(c => c.Id > 0 && c.Status).ToArray();

            return Ok(countries.Select(c => new
            {
                countryFk = c.Id,
                countryName = c.countryName,
                regionId = c.RegionFk
            })
            .OrderBy(c => c.countryName));
        }

        [HttpGet]
        public IHttpActionResult GetPurposes()
        {
            IEnumerable<Purpose> purposes = db.Purposes.Where(p => p.Id > 0).ToArray();

            return Ok(purposes.Select(p => new
            {
                id = p.Id,
                purpose = p.purpose,
            }));
        }

        [HttpGet]
        public IHttpActionResult GetSysUsers()
        {
            IEnumerable<SysUser> sysUsers = db.SysUsers.Where(esu => esu.Id > 0 && esu.Status).ToArray().OrderBy(esu => esu.FullName);
            return Ok(sysUsers.Select(esu => new
            {
                sysUserFk = esu.Id,
                name = esu.FullName
            }));
        }



        [HttpGet]
        public IHttpActionResult GetDurations()
        {
            IEnumerable<Duration> durations = db.Durations.Where(d => d.Id > 0).ToArray();

            return Ok(durations.Select(d => new
            {
                id = d.Id,
                isInternalEngmnt = d.IsInternalEngagement,
                duration = d.duration
            }));
        }

        [HttpGet]
        public IHttpActionResult GetYearQuarter()
        {
            IEnumerable<YearQuarter> yrQtrs = db.YearQuarters.Where(y => y.Id > 0 && y.Year >= DateTime.Today.Year - 1).ToArray();

            return Ok(yrQtrs.Select(y => new
            {
                yearQuarterFk = y.Id,
                year = y.Year,
                quarter = y.Quarter,
                name = y.Display
            }));
        }

        [HttpGet]
        public IHttpActionResult GetStatus()
        {
            IEnumerable<Status> status = db.Status.Where(s => s.Id > 0).ToArray();

            return Ok(status.Select(s => new
            {
                id = s.Id,
                name = s.Name,
                displaySortSequence = s.DisplaySortSequence
            }).OrderBy(s => s.displaySortSequence));
        }

        [HttpGet]
        public IHttpActionResult GetRanking()
        {
            IEnumerable<Ranking> ranking = db.Rankings.Where(r => r.Id > 0).ToArray();

            return Ok(ranking.Select(r => new
            {
                id = r.Id,
                ranking = r.ranking,
                requesterInput = r.RequesterInput,
                presidentReview = r.PresidentReview,
                displaySortSequence = r.DisplaySortSequence,
                status = r.Status
            }));
        }

        [HttpGet]
        public IHttpActionResult IsLeadAdmin()
        {
            return Json(SessionHelper.IsLeadAdmin);
        }

        [HttpGet]
        public IHttpActionResult IsLeadAll()
        {
            return Json(SessionHelper.IsLeadAll);
        }

        [HttpGet]
        public IHttpActionResult IsLeadApprover()
        {
            return Json(SessionHelper.IsLeadApprover);
        }

        [HttpGet]
        public IHttpActionResult IsLeadMultiDivisionUser()
        {
            return Json(SessionHelper.IsLeadMultiDivisionUser);
        }

        //IsLeadReportUser
        [HttpGet]
        public IHttpActionResult IsLeadReportUser()
        {
            return Json(SessionHelper.IsLeadReportUser);
        }

        [HttpGet]
        public IHttpActionResult GetCurrentRole()
        {
            string currentRole = string.Empty;
            if (SessionHelper.IsLeadAdmin)
            {
                currentRole = "IsLeadAdmin";
            }
            else if (SessionHelper.IsLeadApprover)
            {
                currentRole = "IsLeadApprover";
            }
            else if (SessionHelper.IsLeadAll)
            {
                currentRole = "IsLeadAll";
            }
            else if (SessionHelper.IsLeadMultiDivisionUser)
            {
                currentRole = "IsLeadMultiDivisionUser";
            }
            else
            {
                currentRole = "IsLeadReportUser";
            }
            return Json(currentRole);
        }
    }
}