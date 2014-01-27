/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет по сумме кассовых услуг, оказанных принципиалу - запуск

Автор: Бахтадзе Наталья Викторовна
Дата создания: 06/06/03
Author: Bakhtadze Natalya
Creation date: 06/06/03

*/

define input parameter parparentproc as widget-handle no-undo .
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i }
{ cmp/r-page0.i NEW }
{ gbl/getcntxt.i def }

define variable glog as logical no-undo .
{ gbl/getcntxt.i get }
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
                ,input 'cus/e-princp.w'
                ,input ('Отчет по сумме кассовых услуг, оказанных принципиалу')
                ,input 2
                ,input "{&g-one},{&g-choice}"
                ,input "{&o-currency},{&o-firm}"
                ,input ""
                ,input ""
                ,input "shop,{&Excel-yes}"
                ,input no).