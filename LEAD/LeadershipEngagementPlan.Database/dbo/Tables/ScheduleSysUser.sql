CREATE TABLE [dbo].[ScheduleSysUser]
(
	[Id] INT IDENTITY(1000,1) NOT NULL PRIMARY KEY, 
    [ScheduleFk] INT CONSTRAINT [DF_ScheduleSysUser_ScheduleFk] DEFAULT ((0)) NOT NULL, 
    [SysUserFk] INT CONSTRAINT [DF_ScheduleSysUser_SysUserFk] DEFAULT ((0)) NOT NULL, 
    [TypeFk] INT CONSTRAINT [DF_ScheduleSysUser_TypeFk] DEFAULT ((0)) NOT NULL,
	CONSTRAINT [FK_ScheduleSysUser_Schedule] FOREIGN KEY ([ScheduleFk]) REFERENCES [dbo].[Schedule] ([Id]),
	CONSTRAINT [FK_ScheduleSysUser_SysUser] FOREIGN KEY ([SysUserFk]) REFERENCES [dbo].[SysUser] ([Id]),
	CONSTRAINT [FK_ScheduleSysUser_SysUserType] FOREIGN KEY ([TypeFk]) REFERENCES [dbo].[SysUserType] ([Id])
)