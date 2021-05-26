CREATE PROCEDURE [dbo].[usp_RefreshInvestmentData]

AS
	
/*******************************************************************************
Author:		
Created Date:
Description:
Usage:
	
[dbo].[usp_RefreshInvestmentData]
GO

Changed By		Date		Description 
--------------------------------------------------------------------------------
Marlon Ho		10/13/2017	Add change history
							Bug 145876 Add Is_Deleted column
Jeremiah Sarte	10/16/2017	Add an additional criteria for the filter
							on Insert Part
Darwin Baluyot	11/14/2017	Add logic to update Is_Deleted flag for
							excluded investments
Karla Tuazon	01/03/2018  ZD62425: Change the current year to 2017
*******************************************************************************/
	
	 


	
	IF EXISTS(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Investment_Payment' AND TABLE_SCHEMA = 'dbo')
	AND (SELECT Count(*) FROM [dbo].[vInvestmentAll])>0 
	BEGIN
	MERGE INTO [dbo].[Investment] AS TGT
	USING (SELECT * FROM [dbo].[vInvestmentAll] WITH(nolock) WHERE ID_Combined IS NOT NULL)  AS SRC
	ON (ISNULL(TGT.ID_Combined,'UNKNOWN') = ISNULL(SRC.ID_Combined,'UNKNOWN'))
	
	WHEN MATCHED AND 
	(

	     ISNULL(TGT.[INV_Grantee_Vendor_Name],'') <> ISNULL(SRC.[INV_Grantee_Vendor_Name],'')
      OR ISNULL(TGT.[INV_Type],'') <> ISNULL(SRC.[INV_Type],'')
      OR ISNULL(TGT.[INV_Status],'') <> ISNULL(SRC.[INV_Status],'')
      OR ISNULL(TGT.[INV_Title],'') <> ISNULL(SRC.[INV_Title],'')
      OR ISNULL(TGT.[INV_Owner],'') <> ISNULL(SRC.[INV_Owner],'')
      OR ISNULL(TGT.[INV_Manager],'') <> ISNULL(SRC.[INV_Manager],'')
      OR ISNULL(TGT.[INV_Start_Date],'') <> ISNULL(SRC.[INV_Start_Date],'')
      OR ISNULL(TGT.[INV_End_Date],'') <> ISNULL(SRC.[INV_End_Date],'')
      OR ISNULL(TGT.[INV_Level_of_Engagement],'') <> ISNULL(SRC.[INV_Level_of_Engagement],'')
      OR ISNULL(TGT.[Total_Investment_Amount],0) <> ISNULL(SRC.[Total_Investment_Amount],0)
      OR ISNULL(TGT.[Amt_Paid_To_Date],0) <> ISNULL(SRC.[Amt_Paid_To_Date],0)
      OR ISNULL(TGT.[INV_Description],'') <> ISNULL(SRC.[INV_Description],'')
      OR ISNULL(TGT.[Managing_Team_Level_1],'') <> ISNULL(SRC.[Managing_Team_Level_1],'')
      OR ISNULL(TGT.[Managing_Team_Level_2],'') <> ISNULL(SRC.[Managing_Team_Level_2],'')
      OR ISNULL(TGT.[Managing_Team_Level_3],'') <> ISNULL(SRC.[Managing_Team_Level_3],'')
      OR ISNULL(TGT.[Managing_Team_Level_4],'') <> ISNULL(SRC.[Managing_Team_Level_4],'')
      OR ISNULL(TGT.[PMT_Expenditure_Type],'') <> ISNULL(SRC.[PMT_Expenditure_Type],'')
	  OR ISNULL(TGT.[OPP_Closed_Date],'') <> ISNULL(SRC.[OPP_Closed_Date],'')
	  OR ISNULL(TGT.[Is_Deleted],0) <> ISNULL(SRC.[Is_Deleted],0)
	)

	THEN UPDATE SET

	   TGT.[INV_Grantee_Vendor_Name] = SRC.[INV_Grantee_Vendor_Name]
      ,TGT.[INV_Type] = SRC.[INV_Type]
	  ,TGT.[INV_Status] = SRC.[INV_Status]
      ,TGT.[INV_Title] = SRC.[INV_Title]
      ,TGT.[INV_Owner] = SRC.[INV_Owner]
      ,TGT.[INV_Manager] = SRC.[INV_Manager]
      ,TGT.[INV_Start_Date] = SRC.[INV_Start_Date]
	  ,TGT.[INV_End_Date] = SRC.[INV_End_Date]
      ,TGT.[INV_Level_of_Engagement] = SRC.[INV_Level_of_Engagement]
      ,TGT.[Total_Investment_Amount] = SRC.[Total_Investment_Amount]
	  ,TGT.[Amt_Paid_To_Date] = SRC.[Amt_Paid_To_Date]
      ,TGT.[INV_Description] = SRC.[INV_Description]
      ,TGT.[Managing_Team_Level_1] = SRC.[Managing_Team_Level_1]
      ,TGT.[Managing_Team_Level_2] = SRC.[Managing_Team_Level_2]
      ,TGT.[Managing_Team_Level_3] = SRC.[Managing_Team_Level_3]
      ,TGT.[Managing_Team_Level_4] = SRC.[Managing_Team_Level_4]
      ,TGT.[PMT_Expenditure_Type] = SRC.[PMT_Expenditure_Type] 
	  ,TGT.[OPP_Closed_Date] = SRC.[OPP_Closed_Date] 
	  ,TGT.[Is_Deleted] = SRC.[Is_Deleted]
	  

	WHEN NOT MATCHED BY TARGET AND
		(
			SRC.[INV_Status] ='Active' 
			OR
			-- FOR CONTRACT
			(	
				SRC.[INV_TYPE] = 'Contract' 
				AND SRC.[INV_Status] in ('Closed','Cancelled', 'Inactive') 
				--KCT: Set current year to 2017
				AND (DATEPART(Year, SRC.[INV_End_Date]) >= '2017')
			)
			OR 
			-- FOR OPPORTUNITY
			(	
				SRC.[INV_TYPE] IN ('Grant', 'Program Related Investment (PRI)')
				AND SRC.[INV_Status] in ('Closed') 
				--KCT: Set current year to 2017
				AND (DATEPART(Year, SRC.[INV_End_Date]) >= '2017')
			)
		)
	THEN 
	INSERT
	(
	   [ID_Combined]
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
      ,[Old_Investment_ID]
      ,[Old_Investment_ID_MNF]
      ,[OPP_Closed_Date]
      ,[Is_Deleted]
	  )
	VALUES
	(
       Src.[ID_Combined]
      ,Src.[INV_Grantee_Vendor_Name]
      ,Src.[INV_Type]
	  ,Src.[INV_Status]
      ,Src.[INV_Title]
      ,Src.[INV_Owner]
      ,Src.[INV_Manager]
      ,Src.[INV_Start_Date]
	  ,Src.[INV_End_Date]
      ,Src.[INV_Level_of_Engagement]
      ,Src.[Total_Investment_Amount] 
      ,Src.[Amt_Paid_To_Date] 
      ,Src.[INV_Description] 
	  ,Src.[Managing_Team_Level_1]
      ,Src.[Managing_Team_Level_2]
      ,Src.[Managing_Team_Level_3]
      ,Src.[Managing_Team_Level_4]
      ,Src.[PMT_Expenditure_Type]	  
      ,NULL --AS [Funding_Type]
      ,NULL --AS [Old_Investment_ID]
      ,NULL --AS [Old_Investment_ID_MNF]
	  ,Src.[OPP_Closed_Date]
	  ,Src.Is_Deleted 
		


	)


		WHEN NOT MATCHED BY SOURCE AND TGT.[Is_Deleted]	= 0
		
			THEN
				UPDATE SET
					TGT.[Is_Deleted]	= 1;
	
	
	--Update Is_Deleted flag of excluded investments
	
	UPDATE Investment
	SET Investment.[Is_Deleted] = 1
	FROM Investment
	INNER JOIN Excluded_Investments
	ON Investment.[ID_Combined] = Excluded_Investments.[INV_ID]
	WHERE Investment.[Is_Deleted] = 0



	END