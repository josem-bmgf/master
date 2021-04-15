/*******************************************************************************
Author:				Darwin C. Baluyot
Created Date:		07/07/2017
Description:		Returns FullName of SysUser that is either TRIP DIRECTOR or COMMUNICATIONS LEAD or SPEECH WRITER
Parameters:			@engagementId		- id of the current column (e.g. SELECT Id FROM dbo.Schedule)
					@sysuserType		- Specify if which SysUser Type is to be pulled out.
										- Trip Director(1002) or Communications Lead(1003) or Speech Writer(1004) . Values may vary.
									
Execute:			[dbo].[ufnGetNameByScheduleId] ([dbo].[Schedule].[Id], 1002) ; This will only return a list of TRIP DIRECTOR SysUser
					[dbo].[ufnGetNameByScheduleId] ([dbo].[Schedule].[Id], 1003) ; This will only return a list of COMMUNICATIONS LEAD SysUser
					[dbo].[ufnGetNameByScheduleId] ([dbo].[Schedule].[Id], 1004) ; This will only return a list of SPEECH WRITER SysUser


Changed By			Date			Description
Darwin C. Baluyot	7/7/2017		Created function

*******************************************************************************/
CREATE FUNCTION [dbo].[ufnGetNameByScheduleId]
(
	@scheduleId int,
	@sysuserType int
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @Names VARCHAR(MAX)
	
		SELECT @Names = COALESCE(@Names + ', ', '') + su.[FullName]
		FROM [dbo].[ScheduleSysUser] ssu
		LEFT JOIN [dbo].[SysUser] su on su.[Id] = ssu.[SysUserFk]
		Where ssu.[ScheduleFk] = scheduleId AND ssu.[TypeFk] = @sysuserType

	RETURN @Names
END
