
CREATE PROCEDURE [rep].[999_adf_dwh_date] AS /*
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
*/ -- prevent set or regional settings From interfering with
-- interpretation of dates / literals

   SET datefirst 1, -- 1 = Monday, 7 = Sunday
 dateformat mdy,

       LANGUAGE us_english;-- assume the above is here in all subsequent code blocks.
 DECLARE @startdate date = '20100101'; -- startdate
DECLARE @years int = 30 -- add years from startdate
DECLARE @cutoffdate date = dateadd(DAY, -1, dateadd(YEAR, @years, @startdate)); -- determine enddate
DECLARE @startyear int = datepart(YEAR,
                                  @startdate) DECLARE @endyear int = datepart(YEAR,
                                                                              @cutoffdate) IF object_id('adf.DWH_date',
                                                                                                        'U') IS NOT NULL
DROP TABLE [adf].[dwh_date] --
IF object_id('tempdb..##Easter',
             'U') IS NOT NULL
DROP TABLE ##easter IF object_id('tempdb..##BaseCalendar',
                                 'U') IS NOT NULL
DROP TABLE ##basecalendar
CREATE TABLE [adf].[dwh_date](datekey int NOT NULL,
                                          thedate date NULL,
                                                       theday int NULL,
                                                                  thedaysuffix char(2) NULL,
                                                                                       thedayname varchar(30) NULL,
                                                                                                              thedayofweek int NULL,
                                                                                                                               thedayofweekinmonth tinyint NULL,
                                                                                                                                                           thedayofyear int NULL,
                                                                                                                                                                            isweekend int NOT NULL,
                                                                                                                                                                                          isworkday int NOT NULL,
                                                                                                                                                                                                        workdayofmonth int NOT NULL,
                                                                                                                                                                                                                           theweek int NULL,
                                                                                                                                                                                                                                       theisoweek int NULL,
                                                                                                                                                                                                                                                      thefirstofweek date NULL,
                                                                                                                                                                                                                                                                          thelastofweek date NULL,
                                                                                                                                                                                                                                                                                             theweekofmonth tinyint NULL,
                                                                                                                                                                                                                                                                                                                    themonth int NULL,
                                                                                                                                                                                                                                                                                                                                 themonthname varchar(30) NULL,
                                                                                                                                                                                                                                                                                                                                                          thefirstworkdayofmonth date NULL,
                                                                                                                                                                                                                                                                                                                                                                                      thefirstofmonth date NULL,
                                                                                                                                                                                                                                                                                                                                                                                                           thelastworkdayofmonth date NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                      thelastofmonth date NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                          thefirstofnextmonth date NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   thelastofnextmonth date NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           thequarter int NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          thefirstofquarter date NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 thelastofquarter date NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       theyear int NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   theisoyear int NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  thefirstofyear date NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      thelastofyear date NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         isleapyear bit NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        has53weeks int NOT NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       has53isoweeks int NOT NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         mmyyyy char(6) NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        style101 char(10) NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          style103 char(10) NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            style112 char(8) NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             style120 char(10) NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               yearweek char(6) NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                yearisoweek char(6) NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    yearmonth char(6) NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      holidayname varchar(255) NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               isbankholiday int NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 ispublicholiday int NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     holidayname_nl varchar(255) NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 thedayname_nl varchar(255) NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            themonthname_nl varchar (255) NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          daycounter bigint NULL,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            workdaycounter bigint NULL,)
    ON [primary] ;-- First we determine Easter related dates
;WITH t(n) AS

        (SELECT t.n

          FROM (
         VALUES (0), (0), (0), (0), (0), (0), (0), (0), (0), (0)) AS t(n)
       ) ,

       inputyears (y) AS

        (SELECT top (@endyear - @startyear + 1) (@startyear - 1) + row_number() over(
                                                                               ORDER BY @@ spid) AS rn

          FROM t t1,

               t t2,

               t t3,

               t t4
       )
SELECT hd.* INTO ##easter

  FROM inputyears dd /*  Gauss' Easter algorithm

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
		*/ CROSS apply

        (SELECT * --e7.EasterDay


          FROM (
         VALUES (y % 19, y % 4, y % 7, y / 100)) AS e1(a, b, c, k) CROSS apply (
                                                                                VALUES ((13 + 8 * k) / 25, k / 4)) AS e2(p, q) CROSS apply (
                                                                                                                                            VALUES ((15 - p + k - q) % 30, (4 + k - q) % 7)) AS e3(m, n) CROSS apply (
                                                                                                                                                                                                                      VALUES ((19 * a + m) % 30)) AS e4(d) CROSS apply (
                                                                                                                                                                                                                                                                        VALUES ((2 * b + 4 * c + 6 * d + n) % 7)) AS e5(e) CROSS apply (
                                                                                                                                                                                                                                                                                                                                        VALUES (iif(e = 6
                                                                                                                                                                                                                                                                                                                                                    AND (d = 29
                                                                                                                                                                                                                                                                                                                                                         OR (d = 28
                                                                                                                                                                                                                                                                                                                                                             AND a > 10)), 7, 0))) AS e6(o) CROSS apply (
                                                                                                                                                                                                                                                                                                                                                                                                         VALUES (dateadd(DAY, d + e - o, datefromparts(y, 3, 22)))) AS e7(easterday)
       ) AS ge --==== Related Easter Holidays (using Gauss' Western algorithm)
 CROSS apply 
  
        (SELECT h.isholiday , 
               h.holidaydate , 
               h.holidayname , 
               h.holidaynamedutch 
   
          FROM (
         VALUES (ge.easterday)) AS e(easterdate) CROSS apply (
                                                              VALUES (0, dateadd(DAY, -46, e.easterdate), 'Ash Wednesday', 'Aswoensdag') , (0, dateadd(DAY, -7, e.easterdate), 'Palm Sunday' , 'Palmzondag') , (0, dateadd(DAY, -3, e.easterdate), 'Maundy Thursday', 'Witte Donderdag') , (1, dateadd(DAY, -2, e.easterdate), 'Good Friday' , 'Goede Vrijdag') , (0, dateadd(DAY, -1, e.easterdate), 'Holy Saturday', 'Stille Zaterdag') , (1, dateadd(DAY, 0, e.easterdate), 'Easter Sunday', '1e Paasdag') , (0, dateadd(DAY, 1, e.easterdate), 'Easter Monday', '2e Paasdag') , (0, dateadd(DAY, 39, e.easterdate), 'Ascension Day', 'Hemelvaartsdag') , (0, dateadd(DAY, 49, e.easterdate), 'Whit Sunday' , '1e Pinkersterdag') , (0, dateadd(DAY, 50, e.easterdate), 'Whit Monday' , '2e Pinkersterdag')) AS h(isholiday, holidaydate, holidayname, holidaynamedutch)
       ) AS hd;;WITH seq(n) AS

        (SELECT 0

     UNION ALL SELECT n + 1

          FROM seq

         WHERE n < datediff(DAY, @startdate, @cutoffdate)
       ),

       d(d) AS

        (SELECT dateadd(DAY, n, @startdate)

          FROM seq
       ),

       src AS

        (SELECT thedate = convert(date, d),

               theday = datepart(DAY, d),

               thedayname = datename(weekday, d),

               theweek = datepart(WEEK, d),

               theisoweek = datepart(iso_week, d),

               thedayofweek = datepart(weekday, d),

               themonth = datepart(MONTH, d),

               themonthname = datename(MONTH, d),

               thequarter = datepart(QUARTER, d),

               theyear = datepart(YEAR, d),

               thefirstofmonth = datefromparts(year(d), month(d), 1),

               thelastofyear = datefromparts(year(d), 12, 31),

               thedayofyear = datepart(dayofyear, d)

          FROM d
       )
SELECT thedate,

       theday,

       thedaysuffix = convert(char(2), CASE
                                           WHEN theday / 10 = 1 THEN 'th'
                                           ELSE CASE right(theday, 1)
                                                    WHEN '1' THEN 'st'
                                                    WHEN '2' THEN 'nd'
                                                    WHEN '3' THEN 'rd'
                                                    ELSE 'th'
                                                END
                                       END),

       thedayname,

       thedayofweek,

       thedayofweekinmonth = convert(tinyint, row_number() OVER (PARTITION BY thefirstofmonth, thedayofweek
                                                                 ORDER BY thedate)),

       thedayofyear,

       isweekend = CASE
                       WHEN thedayofweek IN (CASE @@ datefirst
                                                 WHEN 1 THEN 6
                                                 WHEN 7 THEN 1
                                             END,
                                             7) THEN 1

            ELSE 0

             END,

       theweek,

       theisoweek,

       thefirstofweek = dateadd(DAY, 1 - thedayofweek, thedate),

       thelastofweek = dateadd(DAY, 6, dateadd(DAY, 1 - thedayofweek, thedate)),

       theweekofmonth = convert(tinyint, dense_rank() OVER (PARTITION BY theyear, themonth
                                                                        ORDER BY theweek)),

       themonth,

       themonthname,

       thefirstofmonth,

       thelastofmonth = max(thedate) OVER (PARTITION BY theyear, themonth),

       thefirstofnextmonth = dateadd(MONTH, 1, thefirstofmonth),

       thelastofnextmonth = dateadd(DAY, -1, dateadd(MONTH, 2, thefirstofmonth)),

       thequarter,

       thefirstofquarter = min(thedate) OVER (PARTITION BY theyear, thequarter),

       thelastofquarter = max(thedate) OVER (PARTITION BY theyear, thequarter),

       theyear,

       theisoyear = theyear - CASE
                                              WHEN themonth = 1
                                                   AND theisoweek > 51 THEN 1

            WHEN themonth = 12
                                                   AND theisoweek = 1 THEN -1

            ELSE 0

             END,

       thefirstofyear = datefromparts(theyear, 1, 1),

       thelastofyear,

       isleapyear = convert(bit, CASE
                                                                        WHEN (theyear % 400 = 0)
                                                                             OR (theyear % 4 = 0
                                                                                 AND theyear % 100 <> 0) THEN 1
                                                                        ELSE 0
                                                                    END),

       has53weeks = CASE
                                                           WHEN datepart(WEEK, thelastofyear) = 53 THEN 1

            ELSE 0

             END,

       has53isoweeks = CASE
                                                                           WHEN datepart(iso_week, thelastofyear) = 53 THEN 1

            ELSE 0

             END,

       mmyyyy = convert(char(2), convert(char(8), thedate, 101)) + convert(char(4), theyear),

       style101 = convert(char(10), thedate, 101),

       style103 = convert(char(10), thedate, 103),

       style112 = convert(char(8), thedate, 112),

       style120 = convert(char(10), thedate, 120),

       yearweek = cast(theyear AS varchar(4)) + right('0' + cast(theweek AS varchar(2)), 2),

       yearisoweek = cast(theyear AS varchar(4)) + right('0' + cast(theisoweek AS varchar(2)), 2),

       yearmonth = cast(theyear AS varchar(4)) + right('0' + cast(themonth AS varchar(2)), 2) INTO ##basecalendar

  FROM src

 ORDER BY thedate ASC
OPTION (maxrecursion 0);;WITH holidays AS

        (-- For now, ONLY Dutch Public Holidays are in use. Therefore currently the only possible values for IsBankHoliday and IsPublicHoliday are 1 (yes) or 0 (no).
 SELECT holidaydate = thedate,

               holidaynamedutch = CASE
                               WHEN (thedate = thefirstofyear)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    THEN 'Nieuwjaarsdag' -- Prinsessedag op 31 augustus: t/m 1948 (Wilhelmina)


                    WHEN (theyear <= 1948
                                     AND themonth = 8
                                     AND theday = 31)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  THEN 'Prinsessedag' -- Koninginnedag op 30 april: 1949-1979 (Juliana), behalve als zondag, dan 1 mei
 -- Koninginnedag op 30 april: 1980-2013 (Juliana), behalve als zondag, dan 29 april


                    WHEN (theyear >= 1949
                                     AND theyear <= 2013
                                     AND themonth = 4
                                     AND theday = 30
                                     AND thedayofweek <> 7)
                                    OR (theyear >= 1949
                                        AND theyear <= 1979
                                        AND themonth = 5
                                        AND theday = 1
                                        AND thedayofweek = 1)
                                    OR (theyear >= 1980
                                        AND theyear <= 2013
                                        AND themonth = 4
                                        AND theday = 29
                                        AND thedayofweek = 6) THEN 'Koninginnedag' -- Koningsdag op 27 april: 2014- (Willem Alexander), behalve als zondag, dan 26 april


                    WHEN (theyear >= 2014
                                     AND themonth = 4
                                     AND theday = 27
                                     AND thedayofweek <> 7)
                                    OR (theyear >= 2014
                                        AND themonth = 4
                                        AND theday = 26
                                        AND thedayofweek = 6)                                                                                                                                                                                                                                                                                                                                                                                    THEN 'Koningsdag' -- since 1990 liberation day is an official national holiday
 -- *Note 5 may 2016 is both Liberation Day and Ascencion Day. This would create a duplicate record for that day (see union all below). This would create a duplicate record for that day (see union all below)


                    WHEN (theyear >= 1990
                                     AND themonth = 5
                                     AND theday = 5)-- HolidayText for 5th of May is always Liberation Day. It is however only a Public Holiday once every 5 year
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     THEN 'Bevrijdingsdag'

                    WHEN (themonth = 12
                                     AND theday = 25)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          THEN '1e Kerstdag'

                    WHEN (themonth = 12
                                     AND theday = 26)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          THEN '2e Kerstdag'

                     END,

               holidayname = CASE
                                             WHEN (thedate = thefirstofyear)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            THEN 'New Year''s Day' -- Prinsessedag op 31 augustus: t/m 1948 (Wilhelmina)


                    WHEN (theyear <= 1948
                                                   AND themonth = 8
                                                   AND theday = 31)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              THEN 'Princess''s Day' -- Koninginnedag op 30 april: 1949-1979 (Juliana), behalve als zondag, dan 1 mei
 -- Koninginnedag op 30 april: 1980-2013 (Juliana), behalve als zondag, dan 29 april


                    WHEN (theyear >= 1949
                                                   AND theyear <= 2013
                                                   AND themonth = 4
                                                   AND theday = 30
                                                   AND thedayofweek <> 7)
                                                  OR (theyear >= 1949
                                                      AND theyear <= 1979
                                                      AND themonth = 5
                                                      AND theday = 1
                                                      AND thedayofweek = 1)
                                                  OR (theyear >= 1980
                                                      AND theyear <= 2013
                                                      AND themonth = 4
                                                      AND theday = 29
                                                      AND thedayofweek = 6) THEN 'Queen''s Day' -- Koningsdag op 27 april: 2014- (Willem Alexander), behalve als zondag, dan 26 april


                    WHEN (theyear >= 2014
                                                   AND themonth = 4
                                                   AND theday = 27
                                                   AND thedayofweek <> 7)
                                                  OR (theyear >= 2014
                                                      AND themonth = 4
                                                      AND theday = 26
                                                      AND thedayofweek = 6)                                                                                                                                                                                                                                                                                                                                                                                                                                                                        THEN 'King''s Day' -- since 1990 liberation day is an official national holiday
 -- *Note 5 may 2016 is both Liberation Day and Ascencion Day. This would create a duplicate record for that day (see union all below). This would create a duplicate record for that day (see union all below)


                    WHEN (theyear >= 1990
                                                   AND themonth = 5
                                                   AND theday = 5)-- HolidayText for 5th of May is always Liberation Day. It is however only a Public Holiday once every 5 year
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 THEN 'Liberation Day'

                    WHEN (themonth = 12
                                                   AND theday = 25)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    THEN 'Christmas'

                    WHEN (themonth = 12
                                                   AND theday = 26)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    THEN 'Boxing Day'

                     END,

               isbankholiday = CASE -- New Year's Day is only a bank holiday when it falls not in a weekend
 
                                                                                                                                                                                     
                    WHEN (thedate = thefirstofyear 
                                                                   AND thedayofweek <= 5)                                                                        THEN 1 -- Christmas is only a bank holiday when it falls not in a weekend
 
                                                             
                    WHEN (themonth = 12
                                                                   AND theday = 25
                                                                   AND thedayofweek <= 5) THEN 1 
                                                             
                    WHEN (themonth = 12
                                                                   AND theday = 26
                                                                   AND thedayofweek <= 5) THEN 1 
                                                             
                    ELSE 0 
                                                         
                     END ,
                                                         
               ispublicholiday = CASE 
                                                                               WHEN (thedate = thefirstofyear)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    THEN 1 -- Prinsessedag op 31 augustus: t/m 1948 (Wilhelmina)
 
                                                                               
                    WHEN (theyear <= 1948
                                                                                     AND themonth = 8
                                                                                     AND theday = 31)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  THEN 1 -- Koninginnedag op 30 april: 1949-1979 (Juliana), behalve als zondag, dan 1 mei
 -- Koninginnedag op 30 april: 1980-2013 (Juliana), behalve als zondag, dan 29 april
 
                                                                               
                    WHEN (theyear >= 1949
                                                                                     AND theyear <= 2013
                                                                                     AND themonth = 4
                                                                                     AND theday = 30
                                                                                     AND thedayofweek <> 7)
                                                                                    OR (theyear >= 1949
                                                                                        AND theyear <= 1979
                                                                                        AND themonth = 5
                                                                                        AND theday = 1
                                                                                        AND thedayofweek = 1)
                                                                                    OR (theyear >= 1980
                                                                                        AND theyear <= 2013
                                                                                        AND themonth = 4
                                                                                        AND theday = 29
                                                                                        AND thedayofweek = 6) THEN 1 -- Koningsdag op 27 april: 2014- (Willem Alexander), behalve als zondag, dan 26 april
 
                                                                               
                    WHEN (theyear >= 2014
                                                                                     AND themonth = 4
                                                                                     AND theday = 27
                                                                                     AND thedayofweek <> 7)
                                                                                    OR (theyear >= 2014
                                                                                        AND themonth = 4
                                                                                        AND theday = 26
                                                                                        AND thedayofweek = 6)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    THEN 1 -- Every 5 year liberation day is a public holiday if it falls on a weekday
 -- *Note 5 may 2016 is both Liberation Day and Ascencion Day. This would create a duplicate record for that day (see union all below)
 
                                                                               
                    WHEN (theyear >= 1990
                                                                                     AND theyear % 5 = 0
                                                                                     AND themonth = 5
                                                                                     AND theday = 5
                                                                                     AND thedayofweek <= 5)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               THEN 1 
                                                                               
                    WHEN (themonth = 12
                                                                                     AND theday = 25)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          THEN 1 
                                                                               
                    WHEN (themonth = 12
                                                                                     AND theday = 26)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          THEN 1 
                                                                           
                     END 
   
          FROM ##basecalendar cte 
   
         WHERE 1 = 1 
     
           AND thedate = thefirstofyear -- 'New Year''s Day'
 
     
            OR (theyear <= 1948
         AND themonth = 8
         AND theday = 31)-- 'Princess''s Day'
 
     
            OR (theyear >= 1949
         AND theyear <= 2013
         AND themonth = 4
         AND theday = 30
         AND thedayofweek <> 7)-- 'Queen''s Day'
 
     
            OR (theyear >= 1949
         AND theyear <= 1979
         AND themonth = 5
         AND theday = 1
         AND thedayofweek = 1)-- 'Queen''s Day'
 
     
            OR (theyear >= 1980
         AND theyear <= 2013
         AND themonth = 4
         AND theday = 29
         AND thedayofweek = 6)-- 'Queen''s Day'
 
     
            OR (theyear >= 2014
         AND themonth = 4
         AND theday = 27
         AND thedayofweek <> 7)-- 'King''s Day'
 
     
            OR (theyear >= 2014
         AND themonth = 4
         AND theday = 26
         AND thedayofweek = 6)-- 'King''s Day'
 
     
            OR (theyear >= 1990
         AND themonth = 5
         AND theday = 5)-- Liberation Day
 
     
            OR (themonth = 12
         AND theday = 25)-- Christmas
 
     
            OR (themonth = 12
         AND theday = 26)-- Boxing Day
 
   
     UNION ALL SELECT thedate = e.holidaydate , 
                    
               e.holidaynamedutch , 
                    
               e.holidayname , 
                    
               isbankholiday = CASE e.holidayname 
                                               
                    WHEN 'Good Friday'   THEN 1 
                                        
                    WHEN 'Easter Monday' THEN 1 
                                        
                    ELSE 0 
                                    
                     END , 
                                    
               ispublicholiday = 1 
   
          FROM ##easter e
       ) , 
     
       lwdm AS -- Last Workday Of Month
 
  
        (SELECT max(thedate) thelastworkdayofmonth, 
          
               yearmonth AS lwdm_yearmonth 
   
          FROM ##basecalendar d 
   
          LEFT JOIN holidays h 
            ON d.thedate = h.holidaydate 
   
         WHERE d.isweekend = 0 
     
           AND h.holidaydate IS NULL 
   
         GROUP BY d.yearmonth
       ) , fwdm AS -- First Workday Of Month
 
  
        (SELECT min(thedate) thefirstworkdayofmonth, 
          
               yearmonth AS fwdm_yearmonth 
   
          FROM ##basecalendar d 
   
          LEFT JOIN holidays h 
            ON d.thedate = h.holidaydate 
   
         WHERE d.isweekend = 0 
     
           AND h.holidaydate IS NULL 
   
         GROUP BY d.yearmonth
       ) , lfdm AS -- Last Friday Of Month
 
  
        (SELECT min(thedate) thelastworkdayofmonth, 
          
               yearmonth AS fwdm_yearmonth 
   
          FROM ##basecalendar d 
   
         WHERE thedayofweek = 5 
   
         GROUP BY d.yearmonth
       ) , wdm AS 
  
        (SELECT d.thedate , 
          
               row_number() OVER (PARTITION BY d.yearmonth 
                             ORDER BY d.thedate) AS workdayofmonth , 
          
               row_number() OVER (PARTITION BY 1 
                             ORDER BY d.thedate) AS workdaycounter 
   
          FROM ##basecalendar d 
   
          LEFT JOIN holidays h 
            ON h.holidaydate = d.thedate 
   
         WHERE d.isweekend = 0 
     
           AND isnull(h.ispublicholiday, 0) = 0
       ) 
INSERT INTO [adf].[dwh_date] (datekey , thedate , theday , thedaysuffix , thedayname , thedayofweek , thedayofweekinmonth , thedayofyear , isweekend , isworkday , workdayofmonth , theweek , theisoweek , thefirstofweek , thelastofweek , theweekofmonth , themonth , themonthname , thefirstworkdayofmonth , thefirstofmonth , thelastworkdayofmonth , thelastofmonth , thefirstofnextmonth , thelastofnextmonth , thequarter , thefirstofquarter , thelastofquarter , theyear , theisoyear , thefirstofyear , thelastofyear , isleapyear , has53weeks , has53isoweeks , mmyyyy , style101 , style103 , style112 , style120 , yearweek , yearisoweek , yearmonth , holidayname , isbankholiday , ispublicholiday , holidayname_nl , thedayname_nl , themonthname_nl , daycounter , workdaycounter) 
SELECT [datekey] = convert(varchar(8), d.[thedate], 112) , 
       
       d.[thedate] , 
       
       d.[theday] , 
       
       d.[thedaysuffix] , 
       
       d.[thedayname] , 
       
       d.[thedayofweek] , 
       
       d.[thedayofweekinmonth] , 
       
       d.[thedayofyear] , 
       
       d.[isweekend] , 
       
       [isworkday] = CASE 
                         WHEN d.isweekend = 0
                              AND isnull(h.ispublicholiday, 0) = 0 THEN 1 
                         
            ELSE 0 
                     
             END , 
                     
       workdayofmonth = coalesce(wdm.workdayofmonth, 0) , 
                     
       d.[theweek] , 
                     
       d.[theisoweek] , 
                     
       d.[thefirstofweek] , 
                     
       d.[thelastofweek] , 
                     
       d.[theweekofmonth] , 
                     
       d.[themonth] , 
                     
       d.[themonthname] , 
                     
       fwdm.thefirstworkdayofmonth , 
                     
       d.[thefirstofmonth] , 
                     
       lwdm.[thelastworkdayofmonth] , 
                     
       d.[thelastofmonth] , 
                     
       d.[thefirstofnextmonth] , 
                     
       d.[thelastofnextmonth] , 
                     
       d.[thequarter] , 
                     
       d.[thefirstofquarter] , 
                     
       d.[thelastofquarter] , 
                     
       d.[theyear] , 
                     
       d.[theisoyear] , 
                     
       d.[thefirstofyear] , 
                     
       d.[thelastofyear] , 
                     
       d.[isleapyear] , 
                     
       d.[has53weeks] , 
                     
       d.[has53isoweeks] , 
                     
       d.[mmyyyy] , 
                     
       d.[style101] , 
                     
       d.[style103] , 
                     
       d.[style112] , 
                     
       d.[style120] , 
                     
       d.[yearweek] , 
                     
       d.[yearisoweek] , 
                     
       d.[yearmonth] , 
                     
       [holidayname] = cast(isnull(h.[holidayname], '') AS varchar(255)) , 
                     
       [isbankholiday] = isnull(h.[isbankholiday], 0) , 
                     
       [ispublicholiday] = isnull(h.[ispublicholiday], 0) , 
                     
       [holidaynamedutch] = cast(isnull(h.[holidaynamedutch], '') AS varchar(255)) , 
                     
       thedayname_nl = CASE 
                                         WHEN d.[thedayofweek] = 1 THEN 'maandag' 
                                         
            WHEN d.[thedayofweek] = 2 THEN 'dinsdag' 
                                         
            WHEN d.[thedayofweek] = 3 THEN 'woensdag' 
                                         
            WHEN d.[thedayofweek] = 4 THEN 'donderdag' 
                                         
            WHEN d.[thedayofweek] = 5 THEN 'vrijdag' 
                                         
            WHEN d.[thedayofweek] = 6 THEN 'zaterdag' 
                                         
            WHEN d.[thedayofweek] = 7 THEN 'zondag' 
                                         
            ELSE '' 
                                     
             END , 
                                     
       themonthname_nl = CASE 
                                                           WHEN d.[themonth] = 1  THEN 'januari' 
                                                           
            WHEN d.[themonth] = 2  THEN 'februari' 
                                                           
            WHEN d.[themonth] = 3  THEN 'maart' 
                                                           
            WHEN d.[themonth] = 4  THEN 'april' 
                                                           
            WHEN d.[themonth] = 5  THEN 'mei' 
                                                           
            WHEN d.[themonth] = 6  THEN 'juni' 
                                                           
            WHEN d.[themonth] = 7  THEN 'juli' 
                                                           
            WHEN d.[themonth] = 8  THEN 'augustus' 
                                                           
            WHEN d.[themonth] = 9  THEN 'september' 
                                                           
            WHEN d.[themonth] = 10 THEN 'oktober' 
                                                           
            WHEN d.[themonth] = 11 THEN 'november' 
                                                           
            WHEN d.[themonth] = 12 THEN 'december' 
                                                           
            ELSE ''

             END ,

       daycounter = row_number() OVER (
                                                                                       ORDER BY d.thedate ASC) ,

       workdaycounter = COALESCE (-- coalesce is needed if the calendare starts with a weekend or an holiday
 max(wdm.workdaycounter) OVER (
                               ORDER BY d.thedate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) ,
 0)

  FROM ##basecalendar d

  LEFT JOIN lwdm
    ON lwdm.lwdm_yearmonth = d.yearmonth

  LEFT JOIN fwdm
    ON fwdm.fwdm_yearmonth = d.yearmonth

  LEFT JOIN holidays h
    ON h.holidaydate = d.thedate

  LEFT JOIN wdm
    ON wdm.thedate = d.thedate

 ORDER BY thedate ASC