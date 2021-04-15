using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Scheduler.Models;

namespace Scheduler.Tests.Providers
{
    public class ScheduleProvider : Schedule
    {
        #region Data Creation
        private static LeadershipEngagementPlannerEntities _db;
        public static Schedule GetSchedule(Engagement engagement)
        {
            _db = new LeadershipEngagementPlannerEntities();
            var schedule = Schedule(engagement);
            _db.Dispose();

            return schedule;

        }
        private static Schedule Schedule(Engagement engagement)
        {
            return new Schedule
            {
                Id = 0,
                EngagementFk = engagement.Id,
                LeaderFk = 0,
                DateFrom = null,
                DateTo = null,
                TripDirectorFk = 0,
                SpeechWriterFk = 0,
                CommunicationsLeadFk = 0,
                BriefDueToGCEByDate = null,
                BriefDueToBGC3ByDate = null,
                ScheduleComment = "",
                ScheduleCommentRtf = "",
                ScheduledByFk = 0,
                ScheduledDate = null,
                ApproveDecline = "",
                ReviewComment = "",
                ReviewCommentRtf = "",
                ReviewCompletedByFk = 0,
                ReviewCompletedDate = null,
                IsDeleted = false,
                Leader = null,
                ReviewCompletedBy = null,
                ScheduledBy = null,
                CommunicationsLead = null,
                SpeechWriter = null,
                TripDirector = null,
                Engagement = engagement
            };                       
        }        
        #endregion
    }
}
