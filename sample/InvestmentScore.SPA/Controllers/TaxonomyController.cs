using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using InvestmentScore.Spa.Models;
using System.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using InvestmentScore.Spa.Infrastructure;
using Microsoft.AspNetCore.Authorization;
using Microsoft.Extensions.Options;
using InvestmentScore.Spa.Helpers;

namespace InvestmentScore_Spa.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    public class TaxonomyController : Controller
    {
        private InvestmentScoreContext _context;
        public Division _divisions;

        public TaxonomyController(InvestmentScoreContext context, IOptions<Division> division)
        {
            _context = context;
            _divisions = division.Value;
        }

         // GET: api/users
        /// <summary>
        /// Return a flag if the Taxonomy tabs should be enabled for the user
        /// </summary>
        /// <returns></returns>
        [HttpGet("[action]")]
        public JsonResult GetTaxonomyFlag()
        {
            var divisions = _divisions.Divisions;
            var user = _context.User.FirstOrDefault(u => divisions.Contains(u.DivisionId) &&
                User.Identity.Name == u.Email);
            return Json(user != null);

        }   
        
        /// <summary>
        /// Retrieves all taxonomy categories
        /// </summary>
        /// <returns></returns>
        [HttpGet("[action]")]
        public JsonResult GetTaxonomyCategories()
        {
            var x = _context.TaxonomyCategories
                .Include(c => c.TaxonomyItems)
                .Where(tc => tc.IsActive)
                .OrderBy(c => c.SortOrder);
            return Json(x);
        }

        /// <summary>
        /// Retrieves all questions of taxonomy items
        /// </summary>
        /// <returns></returns>
        [HttpGet("[action]")]
        public JsonResult GetQuestions()
        {
            var x = _context.TaxonomyItems
                .Where(tq => tq.IsActive)
                .OrderBy(c => c.SortOrder);
            return Json(x);
        }

        /// <summary>
        /// Retrieves all taxonomies of a specified investment
        /// </summary>
        /// <param name="investmentId"></param>
        /// <returns></returns>
        [NoCache]
        [HttpGet("[action]")]
        public JsonResult GetTaxonomy(int investmentId)
        {
            var x = _context.POCO_TaxonomyValues.FromSqlRaw("[dbo].[usp_GetTaxonomyByInvestmentId] @investmentId = {0}", investmentId).ToArray();
            return Json(x);
        }

        /// <summary>
        /// Creates or updates a taxonomy value
        /// </summary>
        /// <param name="taxonomyValues"></param>
        /// <returns></returns>
        [HttpPost("[action]")]
        public JsonResult SaveTaxonomy([FromBody] TaxonomyValues[] taxonomyValues)
        {

            foreach (var taxonomyValue in taxonomyValues)
            {

                var dbTaxonomyValue = _context.TaxonomyValues
                    .FirstOrDefault(tv => tv.TaxonomyItemId.Value == taxonomyValue.TaxonomyItemId.Value
                              && tv.InvestmentId.Value == taxonomyValue.InvestmentId.Value);
                if (taxonomyValue.Id == 0 && dbTaxonomyValue == null)
                {
                    _context.TaxonomyValues.Add(taxonomyValue);
                }
                else
                {
                    dbTaxonomyValue.NumericValue = taxonomyValue.NumericValue;
                    dbTaxonomyValue.Value = taxonomyValue.Value;
                    _context.TaxonomyValues.Update(dbTaxonomyValue);
                }
            }
            
            Task<int> savechanges = _context.SaveChangesAsync();
            savechanges.Wait();            

            return Json(taxonomyValues);
        }

    }
}
