CREATE PROCEDURE [dbo].[sp_GetInvestmentDetails_SumRep]
	@InvTotalPayoutAmt      INT,
	@Division       NVARCHAR(MAX),
	@Strategy       NVARCHAR(MAX),
	@FilterBy       NVARCHAR(100),
	@Order_Group_1  NVARCHAR(100)
AS

BEGIN

	/*******************************************************************************
	Author:		Jake Harry Chavez
	Created Date:	05/30/2018
	Description:	Get the list of Investment Details
	Usage:
		EXEC [sp_GetInvestmentDetails_SumRep]
			@InvTotalPayoutAmt = '1',
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
	Jake Harry Chavez		05/30/2018	US 156048:	Added row number to group and to have distinct records
													Script taken from sp_GetInvestmentDetail. Added some updates
	Jake Harry Chavez		06/27/2018	US 157789	Added temp table to cater pmt_division and pmt_strategy
	Jake Harry Chavez		06/29/2018	US 157887	Added excluded function
	Jake Harry Chavez		07/03/2018	US 157887	Added ID_Combined for sorting parameters
	Sarah Bataller			07/18/2018  US 157915	Updated Division, Strategy to Multi-select and Added Initiative Report filter	
	Richard Joseph Santos   07/18/2018  US 157914   Added filtering by Investment Total Payout Amount
	Sarah Bataller			07/19/2018  US 157915	Updated variable value to MAX and updated filtering condition
	Sarah Bataller			07/24/2018  US 157915	Display No Initiative for blank initiatives
	John Vince Gomez		07/24/2018	US 157919	Add last two years column and modified Scoring Year Declaration
	Sarah Bataller			07/26/2018  US 157915	Bug 161103: Managed Only should have 0 Allocation Amount
	Jake Harry Chavez		08/01/2018	US 157915	Bug 161695: Updated Additional records for Managed only and funded only
	Jake Harry Chavez		08/02/2018	US 157915	Bug 161695: Fixed apostrophe issue
	Jake Harry Chavez		08/07/2018	US 157915	Bug 161665: Optimized query	
	Jake Harry Chavez		08/08/2018	US 160981	Updates on sorting and grouping
	Jonson Villanueva		08/07/2018	US 159071	Cascade Exclude Functionality from Tool to Investment Score Summary Report
	Jake Harry Chavez		08/13/2018	Us 160981	Updated initiative
	Jake Harry Chavez		08/30/2018	US 163760	Added Managed by (ManagedBy) and Funded by (FundedBy) fields
	Jake Harry Chavez		09/11/2018	US 163760	Updated Funded by field
	Jake Harry Chavez		09/19/2018	US 163760	Updates on managed by and funded by rows
	Jake Harry Chavez		09/20/2018	US 163760	Removed Managing Team from the Managing field in details tab\
	Jake Harry Chavez		09/26/2018	US 168057	Updated details slide
	Jake Harry Chavez		11/22/2018	US 170585	Updated Page Number Logic
	Jake Harry Chavez		12/13/2018	US 172689	Removed Initiative as a required field
	Jake Harry Chavez		12/14/2018	US 172689	Removed Initiative as a parameter
	John Louie Chan			12/17/2018  BUG 172985	Adding SUb initiative in scope for page numbering
	Sarah Bataller			12/20/2018	BUG 173145	Removed investment with categories other than 'Managed and Funded Only'
	Sarah Bataller			12/27/2018	BUG 173667	Added PMT_Initiative and Sub_Initiative in the Ordering of Investments
	Jake Harry Chavez		04/30/2020	US 224411	Added FundingTeamCount
	Jeronell Aguila			05/12/2020	US 225841	Include BoW in grouping logic in Investment Scoring Summary report
	Jonson Villanueva		05/14/2021  BUG 36640:	Resolve Stored Procedures in IST database related to exclude flag change
	*******************************************************************************/

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF OBJECT_ID('tempdb..#InvTemp') IS NOT NULL
	DROP TABLE #InvTemp

DECLARE @tmpInvestmentDetails        AS TABLE (
		ID_Combined                      NVARCHAR (255)
		,PMT_Initiative					 NVARCHAR (100)
		,PMT_SubInitiative				NVARCHAR (100)
		,Category                        NVARCHAR (23)
		,Total_Investment_Amount         MONEY
		,Total_Strategy_Amount           MONEY
		,INV_Managing_Team               NVARCHAR (50)
		,INV_Managing_SubTeam            NVARCHAR (255)
		,INV_Managing_Team_Level_3       NVARCHAR (255)
		,INV_Managing_Team_Level_4       NVARCHAR (255)
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
		,LastTwoYearsPerfAgainstExecution    NVARCHAR (220)
		,LastTwoYearsPerfAgainstExecBGColor  NVARCHAR (25)
		,ThisYearReinvestmentProspects   NVARCHAR (220)
		,ThisYearReinvestmentProsBGColor NVARCHAR (25)
		,LastYearReinvestmentProspects   NVARCHAR (220)
		,LastYearReinvestmentProsBGColor NVARCHAR (25)
		,LastTwoYearsReinvestmentProspects   NVARCHAR (220)
		,LastTwoYearsReinvestmentProsBGColor NVARCHAR (25)
		,ThisYearPerfAgainstStrategy     NVARCHAR (220)
		,ThisYearPerfAgainstStratBGColor NVARCHAR (25)
		,LastYearPerfAgainstStrategy     NVARCHAR (220)
		,LastYearPerfAgainstStratBGColor NVARCHAR (25)
		,LastTwoYearsPerfAgainstStrategy     NVARCHAR (220)
		,LastTwoYearsPerfAgainstStratBGColor NVARCHAR (25)
		,ThisYearRelStratImpt            NVARCHAR (220)
		,ThisYearRelStratImptBGColor     NVARCHAR (25)
		,LastYearRelStratImpt            NVARCHAR (220)
		,LastYearRelStratImptBGColor     NVARCHAR (25)
		,LastTwoYearsRelStratImpt            NVARCHAR (220)
		,LastTwoYearsRelStratImptBGColor     NVARCHAR (25)
		,Multi_Strat                     BIT
		,Rationale                       NVARCHAR (MAX)
		,Key_Results_Data                NVARCHAR (MAX)
		,Funding_Team_Input              NVARCHAR (MAX)
		,Amt_Paid_To_Date                MONEY
		,PMT_Division					 NVARCHAR (100)
		,PMT_Strategy					 NVARCHAR (100)
		,FundedBy						 NVARCHAR (MAX)
		,ManagedBy						 NVARCHAR (MAX)
		,FundingTeamCount				 INT
		,PMT_Key_Element				 NVARCHAR (100)
	)
	-- KCT: Switch to 2017 
	DECLARE @ScoringYear AS INT = CASE WHEN MONTH(GETDATE())>=6 THEN YEAR(GETDATE()) ELSE YEAR(GETDATE())-1  END

	DECLARE @ManagedOnlyLiteral    AS        NVARCHAR (MAX) = 'Managed Only'
	DECLARE @FundedOnlyLiteral  AS           NVARCHAR (MAX) = 'Funded Only'
	DECLARE @ManagedandFundedOnlyLiteral  AS NVARCHAR (MAX) = 'Managed and Funded Only'
	DECLARE @InvnotalignedLiteral   As       NVARCHAR (MAX) = 'No Initiative'
    
	-- Get Strategy and insert to table
	DECLARE @StrategyTable TABLE
	(
		StrategyItem NVARCHAR(MAX)
	)
	INSERT INTO @StrategyTable
	SELECT * FROM ufn_Split(REPLACE(@Strategy,', ',''), ',')

	-- Get Division and insert to table
	DECLARE @DivisionTable TABLE
	(
		DivisionItem NVARCHAR(MAX)
	)
	INSERT INTO @DivisionTable
	SELECT * FROM ufn_Split(REPLACE(@Division,', ',''), ',')

	-- Get Initiative and insert to table
	DECLARE @Initiative		NVARCHAR(MAX)=''
		--Removed Initiative as parameter. Now set to blank
	DECLARE @InitiativeTable TABLE
	(
		InitiativeItem NVARCHAR(MAX)
	)
	INSERT INTO @InitiativeTable
	SELECT * FROM ufn_Split(REPLACE(@Initiative,', ',''), ',')

	UPDATE @InitiativeTable
	SET InitiativeItem = ''
	WHERE InitiativeItem = 'No Initiative'

	UPDATE @InitiativeTable
	SET InitiativeItem=REPLACE(InitiativeItem,'''','')

	UPDATE @DivisionTable
	SET DivisionItem=REPLACE(DivisionItem,'''','')

	UPDATE @StrategyTable
	SET StrategyItem=REPLACE(StrategyItem,'''','')
	

	INSERT INTO @tmpInvestmentDetails
	SELECT
		INV_PYMT.ID_Combined
		,INV_PYMT.PMT_Initiative
		,INV_PYMT.PMT_SubInitiative
		,INV_PYMT.Category
		,MAX(ISNULL(INV_PYMT.INV_Total_Payout_Amt,0))                AS Total_Investment_Amount
		,SUM(INV_PYMT.PMT_Strategy_Allocation_Amt)                   AS Total_Strategy_Amount
		,INV_PYMT.INV_Managing_Team
		,INV_PYMT.INV_Managing_SubTeam
		,INV_PYMT.INV_Managing_Team_Level_3
		,INV_PYMT.INV_Managing_Team_Level_4
		,INV_PYMT.INV_Grantee_Vendor_Name
		,INV_PYMT.INV_Title
		,INV_PYMT.INV_Description
		,INV_PYMT.INV_Owner
		,INV_PYMT.INV_Start_Date
		,INV_PYMT.INV_End_Date
		,ThisYearPerfAgainstExecution.Performance_Against_Milestones		AS ThisYearPerfAgainstExecution
		,ThisYearPerfAgainstExecution.BGColor								AS ThisYearPerfAgainstExecBGColor
		,LastYearPerfAgainstExecution.Performance_Against_Milestones		AS LastYearPerfAgainstExecution
		,LastYearPerfAgainstExecution.BGColor								AS LastYearPerfAgainstExecBGColor
		,LastTwoYearsPerfAgainstExecution.Performance_Against_Milestones	AS LastTwoYearsPerfAgainstExecution
		,LastTwoYearsPerfAgainstExecution.BGColor							AS LastTwoYearsPerfAgainstExecBGColor		
		,ThisYearReinvestmentProspects.Reinvestment_Prospects				AS ThisYearReinvestmentProspects
		,ThisYearReinvestmentProspects.BGColor								AS ThisYearReinvestmentProsBGColor
		,LastYearReinvestmentProspects.Reinvestment_Prospects				AS LastYearReinvestmentProspects
		,LastYearReinvestmentProspects.BGColor								AS LastYearReinvestmentProsBGColor
		,LastTwoYearsReinvestmentProspects.Reinvestment_Prospects		    AS LastTwoYearsReinvestmentProspects
		,LastTwoYearsReinvestmentProspects.BGColor					        AS LastTwoYearsReinvestmentProsBGColor
		,ThisYearPerfAgainstStrategy.Performance_Against_Strategy			AS ThisYearPerfAgainstStrategy
		,ThisYearPerfAgainstStrategy.BGColor								AS ThisYearPerfAgainstStratBGColor
		,LastYearPerfAgainstStrategy.Performance_Against_Strategy			AS LastYearPerfAgainstStrategy
		,LastYearPerfAgainstStrategy.BGColor								AS LastYearPerfAgainstStratBGColor
		,LastTwoYearsPerfAgainstStrategy.Performance_Against_Strategy		AS LastTwoYearsPerfAgainstStrategy
		,LastTwoYearsPerfAgainstStrategy.BGColor						    AS LastTwoYearsPerfAgainstStratBGColor
		,ThisYearRelStratImpt.Relative_Strategic_Importance					AS ThisYearRelStratImpt
		,ThisYearRelStratImpt.BGColor										AS ThisYearRelStratImptBGColor
		,LastYearRelStratImpt.Relative_Strategic_Importance				    AS LastYearRelStratImpt
		,LastYearRelStratImpt.BGColor									    AS LastYearRelStratImptBGColor
		,LastTwoYearsRelStratImpt.Relative_Strategic_Importance				AS LastTwoYearsRelStratImpt
		,LastTwoYearsRelStratImpt.BGColor									AS LastTwoYearsRelStratImptBGColor
		,ISNULL(MULTI_STRAT.Multi_Strat,0)									AS Multi_Strat
		,INV_Scoring.Rationale
		,INV_Scoring.Key_Results_Data
		,INV_Scoring.Funding_Team_Input
		,MAX(ISNULL(PTD.Amt_Paid_To_Date,0))								AS Amt_Paid_To_Date
		,PMT_Division
		,PMT_Strategy
		,FundedBy
		,ManagedBy
		,NULL																AS FundingTeamCount	
		,INV_PYMT.PMT_Key_Element											AS PMT_Key_Element
	FROM (SELECT
			INV_ID                                                   AS ID_Combined
			,CASE
				WHEN INV_DT.DivisionItem IS NOT NULL 
					AND INV_ST.StrategyItem IS NOT NULL
					AND 0 < (SELECT COUNT(B.INV_ID)
							FROM Investment_Payment B
							WHERE B.INV_ID = INV_PMT.INV_ID
									AND ISNULL(REPLACE(REPLACE(B.PMT_Division,', ',''),'''',''), '') = PMT_DT.DivisionItem
									AND ISNULL(REPLACE(REPLACE(B.PMT_Strategy,', ',''),'''',''), '') = PMT_ST.StrategyItem)
					THEN @ManagedandFundedOnlyLiteral
				WHEN INV_DT.DivisionItem IS NOT NULL
					AND INV_ST.StrategyItem IS NOT NULL
					AND 0 = (SELECT COUNT(B.INV_ID) 
							FROM Investment_Payment B
							WHERE B.INV_ID = INV_PMT.INV_ID
									AND ISNULL(REPLACE(REPLACE(PMT_Division,', ',''),'''',''), '') = PMT_DT.DivisionItem
									AND ISNULL(REPLACE(REPLACE(PMT_Strategy,', ',''),'''',''), '') = PMT_ST.StrategyItem)
					THEN @ManagedOnlyLiteral
				WHEN (INV_DT.DivisionItem IS NULL OR INV_ST.StrategyItem IS NULL)
					AND PMT_DT.DivisionItem IS NOT NULL
					AND PMT_ST.StrategyItem IS NOT NULL
					THEN @FundedOnlyLiteral
			END                                                      AS Category
			,INV_Managing_Team                                       AS INV_Managing_Team
			,INV_Managing_SubTeam                                    AS INV_Managing_SubTeam
			,INV_Managing_Team_Level_3
			,INV_Managing_Team_Level_4
			,INV_PMT.INV_Grantee_Vendor_Name
			,INV_PMT.INV_Title
			,INV_PMT.INV_Description
			,INV_PMT.INV_Owner
			,CASE 
				WHEN (PMT_DT.DivisionItem IS NOT NULL OR INV_DT.DivisionItem IS NOT NULL)
					AND (PMT_ST.StrategyItem IS NOT NULL OR INV_ST.StrategyItem IS NOT NULL)
					AND ISNULL(REPLACE(REPLACE(INV_PMT.PMT_Initiative,', ',''),'''',''),'') = '' 
						THEN @InvnotalignedLiteral
				ELSE INV_PMT.PMT_Initiative
			END AS PMT_Initiative
			,PMT_SubInitiative		
			,CAST(INV_PMT.INV_Start_Date AS Date)                    AS INV_Start_Date
			,CAST(INV_PMT.INV_End_Date AS Date)                      AS INV_End_Date
			,MIN(ISNULL(INV_Total_Payout_Amt,0))                     AS INV_Total_Payout_Amt
			,SUM(
				CASE
					WHEN PMT_DT.DivisionItem IS NOT NULL AND PMT_ST.StrategyItem IS NOT NULL
						THEN PMT_Strategy_Allocation_Amt
					ELSE 0
				END
			)                                                        AS PMT_Strategy_Allocation_Amt
			,PMT_Division
			,PMT_Strategy
			,'' FundedBy
			,'' ManagedBy
			,NULL													 AS FundingTeamCount
			,INV_PMT.PMT_Key_Element								 AS PMT_Key_Element
		FROM Investment_Payment INV_PMT WITH (NOLOCK)	
		INNER JOIN Investment INV
			ON INV_PMT.INV_ID = INV.ID_Combined
		LEFT JOIN @DivisionTable PMT_DT
			ON REPLACE(REPLACE(PMT_Division,', ',''),'''','') = PMT_DT.DivisionItem
		LEFT JOIN @DivisionTable INV_DT
			ON REPLACE(REPLACE(INV_Managing_Team,', ',''),'''','') = INV_DT.DivisionItem
		LEFT JOIN @StrategyTable PMT_ST
			ON REPLACE(REPLACE(PMT_Strategy,', ',''),'''','') = PMT_ST.StrategyItem
		LEFT JOIN @StrategyTable INV_ST
			ON REPLACE(REPLACE(INV_Managing_SubTeam,', ',''),'''','') = INV_ST.StrategyItem
		
		WHERE
			ISNULL(INV.Is_Deleted,0) != 1
			AND 
			(
				(ISNULL(REPLACE(REPLACE(PMT_Division,', ',''),'''',''), '') = PMT_DT.DivisionItem AND ISNULL(REPLACE(REPLACE(PMT_Strategy,', ',''),'''',''), '') = PMT_ST.StrategyItem)
				
				OR (ISNULL(REPLACE(REPLACE(INV_Managing_Team,', ',''),'''',''), '') = INV_DT.DivisionItem
					AND ISNULL(REPLACE(REPLACE(INV_Managing_SubTeam,', ',''),'''',''), '') = INV_ST.StrategyItem
					AND 0 = (SELECT COUNT(B.INV_ID) 
							FROM Investment_Payment B
							WHERE B.INV_ID = INV_PMT.INV_ID
									AND ISNULL(REPLACE(REPLACE(PMT_Division,', ',''),'''',''), '') = PMT_DT.DivisionItem
									AND ISNULL(REPLACE(REPLACE(PMT_Strategy,', ',''),'''',''), '') = PMT_ST.StrategyItem))
			)
			AND 
			(
				(@InvTotalPayoutAmt = '1' AND INV_Total_Payout_Amt >= 5000000)
				OR @InvTotalPayoutAmt = '2'
			)
			AND (
				INV_PMT.INV_Status = 'Active'
				OR (
					INV_PMT.INV_Status IN ('Closed', 'Cancelled', 'Inactive')
					-- KCT: Switch to 2017 FROM >= YEAR(CURRENT_TIMESTAMP)
					AND YEAR(INV_PMT.INV_END_DATE) >= CASE WHEN MONTH(GETDATE())>=6 THEN YEAR(GETDATE()) ELSE YEAR(GETDATE())-1  END))

			AND
			(
				(PMT_DT.DivisionItem IS NOT NULL AND PMT_ST.StrategyItem IS NOT NULL)
				OR (INV_DT.DivisionItem IS NOT NULL AND INV_ST.StrategyItem IS NOT NULL)
			)
		GROUP BY
			INV_ID
			,PMT_Division
			,PMT_DT.DivisionItem
			,INV_DT.DivisionItem
			,PMT_Strategy
			,PMT_ST.StrategyItem
			,INV_ST.StrategyItem
			,INV_Managing_Team
			,INV_Managing_SubTeam
			,INV_Managing_Team_Level_3
			,INV_Managing_Team_Level_4
			,INV_PMT.INV_Grantee_Vendor_Name
			,INV_PMT.INV_Title
			,INV_PMT.INV_Description
			,INV_PMT.INV_Owner
			,INV_PMT.PMT_Initiative
			,INV_PMT.PMT_SubInitiative
			,CAST(INV_PMT.INV_Start_Date AS Date) 
			,CAST(INV_PMT.INV_End_Date AS Date)
			,Sys_INV_URL
			,INV_PMT.PMT_Key_Element
	 ) AS INV_PYMT
	 
	 --Performance Against Execution (This Year)
	 LEFT JOIN (
		SELECT *
		FROM (
			SELECT
				ID_Combined
				,(
					CASE
						WHEN Is_Excluded = 1 
							THEN ('Excluded')
						WHEN Performance_Against_Milestones IN (SELECT Name FROM Dimension_Values)
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Performance_Against_Milestones = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Performance_Against_Milestones,CharIndex('- ',LTRIM(Performance_Against_Milestones))+1,LEN(Performance_Against_Milestones))))
					END
				) AS Performance_Against_Milestones
				,(
					CASE
						WHEN Is_Excluded = 1 
							THEN ''
						ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Performance_Against_Milestones)),0,(CharIndex('- ',Performance_Against_Milestones))))) 
					END) AS BGColor
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
						WHEN Is_Excluded = 1 
							THEN ('Excluded')
						WHEN Performance_Against_Milestones IN (SELECT Name FROM Dimension_Values)
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Performance_Against_Milestones = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Performance_Against_Milestones,CharIndex('- ',LTRIM(Performance_Against_Milestones))+1,LEN(Performance_Against_Milestones))))
					END
				) AS Performance_Against_Milestones
				,(
					CASE
						WHEN Is_Excluded = 1 
							THEN ''
						ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Performance_Against_Milestones)),0,(CharIndex('- ',Performance_Against_Milestones))))) 
					END) AS BGColor
				,ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
			FROM vInvestmentScoringReporting_preMigration vInv
			WHERE
				(Objective = '.Overall' OR COALESCE(Objective, '') = '')
				AND Score_Year = (@ScoringYear-1)
		) tmp
		WHERE ChangeIndex = 1
	 ) LastYearPerfAgainstExecution
		ON INV_PYMT.ID_Combined = LastYearPerfAgainstExecution.ID_Combined

	--Performance Against Execution (Last Two Years)
	LEFT JOIN (
		SELECT *
		FROM (
			SELECT
				ID_Combined
				,(
					CASE
						WHEN Is_Excluded = 1 
							THEN ('Excluded')
						WHEN Performance_Against_Milestones IN (SELECT Name FROM Dimension_Values)
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Performance_Against_Milestones = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Performance_Against_Milestones,CharIndex('- ',LTRIM(Performance_Against_Milestones))+1,LEN(Performance_Against_Milestones))))
					END
				) AS Performance_Against_Milestones
				,(
					CASE
						WHEN Is_Excluded = 1 
							THEN ''
						ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Performance_Against_Milestones)),0,(CharIndex('- ',Performance_Against_Milestones))))) 
					END) AS BGColor
				,ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
			FROM vInvestmentScoringReporting_preMigration vInv
			WHERE
				(Objective = '.Overall' OR COALESCE(Objective, '') = '')
				AND Score_Year = (@ScoringYear-2)
		) tmp
		WHERE ChangeIndex = 1
	 )LastTwoYearsPerfAgainstExecution
		ON INV_PYMT.ID_Combined = LastTwoYearsPerfAgainstExecution.ID_Combined
	
	--Reinvestment Prospects (This Year)
	LEFT JOIN (
		SELECT *
		FROM (
			SELECT
				ID_Combined
				,(
					CASE
						WHEN Is_Excluded = 1 
							THEN ('Excluded')
						WHEN Reinvestment_Prospects IN (SELECT Name FROM Dimension_Values)
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Reinvestment_Prospects = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Reinvestment_Prospects,CharIndex('- ',LTRIM(Reinvestment_Prospects))+1,LEN(Reinvestment_Prospects))))
					END
				) AS Reinvestment_Prospects
				,(
					CASE
						WHEN Is_Excluded = 1 
							THEN ''
						ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Reinvestment_Prospects)),0,(CharIndex('- ',Reinvestment_Prospects))))) 
					END) AS BGColor
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
						WHEN Is_Excluded = 1 
							THEN ('Excluded')
						WHEN Reinvestment_Prospects IN (SELECT Name FROM Dimension_Values)
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Reinvestment_Prospects = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Reinvestment_Prospects,CharIndex('- ',LTRIM(Reinvestment_Prospects))+1,LEN(Reinvestment_Prospects))))
					END
				) AS Reinvestment_Prospects
				,(
					CASE
						WHEN Is_Excluded = 1 
							THEN ''
						ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Reinvestment_Prospects)),0,(CharIndex('- ',Reinvestment_Prospects))))) 
					END) AS BGColor
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

--Reinvestment Prospects (Last Two Years)
	LEFT JOIN (
		SELECT *
		FROM (
			SELECT
				ID_Combined
				,(
					CASE
						WHEN Is_Excluded = 1 
							THEN ('Excluded')
						WHEN Reinvestment_Prospects IN (SELECT Name FROM Dimension_Values)
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Reinvestment_Prospects = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Reinvestment_Prospects,CharIndex('- ',LTRIM(Reinvestment_Prospects))+1,LEN(Reinvestment_Prospects))))
					END
				) AS Reinvestment_Prospects
				,(
					CASE
						WHEN Is_Excluded = 1 
							THEN ''
						ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Reinvestment_Prospects)),0,(CharIndex('- ',Reinvestment_Prospects))))) 
					END) AS BGColor
				,ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
			FROM vInvestmentScoringReporting_preMigration vInv
			WHERE
				(Objective = '.Overall' OR COALESCE(Objective, '') = '')
				AND Score_Year = (@ScoringYear-2)
				AND Reinvestment_Prospects <> ''
		) tmp
		WHERE ChangeIndex = 1
	) LastTwoYearsReinvestmentProspects
		ON INV_PYMT.ID_Combined = LastTwoYearsReinvestmentProspects.ID_Combined

	--Performance Against Strategy (This Year)
	LEFT JOIN (
		SELECT *
		FROM (
			SELECT
				ID_Combined
				,(
					CASE
						WHEN Is_Excluded = 1 
							THEN ('Excluded')
						WHEN Performance_Against_Strategy IN (SELECT Name FROM Dimension_Values)
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Performance_Against_Strategy = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Performance_Against_Strategy,CharIndex('- ',LTRIM(Performance_Against_Strategy))+1,LEN(Performance_Against_Strategy)))) 
					END
				) AS Performance_Against_Strategy
				,(
					CASE
						WHEN Is_Excluded = 1 
							THEN ''
						ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Performance_Against_Strategy)),0,(CharIndex('- ',Performance_Against_Strategy))))) 
					END) AS BGColor
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
						WHEN Is_Excluded = 1 
							THEN ('Excluded')
						WHEN Performance_Against_Strategy IN (SELECT Name FROM Dimension_Values)
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Performance_Against_Strategy = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Performance_Against_Strategy,CharIndex('- ',LTRIM(Performance_Against_Strategy))+1,LEN(Performance_Against_Strategy)))) 
					END
				) AS Performance_Against_Strategy
				,(
					CASE
						WHEN Is_Excluded = 1 
							THEN ''
						ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Performance_Against_Strategy)),0,(CharIndex('- ',Performance_Against_Strategy))))) 
					END) AS BGColor
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

	--Performance Against Strategy (Last Two Years)
	LEFT JOIN (
		SELECT *
		FROM (
			SELECT
				ID_Combined
				,(
					CASE
						WHEN Is_Excluded = 1 
							THEN ('Excluded')
						WHEN Performance_Against_Strategy IN (SELECT Name FROM Dimension_Values)
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Performance_Against_Strategy = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Performance_Against_Strategy,CharIndex('- ',LTRIM(Performance_Against_Strategy))+1,LEN(Performance_Against_Strategy)))) 
					END
				) AS Performance_Against_Strategy
				,(
					CASE
						WHEN Is_Excluded = 1 
							THEN ''
						ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Performance_Against_Strategy)),0,(CharIndex('- ',Performance_Against_Strategy))))) 
					END) AS BGColor
				,ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
			FROM vInvestmentScoringReporting_preMigration vInv
			WHERE
				(Objective = '.Overall' OR COALESCE(Objective, '') = '')
				AND Score_Year = (@ScoringYear-2)
				AND Performance_Against_Strategy <> ''
		) tmp
		WHERE ChangeIndex = 1
	) LastTwoYearsPerfAgainstStrategy
		ON INV_PYMT.ID_Combined = LastTwoYearsPerfAgainstStrategy.ID_Combined
	
	-- Relative Strategic Importance (This Year)
	LEFT JOIN (
		SELECT *
		FROM (
			SELECT
				ID_Combined					
				,(
					CASE
						WHEN Is_Excluded = 1 
							THEN ('Excluded')
						WHEN Relative_Strategic_Importance IN (SELECT Name FROM Dimension_Values) 
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Relative_Strategic_Importance = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Relative_Strategic_Importance,CharIndex('- ',LTRIM(Relative_Strategic_Importance))+1,LEN(Relative_Strategic_Importance)))) 
					END
				) AS Relative_Strategic_Importance
				,(
					CASE
						WHEN Is_Excluded = 1 
							THEN ''
						ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Relative_Strategic_Importance)),0,(CharIndex('- ',Relative_Strategic_Importance))))) 
					END) AS BGColor
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
						WHEN Is_Excluded = 1 
							THEN ('Excluded')
						WHEN Relative_Strategic_Importance IN (SELECT Name FROM Dimension_Values) 
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Relative_Strategic_Importance = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Relative_Strategic_Importance,CharIndex('- ',LTRIM(Relative_Strategic_Importance))+1,LEN(Relative_Strategic_Importance)))) 
					END
				) AS Relative_Strategic_Importance
				,(
					CASE
						WHEN Is_Excluded = 1 
							THEN ''
						ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Relative_Strategic_Importance)),0,(CharIndex('- ',Relative_Strategic_Importance))))) 
					END) AS BGColor
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

	-- Relative Strategic Importance (Last Two Year)
	LEFT JOIN (
		SELECT *
		FROM (
			SELECT
				ID_Combined					
				,(
					CASE
						WHEN Is_Excluded = 1 
							THEN ('Excluded')
						WHEN Relative_Strategic_Importance IN (SELECT Name FROM Dimension_Values) 
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Relative_Strategic_Importance = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Relative_Strategic_Importance,CharIndex('- ',LTRIM(Relative_Strategic_Importance))+1,LEN(Relative_Strategic_Importance)))) 
					END
				) AS Relative_Strategic_Importance
				,(
					CASE
						WHEN Is_Excluded = 1 
							THEN ''
						ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Relative_Strategic_Importance)),0,(CharIndex('- ',Relative_Strategic_Importance))))) 
					END) AS BGColor
				,ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
			FROM vInvestmentScoringReporting_preMigration vInv
			WHERE
				(Objective = '.Overall' OR COALESCE(Objective, '') = '')
				AND Score_Year = (@ScoringYear-2)
				AND Relative_Strategic_Importance <> ''
		) tmp
		WHERE ChangeIndex = 1
	) LastTwoYearsRelStratImpt
		ON INV_PYMT.ID_Combined = LastTwoYearsRelStratImpt.ID_Combined

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
	LEFT JOIN
	(
		SELECT DISTINCT ID_Combined
		FROM dbo.vInvestmentScoringReporting_preMigration
		WHERE Is_Excluded = 1 AND Score_Year = @ScoringYear
	) ex on ex.ID_Combined=INV_PYMT.ID_Combined
	WHERE 
		ex.ID_Combined IS NULL
	--Main Query Grouping
	GROUP BY
		INV_PYMT.ID_Combined
		,INV_PYMT.INV_Managing_Team
		,INV_PYMT.INV_Managing_SubTeam
		,INV_PYMT.INV_Managing_Team_Level_3
		,INV_PYMT.INV_Managing_Team_Level_4
		,INV_PYMT.INV_Grantee_Vendor_Name
		,INV_PYMT.INV_Title
		,INV_PYMT.INV_Description
		,INV_PYMT.INV_Owner
		,INV_PYMT.PMT_Initiative
		,INV_PYMT.PMT_SubInitiative
		,INV_PYMT.INV_Start_Date
		,INV_PYMT.INV_End_Date
		,ThisYearPerfAgainstExecution.Performance_Against_Milestones
		,ThisYearPerfAgainstExecution.BGColor
		,LastYearPerfAgainstExecution.Performance_Against_Milestones
		,LastYearPerfAgainstExecution.BGColor
		,LastTwoYearsPerfAgainstExecution.Performance_Against_Milestones
		,LastTwoYearsPerfAgainstExecution.BGColor
		,ThisYearReinvestmentProspects.Reinvestment_Prospects
		,ThisYearReinvestmentProspects.BGColor
		,LastYearReinvestmentProspects.Reinvestment_Prospects
		,LastYearReinvestmentProspects.BGColor
		,LastTwoYearsReinvestmentProspects.Reinvestment_Prospects
		,LastTwoYearsReinvestmentProspects.BGColor
		,ThisYearPerfAgainstStrategy.Performance_Against_Strategy
		,ThisYearPerfAgainstStrategy.BGColor
		,LastYearPerfAgainstStrategy.Performance_Against_Strategy
		,LastYearPerfAgainstStrategy.BGColor
		,LastTwoYearsPerfAgainstStrategy.Performance_Against_Strategy
		,LastTwoYearsPerfAgainstStrategy.BGColor
		,ThisYearRelStratImpt.Relative_Strategic_Importance
		,ThisYearRelStratImpt.BGColor
		,LastYearRelStratImpt.Relative_Strategic_Importance
		,LastYearRelStratImpt.BGColor
		,LastTwoYearsRelStratImpt.Relative_Strategic_Importance
		,LastTwoYearsRelStratImpt.BGColor
		,INV_Scoring.Rationale
		,INV_Scoring.Key_Results_Data
		,INV_Scoring.Funding_Team_Input
		,ISNULL(MULTI_STRAT.Multi_Strat,0)
		,Category
		,PMT_Division
		,PMT_Strategy
		,FundedBy
		,ManagedBy
		,FundingTeamCount
		,INV_PYMT.PMT_Key_Element

	-- Removed investment with categories other than 'Managed and Funded Only'

		DELETE FROM @tmpInvestmentDetails
		WHERE ID_Combined IN (
		SELECT ID_Combined FROM @tmpInvestmentDetails WHERE Category = 'Managed and Funded Only') AND Category <> 'Managed and Funded Only'

	--Create new records for multi-select

		UPDATE tmp
		SET ID_Combined= 'UPD_'+ID_Combined
		FROM @tmpInvestmentDetails tmp
		LEFT JOIN @DivisionTable PMT_DT
			ON REPLACE(REPLACE(tmp.PMT_Division,', ',''),'''','') = PMT_DT.DivisionItem
		LEFT JOIN @DivisionTable INV_DT
			ON REPLACE(REPLACE(tmp.INV_Managing_Team,', ',''),'''','') = INV_DT.DivisionItem
		LEFT JOIN @StrategyTable PMT_ST
			ON REPLACE(REPLACE(tmp.PMT_Strategy,', ',''),'''','') = PMT_ST.StrategyItem
		LEFT JOIN @StrategyTable INV_ST
			ON REPLACE(REPLACE(tmp.INV_Managing_SubTeam,', ',''),'''','') = INV_ST.StrategyItem
		LEFT JOIN @InitiativeTable IT
			ON REPLACE(REPLACE(tmp.PMT_Initiative,', ',''),'''','') = IT.InitiativeItem
		WHERE 
			(PMT_Division<>INV_Managing_Team AND PMT_Strategy <> INV_Managing_SubTeam)
			AND (PMT_Division IS NOT NULL OR PMT_Division <>'')
			AND (PMT_Strategy IS NOT NULL OR PMT_Strategy <>'')
			AND (INV_Managing_Team IS NOT NULL OR INV_Managing_Team <>'')
			AND (INV_Managing_SubTeam IS NOT NULL OR INV_Managing_SubTeam <>'')
			AND PMT_DT.DivisionItem IS NOT NULL
			AND INV_DT.DivisionItem IS NOT NULL
			AND PMT_ST.StrategyItem IS NOT NULL
			AND INV_ST.StrategyItem IS NOT NULL
			AND IT.InitiativeItem IS NOT NULL

		INSERT INTO @tmpInvestmentDetails
		SELECT tmp.* FROM @tmpInvestmentDetails tmp
		LEFT JOIN @DivisionTable PMT_DT
			ON REPLACE(REPLACE(tmp.PMT_Division,', ',''),'''','') = PMT_DT.DivisionItem
		LEFT JOIN @DivisionTable INV_DT
			ON REPLACE(REPLACE(tmp.INV_Managing_Team,', ',''),'''','') = INV_DT.DivisionItem
		LEFT JOIN @StrategyTable PMT_ST
			ON REPLACE(REPLACE(tmp.PMT_Strategy,', ',''),'''','') = PMT_ST.StrategyItem
		LEFT JOIN @StrategyTable INV_ST
			ON REPLACE(REPLACE(tmp.INV_Managing_SubTeam,', ',''),'''','') = INV_ST.StrategyItem
		LEFT JOIN @InitiativeTable IT
			ON REPLACE(REPLACE(tmp.PMT_Initiative,', ',''),'''','') = IT.InitiativeItem
		WHERE 
			(PMT_Division<>INV_Managing_Team AND PMT_Strategy <> INV_Managing_SubTeam)
			AND (PMT_Division IS NOT NULL OR PMT_Division <>'')
			AND (PMT_Strategy IS NOT NULL OR PMT_Strategy <>'')
			AND (INV_Managing_Team IS NOT NULL OR INV_Managing_Team <>'')
			AND (INV_Managing_SubTeam IS NOT NULL OR INV_Managing_SubTeam <>'')
			AND PMT_DT.DivisionItem IS NOT NULL
			AND INV_DT.DivisionItem IS NOT NULL
			AND PMT_ST.StrategyItem IS NOT NULL
			AND INV_ST.StrategyItem IS NOT NULL
			AND IT.InitiativeItem IS NOT NULL


		UPDATE SRC
		SET
			 PMT_Division = CASE WHEN Rown=1 THEN '' ELSE PMT_Division END 
			,PMT_Strategy = CASE WHEN Rown=1 THEN '' ELSE PMT_Strategy END 
			,INV_Managing_Team = CASE WHEN Rown=1 THEN INV_Managing_Team ELSE '' END 
			,INV_Managing_SubTeam = CASE WHEN Rown=1 THEN INV_Managing_SubTeam ELSE '' END 
			,ID_Combined= RIGHT(ID_Combined,len(ID_Combined)-4)
	
		FROM
		(
			SELECT 
				ROW_NUMBER() OVER (PARTITION BY ID_COMBINED ORDER BY ID_COMBINED) Rown
				,*
			FROM @tmpInvestmentDetails
			WHERE SUBSTRING(ID_Combined,1,3)='UPD'
		) SRC

		UPDATE tmp
		SET 
		Category=
				CASE
					WHEN INV_DT.DivisionItem IS NOT NULL
						AND INV_ST.StrategyItem IS NOT NULL
						AND 0 < (SELECT COUNT(B.INV_ID)
								FROM Investment_Payment B
								WHERE B.INV_ID = ID_Combined
										AND ISNULL(REPLACE(REPLACE(B.PMT_Division,', ',''),'''',''), '') = PMT_DT.DivisionItem 
										AND ISNULL(REPLACE(REPLACE(B.PMT_Strategy,', ',''),'''',''), '') = PMT_ST.StrategyItem) 
						THEN @ManagedandFundedOnlyLiteral
					WHEN INV_DT.DivisionItem  IS NOT NULL
						AND INV_ST.StrategyItem IS NOT NULL
						AND 0 = (SELECT COUNT(B.INV_ID) 
								FROM Investment_Payment B
								WHERE B.INV_ID = ID_Combined
										AND ISNULL(REPLACE(REPLACE(PMT_Division,', ',''),'''',''), '') = PMT_DT.DivisionItem
										AND ISNULL(REPLACE(REPLACE(PMT_Strategy,', ',''),'''',''), '') = PMT_ST.StrategyItem)
						THEN @ManagedOnlyLiteral
					WHEN (INV_DT.DivisionItem IS NULL OR INV_ST.StrategyItem IS NULL)
						AND PMT_DT.DivisionItem IS NOT NULL
						AND PMT_ST.StrategyItem IS NOT NULL
						THEN @FundedOnlyLiteral
				END

		FROM @tmpInvestmentDetails tmp
		LEFT JOIN @DivisionTable PMT_DT
			ON REPLACE(REPLACE(PMT_Division,', ',''),'''','') = PMT_DT.DivisionItem
		LEFT JOIN @DivisionTable INV_DT
			ON REPLACE(REPLACE(INV_Managing_Team,', ',''),'''','') = INV_DT.DivisionItem
		LEFT JOIN @StrategyTable PMT_ST
			ON REPLACE(REPLACE(PMT_Strategy,', ',''),'''','') = PMT_ST.StrategyItem
		LEFT JOIN @StrategyTable INV_ST
			ON REPLACE(REPLACE(INV_Managing_SubTeam,', ',''),'''','') = INV_ST.StrategyItem
		LEFT JOIN @InitiativeTable IT
			ON REPLACE(REPLACE(PMT_Initiative,', ',''),'''','') = IT.InitiativeItem
			
	
	UPDATE tmpInvDetails
	SET 
		 tmpInvDetails.ManagedBy=SRC.ManagedBy
		,tmpInvDetails.FundedBy=SRC.FundedBy
		,tmpInvDetails.FundingTeamCount=SRC.FTCnt
	FROM @tmpInvestmentDetails tmpInvDetails

	LEFT JOIN 
	(

		SELECT 
		STUFF
		(
			(	SELECT DISTINCT
					' | '
					+CASE WHEN PMT_INITIATIVE ='' THEN 'No Initiative' ELSE PMT_INITIATIVE END
				FROM Investment_Payment
				WHERE INV_ID = tid.ID_COMBINED AND INV_Managing_SubTeam <>'' 
				FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'
			),1,3,''

		) ManagedBy,

		STUFF
		(
			(	
			SELECT FundedSTR
			FROM
				(
					SELECT DISTINCT
						' | '
						+PMT_STRATEGY
						+'-'
						+CASE WHEN PMT_INITIATIVE ='' THEN 'No Initiative' ELSE PMT_INITIATIVE END 
						+' $'+PARSENAME(CONVERT(VARCHAR,SUM(CONVERT(MONEY,PMT_Strategy_Allocation_Amt)) OVER (PARTITION BY INV_ID,PMT_Strategy,PMT_Initiative ),1),2) FundedSTR,
						SUM(CONVERT(MONEY,PMT_Strategy_Allocation_Amt)) OVER (PARTITION BY INV_ID,PMT_Strategy,PMT_Initiative ) OrderSum

					FROM Investment_Payment
					WHERE INV_ID = tid.ID_COMBINED AND PMT_STRATEGY <>'' 
				) FundedList
			ORDER BY OrderSum DESC
			FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'
				
			),1,3,''

		) FundedBy,
		(
			SELECT COUNT(DISTINCT PMT_Strategy)
			FROM Investment_Payment
			WHERE INV_ID = tid.ID_COMBINED AND PMT_STRATEGY <>'' 
		) FTCnt,
		ID_COMBINED from @tmpInvestmentDetails tid
	)SRC on tmpInvDetails.ID_COMBINED=SRC.ID_COMBINED


	--Filter and Order Investments
	
	SELECT
	ROW_NUMBER() OVER (PARTITION BY ID_Combined 
			ORDER BY	
				CASE 
					WHEN Category =@ManagedOnlyLiteral THEN
						INV_Managing_Team
					WHEN Category=@FundedOnlyLiteral THEN
						PMT_Division
					WHEN Category=@ManagedandFundedOnlyLiteral THEN
						PMT_Division
				 END
				,CASE
					WHEN Category=@ManagedOnlyLiteral THEN
						INV_Managing_SubTeam
					WHEN Category=@FundedOnlyLiteral THEN
						PMT_Strategy
					WHEN Category=@ManagedandFundedOnlyLiteral THEN
						PMT_Strategy
				 END
				 
				,CASE
					WHEN Category = @ManagedOnlyLiteral THEN
						INV_Managing_Team_Level_3
					WHEN Category = @FundedOnlyLiteral THEN
						PMT_Initiative
					WHEN Category = @ManagedandFundedOnlyLiteral THEN
						PMT_Initiative
				  END
					  
				,CASE
					WHEN Category = @ManagedOnlyLiteral THEN
						INV_Managing_Team_Level_4
					WHEN Category = @FundedOnlyLiteral THEN
						PMT_SubInitiative
					WHEN Category = @ManagedandFundedOnlyLiteral THEN
						PMT_SubInitiative
				  END
				,CASE														
					WHEN Category = @ManagedOnlyLiteral THEN				
						''								 
					WHEN Category = @FundedOnlyLiteral THEN					
						PMT_Key_Element										
					WHEN Category = @ManagedandFundedOnlyLiteral THEN		
						PMT_Key_Element										
				END
				,Total_Investment_Amount DESC
				,Total_Strategy_Amount DESC
				,ID_Combined
		) DuplicateIndicator, -- Duplicate Tagging
		ROW_NUMBER() OVER (
			ORDER BY
				CASE 
					WHEN Category =@ManagedOnlyLiteral THEN
						INV_Managing_Team
					WHEN Category=@FundedOnlyLiteral THEN
						PMT_Division
					WHEN Category=@ManagedandFundedOnlyLiteral THEN
						PMT_Division
				 END
				,CASE
					WHEN Category=@ManagedOnlyLiteral THEN
						INV_Managing_SubTeam
					WHEN Category=@FundedOnlyLiteral THEN
						PMT_Strategy
					WHEN Category=@ManagedandFundedOnlyLiteral THEN
						PMT_Strategy
				 END
				,CASE
					WHEN Category = @ManagedOnlyLiteral THEN
						INV_Managing_Team_Level_3
					WHEN Category = @FundedOnlyLiteral THEN
						PMT_Initiative
					WHEN Category = @ManagedandFundedOnlyLiteral THEN
						PMT_Initiative
				 END	  
				,CASE
					WHEN Category = @ManagedOnlyLiteral THEN
						INV_Managing_Team_Level_4
					WHEN Category = @FundedOnlyLiteral THEN
						PMT_SubInitiative
					WHEN Category = @ManagedandFundedOnlyLiteral THEN
						PMT_SubInitiative
				END
				,CASE														
					WHEN Category = @ManagedOnlyLiteral THEN				
						''								
					WHEN Category = @FundedOnlyLiteral THEN					
						PMT_Key_Element										
					WHEN Category = @ManagedandFundedOnlyLiteral THEN		
						PMT_Key_Element										
				END
				,Total_Investment_Amount DESC
				,Total_Strategy_Amount DESC
				,ID_Combined
		) AS RowNumber
		,*
	INTO #InvTemp
	FROM @tmpInvestmentDetails
	WHERE
		( @FilterBy = 'Managed Only'
			AND Category = 'Managed Only')

		OR ( @FilterBy = 'Funded Only'
			AND Category = 'Funded Only')

		OR ( @FilterBy = 'Managed and Funded Only'
			AND Category = 'Managed and Funded Only')

		OR ( @FilterBy = 'Managed Only,Funded Only'
			AND Category IN ('Managed Only', 'Funded Only'))

		OR ( @FilterBy = 'Managed Only,Managed and Funded Only'
			AND Category IN ('Managed Only', 'Managed and Funded Only'))

		OR ( @FilterBy = 'Funded Only,Managed and Funded Only'
			AND Category IN ('Funded Only', 'Managed and Funded Only'))

		OR ( @FilterBy = 'Managed Only,Funded Only,Managed and Funded Only'
			AND Category IN ('Managed Only', 'Funded Only', 'Managed and Funded Only'))
		
	

SELECT 
		ROW_NUMBER() OVER (ORDER BY RowNumber) RowNumber
		,ID_Combined                      
		,PMT_Initiative	
		,PMT_SubInitiative				 
		,Category                        
		,Total_Investment_Amount        
		,Total_Strategy_Amount           
		,INV_Managing_Team               
		,INV_Managing_SubTeam            
		,INV_Managing_Team_Level_3     
		,INV_Managing_Team_Level_4  
		,INV_Grantee_Vendor_Name         
		,INV_Title                       
		,INV_Description                 
		,INV_Owner                       
		,INV_Start_Date                  
		,INV_End_Date                    
		,ThisYearPerfAgainstExecution     
		,ThisYearPerfAgainstExecBGColor   
		,LastYearPerfAgainstExecution    
		,LastYearPerfAgainstExecBGColor 
		,LastTwoYearsPerfAgainstExecution    
		,LastTwoYearsPerfAgainstExecBGColor  		
		,ThisYearReinvestmentProspects  
		,ThisYearReinvestmentProsBGColor 
		,LastYearReinvestmentProspects   
		,LastYearReinvestmentProsBGColor
		,LastTwoYearsReinvestmentProspects   
		,LastTwoYearsReinvestmentProsBGColor
		,ThisYearPerfAgainstStrategy     
		,ThisYearPerfAgainstStratBGColor 
		,LastYearPerfAgainstStrategy     
		,LastYearPerfAgainstStratBGColor
		,LastTwoYearsPerfAgainstStrategy     
		,LastTwoYearsPerfAgainstStratBGColor 		
		,ThisYearRelStratImpt            
		,ThisYearRelStratImptBGColor     
		,LastYearRelStratImpt            
		,LastYearRelStratImptBGColor  
		,LastTwoYearsRelStratImpt            
		,LastTwoYearsRelStratImptBGColor     
		,Multi_Strat                     
		,Rationale                      
		,Key_Results_Data                
		,Funding_Team_Input              
		,Amt_Paid_To_Date 
		,FundedBy
		,ManagedBy
		,FundingTeamCount
		,PMT_Key_Element
FROM #InvTemp a

WHERE DuplicateIndicator=1


GROUP BY
		 DuplicateIndicator
		,RowNumber
		,ID_Combined                      
		,PMT_Initiative		
		,PMT_SubInitiative			 
		,Category                        
		,Total_Investment_Amount        
		,Total_Strategy_Amount           
		,INV_Managing_Team               
		,INV_Managing_SubTeam            
		,INV_Managing_Team_Level_3      
		,INV_Managing_Team_Level_4 
		,INV_Grantee_Vendor_Name         
		,INV_Title                       
		,INV_Description                 
		,INV_Owner                       
		,INV_Start_Date                  
		,INV_End_Date                    
		,ThisYearPerfAgainstExecution     
		,ThisYearPerfAgainstExecBGColor   
		,LastYearPerfAgainstExecution    
		,LastYearPerfAgainstExecBGColor 
		,LastTwoYearsPerfAgainstExecution    
		,LastTwoYearsPerfAgainstExecBGColor  		
		,ThisYearReinvestmentProspects  
		,ThisYearReinvestmentProsBGColor 
		,LastYearReinvestmentProspects   
		,LastYearReinvestmentProsBGColor
		,LastTwoYearsReinvestmentProspects   
		,LastTwoYearsReinvestmentProsBGColor
		,ThisYearPerfAgainstStrategy     
		,ThisYearPerfAgainstStratBGColor 
		,LastYearPerfAgainstStrategy     
		,LastYearPerfAgainstStratBGColor
		,LastTwoYearsPerfAgainstStrategy     
		,LastTwoYearsPerfAgainstStratBGColor 		
		,ThisYearRelStratImpt            
		,ThisYearRelStratImptBGColor     
		,LastYearRelStratImpt            
		,LastYearRelStratImptBGColor  
		,LastTwoYearsRelStratImpt            
		,LastTwoYearsRelStratImptBGColor       
		,Multi_Strat                     
		,Rationale                      
		,Key_Results_Data                
		,Funding_Team_Input              
		,Amt_Paid_To_Date   
		,FundedBy
		,ManagedBy
		,FundingTeamCount
		,PMT_Key_Element

		IF OBJECT_ID('tempdb..#InvTemp') IS NOT NULL
		DROP TABLE #InvTemp


END