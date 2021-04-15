/*******************************************************************************
Author:				Darwin C. Baluyot
Created Date:		07/13/2017
Description:		Returns SysUser ud of SysUser that is either TRIP DIRECTOR or COMMUNICATIONS LEAD or SPEECH WRITER
Parameters:			@scheduleId			- id of the current column (e.g. SELECT Id FROM dbo.Schedule)
					@sysuserType		- Specify if which SysUser Type is to be pulled out.
										- Trip Director(1002) or Communications Lead(1003) or Speech Writer(1004) . Values may vary.
									
Execute:			[dbo].[ufnGetSysUserIdByScheduleId] ([dbo].[Schedule].[Id], 1002) ; This will only return id of TRIP DIRECTOR from SysUser table
					[dbo].[ufnGetSysUserIdByScheduleId] ([dbo].[Schedule].[Id], 1003) ; This will only return id of COMMUNICATIONS LEAD from SysUser table
					[dbo].[ufnGetSysUserIdByScheduleId] ([dbo].[Schedule].[Id], 1004) ; This will only return id of SPEECH WRITER from SysUser table


Changed By			Date			Description
Darwin C. Baluyot	7/13/2017		Created function

*******************************************************************************/
CREATE FUNCTION [dbo].[ufnGetSysUserIdByScheduleId]
(
	@scheduleId int,
	@sysuserType int
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @sysuserId VARCHAR(MAX)
	
		SELECT @sysuserId = COALESCE(@sysuserId + ', ', '') + CONVERT(varchar,su.[Id])
		FROM [dbo].[ScheduleSysUser] ssu
		LEFT JOIN [dbo].[SysUser] su on su.[Id] = ssu.[SysUserFk]
		Where ssu.[ScheduleFk] = @scheduleId AND ssu.[TypeFk] = @sysuserType

	RETURN @sysuserId
END