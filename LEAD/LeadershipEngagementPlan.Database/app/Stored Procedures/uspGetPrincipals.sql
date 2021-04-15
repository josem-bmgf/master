-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/26/2016
-- Description:	Get list of Leaders
-- =============================================
CREATE PROCEDURE [app].[uspGetPrincipals]
AS
BEGIN

SELECT CAST(0 as bit) 'Selected'
      ,[ShortName] 'Principal'
	  ,[Id]
	FROM [dbo].[Leader]
	WHERE 1=1
		AND [Status]=1
		AND [Id] > 0
	ORDER BY [DisplaySortSequence], [ShortName];

END;