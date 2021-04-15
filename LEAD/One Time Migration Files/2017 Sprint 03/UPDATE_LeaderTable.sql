--Update the Leader Table
UPDATE [dbo].[Leader]
SET [Status] = 1
WHERE Id not in (-1,0,1017)