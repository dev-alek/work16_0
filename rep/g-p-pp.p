/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Контроль приходных цен

Автор: Чернова Светлана Александровна
Дата создания: 03/02/06
Author: Svetlana Chernova
Creation date: 03/02/06

Creation date: 09/05/03 4:44

*/
define input  parameter parParentProc  as widget-handle no-undo.
{ cmp/str-glbl.i }
{ cmp/r-page1.i NEW }
run rep/d-report.w (
input parParentProc ,
input  "rep/e-p-pp.w","Контроль приходных цен",
input  1,
input  "{&g-choice}":U,
input  "{&o-firm},{&o-currency},{&o-choice}":U,
input  "",
input  "",
input  "all,{&Excel-yes}",
input  no).