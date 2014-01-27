/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Оборотная ведомость по поставшикам по документам

Автор: Чернова Светлана Александровна
Дата создания: 03/02/06
Author: Svetlana Chernova
Creation date: 03/02/06

Creation date: 09/05/03 4:44

*/
define input  parameter parParentProc  as widget-handle no-undo.
{ cmp/str-glbl.i }
{ cmp/r-page1.i NEW}
run rep/d-report.w (
input parParentProc ,
input                   "rep/e-obpstd.w","Оборотная ведомость по поставшикам по документам",
input                        2,
input                        "":U,
input                        "*":U,
input                        "",
input                        "{&v-RUBL},{&v-base}",
input                        "all,{&Excel-yes},{&format-folder}",
input                        no).