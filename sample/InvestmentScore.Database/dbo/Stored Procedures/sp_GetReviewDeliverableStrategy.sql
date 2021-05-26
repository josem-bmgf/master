CREATE PROCEDURE [dbo].[sp_GetReviewDeliverableStrategy] 
	@Division AS NVARCHAR(100),
	@Is5MPlus BIT
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
*******************************************************************************/

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN

iF @Division = 'Choose' 
	BEGIN
		SELECT 'Choose' PMT_Strategy
	END
ELSE
	BEGIN
		SELECT PMT_Strategy
		FROM(
				SELECT 'Choose' PMT_Strategy
				UNION
				SELECT DISTINCT PMT_Strategy
				FROM Investment_Payment 
				WHERE (PMT_Division = (@Division))
					AND INV_Total_Payout_Amt >= CASE WHEN @Is5MPlus = 1 THEN 5000000 ELSE 0 END							  
					AND ([INV_Status] = 'Active'
						 OR ( [INV_Status] IN ('Closed','Cancelled','Inactive')
							   --KCT: Set current year to 2017
							  AND YEAR([INV_END_DATE]) >= '2017')
							 )

				UNION
				SELECT DISTINCT INV_Managing_SubTeam
				FROM Investment_Payment 
				WHERE (INV_Managing_Team =(@Division) )
					AND INV_Total_Payout_Amt >= CASE WHEN @Is5MPlus = 1 THEN 5000000 ELSE 0 END
					AND ([INV_Status] = 'Active'
						 OR ( [INV_Status] IN ('Closed','Cancelled','Inactive')
						   --KCT: Set current year to 2017
							  AND YEAR([INV_END_DATE]) >= '2017')
							 )
			) AS Strategy
		ORDER BY CASE WHEN PMT_Strategy = 'Choose' THEN 1 ELSE 2 END, PMT_Strategy
	END
END