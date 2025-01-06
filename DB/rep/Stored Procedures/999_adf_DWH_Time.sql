
CREATE procedure rep.[999_adf_DWH_Time] as
/* 
=== Comments =========================================

Description:
	creates a time table
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
=======================================================
*/

iF not EXISTS (	Select 1 
				From INFORMATION_SCHEMA.TABLES 
				Where TABLE_TYPE='BASE TABLE' AND TABLE_NAME='DWH_Time') 

Create table [adf].[DWH_Time](
						[Time_HH_MM_SS] [time](7) NULL,
						[Time_Int] [int] NULL
					) ON [PRIMARY]
;


truncate table [adf].[DWH_Time]

;


  with Hours as
  (
       select DATEADD(
        dd, 0, DATEDIFF(
              dd, 0,  getDate() )
      ) as dtHr
    union all
      select  DATEADD (minute , 1 , dtHr ) 
        from Hours
		
        where dtHr < DATEADD(
            dd, 0, DATEDIFF(
                  dd, 0, DATEADD (
                        d , 1 , getDate() 
                      )
                )
        )
  )  
  
  INSERT INTO [adf].[DWH_Time]
           ([Time_HH_MM_SS]
           ,[Time_Int])
     
  
  select distinct cast(dtHr as time) Time_HH_MM_SS , (DATEPART(hour, cast(dtHr as time)) * 60) + (DATEPART(minute, cast(dtHr as time)) ) Time_Int

  from Hours option (maxrecursion 0)