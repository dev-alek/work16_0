/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Расчет ретро-бонусов

Автор: Сливенко Сергей Андреевич
Дата создания: 09/14/11
Author: Sergey Slivenko
Creation date: 09/14/11

*/

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Расчет ретро-бонусов".
{ cmp/vssrevis.i }

{ cmp/str-glbl.i }
{ cmp/library.i }
{ gbl/getcntxt.i def }
{ cmp/r-page1.i new }

define variable glog as logical no-undo .
{ gbl/getcntxt.i get }
{ gbl/chk-actg.i
  v-cntxt-db-num
  v-cntxt-userid
  {&action-head-code-main}
  'actn_fin-bonus_work':U
  {&cntxt-firm}
  v-cntxt-host-code-obj
  '':U
  0
  0
  0
  0
  true
  gLog
}
if NOT gLog then do:
  return.
end.
 run rep/d-report.w (        input parparentproc
                            ,input 'rep/e-retroB.w'
                            ,input ('Расчет ретро-бонусов')
                            ,input 6
                            ,input "*":U
                            ,input "*"
                            ,input ""
                            ,input ""
                            ,input "all,{&Excel-yes},{&customer-yes}"
                            ,input no).