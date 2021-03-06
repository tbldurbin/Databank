USE [ODMS]
GO
/****** Object:  StoredProcedure [dbo].[RPT_Delivery_PSRPerformanceKPISummary]    Script Date: 26-Jul-18 1:08:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE  [dbo].[RPT_Delivery_PSRPerformanceKPISummary]
	@Start_Date Datetime,
	@End_Date Datetime
AS
BEGIN
	SELECT A.DB_Id, A.DB_Name, A.CEAREA_Name, A.AREA_Name, A.REGION_Name, A.DBCode, A.OfficeAddress,A.cluster,A.PSR_Code, B.PerformerId, B.PerformerName, 
                  C.TotalTGTCS, C.TotalTGTVolume8oz, SUM(B.SalesScheduleCall) AS SalesScheduleCall, SUM(B.SalesMemo) AS SalesMemo, SUM(B.TotalLineSold) AS TotalLineSold, SUM(B.TotalSoldInVolume) AS TotalSoldInVolume8oZ, 
                  SUM(B.TotalSoldInCase) AS TotalSoldInCase, SUM(B.TotalSoldInValue) AS TotalSoldInValue, SUM(B.TotalOrderedInVolume) AS TotalOrderedInVolume8oZ, SUM(B.TotalOrderedInCase) AS TotalOrderedInCase, 
                  SUM(B.TotalOrderedInValue) AS TotalOrderedInValue
FROM     tbld_db_psr_zone_view AS A INNER JOIN tblr_PerformanceKPI AS B ON A.DB_Id = B.DB_id AND A.PSR_id=B.PerformerId
LEFT JOIN (SELECT db_id, psr_id, sum(TotalTGTCS) AS TotalTGTCS,Sum(TotalTGTVolume8oz) AS TotalTGTVolume8oz
FROM     tblr_PSRWiseMonthTGT
WHERE  target_id IN (SELECT DISTINCT t1.id FROM      tbld_Target AS t1 INNER JOIN
                                         tbl_calendar AS t2 ON t1.MonthNo = t2.MonthNo AND t1.Year=t2.Year
										 Where t2.Date between @Start_Date AND @End_Date)
GROUP BY db_id, psr_id)AS C on C.db_id=A.DB_Id AND C.psr_id=B.PerformerId 
Where B.BatchDate between @Start_Date AND @End_Date
GROUP BY A.REGION_Name, A.AREA_Name, A.CEAREA_Name, A.DB_Id, A.DB_Name, A.DBCode,A.OfficeAddress,A.cluster,A.PSR_Code, B.PerformerId, B.PerformerName, C.TotalTGTCS, C.TotalTGTVolume8oz

END
