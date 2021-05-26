CREATE PROCEDURE [dbo].[sp_GetInvestmentDetails]
	@Division      NVARCHAR(100),
	@Strategy      NVARCHAR(100),
	@FilterBy      NVARCHAR(100),
	@Order_Group_1 NVARCHAR(100)
AS

BEGIN

	/*******************************************************************************
	Author:		Marlon Ho
	Created Date:	08/10/2017
	Description:	Get the list of Investment Details
	Usage:
		EXEC [sp_GetInvestmentDetails]
			  @Division = 'Global Policy and Advocacy',
			  @Strategy = 'Program Advocacy & Comms',
			  @FilterBy = 'Managed Only,Funded Only,Managed and Funded Only',
			  @Order_Group_1  = 'Managed Only, Funded Only, Managed and Funded Only'

	Changed By		        Date		Description 
	--------------------------------------------------------------------------------
	Marlon Ho				08/10/2017	Initial Version
	Alvin John Apilan		08/21/2017	Updated Sort order
	Marlon Ho				08/23/2017	Bug 144037: Investment Score: SSRS: Change TOP/BOTTOM PERFORMING display
	Alvin John Apilan       08/24/2017  Added INV_Managing_Team and INV_Managing_SubTeam in WHERE Clause
	Marlon Ho				08/25/2017	Bug 144225: Display of Multiple Score in Detailed Slides
	Marlon Ho				09/06/2017	US 144197:  Create a separate SSRS reports to generate Investment Scoring Summary
	Alvin John Apilan		09/07/2017  US 144772:  Added ReportValue for Scoring Year in Detailed Slide
	Darwin Baluyot			09/14/2017	US 144921:  Added ORDER BY clause for Total Investment Amount and Total Strategy Amount
	Darwin Baluyot			09/20/2017	BUG 144536: Updated ORDER BY clause to reflect correct sorting in UI
	Richard Joseph Santos   10/02/2017	US 145603:	Update INVs grouping logic, Refactor
	Marlon Ho				10/04/2017	US 144952:  Add PMT_Initiative information on the result
	Richard Joseph Santos   10/05/2017	US 145846:	Update INVs grouping logic, including PMT_Initiative
	Jenina Chua			    10/06/2017  US 145846 Bug 145921: Capture funded investments with 0 strategy allocation amount
	Darwin Baluyot			11/14/2017	US 146501:	Added filter to exclude specific investments
	Karla Tuazon			01/03/2018  ZD62425: Change the current year to 2017
	Jonson Villanueva		05/14/2021  BUG 36640:	Resolve Stored Procedures in IST database related to exclude flag change
	*******************************************************************************/

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @tmpInvestmentDetails        AS TABLE (
		ID_Combined                      NVARCHAR (255)
		,PMT_Initiative					 NVARCHAR (100)
		,Category                        NVARCHAR (23)
		,Total_Investment_Amount         MONEY
		,Total_Strategy_Amount           MONEY
		,INV_Managing_Team               NVARCHAR (50)
		,INV_Managing_SubTeam            NVARCHAR (255)
		,INV_Managing_Team_Level_3       NVARCHAR (255)
		,INV_Grantee_Vendor_Name         NVARCHAR (255)
		,INV_Title                       NVARCHAR (255)
		,INV_Description                 NVARCHAR (4000)
		,INV_Owner                       NVARCHAR (4000)
		,INV_Start_Date                  DATETIME
		,INV_End_Date                    DATETIME
		,ThisYearPerfAgainstExecution    NVARCHAR (220)
		,ThisYearPerfAgainstExecBGColor  NVARCHAR (25)
		,LastYearPerfAgainstExecution    NVARCHAR (220)
		,LastYearPerfAgainstExecBGColor  NVARCHAR (25)
		,ThisYearReinvestmentProspects   NVARCHAR (220)
		,ThisYearReinvestmentProsBGColor NVARCHAR (25)
		,LastYearReinvestmentProspects   NVARCHAR (220)
		,LastYearReinvestmentProsBGColor NVARCHAR (25)
		,ThisYearPerfAgainstStrategy     NVARCHAR (220)
		,ThisYearPerfAgainstStratBGColor NVARCHAR (25)
		,LastYearPerfAgainstStrategy     NVARCHAR (220)
		,LastYearPerfAgainstStratBGColor NVARCHAR (25)
		,ThisYearRelStratImpt            NVARCHAR (220)
		,ThisYearRelStratImptBGColor     NVARCHAR (25)
		,LastYearRelStratImpt            NVARCHAR (220)
		,LastYearRelStratImptBGColor     NVARCHAR (25)
		,Multi_Strat                     BIT
		,Rationale                       NVARCHAR (MAX)
		,Key_Results_Data                NVARCHAR (MAX)
		,Funding_Team_Input              NVARCHAR (MAX)
		,Amt_Paid_To_Date                MONEY
	)
	
	--KCT: Set current year to 2017
	DECLARE @ScoringYear AS INT = '2017'

	DECLARE
		@ManagedOnlyLiteral             NVARCHAR (MAX) = 'Managed Only'
		,@FundedOnlyLiteral             NVARCHAR (MAX) = 'Funded Only'
		,@ManagedandFundedOnlyLiteral   NVARCHAR (MAX) = 'Managed and Funded Only'
		,@InvnotalignedLiteral          NVARCHAR (MAX) = 'Investment not aligned to strategy team''s initiatives'
       
	INSERT INTO @tmpInvestmentDetails
	SELECT
		INV_PYMT.ID_Combined
		,INV_PYMT.PMT_Initiative
		,INV_PYMT.Category
		,MAX(ISNULL(INV_PYMT.INV_Total_Payout_Amt,0))                AS Total_Investment_Amount
		,SUM(INV_PYMT.PMT_Strategy_Allocation_Amt)                   AS Total_Strategy_Amount
		,INV_PYMT.INV_Managing_Team
		,INV_PYMT.INV_Managing_SubTeam
		,INV_PYMT.INV_Managing_Team_Level_3
		,INV_PYMT.INV_Grantee_Vendor_Name
		,INV_PYMT.INV_Title
		,INV_PYMT.INV_Description
		,INV_PYMT.INV_Owner
		,INV_PYMT.INV_Start_Date
		,INV_PYMT.INV_End_Date
		,ThisYearPerfAgainstExecution.Performance_Against_Milestones AS ThisYearPerfAgainstExecution
		,ThisYearPerfAgainstExecution.BGColor                        AS ThisYearPerfAgainstExecBGColor
		,LastYearPerfAgainstExecution.Performance_Against_Milestones AS LastYearPerfAgainstExecution
		,LastYearPerfAgainstExecution.BGColor                        AS LastYearPerfAgainstExecBGColor
		,ThisYearReinvestmentProspects.Reinvestment_Prospects        AS ThisYearReinvestmentProspects
		,ThisYearReinvestmentProspects.BGColor                       AS ThisYearReinvestmentProsBGColor
		,LastYearReinvestmentProspects.Reinvestment_Prospects        AS LastYearReinvestmentProspects
		,LastYearReinvestmentProspects.BGColor                       AS LastYearReinvestmentProsBGColor
		,ThisYearPerfAgainstStrategy.Performance_Against_Strategy    AS ThisYearPerfAgainstStrategy
		,ThisYearPerfAgainstStrategy.BGColor                         AS ThisYearPerfAgainstStratBGColor
		,LastYearPerfAgainstStrategy.Performance_Against_Strategy    AS LastYearPerfAgainstStrategy
		,LastYearPerfAgainstStrategy.BGColor                         AS LastYearPerfAgainstStratBGColor
		,ThisYearRelStratImpt.Relative_Strategic_Importance          AS ThisYearRelStratImpt
		,ThisYearRelStratImpt.BGColor                                AS ThisYearRelStratImptBGColor
		,LastYearRelStratImpt.Relative_Strategic_Importance          AS LastYearRelStratImpt
		,LastYearRelStratImpt.BGColor                                AS LastYearRelStratImptBGColor
		,ISNULL(MULTI_STRAT.Multi_Strat,0)                           AS Multi_Strat
		,INV_Scoring.Rationale
		,INV_Scoring.Key_Results_Data
		,INV_Scoring.Funding_Team_Input
		,MAX(ISNULL(PTD.Amt_Paid_To_Date,0))                         AS Amt_Paid_To_Date
	FROM (SELECT
			INV_ID                                                   AS ID_Combined
			,CASE
				WHEN ISNULL(INV_Managing_Team, '') = @Division
					AND ISNULL(INV_Managing_SubTeam, '') = @Strategy
					AND 0 < (SELECT COUNT(B.INV_ID)
							FROM Investment_Payment B
							WHERE B.INV_ID = INV_PMT.INV_ID
									AND ISNULL(B.PMT_Division, '') = @Division
									AND ISNULL(B.PMT_Strategy, '') = @Strategy)
					THEN @ManagedandFundedOnlyLiteral
				WHEN ISNULL(INV_Managing_Team, '') = @Division
					AND ISNULL(INV_Managing_SubTeam, '') = @Strategy
					AND 0 = (SELECT COUNT(B.INV_ID) 
							FROM Investment_Payment B
							WHERE B.INV_ID = INV_PMT.INV_ID
									AND ISNULL(PMT_Division, '') = @Division
									AND ISNULL(PMT_Strategy, '') = @Strategy)
					THEN @ManagedOnlyLiteral
				WHEN (ISNULL(INV_Managing_Team, '') <> @Division OR ISNULL(INV_Managing_SubTeam, '') <> @Strategy)
					AND ISNULL(INV_PMT.PMT_Division, '') = @Division
					AND ISNULL(INV_PMT.PMT_Strategy, '') = @Strategy
					THEN @FundedOnlyLiteral
			END                                                      AS Category
			,INV_Managing_Team                                       AS INV_Managing_Team
			,INV_Managing_SubTeam                                    AS INV_Managing_SubTeam
			,INV_Managing_Team_Level_3
			,INV_PMT.INV_Grantee_Vendor_Name
			,INV_PMT.INV_Title
			,INV_PMT.INV_Description
			,INV_PMT.INV_Owner
			,CASE 
				WHEN ISNULL(INV_PMT.PMT_Division, '') = @Division
					AND ISNULL(INV_PMT.PMT_Strategy, '') = @Strategy
					AND ISNULL(INV_PMT.PMT_Initiative,'') = ''
						THEN @InvnotalignedLiteral
				WHEN ISNULL(INV_Managing_Team, '') = @Division
					AND ISNULL(INV_Managing_SubTeam, '') = @Strategy
					AND 0 = (SELECT COUNT(B.INV_ID) 
							FROM Investment_Payment B
							WHERE B.INV_ID = INV_PMT.INV_ID
									AND ISNULL(PMT_Division, '') = @Division
									AND ISNULL(PMT_Strategy, '') = @Strategy)
					THEN @ManagedOnlyLiteral
				ELSE INV_PMT.PMT_Initiative
			END AS PMT_Initiative		
			,CAST(INV_PMT.INV_Start_Date AS Date)                    AS INV_Start_Date
			,CAST(INV_PMT.INV_End_Date AS Date)                      AS INV_End_Date
			,MIN(ISNULL(INV_Total_Payout_Amt,0))                     AS INV_Total_Payout_Amt
			,SUM(
				CASE
					WHEN PMT_Division = @Division AND PMT_Strategy = @Strategy
						THEN PMT_Strategy_Allocation_Amt
					ELSE 0
				END
			)                                                        AS PMT_Strategy_Allocation_Amt
		FROM Investment_Payment INV_PMT WITH (NOLOCK)
		INNER JOIN Investment INV
		ON INV_PMT.INV_ID = INV.ID_Combined
		WHERE
			ISNULL(INV.Is_Deleted,0) != 1
			AND
			(
				(ISNULL(PMT_Division, '') = @Division AND ISNULL(PMT_Strategy, '') = @Strategy)
				
				OR (ISNULL(INV_Managing_Team, '') = @Division
					AND ISNULL(INV_Managing_SubTeam, '') = @Strategy
					AND 0 = (SELECT COUNT(B.INV_ID) 
							FROM Investment_Payment B
							WHERE B.INV_ID = INV_PMT.INV_ID
									AND ISNULL(PMT_Division, '') = @Division
									AND ISNULL(PMT_Strategy, '') = @Strategy))
			)
			AND INV_Total_Payout_Amt >= 5000000
			AND (
				INV_PMT.INV_Status = 'Active'
				OR (
					INV_PMT.INV_Status IN ('Closed', 'Cancelled', 'Inactive')
					--KCT: Set current year to 2017
					AND YEAR(INV_PMT.INV_END_DATE) >= '2017'))
		GROUP BY
			INV_ID
			,PMT_Division
			,PMT_Strategy
			,INV_Managing_Team
			,INV_Managing_SubTeam
			,INV_Managing_Team_Level_3
			,INV_PMT.INV_Grantee_Vendor_Name
			,INV_PMT.INV_Title
			,INV_PMT.INV_Description
			,INV_PMT.INV_Owner
			,INV_PMT.PMT_Initiative
			,CAST(INV_PMT.INV_Start_Date AS Date) 
			,CAST(INV_PMT.INV_End_Date AS Date)
			,Sys_INV_URL
	 ) AS INV_PYMT
	 
	 --Performance Against Execution (This Year)
	 LEFT JOIN (
		SELECT *
		FROM (
			SELECT
				ID_Combined
				,(
					CASE
						WHEN Performance_Against_Milestones IN (SELECT Name FROM Dimension_Values)
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Performance_Against_Milestones = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Performance_Against_Milestones,CharIndex('- ',LTRIM(Performance_Against_Milestones))+1,LEN(Performance_Against_Milestones))))
					END
				) AS Performance_Against_Milestones
				,LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Performance_Against_Milestones)),0,(CharIndex('- ',Performance_Against_Milestones))))) AS BGColor
				,ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
			FROM vInvestmentScoringReporting_preMigration vInv
			WHERE
				(Objective = '.Overall' OR COALESCE(Objective, '') = '')
				AND Score_Year = @ScoringYear
		) tmp
		WHERE ChangeIndex = 1
	 ) ThisYearPerfAgainstExecution
		ON INV_PYMT.ID_Combined = ThisYearPerfAgainstExecution.ID_Combined  

	--Performance Against Execution (Last Year)
	LEFT JOIN (
		SELECT *
		FROM (
			SELECT
				ID_Combined
				,(
					CASE
						WHEN Performance_Against_Milestones IN (SELECT Name FROM Dimension_Values)
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Performance_Against_Milestones = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Performance_Against_Milestones,CharIndex('- ',LTRIM(Performance_Against_Milestones))+1,LEN(Performance_Against_Milestones))))
					END
				) AS Performance_Against_Milestones
				,LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Performance_Against_Milestones)),0,(CharIndex('- ',Performance_Against_Milestones))))) AS BGColor
				,ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
			FROM vInvestmentScoringReporting_preMigration vInv
			WHERE
				(Objective = '.Overall' OR COALESCE(Objective, '') = '')
				AND Score_Year = (@ScoringYear-1)
		) tmp
		WHERE ChangeIndex = 1
	 ) LastYearPerfAgainstExecution
		ON INV_PYMT.ID_Combined = LastYearPerfAgainstExecution.ID_Combined
	
	--Reinvestment Prospects (This Year)
	LEFT JOIN (
		SELECT *
		FROM (
			SELECT
				ID_Combined
				,(
					CASE
						WHEN Reinvestment_Prospects IN (SELECT Name FROM Dimension_Values)
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Reinvestment_Prospects = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Reinvestment_Prospects,CharIndex('- ',LTRIM(Reinvestment_Prospects))+1,LEN(Reinvestment_Prospects))))
					END
				) AS Reinvestment_Prospects
				,LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Reinvestment_Prospects)),0,(CharIndex('- ',Reinvestment_Prospects))))) AS BGColor
				,ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
			FROM vInvestmentScoringReporting_preMigration vInv
			WHERE
				(Objective = '.Overall' OR COALESCE(Objective, '') = '')
				AND Score_Year = @ScoringYear
				AND Reinvestment_Prospects <> ''
		) tmp
		WHERE ChangeIndex = 1
	) ThisYearReinvestmentProspects
		ON INV_PYMT.ID_Combined = ThisYearReinvestmentProspects.ID_Combined

	--Reinvestment Prospects (Last Year)
	LEFT JOIN (
		SELECT *
		FROM (
			SELECT
				ID_Combined
				,(
					CASE
						WHEN Reinvestment_Prospects IN (SELECT Name FROM Dimension_Values)
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Reinvestment_Prospects = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Reinvestment_Prospects,CharIndex('- ',LTRIM(Reinvestment_Prospects))+1,LEN(Reinvestment_Prospects))))
					END
				) AS Reinvestment_Prospects
				,LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Reinvestment_Prospects)),0,(CharIndex('- ',Reinvestment_Prospects))))) AS BGColor
				,ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
			FROM vInvestmentScoringReporting_preMigration vInv
			WHERE
				(Objective = '.Overall' OR COALESCE(Objective, '') = '')
				AND Score_Year = (@ScoringYear-1)
				AND Reinvestment_Prospects <> ''
		) tmp
		WHERE ChangeIndex = 1
	) LastYearReinvestmentProspects
		ON INV_PYMT.ID_Combined = LastYearReinvestmentProspects.ID_Combined

	--Performance Against Strategy (This Year)
	LEFT JOIN (
		SELECT *
		FROM (
			SELECT
				ID_Combined
				,(
					CASE
						WHEN Performance_Against_Strategy IN (SELECT Name FROM Dimension_Values)
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Performance_Against_Strategy = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Performance_Against_Strategy,CharIndex('- ',LTRIM(Performance_Against_Strategy))+1,LEN(Performance_Against_Strategy)))) 
					END
				) AS Performance_Against_Strategy
				,LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Performance_Against_Strategy)),0,(CharIndex('- ',Performance_Against_Strategy))))) AS BGColor
				,ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
			FROM vInvestmentScoringReporting_preMigration vInv
			WHERE
				(Objective = '.Overall' OR COALESCE(Objective, '') = '')
				AND Score_Year = @ScoringYear
				AND Performance_Against_Strategy <> ''
		) tmp
		WHERE ChangeIndex = 1
	) ThisYearPerfAgainstStrategy
		ON INV_PYMT.ID_Combined = ThisYearPerfAgainstStrategy.ID_Combined

	--Performance Against Strategy (Last Year)
	LEFT JOIN (
		SELECT *
		FROM (
			SELECT
				ID_Combined
				,(
					CASE
						WHEN Performance_Against_Strategy IN (SELECT Name FROM Dimension_Values)
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Performance_Against_Strategy = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Performance_Against_Strategy,CharIndex('- ',LTRIM(Performance_Against_Strategy))+1,LEN(Performance_Against_Strategy)))) 
					END
				) AS Performance_Against_Strategy
				,LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Performance_Against_Strategy)),0,(CharIndex('- ',Performance_Against_Strategy))))) AS BGColor
				,ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
			FROM vInvestmentScoringReporting_preMigration vInv
			WHERE
				(Objective = '.Overall' OR COALESCE(Objective, '') = '')
				AND Score_Year = (@ScoringYear-1)
				AND Performance_Against_Strategy <> ''
		) tmp
		WHERE ChangeIndex = 1
	) LastYearPerfAgainstStrategy
		ON INV_PYMT.ID_Combined = LastYearPerfAgainstStrategy.ID_Combined
	
	-- Relative Strategic Importance (This Year)
	LEFT JOIN (
		SELECT *
		FROM (
			SELECT
				ID_Combined					
				,(
					CASE
						WHEN Relative_Strategic_Importance IN (SELECT Name FROM Dimension_Values) 
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Relative_Strategic_Importance = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Relative_Strategic_Importance,CharIndex('- ',LTRIM(Relative_Strategic_Importance))+1,LEN(Relative_Strategic_Importance)))) 
					END
				) AS Relative_Strategic_Importance
				,LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Relative_Strategic_Importance)),0,(CharIndex('- ',Relative_Strategic_Importance))))) AS BGColor
				,ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
			FROM vInvestmentScoringReporting_preMigration vInv
			WHERE
				(Objective = '.Overall' OR COALESCE(Objective, '') = '')
				AND Score_Year = @ScoringYear
				AND Relative_Strategic_Importance <> ''
		) tmp
		WHERE ChangeIndex = 1
	) ThisYearRelStratImpt
		ON INV_PYMT.ID_Combined = ThisYearRelStratImpt.ID_Combined

	-- Relative Strategic Importance (Last Year)
	LEFT JOIN (
		SELECT *
		FROM (
			SELECT
				ID_Combined					
				,(
					CASE
						WHEN Relative_Strategic_Importance IN (SELECT Name FROM Dimension_Values) 
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Relative_Strategic_Importance = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Relative_Strategic_Importance,CharIndex('- ',LTRIM(Relative_Strategic_Importance))+1,LEN(Relative_Strategic_Importance)))) 
					END
				) AS Relative_Strategic_Importance
				,LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Relative_Strategic_Importance)),0,(CharIndex('- ',Relative_Strategic_Importance))))) AS BGColor
				,ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
			FROM vInvestmentScoringReporting_preMigration vInv
			WHERE
				(Objective = '.Overall' OR COALESCE(Objective, '') = '')
				AND Score_Year = (@ScoringYear-1)
				AND Relative_Strategic_Importance <> ''
		) tmp
		WHERE ChangeIndex = 1
	) LastYearRelStratImpt
		ON INV_PYMT.ID_Combined = LastYearRelStratImpt.ID_Combined

	--Scoring
	LEFT JOIN (
		SELECT *
		FROM (
			SELECT DISTINCT
				ID_Combined
				,Score_Year
				,Rationale
				,Key_Results_Data
				,Funding_Team_Input
				,ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
			FROM dbo.vInvestmentScoringReporting_preMigration
			WHERE Score_Year=@ScoringYear
		) tmp
		WHERE ChangeIndex = 1
	) AS INV_Scoring
		ON INV_PYMT.ID_Combined=INV_Scoring.ID_Combined

	--Multiple Strategy
	LEFT JOIN (
		SELECT
			MULTI_STRAT_DET.ID_Combined
			,1 AS Multi_Strat 
		FROM(
			SELECT
				INV_ID AS ID_Combined
				,PMT_Division
				,PMT_Strategy
				,INV_Managing_Team
				,INV_Managing_SubTeam
				,SUM(PMT_Strategy_Allocation_Amt) AS PMT_Strategy_Allocation_Amt 
				,ROW_NUMBER() OVER (PARTITION BY INV_ID ORDER BY INV_ID ASC) ChangeIndex
			FROM [dbo].[Investment_Payment]
			WHERE [PMT_Status] = 'Paid' AND INV_ID IS NOT NULL AND PMT_Division <> 'Unknown'
			GROUP BY INV_ID 
				,PMT_Division
				,PMT_Strategy
				,INV_Managing_Team
				,INV_Managing_SubTeam
			) MULTI_STRAT_DET
		GROUP BY
			MULTI_STRAT_DET.ID_Combined
		HAVING Count(*)>1
	) AS MULTI_STRAT
		ON INV_PYMT.ID_Combined=MULTI_STRAT.ID_Combined

	--Paid to Date
	LEFT JOIN (
		SELECT
			[INV_ID] AS ID_Combined
			,SUM([PMT_Strategy_Allocation_Amt]) AS [Amt_Paid_To_Date]
			,ROW_NUMBER() OVER (PARTITION BY INV_ID ORDER BY INV_ID ASC) ChangeIndex
		FROM [dbo].[Investment_Payment] WITH (NOLOCK)
		WHERE [PMT_Status] = 'Paid' AND INV_ID IS NOT NULL
		GROUP BY [INV_ID]	
	) PTD
		ON INV_PYMT.ID_Combined = PTD.ID_Combined

	--Main Query Grouping
	GROUP BY
		INV_PYMT.ID_Combined
		,INV_PYMT.INV_Managing_Team
		,INV_PYMT.INV_Managing_SubTeam
		,INV_PYMT.INV_Managing_Team_Level_3
		,INV_PYMT.INV_Grantee_Vendor_Name
		,INV_PYMT.INV_Title
		,INV_PYMT.INV_Description
		,INV_PYMT.INV_Owner
		,INV_PYMT.PMT_Initiative
		,INV_PYMT.INV_Start_Date
		,INV_PYMT.INV_End_Date
		,ThisYearPerfAgainstExecution.Performance_Against_Milestones
		,ThisYearPerfAgainstExecution.BGColor
		,LastYearPerfAgainstExecution.Performance_Against_Milestones
		,LastYearPerfAgainstExecution.BGColor
		,ThisYearReinvestmentProspects.Reinvestment_Prospects
		,ThisYearReinvestmentProspects.BGColor
		,LastYearReinvestmentProspects.Reinvestment_Prospects
		,LastYearReinvestmentProspects.BGColor
		,ThisYearPerfAgainstStrategy.Performance_Against_Strategy
		,ThisYearPerfAgainstStrategy.BGColor
		,LastYearPerfAgainstStrategy.Performance_Against_Strategy
		,LastYearPerfAgainstStrategy.BGColor
		,ThisYearRelStratImpt.Relative_Strategic_Importance
		,ThisYearRelStratImpt.BGColor
		,LastYearRelStratImpt.Relative_Strategic_Importance
		,LastYearRelStratImpt.BGColor
		,INV_Scoring.Rationale
		,INV_Scoring.Key_Results_Data
		,INV_Scoring.Funding_Team_Input
		,ISNULL(MULTI_STRAT.Multi_Strat,0)
		,Category

	--Filter and Order Investments
	SELECT
		ROW_NUMBER() OVER (
			ORDER BY
				CASE
					WHEN @Order_Group_1 LIKE (@ManagedOnlyLiteral + '%')                       THEN
						CASE
							WHEN PMT_Initiative = @ManagedOnlyLiteral                          THEN 1
							WHEN PMT_Initiative <> @InvnotalignedLiteral                       THEN 2
							ELSE 3
						END
					WHEN @Order_Group_1 LIKE ('%' + @ManagedOnlyLiteral)                       THEN
						CASE
							WHEN PMT_Initiative = @ManagedOnlyLiteral                          THEN 3
							WHEN PMT_Initiative <> @InvnotalignedLiteral                       THEN 1
							ELSE 2
						END
					ELSE
						CASE
							WHEN PMT_Initiative <> @InvnotalignedLiteral                       THEN 1
							ELSE 2
						END
				END
				,PMT_Initiative
				,CASE
					WHEN @Order_Group_1 = @ManagedOnlyLiteral                                  THEN 1
					WHEN @Order_Group_1 = @FundedOnlyLiteral                                   THEN
						CASE
							WHEN
								Category = @FundedOnlyLiteral
								AND PMT_Initiative <> @InvnotalignedLiteral                    THEN 1
							WHEN
								PMT_Initiative = @InvnotalignedLiteral
								AND Category = @FundedOnlyLiteral                              THEN 2
						END
					WHEN @Order_Group_1 = @ManagedandFundedOnlyLiteral                         THEN
						CASE
							WHEN
								Category = @ManagedandFundedOnlyLiteral
								AND PMT_Initiative <> @InvnotalignedLiteral                    THEN 1
							WHEN
								PMT_Initiative = @InvnotalignedLiteral
								AND Category = @ManagedandFundedOnlyLiteral                    THEN 2
						END
					WHEN @Order_Group_1 = 'Managed Only And Funded Only'                       THEN
						CASE
							WHEN
								Category = @ManagedOnlyLiteral                                 THEN 1
							WHEN
								Category = @FundedOnlyLiteral
								AND PMT_Initiative <> @InvnotalignedLiteral                    THEN 2
							WHEN
								PMT_Initiative = @InvnotalignedLiteral
								AND Category = @FundedOnlyLiteral                              THEN 3
						END
					WHEN @Order_Group_1 = 'Funded Only And Managed Only'                       THEN
						CASE
							WHEN
								Category = @FundedOnlyLiteral
								AND PMT_Initiative <> @InvnotalignedLiteral                    THEN 1
							WHEN
								PMT_Initiative = @InvnotalignedLiteral
								AND Category = @FundedOnlyLiteral                              THEN 2
							WHEN
								Category = @ManagedOnlyLiteral                                 THEN 3
						END
					WHEN @Order_Group_1 = 'Managed Only, Managed and Funded Only'              THEN
						CASE
							WHEN
								Category = @ManagedOnlyLiteral                                 THEN 1
							WHEN
								Category = @ManagedandFundedOnlyLiteral
								AND PMT_Initiative <> @InvnotalignedLiteral                    THEN 2
							WHEN
								PMT_Initiative = @InvnotalignedLiteral
								AND Category = @ManagedandFundedOnlyLiteral                    THEN 3
						END
					WHEN @Order_Group_1 = 'Managed and Funded Only, Managed Only'              THEN
						CASE
							WHEN
								Category = @ManagedandFundedOnlyLiteral
								AND PMT_Initiative <> @InvnotalignedLiteral                    THEN 1
							WHEN
								PMT_Initiative = @InvnotalignedLiteral
								AND Category = @ManagedandFundedOnlyLiteral                    THEN 2
							WHEN
								Category = @ManagedOnlyLiteral                                 THEN 3
						END
					WHEN @Order_Group_1 = 'Funded Only, Managed and Funded Only'               THEN
						CASE
							WHEN
								Category = @FundedOnlyLiteral
								AND PMT_Initiative <> @InvnotalignedLiteral                    THEN 1
							WHEN
								Category = @ManagedandFundedOnlyLiteral
								AND PMT_Initiative <> @InvnotalignedLiteral                    THEN 2
							WHEN
								PMT_Initiative = @InvnotalignedLiteral
								AND Category = @FundedOnlyLiteral                              THEN 3
							WHEN
								PMT_Initiative = @InvnotalignedLiteral
								AND Category = @ManagedandFundedOnlyLiteral                    THEN 4
						END
					WHEN @Order_Group_1 = 'Managed and Funded Only, Funded Only'               THEN
						CASE
							WHEN
								Category = @ManagedandFundedOnlyLiteral
								AND PMT_Initiative <> @InvnotalignedLiteral                    THEN 1
							WHEN
								Category = @FundedOnlyLiteral
								AND PMT_Initiative <> @InvnotalignedLiteral                    THEN 2
							WHEN
								PMT_Initiative = @InvnotalignedLiteral
								AND Category = @ManagedandFundedOnlyLiteral                    THEN 3
							WHEN
								PMT_Initiative = @InvnotalignedLiteral
								AND Category = @FundedOnlyLiteral                              THEN 4
						END
					WHEN @Order_Group_1 = 'Managed Only, Funded Only, Managed and Funded Only' THEN
						CASE
							WHEN
								Category = @ManagedOnlyLiteral                                 THEN 1
							WHEN
								Category = @FundedOnlyLiteral
								AND PMT_Initiative <> @InvnotalignedLiteral                    THEN 2
							WHEN
								Category = @ManagedandFundedOnlyLiteral
								AND PMT_Initiative <> @InvnotalignedLiteral                    THEN 3
							WHEN
								PMT_Initiative = @InvnotalignedLiteral
								AND Category = @FundedOnlyLiteral                              THEN 4
							WHEN
								PMT_Initiative = @InvnotalignedLiteral
								AND Category = @ManagedandFundedOnlyLiteral                    THEN 5
						END
					WHEN @Order_Group_1 = 'Funded Only, Managed and Funded Only, Managed Only' THEN
						CASE
							WHEN
								Category = @FundedOnlyLiteral
								AND PMT_Initiative <> @InvnotalignedLiteral                    THEN 1
							WHEN
								Category = @ManagedandFundedOnlyLiteral
								AND PMT_Initiative <> @InvnotalignedLiteral                    THEN 2
							WHEN
								PMT_Initiative = @InvnotalignedLiteral
								AND Category = @FundedOnlyLiteral                              THEN 3
							WHEN
								PMT_Initiative = @InvnotalignedLiteral
								AND Category = @ManagedandFundedOnlyLiteral                    THEN 4
							WHEN
								Category = @ManagedOnlyLiteral                                 THEN 5
						END
					WHEN @Order_Group_1 = 'Managed Only, Managed and Funded Only, Funded Only' THEN
						CASE
							WHEN
								Category = @ManagedOnlyLiteral                                 THEN 1
							WHEN
								Category = @ManagedandFundedOnlyLiteral
								AND PMT_Initiative <> @InvnotalignedLiteral                    THEN 2
							WHEN
								Category = @FundedOnlyLiteral
								AND PMT_Initiative <> @InvnotalignedLiteral                    THEN 3
							WHEN
								PMT_Initiative = @InvnotalignedLiteral
								AND Category = @ManagedandFundedOnlyLiteral                    THEN 4
							WHEN
								PMT_Initiative = @InvnotalignedLiteral
								AND Category = @FundedOnlyLiteral                              THEN 5
						END
					WHEN @Order_Group_1 = 'Managed and Funded Only, Funded Only, Managed Only' THEN
						CASE
							WHEN
								Category = @ManagedandFundedOnlyLiteral
								AND PMT_Initiative <> @InvnotalignedLiteral                    THEN 1
							WHEN
								Category = @FundedOnlyLiteral
								AND PMT_Initiative <> @InvnotalignedLiteral                    THEN 2
							WHEN
								PMT_Initiative = @InvnotalignedLiteral
								AND Category = @ManagedandFundedOnlyLiteral                    THEN 3
							WHEN
								PMT_Initiative = @InvnotalignedLiteral
								AND Category = @FundedOnlyLiteral                              THEN 4
							WHEN
								Category = @ManagedOnlyLiteral                                 THEN 5
						END
				END
				,Total_Investment_Amount DESC
				,Total_Strategy_Amount DESC
				,INV_Managing_Team
				,INV_Managing_SubTeam
		) AS RowNumber
		,*
	FROM @tmpInvestmentDetails
	WHERE
		(@FilterBy = 'Managed Only'
			AND Category = 'Managed Only')

		OR (@FilterBy = 'Funded Only'
			AND Category = 'Funded Only')

		OR (@FilterBy = 'Managed and Funded Only'
			AND Category = 'Managed and Funded Only')

		OR (@FilterBy = 'Managed Only,Funded Only'
			AND Category IN ('Managed Only', 'Funded Only'))

		OR (@FilterBy = 'Managed Only,Managed and Funded Only'
			AND Category IN ('Managed Only', 'Managed and Funded Only'))

		OR (@FilterBy = 'Funded Only,Managed and Funded Only'
			AND Category IN ('Funded Only', 'Managed and Funded Only'))

		OR (@FilterBy = 'Managed Only,Funded Only,Managed and Funded Only'
			AND Category IN ('Managed Only', 'Funded Only', 'Managed and Funded Only'))
END

