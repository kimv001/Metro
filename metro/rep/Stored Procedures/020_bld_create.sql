
CREATE PROCEDURE [rep].[020_bld_create]  @tgt_table_name VARCHAR(255) =null  AS 
/*
Developed by:			metro
Description:
    This stored procedure creates all build (bld) tables, views, and procedures based on defined [bld].[tr_%] views.

Parameters:
    @tgt_table_name VARCHAR(255) = null  -- Target table name to filter the creation process. If null, all tables, views, and procedures will be created.

Example Usage:
    exec [rep].[020_bld_create] @tgt_table_name = 'Attribute'

Procedure Logic:
    1. Calls the stored procedure [rep].[021_bld_Recreate_BuildTables] to create build tables based on the target table name.
    2. Calls the stored procedure [rep].[022_bld_Recreate_CurrentViews] to create current views based on the target table name.
    3. Refreshes all Metro views by calling the stored procedure [rep].[Helper_RefreshMetroViews].
    4. Calls the stored procedure [rep].[023_bld_Recreate_LoadProcs] to recreate load procedures.

Change log:
Date					Author				Description
20220916 20:15			K. Vermeij			Initial version
*/



--exec [rep].[Helper_RefreshMetroViews]
EXEC [rep].[021_bld_Recreate_BuildTables]  @tgt_table_name 
EXEC [rep].[022_bld_Recreate_CurrentViews] @tgt_table_name

-- refresh views
EXEC [rep].[Helper_RefreshMetroViews]

EXEC [rep].[023_bld_Recreate_LoadProcs]