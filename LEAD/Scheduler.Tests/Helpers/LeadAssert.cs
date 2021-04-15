using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Net.Http;
using System.Threading;
using NUnit.Framework;

namespace Scheduler.Tests.HelpersTests
{
    public class LeadAssert
    {
        public void ActionResult(IHttpActionResult httpActionResult)
        {
            if (httpActionResult == null) throw new Exception("IHttpActionResult cannot be null");
            Assert.That(httpActionResult, Is.Not.Null.Or.Empty);
        }

        public void ResponseMessage(IHttpActionResult httpActionResult)
        {
            if (httpActionResult == null) throw new Exception("IHttpActionResult cannot be null");

            var responseMessage = httpActionResult.ExecuteAsync(new CancellationToken()).GetAwaiter().GetResult();
            Assert.That(responseMessage, Is.Not.Null.Or.Empty);
            Assert.IsTrue(responseMessage.IsSuccessStatusCode);

            IEnumerable<dynamic> dynamicModel;
            Assert.IsTrue(responseMessage.TryGetContentValue(out dynamicModel));
            Assert.That(dynamicModel, Is.Not.Null.Or.Empty);
        }

        public void EngagementResponseMessage(IHttpActionResult httpActionResult)
        {
            if (httpActionResult == null) throw new Exception("IHttpActionResult cannot be null");

            var responseMessage = httpActionResult.ExecuteAsync(new CancellationToken()).GetAwaiter().GetResult();
            Assert.That(responseMessage, Is.Not.Null.Or.Empty);
            Assert.IsTrue(responseMessage.IsSuccessStatusCode);            
        }
    }
}
