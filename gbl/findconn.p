/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Возвращает информацию о подключении

Автор: Белоусов Илья Александрович
Дата создания: 07/16/07
Author: Ilia Belousov
Creation date: 07/16/07

Автор1: Перваков Михаил Сергеевич
Дата создания: 03/01/06

*/

define input  parameter p-conn-id        as integer   no-undo .
define output parameter p-connect-type   as character no-undo .
define output parameter p-connect-time   as character no-undo .
define output parameter p-connect-device as character no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Возвращает информацию о подключении".
{ cmp/vssrevis.i }

do
on error undo, return error return-value
:
  find first _Connect no-lock
    where _Connect._Connect-Usr = p-conn-id
    no-error .
  if available _Connect
  then do:
    assign
      p-connect-type   = _Connect._Connect-Type
      p-connect-time   = _Connect._Connect-Time
      p-connect-device = _Connect._Connect-Device
    .
  end.
end.