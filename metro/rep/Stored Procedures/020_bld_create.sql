
CREATE procedure [rep].[020_bld_create]  @tgt_table_name VARCHAR(255) =null  as 
/*
Developed by:			metro
Description:			create all bld tables, views and procedures based on defined [bld].[tr_%] views


example:

exec [rep].[020_bld_create] @tgt_table_name = 'Attribute'
Change log:
Date					Author				Description
20220916 20:15			K. Vermeij			Initial version
*/



--exec [rep].[Helper_RefreshMetroViews]
exec [rep].[021_bld_Recreate_BuildTables]  @tgt_table_name 
exec [rep].[022_bld_Recreate_CurrentViews] @tgt_table_name

-- refresh views
exec [rep].[Helper_RefreshMetroViews]

exec [rep].[023_bld_Recreate_LoadProcs]