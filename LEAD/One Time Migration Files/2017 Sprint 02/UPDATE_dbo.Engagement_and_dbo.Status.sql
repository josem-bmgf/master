UPDATE dbo.Engagement
SET StatusFk = '1006'
WHERE StatusFk = '1005'

UPDATE dbo.Engagement
SET StatusFk = '1001'
WHERE StatusFk = '1002'

DELETE FROM dbo.Status
WHERE Id = '1002'

DELETE FROM dbo.Status
WHERE Id = '1005'

UPDATE dbo.Status
SET DisplaySortSequence = '1020'
WHERE Id = '1003'

UPDATE dbo.Status
SET DisplaySortSequence = '1030'
WHERE Id = '1004'

UPDATE dbo.Status
SET DisplaySortSequence = '1040'
WHERE Id = '1006'

UPDATE dbo.Status
SET DisplaySortSequence = '1050'
WHERE Id = '1007'