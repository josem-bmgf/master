using System;
using System.Collections.Generic;

namespace InvestmentScore.Spa.Models
{
    public partial class TaxonomyItems
    {
        public TaxonomyItems()
        {
            TaxonomyValues = new HashSet<TaxonomyValues>();
        }

        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public int TaxonomyCategoryId { get; set; }
        public bool IsActive { get; set; }
        public string Label { get; set; }
        public int? SortOrder { get; set; }
        public bool IsNumeric { get; set; }

        public virtual ICollection<TaxonomyValues> TaxonomyValues { get; set; }
        public virtual TaxonomyCategories TaxonomyCategory { get; set; }
    }
}
