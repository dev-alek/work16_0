/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Состояние запаса (с учетом признаков)

Автор: Чернова Светлана Александровна
Дата создания: 06/08/01
Author: Svetlana Chernova
Creation date: 06/08/01

*/
define input  parameter parParentProc  as widget-handle no-undo.
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Состояние запаса (с учетом признаков)".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new}
run rep/d-report.w (
input parParentProc ,
input 'rep/e-prt-z.w',"Состояние запаса (с учетом признаков)",
input 1,
input "*":U,
input "*":U,
input "",
input "{&v-RUBL},{&v-base}",
input "all,{&Excel-yes},{&format-folder},{&Arc-ot-yes}",
input no
).