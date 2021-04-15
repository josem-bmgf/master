CREATE TABLE [dbo].[Schedule] (
    [Id]                   INT           IDENTITY (1000000, 1) NOT NULL,
    [EngagementFk]         INT           CONSTRAINT [DF_Schedule_EngagementFk] DEFAULT ((0)) NOT NULL,
    [LeaderFk]             INT           CONSTRAINT [DF_Schedule_LeaderFk] DEFAULT ((0)) NOT NULL,
    [DateFrom]             DATETIME      CONSTRAINT [DF_Schedule_DateFrom] DEFAULT ('01/01/2000') NULL,
    [DateTo]               DATETIME      CONSTRAINT [DF_Schedule_DateTo] DEFAULT ('12/31/2999') NULL,
    [TripDirectorFk]       INT           CONSTRAINT [DF_Schedule_TripDirectorFk] DEFAULT ((0)) NOT NULL,
    [SpeechWriterFk]       INT           CONSTRAINT [DF_Schedule_SpeechWriterFk] DEFAULT ((0)) NOT NULL,
    [CommunicationsLeadFk] INT           CONSTRAINT [DF_Schedule_CommunicationsLeadFk] DEFAULT ((0)) NOT NULL,
    [BriefDueToGCEByDate]  DATETIME      NULL,
    [BriefDueToBGC3ByDate] DATETIME      CONSTRAINT [DF_Schedule_BriedDueToBGC3ByDate] DEFAULT (((1)/(1))/(1900)) NULL,
    [ScheduleComment]      VARCHAR (MAX) CONSTRAINT [DF_Schedule_ScheduleComment] DEFAULT ('') NULL,
    [ScheduleCommentRtf]   VARCHAR (MAX) CONSTRAINT [DF_Schedule_ScheduleCommentRtf] DEFAULT ('') NOT NULL,
    [ScheduledByFk]        INT           CONSTRAINT [DF_Schedule_ScheduledBy] DEFAULT ((0)) NOT NULL,
    [ScheduledDate]        DATETIME      CONSTRAINT [DF_Schedule_ScheduledDate] DEFAULT (getdate()) NULL,
    [ApproveDecline]       CHAR (1)      CONSTRAINT [DF_Schedule_ApproveDecline] DEFAULT ('') NOT NULL,
    [ReviewComment]        VARCHAR (MAX) CONSTRAINT [DF_Schedule_ReviewComment] DEFAULT ('') NOT NULL,
    [ReviewCommentRtf]     VARCHAR (MAX) CONSTRAINT [DF_Schedule_ReviewCommentRtf] DEFAULT ('') NOT NULL,
    [ReviewCompletedByFk]  INT           CONSTRAINT [DF_Schedule_ApprovedBy] DEFAULT ((0)) NOT NULL,
    [ReviewCompletedDate]  DATETIME      CONSTRAINT [DF_Schedule_ReviewCompletedDate] DEFAULT (getdate()) NULL,
    [IsDeleted]            BIT           CONSTRAINT [DF_Schedule_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Schedule] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Schedule_Engagement] FOREIGN KEY ([EngagementFk]) REFERENCES [dbo].[Engagement] ([Id]),
    CONSTRAINT [FK_Schedule_Leader] FOREIGN KEY ([LeaderFk]) REFERENCES [dbo].[Leader] ([Id]),
	CONSTRAINT [FK_Schedule_SysUser_TripDirector] FOREIGN KEY ([TripDirectorFk]) REFERENCES [dbo].[SysUser] ([Id]),
	CONSTRAINT [FK_Schedule_SysUser_SpeechWriter] FOREIGN KEY ([SpeechWriterFk]) REFERENCES [dbo].[SysUser] ([Id]),
	CONSTRAINT [FK_Schedule_SysUser_CommunicationsLead] FOREIGN KEY ([CommunicationsLeadFk]) REFERENCES [dbo].[SysUser] ([Id]),
    CONSTRAINT [FK_Schedule_SysUser_ReviewCompletedBy] FOREIGN KEY ([ReviewCompletedByFk]) REFERENCES [dbo].[SysUser] ([Id]),
    CONSTRAINT [FK_Schedule_SysUser_ScheduledBy] FOREIGN KEY ([ScheduledByFk]) REFERENCES [dbo].[SysUser] ([Id])
);

GO
CREATE NONCLUSTERED INDEX [IX_Schedule_1]
    ON [dbo].[Schedule]([EngagementFk] ASC);

