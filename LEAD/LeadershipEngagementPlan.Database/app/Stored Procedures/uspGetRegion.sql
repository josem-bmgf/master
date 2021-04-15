-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/20/2016
-- Description:	Get Geographic Region 
-- =============================================
CREATE PROCEDURE [app].[uspGetRegion]
AS
BEGIN

	SELECT [Id], [Region] 
		FROM (	SELECT 0 'Id', ' --- Select ---' [Region],  0 'DisplaySortSequence'
				UNION
				SELECT DISTINCT [Id], [dbo].[ufnProperCase]([Region]),  [DisplaySortSequence]
					FROM [dbo].[Region]
					WHERE [Status] =1
			  ) a
		ORDER BY [DisplaySortSequence], [Region];

END;