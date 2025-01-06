

CREATE view [adf].[vw_SDTAP] as 


select 
	  BK_RepositoryStatus	= BK 
	, RepositoryStatus		= rt.[Name]
	, Environment			= rt.[Name]
	, RepositoryStatusCode	= case when isnumeric(rt.Code)=1 then  cast(rt.Code as int) else 0 end
	from bld.vw_RefType rt
where 1=1
and RefType = 'RepositoryStatus'