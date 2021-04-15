/****** Object:  UserDefinedProcedure [dbo].[uspMigrateEngagementYearQuarter]    Script Date: 11/14/2016 10:49:54 AM ******/
/*******************************************************************************
Author:				Ma. Carina Sanchez 
Created Date:		11/14/2016
Description:		Perform Insert to EngagementYearQuarter. 
					It loops thru all the YearQuarter (a comma delimited column) from dbo.Engagement, 
					and insert these rows to dbo.EngagementYearQuarter 
Parameters:			@FirstId			- the MIN id of the current column (e.g. SELECT MIN(Id) FROM dbo.Engagement)
										- Simply declare a constant here if the column has an IDENTITY property
					@ProceedWithInsert	- Bit(0,1) to idenitify if Insert will push thru

Execute:			EXEC [dbo].[uspMigrateEngagementYearQuarter] 1000000, 0; This will only return a list of YearQuarter to be inserted
					EXEC [dbo].[uspMigrateEngagementYearQuarter] 1000000, 1; Will push thru with the insert to dbo.EngagementYearQuarter


Changed By			Date			Description 

*******************************************************************************/

CREATE PROCEDURE [dbo].[uspMigrateEngagementYearQuarter]
(    
      @FirstId INT,
	  @ProceedWithInsert BIT	
)
AS
BEGIN

	DECLARE @RowLength INT,
		@LoopCounterMin INT,
		@LoopCounterMax INT,
		@YearQtrSet NVARCHAR(MAX)

	--Temp table that will hold Year Quarter to be inserted
	CREATE TABLE #tempMigrateYearQuarter(
		 ToBe_EngagementFk INT,
		 ToBe_YearQuarterFk INT)
	
	--Initialize loop counter by getting the min and max Id of Engagement
	SELECT @LoopCounterMin = @FirstId, 
		@LoopCounterMax = MAX(Id) 
	FROM [dbo].[Engagement]
	WHERE YearQuarterFks IS NOT NULL	

	-- Loop to Engagement rows
	WHILE ( @LoopCounterMin IS NOT NULL
        AND  @LoopCounterMin <= @LoopCounterMax)
		BEGIN
			--Get current YearQuarter - this is a comma delimited string
		   SET @YearQtrSet = (SELECT [YearQuarterFks]
		   FROM [dbo].[Engagement] WHERE Id = @LoopCounterMin)
		   
		   IF (@YearQtrSet IS NOT NULL AND @YearQtrSet <> '')
			   BEGIN
					--Convert the comma delimited string into a table by calling [ufnConvertDelimitedStringToTable]
					--and then insert it to temp table
					INSERT INTO #tempMigrateYearQuarter (ToBe_EngagementFk, ToBe_YearQuarterFk)
					SELECT *
					FROM [dbo].[ufnConvertDelimitedStringToTable](@LoopCounterMin, @YearQtrSet, ',')
			   END
			
		   SET @LoopCounterMin  = @LoopCounterMin  + 1  

	   END      

	IF (@ProceedWithInsert = 1)
		BEGIN
			--Insert rows to Principal table
			INSERT INTO [dbo].[EngagementYearQuarter]
			SELECT [ToBe_EngagementFk] AS [EngagementFk]
				,[ToBe_YearQuarterFk] AS [YearQuarterFk]
			FROM #tempMigrateYearQuarter

			SELECT *
			FROM [dbo].[EngagementYearQuarter]
		END
	ELSE
		BEGIN
			-- Return rows to be migrated
			SELECT *
			FROM #tempMigrateYearQuarter
		END
	
	DROP TABLE #tempMigrateYearQuarter

END;