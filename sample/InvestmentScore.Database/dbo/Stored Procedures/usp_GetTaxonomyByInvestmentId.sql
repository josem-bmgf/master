-- =============================================
-- Author:		Marc Peco
-- Create date: 08/08/2017
-- Description:	Stored procedure to retrieve data for taxonomy tabs
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetTaxonomyByInvestmentId]
	-- Add the parameters for the stored procedure here
	@investmentId int = 0
AS
BEGIN
		SET NOCOUNT ON;
		SELECT 
			Id =  CONCAT(c.Id, '-', i.Id ,'-',@investmentId),
			CategoryId = c.Id, 
			ItemId = i.Id,  
			ItemLabel = i.Label,  
			ItemSort = i.SortOrder,
			ValueId = v.Id,
			Allocation =   ISNULL(v.Numeric_Value,0),
			Comment = v.[Value],
			IsAllocation = i.[IsNumeric]
		FROM Taxonomy_Categories c
		LEFT JOIN Taxonomy_Items i
			ON c.Id = i.Taxonomy_Category_Id
		LEFT JOIN Taxonomy_Values v
			ON v.investment_id = @investmentId
			AND i.Id = v.Taxonomy_Item_ID
		WHERE i.IsActive = 1
		  AND c.IsActive = 1  
		Order By c.Id, i.SortOrder

END

GO
