/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Записать или считать значение атрибута

Автор: Перваков Михаил Сергеевич
Дата создания: 03/02/06
Author: Mikhail Pervakov
Creation date: 03/02/06

{1} имя атрибута

*/


define input  parameter h-widget         as handle    no-undo .
define output parameter p-attr-value     as character no-undo .
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }


do
on error undo, return error return-value
:
  assign
    p-attr-value = string(h-widget :{1})
  .
end.