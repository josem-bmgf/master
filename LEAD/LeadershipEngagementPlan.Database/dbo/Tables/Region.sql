CREATE TABLE [dbo].[Region] (
    [Id]                  INT          IDENTITY (1000, 1) NOT NULL,
    [Region]              VARCHAR (50) CONSTRAINT [DF_Region_Region] DEFAULT ('') NOT NULL,
    [DisplaySortSequence] INT          CONSTRAINT [DF_Region_SortSequence] DEFAULT ((0)) NOT NULL,
    [Status]              BIT          CONSTRAINT [DF_Region_Status] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Region] PRIMARY KEY CLUSTERED ([Id] ASC)
);

