CREATE TABLE [dbo].[Duration] (
    [Id]                   INT          IDENTITY (1000, 1) NOT NULL,
    [IsInternalEngagement] BIT          CONSTRAINT [DF_Duration_IsInternalEngagement] DEFAULT ((0)) NOT NULL,
    [Duration]             VARCHAR (20) NOT NULL,
    [DurationInMinutes]    INT          CONSTRAINT [DF_Duration_DurationInMinutes] DEFAULT ((0)) NOT NULL,
    [DurationInDays]       INT          CONSTRAINT [DF_Duration_DurationInDays] DEFAULT ((0)) NOT NULL,
    [Status]               BIT          CONSTRAINT [DF_Duration_Status] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Duration] PRIMARY KEY CLUSTERED ([Id] ASC)
);

