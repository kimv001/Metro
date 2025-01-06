
CREATE VIEW [bld].[tr_010_reftype_010_default] AS /*
=== Comments =========================================

Description:
	All Defined RefTypes

Changelog:
Date		time		Author					Description
20220804	0000		K. Vermeij				Initial
20230326	1315		K. Vermeij				Added [isDefault]
=======================================================
*/
SELECT rt.bk ,

       rt.code ,

       rt.[name] ,

       rt.[description] ,

       rt.reftype ,

       rt.reftypeabbr ,

       rt.sortorder ,

       rt.linkedreftype ,

       rt.bk_linkedreftype ,

       linkedreftypecode = rtp.[code] ,

       linkedreftypename = rtp.[name] ,

       linkedreftypedecription = rtp.[description] ,

       defaultvalue = CASE
                          WHEN rt.reftype = 'DataType' THEN rt.[default]

            ELSE NULL

             END ,

       isdefault = CASE
                                      WHEN rt.reftype = 'DataType' THEN NULL

            ELSE rt.[default]

             END

  FROM rep.vw_reftype rt

  LEFT JOIN rep.vw_reftype rtp
    ON rt.linkedreftype = rtp.reftypeabbr

   AND rt.bk_linkedreftype = rtp.bk

 WHERE 1 = 1

   AND isnull(rt.active, '1') = 1

   AND rt.bk IS NOT NULL -- and (rt.BK = 'DST|SQL_SYN|' or rt.BK = 'SL|SQLSYN|')
