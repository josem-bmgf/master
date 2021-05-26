
CREATE VIEW [dbo].[vTaxonomyTotals]
	AS
SELECT
	i.ID_Combined
	,[Category] = tc.[Name]
	--,[Sub_Category] = tq.[Name]
	,[Total_Allocation] = SUM(ta.Numeric_Value)
FROM  dbo.Taxonomy_Values ta
	INNER JOIN Investment i
		ON i.ID = ta.Investment_ID
	INNER JOIN dbo.Taxonomy_Items tq
		ON ta.Taxonomy_Item_ID = tq.ID
	INNER JOIN dbo.Taxonomy_Categories tc
		ON tq.Taxonomy_Category_ID = tc.ID
WHERE tc.IsActive = 1
AND tq.IsActive = 1
GROUP BY i.ID_Combined, tc.Name