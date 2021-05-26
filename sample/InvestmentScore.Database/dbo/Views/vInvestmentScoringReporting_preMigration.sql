CREATE VIEW [dbo].[vInvestmentScoringReporting_preMigration]
	AS 

SELECT [ID_Combined]
      ,[INV_Grantee_Vendor_Name]
      ,[INV_Type]
      ,[INV_Status]
      ,[INV_Title]
      ,[INV_Owner]
      ,[INV_Manager]
      ,[INV_Start_Date]
      ,[INV_End_Date]
      ,[INV_Level_of_Engagement]
      ,[Total_Investment_Amount]
      ,[Amt_Paid_To_Date]
      ,[INV_Description]
      ,[Managing_Team_Level_1]
      ,[Managing_Team_Level_2]
      ,[Managing_Team_Level_3]
      ,[Managing_Team_Level_4]
      ,[PMT_Expenditure_Type]
      ,[Funding_Type]
	  ,[Performance_Against_Milestones]
      ,[Performance_Against_Strategy]
      ,[Reinvestment_Prospects]
      ,[Rationale]
      ,[Highest_Performing]
      ,[Lowest_Performing]
      ,[Exclude_from_Scoring]
      ,[Investment_ID]
      ,[Score_Date]
      ,[Score_Year]
      ,[User]
	  ,[On_Behalf_Of] = u.DisplayName
      ,[Objective]
	  ,[Relative_Strategic_Importance]
	  ,[Key_Results_Data]
	  ,[Funding_Team_Input]
	  ,[Is_Archived]
	  ,[Is_Excluded]
      ,[Is_Excluded_From_TOI]

  FROM [dbo].[Investment] i
  LEFT JOIN Scores s
  on s.Investment_ID = i.ID
  LEFT JOIN [User] u
  on s.Scored_By_ID = u.ID
  WHERE i.Is_Deleted=0 		
GO