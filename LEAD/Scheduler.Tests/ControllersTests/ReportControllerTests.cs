using System.Collections.Generic;
using System.Linq;
using NUnit.Framework;
using System.Threading;
using Scheduler.Tests.Providers;
using System.Net;
using Newtonsoft.Json;
using Scheduler.Models;

namespace Scheduler.Tests.ControllersTests
{
    [TestFixture]
    public class ReportControllerTests : ReportProvider
    {
        private vEngagementLeaderSchedule _engagementLeaderSchedule;

        private static IEnumerable<TestCaseData> TestCaseDataEngagementIds()
        {
            yield return new TestCaseData(1000795);
            yield return new TestCaseData(1000009);
        }

        private static IEnumerable<TestCaseData> TestCaseDataEngagementInvalidIds()
        {
            yield return new TestCaseData(0);
            yield return new TestCaseData(10);
        }

        [Test]
        [TestCaseSource("TestCaseDataEngagementIds")]
        [Description("Unit test of GetvEngagementLeaderSchedule() function")]
        [Ignore("This is a running test if we're permitted to modify the Scheduler-ReportController")]
        public void Should_ReturnEngagementLeaderSchedules_UsingValidIds(int engagementId)
        {
            var httpActionResult = _reportController.GetvEngagementLeaderSchedule(engagementId);
            Assert.That(httpActionResult, Is.Not.Null.Or.Empty);

            var responseMessage = httpActionResult.ExecuteAsync(new CancellationToken()).GetAwaiter().GetResult();
            Assert.AreEqual(responseMessage.StatusCode, HttpStatusCode.OK);

            var responseResult = JsonConvert.DeserializeObject<dynamic>(responseMessage.Content.ReadAsStringAsync().Result);
            var engagementScheduleQuery = _leadDb.vEngagementLeaderSchedules.SingleOrDefault(q => q.Id.Equals(engagementId));
            Assert.AreEqual(responseResult.Id.Value, engagementScheduleQuery.Id);
            Assert.AreEqual(responseResult.ScheduleId.Value, engagementScheduleQuery.ScheduleId);
            Assert.AreEqual(responseResult.Purpose.Value, engagementScheduleQuery.Purpose);
        }

        [Test]
        [TestCaseSource("TestCaseDataEngagementInvalidIds")]
        [Description("Unit test of GetvEngagementLeaderSchedule() function")]
        [Ignore("This is a running test if we're permitted to modify the Scheduler-ReportController")]
        public void Should_ThrowNotFoundResult_UsingInvalidIds(int engagementId)
        {
            var httpActionResult = _reportController.GetvEngagementLeaderSchedule(engagementId);
            var responseMessage = httpActionResult.ExecuteAsync(new CancellationToken()).GetAwaiter().GetResult();
            Assert.AreEqual(responseMessage.StatusCode, HttpStatusCode.NotFound);
            Assert.IsFalse(responseMessage.IsSuccessStatusCode);
        }

        [Test]
        [Ignore("For further investigation")]
        [Description("Unit test of PostvEngagementLeaderSchedule() function")]
        public void Should_PostEngagementLeaderSchedule_NewRecord()
        {
            _engagementLeaderSchedule = EngagementLeaderSchedule(
                "Test", "Unit Testing", "Unit Testing", 1005, 1011,
                Visibility.Open, 
                EngagementType.External,
                1017,
                1088,
                Purpose.ProgressReview,
                1014,
                DateFlexible.Flexible,
                Division.GlobalPolicyAndAdvocacy,
                1037,
                StrategicPriority.USEducation,
                TeamRanking.Highest,
                TeamRanking.High,
                Status.Scheduled);

            var httpActionResult = _reportController.PostvEngagementLeaderSchedule(_engagementLeaderSchedule);
            Assert.That(httpActionResult, Is.Not.Null.Or.Empty);

            var responseMessage = httpActionResult.ExecuteAsync(new CancellationToken()).GetAwaiter().GetResult();
            Assert.AreEqual(responseMessage.StatusCode, HttpStatusCode.OK);
        }

        [Test]
        [TestCase(1000804)]
        [Ignore("For further investigation")]
        public void Should_DeleteEngagementLeaderSchedule_UsingValidId(int id)
        {
            var httpActionResult = _reportController.DeletevEngagementLeaderSchedule(id);
            Assert.That(httpActionResult, Is.Not.Null.Or.Empty);

            var responseMessage = httpActionResult.ExecuteAsync(new CancellationToken()).GetAwaiter().GetResult();
            Assert.AreEqual(responseMessage.StatusCode, HttpStatusCode.OK);
        }
    }
}
