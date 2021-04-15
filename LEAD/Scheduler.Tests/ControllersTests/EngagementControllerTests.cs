using System.Collections.Generic;
using NUnit.Framework;
using Scheduler.Controllers;
using System.Net.Http;
using System.Web.Http;
using Scheduler.Api.Helpers;
using Scheduler.Helpers;
using Scheduler.Tests.Providers;
using Scheduler.Tests.HelpersTests;

namespace Scheduler.Tests.ControllerTests
{
    [TestFixture]
    public class EngagementControllerTests : EngagementProvider
    {
        [SetUp]
        public void Init()
        {
            leadAssert = new LeadAssert();
            SessionHelper.ValidateUser(_userLoggedIn);
            _engagementController = new EngagementController
            {
                Request = new HttpRequestMessage(),
                Configuration = new HttpConfiguration()
            };
        }

        private LeadAssert leadAssert;

        private static IEnumerable<TestCaseData> TestCaseDataSource()
        {
            yield return new TestCaseData(1);
            yield return new TestCaseData(2);
            yield return new TestCaseData(3);
        }

        private void AssertEntity(IHttpActionResult httpActionResult)
        {
            leadAssert.ActionResult(httpActionResult);
            leadAssert.ResponseMessage(httpActionResult);
        }

        [Test]
        [TestCaseSource("TestCaseDataSource")]
        [Description("Unit test of GetEngagement() function")]
        public void Should_ReturnEngagementDetails_UsingDifferentSource(int source)
        {
            // Arrange / Act
            var httpActionResult = _engagementController.GetEngagements(source);

            // Assert
            AssertEntity(httpActionResult);
        }

        [Test]
        [Description("Unit test of GetScheduleSysUserDisplay() function")]
        [TestCase(1000000, Constants.TripDirector)]
        [TestCase(1000000, Constants.CommunicationsLead)]
        [TestCase(1000000, Constants.SpeechWriter)]
        public void Should_ReturnSysUserDisplay_UsingEngagementIdsWithDifferentType(int engagementId, int typeFk)
        {
            // Arrange / Act
            var actionResult = _engagementController.GetScheduleSysUserDisplay(engagementId, typeFk);

            // Assert
            Assert.That(actionResult, Is.Not.Null.Or.Empty);
        }

        [Test]
        [Description("Unit test of HardDeleteEngagement() function")]
        public void Should_DeleteAnEngagement_UsingDummyData()
        {
            // Arrange
            var newEngagement = CreateEngagement();
            _engagementController.SaveEngagement(newEngagement, 1);

            // Act
            var actionResult = _engagementController.HardDeleteEngagement(newEngagement);

            // Assert
            leadAssert.ActionResult(actionResult);
        }

        [Test]
        [Description("Unit test SaveEngagement() Function")]
        public void Should_SaveAnEngagement_UsingDummyData()
        {
            // Arrange
            var newEngagement = CreateEngagement();
            var actionResult = _engagementController.SaveEngagement(newEngagement, 1);

            // Act
            LeadDataInserter.AddEntityForDeletion(newEngagement);

            // Assert
            leadAssert.ActionResult(actionResult);
        }

        [Test]
        [Description("Unit test SetPostEngagementValues() function")]
        public void Should_SetPostEngagementValues()
        {
            // Arrange
            var newEngagement = CreateEngagement();
            var actionResult = _engagementController.SetPostEngagementValues(newEngagement, _userLoggedIn);

            // Act
            LeadDataInserter.AddEntityForDeletion(newEngagement);

            // Assert
            Assert.IsNotNull(actionResult);
        }

        [Test]
        [Description("Unit test SetPostEngagementScheduleValues() function")]
        public void Should_SetPostEngagementScheduleValues()
        {
            // Arrange
            var newEngagement = CreateEngagement();

            var schedule = ScheduleProvider.GetSchedule(newEngagement);
            var actionResult = _engagementController.SetPostEngagementScheduleValues(schedule);

            // Act
            LeadDataInserter.AddEntityForDeletion(newEngagement);

            // Assert
            Assert.IsNotNull(actionResult);
        }

        [Test]
        [Description("Unit test SaveEngagementSchedule() Function")]
        public void Should_SaveAnEngagementSchedule_UsingDummyData()
        {
            // Arrange
            var newEngagement = CreateEngagement();
            _engagementController.SaveEngagement(newEngagement, 1);

            var schedule = ScheduleProvider.GetSchedule(newEngagement);
            var actionResult = _engagementController.SaveEngagementSchedule(1, schedule);

            // Act
            LeadDataInserter.AddEntityForDeletion(newEngagement);

            // Assert
            leadAssert.ActionResult(actionResult);
        }

    }
}
