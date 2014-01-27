/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Расчет естественной убыли

Автор: Шальнев Иван Сергеевич
Дата создания: 16/05/11
Author: Shalnev ivan
Creation date: 16/05/11

*/
define input  parameter parParentProc  as widget-handle no-undo.
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Расчет естественной убыли".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i NEW}
run rep/d-report.w (
input parParentProc ,
input                   "rep/e-calcwast.w",
input                   "Расчет естественной убыли",
input                   2,
input                   "{&g-choice}":U,
input                   "{&o-currency}":U,
input                   "",
input                   "",
input                   "all,{&Arc-stk-yes},{&Arc-ot-yes},{&Excel-yes},{&format-folder}",
input                   no).