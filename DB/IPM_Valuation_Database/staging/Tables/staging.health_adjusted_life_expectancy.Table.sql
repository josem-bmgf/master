CREATE TABLE [staging].[health_adjusted_life_expectancy](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[iso_country_cd] [varchar](3) NOT NULL,
	[sex_nm] [varchar](10) NOT NULL,
	[gates_data_exchange_metadata_id] [nvarchar](100) NOT NULL,
	[age_group_nm] [varchar](20) NULL,
	[age_nr] [float] NULL,
	[year_nm] [int] NOT NULL,
	[hale_qty] [float] NULL,
[variable_nm] VARCHAR(255) NULL, 
    PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
