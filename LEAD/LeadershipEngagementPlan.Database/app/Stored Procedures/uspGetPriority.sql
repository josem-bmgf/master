-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 05/12/2016
-- Description:	Get Priority
-- =============================================
CREATE PROCEDURE [app].[uspGetPriority]
AS
BEGIN

	SELECT [Id], [Priority]
		FROM (	SELECT 0 'Id', ' --- Select ---' 'Priority', 0 'DisplaySortSequence'
				UNION
				SELECT [Id], [Priority], [DisplaySortSequence]
					FROM [dbo].[Priority]
					WHERE [Status] =1
			 ) a
		ORDER BY [DisplaySortSequence];

END;