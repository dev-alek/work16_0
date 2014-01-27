/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Автоматизированное формирование списка клиентов - толкач  для меню

Автор: Бахтадзе Наталья Викторовна
Дата создания: 12/28/05
Author: Bakhtadze Natalya
Creation date: 12/28/05

*/

define input parameter parparentproc as widget-handle no-undo .
define input parameter p-curr-host-code like ub.sysconf.host-code no-undo .
define input parameter p-obj-type       like ub.clients.obj-type no-undo .
define input parameter p-obj-code       like ub.clients.obj-code no-undo .
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }
{ cmp/cli-list.i cli-list def "new shared" }

run str/cli-list.w (
                 input parparentproc
                ,input p-curr-host-code
                ,input p-obj-type
                ,input p-obj-code
              ).