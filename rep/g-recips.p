/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Реестр рецептов блюд

Автор: Чернова Светлана Александровна
Дата создания: 03/02/06
Author: Svetlana Chernova
Creation date: 03/02/06

Creation date: 04/06/04 6:29

*/

define input  parameter parParentProc  as widget-handle no-undo.
{ cmp/str-glbl.i }
{ cmp/r-page1.i new }
run rep/d-report.w
    (
    input parParentProc ,
    input 'rep/e-resips.w',"Реестр рецептов производства блюд",2,
    "{&g-all}",
    "{&o-firm}",
    "" ,
    "",
    "all,{&Excel-yes}", no).