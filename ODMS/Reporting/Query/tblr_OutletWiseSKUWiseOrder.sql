
SELECT 
'2018-07-06'                        AS BatchDate
,A.OutletId
      ,A.OutletCode
      ,A.OutletName 
      ,A.Distributorid
      ,A.HaveVisicooler
	  ,B.sku_id AS SKUId
	  ,B.SKUName
	  ,B.PackSize AS PackSize
	  ,Isnull(C.UnitPrice, 0)         AS UnitPrice
	  ,B.SKUVolume_8oz As SKUVolume8oz
	  ,Isnull(C.order_quentity, 0)         AS Order_Quentity,	  
       Isnull(C.confirmed_quantity, 0)     AS Confirmed_Quantity, 
       Isnull(D.FreeOrder_Quentity, 0)     AS FreeOrder_Quentity, 
       Isnull(D.FreeConfirmed_Quantity, 0) AS FreeConfirmed_Quantity
  FROM tbld_Outlet as A

   INNER JOIN (SELECT DISTINCT t1.db_id
		,t1.outlet_id
		,t2.sku_id
		,t3.SKUName
		,t2.Pack_size As PackSize,
		 t3.SKUVolume_8oz
	FROM tblt_Order AS t1
	INNER JOIN tblt_Order_line AS t2 ON t1.Orderid = t2.Orderid
	LEFT JOIN tbld_SKU AS t3 ON t2.sku_id = t3.SKU_id
                   WHERE  t1.planned_order_date = '2018-07-06') AS B 
               ON A.Distributorid = B.db_id 
                  AND A.OutletId = B.outlet_id

				  Left Join (SELECT t1.db_id, t1.outlet_id, t2.sku_id,t2.unit_sale_price As UnitPrice,sum(t2.quantity_ordered) AS Order_Quentity, sum(t2.quantity_confirmed) AS Confirmed_Quantity
FROM     tblt_Order as t1 INNER JOIN
                  tblt_Order_line as t2 ON t1.Orderid = t2.Orderid
				  Left Join tbld_SKU as t3 on t2.sku_id=t3.SKU_id
				  where  t1.planned_order_date='2018-07-06' and  t2.sku_order_type_id=1 and t1.so_status<>9
				  Group by t1.db_id,t1.outlet_id,t3.SKUName, t2.sku_id,t2.Pack_size,t2.unit_sale_price) As C on A.Distributorid=C.db_id AND A.OutletId=C.outlet_id AND B.sku_id=C.sku_id
				   Left Join (SELECT t1.db_id, t1.outlet_id, t2.sku_id,t3.SKUName,t2.Pack_size,sum(t2.quantity_ordered) AS FreeOrder_Quentity, sum(t2.quantity_confirmed) AS FreeConfirmed_Quantity
FROM     tblt_Order as t1 INNER JOIN
                  tblt_Order_line as t2 ON t1.Orderid = t2.Orderid
				  Left Join tbld_SKU as t3 on t2.sku_id=t3.SKU_id
				  where  t1.planned_order_date='2018-07-06' and  t2.sku_order_type_id=2 and t1.so_status<>9
				  Group by t1.db_id,t1.outlet_id,t3.SKUName, t2.sku_id,t2.Pack_size) As D on A.Distributorid=D.db_id AND A.OutletId=D.outlet_id AND B.sku_id=D.sku_id
  where A.Distributorid=1
  