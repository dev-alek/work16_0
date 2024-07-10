/*

$Revision: 5918d4369f7a, 3506, rls $
$Author: VSpiridonov $
$Date: 2023/10/16 15:13:37 $
$Workfile: sendqr.p $
$Archive: str/sendqr.p $

Отсылка QR-code

Автор: Шкляр Елена
Дата создания: 02/14/14
Author: Elena Shklyar
Creation date: 02/14/14

Input:

Output:

*/

block-level on error undo, throw.

define input parameter parparentproc as widget-handle no-undo .
define input parameter p-parent-handle  as widget-handle no-undo .
define input parameter p-log-handle  as handle no-undo .
define input parameter p-parameter   as character no-undo .


define variable vss-revision    as character no-undo init "$Revision: e455fc319afd, 3602, rls $":U .
define variable vss-author      as character no-undo init "$Author: ARostovtsev $":U .
define variable vss-date        as character no-undo init "$Date: 2023/12/28 12:56:37 $":U .
define variable vss-workfile    as character no-undo init "$Workfile: sendqr.p $":U .
define variable vss-archive     as character no-undo init "$Archive: str/sendqr.p $":U .
define variable vss-description as character no-undo init "Толкач пересылки промоакций на кассу".
{ cmp/vssrevis.i }
{ cmp/trg-def.i  }
{ gbl/getcntxt.i def }

define variable p-pos-type    as character no-undo .
define variable p-obj-type    like ub.clients.obj-type no-undo .
define variable p-obj-code    like ub.clients.obj-code no-undo .
define variable action        as char      no-undo .
define variable recid-list    as character no-undo .

define var      choice        as integer   no-undo.
define var      rid-list      as char      no-undo.
define variable glog          as logical   no-undo .
define variable log-file-name as character no-undo init "send-cd.txt":U .
define variable v-view-log as logical no-undo .
define variable v-host-code like ub.sysconf.host-code no-undo .

define variable vSubs as class ibs.th.ref.promo.promoactionsubs no-undo .

assign
   p-pos-type = entry(1, p-parameter, {&delim-par})
   p-obj-type = entry(2, p-parameter, {&delim-par})
   p-obj-code = integer(entry(3, p-parameter, {&delim-par}))
   action     = entry(4, p-parameter, {&delim-par})
   recid-list = entry(6, p-parameter, {&delim-par})
no-error .
if error-status:error then do:
  run write-log-and-file in p-log-handle (
        input 1
      , input log-file-name
      , input 1
      , input substitute("Ошибка входных параметров &1:&2&3"
                         , p-parameter
                         , {&new-line}
                         , error-status:get-message(1)
                         )).
  v-view-log = yes.
  undo, return error .
end .

{ gbl/hostcode.i p-obj-type p-obj-code v-host-code }


CASE p-pos-type:
  when  {&cd-type-IBm-XML}
  then do:
    run str/send-qr.p (
                    input parparentproc
                   ,input p-parent-handle
                   ,input p-log-handle
                   ,input p-obj-code
                   ,input action
                   ,input 1
                  , input recid-list
                  , input log-file-name
                  , input-output v-view-log
                  ) no-error .
  end.
end CASE.

  finally :
    run write-log-and-file in p-log-handle (
        input 1
      , input log-file-name
      , input 1
      , input substitute("&1", {&new-line})
    ).
    define variable v-save-file-name as character no-undo .
    v-save-file-name = substitute("&1send-cd.log", ibs.th.gbl.gbl-inipar:logDir) .
    OS-APPEND value(log-file-name) value(v-save-file-name).
    OS-DELETE value(log-file-name).
  end finally .
