-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/26/2016
-- Description:	Update SysUser Table from SQLManager.
-- =============================================
CREATE PROCEDURE [app].[uspUpsertSysUser]
AS
BEGIN

SELECT 
	 LastName
	,FirstName
	,ADUser
	,FullName
	INTO #T
	FROM OPENROWSET('sqloledb','trusted_connection=yes;server=SQL01;database=SQLManager',
					'SELECT 
								CAST('''' AS VARCHAR(50)) ''LastName''
							,CAST('''' AS VARCHAR(50)) ''FirstName''
							,''seattle\'' + REPLACE(LTRIM(RTRIM([sAMAccount])), '','', '' '') ''ADUser''
							,REPLACE(SUBSTRING([DistinguishedName], CHARINDEX(''CN='',[DistinguishedName]) + 3, CHARINDEX('',OU='',[DistinguishedName]) - CHARINDEX(''CN='',[DistinguishedName]) - 3), '','', '' '') ''FullName''
							FROM [dbo].[vDomainGroupUser]
							WHERE 1=1
								AND [Type] = ''U''
								AND [Status] = ''1''
								AND [Domain] = ''Seattle''
								AND SUBSTRING([sAMAccount], 1,4) !=''svc_''
								AND SUBSTRING([sAMAccount], 1,4) !=''app_''
								AND ([sAMAccount] NOT LIKE ''%test%'' OR [DistinguishedName] NOT LIKE ''%test%'')
								AND [sAMAccount] NOT LIKE ''%LyncUser%''
								AND [sAMAccount] NOT LIKE ''%-lync%''
								AND [sAMAccount] NOT LIKE ''%System%''
								AND [sAMAccount] NOT LIKE ''%mailstop%''


								AND CAST([AccountControl] AS INT) & 2 != 2 --account not disabled
								AND [DistinguishedName] LIKE ''%,OU=General Users,%'';');

UPDATE #T
	SET FirstName = SUBSTRING(CASE WHEN CHARINDEX(' ', FullName) > 1 AND LEN(FullName) > CHARINDEX(' ', FullName) + 1 
							THEN SUBSTRING(FullName, 1, CHARINDEX(' ', FullName) -1) 
							ELSE '' END, 1, 50);

DELETE #T
	WHERE FirstName = '';

UPDATE #T
	SET LastName = SUBSTRING(LTRIM(RTRIM(REPLACE(FullName, FirstName, ''))), 1, 50);

Update #t
	SET	 FullName = [dbo].[ufnProperCase](FullName)
		,FirstName = [dbo].[ufnProperCase](FirstName)
		,LastName = [dbo].[ufnProperCase](LastName);


MERGE [dbo].[SysUser] su
USING #t src
ON su.[ADUser] = src.[ADUser]
WHEN MATCHED AND ((su.[Status] = 1 AND (su.[FullName] != src.[FullName] OR su.[LastName] != src.[LastName] OR su.[FirstName] != src.[FirstName])) OR su.[Status] = 0)
	THEN UPDATE SET su.[FullName] = src.[FullName], su.[LastName] = src.[LastName], su.[FirstName] = src.[FirstName], su.[Status] = 1
WHEN NOT MATCHED BY TARGET 
	THEN INSERT ([FullName], [LastName], [FirstName], [ADUser], [Status]) VALUES (src.[FullName],src.[LastName], src.[FirstName], src.[ADUser], 1)
WHEN NOT MATCHED BY SOURCE 
	THEN UPDATE SET su.[Status] = 0;

UPDATE [dbo].[SysUser]
	SET [Status] = 1
	WHERE [ADUser] IN ('Seattle\toshiwprd', 'System');

UPDATE [dbo].[SysUser]
	SET FullName = LTRIM(RTRIM(FirstName)) + ' ' + LTRIM(RTRIM(LastName))
	WHERE LTRIM(RTRIM(FullName)) = '';


END;