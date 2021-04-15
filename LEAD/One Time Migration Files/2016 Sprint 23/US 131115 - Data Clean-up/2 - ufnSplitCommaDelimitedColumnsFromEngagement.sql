/****** Object:  UserDefinedFunction [dbo].[ufnConvertDelimitedStringToTable]    Script Date: 11/14/2016 10:40:16 AM ******/
/*******************************************************************************
Author:				Ma. Carina Sanchez 
Created Date:		11/14/2016
Description:		Convert delimited string into a table
Parameters:			@Id					- An integer that will serve as the Id for the comma delimited string,
					@DelimitedString	- Delimited string,
					@CharacterSplitter	- Character on how the string is grouped (e.g. ',' or ';')

Execute:			SELECT * FROM [dbo].[ufnConvertDelimitedStringToTable]('10000', '2001,2002,2003',','); 
					Output is 
					|Id		|Item	|
					|10000	| 2001	|
					|10000	| 2002	|
					|10000	| 2003	|



Changed By			Date			Description 

*******************************************************************************/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[ufnConvertDelimitedStringToTable]
(    
      @Id INT,
	  @DelimitedString NVARCHAR(MAX),
      @CharacterSplitter CHAR(1)
)
RETURNS @Output TABLE (
	  Id INT,
      Item NVARCHAR(1000)
)
AS
BEGIN
      DECLARE @StartIndex INT, @EndIndex INT
	  SET @DelimitedString = [dbo].[ufnRemoveLastCharacter](@DelimitedString, @CharacterSplitter)
 
      SET @StartIndex = 1
      IF SUBSTRING(@DelimitedString, LEN(@DelimitedString) - 1, LEN(@DelimitedString)) <> @CharacterSplitter
      BEGIN
            SET @DelimitedString = @DelimitedString + @CharacterSplitter
      END
 
      WHILE CHARINDEX(@CharacterSplitter, @DelimitedString) > 0
      BEGIN
            SET @EndIndex = CHARINDEX(@CharacterSplitter, @DelimitedString)
           
            INSERT INTO @Output(Id, Item)
            SELECT @Id, SUBSTRING(@DelimitedString, @StartIndex, @EndIndex - 1)
           
            SET @DelimitedString = SUBSTRING(@DelimitedString, @EndIndex + 1, LEN(@DelimitedString))
      END
 
      RETURN
END


