/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Формирование списка товаров

Автор: Бахтадзе Наталья Викторовна
Дата создания: 03/24/06
Author: Bakhtadze Natalya
Creation date: 03/24/06

*/

define input parameter parparentproc as widget-handle no-undo .
define input parameter p-curr-host-code like ub.sysconf.host-code no-undo .
define input parameter p-curr-obj-type  like ub.clients.obj-type no-undo .
define input parameter p-curr-obj-code  like ub.clients.obj-code no-undo .
define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo initial "Формирование списка товаров".
{ cmp/vssrevis.i }

{ cmp/trg-def.i }
{ cmp/gds-list.i gds-list def " new shared " }

run str/gds-list.w (
                 input parparentproc
                ,input p-curr-host-code
                ,input p-curr-obj-type
                ,input p-curr-obj-code).