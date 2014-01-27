/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Возвращает текущую дату и время по текущему объекту

Автор: Перваков Михаил Сергеевич
Дата создания: 05/15/02
Author: Mikhail Pervakov
Creation date: 05/15/02

*/

define output parameter p-today as date      no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Возвращает текущую дату и время".
{ cmp/vssrevis.i }
{ gbl/cur-time.i }

define variable v-today as date      no-undo.
define variable v-time  as integer   no-undo.

do
on error undo, return error return-value
:
  run cur-time in this-procedure
    (output v-today
    ,output v-time
    ).

  assign
    p-today = v-today
  .
end.

