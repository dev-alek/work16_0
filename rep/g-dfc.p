/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Документ назначения цены

Автор: Чернова Светлана Александровна
Дата создания: 04/26/06
Author: Svetlana Chernova
Creation date: 04/26/06

*/

define input  parameter parParentProc  as widget-handle no-undo.
define input  parameter p-recid        as recid no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Документ назначения цены".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new }
{ gbl/getcntxt.i def }
{ gbl/getcntxt.i get }

   define variable g#log as logical   no-undo .
  { gbl/chk-actg.i
    v-cntxt-db-num
    v-cntxt-userid
    {&action-head-code-main}
    'actn_pdf_print':U
    {&cntxt-global}
    v-cntxt-host-code-obj
    v-cntxt-obj-type
    v-cntxt-obj-code
    0
    0
    0
    true
    g#log
  }
  if not g#log then return .

define buffer buf_price-doc-forming for ub.price-doc-forming .
find first buf_price-doc-forming no-lock where recid(buf_price-doc-forming) = p-recid no-error .
if error-status :error then return .

run rep/d-report.w
( input  parParentProc ,
  input  "rep/e-dfc.w" ,
  input  "Документ назначения цены " +
          caps(buf_price-doc-forming.name) +
          fill(" ",200) + "|" +
          string(p-recid) + "|"   ,
  input  0 ,
  input  "{&g-all}":U ,
  input  "":U ,
  input  "" ,
  input  "" ,
  input  "all,{&Excel-yes},{&format-folder}" ,
  input  no ).