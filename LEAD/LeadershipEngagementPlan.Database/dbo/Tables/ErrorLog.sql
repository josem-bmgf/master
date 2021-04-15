CREATE TABLE [dbo].[ErrorLog]
(
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[RunDate] [datetime] NOT NULL,
	[UserID] [int] NOT NULL,
	[Details] [nvarchar](MAX) NULL,
	CONSTRAINT [PK_ErrorLog] PRIMARY KEY CLUSTERED ([LogID] ASC),
	CONSTRAINT [FK_ErrorLog_SysUser] FOREIGN KEY ([UserID]) REFERENCES [dbo].[SysUser] ([Id])
	)
