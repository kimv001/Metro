
CREATE PROCEDURE rep.[999_adf_dwh_time] AS /*
=== Comments =========================================

Description:
	creates a time table

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
=======================================================
*/ IF NOT EXISTS

        (SELECT 1

          FROM information_schema.tables

         WHERE table_type = 'BASE TABLE'

           AND TABLE_NAME = 'DWH_Time'
       )
CREATE TABLE [adf].[dwh_time]([time_hh_mm_ss] [time](7) NULL, [time_int] [int] NULL)
    ON [primary] ;
TRUNCATE TABLE [adf].[dwh_time] ;WITH hours AS

        (SELECT dateadd(dd, 0, datediff(dd, 0, getdate())) AS dthr

     UNION ALL SELECT dateadd (MINUTE, 1, dthr)

          FROM hours

         WHERE dthr < dateadd(dd, 0, datediff(dd, 0, dateadd (d, 1, getdate())))
       )
INSERT INTO [adf].[dwh_time] ([time_hh_mm_ss], [time_int])
SELECT DISTINCT cast(dthr AS TIME) time_hh_mm_ss,

       (datepart(HOUR, cast(dthr AS TIME)) * 60) + (datepart(MINUTE, cast(dthr AS TIME))) time_int

  FROM hours
OPTION (maxrecursion 0)
