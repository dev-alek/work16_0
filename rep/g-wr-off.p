/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет по списанию

Автор: Шальнев Иван Сергеевич
Дата создания: 17/06/11
Author: Shalnev ivan
Creation date: 17/06/11

*/
define input  parameter parParentProc  as widget-handle no-undo.
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет по списанию".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i NEW}
run rep/d-report.w (
input parParentProc ,
input                   "rep/r-wr-off.p",
input                   "Отчет по списаниям",
input                   4,
input                   "":U,
input                   "{&o-currency},{&o-firm},{&o-choice},{&o-all}":U,
input                   "",
input                   "",
input                   "all,{&Excel-yes}",
input                   yes).