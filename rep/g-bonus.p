/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет по бонусам

Автор: Шальнев Иван Сергеевич
Дата создания: 23/07/10
Author: Shalnev ivan
Creation date: 23/07/10

*/
define input  parameter parParentProc  as widget-handle no-undo.
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет по бонусам".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i NEW}
run rep/d-report.w (
input parParentProc ,
input                   "rep/e-bonus.w","Отчет по бонусам",
input                   2,
input                   "{&g-all},{&g-grp},{&g-prod},{&g-choice},{&g-one},{&g-grp-prod}":U,
input                   "*":U,
input                   "",
input                   "",
input                   "all,{&Arc-supp-yes},{&Arc-ot-yes},{&Excel-yes},{&format-folder}",
input                   no).