 /* BEGIN COMMENT-->
{
  "Description":
	[
    "Create DataType syntax for table creation - redesigned from 2011",
	"First parameter is the AttributeID, the second paramter @GetIsNullable gives the option to get Nullbale information, Default set to 1 (give nullable information)",
	"The third @AddAs gives you the possibility to make sql statements like cast([Kim] AS [int])"
	],
	"Example": "Select [rep].[GetDummyValueByAttributeId](441232,'-1', '<Empty>','1900-01-01')",
	"Fail Example": "Select [rep].[GetDataTypeSyntaxByAttributeId](-1)",
  "Log": [
    {"Change date": "20190923", "Author":"Tijs van Rinsum"      , "Description":"Initial"},
    {"Change date": "20211205", "Author":"Kim Vermeij"          , "Description":"Code Review"}
    ]
}
select
STRING_AGG(
										CONVERT(VARCHAR(max),
											[rep].[GetDummyValueByAttributeBK](a.BK,'-1', '<Empty>','1900-01-01') +' AS '+ QUOTENAME(A.AttributeName)
										)

									,',' ) WITHIN GROUP (ORDER BY  cast(a.OrdinalPosition as int))
<--END COMMENT */
CREATE
FUNCTION [rep].[getdummyvaluebyattributebk] (@attributebk varchar(255), @dummytype varchar(2) = '-1' --/ -2
, @dummystring10 varchar(10) = '<EMPTY>' --/ '<UNKNOWN>'
, @dummydate varchar(10) = '1900-01-01') RETURNS varchar(255) AS BEGIN --;
--with dummy_list as ( select reftype from bld.vw_RefType RT where 1=1 and rt.RefTypeAbbr = 'DUM' and [Name] = @DummyType )
--select
--	  DummyDate			= [Code]
--	, DummyValue		= [Name]
--from   bld.vw_RefType RT
--join dummy_list dl on rt.reftype = dl.reftype
 DECLARE @datatype varchar(20),

       @maxlength varchar(10),

       @dummystringshort varchar(2)

   SET @dummystringshort = cast(@dummytype AS varchar(2)) BEGIN
SELECT @datatype = a.datatype,

       @maxlength = --cast(A.MaximumLength as int)
 cast(CASE
          WHEN a.maximumlength = 'max' THEN '-1'
          ELSE a.maximumlength
      END AS int) --cast(
 --	case
 --		--when A.MaximumLength = 'max' then '-1'
 --	    when A.MaximumLength = '-1'
 --								then case
 --										when A.DataType = 'varchar'
 --											then '8000'
 --											else '4000'
 --										end
 --		else A.MaximumLength
 --		end
 --   as int)

  FROM bld.vw_attribute a

 WHERE a.bk = @attributebk if(@datatype IS NULL) BEGIN RETURN 'DATATYPE NOT FOUND'; END -- Declare the return variable here
 DECLARE @result varchar(255)

   SET @result = 'ERROR';
  SELECT @result = CASE
                       WHEN @datatype IN ('nchar',
                                          'nvarchar',
                                          'char',
                                          'varchar')
                            AND (@maxlength > 9
                                 OR @maxlength = -1)                                   THEN + '''' +@ dummystring10 + ''''

            WHEN @datatype IN ('nchar',
                                          'nvarchar',
                                          'char',
                                          'varchar')
                            AND @maxlength BETWEEN 2 AND 9                                                                              THEN '''' +@ dummystringshort + ''''

            WHEN @datatype IN ('nchar',
                                          'nvarchar',
                                          'char',
                                          'varchar')
                            AND @maxlength = 1                                                                                          THEN '''' + '-' + ''''

            WHEN @datatype IN ('smallint',
                                          'int',
                                          'bigint',
                                          'tinyint',
                                          'numeric',
                                          'decimal') THEN @dummytype

            WHEN @datatype IN ('uniqueidentifier',
                                          'xml',
                                          'bit',
                                          'varbinary')                                                                                                      THEN '''' + '0' + ''''

            WHEN @datatype IN ('date',
                                          'datetime',
                                          'datetime2')                                                                                                                                                               THEN '''' + @dummydate + ''''

            WHEN @datatype IN ('time')                                                                                                                                                                                                                                                                              THEN '''' + '00:00:00' + ''''

             END -- Set @Result = iif(@AddAs=1, 'AS '+@Result,@Result)
 if(@result = '') BEGIN

   SET @result = 'ERRORR' END RETURN @result END END
