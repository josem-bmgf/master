--Migrate YearQuarterFk to Engagement Year Quarter table
TRUNCATE TABLE [dbo].[EngagementYearQuarter];
EXEC [dbo].[uspMigrateEngagementYearQuarter] 1000000, 1;

--Migrate AlternatePrincipalFK and RequiredPrincipalFK to Principal table
TRUNCATE TABLE [dbo].[Principal];
EXEC [dbo].[uspMigratePrincipal] 1000000, 1, 1000;
EXEC [dbo].[uspMigratePrincipal] 1000000, 1, 1001;

--Fill up Status column in Engagement table
EXEC [dbo].[uspMigrateStatus] 1000000, 1;