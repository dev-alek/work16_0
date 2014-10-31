/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет Прайс лист на табачные изделия

Автор: Гридчина Полина Дмитриевна
Дата создания: 14/07/22
Author: Gridchina Polina
Creation date: 14/07/22

*/

define input  parameter parParentProc  as widget-handle no-undo.
/*define input  parameter p-recid-grp    as recid no-undo .*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет Отчет по прайс-листам".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new }
run rep/d-report.w
    (
    input parParentProc ,
    input 'rep/e-prcsigar.w',
    "Прайс-лист на табачные изделия",
    0,
    "{&g-choice}":U,
    "",
    "" ,
    "",
    "all,{&format-folder},{&Excel-yes}",
    no).