using System;
using System.Collections.Generic;

namespace InvestmentScore.Spa.Models
{
    public partial class ScoreDimensionValues
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public bool IsArchived { get; set; }
        public int DimensionCategoryFk { get; set; }
        public int DisplaySortSequence { get; set; }

        public virtual ScoreDimensionCategories DimensionCategoryFkNavigation { get; set; }
    }
}
