




CREATE view [bld].[tr_700_BuildCheck_010_dataset] as
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


With ErrorCodes as (
	select Severity, Code, Error from 
			(values 
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

					)  list (Severity, Code, Error)

)
, All_Checks as (
select
	  BK_Dataset		= a.bk_dataset
	, Code				= a.code
	--, DatasetName		= d.DatasetName
	, CheckMessage		= 'Dataset has no BusinessKey defined' -- U1
	--, BK_Schema			= s.bk
	--, BK_Group			= d.BK_Group

	
from bld.vw_Attribute		a
left join bld.vw_Dataset	d on a.bk_dataset	= d.bk
--left join rep.vw_Schema		s on d.bk_schema	= s.bk
where 1=1
and d.BK_Layer = 'src'
group by a.bk_dataset, a.code
having sum(isnull(cast(a.businesskey as int),0)) = 0

UNION ALL

select 
	 BK_Dataset		= d.bk
	, Code				= d.code
	, CheckMessage		= '%File Dataset has no (valid) fileproperties defined' -- U2


from bld.vw_Dataset D
left join bld.vw_FileProperties fp on fp.Code = D.code

where 1=1
and (
		d.ObjectType like '%file' 

	)
group by d.bk, d.code
having count(isnull(fp.code,0)) =0

UNION ALL

select 
	d.bk, d.code
	, CheckMessage		= 'Dataset has no atrributes defined' -- U5
	
from bld.vw_Dataset D
left join bld.vw_attribute a on A.BK_Dataset = D.bk

where 1=1

and (
		d.SchemaName = 'src_file' 
		OR
		d.prefix= 'trv'
	)

group by d.bk, d.code
having count(isnull(a.BK_Dataset,0)) =0

UNION ALL

select 
	d.bk, d.code
	, CheckMessage		= 'Dataset has attributes with the same ordinal position defined' -- U6
	
from bld.vw_Dataset D
left join bld.vw_attribute a on A.BK_Dataset = D.bk

where 1=1
--and d.Active = 1
and (
		d.SchemaName = 'src_file' 
		OR
		d.prefix = 'trv'
	)

group by d.bk, d.code, a.OrdinalPosition
having count (a.OrdinalPosition)>1


UNION ALL

select 
	d.bk, d.code
	, CheckMessage				= case 
										when a.datatype in ('numeric', 'decimal') and a.scale = 0 then a.AttributeName + ' : Scale is set to 0, consider a (big)integer'   -- W1
									end 	

from bld.vw_Dataset D
left join bld.vw_attribute a on A.BK_Dataset = D.bk

where 1=1

and (
		d.SchemaName = 'src_file' 
		OR
		d.prefix = 'trv'
	)

UNION ALL

select 
	d.bk, d.code
	, CheckMessage				= case 
										when ISNULL(a.datatype,'') = ''		THEN a.AttributeName + ' :DataType not defined'	-- U7
										when a.datatype in ('char', 'varchar', 'nchar', 'nvarchar') and ISNULL(a.MaximumLength, 0) = 0 then a.AttributeName + ' :Datatype Length is nog defined'  -- U8
										when a.datatype in ('numeric', 'decimal') and ( ISNULL(a.scale, -1) = -1 OR ISNULL(a.Precision, -1) = -1) then a.AttributeName + ' :Datatype Scale and/or Precesion is not set correct'  -- U9
									end 	
	
from bld.vw_Dataset D
left join bld.vw_attribute a on A.BK_Dataset = D.bk

where 1=1

and (
		d.SchemaName = 'src_file' 
		OR
		d.prefix = 'trv'
	)
)
select 
	  BK				= AC.BK_Dataset + AC.CheckMessage
	, Code				= AC.Code
	, CheckMessage		= AC.CheckMessage
	, LayerName			= d.LayerName
	, SchemaName		= d.SchemaName
	, GroupName			= d.BK_Group
	, ShortName			= d.ShortName
	
	
from All_Checks AC
left join bld.vw_Dataset	D on AC.BK_Dataset	= D.BK

WHERE 1=1
and ac.CheckMessage is not null