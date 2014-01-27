/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Расход по скидкам для БЕНЕТТОНА

Автор: Бахтадзе Наталья Викторовна
Дата создания: 03/21/06
Author: Bakhtadze Natalya
Creation date: 03/21/06

*/

define input parameter parparentproc as widget-handle no-undo .
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }
{ cmp/trg-def.i }
{ cmp/r-page0.i new }
{ gbl/getcntxt.i def }
/* использовать смены на объекте*/
{ gbl/getcntxt.i get }

def NEW SHARED var shft as logical no-undo init no.
def NEW SHARED var cas-shft as logical no-undo init no.
define variable glog as logical no-undo .


{ gbl/chk-actg.i
  v-cntxt-db-num
  v-cntxt-userid
  {&action-head-code-main}
  'actn_reports_report-benet3':U
  {&cntxt-object}
  v-cntxt-host-code-obj
  v-cntxt-obj-type
  v-cntxt-obj-code
  0
  0
  0
  true
  glog
}
if not glog then return.

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
  glog
}
if not glog then return.

if v-cntxt-obj-type = {&shop} then do:
    FIND FIRST ub.shop no-lock where ub.shop.obj-code = v-cntxt-obj-code No-ERROR.
    shft = ub.shop.shift-on.
end.
else do:
    FIND FIRST ub.store no-lock where ub.store.obj-code = v-cntxt-obj-code No-ERROR.
    shft = ub.store.shift-on.
end.

run rep/d-report.w (  input parparentproc
                 ,input 'cus/e-benet3.p'
                 ,input 'Отчет по процентам скидки реализованного товара'
                 ,input 2
                 ,input "{&g-all},{&g-choice}"
                 ,input "*"
                 ,input ""
                 ,input ""
                 ,input "shop,{&send-check},{&Excel-yes}"
                 ,input yes).