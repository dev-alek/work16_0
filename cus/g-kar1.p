/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Список чеков с одной товарной строкой - для каравана - запуск

Автор: Бахтадзе Наталья Викторовна
Дата создания: 03/21/06
Author: Bakhtadze Natalya
Creation date: 03/21/06

выкидывает все чеки в которых один товар и артикул поставщика и название этого товара

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
{ cmp/r-page0.i new }
{ cmp/library.i }
{ gbl/getcntxt.i def }
{ gbl/getcntxt.i get }

define NEW SHARED var shft as logical no-undo init no.
define NEW SHARED var cas-shft as logical no-undo init no.
define variable glog as logical no-undo .

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

run rep/d-report.w (    input parparentproc
                  , input 'cus/e-kar1.w'
                  , input 'Список чеков с одной товарной строкой'
                  , input 2
                  , input ""
                  , input "*"
                  , input ""
                  , input ""
                  , input "shop,{&send-check}"
                  , input no).