USE [ODMS]
GO
/****** Object:  StoredProcedure [dbo].[DayEnd_PSRWiseMonthTGT]    Script Date: 26-Jul-18 12:40:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[DayEnd_PSRWiseMonthTGT]
	@Db_id int,
	@target_id int,
	@BatchDate Datetime
AS
BEGIN

Delete FROM [dbo].[tblr_PSRWiseMonthTGT]  where [target_id]=@target_id AND db_id=@Db_id;


INSERT INTO [dbo].[tblr_PSRWiseMonthTGT]
           ([target_id]
           ,[db_id]
           ,[psr_id]
           ,[TotalTGTCS]
           ,[TotalTGTVolume8oz]
           ,[TGTOrder]
           ,[TGTConfirmed]
           ,[TGTDelivered])
SELECT a1.target_id, a1.db_id, a1.psr_id, Sum(a1.total_Qty/a1.Pack_size) As TotalTGTCS,  Sum(a1.total_Qty * a2.SKUVolume_8oz) TotalTGTVolume8oz,IsNULL(a3.TGTOrder,0)AS TGTOrder,IsNULL(a3.TGTConfirmed,0)As TGTConfirmed,IsNULL(a3.TGTDelivered,0)AS TGTDelivered
FROM     tbld_Target_PSR_Details AS a1 INNER JOIN
                  tbld_SKU AS a2 ON a1.sku_id = a2.SKU_id
				  Left Join (SELECT t1.db_id,t1.psr_id,Sum(t2.quantity_ordered/t2.Pack_size) AS TGTOrder, 
                  Sum(t2.quantity_confirmed/t2.Pack_size) AS TGTConfirmed, Sum(t2.quantity_delivered/t2.Pack_size) AS TGTDelivered
FROM     tblt_Order AS t1 INNER JOIN
                  tblt_Order_line AS t2 ON t1.Orderid = t2.Orderid
				  where datepart(month,t1.planned_order_date)=datepart(month,@BatchDate) AND t1.db_id=@Db_id
				  group by t1.db_id,t1.psr_id) As a3 on a3.db_id=a1.db_id and a3.psr_id=a1.psr_id
				  Where a1.db_id=@Db_id and a1.target_id=@target_id
				  Group by a1.target_id, a1.db_id, a1.psr_id,a3.TGTOrder,a3.TGTConfirmed,a3.TGTDelivered
END
