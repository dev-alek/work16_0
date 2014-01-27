/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Оборотная ведомость по одному товару

Автор: Чернова Светлана Александровна
Дата создания: 09/09/05
Author: Svetlana Chernova
Creation date: 09/09/05

*/
define input  parameter parParentProc  as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new}
run rep/d-report.w (
input parParentProc ,
input                       'rep/e-o-good.w',
input "Оборотная ведомость по одному товару",
input                        4,
input                        "{&g-one}",
input                        "{&o-currency}",
input                        "",
input                        "{&v-rubl},{&v-base}",
input                        "all,{&Arc-ot-yes},{&format-folder}":U,
input                        no).