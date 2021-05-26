using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using InvestmentScore.Spa.Models;
using Microsoft.Extensions.Options;
using Microsoft.AspNetCore.Authorization;

namespace InvestmentScore_Spa.Controllers
{    
    public class HomeController : Controller
    {

        //private InvestmentScoreContext _context;
        private readonly IOptions<InvestmentScoreConfig> _investmentScoreConfig;

        public HomeController(InvestmentScoreContext context, IOptions<InvestmentScoreConfig> optionsAccessor)
        {
            _investmentScoreConfig = optionsAccessor;
            //_context = context;

        }

        [Authorize]
        public IActionResult Index()
        {
            var config = new
            {
                tenant = _investmentScoreConfig.Value.Tenant,
                clientId = _investmentScoreConfig.Value.ClientId
            };
            ViewData["clientId"] = _investmentScoreConfig.Value.ClientId;
            ViewData["tenant"] = _investmentScoreConfig.Value.Tenant;
            return View();
        }

        public IActionResult AccessDenied()
        {
            return View();
        }
    }
}
