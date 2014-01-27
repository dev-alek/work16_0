/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

ручной толкач Отчет Реализация топлива (Кедр)

Автор: Хныкин Павел Андреевич
Дата создания: 04/22/09
Author: Pavel Khnykin
Creation date: 04/22/09

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "ручной толкач Отчет Реализация топлива (Кедр)".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i  }


do
on error undo, return error return-value
:
  run rep/r-kfsale.p ( input my-handle
                     , input no
                     , input x-date-Start
                     , input x-Shift-Start
                     , input x-date-End
                     , input x-Shift-End
                     , input ?
                     , input ?
                     ) no-error.
                     
  if return-value <> "" and return-value <> ? then do:
    message return-value + ". Продолжение не возможно!".
    return error return-value.
  end.
end.