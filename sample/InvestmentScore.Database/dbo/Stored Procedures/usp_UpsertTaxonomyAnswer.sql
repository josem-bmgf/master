-- =============================================
-- Author:		Marc Peco
-- Create date: 04/27/2017
-- Description:	Handles the update/create of taxonomy answers
-- =============================================
CREATE PROCEDURE [dbo].[usp_UpsertTaxonomyAnswer] 
	-- Add the parameters for the stored procedure here
	@InvestmentId int,
	@QuestionId int,
	@StringValue varchar (500) = null,
	@NumericValue int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @answerId int;
	SELECT @answerId FROM dbo.Taxonomy_Values ta
	WHERE ta.Investment_ID = @InvestmentId
	  AND ta.Taxonomy_Item_ID = @QuestionId

	IF (@answerId IS NULL)
		INSERT INTO [dbo].[Taxonomy_Values]
			   ([Value]
			   ,[Numeric_Value]
			   ,[Taxonomy_Item_ID]
			   ,[Investment_ID])
		 VALUES
			   (@StringValue
			   ,@NumericValue
			   ,@QuestionId
			   ,@InvestmentId)
	ELSE
		UPDATE [dbo].[Taxonomy_Values]
		   SET [Value] = @StringValue
			  ,[Numeric_Value] = @NumericValue
		 WHERE ID = @answerId
END