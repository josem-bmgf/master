CREATE VIEW [dbo].[vInvestment]
	AS 
SELECT 
	[ID_Combined] = i.[INV_ID]
	,i.[INV_Title]
	,i.[INV_Type]
	,i.[INV_Description]
	,i.[INV_Start_Date]
	,i.[INV_End_Date]
	,i.[INV_Status]
	,i.[INV_Grantee_Vendor_Name]
	,i.[INV_Level_Of_Engagement]
	,i.[INV_Owner]
	,i.[INV_Manager]
	,[Managing_Team_Level_1]= i.[INV_Managing_Team]
	,[Managing_Team_Level_2]=i.[INV_Managing_SubTeam]
	,[Managing_Team_Level_3]=i.[INV_Managing_Team_Level_3]
	,[Managing_Team_Level_4]=i.[INV_Managing_Team_Level_4]
	,i.[PMT_Expenditure_Type]
	,i.[OPP_Closed_Date]
	,ISNULL(MAX([INV_Total_Payout_Amt]),0)  as [Total_Investment_Amount]
	,ISNULL(ptd.[Amt_Paid_To_Date],0) as [Amt_Paid_To_Date]
FROM [dbo].[Investment_Payment] i with (nolock)
	LEFT JOIN (
			SELECT 
				[INV_ID]
				,ISNULL(SUM([PMT_Strategy_Allocation_Amt]),0) as [Amt_Paid_To_Date]
			FROM [dbo].[Investment_Payment] i 
			WHERE  i.[PMT_Status] = 'Paid' 
			GROUP BY	
				[INV_ID]	
	) ptd
	ON i.INV_ID = ptd.INV_ID
WHERE [PMT_Expenditure_Type] = 'DCE'
	AND 
	([INV_Status] ='Active' OR
		-- FOR CONTRACT
		(	
			[INV_TYPE] = 'Contract' 
			AND [INV_Status] in ('Closed','Cancelled', 'Inactive') 
			AND (DATEPART(Year, i.[INV_End_Date]) >= DATEPART(YEAR,GETDATE()))
		)
		OR 
		-- FOR OPPORTUNITY
		(	
			[INV_TYPE] IN ('Grant', 'Program Related Investment (PRI)')
			AND [INV_Status] in ('Closed') 
			AND (DATEPART(Year, i.[INV_End_Date]) >= DATEPART(YEAR,GETDATE()))
		)
	)
GROUP BY	
	i.[INV_ID]
	,i.[INV_Title]
	,i.[INV_Type]
	,i.[INV_Description]
	,i.[INV_Start_Date]
	,i.[INV_End_Date]
	,i.[INV_Status]
	,i.[INV_Grantee_Vendor_Name]
	,i.[INV_Level_of_Engagement]
	,i.[INV_Owner]
	,i.[INV_Manager]
	,i.[INV_Managing_Team]
	,i.[INV_Managing_SubTeam]
	,i.[INV_Managing_Team_Level_3]
	,i.[INV_Managing_Team_Level_4]
	,i.[PMT_Expenditure_Type]
	,ptd.[Amt_Paid_To_Date]
	,i.[OPP_Closed_Date]