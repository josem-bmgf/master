CREATE PROCEDURE [dbo].[sp_GetInvestmentSummary]
	@Division      NVARCHAR(100),
	@Strategy      NVARCHAR(100),
	@Filter_By     NVARCHAR(100),
	@Order_Group_1 NVARCHAR(100)
AS

BEGIN

	/*******************************************************************************
	Author:		Alvin John Apilan
	Created Date:	08/03/2017
	Description:	Get the list of Investment Summaries
	Usage:
		EXEC [sp_GetInvestmentSummary]
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
	Karla Tuazon		    01/03/2018  ZD62425: Change the current year to 2017
	Alvin John Apilan       01/05/2018  Bug 148543: Limit the Summary report displays to 2017 only
	Jonson Villanueva		05/14/2021  BUG 36640:	Resolve Stored Procedures in IST database related to exclude flag change
	*******************************************************************************/

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

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
	)

	DECLARE
		@ManagedOnlyLiteral             NVARCHAR (MAX) = 'Managed Only'
		,@FundedOnlyLiteral             NVARCHAR (MAX) = 'Funded Only'
		,@ManagedandFundedOnlyLiteral   NVARCHAR (MAX) = 'Managed and Funded Only'
		,@InvnotalignedLiteral          NVARCHAR (MAX) = 'Investment not aligned to strategy team''s initiatives'

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
		,CAST(INV_PMT.INV_Start_Date AS DATE)                        AS INV_Start_Date
		,CAST(INV_PMT.INV_End_Date AS DATE)                          AS INV_End_Date
		,MIN(ISNULL(INV_Total_Payout_Amt,0))                         AS INV_Total_Payout_Amt
		,SUM (
			CASE
				WHEN PMT_Division = @Division AND PMT_Strategy = @Strategy
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
		END                                                          AS Category
	FROM Investment_Payment INV_PMT
	INNER JOIN Investment INV
	ON INV_PMT.INV_ID = INV.ID_Combined
	WHERE
		ISNULL(INV.Is_Deleted,0) != 1
		AND
		(
			(ISNULL(PMT_Division, '') = @Division AND ISNULL(PMT_Strategy, '') = @Strategy)
			OR (ISNULL(INV_Managing_Team, '') = @Division AND ISNULL(INV_Managing_SubTeam, '') = @Strategy)
		)
		AND INV_Total_Payout_Amt >= 5000000
		AND (
			INV_PMT.INV_Status = 'Active'
			OR (
				INV_PMT.INV_Status IN ('Closed', 'Cancelled', 'Inactive')
				--KCT: Set current year to 2017
				AND YEAR(INV_PMT.INV_END_DATE) >= '2017'
			)
		)
	GROUP BY
		INV_ID
		,PMT_Division
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
					--KCT: Set current year to 2017
					AND Score_Year = '2017'
			) tmp
			WHERE ChangeIndex = 1
		) PerfAgainstResult
			ON Investment_Payment.ID_Combined = PerfAgainstResult.ID_Combined

	--Filter and Order Investments
	SELECT
		ROW_NUMBER() OVER (ORDER BY Min(a.RowOrder)) AS RowNumber
		,a.ID_Combined
		,a.PMT_Initiative
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
			,INV_Total_Payout_Amt
			,PMT_Strategy_Allocation_Amt
			,PerformanceInvestmentFlag	
			,HyperlinkURL	
			,Performance_Against_Milestones	
			,Performance_Against_Strategy	
			,Relative_Strategic_Importance
			,Category
			,ROW_NUMBER() OVER (
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
					,INV_Total_Payout_Amt DESC
					,PMT_Strategy_Allocation_Amt DESC
					,INV_Managing_Team
					,INV_Managing_SubTeam
					,PMT_Division
					,PMT_Strategy
			) RowOrder
		FROM @tmpInvestmentSummary
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
			     OR (PMT_Division = @Division AND PMT_Strategy = @Strategy))

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
END

