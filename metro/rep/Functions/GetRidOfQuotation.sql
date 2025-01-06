
CREATE
FUNCTION rep.[getridofquotation](@txt nvarchar(MAX)) /*
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
*/ RETURNS nvarchar(MAX) AS BEGIN RETURN iif(left(@txt, 1) = n'['
                                             AND right(@txt, 1) = n']', substring(@txt, 2, len(@txt) - 2), @txt); --   SET @TXT = replace(replace(@TXT,N'[',N'')
 END;
