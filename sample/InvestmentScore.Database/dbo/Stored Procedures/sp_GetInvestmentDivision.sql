CREATE PROCEDURE [dbo].[sp_GetInvestmentDivision] 
	@InvTotalPayoutAmt INT

AS

/*******************************************************************************
Author:	Alvin John C. Apilan
Created Date:	8/1/2017
Description:	Get the list of Investment Division
exec [sp_GetInvestmentDivision] 'Global Health'
Changed By		Date		Description 
--------------------------------------------------------------------------------
Alvin John Apilan	8/1/2017	Initial Version
Alvin John Apilan	9/11/2017	[Defect 144877] Removed Unknown in Division dropdown
Karla Tuazon		01/03/2018  ZD62425: Change the current year to 2017
Sarah Bataller		07/18/2018  US 157915: Updated Division, Strategy to Multi-select and Added Initiative Report filter
Sarah Bataller		07/30/2018  US 157915: Updated parameter, date, and filtering on excluded investments
Jake Harry Chavez	08/07/2018	US 157915	optimized query
Jake Harry Chavez	08/09/2018	US 160981:	Cascased lock-in period
Jonson Villanueva	05/14/2021  BUG 36640:	Resolve Stored Procedures in IST database related to exclude flag change
*******************************************************************************/

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN

DECLARE @Scoring_Year AS NVARCHAR(100)=CASE WHEN MONTH(GETDATE())>=6 THEN YEAR(GETDATE()) ELSE YEAR(GETDATE())-1 END

SELECT PMT_Division
FROM(
		SELECT DISTINCT PMT_Division
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
			AND ex.ID_Combined IS NULL	
			AND invDel.ID_Combined IS NULL	
		UNION
		SELECT DISTINCT INV_Managing_Team
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
			AND	ex.ID_Combined IS NULL	
			AND invDel.ID_Combined IS NULL		
	) AS Division
	
WHERE PMT_Division != 'Unknown'
ORDER BY PMT_Division

END