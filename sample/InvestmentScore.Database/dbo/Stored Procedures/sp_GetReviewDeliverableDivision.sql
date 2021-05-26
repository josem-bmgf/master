CREATE PROCEDURE [dbo].[sp_GetReviewDeliverableDivision] 
	@Is5MPlus BIT

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
*******************************************************************************/

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN

SELECT PMT_Division
FROM(
		SELECT 'Choose' PMT_Division
		UNION
		SELECT DISTINCT PMT_Division
		FROM Investment_Payment
		WHERE
			(INV_Total_Payout_Amt >= CASE WHEN @Is5MPlus = 1 THEN 5000000 ELSE 0 END)
			AND ([INV_Status] = 'Active' OR  ([INV_Status] IN ('Closed','Cancelled','Inactive') 
			--KCT: Set current year to 2017
			AND YEAR([INV_END_DATE]) >= '2017'))		
		UNION
		SELECT DISTINCT INV_Managing_Team
		FROM Investment_Payment
		WHERE
			(INV_Total_Payout_Amt >= CASE WHEN @Is5MPlus = 1 THEN 5000000 ELSE 0 END	)
			AND ([INV_Status] = 'Active' OR  ([INV_Status] IN ('Closed','Cancelled','Inactive') 
			--KCT: Set current year to 2017
			AND YEAR([INV_END_DATE]) >= '2017'))			
	) AS Division
WHERE PMT_Division != 'Unknown'
ORDER BY CASE WHEN PMT_Division = 'Choose' THEN 1 ELSE 2 END, PMT_Division
	
END