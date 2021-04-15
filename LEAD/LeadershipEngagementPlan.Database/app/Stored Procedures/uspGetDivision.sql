-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/20/2016
-- Description:	Get Division
-- =============================================
CREATE PROCEDURE [app].[uspGetDivision]
AS
BEGIN

	SELECT [Id], [GroupName]
		FROM (	SELECT 0 'Id', ' --- Select ---' 'GroupName', 0 'GroupDisplaySortSequence'
				UNION
				SELECT [Id], [GroupName], [GroupDisplaySortSequence]
					FROM [dbo].[SysGroup]
					WHERE [Status] =1
						AND [RequestingTeam] = 1 ) a
		ORDER BY [GroupDisplaySortSequence];

END;