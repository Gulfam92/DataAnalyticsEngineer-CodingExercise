use FetchRewards

--Stage data load
Declare @JSON varchar(max)
SELECT @JSON=BulkColumn
FROM OPENROWSET (BULK 'F:\Gulfam\FetchRewards\users\userscleansed.json', SINGLE_CLOB) as j

TRUNCATE TABLE [STG].[users]

INSERT INTO [STG].[users] ([_id], [active], [createdDate], [lastLogin], [role], [signUpSource], [state])
SELECT [_id], [active], [createdDate], [lastLogin], [role], [signUpSource], [state]
FROM OPENJSON (@JSON )
WITH 
(
	_id varchar(250) '$._id.oid',
	active varchar(250) '$.active',
	createdDate varchar(250)'$.createdDate.date',
	lastLogin varchar(250) '$.lastLogin.date',
	[role] varchar(250) '$.role',
	signUpSource varchar(250) '$.signUpSource',
	[state] varchar(250) '$.state'
) as Dataset
GO


--DW data load
INSERT INTO [DW].[dimUsers]([_id]
           ,[active]
           ,[createdDate]
           ,[lastLogin]
           ,[role]
           ,[signUpSource]
           ,[state])
SELECT distinct
	[_id]
	,CASE WHEN [active] = 'true' THEN 1 WHEN [active] = 'false' THEN 0 ELSE NULL END AS [active]
    ,DATEADD(SECOND, CAST([createdDate] AS BIGINT) / 1000, '19700101 00:00') AS createdDate
    ,DATEADD(SECOND, CAST([lastLogin] AS BIGINT) / 1000, '19700101 00:00') AS lastLogin
    ,[role]
    ,[signUpSource]
    ,[state]
FROM [STG].[users]
