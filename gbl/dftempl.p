/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Возвращает адрес записи таблицы template

Автор: Перваков Михаил Сергеевич
Дата создания: 02/20/02
Author: Mikhail Pervakov
Creation date: 02/20/02

*/


define input  parameter p-table-name     as character no-undo .
define output parameter p-template-recid as recid     no-undo .

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Возвращает адрес записи таблицы template".
{ cmp/vssrevis.i "substitute('&1|&2':u,p-table-name,p-template-recid)" }

do
on error undo, return error return-value
:
  find first _File no-lock
    where _File._File-Name = p-table-name
    no-error .
  if not available _File then do:
    message
      vss-workfile vss-revision vss-description skip
      "Ошибка задания входных параметров" skip
      "Неизвестная таблица" p-table-name skip
      view-as alert-box error .
  end.

  assign
    p-template-recid = _File._Template
  .

end.