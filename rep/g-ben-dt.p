/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет по движению товара - сводный-запуск

Автор: Демин Алексей Сергеевич
Дата создания: 03/27/06
Author: Alexey Demin
Creation date: 03/27/06

*/

define input parameter parparentproc as widget-handle no-undo .
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет по движению товара - сводный-запуск".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new}
{ gbl/getcntxt.i def }


{ gbl/getcntxt.i get }

 define variable g#log as logical   no-undo .
{ gbl/chk-actg.i
  v-cntxt-db-num
  v-cntxt-userid
  {&action-head-code-main}
  'actn_reports_report-benet6':U
  {&cntxt-object}
  v-cntxt-host-code-obj
  v-cntxt-obj-type
  v-cntxt-obj-code
  0
  0
  0
  true
  g#log
}
 if not g#log then return.

run rep/d-report.w ( input parParentProc ,
input                       'rep/e-ben-dt.w',
input                       'Отчет по движению товара - сводный',
input                        2,
input                        "{&g-all},{&g-grp},{&g-prod},{&g-choice},{&g-one},{&g-grp-prod}",
input                        "{&o-firm},{&o-currency},{&o-choice}",
input                        "",
input                        "{&v-RUBL},{&v-base}",
input                        "shop,{&Arc-stk-yes},{&Excel-yes}",
input                        no).