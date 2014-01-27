/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$


Отчет "Состояние запаса с учетом резервов"

Автор: Демин Алексей Сергеевич
Дата создания: 01/11/06
Author: Alexey Demin
Creation date: 01/11/06

*/

define input  parameter parParentProc  as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Состояние запаса с учетом резервов".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new }

run rep/d-report.w
    (
    input parParentProc ,
    input 'rep/e-zapasr.w',"Состояние запаса с учетом резервов",
    1,
    "{&g-all},{&g-grp},{&g-prod},{&g-choice},{&g-one},{&g-grp-prod}":U,
    "*",
    "" ,
    "{&v-RUBL},{&v-base}",
    "all,{&Excel-yes},{&format-folder}", no).