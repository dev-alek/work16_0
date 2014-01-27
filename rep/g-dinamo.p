/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Динамика движения товара - запуск 1

Автор: Бахтадзе Наталья Викторовна
Дата создания: 09/07/05
Author: Bakhtadze Natalya
Creation date: 09/07/05

*/

define input parameter parparentproc as widget-handle no-undo .
define input parameter p-gds-code like ub.goods.gds-code no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Динамика движения товара - запуск 1".
{ cmp/vssrevis.i }


{ cmp/str-glbl.i }
{ cmp/library.i }
{ gbl/getcntxt.i def }
{ gbl/getcntxt.i get }
{ cmp/r-page0.i new }

define new shared buffer buf_goods for ub.goods.
define variable glog as logical no-undo .

do
on error undo, return error
:
  find first buf_goods no-lock where
             buf_goods.gds-code = p-gds-code.

  { gbl/chk-actg.i
  v-cntxt-db-num
  v-cntxt-userid
  {&action-head-code-main}
  'actn_tax-settlement_print':U
  {&cntxt-firm}
  v-cntxt-host-code-obj
  '':U
  0
  0
  0
  0
  true
  glog
  }
  if not gLog then return "NO".
  run rep/d-report.w ( input parparentproc
                  ,input 'rep/e-dinamo.p'
                  ,input ('Динамика движения товара' + {&space-char} + "код товара:" + {&space-char} +
                          string(buf_goods.gds-code) + {&space-char} + "артикул:" + {&space-char} +
                          buf_goods.artic + {&space-char} +
                          buf_goods.prod-type + string(buf_goods.prod-code) + {&space-char} +
                          buf_goods.gds-name)
                  ,input 0
                  ,input "":U
                  ,input "*"
                  ,input ""
                  ,input ""
                  ,input "all,{&Arc-OT-yes}"
                  ,input yes) no-error .


end.

