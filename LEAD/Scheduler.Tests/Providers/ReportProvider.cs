using System.Linq;
using NUnit.Framework;
using Scheduler.Controllers;
using System.Net.Http;
using System.Web.Http;
using Scheduler.Models;
using System;
using System.ComponentModel;
using System.Reflection;

namespace Scheduler.Tests.Providers
{
    [SetUpFixture]
    public class ReportProvider
    {
        #region Set Up
        
        [OneTimeSetUp]
        public void SetUp()
        {
            _reportController = new ReportController
            {
                Request = new HttpRequestMessage(),
                Configuration = new HttpConfiguration()
            };
            _leadDb = new LeadershipEngagementPlannerEntities();
        }

        [OneTimeTearDown]
        public void TearDown()
        {
            Dispose();
        }

        #endregion

        public static ReportController _reportController;
        public static LeadershipEngagementPlannerEntities _leadDb;
        private static readonly Random _random = new Random();

        #region Data Provider

        public enum Division
        {
            [System.ComponentModel.Description("CEO Office")]
            CEOOffice,
            [System.ComponentModel.Description("Global Communications & Engagement")]
            GlobalCommunicationsAndEngagement,
            [System.ComponentModel.Description("Global Development")]
            GlobalDevelopment,
            [System.ComponentModel.Description("Global Health")]
            GlobalHealth,
            [System.ComponentModel.Description("Global Policy and Advocacy")]
            GlobalPolicyAndAdvocacy,
            [System.ComponentModel.Description("Foundation Strategy Office")]
            FoundationStrategyOffice,
            [System.ComponentModel.Description("Operations")]
            Operations,
            [System.ComponentModel.Description("U.S. Program")]
            USProgram,
            [System.ComponentModel.Description("Executive")]
            Executive,
            [System.ComponentModel.Description("Legal")]
            Legal,
            [System.ComponentModel.Description("Global Growth and Opportunity")]
            GlobalGrowthAndOpportunity
        }

        public enum Visibility
        {
            Open,
            Close
        }

        public enum EngagementType
        {
            Internal,
            External
        }

        public enum Purpose
        {
            [System.ComponentModel.Description("Strategy Review")]
            StrategyReview,
            [System.ComponentModel.Description("Progress Review")]
            ProgressReview,
            [System.ComponentModel.Description("Strategy Development")]
            StrategyDevelopment,
            [System.ComponentModel.Description("Learning")]
            Learning,
            [System.ComponentModel.Description("Advocacy/Outreach Calls")]
            AdvocacyOutreachCalls,
            [System.ComponentModel.Description("Trip/Event/Pre-trip/Speech prep")]
            TripEventPreTripSpeechPrep,
            [System.ComponentModel.Description("Book of Business")]
            BookOfBusiness,
            [System.ComponentModel.Description("Global Good")]
            GlobalGood
        }

        public enum DateFlexible
        {
            Flexible,
            Nonflexible
        }

        public enum StrategicPriority
        {
            [System.ComponentModel.Description("FP2020")]
            FP2020,
            [System.ComponentModel.Description("Women & Girls")]
            WomenAndGirls,
            [System.ComponentModel.Description("R&D/Pandemic")]
            RAndDPandemic,
            [System.ComponentModel.Description("US Education")]
            USEducation,
            [System.ComponentModel.Description("Neglected Tropical Diseases")]
            NeglectedTropicalDiseases,
            [System.ComponentModel.Description("Programmatic Engagement")]
            ProgrammaticEngagement,
            [System.ComponentModel.Description("Polio & Routine Immunization")]
            PolioAndRoutineImmunization,
            [System.ComponentModel.Description("Family Planning & RMNCAH+N")]
            FamilyPlanningAndRMNCAHN,
            [System.ComponentModel.Description("Malaria")]
            Malaria,
            [System.ComponentModel.Description("Financing for Development")]
            FinancingForDevelopment
        }

        public enum TeamRanking
        {
            [System.ComponentModel.Description("1 - Highest")]
            Highest,
            [System.ComponentModel.Description("2 - High")]
            High,
            [System.ComponentModel.Description("3 - Medium/Opportunistic")]
            MediumOpportunistic,
            [System.ComponentModel.Description("4 - Declined")]
            Declined
        }

        public enum Status
        {
            [System.ComponentModel.Description("Draft")]
            Draft,
            [System.ComponentModel.Description("Submitted for Review")]
            SubmittedForReview,
            [System.ComponentModel.Description("Declined")]
            Declined,
            [System.ComponentModel.Description("Approved")]
            Approved,
            [System.ComponentModel.Description("Scheduled")]
            Scheduled,
            [System.ComponentModel.Description("Completed")]
            Completed,
            [System.ComponentModel.Description("Opportunistic")]
            Opportunistic
        }

        #endregion

        public void Dispose()
        {
            _reportController.Dispose();
        }

        public static vEngagementLeaderSchedule EngagementLeaderSchedule(string title, string details, string objectives, int principalId, int executiveSponsorId,
            Visibility visibility, EngagementType engagementType, int regionId, int countryId, Purpose purpose, int durationId, DateFlexible dateFlexible, 
            Division division, int teamId, StrategicPriority strategicPriority, TeamRanking teamRanking, TeamRanking presidentRanking, Status status)
        {
            return new vEngagementLeaderSchedule
            {
                Id = 0,
                Title = title,
                Details = details,
                DetailsRtf = "",
                Objectives = objectives,
                ObjectivesRtf = "",
                PrincipalRequired = GetPrincipal(principalId),
                ExecutiveSponsor = GetExecutiveSponsor(executiveSponsorId),
                Visibility = visibility.ToString(),
                EngagementType = engagementType.ToString(),
                EngagementExtInt = GetRegion(regionId) + "/" + GetCountry(countryId),
                Region = GetRegion(regionId),
                Country = GetCountry(countryId),
                Purpose = GetEnumDescription(purpose),
                BriefOwner = GetBriefOwner(),
                Staff = GetBriefOwner(),
                Duration = GetDuration(durationId).Item1,
                DurationInMinutes = GetDuration(durationId).Item2,
                DurationInDays = GetDuration(durationId).Item3,
                DateFlexible = dateFlexible.ToString(),
                YearQuarter = GetYearQuarter(),
                DateStart = DateTime.Now,
                DateEnd = DateTime.Now.AddDays(7),
                TeamInfo = "Div: " + GetEnumDescription(division) + " Team: " + GetTeam(teamId) + " Pri: " + GetEnumDescription(strategicPriority) + " Rank: " + GetEnumDescription(teamRanking),
                Division = GetEnumDescription(division),
                DivisionDescription = GetEnumDescription(division),
                Team = GetTeam(teamId),
                StrategicPriority = GetEnumDescription(strategicPriority),
                TeamRanking = GetEnumDescription(teamRanking),
                PresidentRanking = GetEnumDescription(teamRanking),
                PresidentComment = "",
                PresidentCommentRtf = "",
                Status = GetEnumDescription(status),
                StatusDisplaySortSequence = GetStatusDisplaySortSequence(status),
                EntryDate = DateTime.Now,
                EntryBY = "",
                ModifiedDate = DateTime.Now,
                ModifiedBy = "",
                ScheduleFromDate = DateTime.Now.AddMonths(1),
                ScheduleToDate = DateTime.Now.AddMonths(1).AddDays(15),
                ScheduleComment = "Unit Testing",
                ScheduleApprovalStatus = "",
                IsConfidential = false,
                IsExternal = true,
                EntryCompleted = true,
                PresidentReviewCompleted = true,
                ScheduleCompleted = false,
                ScheduleReviewCompleted = false,
                ScheduleId = 0
            };
        }

        private static int GetRandomNumber(int min = 1000000, int max = 9999999)
        {
            var randomNumber = 0;
            var isRandomNumberExistingInDb = false;
            lock (_random)
            {
                validateRandomNumber:
                randomNumber = _random.Next(min, max);
                isRandomNumberExistingInDb = _leadDb.Engagements.Count(q => q.Id.Equals(randomNumber)) > 0;
                if (isRandomNumberExistingInDb) goto validateRandomNumber;
            }
            return randomNumber;
        }

        private static string GetEnumDescription(Enum value)
        {
            FieldInfo fieldInfo = value.GetType().GetField(value.ToString());
            System.ComponentModel.DescriptionAttribute[] attributes = (System.ComponentModel.DescriptionAttribute[])fieldInfo.GetCustomAttributes(typeof(System.ComponentModel.DescriptionAttribute), false);
            if (attributes != null && attributes.Length > 0)
                return attributes[0].Description;
            else
                return value.ToString();
        }

        public static string GetPrincipal(int principalId)
        {
            var principal = _leadDb.Leaders.SingleOrDefault(q => q.Id.Equals(principalId));
            return principal.LastName + ", " + principal.FirstName;
        }

        public static string GetExecutiveSponsor(int executiveSponsorId)
        {
            var executiveSponsor = _leadDb.Leaders.SingleOrDefault(q => q.Id.Equals(executiveSponsorId));
            return executiveSponsor.FirstName;
        }

        public static string GetRegion(int regionId)
        {
            var region = _leadDb.Regions.SingleOrDefault(q => q.Id.Equals(regionId));
            return region.regionName;
        }

        public static string GetCountry(int countryId)
        {
            var country = _leadDb.Countries.SingleOrDefault(q => q.Id.Equals(countryId));
            return country.countryName;
        }

        public static Tuple<string, int, int> GetDuration(int durationId)
        {
            var duration = _leadDb.Durations.SingleOrDefault(q => q.Id.Equals(durationId));
            return Tuple.Create(duration.duration, duration.DurationInMinutes, duration.DurationInDays);
        }

        private static string GetYearQuarter()
        {
            var currentYear = DateTime.Now.Year;
            var currentMonth = DateTime.Now.Month;
            var dMonth = String.Empty;
            switch(currentMonth)
            {
                case 1:
                case 2:
                case 3:
                    dMonth = "01";
                    break;
                case 4:
                case 5:
                case 6:
                    dMonth = "02";
                    break;
                case 7:
                case 8:
                case 9:
                    dMonth = "03";
                    break;
                case 10:
                case 11:
                case 12:
                    dMonth = "04";
                    break;
            }
            var quarterId = Int32.Parse(currentYear + dMonth);
            var yearQuarter = _leadDb.YearQuarters.SingleOrDefault(q => q.Id.Equals(quarterId));
            return yearQuarter.Display;
        }

        public static string GetTeam(int teamId)
        {
            var team = _leadDb.Teams.SingleOrDefault(q => q.Id.Equals(teamId));
            return team.team;
        }

        private static int GetStatusDisplaySortSequence(Status status)
        {
            var enumDesc = GetEnumDescription(status);
            var sortSequence = _leadDb.Status.SingleOrDefault(q => q.Name.Equals(enumDesc));
            return sortSequence.DisplaySortSequence;
        }

        private static string GetBriefOwner()
        {
            var currentLoggedUser = System.Security.Principal.WindowsIdentity.GetCurrent().Name.ToLower();
            var briefOwner = _leadDb.SysUsers.SingleOrDefault(q => q.ADUser.Equals(currentLoggedUser));
            return briefOwner.FullName;
        }
    }
}