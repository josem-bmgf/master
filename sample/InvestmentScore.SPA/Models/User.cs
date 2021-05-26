using System;
using System.Collections.Generic;

namespace InvestmentScore.Spa.Models
{
    public partial class User
    {
        public User()
        {
            ScoresCreatedBy = new HashSet<Scores>();
            ScoresModifiedBy = new HashSet<Scores>();
            ScoresScoredBy = new HashSet<Scores>();
        }

        public string Id { get; set; }
        public string Department { get; set; }
        public string DisplayName { get; set; }
        public string Email { get; set; }
        public string JobTitle { get; set; }
        public string LoginName { get; set; }
        public string Mobile { get; set; }
        public int? PrincipleType { get; set; }
        public string SipAddress { get; set; }
        public DateTime? LastUpdated { get; set; }
        public string DivisionId { get; set; }
        public string Division { get; set; }
        public string EmployeeId { get; set; }

        public virtual ICollection<Scores> ScoresCreatedBy { get; set; }
        public virtual ICollection<Scores> ScoresModifiedBy { get; set; }
        public virtual ICollection<Scores> ScoresScoredBy { get; set; }
    }
}
