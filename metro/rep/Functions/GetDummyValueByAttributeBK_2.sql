
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


CREATE FUNCTION [rep].[GetDummyValueByAttributeBK]
(      
       @AttributeBK varchar(255)
	   , @DummyType varchar(2)		= '-1' --/ -2
	   , @DummyString10 varchar(10) = '<EMPTY>' --/ '<UNKNOWN>'
	   , @DummyDate varchar(10)		= '1900-01-01'
	   
	 
)
RETURNS varchar(255)
AS
BEGIN
--;
--with dummy_list as ( select reftype from bld.vw_RefType RT where 1=1 and rt.RefTypeAbbr = 'DUM' and [Name] = @DummyType )
--select 
--	  DummyDate			= [Code]
--	, DummyValue		= [Name] 
--from   bld.vw_RefType RT
--join dummy_list dl on rt.reftype = dl.reftype

	DECLARE @DataType varchar(20), @MaxLength varchar(10), @DummyStringShort varchar(2)
	SET @DummyStringShort = cast(@DummyType as varchar(2))

	   BEGIN
		
	   
			SELECT 
				  @DataType		= A.DataType
				, @MaxLength	= 
									--cast(A.MaximumLength as int)

								cast(
									case
										when A.MaximumLength = 'max' then '-1'
									    else A.MaximumLength
										end
								   as int)

								--cast(
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


			FROM bld.vw_Attribute A
			WHERE A.BK = @AttributeBK
		
		

		IF(@DataType IS NULL)
			BEGIN
				RETURN 'DATATYPE NOT FOUND';
			END
		-- Declare the return variable here
       DECLARE @Result varchar(255)
       
       SET @Result = 'ERROR';
       
       SELECT @Result = 
		CASE 
			WHEN @DataType IN ('nchar', 'nvarchar', 'char', 'varchar') AND (@MaxLength > 9 or @MaxLength =-1) THEN +''''+@DummyString10+''''
			WHEN @DataType IN ('nchar', 'nvarchar', 'char', 'varchar') AND @MaxLength between 2 AND 9 THEN ''''+@DummyStringShort+''''
			WHEN @DataType IN ('nchar', 'nvarchar', 'char', 'varchar') AND @MaxLength =1 THEN ''''+'-'+''''
             


			WHEN @DataType IN ('smallint', 'int','bigint', 'tinyint', 'numeric', 'decimal') THEN @DummyType
			WHEN @DataType IN ('uniqueidentifier', 'xml', 'bit', 'varbinary') THEN ''''+ '0' +''''
			WHEN @DataType IN ('date','datetime','datetime2' ) THEN ''''+ @DummyDate+''''
			WHEN @DataType IN ('time' ) THEN ''''+ '00:00:00' +''''
		END

	  -- Set @Result = iif(@AddAs=1, 'AS '+@Result,@Result)
		   IF(@Result = '')
			   BEGIN 
					 SET @Result = 'ERRORR'
			   END
       RETURN @Result
END
END