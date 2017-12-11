/* 
	SaveMoreCase 2016 - Roelant Vos
    Please don't distribute
*/

--USE [EDW_000_Source]
USE [DVI_000_Source]

DELETE FROM [dbo].[CUST_MEMBERSHIP]
DELETE FROM [dbo].[CUSTOMER_OFFER]
DELETE FROM [dbo].[CUSTOMER_PERSONAL]
DELETE FROM [dbo].[ESTIMATED_WORTH]
DELETE FROM [dbo].[OFFER] 
DELETE FROM [dbo].[PERSONALISED_COSTING]
DELETE FROM [dbo].[PLAN]

INSERT [dbo].[CUST_MEMBERSHIP] ([CustomerID], [Plan_Code], [Start_Date], [End_Date], [Status]) VALUES (235892, N'HIGH', CAST(N'2012-05-12 00:00:00.000' AS DateTime), CAST(N'2015-12-31 00:00:00.000' AS DateTime), N'High')
INSERT [dbo].[CUST_MEMBERSHIP] ([CustomerID], [Plan_Code], [Start_Date], [End_Date], [Status]) VALUES (321799, N'AVG', CAST(N'2010-01-01 00:00:00.000' AS DateTime), CAST(N'2014-10-28 00:00:00.000' AS DateTime), N'Open')
INSERT [dbo].[CUST_MEMBERSHIP] ([CustomerID], [Plan_Code], [Start_Date], [End_Date], [Status]) VALUES (683492, N'LOW', CAST(N'2012-12-12 00:00:00.000' AS DateTime), CAST(N'2020-02-27 00:00:00.000' AS DateTime), N'Active')
INSERT [dbo].[CUSTOMER_OFFER] ([CustomerID], [OfferID]) VALUES (235892, 450)
INSERT [dbo].[CUSTOMER_OFFER] ([CustomerID], [OfferID]) VALUES (258279, 450)
INSERT [dbo].[CUSTOMER_OFFER] ([CustomerID], [OfferID]) VALUES (321799, 469)
INSERT [dbo].[CUSTOMER_PERSONAL] ([CustomerID], [Given], [Surname], [Suburb], [State], [Postcode], [Country], [Gender], [DOB], [Contact_Number], [Referee_Offer_Made]) VALUES (235892, N'Simon', N'Vos', N'Sydney', N'NSW', N'1000', N'Australia', N'M', CAST(N'1960-12-10' AS Date), 9874634, 1)
INSERT [dbo].[CUSTOMER_PERSONAL] ([CustomerID], [Given], [Surname], [Suburb], [State], [Postcode], [Country], [Gender], [DOB], [Contact_Number], [Referee_Offer_Made]) VALUES (258279, N'John', N'Doe', N'Indooropilly', N'QLD', N'4000', N'Australia', N'M', CAST(N'1980-01-04' AS Date), 41234, 1)
INSERT [dbo].[CUSTOMER_PERSONAL] ([CustomerID], [Given], [Surname], [Suburb], [State], [Postcode], [Country], [Gender], [DOB], [Contact_Number], [Referee_Offer_Made]) VALUES (321799, N'Jonathan', N'Slimpy', N'London', N'N/A', N'0000', N'UK', N'M', CAST(N'1951-01-04' AS Date), 23555, 1)
INSERT [dbo].[CUSTOMER_PERSONAL] ([CustomerID], [Given], [Surname], [Suburb], [State], [Postcode], [Country], [Gender], [DOB], [Contact_Number], [Referee_Offer_Made]) VALUES (683492, N'Mary', N'Smith', N'Bulimba', N'QLD', N'3000', N'Australia', N'F', CAST(N'1977-04-12' AS Date), 41234, 0)
INSERT [dbo].[CUSTOMER_PERSONAL] ([CustomerID], [Given], [Surname], [Suburb], [State], [Postcode], [Country], [Gender], [DOB], [Contact_Number], [Referee_Offer_Made]) VALUES (885325, N'Michael', N'Evans', N'Bourke', N'NWS', N'2000', N'Australia', N'M', CAST(N'1985-04-19' AS Date), 89235, 0)
INSERT [dbo].[ESTIMATED_WORTH] ([Plan_Code], [Date_effective], [Value_Amount]) VALUES (N'AVG', CAST(N'2016-06-06 00:00:00.000' AS DateTime), CAST(10 AS Numeric(18, 0)))
INSERT [dbo].[ESTIMATED_WORTH] ([Plan_Code], [Date_effective], [Value_Amount]) VALUES (N'HIGH', CAST(N'2011-01-01 00:00:00.000' AS DateTime), CAST(1545000 AS Numeric(18, 0)))
INSERT [dbo].[ESTIMATED_WORTH] ([Plan_Code], [Date_effective], [Value_Amount]) VALUES (N'LOW', CAST(N'2012-05-04 00:00:00.000' AS DateTime), CAST(450000 AS Numeric(18, 0)))
INSERT [dbo].[ESTIMATED_WORTH] ([Plan_Code], [Date_effective], [Value_Amount]) VALUES (N'LOW', CAST(N'2013-06-19 00:00:00.000' AS DateTime), CAST(550000 AS Numeric(18, 0)))
INSERT [dbo].[OFFER] ([OfferID], [Offer_Long_Description]) VALUES (450, N'20% off all future purchases')
INSERT [dbo].[OFFER] ([OfferID], [Offer_Long_Description]) VALUES (462, N'10% off all future purchases')
INSERT [dbo].[OFFER] ([OfferID], [Offer_Long_Description]) VALUES (469, N'Free movie tickets')
INSERT [dbo].[PERSONALISED_COSTING] ([Member], [Segment], [Plan_Code], [Date_effective], [Monthly_Cost]) VALUES (258279, N'LOW', N'HIGH', CAST(N'2014-01-01 00:00:00.000' AS DateTime), CAST(150 AS Numeric(18, 0)))
INSERT [dbo].[PERSONALISED_COSTING] ([Member], [Segment], [Plan_Code], [Date_effective], [Monthly_Cost]) VALUES (683492, N'HIGH', N'AVG', CAST(N'2013-01-01 00:00:00.000' AS DateTime), CAST(450 AS Numeric(18, 0)))
INSERT [dbo].[PERSONALISED_COSTING] ([Member], [Segment], [Plan_Code], [Date_effective], [Monthly_Cost]) VALUES (885325, N'MED', N'AVG', CAST(N'2013-01-01 00:00:00.000' AS DateTime), CAST(475 AS Numeric(18, 0)))
INSERT [dbo].[PLAN] ([Plan_Code], [Plan_Desc], [Renewal_Plan_Code]) VALUES (N'AVG', N'Average / Mix plan', 'SUPR')
INSERT [dbo].[PLAN] ([Plan_Code], [Plan_Desc], [Renewal_Plan_Code]) VALUES (N'HIGH', N'Highroller / risk embracing', 'SUPR')
INSERT [dbo].[PLAN] ([Plan_Code], [Plan_Desc], [Renewal_Plan_Code]) VALUES (N'LOW', N'Risk avoiding', 'MAXM')
