/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Определить текущее подключение

Автор: Перваков Михаил Сергеевич
Дата создания: 07/20/05
Author: Mikhail Pervakov
Creation date: 07/20/05

*/

define output parameter p-connect-usr    as integer   no-undo .
define output parameter p-connect-device as character no-undo .
define output parameter p-userio-id      as integer   no-undo .


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Определить текущее подключение".
{ cmp/vssrevis.i }

do
on error undo, return error return-value
:
  find first ub._myconnection no-lock .
  find first ub._connect no-lock
    where ub._Connect._Connect-Usr = ub._myconnection._myconn-userid
    .
  find first ub._userio no-lock
    where ub._userio._userio-usr = ub._myconnection._myconn-userid
    .

  assign
    p-connect-usr    = ub._Connect._Connect-Usr
    p-connect-device = ub._Connect._Connect-Device
    p-userio-id      = _userio._userio-id
  .

end.