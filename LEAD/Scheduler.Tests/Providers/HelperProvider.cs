using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Http;
using NUnit.Framework;
using Scheduler.Api.Helpers;

namespace Scheduler.Tests.Providers
{
    [SetUpFixture]
    public class HelperProvider : ApiController
    {
        [OneTimeSetUp]
        public void SetUp()
        {            
            Thread.CurrentPrincipal = new GenericPrincipal(new GenericIdentity(Environment.UserName), new[] { "" });
            _userLoggedIn = ActiveDirectoryHelper.UserLoggedIn(User.Identity.Name);
        }

        public static string _userLoggedIn;
    }
}
