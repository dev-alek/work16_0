/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Очистка накладных.

Автор: Морозов Алекасандр Сергеевич
Дата создания: 24/12/15
Author: Alexand Morozov
Creation date: 24/12/15

*/


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Очистка накладных.".
{ cmp/vssrevis.i }

{ gbl/waitfram.i }

define variable v-log as logical no-undo.
define variable i     as integer no-undo.


do :
  i = 0.
  run waitfram-show in this-procedure ( "ЖДИТЕ...") .
  for each ub.clob-bind exclusive-lock where field-name_ begins 'egais'.
    delete ub.clob-bind.
  end.
  run waitfram-hide in this-procedure .
  message "Готово." view-as alert-box.
end.
