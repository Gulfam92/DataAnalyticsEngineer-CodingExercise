USE [FetchRewards]
GO

CREATE SCHEMA STG
GO

/****** Object:  Table [STG].[brands]    Script Date: 3/22/2021 12:44:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [STG].[brands](
	[_id] [varchar](250) NOT NULL,
	[barcode] [varchar](250) NULL,
	[brandCode] [varchar](250) NULL,
	[category] [varchar](250) NULL,
	[categoryCode] [varchar](250) NULL,
	[cpgIdOid] [varchar](250) NOT NULL,
	[cpgIdRef] [varchar](250) NULL,
	[name] [varchar](250) NULL,
	[topBrand] [varchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [STG].[Receipts]    Script Date: 3/22/2021 12:44:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [STG].[Receipts](
	[_id] [varchar](250) NULL,
	[bonusPointsEarned] [varchar](250) NULL,
	[bonusPointsEarnedReason] [varchar](250) NULL,
	[createDate] [varchar](250) NULL,
	[dateScanned] [varchar](250) NULL,
	[finishedDate] [varchar](250) NULL,
	[modifyDate] [varchar](250) NULL,
	[pointsAwardedDate] [varchar](250) NULL,
	[pointsEarned] [varchar](250) NULL,
	[purchaseDate] [varchar](250) NULL,
	[purchasedItemCount] [varchar](250) NULL,
	[rewardsReceiptItemListBarcode] [varchar](250) NULL,
	[rewardsReceiptItemListdescription] [varchar](250) NULL,
	[rewardsReceiptItemListfinalPrice] [varchar](250) NULL,
	[rewardsReceiptItemListitemPrice] [varchar](250) NULL,
	[rewardsReceiptItemListneedsFetchReview] [varchar](250) NULL,
	[rewardsReceiptItemListneedsFetchReviewReason] [varchar](250) NULL,
	[rewardsReceiptItemListpartnerItemId] [varchar](250) NULL,
	[rewardsReceiptItemListpointsNotAwardedReason] [varchar](250) NULL,
	[rewardsReceiptItemListpointsPayerId] [varchar](250) NULL,
	[rewardsReceiptItemListpreventTargetGapPoints] [varchar](250) NULL,
	[rewardsReceiptItemListquantityPurchased] [varchar](250) NULL,
	[rewardsReceiptItemListrewardsGroup] [varchar](250) NULL,
	[rewardsReceiptItemListrewardsProductPartnerId] [varchar](250) NULL,
	[rewardsReceiptItemListuserFlaggedBarcode] [varchar](250) NULL,
	[rewardsReceiptItemListuserFlaggedDescription] [varchar](250) NULL,
	[rewardsReceiptItemListuserFlaggedNewItem] [varchar](250) NULL,
	[rewardsReceiptItemListuserFlaggedPrice] [varchar](250) NULL,
	[rewardsReceiptItemListuserFlaggedQuantity] [varchar](250) NULL,
	[rewardsReceiptStatus] [varchar](250) NULL,
	[totalSpent] [varchar](250) NULL,
	[userId] [varchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [STG].[users]    Script Date: 3/22/2021 12:44:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [STG].[users](
	[_id] [varchar](250) NOT NULL,
	[active] [varchar](250) NULL,
	[createdDate] [varchar](250) NULL,
	[lastLogin] [varchar](250) NULL,
	[role] [varchar](250) NULL,
	[signUpSource] [varchar](250) NULL,
	[state] [varchar](250) NULL
) ON [PRIMARY]
GO
