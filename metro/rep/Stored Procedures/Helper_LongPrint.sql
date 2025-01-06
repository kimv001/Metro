
CREATE PROCEDURE rep.[helper_longprint] @string varchar(MAX) AS /*
=== Comments =========================================

Description:
This procedure is designed to overcome the limitation
in the SQL print command that causes it to truncate strings
longer than 8000 characters (4000 for nvarchar).

It will print the text passed to it in substrings smaller than 4000
characters.  If there are carriage returns (CRs) or new lines (NLs in the text),
it will break up the substrings at the carriage returns and the
printed version will exactly reflect the string passed.

If there are insufficient line breaks in the text, it will
print it out in blocks of 4000 characters with an extra carriage
return at that point.

If it is passed a null value, it will do virtually nothing.

NOTE: This is substantially slower than a simple print, so should only be used
when actually needed.

Test:
OK:
exec rep.[Helper_LongPrint] @string =
									'This String
									Exists to test
									the system.'

NOK:

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
=======================================================
*/ /*
Example:

*/ /*
 */ DECLARE @currentend BIGINT, /* track the length of the next substring */ @offset tinyint /*tracks the amount of offset needed */

   SET @string = replace(replace(@string, char(13) + char(10), char(10)), char(13), char(10)) WHILE len(@string) > 1 BEGIN IF charindex(char(10), @string) BETWEEN 1 AND 8000 BEGIN

   SET @currentend = charindex(char(10), @string) -1

   SET @offset = 2 END ELSE BEGIN

   SET @currentend = 8000

   SET @offset = 1 END PRINT substring(@string, 1, @currentend)

   SET @string = substring(@string, @currentend +@
                        OFFSET, 1073741822) END /*End While loop*/
