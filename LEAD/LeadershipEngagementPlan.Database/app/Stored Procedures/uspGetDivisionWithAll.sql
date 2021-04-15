
-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/20/2016
-- Description:	Get Division
-- =============================================
CREATE PROCEDURE [app].[uspGetDivisionWithAll]
AS
BEGIN

	SELECT [Id], [GroupName]
		FROM (	SELECT 0 'Id', ' --- All ---' 'GroupName', 0 'GroupDisplaySortSequence'
				UNION
				SELECT [Id], [GroupName], [GroupDisplaySortSequence]
					FROM [dbo].[SysGroup]
					WHERE [Status] =1
						AND [RequestingTeam] = 1 ) a
		ORDER BY [GroupDisplaySortSequence];

END;