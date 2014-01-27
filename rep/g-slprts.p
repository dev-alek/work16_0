/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Партии товара - запуск

Автор: Бахтадзе Наталья Викторовна
Дата создания: 09/07/05
Author: Bakhtadze Natalya
Creation date: 09/07/05

*/

define input parameter parparentproc as widget-handle no-undo .
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Партии товара - запуск".
{ cmp/vssrevis.i }

{ cmp/str-glbl.i }
{ cmp/library.i }
{ cmp/r-page0.i new }
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

run rep/d-report.w (
                            input parparentproc
                           , input 'rep/e-slprts.w'
                           , input ('Партии товара по документам')
                           , input 2
                           , input ""
                           , input "*"
                           , input ""
                           , input ""
                           , input "all,{&Excel-yes},{&Print-List-Hist-yes}"
                           , input  no).