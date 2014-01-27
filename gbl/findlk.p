/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Найти информацию обо всех пользователях, захвативших запись

Автор: Белоусов Илья Александрович
Дата создания: 07/16/07
Author: Ilia Belousov
Creation date: 07/16/07

Автор1: Перваков Михаил Сергеевич
Дата создания: 03/01/06

*/

{ gbl/findlock.i }
define input  parameter p-recid     as integer   no-undo .
define output parameter table for temp-lock .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Найти информацию обо всех пользователях, захвативших запись".
{ cmp/vssrevis.i }

define variable v-ind as integer no-undo .

do
on error undo, return error return-value
:
  for each _userlock no-lock
    where _userlock._userlock-usr <> ?
  :
    do v-ind = 1 to extent(_userlock._userlock-recid)
    :
      if _userlock._userlock-recid[v-ind] = p-recid
      then do:
        create temp-lock .
        assign
          temp-lock.lock-conn-id = _userlock._userlock-usr
          temp-lock.user-name = _userlock._userlock-name
          temp-lock.lock-flag = _userlock._userlock-flags[v-ind]
        .
      end.
    end.
  end.
end.