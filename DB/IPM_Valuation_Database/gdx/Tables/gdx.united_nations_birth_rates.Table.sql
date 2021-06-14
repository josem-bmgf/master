CREATE TABLE [gdx].[united_nations_birth_rates] (
    [id]                              INT        IDENTITY (1, 1) NOT NULL,
    [country_dimension_id]            INT        NOT NULL,
    [gates_data_exchange_metadata_id] INT        NOT NULL,
    [year_nr]                         FLOAT (53) NOT NULL,
    [measure_dimension_id]            INT        NOT NULL,
    [measure_format_dimension_id]     INT        NOT NULL,
    [measure_point_estimate]          FLOAT (53) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_united_nations_birth_rates_country_dimension] FOREIGN KEY ([country_dimension_id]) REFERENCES [gdx].[country_dimension] ([id]),
    CONSTRAINT [FK_united_nations_birth_rates_gates_data_exchange_metadata] FOREIGN KEY ([gates_data_exchange_metadata_id]) REFERENCES [gdx].[gates_data_exchange_metadata] ([id]),
    CONSTRAINT [FK_united_nations_birth_rates_measure_dimension] FOREIGN KEY ([measure_dimension_id]) REFERENCES [gdx].[measure_dimension] ([id]),
    CONSTRAINT [FK_united_nations_birth_rates_measure_format_dimension] FOREIGN KEY ([measure_format_dimension_id]) REFERENCES [gdx].[measure_format_dimension] ([id])
);


GO
ALTER TABLE [gdx].[united_nations_birth_rates] NOCHECK CONSTRAINT [FK_united_nations_birth_rates_country_dimension];


GO
ALTER TABLE [gdx].[united_nations_birth_rates] NOCHECK CONSTRAINT [FK_united_nations_birth_rates_gates_data_exchange_metadata];


GO
ALTER TABLE [gdx].[united_nations_birth_rates] NOCHECK CONSTRAINT [FK_united_nations_birth_rates_measure_dimension];


GO
ALTER TABLE [gdx].[united_nations_birth_rates] NOCHECK CONSTRAINT [FK_united_nations_birth_rates_measure_format_dimension];
GO

CREATE NONCLUSTERED INDEX [IX_united_nations_birth_rates_Column]
    ON [gdx].[united_nations_birth_rates]([country_dimension_id] ASC, [year_nr] ASC, [gates_data_exchange_metadata_id] ASC, [measure_dimension_id] ASC, [measure_format_dimension_id] ASC);
GO

