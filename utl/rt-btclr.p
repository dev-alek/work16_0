/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Очистка Batchprocess от данных радиотерминала

Автор: Хныкин Павел Андреевич
Дата создания: 05/23/08
Author: Pavel Khnykin
Creation date: 05/23/08

*/
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Очистка Batchprocess от данных радиотерминала".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }


define buffer buf_batchprocess for ub.batchprocess.

define variable v-log as logical   no-undo .

do
on error undo, return error return-value
:
  message
    "Очистка списков редактируемых документов, строк документов на РТ, список ценников на печать." skip
    "Вы хотите удалить все временные привязки ?"
  view-as alert-box question buttons yes-no update v-log.

  if v-log = yes
  then do:
    for each buf_batchprocess exclusive-lock
      where buf_batchprocess.BP_type  = {&btpr-type-rt-doc}
        or buf_batchprocess.BP_type   = {&btpr-type-rt-line}
        or buf_batchprocess.BP_type   = {&btpr-type-rt-bcprint}
    :
      delete buf_batchprocess.
    end.

  end.

  message
    "Списки удалены."
  view-as alert-box information.

end.