
CREATE VIEW [bld].[tr_300_testrules_010_datasets] AS /*
=== Comments =========================================

Description:
	builds up a test rules definition set

Changelog:
Date		time		Author					Description
20230907	0012		K. Vermeij				Initial
20231031	1521		K.Siva				    Added new columns to the get_datasets,get_schemas,get_datasources
=======================================================
*/  WITH all_testrules AS

        (SELECT bk_testdefinition = td.bk ,

               code = td.code ,

               test = td.test ,

               adfpipeline = td.adfpipeline ,

               getattributes = td.getattributes ,

               bk_reftype_objecttype_target = tr.bk_reftype_objecttype_target ,

               bk_datasource = tr.bk_datasource ,

               bk_schema = tr.bk_schema ,

               bk_dataset = coalesce(tr.bk_datasetsrc, tr.bk_datasettrn) ,

               bk_datasetsrcattribute = tr.bk_datasetsrcattribute ,

               expectedvalue = coalesce(tr.expectedvalue, '') ,

               tresholdvalue = coalesce(tr.tresholdvalue, '') ,

               tr.active ,

               tr.bk_reftype_repositorystatus

          FROM rep.vw_testdefinition td

          JOIN rep.vw_testrule tr
            ON tr.bk_testdefinition = td.bk
       ) ,

       get_datasets AS

        (SELECT bk = concat(src.bk_testdefinition, '|dataset|', d.bk, '|' + isnull(a.attributename, '')) ,

               src.test ,

               src.adfpipeline ,

               src.bk_reftype_repositorystatus ,

               src.getattributes ,

               bk_dataset = d.bk ,

               objecttype = src.bk_reftype_objecttype_target ,

               specificattribute = sa.attributename ,

               attributename = isnull(a.attributename, '') ,

               src.expectedvalue ,

               src.tresholdvalue

          FROM all_testrules src

          JOIN bld.vw_dataset d
            ON src.bk_dataset = d.bk

           AND src.bk_reftype_objecttype_target = d.bk_reftype_objecttype

           AND src.bk_schema = d.bk_schema

          LEFT JOIN bld.vw_attribute a
            ON src.getattributes = 1

           AND a.bk_dataset = d.bk

          LEFT JOIN bld.vw_attribute sa
            ON src.bk_datasetsrcattribute = sa.bk
       ) ,

       get_schemas AS

        (SELECT bk = concat(src.bk_testdefinition, '|schema|', d.bk, '|' + isnull(a.attributename, '')) ,

               src.test ,

               src.adfpipeline ,

               src.bk_reftype_repositorystatus ,

               src.getattributes ,

               bk_dataset = d.bk ,

               objecttype = src.bk_reftype_objecttype_target ,

               specificattribute = sa.attributename ,

               attributename = isnull(a.attributename, '') ,

               src.expectedvalue ,

               src.tresholdvalue

          FROM all_testrules src

          JOIN bld.vw_dataset d
            ON d.bk_schema = src.bk_schema

           AND src.bk_dataset IS NULL

           AND src.bk_reftype_objecttype_target = d.bk_reftype_objecttype

          LEFT JOIN bld.vw_attribute a
            ON src.getattributes = 1

           AND a.bk_dataset = d.bk

          LEFT JOIN bld.vw_attribute sa
            ON src.bk_datasetsrcattribute = sa.bk

          LEFT JOIN get_datasets gd
            ON d.bk = gd.bk_dataset

           AND gd.test = src.test

         WHERE gd.bk IS NULL
       ),

       get_datasources AS

        (SELECT bk = concat(src.bk_testdefinition, '|source|', d.bk, '|' + isnull(a.attributename, '')) ,

               src.test ,

               src.adfpipeline ,

               src.bk_reftype_repositorystatus ,

               src.getattributes ,

               bk_dataset = d.bk ,

               objecttype = src.bk_reftype_objecttype_target ,

               specificattribute = sa.attributename ,

               attributename = isnull(a.attributename, '') ,

               src.expectedvalue ,

               src.tresholdvalue

          FROM all_testrules src

          JOIN bld.vw_dataset d
            ON d.bk_datasource = src.bk_datasource

           AND src.bk_dataset IS NULL

           AND src.bk_reftype_objecttype_target = d.bk_reftype_objecttype

          LEFT JOIN bld.vw_attribute a
            ON src.getattributes = 1

           AND a.bk_dataset = d.bk

          LEFT JOIN bld.vw_attribute sa
            ON src.bk_datasetsrcattribute = sa.bk

          LEFT JOIN get_datasets gd
            ON d.bk = gd.bk_dataset

           AND gd.test = src.test

          LEFT JOIN get_schemas gs
            ON d.bk = gs.bk_dataset

           AND gs.test = src.test

         WHERE gd.bk IS NULL

           AND gs.bk IS NULL
       ),

       all_datasets AS

        (SELECT *

          FROM get_datasets

     UNION ALL SELECT *

          FROM get_schemas

     UNION ALL SELECT *

          FROM get_datasources
       ) ,

       FINAL AS (
SELECT bk = src.bk ,

       bk_dataset = src.bk_dataset ,

       bk_reftype_repositorystatus = src.bk_reftype_repositorystatus ,

       testdefintion = src.test ,

       adfpipeline = src.adfpipeline ,

       getattributes = coalesce(src.getattributes, '') ,

       tresholdvalue = src.tresholdvalue ,

       specificattribute = coalesce(src.specificattribute, '') ,

       attributename = src.attributename ,

       expectedvalue = concat(fp.filesystem,

       '\', fp.folder,'\', fp.FileMask)
from all_datasets src
join bld.vw_FileProperties fp		on fp.bk=  src.BK_Dataset
where src.test  = 'FILE NOT FOUND'

union all									

select 
	  BK							= src.bk
	, BK_Dataset					= src.BK_Dataset
	, BK_RefType_RepositoryStatus	= src.BK_RefType_RepositoryStatus
	, TestDefintion					= src.Test
	, ADFPipeline					= src.ADFPipeline
	, GetAttributes					= coalesce(src.GetAttributes,'')
	, TresholdValue					= src.TresholdValue
	, SpecificAttribute				= coalesce(src.SpecificAttribute,'')
	, AttributeName					= src.AttributeName
	, ExpectedValue					= coalesce(fp.ExpectedFileSize, src.ExpectedValue, '0')
from all_datasets src
join bld.vw_FileProperties fp		on fp.bk=  src.BK_Dataset
where src.test  = 'FILE SIZE LESS'

union all									

select 
	  BK							= src.bk
	, BK_Dataset					= src.BK_Dataset
	, BK_RefType_RepositoryStatus	= src.BK_RefType_RepositoryStatus
	, TestDefintion					= src.Test
	, ADFPipeline					= src.ADFPipeline
	, GetAttributes					= coalesce(src.GetAttributes,'')
	, TresholdValue					= src.TresholdValue
	, SpecificAttribute				= coalesce(src.SpecificAttribute,'')
	, AttributeName					= src.AttributeName
	, ExpectedValue					= coalesce(src.ExpectedValue,src.SpecificAttribute,'')
from all_datasets src
where src.test  = 'Date mismatch IN FILE'

union all									

select 
	  BK							= src.bk
	, BK_Dataset					= src.BK_Dataset
	, BK_RefType_RepositoryStatus	= src.BK_RefType_RepositoryStatus
	, TestDefintion					= src.Test
	, ADFPipeline					= src.ADFPipeline
	, GetAttributes					= coalesce(src.GetAttributes,'')
	, TresholdValue					= src.TresholdValue
	, SpecificAttribute				= coalesce(src.SpecificAttribute,'')
	, AttributeName					= src.AttributeName
	, ExpectedValue					= coalesce(src.ExpectedValue,'')
from all_datasets src
where src.test  = 'COLUMN mismatch 1st'

)
select Code=bk, * from final
where 1=1
--and bk_dataset = 'sa_dwh | src_file || billing | carecontracts | '
--and BK_Dataset = 'sa_dwh | src_file || grafana | lwap | '
