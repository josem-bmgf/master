CREATE TABLE [gdx].[ihme_attributable_fraction]
(
    [Id] INT IDENTITY(1, 1) NOT NULL PRIMARY KEY, 
    [ihme_cause_id] INT NOT NULL, 
    [cause_nm] nvarchar(100) NOT NULL,
    [disease_nm] NVARCHAR(100) NOT NULL, 
    [age_nr] FLOAT NOT NULL, 
    [death_attributable_pct] FLOAT NULL, 
    [incidence_attributable_pct] FLOAT NULL
)
