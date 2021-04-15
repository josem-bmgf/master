
-- =============================================
-- Author:		Marc Peco
-- Create date: 07/17/2016
-- Description:	Get Id for engagement for a particular leader
-- =============================================
CREATE FUNCTION [dbo].[ufnGetEngagementIdsByPrincipal] 
(	
	@Fks VARCHAR(255)
)
RETURNS @Output TABLE (
      Id Int
)
AS
BEGIN
		INSERT INTO @Output	
			SELECT Id
				FROM [dbo].[Principal] p
				WHERE p.EngagementFK = @Fks
					AND p.TypeFK = 1; -- 1 for Required Principal
	Return;
END