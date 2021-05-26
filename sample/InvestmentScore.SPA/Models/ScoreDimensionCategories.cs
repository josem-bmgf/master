using System;
using System.Collections.Generic;

namespace InvestmentScore.Spa.Models
{
    public partial class ScoreDimensionCategories
    {
        public ScoreDimensionCategories()
        {
            ScoreDimensionValues = new HashSet<ScoreDimensionValues>();
        }

        public int Id { get; set; }
        public string Name { get; set; }
        public bool IsActive { get; set; }

        public virtual ICollection<ScoreDimensionValues> ScoreDimensionValues { get; set; }
    }
}
