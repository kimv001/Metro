﻿create view rep.vw_DataTypeMapping as
/*
View is generated by  : metro
Generated at          : 2023-02-15 05:30:46
Description           : View on stage table
*/

Select 
	-- List of columns:
	Cast([BK] as varchar(255)) as [BK],Cast([Code] as varchar(255)) as [Code],Cast([Name] as varchar(255)) as [Name],Cast([Description] as varchar(255)) as [Description],Cast([BK_RefType_DataType] as varchar(255)) as [BK_RefType_DataType],Cast([DataTypeByDataSource] as varchar(255)) as [DataTypeByDataSource],Cast([BK_RefType_DST] as varchar(255)) as [BK_RefType_DST],Cast([Active] as varchar(255)) as [Active],Cast([IsSystem] as varchar(255)) as [IsSystem]
	
	-- Meta data columns:
	, mta_RowNum     = Row_Number() Over (Order By [BK] asc)
	, mta_BK         = Upper(Isnull(Ltrim(Rtrim(Cast([BK] as varchar(500)))),'-'))
	, mta_BKH        = Convert(char(64),(hashbytes('sha2_512',
								Upper(Isnull(Ltrim(Rtrim(Cast([BK] as varchar(500)))),'-'))
							)),2)
	, mta_RH         = Convert(char(64),(Hashbytes('sha2_512',upper(
								isnull(ltrim(rtrim(cast([BK]as varchar(255))	)),'-')+'|'+isnull(ltrim(rtrim(cast([Code]as varchar(255))	)),'-')+'|'+isnull(ltrim(rtrim(cast([Name]as varchar(255))	)),'-')+'|'+isnull(ltrim(rtrim(cast([Description]as varchar(255))	)),'-')+'|'+isnull(ltrim(rtrim(cast([BK_RefType_DataType]as varchar(255))	)),'-')+'|'+isnull(ltrim(rtrim(cast([DataTypeByDataSource]as varchar(255))	)),'-')+'|'+isnull(ltrim(rtrim(cast([BK_RefType_DST]as varchar(255))	)),'-')+'|'+isnull(ltrim(rtrim(cast([Active]as varchar(255))	)),'-')+'|'+isnull(ltrim(rtrim(cast([IsSystem]as varchar(255))	)),'-')
							))),2)	
	, mta_Source     = mta_Source
	, mta_Loaddate   = Cast(mta_LoadDate as datetime2)
From rep.[DataTypeMapping]
Where 1=1
	and isnull(Active,'1') = '1' 
	and isnull([BK],'') != ''	;