using System;
using System.Collections.Generic;

namespace InvestmentScore.Spa.Models
{
    public partial class Investment_Payment
    {
        public Investment_Payment()
        {
        }

        public int Id { get; set; }
        public string InvestmentId { get; set; }
        public string PaymentId { get; set; }
        public string Strategy { get; set; }
        
    }
}
