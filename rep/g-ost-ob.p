/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет о суммарных остатках на объектах

Автор: Демин Алексей Сергеевич
Дата создания: 03/27/06
Author: Alexey Demin
Creation date: 03/27/06

*/
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет о суммарных остатках на объектах".
{ cmp/vssrevis.i }

define input  parameter parParentProc  as widget-handle no-undo.
{ cmp/str-glbl.i }
{ cmp/r-page1.i new}

run rep/d-report.w (
input parParentProc ,
input                       'rep/r-ost-ob.p',
input                       'Отчет о суммарных остатках на объектах',
input                        1,
input                        "",
input                        "*",
input                        "{&p-crsa},{&p-cost}",
input                        "{&v-rubl},{&v-base}",
input                        "all,{&Arc-stk-yes}",
input                        yes).