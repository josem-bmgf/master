/****** Object:  Table [gdx].[country_scope]    Script Date: 12/12/2019 9:48:30 AM ******/

GO

GO
CREATE TABLE [gdx].[country_scope](
	[ISO_Code] [nvarchar](max) NULL,
	[iso_name] [nvarchar](max) NULL,
	[cntry_name] [nvarchar](max) NULL,
	[ISO2] [nvarchar](max) NULL,
	[UNI] [float] NULL,
	[GAUL] [float] NULL,
	[FAOSTAT] [float] NULL,
	[UNDP] [nvarchar](max) NULL,
	[IPM_Country_Name] [nvarchar](max) NULL,
	[IHME_Country_Name] [nvarchar](max) NULL,
	[GAVI_Country_Name] [nvarchar](max) NULL,
	[continent] [nvarchar](max) NULL,
	[crs_continent_code] [float] NULL,
	[region_name] [nvarchar](max) NULL,
	[world_bank_income_group] [nvarchar](max) NULL,
	[WHO_Region] [nvarchar](max) NULL,
	[GAVI_Grouping] [nvarchar](max) NULL,
	[IPM_scope] [float] NULL,
	[GAVI_73] [int] NULL,
	[vx_del98] [int] NULL,
	[vx_del_grps] [int] NULL,
	[all_reference_data_complete] [nvarchar](max) NULL,
	[un_pop] [int] NULL,
	[un_birth_rates] [nvarchar](max) NULL,
	[un_births] [nvarchar](max) NULL,
	[un_deaths] [nvarchar](max) NULL,
	[un_migration] [nvarchar](max) NULL,
	[gbd_2016_death_rates] [float] NULL,
	[gbd_2016_hale] [float] NULL,
	[gbd_2016_le] [float] NULL,
	[ihme_2015_projected_death_rates] [float] NULL,
	[ihme_2015_projected_life_expectancy] [float] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
