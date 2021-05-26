CREATE VIEW [dbo].[vTaxonomy]
	AS
SELECT
	i.ID_Combined
	,[Category] = tc.[Name]
	,[Sub_Category] = tq.[Name]
	,[Percent_Allocation] = CONVERT(DECIMAL,ta.Numeric_Value)/100
FROM  dbo.Taxonomy_Values ta
	INNER JOIN Investment i
		ON i.ID = ta.Investment_ID
	INNER JOIN dbo.Taxonomy_Items tq
		ON ta.Taxonomy_Item_ID = tq.ID
	INNER JOIN dbo.Taxonomy_Categories tc
		ON tq.Taxonomy_Category_ID = tc.ID
WHERE tq.IsNumeric = 1