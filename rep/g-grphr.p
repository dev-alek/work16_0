/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Запуск отчета ПОЧАСОВАЯ СТАТИСТИКА ПО КОЛ-ВУ ТОВАРОВ

Автор: Бахтадзе Наталья Викторовна
Дата создания: 05/07/09
Author: Bakhtadze Natalya
Creation date: 05/07/09

*/

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Запуск отчета ПОЧАСОВАЯ СТАТИСТИКА ПО КОЛ-ВУ ТОВАРОВ".
{ cmp/vssrevis.i }
{ cmp/trg-def.i }
{ cmp/r-page0.i new }
{ gbl/getcntxt.i def }
{ gbl/getcntxt.i get }


define variable varis-ok      as   logical             no-undo initial no.
{ gbl/chk-actg.i
  v-cntxt-db-num
  v-cntxt-userid
  {&action-head-code-main}
  'actn_cur-obj-proceeds_print':U
  {&cntxt-firm}
  v-cntxt-host-code-obj
  '':U
  0
  0
  0
  0
  true
  varis-ok
}
if not varis-ok then return error.
run rep/d-report.w ( input parparentproc
                    ,input 'rep/e-grphr.w'
                    ,input 'Почасовая статистика розничных продаж по КОЛИЧЕСТВУ ТОВАРОВ'
                    ,input 2
                    ,input "{&g-all },{&g-grp},{&g-prod},{&g-choice}"
                    ,input '*'
                    ,input ''
                    ,input ''
                    ,input 'shop,{&send-check}'
                    ,input no).
