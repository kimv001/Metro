CREATE  view [bld].[tr_060_Layer_010_Default] as 

select 
	bk, 
	code,
	Layer_Name				= l.[name],
	Layer_Desciption		= isnull(l.[Description],'<no description available ...>'),
	
	isDWHhelper				= l.isDWHhelper,
	isRep					= l.isRep,
	isAudit					= l.isAudit,

	isSRC					= l.isSRC,
	isDWH					= l.isDWH,
	isTGT					= l.isTGT,
	
	
	Layer_Process_Order		= l.LayerOrder
	
from rep.vw_Layer l