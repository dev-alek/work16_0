/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

График поставок (вызов)

Автор: Комаров Иван Сергеевич
Дата создания: 10/07/10
Author: Ivan Komarov
Creation date: 10/07/10

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "График поставок".
{ cmp/vssrevis.i }

define input  parameter parParentProc  as widget-handle no-undo.
{ cmp/str-glbl.i }
{ cmp/r-page1.i new}
run rep/d-report.w (
                input parParentProc ,
                input 'rep/e-ordrcv.w',"График поставок",
                input 1,
                input "",
                input "{&o-currency},{&o-choice}",
                input "",
                input "",
                input "all,{&Excel-yes}",
                input no).