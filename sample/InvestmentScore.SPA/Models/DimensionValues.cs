using System;
using System.Collections.Generic;

namespace InvestmentScore.Spa.Models
{
    public partial class DimensionValues
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int DimensionCategoryId { get; set; }
        public int DisplaySortSequence { get; set; }

        public virtual DimensionCategories DimensionCategory { get; set; }
    }
}
