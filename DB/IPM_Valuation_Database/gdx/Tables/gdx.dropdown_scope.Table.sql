CREATE TABLE [gdx].[dropdown_scope] (
    [id]                              INT           IDENTITY (1, 1) NOT NULL,
    [gates_data_exchange_metadata_id] INT           NOT NULL,
    [measure_dimension_id]            INT           NOT NULL,
    [measure_format_dimension_id]     INT           NOT NULL,
    [country_dimension_id]            INT           NOT NULL,
    [cause_id]                        INT           NULL,
    [attributable_cause_nm]           VARCHAR (50)  NULL,
    [proxy_nm]                        VARCHAR (50)  NULL,
    [variable_nm]                     VARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_dropdown_scope_country_dimension] FOREIGN KEY ([country_dimension_id]) REFERENCES [gdx].[country_dimension] ([id]),
    CONSTRAINT [FK_dropdown_scope_gates_data_exchange_metadata] FOREIGN KEY ([gates_data_exchange_metadata_id]) REFERENCES [gdx].[gates_data_exchange_metadata] ([id]),
    CONSTRAINT [FK_dropdown_scope_measure_dimension] FOREIGN KEY ([measure_dimension_id]) REFERENCES [gdx].[measure_dimension] ([id]),
    CONSTRAINT [FK_dropdown_scope_measure_format_dimension] FOREIGN KEY ([measure_format_dimension_id]) REFERENCES [gdx].[measure_format_dimension] ([id])
);


GO
ALTER TABLE [gdx].[dropdown_scope] NOCHECK CONSTRAINT [FK_dropdown_scope_country_dimension];


GO
ALTER TABLE [gdx].[dropdown_scope] NOCHECK CONSTRAINT [FK_dropdown_scope_gates_data_exchange_metadata];


GO
ALTER TABLE [gdx].[dropdown_scope] NOCHECK CONSTRAINT [FK_dropdown_scope_measure_dimension];


GO
ALTER TABLE [gdx].[dropdown_scope] NOCHECK CONSTRAINT [FK_dropdown_scope_measure_format_dimension];




GO
ALTER TABLE [gdx].[dropdown_scope] NOCHECK CONSTRAINT [FK_dropdown_scope_country_dimension];


GO
ALTER TABLE [gdx].[dropdown_scope] NOCHECK CONSTRAINT [FK_dropdown_scope_gates_data_exchange_metadata];


GO
ALTER TABLE [gdx].[dropdown_scope] NOCHECK CONSTRAINT [FK_dropdown_scope_measure_dimension];


GO
ALTER TABLE [gdx].[dropdown_scope] NOCHECK CONSTRAINT [FK_dropdown_scope_measure_format_dimension];
GO

