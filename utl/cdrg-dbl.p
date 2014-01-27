/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Генерация списка БД где есть code-range

Автор: Уханов Дмитрий Юрьевич
Дата создания: 03/22/04
Author: Dmitry Ukhanov
Creation date: 03/22/04

*/

define input  parameter p-action       as character no-undo .
define input  parameter p-uniq-key-rec as character no-undo .
define output parameter p-list-db      as character no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Генерация списка БД где есть code-range".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }

do
on error undo, return error
:
  define buffer buf_db for ub.db .

  assign
    p-list-db = "":U .
  .
  for each buf_db no-lock
    where buf_db.db-num >= 0
  on error undo, return error
  :
    if p-list-db = "":U then do:
      assign
        p-list-db = string( buf_db.db-num ).
      .
    end.
    else do:
      assign
        p-list-db = p-list-db + {&comma-char} + string( buf_db.db-num ).
      .
    end.
  end.

end.

return.

/* $Workfile$ end */