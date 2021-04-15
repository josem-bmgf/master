-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/20/2016
-- Description:	Get Team by Division (SysGroupFk)
-- =============================================
CREATE PROCEDURE [app].[uspGetTeamBySysGroupFk]
(
	 @SysGroupFk INT
)
AS
BEGIN

SELECT 0 'Id', ' --- Select ---' 'Team'
UNION
SELECT [Id], [Team]
	FROM [dbo].[Team]
	WHERE [Status] =1
		AND [SysGroupFk] =  @SysGroupFk
	ORDER BY [Team];

END;