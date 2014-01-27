/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Утилита проверки/инициализации параметров при запуске ТН

Автор: Уханов Дмитрий Юрьевич
Дата создания: 02/11/10
Author: Dmitry Ukhanov
Creation date: 02/11/10

*/

define input parameter p-forced as logical no-undo .
define input parameter p-read-only as logical no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Утилита проверки/инициализации параметров при запуске ТН".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }

do
on error  undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( 1 ) )
on stop   undo, return error substitute( "&1. stop", vss-workfile )
on endkey undo, return error substitute( "&1. endkey", vss-workfile )
:
  define buffer buf_sys-ctrl for ub.sys-ctrl .

  do transaction
  on error  undo, return error substitute( "&1 (sys-key). &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
  on stop   undo, return error substitute( "&1 (sys-key). stop", vss-workfile )
  on endkey undo, return error substitute( "&1 (sys-key). endkey", vss-workfile )
  :
    find first buf_sys-ctrl exclusive-lock
      no-wait
      no-error
    .
    if locked buf_sys-ctrl then do:
      undo, return error substitute( "Уже начат процесс инициализации ПАРАМЕТРОВ другим пользователем.&1Дождитесь завершения и повторите попытку запуска.", {&new-line} ).
    end.
    find first buf_sys-ctrl share-lock .
  end.


end.