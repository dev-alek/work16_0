/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Главная программа запуска отчета r-ptlbal.p из меню

Автор: Уханов Дмитрий Юрьевич
Дата создания: 07/09/09
Author: Dmitry Ukhanov
Creation date: 07/09/09

Author1: Alexey Suslov
Creation date1: 03/27/06

*/
define input  parameter parParentProc  as widget-handle no-undo.

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Главная программа запуска отчета r-ptlbal.p из меню".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new }
run rep/d-report.w (
                input parParentProc ,
                input 'rep/e-ptlbal.w',
                input "ОПЕРАТИВНЫЙ БАЛАНСОВЫЙ ОТЧЕТ ДВИЖЕНИЯ НЕФТЕПРОДУКТОВ",
                input 4,
                input "{&g-choice}",
                input "{&o-currency}",
                input "",
                input "",
                input "all,{&Excel-yes}",
                input no).