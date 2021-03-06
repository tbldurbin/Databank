SELECT A.distributionid                    AS DB_id, 
       '2018-07-07'                        AS BatchDate, 
       A.id                                AS PSRId, 
       A.NAME                              AS PSRName, 
       B.sku_id                            AS SKUId, 
       B.skuname                           AS SKUName, 
       B.pack_size                         AS PackSize, 
       B.skuvolume_8oz                     AS SKUVolume8oz, 
       Isnull(C.unit_sale_price, 0)        AS UnitPrice, 
       Isnull(C.delivered_quentity, 0)     AS Delivered_Quentity, 
       Isnull(D.freedelivered_quentity, 0) AS FreeDelivered_Quentity 
FROM   tbld_distribution_employee AS A 
       INNER JOIN (SELECT DISTINCT t1.db_id, 
                                   t1.psr_id, 
                                   t2.sku_id, 
                                   t3.skuname, 
                                   t2.pack_size, 
                                   t3.skuvolume_8oz 
                   FROM   tblt_order AS t1 
                          INNER JOIN tblt_order_line AS t2 
                                  ON t1.orderid = t2.orderid 
                          LEFT JOIN tbld_sku AS t3 
                                 ON t2.sku_id = t3.sku_id 
                   WHERE  t1.delivery_date = '2018-07-07') AS B 
               ON A.distributionid = B.db_id 
                  AND A.id = B.psr_id 
       LEFT JOIN (SELECT t1.db_id, 
                         t1.psr_id, 
                         t2.sku_id, 
                         t3.skuname, 
                         t2.pack_size, 
                         t2.unit_sale_price, 
                         Sum(t2.quantity_delivered) AS Delivered_Quentity 
                  FROM   tblt_order AS t1 
                         INNER JOIN tblt_order_line AS t2 
                                 ON t1.orderid = t2.orderid 
                         LEFT JOIN tbld_sku AS t3 
                                ON t2.sku_id = t3.sku_id 
                  WHERE  t1.delivery_date = '2018-07-07' 
                         AND t2.sku_order_type_id = 1 
                  GROUP  BY t1.db_id, 
                            t1.psr_id, 
                            t3.skuname, 
                            t2.sku_id, 
                            t2.pack_size, 
                            t2.unit_sale_price) AS C 
              ON A.distributionid = C.db_id 
                 AND A.id = C.psr_id 
                 AND B.sku_id = C.sku_id 
       LEFT JOIN (SELECT t1.db_id, 
                         t1.psr_id, 
                         t2.sku_id, 
                         t3.skuname, 
                         t2.pack_size, 
                         Sum(t2.quantity_delivered) AS FreeDelivered_Quentity 
                  FROM   tblt_order AS t1 
                         INNER JOIN tblt_order_line AS t2 
                                 ON t1.orderid = t2.orderid 
                         LEFT JOIN tbld_sku AS t3 
                                ON t2.sku_id = t3.sku_id 
                  WHERE  t1.delivery_date = '2018-07-07' 
                         AND t2.sku_order_type_id = 2 
                  GROUP  BY t1.db_id, 
                            t1.psr_id, 
                            t3.skuname, 
                            t2.sku_id, 
                            t2.pack_size) AS D 
              ON A.distributionid = D.db_id 
                 AND A.id = D.psr_id 
                 AND B.sku_id = D.sku_id 
WHERE  A.active = 1 
       AND A.emp_type = 2 
       AND A.distributionid = 1 