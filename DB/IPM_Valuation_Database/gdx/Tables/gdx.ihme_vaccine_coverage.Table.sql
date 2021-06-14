CREATE TABLE [gdx].[ihme_vaccine_coverage] (
    [id]                              INT           IDENTITY (1, 1) NOT NULL,
    [country_dimension_id]            INT           NOT NULL,
    [gates_data_exchange_metadata_id] INT           NOT NULL,
    [year_nr]                         FLOAT (53)    NOT NULL,
    [sex_nm]                          VARCHAR (10)  NOT NULL,
    [age_group_nm]                    VARCHAR (50)  NOT NULL,
    [proxy_nm]                        VARCHAR (100) NULL  ,
	[variable_nm]                     VARCHAR (255) NULL,
    [scenario_nm]                     VARCHAR (50)  NOT NULL,
    [measure_dimension_id]            INT           NOT NULL,
    [measure_format_dimension_id]     INT           NOT NULL,
    [measure_point_estimate]          FLOAT (53)    NULL,
    CONSTRAINT [PK_ihme_vaccine_coverage] PRIMARY KEY CLUSTERED ([id] ASC)
);
GO

CREATE NONCLUSTERED INDEX [IX_ihme_vaccine_coverage_Column]
    ON [gdx].[ihme_vaccine_coverage]([country_dimension_id] ASC, [year_nr] ASC, [gates_data_exchange_metadata_id] ASC, [measure_dimension_id] ASC, [measure_format_dimension_id] ASC)
    INCLUDE([proxy_nm]);
GO

CREATE NONCLUSTERED INDEX [IX_ihme_vaccine_coverage_variable_nm]
    ON [gdx].[ihme_vaccine_coverage]([country_dimension_id] ASC, [year_nr] ASC, [gates_data_exchange_metadata_id] ASC, [measure_dimension_id] ASC, [measure_format_dimension_id] ASC)
    INCLUDE([variable_nm]);
GO