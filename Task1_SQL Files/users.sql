use FetchRewards
Declare @JSON varchar(max)
SELECT @JSON=BulkColumn
FROM OPENROWSET (BULK 'F:\Gulfam\FetchRewards\users\userscleansed.json', SINGLE_CLOB) as j
SELECT distinct
	_id, 
	active, 
	DATEADD(SECOND, createdDate / 1000, '19700101 00:00') AS createdDate, 
	DATEADD(SECOND, lastLogin / 1000, '19700101 00:00') AS lastLogin, 
	[role], signUpSource, [state]
FROM OPENJSON (@JSON )
WITH 
(
	_id varchar(50) '$._id.oid',
	active char(5) '$.active',
	createdDate bigint'$.createdDate.date',
	lastLogin bigint '$.lastLogin.date',
	[role] varchar(50) '$.role',
	signUpSource varchar(50) '$.signUpSource',
	[state] char(2) '$.state'
) as Dataset
GO




