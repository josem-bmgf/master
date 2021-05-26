CREATE VIEW [dbo].[vInvestmentScores]

	AS

WITH AllScores
AS
(
		SELECT * 
		FROM
		(
			SELECT 
				ROW_NUMBER() OVER (PARTITION BY Investment_ID,Score_Year ORDER BY Score_Date DESC) RowNumber
				,src.*
				,ScoredBy.EmployeeID ScoredBy
				,ModifiedBy.EmployeeID ModifiedBy 
			FROM Scores src WITH (NOLOCK)
			
			LEFT JOIN dbo.[User] AS ScoredBy WITH (NOLOCK)
			ON src.Scored_By_ID = ScoredBy.id

			LEFT JOIN dbo.[User] ModifiedBy WITH (NOLOCK)
			ON src.Modified_By_ID = ModifiedBy.ID
			
		) scr
		WHERE RowNumber=1
		
),
DSA_ImpactPerformance
 AS
(
SELECT      'Blue - Investment exceeds impact targets'									   Performance_Against_Strategy
		   ,'Exceeds Expectations'														   ICT_Performance_Against_Strategy
UNION ALL 
SELECT		'Blue - Strong Fit'															   Performance_Against_Strategy
		   ,'Exceeds Expectations'														   ICT_Performance_Against_Strategy
UNION ALL 
SELECT		'Green - Investment meets impact targets'									   Performance_Against_Strategy
		   ,'Meets Expectations'														   ICT_Performance_Against_Strategy
UNION ALL 
SELECT		'Green - Good Fit'															   Performance_Against_Strategy
		   ,'Meets Expectations'														   ICT_Performance_Against_Strategy
UNION ALL 
SELECT		'Yellow - Investment partially meets impact targets'                           Performance_Against_Strategy
		   ,'Slightly Below Expectations'                                                  ICT_Performance_Against_Strategy
UNION ALL 
SELECT      'Yellow - Weak Fit'															   Performance_Against_Strategy
		   ,'Slightly Below Expectations'												   ICT_Performance_Against_Strategy
UNION ALL 
SELECT		'Red - Investment does not meet impact targets'								   Performance_Against_Strategy
		   ,'Below Expectations'														   ICT_Performance_Against_Strategy
UNION ALL 
SELECT      'Red - No Longer a Fit'														   Performance_Against_Strategy
		   ,'Below Expectations'														   ICT_Performance_Against_Strategy
UNION ALL 
SELECT	    'Black - Too soon to evaluate investment’s progress (<6 months active)'        Performance_Against_Strategy
		   ,'Too Early to Tell'                                                            ICT_Performance_Against_Strategy
UNION ALL
SELECT      'Black - Too Soon'                                                             Performance_Against_Strategy
		   ,'Too Early to Tell'                                                            ICT_Performance_Against_Strategy

),
DSA_ExecutionPerformance
AS
(
SELECT		'Blue - Investment exceeds expectations'										Performance_Against_Milestones
		   ,'Exceeds Expectations'															ICT_Performance_Against_Milestones
UNION ALL 
SELECT      'Blue - Exceeding Expectations'													Performance_Against_Milestones
		   ,'Exceeds Expectations'															ICT_Performance_Against_Milestones
UNION ALL  
SELECT      'Green - Investment meets expectations'											Performance_Against_Milestones
           ,'Meets Expectations'															ICT_Performance_Against_Milestones
UNION ALL	
SELECT      'Green  - Meeting Expectations'													Performance_Against_Milestones
           ,'Meets Expectations'															ICT_Performance_Against_Milestones
UNION ALL 
SELECT      'Yellow - Investment partially meets expectations'								Performance_Against_Milestones
           ,'Slightly Below Expectations'													ICT_Performance_Against_Milestones
UNION ALL  
SELECT      'Yellow - Slightly Off Track'													Performance_Against_Milestones
           ,'Slightly Below Expectations'													ICT_Performance_Against_Milestones
UNION ALL  
SELECT      'Red - Investment does not meet expectations'									Performance_Against_Milestones
           ,'Below Expectations'															ICT_Performance_Against_Milestones
UNION ALL  
SELECT      'Red - Not Meeting Expectations'												Performance_Against_Milestones
           ,'Below Expectations'															ICT_Performance_Against_Milestones
UNION ALL  
SELECT      'Black - Too soon to evaluate investment’s progress (<6 months active)'			Performance_Against_Milestones
			,'Too Early to Tell'															ICT_Performance_Against_Milestones
UNION ALL  
SELECT		'Black - Too Soon'																Performance_Against_Milestones
			,'Too Early to Tell'															ICT_Performance_Against_Milestones
)
,CurrentScores
AS
(
		SELECT * 
		FROM
		(
			SELECT 
				ROW_NUMBER() OVER (PARTITION BY Investment_ID,Score_Year ORDER BY Score_Date DESC) RowNumber
				,* 
			FROM Scores	
		) scr
		WHERE RowNumber=1
		AND Score_Year= CASE WHEN MONTH(GETDATE())>=6 THEN YEAR(GETDATE()) ELSE YEAR(GETDATE())-1  END
), 

CteInvestmentScores
AS
(SELECT 
		  
		
		  [Investment_Number__c] = CAST(INV_PMT.ID_Combined AS NVARCHAR(255))
		, [Status__c] = INV_PMT.INV_Status
		, [Type__c] = INV_PMT.INV_Type
		, [Investment_Description__c] = CAST(INV_PMT.INV_Description AS NVARCHAR(MAX))
		, [Investment_Grantee_Vendor_Name__c] = CAST(INV_PMT.INV_Grantee_Vendor_Name AS NVARCHAR(255))
		, [Investment_Title__c] = CAST(INV_PMT.INV_Title AS NVARCHAR(255))
		, [Investment_Owner__c] = CAST(INV_PMT.INV_Owner AS NVARCHAR(255))
		, [Managing_Strategy_Path__c] = CAST(ISNULL(INV_PMT.Managing_Team_Level_1,'')
										+ CASE WHEN ISNULL(INV_PMT.Managing_Team_Level_2,'')='' THEN '' ELSE '\'+ INV_PMT.Managing_Team_Level_2 END
										+ CASE WHEN ISNULL(INV_PMT.Managing_Team_Level_3,'')='' THEN '' ELSE '\'+ INV_PMT.Managing_Team_Level_3 END
										+ CASE WHEN ISNULL(INV_PMT.Managing_Team_Level_4,'')='' THEN '' ELSE '\'+ INV_PMT.Managing_Team_Level_4 END AS NVARCHAR(255))
		, [Total_Commitment__c] = CAST(MAX(ISNULL(INV_PMT.INV_Total_Payout_Amt,0)) AS MONEY)
		, [Paid_to_Date__c] = CAST(MAX(ISNULL(PTD.Amt_Paid_To_Date,0)) AS MONEY)
		, [Remaining_Balance__c] = CAST(MAX(ISNULL(INV_PMT.INV_Total_Payout_Amt,0)) - MAX(ISNULL(PTD.Amt_Paid_To_Date,0)) AS MONEY)
		, [Investment_Start_Date__c] = CAST(INV_PMT.INV_Start_Date AS DATE)
		, [Investment_End_Date__c] = CAST(INV_PMT.INV_End_Date AS DATE)
		, [Investment_Funding_Detail__c] = CAST(STUFF
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

						FROM Investment_Payment WITH (NOLOCK)
						WHERE INV_ID = INV_PMT.ID_Combined AND  PMT_STRATEGY <>'' 
					) FundedList
				ORDER BY OrderSum DESC
				FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'
				
				),1,3,''

			) AS NVARCHAR(MAX))
		, [Investment_ID] = INV_PMT.ID
		
		
	FROM (SELECT 
			INV_PMT.PMT_Division
			, INV_PMT.PMT_Strategy
			, MIN(ISNULL(INV_PMT.INV_Total_Payout_Amt,0))	AS INV_Total_Payout_Amt
			, INV.ID
			, INV.ID_Combined AS ID_Combined
			, INV.INV_Status
			, INV.INV_Type
			, INV.INV_Description
			, INV.INV_Grantee_Vendor_Name
			, INV.INV_Title
			, INV.INV_Owner
			, INV.Managing_Team_Level_1
			, INV.Managing_Team_Level_2
			, INV.Managing_Team_Level_3
			, INV.Managing_Team_Level_4
			, INV.INV_Start_Date
			, INV.INV_End_Date
			FROM [dbo].[Investment_Payment] INV_PMT WITH (NOLOCK)	
			
			INNER JOIN [dbo].[Investment] INV WITH (NOLOCK)
			ON INV_PMT.INV_ID = INV.ID_Combined
					
			WHERE
				ISNULL(INV.Is_Deleted,0) != 1
		
				
			GROUP BY
			INV_PMT.PMT_Division
			, INV_PMT.PMT_Strategy
			, INV.ID
			, INV.ID_Combined 
			, INV.INV_Status
			, INV.INV_Type
			, INV.INV_Description
			, INV.INV_Grantee_Vendor_Name
			, INV.INV_Title
			, INV.INV_Owner
			, INV.Managing_Team_Level_1
			, INV.Managing_Team_Level_2
			, INV.Managing_Team_Level_3
			, INV.Managing_Team_Level_4
			, INV.INV_Start_Date
			, INV.INV_End_Date
			) INV_PMT 
	

			--Paid to Date
	LEFT JOIN (
		SELECT
			[INV_ID] AS ID_Combined
			,SUM([PMT_Strategy_Allocation_Amt]) AS [Amt_Paid_To_Date]
			,ROW_NUMBER() OVER (PARTITION BY INV_ID ORDER BY INV_ID ASC) ChangeIndex
		FROM [dbo].[Investment_Payment] WITH (NOLOCK)
		WHERE [PMT_Status] = 'Paid' AND INV_ID IS NOT NULL
		GROUP BY [INV_ID]	
	) PTD
		ON INV_PMT.ID_Combined = PTD.ID_Combined	

	GROUP BY
		
		 INV_PMT.ID_Combined 
		, INV_PMT.INV_Status
		, INV_PMT.INV_Type
		, INV_PMT.INV_Description
		, INV_PMT.INV_Grantee_Vendor_Name
		, INV_PMT.INV_Title
		, INV_PMT.INV_Owner
		, ISNULL(INV_PMT.Managing_Team_Level_1,'')
		+ CASE WHEN ISNULL(INV_PMT.Managing_Team_Level_2,'')='' THEN '' ELSE '\'+ INV_PMT.Managing_Team_Level_2 END
		+ CASE WHEN ISNULL(INV_PMT.Managing_Team_Level_3,'')='' THEN '' ELSE '\'+ INV_PMT.Managing_Team_Level_3 END
		+ CASE WHEN ISNULL(INV_PMT.Managing_Team_Level_4,'')='' THEN '' ELSE '\'+ INV_PMT.Managing_Team_Level_4 END
		, INV_PMT.INV_Start_Date
		, INV_PMT.INV_End_Date
		, INV_PMT.ID		

)

SELECT 

		  [Investment_Number__c] 
		, [Year__c] = CAST(Scores.Score_Year AS Numeric(4,0))
		, [Status__c] 
		, [Type__c] 
		, [Impact_Performance__c] = CAST(DIP.ICT_Performance_Against_Strategy AS NVARCHAR(255))
		, [Execution_Performance__c] = CAST(DEP.ICT_Performance_Against_Milestones AS NVARCHAR(255))
		, [Reinvestment_Prospects__c] = CAST(Scores.Reinvestment_Prospects AS NVARCHAR(255))
		, [Managing_Team_Scoring_Rationale__c] = CAST(Scores.Rationale AS NVARCHAR(MAX))
		, [Investment_Description__c]
		, [Key_Results_and_Data__c] = CAST(Scores.Key_Results_Data AS NVARCHAR(MAX))
		, [Funding_Team_Input__c] = CAST(Scores.Funding_Team_Input AS NVARCHAR(MAX))
		, [Investment_Grantee_Vendor_Name__c]
		, [Investment_Title__c] 
		, [Investment_Owner__c] 
		, [Managing_Strategy_Path__c]
		, [Total_Commitment__c]
		, [Paid_to_Date__c]
		, [Remaining_Balance__c] 
		, [Investment_Start_Date__c] 
		, [Investment_End_Date__c] 
		, [Investment_Funding_Detail__c] 
		, [Investment_Score_External_ID__c] = CAST(CAST(Scores.Score_Year AS NVARCHAR(4))+'-'+Investment_Number__c AS NVARCHAR(255))  
		, [Scored_By__c] = Scores.ScoredBy 
		, [Scored_On__c] = ISNULL(Scores.Score_Date,'1900-01-01')
		, [Score_Modified_By__c] = Scores.ModifiedBy 
		, [Score_Modified_On__c] = ISNULL(Scores.Modified_On ,'1900-01-01')
		, [Is_Excluded__c] = Scores.Is_Excluded
FROM CteInvestmentScores cis
LEFT JOIN AllScores Scores 
	ON cis.[Investment_ID] = Scores.Investment_ID
	AND Scores.Score_Year IS NOT NULL
LEFT JOIN DSA_ImpactPerformance DIP
	ON Scores.Performance_Against_Strategy = DIP.Performance_Against_Strategy
LEFT JOIN DSA_ExecutionPerformance DEP
	ON Scores.Performance_Against_Milestones =  DEP.Performance_Against_Milestones
WHERE CAST(Scores.Score_Year AS Numeric(4,0)) <= CASE WHEN MONTH(GETDATE())>=6 THEN YEAR(GETDATE()) ELSE YEAR(GETDATE())-1 END
AND ISNULL(Is_Archived,0) = 0

UNION ALL

SELECT DISTINCT

		  [Investment_Number__c] 
		, [Year__c] = CASE WHEN MONTH(GETDATE())>=6 THEN YEAR(GETDATE()) ELSE YEAR(GETDATE())-1  END
		, [Status__c] 
		, [Type__c] 
		, [Impact_Performance__c] = NULL
		, [Execution_Performance__c] = NULL
		, [Reinvestment_Prospects__c] = NULL
		, [Managing_Team_Scoring_Rationale__c] = NULL
		, [Investment_Description__c]
		, [Key_Results_and_Data__c] = NULL
		, [Funding_Team_Input__c] = NULL
		, [Investment_Grantee_Vendor_Name__c]
		, [Investment_Title__c] 
		, [Investment_Owner__c] 
		, [Managing_Strategy_Path__c]
		, [Total_Commitment__c]
		, [Paid_to_Date__c]
		, [Remaining_Balance__c] 
		, [Investment_Start_Date__c] 
		, [Investment_End_Date__c] 
		, [Investment_Funding_Detail__c] 
		, [Investment_Score_External_ID__c]  = CAST(CASE WHEN MONTH(GETDATE())>=6 THEN YEAR(GETDATE()) ELSE YEAR(GETDATE())-1  END AS NVARCHAR(4)) +'-'+ [Investment_Number__c]
		, [Scored_By__c] = NULL
		, [Scored_On__c] = '1900-01-01'
		, [Score_Modified_By__c] = NULL
		, [Score_Modified_On__c] = '1900-01-01'
		, [Is_Excluded__c] = CurrentScores.Is_Excluded
FROM CteInvestmentScores cis
LEFT JOIN CurrentScores
	ON cis.Investment_ID = CurrentScores.Investment_ID
WHERE 
	CurrentScores.ID IS NULL
	 AND (
			cis.Status__c = 'Active'
			OR (
					cis.Status__c IN ('Closed', 'Cancelled', 'Inactive')
					AND YEAR(cis.Investment_End_Date__c) >= CASE WHEN MONTH(GETDATE())>=6 THEN YEAR(GETDATE()) ELSE YEAR(GETDATE())-1  END
				)
		 )