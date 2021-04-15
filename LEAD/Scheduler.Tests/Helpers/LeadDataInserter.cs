using System;
using Scheduler.Models;
using Scheduler.Controllers;
using System.Collections.Generic;

namespace Scheduler.Tests.HelpersTests
{
    public class LeadDataInserter
    {
        private static EngagementController _engagementController = new EngagementController();
        private static List<Engagement> listEngagement = new List<Engagement>();

        public static void AddEntityForDeletion(Engagement engagement)
        {
            if (!listEngagement.Contains(engagement))
            {
                listEngagement.Add(engagement);
            }
        }

        public static void DeleteEngagement()
        {
            try
            {
                foreach(Engagement engagement in listEngagement)
                {
                    _engagementController.HardDeleteEngagement(engagement);
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
    }
}
