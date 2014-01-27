/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет о состоянии запаса и продажах (Excel)

Автор: Демин Алексей Сергеевич
Дата создания: 03/27/06
Author: Alexey Demin
Creation date: 03/27/06

*/
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет о состоянии запаса и продажах (Excel)".
{ cmp/vssrevis.i }

define input  parameter parParentProc  as widget-handle no-undo.
{ cmp/str-glbl.i }
{ cmp/r-page1.i new}
run rep/d-report.w (
input parParentProc ,
input                   'rep/e-zap-pr.w',"Отчет о состоянии запаса и продажах (Excel)",
input                        2,
input                        "{&g-all},{&g-choice},{&g-one}":U,
input                        "{&o-currency},{&o-choice}":U,
input                        "",
input                        "{&v-RUBL},{&v-base}",
input                        "all,{&Arc-stk-yes},{&Excel-yes}",
input                        no).