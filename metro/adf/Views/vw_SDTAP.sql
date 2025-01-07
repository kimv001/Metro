

CREATE VIEW [adf].[vw_SDTAP] AS 


SELECT 
	  BK_RepositoryStatus	= BK 
	, RepositoryStatus		= rt.[Name]
	, Environment			= rt.[Name]
	, RepositoryStatusCode	= CASE WHEN isnumeric(rt.Code)=1 THEN  CAST(rt.Code AS int) ELSE 0 END
	FROM bld.vw_RefType rt
WHERE 1=1
AND RefType = 'RepositoryStatus'