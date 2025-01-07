
CREATE VIEW [bld].[tr_700_BuildCheck_010_dataset] AS
/* 
=== Comments =========================================

Description:
	The BuildChecks are the last step(s) before the templates get filled

	# Note
	Because of the recoding of Metro, the most checks need  a review before activating them.
	All old Checks are commented out
	
	
Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
=======================================================
*/


WITH ErrorCodes AS (
	SELECT Severity, Code, Error FROM 
			(VALUES 
				/* 
				Severity:
						1	Blocking for ETL Generation
						2	Blocking for ETL Execution
						3	Warning or Consideration
				*/
					
					 (1, 'U1', 'Dataset has no BusinessKey defined')
					,(1, 'U2', '%File Dataset has no (valid) fileproperties defined')
					,(1, 'U3', '%File Dataset has no (valid) fileformat defined')
					,(1, 'U4', 'Dataset has no correct BusinessKey order defined')
					,(1, 'U5', 'Dataset has no atrributes defined')
					,(1, 'U6', 'Dataset has attributes with the same ordinal position defined')
					,(3, 'C1', 'Scale is set to 0, consider a (big)integer')
					,(1, 'U7', 'DataType not defined')
					,(1, 'U8', 'Datatype Length is not defined')
					,(1, 'U9', 'Datatype Scale and/or Precesion is not set correct')

					)  list ([Severity], [Code], [Error])   -- noqa: PRS

)
, All_Checks AS (
SELECT
	  BK_Dataset		= a.bk_dataset
	, Code				= a.code
	--, DatasetName		= d.DatasetName
	, CheckMessage		= 'Dataset has no BusinessKey defined' -- U1
	--, BK_Schema			= s.bk
	--, BK_Group			= d.BK_Group

	
FROM bld.vw_Attribute		a
LEFT JOIN bld.vw_Dataset	d ON a.bk_dataset	= d.bk
--left join rep.vw_Schema		s on d.bk_schema	= s.bk
WHERE 1=1
AND d.BK_Layer = 'src'
GROUP BY a.bk_dataset, a.code
HAVING sum(isnull(CAST(a.businesskey AS int),0)) = 0

UNION ALL

SELECT 
	 BK_Dataset		= d.bk
	, Code				= d.code
	, CheckMessage		= '%File Dataset has no (valid) fileproperties defined' -- U2


FROM bld.vw_Dataset D
LEFT JOIN bld.vw_FileProperties fp ON fp.Code = D.code

WHERE 1=1
AND (
		d.ObjectType LIKE '%file' 

	)
GROUP BY d.bk, d.code
HAVING count(isnull(fp.code,0)) =0

UNION ALL

SELECT 
	d.bk, d.code
	, CheckMessage		= 'Dataset has no atrributes defined' -- U5
	
FROM bld.vw_Dataset D
LEFT JOIN bld.vw_attribute a ON A.BK_Dataset = D.bk

WHERE 1=1

AND (
		d.SchemaName = 'src_file' 
		OR
		d.prefix= 'trv'
	)

GROUP BY d.bk, d.code
HAVING count(isnull(a.BK_Dataset,0)) =0

UNION ALL

SELECT 
	d.bk, d.code
	, CheckMessage		= 'Dataset has attributes with the same ordinal position defined' -- U6
	
FROM bld.vw_Dataset D
LEFT JOIN bld.vw_attribute a ON A.BK_Dataset = D.bk

WHERE 1=1
--and d.Active = 1
AND (
		d.SchemaName = 'src_file' 
		OR
		d.prefix = 'trv'
	)

GROUP BY d.bk, d.code, a.OrdinalPosition
HAVING count (a.OrdinalPosition)>1


UNION ALL

SELECT 
	d.bk, d.code
	, CheckMessage				= CASE 
										WHEN a.datatype IN ('numeric', 'decimal') AND a.scale = 0 THEN a.AttributeName + ' : Scale is set to 0, consider a (big)integer'   -- W1
									END 	

FROM bld.vw_Dataset D
LEFT JOIN bld.vw_attribute a ON A.BK_Dataset = D.bk

WHERE 1=1

AND (
		d.SchemaName = 'src_file' 
		OR
		d.prefix = 'trv'
	)

UNION ALL

SELECT 
	d.bk, d.code
	, CheckMessage				= CASE 
										WHEN ISNULL(a.datatype,'') = ''		THEN a.AttributeName + ' :DataType not defined'	-- U7
										-- U8
										WHEN
										    a.datatype IN ('char', 'varchar', 'nchar', 'nvarchar') AND ISNULL(a.MaximumLength, 0) = 0
										    THEN a.AttributeName + ' :Datatype Length is nog defined'
										-- U9
										WHEN
										    a.datatype IN ('numeric', 'decimal') AND ( ISNULL(a.scale, -1) = -1 OR ISNULL(a.Precision, -1) = -1)
										    THEN a.AttributeName + ' :Datatype Scale and/or Precesion is not set correct'
									END 	
	
FROM bld.vw_Dataset D
LEFT JOIN bld.vw_attribute a ON A.BK_Dataset = D.bk

WHERE 1=1

AND (
		d.SchemaName = 'src_file' 
		OR
		d.prefix = 'trv'
	)
)
SELECT 
	  BK				= AC.BK_Dataset + AC.CheckMessage
	, Code				= AC.Code
	, CheckMessage		= AC.CheckMessage
	, LayerName			= d.LayerName
	, SchemaName		= d.SchemaName
	, GroupName			= d.BK_Group
	, ShortName			= d.ShortName
	
	
FROM All_Checks AC
LEFT JOIN bld.vw_Dataset	D ON AC.BK_Dataset	= D.BK

WHERE 1=1
AND ac.CheckMessage IS NOT null
GO


