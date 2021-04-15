using NUnit.Framework;
using Scheduler.Controllers;
using Scheduler.Tests.HelpersTests;
using System.Web.Http;
using System.Net.Http;

namespace Scheduler.Tests.ControllersTests
{
    [TestFixture]
    public class ErrorLogsControllerTests : LeadAssert
    {
        [SetUp]
        public void Setup()
        {
            _errorLogsController = new ErrorLogsController
            {
                Request = new HttpRequestMessage(),
                Configuration = new HttpConfiguration()
            };
        }

        [TearDown]
        public void TearDown()
        {
            _errorLogsController.Dispose();
        }

        public static ErrorLogsController _errorLogsController;

        [Test]
        public void Should_ReturnErrorLogs()
        {
            var actionResult = _errorLogsController.GetErrors();
            ActionResult(actionResult);
            ResponseMessage(actionResult);
        }
    }
}
