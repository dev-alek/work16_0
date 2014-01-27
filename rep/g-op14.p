/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

"Товарный отчет по форме ОП-14"

Автор: Чернова Светлана Александровна
Дата создания: 03/02/06
Author: Svetlana Chernova
Creation date: 03/02/06

Creation date: 11/04/03 2:56

*/
define input  parameter parParentProc  as widget-handle no-undo.
{ cmp/str-glbl.i }
{ cmp/r-page1.i new }
run rep/d-report.w
    (
    input parParentProc ,
    input 'rep/e-op14.w',"Товарный отчет по форме ОП-14"  , 2 ,
            "":U,
            "*",
            "" ,
            "",
            "all,{&Excel-yes},{&Arc-OT-yes}", no ).