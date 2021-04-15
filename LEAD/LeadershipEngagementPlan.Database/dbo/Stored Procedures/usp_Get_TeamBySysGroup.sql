-- =============================================
-- Author:		Kirk Encarnacion
-- Create date: 07/14/2016
-- Description:	Get Team by Division (SysGroupFk)
-- =============================================
CREATE PROCEDURE [dbo].[usp_Get_TeamBySysGroup]
(
	 @SysGroupFk varchar(100)
)
AS
BEGIN

SELECT [Id], [Team]
	FROM [dbo].[Team]
	WHERE [Status] = 1
		AND [SysGroupFk] in (select Item from dbo.SplitString(@SysGroupFk,','))
	ORDER BY [Team];

END;