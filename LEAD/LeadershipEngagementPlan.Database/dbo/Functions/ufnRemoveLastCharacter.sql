/****** Object:  UserDefinedFunction [dbo].[ufnRemoveLastCharacter]    Script Date: 11/14/2016 10:49:54 AM ******/
/*******************************************************************************
Author:				Ma. Carina Sanchez 
Created Date:		11/14/2016
Description:		Conditionally remove the last character of a string only if the given character is the last character
Parameters:			@StringToClean		- string to be modified,
					@CharacterToRemove	- last character to be removed

Execute:			SELECT [dbo].[ufnRemoveLastCharacter]('helloworld!', '!'); Output is 'helloworld'
					SELECT [dbo].[ufnRemoveLastCharacter]('helloworld?', '!'); Output is 'helloworld?'


Changed By			Date			Description 

*******************************************************************************/


CREATE FUNCTION [dbo].[ufnRemoveLastCharacter]
(    
      @StringToClean NVARCHAR(MAX),
      @CharacterToRemove CHAR(1)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	SET @StringToClean = RTRIM(LTRIM(@StringToClean)) -- Remove leading and trailing whitespace
	--Check if last character is the character to remove
	IF (RIGHT(RTRIM(@StringToClean),1) = @CharacterToRemove) 
	BEGIN
		--Remove last character
		SET @StringToClean = SUBSTRING(RTRIM(@StringToClean),1,LEN(RTRIM(@StringToClean))-1)
	END
 
    RETURN @StringToClean
END


