CREATE PROCEDURE [dbo].[sp_GetExcludedStrategy]
	@Division		NVARCHAR(MAX)
	
	
AS
/*******************************************************************************
Author:	Jake Harry Chavez
Created Date:	07/13/2018
Description:	Get the list of Investment Strategy
Usage:
	EXEC  [dbo].[sp_GetExcludedStrategy] 'Global Development'

Changed By			Date		Description 
--------------------------------------------------------------------------------
Jake Harry Chavez	07/13/2018	Initial Version
Jake Harry Chavez	07/18/2018	Removed INV_Managing_SubTeam
Jake Harry Chavez	08/02/2018	Switched from INV_END_DATE to Score_Year
Jake Harry Chavez	08/06/2018	Removed $5M+ filter
*******************************************************************************/
BEGIN


SELECT PMT_Strategy
FROM
(
		SELECT DISTINCT PMT_Strategy
		FROM Investment_Payment ip

		LEFT JOIN
		(
			SELECT * FROM dbo.ufn_Split(@Division,',')
		) DIV 
			ON DIV.Item=ip.PMT_Division
		LEFT JOIN Investment i 
			ON ip.INV_ID=i.ID_Combined
		LEFT JOIN Scores s
			ON i.ID=s.Investment_ID
		WHERE DIV.Item IS NOT NULL
			AND s.Score_Year >= CASE WHEN MONTH(GETDATE())>=6 THEN YEAR(GETDATE()) ELSE YEAR(GETDATE())-1  END
			AND s.Is_Excluded=1

) AS Strategy
ORDER BY  PMT_Strategy

		

END