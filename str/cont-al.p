/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

вызов справочника договоров

Автор: Чернова Светлана Александровна
Дата создания: 03/27/06
Author: Svetlana Chernova
Creation date: 03/27/06

*/
define input parameter parParentProc  AS WIDGET-HANDLE NO-UNDO.
define input parameter p-type     as character no-undo .


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i  }
{ cmp/showinf.i  }

define variable  bttns          as character no-undo .
define variable  par-mode       as character no-undo .
define variable  pardoc-rec     as character no-undo.
define variable  cli-type       as character no-undo .
define variable  cli-code       as integer   no-undo .
define variable  mngr-type      as character no-undo .
define variable  mngr-code      as integer   no-undo .
define variable  p-status       as character no-undo .
define variable  p-doc-type     as character no-undo .

  assign
    par-mode = {&company}
    bttns    = "b-add,b-chg,b-del,b-open,b-mark"
    cli-type = ?
    cli-code = ?
    mngr-type = ?
    mngr-code = ?
    p-status  = "current"
    pardoc-rec = ""
  .
  { gbl/getcntxt.i def }
  { gbl/getcntxt.i get }

  case p-type :
  when "inc" then
     assign p-doc-type = {&income} .
  when "exp" then
      assign p-doc-type = {&expense} .
  when "add" then
      assign p-doc-type = {&income}
             par-mode = "contract-type=" + {&contr-addch}
      .
  otherwise do:
     message "Неизвестный параметр " p-type view-as alert-box error .
  end.
  end case.

  run str/cont-all.w
        (   input parParentProc ,
            input v-cntxt-host-code-obj ,
            input bttns         ,
            input par-mode      ,
            input cli-type      ,
            input cli-code      ,
            input mngr-type     ,
            input mngr-code     ,
            input p-status      ,
            input p-doc-type    ,
            input-output pardoc-rec )  .