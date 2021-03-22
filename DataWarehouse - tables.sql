USE [FetchRewards]
GO
/****** Object:  Table [DW].[dimBrands]    Script Date: 3/22/2021 2:57:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[dimBrands](
	[barcode] [varchar](15) NOT NULL,
	[_id] [varchar](50) NULL,
	[brandCode] [varchar](50) NULL,
	[category] [varchar](50) NULL,
	[categoryCode] [varchar](50) NULL,
	[cpgIdOid] [varchar](50) NULL,
	[cpgIdRef] [char](5) NULL,
	[name] [varchar](200) NULL,
	[topBrand] [bit] NULL,
 CONSTRAINT [PK_dimBrands] PRIMARY KEY CLUSTERED 
(
	[barcode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [DW].[dimUsers]    Script Date: 3/22/2021 2:57:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[dimUsers](
	[usersCode] [int] IDENTITY(1,1) NOT NULL,
	[_id] [varchar](50) NOT NULL,
	[active] [bit] NULL,
	[createdDate] [datetime] NULL,
	[lastLogin] [datetime] NULL,
	[role] [varchar](50) NULL,
	[signUpSource] [varchar](50) NULL,
	[state] [char](2) NULL,
 CONSTRAINT [PK_dimUsers] PRIMARY KEY CLUSTERED 
(
	[usersCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [DW].[factReceipts]    Script Date: 3/22/2021 2:57:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[factReceipts](
	[receiptCode] [int] IDENTITY(1,1) NOT NULL,
	[userCode] [int] NULL,
	[barcode] [varchar](15) NULL,
	[_id] [varchar](50) NOT NULL,
	[bonusPointsEarned] [varchar](20) NULL,
	[bonusPointsEarnedReason] [varchar](250) NULL,
	[createDate] [datetime] NULL,
	[dateScanned] [datetime] NULL,
	[finishedDate] [datetime] NULL,
	[modifyDate] [datetime] NULL,
	[pointsAwardedDate] [datetime] NULL,
	[pointsEarned] [varchar](20) NULL,
	[purchaseDate] [datetime] NULL,
	[purchasedItemCount] [int] NULL,
	[rewardsReceiptItemListBarcode] [varchar](20) NULL,
	[rewardsReceiptItemListdescription] [varchar](250) NULL,
	[rewardsReceiptItemListfinalPrice] [varchar](10) NULL,
	[rewardsReceiptItemListitemPrice] [varchar](10) NULL,
	[rewardsReceiptItemListneedsFetchReview] [char](6) NULL,
	[rewardsReceiptItemListneedsFetchReviewReason] [varchar](50) NULL,
	[rewardsReceiptItemListpartnerItemId] [varchar](20) NULL,
	[rewardsReceiptItemListpointsNotAwardedReason] [varchar](50) NULL,
	[rewardsReceiptItemListpointsPayerId] [varchar](50) NULL,
	[rewardsReceiptItemListpreventTargetGapPoints] [char](6) NULL,
	[rewardsReceiptItemListquantityPurchased] [varchar](10) NULL,
	[rewardsReceiptItemListrewardsGroup] [varchar](250) NULL,
	[rewardsReceiptItemListrewardsProductPartnerId] [varchar](50) NULL,
	[rewardsReceiptItemListuserFlaggedBarcode] [varchar](20) NULL,
	[rewardsReceiptItemListuserFlaggedDescription] [varchar](250) NULL,
	[rewardsReceiptItemListuserFlaggedNewItem] [char](6) NULL,
	[rewardsReceiptItemListuserFlaggedPrice] [varchar](20) NULL,
	[rewardsReceiptItemListuserFlaggedQuantity] [varchar](20) NULL,
	[rewardsReceiptStatus] [varchar](20) NULL,
	[totalSpent] [float] NULL,
 CONSTRAINT [PK_factReceipts] PRIMARY KEY CLUSTERED 
(
	[receiptCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [DW].[factReceipts]  WITH CHECK ADD  CONSTRAINT [FK_factReceipts_dimBrands] FOREIGN KEY([barcode])
REFERENCES [DW].[dimBrands] ([barcode])
GO
ALTER TABLE [DW].[factReceipts] CHECK CONSTRAINT [FK_factReceipts_dimBrands]
GO
ALTER TABLE [DW].[factReceipts]  WITH CHECK ADD  CONSTRAINT [FK_factReceipts_dimUsers] FOREIGN KEY([userCode])
REFERENCES [DW].[dimUsers] ([usersCode])
GO
ALTER TABLE [DW].[factReceipts] CHECK CONSTRAINT [FK_factReceipts_dimUsers]
GO
