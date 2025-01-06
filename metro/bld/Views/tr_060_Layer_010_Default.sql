﻿
CREATE VIEW [bld].[tr_060_layer_010_default] AS
SELECT bk,

       code,

       layer_name = l.[name],

       layer_desciption = isnull(l.[description], '<no description available ...>'),

       isdwhhelper = l.isdwhhelper,

       isrep = l.isrep,

       isaudit = l.isaudit,

       issrc = l.issrc,

       isdwh = l.isdwh,

       istgt = l.istgt,

       layer_process_order = l.layerorder

  FROM rep.vw_layer l