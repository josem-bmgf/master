CREATE TABLE [dbo].[Taxonomy_Values] (
    [ID]               INT            IDENTITY (1, 1) NOT NULL,
    [Value]            NVARCHAR (MAX) NULL,
    [Numeric_Value]    INT            NULL,
    [Taxonomy_Item_ID] INT            NULL,
    [Investment_ID]    INT            NULL,
    CONSTRAINT [PK_Taxonomy_Values] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_Taxonomy_Values_Investment] FOREIGN KEY ([Investment_ID]) REFERENCES [dbo].[Investment] ([ID]),
    CONSTRAINT [FK_Taxonomy_Values_Taxonomy_Items] FOREIGN KEY ([Taxonomy_Item_ID]) REFERENCES [dbo].[Taxonomy_Items] ([ID])
);

