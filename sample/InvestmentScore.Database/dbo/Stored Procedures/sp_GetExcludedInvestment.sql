CREATE PROCEDURE [dbo].[sp_GetExcludedInvestment]
	@Division      NVARCHAR(MAX),
	@Strategy      NVARCHAR(MAX)
AS
/*******************************************************************************
Author:	Jake Harry Chavez
Created Date:	07/13/2018
Description:	Returns rows of excluded records.

Changed By			Date		Description 
--------------------------------------------------------------------------------
Jake Harry Chavez	07/13/2018	Initial Version
Jake Harry Chavez	07/17/2018	Added functions that wil bypass commas in strategy 
								items.
Jake Harry Chavez	07/18/2018	Removed INV_Managing_Team and INV_ManagingSubTeam
Jake Harry Chavez	07/20/2018	Added ordering and different string if Initiative
								is empty.
Jake Harry Chavez	08/02/2018	Added PMT_Division and PMT_Strategy for 
								new grouping
Jake Harry Chavez	08/08/2018	Added PMT_Division and PMT_Strategy for 
								sorting
Jeronell Aguila		05/21/2020	User Story 227986 Investment Scoring - Excluded 
								Investments Report - Include Level5 in grouping 
								logic
*******************************************************************************/
BEGIN


SELECT 
	 ROW_NUMBER() 
		OVER 
		(
			ORDER BY 
				 INV_PMT.PMT_Division
				,INV_PMT.PMT_Strategy
				,CASE
					WHEN PMT_Initiative='' THEN
						2
					ELSE
						1
				 END
				,PMT_Initiative
				,CONVERT(DECIMAL(18,2),AVG(INV_Total_Payout_Amt)) DESC
				,CONVERT(DECIMAL(18,2),SUM(PMT_Strategy_Allocation_Amt)) DESC
				
		)																AS [Row_Number]
	,INV_ID																AS [Investment ID]
	,INV.INV_Grantee_Vendor_Name										AS [Organization Name]
	,INV.INV_Title														AS [Title]
	,CONVERT(DECIMAL(18,2),AVG(INV_Total_Payout_Amt))					AS [Total Investment Amount]
	,CONVERT(DECIMAL(18,2),SUM(PMT_Strategy_Allocation_Amt))			AS [Total Strategy Amount]
	,INV.INV_Owner														AS [INV Owner]
	,USR.DisplayName													AS [Excluded By]
	,SCR.Modified_On													AS [Excluded Date]
	,CASE 
		WHEN PMT_Initiative='' THEN
			'No Initiative'
		ELSE		
			PMT_Initiative + CASE
								WHEN PMT_SubInitiative = '' THEN ''
								ELSE '/ ' + PMT_SubInitiative 
								+ CASE
									WHEN PMT_Key_Element = '' THEN ''
									ELSE '/ ' + PMT_Key_Element
								END
							 END
	 END																AS [PMT_Initiative]
	,PMT_Division
	,PMT_Strategy
	,PMT_SubInitiative													AS [PMT_SubInitiative]
	,PMT_Key_Element													AS [PMT_Key_Element]
FROM Investment_Payment INV_PMT

INNER JOIN Investment INV
	ON INV_PMT.INV_ID = INV.ID_Combined
LEFT JOIN
(
	SELECT * FROM dbo.ufn_Split(REPLACE(@Strategy,', ',''),',')
) STRAT 
	ON		Strat.Item=REPLACE(PMT_Strategy,', ','')
LEFT JOIN
(
	SELECT * FROM dbo.ufn_Split(REPLACE(@Division,', ',''),',')
) DIV 
	ON		DIV.Item=REPLACE(PMT_Division,', ','') 
INNER JOIN dbo.Scores SCR
	ON INV.ID = SCR.Investment_ID
LEFT JOIN dbo.[User] USR
	ON SCR.Modified_By_ID=USR.ID

WHERE
		ISNULL(INV.Is_Deleted,0) != 1
		AND STRAT.Item IS NOT NULL
		AND DIV.Item IS NOT NULL
		AND SCR.Is_Excluded = 1
		AND SCR.Score_Year >= CASE WHEN MONTH(GETDATE())>=6 THEN YEAR(GETDATE()) ELSE YEAR(GETDATE())-1  END
		
		
GROUP BY
	 INV_ID
	,INV.INV_Grantee_Vendor_Name
	,INV.INV_Title	
	,INV.INV_Owner
	,USR.DisplayName
	,SCR.Modified_On
	,PMT_Initiative
	,PMT_Division
	,PMT_Strategy
	,PMT_SubInitiative
	,PMT_Key_Element

END 