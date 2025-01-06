


CREATE FUNCTION rep.[GetRidOfQuotation](@TXT NVARCHAR(MAX)) 

/*
Developed by:			metro
Description:			
    Gets rid of the QUOTES [ ],
	Stolen from https://dba.stackexchange.com/questions/195923/is-there-any-hidden-built-in-function-on-ms-sql-to-unquote-object-names

OK:
Select[rep].[GetRidOfQuotation] ('[Kim]')

NOK:
Select[rep].[GetRidOfQuotation] ('[sta].[Kim]')
Select [rep].[GetRidOfQuotation]('TestKim]]')
Select [rep].[GetRidOfQuotation]('[TestKim]]')


Change log:
Date					Author				Description
20220915 00:00			K. Vermeij			Initial version
*/

RETURNS NVARCHAR(MAX)
AS
    BEGIN
        RETURN 
	
			IIF(LEFT(@TXT, 1) = N'[' AND RIGHT(@TXT, 1) = N']', 
                   SUBSTRING(@TXT, 2, LEN(@TXT) -  2), 
                   @TXT);
				

				--   SET @TXT = replace(replace(@TXT,N'[',N'')

    END;