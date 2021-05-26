using System;
using System.Collections.Generic;

namespace InvestmentScore.Spa.Models
{
    public partial class DimensionCategories
    {
        public DimensionCategories()
        {
            DimensionValues = new HashSet<DimensionValues>();
        }

        public int Id { get; set; }
        public string Name { get; set; }
        public bool IsActive { get; set; }

        public virtual ICollection<DimensionValues> DimensionValues { get; set; }
    }
}
