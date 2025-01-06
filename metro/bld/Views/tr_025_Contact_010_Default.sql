
CREATE VIEW [bld].[tr_025_contact_010_default] AS /*
=== Comments =========================================

Description:
	 List of Contact Persons

Changelog:
Date		time		Author					Description
20241004	1603		K. Vermeij				Initial
=======================================================
*/ WITH contactroles AS

        (SELECT [bk] ,

               [code] ,

               [name] ,

               [description] ,

               [reftype] ,

               [reftypeabbr] ,

               [sortorder]

          FROM [rep].[vw_reftype]

         WHERE [reftypeabbr] = 'CR'
       ),

       FINAL AS

        (SELECT src.bk ,

               src.code ,

               src.bk_contactgroup ,

               contactgroup = cg.[name] ,

               contactrole = cr.[name] ,

               main_contact = src.main_contact ,

               alert_contact = src.alert_contact ,

               contactperson_name = cp.[contact_name] ,

               contactperson_department = cp.[contact_department] ,

               contacperson_phonenumber = cp.[contact_phone_number] ,

               contactperson_mailadress = cp.[contact_mail_address] ,

               contactperson_active = cp.[active] ,

               rn_contact = row_number() OVER (PARTITION BY src.bk
                                          ORDER BY src.bk ASC) -- select *

          FROM [rep].[vw_contact] src

          JOIN rep.vw_contactgroup cg
            ON src.bk_contactgroup = cg.bk

          LEFT JOIN [rep].[vw_contactperson] cp
            ON src.bk_contactperson = cp.bk

          LEFT JOIN contactroles cr
            ON src.bk_contactrole = cr.bk

         WHERE 1 = 1

           AND isnull(src.active, '1') = 1

           AND src.bk IS NOT NULL
       )
SELECT *

  FROM FINAL

 WHERE rn_contact = 1
