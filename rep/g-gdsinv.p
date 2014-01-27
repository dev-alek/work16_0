/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет Вхождение товара в инвентаризации

Автор: Морозов Александр Сергеевич
Дата создания: 04/22/11
Author: Alexandr Morozov
Creation date: 04/22/11

*/
define input parameter parParentProc as widget-handle no-undo.
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет Вхождение товара в инвентаризации".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new }
run rep/d-report.w (
    input parParentProc ,
    input "rep/e-gdsinv.w",
    input "Вхождение товара в инвентаризации",
    input 2,
    input "{&g-all},{&g-grp},{&g-choice}":U,
    input "{&o-firm},{&o-currency},{&o-choice}":U,
    input "",
    input "",
    input "all,{&Excel-yes}",
    input false  ).