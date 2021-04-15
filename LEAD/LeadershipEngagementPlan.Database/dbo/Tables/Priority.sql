CREATE TABLE [dbo].[Priority] (
    [Id]                  INT          IDENTITY (1000, 1) NOT NULL,
    [Priority]            VARCHAR (50) CONSTRAINT [DF_Priority_Priority] DEFAULT ('') NOT NULL,
    [DisplaySortSequence] INT          CONSTRAINT [DF_Priority_DisplaySortSequence] DEFAULT ((-1)) NOT NULL,
    [Status]              BIT          CONSTRAINT [DF_Priority_Status] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Priority] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Priority]
    ON [dbo].[Priority]([Priority] ASC);

