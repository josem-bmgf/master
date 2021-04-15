-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/21/2016
-- Description:	Get All Users from SysUser 
-- =============================================
CREATE PROCEDURE [app].[uspGetSysUserByType]
(
	@Type VARCHAR(20)
)
AS
BEGIN

IF @Type = 'TripDirector'
	SELECT [FullName], [Id] 
		FROM (
					SELECT ' --- Select ---'  'FullName', 0 'Id', 100 'DisplaySortSequence'
					UNION
					SELECT FirstName + ' ' + LastName 'FullName', [Id], 200 'DisplaySortSequence'
							FROM [dbo].[SysUser]
							WHERE 1=1
								AND [Status] = 1
								AND FirstName + ' ' + LastName IN ('Dehdan Miller', 'Kathy Young','Koren Bell','Isabelle Lagarde','Ida Norheim Hagtun' )
					UNION
					SELECT '--------------', -1, 300 'DisplaySortSequence'

					UNION
					SELECT FirstName + ' ' + LastName 'FullName', [Id], 500 'DisplaySortSequence'
							FROM [dbo].[SysUser]
							WHERE 1=1
								AND [Status] = 1
								AND FirstName + ' ' + LastName NOT IN ('Dehdan Miller', 'Kathy Young','Koren Bell','Isabelle Lagarde','Ida Norheim Hagtun' )
			 ) a
		ORDER BY DisplaySortSequence, FullName;
ELSE IF @Type = 'SpeechWriter'
	SELECT [FullName], [Id] 
		FROM (
					SELECT ' --- Select ---'  'FullName', 0 'Id', 100 'DisplaySortSequence'
					UNION
					SELECT FirstName + ' ' + LastName 'FullName', [Id], 200 'DisplaySortSequence'
							FROM [dbo].[SysUser]
							WHERE 1=1
								AND [Status] = 1
								AND FirstName + ' ' + LastName IN ('Dean Katz', 'Michael Lea','Sean Kelly')
					UNION
					SELECT '--------------', -1, 300 'DisplaySortSequence'

					UNION
					SELECT FirstName + ' ' + LastName 'FullName', [Id], 500 'DisplaySortSequence'
							FROM [dbo].[SysUser]
							WHERE 1=1
								AND [Status] = 1
								AND FirstName + ' ' + LastName NOT IN ('Dean Katz', 'Michael Lea','Sean Kelly')
			 ) a
		ORDER BY DisplaySortSequence, FullName;
ELSE IF @Type = 'CommunicationsLead'
	SELECT [FullName], [Id] 
		FROM (
					SELECT ' --- Select ---'  'FullName', 0 'Id', 100 'DisplaySortSequence'
					UNION
					SELECT FirstName + ' ' + LastName 'FullName', [Id], 200 'DisplaySortSequence'
							FROM [dbo].[SysUser]
							WHERE 1=1
								AND [Status] = 1
								AND FirstName + ' ' + LastName IN
									('Alex Jakana','Alex Reid','Amber Zeddies','Amy Enright','Amy Jarrett',
									'Archna Vyas','Bryan Callahan','Caroline Esser','Diane Scott','Dina Yang',
									'Douglas Hopper','Emily Floeck','Gabriella Stern','Jen Donofrio',
									'Jillian Foote','Katie Harris','Laura Dickinson','Leonora Diller',
									'Lorilyn Roller','Moky Makura','Nora Coghlan','Rachel Lonsdale','Rinn Self',
									'Ryan Cherlin','Sara Rogge','Sarah Logan','Sebastian Majewski','Tom Black',
									'Zyanya Correa')
					UNION
					SELECT '--------------', -1, 300 'DisplaySortSequence'

					UNION
					SELECT FirstName + ' ' + LastName 'FullName', [Id], 500 'DisplaySortSequence'
							FROM [dbo].[SysUser]
							WHERE 1=1
								AND [Status] = 1
								AND FirstName + ' ' + LastName NOT IN
									('Alex Jakana','Alex Reid','Amber Zeddies','Amy Enright','Amy Jarrett',
									'Archna Vyas','Bryan Callahan','Caroline Esser','Diane Scott','Dina Yang',
									'Douglas Hopper','Emily Floeck','Gabriella Stern','Jen Donofrio',
									'Jillian Foote','Katie Harris','Laura Dickinson','Leonora Diller',
									'Lorilyn Roller','Moky Makura','Nora Coghlan','Rachel Lonsdale','Rinn Self',
									'Ryan Cherlin','Sara Rogge','Sarah Logan','Sebastian Majewski','Tom Black',
									'Zyanya Correa')
			 ) a
		ORDER BY DisplaySortSequence, FullName
ELSE IF @Type = 'Staff'
	SELECT [FullName], [Id] 
		FROM (
					SELECT ' --- Select ---'  'FullName',  0 'Id', 100 'DisplaySortSequence'
					UNION
					SELECT 'Not Applicable '  'FullName',  -1 'Id', 200 'DisplaySortSequence'

					UNION
					SELECT FirstName + ' ' + LastName 'FullName', [Id], 500 'DisplaySortSequence'
							FROM [dbo].[SysUser]
							WHERE 1=1
								AND [Status] = 1
			 ) a
		ORDER BY DisplaySortSequence, FullName;
ELSE
	SELECT [FullName], [Id] 
		FROM (
					SELECT ' --- Select ---'  'FullName', 0 'Id', 100 'DisplaySortSequence'
					UNION
					SELECT FirstName + ' ' + LastName 'FullName', [Id], 500 'DisplaySortSequence'
							FROM [dbo].[SysUser]
							WHERE 1=1
								AND [Status] = 1
			 ) a
		ORDER BY DisplaySortSequence, FullName;



END;