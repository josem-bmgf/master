CREATE TABLE [dbo].[Purpose] (
    [Id]                   INT          IDENTITY (1000, 1) NOT NULL,
    [IsInternalEngagement] BIT          CONSTRAINT [DF_EngagementPurpose_IsInternalEngagement] DEFAULT ((1)) NOT NULL,
    [Purpose]              VARCHAR (50) CONSTRAINT [DF_EngagementPurpose_Purpose] DEFAULT ('') NOT NULL,
    [DisplaySortSequence]  INT          CONSTRAINT [DF_EngagementPurpose_DisplaySortSequence] DEFAULT ((-1)) NOT NULL,
    [Status]               BIT          CONSTRAINT [DF_EngagementPurpose_Status] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_EngagementPurpose] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_EngagementPurpose]
    ON [dbo].[Purpose]([IsInternalEngagement] ASC, [Purpose] ASC);

