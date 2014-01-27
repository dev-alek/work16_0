/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Начисление и списание бонусов по программе БОНУС-КЛУБ

Автор: Бахтадзе Наталья Викторовна
Дата создания: 10/11/06
Author: Bakhtadze Natalya
Creation date: 10/11/06

*/

define input parameter parparentproc as widget-handle no-undo .
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Начисление и списание бонусов по программе БОНУС-КЛУБ".
{ cmp/vssrevis.i }

{ cmp/str-glbl.i }
{ cmp/library.i }
{ cmp/r-page0.i new }
{ gbl/getcntxt.i def }
{ gbl/getcntxt.i get }
define variable glog as logical no-undo .

{ gbl/chk-actg.i
v-cntxt-db-num
v-cntxt-userid
{&action-head-code-main}
'actn_cur-obj-proceeds_print':U
{&cntxt-global}
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


run rep/d-report.w (  input parparentproc
                 ,input 'cus/e-bonus1.w'
                 ,input 'Начисление и списание бонусов по программе БОНУС-КЛУБ'
                 ,input 2
                 ,input ""
                 ,input "{&o-choice}"
                 ,input ""
                 ,input ""
                 ,input "shop,{&send-check},{&Excel-yes}"
                 ,input no).