/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Файл пирога обрезания. Относится к категории 106.

tnved-head
tnved-head-attr
tnved-item
tnved-item-attr

Автор: Бахтадзе Наталья Викторовна
Дата создания: 05/22/09
Author: Bakhtadze Natalya
Creation date: 05/22/09

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Файл пирога обрезания. Относится к категории 106.".
{ cmp/vssrevis.i }

define buffer old-tnved-head for src.tnved-head.
define buffer new-tnved-head for dst.tnved-head.
define buffer old-tnved-head-attr for src.tnved-head-attr.
define buffer new-tnved-head-attr for dst.tnved-head-attr.
define buffer old-tnved-item for src.tnved-item.
define buffer new-tnved-item for dst.tnved-item.
define buffer old-tnved-item-attr for src.tnved-item-attr.
define buffer new-tnved-item-attr for dst.tnved-item-attr.



do
on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)) :
{ utl/00000001.i }
on WRITE of dst.tnved-head override do: end.
on WRITE of dst.tnved-head-attr override do: end.
on WRITE of dst.tnved-item override do: end.
on WRITE of dst.tnved-item-attr override do: end.




{ utl/00000002.i tnved-head }
{ utl/00000002.i tnved-head-attr }
{ utl/00000002.i tnved-item }
{ utl/00000002.i tnved-item-attr }



output stream str-gen close.
return "Произведен экспорт таблиц: ~
tnved-head tnved-head-attr tnved-item tnved-item-attr .".
end.