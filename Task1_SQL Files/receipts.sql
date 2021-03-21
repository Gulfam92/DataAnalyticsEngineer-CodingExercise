use FetchRewards
Declare @JSON varchar(max)
SELECT @JSON=BulkColumn
FROM OPENROWSET (BULK 'F:\Gulfam\FetchRewards\receipts\receiptscleansed.json', SINGLE_CLOB) as j

insert into [dbo].[receipts1] 
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
DATEADD(SECOND, cast(JSON_VALUE(p.value,'$.createDate.date') as bigint)  / 1000, '19700101 00:00') AS createDate,
DATEADD(SECOND, cast(JSON_VALUE(p.value,'$.dateScanned.date') as bigint)  / 1000, '19700101 00:00') AS dateScanned,
DATEADD(SECOND, cast(JSON_VALUE(p.value,'$.finishedDate.date') as bigint)  / 1000, '19700101 00:00') AS finishedDate,
DATEADD(SECOND, cast(JSON_VALUE(p.value,'$.modifyDate.date') as bigint)  / 1000, '19700101 00:00') AS modifyDate,
DATEADD(SECOND, cast(JSON_VALUE(p.value,'$.pointsAwardedDate.date') as bigint)  / 1000, '19700101 00:00') AS pointsAwardedDate,
JSON_VALUE(p.value,'$.pointsEarned') AS pointsEarned,
DATEADD(SECOND, cast(JSON_VALUE(p.value,'$.purchaseDate.date') as bigint)  / 1000, '19700101 00:00') AS purchaseDate,
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
