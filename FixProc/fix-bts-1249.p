/*

$Revision: 43079881fc1c, 3306, rls $
$Author: Rostovtsev $
$Date: 2025/02/04 08:00:00 $
$Workfile: change_trn-doc_fact-order.p $
$Archive: FixProc/change_trn-doc_fact-order.p $

Утилита обновления fact-order по fact-date в ПН
Автор: Ростовцев Александр
Дата создания: 04/02/22
Author: Rostovtsev Aleksandr

*/
{ utl/runpro.i }
define input parameter p-from-date      as character no-undo .

define variable vss-revision    as character no-undo init "$Revision:$":U .
define variable vss-author      as character no-undo init "$Author:$":U .
define variable vss-date        as character no-undo init "$Date:$":U .
define variable vss-workfile    as character no-undo init "$Workfile:$":U .
define variable vss-archive     as character no-undo init "$Archive:$":U .
define variable vss-description as character no-undo init "".

{ cmp/vssrevis.i }
{ cmp/trg-def.i  }
{ cmp/str-glbl.i }
{ trg/factord.i  }

define variable v-obj-code    as integer   no-undo .
define variable v-file-logs   as character no-undo .
define variable v-res         as character no-undo.
define variable v-date        as date no-undo.
define variable v-fact-order           as decimal no-undo .
define variable v-shift-end-fact-order as decimal no-undo .
define variable v-day-end-fact-order   as decimal no-undo .
define variable l-shift-on             as logical no-undo .

define stream sPut.

define buffer buf_clients for ub.clients .
define buffer buf_trn-doc for ub.trn-doc.

v-date = date(p-from-date) no-error.
if error-status:error then do:
  return error substitute("Ошибка передачи входных параметров в процедуру &1&2&3&2"
                       , (this-procedure:filename)
                       , {&new-line}
                       , error-status:get-message(1)).
end.

find first sys-ctrl no-lock .   

for first buf_clients where
          buf_clients.db-num = sys-ctrl.db-num
      and buf_clients.obj-type = {&shop}
    no-lock:
  v-obj-code = buf_clients.obj-code.    
end.


v-file-logs = "C:\Trade_House16x\Logs\fix-bts-1249.txt".
Output stream sPut to value(v-file-logs).

for each  buf_trn-doc where
          buf_trn-doc.obj-type = {&shop}
      and buf_trn-doc.obj-code = v-obj-code
      and buf_trn-doc.internal = false
      and buf_trn-doc.doc-type = {&income}
      and buf_trn-doc.ext-doc-type = {&TDEDT_Pri_Vnesh}
      and buf_trn-doc.doc-date >= v-date
      and buf_trn-doc.status_ = {&fact}
    :
  if buf_trn-doc.fact-order > 0 and 
     buf_trn-doc.fact-date <> date(int(trunc(buf_trn-doc.fact-order,0)))
  then do:
     put stream sPut
       buf_trn-doc.doc-date format "99/99/9999" " "
       buf_trn-doc.shift-date format "99/99/9999" " "
       buf_trn-doc.doc-code format "X(12)"
       buf_trn-doc.fact-date format "99/99/9999" " "
       buf_trn-doc.fact-order format ">>>>>>>>>9.9999999999" " "
     .
     run factord in this-procedure
        (input  buf_trn-doc.fact-date   /* p-fact-date            */
        ,input  buf_trn-doc.fact-time   /* p-fact-time            */
        ,input  buf_trn-doc.fact-num    /* p-fact-num             */
        ,input  buf_trn-doc.shift-date  /* p-shift-date           */
        ,input  buf_trn-doc.shift-num   /* p-shift-num            */
        ,input  l-shift-on             /* p-shift-on             */
        ,output v-fact-order           /* p-fact-order           */
        ,output v-shift-end-fact-order /* p-shift-end-fact-order */
        ,output v-day-end-fact-order   /* p-day-end-fact-order   */
        ) no-error .
     if error-status :error or v-fact-order = ? or v-fact-order = 0 
     then do:
       put stream sPut
         "Ошибка при определении фактического номера" skip.
     end. 
     else do:
       buf_trn-doc.fact-order = v-fact-order.
       put stream sPut
         v-fact-order format ">>>>>>>>>9.9999999999" skip. 
     end.
  end.
end.


output stream sPut close.

if search(v-file-logs) <> ? then
  v-res = "Успешно. Лог change_trn-doc_fact-order.txt сформирован в C:\Trade_House16x\Logs.".
else
  v-res = "Успешно. Лог не сформирован.".

message v-res view-as alert-box.