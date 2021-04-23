USE [LEAD]
GO

If(OBJECT_ID('tempdb..#TempUserDivisionMapping') Is Not Null)
Begin
    Drop Table #TempUserDivisionMapping
End

SELECT Division
	  ,FULLNAME
	  ,(SELECT TOP 1 u.DivisionFk FROM SysUser u WHERE u.FullName = ud.FullName AND u.Status = 1) OldDivisionFk
	  ,(SELECT d.Id FROM Division d WHERE d.Name = ud.Division) NewDivisionFk
INTO #TempUserDivisionMapping
FROM UserDivision ud 

UPDATE u
   SET u.[DivisionFk] = (SELECT m.NewDivisionFk FROM #TempUserDivisionMapping m WHERE m.FULLNAME = u.FULLNAME)
FROM [dbo].[SysUser] u
WHERE [FULLNAME] IN (SELECT FULLNAME FROM #TempUserDivisionMapping) AND u.[Status] = 1
GO

If(OBJECT_ID('tempdb..#TempUserDivisionMapping') Is Not Null)
Begin
    Drop Table #TempUserDivisionMapping
End

--Please Drop table UserDivision after verification User Division mapping

