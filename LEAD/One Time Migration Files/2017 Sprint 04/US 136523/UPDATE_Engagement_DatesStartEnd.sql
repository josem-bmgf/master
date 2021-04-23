--Clean up to Start date and end date that were system defaults because they were required at first
Update Engagement set DateStart = null where DateStart = '1/1/2000'
Update Engagement set DateEnd = null where DateEnd = '2999-12-31'