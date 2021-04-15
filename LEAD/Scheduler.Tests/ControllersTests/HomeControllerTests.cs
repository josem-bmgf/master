using NUnit.Framework;
using Scheduler.Controllers;
using System.Web.Mvc;
using System.Collections.Generic;

namespace Scheduler.Tests.ControllersTests
{
    [TestFixture]
    public class HomeControllerTests
    {
        [SetUp]
        public void SetUp()
        {
            _homeController = new HomeController();
        }

        private HomeController _homeController;

        [Test]
        public void Should_ReturnNullViewName_Index()
        {
            var viewResult = _homeController.Index() as ViewResult;
            Assert.AreEqual(string.Empty, viewResult.ViewName);
        }

        [Test]
        public void Should_ReturnNullViewName_Engagement()
        {
            var viewResult = _homeController.Engagement() as ViewResult;
            Assert.AreEqual(string.Empty, viewResult.ViewName);
        }

        [Test]
        public void Should_ReturnNullViewName_Report()
        {
            var viewResult = _homeController.Report() as ViewResult;
            Assert.AreEqual(string.Empty, viewResult.ViewName);
        }

        [Test]
        public void Should_ReturnNullViewName_Error()
        {
            var viewResult = _homeController.Error() as ViewResult;
            Assert.AreEqual(string.Empty, viewResult.ViewName);
        }

        [Test]
        [TestCase("Engagement")]
        [TestCase("ErrorLogs")]
        [TestCase("Home")]
        [TestCase("Lookup")]
        [TestCase("Report")]
        public void Should_ReturnNullViewName_AccessDenied(string page)
        {
            var viewResult = _homeController.AccessDenied(page) as ViewResult;
            Assert.AreEqual(string.Empty, viewResult.ViewName);
        }

        [Test]
        public void Should_ReturnNullViewName_Administration()
        {
            var viewResult = _homeController.Administration() as ViewResult;
            Assert.AreEqual(string.Empty, viewResult.ViewName);
        }

    }
}
