/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет для Бизнес-Букета - запуск - Отчет о движении товаров через кассу

Автор: Бахтадзе Наталья Викторовна
Дата создания: 04/20/05
Author: Bakhtadze Natalya
Creation date: 04/20/05

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
{ gbl/getcntxt.i def }
{ gbl/getcntxt.i get }
define variable glog as logical no-undo .
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
run rep/d-report.w (
                   input parparentproc
                 , input 'cus/e-bb.w'
                 , input ('Отчет о движении товаров через кассу')
                 , input 2
                 , input "{&g-all},{&g-choice}"
                 , input "*"
                 , input ""
                 , input ""
                 , input "shop"
                 , input no).