/*
$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Состояние запаса (с учетом признаков и коллекций)

Автор: Чернова Светлана Александровна
Дата создания: 03/03/06
Author: Svetlana Chernova
Creation date: 03/03/06

Дата создания: 10/11/04
*/
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Состояние запаса (с учетом признаков и коллекций)".
{ cmp/vssrevis.i }
define input  parameter parParentProc  as widget-handle no-undo.
{ cmp/str-glbl.i }
{ cmp/r-page1.i new}

run rep/d-report.w (
input parParentProc ,
input 'rep/e-prtse.w',
input "Состояние запаса (с учетом признаков и коллекций)",
input 1,
input "*":U,
input "*":U,
input "",
input "{&v-RUBL},{&v-base}",
input "all,{&Excel-yes},{&format-folder},{&Arc-ot-yes}",
input no ).