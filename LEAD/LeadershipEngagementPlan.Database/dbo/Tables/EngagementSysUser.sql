CREATE TABLE [dbo].[EngagementSysUser]
(
	[Id] INT IDENTITY(1000,1) NOT NULL PRIMARY KEY, 
    [EngagementFk] INT CONSTRAINT [DF_EngagementSysUser_EngagementFk] DEFAULT ((0)) NOT NULL, 
    [SysUserFk] INT CONSTRAINT [DF_EngagementSysUser_SysUserFk] DEFAULT ((0)) NOT NULL, 
    [TypeFk] INT CONSTRAINT [DF_EngagementSysUser_TypeFk] DEFAULT ((0)) NOT NULL,
	CONSTRAINT [FK_EngagementSysUser_Engagement] FOREIGN KEY ([EngagementFk]) REFERENCES [dbo].[Engagement] ([Id]),
	CONSTRAINT [FK_EngagementSysUser_SysUser] FOREIGN KEY ([SysUserFk]) REFERENCES [dbo].[SysUser] ([Id]),
	CONSTRAINT [FK_EngagementSysUser_SysUserType] FOREIGN KEY ([TypeFk]) REFERENCES [dbo].[SysUserType] ([Id])
)