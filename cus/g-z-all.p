/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Состояние запаса по объектам (с учетом признаков)

Автор: Чернова Светлана Александровна
Дата создания: 09/08/05
Author: Svetlana Chernova
Creation date: 09/08/05

*/
define input  parameter parParentProc  as widget-handle no-undo.
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Состояние запаса по объектам (с учетом признаков)".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new}
run rep/d-report.w ( input parParentProc ,
input 'cus/e-z-all.w',
input "Состояние запаса по объектам (с учетом признаков)",
input 0,
input "{&g-all},{&g-choice},{&g-one}":U,
input "{&o-currency},{&o-choice}":U,
input "",
input "{&v-RUBL},{&v-base}",
input "all,{&Arc-stk-yes},{&Excel-yes},{&format-folder},{&send-check}",
input no).