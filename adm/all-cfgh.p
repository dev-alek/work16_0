/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Подготовка к показу истории по всем конфигурационным параметрам

Автор: Уханов Дмитрий Юрьевич
Дата создания: 12/02/05
Author: Dmitry Ukhanov
Creation date: 12/02/05

*/
define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Подготовка к показу истории по всем конфигурационным параметрам".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }

{ adm/cnf-inc.i &new = "new" }

do
on error  undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( error-status :num-messages ) )
on stop   undo, return error substitute( "&1. stop", vss-workfile )
on endkey undo, return error substitute( "&1. endkey", vss-workfile )
:
  run adm/cfg-hist.w
    ( input parparentproc
     ,buffer cnf
    )
  .
  return.
end.

/* $Workfile$ e n d */