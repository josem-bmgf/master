using System;
using System.Collections.Generic;

namespace InvestmentScore.Spa.Models
{
    public partial class ReportCategories
    {
        public ReportCategories()
        {
            Reports = new HashSet<Reports>();
        }

        public int Id { get; set; }
        public string Name { get; set; }
        public int DisplaySortSequence { get; set; }
        public bool IsActive { get; set; }

        public virtual ICollection<Reports> Reports { get; set; }
    }
}
