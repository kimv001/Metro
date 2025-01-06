
CREATE
FUNCTION rep.[getnamepart] (@name nvarchar(255), @position int) /*
=== Comments =========================================

Description:
	retruns the first, second or the thirdname part of a string. The function doesnt work with four or more parts.

Test:
OK:
select rep.[GetNamePart] ('Groupname_ShortName',2)					-- returns 'Shortname'
select rep.[GetNamePart] ('vw_Groupname_ShortName',2)				-- returns 'Groupname'
select rep.[GetNamePart] ('vw_Groupname_ShortName',1)				-- returns 'vw'
select rep.[GetNamePart] ('vw_Groupname_ShortName_suffix',4)		-- returns 'suffix'

NOK:
select rep.[GetNamePart] ('vw_prefix_Groupname_ShortName_suffix',4) -- returns 'NULL', because the name contains 5 parts

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
=======================================================
*/ RETURNS nvarchar(255) AS BEGIN DECLARE @result nvarchar(255)

   SET @result = reverse(parsename(replace(reverse(@name), '_', '.'), @position)) if(@result = '') BEGIN

   SET @result = 'ERRORR' END RETURN @result END
