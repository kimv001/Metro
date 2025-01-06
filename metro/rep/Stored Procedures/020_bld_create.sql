
CREATE PROCEDURE [rep].[020_bld_create] @tgt_table_name varchar(255) = NULL AS /*
Developed by:			metro
Description:			create all bld tables, views and procedures based on defined [bld].[tr_%] views

example:

exec [rep].[020_bld_create] @tgt_table_name = 'Attribute'
Change log:
Date					Author				Description
20220916 20:15			K. Vermeij			Initial version
*/ --exec [rep].[Helper_RefreshMetroViews]
EXEC [rep].[021_bld_recreate_buildtables] @tgt_table_name EXEC [rep].[022_bld_recreate_currentviews] @tgt_table_name -- refresh views
EXEC [rep].[helper_refreshmetroviews] EXEC [rep].[023_bld_recreate_loadprocs]
