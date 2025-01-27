

CREATE PROCEDURE rep.[Helper_LongPrint]
      @String VARCHAR(MAX)

AS


/* 
=== Comments =========================================

Description:
    This procedure is designed to overcome the limitation in the SQL print command that causes it to truncate strings longer than 8000 characters (4000 for nvarchar).
    It will print the text passed to it in substrings smaller than 4000 characters. If there are carriage returns (CRs) or new lines (NLs) in the text, 
    it will break up the substrings at the carriage returns and the printed version will exactly reflect the string passed.
    If there are insufficient line breaks in the text, it will print it out in blocks of 4000 characters with an extra carriage return at that point.
    If it is passed a null value, it will do virtually nothing.
    NOTE: This is substantially slower than a simple print, so should only be used when actually needed.

Parameters:
    @String VARCHAR(MAX)  -- The string to be printed.

Example Usage:
    -- To print a long string
    exec rep.[Helper_LongPrint] @string = 'This String Exists to test the system.'

Procedure Logic:
    1. Checks if the input string is null.
    2. Initializes variables for string length and position.
    3. Loops through the string and prints substrings of up to 4000 characters.
    4. Handles carriage returns and new lines to ensure the printed version reflects the original string.

AST:
Procedure: [rep].[Helper_LongPrint]
  Parameters:
    - @String: VARCHAR(MAX)
  Variables:
    - @Len: INT
    - @Pos: INT
    - @Substr: VARCHAR(4000)
  Logic:
    - Check if the input string is null
    - Initialize variables for string length and position
    - Loop through the string and print substrings of up to 4000 characters
    - Handle carriage returns and new lines

Mermaid Diagram:
graph TD
    A[Start] --> B{Is @String null?}
    B --> C[Do nothing]
    B --> D[Initialize variables for string length and position]
    D --> E{Loop through the string}
    E --> F[Print substrings of up to 4000 characters]
    F --> G{Handle carriage returns and new lines}
    G --> E
    E --> H[End]

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
=======================================================
*/


DECLARE
               @CurrentEnd BIGINT, /* track the length of the next substring */
               @offset tinyint /*tracks the amount of offset needed */


SET @string = replace(  replace(@string, char(13) + char(10), char(10))   , char(13), char(10))

WHILE LEN(@String) > 1
BEGIN

              
    IF CHARINDEX(CHAR(10), @String) BETWEEN 1 AND 8000
    BEGIN

           SET @CurrentEnd =  CHARINDEX(char(10), @String) -1
           SET @offset = 2
    END
    ELSE
    BEGIN
           SET @CurrentEnd = 8000
            SET @offset = 1
    END   
   

    PRINT SUBSTRING(@String, 1, @CurrentEnd) 
                                                 
    SET @string = SUBSTRING(@String, @CurrentEnd+@offset, 1073741822)   
              
END /*End While loop*/