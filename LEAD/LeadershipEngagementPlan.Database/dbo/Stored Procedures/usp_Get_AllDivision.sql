-- =============================================
-- Author:		Kirk Encarnacion
-- Create date: 07/14/2016
-- Description:	Get Division
-- =============================================
CREATE PROCEDURE [dbo].[usp_Get_AllDivision]
AS
BEGIN

	SELECT [Id], [GroupName]
		FROM ( SELECT [Id], [GroupName], [GroupDisplaySortSequence]
					FROM [dbo].[SysGroup]
					WHERE [Status] =1
						AND [RequestingTeam] = 1 ) a
		ORDER BY [GroupDisplaySortSequence];

END;