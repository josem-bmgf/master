using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace InvestmentScore.Spa.Models
{
    public partial class InvestmentScoreContext : DbContext
    {
        public virtual DbSet<Investment> Investment { get; set; }
        public virtual DbSet<Investment_Payment> Investment_Payment { get; set; }
        public virtual DbSet<ReportCategories> ReportCategories { get; set; }
        public virtual DbSet<Reports> Reports { get; set; }
        public virtual DbSet<DimensionCategories> DimensionCategories { get; set; }
        public virtual DbSet<DimensionValues> DimensionValues { get; set; }
        public virtual DbSet<Scores> Scores { get; set; }
        public virtual DbSet<TaxonomyCategories> TaxonomyCategories { get; set; }
        public virtual DbSet<TaxonomyItems> TaxonomyItems { get; set; }
        public virtual DbSet<TaxonomyValues> TaxonomyValues { get; set; }
        public virtual DbSet<User> User { get; set; }

        // Unable to generate entity type for table 'dbo.Investment_Payment'. Please see the warning messages.
        public InvestmentScoreContext(DbContextOptions<InvestmentScoreContext> options)
            : base(options) { }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<POCO_TaxonomyValues>();
            modelBuilder.Entity<Investment>(entity =>
            {
                entity.Property(e => e.Id).HasColumnName("ID");

                entity.Property(e => e.AmtPaidToDate)
                    .HasColumnName("Amt_Paid_To_Date")
                    .HasColumnType("decimal");

                entity.Property(e => e.FundingType)
                    .HasColumnName("Funding_Type")
                    .HasMaxLength(50);

                entity.Property(e => e.IdCombined)
                    .HasColumnName("ID_Combined")
                    .HasMaxLength(255);

                entity.Property(e => e.InvDescription).HasColumnName("INV_Description");

                entity.Property(e => e.InvEndDate)
                    .HasColumnName("INV_End_Date")
                    .HasColumnType("datetime");

                entity.Property(e => e.InvGranteeVendorName)
                    .HasColumnName("INV_Grantee_Vendor_Name")
                    .HasMaxLength(255);

                entity.Property(e => e.InvLevelOfEngagement)
                    .HasColumnName("INV_Level_of_Engagement")
                    .HasMaxLength(100);

                entity.Property(e => e.InvManager)
                    .HasColumnName("INV_Manager")
                    .HasMaxLength(255);

                entity.Property(e => e.InvOwner).HasColumnName("INV_Owner");

                entity.Property(e => e.InvStartDate)
                    .HasColumnName("INV_Start_Date")
                    .HasColumnType("datetime");

                entity.Property(e => e.InvStatus)
                    .HasColumnName("INV_Status")
                    .HasMaxLength(255);

                entity.Property(e => e.InvTitle)
                    .HasColumnName("INV_Title")
                    .HasMaxLength(255);

                entity.Property(e => e.InvType)
                    .HasColumnName("INV_Type")
                    .HasMaxLength(100);

                entity.Property(e => e.ManagingTeamLevel1)
                    .HasColumnName("Managing_Team_Level_1")
                    .HasMaxLength(255);

                entity.Property(e => e.ManagingTeamLevel2)
                    .HasColumnName("Managing_Team_Level_2")
                    .HasMaxLength(255);

                entity.Property(e => e.ManagingTeamLevel3)
                    .HasColumnName("Managing_Team_Level_3")
                    .HasMaxLength(255);

                entity.Property(e => e.ManagingTeamLevel4)
                    .HasColumnName("Managing_Team_Level_4")
                    .HasMaxLength(255);

                entity.Property(e => e.OldInvestmentId).HasColumnName("Old_Investment_ID");

                entity.Property(e => e.OldInvestmentIdMnf).HasColumnName("Old_Investment_ID_MNF");

                entity.Property(e => e.OppClosedDate)
                    .HasColumnName("OPP_Closed_Date")
                    .HasColumnType("datetime");

                entity.Property(e => e.PmtExpenditureType)
                    .HasColumnName("PMT_Expenditure_Type")
                    .HasMaxLength(100);

                entity.Property(e => e.TotalInvestmentAmount)
                    .HasColumnName("Total_Investment_Amount")
                    .HasColumnType("decimal");

                entity.Property(e => e.IsDeleted)
                    .HasColumnName("Is_Deleted").HasDefaultValueSql("0");

                entity.Property(e => e.IsExcludedFromTOI)
                    .HasColumnName("Is_Excluded_From_TOI")
                    .HasColumnType("bit")
                    .HasDefaultValueSql("0");
            });
            
            modelBuilder.Entity<Investment_Payment>(entity =>
            {

                entity.Property(e => e.Id).HasColumnName("ID");
                entity.Property(e => e.InvestmentId).HasColumnName("INV_ID").HasMaxLength(255);
                entity.Property(e => e.PaymentId).HasColumnName("PMT_Payment_ID").HasMaxLength(255);
                entity.Property(e => e.Strategy).HasColumnName("PMT_Strategy").HasMaxLength(100);
            });

            modelBuilder.Entity<ReportCategories>(entity =>
            {
                entity.ToTable("Report_Categories");

                entity.Property(e => e.IsActive).HasDefaultValueSql("1");

                entity.Property(e => e.Name).HasMaxLength(100);

                entity.Property(e => e.DisplaySortSequence);
            });
            
            modelBuilder.Entity<Reports>(entity =>
            {
                entity.ToTable("Reports");

                entity.Property(e => e.Description).HasMaxLength(500);

                entity.Property(e => e.DisplaySortSequence);

                entity.Property(e => e.ReportUrl);

                entity.Property(e => e.IsActive).HasDefaultValueSql("1");

                entity.Property(e => e.ReportCategoryId);

                entity.Property(e => e.Name).HasColumnType("varchar(250)");

                entity.HasOne(d => d.ReportCategory)
                    .WithMany(p => p.Reports)
                    .HasForeignKey(d => d.ReportCategoryId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Reports_Report_Categories");
            });

            modelBuilder.Entity<DimensionCategories>(entity =>
            {
                entity.ToTable("Dimension_Categories");

                entity.Property(e => e.IsActive).HasDefaultValueSql("1");

                entity.Property(e => e.Name).HasMaxLength(100);
            });

            modelBuilder.Entity<DimensionValues>(entity =>
            {
                entity.ToTable("Dimension_Values");

                entity.Property(e => e.DimensionCategoryId).HasDefaultValueSql("0");
                
                entity.Property(e => e.Name).HasColumnType("varchar(250)");

                entity.HasOne(d => d.DimensionCategory)
                    .WithMany(p => p.DimensionValues)
                    .HasForeignKey(d => d.DimensionCategoryId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Dimension_Values_Dimension_Categories");
            });

            modelBuilder.Entity<Scores>(entity =>
            {
                entity.Property(e => e.Id).HasColumnName("ID");

                entity.Property(e => e.CreatedById)
                    .HasColumnName("Created_By_ID")
                    .HasMaxLength(255);

                entity.Property(e => e.CreatedOn)
                    .HasColumnName("Created_On")
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("getdate()");

                entity.Property(e => e.ExcludeFromScoring).HasColumnName("Exclude_from_Scoring");

                entity.Property(e => e.FundingTeamInput).HasColumnName("Funding_Team_Input");

                entity.Property(e => e.HighestPerforming).HasColumnName("Highest_Performing");

                entity.Property(e => e.InvestmentId).HasColumnName("Investment_ID");

                entity.Property(e => e.KeyResultsData).HasColumnName("Key_Results_Data");

                entity.Property(e => e.LowestPerforming).HasColumnName("Lowest_Performing");

                entity.Property(e => e.ModifiedById)
                    .HasColumnName("Modified_By_ID")
                    .HasMaxLength(255);

                entity.Property(e => e.ModifiedOn)
                    .HasColumnName("Modified_On")
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("getdate()");

                entity.Property(e => e.Objective).HasMaxLength(220);

                entity.Property(e => e.OldInvestmentId).HasColumnName("Old_Investment_ID");

                entity.Property(e => e.OldInvestmentIdMnf).HasColumnName("Old_Investment_ID_MNF");
                
                entity.Property(e => e.PerformanceAgainstMilestones)
                    .HasColumnName("Performance_Against_Milestones")
                    .HasMaxLength(220);

                entity.Property(e => e.PerformanceAgainstStrategy)
                    .HasColumnName("Performance_Against_Strategy")
                    .HasMaxLength(220);

                entity.Property(e => e.RelativeStrategicImportance)
                    .HasColumnName("Relative_Strategic_Importance")
                    .HasMaxLength(220);

                entity.Property(e => e.ReinvestmentProspects)
                    .HasColumnName("Reinvestment_Prospects")
                    .HasMaxLength(220);
                
                entity.Property(e => e.IsArchived)
                    .HasColumnName("Is_Archived")
                    .HasColumnType("bit");
                
                entity.Property(e => e.IsExcluded)
                    .HasColumnName("Is_Excluded")
                    .HasColumnType("bit");

                entity.Property(e => e.ScoreDate)
                    .HasColumnName("Score_Date")
                    .HasColumnType("datetime");

                entity.Property(e => e.ScoreYear).HasColumnName("Score_Year");

                entity.Property(e => e.ScoredById)
                    .HasColumnName("Scored_By_ID")
                    .HasMaxLength(255);

                entity.Property(e => e.User).HasMaxLength(220);

                entity.HasOne(d => d.CreatedBy)
                    .WithMany(p => p.ScoresCreatedBy)
                    .HasForeignKey(d => d.CreatedById)
                    .HasConstraintName("FK_Created_By_ID");

                entity.HasOne(d => d.Investment)
                    .WithMany(p => p.Scores)
                    .HasForeignKey(d => d.InvestmentId)
                    .HasConstraintName("FK_Scoring_ToInvestment");

                entity.HasOne(d => d.ModifiedBy)
                    .WithMany(p => p.ScoresModifiedBy)
                    .HasForeignKey(d => d.ModifiedById)
                    .HasConstraintName("FK_Modified_By_ID");
                
                entity.HasOne(d => d.ScoredBy)
                    .WithMany(p => p.ScoresScoredBy)
                    .HasForeignKey(d => d.ScoredById)
                    .HasConstraintName("FK_Scored_By_ID");
            });

            modelBuilder.Entity<TaxonomyValues>(entity =>
            {
                entity.ToTable("Taxonomy_Values");

                entity.Property(e => e.Id).HasColumnName("ID");

                entity.Property(e => e.InvestmentId).HasColumnName("Investment_ID");

                entity.Property(e => e.NumericValue).HasColumnName("Numeric_Value");

                entity.Property(e => e.TaxonomyItemId).HasColumnName("Taxonomy_Item_ID");

                entity.HasOne(d => d.Investment)
                    .WithMany(p => p.TaxonomyValues)
                    .HasForeignKey(d => d.InvestmentId)
                    .HasConstraintName("FK_Taxonomy_Values_Investment");

                entity.HasOne(d => d.TaxonomyItem)
                    .WithMany(p => p.TaxonomyValues)
                    .HasForeignKey(d => d.TaxonomyItemId)
                    .HasConstraintName("FK_Taxonomy_Values_Taxonomy_Items");
            });

            modelBuilder.Entity<TaxonomyCategories>(entity =>
            {
                entity.ToTable("Taxonomy_Categories");

                entity.Property(e => e.Id).HasColumnName("ID");

                entity.Property(e => e.Description).HasMaxLength(500);

                entity.Property(e => e.IsActive).HasDefaultValueSql("1");

                entity.Property(e => e.Label).HasMaxLength(250);

                entity.Property(e => e.Name).HasMaxLength(50);
            });

            modelBuilder.Entity<TaxonomyItems>(entity =>
            {
                entity.ToTable("Taxonomy_Items");

                entity.Property(e => e.Id).HasColumnName("ID");

                entity.Property(e => e.Description).HasMaxLength(500);

                entity.Property(e => e.IsActive).HasDefaultValueSql("1");

                entity.Property(e => e.IsNumeric).HasDefaultValueSql("1");

                entity.Property(e => e.Label).HasMaxLength(250);

                entity.Property(e => e.Name).HasMaxLength(50);

                entity.Property(e => e.TaxonomyCategoryId).HasColumnName("Taxonomy_Category_ID");

                entity.HasOne(d => d.TaxonomyCategory)
                    .WithMany(p => p.TaxonomyItems)
                    .HasForeignKey(d => d.TaxonomyCategoryId)
                    .OnDelete(DeleteBehavior.Restrict)
                    .HasConstraintName("FK_Taxonomy_Values_Taxonomy_Categories");
            });

            modelBuilder.Entity<TaxonomyValues>(entity =>
            {
                entity.ToTable("Taxonomy_Values");

                entity.Property(e => e.Id).HasColumnName("ID");

                entity.Property(e => e.InvestmentId).HasColumnName("Investment_ID");

                entity.Property(e => e.NumericValue).HasColumnName("Numeric_Value");

                entity.Property(e => e.TaxonomyItemId).HasColumnName("Taxonomy_Item_ID");

                entity.HasOne(d => d.Investment)
                    .WithMany(p => p.TaxonomyValues)
                    .HasForeignKey(d => d.InvestmentId)
                    .HasConstraintName("FK_Taxonomy_Values_Investment");

                entity.HasOne(d => d.TaxonomyItem)
                    .WithMany(p => p.TaxonomyValues)
                    .HasForeignKey(d => d.TaxonomyItemId)
                    .HasConstraintName("FK_Taxonomy_Values_Taxonomy_Items");
            });

            modelBuilder.Entity<User>(entity =>
            {
                entity.Property(e => e.Id)
                    .HasColumnName("ID")
                    .HasMaxLength(255);

                entity.Property(e => e.Department).HasMaxLength(255);

                entity.Property(e => e.DisplayName).HasMaxLength(255);

                entity.Property(e => e.Division).HasMaxLength(255);

                entity.Property(e => e.DivisionId)
                    .HasColumnName("DivisionID")
                    .HasMaxLength(255);

                entity.Property(e => e.Email).HasMaxLength(255);

                entity.Property(e => e.EmployeeId)
                    .HasColumnName("EmployeeID")
                    .HasMaxLength(10);

                entity.Property(e => e.JobTitle).HasMaxLength(255);

                entity.Property(e => e.LastUpdated).HasColumnType("datetime");

                entity.Property(e => e.LoginName).HasMaxLength(255);

                entity.Property(e => e.Mobile).HasMaxLength(255);

                entity.Property(e => e.SipAddress).HasMaxLength(255);
            });
        }
    }
}