/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Утилита выравнивания остатков по товарам на оcнове партий свободной зоны

Автор: Чернова Светлана Александровна
Дата создания: 01/17/08
Author: Svetlana Chernova
Creation date: 01/17/08

*/

define input  parameter parparentproc as widget-handle no-undo .
define input  parameter p-install     as logical no-undo init no .


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Утилита выравнивания остатков по товарам на оcнове партий свободной зоны".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ gbl/getcntxt.i def }
{ cmp/r-page1.i  new }
{ gbl/waitfram.i }
{ gbl/getcntxt.i get }

  for each gds-list :
      delete  gds-list.
  end.

  run str/gds-list.w ( input parparentproc, input v-cntxt-host-code-obj, input v-cntxt-obj-type, input v-cntxt-obj-code ).

  for each gds-list :
    run waitfram-show in this-procedure  ( substitute("Обработка товара  &1" ,gds-list.gds-name )  )  .
    for each ub.gds-obj no-lock where
             ub.gds-obj.artic = gds-list.artic and
             ub.gds-obj.prod-type = gds-list.prod-type and
             ub.gds-obj.prod-code = gds-list.prod-code
             :
              run utl/par2gds.p (
                  input gds-list.artic,
                  input gds-list.prod-type,
                  input gds-list.prod-code,
                  input ub.gds-obj.obj-type,
                  input ub.gds-obj.obj-code
                  ) .
    end.
  end.

  run waitfram-hide in this-procedure.

message 'все' view-as alert-box information .
