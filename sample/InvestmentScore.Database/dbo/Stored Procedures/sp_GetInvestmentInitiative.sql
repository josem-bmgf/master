CREATE PROCEDURE [dbo].[sp_GetInvestmentInitiative] 
	@Division AS NVARCHAR(MAX),
	@Strategy AS NVARCHAR(MAX),
	@InvTotalPayoutAmt INT
AS

/*******************************************************************************
Author: Sarah Bataller
Created Date: 07/18/2018
Description:	Get the list of Investment Initiative
exec [sp_GetInvestmentInitiative] 'Executive'
Changed By		Date		Description 
--------------------------------------------------------------------------------
Sarah Bataller		7/18/2018	Initial Version
Sarah Bataller		07/19/2018  US 157915	Updated variable value to MAX
Sarah Bataller		07/24/2018  US 157915	Display No Initiative for blank initiatives
Sarah Bataller		07/30/2018  US 157915	Updated parameter, date, and filtering on excluded investments
Jake Harry Chavez	08/07/2018	US 157915	optimized query
Jake Harry Chavez	08/09/2018	US 160981	Cascased lock-in period
Jake Harry Chavez	12/13/2018	US 172689	Removed Initiative as a required field
Jake Harry Chavez	12/14/2018	US 172689	Removed Initiative as a parameter
Jonson Villanueva	05/14/2021  BUG 36640:	Resolve Stored Procedures in IST database related to exclude flag change
*******************************************************************************/

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


BEGIN

DECLARE @Scoring_Year AS NVARCHAR(100)=CASE WHEN MONTH(GETDATE())>=6 THEN YEAR(GETDATE()) ELSE YEAR(GETDATE())-1 END
-- Get Division and insert to table
DECLARE @DivisionTable TABLE
(
	DivisionItem NVARCHAR(MAX)
)
INSERT INTO @DivisionTable
SELECT * FROM dbo.ufn_Split(REPLACE(@Division,', ',''),',')

-- Get Strategy and insert to table
DECLARE @StrategyTable TABLE(
		StrategyItem NVARCHAR(MAX))
INSERT INTO @StrategyTable
SELECT * FROM dbo.ufn_Split(REPLACE(@Strategy,', ',''),',')

	BEGIN

		SELECT PMT_Initiative
		FROM(


				SELECT 'No Initiative' PMT_Initiative

				UNION

				SELECT DISTINCT PMT_Initiative
				FROM Investment_Payment invPayment
				LEFT JOIN 
				(
					SELECT DISTINCT ID_Combined FROM INVESTMENT WHERE IS_DELETED=1
				) invDel
					ON invDel.ID_Combined=invPayment.INV_ID
				LEFT JOIN
				(
					SELECT DISTINCT ID_Combined
					FROM dbo.vInvestmentScoringReporting_preMigration
					WHERE Is_Excluded=1 and Score_Year=@Scoring_Year
				) ex ON ex.ID_Combined=invPayment.INV_ID

				LEFT JOIN @DivisionTable DT
					ON DT.DivisionItem=REPLACE(PMT_Division,', ','')
				LEFT JOIN @StrategyTable ST
					ON ST.StrategyItem=REPLACE(PMT_Strategy,', ','')
		
				WHERE
					(
						(@InvTotalPayoutAmt = '1' AND INV_Total_Payout_Amt >= 5000000)
						OR @InvTotalPayoutAmt = '2'
					)					  
					AND ([INV_Status] = 'Active'
						 OR ( [INV_Status] IN ('Closed','Cancelled','Inactive')
							  AND YEAR([INV_END_DATE]) >=@Scoring_Year)
							 )
				AND DT.DivisionItem IS NOT NULL
				AND ST.StrategyItem IS NOT NULL
				AND ex.ID_Combined IS NULL
				AND invDel.ID_Combined IS NULL
				UNION

				SELECT DISTINCT PMT_Initiative
				FROM Investment_Payment invPayment
				LEFT JOIN 
				(
					SELECT DISTINCT ID_Combined FROM INVESTMENT WHERE IS_DELETED=1
				) invDel
					ON invDel.ID_Combined=invPayment.INV_ID
				LEFT JOIN
				(
					SELECT DISTINCT ID_Combined
					FROM dbo.vInvestmentScoringReporting_preMigration
					WHERE Is_Excluded=1 and Score_Year=@Scoring_Year
				) ex ON ex.ID_Combined=invPayment.INV_ID

				LEFT JOIN @DivisionTable DT
					ON DT.DivisionItem=REPLACE(INV_Managing_Team,', ','')
				LEFT JOIN @StrategyTable ST
					ON ST.StrategyItem=REPLACE(INV_Managing_SubTeam,', ','')
		
				WHERE
					(
						(@InvTotalPayoutAmt = '1' AND INV_Total_Payout_Amt >= 5000000)
						OR @InvTotalPayoutAmt = '2'
					)
					AND ([INV_Status] = 'Active'
						 OR ( [INV_Status] IN ('Closed','Cancelled','Inactive')
							  AND YEAR([INV_END_DATE]) >= @Scoring_Year)
							 )
					AND DT.DivisionItem IS NOT NULL
					AND ST.StrategyItem IS NOT NULL
					AND ex.ID_Combined IS NULL
					AND invDel.ID_Combined IS NULL
			) AS Strategy
		ORDER BY CASE WHEN PMT_Initiative = '_' THEN 1 ELSE 2 END,CASE WHEN PMT_Initiative = 'No Initiative' THEN 2 ELSE 3 END, PMT_Initiative
	END
END