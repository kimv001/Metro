CREATE FUNCTION [rep].[GetColumnListPerDatasetBK]  -- noqa: PRS
(
	@DatasetBK VARCHAR(255),
	@Option INT = 1,
	@Type VARCHAR(7),
	@prefixA VARCHAR(MAX) = '',
	@postfixA VARCHAR(MAX) = '',
	@prefixDS VARCHAR(MAX) = '',
	@postfixDS VARCHAR(MAX) = '',
	@seperator VARCHAR(MAX) = '',
	@UseExpression INT = 0
)
RETURNS VARCHAR(MAX)
AS

BEGIN
	-- Declare the return variable here
	DECLARE @Result VARCHAR(max),
		@lenSeperator INT = len(@seperator)-0


if @Option = -1	-- column cast as datatype ordered by ordinal position
	SELECT @Result =    @prefixDS+ STUFF((
					SELECT @seperator +CHAR(10)+ 
					ISNULL(@prefixA+ISNULL(CASE WHEN @UseExpression=1 THEN ISNULL(cast(A.Expression as varchar(max)),QUOTENAME(A.AttributeName))
												WHEN @UseExpression=0 THEN QUOTENAME(A.AttributeName)
												END
												, '')
													
													+@postfixA,'N/A')
						
						FROM bld.vw_Attribute A
						where 1=1
						 and A.BK_Dataset = @DatasetBK
						AND (
													(iif(@Type='','all',@Type) = 'all' )
													OR (@Type = 'bk_data'	and cast(isnull(a.Ismta,0) as int) = 0)
													OR (@Type = 'bk'		and cast(A.BusinessKey as int) > 0)
													OR (@Type = 'data'		and cast(A.BusinessKey as int) = 0 and cast(isnull(a.IsMta,0) as int) = 0)
													OR (@Type = 'rh'		and cast(A.BusinessKey as int) = 0 and isnull(a.IsMta,0) = 0 and cast(isnull(a.NotInRH,0) as int)=0)
													OR (@Type = 'mta'		and cast(isnull(a.IsMta,0) as int) = 1)
													)
       ORDER BY case when @Type='bk' then cast(a.businesskey as int) else cast(a.OrdinalPosition as int) end asc
						 FOR XML PATH(''), TYPE).value('.', 'VARCHAR(MAX)'
						), 1, @lenSeperator, '') + @postfixDS
													


if @Option = -2	-- column cast as datatype ordered by ordinal position

	SELECT @Result =    @prefixDS+ STUFF((
					SELECT @seperator +CHAR(10) + ISNULL(@prefixA+QUOTENAME(A.AttributeName)+' ' +a.[DDL_Type2]+@postfixA ,'N/A')
						FROM bld.vw_Attribute A
						where 1=1
						 and A.BK_Dataset = @DatasetBK
						AND (
													(iif(@Type='','all',@Type) = 'all' )
													OR (@Type = 'bk_data'	and cast(isnull(a.IsMta,0) as int) = 0)
													OR (@Type = 'bk'		and A.BusinessKey is not null)
													OR (@Type = 'data'		and A.BusinessKey is null and cast(isnull(a.IsMta,0) as int) = 0)
													OR (@Type = 'rh'		and A.BusinessKey is null and cast(isnull(a.IsMta,0)  as int) = 0 and cast(isnull(a.NotInRH,0) as int)=0)
													OR (@Type = 'mta'		and cast(isnull(a.IsMta,0) as int) = 1)
													)
      ORDER BY case when @Type='bk' then cast(a.businesskey as int) else cast(a.OrdinalPosition as int) end asc
						 FOR XML PATH(''), TYPE).value('.', 'VARCHAR(MAX)'
						), 1, @lenSeperator, '') + @postfixDS
	
if @Option = -4	-- column cast as datatype ordered by ordinal position

	SELECT @Result = 
					@prefixDS+ 
					STUFF((
					SELECT @seperator +CHAR(10) + ISNULL(@prefixA+ISNULL(cast(A.Expression as varchar(max)),QUOTENAME(A.AttributeName))+' ' +a.[DDL_Type3]+@postfixA+' ' +QUOTENAME(cast(A.AttributeName as varchar(max))),'N/A')
						FROM bld.vw_Attribute A
						where 1=1
						 and A.BK_Dataset = @DatasetBK
						AND (
													(iif(@Type='','all',@Type) = 'all' )
													OR (@Type = 'bk_data'	and isnull(a.IsMta,0) = 0)
													OR (@Type = 'bk'		and cast(A.BusinessKey as int)>0)
													OR (@Type = 'data'		and cast(A.BusinessKey as int) = 0 and cast(isnull(a.IsMta,0) as int) = 0)
													OR (@Type = 'rh'		and cast(A.BusinessKey as int) = 0 and cast(isnull(a.IsMta,0) as int) = 0 and cast(isnull(a.NotInRH,0) as int)=0)
													OR (@Type = 'mta'		and cast(isnull(a.IsMta,0) as int) = 1)
													)
       ORDER BY case when @Type='bk' then (ISNULL(cast(a.businesskey as int),100)*1000)+ cast(a.OrdinalPosition as int)  else cast(a.OrdinalPosition as int) end asc
						 FOR XML PATH(''), TYPE).value('.', 'VARCHAR(MAX)'
						), 1, @lenSeperator, '')
						+ @postfixDS


if @Option = -7 --- Empty Dummies
	SELECT @Result =  REPLACE( REPLACE(  @prefixDS+ STUFF((
					SELECT @seperator + ISNULL(@prefixA + [rep].[GetDummyValueByAttributeBK](a.BK,'-1', '<Empty>','1900-01-01') +' AS '+ QUOTENAME(A.AttributeName)+@postfixA ,'')
						FROM bld.vw_Attribute A
						where 1=1
						 and A.BK_Dataset = @DatasetBK
						AND (
													(iif(@Type='','all',@Type) = 'all' )
													OR (@Type = 'bk_data'	and cast(isnull(a.IsMta,0) as int) = 0)
													OR (@Type = 'bk'		and A.BusinessKey is not null)
													OR (@Type = 'data'		and A.BusinessKey is null and cast(isnull(a.IsMta,0) as int) = 0)
													OR (@Type = 'rh'		and A.BusinessKey is null and cast(isnull(a.IsMta,0) as int) = 0 and cast(a.NotInRH as int)=0)
													OR (@Type = 'mta'		and cast(isnull(a.IsMta,0) as int) = 1)
													)
       ORDER BY case when @Type='bk' then (ISNULL(cast(a.businesskey as int),100)*1000)+ cast(a.OrdinalPosition as int)  else cast(a.OrdinalPosition as int) end asc

						 FOR XML PATH(''), TYPE).value('.', 'VARCHAR(MAX)'
						), 1, @lenSeperator, '') + @postfixDS
						, '&lt;','<'), '&gt;','>')
						
if @Option = -8 --- Empty Unknown
	SELECT @Result =  REPLACE( REPLACE(  @prefixDS+ STUFF((
					SELECT @seperator + ISNULL(@prefixA + [rep].[GetDummyValueByAttributeBK](a.BK,'-2', '<Unknown>','1900-01-01') +' AS '+ QUOTENAME(A.AttributeName)+@postfixA ,'')
						FROM bld.vw_Attribute A
						where 1=1
						 and A.BK_Dataset = @DatasetBK
						AND (
													(iif(@Type='','all',@Type) = 'all' )
													OR (@Type = 'bk_data'	and isnull(a.IsMta,0) = 0)
													OR (@Type = 'bk'		and A.BusinessKey is not null)
													OR (@Type = 'data'		and A.BusinessKey is null and cast(isnull(a.IsMta,0) as int) = 0)
													OR (@Type = 'rh'		and A.BusinessKey is null and cast(isnull(a.IsMta,0)  as int) = 0 and cast(a.NotInRH  as int)=0)
													OR (@Type = 'mta'		and cast(isnull(a.IsMta,0) as int) = 1)
													)
        ORDER BY case when @Type='bk' then (ISNULL(cast(a.businesskey as int),100)*1000)+ cast(a.OrdinalPosition as int)  else cast(a.OrdinalPosition as int) end asc
						 FOR XML PATH(''), TYPE).value('.', 'VARCHAR(MAX)'
						), 1, @lenSeperator, '') + @postfixDS
						, '&lt;','<'), '&gt;','>')
					
	-- Return the result of the function
	RETURN @Result

END