-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/20/2016
-- Description:	Get Division
-- =============================================
CREATE PROCEDURE [app].[uspGetDivisionById]
(
	@SysGroupFk INT
)
AS
BEGIN

	SELECT [Id], [GroupName]
		FROM (	SELECT 0 'Id', ' --- Select ---' 'GroupName', 0 'GroupDisplaySortSequence'
				UNION
				SELECT [Id], [GroupName], [GroupDisplaySortSequence]
					FROM [dbo].[SysGroup]
					WHERE (@SysGroupFK = 1000 AND [Status] = 1 AND [Id] > 0)
							 OR
						  (@SysGroupFK = 1001 AND [Status] = 1 AND [Id] != 1000 AND [Id] > 0)
						     OR
						  (@SysGroupFK = [Id])  
			) a
		ORDER BY [GroupDisplaySortSequence];

END;