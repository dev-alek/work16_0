/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Толкач пересылки промоакций на кассу

Автор: Бахтадзе Наталья Викторовна
Дата создания: 02/19/06
Author: Bakhtadze Natalya
Creation date: 02/19/06

*/
block-level on error undo, throw.

define input parameter parparentproc as widget-handle no-undo .
define input parameter p-parent-handle  as widget-handle no-undo .
define input parameter p-log-handle  as handle no-undo .
define input parameter p-parameter   as character no-undo .
/*
включает
define input parameter p-pos-type as character no-undo .
define input parameter p-obj-type like ub.clients.obj-type no-undo .
define input parameter p-obj-code like ub.clients.obj-code no-undo .
define input parameter action as char no-undo .
*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Толкач пересылки промоакций на кассу".
{ cmp/vssrevis.i }
{ cmp/trg-def.i  }
{ gbl/getcntxt.i def }

define variable p-pos-type as character no-undo .
define variable p-obj-type like ub.clients.obj-type no-undo .
define variable p-obj-code like ub.clients.obj-code no-undo .
define variable action as char no-undo .
define variable p-db-num  as integer  no-undo .
define variable p-id      as int64  no-undo .

define var choice as integer no-undo.
define var rid-list as char no-undo.
define variable glog as logical no-undo .
define variable log-file-name as character no-undo init "send-cd.txt":U .
define variable v-view-log as logical no-undo .
define variable v-host-code like ub.sysconf.host-code no-undo .

define variable vSubs as class ibs.th.ref.promo.promoactionsubs no-undo .
.
assign
p-pos-type = entry(1, p-parameter, {&delim-par})
p-obj-type = entry(2, p-parameter, {&delim-par})
p-obj-code = integer(entry(3, p-parameter, {&delim-par}))
action     = entry(4, p-parameter, {&delim-par})
p-db-num   = integer (entry(5, p-parameter, {&delim-par}))
p-id       = int64(entry(6, p-parameter, {&delim-par}))
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
find first PromoAction where PromoAction.db-num  eq p-db-num
                         and PromoAction.id      eq p-id
no-lock no-error.
if not available PromoAction 
then do:
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
end.

     
    
CASE p-pos-type:
  when {&cd-type-IBM-XML}
  then do:
    FIND FIRST ub.cash-desk NO-LOCK WHERE
              ub.cash-desk.db-num = g#db-num AND
              ub.cash-desk.pos-type = {&cd-type-IBM-XML}

              No-error.
    IF not avail(ub.cash-desk) then do:
        run write-log-and-file in p-log-handle (
              input 1
            , input log-file-name
            , input 1
            , input substitute( "!!!&1 промоакции реализуются только для POS &2"
                                , (if action = "U" then "Передача" else "Удаление")
                                , {&cd-type-IBM-XML}
                              )
                                              ).
      return.
    end.
end. /*ibm*/
END CASE.

define variable v-promo-actions as class ibs.th.ref.promo.promoactionsubs no-undo .
define variable v-promo-stor as class ibs.th.gbl.storage.promoactionstorage no-undo .
v-promo-stor = new ibs.th.gbl.storage.promoactionstorage().
v-promo-actions = v-promo-stor:getpromoactionsubs(p-db-num,p-id).
delete object v-promo-stor.

CASE p-pos-type:
  when  {&cd-type-IBm-XML}
  then do:
    run str/send-promo.p (
                    input parparentproc
                   ,input p-parent-handle
                   ,input p-log-handle
                   ,input p-obj-code
                   ,input action
                   ,input (if not valid-object (vSubs)
                           then 0
                           else 1)
                  , input vSubs
                  , input log-file-name
                  , input-output v-view-log
                  ) no-error .
  end.
end CASE.

  finally :
    delete object v-promo-actions no-error.
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
