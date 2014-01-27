/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Запуск отсылки товаров на  ТСД

Автор: Бахтадзе Наталья Викторовна
Дата создания: 06/08/05
Author: Bakhtadze Natalya
Creation date: 06/08/05

*/

define input parameter parparentproc as widget-handle no-undo .
define input parameter p-parent-handle  as widget-handle no-undo .
define input parameter p-log-handle  as handle no-undo .
define input parameter p-parameter   as character no-undo .


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Запуск отсылки товаров на  ТСД".
{ cmp/vssrevis.i }

{ cmp/trg-def.i }
{ cmp/bb-list.i bb-list def "NEW shared" }


run str/send-tsd.p (
               input parparentproc
              ,input p-parent-handle
              ,input p-log-handle
              ,input p-parameter
               ) no-error .

if return-value <> '':U then return return-value .