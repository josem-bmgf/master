-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/20/2016
-- Description:	Get Country by Geographic Region 
-- =============================================
CREATE PROCEDURE [app].[uspGetCountryByRegion]
(
	 @RegionFk INT
)
AS
BEGIN

	SELECT 0 'ID', '-Select-' 'Country'
	UNION
	SELECT [ID], [Country]
		FROM [dbo].[Country]
		WHERE [Status] =1
		  AND [RegionFk] = @RegionFk
		ORDER BY [Country]

END;