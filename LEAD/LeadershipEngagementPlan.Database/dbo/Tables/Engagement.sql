CREATE TABLE [dbo].[Engagement] (
    [Id]                       INT           IDENTITY (1000000, 1) NOT NULL,
    [Title]                    VARCHAR (128) CONSTRAINT [DF_Engagement_Title] DEFAULT ('') NOT NULL,
    [Details]                  VARCHAR (MAX) CONSTRAINT [DF_Engagement_Details] DEFAULT ('') NULL,
    [DetailsRtf]               VARCHAR (MAX) CONSTRAINT [DF_Engagement_DetailsRtf] DEFAULT ('') NOT NULL,
    [Objectives]               VARCHAR (MAX) CONSTRAINT [DF_Engagement_Objectives] DEFAULT ('') NOT NULL,
    [ObjectivesRtf]            VARCHAR (MAX) CONSTRAINT [DF_Engagement_ObjectivesRtf] DEFAULT ('') NOT NULL,
    [ExecutiveSponsorFk]       INT           CONSTRAINT [DF_Engagement_ExecutiveSponsorFk] DEFAULT ((0)) NOT NULL,
    [IsConfidential]           BIT           CONSTRAINT [DF_Engagement_IsConfidential] DEFAULT ((0)) NOT NULL,
    [IsExternal]               BIT           CONSTRAINT [DF_Engagement_EngagementType] DEFAULT ((1)) NOT NULL,
    [RegionFk]                 INT           CONSTRAINT [DF_Engagement_RegionFk] DEFAULT ((0)) NOT NULL,
    [City]                     VARCHAR (128) CONSTRAINT [DF_Engagement_City] DEFAULT ('') NULL,
    [PurposeFk]                INT           CONSTRAINT [DF_Engagement_EngagementPurposeFk] DEFAULT ((0)) NOT NULL,
    [BriefOwnerFk]             INT           CONSTRAINT [DF_Engagement_BriefOwnerFk] DEFAULT ((0)) NOT NULL,
    [StaffFk]                  INT           CONSTRAINT [DF_Engagement_StaffFk] DEFAULT ((0)) NOT NULL,
    [DurationFk]               INT           CONSTRAINT [DF_Engagement_DurationFk] DEFAULT ((0)) NOT NULL,
    [IsDateFlexible]           BIT           CONSTRAINT [DF_Engagement_IsDateFlexible] DEFAULT ((1)) NOT NULL,
    [DateStart]                DATE          CONSTRAINT [DF_Engagement_DateStart] DEFAULT (getdate()) NULL,
    [DateEnd]                  DATE          CONSTRAINT [DF_Engagement_DateEnd] DEFAULT (getdate()) NULL,
    [DivisionFk]               INT           CONSTRAINT [DF_Engagement_DivisionFk] DEFAULT ((0)) NOT NULL,
    [TeamFk]                   INT           CONSTRAINT [DF_Engagement_TeamFk] DEFAULT ((0)) NOT NULL,
    [StrategicPriorityFk]      INT           CONSTRAINT [DF_Engagement_StrategicPriorityFk] DEFAULT ((0)) NOT NULL,
    [TeamRankingFk]            INT           CONSTRAINT [DF_Engagement_TeamRankingFk] DEFAULT ((0)) NOT NULL,
    [PresidentRankingFk]       INT           CONSTRAINT [DF_Engagement_PresidentRankingFk] DEFAULT ((0)) NOT NULL,
    [PresidentComment]         VARCHAR (MAX) CONSTRAINT [DF_Engagement_PresidentComment] DEFAULT ('') NULL,
    [PresidentCommentRtf]      VARCHAR (MAX) CONSTRAINT [DF_Engagement_PresidentCommentRtf] DEFAULT ('') NOT NULL,
    [EntryCompleted]           BIT           CONSTRAINT [DF_Engagement_EntryCompleted] DEFAULT ((0)) NOT NULL,
    [PresidentReviewCompleted] BIT           CONSTRAINT [DF_Engagement_PresidentReviewCompleted] DEFAULT ((0)) NOT NULL,
    [ScheduleCompleted]        BIT           CONSTRAINT [DF_Engagement_ScheduleCompleted] DEFAULT ((0)) NOT NULL,
    [ScheduleReviewCompleted]  BIT           CONSTRAINT [DF_Engagement_ScheduleReviewCompleted] DEFAULT ((0)) NOT NULL,
    [EntryDate]                DATETIME      CONSTRAINT [DF_Engagement_EntryDate] DEFAULT (getdate()) NOT NULL,
    [EntryByFk]                INT           CONSTRAINT [DF_Engagement_EntryByFk] DEFAULT ((0)) NOT NULL,
    [ModifiedDate]             DATETIME      CONSTRAINT [DF_Engagement_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedByFk]             INT           CONSTRAINT [DF_Engagement_ModifiedByFk] DEFAULT ((0)) NOT NULL,
    [IsDeleted]                BIT           CONSTRAINT [DF_Engagement_IsDeleted] DEFAULT ((0)) NOT NULL,
	[StatusFk]                 INT           CONSTRAINT [DF_Engagement_StatusFk] DEFAULT ((0)) NOT NULL,
	[Location]                 VARCHAR (128) CONSTRAINT [DF_Engagement_Location] DEFAULT ('') NULL,

    CONSTRAINT [PK_Engagement] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Engagement_Duration] FOREIGN KEY ([DurationFk]) REFERENCES [dbo].[Duration] ([Id]),
    CONSTRAINT [FK_Engagement_Leader] FOREIGN KEY ([ExecutiveSponsorFk]) REFERENCES [dbo].[Leader] ([Id]),
    CONSTRAINT [FK_Engagement_Priority] FOREIGN KEY ([StrategicPriorityFk]) REFERENCES [dbo].[Priority] ([Id]),
    CONSTRAINT [FK_Engagement_Purpose] FOREIGN KEY ([PurposeFk]) REFERENCES [dbo].[Purpose] ([Id]),
    CONSTRAINT [FK_Engagement_Ranking_PresidentRanking] FOREIGN KEY ([PresidentRankingFk]) REFERENCES [dbo].[Ranking] ([Id]),
    CONSTRAINT [FK_Engagement_Ranking_TeamRanking] FOREIGN KEY ([TeamRankingFk]) REFERENCES [dbo].[Ranking] ([Id]),
    CONSTRAINT [FK_Engagement_Region] FOREIGN KEY ([RegionFk]) REFERENCES [dbo].[Region] ([Id]),
    CONSTRAINT [FK_Engagement_Division] FOREIGN KEY ([DivisionFk]) REFERENCES [dbo].[Division] ([Id]),
    CONSTRAINT [FK_Engagement_SysUser_BriefOwner] FOREIGN KEY ([BriefOwnerFk]) REFERENCES [dbo].[SysUser] ([Id]),
    CONSTRAINT [FK_Engagement_SysUser_EntryBy] FOREIGN KEY ([EntryByFk]) REFERENCES [dbo].[SysUser] ([Id]),
    CONSTRAINT [FK_Engagement_SysUser_ModifiedBy] FOREIGN KEY ([ModifiedByFk]) REFERENCES [dbo].[SysUser] ([Id]),
	CONSTRAINT [FK_Engagement_SysUser_Staff] FOREIGN KEY ([StaffFk]) REFERENCES [dbo].[SysUser] ([Id]),
    CONSTRAINT [FK_Engagement_Team] FOREIGN KEY ([TeamFk]) REFERENCES [dbo].[Team] ([Id]),
    CONSTRAINT [FK_Engagement_Status] FOREIGN KEY ([StatusFk]) REFERENCES [dbo].[Status] ([Id])

);



GO
CREATE NONCLUSTERED INDEX [IX_Engagement]
    ON [dbo].[Engagement]([Id] ASC);

