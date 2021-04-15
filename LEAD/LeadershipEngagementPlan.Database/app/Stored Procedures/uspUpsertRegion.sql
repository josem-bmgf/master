-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/26/2016
-- Description:	Update Region Table from Foundation domain.
-- =============================================
CREATE PROCEDURE [app].[uspUpsertRegion]
AS
BEGIN

MERGE [dbo].[Region] r
USING OPENROWSET('sqloledb','trusted_connection=yes;server=DWODSSQL01;database=SourceFoundationDomain',
				 'SELECT DISTINCT [RegionName]
					FROM [dbo].[Geography] 
					WHERE	[RegionName] IS NOT NULL 
						AND [ISOCountryName] IS NOT NULL
						AND EffectiveStartDate <= GETDATE()
						AND GETDATE() < EffectiveEndDate') dd
ON r.[Region] = dd.[RegionName]
WHEN MATCHED AND r.[Status] = 0 
	THEN UPDATE SET r.[Status] = 1
WHEN NOT MATCHED BY TARGET 
	THEN INSERT ([Region], [Status]) VALUES ([dbo].[ufnProperCase](dd.[RegionName]), 1)
WHEN NOT MATCHED BY SOURCE 
	THEN UPDATE SET r.[Status] = 0;

END;