
CREATE TABLE [staging].[united_nations_birth_rates](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[iso_country_cd] VARCHAR(3) NOT NULL,
	[gates_data_exchange_metadata_id] [varchar](50) NOT NULL,
	[year_nm] INT NOT NULL, 
	[births_qty] [float] NULL,
	[crude_birth_rate_pct] [float] NULL,

    PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
