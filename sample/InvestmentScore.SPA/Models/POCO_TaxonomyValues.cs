using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace InvestmentScore.Spa.Models
{

    public class POCO_TaxonomyValues
    {
        public string Id { get; set; }
        public int CategoryId { get; set; }
        public int ItemId { get; set; }
        public string ItemLabel { get; set; }
        public int? ItemSort { get; set; }
        public int? ValueId { get; set; }
        public int? Allocation { get; set; }
        public string Comment { get; set; }
        public bool IsAllocation { get; set; }       
    }
}
