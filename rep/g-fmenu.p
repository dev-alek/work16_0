/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

"Меню"

Автор: Чернова Светлана Александровна
Дата создания: 11/04/03
Author: Svetlana Chernova
Creation date: 11/04/03

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Меню".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new }

define input  parameter parParentProc  as widget-handle no-undo.
run rep/d-report.w
  (
    input parParentProc ,
    input "rep/r-fmenu.p",
    input "Меню",
    input 1  ,
    input "" ,
    input "*",
    input "" ,
    input "" ,
    input "all,{&Excel-yes}",
    input yes
    ).