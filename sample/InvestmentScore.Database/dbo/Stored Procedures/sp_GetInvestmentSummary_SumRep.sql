CREATE PROCEDURE [dbo].[sp_GetInvestmentSummary_SumRep]
	@InvTotalPayoutAmt      INT,
	@Division      NVARCHAR(MAX),
	@Strategy      NVARCHAR(MAX),
	@Filter_By     NVARCHAR(100),
	@Order_Group_1 NVARCHAR(100)
AS



BEGIN

	/*******************************************************************************
	Author:		Jake Harry Chavez
	Created Date:	05/30/2018
	Description:	Get the list of Investment Summaries
	Usage:
		EXEC [sp_GetInvestmentSummary_SumRep]
			@InvTotalPayoutAmt = '1',
			  @Division = 'Global Policy and Advocacy',
			  @Strategy = 'Program Advocacy & Comms',
			  @Filter_By = 'Managed Only,Funded Only,Managed and Funded Only',
			  @Order_Group_1  = 'Managed Only, Funded Only, Managed and Funded Only'

	Changed By				Date		Description 
	--------------------------------------------------------------------------------
	Alvin John Apilan		08/01/2017	Initial Version
	Alvin John Apilan		08/24/2017	Added INV_Managing_Team and INV_Managing_SubTeam in WHERE Clause
	Alvin John Apilan		08/24/2017	Bug 144671: Unexpected Total Strategy Amount Value
	Marlon Ho				09/05/2017	US 144197:  Create a separate SSRS reports to generate Investment Scoring Summary
	Darwin Baluyot			09/14/2017	US 144921:  Added ORDER BY clause for Total Investment Amount and Total Strategy Amount
	Darwin Baluyot			09/20/2017	BUG 144536: Updated ORDER BY clause to reflect correct sorting in UI
	Richard Joseph Santos   09/28/2017	US 145603:	Update INVs grouping logic, Refactor
	Marlon Ho				10/04/2017	US 144952:  Add PMT_Initiative information on the result
	Richard Joseph Santos   10/05/2017	US 145846:	Update INVs grouping logic, including PMT_Initiative
	Jenina Chua			    10/06/2017  US 145846 Bug 145921: Capture funded investments with 0 strategy allocation amount
	Darwin Baluyot			11/14/2017	US 146501:	Added filter to exclude specific investments
	Jake Harry Chavez		05/30/2017	US 156048:	Updates on page numbers
													Script taken from sp_GetInvestmentDetail. Added some updates
	Jake Harry Chavez		06/29/2018	US 157887	Added excluded function
	Jake Harry Chavez		07/03/2018	US 157887	Added ID_Combined as sorting parameter
	Sarah Bataller			07/18/2018  US 157915	Updated Division, Strategy to Multi-select and Added Initiative Report filter
	Richard Joseph Santos   07/18/2018  US 157914   Added filtering by Investment Total Payout Amount
	Sarah Bataller			07/19/2018  US 157915	Updated variable value to MAX and updated filtering condition
	Sarah Bataller			07/24/2018  US 157915	Display No Initiative for blank initiatives
	John Vince Gomez		07/23/2018	US 157919	Modified Scoring year declarations
	Sarah Bataller			07/26/2018  US 157915	Bug 161103: Managed Only should have 0 Allocation Amount
	Jake Harry Chavez		08/01/2018	US 157915	Bug 161695: Updated Additional records for Managed only and funded only
	Jake Harry Chavez		08/02/2018	US 157915	Bug 161695: Fixed apostrophe issue
	Jake Harry Chavez		08/02/2018	US 157915	Bug 161665: Optimized query
	Jake Harry Chavez		08/08/2018	US 160981	Updates on sorting and grouping
	Jonson Villanueva		08/07/2018	US 159071	Cascade Exclude Functionality from Tool to Investment Score Summary Report
	Jake Harry Chavez		08/31/2018	US 163759	Added INV Start Date and INV End Date
	Jake Harry Chavez		10/24/2018	US 168055	Adjusted blue header
	Jake Harry Chavez		11/05/2018	US 168055	Added forward slash in blue header. Removes forward slash when INV_Managing_Team_Level_3 or INV_Managing_Team_Level_4 is empty
	Jake Harry Chavez		11/06/2018	US 169344	Changed forward slash to backward slash	
	Jake Harry Chavez		11/22/2018	US 170585	Updated Page Number Logic
	Jake Harry Chavez		12/13/2018	US 172689	Removed Initiative as a required field
	Jake Harry Chavez		12/14/2018	US 172689	Removed Initiative as a parameter
	John Louie Chan			12/17/2018  BUG 172985	Adding SUb initiative in scope for page numbering
	Sarah Bataller			12/21/2018	BUG 173145	Removed investment with categories other than 'Managed and Funded Only'
	Sarah Bataller			12/22/2018	BUG 172985	Made paging in chronological order
	Jake Harry Chavez		08/29/2019	BUG 196236	Updated sorting logic
	JAke Harry Chavez		09/05/2019	BUG 196236	Added sorting logic for header
	Jake Harry Chavez		04/30/2020	US 224411	Added FundingTeamCount
	Jeronell Aguila			05/12/2020	US 225841	Include BoW in grouping logic in Investment Scoring Summary report
	Jeronell Aguila			07/23/2020	BUG 6282	Fixed duplicates for managed only by adding case statement of PMT_Key_Element
	Jonson Villanueva		05/14/2021  BUG 36640:	Resolve Stored Procedures in IST database related to exclude flag change
	*******************************************************************************/

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


	IF OBJECT_ID('tempdb..#InvTemp') IS NOT NULL
	DROP TABLE #InvTemp

	DECLARE @tmpInvestmentSummary       AS TABLE (
		ID_Combined                     NVARCHAR (255)
		,PMT_Division                   NVARCHAR (100)
		,PMT_Strategy                   NVARCHAR (100)
		,INV_Managing_Team              NVARCHAR (50)
		,INV_Managing_SubTeam           NVARCHAR (255)
		,INV_Grantee_Vendor_Name        NVARCHAR (255)
		,INV_Title                      NVARCHAR (255)
		,INV_Description                NVARCHAR (4000)
		,INV_Owner                      NVARCHAR (4000)
		,PMT_Initiative					NVARCHAR (100)	
		,INV_Start_Date                 DATETIME 
		,INV_End_Date                   DATETIME 
		,INV_Total_Payout_Amt           MONEY
		,PMT_Strategy_Allocation_Amt    MONEY
		,PerformanceInvestmentFlag      BIT		 
		,HyperlinkURL                   NVARCHAR (255)
		,Performance_Against_Milestones NVARCHAR (220)
		,Performance_Against_Strategy   NVARCHAR (220)
		,Relative_Strategic_Importance  NVARCHAR (220)
		,Category                       NVARCHAR (23)
		,INV_Managing_Team_Level_3		NVARCHAR (255)
		,INV_Managing_Team_Level_4		NVARCHAR (255)
		,PMT_SubInitiative				NVARCHAR (100)
		,FundingTeamCount				INT
		,PMT_Key_Element				NVARCHAR (100)
	)

	DECLARE
		@ManagedOnlyLiteral             NVARCHAR (MAX) = 'Managed Only'
	DECLARE @FundedOnlyLiteral             NVARCHAR (MAX) = 'Funded Only'
	DECLARE @ManagedandFundedOnlyLiteral   NVARCHAR (MAX) = 'Managed and Funded Only'
	DECLARE @InvnotalignedLiteral          NVARCHAR (MAX) = 'No Initiative'
	
	DECLARE @ScoringYear AS INT = CASE WHEN MONTH(GETDATE())>=6 THEN YEAR(GETDATE()) ELSE YEAR(GETDATE())-1  END

	--Get Strategy and insert to table
	DECLARE @StrategyTable TABLE
	(
		StrategyItem NVARCHAR(MAX)
	)
	INSERT INTO @StrategyTable
	SELECT * FROM dbo.ufn_Split(REPLACE(@Strategy,', ',''),',')

	--Get Division and insert to table
	DECLARE @DivisionTable TABLE
	(
		DivisionItem NVARCHAR(MAX)
	)
	INSERT INTO @DivisionTable
	SELECT * FROM dbo.ufn_Split(REPLACE(@Division,', ',''),',')

	--Get Initiative and insert to table
	DECLARE @Initiative		NVARCHAR(MAX)=''
		--Removed Initiative as parameter. Now set to blank
	DECLARE @InitiativeTable TABLE
	(
		InitiativeItem NVARCHAR(MAX)
	)
	INSERT INTO @InitiativeTable
	SELECT * FROM dbo.ufn_Split(REPLACE(@Initiative,', ',''),',')

	UPDATE @InitiativeTable
	SET InitiativeItem = ''
	WHERE InitiativeItem = 'No Initiative'

	UPDATE @InitiativeTable
	SET InitiativeItem=REPLACE(InitiativeItem,'''','')

	UPDATE @DivisionTable
	SET DivisionItem=REPLACE(DivisionItem,'''','')

	UPDATE @StrategyTable
	SET StrategyItem=REPLACE(StrategyItem,'''','')

	
	--Get all Investments
	INSERT INTO @tmpInvestmentSummary
	SELECT
		INV_ID                                                       AS ID_Combined
		,PMT_Division
		,PMT_Strategy
		,INV_Managing_Team                                           AS INV_Managing_Team
		,INV_Managing_SubTeam                                        AS INV_Managing_SubTeam
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
		,CAST(INV_PMT.INV_Start_Date AS DATE)                        AS INV_Start_Date
		,CAST(INV_PMT.INV_End_Date AS DATE)                          AS INV_End_Date
		,MIN(ISNULL(INV_Total_Payout_Amt,0))                         AS INV_Total_Payout_Amt
		,SUM (
			CASE
				WHEN PMT_DT.DivisionItem IS NOT NULL AND PMT_ST.StrategyItem IS NOT NULL
					THEN PMT_Strategy_Allocation_Amt
				ELSE 0
			END
		)                                                            AS PMT_Strategy_Allocation_Amt
		,NULL                                                        AS PerformanceInvestmentFlag
		,Sys_INV_URL                                                 AS HyperlinkURL
		,NULL                                                        AS Performance_Against_Milestones
		,NULL                                                        AS Performance_Against_Strategy
		,NULL                                                        AS Relative_Strategic_Importance
		,CASE
			WHEN INV_DT.DivisionItem IS NOT NULL
				AND INV_ST.StrategyItem IS NOT NULL
				AND 0 < (SELECT COUNT(B.INV_ID)
						FROM Investment_Payment B
						WHERE B.INV_ID = INV_PMT.INV_ID
								AND ISNULL(REPLACE(REPLACE(B.PMT_Division,', ',''),'''',''), '') = PMT_DT.DivisionItem 
								AND ISNULL(REPLACE(REPLACE(B.PMT_Strategy,', ',''),'''',''), '') = PMT_ST.StrategyItem) 
				THEN @ManagedandFundedOnlyLiteral
			WHEN INV_DT.DivisionItem  IS NOT NULL
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
		 END                                                          AS Category
		,INV_Managing_Team_Level_3									  AS INV_Managing_Team_Level_3
		,INV_Managing_Team_Level_4									  AS INV_Managing_Team_Level_4
		,PMT_SubInitiative											  AS PMT_SubInitiative
		,NULL														  AS FundingTeamCount
		,INV_PMT.PMT_Key_Element 									  AS PMT_Key_Element
	FROM Investment_Payment INV_PMT
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
	LEFT JOIN
	(
		SELECT DISTINCT ID_Combined
		FROM dbo.vInvestmentScoringReporting_preMigration
		WHERE Is_Excluded = 1 AND Score_Year = @ScoringYear
	) ex on ex.ID_Combined=INV_PMT.INV_ID
	WHERE
		ISNULL(INV.Is_Deleted,0) != 1
		AND
		(
				(@InvTotalPayoutAmt = '1' AND INV_Total_Payout_Amt >= 5000000)
				OR @InvTotalPayoutAmt = '2'
		)
		AND 
		(
			INV_PMT.INV_Status = 'Active'
			OR (
				INV_PMT.INV_Status IN ('Closed', 'Cancelled', 'Inactive')
				-- KCT: Switch to 2017
				AND YEAR(INV_PMT.INV_END_DATE) >= CASE WHEN MONTH(GETDATE())>=6 THEN YEAR(GETDATE()) ELSE YEAR(GETDATE())-1 END
			)
		)
		AND 
			ex.ID_Combined IS NULL
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
		,PMT_ST.StrategyItem
		,INV_ST.StrategyItem
		,PMT_Strategy
		,INV_Managing_Team
		,INV_Managing_SubTeam
		,INV_PMT.INV_Grantee_Vendor_Name
		,INV_PMT.INV_Title
		,INV_PMT.INV_Description
		,INV_PMT.INV_Owner
		,INV_PMT.PMT_Initiative
		,CAST(INV_PMT.INV_Start_Date AS DATE) 
		,CAST(INV_PMT.INV_End_Date AS DATE)
		,Sys_INV_URL
		,INV_Managing_Team_Level_3
		,INV_Managing_Team_Level_4
		,PMT_SubInitiative
		,INV_PMT.PMT_Key_Element
	--Update funding team count
		UPDATE tmpInv
		SET FundingTeamCount=ftc.FTCnt	
		FROM @tmpInvestmentSummary tmpInv
		JOIN
		(
				SELECT 
				(
					SELECT 
						COUNT(DISTINCT PMT_Strategy)
					FROM Investment_Payment
					WHERE INV_ID = tis.ID_COMBINED AND PMT_STRATEGY <>'' 
				) FTCnt
				,ID_COMBINED FROM @tmpInvestmentSummary tis
		) ftc ON tmpInv.ID_Combined=ftc.ID_Combined

	-- Removed investment with categories other than 'Managed and Funded Only'

		DELETE FROM @tmpInvestmentSummary
		WHERE ID_Combined IN (
		SELECT ID_Combined FROM @tmpInvestmentSummary WHERE Category = 'Managed and Funded Only') AND Category <> 'Managed and Funded Only'

	--Create new records for multiselect
	

		UPDATE tmp
		SET ID_Combined= 'UPD_'+ID_Combined
		FROM @tmpInvestmentSummary tmp
		LEFT JOIN @DivisionTable PMT_DT
			ON REPLACE(REPLACE(tmp.PMT_Division,', ',''),'''','') = PMT_DT.DivisionItem
		LEFT JOIN @DivisionTable INV_DT
			ON REPLACE(REPLACE(tmp.INV_Managing_Team,', ',''),'''','') = INV_DT.DivisionItem
		LEFT JOIN @StrategyTable PMT_ST
			ON REPLACE(REPLACE(tmp.PMT_Strategy,', ',''),'''','') = PMT_ST.StrategyItem
		LEFT JOIN @StrategyTable INV_ST
			ON REPLACE(REPLACE(tmp.INV_Managing_SubTeam,', ',''),'''','') = INV_ST.StrategyItem
		
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
			

		INSERT INTO @tmpInvestmentSummary
		SELECT tmp.* FROM @tmpInvestmentSummary tmp
		LEFT JOIN @DivisionTable PMT_DT
			ON REPLACE(REPLACE(tmp.PMT_Division,', ',''),'''','') = PMT_DT.DivisionItem
		LEFT JOIN @DivisionTable INV_DT
			ON REPLACE(REPLACE(tmp.INV_Managing_Team,', ',''),'''','') = INV_DT.DivisionItem
		LEFT JOIN @StrategyTable PMT_ST
			ON REPLACE(REPLACE(tmp.PMT_Strategy,', ',''),'''','') = PMT_ST.StrategyItem
		LEFT JOIN @StrategyTable INV_ST
			ON REPLACE(REPLACE(tmp.INV_Managing_SubTeam,', ',''),'''','') = INV_ST.StrategyItem
		
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
			FROM @tmpInvestmentSummary
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
				END,
		 PMT_Strategy_Allocation_Amt=
			CASE
				WHEN INV_DT.DivisionItem  IS NOT NULL
						AND INV_ST.StrategyItem IS NOT NULL
						AND 0 = (SELECT COUNT(B.INV_ID) 
								FROM Investment_Payment B
								WHERE B.INV_ID = ID_Combined
										AND ISNULL(REPLACE(REPLACE(PMT_Division,', ',''),'''',''), '') = PMT_DT.DivisionItem
										AND ISNULL(REPLACE(REPLACE(PMT_Strategy,', ',''),'''',''), '') = PMT_ST.StrategyItem) 
				THEN
					0.00
				ELSE
					PMT_Strategy_Allocation_Amt
			END                     

		FROM @tmpInvestmentSummary tmp
		LEFT JOIN @DivisionTable PMT_DT
			ON REPLACE(REPLACE(PMT_Division,', ',''),'''','') = PMT_DT.DivisionItem
		LEFT JOIN @DivisionTable INV_DT
			ON REPLACE(REPLACE(INV_Managing_Team,', ',''),'''','') = INV_DT.DivisionItem
		LEFT JOIN @StrategyTable PMT_ST
			ON REPLACE(REPLACE(PMT_Strategy,', ',''),'''','') = PMT_ST.StrategyItem
		LEFT JOIN @StrategyTable INV_ST
			ON REPLACE(REPLACE(INV_Managing_SubTeam,', ',''),'''','') = INV_ST.StrategyItem
		


	--Set Performance Results
	UPDATE 
		@tmpInvestmentSummary
	SET
		Relative_Strategic_Importance = PerfAgainstResult.Relative_Strategic_Importance
		,Performance_Against_Milestones = PerfAgainstResult.Performance_Against_Milestones 
		,Performance_Against_Strategy = PerfAgainstResult.Performance_Against_Strategy 
	FROM @tmpInvestmentSummary Investment_Payment
		LEFT JOIN (
			SELECT
				ID_Combined
				,Performance_Against_Strategy
				,Performance_Against_Milestones
				,Relative_Strategic_Importance
			FROM (
				SELECT
					ID_Combined
					,Performance_Against_Strategy
					,Performance_Against_Milestones
					,Relative_Strategic_Importance
					,ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
				FROM vInvestmentScoringReporting_preMigration
				WHERE 
					(Objective = '.Overall' OR COALESCE(Objective, '') = '')
					-- KCT: Switch to 2017
					AND Score_Year >= CASE WHEN MONTH(GETDATE())>=6 THEN YEAR(GETDATE()) ELSE YEAR(GETDATE())-1 END
			) tmp
			WHERE ChangeIndex = 1
		) PerfAgainstResult
			ON Investment_Payment.ID_Combined = PerfAgainstResult.ID_Combined

	--Filter and Order Investments
	
	SELECT
		 ROW_NUMBER() OVER (Partition by ID_Combined Order by Min(a.RowOrder)) DuplicateIndicator 
		,ROW_NUMBER() OVER (ORDER BY Min(a.RowOrder)) AS RowNumber
		,ROW_NUMBER() OVER (ORDER BY Min(a.RowOrder)) AS PageNumber
		,a.ID_Combined
		,a.PMT_Initiative
		,a.PMT_SubInitiative
		,a.Category
		,AVG(a.INV_Total_Payout_Amt) AS INV_Total_Payout_Amt
		,SUM(a.PMT_Strategy_Allocation_Amt) AS PMT_Strategy_Allocation_Amt
		,a.INV_Grantee_Vendor_Name	
		,a.INV_Title	
		,a.INV_Owner
		,a.PerformanceInvestmentFlag	
		,a.HyperlinkURL	
		,a.Performance_Against_Milestones	
		,a.Performance_Against_Strategy	
		,a.Relative_Strategic_Importance
		,INV_Start_Date
		,INV_End_Date
		,CASE 
			WHEN Category =@ManagedOnlyLiteral THEN
				a.INV_Managing_Team
			WHEN Category=@FundedOnlyLiteral THEN
				a.PMT_Division
			WHEN Category=@ManagedandFundedOnlyLiteral THEN
				a.PMT_Division
		 END Division
		,CASE
			WHEN Category=@ManagedOnlyLiteral THEN
				a.INV_Managing_SubTeam
			WHEN Category=@FundedOnlyLiteral THEN
				a.PMT_Strategy
			WHEN Category=@ManagedandFundedOnlyLiteral THEN
				a.PMT_Strategy
		 END Strategy
		 ,a.FundingTeamCount
		 ,CASE
			WHEN Category=@ManagedOnlyLiteral THEN
				NULL
			WHEN Category=@FundedOnlyLiteral THEN
				a.PMT_Key_Element
			WHEN Category=@ManagedandFundedOnlyLiteral THEN
				a.PMT_Key_Element
		 END PMT_Key_Element
		INTO #InvTemp
	FROM (
		SELECT
			ID_Combined
			,PMT_Division
			,PMT_Strategy
			,INV_Managing_Team
			,INV_Managing_SubTeam
			,INV_Grantee_Vendor_Name	
			,INV_Title	
			,INV_Owner
			,PMT_Initiative
			,PMT_SubInitiative
			,INV_Total_Payout_Amt
			,PMT_Strategy_Allocation_Amt
			,PerformanceInvestmentFlag	
			,HyperlinkURL	
			,Performance_Against_Milestones	
			,Performance_Against_Strategy	
			,Relative_Strategic_Importance
			,Category
			,INV_Start_Date
			,INV_End_Date
			,FundingTeamCount
			,PMT_Key_Element
			,ROW_NUMBER() OVER (
				ORDER BY
					 CASE 
						WHEN Category = @ManagedOnlyLiteral THEN
							INV_Managing_Team
						WHEN Category = @FundedOnlyLiteral THEN
							PMT_Division
						WHEN Category = @ManagedandFundedOnlyLiteral THEN
							PMT_Division
					 END
					,CASE
						WHEN Category = @ManagedOnlyLiteral THEN
							INV_Managing_SubTeam
						WHEN Category = @FundedOnlyLiteral THEN
							PMT_Strategy
						WHEN Category = @ManagedandFundedOnlyLiteral THEN
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
					,INV_Total_Payout_Amt DESC
					,PMT_Strategy_Allocation_Amt DESC
					,ID_Combined
			) RowOrder
		
		FROM @tmpInvestmentSummary
		LEFT JOIN @StrategyTable ST
			ON ST.StrategyItem = REPLACE(REPLACE(PMT_Strategy,', ',''),'''','')
		LEFT JOIN @DivisionTable DT
			ON DT.DivisionItem = REPLACE(REPLACE(PMT_Division,', ',''),'''','')
		--FilterBy
		WHERE
			((@Filter_By = 'Managed Only'
				AND Category = 'Managed Only')

			OR (@Filter_By = 'Funded Only'
				AND Category = 'Funded Only')

			OR (@Filter_By = 'Managed and Funded Only'
				AND Category = 'Managed and Funded Only')

			OR (@Filter_By = 'Managed Only,Funded Only'
				AND Category IN ('Managed Only', 'Funded Only'))

			OR (@Filter_By = 'Managed Only,Managed and Funded Only'
				AND Category IN ('Managed Only', 'Managed and Funded Only'))

			OR (@Filter_By = 'Funded Only,Managed and Funded Only'
				AND Category IN ('Funded Only', 'Managed and Funded Only'))

			OR (@Filter_By = 'Managed Only,Funded Only,Managed and Funded Only'
				AND Category IN ('Managed Only', 'Funded Only', 'Managed and Funded Only')))

			AND (Category = 'Managed Only'
			     OR (REPLACE(PMT_Division,', ','') = DT.DivisionItem AND REPLACE(PMT_Strategy,', ','') = ST.StrategyItem))
			


	) a
	GROUP BY
		a.ID_Combined
		,a.INV_Grantee_Vendor_Name	
		,a.INV_Title	
		,a.INV_Owner
		,a.PMT_Initiative
		,a.PerformanceInvestmentFlag	
		,a.HyperlinkURL	
		,a.Performance_Against_Milestones	
		,a.Performance_Against_Strategy	
		,a.Relative_Strategic_Importance
		,a.Category
		,a.INV_Start_Date
		,a.INV_End_Date
		,CASE 
			WHEN Category =@ManagedOnlyLiteral THEN
				a.INV_Managing_Team
			WHEN Category=@FundedOnlyLiteral THEN
				a.PMT_Division
			WHEN Category=@ManagedandFundedOnlyLiteral THEN
				a.PMT_Division
		 END
		,CASE
			WHEN Category=@ManagedOnlyLiteral THEN
				a.INV_Managing_SubTeam
			WHEN Category=@FundedOnlyLiteral THEN
				a.PMT_Strategy
			WHEN Category=@ManagedandFundedOnlyLiteral THEN
				a.PMT_Strategy
		 END
		 ,a.PMT_SubInitiative
		 ,a.FundingTeamCount
		,CASE
			WHEN Category=@ManagedOnlyLiteral THEN
				NULL
			WHEN Category=@FundedOnlyLiteral THEN
				a.PMT_Key_Element
			WHEN Category=@ManagedandFundedOnlyLiteral THEN
				a.PMT_Key_Element
		 END
	

		UPDATE invt
		SET
			invt.PageNumber=NewRowNumber
		FROM 
		(
			SELECT 
				 CASE WHEN  DuplicateIndicator=1 THEN 
					 ROW_NUMBER() OVER (Partition by DuplicateIndicator ORDER BY PageNumber) 
				 END NewRowNumber
				,DuplicateIndicator
				,PageNumber  
			FROM #InvTemp
		) invt

		WHERE	DuplicateIndicator=1

		--Change blue header depending on funding model
		SELECT 
			ROW_NUMBER() OVER (
				ORDER BY
					 Division
					,Strategy
					,SUBSTRING(PMT_Initiative,1,CHARINDEX('\',PMT_Initiative+'\')-1)
					,PMT_Initiative
					,INV_Total_Payout_Amt DESC
					,PMT_Strategy_Allocation_Amt DESC
					,ID_Combined
			) RowNumber
		,*
		FROM
		(
			SELECT DISTINCT
			CASE WHEN DuplicateIndicator>1 THEN
				(SELECT Min(PageNumber) from #InvTemp where ID_combined=it.Id_Combined)
			 ELSE
				PageNumber
			End PageNumber --New PageNumber
			,ID_Combined
			,CASE 																				
				WHEN Category='Managed Only'													
					THEN MngLvl																	
				ELSE																			
					PMT_Initiative + 															
						CASE WHEN LTRIM(RTRIM(PMT_SubInitiative)) = '' THEN '' 					
							ELSE '\ ' + PMT_SubInitiative +									
								CASE WHEN LTRIM(RTRIM(PMT_Key_Element)) = '' THEN ''			
									ELSE '\ ' + PMT_Key_Element									
								END															
						END																		
			 END PMT_Initiative
			,Category
			,INV_Total_Payout_Amt
			,PMT_Strategy_Allocation_Amt
			,INV_Grantee_Vendor_Name	
			,INV_Title	
			,INV_Owner
			,PerformanceInvestmentFlag	
			,HyperlinkURL	
			,Performance_Against_Milestones	
			,Performance_Against_Strategy	
			,Relative_Strategic_Importance
			,Division
			,Strategy
			,INV_Start_Date
			,INV_End_Date
			,FundingTeamCount
			,PMT_Key_Element
			FROM #InvTemp it
			LEFT JOIN
			(
				SELECT  DISTINCT 
					 INV_ID
					,CASE WHEN INV_Managing_Team_Level_3 IS NULL OR INV_Managing_Team_Level_3 ='' THEN '' ELSE  INV_Managing_Team_Level_3 END +
					 CASE WHEN INV_Managing_Team_Level_4 IS NULL OR INV_Managing_Team_Level_4 ='' THEN '' ELSE  '\ '+INV_Managing_Team_Level_4 END  MngLvl 
				FROM Investment_Payment INV_PMT
				WHERE 
				(
					INV_PMT.INV_Status = 'Active'
					OR (
						INV_PMT.INV_Status IN ('Closed', 'Cancelled', 'Inactive')
						-- KCT: Switch to 2017
						AND YEAR(INV_PMT.INV_END_DATE) >= @ScoringYear
					)
				) 
			)src ON it.ID_Combined=src.INV_ID
		) finInv
		
		
		
		IF OBJECT_ID('tempdb..#InvTemp') IS NOT NULL
		DROP TABLE #InvTemp
		
END