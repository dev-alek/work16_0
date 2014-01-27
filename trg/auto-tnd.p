/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Триггер на удаление auto-tank

Автор: Перваков Михаил Сергеевич
Дата создания: 04/11/06
Author: Mikhail Pervakov
Creation date: 04/11/06

*/

TRIGGER PROCEDURE FOR DELETE OF ub.auto-tank.

define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo initial "Триггер на запись автоцистерны".
{ cmp/vssrevis.i }
{ cmp/trg-def.i  }

main-block:
do
on error undo main-block, return error
:
  message
    "Удаление автоцистерны невозможно" skip
    view-as alert-box error .
    undo, return error .
end.