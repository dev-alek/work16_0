/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет по изменению розничных цен в соответствии с МРЦ

Автор: Комаров Иван Сергеевич
Дата создания: 03/29/10
Author: Ivan Komarov
Creation date: 03/29/10

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет по изменению розничных цен в соответствии с МРЦ".
{ cmp/vssrevis.i }

define input  parameter parParentProc  as widget-handle no-undo.
{ cmp/str-glbl.i }
{ cmp/r-page1.i new}
run rep/d-report.w (
                input parParentProc ,
                input "rep/r-change_price.p " + string(parParentProc),
                input "Отчет по изменению розничных цен в соответствии с МРЦ",
                input 4,
                input "",
                input "*",
                input "",
                input "",
                input "all,{&Excel-yes}",
                input yes).