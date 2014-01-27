/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Файл пирога обрезания. Относится к категории 200.

Автор: Уханов Дмитрий Юрьевич
Дата создания: 08/05/09
Author: Dmitry Ukhanov
Creation date: 08/05/09

Обработка таблиц:
schedule
schedule-attr

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$".
define variable vss-description as character no-undo init "Файл пирога обрезания. Относится к категории 200.".
{ cmp/str-glbl.i }

define buffer old-schedule      for src.schedule.
define buffer new-schedule      for dst.schedule.
define buffer old-schedule-attr for src.schedule-attr.
define buffer new-schedule-attr for dst.schedule-attr.

do
on error undo, return error
:
  { utl/00000001.i }
  on WRITE of dst.schedule      override do: end.
  on WRITE of dst.schedule-attr override do: end.

  { utl/00000002.i schedule      }
  { utl/00000002.i schedule-attr }
output stream str-gen close.
  return "Произведен экспорт таблиц: schedule schedule-attr.".
end.