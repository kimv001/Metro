



CREATE view [adf].[vw_Markers] as
SELECT 

	*

	
  FROM bld.vw_Markers src
  Cross join [adf].[vw_SDTAP]  env