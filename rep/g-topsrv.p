/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Продажи топлива и сервисного элемента

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
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i }
{ gbl/getcntxt.i def }
{ cmp/r-page0.i new }

define NEW SHARED variable cas-shft as logical no-undo init no.
define variable conf-attr as char no-undo.                  /* для чтения параметра конфигурации */
define variable conf-par as char no-undo.                  /* для чтения параметра конфигурации */
define variable par-type as char no-undo.
define variable glog as logical no-undo .
{ gbl/getcntxt.i get }
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
if not glog then return "NO".

/*найдем параметр - использовать смены на кассе или нет*/
{ gbl/cas-shft.i v-cntxt-obj-type v-cntxt-obj-code cas-shft }

run rep/d-report.w (
                      input parparentproc
                    ,input 'rep/e-topsrv.w'
                    ,input ('Продажи топлива и сервисного элемента')
                    ,input (if cas-shft then 5 else 6)
                    ,input ""
                    ,input "*"
                    ,input ""
                    ,input ""
                    ,input "shop,{&send-check}"
                    ,input no).