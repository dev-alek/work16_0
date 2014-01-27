/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Формирование списка бар-кодов и ДопБк

Автор: Бахтадзе Наталья Викторовна
Дата создания: 06/15/06
Author: Bakhtadze Natalya
Creation date: 06/15/06

*/

define input parameter parparentproc as widget-handle no-undo .
define input parameter p-curr-obj-type  like ub.clients.obj-type no-undo .
define input parameter p-curr-obj-code  like ub.clients.obj-code no-undo .
define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo initial "Формирование списка бар-кодов и ДопБк".
{ cmp/vssrevis.i }
{ cmp/trg-def.i }
{ cmp/bb-list.i bb-list def " new shared " }

run str/bb-list.w (
                   input parparentproc
                  ,input p-curr-obj-type
                  ,input p-curr-obj-code
                  ,input '').