/*******************************************************************************
Author:				Darwin C. Baluyot
Created Date:		07/13/2017
Description:		Returns SysUser id that is either STAFF or CONTENT OWNER
Parameters:			@engagementId		- id of the current column (e.g. SELECT Id FROM dbo.Engagement)
					@sysuserType		- Specify if which SysUser Type is to be pulled out.
										- Staff(1000) or Content Owner(1001). Values may vary.

Execute:			[dbo].[ufnGetSysUserIdByEngagementId] ([dbo].[Engagement].[Id], 1000) ; This will only return id of STAFF from SysUser table
					[dbo].[ufnGetSysUserIdByEngagementId] ([dbo].[Engagement].[Id], 1001) ; This will only return id of CONTENT OWNER from SysUser table


Changed By			Date			Description
Darwin C. Baluyot	7/13/2017		Created function

*******************************************************************************/
CREATE FUNCTION [dbo].[ufnGetSysUserIdByEngagementId]
(
	@engagementId int,
	@sysuserType int
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @sysuserId VARCHAR(MAX)
	
		SELECT @sysuserId = COALESCE(@sysuserId + ', ', '') + CONVERT(varchar,su.[Id])
		FROM [dbo].[EngagementSysUser] esu
		LEFT JOIN [dbo].[SysUser] su on su.[Id] = esu.[SysUserFk]
		Where esu.[EngagementFk]= @engagementId AND esu.[TypeFk] = @sysuserType

	RETURN @sysuserId
END
