-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 05/12/2016
-- Description:	Get Principals for single select
-- =============================================
CREATE PROCEDURE [app].[uspGetPrincipalsSingleSelect]
(
	@SysGroupFk INT
)
AS
BEGIN

	SELECT [Id], [Principal]
		FROM (	SELECT 0 'Id', ' --- Select ---' 'Principal', 0 'DisplaySortSequence'
				UNION
				SELECT [Id],   [ShortName] 'Principal', [DisplaySortSequence]
					FROM [dbo].[Leader]
					WHERE 1=1
						AND [Status]=1
						AND [Id] > 0
						AND (
								(@SysGroupFk IN (1000, 1001))
									OR
								(@SysGroupFk = [SysGroupFk])
							)
			 ) a
		ORDER BY [DisplaySortSequence];
END;