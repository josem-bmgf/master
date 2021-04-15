-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/20/2016
-- Description:	Get Ranking by user type 
-- =============================================
CREATE PROCEDURE [app].[uspGetRankingByUserType]
(
	 @UserType CHAR(1)
)
AS
BEGIN

	SELECT [Id], [Ranking]
		FROM (	SELECT 0 'Id', ' --- Select ---' 'Ranking', 0 'DisplaySortSequence'
				UNION
				SELECT [Id], [Ranking], [DisplaySortSequence]
					FROM [dbo].[Ranking]
					WHERE [Status] =1
						AND (	(@UserType = 'R' AND [RequesterInput]  = 1)
								OR
								(@UserType = 'P' AND [PresidentReview] = 1)	)	) a
		ORDER BY [DisplaySortSequence];

END;