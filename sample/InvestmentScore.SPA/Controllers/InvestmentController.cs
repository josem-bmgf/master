using InvestmentScore.Spa.Helpers;
using InvestmentScore.Spa.Infrastructure;
using InvestmentScore.Spa.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace InvestmentScore.Spa.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    public class InvestmentController : Controller
    {
        private InvestmentScoreContext _context;
        public FISConfigurations _configurations;
        public DateReference _dateReference;
        public static List<Investment_Payment> _fundingTeam;

        public InvestmentController(InvestmentScoreContext context, IOptions<FISConfigurations> properties, IOptions<DateReference> dateReference)
        {
            _context = context;
            _configurations = properties.Value;
            _dateReference = dateReference.Value;           
        }

        public List<Investment_Payment> LoadFundingTeam()
        {
            _fundingTeam = _context.Investment_Payment
                             .Where(p => !string.IsNullOrEmpty(p.Strategy) && p.Strategy.Trim() != string.Empty)
                             .OrderBy(p => p.Strategy).Select(p => new Investment_Payment
                             {
                                 Strategy = p.Strategy,
                                 InvestmentId = p.InvestmentId
                             }).ToList();

            return _fundingTeam;
        }

        /// <summary>
        /// Gets the investment details of the specified investment ID
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet("[action]")]
        [NoCache]
        public JsonResult Get([FromQuery]int id)
        {       
            var investment = _context.Investment
                .Include(i => i.Scores)
                .Include(t => t.TaxonomyValues)
                .Select(i => new
                {
                    AmtPaidToDate = i.AmtPaidToDate.Value.ToString("N0"),
                    i.FundingType,
                    i.Id,
                    i.IdCombined,
                    i.InvDescription,
                    InvEndDate = i.InvEndDate.Value.ToString("d"),
                    i.InvGranteeVendorName,
                    i.InvLevelOfEngagement,
                    i.InvManager,
                    i.InvOwner,
                    InvStartDate = i.InvStartDate.Value.ToString("d"),
                    i.InvStatus,
                    i.InvTitle,
                    i.InvType,
                    i.ManagingTeamLevel1,
                    i.ManagingTeamLevel2,
                    i.ManagingTeamLevel3,
                    i.ManagingTeamLevel4,
                    i.PmtExpenditureType,
                    i.TaxonomyValues,
                    Scores = i.Scores.OrderByDescending(s => s.ScoreYear).ToList(),
                    TotalInvestmentAmount = i.TotalInvestmentAmount.Value.ToString("N0"),
                    FundingTeams = GetInvestmentFundingTeams(i.IdCombined),
                    i.IsDeleted,
                    i.IsExcludedFromTOI
                })
                .FirstOrDefault(i => i.Id == id);
            return Json(investment);
        }

        public static string GetInvestmentFundingTeams(string investmentId )
        {         
            var payments = _fundingTeam.Where(x => x.InvestmentId == investmentId).Select(s => s.Strategy).Distinct();

            if (payments != null) {
                return string.Join(", ", payments);
            }

            return string.Empty;  
        }

        /// <summary>
        /// Returns a list of 20 investments that matches the specified criteria
        /// </summary>
        /// <param name="term"></param>
        /// <param name="overFiveMillion"></param>
        /// <returns></returns>
        [HttpGet("[action]")]
        [NoCache]
        public JsonResult Search([FromQuery]string term, bool overFiveMillion)
        {
            if (_fundingTeam == null)
            {
                LoadFundingTeam();
            }

            IEnumerable<Investment> investments = null;
            if (term is null)
            {
                investments = returnInvestmentQuery();
            }
            else
            {
                List<string> terms = term.ToUpper().Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries).Distinct().ToList<string>();

                investments = returnInvestmentQuery().AsEnumerable()
                    .Where(i => MatchesSearchTerms(terms, i.InvTitle, i.IdCombined, i.InvManager, i.InvOwner, i.InvGranteeVendorName, i.ManagingTeamLevel2));
            }

            if (overFiveMillion)
            {
                investments = investments.AsEnumerable().Where(i => i.TotalInvestmentAmount >= 5000000);
            }

            investments = investments.Take(100);

            return Json(investments.Select(i => new
            {
                i.Id,
                i.IdCombined,
                i.InvDescription,
                i.InvGranteeVendorName,
                i.InvTitle
            }));
        }

        public class SearchTerm {
            public string Term;
            public bool Found;

            public SearchTerm(string term) {
                this.Term = term;
                this.Found = false;
            }
        }

        /// <summary>
        /// Checks if all search terms provided is contained by the series of values provided
        /// </summary>
        /// <param name="input">Input string to check</param>
        /// <param name="terms">List of search terms</param>
        /// <returns></returns>
        public bool MatchesSearchTerms(List<string> terms, params string[] values) {

            List<SearchTerm> searchTerms = new List<SearchTerm>();
            foreach(string t in terms)
            {
                if (string.IsNullOrWhiteSpace(t)
                    || searchTerms.Where(s => string.Compare(s.Term, t, true) == 0).Any())
                    continue;

                SearchTerm searchTerm = new SearchTerm(t.ToUpper());
                searchTerms.Add(searchTerm);
            }

            foreach (SearchTerm st in searchTerms)
            {
                foreach (string v in values)
                {
                    if (string.IsNullOrWhiteSpace(v))
                    {
                        continue;
                    }

                    if (v.ToUpper().Contains(st.Term))
                    {
                        st.Found = true;
                        break;
                    }
                }

                if (!st.Found) {
                    return false;
                }
            }
            
            return true;
        }

        /// <summary>
        /// Deletes the score with the specified ID
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet("[action]")]
        public JsonResult DeleteScore([FromQuery]int id)
        {
            _context.Scores.Remove(_context.Scores.Find(id));
            int result = _context.SaveChanges();

            return Json(1);
        }

        /// <summary>
        /// The existing investment is updated based on the passed investment object
        /// </summary>
        /// <param name="investment"></param>
        /// <returns></returns>
        [HttpPost("[action]")]
        public JsonResult SaveInvestment([FromBody] Investment investment)
        {
            Investment data = _context.Investment
                .Where<Investment>(i => i.Id == investment.Id)
                .FirstOrDefault<Investment>();
            data.IsExcludedFromTOI = investment.IsExcludedFromTOI;
            _context.SaveChanges();

            return Json(data);
        }

        /// <summary>
        /// Creates a new Score record if the score.id specified is 0 or doesn't exisit in the DB context
        /// Otherwise, the existing score is updated based on the passed score object
        /// </summary>
        /// <param name="score"></param>
        /// <returns></returns>
        [HttpPost("[action]")]
        public JsonResult SaveScore([FromBody] Models.ScoringDetail.Scores score)
        {
            int? scoreYear = score.scoreYear == null ? (int?)null : int.Parse(score.scoreYear);
            int? investmentId = score.investmentId == null ? (int?)null : int.Parse(score.investmentId);

            Scores data = _context.Scores
                .Where<Scores>(s => s.Id == score.id
                    || s.ScoreYear == scoreYear && s.InvestmentId == investmentId)
                .FirstOrDefault<Scores>();
            
            User currentUser = GetCurrentUser();

            if (data == null)
            {
                data = new Scores();
                data.CreatedOn = DateTime.Now.ToUniversalTime();
                data.CreatedBy = currentUser;
                data.CreatedById = currentUser.Id;
                data.ScoreDate = data.CreatedOn;

                // All newly created data are tagged as non-historical
                data.IsArchived = false;
            }

            data.InvestmentId = score.investmentId == null ? (int?)null : int.Parse(score.investmentId);
            data.PerformanceAgainstMilestones = score.performanceAgainstMilestones;
            data.PerformanceAgainstStrategy = score.performanceAgainstStrategy;
            data.ReinvestmentProspects = score.reinvestmentProspects;

            data.Rationale = score.rationale;
            data.KeyResultsData = score.keyResultsData;
            data.FundingTeamInput = score.fundingTeamInput;

            data.HighestPerforming = score.highestPerforming == null ? false : bool.Parse(score.highestPerforming);
            data.LowestPerforming = score.lowestPerforming == null ? false : bool.Parse(score.lowestPerforming);
            data.ExcludeFromScoring = score.excludeFromScoring == null ? false : bool.Parse(score.excludeFromScoring);
            data.IsExcluded = score.isExcluded == null ? false : bool.Parse(score.isExcluded);

            data.ScoreYear = score.scoreYear == null ? (int?)null : int.Parse(score.scoreYear);
            data.Objective = score.objective;

            data.ScoredBy = _context.User.Where<User>(u => u.Id == score.scoredById).FirstOrDefault<User>();

            if (data.ScoredBy != null)
            {
                data.ScoredById = score.scoredById;
                data.User = data.ScoredBy.DisplayName;
            }

            data.ModifiedBy = currentUser;
            data.ModifiedById = currentUser.Id;

            data.ModifiedOn = DateTime.Now.ToUniversalTime();

            if (data.Id == 0)
            {
                _context.Add(data);
            }

            _context.SaveChanges();

            return Json(data);

        }

        /// <summary>
        /// Retrieves the list of users sorted by DisplayName
        /// </summary>
        /// <returns></returns>
        [HttpGet("[action]")]
        public JsonResult GetUsers()
        {
            IEnumerable<User> users = _context.User.OrderBy(u => u.DisplayName);
            return Json(users.Select(u => new
            {
                u.Id,
                u.Department,
                u.DisplayName,
                u.Email,
                u.EmployeeId,
                u.JobTitle,
                u.LoginName,
                u.Mobile,
                u.PrincipleType,
                u.SipAddress,
                u.LastUpdated
            }));
        }

        /// <summary>
        /// Returns the ID of the current user
        /// </summary>
        /// <returns></returns>
        [HttpGet("[action]")]
        public JsonResult GetCurrentUserID()
        {
            string currentUserId = GetCurrentUser().Id;
            return Json(currentUserId);
        }

        public User GetCurrentUser()
        {
            User currentUser = _context.User
                .Where(u => u.Email == User.Identity.Name || u.DisplayName == User.Identity.Name)
                .FirstOrDefault();
            return currentUser;
        }

        /// <summary>
        /// Return Investment LINQ that will be displayed in the Investment Score UI
        /// </summary>
        /// <returns></returns>
        public IQueryable<Investment> returnInvestmentQuery()
        {
            return _context.Investment.Where(i => 
                i.IsDeleted.Equals(false)
                && (i.InvStatus.Equals("Active")
                    || (i.InvType.Equals("Contract")
                        && Constants.ContractClosedStatus.Contains(i.InvStatus)
                        && (i.InvEndDate != null
                            && i.InvEndDate.Value.Year >= (
                                DateTime.Now >= DateTime.ParseExact(
                                    _dateReference.EndOfSeason,
                                    _dateReference.EndOfSeasonFormat,
                                    System.Globalization.CultureInfo.InvariantCulture)
                                ? DateTime.Now.Year : DateTime.Now.Year - 1)))
                    || (Constants.OpportunityType.Contains(i.InvType)
                        && Constants.OpportunityClosedStatus.Contains(i.InvStatus)
                        && (i.InvEndDate != null
                            && i.InvEndDate.Value.Year >= (
                                DateTime.Now >= DateTime.ParseExact(
                                    _dateReference.EndOfSeason,
                                    _dateReference.EndOfSeasonFormat,
                                    System.Globalization.CultureInfo.InvariantCulture)
                                ? DateTime.Now.Year : DateTime.Now.Year - 1)))
                )
            );
        }

        /// <summary>
        /// Return field length properties
        /// </summary>
        /// <returns></returns>
        [HttpGet("[action]")]
        public JsonResult FieldLengthProperties()
        {
            return Json(_configurations.FieldLength);
        }
        
    }
}
