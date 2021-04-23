GO
If(OBJECT_ID('tempdb..#TempLead') Is Not Null)
Begin
    Drop Table #TempLead
End
If(OBJECT_ID('tempdb..#TempEngToUpdate') Is Not Null)
Begin
    Drop Table #TempEngToUpdate
End

Select eng.[Id], eng.[EntryDate], eng.[ModifiedDate]
	INTO #TempLead
	FROM [LEAD].[dbo].[Engagement] eng
	WHERE eng.[EntryDate] = eng.[ModifiedDate]
--SELECT * FROM #TempLead

SELECT e.[Id], e.[EntryDate], e.[ModifiedDate]
	INTO #TempEngToUpdate
	FROM [LeadershipEngagementPlanner].[dbo].[Engagement] e
	WHERE e.[Id] IN (SELECT eng.[Id] FROM #TempLead eng)
--SELECT * FROM #TempEngToUpdate
GO

UPDATE en 
	SET en.[EntryDate] = (SELECT [EntryDate] FROM #TempEngToUpdate e WHERE en.Id = e.Id)
	FROM [LEAD].[dbo].[Engagement] en
	WHERE Id IN (SELECT Id FROM #TempEngToUpdate)

SELECT e1.[Id], e1.[EntryDate] NEW, (SELECT e2.[EntryDate] FROM #TempLead e2 WHERE e2.Id = e1.Id) OLD
FROM [LEAD].[dbo].[Engagement] e1
WHERE e1.Id IN (SELECT Id FROM #TempEngToUpdate)
GO
