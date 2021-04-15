CREATE TABLE [dbo].[Ranking] (
    [Id]                  INT          IDENTITY (1000, 1) NOT NULL,
    [Ranking]             VARCHAR (50) CONSTRAINT [DF_Ranking_Priority] DEFAULT ('') NOT NULL,
    [RequesterInput]      BIT          CONSTRAINT [DF_Ranking_RequesterInput] DEFAULT ((1)) NOT NULL,
    [PresidentReview]     BIT          CONSTRAINT [DF_Ranking_PresidentReview] DEFAULT ((1)) NOT NULL,
    [DisplaySortSequence] INT          CONSTRAINT [DF_Ranking_DisplaySortSequence] DEFAULT ((-1)) NOT NULL,
    [Status]              BIT          CONSTRAINT [DF_Ranking_Status] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Ranking] PRIMARY KEY CLUSTERED ([Id] ASC)
);

