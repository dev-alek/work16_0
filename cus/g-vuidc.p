/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

ОТЧЕТ ПО ПОКУПКАМ ПОСТОЯННЫХ КЛИЕНТОВ ( С ДИС.КАРТАМИ) для Lui Vuitton - запуск

Автор: Бахтадзе Наталья Викторовна
Дата создания: 09/23/03
Author: Bakhtadze Natalya
Creation date: 09/23/03

*/

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "ОТЧЕТ ПО ПОКУПКАМ ПОСТОЯННЫХ КЛИЕНТОВ ( С ДИС.КАРТАМИ) для Lui Vuitton - запуск".
{ cmp/vssrevis.i }

{ cmp/trg-def.i }
{ cmp/library.i }
{ cmp/r-page0.i new}
{ gbl/getcntxt.i def }

define variable glog as logical no-undo .

find first ub.sys-ctrl no-lock.
if ub.sys-ctrl.db-num <> 0 then do:
  message
  "Данный отчет можно запускать тольков ГБД"
  view-as alert-box error .
  return error.
end.

{ gbl/getcntxt.i get }
{ gbl/chk-actg.i
v-cntxt-db-num
v-cntxt-userid
{&action-head-code-main}
'actn_permanent-client-sale_print':U
{&cntxt-firm}
v-cntxt-host-code-obj
'':U
0
0
0
0
false
glog
}

if NOT glog then do:
  message
  "У Вас недостаточно прав" skip
  "для выполнения данного действия." skip
  "Обратитесь к администратору системы."
  view-as alert-box error.
  return .
end.


run rep/d-report.w (
                input parparentproc
               ,input 'cus/r-vuidc.p'
               ,input ('Продажи постоянным клиентам-Lui Vuitton')
               ,input 2
               ,input "{&g-all},{&g-prod},{&g-grp},{&g-choice},{&g-one}"
               ,input "*"
               ,input ""
               ,input ""
               ,input "shop,{&news-arj},{&Excel-yes}"
               ,input yes).