/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отметить систему прав, как требующую инициализации

Автор: Белоусов Илья Александрович
Дата создания: 05/08/07
Author: Ilia Belousov
Creation date: 05/08/07

Автор1: Перваков Михаил Сергеевич
Дата создания: 05/16/06


*/

define input  parameter p-action-head-code as integer   no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отметить систему прав, как требующую инициализации".
{ cmp/vssrevis.i }

define buffer buf_action-head for ub.action-head .

do
on error undo, return error return-value
:
  find first buf_action-head exclusive-lock
    where buf_action-head.action-head-code = p-action-head-code
    no-error .
  if available buf_action-head
  then do:
    assign
      buf_action-head.action-head-control-number = ""
    .
  end.
end.