USE [LEAD]
GO
/****** Object:  UserDefinedFunction [dbo].[ufnGetNameByScheduleId]    Script Date: 7/15/2017 4:15:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
Author:				Darwin C. Baluyot
Created Date:		07/07/2017
Description:		Returns FullName of SysUser that is either TRIP DIRECTOR or COMMUNICATIONS LEAD or SPEECH WRITER
Parameters:			@scheduleId			- id of the current column (e.g. SELECT Id FROM dbo.Schedule)
					@sysuserType		- Specify if which SysUser Type is to be pulled out.
										- Trip Director(1002) or Communications Lead(1003) or Speech Writer(1004) . Values may vary.
									
Execute:			[dbo].[ufnGetSysUserNameByScheduleId] ([dbo].[Schedule].[Id], 1002) ; This will only return a list of TRIP DIRECTOR SysUser
					[dbo].[ufnGetSysUserNameByScheduleId] ([dbo].[Schedule].[Id], 1003) ; This will only return a list of COMMUNICATIONS LEAD SysUser
					[dbo].[ufnGetSysUserNameByScheduleId] ([dbo].[Schedule].[Id], 1004) ; This will only return a list of SPEECH WRITER SysUser


Changed By			Date			Description
Darwin C. Baluyot	7/7/2017		Created function

*******************************************************************************/
CREATE FUNCTION [dbo].[ufnGetSysUserNameByScheduleId]
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
		Where ssu.[ScheduleFk] = @scheduleId AND ssu.[TypeFk] = @sysuserType

	RETURN COALESCE(@Names,'')
END
