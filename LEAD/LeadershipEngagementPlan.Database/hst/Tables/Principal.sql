CREATE TABLE [hst].[Principal]
(
	[Id] INT NOT NULL,
	[IdFk]                     INT           NOT NULL,
	[EngagementFK] INT NOT NULL, 
    [LeaderFK] INT NOT NULL, 
    [TypeFK] INT NOT NULL,
	CONSTRAINT [PK_PrincipalHistory] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Principal_Principal] FOREIGN KEY ([IdFk]) REFERENCES [dbo].[Principal] ([Id])
)
