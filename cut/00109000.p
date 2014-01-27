/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Файл пирога обрезания. Относится к категории 109.

Автор: Уханов Дмитрий Юрьевич
Дата создания: 08/05/09
Author: Dmitry Ukhanov
Creation date: 08/05/09

Обработка таблиц:
grpa
grp-acta

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Файл пирога обрезания. Относится к категории 109.".

{ cmp/str-glbl.i }
do
on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)):
{ utl/00000001.i }
output stream str-gen close.
return "Произведен экспорт таблиц по группам прав: .".
end.