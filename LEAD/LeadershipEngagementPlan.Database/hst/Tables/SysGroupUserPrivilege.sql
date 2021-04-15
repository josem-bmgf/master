CREATE TABLE [hst].[SysGroupUserPrivilege] (
    [Id]                INT      IDENTITY (1000, 1) NOT NULL,
    [IdFk]              INT      CONSTRAINT [DF_SysGroupUserPrivilege_IdFk] DEFAULT ((0)) NOT NULL,
    [SysGroupFK]        INT      CONSTRAINT [DF_SysGroupUserPrivilege_SysGroupFK] DEFAULT ((0)) NOT NULL,
    [SysUserFK]         INT      CONSTRAINT [DF_SysGroupUserPrivilege_SysUserFK] DEFAULT ((0)) NOT NULL,
    [SysAdmin]          BIT      CONSTRAINT [DF_SysGroupUserPrivilege_SysAdmin] DEFAULT ((0)) NOT NULL,
    [AppAdmin]          BIT      CONSTRAINT [DF_SysGroupUserPrivilege_AppAdmin] DEFAULT ((0)) NOT NULL,
    [GroupAdmin]        BIT      CONSTRAINT [DF_SysGroupUserPrivilege_GroupAdmin] DEFAULT ((0)) NOT NULL,
    [GroupEntry]        BIT      CONSTRAINT [DF_SysGroupUserPrivilege_GroupEntry] DEFAULT ((0)) NOT NULL,
    [GroupApprover]     BIT      CONSTRAINT [DF_SysGroupUserPrivilege_GroupApproval] DEFAULT ((0)) NOT NULL,
    [Scheduler]         BIT      CONSTRAINT [DF_SysGroupUserPrivilege_GroupScheduler] DEFAULT ((0)) NOT NULL,
    [ScheduleApprover]  BIT      CONSTRAINT [DF_SysGroupUserPrivilege_GroupScheduleApprover] DEFAULT ((0)) NOT NULL,
    [BlackOutDateEntry] BIT      CONSTRAINT [DF_SysGroupUserPrivilege_BlackOutDateEntry] DEFAULT ((0)) NOT NULL,
    [Status]            BIT      CONSTRAINT [DF_SysGroupUserPrivilege_Status] DEFAULT ((1)) NOT NULL,
    [EntryDate]         DATETIME CONSTRAINT [DF_SysGroupUserPrivilege_EntryDate] DEFAULT (getdate()) NOT NULL,
    [EntryByFk]         INT      CONSTRAINT [DF_SysGroupUserPrivilege_EntryByFk] DEFAULT ((0)) NOT NULL,
    [ModifiedDate]      DATETIME CONSTRAINT [DF_SysGroupUserPrivilege_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedByFk]      INT      CONSTRAINT [DF_SysGroupUserPrivilege_ModifiedByFk] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_SysGroupUserPrivilege] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_SysGroupUserPrivilege_SysGroupUserPrivilege1] FOREIGN KEY ([IdFk]) REFERENCES [dbo].[SysGroupUserPrivilege] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IX_SysGroupUserPrivilege_1]
    ON [hst].[SysGroupUserPrivilege]([IdFk] ASC, [Id] ASC);

