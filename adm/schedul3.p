/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Удаление строки расписани

Автор: Бахтадзе Наталья Викторовна
Дата создания: 06/18/09
Author: Bakhtadze Natalya
Creation date: 06/18/09

*/

define input parameter p-rec as recid no-undo .
define input parameter p-silent as logical no-undo .


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Удаление строки расписани ".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ gbl/key-rec.i }
{ ref/shd-attr.i }

define variable v-mess as character no-undo .
define variable v-uniq-key-rec as character no-undo .
define variable v-free-id as character no-undo .
define variable v-rum-type as character no-undo .

define buffer buf_schedule for ub.schedule.
define buffer buf-del_schedule-attr   for ub.schedule-attr .
define buffer buf_schedule-attr       for ub.schedule-attr .
define buffer buf-del_schedule        for ub.schedule .
DEFINE TEMP-TABLE tt0-rp-by-call NO-UNDO LIKE ub.rp-by-call.
DEFINE TEMP-TABLE tt0-rule-by-call NO-UNDO LIKE ub.rule-by-call.
DEFINE TEMP-TABLE tt0-rule-call-param NO-UNDO LIKE ub.rule-call-param.


main-block:
do
on error  undo main-block, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
on stop   undo main-block, return error substitute( "&1. stop", vss-workfile )
on endkey undo main-block, return error substitute( "&1. endkey", vss-workfile )
:
  find first buf_schedule exclusive-lock where
          recid(buf_schedule) = p-rec .

  /*удалим привязки машины отчетов*/
  case buf_schedule.task-type:
    when {&btpr-type-autosuz} then do:
     v-rum-type = {&rep}.
    end.
    when {&btpr-type-autofree}
    then do:
      run schedule-attr-get-free-id in this-procedure (
                                                       input buf_schedule.cre-db-num
                                                      ,input buf_schedule.task-type
                                                      ,input buf_schedule.task-num
                                                      ,output v-free-id) no-error.

     if num-entries(v-rum-type, "_") = 1 then do:
       v-rum-type = entry(1, v-free-id, "_").
         end.
    end.
    otherwise do:

    end.
  end case.
  if v-rum-type <> "" then do:
    run gen-key-rec in this-procedure ( input {&table_schedule}
                                        ,input (buffer buf_schedule:handle)
                                        , output v-uniq-key-rec).

    run rul/thbjrum1.p (
                    input {&update}
                    ,input v-rum-type
                    ,input v-uniq-key-rec
                    ,input 0
                    ,input "":U
                    ,input 0
                    ,input ? /*v-logical-value*/
                    ,INPUT TABLE tt0-rp-by-call
                    ,INPUT TABLE tt0-rule-by-call
                    ,INPUT TABLE tt0-rule-call-param) no-error .
    if error-status:error then do:
      v-mess = substitute("Ошибка при удалении настроек строки расписания машины правил: &1&2&3"
                          , error-status:get-message(1)
                          , {&new-line}
                          , return-value ).
      run err-mess in this-procedure ( input-output v-mess) .
      undo main-block, return error (if p-silent = yes then v-mess else '':U).
    end.
  end.
  for each buf_schedule-attr no-lock
     where buf_schedule-attr.cre-db-num     = buf_schedule.cre-db-num
       and buf_schedule-attr.task-type      = buf_schedule.task-type
       and buf_schedule-attr.task-num       = buf_schedule.task-num
  on error undo, return error
  :
    find first buf-del_schedule-attr exclusive-lock
         where recid( buf-del_schedule-attr ) = recid( buf_schedule-attr )
    .
    delete buf-del_schedule-attr.
  end.      /* for each buf-del_schedule-attr */
  delete buf_schedule no-error.
  if error-status:error then do:
    v-mess = substitute("Ошибка при удалении: &1&2&3"
                         , error-status:get-message(1)
                         , {&new-line}
                         , return-value ).
   run err-mess in this-procedure ( input-output v-mess) .
   undo main-block, return error (if p-silent = yes then v-mess else '':U).
  end.
end. /*doe*/



PROCEDURE err-mess:
  DEFINE INPUT-OUTPUT PARAMETER p-mess as character No-UNDO.
  CASE p-silent:
    when yes then do:
      assign
      p-mess = substitute("Расписание БД &1 тип &2 задача &3:&4 &5"
                         , buf_schedule.cre-db-num
                         , buf_schedule.task-type
                         , buf_schedule.task-num
                         , {&new-line}
                         , p-mess)
      .
    end.
    when no then do:
      message
      p-mess
      view-as alert-box error .
    end.
  end.
END PROCEDURE.
