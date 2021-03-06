USE [ODMS]
GO
/****** Object:  StoredProcedure [dbo].[ApiGetSku]    Script Date: 31-Jul-2018 4:12:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
ALTER PROCEDURE [dbo].[ApiGetSku]
	@dbid int
	
AS
BEGIN

 SELECT B.sku_id As SKUId, C.SKUName, B.batch_id,D.qty As PackSize ,B.outlet_lifting_price AS TP, B.mrp AS MRP
FROM     tbld_distribution_house AS A INNER JOIN
                  tbld_bundle_price_details AS B ON A.PriceBuandle_id = B.bundle_price_id INNER JOIN
                  tbld_SKU AS C ON B.sku_id = C.SKU_id INNER JOIN
                  tbld_SKU_unit AS D ON C.SKUUnit = D.id
WHERE  (A.DB_Id = @dbid) and B.status=1 AND (B.end_date='0001-01-01' OR B.end_date>=GETDATE())  ANd C.SKUStatus=1
Order By C.SKUsl
END
