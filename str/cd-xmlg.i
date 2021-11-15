/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Специфические процедуры обработки ПРИЕМА xml почты с касс

Автор: Бахтадзе Наталья Викторовна
Дата создания: 06/22/04
Author: Bakhtadze Natalya
Creation date: 06/22/04

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

{ gbl/cd-attr.i }

define temp-table temp-temp no-undo
field id as character
field ctime as integer
field cr as integer
field record-name as character
field field-name as character
field field-value as character
index iid id ctime
index ifile record-name field-name
index icr is unique primary cr
.
define temp-table temp-temp-attr no-undo
field id as character
field cr  as integer
field cra as integer
field record-name as character
field field-name as character
field attr-name as character
field attr-value as character
index iid id
index icr is unique primary cr cra
.

define variable v-mail-parameters-start     as logical        no-undo.
define variable v-date-format as character no-undo .
define variable v-version as character no-undo .
define variable v-pos-version as character no-undo .
define variable v-from as character no-undo .
define variable v-is-spool-file as logical no-undo .
define variable v-start-err as integer no-undo .
define variable v-num-errors as integer no-undo .
define variable v-dec-sep as character no-undo init ".":U.
define variable v-encoding as character no-undo .
define variable v-db-key-enc as character no-undo .
define variable cri as integer no-undo .
define variable crai as integer no-undo .
define variable v-id as character no-undo .
define variable v-ctrl as character no-undo .
define variable v-time as integer no-undo .
define variable v-time-char as character no-undo .
define variable v-cd-fatal-error as logical no-undo .
define variable v-cd-fatal-message as character no-undo .
define variable v-errorSeverity as integer no-undo .
define variable v-errormessage as character no-undo .
define variable v-errornum as character no-undo .


PROCEDURE get-xml-ibm-c.
define input parameter p-filename as char no-undo.

define variable v-new-filename-full     as character         no-undo.
define variable v-xml-buffer as character no-undo.
define variable v-my-string as character no-undo .
define variable v-read-char as character no-undo .
define buffer buf_cash-desk for ub.cash-desk.

&if "{1}" = "spool" &then
run get-ibm-parameters in this-procedure no-error.
if error-status:error then do:
  assign
  p-view-log = yes
  .
  run write-log-and-file in p-log-handle (
        input 1
      , input log-file-name
      , input 1
      , input substitute( "!!!При обработке файла &1 произошла ошибка при получении значений настроечных параметров: &2"
                          , p-filename
                          , return-value
                        )
                                        ).
  undo, return .
end.
&endif
run gbl/filename.p (
              input p-filename
              ,output v-full-path
              ,output v-path
              ,output v-file-name
              ,output v-file-name-no-ext
              ,output v-file-name-ext
              ) no-error .
if error-status:error then do:
  assign
  p-view-log = yes
  .
  run write-log-and-file in p-log-handle (
        input 1
      , input log-file-name
      , input 1
      , input substitute( "!!!При обработке файла &1 произошла ошибка при получении полного пути файлу: &2"
                          , p-filename
                          , return-value
                        )
                                  ).
  return.
end.
error-status:error = FALSE.
if p-encoding = "utf-8":U  then  do:
  input stream ChkStream from value( p-filename ) convert source "utf-8".
end.
else do:
  input stream ChkStream from value( p-filename ) /*convert target "utf-8"*/.
end.
_repeat:
REPEAT :
  if v-exit-processing then leave _repeat.
  _line:
  DO TRANSACTION:
    import stream Chkstream unformatted  v-xml-buffer  .
    if v-xml-buffer = "":U then do:
      NEXT _repeat.
    end.
    /*
    _readkey:
    repeat:
      readkey stream ChkStream.
      if lastkey = - 2 then leave _repeat.
      v-read-char = chr(lastkey).

      if v-read-char = ">" then do:
        assign
        v-my-string = v-my-string + v-read-char
        v-xml-buffer = v-my-string
        v-my-string = "":U
        .
        LEAVE _readkey.
      end.
      else do:
        assign
        v-my-string = v-my-string + v-read-char
        .
      end.
    end. /*_readkey:*/
    */
    assign
    var-file-line-num = var-file-line-num + 1
    .
    if left-trim(v-xml-buffer)  begins "<?xml":U then do:
      assign
      v-encoding = cb-xmlparse-get-attr(
                              input this-procedure:handle
                             ,input "xml":U
                             ,input trim(v-xml-buffer, "?>")
                             ,input "encoding":U
                             ,input yes)
     .
     if v-encoding <> p-encoding
     then do:
        run write-log-and-file in p-log-handle (
              input 1
            , input log-file-name
            , input 1
            , input substitute( "!!!Ошибка чтения файла &1: кодировка НЕ &2"
                                , p-filename
                                , p-encoding
                              )
                                            ).
      assign
      p-view-log = yes
      .
      undo, return .
     end.
    end.
    run xmlvalid in this-procedure (
          input this-procedure:handle
        , input v-xml-buffer
        , input 'fatal':u
    ) no-error .
    if error-status:error  then do:
        run write-log-and-file in p-log-handle (
              input 1
            , input log-file-name
            , input 1
            , input substitute( "!!!Ошибка импорта файла &1: &2"
                                , p-filename
                                , return-value
                              )
                                            ).
      assign
      p-view-log = yes
      .
      undo, return .
    end.
    if v-cd-fatal-error then do:
      run write-log-and-file in p-log-handle (
            input 1
          , input log-file-name
          , input 1
          , input substitute( "!!!Файл &1 строка &2 фатальные ошибки: &3 - импорт прекращен"
                              , p-filename
                              , var-file-line-num
                              , v-cd-fatal-message
                            )
                                          ).
      assign
      p-view-log = yes
      .
      undo, return.
    end.
    if var-file-line-num modulo 100 = 0 then do:
      run show-counter in p-log-handle .
      run write-counter in p-log-handle (substitute("Файл &1: прочитано строк &2", p-filename, var-file-line-num)).
    end.
  END .
end.
&if "{1}" = "spool" &then
DO TRANSACTION:
  run proc-end in this-procedure no-error .
END.
assign
error-status:error = false.
input stream ChkStream close.
for each temp-cash-desk:
  find first buf_cash-desk no-lock where
            buf_cash-desk.db-num = g#db-num
        AND buf_cash-desk.obj-code = p-obj-code
        AND buf_cash-desk.pos-type = p-pos-type
        AND buf_cash-desk.cash-num = temp-cash-desk.cash-num no-error .
  if available buf_cash-desk then do:
  run cd-attr-write in this-procedure (
                                          input g#db-num
                                         ,input p-obj-code
                                        ,input p-pos-type
                                        ,input temp-cash-desk.cash-num
                                        ,input (if buf_cash-desk.pos-type = {&cd-type-ibm-xml}
                                                then {&cda-ibm-xml_operative}
                                                else if  buf_cash-desk.pos-type = {&cd-type-autotank}
                                                then {&cda-autotank_operative}
                                                else {&cda-magia-xml_operative})
                                        ,input (if buf_cash-desk.pos-type = {&cd-type-ibm-xml}
                                                then {&cda-ibm-xml_operative_last-check-params}
                                                else if  buf_cash-desk.pos-type = {&cd-type-autotank}
                                                then {&cda-autotank_operative_last-check-params}
                                                else {&cda-magia-xml_operative_last-check-date-time}
                                               )
                                        ,input (cd-attr-CD-DatetoString (temp-cash-desk.last-date) + {&space-char}  +  string(temp-cash-desk.last-time, "HH:MM:SS":U)
                                             +  (if buf_cash-desk.pos-type = {&cd-type-ibm-xml}
                                                 or buf_cash-desk.pos-type = {&cd-type-autotank}
                                               then ({&space-char} + string(temp-cash-desk.last-shift-num) +
                                                      {&space-char} + string(temp-cash-desk.last-z-count) +
                                                      {&space-char} + string(temp-cash-desk.last-chk-num))
                                               else  "":U)
                                               )
                                        ,input ?
                                        ,input 0.0
                                        ,input 0
                                        ,input no
                                        ) no-error.
end.
end.
&else
input stream ChkStream close.
&endif
END PROCEDURE.




procedure cb-xmlparse-tag-start-Header :
/* обработка события "начало Header"*/

do
on error undo, return error
:
  assign
      v-mail-parameters-start = yes
  .

end.

end procedure. /* cb-xmlparse-tag-start-Header */

procedure cb-xmlparse-tag-end-Header :
/* обработка события "конец Header"*/

do
on error undo, return error
:
  assign
      v-mail-parameters-start = no
  .

end.

end procedure. /* cb-xmlparse-tag-start-Header */


procedure cb-xmlparse-tag-start-{1} :
define input parameter p-parameter as character no-undo .
define variable v-file-type as character no-undo .
define variable v-adresat as character no-undo .
define variable v-FO-version as character no-undo .
define variable v-old-fo-version as character no-undo .
define variable v-pay-desk as integer no-undo .
define variable v-dop as character no-undo .
define variable v-date as date no-undo .
define variable v-decimal as decimal no-undo .
define variable v-integer as integer no-undo .
define variable v-logical as logical no-undo .
define variable v-err-message as character no-undo .

do
on error undo, return error
:
  if v-is-spool-file = no then do:
    assign
    v-file-type = cb-xmlparse-get-attr(
                              input this-procedure:handle
                             ,input p-spool-or-data
                             ,input p-parameter
                             ,input "type":U
                             ,input yes)
    v-adresat =  cb-xmlparse-get-attr(
                              input this-procedure:handle
                             ,input p-spool-or-data
                             ,input p-parameter
                             ,input "to":U
                             ,input no)
    &if "{1}" = "spool" &then
    v-pos-version =  cb-xmlparse-get-attr(
                              input this-procedure:handle
                             ,input p-spool-or-data
                             ,input p-parameter
                             ,input "version":U
                             ,input no)
    v-from =  cb-xmlparse-get-attr(
                              input this-procedure:handle
                             ,input p-spool-or-data
                             ,input p-parameter
                             ,input "from":U
                             ,input no)
    v-FO-version =  cb-xmlparse-get-attr(
                              input this-procedure:handle
                             ,input p-spool-or-data
                             ,input p-parameter
                             ,input "release":U
                             ,input no)
    &endif
    .

    if v-file-type = "REPLY":U AND
    (v-adresat begins ({&shop} + string(p-obj-code))
&if "{1}" = "data" &then
     or v-adresat begins ("БД" + string(g#db-num))
     or p-spool-or-data = "config"
     or p-spool-or-data = "control"
&endif
    )
    then do:
    assign
    v-is-spool-file = yes
    .
      if v-from begins ({&shop} + string(p-obj-code) + "_" + "касса") then do:
        v-pay-desk = integer(replace(v-from, ({&shop} + string(p-obj-code) + "_" + "касса"), "")) no-error.
        run cd-attr-value in this-procedure (
                                              input  g#db-num
                                              ,input  p-obj-code
                                              ,input  p-pos-type
                                              ,input  v-pay-desk
                                              ,input  (if p-pos-type = {&cd-type-IBM-XML}
                                                      then {&cda-IBM-XML_operative}
                                                      else {&cda-AUTOTANK_operative})
                                              ,input  (if p-pos-type = {&cd-type-IBM-XML}
                                                       then {&cda-IBM-XML_operative_fo-version}
                                                       else {&cda-AUTOTANK_operative_fo-version})
                                              ,output v-old-fo-version
                                              ,output v-date
                                              ,output v-decimal
                                              ,output v-integer
                                              ,output v-logical
                                              ,output v-dop) no-error.
       if v-old-fo-version <> v-fo-version
       and can-find(first ub.cash-desk where
                         ub.cash-desk.db-num = g#db-num
                     and ub.cash-desk.obj-code = p-obj-code
                     and ub.cash-desk.pos-type = p-pos-type
                     and ub.cash-desk.cash-num = v-pay-desk)
       then do:
         do transaction :
            run cd-attr-write in this-procedure (
                                                    input g#db-num
                                                  ,input p-obj-code
                                                  ,input p-pos-type
                                                  ,input v-pay-desk
                                                  ,input  (if p-pos-type = {&cd-type-ibm-xml}
                                                           then {&cda-IBM-XML_operative}
                                                           else {&cda-AUTOTANK_operative})
                                                  ,input (if p-pos-type = {&cd-type-IBM-XML}
                                                          then {&cda-IBM-XML_operative_fo-version}
                                                          else {&cda-AUTOTANK_operative_fo-version})
                                                  ,input v-fo-version
                                                  ,input ? /*p-date*/
                                                  ,input 0 /*p-decimal*/
                                                  ,input 0 /*p-integer*/
                                                  ,input no /*p-logical*/
                                                  ) no-error.
            if error-status:error then do :
              v-err-message = return-value . // чтобы видеть текст сообщения в деббагере
              run write-log-and-file in p-log-handle (
            input 1
          , input log-file-name
          , input 1
          , input v-err-message
                                          ).
              p-view-log = yes .
            end .                                      
          end. /*  do transaction :*/
        end. /*if v-old-fo-version <> v-fo-version then do:*/
      end. /*if v-from begins ({&shop} + string(p-obj-code) + "_" + "касса") then do:*/
    end.
    else do:
      run write-log-and-file in p-log-handle (
            input 1
          , input log-file-name
          , input 1
          , input substitute( "!!!В директории приема файлов обнаружен файл с неизвестным адресатом: &1 и/или неизвестного типа: &2"
                              , v-adresat
                              , v-file-type
                            )
                                          ).
      assign
      p-view-log = yes
      v-exit-processing = yes
      .
    end.
  end.
  else do:
      run write-log-and-file in p-log-handle (
            input 1
          , input log-file-name
          , input 1
          , input substitute( "!!!Нарушение протокола обмена : тэг <&1>", p-spool-or-data
                            )
                                          ).
      assign
      p-view-log = yes
      .
  end.
end.

end procedure. /* cb-xmlparse-tag-start-spool */


procedure cb-xmlparse-tag-start-config :
define input parameter p-parameter as character no-undo .
  run cb-xmlparse-tag-start-{1} in this-procedure ( input p-parameter) no-error.
  if error-status:error then return error return-value .
end procedure.

procedure cb-xmlparse-tag-start-control :
define input parameter p-parameter as character no-undo .
  run cb-xmlparse-tag-start-{1} in this-procedure ( input p-parameter) no-error.
  if error-status:error then return error return-value .
end procedure.


procedure cb-xmlparse-tag-end-{1} :
define input parameter p-parameter as character no-undo .

do
on error undo, return error
:
  assign
  v-is-spool-file = no
  .
  end.

end procedure. /* cb-xmlparse-tag-end-{1} */


procedure cb-xmlparse-tag-end-config :
define input parameter p-parameter as character no-undo .
run cb-xmlparse-tag-end-{1}  in this-procedure ( input p-parameter) no-error.
if error-status:error then return error return-value .

end procedure. /* cb-xmlparse-tag-end-config */

procedure cb-xmlparse-tag-end-control :
define input parameter p-parameter as character no-undo .
run cb-xmlparse-tag-end-{1}  in this-procedure ( input p-parameter) no-error.
if error-status:error then return error return-value .

end procedure. /* cb-xmlparse-tag-end-control */



procedure cb-xmlparse-tag-start-{2} :
define input parameter p-parameter as character no-undo .
do
on error undo, return error
:
  if v-is-spool-file = yes then do:
      run write-log-and-file in p-log-handle (
            input 1
          , input log-file-name
          , input 1
          , input substitute( "!!!Нарушение протокола обмена : тэг <&1>",
&if "{2}" = "data" &then
 "data":U
&else
 "spool":U
&endif
                           )
                                          ).
      assign
      p-view-log = yes
      .
  end.
  else do:
    assign
    v-exit-processing = yes
    .
    /*это файл не того типа, что мы ищем*/
  end.
end.

end procedure. /* cb-xmlparse-tag-start-{2} */

procedure cb-xmlparse-tag-end-{2} :
define input parameter p-parameter as character no-undo .

do
on error undo, return error
:
end.

end procedure. /* cb-xmlparse-tag-end-{2} */


procedure cb-xmlparse-tag-start-error:
define input parameter p-parameter as character no-undo .
run cb-xmlparse-tag-start-err in this-procedure ( input p-parameter)  .
end procedure .


procedure cb-xmlparse-tag-end-error :
define input parameter p-parameter as character no-undo .
run cb-xmlparse-tag-end-err in this-procedure ( input p-parameter)  .
end procedure .


procedure cb-xmlparse-tag-end-ErrorMessage :
define input parameter p-parameter as character no-undo .
assign
v-ErrorMessage = v-xmlvalid-tag-value
.
if p-pos-type = {&cd-type-IBM-XML}
or p-pos-type = {&cd-type-autotank}
then do:
    run write-log-and-file in p-log-handle (
          input 1
        , input log-file-name
        , input 1
        , input substitute( "!!!&1"
                            ,v-ErrorMessage
                          )
                                        ).
    assign
    p-view-log = yes
    .
end.
end procedure .

procedure cb-xmlparse-tag-end-ErrorSeverity :
define input parameter p-parameter as character no-undo .
assign
v-Errorseverity = integer(v-xmlvalid-tag-value)
no-error
.
if p-pos-type = {&cd-type-IBM-XML}
or p-pos-type = {&cd-type-autotank}
then do:
    run write-log-and-file in p-log-handle (
          input 1
        , input log-file-name
        , input 1
        , input substitute( "!!!&1"
                          , (if v-errorseverity = 0
                              then "Информация"
                              else (if v-Errorseverity = 1
                                    then "Предупреждение"
                                    else "Ошибка"
                                    )
                              ))
                              ).
    assign
    p-view-log = yes
    .
end.

end procedure .



procedure cb-xmlparse-tag-start-err:
define input parameter p-parameter as character no-undo .
/* обработка события "начало Err"*/

do
on error undo, return error
:
  if v-is-spool-file
  then do:
    assign
    v-start-err = v-start-err + 1
    v-num-errors = v-num-errors + 1
    v-errormessage = '':U
    v-errorseverity = 0
    v-errornum = '':U
    .
    if p-pos-type = {&cd-type-MAGIA-XML} then do:
      assign
      v-ErrorMessage = cb-xmlparse-get-attr(
                                input this-procedure:handle
                              ,input p-spool-or-data
                              ,input p-parameter
                              ,input "ErrorMessage":U
                              ,input yes)
      v-ErrorNum =  cb-xmlparse-get-attr(
                                input this-procedure:handle
                              ,input p-spool-or-data
                              ,input p-parameter
                              ,input "Error":U
                              ,input no)
      v-ErrorSeverity =  integer(cb-xmlparse-get-attr(
                                input this-procedure:handle
                              ,input p-spool-or-data
                              ,input p-parameter
                              ,input "ErrorSeverity":U
                              ,input no))
      no-error
      .
      run write-log-and-file in p-log-handle (
            input 1
          , input log-file-name
          , input 1
          , input substitute( "!!!&1: &2 &3                   Код &4"
                              , (if v-errorseverity = 0
                                then "Информация"
                                else (if v-Errorseverity = 1
                                      then "Предупреждение"
                                      else "Ошибка"
                                      )
                                )
                              , v-ErrorMessage
                              , {&new-line}
                              , v-ErrorNum
                            )
                                          ).
      assign
      p-view-log = yes
      .
    end.
  end.
  else do:
      run write-log-and-file in p-log-handle (
            input 1
          , input log-file-name
          , input 1
          , input substitute( "!!!Нарушение протокола обмена : тэг Err", p-spool-or-data
                            )
                                          ).
      assign
      p-view-log = yes
      .
    /*todo ошибка*/
  end.
end.

end procedure. /* cb-xmlparse-tag-start-err */

procedure cb-xmlparse-tag-end-err :
define input parameter p-parameter as character no-undo .
/* обработка события "конец err"*/

do
on error undo, return error
:
  if p-pos-type = {&cd-type-magia-xml} then do:
    /*если мы здесь то кончился err !!!*/
    if v-start-err =  1 then do:
      assign
      v-start-err = 0
      .
      /*разберем на атрибуты*/

    end.
    else do:
      assign
      v-start-err = v-start-err - 1
      .
      /*todo ошибка*/
    end.
  end.
  if p-pos-type = {&cd-type-ibm-xml}
  or p-pos-type = {&cd-type-autotank}
  then do:
    assign
    v-errornum = v-xmlvalid-tag-value
    no-error .
    run write-log-and-file in p-log-handle (
          input 1
        , input log-file-name
        , input 1
        , input substitute( "!!!           Код &1"
                            , v-ErrorNum  )
                                        ).

    assign
    p-view-log = yes
    .
  end.
end.

end procedure. /* cb-xmlparse-tag-end-err */




PROCEDURE fill-doc-property :
/*------------------------------------------------------------------------------
Purpose:
Parameters:  <none>
Notes:
------------------------------------------------------------------------------*/
do
on error undo, return error
:
define input parameter p-tag-name   as character    no-undo.
define input parameter p-tag-value  as character    no-undo.
define buffer buf_db for ub.db.

if v-mail-parameters-start = yes
then do:
  CASE p-tag-name:
    when "DocumentName":U
    then do:
      if p-tag-value = p-spool-or-data then do:
      end.
      else do:
        /*нечто нам не нужное уходим совсем*/
      end.
    end.
    when "DateFormat":U
    then do:
      assign
      v-date-format = p-tag-value
      .
    end.
    when "DocumentVersion":U
    then do:
      assign
      v-version = p-tag-value
      .
    end.
    when "DecimalSeparator":U
    then do:
      assign
      v-dec-sep = p-tag-value
      .
    end.
    when "objList":U then do:

    end.
    when "dbEncKey":U then do:
      assign
      v-db-key-enc = p-tag-value
      .
      find first buf_db where buf_db.db-num = g#db-num no-lock.
      if buf_db.db-key-enc = v-db-key-enc then do:
        return error
        substitute("Кодир. значение ключа БД-приемника &1 совпадает с кодир. значением ключа БД-источника &2&3- импорт данных со своей БД на свою БД невозможен"
                   , buf_Db.db-key-enc
                   , v-db-key-enc
                   , {&new-line}).
      end.
    end.
  end case.
end.        /* v-mail-parameters-start = yes */
end.
end PROCEDURE.

procedure create-temp-table-record :
define input parameter p-record-name as character no-undo .
define input parameter p-field-name as character no-undo .
define input parameter p-field-value as character no-undo .

  do
  on error undo, return error
  :
    find first temp-temp where
               temp-temp.cr = cri + 1 no-error .
    if not avail temp-temp then do:
      create
      temp-temp.
      assign
      temp-temp.cr = cri + 1
      .
    end.
    assign
    temp-temp.record-name = p-record-name
    temp-temp.field-name  = p-field-name
    temp-temp.field-value = p-field-value
    temp-temp.id          = v-id
    temp-temp.ctime       = v-time
    cri                   = cri + 1
    .
    /*
    if index(p-field-value, '<':U) > 0 then do:
    end.
    output to jj.txt append.
    export temp-temp .
    output close.
    */
  end.

end procedure. /* create-temp-table-record */



/* $Workfile$ e n d */