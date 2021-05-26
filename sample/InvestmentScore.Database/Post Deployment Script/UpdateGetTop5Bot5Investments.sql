ALTER PROCEDURE [dbo].[sp_GetTop5Bot5Investments]
		@Division	NVARCHAR(100),
		@Strategy	NVARCHAR(100),			  
		@Top5		NVARCHAR(100),
		@Bot5		NVARCHAR(100)
		
AS
BEGIN


/*******************************************************************************
=============================================
 Author:		Alvin John Apilan
 Create date: 08/03/2017
 Description:	For Payments
=============================================
 Usage:

 [dbo].[sp_GetTop5Bot5Investments]
'Global Development'
,'MNCH'
,'1-OPP1126866,2-OPP1158362,3-,4-,5-'
,'1-OPP1126866,2-OPP1158362'

 [dbo].[sp_GetTop5Bot5Investments]
'Global Development'
,'MNCH'
,'1|OPP1158362,2|?OPP1126866,3|OPP1109329,4|OPP1114237,5|OPP1155842'
,'1|?OPP1158362,2|OPP1126866'
GO
 

 Alvin John Apilan 	8/1/2017	Initial Version
 Alvin John Apilan 	8/24/2017	Added INV_Managing_Team and INV_Managing_SubTeam in WHERE Clause
 Alvin/Marlon		8/28/2017   Changed INV_Total_Payout_Amt and PMT_Strategy_Allocation_Amt from NVARCHAR to Money
 Alvin John Apilan	9/05/2017   Updated criteria for INV_END_DATE 
 Alvin John Apilan	9/18/2017   [Defect 144947]: Display Investments even not under the selected Division and Strategy but display 0 amount in Total Statement Allocation 
 Marlon Ho			10/06/2017	US 145604 paging implementation
 Marlon Ho			10/10/2017	Bug 146043 T5/B5 page number skips when invalid INV ID is input
 Darwin Baluyot		10/9/2017	Bug 146053 Addressed issue on inconsistent results when entered invesment id contains space
 Darwin Baluyot		11/14/2017	US 146501:	Added filter to exclude specific investments
 Karla Tuazon		01/03/2018  ZD62425: Change the current year to 2017
 Jake Harry Chavez	10/14/2018	US 166719: Applied changes from Investment Summary Report
 Jake Harry Chavez	10/23/2018	US 166719: Adjustment due to scope change: Added Is_Excluded in Summary Slides
*******************************************************************************/
	

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @ScoringYear AS INT = 0

--KCT: Set current year to 2017
SET @ScoringYear= CASE WHEN MONTH(GETDATE())>=11 THEN YEAR(GETDATE()) ELSE YEAR(GETDATE())-1  END

DECLARE @tmpInvestments AS TABLE (
	  RowNumber Int
	  ,RowGroup NVARCHAR(100)
	  ,ID_Combined NVARCHAR(max)
	  ,PMT_Division NVARCHAR(100)	  
	  ,PMT_Strategy NVARCHAR(100)	  
	  ,INV_Managing_Team NVARCHAR(100)	  
	  ,INV_Managing_SubTeam NVARCHAR(100)	  
	  ,INV_Grantee_Vendor_Name NVARCHAR(MAX)
	  ,INV_Title NVARCHAR(MAX)	  
	  ,INV_Description NVARCHAR(MAX)
	  ,INV_Total_Payout_Amt Money
	  ,PMT_Strategy_Allocation_Amt Money	 	  
	  ,HyperlinkURL NVARCHAR(MAX)
	  ,TopOrder NVARCHAR(100)
	  ,ExecutionPerformance NVARCHAR(100)
	  ,StrategyPerformance NVARCHAR(100)
 	  ,Relative_Strategic_Importance NVARCHAR(220)
	  ,INV_Owner NVARCHAR(4000)
	  ,Category NVARCHAR(23)
	  ,INV_Start_Date                 DATETIME 
	  ,INV_End_Date                   DATETIME
	  ,Is_Excluded	BIT
	  )
INSERT INTO @tmpInvestments
SELECT
	  Top5.RowNumber AS PageNumber	
	  ,Top5.RowGroup
       ,CASE 
			WHEN NULLIF(LTRIM(RTRIM(ISNULL(INV_ID,''))),'') IS NULL 
				THEN CPT_GATEWAY_ID
            ELSE INV_ID
			END ID_Combined
      ,PMT_Division
      ,PMT_Strategy
	  ,INV_Managing_Team
	  ,INV_Managing_SubTeam
      ,Investment_Payment.INV_Grantee_Vendor_Name
      ,Investment_Payment.INV_Title
      ,Investment_Payment.INV_Description      	 
      ,MIN(ISNULL(INV_Total_Payout_Amt,0)) INV_Total_Payout_Amt
	  ,SUM(CASE 
				WHEN  PMT_Division = @Division AND PMT_Strategy =@Strategy
					THEN PMT_Strategy_Allocation_Amt
				ELSE 0
			END) PMT_Strategy_Allocation_Amt
	  ,Sys_INV_URL as 	  HyperlinkURL
	  ,NULL AS TopOrder
	  ,NULL AS ExecutionPerformance
	  ,NULL AS StrategyPerformance
	  ,NULL AS Relative_Strategic_Importance
	  ,Investment_Payment.INV_Owner
	  ,CASE 
		WHEN PMT_Division = @Division AND INV_Managing_Team = @Division and PMT_Strategy = @Strategy AND INV_Managing_SubTeam = @Strategy
			THEN 'Managed and Funded'
		WHEN PMT_Division = @Division AND PMT_Strategy=@Strategy
			THEN 'Funded'
		WHEN INV_Managing_Team = @Division AND INV_Managing_SubTeam = @Strategy
			THEN 'Managed'
		END Category
	  ,Investment_Payment.INV_Start_Date
	  ,Investment_Payment.INV_End_Date
	  ,Is_Excluded
FROM Investment_Payment 
INNER JOIN
(
SELECT ROW_NUMBER() OVER (ORDER By CASE WHEN RowGroup = 'Top Performing' THEN 0 ELSE 1 END, Rowid) AS RowNumber,  * 
FROM
	(SELECT TOP 5 
		Min(CONVERT(INT,SUBSTRING(Item, 0, CHARINDEX('|', Item)))) AS Rowid
		,LTRIM(RTRIM(SUBSTRING(Item, CHARINDEX('|', Item) + 1, LEN(Item)))) AS Item 
		,1 AS OrderGroup
		, 'Top Performing' AS 'RowGroup' 
	FROM [dbo].[ufn_Split] (@Top5,',')
	INNER JOIN Investment INV
	ON LTRIM(RTRIM(SUBSTRING(Item, CHARINDEX('|', Item) + 1, LEN(Item)))) = INV.ID_Combined
	WHERE ISNULL(INV.Is_Deleted,0) != 1
		AND ISNULL(SUBSTRING(Item, CHARINDEX('|', Item) + 1, LEN(Item)),'')<>''
	GROUP BY SUBSTRING(Item, CHARINDEX('|', Item) + 1, LEN(Item))
	Order By Min(CONVERT(INT,SUBSTRING(Item, 0, CHARINDEX('|', Item))))

	UNION ALL

	SELECT TOP 5 
		Min(CONVERT(INT,SUBSTRING(Item, 0, CHARINDEX('|', Item))))AS Rowid
		,LTRIM(RTRIM(SUBSTRING(Item, CHARINDEX('|', Item) + 1, LEN(Item)))) AS Item
		,2 AS OrderGroup
		,'Bottom Performing' AS 'RowGroup' 
	FROM [dbo].[ufn_Split] (@Bot5,',')
	INNER JOIN Investment INV
	ON LTRIM(RTRIM(SUBSTRING(Item, CHARINDEX('|', Item) + 1, LEN(Item)))) = INV.ID_Combined
	WHERE ISNULL(INV.Is_Deleted,0) != 1
		AND ISNULL(SUBSTRING(Item, CHARINDEX('|', Item) + 1, LEN(Item)),'')<>''
	GROUP BY SUBSTRING(Item, CHARINDEX('|', Item) + 1, LEN(Item))
	Order By Min(CONVERT(INT,SUBSTRING(Item, 0, CHARINDEX('|', Item))))) AS a
	INNER JOIN (	SELECT Distinct
						CASE 
							WHEN NULLIF(LTRIM(RTRIM(ISNULL(INV_ID,''))),'') IS NULL 
								THEN CPT_GATEWAY_ID
						ELSE INV_ID
						END AS ID_Combined 
					FROM Investment_Payment WITH (NoLock)	)  AS INV_PAY
	ON a.Item=INV_PAY.ID_Combined
	) AS Top5
			ON (CASE WHEN NULLIF(LTRIM(RTRIM(ISNULL(INV_ID,''))),'') IS NULL 
                THEN CPT_GATEWAY_ID
                ELSE INV_ID
			   END) = Top5.Item
LEFT JOIN
(
SELECT *
FROM vInvestmentScoringReporting 
WHERE Score_Year=@ScoringYear
) sc ON sc.ID_Combined=top5.ID_Combined

 GROUP BY
      Top5.RowNumber
	  ,Top5.RowGroup
	  ,CASE 
			WHEN NULLIF(LTRIM(RTRIM(ISNULL(INV_ID,''))),'') IS NULL 
				THEN CPT_GATEWAY_ID
            ELSE INV_ID
			END 
      ,PMT_Division
      ,PMT_Strategy
	  ,INV_Managing_Team
	  ,INV_Managing_SubTeam
      ,Investment_Payment.INV_Grantee_Vendor_Name
      ,Investment_Payment.INV_Title
      ,Investment_Payment.INV_Description     
	  ,CAST(Investment_Payment.INV_Start_Date AS Date) 
      ,CAST(Investment_Payment.INV_End_Date AS Date)
	  ,Sys_INV_URL
	  ,Investment_Payment.INV_Owner
	  ,CASE 
		WHEN PMT_Division = @Division AND PMT_Strategy=@Strategy
			THEN 'Funded'
		WHEN INV_Managing_Team = @Division AND INV_Managing_SubTeam = @Strategy
			THEN 'Managed'
		WHEN PMT_Division = @Division AND INV_Managing_Team = @Division and PMT_Strategy = @Strategy AND INV_Managing_SubTeam = @Strategy
			THEN 'Managed and Funded'
		END 
	  ,Investment_Payment.INV_Start_Date
	  ,Investment_Payment.INV_End_Date
	  ,Is_Excluded
--SET Performance Results
	UPDATE	@tmpInvestments
	SET		ExecutionPerformance			= PerfAgainstResult.Performance_Against_Milestones
			,StrategyPerformance			= PerfAgainstResult.Performance_Against_Strategy 
			,Relative_Strategic_Importance	=  PerfAgainstResult.Relative_Strategic_Importance
	FROM @tmpInvestments Investment_Payment

	--Performance Against Execution
	 LEFT JOIN (SELECT 
					ID_Combined
					,Performance_Against_Strategy
					,Performance_Against_Milestones
					,Relative_Strategic_Importance
				  FROM (SELECT 
							ID_Combined
							,Performance_Against_Strategy
							,Performance_Against_Milestones
							,Relative_Strategic_Importance
							,ROW_NUMBER() OVER (PARTITION BY ID_Combined ORDER BY Score_Date DESC) ChangeIndex
						 FROM vInvestmentScoringReporting
						 WHERE (Objective = '.Overall' OR COALESCE(Objective, '') = '') 
						 --KCT: Set current year to 2017
						   AND Score_Year = @ScoringYear)  tmp
				 WHERE ChangeIndex = 1 ) PerfAgainstResult
	   ON Investment_Payment.ID_Combined = PerfAgainstResult.ID_Combined


SELECT * FROM @tmpInvestments
ORDER BY RowNumber ASC
END