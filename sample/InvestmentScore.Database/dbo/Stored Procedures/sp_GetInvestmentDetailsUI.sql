CREATE PROCEDURE [dbo].[sp_GetInvestmentDetailsUI]
		  
		@ID_Combined NVARCHAR(100)

AS

/*******************************************************************************
Author		:	Marlon Ho
Created Date:	August 22, 2017
Description	:	Get the list of Investments
Usage:
	sp_GetInvestmentDetailsUI '19762'


Changed By			Date		Description 
--------------------------------------------------------------------------------
Marlon Ho			8/22/2017	Initial Version. 
								US 143740 - Investment Score: Add/Edit Score:  
								Add link that opens up SSRS report to generate detailed slide 
Karla Tuazon		01/03/2018  ZD62425: Change the current year to 2017
Jake Harry Chavez	09/26/2018	US 165819: Applied updates from Investment Summary 
John Louie Chan	    10/02/2018  US 165819: changed all hard coded years 
Jake Harry Chavez	10/01/2018	US 168057: Updated title header
Jonson Villanueva	05/14/2021  BUG 36640:	Resolve Stored Procedures in IST database related to exclude flag change
*******************************************************************************/

BEGIN

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @ScoringYear AS INT = CASE WHEN MONTH(GETDATE())>=6 THEN YEAR(GETDATE()) ELSE YEAR(GETDATE())-1  END

SELECT Distinct
       INV_PYMT.ID_Combined
      ,INV_PYMT.PMT_Division
      ,INV_PYMT.PMT_Strategy
	  ,INV_PYMT.INV_Managing_Team
	  ,INV_PYMT.INV_Managing_SubTeam
	  ,INV_PYMT.INV_Managing_Team_Level_3
	  ,INV_PYMT.INV_Managing_Team_Level_4
      ,INV_PYMT.INV_Grantee_Vendor_Name
      ,INV_PYMT.INV_Title
      ,INV_PYMT.INV_Description
      ,INV_PYMT.INV_Owner
      ,INV_PYMT.INV_Start_Date
      ,INV_PYMT.INV_End_Date
	  ,MAX(ISNULL(INV_PYMT.[INV_Total_Payout_Amt],0))  AS [Total_Investment_Amount]
	  ,CY.Performance_Against_Milestones AS ThisYearPerfAgainstExecution
	  ,CY.PAM_BGColor AS ThisYearPerfAgainstExecBGColor
	  ,PY.Performance_Against_Milestones AS LastYearPerfAgainstExecution
	  ,PY.PAM_BGColor AS LastYearPerfAgainstExecBGColor
	  ,PTY.Performance_Against_Milestones AS LastTwoYearsPerfAgainstExecution
	  ,PTY.PAM_BGColor AS LastTwoYearsPerfAgainstExecBGColor
	  ,CY.Reinvestment_Prospects AS ThisYearReinvestmentProspects
	  ,CY.RP_BGColor AS ThisYearReinvestmentProsBGColor
	  ,PY.Reinvestment_Prospects AS LastYearReinvestmentProspects
	  ,PY.RP_BGColor AS LastYearReinvestmentProsBGColor
	  ,PTY.Reinvestment_Prospects AS LastTwoYearsReinvestmentProspects
	  ,PTY.RP_BGColor AS LastTwoYearsReinvestmentProsBGColor
	  ,CY.Performance_Against_Strategy AS ThisYearPerfAgainstStrategy
	  ,CY.PAS_BGColor AS ThisYearPerfAgainstStratBGColor
	  ,PY.Performance_Against_Strategy AS LastYearPerfAgainstStrategy
	  ,PY.PAS_BGColor AS LastYearPerfAgainstStratBGColor
	  ,PTY.Performance_Against_Strategy AS LastTwoYearsPerfAgainstStrategy
	  ,PTY.PAS_BGColor AS LastTwoYearsPerfAgainstStratBGColor
	  ,CY.Relative_Strategic_Importance AS ThisYearRelStratImpt
	  ,CY.RSI_BGColor AS ThisYearRelStratImptBGColor
	  ,PY.Relative_Strategic_Importance AS LastYearRelStratImpt
	  ,PY.RSI_BGColor AS LastYearRelStratImptBGColor
	  ,PTY.Relative_Strategic_Importance AS LastTwoYearsRelStratImpt
	  ,PTY.RSI_BGColor AS LastTwoYearsRelStratImptBGColor
	  ,ManagedBy
	  ,FundedBy

	  --,Top_Bot_Perf.flag AS PerformanceInvestmentFlag
	  ,ISNULL(MULTI_STRAT.Multi_Strat,0) AS Multi_Strat
	  ,CY.Rationale
	  ,CY.Key_Results_Data
	  ,CY.Funding_Team_Input
	  ,MAX(ISNULL(ptd.[Amt_Paid_To_Date],0)) as [Amt_Paid_To_Date]
 FROM (
 SELECT TOP 1
       CASE WHEN NULLIF(LTRIM(RTRIM(ISNULL(INV_ID,''))),'') IS NULL 
            THEN CPT_GATEWAY_ID
            ELSE INV_ID
       END ID_Combined
      ,PMT_Division
      ,PMT_Strategy
	  ,INV_Managing_Team
	  ,INV_Managing_SubTeam
	  ,INV_Managing_Team_Level_3
	  ,INV_Managing_Team_Level_4
      ,INV_Grantee_Vendor_Name
      ,INV_Title
      ,INV_Description
      ,INV_Owner
      ,CAST(INV_Start_Date AS Date) INV_Start_Date
      ,CAST(INV_End_Date AS Date) INV_End_Date
	  ,MIN(ISNULL(INV_Total_Payout_Amt,0)) INV_Total_Payout_Amt

 FROM Investment_Payment WITH (NoLock) 
 WHERE CASE WHEN NULLIF(LTRIM(RTRIM(ISNULL(INV_ID,''))),'') IS NULL 
            THEN CPT_GATEWAY_ID
            ELSE INV_ID
       END = @ID_Combined
 AND ([INV_Status] = 'Active'
			OR ( [INV_Status] IN ('Closed','Cancelled','Inactive')
			   --KCT: Set current year to 2017
				AND YEAR([INV_END_DATE]) = @ScoringYear)
         )
 
 GROUP BY
       CASE WHEN NULLIF(LTRIM(RTRIM(ISNULL(INV_ID,''))),'') IS NULL 
            THEN CPT_GATEWAY_ID
            ELSE INV_ID
       END 
      ,PMT_Division
      ,PMT_Strategy
	  ,INV_Managing_Team
	  ,INV_Managing_SubTeam
	  ,INV_Managing_Team_Level_3
	  ,INV_Managing_Team_Level_4
      ,INV_Grantee_Vendor_Name
      ,INV_Title
      ,INV_Description
      ,INV_Owner
	  --,INV_Status
      ,CAST(INV_Start_Date AS Date) 
      ,CAST(INV_End_Date AS Date)
	  ,Sys_INV_URL
 ) AS INV_PYMT


--Scoring
	LEFT JOIN
	(SELECT * FROM
	(SELECT
		ID_Combined
		,Score_Year
		,CASE WHEN Is_Excluded=1 THEN 'EXCLUDED' 
		 ELSE
			(CASE WHEN Performance_Against_Milestones IN ( SELECT Name FROM Dimension_Values ) 
			   THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Performance_Against_Milestones = dv.Name)
			   ELSE LTRIM(RTRIM(SUBSTRING(Performance_Against_Milestones,CharIndex('- ',LTRIM(Performance_Against_Milestones))+1,LEN(Performance_Against_Milestones)))) 
			   END )
		 END AS Performance_Against_Milestones

		,CASE WHEN Is_Excluded=1 THEN ''
		 ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Performance_Against_Milestones)),0,(CharIndex('- ',Performance_Against_Milestones))))) 
		 END AS PAM_BGColor

		,CASE WHEN Is_Excluded=1 THEN 'EXCLUDED' 
		 ELSE
			(CASE WHEN Reinvestment_Prospects IN ( SELECT Name FROM Dimension_Values ) 
			   THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Reinvestment_Prospects = dv.Name)
			   ELSE LTRIM(RTRIM(SUBSTRING(Reinvestment_Prospects,CharIndex('- ',LTRIM(Reinvestment_Prospects))+1,LEN(Reinvestment_Prospects)))) 
			   END) 
	     END AS Reinvestment_Prospects

		,CASE WHEN Is_Excluded=1 THEN ''
		 ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Reinvestment_Prospects)),0,(CharIndex('- ',Reinvestment_Prospects))))) 
		 END AS RP_BGColor

		,CASE WHEN Is_Excluded=1 THEN 'EXCLUDED' 
		 ELSE 
			(CASE WHEN Performance_Against_Strategy IN ( SELECT Name FROM Dimension_Values ) 
			   THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Performance_Against_Strategy = dv.Name)
			   ELSE LTRIM(RTRIM(SUBSTRING(Performance_Against_Strategy,CharIndex('- ',LTRIM(Performance_Against_Strategy))+1,LEN(Performance_Against_Strategy)))) 
			   END ) 
	     END AS Performance_Against_Strategy

		,CASE WHEN Is_Excluded=1 THEN '' 
		 ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Performance_Against_Strategy)),0,(CharIndex('- ',Performance_Against_Strategy))))) 
		 END AS PAS_BGColor

		,CASE WHEN Is_Excluded=1 THEN 'EXCLUDED' 
		 ELSE 
			(CASE WHEN Relative_Strategic_Importance IN ( SELECT Name FROM Dimension_Values ) 
			  THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Relative_Strategic_Importance = dv.Name)
			  ELSE LTRIM(RTRIM(SUBSTRING(Relative_Strategic_Importance,CharIndex('- ',LTRIM(Relative_Strategic_Importance))+1,LEN(Relative_Strategic_Importance)))) 
			  END ) 
		 END AS Relative_Strategic_Importance

		,CASE WHEN Is_Excluded=1 THEN ''
		 ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Relative_Strategic_Importance)),0,(CharIndex('- ',Relative_Strategic_Importance)))))
		 END AS RSI_BGColor

		,Rationale
		,Key_Results_Data
		,Funding_Team_Input
		,Row_Number() OVER (Partition By Investment_id ORDER BY Score_Date DESC) AS ChangeIndex
	FROM dbo.vInvestmentScoringReporting_preMigration vInv 
	WHERE 
	(Objective = '.Overall' 
	OR COALESCE(Objective, '') = '')
	--KCT: Set current year to 2017
	AND Score_Year=@ScoringYear) Temp
	WHERE Temp.ChangeIndex=1) AS CY
	ON INV_PYMT.ID_Combined=CY.ID_Combined

	LEFT JOIN
	(SELECT * FROM
	(SELECT
		ID_Combined
		,Score_Year
		,CASE WHEN Is_Excluded=1 THEN 'EXCLUDED' 
		 ELSE
			(CASE WHEN Performance_Against_Milestones IN ( SELECT Name FROM Dimension_Values ) 
			   THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Performance_Against_Milestones = dv.Name)
			   ELSE LTRIM(RTRIM(SUBSTRING(Performance_Against_Milestones,CharIndex('- ',LTRIM(Performance_Against_Milestones))+1,LEN(Performance_Against_Milestones)))) 
			   END )
		 END AS Performance_Against_Milestones

		,CASE WHEN Is_Excluded=1 THEN ''
		 ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Performance_Against_Milestones)),0,(CharIndex('- ',Performance_Against_Milestones))))) 
		 END AS PAM_BGColor

		,CASE WHEN Is_Excluded=1 THEN 'EXCLUDED' 
		 ELSE
			(CASE WHEN Reinvestment_Prospects IN ( SELECT Name FROM Dimension_Values ) 
			   THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Reinvestment_Prospects = dv.Name)
			   ELSE LTRIM(RTRIM(SUBSTRING(Reinvestment_Prospects,CharIndex('- ',LTRIM(Reinvestment_Prospects))+1,LEN(Reinvestment_Prospects)))) 
			   END) 
	     END AS Reinvestment_Prospects

		,CASE WHEN Is_Excluded=1 THEN ''
		 ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Reinvestment_Prospects)),0,(CharIndex('- ',Reinvestment_Prospects))))) 
		 END AS RP_BGColor

		,CASE WHEN Is_Excluded=1 THEN 'EXCLUDED' 
		 ELSE 
			(CASE WHEN Performance_Against_Strategy IN ( SELECT Name FROM Dimension_Values ) 
			   THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Performance_Against_Strategy = dv.Name)
			   ELSE LTRIM(RTRIM(SUBSTRING(Performance_Against_Strategy,CharIndex('- ',LTRIM(Performance_Against_Strategy))+1,LEN(Performance_Against_Strategy)))) 
			   END ) 
	     END AS Performance_Against_Strategy

		,CASE WHEN Is_Excluded=1 THEN '' 
		 ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Performance_Against_Strategy)),0,(CharIndex('- ',Performance_Against_Strategy))))) 
		 END AS PAS_BGColor

		,CASE WHEN Is_Excluded=1 THEN 'EXCLUDED' 
		 ELSE 
			(CASE WHEN Relative_Strategic_Importance IN ( SELECT Name FROM Dimension_Values ) 
			  THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Relative_Strategic_Importance = dv.Name)
			  ELSE LTRIM(RTRIM(SUBSTRING(Relative_Strategic_Importance,CharIndex('- ',LTRIM(Relative_Strategic_Importance))+1,LEN(Relative_Strategic_Importance)))) 
			  END ) 
		 END AS Relative_Strategic_Importance

		,CASE WHEN Is_Excluded=1 THEN ''
		 ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Relative_Strategic_Importance)),0,(CharIndex('- ',Relative_Strategic_Importance)))))
		 END AS RSI_BGColor

		,Rationale
		,Key_Results_Data
		,Funding_Team_Input
		,Row_Number() OVER (Partition By Investment_id ORDER BY Score_Date DESC) AS ChangeIndex
	FROM dbo.vInvestmentScoringReporting_preMigration vInv 
	WHERE 
	(Objective = '.Overall' 
	OR COALESCE(Objective, '') = '')
	--KCT: Set current year to 2017
	AND Score_Year=@ScoringYear-1) Temp
	WHERE Temp.ChangeIndex=1) AS PY
	ON INV_PYMT.ID_Combined=PY.ID_Combined

	LEFT JOIN
	(SELECT * FROM
	(SELECT
		ID_Combined
		,Score_Year
		,CASE WHEN Is_Excluded=1 THEN 'EXCLUDED' 
		 ELSE
			(CASE WHEN Performance_Against_Milestones IN ( SELECT Name FROM Dimension_Values ) 
			   THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Performance_Against_Milestones = dv.Name)
			   ELSE LTRIM(RTRIM(SUBSTRING(Performance_Against_Milestones,CharIndex('- ',LTRIM(Performance_Against_Milestones))+1,LEN(Performance_Against_Milestones)))) 
			   END )
		 END AS Performance_Against_Milestones

		,CASE WHEN Is_Excluded=1 THEN ''
		 ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Performance_Against_Milestones)),0,(CharIndex('- ',Performance_Against_Milestones))))) 
		 END AS PAM_BGColor

		,CASE WHEN Is_Excluded=1 THEN 'EXCLUDED' 
		 ELSE
			(CASE WHEN Reinvestment_Prospects IN ( SELECT Name FROM Dimension_Values ) 
			   THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Reinvestment_Prospects = dv.Name)
			   ELSE LTRIM(RTRIM(SUBSTRING(Reinvestment_Prospects,CharIndex('- ',LTRIM(Reinvestment_Prospects))+1,LEN(Reinvestment_Prospects)))) 
			   END) 
	     END AS Reinvestment_Prospects

		,CASE WHEN Is_Excluded=1 THEN ''
		 ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Reinvestment_Prospects)),0,(CharIndex('- ',Reinvestment_Prospects))))) 
		 END AS RP_BGColor

		,CASE WHEN Is_Excluded=1 THEN 'EXCLUDED' 
		 ELSE 
			(CASE WHEN Performance_Against_Strategy IN ( SELECT Name FROM Dimension_Values ) 
			   THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Performance_Against_Strategy = dv.Name)
			   ELSE LTRIM(RTRIM(SUBSTRING(Performance_Against_Strategy,CharIndex('- ',LTRIM(Performance_Against_Strategy))+1,LEN(Performance_Against_Strategy)))) 
			   END ) 
	     END AS Performance_Against_Strategy

		,CASE WHEN Is_Excluded=1 THEN '' 
		 ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Performance_Against_Strategy)),0,(CharIndex('- ',Performance_Against_Strategy))))) 
		 END AS PAS_BGColor

		,CASE WHEN Is_Excluded=1 THEN 'EXCLUDED' 
		 ELSE 
			(CASE WHEN Relative_Strategic_Importance IN ( SELECT Name FROM Dimension_Values ) 
			  THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Relative_Strategic_Importance = dv.Name)
			  ELSE LTRIM(RTRIM(SUBSTRING(Relative_Strategic_Importance,CharIndex('- ',LTRIM(Relative_Strategic_Importance))+1,LEN(Relative_Strategic_Importance)))) 
			  END ) 
		 END AS Relative_Strategic_Importance

		,CASE WHEN Is_Excluded=1 THEN ''
		 ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Relative_Strategic_Importance)),0,(CharIndex('- ',Relative_Strategic_Importance)))))
		 END AS RSI_BGColor

		,Rationale
		,Key_Results_Data
		,Funding_Team_Input
		,Row_Number() OVER (Partition By Investment_id ORDER BY Score_Date DESC) AS ChangeIndex
	FROM dbo.vInvestmentScoringReporting_preMigration vInv 
	WHERE 
	(Objective = '.Overall' 
	OR COALESCE(Objective, '') = '')
	--KCT: Set current year to 2017
	AND Score_Year=@ScoringYear-2) Temp
	WHERE Temp.ChangeIndex=1) AS PTY --previous two years
	ON INV_PYMT.ID_Combined=PTY.ID_Combined


--Multiple Strategy
LEFT JOIN
	(SELECT MULTI_STRAT_DET.ID_Combined, 1 AS Multi_Strat 
	FROM
		(SELECT INV_ID AS ID_Combined
		, PMT_Division
		, PMT_Strategy
		, INV_Managing_Team
		, INV_Managing_SubTeam
		, SUM(PMT_Strategy_Allocation_Amt) AS PMT_Strategy_Allocation_Amt 
		, ROW_NUMBER() OVER (PARTITION BY INV_ID ORDER BY INV_ID ASC) ChangeIndex
	FROM [dbo].[Investment_Payment]
	WHERE 1=1 AND [PMT_Status] = 'Paid' AND INV_ID IS NOT NULL AND PMT_Division<>'Unknown'
	Group By INV_ID 
		, PMT_Division
		, PMT_Strategy
		, INV_Managing_Team
		, INV_Managing_SubTeam) MULTI_STRAT_DET
	Group By MULTI_STRAT_DET.ID_Combined
	HAVING Count(*)>1) AS MULTI_STRAT
	ON INV_PYMT.ID_Combined=MULTI_STRAT.ID_Combined

--Paid to Date
LEFT JOIN (
			SELECT [INV_ID] AS ID_Combined, SUM([PMT_Strategy_Allocation_Amt]) as [Amt_Paid_To_Date],
			ROW_NUMBER() OVER (PARTITION BY INV_ID ORDER BY INV_ID ASC) ChangeIndex
			FROM [dbo].[Investment_Payment] WITH (NoLock)
			WHERE 1=1 AND [PMT_Status] = 'Paid' AND INV_ID IS NOT NULL 
			GROUP BY [INV_ID]	
		  ) ptd
	ON INV_PYMT.ID_Combined = ptd.ID_Combined
LEFT JOIN 
(

	SELECT 
	STUFF
	(
		(	SELECT DISTINCT
				' | '
				+CASE WHEN PMT_INITIATIVE ='' THEN 'No Initiative' ELSE PMT_INITIATIVE END
			FROM Investment_Payment
			WHERE INV_ID = tid.INV_ID AND INV_Managing_SubTeam <>'' 
			FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'
		),1,3,''

	) ManagedBy,

	STUFF
	(
		(	
		SELECT FundedSTR
		FROM
			(
				SELECT DISTINCT
					' | '
					+PMT_STRATEGY
					+'-'
					+CASE WHEN PMT_INITIATIVE ='' THEN 'No Initiative' ELSE PMT_INITIATIVE END 
					+' $'+PARSENAME(CONVERT(VARCHAR,SUM(CONVERT(MONEY,PMT_Strategy_Allocation_Amt)) OVER (PARTITION BY INV_ID,PMT_Strategy,PMT_Initiative ),1),2) FundedSTR,
					SUM(CONVERT(MONEY,PMT_Strategy_Allocation_Amt)) OVER (PARTITION BY INV_ID,PMT_Strategy,PMT_Initiative ) OrderSum

				FROM Investment_Payment
				WHERE INV_ID = tid.INV_ID AND PMT_STRATEGY <>'' 
			) FundedList
		ORDER BY OrderSum DESC
		FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'
				
		),1,3,''

	) FundedBy,
	INV_ID from Investment_Payment tid
	WHERE INV_ID=@ID_Combined
)SRC on SRC.INV_ID=@ID_Combined

WHERE 1=1
GROUP BY
      INV_PYMT.ID_Combined 
      ,INV_PYMT.PMT_Division
      ,INV_PYMT.PMT_Strategy
	  ,INV_PYMT.INV_Managing_Team
	  ,INV_PYMT.INV_Managing_SubTeam
	  ,INV_PYMT.INV_Managing_Team_Level_3
	  ,INV_PYMT.INV_Managing_Team_Level_4
      ,INV_PYMT.INV_Grantee_Vendor_Name
      ,INV_PYMT.INV_Title
      ,INV_PYMT.INV_Description
      ,INV_PYMT.INV_Owner
	  ,INV_PYMT.INV_Start_Date
      ,INV_PYMT.INV_End_Date
	  ,CY.Performance_Against_Milestones
	  ,CY.PAM_BGColor
	  ,PY.Performance_Against_Milestones
	  ,PY.PAM_BGColor
	  ,PTY.Performance_Against_Milestones
	  ,PTY.PAM_BGColor
	  ,CY.Reinvestment_Prospects
	  ,CY.RP_BGColor
	  ,PY.Reinvestment_Prospects
	  ,PY.RP_BGColor
	  ,PTY.Reinvestment_Prospects
	  ,PTY.RP_BGColor
	  ,CY.Performance_Against_Strategy
	  ,CY.PAS_BGColor
	  ,PY.Performance_Against_Strategy
	  ,PY.PAS_BGColor
	  ,PTY.Performance_Against_Strategy
	  ,PTY.PAS_BGColor
	  ,CY.Relative_Strategic_Importance
	  ,CY.RSI_BGColor
	  ,PY.Relative_Strategic_Importance
	  ,PY.RSI_BGColor
	  ,PTY.Relative_Strategic_Importance
	  ,PTY.RSI_BGColor
	  ,ManagedBy
	  ,FundedBy
	  ,CY.Rationale
	  ,CY.Key_Results_Data
	  ,CY.Funding_Team_Input
	  ,ISNULL(MULTI_STRAT.Multi_Strat,0)
	  --,Top_Bot_Perf.flag

END