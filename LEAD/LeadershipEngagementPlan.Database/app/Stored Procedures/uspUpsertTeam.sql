-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/26/2016
-- Description:	Update DivisionTeamSysGroup Table from Foundation domain.
-- =============================================
CREATE PROCEDURE [app].[uspUpsertTeam]
AS
BEGIN
/*
MERGE [dbo].[DivisionTeamSysGroup] dtsg
USING ( SELECT src.[Team], src.[SubTeam], grp.[Id]
 			FROM OPENROWSET('sqloledb','trusted_connection=yes;server=DWODSSQL01;database=SourceFoundationDomain',
								 'SELECT DISTINCT [Team], [SubTeam]
									FROM [dbo].[Team]
									WHERE [Team] IS NOT NULL 
										AND [SubTeam] IS NOT NULL
										AND EffectiveStartDate <= GETDATE()
										AND GETDATE() < EffectiveEndDate;') src
			JOIN [dbo].[SysGroup] grp ON src.Team = grp.FoundationDomainTeam) dd
ON dtsg.[Division] = dd.[Team] AND dtsg.[Team] = dd.[SubTeam]
WHEN MATCHED AND dtsg.[Status] = 0 
	THEN UPDATE SET dtsg.[Status] = 1
WHEN NOT MATCHED BY TARGET 
	THEN INSERT ([Division], [Team], [SysGroupFk], [Status]) VALUES (dd.[Team], dd.[SubTeam], dd.[Id], 1)
WHEN NOT MATCHED BY SOURCE 
	THEN UPDATE SET dtsg.[Status] = 0;
*/

MERGE [dbo].[Team] t
USING (SELECT src.[Team], src.[SubTeam], grp.[Id] [SysGroupFk]
		FROM          
		(	  SELECT 'Global Communications & Engagement' [Team],'Media & External Relations' [SubTeam]
		UNION SELECT 'Global Communications & Engagement','Employee Communications'
		UNION SELECT 'Global Communications & Engagement','Brand, Campaigns & Creative' 
		UNION SELECT 'Global Communications & Engagement','Office of the CCO'
		UNION SELECT 'Global Communications & Engagement','Executive Engagement' 
		UNION SELECT 'Executive', 'Strategy, Innovation, & Impact'
		UNION SELECT 'Executive', 'Office of the CEO'
		UNION SELECT 'Global Development','Agriculture'
		UNION SELECT 'Global Development','Emergency Response'
		UNION SELECT 'Global Development','Family Planning'
		UNION SELECT 'Global Development','Financial Services for the Poor'
		UNION SELECT 'Global Development','GD Office of the President'
		UNION SELECT 'Global Development','GD Special Initiatives'
		UNION SELECT 'Global Development','GD Strategy Planning & Management'
		UNION SELECT 'Global Development','Global Libraries'
		UNION SELECT 'Global Development','India Office'
		UNION SELECT 'Global Development','Integrated Delivery'
		UNION SELECT 'Global Development','MNCH'
		UNION SELECT 'Global Development','Multilateral Partnerships'
		UNION SELECT 'Global Development','Nutrition'
		UNION SELECT 'Global Development','Polio'
		UNION SELECT 'Global Development','Urban Poverty'
		UNION SELECT 'Global Development','Vaccine Delivery'
		UNION SELECT 'Global Development','Water, Sanitation, and Hygiene'
		UNION SELECT 'Global Health','Discovery'
		UNION SELECT 'Global Health','Enteric and Diarrheal Diseases'
		UNION SELECT 'Global Health','GH Office of the President'
		UNION SELECT 'Global Health','GH Strategy Planning & Management'
		UNION SELECT 'Global Health','HIV'
		UNION SELECT 'Global Health','Integrated Development'
		UNION SELECT 'Global Health','Life Sciences Partnerships'
		UNION SELECT 'Global Health','Malaria'
		UNION SELECT 'Global Health','Neglected Tropical Diseases'
		UNION SELECT 'Global Health','Pneumonia'
		UNION SELECT 'Global Health','TB'
		UNION SELECT 'Global Health','Vaccine Development'
		UNION SELECT 'Global Policy and Advocacy','Africa Offices'
		UNION SELECT 'Global Policy and Advocacy','China Office'
		UNION SELECT 'Global Policy and Advocacy','Development Policy & Finance'
		UNION SELECT 'Global Policy and Advocacy','Donor Government Relations'
		UNION SELECT 'Global Policy and Advocacy','GPA Office of the President'
		UNION SELECT 'Global Policy and Advocacy','GPA Strategy Planning & Management'
		UNION SELECT 'Global Policy and Advocacy','Philanthropic Partnerships'
		UNION SELECT 'Global Policy and Advocacy','Program Advocacy & Comms'
		UNION SELECT 'Operations','Office of the COO'
		UNION SELECT 'Operations','Finance & Investments Team'
		UNION SELECT 'Operations','Global Workplace Resources'
		UNION SELECT 'Operations','Human Resources'
		UNION SELECT 'Operations','IT'
		UNION SELECT 'U.S. Program','K-12'
		UNION SELECT 'U.S. Program','PNW'
		UNION SELECT 'U.S. Program','Postsecondary Success'
		UNION SELECT 'U.S. Program','Scholarships'
		UNION SELECT 'U.S. Program','U.S. Advocacy'
		UNION SELECT 'U.S. Program','U.S. Operations'
		UNION SELECT 'U.S. Program','USP Office of the President'
		UNION SELECT 'U.S. Program','WA State Charter Schools' ) src
		JOIN [dbo].[SysGroup] grp ON src.Team = grp.GroupName) dd
ON t.[SysGroupFk] = dd.[SysGroupFk] AND t.[Team] = dd.[SubTeam]
WHEN MATCHED AND t.[Status] = 0 
	THEN UPDATE SET t.[Status] = 1
WHEN NOT MATCHED BY TARGET 
	THEN INSERT ( [SysGroupFk], [Team], [Status]) VALUES (dd.[SysGroupFk], dd.[SubTeam],  1)
WHEN NOT MATCHED BY SOURCE 
	THEN UPDATE SET t.[Status] = 0;
END;