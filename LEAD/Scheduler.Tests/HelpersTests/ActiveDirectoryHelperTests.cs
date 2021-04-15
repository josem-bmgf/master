using NUnit.Framework;
using Scheduler.Api.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http;
using Scheduler.Helpers;
using Scheduler.Tests.Providers;

namespace Scheduler.Tests.HelpersTests
{
    [TestFixture]
    public class ActiveDirectoryHelperTests : HelperProvider
    {              
        [Test]
        [Description("Unit test of GetDomainGroups() function")]
        public void Should_ReturnDomainGroups_UsingExistingUser()
        {
            // Arrange / Act
            var httpActionResult = ActiveDirectoryHelper.GetDomainGroups("dev\\app_lead_scheduler");

            // Assert
            Assert.IsNotNull(httpActionResult);
        }

        [Test]
        [Description("Unit test of GetDomainGroups() function")]
        public void Should_ReturnZeroDomainGroups_UsingInvalidUser()
        {
            // Arrange / Act
            var httpActionResult = ActiveDirectoryHelper.GetDomainGroups("invaliduser");

            // Assert
            Assert.AreEqual(0,httpActionResult.Count);
        }
        
        [Test]
        [Description("Unit test of GetDirectoryEntry() function")]
        public void Should_ReturnDirectoryEntry_UsingExistingUser()
        {
            // Arrange / Act
            var httpActionResult = ActiveDirectoryHelper.GetDirectoryEntry(_userLoggedIn);

            // Assert
            Assert.IsNotNull(httpActionResult);
        }

        [Test]
        [Description("Unit test of GetDirectoryEntry() function")]
        public void Should_ReturnNullDirectoryEntry_UsingInvalidUser()
        {
            // Arrange / Act
            var httpActionResult = ActiveDirectoryHelper.GetDirectoryEntry("invaliduser");

            // Assert
            Assert.IsNull(httpActionResult);
        }


    }
}
