use FetchRewards
Declare @JSON varchar(max)
SELECT @JSON=BulkColumn
FROM OPENROWSET (BULK 'F:\Gulfam\FetchRewards\receipts\receiptscleansed.json', SINGLE_CLOB) as j

--Stage data load
TRUNCATE TABLE [STG].[receipts] 
INSERT INTO [STG].[receipts] 
	([_id],[bonusPointsEarned],[bonusPointsEarnedReason],[createDate], [dateScanned],
	[finishedDate], [modifyDate],[pointsAwardedDate],[pointsEarned],[purchaseDate], [purchasedItemCount],[rewardsReceiptItemListBarcode],
	[rewardsReceiptItemListdescription],[rewardsReceiptItemListfinalPrice],[rewardsReceiptItemListitemPrice],
	[rewardsReceiptItemListneedsFetchReview], [rewardsReceiptItemListneedsFetchReviewReason],[rewardsReceiptItemListpartnerItemId],
	[rewardsReceiptItemListpointsNotAwardedReason], [rewardsReceiptItemListpointsPayerId],[rewardsReceiptItemListpreventTargetGapPoints],
	[rewardsReceiptItemListquantityPurchased],[rewardsReceiptItemListrewardsGroup], [rewardsReceiptItemListrewardsProductPartnerId],
	[rewardsReceiptItemListuserFlaggedBarcode],[rewardsReceiptItemListuserFlaggedDescription], [rewardsReceiptItemListuserFlaggedNewItem],
	[rewardsReceiptItemListuserFlaggedPrice],[rewardsReceiptItemListuserFlaggedQuantity], [rewardsReceiptStatus],
	[totalSpent],[userId])
SELECT 
	JSON_VALUE(p.value,'$._id.oid') AS _id,
	JSON_VALUE(p.value,'$.bonusPointsEarned') AS bonusPointsEarned,
	JSON_VALUE(p.value,'$.bonusPointsEarnedReason') AS bonusPointsEarnedReason,
	JSON_VALUE(p.value,'$.createDate.date') AS createDate,
	JSON_VALUE(p.value,'$.dateScanned.date') AS dateScanned,
	JSON_VALUE(p.value,'$.finishedDate.date') AS finishedDate,
	JSON_VALUE(p.value,'$.modifyDate.date') AS modifyDate,
	JSON_VALUE(p.value,'$.pointsAwardedDate.date') AS pointsAwardedDate,
	JSON_VALUE(p.value,'$.pointsEarned') AS pointsEarned,
	JSON_VALUE(p.value,'$.purchaseDate.date') AS purchaseDate,
	JSON_VALUE(p.value,'$.purchasedItemCount') AS purchasedItemCount,
	JSON_VALUE(c.value,'$.barcode') AS rewardsReceiptItemListBarcode,
	JSON_VALUE(c.value,'$.description') AS rewardsReceiptItemListdescription,
	JSON_VALUE(c.value,'$.finalPrice') AS rewardsReceiptItemListfinalPrice,
	JSON_VALUE(c.value,'$.itemPrice') AS rewardsReceiptItemListitemPrice,
	JSON_VALUE(c.value,'$.needsFetchReview') AS rewardsReceiptItemListneedsFetchReview,
	JSON_VALUE(c.value,'$.needsFetchReviewReason') AS rewardsReceiptItemListneedsFetchReviewReason,
	JSON_VALUE(c.value,'$.partnerItemId') AS rewardsReceiptItemListpartnerItemId,
	JSON_VALUE(c.value,'$.pointsNotAwardedReason') AS rewardsReceiptItemListpointsNotAwardedReason,
	JSON_VALUE(c.value,'$.pointsPayerId') AS rewardsReceiptItemListpointsPayerId,
	JSON_VALUE(c.value,'$.preventTargetGapPoints') AS rewardsReceiptItemListpreventTargetGapPoints,
	JSON_VALUE(c.value,'$.quantityPurchased') AS rewardsReceiptItemListquantityPurchased,
	JSON_VALUE(c.value,'$.rewardsGroup') AS rewardsReceiptItemListrewardsGroup,
	JSON_VALUE(c.value,'$.rewardsProductPartnerId') AS rewardsReceiptItemListrewardsProductPartnerId,
	JSON_VALUE(c.value,'$.userFlaggedBarcode') AS rewardsReceiptItemListuserFlaggedBarcode,
	JSON_VALUE(c.value,'$.userFlaggedDescription') AS rewardsReceiptItemListuserFlaggedDescription,
	JSON_VALUE(c.value,'$.userFlaggedNewItem') AS rewardsReceiptItemListuserFlaggedNewItem,
	JSON_VALUE(c.value,'$.userFlaggedPrice') AS rewardsReceiptItemListuserFlaggedPrice,
	JSON_VALUE(c.value,'$.userFlaggedQuantity') AS rewardsReceiptItemListuserFlaggedQuantity,
	JSON_VALUE(p.value,'$.rewardsReceiptStatus') AS rewardsReceiptStatus,
	JSON_VALUE(p.value,'$.totalSpent') AS totalSpent,
	JSON_VALUE(p.value,'$.userId') AS userId
FROM OPENJSON(@json) AS p CROSS APPLY OPENJSON (p.value,'$.rewardsReceiptItemList') AS c

UPDATE [STG].[receipts] SET rewardsReceiptItemListBarcode = 999999 WHERE rewardsReceiptItemListBarcode IS NULL

--Load missing users records - handling early arriving facts
INSERT INTO [DW].[dimUsers]([_id]
           ,[active]
           ,[createdDate]
           ,[lastLogin]
           ,[role]
           ,[signUpSource]
           ,[state])
select distinct userId, 1, GETDATE(), NULL, NULL, NULL, NULL from [STG].[receipts] 
WHERE userId not in (SELECT _id from [DW].[dimUsers])

--Load missing brands records - handling early arriving facts
INSERT INTO [DW].[dimBrands]
           ([barcode]
           ,[_id]
           ,[brandCode]
           ,[category]
           ,[categoryCode]
           ,[cpgIdOid]
           ,[cpgIdRef]
           ,[name]
           ,[topBrand])
select distinct rewardsReceiptItemListBarcode, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL from [STG].[receipts]
WHERE rewardsReceiptItemListBarcode NOT IN (SELECT barcode FROM [DW].[dimBrands]) 

--DW data load
INSERT INTO [DW].[factReceipts] 
	([_id],[bonusPointsEarned],[bonusPointsEarnedReason],[createDate], [dateScanned],
	[finishedDate], [modifyDate],[pointsAwardedDate],[pointsEarned],[purchaseDate], [purchasedItemCount],[rewardsReceiptItemListBarcode],
	[rewardsReceiptItemListdescription],[rewardsReceiptItemListfinalPrice],[rewardsReceiptItemListitemPrice],
	[rewardsReceiptItemListneedsFetchReview], [rewardsReceiptItemListneedsFetchReviewReason],[rewardsReceiptItemListpartnerItemId],
	[rewardsReceiptItemListpointsNotAwardedReason], [rewardsReceiptItemListpointsPayerId],[rewardsReceiptItemListpreventTargetGapPoints],
	[rewardsReceiptItemListquantityPurchased],[rewardsReceiptItemListrewardsGroup], [rewardsReceiptItemListrewardsProductPartnerId],
	[rewardsReceiptItemListuserFlaggedBarcode],[rewardsReceiptItemListuserFlaggedDescription], [rewardsReceiptItemListuserFlaggedNewItem],
	[rewardsReceiptItemListuserFlaggedPrice],[rewardsReceiptItemListuserFlaggedQuantity], [rewardsReceiptStatus],
	[totalSpent],[userCode], [barcode])
SELECT 
	r.[_id],[bonusPointsEarned],[bonusPointsEarnedReason],
	DATEADD(SECOND, cast([createDate] as bigint)  / 1000, '19700101 00:00') AS createDate,  
	DATEADD(SECOND, cast([dateScanned] as bigint)  / 1000, '19700101 00:00') AS dateScanned,
	DATEADD(SECOND, cast([finishedDate] as bigint)  / 1000, '19700101 00:00') AS finishedDate,
	DATEADD(SECOND, cast([modifyDate] as bigint)  / 1000, '19700101 00:00') AS modifyDate,
	DATEADD(SECOND, cast([pointsAwardedDate] as bigint)  / 1000, '19700101 00:00') AS pointsAwardedDate,
	[pointsEarned],
	DATEADD(SECOND, cast([purchaseDate] as bigint)  / 1000, '19700101 00:00') AS purchaseDate,
	[purchasedItemCount],[rewardsReceiptItemListBarcode],
	[rewardsReceiptItemListdescription],[rewardsReceiptItemListfinalPrice],[rewardsReceiptItemListitemPrice],
	[rewardsReceiptItemListneedsFetchReview], [rewardsReceiptItemListneedsFetchReviewReason],[rewardsReceiptItemListpartnerItemId],
	[rewardsReceiptItemListpointsNotAwardedReason], [rewardsReceiptItemListpointsPayerId],[rewardsReceiptItemListpreventTargetGapPoints],
	[rewardsReceiptItemListquantityPurchased],[rewardsReceiptItemListrewardsGroup], [rewardsReceiptItemListrewardsProductPartnerId],
	[rewardsReceiptItemListuserFlaggedBarcode],[rewardsReceiptItemListuserFlaggedDescription], [rewardsReceiptItemListuserFlaggedNewItem],
	[rewardsReceiptItemListuserFlaggedPrice],[rewardsReceiptItemListuserFlaggedQuantity], [rewardsReceiptStatus],
	[totalSpent], u.usersCode, b.barcode
FROM [STG].[receipts] r
LEFT OUTER JOIN [DW].[dimUsers] u ON r.userId = u.[_id] 
LEFT OUTER JOIN [DW].[dimBrands] b ON r.rewardsReceiptItemListBarcode = b.[barcode] 


