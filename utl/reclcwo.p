/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Пересчет МЦ всех объектов

Автор: Бахтадзе Наталья Викторовна
Дата создания: 04/10/06
Author: Bakhtadze Natalya
Creation date: 04/10/06

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Пересчет МЦ всех объектов".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }

for each ub.clients no-lock where
ub.clients.obj-type = {&shop} or ub.clients.obj-type = {&stock}
:
    run utl/reclcwth.p ( ub.clients.obj-type, ub.clients.obj-code) no-error.
    if error-status:error then do:
    message
    vss-workfile vss-revision vss-description skip
    "Ошибка при пересчете объекта" skip
    ub.clients.obj-type ub.clients.obj-code.
    end.
end.