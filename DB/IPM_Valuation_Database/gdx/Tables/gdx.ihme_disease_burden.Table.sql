CREATE TABLE [gdx].[ihme_disease_burden] (
    [id]                              INT           IDENTITY (1, 1) NOT NULL,
    [country_dimension_id]            INT           NOT NULL,
    [ihme_cause_id]                   INT           NOT NULL,
    [attributable_cause_nm]           VARCHAR (150) NULL,
    [disease_burden_source_nm]        VARCHAR (100) NOT NULL,
    [gates_data_exchange_metadata_id] INT           NOT NULL,
    [sex_nm]                          VARCHAR (10)  NOT NULL,
    [age_group_nm]                    VARCHAR (50)  NOT NULL,
    [age_nr]                          FLOAT (53)    NOT NULL,
    [year_nr]                         FLOAT (53)    NOT NULL,
    [scenario]                        VARCHAR (50)  NOT NULL,
    [measure_dimension_id]            INT           NOT NULL,
    [measure_format_dimension_id]     INT           NOT NULL,
    [measure_point_estimate]          FLOAT (53)    NULL,
    [measure_upper_value]             FLOAT (53)    NULL,
    [measure_lower_value]             FLOAT (53)    NULL,
    [variable_nm]                     VARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_ihme_disease_burden_country_dimension] FOREIGN KEY ([country_dimension_id]) REFERENCES [gdx].[country_dimension] ([id]),
    CONSTRAINT [FK_ihme_disease_burden_gates_data_exchange_metadata] FOREIGN KEY ([gates_data_exchange_metadata_id]) REFERENCES [gdx].[gates_data_exchange_metadata] ([id]),
    CONSTRAINT [FK_ihme_disease_burden_measure_dimension] FOREIGN KEY ([measure_dimension_id]) REFERENCES [gdx].[measure_dimension] ([id]),
    CONSTRAINT [FK_ihme_disease_burden_measure_format_dimension] FOREIGN KEY ([measure_format_dimension_id]) REFERENCES [gdx].[measure_format_dimension] ([id])
);


GO
ALTER TABLE [gdx].[ihme_disease_burden] NOCHECK CONSTRAINT [FK_ihme_disease_burden_country_dimension];


GO
ALTER TABLE [gdx].[ihme_disease_burden] NOCHECK CONSTRAINT [FK_ihme_disease_burden_gates_data_exchange_metadata];


GO
ALTER TABLE [gdx].[ihme_disease_burden] NOCHECK CONSTRAINT [FK_ihme_disease_burden_measure_dimension];


GO
ALTER TABLE [gdx].[ihme_disease_burden] NOCHECK CONSTRAINT [FK_ihme_disease_burden_measure_format_dimension];




GO
ALTER TABLE [gdx].[ihme_disease_burden] NOCHECK CONSTRAINT [FK_ihme_disease_burden_country_dimension];


GO
ALTER TABLE [gdx].[ihme_disease_burden] NOCHECK CONSTRAINT [FK_ihme_disease_burden_gates_data_exchange_metadata];


GO
ALTER TABLE [gdx].[ihme_disease_burden] NOCHECK CONSTRAINT [FK_ihme_disease_burden_measure_dimension];


GO
ALTER TABLE [gdx].[ihme_disease_burden] NOCHECK CONSTRAINT [FK_ihme_disease_burden_measure_format_dimension];
GO

CREATE NONCLUSTERED INDEX [IX_ihme_disease_burden_Column]
    ON [gdx].[ihme_disease_burden]([country_dimension_id] ASC, [age_nr] ASC, [year_nr] ASC, [gates_data_exchange_metadata_id] ASC, [measure_dimension_id] ASC, [measure_format_dimension_id] ASC)
    INCLUDE([scenario], [attributable_cause_nm], [ihme_cause_id], [sex_nm]);
GO

CREATE NONCLUSTERED INDEX [IX_ihme_disease_burden_variable_nm]
    ON [gdx].[ihme_disease_burden]([country_dimension_id] ASC, [age_nr] ASC, [year_nr] ASC, [gates_data_exchange_metadata_id] ASC, [measure_dimension_id] ASC, [measure_format_dimension_id] ASC)
    INCLUDE([scenario], [variable_nm], [sex_nm]);
Go
