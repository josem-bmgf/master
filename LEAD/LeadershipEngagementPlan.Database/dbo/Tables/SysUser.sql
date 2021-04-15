CREATE TABLE [dbo].[SysUser] (
    [Id]        INT           IDENTITY (1000, 1) NOT NULL,
    [LastName]  VARCHAR (50)  CONSTRAINT [DF_SysUser_LastName] DEFAULT ('') NOT NULL,
    [FirstName] VARCHAR (50)  CONSTRAINT [DF_SysUser_FirstName] DEFAULT ('') NOT NULL,
    [FullName]  VARCHAR (128) CONSTRAINT [DF_SysUser_FullName] DEFAULT ('') NOT NULL,
    [ADUser]    VARCHAR (50)  CONSTRAINT [DF_SysUser_ADUser] DEFAULT ('') NOT NULL,
    [Status]    BIT           CONSTRAINT [DF_SysUser_Status] DEFAULT ((1)) NOT NULL,
    [DivisionFk] INT		  CONSTRAINT [DF_SysUser_Division] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_SysUser] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_SysUser]
    ON [dbo].[SysUser]([ADUser] ASC);

