using System.Web.Http;
using NUnit.Framework;
using Scheduler.Tests.Providers;

namespace Scheduler.Tests.Controllers
{
    [TestFixture]
    public class LookupControllerTests : LookupProvider
    {
        private void AssertEntity(IHttpActionResult httpActionResult)
        {
            ActionResult(httpActionResult);
            ResponseMessage(httpActionResult);
        }

        [Test]
        public void Should_ReturnResultsAndSuccessStatusCode_GetDivisions()
        {
            // Arrange / Act
            var actionResult = _lookUpController.GetDivisions();

            // Assert
            AssertEntity(actionResult);
        }

        [Test]
        public void Should_ReturnResultsAndSuccessStatusCode_GetTeams()
        {
            // Arrange / Act
            var actionResult = _lookUpController.GetTeams();

            // Assert
            AssertEntity(actionResult);
        }

        [Test]
        public void Should_ReturnResultsAndSuccessStatusCode_GetLeaders()
        {
            // Arrange / Act
            var actionResult = _lookUpController.GetLeaders();

            // Assert
            AssertEntity(actionResult);
        }

        [Test]
        public void Should_ReturnResultsAndSuccessStatusCode_GetExecutiveSponsors()
        {
            // Arrange / Act
            var actionResult = _lookUpController.GetExecutiveSponsors();

            // Assert
            AssertEntity(actionResult);
        }

        [Test]
        public void Should_ReturnResultsAndSuccessStatusCode_GetAlternatePrincipals()
        {
            // Arrange / Act
            var actionResult = _lookUpController.GetAlternatePrincipals();

            // Assert
            AssertEntity(actionResult);
        }

        [Test]
        public void Should_ReturnResultsAndSuccessStatusCode_GetRequiredPrincipals()
        {
            // Arrange / Act
            var actionResult = _lookUpController.GetRequiredPrincipals();

            // Assert
            AssertEntity(actionResult);
        }

        [Test]
        public void Should_ReturnResultsAndSuccessStatusCode_GetStrategicPriorities()
        {
            // Arrange / Act
            var actionResult = _lookUpController.GetStrategicPriorities();

            // Assert
            AssertEntity(actionResult);
        }

        [Test]
        public void Should_ReturnResultsAndSuccessStatusCode_GetTeamRankings()
        {
            // Arrange / Act
            var actionResult = _lookUpController.GetTeamRankings();

            // Assert
            AssertEntity(actionResult);
        }

        [Test]
        public void Should_ReturnResultsAndSuccessStatusCode_GetRegions()
        {
            // Arrange / Act
            var actionResult = _lookUpController.GetRegions();

            // Assert
            AssertEntity(actionResult);
        }

        [Test]
        public void Should_ReturnResultsAndSuccessStatusCode_GetCountries()
        {
            // Arrange / Act
            var actionResult = _lookUpController.GetCountries();

            // Assert
            AssertEntity(actionResult);
        }

        [Test]
        public void Should_ReturnResultsAndSuccessStatusCode_GetPurposes()
        {
            // Arrange / Act
            var actionResult = _lookUpController.GetPurposes();

            // Assert
            AssertEntity(actionResult);
        }

        [Test]
        public void Should_ReturnResultsAndSuccessStatusCode_GetSysUsers()
        {
            // Arrange / Act
            var actionResult = _lookUpController.GetSysUsers();

            // Assert
            AssertEntity(actionResult);
        }

        [Test]
        public void Should_ReturnResultsAndSuccessStatusCode_GetDurations()
        {
            // Arrange / Act
            var actionResult = _lookUpController.GetDurations();

            // Assert
            AssertEntity(actionResult);
        }

        [Test]
        public void Should_ReturnResultsAndSuccessStatusCode_GetYearQuarter()
        {
            // Arrange / Act
            var actionResult = _lookUpController.GetYearQuarter();

            // Assert
            AssertEntity(actionResult);
        }

        [Test]
        public void Should_ReturnResultsAndSuccessStatusCode_GetStatus()
        {
            // Arrange / Act
            var actionResult = _lookUpController.GetStatus();

            // Assert
            AssertEntity(actionResult);
        }

        [Test]
        public void Should_ReturnResultsAndSuccessStatusCode_GetRanking()
        {
            // Arrange / Act
            var actionResult = _lookUpController.GetRanking();

            // Assert
            AssertEntity(actionResult);
        }
    }
}
