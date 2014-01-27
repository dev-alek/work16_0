/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Показать изображение клиента

Автор: Бахтадзе Наталья Викторовна
Дата создания: 04/10/06
Author: Bakhtadze Natalya
Creation date: 04/10/06

*/

define input parameter parparentproc  as widget-handle no-undo.

define parameter buffer b-clients for ub.clients .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Показать изображение клиента".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/ini-lib.i  }
{ cmp/library.i  }
{ gbl/getcntxt.i def }

define variable loc#log as logical no-undo.
define variable v-can-edit as logical no-undo .
define variable v-long-obj-code as integer no-undo .

{ gbl/getcntxt.i get }

case b-clients.obj-type
:
  when {&cmp}
  then do:
    { gbl/chk-actg.i
      v-cntxt-db-num
      v-cntxt-userid
      {&action-head-code-main}
      'actn_client-reference_add-del':U
      {&cntxt-global}
      0
      '':U
      0
      0
      0
      0
      true
      v-can-edit
    }
  end.
  when {&prs}
  then do:
    { gbl/chk-actg.i
      v-cntxt-db-num
      v-cntxt-userid
      {&action-head-code-main}
      'actn_client-reference-prs_add-del':U
      {&cntxt-global}
      0
      '':U
      0
      0
      0
      0
      true
      v-can-edit
    }
  end.
  otherwise do:
    message
      vss-workfile vss-revision vss-description skip
      "Неизестное значение типа клиента" skip
      "Тип клиента" b-clients.obj-type skip
      "Код клиента" b-clients.obj-code skip
      view-as alert-box error .
    return.
  end.
end case.
assign
  v-long-obj-code = (if b-clients.obj-type = {&cmp}
                     then exp(10, 9)
                     else 0
                    )
                  + b-clients.obj-code
.

{ ref/viewpict.i cli\ b-clients.obj-code v-can-edit }