/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Запуск переименования артикула и(или) производителя.

Автор: Уханов Дмитрий Юрьевич
Дата создания: 09/08/05
Author: Dmitry Ukhanov
Creation date: 09/08/05

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "процедура запуска переименования артикула и(или) производителя".
{ cmp/vssrevis.i }

define input parameter parParentProc as handle no-undo .

do
on error undo, return error
:
  run utl/new-art.w ( input parParentProc
                 ,input ?
                 ,input ?
                 ,input ?
                ).

end.

return.

/* $Workfile$ end */