/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Удаление бибилиотеки attr-lib.p

Автор: Перваков Михаил Сергеевич
Дата создания: 12/13/06
Author: Mikhail Pervakov
Creation date: 12/13/06

*/


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Удаление бибилиотеки attr-lib.p".
{ cmp/vssrevis.i }
{ gbl/attr-lib.i }

do
on error undo, return error return-value
:
  {&del_attr-lib}
end.