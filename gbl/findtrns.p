/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Возвращает информацию о транзакции

Автор: Белоусов Илья Александрович
Дата создания: 07/16/07
Author: Ilia Belousov
Creation date: 07/16/07

Автор1: Перваков Михаил Сергеевич
Дата создания: 03/01/06

*/

define input  parameter p-conn-id      as integer   no-undo .
define output parameter p-trans-id     as integer   no-undo .
define output parameter p-trans-txtime as character no-undo .
define output parameter p-trans-state  as character no-undo .
define output parameter p-trans-dur    as integer   no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Возвращает информацию о транзакции".
{ cmp/vssrevis.i }

do
on error undo, return error return-value
:
  find first _Trans
    where _Trans._Trans-Usrnum = p-conn-id
    no-error .
  if available _Trans
  then do:
    assign
      p-trans-id     = _Trans._Trans-Id
      p-trans-txtime = _Trans._Trans-txtime
      p-trans-state  = _Trans._Trans-State
      p-trans-dur    = _Trans._Trans-Duration
    .
  end.
end.