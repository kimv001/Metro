﻿create view rep.vw_RefType as
/*
View is generated by  : metro
Generated at          : 2023-02-15 05:30:46
Description           : View on stage table
*/

Select 
	-- List of columns:
	Cast([BK] as varchar(255)) as [BK],Cast([Code] as varchar(255)) as [Code],Cast([Name] as varchar(255)) as [Name],Cast([Description] as varchar(255)) as [Description],Cast([RefType] as varchar(255)) as [RefType],Cast([RefTypeAbbr] as varchar(255)) as [RefTypeAbbr],Cast([SortOrder] as varchar(255)) as [SortOrder],Cast([LinkedReftype] as varchar(255)) as [LinkedReftype],Cast([BK_LinkedRefType] as varchar(255)) as [BK_LinkedRefType],Cast([Active] as varchar(255)) as [Active]
	
	-- Meta data columns:
	, mta_RowNum     = Row_Number() Over (Order By [BK] asc)
	, mta_BK         = Upper(Isnull(Ltrim(Rtrim(Cast([BK] as varchar(500)))),'-'))
	, mta_BKH        = Convert(char(64),(hashbytes('sha2_512',
								Upper(Isnull(Ltrim(Rtrim(Cast([BK] as varchar(500)))),'-'))
							)),2)
	, mta_RH         = Convert(char(64),(Hashbytes('sha2_512',upper(
								isnull(ltrim(rtrim(cast([BK]as varchar(255))	)),'-')+'|'+isnull(ltrim(rtrim(cast([Code]as varchar(255))	)),'-')+'|'+isnull(ltrim(rtrim(cast([Name]as varchar(255))	)),'-')+'|'+isnull(ltrim(rtrim(cast([Description]as varchar(255))	)),'-')+'|'+isnull(ltrim(rtrim(cast([RefType]as varchar(255))	)),'-')+'|'+isnull(ltrim(rtrim(cast([RefTypeAbbr]as varchar(255))	)),'-')+'|'+isnull(ltrim(rtrim(cast([SortOrder]as varchar(255))	)),'-')+'|'+isnull(ltrim(rtrim(cast([LinkedReftype]as varchar(255))	)),'-')+'|'+isnull(ltrim(rtrim(cast([BK_LinkedRefType]as varchar(255))	)),'-')+'|'+isnull(ltrim(rtrim(cast([Active]as varchar(255))	)),'-')
							))),2)	
	, mta_Source     = mta_Source
	, mta_Loaddate   = Cast(mta_LoadDate as datetime2)
From rep.[RefType]
Where 1=1
	and isnull(Active,'1') = '1' 
	and isnull([BK],'') != ''	;