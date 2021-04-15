CREATE TABLE [hst].[Engagement] (
    [Id]                       INT           IDENTITY (1000000, 1) NOT NULL,
    [IdFk]                     INT           NOT NULL,
    [Title]                    VARCHAR (128) NOT NULL,
    [Details]                  VARCHAR (MAX) NOT NULL,
    [DetailsRtf]               VARCHAR (MAX) NOT NULL,
    [Objectives]               VARCHAR (MAX) NOT NULL,
    [ObjectivesRtf]            VARCHAR (MAX) NOT NULL,
    [ExecutiveSponsorFk]       INT           NOT NULL,
    [IsConfidential]           BIT           CONSTRAINT [DF_Engagement_IsConfidential_1] DEFAULT ((0)) NOT NULL,
    [IsExternal]               BIT           NOT NULL,
    [RegionFk]                 INT           NOT NULL,
    [City]                     VARCHAR (128) NOT NULL,
    [PurposeFk]                INT           NOT NULL,
    [BriefOwnerFk]             INT           NOT NULL,
    [StaffFk]                  INT           NOT NULL,
    [DurationFk]               INT           NOT NULL,
    [IsDateFlexible]           BIT           NOT NULL,
    [DateStart]                DATE          NOT NULL,
    [DateEnd]                  DATE          NOT NULL,
    [DivisionFk]               INT           NOT NULL,
    [TeamFk]                   INT           NOT NULL,
    [StrategicPriorityFk]      INT           NOT NULL,
    [TeamRankingFk]            INT           NOT NULL,
    [PresidentRankingFk]       INT           NOT NULL,
    [PresidentComment]         VARCHAR (MAX) NOT NULL,
    [PresidentCommentRtf]      VARCHAR (MAX) NOT NULL,
    [EntryCompleted]           INT           NOT NULL,
    [PresidentReviewCompleted] INT           NOT NULL,
    [ScheduleCompleted]        INT           NOT NULL,
    [ScheduleReviewCompleted]  INT           NOT NULL,
    [EntryDate]                DATETIME      NOT NULL,
    [EntryByFk]                INT           NOT NULL,
    [ModifiedDate]             DATETIME      NOT NULL,
    [ModifiedByFk]             INT           NOT NULL,
    [IsDeleted]                BIT           NOT NULL,
    CONSTRAINT [PK_EngagementHistory] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Engagement_Engagement] FOREIGN KEY ([IdFk]) REFERENCES [dbo].[Engagement] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IX_Engagement_1]
    ON [hst].[Engagement]([IdFk] ASC, [Id] ASC);

