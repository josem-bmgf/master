using System;
using System.Collections.Generic;

namespace InvestmentScore.Spa.Models
{
    public partial class TaxonomyCategories
    {
        public TaxonomyCategories()
        {
            TaxonomyItems = new HashSet<TaxonomyItems>();
        }

        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
        public string Label { get; set; }
        public int? SortOrder { get; set; }

        public virtual ICollection<TaxonomyItems> TaxonomyItems { get; set; }
    }
}
