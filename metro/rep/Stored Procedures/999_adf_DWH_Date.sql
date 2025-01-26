 
CREATE PROCEDURE [rep].[999_adf_DWH_Date] AS
/* 
=== Comments =========================================

Description:
	creates a date table

Copy Paste:
	Calculate Easter Days
	Author: Jeffrey Williams
	https://www.sqlservercentral.com/scripts/calculating-easter-in-sql
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20240106	1300		K. Vermeij				Added WorkDayOfMonth and WorkDayCounter
=======================================================
*/

-- prevent set or regional settings From interfering with 
-- interpretation of dates / literals
SET DATEFIRST  1, -- 1 = Monday, 7 = Sunday
    DATEFORMAT mdy, 
    LANGUAGE   US_ENGLISH;
-- assume the above is here in all subsequent code blocks.

DECLARE @StartDate  DATE	= '20100101';											-- startdate
DECLARE @Years		INT		= 30													-- add years from startdate
DECLARE @CutoffDate DATE	= DATEADD(DAY, -1, DATEADD(YEAR, @Years, @StartDate));	-- determine enddate
DECLARE @startYear	INT		= DATEPART(YEAR, @StartDate)
DECLARE @endYear	INT		= DATEPART(YEAR, @CutoffDate)


IF OBJECT_ID('adf.DWH_date', 'U') IS NOT NULL
Drop Table [adf].[DWH_Date]
				-- 
IF OBJECT_ID('tempdb..##Easter', 'U') IS NOT NULL
Drop Table ##Easter

IF OBJECT_ID('tempdb..##BaseCalendar', 'U') IS NOT NULL
Drop Table ##BaseCalendar


Create table [adf].[DWH_Date](
					DateKey					int not null,
					TheDate					date NULL,
					TheDay					int NULL,
					TheDaySuffix			char(2) NULL,
					TheDayName				varchar(30) NULL,
					TheDayOfWeek			int NULL,
					TheDayOfWeekInMonth		tinyint NULL,
					TheDayOfYear			int		NULL,
					IsWeekend				int NOT NULL,
					IsWorkDay				int NOT NULL,
					WorkdayOfMonth			int not null,
					TheWeek					int NULL,
					TheISOweek				int NULL,
					TheFirstOfWeek			date NULL,
					TheLastOfWeek			date NULL,
					TheWeekOfMonth			tinyint NULL,
					TheMonth				int NULL,
					TheMonthName			varchar(30) NULL,
					TheFirstWorkDayOfMonth	date NULL,
					TheFirstOfMonth			date NULL,
					TheLastWorkDayOfMonth	date NULL,
					TheLastOfMonth			date NULL,
					TheFirstOfNextMonth		date NULL,
					TheLastOfNextMonth		date NULL,
					TheQuarter				int NULL,
					TheFirstOfQuarter		date NULL,
					TheLastOfQuarter		date NULL,
					TheYear					int NULL,
					TheISOYear				int NULL,
					TheFirstOfYear			date NULL,
					TheLastOfYear			date NULL,
					IsLeapYear				bit NULL,
					Has53Weeks				int NOT NULL,
					Has53ISOWeeks			int NOT NULL,
					MMYYYY					char(6) NULL,
					Style101				char(10) NULL,
					Style103				char(10) NULL,
					Style112				char(8) NULL,
					Style120				char(10) NULL,
					YearWeek				char(6) null,
					YearISOWeek				char(6) null,
					YearMonth				char(6) null,

					HolidayName				varchar(255) null,
					IsBankHoliday			int null,
					IsPublicHoliday			int null,

					HolidayName_NL			varchar(255) null,
					TheDayName_NL			varchar(255) null,
					TheMonthName_NL			varchar (255) null,
					DayCounter				bigint null,
					WorkDayCounter			bigint null,
				) ON [PRIMARY]
;





-- First we determine Easter related dates
;
		   With t(n)
			 As (
		 Select t.n 
		   From (
		 Values (0), (0), (0), (0), (0), (0), (0), (0), (0), (0)) As t(n)
				)
			  , inputYears (y)
			 As (
		 Select Top (@endYear - @startYear + 1) 
				(@startYear - 1) + row_number() over(Order By @@spid) As rn 
		   From t t1, t t2, t t3, t t4
				)
		 Select hd.*
		 into ##Easter
		   From inputYears                                      dd

		/*  Gauss' Easter algorithm

			a       y % 19                                                  year's position in the 19-year lunar phase cycle
			b,c,k   y % 4, y % 7, y / 100                                   corrections for century years
			p       (13 + 8*k) / 25                                         correct for the lunar orbit not being fully describable in integer terms
			q       k / 4                                                   leap-year exceptions in century years
			M       (15 - p + k - q) % 30                                   correct starting point at the start of each century
			N       (4 + k - q) % 7                                         starting point for each century
			d       (19*a + M) % 30                                         number of days between 21 March and the coincident or next following full moon
			e       (2*b + 4*c + 6*d + N) % 7)                              offset days that must be added to make d arrive on a Sunday
			o       iif(e = 6 And (d = 29 Or (d = 28 And a > 10)), 7, 0)    subtract days for 26 April OR 25 April AND a > 10
					Add d + e - o to March 22                               Easter Sunday (Gregorian calendar)
		*/ 
		Cross Apply (
				Select * --e7.EasterDay
				  From (Values (y % 19, y % 4, y % 7, y / 100))                                 As e1(a, b, c, k)
				 Cross Apply (Values ((13 + 8*k) / 25, k / 4))                                  As e2(p, q)
				 Cross Apply (Values ((15 - p + k - q) % 30, (4 + k - q) % 7))                  As e3(M, N)
				 Cross Apply (Values ((19*a + M) % 30))                                         As e4(d)
				 Cross Apply (Values ((2*b + 4*c + 6*d + N) % 7))                               As e5(e)
				 Cross Apply (Values (iif(e = 6 And (d = 29 Or (d = 28 And a > 10)), 7, 0)))    As e6(o)
				 Cross Apply (Values (dateadd(day, d + e - o, dateFromparts(y, 3, 22))))        As e7(EasterDay)
					  ) As ge


		 --==== Related Easter Holidays (using Gauss' Western algorithm)
		  Cross Apply (
				Select h.IsHoliday
					 , h.HolidayDate
					 , h.HolidayName
					 , h.HolidayNameDutch
				  From (Values (ge.EasterDay))                                                  As e(EasterDate)
				 Cross Apply (Values (0, dateadd(day,-46, e.EasterDate), 'Ash Wednesday'	, 'Aswoensdag'		)
								   , (0, dateadd(day, -7, e.EasterDate), 'Palm Sunday'		, 'Palmzondag'		)
								   , (0, dateadd(day, -3, e.EasterDate), 'Maundy Thursday'	, 'Witte Donderdag'	)
								   , (1, dateadd(day, -2, e.EasterDate), 'Good Friday'		, 'Goede Vrijdag'	)
								   , (0, dateadd(day, -1, e.EasterDate), 'Holy Saturday'	, 'Stille Zaterdag'	)
								   , (1, dateadd(day,  0, e.EasterDate), 'Easter Sunday'	, '1e Paasdag'		)
								   , (0, dateadd(day,  1, e.EasterDate), 'Easter Monday'	, '2e Paasdag'		)
								   , (0, dateadd(day, 39, e.EasterDate), 'Ascension Day'	, 'Hemelvaartsdag'	)
								   , (0, dateadd(day, 49, e.EasterDate), 'Whit Sunday'		, '1e Pinkersterdag')
								   , (0, dateadd(day, 50, e.EasterDate), 'Whit Monday'		, '2e Pinkersterdag')
							 ) As h(IsHoliday, HolidayDate, HolidayName, HolidayNameDutch)
					  ) As hd;



;WITH seq(n) AS 
(
  Select 0 UNION ALL Select n + 1 From seq
  Where n < DATEDIFF(DAY, @StartDate, @CutoffDate)
),
d(d) AS 
(
  Select DATEADD(DAY, n, @StartDate) From seq
),
src AS
(
  Select
    TheDate         = CONVERT(date, d),
    TheDay          = DATEPART(DAY,       d),
    TheDayName      = DATENAME(WEEKDAY,   d),
    TheWeek         = DATEPART(WEEK,      d),
    TheISOWeek      = DATEPART(ISO_WEEK,  d),
    TheDayOfWeek    = DATEPART(WEEKDAY,   d),
    TheMonth        = DATEPART(MONTH,     d),
    TheMonthName    = DATENAME(MONTH,     d),
    TheQuarter      = DATEPART(Quarter,   d),
    TheYear         = DATEPART(YEAR,      d),
    TheFirstOfMonth = DATEFromPARTS(YEAR(d), MONTH(d), 1),
    TheLastOfYear   = DATEFromPARTS(YEAR(d), 12, 31),
    TheDayOfYear    = DATEPART(DAYOFYEAR, d)
  From d
)


  Select
    TheDate, 
    TheDay,
    TheDaySuffix        = CONVERT(char(2), CASE WHEN TheDay / 10 = 1 THEN 'th' ELSE 
                            CASE RIGHT(TheDay, 1) WHEN '1' THEN 'st' WHEN '2' THEN 'nd' 
                            WHEN '3' THEN 'rd' ELSE 'th' END END),
    TheDayName,
    TheDayOfWeek,
    TheDayOfWeekInMonth = CONVERT(tinyint, ROW_NUMBER() OVER 
                            (PARTITION BY TheFirstOfMonth, TheDayOfWeek ORDER BY TheDate)),
    TheDayOfYear,
    IsWeekend           = CASE WHEN TheDayOfWeek IN (CASE @@DATEFIRST WHEN 1 THEN 6 WHEN 7 THEN 1 END,7) 
                            THEN 1 ELSE 0 END,
    TheWeek,
    TheISOweek,
    TheFirstOfWeek      = DATEADD(DAY, 1 - TheDayOfWeek, TheDate),
    TheLastOfWeek       = DATEADD(DAY, 6, DATEADD(DAY, 1 - TheDayOfWeek, TheDate)),
    TheWeekOfMonth      = CONVERT(tinyint, DENSE_RANK() OVER 
                            (PARTITION BY TheYear, TheMonth ORDER BY TheWeek)),
    TheMonth,
    TheMonthName,
    TheFirstOfMonth,
    TheLastOfMonth      = MAX(TheDate) OVER (PARTITION BY TheYear, TheMonth),
	
    TheFirstOfNextMonth = DATEADD(MONTH, 1, TheFirstOfMonth),
    TheLastOfNextMonth  = DATEADD(DAY, -1, DATEADD(MONTH, 2, TheFirstOfMonth)),
    TheQuarter,
    TheFirstOfQuarter   = MIN(TheDate) OVER (PARTITION BY TheYear, TheQuarter),
    TheLastOfQuarter    = MAX(TheDate) OVER (PARTITION BY TheYear, TheQuarter),
    TheYear,
    TheISOYear          = TheYear - CASE WHEN TheMonth = 1 AND TheISOWeek > 51 THEN 1 
                            WHEN TheMonth = 12 AND TheISOWeek = 1  THEN -1 ELSE 0 END,      
    TheFirstOfYear      = DATEFromPARTS(TheYear, 1,  1),
    TheLastOfYear,
    IsLeapYear          = CONVERT(bit, CASE WHEN (TheYear % 400 = 0) 
                            OR (TheYear % 4 = 0 AND TheYear % 100 <> 0) 
                            THEN 1 ELSE 0 END),
    Has53Weeks          = CASE WHEN DATEPART(WEEK,     TheLastOfYear) = 53 THEN 1 ELSE 0 END,
    Has53ISOWeeks       = CASE WHEN DATEPART(ISO_WEEK, TheLastOfYear) = 53 THEN 1 ELSE 0 END,
    MMYYYY              = CONVERT(char(2), CONVERT(char(8), TheDate, 101))
                          + CONVERT(char(4), TheYear),
    Style101            = CONVERT(char(10), TheDate, 101),
    Style103            = CONVERT(char(10), TheDate, 103),
    Style112            = CONVERT(char(8),  TheDate, 112),
    Style120            = CONVERT(char(10), TheDate, 120),

	YearWeek			= cast(TheYear as varchar(4))+right('0'+cast(TheWeek as varchar(2)),2),
	YearISOWeek			= cast(TheYear as varchar(4))+right('0'+cast(TheISOweek as varchar(2)),2),
	YearMonth			= cast(TheYear as varchar(4))+right('0'+cast(TheMonth as varchar(2)),2)
into ##BaseCalendar
  From src
  Order by TheDate asc
  Option (MAXRECURSION 0);

  ;
With Holidays as
               (
  -- For now, ONLY Dutch Public Holidays are in use. Therefore currently the only possible values for IsBankHoliday and IsPublicHoliday are 1 (yes) or 0 (no).
 
	Select 
		HolidayDate			= TheDate, 
	    HolidayNameDutch	= Case
								When (TheDate = TheFirstOfYear)
	                                            Then 'Nieuwjaarsdag'
	                             -- Prinsessedag op 31 augustus: t/m 1948 (Wilhelmina)
	                             When (TheYear <= 1948 and TheMonth = 8 and TheDay = 31) 
	                                            Then 'Prinsessedag'
	                             -- Koninginnedag op 30 april: 1949-1979 (Juliana), behalve als zondag, dan 1 mei
	                             -- Koninginnedag op 30 april: 1980-2013 (Juliana), behalve als zondag, dan 29 april
	                             When (TheYear >= 1949 and TheYear <= 2013 and TheMonth = 4 and TheDay = 30 and TheDayOfWeek <> 7) OR
	                                             (TheYear >= 1949 and TheYear <= 1979 and TheMonth = 5 and TheDay = 1 and TheDayOfWeek = 1) OR
	                                             (TheYear >= 1980 and TheYear <= 2013 and TheMonth = 4 and TheDay = 29 and TheDayOfWeek = 6)
	                                            Then 'Koninginnedag'
	                             -- Koningsdag op 27 april: 2014- (Willem Alexander), behalve als zondag, dan 26 april
	                             When (TheYear >= 2014 and TheMonth = 4 and TheDay = 27 and TheDayOfWeek <> 7) OR
	                                             (TheYear >= 2014 and TheMonth = 4 and TheDay = 26 and TheDayOfWeek = 6)
	                                            Then 'Koningsdag'
	                             -- since 1990 liberation day is an official national holiday
								-- *Note 5 may 2016 is both Liberation Day and Ascencion Day. This would create a duplicate record for that day (see union all below). This would create a duplicate record for that day (see union all below)
	                             When (TheYear >= 1990 and TheMonth = 5 and TheDay = 5) -- HolidayText for 5th of May is always Liberation Day. It is however only a Public Holiday once every 5 year
	                                            Then 'Bevrijdingsdag'
	                             When (TheMonth = 12 and TheDay = 25)
	                                            Then '1e Kerstdag'
	                             When (TheMonth = 12 and TheDay = 26)
	                                            Then '2e Kerstdag'
	                             END,
		HolidayName			= Case
								When (TheDate = TheFirstOfYear)
	                                            Then 'New Year''s Day'
	                             -- Prinsessedag op 31 augustus: t/m 1948 (Wilhelmina)
	                             When (TheYear <= 1948 and TheMonth = 8 and TheDay = 31) 
	                                            Then 'Princess''s Day'
	                             -- Koninginnedag op 30 april: 1949-1979 (Juliana), behalve als zondag, dan 1 mei
	                             -- Koninginnedag op 30 april: 1980-2013 (Juliana), behalve als zondag, dan 29 april
	                             When (TheYear >= 1949 and TheYear <= 2013 and TheMonth = 4 and TheDay = 30 and TheDayOfWeek <> 7) OR
	                                             (TheYear >= 1949 and TheYear <= 1979 and TheMonth = 5 and TheDay = 1 and TheDayOfWeek = 1) OR
	                                             (TheYear >= 1980 and TheYear <= 2013 and TheMonth = 4 and TheDay = 29 and TheDayOfWeek = 6)
	                                            Then 'Queen''s Day'
	                             -- Koningsdag op 27 april: 2014- (Willem Alexander), behalve als zondag, dan 26 april
	                             When (TheYear >= 2014 and TheMonth = 4 and TheDay = 27 and TheDayOfWeek <> 7) OR
	                                             (TheYear >= 2014 and TheMonth = 4 and TheDay = 26 and TheDayOfWeek = 6)
	                                            Then 'King''s Day'
	                             -- since 1990 liberation day is an official national holiday
								-- *Note 5 may 2016 is both Liberation Day and Ascencion Day. This would create a duplicate record for that day (see union all below). This would create a duplicate record for that day (see union all below)
	                             When (TheYear >= 1990 and TheMonth = 5 and TheDay = 5) -- HolidayText for 5th of May is always Liberation Day. It is however only a Public Holiday once every 5 year
	                                            Then 'Liberation Day'
	                             When (TheMonth = 12 and TheDay = 25)
	                                            Then 'Christmas'
	                             When (TheMonth = 12 and TheDay = 26)
	                                            Then 'Boxing Day'
	                             End,
		IsBankHoliday		= Case
	                             -- New Year's Day is only a bank holiday when it falls not in a weekend
								When (TheDate = TheFirstOfYear  and TheDayOfWeek <=5)
	                                            Then 1
	                             -- Christmas is only a bank holiday when it falls not in a weekend
								When (TheMonth = 12 and TheDay = 25 and TheDayOfWeek <=5)
	                                            Then 1
	                            When (TheMonth = 12 and TheDay = 26 and TheDayOfWeek <=5)
	                                            Then 1
								Else 0
	                            End
	    ,IsPublicHoliday	= Case
	                             When (TheDate = TheFirstOfYear)
	                                            Then 1
	                             -- Prinsessedag op 31 augustus: t/m 1948 (Wilhelmina)
	                             When (TheYear <= 1948 and TheMonth = 8 and TheDay = 31) 
	                                            Then 1
	                             -- Koninginnedag op 30 april: 1949-1979 (Juliana), behalve als zondag, dan 1 mei
	                             -- Koninginnedag op 30 april: 1980-2013 (Juliana), behalve als zondag, dan 29 april
	                             When (TheYear >= 1949 and TheYear <= 2013 and TheMonth = 4 and TheDay = 30 and TheDayOfWeek <> 7) OR
	                                             (TheYear >= 1949 and TheYear <= 1979 and TheMonth = 5 and TheDay = 1 and TheDayOfWeek = 1) OR
	                                             (TheYear >= 1980 and TheYear <= 2013 and TheMonth = 4 and TheDay = 29 and TheDayOfWeek = 6)
	                                            Then 1
	                             -- Koningsdag op 27 april: 2014- (Willem Alexander), behalve als zondag, dan 26 april
	                             When (TheYear >= 2014 and TheMonth = 4 and TheDay = 27 and TheDayOfWeek <> 7) OR
	                                             (TheYear >= 2014 and TheMonth = 4 and TheDay = 26 and TheDayOfWeek = 6)
	                                            Then 1
	                             -- Every 5 year liberation day is a public holiday if it falls on a weekday
	                              -- *Note 5 may 2016 is both Liberation Day and Ascencion Day. This would create a duplicate record for that day (see union all below)
								When (TheYear >= 1990 and TheYear % 5 = 0 and TheMonth = 5 and TheDay = 5 and TheDayOfWeek <=5)
	                                            Then 1
	                             When (TheMonth = 12 and TheDay = 25)
	                                            Then 1
	                             When (TheMonth = 12 and TheDay = 26)
	                                            Then 1
	                             END
	               From   ##BaseCalendar cte
	               Where 1=1
								and TheDate = TheFirstOfYear -- 'New Year''s Day'
	                              or (TheYear <= 1948 and TheMonth = 8 and TheDay = 31) -- 'Princess''s Day'
	                              or (TheYear >= 1949 and TheYear <= 2013 and TheMonth = 4 and TheDay = 30 and TheDayOfWeek <> 7) -- 'Queen''s Day'
	                              or (TheYear >= 1949 and TheYear <= 1979 and TheMonth = 5 and TheDay = 1 and TheDayOfWeek = 1)  -- 'Queen''s Day'
	                              or (TheYear >= 1980 and TheYear <= 2013 and TheMonth = 4 and TheDay = 29 and TheDayOfWeek = 6) -- 'Queen''s Day'
	                              or (TheYear >= 2014 and TheMonth = 4 and TheDay = 27 and TheDayOfWeek <> 7) -- 'King''s Day'
	                              or (TheYear >= 2014 and TheMonth = 4 and TheDay = 26 and TheDayOfWeek = 6) -- 'King''s Day'
								  or (TheYear >= 1990 and TheMonth = 5 and TheDay = 5) -- Liberation Day
	                              or (TheMonth = 12 and TheDay = 25) -- Christmas
	                              or (TheMonth = 12 and TheDay = 26) -- Boxing Day
	
	               UNION ALL
				   Select 
						TheDate	 = e.HolidayDate
						, e.HolidayNameDutch
						, e.HolidayName
						, IsBankHoliday = CASE e.HolidayName When 'Good Friday' Then 1 WHen 'Easter Monday' Then 1 Else 0 END
						, IsPublicHoliday = 1
					From ##Easter e
             
               )
	, LWDM as  -- Last Workday Of Month
		(
		Select 
			max(TheDate) TheLastWorkDayOfMonth, yearmonth as LWDM_Yearmonth 
		From ##BaseCalendar d 
		left join Holidays h on d.TheDate = h.HolidayDate
		Where d.IsWeekend = 0  and h.HolidayDate is null
		Group by d.YearMonth
		)
	, FWDM as  -- First Workday Of Month
		(
		Select 
			min(TheDate) TheFirstWorkDayOfMonth, yearmonth as FWDM_Yearmonth 
		From ##BaseCalendar d 
		left join Holidays h on d.TheDate = h.HolidayDate
		Where d.IsWeekend = 0  and h.HolidayDate is null
		Group by d.YearMonth
		)
	, LFDM as  -- Last Friday Of Month
		(
		Select 
			min(TheDate) TheLastWorkDayOfMonth, yearmonth as FWDM_Yearmonth 
		From ##BaseCalendar d 
		Where TheDayOfWeek = 5
		Group by d.YearMonth
		)
	, WDM as (
		select
			d.TheDate
			, ROW_NUMBER() OVER (PARTITION BY d.yearmonth  ORDER BY d.TheDate) AS WorkDayOfMonth
			, ROW_NUMBER() OVER (PARTITION BY 1  ORDER BY d.TheDate) AS WorkDayCounter
		from ##BaseCalendar d
		left join Holidays h on h.HolidayDate = d.TheDate
		where d.IsWeekend = 0 
		 AND isnull(h.IsPublicHoliday,0) = 0

	)

Insert into [adf].[DWH_Date]
           (
		     DateKey
		   , TheDate
           , TheDay
           , TheDaySuffix
           , TheDayName
           , TheDayOfWeek
           , TheDayOfWeekInMonth
           , TheDayOfYear
           , IsWeekend
		   , IsWorkDay
		   , WorkdayOfMonth
           , TheWeek
           , TheISOweek
           , TheFirstOfWeek
           , TheLastOfWeek
           , TheWeekOfMonth
           , TheMonth
           , TheMonthName
		   , TheFirstWorkDayOfMonth
           , TheFirstOfMonth
		   , TheLastWorkDayOfMonth
           , TheLastOfMonth
           , TheFirstOfNextMonth
           , TheLastOfNextMonth
           , TheQuarter
           , TheFirstOfQuarter
           , TheLastOfQuarter
           , TheYear
           , TheISOYear
           , TheFirstOfYear
           , TheLastOfYear
           , IsLeapYear
           , Has53Weeks
           , Has53ISOWeeks
           , MMYYYY
           , Style101
           , Style103
           , Style112
           , Style120
		   , YearWeek	
		   , YearISOWeek	
	 	   , YearMonth
		   
		   , HolidayName
		   , IsBankHoliday
		   , IsPublicHoliday
		   
		   , HolidayName_NL
		   , TheDayName_NL	
		   , TheMonthName_NL
		   , DayCounter	
		   , WorkDayCounter


		         )	



Select 
	  [DateKey]							= convert(varchar(8),d.[TheDate],112)
	, d.[TheDate]
	, d.[TheDay]
	, d.[TheDaySuffix]
	, d.[TheDayName]
	, d.[TheDayOfWeek]
	, d.[TheDayOfWeekInMonth]
	, d.[TheDayOfYear]
	, d.[IsWeekend]
	, [IsWorkDay]							= case when d.IsWeekend = 0 and isnull(h.IsPublicHoliday,0) = 0 then 1 else 0 end
	, WorkDayOfMonth						= coalesce(wdm.WorkdayOfMonth,0)				
	, d.[TheWeek]
	, d.[TheISOweek]
	, d.[TheFirstOfWeek]
	, d.[TheLastOfWeek]
	, d.[TheWeekOfMonth]
	, d.[TheMonth]
	, d.[TheMonthName]
	, FWDM.TheFirstWorkDayOfMonth
	, d.[TheFirstOfMonth]
	, LWDM.[TheLastWorkDayOfMonth]
	, d.[TheLastOfMonth]
	, d.[TheFirstOfNextMonth]
	, d.[TheLastOfNextMonth]
	, d.[TheQuarter]
	, d.[TheFirstOfQuarter]
	, d.[TheLastOfQuarter]
	, d.[TheYear]
	, d.[TheISOYear]
	, d.[TheFirstOfYear]
	, d.[TheLastOfYear]
	, d.[IsLeapYear]
	, d.[Has53Weeks]
	, d.[Has53ISOWeeks]
	, d.[MMYYYY]
	, d.[Style101]
	, d.[Style103]
	, d.[Style112]
	, d.[Style120]
	, d.[YearWeek]	
	, d.[YearISOWeek]
	, d.[YearMonth]

	, [HolidayName]					= cast(Isnull(h.[HolidayName],'') as varchar(255))
	, [IsBankHoliday]				= isnull(h.[IsBankHoliday],0)
	, [IsPublicHoliday]				= isnull(h.[IsPublicHoliday],0)

	, [HolidayNameDutch]			= cast(isnull(h.[HolidayNameDutch],'') as varchar(255))
	, TheDayName_NL					= case 
										when d.[TheDayOfWeek] = 1 then 'maandag'
										when d.[TheDayOfWeek] = 2 then 'dinsdag'
										when d.[TheDayOfWeek] = 3 then 'woensdag'
										when d.[TheDayOfWeek] = 4 then 'donderdag'
										when d.[TheDayOfWeek] = 5 then 'vrijdag'
										when d.[TheDayOfWeek] = 6 then 'zaterdag'
										when d.[TheDayOfWeek] = 7 then 'zondag'
										else ''
										end
	, TheMonthName_NL				= case 
										when d.[TheMonth] = 1  then 'januari'
										when d.[TheMonth] = 2  then 'februari'
										when d.[TheMonth] = 3  then 'maart'
										when d.[TheMonth] = 4  then 'april'
										when d.[TheMonth] = 5  then 'mei'
										when d.[TheMonth] = 6  then 'juni'
										when d.[TheMonth] = 7  then 'juli'
										when d.[TheMonth] = 8  then 'augustus'
										when d.[TheMonth] = 9  then 'september'
										when d.[TheMonth] = 10 then 'oktober'
										when d.[TheMonth] = 11 then 'november'
										when d.[TheMonth] = 12 then 'december'
										else ''
										end
	, DayCounter					= ROW_NUMBER() Over (order by d.thedate asc)
	, WorkDayCounter				= coalesce ( -- coalesce is needed if the calendare starts with a weekend or an holiday
											MAX(wdm.WorkDayCounter) OVER (ORDER BY d.thedate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
											,0
											)
										
From ##BaseCalendar	d
Left join	LWDM		on LWDM.LWDM_Yearmonth	= d.YearMonth
Left join	FWDM		on FWDM.FWDM_Yearmonth	= d.YearMonth
Left join	Holidays h	on h.HolidayDate		= d.TheDate
left join	WDM			on WDM.TheDate			= d.TheDate
Order by TheDate asc