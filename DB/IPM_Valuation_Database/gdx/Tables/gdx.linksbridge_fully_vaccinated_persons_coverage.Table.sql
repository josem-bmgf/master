/****** Object:  Table [gdx].[linksbridge_fully_vaccinated_persons_coverage]    Script Date: 12/12/2019 9:48:31 AM ******/

GO

GO
CREATE TABLE [gdx].[linksbridge_fully_vaccinated_persons_coverage](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[iso_country_cd] [varchar](3) NOT NULL,
	[gates_data_exchange_metadata_id] [varchar](50) NOT NULL,
	[year_nm] [int] NULL,
	[vaccine_nm] [varchar](50) NULL,
	[vaccine_subtype_nm] [varchar](50) NULL,
	[vial_size_nm] [varchar](50) NULL,
	[target_age_nm] [int] NULL,
	[no_doses_qty] [int] NULL,
	[fvp_coverage_type_nm] [varchar](50) NULL,
	[fvp_coverage_pct] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
