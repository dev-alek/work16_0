/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Файл пирога обрезания. Относится к категории 995.

some-lk
some-lk-attr
who-lk
who-lk-attr


Автор: Бахтадзе Наталья Викторовна
Дата создания: 05/25/09
Author: Bakhtadze Natalya
Creation date: 05/25/09

*/


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$".
define variable vss-description as character no-undo init "Файл пирога обрезания. Относится к категории 995.".
{ cmp/str-glbl.i }

define buffer old-some-lk for src.some-lk.
define buffer new-some-lk for dst.some-lk.
define buffer old-some-lk-attr for src.some-lk-attr.
define buffer new-some-lk-attr for dst.some-lk-attr.
define buffer old-who-lk for src.who-lk.
define buffer new-who-lk for dst.who-lk.
define buffer old-who-lk-attr for src.who-lk-attr.
define buffer new-who-lk-attr for dst.who-lk-attr.






do
on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)) :
{ utl/00000001.i }
on WRITE of dst.some-lk override do: end.
on WRITE of dst.some-lk-attr override do: end.
on WRITE of dst.who-lk override do: end.
on WRITE of dst.who-lk-attr override do: end.


{ utl/00000002.i some-lk }
{ utl/00000002.i some-lk-attr }
{ utl/00000002.i who-lk }
{ utl/00000002.i who-lk-attr }

output stream str-gen close.
return "Произведен экспорт таблиц: some-lk some-lk-attr who-lk who-lk-attr .".
end.





