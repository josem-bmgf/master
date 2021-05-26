using System;
using System.Collections.Generic;

namespace InvestmentScore.Spa.Models
{
    public partial class TaxonomyValues
    {
        public int Id { get; set; }
        public string Value { get; set; }
        public int? NumericValue { get; set; }
        public int? TaxonomyItemId { get; set; }
        public int? InvestmentId { get; set; }

        public virtual Investment Investment { get; set; }
        public virtual TaxonomyItems TaxonomyItem { get; set; }
    }
}
