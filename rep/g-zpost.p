/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Состояние запаса по поставщикам

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
define variable vss-description as character no-undo init "Состояние запаса по поставщикам".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i NEW}
run rep/d-report.w (
input parParentProc ,
input                   "rep/e-zpost.w","Состояние запаса по поставщикам",
input                        1,
input                        "*",
input                        "*",
input                        "{&p-cost},{&p-crsa}",
input                        "{&v-RUBL},{&v-base}",
input                        "all,{&Arc-supp-yes},{&Arc-stk-yes},{&Excel-yes},{&format-folder}",
input                        no).