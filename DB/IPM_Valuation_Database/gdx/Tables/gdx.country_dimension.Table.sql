CREATE TABLE [gdx].[country_dimension](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[iso_country_cd] [varchar](3) NOT NULL,
	[iso_country_nm] [varchar](50) NOT NULL,
	[ipm_country_nm] [varchar](50) NOT NULL, --country_nm
	--[iso2_cd] [varchar](2) NULL,
	--[fao_short_nm] [varchar](50) NULL,
	--[fao_official_nm] [varchar](50) NULL,
	--[faostat_cd] [int] NULL,
	--[gaul_cd] [int] NULL,
	--[uni_cd] [int] NULL,
	--[un_country_nm] [varchar](50) NULL,
	--[undp_cd] [varchar](3) NULL,
	--[world_bank_short_nm] [varchar](50) NULL,
	--[world_bank_long_nm] [varchar](50) NULL,
	--[world_bank_region_nm] [varchar](50) NULL,
	--[ida_country_nm] [varchar](50) NULL,
	--[oecd_nm] [varchar](50) NULL,
	--[who_country_nm] [varchar](50) NULL,
	--[who_region_nm] [varchar](50) NULL,
	[ihme_location_cd] [int] NULL,
	--[ihme_country_nm] [varchar](50) NULL,
	--[ipm_country_nm] [varchar](50) NULL,
	--[gavi_country_nm] [varchar](50) NULL,
	--[gavi_grouping_nm] [varchar](50) NULL,
	--[continent_nm] [varchar](50) NULL,
	--[crs_continent_cd] [int] NULL,
	--[region_nm] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_country_name] UNIQUE NONCLUSTERED 
(
	[ipm_country_nm] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_iso_code] UNIQUE NONCLUSTERED 
(
	[iso_country_cd] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_iso_name] UNIQUE NONCLUSTERED 
(
	[iso_country_nm] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
