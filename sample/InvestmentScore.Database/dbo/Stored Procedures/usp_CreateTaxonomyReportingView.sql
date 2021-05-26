-- =============================================
-- Author:		Marc Peco
-- Create date: 08/16/2017
-- Description:	Drops and recreates the taxonomy reporting view
-- =============================================
CREATE PROCEDURE [dbo].[usp_CreateTaxonomyReportingView]
AS

DECLARE @cols AS NVARCHAR(MAX),
        @query  AS NVARCHAR(MAX);

SET @cols = STUFF((SELECT distinct ',' + QUOTENAME(REPLACE (ti.[Name],' ' ,'_')) 
            FROM Taxonomy_Items ti
			WHERE ti.[IsNumeric] = 1
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

DROP VIEW IF EXISTS [dbo].[vTaxonomyReporting];

set @query = '
CREATE VIEW [dbo].[vTaxonomyReporting]
	AS
SELECT inv.[ID]
      ,inv.[ID_Combined]
      ,inv.[INV_Grantee_Vendor_Name]
      ,inv.[INV_Type]
      ,inv.[INV_Status]
      ,inv.[INV_Title]
      ,inv.[INV_Owner]
      ,inv.[INV_Manager]
      ,inv.[INV_Start_Date]
      ,inv.[INV_End_Date]
      ,inv.[INV_Level_of_Engagement]
      ,inv.[Total_Investment_Amount]
      ,inv.[Amt_Paid_To_Date]
      ,inv.[INV_Description]
      ,inv.[Managing_Team_Level_1]
      ,inv.[Managing_Team_Level_2]
      ,inv.[Managing_Team_Level_3]
      ,inv.[Managing_Team_Level_4]
      ,inv.[PMT_Expenditure_Type]
      ,inv.[Funding_Type]
      ,inv.[OPP_Closed_Date]
	  , ' + @cols + '  
FROM Investment inv
LEFT JOIN (	SELECT 	
			ItemLabel = REPLACE (i.[Name],'' '' ,''_''),
			Allocation = ISNULL(v.Numeric_Value,0),
			Investment_ID			
		FROM Taxonomy_Categories c
		INNER JOIN Taxonomy_Items i
			ON c.Id = i.Taxonomy_Category_Id
		INNER JOIN  Taxonomy_Values v
			ON i.Id = v.Taxonomy_Item_ID			
		WHERE i.IsActive = 1
		  AND c.IsActive = 1  
		 
		) p
  PIVOT
  (
	MAX([Allocation])
	FOR [ItemLabel] in (' + @cols + ')
            ) p 
	ON inv.ID = p.Investment_ID'

execute(@query)

RETURN 0
