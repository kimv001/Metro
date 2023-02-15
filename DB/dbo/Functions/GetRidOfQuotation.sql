


/* BEGIN COMMENT-->
{
  "Description": 
	[
    "Gets rid of the QUOTES [ ]",
	"Stolen from https://dba.stackexchange.com/questions/195923/is-there-any-hidden-built-in-function-on-ms-sql-to-unquote-object-names"
	],
	"Example": 
		[
		"select[rep].[GetRidOfQuotation] ('[sta].[Kim]')"
		"select[rep].[GetRidOfQuotation] ('[Kim]')"
		],
	"Fail Example":
		[
		"Select [rep].[GetRidOfQuotation]('TestKim]]')",
		"Select [rep].[GetRidOfQuotation]('[TestKim]]')"
		]
  "Log": [
    {"Change date": "20220116", "Author":"Kim Vermeij"			, "Description":"Initial"
    ]
}
<--END COMMENT */


Create FUNCTION dbo.[GetRidOfQuotation](@TXT NVARCHAR(MAX)) 
RETURNS NVARCHAR(MAX)
AS
    BEGIN
        RETURN 
	
			IIF(LEFT(@TXT, 1) = N'[' AND RIGHT(@TXT, 1) = N']', 
                   SUBSTRING(@TXT, 2, LEN(@TXT) -  2), 
                   @TXT);
				

				--   SET @TXT = replace(replace(@TXT,N'[',N'')

    END;