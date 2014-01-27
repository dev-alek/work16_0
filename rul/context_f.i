/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Функции псевдокласса КОНТЕКСТ ПРАВИЛА

Автор: Бахтадзе Наталья Викторовна
Дата создания: 05/13/07
Author: Bakhtadze Natalya
Creation date: 05/13/07

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

{ gbl/key-rec.i }


&if "{1}" = "get-next-rule-call-param" &then
FUNCTION context_get-next-rule-call-param returns logical ( input p-param-name as character
                                                          , input-output p-index as integer):
define buffer buf_temp-rule-call-param for temp-rule-call-param.
find first buf_temp-rule-call-param where
          buf_temp-rule-call-param.param-name = p-param-name
      and buf_temp-rule-call-param.p-index > p-index no-error .
if available buf_temp-rule-call-param then do:
  p-index = buf_temp-rule-call-param.p-index.
end.
return available(buf_temp-rule-call-param).
END FUNCTION.

&endif

&if "{1}" = "get-last-rule-call-param" &then

FUNCTION context_get-next-rule-call-param returns logical ( input p-param-name as character
                                                           , output p-index as integer):
define buffer buf_temp-rule-call-param for temp-rule-call-param.
find last buf_temp-rule-call-param where
          buf_temp-rule-call-param.param-name = p-param-name no-error .
if available buf_temp-rule-call-param then do:
  p-index = buf_temp-rule-call-param.p-index.
end.
return available(buf_temp-rule-call-param).
END FUNCTION.

&endif

&if "{1}" = "get-rule-call-param_integer" &then
FUNCTION context_get-rule-call-param_integer returns integer (  input p-param-name as character
                                                               ,input p-index as integer):
define buffer buf_temp-rule-call-param for temp-rule-call-param.
find first buf_temp-rule-call-param where
          buf_temp-rule-call-param.param-name = p-param-name
      and buf_temp-rule-call-param.p-index = p-index
          no-error .
if available buf_temp-rule-call-param then do:
  return buf_temp-rule-call-param.param-value-integer.
end.
end function.
&endif

&if "{1}" = "begin-esys-command" &then
FUNCTION context_begin-esys-command returns logical (
                                                       input p-esys-id-list as character
                                                      ,input-output p-esys-cmd-proc-handle as handle
                                                      ,output p-esys-cmd-code as integer
                                                     ):

if not valid-handle(p-esys-cmd-proc-handle ) then do:
  /* инициализируем библиотеку формирования команды */
  run nws/cmd-bush.p persistent set p-esys-cmd-proc-handle no-error .
  if error-status :error
  then do:
    delete procedure p-esys-cmd-proc-handle .
    run set-error in this-procedure ( substitute("&1 &2 &3&4Ошибка при запуске процедуры cmd-bush.p&4" +
                                        "&5&4&6"
                                        ,vss-workfile
                                        ,vss-revision
                                        ,vss-description
                                        ,{&new-line}
                                        ,error-status:get-message(1)
                                        ,return-value )).
  end.
  /* начало формирования команды */
  run begin-create-command in p-esys-cmd-proc-handle
    (input {&cmd-esys-general} /* p-command-name */
    ,input p-esys-id-list             /* p-esys-id-list      */
    ,output p-esys-cmd-code        /* p-command-code */
    ) no-error.
  if error-status :error
  then do:
    delete procedure p-esys-cmd-proc-handle .
    run set-error in this-procedure ( input substitute("Ошибка при создании команды &1&2&3&1&4"
                                                     , {&cmd-esys-general}
                                                     , error-status:get-message(1)
                                                     , return-value
                                                     )).
    return no .
  end.
  return yes.
end.
end function.
&endif

&if "{1}" = "esys-add-dump" &then
FUNCTION context_esys-add-dump returns logical (
                                          input p-esys-cmd-proc-handle as handle
                                        , input p-esys-cmd-code as integer
                                        , input p-action as character
                                        , input p-name as character
                                        , input p-data-type as character
                                        , input p-value as character
                                        ):
  define variable v-esys-rec-ord as integer no-undo .
  define variable v-no-id as integer no-undo .
  find last temp-nws-outline use-index pi no-error .
  v-no-id = (if available temp-nws-outline
              then (temp-nws-outline.no-id  + 1)
              else 1).
  create temp-nws-outline.
  assign
  temp-nws-outline.charkeY_one = p-name
  temp-nws-outline.charkeY_two = p-data-type
  temp-nws-outline.charkeY_three = p-value
  temp-nws-outline.key#_one = 0
  temp-nws-outline.key#_two = 0
  temp-nws-outline.key#_three = 0
  temp-nws-outline.no-id = v-no-id
  temp-nws-outline.outline-type = 'value':U
  .

  run add-dump in p-esys-cmd-proc-handle
    (input p-esys-cmd-code
    ,input {&table_nws-outline}
    ,input p-action
    ,input buffer temp-nws-outline:handle
    ,input '':U
    ,output v-esys-rec-ord
    ) no-error .
  if error-status :error
  then do:
    delete procedure p-esys-cmd-proc-handle .
    run set-error in this-procedure ( substitute("Ошибка при добавлении значения &2 в команду с кодом &3&1&4&1&5"
                                        ,{&new-line}
                                        ,p-name
                                        ,p-esys-cmd-code
                                        ,error-status:get-message(1)
                                        ,return-value
                                        ) ).
    return no.
  end.
  return yes.
end function.

&Endif

&if "{1}" = "send-esys-command" &then
FUNCTION context_send-esys-command returns logical (
                                                      input p-esys-id-list as character
                                                     ,input p-esys-cmd-proc-handle as handle
                                                     ,input p-esys-cmd-code as integer
                                                     ,input p-user-id as character
                                                     ):
define variable v-dmp-ord-int64 as int64 no-undo .
if valid-handle(p-esys-cmd-proc-handle ) then do:
  run send-command-esys in p-esys-cmd-proc-handle
    (input p-esys-cmd-code /* p-command-code */
    ,input p-esys-id-list             /* p-esys-id-list      */
    ,input p-user-id        /* p-user-id */
    ,output v-dmp-ord-int64
    ) no-error.
  if error-status :error
  then do:
    delete procedure p-esys-cmd-proc-handle no-error.
    run set-error in this-procedure ( input substitute("Ошибка при отсылке во внешнюю систему &1 команды с кодом &2&3&4&3&5"
                                                     , p-esys-id-list
                                                     , p-cmd-code
                                                     , {&new-line}
                                                     , error-status:get-message(1)
                                                     , return-value
                                                     )).
    return no .
  end.
  delete procedure p-esys-cmd-proc-handle no-error.
  return yes.
end.
else do:
  run set-error in this-procedure ( input substitute("Ошибка при отсылке во внешнюю систему &1 команды с кодом &2&3&4&3&5"
                                                    , p-esys-id-list
                                                    , p-cmd-code
                                                    , {&new-line}
                                                    , error-status:get-message(1)
                                                    , return-value
                                                    )).
  return no .
end.
end function.
&endif

&if "{1}" = "send-esys-command-ext" &then
FUNCTION context_send-esys-command returns int64 (
                                                      input p-esys-id-list as character
                                                     ,input p-esys-cmd-proc-handle as handle
                                                     ,input p-esys-cmd-code as integer
                                                     ,input p-user-id as character
                                                     ):
define variable v-dmp-ord-int64 as int64 no-undo .
if valid-handle(p-esys-cmd-proc-handle ) then do:
  run send-command-esys in p-esys-cmd-proc-handle
    (input p-esys-cmd-code /* p-command-code */
    ,input p-esys-id-list             /* p-esys-id-list      */
    ,input p-user-id        /* p-user-id */
    ,output v-dmp-ord-int64
    ) no-error.
  if error-status :error
  then do:
    delete procedure p-esys-cmd-proc-handle no-error.
    run set-error in this-procedure ( input substitute("Ошибка при отсылке во внешнюю систему &1 команды с кодом &2&3&4&3&5"
                                                     , p-esys-id-list
                                                     , p-cmd-code
                                                     , {&new-line}
                                                     , error-status:get-message(1)
                                                     , return-value
                                                     )).
    return 0.
  end.
  delete procedure p-esys-cmd-proc-handle no-error.
  return v-dmp-ord-int64.
end.
else do:
  run set-error in this-procedure ( input substitute("Ошибка при отсылке во внешнюю систему &1 команды с кодом &2&3&4&3&5"
                                                    , p-esys-id-list
                                                    , p-cmd-code
                                                    , {&new-line}
                                                    , error-status:get-message(1)
                                                    , return-value
                                                    )).
  return 0 .
end.
end function.
&endif



&if "{1}" = "set-custom-esys-pck-name" &then
FUNCTION context_set-custom-esys-pck-name  returns logical (
                                                      input p-esys-cmd-proc-handle as handle
                                                     ,input p-esys-cmd-code as integer
                                                     ,input p-custom-pck-name as character
                                                     ):
  if valid-handle(p-esys-cmd-proc-handle ) then do:
    run set-custom-esys-pck-name in p-esys-cmd-proc-handle (
                                                            input p-esys-cmd-code
                                                           ,input p-custom-pck-name) no-error .
  if error-status :error
  then do:
    delete procedure p-esys-cmd-proc-handle no-error.
    run set-error in this-procedure ( input substitute("Ошибка при установке спец имени пакета для отсылки во внешнюю систему команды с кодом &1&2&3&2&4"
                                                     , p-cmd-code
                                                     , {&new-line}
                                                     , error-status:get-message(1)
                                                     , return-value
                                                     )).
    return no .
  end.
  return yes.
end.
else do:
  run set-error in this-procedure ( input substitute("Ошибка при установке спец имени пакета для отсылки во внешнюю систему команды с кодом &1&2&3&2&4"
                                                    , p-cmd-code
                                                    , {&new-line}
                                                    , error-status:get-message(1)
                                                    , return-value
                                                    )).
  return no .
end.
end function.
&endif


&if "{1}" = "delete-command" &then
FUNCTION context_delete-command returns logical (
                                                      input p-esys-cmd-proc-handle as handle
                                                     ,input p-esys-cmd-code as integer
                                                     ):
if valid-handle(p-esys-cmd-proc-handle ) then do:
  run delete-command in p-esys-cmd-proc-handle
    (input p-esys-cmd-code /* p-command-code */
    ) no-error.
  if error-status :error
  then do:
    delete procedure p-esys-cmd-proc-handle no-error.
    run set-error in this-procedure ( input substitute("Ошибка при удалении команды с кодом &1&2&3&2&4"
                                                     , p-cmd-code
                                                     , {&new-line}
                                                     , error-status:get-message(1)
                                                     , return-value
                                                     )).
    return no .
  end.
  delete procedure p-esys-cmd-proc-handle no-error.
  return yes.
end.
else do:
  run set-error in this-procedure ( input substitute("Ошибка при удалении команды с кодом &1&2&3&2&4"
                                                    , p-cmd-code
                                                    , {&new-line}
                                                    , error-status:get-message(1)
                                                    , return-value
                                                    )).
  return no .
end.
end function.
&endif



&if "{1}" = "get-thobj-es" &then
{ ref/extclass.i }
FUNCTION context_get-thobj-es returns logical (
                                               input p-esys-id as integer
                                              ,input p-eobj-type as character
                                              ,input p-eobj-code as integer
                                              ,output p-obj-type as character
                                              ,output p-obj-code as integer
                                              ):
define variable v-value-list as character no-undo .
define variable v-field-list as character no-undo .
define buffer buf_clients for ub.clients.
define buffer buf_ext-classif for ub.ext-classif.
find first buf_ext-classif no-lock where
          buf_ext-classif.classif-name = {&extclass_clients_esys}
      and buf_ext-classif.classif-subject = {&table_clients}
      and buf_ext-classif.db-num = 0
      and buf_Ext-classif.key#_one = p-esys-id
      and buf_Ext-classif.charkey_one = p-eobj-type
      and buf_Ext-classif.key#_two = p-eobj-code no-error .
if available buf_Ext-classif then do:
  run gen-key-fv in this-procedure (
                                      input buf_Ext-classif.uniq-key-rec
                                      ,output v-field-list
                                      ,output v-value-list).
    assign
    p-obj-type = entry(lookup("obj-type":U
                                      , v-field-list
                                      , {&delim-key})
                                , v-value-list, {&delim-key})
    p-obj-code = integer(entry(lookup("obj-code":U
                                      , v-field-list
                                      , {&delim-key})
                                , v-value-list, {&delim-key}))
    no-error .
end.
if available buf_ext-classif
and (p-obj-type = {&shop}
     or
     p-obj-type = {&stock}
     )
and (p-obj-code > 0 and p-obj-code <= 99999)
then do:
  find first buf_clients no-lock where
            buf_clients.obj-type = p-obj-type
        and buf_clients.obj-code = p-obj-code no-error.
 if available buf_clients then do:
   return yes.
 end.
 else do:
    assign
    p-obj-type = '':U
    p-obj-code = 0
    .
   return no.
 end.
end.
else do:
  assign
  p-obj-type = '':U
  p-obj-code = 0
  .
  return no.
end.
END FUNCTION.

&endif

&if "{1}" = "begin-nws2esys-command" &then

{ cmp/strcodec.i }
FUNCTION context_begin-nws2esys-command returns logical (
                                                       input p-esys-id as integer
                                                      ,input p-db-num-export as integer
                                                      ,input p-uniq-gate-rec as character
                                                      ,input-output p-esys-cmd-proc-handle as handle
                                                      ,output p-esys-cmd-code as integer
                                                     ):
define variable v-command-name as character no-undo .
define variable v-dst-list as character no-undo .
if g#db-num = p-db-num-export  then do:
  v-command-name = {&cmd-esys-general}.
  v-dst-list = string(p-esys-id).
end.
else do:
  v-command-name = substitute("&2&1&3&1&4&1&5"
                              ,{&delim-cmd}
                              ,{&cmd-nws2esys-general}
                              ,p-esys-id
                              ,p-db-num-export
                              ,str-encode( p-uniq-gate-rec
                                       , "" /*p-encode-char*/
                                       , {&delim-key})
                              ).
  if g#db-num > 0 then do:
    v-dst-list = string(0).
  end.
  else do:
    v-dst-list = string(p-db-num-export).
  end.
end.
if not valid-handle(p-esys-cmd-proc-handle ) then do:
  /* инициализируем библиотеку формирования команды */
  run nws/cmd-bush.p persistent set p-esys-cmd-proc-handle no-error .
  if error-status :error
  then do:
    delete procedure p-esys-cmd-proc-handle .
    run set-error in this-procedure ( substitute("&1 &2 &3&4Ошибка при запуске процедуры cmd-bush.p&4" +
                                        "&5&4&6"
                                        ,vss-workfile
                                        ,vss-revision
                                        ,vss-description
                                        ,{&new-line}
                                        ,error-status:get-message(1)
                                        ,return-value )).
  end.
  /* начало формирования команды */
  run begin-create-command in p-esys-cmd-proc-handle
    (input v-command-name /* p-command-name */
    ,input v-dst-list             /* p-esys-id-list      */
    ,output p-esys-cmd-code        /* p-command-code */
    ) no-error.
  if error-status :error
  then do:
    delete procedure p-esys-cmd-proc-handle .
    run set-error in this-procedure ( input substitute("Ошибка при создании команды &1&2&3&1&4"
                                                     , {&cmd-nws2esys-general}
                                                     , error-status:get-message(1)
                                                     , return-value
                                                     )).
    return no .
  end.
  return yes.
end.
end function.
&endif

&if "{1}" = "send-nws2esys-command" &then

{ cmp/strcodec.i }
FUNCTION context_send-nws2esys-command returns logical (
                                                      input p-esys-id as integer
                                                     ,input p-db-num-export as integer
                                                     ,input p-uniq-gate-rec as character
                                                     ,input p-esys-cmd-proc-handle as handle
                                                     ,input p-esys-cmd-code as integer
                                                     ,input p-user-id as character
                                                     ):
define variable v-dmp-ord-int64 as int64 no-undo .
define variable v-command-name as character no-undo .
define variable v-dst-list as character no-undo .
if g#db-num = p-db-num-export  then do:
  v-command-name = {&cmd-esys-general}.
  v-dst-list = string(p-esys-id).
end.
else do:
  v-command-name = substitute("&2&1&3&1&4&1&5"
                              ,{&delim-cmd}
                              ,{&cmd-nws2esys-general}
                              ,p-esys-id
                              ,p-db-num-export
                              ,str-encode( p-uniq-gate-rec
                                       , "" /*p-encode-char*/
                                       , {&delim-key})
                              ).

  if g#db-num > 0 then do:
    v-dst-list = string(0).
  end.
  else do:
    v-dst-list = string(p-db-num-export).
  end.
end.
if valid-handle(p-esys-cmd-proc-handle ) then do:
  if v-command-name = {&cmd-esys-general} then do:
    run send-command-esys in p-esys-cmd-proc-handle
      (input p-esys-cmd-code /* p-command-code */
      ,input v-dst-list          /* p-esys-id-list      */
      ,input p-user-id        /* p-user-id */
      ,output v-dmp-ord-int64
      ) no-error.
  end.
  else do:
    run send-command in p-esys-cmd-proc-handle
      (input p-esys-cmd-code /* p-command-code */
      ,input v-dst-list          /* p-esys-id-list      */
      ) no-error.
  end.
  if error-status :error
  then do:
    delete procedure p-esys-cmd-proc-handle no-error.
    run set-error in this-procedure ( input substitute("Ошибка при отсылке во внешнюю систему &1 команды с кодом &2&3&4&3&5"
                                                     , p-esys-id
                                                     , p-cmd-code
                                                     , {&new-line}
                                                     , error-status:get-message(1)
                                                     , return-value
                                                     )).
    return no .
  end.
  delete procedure p-esys-cmd-proc-handle no-error.
  return yes.
end.
else do:
  run set-error in this-procedure ( input substitute("Ошибка при отсылке во внешнюю систему &1 команды с кодом &2&3&4&3&5"
                                                    , p-esys-id
                                                    , p-cmd-code
                                                    , {&new-line}
                                                    , error-status:get-message(1)
                                                    , return-value
                                                    )).
  return no .
end.
end function.
&endif


&if "{1}" = "set-esys-command-action" &then
FUNCTION context_set-esys-command-action returns logical (
                                                      input p-esys-cmd-proc-handle as handle
                                                     ,input p-esys-cmd-code as integer
                                                     ,input p-action as character
                                                     ):
if valid-handle(p-esys-cmd-proc-handle ) then do:
  run set-esys-command-action in p-esys-cmd-proc-handle
    (
     input p-esys-cmd-code /* p-command-code */
    ,input p-action
    ) no-error.
  if error-status :error
  then do:
    delete procedure p-esys-cmd-proc-handle no-error.
    run set-error in this-procedure ( input substitute("Ошибка при установке кода действия команды &1 маршрутизации во внешнюю систему &2&3&2&4"
                                                     , p-cmd-code
                                                     , {&new-line}
                                                     , error-status:get-message(1)
                                                     , return-value
                                                     )).
    return no .
  end.
  return yes.
end.
else do:
  run set-error in this-procedure ( input substitute("Ошибка при установке кода действия команды &1 команды маршрутизации во внешнюю систему &2Процедура маршрутизации еще не запущена"
                                                    , p-cmd-code
                                                    , {&new-line}
                                                    )).
  return no .
end.
end function.
&endif




/* $Workfile$ e n d */