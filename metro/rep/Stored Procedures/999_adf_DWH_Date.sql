 -- noqa: PRS
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
-- 1 = Monday, 7 = Sunday
SET DATEFIRST  1,  -- noqa: PRS
    DATEFORMAT mdy,  -- noqa: PRS
    LANGUAGE   US_ENGLISH;  -- noqa: PRS
-- assume the above is here in all subsequent code blocks.

DECLARE @StartDate  date	= '20100101';											-- startdate
DECLARE @Years		int		= 30													-- add years from startdate
DECLARE @CutoffDate date	= Dateadd(DAY, -1, Dateadd(YEAR, @Years, @StartDate));	-- determine enddate
DECLARE @startYear	int		= Datepart(YEAR,@StartDate)
DECLARE @endYear	int		= Datepart(YEAR, @CutoffDate)


IF OBJECT_ID('adf.DWH_date', 'U') IS NOT NULL
DROP TABLE [adf].[DWH_Date]
				-- 
IF OBJECT_ID('tempdb..##Easter', 'U') IS NOT NULL
DROP TABLE ##Easter

IF OBJECT_ID('tempdb..##BaseCalendar', 'U') IS NOT NULL
DROP TABLE ##BaseCalendar


CREATE TABLE [adf].[DWH_Date](
					DateKey					int NOT NULL,
					TheDate					date NULL,
					TheDay					int NULL,
					TheDaySuffix			char(2) NULL,
					TheDayName				varchar(30) NULL,
					TheDayOfWeek			int NULL,
					TheDayOfWeekInMonth		tinyint NULL,
					TheDayOfYear			int		NULL,
					IsWeekend				int NOT NULL,
					IsWorkDay				int NOT NULL,
					WorkdayOfMonth			int NOT NULL,
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
					YearWeek				char(6) NULL,
					YearISOWeek				char(6) NULL,
					YearMonth				char(6) NULL,

					HolidayName				varchar(255) NULL,
					IsBankHoliday			int NULL,
					IsPublicHoliday			int NULL,

					HolidayName_NL			varchar(255) NULL,
					TheDayName_NL			varchar(255) NULL,
					TheMonthName_NL			varchar (255) NULL,
					DayCounter				bigint NULL,
					WorkDayCounter			bigint NULL,
				) ON [PRIMARY]
;





-- First we determine Easter related dates
;
		   WITH t(n)
			 AS (
		 SELECT t.n 
		   FROM (
		 VALUES (0), (0), (0), (0), (0), (0), (0), (0), (0), (0)) AS t(n)
				)
			  , inputYears (y)
			 AS (
		 SELECT TOP (@endYear - @startYear + 1) 
				(@startYear - 1) + ROW_NUMBER() OVER(ORDER BY @@spid) AS rn 
		   FROM t t1, t t2, t t3, t t4
				)
		 SELECT hd.*
		 INTO ##Easter
		   FROM inputYears                                      dd

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
		CROSS APPLY (
				SELECT * --e7.EasterDay
				  FROM (VALUES (y % 19, y % 4, y % 7, y / 100))                                 AS e1(a, b, c, k)
				 CROSS APPLY (VALUES ((13 + 8*k) / 25, k / 4))                                  AS e2(p, q)
				 CROSS APPLY (VALUES ((15 - p + k - q) % 30, (4 + k - q) % 7))                  AS e3(M, N)
				 CROSS APPLY (VALUES ((19*a + M) % 30))                                         AS e4(d)
				 CROSS APPLY (VALUES ((2*b + 4*c + 6*d + N) % 7))                               AS e5(e)
				 CROSS APPLY (VALUES (iif(e = 6 AND (d = 29 OR (d = 28 AND a > 10)), 7, 0)))    AS e6(o)
				 CROSS APPLY (VALUES (dateadd(DAY, d + e - o, dateFromparts(y, 3, 22))))        AS e7(EasterDay)
					  ) AS ge


		 --==== Related Easter Holidays (using Gauss' Western algorithm)
		  CROSS APPLY (
				SELECT h.IsHoliday
					 , h.HolidayDate
					 , h.HolidayName
					 , h.HolidayNameDutch
				  FROM (VALUES (ge.EasterDay))                                                  AS e(EasterDate)
				 CROSS APPLY (VALUES (0, dateadd(DAY,-46, e.EasterDate), 'Ash Wednesday'	, 'Aswoensdag'		)
								   , (0, dateadd(DAY, -7, e.EasterDate), 'Palm Sunday'		, 'Palmzondag'		)
								   , (0, dateadd(DAY, -3, e.EasterDate), 'Maundy Thursday'	, 'Witte Donderdag'	)
								   , (1, dateadd(DAY, -2, e.EasterDate), 'Good Friday'		, 'Goede Vrijdag'	)
								   , (0, dateadd(DAY, -1, e.EasterDate), 'Holy Saturday'	, 'Stille Zaterdag'	)
								   , (1, dateadd(DAY,  0, e.EasterDate), 'Easter Sunday'	, '1e Paasdag'		)
								   , (0, dateadd(DAY,  1, e.EasterDate), 'Easter Monday'	, '2e Paasdag'		)
								   , (0, dateadd(DAY, 39, e.EasterDate), 'Ascension Day'	, 'Hemelvaartsdag'	)
								   , (0, dateadd(DAY, 49, e.EasterDate), 'Whit Sunday'		, '1e Pinkersterdag')
								   , (0, dateadd(DAY, 50, e.EasterDate), 'Whit Monday'		, '2e Pinkersterdag')
							 ) AS h(IsHoliday, HolidayDate, HolidayName, HolidayNameDutch)
					  ) AS hd;



;WITH seq(n) AS 
(
  SELECT 0 UNION ALL SELECT n + 1 FROM seq
  WHERE n < DATEDIFF(DAY, @StartDate, @CutoffDate)
),
d(d) AS 
(
  SELECT DATEADD(DAY, N, @StartDate) FROM seq
),
src AS
(
  SELECT
    TheDate         = CONVERT(date, d),
    TheDay          = DATEPART(DAY,       D),
    TheDayName      = DATENAME(WEEKDAY,   D),
    TheWeek         = DATEPART(WEEK,      D),
    TheISOWeek      = DATEPART(ISO_WEEK,  D),
    TheDayOfWeek    = DATEPART(WEEKDAY,   D),
    TheMonth        = DATEPART(MONTH,     D),
    TheMonthName    = DATENAME(MONTH,     D),
    TheQuarter      = DATEPART(QUARTER,   D),
    TheYear         = DATEPART(YEAR,      D),
    TheFirstOfMonth = DATEFromPARTS(YEAR(d), MONTH(d), 1),
    TheLastOfYear   = DATEFromPARTS(YEAR(d), 12, 31),
    TheDayOfYear    = DATEPART(DAYOFYEAR, D)
  FROM d
)


  SELECT
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

	YearWeek			= CAST(TheYear AS varchar(4))+RIGHT('0'+CAST(TheWeek AS varchar(2)),2),
	YearISOWeek			= CAST(TheYear AS varchar(4))+RIGHT('0'+CAST(TheISOweek AS varchar(2)),2),
	YearMonth			= CAST(TheYear AS varchar(4))+RIGHT('0'+CAST(TheMonth AS varchar(2)),2)
INTO ##BaseCalendar
  FROM src
  ORDER BY TheDate ASC
  OPTION (MAXRECURSION 0);

  ;
WITH Holidays AS
               (
  -- For now, ONLY Dutch Public Holidays are in use. Therefore currently the only possible values for IsBankHoliday and IsPublicHoliday are 1 (yes) or 0 (no).
 
	SELECT 
		HolidayDate			= TheDate, 
	    HolidayNameDutch	= CASE
								WHEN (TheDate = TheFirstOfYear)
	                                            THEN 'Nieuwjaarsdag'
	                        -- Prinsessedag op 31 augustus: t/m 1948 (Wilhelmina)
	                             WHEN (TheYear <= 1948 AND TheMonth = 8 AND TheDay = 31) 
	                                            THEN 'Prinsessedag'
	                        -- Koninginnedag op 30 april: 1949-1979 (Juliana), behalve als zondag, dan 1 mei
	                        -- Koninginnedag op 30 april: 1980-2013 (Juliana), behalve als zondag, dan 29 april
	                             WHEN (TheYear >= 1949 AND TheYear <= 2013 AND TheMonth = 4 AND TheDay = 30 AND TheDayOfWeek <> 7) OR
	                                             (TheYear >= 1949 AND TheYear <= 1979 AND TheMonth = 5 AND TheDay = 1 AND TheDayOfWeek = 1) OR
	                                             (TheYear >= 1980 AND TheYear <= 2013 AND TheMonth = 4 AND TheDay = 29 AND TheDayOfWeek = 6)
	                                            THEN 'Koninginnedag'
	                        -- Koningsdag op 27 april: 2014- (Willem Alexander), behalve als zondag, dan 26 april
	                             WHEN (TheYear >= 2014 AND TheMonth = 4 AND TheDay = 27 AND TheDayOfWeek <> 7) OR
	                                             (TheYear >= 2014 AND TheMonth = 4 AND TheDay = 26 AND TheDayOfWeek = 6)
	                                            THEN 'Koningsdag'
							-- since 1990 liberation day is an official national holiday
							-- *Note 5 may 2016 is both Liberation Day and Ascencion Day. This would create a duplicate record for that day (see union all below).
							-- This would create a duplicate record for that day (see union all below)
							-- HolidayText for 5th of May is always Liberation Day. It is however only a Public Holiday once every 5 year
	                             WHEN (TheYear >= 1990 AND TheMonth = 5 AND TheDay = 5)
	                                            THEN 'Bevrijdingsdag'
	                             WHEN (TheMonth = 12 AND TheDay = 25)
	                                            THEN '1e Kerstdag'
	                             WHEN (TheMonth = 12 AND TheDay = 26)
	                                            THEN '2e Kerstdag'
	                             END,
		HolidayName			= CASE
								WHEN (TheDate = TheFirstOfYear)
	                                            THEN 'New Year''s Day'
	                    	-- Prinsessedag op 31 augustus: t/m 1948 (Wilhelmina)
	                             WHEN (TheYear <= 1948 AND TheMonth = 8 AND TheDay = 31) 
	                                            THEN 'Princess''s Day'
	                        -- Koninginnedag op 30 april: 1949-1979 (Juliana), behalve als zondag, dan 1 mei
	                        -- Koninginnedag op 30 april: 1980-2013 (Juliana), behalve als zondag, dan 29 april
	                             WHEN (TheYear >= 1949 AND TheYear <= 2013 AND TheMonth = 4 AND TheDay = 30 AND TheDayOfWeek <> 7) OR
	                                             (TheYear >= 1949 AND TheYear <= 1979 AND TheMonth = 5 AND TheDay = 1 AND TheDayOfWeek = 1) OR
	                                             (TheYear >= 1980 AND TheYear <= 2013 AND TheMonth = 4 AND TheDay = 29 AND TheDayOfWeek = 6)
	                                            THEN 'Queen''s Day'
	                        -- Koningsdag op 27 april: 2014- (Willem Alexander), behalve als zondag, dan 26 april
	                             WHEN (TheYear >= 2014 AND TheMonth = 4 AND TheDay = 27 AND TheDayOfWeek <> 7) OR
	                                             (TheYear >= 2014 AND TheMonth = 4 AND TheDay = 26 AND TheDayOfWeek = 6)
	                                            THEN 'King''s Day'
	                        -- since 1990 liberation day is an official national holiday
							-- *Note 5 may 2016 is both Liberation Day and Ascencion Day. This would create a duplicate record for that day (see union all below).
							-- This would create a duplicate record for that day (see union all below)
	                        -- HolidayText for 5th of May is always Liberation Day. It is however only a Public Holiday once every 5 year
	                             WHEN (TheYear >= 1990 AND TheMonth = 5 AND TheDay = 5)
	                                            THEN 'Liberation Day'
	                             WHEN (TheMonth = 12 AND TheDay = 25)
	                                            THEN 'Christmas'
	                             WHEN (TheMonth = 12 AND TheDay = 26)
	                                            THEN 'Boxing Day'
	                             END,
		IsBankHoliday		= CASE
	                        -- New Year's Day is only a bank holiday when it falls not in a weekend
								WHEN (TheDate = TheFirstOfYear  AND TheDayOfWeek <=5)
	                                            THEN 1
	                        -- Christmas is only a bank holiday when it falls not in a weekend
								WHEN (TheMonth = 12 AND TheDay = 25 AND TheDayOfWeek <=5)
	                                            THEN 1
	                            WHEN (TheMonth = 12 AND TheDay = 26 AND TheDayOfWeek <=5)
	                                            THEN 1
								ELSE 0
	                            END
	    ,IsPublicHoliday	= CASE
	                             WHEN (TheDate = TheFirstOfYear)
	                                            THEN 1
	                        -- Prinsessedag op 31 augustus: t/m 1948 (Wilhelmina)
	                             WHEN (TheYear <= 1948 AND TheMonth = 8 AND TheDay = 31) 
	                                            THEN 1
	                        -- Koninginnedag op 30 april: 1949-1979 (Juliana), behalve als zondag, dan 1 mei
	                        -- Koninginnedag op 30 april: 1980-2013 (Juliana), behalve als zondag, dan 29 april
	                             WHEN (TheYear >= 1949 AND TheYear <= 2013 AND TheMonth = 4 AND TheDay = 30 AND TheDayOfWeek <> 7) OR
	                                             (TheYear >= 1949 AND TheYear <= 1979 AND TheMonth = 5 AND TheDay = 1 AND TheDayOfWeek = 1) OR
	                                             (TheYear >= 1980 AND TheYear <= 2013 AND TheMonth = 4 AND TheDay = 29 AND TheDayOfWeek = 6)
	                                            THEN 1
	                        -- Koningsdag op 27 april: 2014- (Willem Alexander), behalve als zondag, dan 26 april
	                             WHEN (TheYear >= 2014 AND TheMonth = 4 AND TheDay = 27 AND TheDayOfWeek <> 7) OR
	                                             (TheYear >= 2014 AND TheMonth = 4 AND TheDay = 26 AND TheDayOfWeek = 6)
	                                            THEN 1
	                        -- Every 5 year liberation day is a public holiday if it falls on a weekday
	                        -- *Note 5 may 2016 is both Liberation Day and Ascencion Day.
							-- This would create a duplicate record for that day (see union all below)
								WHEN (TheYear >= 1990 AND TheYear % 5 = 0 AND TheMonth = 5 AND TheDay = 5 AND TheDayOfWeek <=5)
	                                            THEN 1
	                             WHEN (TheMonth = 12 AND TheDay = 25)
	                                            THEN 1
	                             WHEN (TheMonth = 12 AND TheDay = 26)
	                                            THEN 1
	                             END
	               FROM   ##BaseCalendar cte
	               WHERE 1=1
								AND TheDate = TheFirstOfYear -- 'New Year''s Day'
	                              OR (TheYear <= 1948 AND TheMonth = 8 AND TheDay = 31) -- 'Princess''s Day'
	                              OR (TheYear >= 1949 AND TheYear <= 2013 AND TheMonth = 4 AND TheDay = 30 AND TheDayOfWeek <> 7) -- 'Queen''s Day'
	                              OR (TheYear >= 1949 AND TheYear <= 1979 AND TheMonth = 5 AND TheDay = 1 AND TheDayOfWeek = 1)  -- 'Queen''s Day'
	                              OR (TheYear >= 1980 AND TheYear <= 2013 AND TheMonth = 4 AND TheDay = 29 AND TheDayOfWeek = 6) -- 'Queen''s Day'
	                              OR (TheYear >= 2014 AND TheMonth = 4 AND TheDay = 27 AND TheDayOfWeek <> 7) -- 'King''s Day'
	                              OR (TheYear >= 2014 AND TheMonth = 4 AND TheDay = 26 AND TheDayOfWeek = 6) -- 'King''s Day'
								  OR (TheYear >= 1990 AND TheMonth = 5 AND TheDay = 5) -- Liberation Day
	                              OR (TheMonth = 12 AND TheDay = 25) -- Christmas
	                              OR (TheMonth = 12 AND TheDay = 26) -- Boxing Day
	
	               UNION ALL
				   SELECT 
						TheDate	 = e.HolidayDate
						, e.HolidayNameDutch
						, e.HolidayName
						, IsBankHoliday = CASE e.HolidayName WHEN 'Good Friday' THEN 1 WHEN 'Easter Monday' THEN 1 ELSE 0 END
						, IsPublicHoliday = 1
					FROM ##Easter e
             
               )
	, LWDM AS  -- Last Workday Of Month
		(
		SELECT 
			max(TheDate) TheLastWorkDayOfMonth, yearmonth AS LWDM_Yearmonth 
		FROM ##BaseCalendar d 
		LEFT JOIN Holidays h ON d.TheDate = h.HolidayDate
		WHERE d.IsWeekend = 0  AND h.HolidayDate IS null
		GROUP BY d.YearMonth
		)
	, FWDM AS  -- First Workday Of Month
		(
		SELECT 
			min(TheDate) TheFirstWorkDayOfMonth, yearmonth AS FWDM_Yearmonth 
		FROM ##BaseCalendar d 
		LEFT JOIN Holidays h ON d.TheDate = h.HolidayDate
		WHERE d.IsWeekend = 0  AND h.HolidayDate IS null
		GROUP BY d.YearMonth
		)
	, LFDM AS  -- Last Friday Of Month
		(
		SELECT 
			min(TheDate) TheLastWorkDayOfMonth, yearmonth AS FWDM_Yearmonth 
		FROM ##BaseCalendar d 
		WHERE TheDayOfWeek = 5
		GROUP BY d.YearMonth
		)
	, WDM AS (
		SELECT
			d.TheDate
			, ROW_NUMBER() OVER (PARTITION BY d.yearmonth  ORDER BY d.TheDate) AS WorkDayOfMonth
			, ROW_NUMBER() OVER (PARTITION BY 1  ORDER BY d.TheDate) AS WorkDayCounter
		FROM ##BaseCalendar d
		LEFT JOIN Holidays h ON h.HolidayDate = d.TheDate
		WHERE d.IsWeekend = 0 
		 AND isnull(h.IsPublicHoliday,0) = 0

	)

INSERT INTO [adf].[DWH_Date]
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



SELECT 
	  [DateKey]							= CONVERT(varchar(8),d.[TheDate],112)
	, d.[TheDate]
	, d.[TheDay]
	, d.[TheDaySuffix]
	, d.[TheDayName]
	, d.[TheDayOfWeek]
	, d.[TheDayOfWeekInMonth]
	, d.[TheDayOfYear]
	, d.[IsWeekend]
	, [IsWorkDay]							= CASE WHEN d.IsWeekend = 0 AND isnull(h.IsPublicHoliday,0) = 0 THEN 1 ELSE 0 END
	, WorkDayOfMonth						= COALESCE(wdm.WorkdayOfMonth,0)				
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

	, [HolidayName]					= CAST(Isnull(h.[HolidayName],'') AS varchar(255))
	, [IsBankHoliday]				= isnull(h.[IsBankHoliday],0)
	, [IsPublicHoliday]				= isnull(h.[IsPublicHoliday],0)

	, [HolidayNameDutch]			= CAST(isnull(h.[HolidayNameDutch],'') AS varchar(255))
	, TheDayName_NL					= CASE 
										WHEN d.[TheDayOfWeek] = 1 THEN 'maandag'
										WHEN d.[TheDayOfWeek] = 2 THEN 'dinsdag'
										WHEN d.[TheDayOfWeek] = 3 THEN 'woensdag'
										WHEN d.[TheDayOfWeek] = 4 THEN 'donderdag'
										WHEN d.[TheDayOfWeek] = 5 THEN 'vrijdag'
										WHEN d.[TheDayOfWeek] = 6 THEN 'zaterdag'
										WHEN d.[TheDayOfWeek] = 7 THEN 'zondag'
										ELSE ''
										END
	, TheMonthName_NL				= CASE 
										WHEN d.[TheMonth] = 1  THEN 'januari'
										WHEN d.[TheMonth] = 2  THEN 'februari'
										WHEN d.[TheMonth] = 3  THEN 'maart'
										WHEN d.[TheMonth] = 4  THEN 'april'
										WHEN d.[TheMonth] = 5  THEN 'mei'
										WHEN d.[TheMonth] = 6  THEN 'juni'
										WHEN d.[TheMonth] = 7  THEN 'juli'
										WHEN d.[TheMonth] = 8  THEN 'augustus'
										WHEN d.[TheMonth] = 9  THEN 'september'
										WHEN d.[TheMonth] = 10 THEN 'oktober'
										WHEN d.[TheMonth] = 11 THEN 'november'
										WHEN d.[TheMonth] = 12 THEN 'december'
										ELSE ''
										END
	, DayCounter					= ROW_NUMBER() OVER (ORDER BY d.thedate ASC)
	, WorkDayCounter				= COALESCE ( -- coalesce is needed if the calendare starts with a weekend or an holiday
											MAX(wdm.WorkDayCounter) OVER (ORDER BY d.thedate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
											,0
											)
										
FROM ##BaseCalendar	d
LEFT JOIN	LWDM		ON LWDM.LWDM_Yearmonth	= d.YearMonth
LEFT JOIN	FWDM		ON FWDM.FWDM_Yearmonth	= d.YearMonth
LEFT JOIN	Holidays h	ON h.HolidayDate		= d.TheDate
LEFT JOIN	WDM			ON WDM.TheDate			= d.TheDate
ORDER BY TheDate ASC