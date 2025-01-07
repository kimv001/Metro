 -- noqa: PRS
CREATE PROCEDURE rep.[999_adf_DWH_Time] AS
/* 
=== Comments =========================================

Description:
	creates a time table
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
=======================================================
*/

IF NOT EXISTS (	SELECT 1 
				FROM INFORMATION_SCHEMA.TABLES 
				WHERE TABLE_TYPE='BASE TABLE' AND TABLE_NAME='DWH_Time') 

CREATE TABLE [adf].[DWH_Time](
						[Time_HH_MM_SS] [time](7) NULL,
						[Time_Int] [int] NULL
					) ON [PRIMARY]
;


TRUNCATE TABLE [adf].[DWH_Time]

;


  WITH Hours AS
  (
       SELECT DATEADD(
        DD, 0, DATEDIFF(
              DD, 0,  getDate() )
      ) AS dtHr
    UNION ALL
      SELECT  DATEADD (MINUTE , 1 , dtHr ) 
        FROM Hours
		
        WHERE dtHr < DATEADD(
            DD, 0, DATEDIFF(
                  DD, 0, DATEADD (
                        D , 1 , getDate() 
                      )
                )
        )
  )  
  
  INSERT INTO [adf].[DWH_Time]
           ([Time_HH_MM_SS]
           ,[Time_Int])
     
  
  SELECT DISTINCT CAST(dtHr AS time) Time_HH_MM_SS , (DATEPART(HOUR, CAST(dtHr AS time)) * 60) + (DATEPART(MINUTE, CAST(dtHr AS time)) ) Time_Int

  FROM Hours OPTION (MAXRECURSION 0)