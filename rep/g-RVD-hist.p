/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Главная программа запуска отчета r-RVD-hist.p из меню

Автор: Уханов Дмитрий Юрьевич
Дата создания: 11/08/10
Author: Dmitry Ukhanov
Creation date: 11/08/10

*/

define input  parameter parParentProc  as widget-handle no-undo.

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Главная программа запуска отчета r-RVD-hist.p из меню".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new }
{ gbl/getcntxt.i def  }
{ gbl/getcntxt.i get  }
&scop tt-l " История изменения режимов измерения в резервуарах"
define variable v-value    as character no-undo .
define variable v-type     as character no-undo .

run gbl/conf-rd.p ("is-erpRN", "", "", 0, "", "", "", no, output v-value, output v-type) no-error.
    
if v-value = "yes"
and v-cntxt-db-num = 0
then do:
  message "В ТБД нет справочника товаров. Запуск отчёта невозможен!" view-as alert-box .
  return .
end .

run rep/d-report.w (
                input parParentProc ,
                input 'rep/e-RVD-hist.w',
                {&tt-l},
                input 4,
                input "{&g-one},{&g-choice}",
                input "*",
                input "",
                input "",
                input "all,{&Excel-yes}",
                input no).