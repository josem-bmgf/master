using System.Linq;
using System.Web.Http;
using System.Net.Http;
using NUnit.Framework;
using Scheduler.Models;
using Scheduler.Controllers;
using Scheduler.Tests.HelpersTests;

namespace Scheduler.Tests.Providers
{
    [SetUpFixture]
    public class LookupProvider : LeadAssert
    {
        #region SetUp

        [OneTimeSetUp]
        public void SetUp()
        {
            _lookUpController = new LookupController
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

        public static LookupController _lookUpController;
        public static LeadershipEngagementPlannerEntities _leadDb;

        private void Dispose()
        {
            _lookUpController.Dispose();
        }
    }
}
