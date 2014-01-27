/*
$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет по межфирменным операциям - динамика закупки

Автор: Демин Алексей Сергеевич
Дата создания: 09/16/05
Author: Alexey Demin
Creation date: 09/16/05

*/

{ cmp/str-glbl.i }
{ cmp/r-page1.i new}

define input  parameter parParentProc  as widget-handle no-undo.

run rep/d-report.w (
input parParentProc ,
input                       'rep/e-hold2.w',
input                       'Отчет по межфирменным операциям - динамика закупки',
input                        0,
input                        "{&g-all},{&g-grp},{&g-prod},{&g-choice},{&g-one},{&g-grp-prod}",
input                        "",
input                        "",
input                        "{&v-RUBL},{&v-base}",
input                        "{&Arc-hold-yes}",
input                        no).