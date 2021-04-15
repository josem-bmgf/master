/*******************************************************************************
Author:				Darwin C. Baluyot
Created Date:		07/07/2017
Description:		Perform Insert to ScheduleSysUser. 
					It loops thru all the Trip Director or Communications Lead or Speech Writer SysUser (a comma delimited column)
					from dbo.Schedule, and insert these rows to dbo.ScheduleSysUser
Parameters:			@FirstId			- the MIN id of the current column (e.g. SELECT MIN(Id) FROM dbo.Schedule)
										- Simply declare a constant here if the column has an IDENTITY property
					@ProceedWithInsert	- Bit(0,1) to idenitify if Insert will push thru,
					@SysUserType		- Specify if which SysUser Type is to be migrated
										- Trip Director(1002) or Communications Lead(1003) or Speech Writer(1004). Values may vary.

Execute:			EXEC [dbo].[uspMigrateScheduleSysUser] 1000005, 0, 1002; This will only return a list of TRIP DIRECTOR SysUser to be inserted
					EXEC [dbo].[uspMigrateScheduleSysUser] 1000005, 1, 1003; Will push thru with the insert of COMMUNICATIONS LEAD SysUser to dbo.ScheduleSysUser
					EXEC [dbo].[uspMigrateScheduleSysUser] 1000005, 1, 1004; Will push thru with the insert of SPEECH WRITER SysUser to dbo.ScheduleSysUser


Changed By			Date			Description
Darwin C. Baluyot	7/7/2017		Created stored procedure 

*******************************************************************************/

CREATE PROCEDURE [dbo].[uspMigrateScheduleSysUser]
(    
      @FirstId INT,
	  @ProceedWithInsert BIT,
	  @SysUserType INT
)
AS
BEGIN

	DECLARE @LoopCounterMin INT,
		@LoopCounterMax INT,
		@ScheduleSysUserSet NVARCHAR(MAX),
		@TripDirectorType INT,
		@CommunicationsLeadType INT,
		@SpeechWriterType INT


	SET @TripDirectorType = (SELECT [Id] FROM [dbo].[SysUserType] WHERE [Name] = 'Trip Director')
	SET @CommunicationsLeadType = (SELECT [Id] FROM [dbo].[SysUserType] WHERE [Name] = 'Communications Lead')
	SET @SpeechWriterType = (SELECT [Id] FROM [dbo].[SysUserType] WHERE [Name] = 'Speech Writer')


	--Temp table that will hold ScheduleSysUser to be inserted
	CREATE TABLE #tempMigrateScheduleSysUser(
		 ToBe_ScheduleFK INT,
		 ToBe_SysUserFK INT,
		 ToBe_TypeFK INT)


	--Initialize loop counter by getting the min and max Id of Schedule based on SysUserType
	IF (@SysUserType = @TripDirectorType)
		BEGIN
			SELECT @LoopCounterMin = @FirstId, 
				@LoopCounterMax = MAX(Id) 
			FROM [dbo].[Schedule]
			WHERE [TripDirectorFk] > 0
		END	
	ELSE IF (@SysUserType = @CommunicationsLeadType)
		BEGIN
			SELECT @LoopCounterMin = @FirstId, 
				@LoopCounterMax = MAX(Id) 
			FROM [dbo].[Schedule]
			WHERE [CommunicationsLeadFk] > 0
		END	
	ELSE IF (@SysUserType = @SpeechWriterType)
		BEGIN
			SELECT @LoopCounterMin = @FirstId, 
				@LoopCounterMax = MAX(Id) 
			FROM [dbo].[Schedule]
			WHERE [SpeechWriterFk] > 0
		END								


	-- Loop to Engagement and Schedule rows
	WHILE ( @LoopCounterMin > 0
        AND  @LoopCounterMin <= @LoopCounterMax)
		BEGIN
			--Get current SysUser - this is a comma delimited string
			IF (@SysUserType = @TripDirectorType)
				BEGIN
					SET @ScheduleSysUserSet = (SELECT [TripDirectorFk]
					FROM [dbo].[Schedule] WHERE Id = @LoopCounterMin AND [TripDirectorFk] > 0)
				END	
			ELSE IF (@SysUserType = @CommunicationsLeadType)
				BEGIN
					SET @ScheduleSysUserSet = (SELECT [CommunicationsLeadFk]
					FROM [dbo].[Schedule] WHERE Id = @LoopCounterMin AND [CommunicationsLeadFk] > 0)
				END
			ELSE IF (@SysUserType = @SpeechWriterType)
				BEGIN
					SET @ScheduleSysUserSet = (SELECT [SpeechWriterFk]
					FROM [dbo].[Schedule] WHERE Id = @LoopCounterMin AND [SpeechWriterFk] > 0)
				END													
			
		   
		   IF (@ScheduleSysUserSet IS NOT NULL AND @ScheduleSysUserSet <> '')
			   BEGIN
					--Convert the comma delimited string into a table by calling [ufnConvertDelimitedStringToTable]
					--and then insert it to temp table
					INSERT INTO #tempMigrateScheduleSysUser (ToBe_ScheduleFK, ToBe_SysUserFK, ToBe_TypeFK)
					SELECT *, @SysUserType
					FROM [dbo].[ufnConvertDelimitedStringToTable](@LoopCounterMin, @ScheduleSysUserSet, ',')
			   END

			
		   SET @LoopCounterMin  = @LoopCounterMin  + 1  

	   END      

	IF (@ProceedWithInsert = 1)
		BEGIN
			--Insert rows to ScheduleSysUser table
			INSERT INTO [dbo].[ScheduleSysUser]
			SELECT [ToBe_ScheduleFK] AS [ScheduleFK]
				,[ToBe_SysUserFK] AS [SysUserFK]
				,[ToBe_TypeFK] AS [TypeFK]
			FROM #tempMigrateScheduleSysUser
			
			-- Return rows that has been migrated
			SELECT *
			FROM #tempMigrateScheduleSysUser

		END
	ELSE
		BEGIN
			-- Return rows to be migrated
			SELECT *
			FROM #tempMigrateScheduleSysUser

		END
	

	DROP TABLE #tempMigrateScheduleSysUser

END;