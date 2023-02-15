
/* BEGIN COMMENT-->
{
  "Description": 
	[
    "Get name part based on underscores (_)"
	],
	"Example": "
	Select [dbo].[GetNamePart]('Test_Kim_Underscore_20',2)
	Select [dbo].[GetNamePart](replace('Tr_10_dataset_20_add','tr_',''),4)
	",
	"Fail Example":
		[
		"Select [dbo].[GetNamePart]('TestKim',-5)",
		"Select [dbo].[GetNamePart]('Test._Kim',2)"
		]
  "Log": [
    {"Change date": "20211105", "Author":"Kim Vermeij"			, "Description":"Initial"},
    {"Change date": "20211205", "Author":"Kim Vermeij"          , "Description":"Code Review"}
    ]
}
<--END COMMENT */

CREATE FUNCTION [dbo].[GetNamePart]
(
       @Name nvarchar(255),
	   @Position int
)
RETURNS nvarchar(255)
AS
BEGIN
       DECLARE @Result nvarchar(255)
            
       
set  @Result=  reverse(parsename(replace(reverse(@Name), '_', '.'), @Position)) 

IF(@Result = '')
       BEGIN 
             SET @Result = 'ERRORR'
       END
       
       RETURN @Result
       
END