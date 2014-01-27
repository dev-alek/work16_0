/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет об исполнении заявок

Автор: Чернова Светлана Александровна
Дата создания: 12/11/08
Author: Svetlana Chernova
Creation date: 12/11/08

*/

define input  parameter parParentProc  as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет об исполнении заявок".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new}
run rep/d-report.w (
input parParentProc ,
input                       'cus/e-isp-zy.w',"Отчет об исполнении заявок",
input                        2,
input                        "{&g-all},{&g-choice},{&g-one}":U,
input                        "{&o-firm},{&o-currency},{&o-choice},{&o-all}":U,
input                        "",
input                        "",
input                        "all,{&Arc-stk-yes}",
input                        no).