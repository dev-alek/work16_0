/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Описание файла

Автор: Сливенко Сергей Андреевич
Дата создания: 11/07/11
Author: Sergey Slivenko
Creation date: 11/07/11

*/

define input parameter parParentProc as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет по продажам упаковками".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new }
run rep/d-report.w (
    input parParentProc ,
    input "rep/e-saleup.w",
    input "Отчет по продажам упаковками",
    input 2,
    input "{&g-all},{&g-grp},{&g-prod},{&g-choice},{&g-one},{&g-grp-prod}",
    input "*":U,
    input "",
/*input      "{&v-rubl},{&v-base}",*/
    input "",
    input "all,{&Excel-yes}",
    input no).