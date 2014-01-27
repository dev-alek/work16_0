/*
$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Оперативный отчет по закончившимся наименованиям

Автор: Демин Алексей Сергеевич
Дата создания: 09/16/05
Author: Alexey Demin
Creation date: 09/16/05

*/

{ cmp/str-glbl.i }
{ cmp/r-page1.i new}

define input  parameter parParentProc  as widget-handle no-undo.

run rep/d-report.w (
parParentProc,
input                       'rep/e-slg-e.w',
input                       'Оперативный отчет по закончившимся наименованиям',
input                        1,
input                        "{&g-all},{&g-grp},{&g-prod},{&g-choice},{&g-one},{&g-grp-prod}",
input                        "{&o-currency}",
input                        "",
input                        "",
input                        "all,{&Arc-stk-yes}",
input                        no).