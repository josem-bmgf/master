-- Migrates SysUser from dbo.Engagement to dbo.EngagementSysUser
EXEC [dbo].[uspMigrateEngagementSysUser] 1000000, 1, 1000;
EXEC [dbo].[uspMigrateEngagementSysUser] 1000000, 1, 1001;


-- Migrates SysUser from dbo.Schedule to dbo.ScheduleSysUser
EXEC [dbo].[uspMigrateScheduleSysUser] 1000005, 1, 1002;
EXEC [dbo].[uspMigrateScheduleSysUser] 1000005, 1, 1003;
EXEC [dbo].[uspMigrateScheduleSysUser] 1000005, 1, 1004;