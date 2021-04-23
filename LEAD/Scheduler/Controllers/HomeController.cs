using System.Threading.Tasks;
using System.Web.Mvc;
using Scheduler.Api.Helpers;
using Scheduler.Helpers;

namespace Scheduler.Controllers
{
    [Authorize]
    public class HomeController : Controller
    {
        // GET: Home
        public async Task<ActionResult> Index()
        {
            await SessionHelper.ValidateUser(User.Identity.Name);
            return View();
        }

        [AuthorizedDomainGroups(DomainGroups = "IsLeadAll,IsLeadAdmin,IsLeadApprover,IsLeadMultiDivisionUser")]
        public ActionResult Engagement()
        {
            return View();
        }

        public ActionResult Report()
        {
            return View();
        }

        public ActionResult Error()
        {
            return View();
        }

        public ActionResult AccessDenied(string page)
        {
            ViewData["PageName"] = page;
            return View();
        }

        [AuthorizedDomainGroups(DomainGroups = "IsLeadAdmin")]
        public ActionResult Administration()
        {
            return View();
        }
    }
}