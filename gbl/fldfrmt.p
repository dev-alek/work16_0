/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Получить формат поля из базы данных

Автор: Перваков Михаил Сергеевич
Дата создания: 01/11/01
Author: Mikhail Pervakov
Creation date: 01/11/01

*/

define input  parameter p-table-name  as character no-undo .
define input  parameter p-field-name  as character no-undo .
define output parameter p-format-name as character no-undo .

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Получить формат поля из базы данных".
{ cmp/vssrevis.i }

find first _File no-lock
  where _File._File-Name = p-table-name
  no-error .
if not available _File then do:
  message
    vss-workfile vss-revision vss-description skip
    "Ошибка задания входных параметров" skip
    "Неизвестная таблица базы данных" p-table-name skip
    "p-table-name" p-table-name skip
    "p-field-name" p-field-name skip
    view-as alert-box error .
  undo, return error .
end.

find first _Field of _File no-lock
  where _Field._Field-Name = p-field-name
  no-error .
if not available _File then do:
  message
    vss-workfile vss-revision vss-description skip
    "Ошибка задания входных параметров" skip
    "Неизвестное поле в таблице" p-table-name skip
    "p-table-name" p-table-name skip
    "p-field-name" p-field-name skip
    view-as alert-box error .
  undo, return error .
end.

assign
  p-format-name = _Field._Format
.