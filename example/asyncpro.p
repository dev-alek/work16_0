/*
$Revision:$
$Author:$
$Date:$
$Workfile:$
$Archive:$

Автор: Рубан Дмитрий Андреевич 
Дата создания: 11 сент. 2023 г.
Author:  Ruban Dmitriy Andreevich
Creation date: 11 сент. 2023 г.

*/
define variable vss-revision    as character no-undo init "$Revision:$":U .
define variable vss-author      as character no-undo init "$Author:$":U .
define variable vss-date        as character no-undo init "$Date:$":U .
define variable vss-workfile    as character no-undo init "$Workfile:$":U .
define variable vss-archive     as character no-undo init "$Archive:$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }
{ adm/auto-def.i new}
define variable mAsyncHelper as class ibs.th.file.AsyncHelperth  no-undo.
mAsyncHelper = new ibs.th.file.AsyncHelperth ().
{utl/asuncprocauto.i &starterasunc = yes}
mAsyncHelper:setTimeOutTask("testasync", 70).
run AddTaskTime in this-procedure ("testasync", "example/proc-testasync", "", datetime-tz("01/01/2024")).
run AddTask in this-procedure ("testasyncNoTimeOut", "example/proc-testasync", "").
mAsyncHelper:myTimeOut = 300.
mAsyncHelper:SaveFile = yes.
run waitproc("тестовый процесс").
message "StopProc"
view-as alert-box.
delete object mAsyncHelper.
