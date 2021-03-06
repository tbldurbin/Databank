USE [ODMS]
GO
/****** Object:  StoredProcedure [dbo].[RPT_Delivery_OutletWiseSKUWiseDelivery]    Script Date: 07-Aug-2018 5:07:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[RPT_Delivery_OutletWiseSKUWiseDelivery]
	@Start_Date Datetime,
	@End_Date Datetime
AS
BEGIN
SELECT A.DB_Id, A.DB_Name, A.CEAREA_id, A.CEAREA_Name, A.AREA_id, A.AREA_Name, A.REGION_id, A.REGION_Name, A.National_id, A.[National], A.Status, A.Name, A.PSR_id, A.PSR_Code, A.DBCode, A.OfficeAddress, A.cluster, 
                  A.RouteName, A.RouteID, A.OutletId, A.OutletCode, A.OutletName, A.OutletName_b, A.Address, A.OwnerName, A.ContactNo, A.HaveVisicooler,A.IsActive, A.channel_name, A.outlet_category_name, A.Outlet_grade, B.Distributorid,B.SKUId,B.SKUName,B.PackSize,SUM(B.Delivered_Quentity) AS Delivered_Quentity,SUM(B.Delivered_Quentity* B.UnitPrice) AS Value,
                   SUM(B.FreeDelivered_Quentity) AS FreeDelivered_Quentity
FROM     tbld_db_psr_outlet_zone_view AS A INNER JOIN
                  tblr_OutletWiseSKUWiseDelivery AS B ON A.OutletId = B.OutletId
				    where   B.BatchDate between @Start_Date AND @End_Date
				  Group by A.DB_Id, A.DB_Name, A.CEAREA_id, A.CEAREA_Name, A.AREA_id, A.AREA_Name, A.REGION_id, A.REGION_Name, A.National_id, A.[National], A.Status, A.Name, A.PSR_id, A.PSR_Code, A.DBCode, A.OfficeAddress, A.cluster, 
                  A.RouteName, A.RouteID, A.OutletId, A.OutletCode, A.OutletName, A.OutletName_b, A.Address, A.OwnerName, A.ContactNo, A.HaveVisicooler,A.IsActive, A.channel_name, A.outlet_category_name, A.Outlet_grade, B.Distributorid,B.SKUId,B.SKUName,B.PackSize

				
END
