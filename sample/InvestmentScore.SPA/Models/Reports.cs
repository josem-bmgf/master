using System;
using System.Collections.Generic;

namespace InvestmentScore.Spa.Models
{
    public partial class Reports
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int ReportCategoryId { get; set; }
        public int? DisplaySortSequence { get; set; }
        public string Description { get; set; }
        public string ReportUrl { get; set; }
        public bool IsActive { get; set; }

        public virtual ReportCategories ReportCategory { get; set; }
    }
}
