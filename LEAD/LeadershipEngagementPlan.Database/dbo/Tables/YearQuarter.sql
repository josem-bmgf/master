CREATE TABLE [dbo].[YearQuarter] (
    [Id]      INT       NOT NULL,
    [Year]    INT       NOT NULL,
    [Quarter] TINYINT   NOT NULL,
    [Display] CHAR (10) CONSTRAINT [DF_YearQuarter_Display] DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_YearQuarter] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_YearQuarter_1]
    ON [dbo].[YearQuarter]([Display] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_YearQuarter]
    ON [dbo].[YearQuarter]([Year] ASC, [Quarter] ASC);

