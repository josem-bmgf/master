/*******************************************************************************
Author:				Darwin C. Baluyot
Created Date:		07/07/2017
Description:		Returns FullName of SysUser that is either STAFF or CONTENT OWNER
Parameters:			@engagementId		- id of the current column (e.g. SELECT Id FROM dbo.Engagement)
					@sysuserType		- Specify if which SysUser Type is to be pulled out.
										- Staff(1000) or Content Owner(1001). Values may vary.

Execute:			[dbo].[ufnGetNameByEngagementId] ([dbo].[Engagement].[Id], 1000) ; This will only return a list of STAFF SysUser
					[dbo].[ufnGetNameByEngagementId] ([dbo].[Engagement].[Id], 1001) ; This will only return a list of CONTENT OWNER SysUser


Changed By			Date			Description
Darwin C. Baluyot	7/7/2017		Created function

*******************************************************************************/
CREATE FUNCTION [dbo].[ufnGetNameByEngagementId]
(
	@engagementId int,
	@sysuserType int
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @Names VARCHAR(MAX)
	
		SELECT @Names = COALESCE(@Names + ', ', '') + su.[FullName]
		FROM [dbo].[EngagementSysUser] esu
		LEFT JOIN [dbo].[SysUser] su on su.[Id] = esu.[SysUserFk]
		Where esu.[EngagementFk]= @engagementId AND esu.[TypeFk] = @sysuserType

	RETURN @Names
END