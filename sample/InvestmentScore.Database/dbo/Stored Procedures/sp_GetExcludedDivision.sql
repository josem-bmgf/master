CREATE PROCEDURE [dbo].[sp_GetExcludedDivision]
	
AS

/*******************************************************************************
Author:	Jake Harry Chavez
Created Date:	07/13/2018
Description:	Get the list of Investment Division

Changed By			Date		Description 
--------------------------------------------------------------------------------
Jake Harry Chavez	07/13/2018	Initial Version
Jake Harry Chavez	07/18/2018	Removed Inv_Managing_Team
Jake Harry Chavez	08/02/2018	Switched from INV_END_DATE to Score_Year
Jake Harry Chavez	08/07/2018	Removed $5M+ filter
*******************************************************************************/

BEGIN


SELECT PMT_Division
FROM(
		
		SELECT DISTINCT PMT_Division
		FROM Investment_Payment ip
		LEFT JOIN Investment i 
			ON ip.INV_ID=i.ID_Combined
		LEFT JOIN Scores s
			ON i.ID=s.Investment_ID
		WHERE
			s.Score_Year >= CASE WHEN MONTH(GETDATE())>=6 THEN YEAR(GETDATE()) ELSE YEAR(GETDATE())-1  END
			AND s.Is_Excluded=1			
	) AS Division
WHERE PMT_Division != 'Unknown'
ORDER BY PMT_Division

		

END