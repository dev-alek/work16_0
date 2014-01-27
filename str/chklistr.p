/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Формирование списка чеков

Автор: Бахтадзе Наталья Викторовна
Дата создания: 03/03/04
Author: Bakhtadze Natalya
Creation date: 03/03/04

*/

define input parameter parparentproc as widget-handle no-undo .
define input parameter p-curr-obj-type like ub.clients.obj-type no-undo .
define input parameter p-curr-obj-code like ub.clients.obj-code no-undo .
define input parameter p-curr-host-code like ub.sysconf.host-code no-undo .
/*текущий код фирмы - в том числе в АРМ финансы*/


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Формирование списка чеков".
{ cmp/vssrevis.i }

{ cmp/trg-def.i }
{ cmp/chk-list.i chk-list def " new shared " }

run str/chk-list.w (
               input parparentproc
               ,input p-curr-obj-type
               ,input p-curr-obj-code
               ,input p-curr-host-code

                ).