/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Файл пирога обрезания. Относится к категории 205.

Автор: Бахтадзе Наталья Викторовна
Дата создания: 06/23/06
Author: Bakhtadze Natalya
Creation date: 06/23/06

Обработка таблиц:
upgrade
upgrade-attr

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$".
define variable vss-description as character no-undo init "Файл пирога обрезания. Относится к категории 205.".
{ cmp/str-glbl.i }

define buffer old-upgrade       for src.upgrade.
define buffer new-upgrade       for dst.upgrade.
define buffer old-upgrade-attr  for src.upgrade-attr.
define buffer new-upgrade-attr  for dst.upgrade-attr.


do
on error undo, return error
:
  { utl/00000001.i }
  on WRITE of dst.upgrade       override do: end.
  on WRITE of dst.upgrade-attr  override do: end.

  { utl/00000002.i upgrade      }
  { utl/00000002.i upgrade-attr }
output stream str-gen close.
  return "Произведен экспорт таблиц: upgrade upgrade-attr.".
end.