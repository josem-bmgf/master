-- =============================================
-- Author:		Kirk Encarnacion
-- Create date: 07/14/2016
-- Description:	Get Country 
-- =============================================
CREATE PROCEDURE [dbo].[usp_Get_CountryAvailable]

AS
BEGIN
	SELECT [ID], [Country] 
	FROM [dbo].[Country]
		WHERE [Status] = 1 and [Country] in (Select [Country] from [app].[vEngagement])
		ORDER BY [Country]
END;