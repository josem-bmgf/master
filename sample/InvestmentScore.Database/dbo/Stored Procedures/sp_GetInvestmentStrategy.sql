CREATE PROCEDURE [dbo].[sp_GetInvestmentStrategy]
	@Division AS NVARCHAR(MAX),
	@InvTotalPayoutAmt      INT
AS

/*******************************************************************************
Author: Alvin John C. Apilan
Created Date: 08/1/2017
Description:	Get the list of Investment Strategy
exec [sp_GetInvestmentStrategy] 'Executive'
Changed By		Date		Description 
--------------------------------------------------------------------------------
Alvin John Apilan	8/1/2017	Initial Version
Alvin John Apilan	8/24/2017	Added INV_Managing_Team in WHERE Clause
Karla Tuazon		01/03/2018  ZD62425: Change the current year to 2017
Sarah Bataller		07/18/2018  US 157915	Updated Division, Strategy to Multi-select and Added Initiative Report filter
Sarah Bataller		07/19/2018  US 157915	Updated variable value to MAX
Sarah Bataller		07/30/2018  US 157915: Updated parameter, date, and filtering on excluded investments
Jake Harry Chavez	08/07/2018	US 157915	optimized query
Jake Harry Chavez	08/09/2018	US 160981	Cascased lock-in period
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
SELECT * FROM ufn_Split(REPLACE(@Division,', ',''), ',')

	BEGIN
		SELECT PMT_Strategy
		FROM(
				SELECT DISTINCT PMT_Strategy
				FROM Investment_Payment invPayment
				LEFT JOIN @DivisionTable DT
				ON REPLACE(PMT_Division,', ','') = DT.DivisionItem
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
				) ex on ex.ID_Combined=invPayment.INV_ID
				WHERE
				(
					(@InvTotalPayoutAmt = '1' AND INV_Total_Payout_Amt >= 5000000)
					OR @InvTotalPayoutAmt = '2'
				)						  
				AND 
				(
						[INV_Status] = 'Active' 
					OR  ([INV_Status] IN ('Closed','Cancelled','Inactive') AND YEAR([INV_END_DATE]) >= @Scoring_Year)
				)
				AND DT.DivisionItem IS NOT NULL
				AND ex.ID_Combined IS NULL
				AND invDel.ID_Combined IS NULL

				UNION

				SELECT DISTINCT INV_Managing_SubTeam
				FROM Investment_Payment invPayment
				LEFT JOIN @DivisionTable DT
				ON REPLACE(invPayment.INV_Managing_Team,', ','') = DT.DivisionItem
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
				) ex on ex.ID_Combined=invPayment.INV_ID
				WHERE 
				(
					(@InvTotalPayoutAmt = '1' AND INV_Total_Payout_Amt >= 5000000)
					OR @InvTotalPayoutAmt = '2'
				)
				AND 
				(
						[INV_Status] = 'Active' 
					OR  ([INV_Status] IN ('Closed','Cancelled','Inactive') AND YEAR([INV_END_DATE]) >= @Scoring_Year)
				)
				AND DT.DivisionItem IS NOT NULL
				AND ex.ID_Combined IS NULL
				AND invDel.ID_Combined IS NULL
			) AS Strategy
		ORDER BY PMT_Strategy
	END
END