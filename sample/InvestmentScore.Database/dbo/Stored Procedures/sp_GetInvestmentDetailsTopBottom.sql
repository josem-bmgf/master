CREATE PROCEDURE [dbo].[sp_GetInvestmentDetailsTopBottom]
		@Top5		NVARCHAR(100),
		@Bot5		NVARCHAR(100)
	
						 		 
AS

/*******************************************************************************
Author:		Alvin John Apilan
Created Date:	August 31, 2017
Description:	Get the list of Investments
Usage:
	

[dbo].[sp_GetInvestmentDetailsTopBottom]
 '1|OPP1017337,2|OPP1017378,3|?OPP1128932,4|OPP1068045,5|?OPP1033514'
,'1|?OPP1107312,2|OPP1054163,3|OPP1136821,4|OPP1137901,5|OPP1136804'

GO

Changed By		Date		Description 
--------------------------------------------------------------------------------
Alvin John Apilan		8/31/2017	Initial draft
Alvin John Apilan		9/05/2017   Updated criteria for INV_END_DATE 
Alvin John Apilan		9/07/2017   US 144772 Added ReportValue for Scoring Year in Detailed Slide
Alvin John Apilan		9/18/2017   [Defect 144947]: Display Investments even not under the selected Division and Strategy but display 0 amount in Total Statement Allocation 
Marlon Ho				10/06/2017	US 145604 paging implementation
Marlon Ho				10/10/2017	Bug 146043 T5/B5 page number skips when invalid INV ID is input
Darwin Baluyot			10/9/2017	Bug 146053 Addressed issue on inconsistent results when entered invesment id contains space
Darwin Baluyot			11/14/2017	US 146501:	Added filter to exclude specific investments
Karla Tuazon			01/03/2018  ZD62425: Change the current year to 2017
Jake Harry Chavez		10/14/2018	US 166719: Applied changes from Investment Summary Report
Jake Harry Chavez		10/23/2018	US 166719: Removed unnecessary filter
Jake Harry Chavez		11/01/2018	US 168057: Updated header title
Jonson Villanueva		05/14/2021  BUG 36640:	Resolve Stored Procedures in IST database related to exclude flag change
*******************************************************************************/
BEGIN

Declare @ScoringYear AS INT = 0

--KCT: Set current year to 2017
SET @ScoringYear= CASE WHEN MONTH(GETDATE())>=6 THEN YEAR(GETDATE()) ELSE YEAR(GETDATE())-1  END


DECLARE @tmpInvestmentSummary AS TABLE (
		RowNumber Int
		,ID_Combined NVARCHAR(max)
		,PMT_Division  NVARCHAR(100)
		,PMT_Strategy  NVARCHAR(100)
		,INV_Managing_Team  NVARCHAR(100)
		,INV_Managing_SubTeam  NVARCHAR(100)
		,INV_Managing_Team_Level_3  NVARCHAR(100)
		,INV_Managing_Team_Level_4  NVARCHAR(100)
		,INV_Grantee_Vendor_Name  NVARCHAR(255)
		,INV_Title  NVARCHAR(MAX)
		,INV_Description  NVARCHAR(MAX)
		,INV_Owner  NVARCHAR(MAX)
		,INV_Start_Date DATETIME
		,INV_End_Date DATETIME      
		,Total_Investment_Amount MONEY
		,ThisYearPerfAgainstExecution NVARCHAR(100)
		,ThisYearPerfAgainstExecBGColor NVARCHAR(100)
		,LastYearPerfAgainstExecution NVARCHAR(100)
		,LastYearPerfAgainstExecBGColor NVARCHAR(100)
		,LastTwoYearPerfAgainstExecution NVARCHAR(100)
		,LastTwoYearPerfAgainstExecBGColor NVARCHAR(100)
		,ThisYearReinvestmentProspects NVARCHAR(100)
		,ThisYearReinvestmentProsBGColor NVARCHAR(100)
		,LastYearReinvestmentProspects NVARCHAR(100)
		,LastYearReinvestmentProsBGColor NVARCHAR(100)
		,LastTwoYearReinvestmentProspects NVARCHAR(100)
		,LastTwoYearReinvestmentProsBGColor NVARCHAR(100)
		,ThisYearPerfAgainstStrategy NVARCHAR(100)
		,ThisYearPerfAgainstStratBGColor NVARCHAR(100)
		,LastYearPerfAgainstStrategy NVARCHAR(100)
		,LastYearPerfAgainstStratBGColor NVARCHAR(100)
		,LastTwoYearPerfAgainstStrategy NVARCHAR(100)
		,LastTwoYearPerfAgainstStratBGColor NVARCHAR(100)
		,ThisYearRelStratImpt NVARCHAR(100)
		,ThisYearRelStratImptBGColor NVARCHAR(100)
		,LastYearRelStratImpt NVARCHAR(100)
		,LastYearRelStratImptBGColor NVARCHAR(100)
		,LastTwoYearRelStratImpt NVARCHAR(100)
		,LastTwoYearRelStratImptBGColor NVARCHAR(100)
		,Top_Performer BIT
		,Bottom_Performer BIT
		,Multi_Strat BIT
		,Rationale NVARCHAR(MAX)
		,Key_Results_Data NVARCHAR(MAX)
		,Funding_Team_Input NVARCHAR(MAX)
		,Amt_Paid_To_Date MONEY
		,INV_Order INT
		,FundedBy						 NVARCHAR (MAX)
		,ManagedBy					 NVARCHAR (MAX))

INSERT INTO @tmpInvestmentSummary
SELECT DISTINCT
	  INV_PYMT.RowNumber AS PageNumber
      ,INV_PYMT.ID_Combined
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
	  ,ThisYearPerfAgainstExecution.Performance_Against_Milestones AS ThisYearPerfAgainstExecution
	  ,ThisYearPerfAgainstExecution.BGColor AS ThisYearPerfAgainstExecBGColor
	  ,LastYearPerfAgainstExecution.Performance_Against_Milestones AS LastYearPerfAgainstExecution
	  ,LastYearPerfAgainstExecution.BGColor AS LastYearPerfAgainstExecBGColor
	  ,LastTwoYearPerfAgainstExecution.Performance_Against_Milestones AS LastTwoYearPerfAgainstExecution
	  ,LastTwoYearPerfAgainstExecution.BGColor AS LastTwoYearPerfAgainstExecBGColor
	  ,ThisYearReinvestmentProspects.Reinvestment_Prospects AS ThisYearReinvestmentProspects
	  ,ThisYearReinvestmentProspects.BGColor AS ThisYearReinvestmentProsBGColor
	  ,LastYearReinvestmentProspects.Reinvestment_Prospects AS LastYearReinvestmentProspects
	  ,LastYearReinvestmentProspects.BGColor AS LastYearReinvestmentProsBGColor
	  ,LastTwoYearReinvestmentProspects.Reinvestment_Prospects AS LastTwoYearReinvestmentProspects
	  ,LastTwoYearReinvestmentProspects.BGColor AS LastTwoYearReinvestmentProsBGColor
	  ,ThisYearPerfAgainstStrategy.Performance_Against_Strategy AS ThisYearPerfAgainstStrategy
	  ,ThisYearPerfAgainstStrategy.BGColor AS ThisYearPerfAgainstStratBGColor
	  ,LastYearPerfAgainstStrategy.Performance_Against_Strategy AS LastYearPerfAgainstStrategy
	  ,LastYearPerfAgainstStrategy.BGColor AS LastTwoYearPerfAgainstStratBGColor
	  ,LastTwoYearPerfAgainstStrategy.Performance_Against_Strategy AS LastTwoYearPerfAgainstStrategy
	  ,LastTwoYearPerfAgainstStrategy.BGColor AS LastYearPerfAgainstStratBGColor
	  ,ThisYearRelStratImpt.Relative_Strategic_Importance AS ThisYearRelStratImpt
	  ,ThisYearRelStratImpt.BGColor AS ThisYearRelStratImptBGColor
	  ,LastYearRelStratImpt.Relative_Strategic_Importance AS LastYearRelStratImpt
	  ,LastYearRelStratImpt.BGColor AS LastYearRelStratImptBGColor
	  ,LastTwoYearRelStratImpt.Relative_Strategic_Importance AS LastTwoYearRelStratImpt
	  ,LastTwoYearRelStratImpt.BGColor AS LastTwoYearRelStratImptBGColor
	  ,ISNULL(INV_PYMT.Top_Performer,0) AS Top_Performer
	  ,ISNULL(INV_PYMT.Bottom_Performer,0) AS Bottom_Performer
	  ,ISNULL(MULTI_STRAT.Multi_Strat,0) AS Multi_Strat
	  ,INV_Scoring.Rationale
	  ,INV_Scoring.Key_Results_Data
	  ,INV_Scoring.Funding_Team_Input
	  ,MAX(ISNULL(ptd.[Amt_Paid_To_Date],0)) as [Amt_Paid_To_Date]
	  ,OrderGroup AS INV_Order
	  ,''
	  ,''
 FROM (
 SELECT
		DetailedSlide.RowNumber
       ,CASE 
			WHEN NULLIF(LTRIM(RTRIM(ISNULL(INV_ID,''))),'') IS NULL 
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
	  ,Top_Performer
	  ,Bottom_Performer
	  ,OrderGroup
 FROM Investment_Payment WITH (NoLock) 
      INNER JOIN (
				SELECT
					ROW_NUMBER() OVER (ORDER By a.OrderGroup, a.Rowid) AS RowNumber
					,a.OrderGroup
					,a.Item
					,a.RowGroup
					,a.Top_Performer
					,a.Bottom_Performer
				FROM (SELECT TOP 5 
							Min(CONVERT(INT,SUBSTRING(Item, 0, CHARINDEX('|', Item)))) AS Rowid
							,LTRIM(RTRIM(SUBSTRING(Item, CHARINDEX('|', Item) + 1, LEN(Item)))) AS Item 
							,1 AS OrderGroup
							,'Top Performing' AS 'RowGroup' 
							,1 AS Top_Performer
							,0 AS Bottom_Performer
					 FROM [dbo].[ufn_Split] (@Top5,',')
					 INNER JOIN Investment INV
					 ON LTRIM(RTRIM(SUBSTRING(Item, CHARINDEX('|', Item) + 1, LEN(Item)))) = INV.ID_Combined
					 WHERE ISNULL(INV.Is_Deleted,0) != 1
						AND ISNULL(SUBSTRING(Item, CHARINDEX('|', Item) + 1, LEN(Item)),'')<>''
					 GROUP BY SUBSTRING(Item, CHARINDEX('|', Item) + 1, LEN(Item))
					 ORDER BY Min(CONVERT(INT,SUBSTRING(Item, 0, CHARINDEX('|', Item))))

					 UNION ALL

					 SELECT TOP 5 
							Min(CONVERT(INT,SUBSTRING(Item, 0, CHARINDEX('|', Item)))) AS Rowid
							,LTRIM(RTRIM(SUBSTRING(Item, CHARINDEX('|', Item) + 1, LEN(Item)))) AS Item
							,2 AS OrderGroup
							,'Bottom Performing' AS 'RowGroup' 
							,0 AS Top_Performer
							,1 AS Bottom_Performer
					 FROM [dbo].[ufn_Split] (@Bot5,',')
					 INNER JOIN Investment INV
					 ON LTRIM(RTRIM(SUBSTRING(Item, CHARINDEX('|', Item) + 1, LEN(Item)))) = INV.ID_Combined
					 WHERE ISNULL(INV.Is_Deleted,0) != 1
						AND ISNULL(SUBSTRING(Item, CHARINDEX('|', Item) + 1, LEN(Item)),'')<>''
					 GROUP BY SUBSTRING(Item, CHARINDEX('|', Item) + 1, LEN(Item))
					 ORDER BY Min(CONVERT(INT,SUBSTRING(Item, 0, CHARINDEX('|', Item))))) AS a
					 INNER JOIN (	SELECT Distinct
										CASE 
											WHEN NULLIF(LTRIM(RTRIM(ISNULL(INV_ID,''))),'') IS NULL 
												THEN CPT_GATEWAY_ID
										ELSE INV_ID
										END AS ID_Combined 
									FROM Investment_Payment WITH (NoLock)	)  AS INV_PAY
					 ON a.Item=INV_PAY.ID_Combined) AS DetailedSlide
				  ON (CASE WHEN NULLIF(LTRIM(RTRIM(ISNULL(INV_ID,''))),'') IS NULL 
								THEN CPT_GATEWAY_ID
								ELSE INV_ID
							   END) = DetailedSlide.Item
				 GROUP BY
						DetailedSlide.RowNumber
					   ,CASE WHEN NULLIF(LTRIM(RTRIM(ISNULL(INV_ID,''))),'') IS NULL 
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
					  ,CAST(INV_Start_Date AS Date) 
					  ,CAST(INV_End_Date AS Date)
					  ,Sys_INV_URL
					  ,DetailedSlide.Top_Performer
					  ,DetailedSlide.Bottom_Performer
					  ,DetailedSlide.OrderGroup
				 ) AS INV_PYMT

 --Performance Against Execution
 LEFT JOIN (SELECT *
              FROM (SELECT ID_Combined					
					, (	CASE 
							WHEN Is_Excluded=1
								THEN 'EXCLUDED'
							WHEN Performance_Against_Milestones IN ( SELECT Name FROM Dimension_Values ) 
								THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv 
										WHERE vInv.Performance_Against_Milestones = dv.Name)
							ELSE LTRIM(RTRIM(SUBSTRING(Performance_Against_Milestones,CharIndex('- ',LTRIM(Performance_Against_Milestones))+1,LEN(Performance_Against_Milestones)))) 
						END ) AS Performance_Against_Milestones
					,CASE 
						WHEN Is_Excluded=1 
							THEN ''
						ELSE
							LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Performance_Against_Milestones)),0,(CharIndex('- ',Performance_Against_Milestones))))) 
					 END AS BGColor
					, ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
                      FROM vInvestmentScoringReporting_preMigration vInv
			         WHERE (Objective = '.Overall' OR COALESCE(Objective, '') = '') 
			           AND Score_Year = @ScoringYear )  tmp
			 WHERE ChangeIndex = 1 ) ThisYearPerfAgainstExecution
   ON INV_PYMT.ID_Combined = ThisYearPerfAgainstExecution.ID_Combined  

 LEFT JOIN (SELECT *
              FROM (SELECT ID_Combined				
				, (	CASE 
						WHEN Is_Excluded=1
								THEN 'EXCLUDED'
						WHEN Performance_Against_Milestones IN ( SELECT Name FROM Dimension_Values ) 
					       THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Performance_Against_Milestones = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Performance_Against_Milestones,CharIndex('- ',LTRIM(Performance_Against_Milestones))+1,LEN(Performance_Against_Milestones)))) 
					END ) AS Performance_Against_Milestones
				,CASE 
					WHEN Is_Excluded=1 
						THEN ''
					ELSE
						LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Performance_Against_Milestones)),0,(CharIndex('- ',Performance_Against_Milestones))))) 
				 END AS BGColor
				, ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
                    FROM vInvestmentScoringReporting_preMigration vInv
			        WHERE (Objective = '.Overall' OR COALESCE(Objective, '') = '') 
			        AND Score_Year = (@ScoringYear-1)  )  tmp
			 WHERE ChangeIndex = 1 ) LastYearPerfAgainstExecution
   ON INV_PYMT.ID_Combined = LastYearPerfAgainstExecution.ID_Combined  
  LEFT JOIN (SELECT *
              FROM (SELECT ID_Combined				
				, (	CASE 
						WHEN Is_Excluded=1
								THEN 'EXCLUDED'
						WHEN Performance_Against_Milestones IN ( SELECT Name FROM Dimension_Values ) 
					       THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Performance_Against_Milestones = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Performance_Against_Milestones,CharIndex('- ',LTRIM(Performance_Against_Milestones))+1,LEN(Performance_Against_Milestones)))) 
					END ) AS Performance_Against_Milestones
				,CASE 
					WHEN Is_Excluded=1 
						THEN ''
					ELSE
						LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Performance_Against_Milestones)),0,(CharIndex('- ',Performance_Against_Milestones))))) 
				 END AS BGColor
				, ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
                    FROM vInvestmentScoringReporting_preMigration vInv
			        WHERE (Objective = '.Overall' OR COALESCE(Objective, '') = '') 
			        AND Score_Year = (@ScoringYear-2)  )  tmp
			 WHERE ChangeIndex = 1 ) LastTwoYearPerfAgainstExecution
   ON INV_PYMT.ID_Combined = LastTwoYearPerfAgainstExecution.ID_Combined  
	--Reinvestment Prospects
  LEFT JOIN (SELECT *
               FROM (SELECT ID_Combined			
				, (	CASE 
						WHEN Is_Excluded=1
								THEN 'EXCLUDED'
						WHEN Reinvestment_Prospects IN ( SELECT Name FROM Dimension_Values ) 
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Reinvestment_Prospects = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Reinvestment_Prospects,CharIndex('- ',LTRIM(Reinvestment_Prospects))+1,LEN(Reinvestment_Prospects)))) 
					END) AS Reinvestment_Prospects
				,CASE 
					WHEN Is_Excluded=1 
						THEN ''
					ELSE
						LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Reinvestment_Prospects)),0,(CharIndex('- ',Reinvestment_Prospects))))) 
				 END AS BGColor
				,ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
						FROM vInvestmentScoringReporting_preMigration vInv
						WHERE (Objective = '.Overall' OR COALESCE(Objective, '') = '') 
                        AND Score_Year = @ScoringYear)  tmp
              WHERE ChangeIndex = 1)  ThisYearReinvestmentProspects
   ON INV_PYMT.ID_Combined = ThisYearReinvestmentProspects.ID_Combined 
     
	 LEFT JOIN (SELECT *
               FROM (SELECT ID_Combined				
				, (	CASE 
						WHEN Is_Excluded=1
								THEN 'EXCLUDED'
						WHEN Reinvestment_Prospects IN ( SELECT Name FROM Dimension_Values ) 
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Reinvestment_Prospects = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Reinvestment_Prospects,CharIndex('- ',LTRIM(Reinvestment_Prospects))+1,LEN(Reinvestment_Prospects)))) 
					END) AS Reinvestment_Prospects
				,CASE 
					WHEN Is_Excluded=1 
						THEN ''
					ELSE
						LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Reinvestment_Prospects)),0,(CharIndex('- ',Reinvestment_Prospects))))) 
				 END AS BGColor
				,ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
                       FROM vInvestmentScoringReporting_preMigration vInv
                      WHERE (Objective = '.Overall' OR COALESCE(Objective, '') = '') 
                        AND Score_Year = @ScoringYear-1)  tmp
              WHERE ChangeIndex = 1)  LastYearReinvestmentProspects
   ON INV_PYMT.ID_Combined = LastYearReinvestmentProspects.ID_Combined 

    LEFT JOIN (SELECT *
               FROM (SELECT ID_Combined				
				, (	CASE 
						WHEN Is_Excluded=1
								THEN 'EXCLUDED'
						WHEN Reinvestment_Prospects IN ( SELECT Name FROM Dimension_Values ) 
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Reinvestment_Prospects = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Reinvestment_Prospects,CharIndex('- ',LTRIM(Reinvestment_Prospects))+1,LEN(Reinvestment_Prospects)))) 
					END) AS Reinvestment_Prospects
				,CASE 
					WHEN Is_Excluded=1 
						THEN ''
					ELSE
						LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Reinvestment_Prospects)),0,(CharIndex('- ',Reinvestment_Prospects))))) 
				 END AS BGColor
				,ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
                       FROM vInvestmentScoringReporting_preMigration vInv
                      WHERE (Objective = '.Overall' OR COALESCE(Objective, '') = '') 
                        AND Score_Year = @ScoringYear-2)  tmp
              WHERE ChangeIndex = 1)  LastTwoYearReinvestmentProspects
   ON INV_PYMT.ID_Combined = LastTwoYearReinvestmentProspects.ID_Combined 

   --Performance_Against_Strategy
   LEFT JOIN (SELECT *
               FROM (SELECT ID_Combined					
					, (	CASE 
							WHEN Is_Excluded=1
								THEN 'EXCLUDED'
							WHEN Performance_Against_Strategy IN ( SELECT Name FROM Dimension_Values ) 
								THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Performance_Against_Strategy = dv.Name)
						   ELSE LTRIM(RTRIM(SUBSTRING(Performance_Against_Strategy,CharIndex('- ',LTRIM(Performance_Against_Strategy))+1,LEN(Performance_Against_Strategy)))) 
						END ) AS Performance_Against_Strategy
					,CASE 
						WHEN Is_Excluded=1 
							THEN ''
						ELSE
							LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Performance_Against_Strategy)),0,(CharIndex('- ',Performance_Against_Strategy))))) 
					 END AS BGColor
					, ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
                       FROM vInvestmentScoringReporting_preMigration vInv
                      WHERE (Objective = '.Overall' OR COALESCE(Objective, '') = '') 
                        AND Score_Year = @ScoringYear)  tmp
              WHERE ChangeIndex = 1)  ThisYearPerfAgainstStrategy
   ON INV_PYMT.ID_Combined = ThisYearPerfAgainstStrategy.ID_Combined 
     
	LEFT JOIN (SELECT *
               FROM (SELECT ID_Combined					
					, (CASE 
							WHEN Is_Excluded=1
								THEN 'EXCLUDED'
							WHEN Performance_Against_Strategy IN ( SELECT Name FROM Dimension_Values ) 
								THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Performance_Against_Strategy = dv.Name)
							ELSE LTRIM(RTRIM(SUBSTRING(Performance_Against_Strategy,CharIndex('- ',LTRIM(Performance_Against_Strategy))+1,LEN(Performance_Against_Strategy)))) 
						END) AS Performance_Against_Strategy
					,CASE 
						WHEN Is_Excluded=1 
							THEN ''
						ELSE
							LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Performance_Against_Strategy)),0,(CharIndex('- ',Performance_Against_Strategy))))) 
					 END AS BGColor
					, ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
                       FROM vInvestmentScoringReporting_preMigration vInv
                      WHERE (Objective = '.Overall' OR COALESCE(Objective, '') = '') 
                        AND Score_Year = @ScoringYear-1)  tmp
              WHERE ChangeIndex = 1)  LastYearPerfAgainstStrategy
   ON INV_PYMT.ID_Combined = LastYearPerfAgainstStrategy.ID_Combined 

   LEFT JOIN (SELECT *
               FROM (SELECT ID_Combined					
					, (CASE 
							WHEN Is_Excluded=1
								THEN 'EXCLUDED'
							WHEN Performance_Against_Strategy IN ( SELECT Name FROM Dimension_Values ) 
								THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Performance_Against_Strategy = dv.Name)
							ELSE LTRIM(RTRIM(SUBSTRING(Performance_Against_Strategy,CharIndex('- ',LTRIM(Performance_Against_Strategy))+1,LEN(Performance_Against_Strategy)))) 
						END) AS Performance_Against_Strategy
					,CASE 
						WHEN Is_Excluded=1 
							THEN ''
						ELSE
							LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Performance_Against_Strategy)),0,(CharIndex('- ',Performance_Against_Strategy))))) 
					 END AS BGColor
					, ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
                       FROM vInvestmentScoringReporting_preMigration vInv
                      WHERE (Objective = '.Overall' OR COALESCE(Objective, '') = '') 
                        AND Score_Year = @ScoringYear-2)  tmp
              WHERE ChangeIndex = 1)  LastTwoYearPerfAgainstStrategy
   ON INV_PYMT.ID_Combined = LastTwoYearPerfAgainstStrategy.ID_Combined 

   -- Relative Strategic Importance


      LEFT JOIN (SELECT *
               FROM (SELECT ID_Combined					
					,(CASE 
						WHEN Is_Excluded=1
							THEN 'EXCLUDED'
						WHEN Relative_Strategic_Importance IN ( SELECT Name FROM Dimension_Values ) 
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Relative_Strategic_Importance = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Relative_Strategic_Importance,CharIndex('- ',LTRIM(Relative_Strategic_Importance))+1,LEN(Relative_Strategic_Importance)))) 
					 END ) AS Relative_Strategic_Importance
					,CASE 
						WHEN Is_Excluded=1 
							THEN ''
						ELSE
							LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Relative_Strategic_Importance)),0,(CharIndex('- ',Relative_Strategic_Importance))))) 
					 END AS BGColor
					, ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
                       FROM vInvestmentScoringReporting_preMigration vInv
                      WHERE (Objective = '.Overall' OR COALESCE(Objective, '') = '') 
                        AND Score_Year = @ScoringYear)  tmp
              WHERE ChangeIndex = 1)  ThisYearRelStratImpt
   ON INV_PYMT.ID_Combined = ThisYearRelStratImpt.ID_Combined 
     
	LEFT JOIN (SELECT *
               FROM (SELECT ID_Combined					
					,(CASE 
						WHEN Is_Excluded=1
							THEN 'EXCLUDED'
						WHEN Relative_Strategic_Importance IN ( SELECT Name FROM Dimension_Values ) 
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Relative_Strategic_Importance = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Relative_Strategic_Importance,CharIndex('- ',LTRIM(Relative_Strategic_Importance))+1,LEN(Relative_Strategic_Importance)))) 
					 END ) AS Relative_Strategic_Importance
					,CASE 
						WHEN Is_Excluded=1 
							THEN ''
						ELSE
							LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Relative_Strategic_Importance)),0,(CharIndex('-',Relative_Strategic_Importance))))) 
					 END AS BGColor
					, ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
                       FROM vInvestmentScoringReporting_preMigration vInv
                      WHERE (Objective = '.Overall' OR COALESCE(Objective, '') = '') 
                        AND Score_Year = @ScoringYear-1)  tmp
              WHERE ChangeIndex = 1)  LastYearRelStratImpt
   ON INV_PYMT.ID_Combined = LastYearRelStratImpt.ID_Combined 

   LEFT JOIN (SELECT *
               FROM (SELECT ID_Combined					
					,(CASE 
						WHEN Is_Excluded=1
							THEN 'EXCLUDED'
						WHEN Relative_Strategic_Importance IN ( SELECT Name FROM Dimension_Values ) 
							THEN (SELECT TOP 1 ReportValue FROM Dimension_Values dv WHERE vInv.Relative_Strategic_Importance = dv.Name)
						ELSE LTRIM(RTRIM(SUBSTRING(Relative_Strategic_Importance,CharIndex('- ',LTRIM(Relative_Strategic_Importance))+1,LEN(Relative_Strategic_Importance)))) 
					 END ) AS Relative_Strategic_Importance
					,CASE 
						WHEN Is_Excluded=1 
							THEN ''
						ELSE
							LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(Relative_Strategic_Importance)),0,(CharIndex('-',Relative_Strategic_Importance))))) 
					 END AS BGColor
					, ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
                       FROM vInvestmentScoringReporting_preMigration vInv
                      WHERE (Objective = '.Overall' OR COALESCE(Objective, '') = '') 
                        AND Score_Year = @ScoringYear-2)  tmp
              WHERE ChangeIndex = 1)  LastTwoYearRelStratImpt
   ON INV_PYMT.ID_Combined = LastTwoYearRelStratImpt.ID_Combined 
--Scoring
LEFT JOIN (	SELECT * FROM 	
		(SELECT	DISTINCT ID_Combined
				,Score_Year
				,Rationale
				,Key_Results_Data
				,Funding_Team_Input
				,ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
		FROM	dbo.vInvestmentScoringReporting_preMigration 
	WHERE Score_Year=@ScoringYear) Tmp
	WHERE  ChangeIndex=1) AS INV_Scoring
ON INV_PYMT.ID_Combined=INV_Scoring.ID_Combined

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
			WHERE 1=1 AND [PMT_Status] = 'Paid' AND INV_ID IS NOT NULL --AND INV_ID = '26001'
			GROUP BY [INV_ID]	
		  ) ptd
	ON INV_PYMT.ID_Combined = ptd.ID_Combined

WHERE 1=1
GROUP BY
	  INV_PYMT.RowNumber
      ,INV_PYMT.ID_Combined 
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
	  ,ThisYearPerfAgainstExecution.Performance_Against_Milestones
	  ,ThisYearPerfAgainstExecution.BGColor
	  ,LastYearPerfAgainstExecution.Performance_Against_Milestones
	  ,LastYearPerfAgainstExecution.BGColor
	  ,LastTwoYearPerfAgainstExecution.Performance_Against_Milestones
	  ,LastTwoYearPerfAgainstExecution.BGColor
	  ,ThisYearReinvestmentProspects.Reinvestment_Prospects
	  ,ThisYearReinvestmentProspects.BGColor
	  ,LastYearReinvestmentProspects.Reinvestment_Prospects
	  ,LastYearReinvestmentProspects.BGColor
	  ,LastTwoYearReinvestmentProspects.Reinvestment_Prospects
	  ,LastTwoYearReinvestmentProspects.BGColor
	  ,ThisYearPerfAgainstStrategy.Performance_Against_Strategy
	  ,ThisYearPerfAgainstStrategy.BGColor
	  ,LastYearPerfAgainstStrategy.Performance_Against_Strategy
	  ,LastYearPerfAgainstStrategy.BGColor
	  ,LastTwoYearPerfAgainstStrategy.Performance_Against_Strategy
	  ,LastTwoYearPerfAgainstStrategy.BGColor
	  ,ThisYearRelStratImpt.Relative_Strategic_Importance
	  ,ThisYearRelStratImpt.BGColor
	  ,LastYearRelStratImpt.Relative_Strategic_Importance
	  ,LastYearRelStratImpt.BGColor
	  ,LastTwoYearRelStratImpt.Relative_Strategic_Importance
	  ,LastTwoYearRelStratImpt.BGColor
	  ,INV_Scoring.Rationale
	  ,INV_Scoring.Key_Results_Data
	  ,INV_Scoring.Funding_Team_Input
	  ,INV_PYMT.Top_Performer
	  ,INV_PYMT.Bottom_Performer
	  ,ISNULL(MULTI_STRAT.Multi_Strat,0)
	  ,INV_PYMT.OrderGroup


	UPDATE tmpInvDetails
	SET 
		 tmpInvDetails.ManagedBy=SRC.ManagedBy
		,tmpInvDetails.FundedBy=SRC.FundedBy
	FROM @tmpInvestmentSummary tmpInvDetails

	LEFT JOIN 
	(

		SELECT 
		STUFF
		(
			(	SELECT DISTINCT
					' | '
					+CASE WHEN PMT_INITIATIVE ='' THEN 'No Initiative' ELSE PMT_INITIATIVE END
				FROM Investment_Payment
				WHERE INV_ID = tid.ID_COMBINED AND INV_Managing_SubTeam <>'' 
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
					WHERE INV_ID = tid.ID_COMBINED AND PMT_STRATEGY <>'' 
				) FundedList
			ORDER BY OrderSum DESC
			FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'
				
			),1,3,''

		) FundedBy,
		ID_COMBINED from @tmpInvestmentSummary tid
	)SRC on tmpInvDetails.ID_COMBINED=SRC.ID_COMBINED

SELECT * FROM @tmpInvestmentSummary
ORDER BY RowNumber ASC

END