/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Вспомогательный файл для кодекса правил 20 набор правил 4

Автор: Морозов Александр Сергеевич
Дата создания: 04/14/13
Author: Morozov Alexandr
Creation date: 04/14/13

Импорт справочников 1С (РОСНЕФТЬ).

---------------------------&start-codex_id=18;ruleset_id=12;-----------------
Импорт справочников 1С (РОСНЕФТЬ).

---------------------------&end-codex_id=18;ruleset_id=12;-----------------

*/

/*---------------------------&start-using-class&-------------------------------*/
using ibs.th.bge.*.
using ibs.th.bge.1crn.import.*.
using ibs.th.bge.1crn.import.*.

/*---------------------------&end-using-class&---------------------------------*/
block-level on error undo, throw.

define variable parseSubObj as class parsesub no-undo.
define variable impSubObj as class impsubject no-undo.

define input parameter parparentproc as widget-handle no-undo .
define input parameter p-parent-handle as handle no-undo .
define input parameter p-log-handle  as handle no-undo .
define input parameter p-cont-handle  as handle no-undo .
define input parameter p-codex-id as integer no-undo .
define input parameter p-ruleset-id as integer no-undo .
define input parameter p-call-id as character no-undo .
define input parameter p-order-id as integer no-undo .
define input parameter p-rule-id as integer no-undo .
define input parameter p-profile-id as integer no-undo .
define input parameter p-is-dynamic as logical no-undo .
define input parameter p-doc-type as character no-undo .
define input parameter p-host-code like ub.sysconf.host-code no-undo .
define input parameter p-obj-type like ub.clients.obj-type no-undo .
define input parameter p-obj-code like ub.clients.obj-code no-undo .
define input parameter p-doc-code as character no-undo .
define input parameter p-process-file-name as character no-undo .
define input parameter p-save       as integer no-undo .
define input parameter v-curr-r-b   as character no-undo .
define input parameter p-cmd-proc-handle as handle no-undo .
define input parameter p-cmd-code  as integer no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Библиотека процедур для работы с кодексом 20 набор правил 4".
{ cmp/vssrevis.i }
{ cmp/trg-def.i }
{ rul/garbcoll.i }
{ gbl/cur-time.i }
{ nws/lib-nws.i }
&glob cmd-proc-handle p-cmd-proc-handle
&glob cmd-code p-cmd-code

{ nws/temp-cmd.i "SHARED" }
{ rul/cl-hist.i "shared" }
{ rul/library-cls.i "non-class-part" }
{ gbl/key-rec.i }
{ rul/tempcxml.i "shared" }
{ gbl/gate-clb.i }
{ rul/ruleset_.i }

define temp-table temp-asmg no-undo
field gds-code as integer
field asmg-des as character
field obj-type  as character
field gdop-igt as character
field gdop-assort-min as logical
field obj-code as integer
field mode as character
index pi obj-code obj-type
.

/*переменные контекста*/
/*это у нас объект 0*/

define variable v-current-host-code as integer no-undo .
define variable v-current-obj-type as character no-undo .
define variable v-current-obj-code as integer no-undo .
define variable v-current-doc-code as character no-undo .
define variable v-current-doc-date as date no-undo .
define variable v-current-doc-type as character no-undo .
define variable v-current-doc-time as integer no-undo .
define variable v-current-lock as integer no-undo .
define variable v-current-wait as integer no-undo .
define variable v-save as integer no-undo .
define variable v-current-db-num as integer no-undo .
define variable v-current-date as date no-undo .
/*****************************/
define variable v-sign as integer no-undo .
define variable file-name as char.
define variable num-rec as integer no-undo .
define variable num-rec-ok as integer no-undo .
define variable num-rec-ok2 as integer no-undo .
define variable v-full-path        as character no-undo .
define variable v-path             as character no-undo .
define variable v-file-name        as character no-undo .
define variable v-file-name-no-ext as character no-undo .
define variable v-file-name-ext    as character no-undo .
define variable v-end-new-line     as logical no-undo .
define variable v-last-error-message as character no-undo .
define variable v-retry-action as integer no-undo .
define variable v-xmlh as handle no-undo .
define variable v_qh as handle no-undo .
define variable glog as logical no-undo .
define variable v-ds-read-order as character no-undo .
define variable v-esys-id as integer no-undo .
define variable v-err-message as character no-undo .

{ rul/seterror.i }
define buffer buf_temp-cmd for temp-cmd.
define temp-table temp-rule-call-param no-undo like ub.rule-call-param.
define buffer buf_temp-rule-call-param for temp-rule-call-param.
define buffer buf_temp-xml-tables for temp-xml-tables.


define variable log-file-name                as character      no-undo init "imp-1crn.txt".
define variable v-view-log                   as logical        no-undo .
define variable v-stop                       as logical        no-undo .


function 00200004_get-error-message returns character :
define variable v-ii as integer no-undo .
define variable v-mess as character no-undo .
do v-ii = 1 to error-status:num-messages:
    v-mess = substitute("&1&2ош &3"
                        ,v-mess
                        ,{&new-line}
                        ,error-status:get-message(v-ii)).
end.
end function.

function notnull returns character (input str as character):
if str = ? then return "" . else return str .
end function.

function get-time returns character(p-time as integer):
    return string(p-time, "HH:MM:SS").
end.

function get-date returns character(p-date as date):
    return subst("&1.&2.&3", string(day(p-date), "99"), string(month(p-date), "99"), string(year(p-date), "9999")).
end.

&scop display-message ~
          run write-log-and-file in p-log-handle ( ~
                input 1                            ~
              , input log-file-name                ~
              , input 1                            ~
              , input ~{&my-message}~)




/*---------------------------&start-rule-call-param&-------------------------------*/
  define variable p-esys-id     as integer   no-undo .
  define variable p-sub-type    as character no-undo.
  define variable p-reciever-id as character no-undo .
  define variable p-sender-id   as character no-undo.

/*---------------------------&end-rule-call-param&-------------------------------*/
/* ------------------------- &start-i-script& -----------------------------------*/
/* ------------------------- &end-i-script& -----------------------------------*/

on delete of this-procedure do:
  run delete-procedure in this-procedure .
end.


&scop sign v-sign *

run load-ruleset-context in this-procedure ( input p-ruleset-id) no-error .
if error-status:error
or return-value = "return" then return.

/* ------------------------- &start-def-vars& -----------------------------------*/

/* ------------------------- &end-def-vars& -----------------------------------*/


if not this-procedure:persistent then do:
  run proc-main in this-procedure  no-error .
  if error-status:error then do:
      run delete-procedure in this-procedure .
      undo, return error.
  end.
  run delete-procedure in this-procedure .
end.

procedure proc-main :
define variable v-ii as integer   no-undo .
define variable v-current-b-code as integer no-undo .
define buffer buf_ext-system for ub.ext-system.

_main:
do
on error  undo _main, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
on stop   undo _main, return error substitute( "&1. stop", vss-workfile )
on endkey undo _main, return error substitute( "&1. endkey", vss-workfile )
:

/* ------------------------- &start-hn-option& -----------------------------------*/
/* ------------------------- &end-hn-option -----------------------------------*/

run write-log  in p-log-handle (
                                 input 0
                               , "&DLine").
&scop my-message substitute(".............Импорт данных по пакету 1С (РОСНФЕТЬ) из ВС")
  {&display-message}.
  &scop my-message substitute("Импорт данных по пакету 1С (РОСНФЕТЬ) из файла &1", file-name)
  {&display-message}.

    find first buf_ext-system no-lock where
              buf_ext-system.esys-id = v-esys-id
          and buf_ext-system.db-num = 0 no-error.
    if not available buf_ext-system
    or not (buf_ext-system.esys-type  > integer({&openxml-type-ordinal})) then do:
    &scop my-message  substitute("Не найдена ВС &1 или она не имеет типа СПЕЦИАЛЬНАЯ", v-esys-id)
       {&display-message}.
       undo _main, return error ''.
    end.
  do transaction:
    parseSubObj = new parsesub ().
    impSubObj = new impsubject (parseSubObj).
    parseSubObj:Parse1CRNSub(file-name).
    catch exAppErrors as class Progress.Lang.AppError :
      &scop my-message substitute("Ошибка при сохранении данных по пакету 1С (РОСНФЕТЬ) из ВС:&1&2&1&3", {&new-line}, parseSubObj:Msg , error-status :get-message(1)  )
      v-err-message = {&my-message} .
      {&display-message}.
      undo, throw exAppErrors .
    end catch .
    catch exProErrors as class Progress.Lang.ProError :
      undo, throw exProErrors .
    end catch .
    catch exAnyErrors as class Progress.Lang.Error:
/*      Msg = "Unexpected error occurred..." .*/
      undo, throw exAnyErrors .
    end catch .
    finally :
      delete object parseSubObj no-error.
      delete object impSubObj no-error.
    end finally .
  end.

end. /*doe _main*/
end procedure. /* proc-main */

procedure load-ruleset-context :
define input parameter p-ruleset-id as integer no-undo .
define buffer buf_rule-call-param for ub.rule-call-param.
define variable v-itop as integer   no-undo .
define variable v-ichild as integer   no-undo .
define variable v-pck-num as integer no-undo .
define buffer buf_esys-pck-keys for ub.esys-pck-keys.
define buffer buf_ext-system for ub.ext-system.

  do
  on error undo, return error
  :

/*---------------------------&start-process-rule-call-param&-------------------------------*/

 find first buf_rule-call-param no-lock where
buf_rule-call-param.codex_id = p-codex-id
and buf_rule-call-param.ruleset_id = p-ruleset-id
and buf_rule-call-param.call_id = p-call-id
and buf_rule-call-param.order_id = p-order-id
and buf_rule-call-param.rule_id = p-rule-id
and buf_rule-call-param.param-name = "p-esys-id"
 no-error.
if available buf_rule-call-param then do:
assign p-esys-id = buf_rule-call-param.param-value-integer.
end.

 find first buf_rule-call-param no-lock where
buf_rule-call-param.codex_id = p-codex-id
and buf_rule-call-param.ruleset_id = p-ruleset-id
and buf_rule-call-param.call_id = p-call-id
and buf_rule-call-param.order_id = p-order-id
and buf_rule-call-param.rule_id = p-rule-id
and buf_rule-call-param.param-name = "p-sub-type"
 no-error.
if available buf_rule-call-param then do:
assign p-sub-type = buf_rule-call-param.param-value-character.
end.

 find first buf_rule-call-param no-lock where
buf_rule-call-param.codex_id = p-codex-id
and buf_rule-call-param.ruleset_id = p-ruleset-id
and buf_rule-call-param.call_id = p-call-id
and buf_rule-call-param.order_id = p-order-id
and buf_rule-call-param.rule_id = p-rule-id
and buf_rule-call-param.param-name = "p-sender-id"
 no-error.
if available buf_rule-call-param then do:
assign p-sender-id = buf_rule-call-param.param-value-character.
end.

 find first buf_rule-call-param no-lock where
buf_rule-call-param.codex_id = p-codex-id
and buf_rule-call-param.ruleset_id = p-ruleset-id
and buf_rule-call-param.call_id = p-call-id
and buf_rule-call-param.order_id = p-order-id
and buf_rule-call-param.rule_id = p-rule-id
and buf_rule-call-param.param-name = "p-reciever-id"
 no-error.
if available buf_rule-call-param then do:
assign p-reciever-id = buf_rule-call-param.param-value-character.
end.

    case p-ruleset-id:
      when {&thref-proc_20_xml-esys-import} then do:
          
        assign
        v-sign = 1
        v-current-host-code = p-host-code
        v-current-obj-type = p-obj-type
        v-current-obj-code = p-obj-code
        v-current-doc-code = p-doc-code
        v-current-db-num = g#db-num
        v-current-lock = (if p-save >= 0 then exclusive-lock else no-lock)
        file-name  = entry(2, p-process-file-name, {&delim-par})
        v-esys-id = integer(trim(p-doc-code))
        no-error
       .
       
        find first buf_ext-system no-lock where
                  buf_ext-system.esys-id = v-esys-id
              and buf_ext-system.db-num = 0 no-error .
        if not available buf_ext-system
        or buf_ext-system.esys-type <> integer({&openxml-type-special})
        then do:
          &scop my-message substitute("Не найдена ВС &1&2пропускаем ..." ~
                                        , v-esys-id ~
                                        , ~{&new-line~} ~
                                        )
          {&display-message}.
          undo, return error {&my-message}.
        end.

        
      end.
      otherwise do:
        undo, return error "Неправильный вызов".
      end.
    end case.
  end. /*doe*/

/*---------------------------&end-process-rule-call-param&-------------------------------*/
end procedure. /* load-ruleset-context */


procedure delete-procedure :

  do
  on error undo, return error
  :
      run garbcoll_clear in this-procedure .
  end.

end procedure. /* delete-procedure */


procedure pcall-log-file :
define input  parameter p-message as character no-undo .
  do
  on error undo, return error return-value
  :
    run write-log-and-file in p-log-handle (
          input 1
        , input log-file-name
        , input 1
        , input p-message ) .

  end.

end procedure. /* pcall-log-file */

procedure cre-status :

  define variable hSAXWriter as handle no-undo.
  define variable v-str as character no-undo.
  define variable v-dt-1c as character no-undo.
  define variable dir_crt as logical no-undo.



end.
