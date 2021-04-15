-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/26/2016
-- Description:	Update Country Table from Foundation domain.
-- =============================================
CREATE PROCEDURE [app].[uspUpsertCountry]
AS
BEGIN

MERGE [dbo].[Country] c
USING (
		SELECT r.[Id] 'RegionFk', s.[ISOCountryName]
			FROM OPENROWSET('sqloledb','trusted_connection=yes;server=DWODSSQL01;database=SourceFoundationDomain',
					 'SELECT DISTINCT [RegionName],[ISOCountryName] 
						FROM [dbo].[Geography] 
						WHERE	[RegionName] IS NOT NULL 
							AND [ISOCountryName] IS NOT NULL
							AND EffectiveStartDate <= GETDATE()
							AND GETDATE() < EffectiveEndDate') s
			JOIN [dbo].[Region] r ON s.[RegionName] = r.[Region]
	  ) dd
ON c.[RegionFk] = dd.[RegionFk] AND c.[Country] = dd.[ISOCountryName]
WHEN MATCHED AND c.[Status] = 0 
	THEN UPDATE SET c.[Status] = 1
WHEN NOT MATCHED BY TARGET 
	THEN INSERT ([RegionFk], [Country], [Status]) VALUES (dd.[RegionFk], dd.[ISOCountryName], 1)
WHEN NOT MATCHED BY SOURCE 
	THEN UPDATE SET c.[Status] = 0;

END;