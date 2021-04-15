-- =============================================
-- Author:		Toshi Watanabe
-- Create date: 04/20/2016
-- Description:	Get Engagement Purpose
-- =============================================
CREATE PROCEDURE [app].[uspGetPurposeWithAll]
(
	@IsInternalEngagement BIT
)
AS
BEGIN

	SELECT [Id], [Purpose] 
		FROM (	SELECT 0 'Id', ' --- All ---' 'Purpose', 0 'DisplaySortSequence'
				UNION
				SELECT [Id], [Purpose], [DisplaySortSequence]
					FROM [dbo].[Purpose]
					WHERE	[Status] =1
						AND [IsInternalEngagement] = @IsInternalEngagement ) a
		ORDER BY [DisplaySortSequence];

END;