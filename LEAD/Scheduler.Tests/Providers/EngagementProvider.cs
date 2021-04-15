using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net.Http;
using System.Web.Http;
using Scheduler.Models;
using NUnit.Framework;
using Scheduler.Controllers;
using Scheduler.Api.Helpers;
using Scheduler.Tests.HelpersTests;
using System.Threading;
using System.Web;
using System.Security.Principal;

namespace Scheduler.Tests.Providers
{
    [SetUpFixture]
    public class EngagementProvider : ApiController
    {
        [OneTimeSetUp]
        public void SetUp()
        {
            Thread.CurrentPrincipal = new GenericPrincipal(new GenericIdentity(Environment.UserName), new[] { "" });
            _leadDb = new LeadershipEngagementPlannerEntities();            
            _userLoggedIn = ActiveDirectoryHelper.UserLoggedIn(User.Identity.Name);
        }


        [TearDown]
        public void TearDown()
        {
            DisposeController();
        }

        [OneTimeTearDown]
        public void OneTimeTearDown()
        {
            LeadDataInserter.DeleteEngagement();
        }

        public static EngagementController _engagementController;
        public static LeadershipEngagementPlannerEntities _leadDb;
        public static string _userLoggedIn;

        private void DisposeController()
        {
            _engagementController.Dispose();
        }

        #region DataProvider
        public static Engagement CreateEngagement()
        {
            _leadDb = new LeadershipEngagementPlannerEntities();
            var engagement = Engagement();
            _leadDb.Dispose();
            Thread.Sleep(1000);

            return engagement;
        }
       
        public static Engagement Engagement()
        {
            return new Engagement
            {
                Id = 0,
                Title = "Test Automation",
                Details = "For Test Automation",
                DetailsRtf = String.Empty,
                Objectives = "For Testing",
                ObjectivesRtf = String.Empty,
                ExecutiveSponsorFk = 1008,
                IsConfidential = false,
                IsExternal = false,
                RegionFk = 1005,
                City = "Quezon City",
                PurposeFk = 1000,
                BriefOwnerFk = 3869,
                StaffFk = 2559,
                DurationFk = 1014,
                IsDateFlexible = false,
                DateStart = null,
                DateEnd = null,
                DivisionFk = 1001,
                TeamFk = 1005,
                StrategicPriorityFk = 1003,
                TeamRankingFk = 1002,
                PresidentRankingFk = 1001,
                PresidentComment = "test",
                PresidentCommentRtf = String.Empty,
                EntryCompleted = false,
                PresidentReviewCompleted = false,
                ScheduleCompleted = false,
                ScheduleReviewCompleted = false,
                EntryDate = DateTime.Now,
                EntryByFk = 2879,
                ModifiedDate = DateTime.Now,
                ModifiedByFk = 0,
                IsDeleted = false,
                StatusFk = 1000,
                Location = "Test",
                Division = Division(1001),
                Duration = Duration(1014),
                ExecutiveSponsor = Leader(1008),
                Priority = Priority(1003),
                Purpose = Purpose(1000),
                PresidentRanking = Ranking(1001),
                TeamRanking = Ranking(1002),
                Region = Region(1005),
                Status = Status(1000),
                BriefOwner = SysUser(3869),
                EntryBy = SysUser(2879),
                ModifiedBy = SysUser(0),
                Staff = SysUser(2559),
                Team = Team(1005)
            };
        }
        public static Division Division(int id)
        {
           return _leadDb.Divisions.AsNoTracking().Where(e => e.Id == id).FirstOrDefault();
        }
        public static Duration Duration(int id)
        {
            return _leadDb.Durations.AsNoTracking().Where(e => e.Id == id).FirstOrDefault();
        }
        public static Leader Leader(int id)
        {
            return _leadDb.Leaders.AsNoTracking().Where(e => e.Id == id).FirstOrDefault();            
        }
        public static Priority Priority(int id)
        {
            return _leadDb.Priorities.AsNoTracking().Where(e => e.Id == id).FirstOrDefault();
        }
        public static Purpose Purpose(int id)
        {
            return _leadDb.Purposes.AsNoTracking().Where(e => e.Id == id).FirstOrDefault();            
        }
        public static Ranking Ranking(int id)
        {
            return _leadDb.Rankings.AsNoTracking().Where(e => e.Id == id).FirstOrDefault();
        }
        public static Region Region(int id)
        {
            return _leadDb.Regions.AsNoTracking().Where(e => e.Id == id).FirstOrDefault();
        }
        public static Status Status(int id)
        {
            return _leadDb.Status.AsNoTracking().Where(e => e.Id == id).FirstOrDefault();
        }
        public static SysUser SysUser(int id)
        {
            return _leadDb.SysUsers.AsNoTracking().Where(e => e.Id == id).FirstOrDefault();
        }
        public static Team Team(int id)
        {
            return _leadDb.Teams.AsNoTracking().Where(e => e.Id == id).FirstOrDefault();
        }
        
        #endregion DataProvider

        #region DataRetrieval

        public static Engagement GetEngagementById(int id)
        {
            _leadDb = new LeadershipEngagementPlannerEntities();
            var engagement = _leadDb.Engagements.AsNoTracking().Where(e => e.Id == id).FirstOrDefault();
            _leadDb.Dispose();

            return engagement;

        }

        #endregion DataRetrieval
    }
}
