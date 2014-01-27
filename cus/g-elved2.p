 /*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Ведомость клиента за период времени- запуск

Автор: Бахтадзе Наталья Викторовна
Дата создания: 01/20/06
Author: Bakhtadze Natalya
Creation date: 01/20/06

*/

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Ведомость клиента за период времени - запуск".
{ cmp/vssrevis.i }

{ cmp/trg-def.i }
{ gbl/getcntxt.i def }
{ cmp/r-page0.i new }
define variable glog as logical no-undo .
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
true
glog
}
if NOT glog then  do:
  return .
end.

run rep/d-report.w (
                  input parparentproc
                  ,input 'cus/e-elved2.w'
                  ,input ('Ведомость клиента за период временим')
                  ,input 2  /*param-date*/
                  ,input "" /*param-goods*/
                  ,input ""  /*param-obj*/
                  ,input ""  /*param-pay*/
                  ,input ""  /*param-pay-hide*/
                  ,input "{&Excel-yes}"
                  ,input no).