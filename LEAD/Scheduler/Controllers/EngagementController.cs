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
using Scheduler.Helpers;
using Scheduler.Api.Helpers;
using System.DirectoryServices.AccountManagement;
using System.Configuration;
using HtmlAgilityPack;

namespace Scheduler.Controllers
{
    public class EngagementController : ApiController
    {
        private LeadershipEngagementPlannerEntities db = new LeadershipEngagementPlannerEntities();

        // GET: api/Engagement/GetEngagements
        public IHttpActionResult GetEngagements(int source)
        {
           // Get logged in user's divisionFk
            string userLoggedIn = ActiveDirectoryHelper.UserLoggedIn(User.Identity.Name);
            int divisionFk = db.SysUsers.Where(u => u.ADUser == userLoggedIn).Select(u => u.DivisionFk).FirstOrDefault();

            IQueryable<Engagement> engagements = db.Engagements;
            DbSet<Engagement> dbSetEngagements = db.Engagements;

            if (source == 1) //All Engagements with only Draft and Declined Status
            {
                IQueryable<Engagement> engagementQuery = dbSetEngagements.Where(e => (e.StatusFk == Constants.Draft || e.StatusFk == Constants.Declined));
                if (SessionHelper.IsLeadMultiDivisionUser == true)
                 {
                    engagements = engagementQuery;
                 }
                  else
                   {
                      engagements = FilterEngagementByDivision(engagementQuery, divisionFk);
                   }
            }

            else if (source == 2) //All Review Ready engagements
            {
                IQueryable<Engagement> engagementQuery = dbSetEngagements.Where(e => e.StatusFk == Constants.SubmittedforReview);// Submitted for Review Status
                engagements = FilterEngagementByDivision(engagementQuery, divisionFk);
            }
            else
            {
                IQueryable<Engagement> engagementQuery = dbSetEngagements.Where(e => e.StatusFk >= Constants.Approved); // Approved Status
                engagements = FilterEngagementByDivision(engagementQuery, divisionFk);
            }
            
            var renderEngagementFieldsNeeded = engagements.Select(e => new
            {
                e.Id,
                Title = e.Title,
                Details = e.Details,
                StatusFk = e.StatusFk,
                Status = new { id = e.Status.Id, name = e.Status.Name, display = e.Status.DisplaySortSequence },
                e.DetailsRtf,
                Objectives = e.Objectives,
                e.ObjectivesRtf,
                PrincipalRequired = e.Principals
                       .Where(p => p.TypeFK.Equals(1000))
                       .Select(pr => new { id = pr.Id, leaderFk = pr.Leader.Id, name = pr.Leader.FirstName + " " + pr.Leader.LastName, typeFk = pr.TypeFK, engagementFk = pr.EngagementFK }),
                PrincipalAlternate = e.Principals
                       .Where(p => p.TypeFK.Equals(1001))
                       .Select(pa => new { id = pa.Id, leaderFk = pa.Leader.Id, name = pa.Leader.FirstName + " " + pa.Leader.LastName, typeFk = pa.TypeFK, engagementFk = pa.EngagementFK }),
                ExecutiveSponsor = new { id = e.ExecutiveSponsor.Id, name = e.ExecutiveSponsor.FirstName + " " + e.ExecutiveSponsor.LastName },
                IsExternal = e.IsExternal,
                IsExternalLabel = e.IsExternal ? "External" : "Internal",
                e.TeamFk,
                Team = new { id = e.Team.Id, team = e.Team.team },
                RegionFk = e.RegionFk,
                Region = new { regionId = e.Region.Id, regionName = e.Region.regionName },
                //Country = new { id = e.Country.Id, countryName = e.Country.countryName, regionId = e.RegionFk },
                EngagementCountries = e.EngagementCountries.Select(ec => new { id = ec.Country.Id, countryName = ec.Country.countryName, engagementFk = ec.EngagementFk, countryFk = ec.CountryFk }),
                City = e.City,
                Location = e.Location,
                e.PurposeFk,
                Purpose = new { id = e.Purpose.Id, purpose = e.Purpose.purpose },
                ContentOwner = e.EngagementSysUsers
                       .Where(p => p.TypeFk.Equals(Constants.ContentOwner))
                       .Select(esu => new { id = esu.Id, sysUserFk = esu.SysUserFk, name = esu.SysUser.FullName, typeFk = esu.TypeFk, engagementFk = esu.EngagementFk }),
                Staff = e.EngagementSysUsers
                       .Where(p => p.TypeFk.Equals(Constants.Staff))
                       .Select(esu => new { id = esu.Id, sysUserFk = esu.SysUserFk, name = esu.SysUser.FullName, typeFk = esu.TypeFk, engagementFk = esu.EngagementFk }),
                e.DurationFk,
                Duration = new { id = e.Duration.Id, duration = e.Duration.duration },
                e.IsDateFlexible,
                EngagementYearQuarters = e.EngagementYearQuarters.Select(yq => new { id = yq.Id, name = yq.YearQuarter.Display, engagementFk = yq.EngagementFk, yearQuarterFk = yq.YearQuarterFk }),
                //.Select(yq => new { Id = yq.Id, Display = yq.YearQuarter }),
                DateStart = e.DateStart,
                DateEnd = e.DateEnd,
                e.DivisionFk,
                Division = new { name = e.Division.Name, divisionId = e.Division.Id },
                e.StrategicPriorityFk,
                Priority = e.Priority != null ? e.Priority.priority : String.Empty,
                e.TeamRankingFk,
                TeamRanking = new { id = e.TeamRanking.Id, ranking = e.TeamRanking.ranking },
                e.PresidentRankingFk,
                PresidentRanking = new { id = e.PresidentRanking.Id, ranking = e.PresidentRanking.ranking },
                PresidentComment = e.PresidentComment,
                e.PresidentCommentRtf,
                e.EntryCompleted,
                e.PresidentReviewCompleted,
                e.ScheduleCompleted,
                e.ScheduleReviewCompleted,
                e.EntryDate,
                e.EntryByFk,
                EntryBy = new { fullName = e.EntryBy.FullName, entryById = e.EntryBy.Id, adUser = e.EntryBy.ADUser },
                e.ModifiedDate,
                e.ModifiedByFk,
                ModifiedBy = new { fullName = e.ModifiedBy.FullName, modifiedById = e.ModifiedBy.Id },
                e.IsDeleted,
                IsScheduleNotNull = e.Schedules.FirstOrDefault() != null,
                Schedule = e.Schedules.Select(s => new
                {
                    s.Id,
                    s.BriefDueToGCEByDate,
                    s.DateTo,
                    s.DateFrom,
                    s.ScheduleComment,
                    SsuTripDirector = s.ScheduleSysUsers.Where(p => p.TypeFk.Equals(Constants.TripDirector)).Select(ssu => new
                    {
                        id = ssu.Id,
                        sysUserFk = ssu.SysUserFk,
                        name = ssu.SysUser.FullName,
                        typeFk = ssu.TypeFk,
                        scheduleFk = ssu.ScheduleFk
                    }),
                    SsuCommunicationsLead = s.ScheduleSysUsers.Where(p => p.TypeFk.Equals(Constants.CommunicationsLead)).Select(ssu => new
                    {
                        id = ssu.Id,
                        sysUserFk = ssu.SysUserFk,
                        name = ssu.SysUser.FullName,
                        typeFk = ssu.TypeFk,
                        scheduleFk = ssu.ScheduleFk
                    }),
                    SsuSpeechWriter = s.ScheduleSysUsers.Where(p => p.TypeFk.Equals(Constants.SpeechWriter)).Select(ssu => new
                    {
                        id = ssu.Id,
                        sysUserFk = ssu.SysUserFk,
                        name = ssu.SysUser.FullName,
                        typeFk = ssu.TypeFk,
                        scheduleFk = ssu.ScheduleFk
                    }),
                }).FirstOrDefault(),
            }).AsEnumerable();

            var returnFinalDataSource = renderEngagementFieldsNeeded.Select(e => new
            {
                e.Id,
                e.Title,
                e.Details,
                e.StatusFk,
                e.Status,
                e.DetailsRtf,
                e.Objectives,
                e.ObjectivesRtf,
                e.PrincipalRequired, 
                PrincipalRequiredDisplay = String.Join(", ", e.PrincipalRequired.Select(p => p.name)), //Converted
                e.PrincipalAlternate,
                PrincipalAlternateDisplay = String.Join(", ", e.PrincipalAlternate.Select(p => p.name)), //Converted
                e.ExecutiveSponsor,
                e.IsExternal,
                e.IsExternalLabel,
                e.TeamFk,
                e.Team ,
                e.RegionFk,
                e.Region,
                e.EngagementCountries,
                EngagementCountriesDisplay = String.Join(", ", e.EngagementCountries.Select(ec => ec.countryName.Trim())), //Converted
                e.City,
                e.Location,
                e.PurposeFk,
                e.Purpose,
                e.ContentOwner,
                ContentOwnerDisplay = String.Join(", ", e.ContentOwner.Select(esu => esu.name)), //Converted
                e.Staff,
                StaffDisplay = String.Join(", ", e.Staff.Select(esu => esu.name)), //Converted
                e.DurationFk,
                e.Duration,
                e.IsDateFlexible,
                e.EngagementYearQuarters,
                EngagementYearQuartersDisplay = String.Join(", ", e.EngagementYearQuarters.Select(yq => yq.name.Trim())), //Converted
                e.DateStart, 
                e.DateEnd,
                e.DivisionFk,
                e.Division,
                e.StrategicPriorityFk,
                e.Priority,
                e.TeamRankingFk,
                e.TeamRanking,
                e.PresidentRankingFk,
                e.PresidentRanking,
                e.PresidentComment,
                e.PresidentCommentRtf,
                e.EntryCompleted,
                e.PresidentReviewCompleted,
                e.ScheduleCompleted,
                e.ScheduleReviewCompleted,
                e.EntryDate,
                e.EntryByFk,
                e.EntryBy,
                e.ModifiedDate,
                e.ModifiedByFk,
                e.ModifiedBy,
                e.IsDeleted,
                //Reused redundant fields
                ScheduleComment = (e.IsScheduleNotNull ? e.Schedule.ScheduleComment :String.Empty),
                BriefDueToGCEByDate = (e.IsScheduleNotNull ? e.Schedule.BriefDueToGCEByDate : null),
                DateTo = (e.IsScheduleNotNull ? e.Schedule.DateTo : null),
                DateFrom = (e.IsScheduleNotNull ? e.Schedule.DateFrom : null),
                DateToString = (e.IsScheduleNotNull ? e.Schedule.DateTo.ToString() : String.Empty),
                DateFromString = (e.IsScheduleNotNull ? e.Schedule.DateFrom.ToString() : String.Empty),
                DateFromTime = (e.IsScheduleNotNull ? e.Schedule.DateFrom.GetValueOrDefault().TimeOfDay.ToString() : null),
                DateToTime = (e.IsScheduleNotNull ?  e.Schedule.DateTo.GetValueOrDefault().TimeOfDay.ToString() : null),
                SsuTripDirectorDisplay = (e.IsScheduleNotNull ? String.Join(", ", e.Schedule.SsuTripDirector.Select(ssu => ssu.name)) : String.Empty),
                SsuCommunicationsLeadDisplay = (e.IsScheduleNotNull ? String.Join(", ", e.Schedule.SsuCommunicationsLead.Select(ssu=> ssu.name)) : String.Empty),
                SsuSpeechWriterDisplay = (e.IsScheduleNotNull ? String.Join(", ", e.Schedule.SsuSpeechWriter.Select(ssu=> ssu.name)) : String.Empty),
                e.Schedule
            }).AsEnumerable();

            return Ok(
                returnFinalDataSource
               );
        }

        
        /// <summary>
        /// If logged in user is not admin, the engagement list returned is filtered by its related Division
        /// </summary>
        /// <param name="engagementQuery"></param>
        /// <param name="divisionFk"></param>
        /// <returns>Engagement list</returns>
        public IQueryable<Engagement> FilterEngagementByDivision(IQueryable<Engagement> engagementQuery, int divisionFk)
        {
            return SessionHelper.IsLeadAdmin ?
                   engagementQuery
                    : engagementQuery.Where(e => e.DivisionFk == divisionFk);
        }
        
        public IHttpActionResult HardDeleteEngagement(Engagement engagement)
        {
            try
            {
                if (engagement != null && engagement.Id > 0)
                {
                    // Delete rows from associated tables of Engagement
                    DeleteEngagementCountry(engagement.Id);
                    DeleteEngagementPrincipals(engagement.Id);
                    DeleteEngagementSchedule(engagement.Id);
                    DeleteEngagementYearQuarter(engagement.Id);
                    DeleteEngagementHistory(engagement.Id);
                    DeleteEngagementSysUsers(engagement.Id);

                    // Delete Engagement
                    DeleteEngagement(engagement.Id);

                    db.SaveChanges();

                }

                return Ok(new { engagement.Id, engagement.ModifiedDate });
            }
            catch (Exception e)
            {
                SessionHelper.LogError(e.ToString());
                return Ok();
            }

        }

        public IHttpActionResult SaveEngagement(Engagement engagement, int prevStatus)
        {
            try
            {
                if (engagement != null)
                {
                    string userLoggedIn = ActiveDirectoryHelper.UserLoggedIn(User.Identity.Name);
                    engagement = SetPostEngagementValues(engagement, userLoggedIn);
                    SetEngagementPrincipals(engagement);
                    SetEngagementYearQuarter(engagement);
                    SetEngagementCountries(engagement);
                    SetEngagementSysUsers(engagement);

                    engagement.PresidentRanking = null;
                    engagement.TeamRanking = null;

                    if (engagement.Id > 0)
                    {
                        db.Set<Engagement>().AddOrUpdate(engagement);
                    }
                    else
                    {
                        engagement.EntryBy = db.SysUsers.Where(eb => eb.ADUser == userLoggedIn).FirstOrDefault();
                        engagement.EntryByFk = (engagement.EntryBy == null) ? 0 : engagement.EntryBy.Id;
                        engagement.EntryBy = null;
                        engagement.EntryDate = DateTime.Now;
                        db.Engagements.Attach(engagement);
                        db.Engagements.AddOrUpdate(engagement);
                    }
                    db.SaveChanges();
                }

                SendEmailNotification(engagement, null, prevStatus);

                return Ok(new { engagement.Id, engagement.ModifiedDate });
            }
            catch (Exception e)
            {
                SessionHelper.LogError(e.ToString());
                return Ok();
            }
        }

        public Engagement SetPostEngagementValues(Engagement engagement, string userLoggedIn)
        {
            engagement.Division.Id = engagement.DivisionFk; //reverse assign due to cascade adjustments in fron end
            engagement.Region.Id = engagement.RegionFk; //reverse assign due to cascade adjustments in fron end
            engagement.PurposeFk = engagement.Purpose.Id;

            engagement.TeamRankingFk = engagement.TeamRanking.Id;
            engagement.PresidentRankingFk = (engagement.PresidentRanking == null) ? 0 : engagement.PresidentRanking.Id;
            engagement.TeamFk = engagement.Team.Id;
            engagement.DurationFk = (engagement.Duration == null) ? 0 : engagement.Duration.Id;
            if (engagement.ExecutiveSponsor != null)
            {
                engagement.ExecutiveSponsor.Id = engagement.ExecutiveSponsorFk;
            }
            engagement.StatusFk = (engagement.Status == null) ? 0 : engagement.Status.Id;
            engagement.ExecutiveSponsor = db.Leaders.Where(l => l.Id == engagement.ExecutiveSponsorFk).FirstOrDefault();
            engagement.ModifiedDate = DateTime.Now;
            engagement.Details = (engagement.Details == null) ? "" : engagement.Details;
            engagement.City = (engagement.City == null) ? "" : engagement.City;
            engagement.Location = (engagement.Location == null) ? "" : engagement.Location;
            engagement.ModifiedBy = db.SysUsers.Where(eb => eb.ADUser == userLoggedIn).FirstOrDefault();
            engagement.ModifiedByFk = (engagement.ModifiedBy == null) ? 0 : engagement.ModifiedBy.Id;

            return engagement;
        }

        #region Add/Remove 1 Engagement to Multiselect fields
        public void SetEngagementPrincipals(Engagement engagement)
        {
            IEnumerable<Models.Principal> principals = db.Principals.Where(p => p.EngagementFK == engagement.Id);

            //AddPrincipals to Engagement
            foreach (Models.Principal currentPrincipal in engagement.Principals)
            {
                Models.Principal principal = principals.Where(p => p.LeaderFK == currentPrincipal.LeaderFK && p.TypeFK == currentPrincipal.TypeFK).FirstOrDefault();
                if (principal == null)
                {
                    db.Principals.Add(currentPrincipal);
                }
            }
            //Remove Principals from engagement
            foreach (Models.Principal currentPrincipal in principals)
            {
                Models.Principal principal = engagement.Principals.Where(p => p.LeaderFK == currentPrincipal.LeaderFK && p.TypeFK == currentPrincipal.TypeFK).FirstOrDefault();
                if (principal == null)
                {
                    db.Principals.Remove(currentPrincipal);
                }
            }
        }

        public void SetEngagementYearQuarter(Engagement engagement)
        {
            IEnumerable<EngagementYearQuarter> engagementYearQuarters = db.EngagementYearQuarters.Where(yq => yq.EngagementFk == engagement.Id);

            //Add year quarters to Engagement
            foreach (EngagementYearQuarter currentYearQuarter in engagement.EngagementYearQuarters)
            {
                EngagementYearQuarter yearQuarter = engagementYearQuarters.Where(yq => yq.YearQuarterFk == currentYearQuarter.YearQuarterFk).FirstOrDefault();
                if (yearQuarter == null)
                {
                    db.EngagementYearQuarters.Add(currentYearQuarter);
                }
            }

            //Remove yearquarter from engagement
            foreach (EngagementYearQuarter currentYearQuarter in engagementYearQuarters)
            {
                EngagementYearQuarter yearQuarter = engagement.EngagementYearQuarters.Where(yq => yq.YearQuarterFk == currentYearQuarter.YearQuarterFk).FirstOrDefault();
                if (yearQuarter == null)
                {
                    db.EngagementYearQuarters.Remove(currentYearQuarter);
                }
            }
        }

        public void SetEngagementCountries(Engagement engagement)
        {
            IEnumerable<EngagementCountry> engagementCountries = db.EngagementCountries.Where(ec => ec.EngagementFk == engagement.Id);

            //Add year quarters to Engagement
            foreach (EngagementCountry ecountry in engagement.EngagementCountries)
            {
                EngagementCountry country = engagementCountries.Where(ec => ec.CountryFk == ecountry.CountryFk).FirstOrDefault();
                if (country == null)
                {
                    db.EngagementCountries.Add(ecountry);
                }
            }

            //Remove yearquarter from engagement
            foreach (EngagementCountry ecountry in engagementCountries)
            {
                EngagementCountry country = engagement.EngagementCountries.Where(ec => ec.CountryFk == ecountry.CountryFk).FirstOrDefault();
                if (country == null)
                {
                    db.EngagementCountries.Remove(ecountry);
                }
            }
        }
        public void SetEngagementSysUsers(Engagement engagement)
        {
            IEnumerable<EngagementSysUser> engagementSysUsers = db.EngagementSysUsers.Where(esu => esu.EngagementFk == engagement.Id);

            //Add EngagementSysUsers to Engagement
            foreach (EngagementSysUser currentEngagementSysUser in engagement.EngagementSysUsers)
            {
                EngagementSysUser engagementSysUser = engagementSysUsers.Where(esu => esu.SysUserFk == currentEngagementSysUser.SysUserFk && esu.TypeFk == currentEngagementSysUser.TypeFk).FirstOrDefault();
                if (engagementSysUser == null)
                {
                    db.EngagementSysUsers.Add(currentEngagementSysUser);
                }
            }
            //Remove EngagementSysUser from engagement
            foreach (EngagementSysUser currentEngagementSysUser in engagementSysUsers)
            {
                EngagementSysUser engagementSysUser = engagement.EngagementSysUsers.Where(esu => esu.SysUserFk == currentEngagementSysUser.SysUserFk && esu.TypeFk == currentEngagementSysUser.TypeFk).FirstOrDefault();
                if (engagementSysUser == null)
                {
                    db.EngagementSysUsers.Remove(currentEngagementSysUser);
                }
            }
        }
        #endregion

        #region Add/Remove 1 Schedule to Multiselect fields
        public void SetScheduleSysUsers(Schedule schedule)
        {
            IEnumerable<ScheduleSysUser> scheduleSysUsers = db.ScheduleSysUsers.Where(ssu => ssu.ScheduleFk == schedule.Id);
            

            //Add ScheduleSysUsers to Schedule
            foreach (ScheduleSysUser currentScheduleSysUser in schedule.ScheduleSysUsers)
            {
                ScheduleSysUser ScheduleSysUser = scheduleSysUsers.Where(ssu => ssu.SysUserFk == currentScheduleSysUser.SysUserFk && ssu.TypeFk == currentScheduleSysUser.TypeFk).FirstOrDefault();
                if (ScheduleSysUser == null)
                {
                    db.ScheduleSysUsers.Add(currentScheduleSysUser);
                }
            }
            //Remove ScheduleSysUser from Schedule
            foreach (ScheduleSysUser currentScheduleSysUser in scheduleSysUsers)
            {
                ScheduleSysUser ScheduleSysUser = schedule.ScheduleSysUsers.Where(ssu => ssu.SysUserFk == currentScheduleSysUser.SysUserFk && ssu.TypeFk == currentScheduleSysUser.TypeFk).FirstOrDefault();
                if (ScheduleSysUser == null)
                {
                    db.ScheduleSysUsers.Remove(currentScheduleSysUser);
                }
            }
        }
        #endregion

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

        public Schedule SetPostEngagementScheduleValues(Schedule schedule)
        {
            schedule.ScheduleComment = (schedule.ScheduleComment == null) ? "" : schedule.ScheduleComment;
            schedule.ScheduleCommentRtf = "";
            schedule.ApproveDecline = "";
            schedule.ReviewComment = "";
            schedule.ReviewCommentRtf = "";
            
            return schedule;
        }


        public IHttpActionResult SaveEngagementSchedule(int prevStatus, Schedule schedule)
        {
            //int prevStatus = preEngagement.Status.Id;
            try
            {
                if (schedule == null) return Ok();   
                
                schedule = SetPostEngagementScheduleValues(schedule);
                SetScheduleSysUsers(schedule);
                if (schedule.Id > 0)
                {
                    db.Set<Schedule>().AddOrUpdate(schedule);
                }
                else
                {
                    db.Schedules.Attach(schedule);
                    db.Schedules.AddOrUpdate(schedule);
                }
                db.SaveChanges();

                SendEmailNotification(schedule, prevStatus);

                return Ok(new
                {
                    schedule.Id
                });
            }
            catch (Exception e)
            {
                SessionHelper.LogError(e.ToString());
                return Ok();
            }
        }

        #region DELETE METHODS

        public void DeleteEngagement(int engagementId)
        {
            IEnumerable<Engagement> engagements = db.Engagements.Where(p => p.Id == engagementId);

            //Delete Engagement
            foreach (Engagement currentEngagement in engagements)
            {
                db.Engagements.Remove(currentEngagement);
            }

        }

        public void DeleteEngagementCountry(int engagementId)
        {
            IEnumerable<EngagementCountry> engagementCountries = db.EngagementCountries.Where(c => c.EngagementFk == engagementId);

            //Delete YearQuarter from engagement
            foreach (EngagementCountry currentCountry in engagementCountries)
            {
                db.EngagementCountries.Remove(currentCountry);
            }

        }

        public void DeleteEngagementHistory(int engagementId)
        {
            IEnumerable<Hst_Engagement> hstEngagements = db.Hst_Engagement.Where(p => p.IdFk == engagementId);

            //Delete Engagement
            foreach (Hst_Engagement currentHstEngagement in hstEngagements)
            {
                db.Hst_Engagement.Remove(currentHstEngagement);
            }

        }

        public void DeleteEngagementPrincipals(int engagementId)
        {
            IEnumerable<Models.Principal> principals = db.Principals.Where(p => p.EngagementFK == engagementId);

            //Delete Principal
            foreach (Models.Principal currentPrincipal in principals)
            {
                db.Principals.Remove(currentPrincipal);
            }
        }

        public void DeleteEngagementSchedule(int engagementId)
        {
            IEnumerable<Schedule> schedules = db.Schedules.Where(s => s.EngagementFk == engagementId);

            //Delete Schedule
            foreach (Schedule currentSchedule in schedules)
            {
                if (currentSchedule != null) DeleteScheduleSysUsers(currentSchedule.Id);
                db.Schedules.Remove(currentSchedule);
            }
        }

        public void DeleteEngagementYearQuarter(int engagementId)
        {
            IEnumerable<EngagementYearQuarter> engagementYearQuarters = db.EngagementYearQuarters.Where(yq => yq.EngagementFk == engagementId);

            //Remove YearQuarter from engagement
            foreach (EngagementYearQuarter currentYearQuarter in engagementYearQuarters)
            {
                db.EngagementYearQuarters.Remove(currentYearQuarter);
            }

        }

        public void DeleteEngagementSysUsers(int engagementId)
        {
            IEnumerable<EngagementSysUser> engagementSysUsers = db.EngagementSysUsers.Where(esu => esu.EngagementFk == engagementId);
            //Delete SysUsers from engagement
            foreach (EngagementSysUser currentEngagementSysUser in engagementSysUsers)
            {
                db.EngagementSysUsers.Remove(currentEngagementSysUser);
            }
        }

        public void DeleteScheduleSysUsers(int scheduleId)
        {
            IEnumerable<ScheduleSysUser> scheduleSysUsers = db.ScheduleSysUsers.Where(ssu => ssu.ScheduleFk == scheduleId);
            //Delete SysUsers from schedule
            foreach (ScheduleSysUser currentScheduleSysUser in scheduleSysUsers)
            {
                db.ScheduleSysUsers.Remove(currentScheduleSysUser);
            }
        }
        #endregion

        #region SEND EMAIL METHODS
        private void SendEmailNotification(Schedule schedule, int prevStatus)
        {
            LeadershipEngagementPlannerEntities _context = new LeadershipEngagementPlannerEntities();
            Engagement engagement = new Engagement();
            engagement = _context.Engagements.Where(e => e.Id == schedule.EngagementFk).FirstOrDefault();
            SendEmailNotification(engagement, schedule, prevStatus);
        }

        private void SendEmailNotification(Engagement engagement, Schedule schedule, int prevStatus)
        {
            EmailHelper.SendNotification(engagement, schedule, prevStatus);
        }
        #endregion
    }
}