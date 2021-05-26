using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Mvc;
using InvestmentScore.Spa.Models;
using InvestmentScore.Spa.Helpers;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace InvestmentScore_Spa.Controllers
{
    [Route("api/[controller]")]
    public class LookupController : Controller
    {
        private InvestmentScoreContext _context;
        public FISConfigurations _configurations;
        public DateReference _dateReference;
        public MaintenanceNoticeConfiguration _maintenanceNotice;

        public LookupController(InvestmentScoreContext context, IOptions<FISConfigurations> properties, IOptions<DateReference> dateReference, IOptions<MaintenanceNoticeConfiguration> maintenanceNotice)
        {
            _context = context;
            _configurations = properties.Value;
            _dateReference = dateReference.Value;
            _maintenanceNotice = maintenanceNotice.Value;
        }

        /// <summary>
        /// Retrieves all dimension categories with their corresponding dimension values
        /// </summary>
        /// <returns></returns>
        [HttpGet("[action]")]
        public JsonResult GetDimensionCategories()
        {
            IEnumerable<DimensionCategories> dimensionCategories = null;
            dimensionCategories = _context.DimensionCategories.Include(c => c.DimensionValues).ToArray();

            return Json(dimensionCategories.Select(s => new
            {
                s.Id,
                s.Name,
                s.IsActive,
                DimensionValues = s.DimensionValues.OrderBy(v => v.DisplaySortSequence)
            }));
        }

        /// <summary>
        /// Retrieves all dimension values
        /// </summary>
        /// <returns></returns>
        [HttpGet("[action]")]
        public JsonResult GetDimensionValues()
        {
            IEnumerable<DimensionValues> dimensionValues = null;

            dimensionValues = _context.DimensionValues.ToArray();

            return Json(dimensionValues.Select(s => new
            {
                s.Id,
                s.Name,
                s.DimensionCategoryId,
                s.DisplaySortSequence

            }).OrderBy(s => s.DisplaySortSequence));

        }

        /// <summary>
        /// Return FISLink Url property
        /// </summary>
        /// <returns></returns>
        [HttpGet("[action]")]
        public JsonResult GetFISLinks()
        {
            return Json(_configurations.GuidanceURL);
        }

        /// <summary>
        /// Return Preview Report Url 
        /// </summary>
        /// <returns></returns>
        [HttpGet("[action]")]
        public JsonResult GetPreviewDetailedSlideReportLink()
        {
            return Json(_configurations.PreviewDetailedSlideReportURL);
        }

        /// <summary>
        /// Return Fraudulent Activity URL
        /// </summary>
        /// <returns></returns>
        [HttpGet("[action]")]
        public JsonResult GetFraudulentActivityURL()
        {
            return Json(_configurations.FraudulentActivityURL);
        }

        /// <summary>
        /// Return Privacy and cookies URL
        /// </summary>
        /// <returns></returns>
        [HttpGet("[action]")]
        public JsonResult GetPrivacyAndCookiesURL()
        {
            return Json(_configurations.PrivacyAndCookiesURL);
        }

        /// <summary>
        /// Return Term of use URL
        /// </summary>
        /// <returns></returns>
        [HttpGet("[action]")]
        public JsonResult GetTermsOfUseURL()
        {
            return Json(_configurations.TermsOfUseURL);
        }

        /// <summary>
        /// Return Date of End of Season
        /// </summary>
        /// <returns></returns>
        [HttpGet("[action]")]
        public JsonResult GetEndSeasonDate()
        {
            return Json(_dateReference.EndOfSeason);
        }

        /// <summary>
        /// Return Test Score Year
        /// </summary>
        /// <returns></returns>
        [HttpGet("[action]")]
        public JsonResult GetTestScoreYear()
        {
            return Json(_dateReference.TestScoreYear);
        }

        /// <summary>
        /// Return Maintenance Notice HTML
        /// </summary>
        /// <returns></returns>
        [HttpGet("[action]")]
        public JsonResult GetMaintenanceNoticeHTML()
        {
            return Json(_maintenanceNotice.MaintenanceNoticeHTML);
        }
    }
}
