/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Обща

Автор: Чернова Светлана Александровна
Дата создания: 07/03/07
Author: Svetlana Chernova
Creation date: 07/03/07


*/
define input  parameter parParentProc  as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Общая".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i NEW }

run rep/d-report.w (
    input parParentProc ,
    input "cus/r-o-chkv.p",
    input "Общая",
    input 2,
    input "":U,
    input "{&o-currency},{&o-choice}":U,
    input "",
    input "{&v-rubl}",
    input "shop,{&Excel-yes}",
    input yes
    ) .