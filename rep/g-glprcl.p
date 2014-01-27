/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Печать прайс-листа с сортировкой по наименованию

Автор: Демин Алексей Сергеевич
Дата создания: 09/20/05
Author: Alexey Demin
Creation date: 09/20/05

*/

define input  parameter parParentProc  as widget-handle no-undo.
{ cmp/str-glbl.i }
{ cmp/r-page1.i new}
run rep/d-report.w
    (
    input parParentProc ,
    input 'rep/e-glprcl.w',
    "Прайс-лист",
    0,
    "{&g-choice}":U,
    "",
    "" ,
    "",
    "all,{&format-folder}",
    no).