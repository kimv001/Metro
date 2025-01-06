





CREATE view [bld].[tr_025_Contact_010_Default] as
/* 
=== Comments =========================================

Description:
	 List of Contact Persons
	
Changelog:
Date		time		Author					Description
20241004	1603		K. Vermeij				Initial
=======================================================
*/
with ContactRoles as (
select [BK]
      ,[Code]
      ,[Name]
     
      ,[Description]
      ,[RefType]
      ,[RefTypeAbbr]
      ,[SortOrder]
from [rep].[vw_RefType]
where [RefTypeAbbr] = 'CR'


)
, final as (
select 
	src.bk
	, src.code
	, src.bk_contactgroup
	, contactgroup						= cg.[name]
	, contactrole						= cr.[name]
	, main_contact						= src.main_contact
	, alert_contact						= src.alert_contact
	, contactperson_name				= cp.[contact_name]
	, contactperson_department			= cp.[contact_department]
	, contacperson_phonenumber			= cp.[contact_phone_number]
	, contactperson_mailadress			= cp.[contact_mail_address]
	, contactperson_active				= cp.[Active]
	, rn_contact						= row_number() over (partition by src.bk order by src.bk asc)
	-- select *
from [rep].[vw_Contact] src
join rep.vw_contactgroup cg on src.bk_contactgroup = cg.bk
left join [rep].[vw_ContactPerson] cp on src.bk_contactperson = cp.bk
left join ContactRoles cr on src.bk_contactrole = cr.bk
Where 1=1
  and isnull( src.Active,'1')=1
  and src.bk is not null
  )
  select * from final where rn_contact = 1