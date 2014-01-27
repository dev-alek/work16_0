/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Файл пирога обрезания. Относится к категории 104.

attr-prop
custom-labels

Автор: Бахтадзе Наталья Викторовна
Дата создания: 05/21/09
Author: Bakhtadze Natalya
Creation date: 05/21/09

*/


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$".
define variable vss-description as character no-undo init "Файл пирога обрезания. Относится к категории 104.".
{ cmp/str-glbl.i }

define buffer old-attr-prop for src.attr-prop.
define buffer new-attr-prop for dst.attr-prop.
define buffer old-custom-labels for src.custom-labels.
define buffer new-custom-labels for dst.custom-labels.




do
on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)) :
{ utl/00000001.i }
on WRITE of dst.attr-prop override do: end.
on WRITE of dst.custom-labels override do: end.


{ utl/00000002.i attr-prop }
{ utl/00000002.i custom-labels }

output stream str-gen close.
return "Произведен экспорт таблиц: attr-prop custom-labels .".
end.




