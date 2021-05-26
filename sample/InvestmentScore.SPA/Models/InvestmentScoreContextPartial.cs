using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace InvestmentScore.Spa.Models
{
    public partial class InvestmentScoreContext : DbContext
    {
        public virtual DbSet<POCO_TaxonomyValues> POCO_TaxonomyValues { get; set; }
    }
}
