/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

ДНЦ

Автор: Чернова Светлана Александровна
Дата создания: 06/08/06
Author: Svetlana Chernova
Creation date: 06/08/06

*/
&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

DO counter = 1 TO l-counter
on error  undo, return error
on endkey undo, return error :

  { nws/imps-nws.i rec-full }

  assign
    rec-name = entry( 1, rec-full, {&delim-nws} )
    .

  {&test-count}

  CASE rec-name :
    when "utd-attr" then do:
      create locb-utd-attr.
      { nws/impl-nws.i "utd-attr" "locb-" }
    end.
    when "utd-lines" then do:
      create locb-utd-lines.
      { nws/impl-nws.i "utd-lines" "locb-" }
    end.
    when "utd-lines-attr" then do:
      create locb-utd-lines-attr.
      { nws/impl-nws.i "utd-lines-attr" "locb-" }
    end.
    when "utd-err" then do:
      create locb-utd-err.
      { nws/impl-nws.i "utd-err" "locb-" }
    end.
    when "utd-err-attr" then do:
      create locb-utd-err-attr.
      { nws/impl-nws.i "utd-err-attr" "locb-" }
    end.
    when "marking" then do:
      create locb-marking.
      { nws/impl-nws.i "marking" "locb-" }
    end.
    when "marking-attr" then do:
      create locb-marking-attr.
      { nws/impl-nws.i "marking-attr" "locb-" }
    end.
    when "utd-marking-lines" then do:
      create locb-utd-marking-lines.
      { nws/impl-nws.i "utd-marking-lines" "locb-" }
    end.
    when "utd-marking-lines-attr" then do:
      create locb-utd-marking-lines-attr.
      { nws/impl-nws.i "utd-marking-lines-attr" "locb-" }
    end.
    when "utd-lines" then do:
      create locb-utd-lines.
      { nws/impl-nws.i "utd-lines" "locb-" }
    end.
    when "utd-lines-attr" then do:
      create locb-utd-lines-attr.
      { nws/impl-nws.i "utd-lines-attr" "locb-" }
    end.
    otherwise do:
      message "Не предуcмотрен прием таблицы " rec-name skip
              "в cоcтаве куcта."
              view-as alert-box error.
      return error.
    end.
  END CASE.
end.

subscribe "getNextseq" anywhere run-procedure "MySeqForUtd".
MySeqUtd = ?.
/* ------------------------------- utd-attr ---------------------------------------------- */
for each buf_utd-attr where buf_utd-attr.db-num     = wt-utd.db-num
                                   and buf_utd-attr.doc-id = wt-utd.doc-id

on error  undo, return error
:
  delete buf_utd-attr.
  validate buf_utd-attr no-error.
  if error-status:error
  then
     return error return-value.
end.
for each locb-utd-attr where locb-utd-attr.db-num     = wt-utd.db-num
                                   and locb-utd-attr.doc-id = wt-utd.doc-id

no-lock
on error  undo, return error
:
  create buf_utd-attr.
  buffer-copy locb-utd-attr to buf_utd-attr.
  validate buf_utd-attr  no-error.
  if error-status:error
  then
     return error return-value.
end.


/* ------------------------------- utd-lines ---------------------------------------------- */
for each buf_utd-lines where buf_utd-lines.db-num     = wt-utd.db-num
                                   and buf_utd-lines.doc-id = wt-utd.doc-id

on error  undo, return error
:
  delete buf_utd-lines.
  validate buf_utd-lines no-error.
  if error-status:error
  then
     return error return-value.
end.
for each locb-utd-lines where locb-utd-lines.db-num     = wt-utd.db-num
                                   and locb-utd-lines.doc-id = wt-utd.doc-id

no-lock
on error  undo, return error
:
  create buf_utd-lines.
  buffer-copy locb-utd-lines to buf_utd-lines.
  validate buf_utd-lines no-error.
  if error-status:error
  then
     return error return-value.
end.
/* ------------------------------- utd-lines-attr ---------------------------------------------- */
for each buf_utd-lines-attr where buf_utd-lines-attr.db-num     = wt-utd.db-num
                                   and buf_utd-lines-attr.doc-id = wt-utd.doc-id

on error  undo, return error
:
  delete buf_utd-lines-attr.
  validate buf_utd-lines-attr no-error.
  if error-status:error
  then
     return error return-value.
end.
for each locb-utd-lines-attr where locb-utd-lines-attr.db-num     = wt-utd.db-num
                                   and locb-utd-lines-attr.doc-id = wt-utd.doc-id

no-lock
on error  undo, return error
:
  create buf_utd-lines-attr.
  buffer-copy locb-utd-lines-attr to buf_utd-lines-attr.
  validate buf_utd-lines-attr no-error.
  if error-status:error
  then
     return error return-value.
end.

/* ------------------------------- utd-err ---------------------------------------------- */
for each buf_utd-err where buf_utd-err.db-num     = wt-utd.db-num
                                   and buf_utd-err.doc-id = wt-utd.doc-id

on error  undo, return error
:
  delete buf_utd-err.
  validate buf_utd-err no-error.
  if error-status:error
  then
     return error return-value. 
end.

for each locb-utd-err where locb-utd-err.db-num     = wt-utd.db-num
                                    and locb-utd-err.doc-id = wt-utd.doc-id

no-lock
on error  undo, return error
:
  create buf_utd-err.
  buffer-copy locb-utd-err to buf_utd-err.
  validate buf_utd-err no-error.
  if error-status:error
  then
     return error return-value. 
end.

/* ------------------------------- utd-err-attr ---------------------------------------------- */
for each buf_utd-err-attr where buf_utd-err-attr.db-num     = wt-utd.db-num
                                   and buf_utd-err-attr.doc-id = wt-utd.doc-id

on error  undo, return error
:
  delete buf_utd-err-attr.
  validate buf_utd-err-attr no-error.
  if error-status:error
  then
     return error return-value.
end.

for each locb-utd-err-attr where locb-utd-err-attr.db-num     = wt-utd.db-num
                                    and locb-utd-err-attr.doc-id = wt-utd.doc-id

no-lock
on error  undo, return error
:
  create buf_utd-err-attr.
  buffer-copy locb-utd-err-attr to buf_utd-err-attr.
  validate buf_utd-err-attr no-error.
  if error-status:error
  then
     return error return-value.
end.

/* ------------------------------- utd-marking-lines ---------------------------------------------- */
for each buf_utd-marking-lines where buf_utd-marking-lines.db-num     = wt-utd.db-num
                                   and buf_utd-marking-lines.doc-id = wt-utd.doc-id

on error  undo, return error
:
  delete buf_utd-marking-lines.
  validate buf_utd-marking-lines no-error.
  if error-status:error
  then
     return error return-value.
end.

for each locb-utd-marking-lines where locb-utd-marking-lines.db-num     = wt-utd.db-num
                                    and locb-utd-marking-lines.doc-id = wt-utd.doc-id

no-lock
on error  undo, return error
:
  create buf_utd-marking-lines.
  buffer-copy locb-utd-marking-lines to buf_utd-marking-lines.
  validate buf_utd-marking-lines no-error.
  if error-status:error
  then
     return error return-value.
  for each locb-marking where locb-marking.mark     = buf_utd-marking-lines.mark
  no-lock
  on error  undo, return error
  :
    find first buf_marking where buf_marking.mark = locb-marking.mark no-error.
    if not available buf_marking
      then create buf_marking.
    buffer-copy locb-marking to buf_marking.
    validate buf_marking no-error.
  if error-status:error
  then
     return error return-value.
    for each locb-marking-attr where locb-marking-attr.mark     = buf_utd-marking-lines.mark
      no-lock
      on error  undo, return error
      :
        find first buf_marking-attr where buf_marking-attr.mark = locb-marking-attr.mark and buf_marking-attr.attr-code = locb-marking-attr.attr-code no-error.
        if not available buf_marking-attr
          then create buf_marking-attr.
        buffer-copy locb-marking-attr to buf_marking-attr.
        validate buf_marking-attr no-error.
  if error-status:error
  then
     return error return-value.
    end.
  end.
end.



/* ------------------------------- utd-marking-lines-attr ---------------------------------------------- */
for each buf_utd-marking-lines-attr where buf_utd-marking-lines-attr.db-num     = wt-utd.db-num
                                   and buf_utd-marking-lines-attr.doc-id = wt-utd.doc-id

on error  undo, return error
:
  delete buf_utd-marking-lines-attr.
  validate buf_utd-marking-lines-attr no-error.
  if error-status:error
  then
     return error return-value.
end.

for each locb-utd-marking-lines-attr where locb-utd-marking-lines-attr.db-num     = wt-utd.db-num
                                    and locb-utd-marking-lines-attr.doc-id = wt-utd.doc-id

no-lock
on error  undo, return error
:
  create buf_utd-marking-lines-attr.
  buffer-copy locb-utd-marking-lines-attr to buf_utd-marking-lines-attr.
  validate buf_utd-marking-lines-attr no-error.
  if error-status:error
  then
     return error return-value.
end.

/* ------------------------------- utd-lines ---------------------------------------------- */
for each buf_utd-lines where buf_utd-lines.db-num     = wt-utd.db-num
                                   and buf_utd-lines.doc-id = wt-utd.doc-id

on error  undo, return error
:
  delete buf_utd-lines.
  validate buf_utd-lines no-error.
  if error-status:error
  then
     return error return-value.
end.

for each buf_utd-lines-attr where buf_utd-lines-attr.db-num     = wt-utd.db-num
                                   and buf_utd-lines-attr.doc-id = wt-utd.doc-id

on error  undo, return error
:
  delete buf_utd-lines-attr.
  validate buf_utd-lines-attr no-error.
  if error-status:error
  then
     return error return-value.
end.


for each locb-utd-lines where locb-utd-lines.db-num     = wt-utd.db-num
                                    and locb-utd-lines.doc-id = wt-utd.doc-id

no-lock
on error  undo, return error
:
  create buf_utd-lines.
  buffer-copy locb-utd-lines to buf_utd-lines.
  validate buf_utd-lines no-error.
  if error-status:error
  then
     return error return-value.
end.

for each locb-utd-lines-attr where locb-utd-lines-attr.db-num     = wt-utd.db-num
                                    and locb-utd-lines-attr.doc-id = wt-utd.doc-id

no-lock
on error  undo, return error
:
  create buf_utd-lines-attr.
  buffer-copy locb-utd-lines-attr to buf_utd-lines-attr.
  validate buf_utd-lines-attr no-error.
  if error-status:error
  then
     return error return-value.
end.

/* ------------------------------- utd ---------------------------------------------- */
if not available tb-utd then do:
  create tb-utd.
end.

buffer-copy wt-utd to tb-utd.
validate tb-utd no-error.
  if error-status:error
  then
     return error return-value.
unsubscribe "getNextseq".

define variable objSrv as class ibs.th.gbl.sys.objsrv no-undo.
run gbl/getobjsrvhndl.p (input-output ObjSrv).
if g#db-num ne 0 and tb-utd.doc-code = "" and tb-utd.sts = objSrv:Env:Utd:Sts:TH:Confirmed:KeyIntDB 
  and (tb-utd.EDocType = objSrv:Env:Utd:EDocType:UTD:KeyIntDB)
then do:
  def var v-file-name as character no-undo.
  def var v-msg as character no-undo.
  run ibs\th\str\utd\adaputd.p
    (tb-utd.db-num, /*db-num*/
    tb-utd.doc-id, /* doc-id*/
    g#userid /*User-Id*/
    ) no-error.
  if not error-status:error
  then do:
    if return-value matches "*ошибка*"
    then v-msg = substitute ('MsgBox "Документ № &1 от &2. Сформирована ПН: &3. &4", ,"Получен УПД"', tb-utd.DocumentNumber, string (tb-utd.DocumentDate) , tb-utd.doc-code, return-value).
    else v-msg = substitute ('MsgBox "Документ № &1 от &2. Сформирована ПН: &3. &5 &4", ,"Получен УПД"', tb-utd.DocumentNumber, string (tb-utd.DocumentDate) , tb-utd.doc-code, return-value, "Товары данной поставки можно продавать на кассе.").
  end.
    else v-msg = substitute ('MsgBox "Документ: &1 от &2. Ошибка при формирование ПН &3. &4", ,"Получен УПД"', tb-utd.DocumentNumber, string (tb-utd.DocumentDate), return-value).
  
  v-file-name = string (guid(generate-uuid)) + ".vbs".
  output to value (v-file-name).
  put unformatted v-msg. 
  output close.
  file-info:file-name = (v-file-name).    
  os-command no-wait value (file-info:full-pathname).

end.

if g#db-num ne 0 and tb-utd.sts = objSrv:Env:Utd:Sts:TH:Confirmed:KeyIntDB and tb-utd.EDocType = objSrv:Env:Utd:EDocType:Introduce:KeyIntDB
then do:
    v-msg = substitute ('MsgBox "Документ № &1 от &2. &3Обратитесь в Техническую поддержку.", ,"Получен документ первоначального ввода."', tb-utd.DocumentNumber, string (tb-utd.DocumentDate),  '" & vbCrLf &  "').
    v-file-name = string (guid(generate-uuid)) + ".vbs".
    output to value (v-file-name).
    put unformatted v-msg. 
    output close.
    file-info:file-name = (v-file-name).    
    os-command no-wait value (file-info:full-pathname).
end.


/*------------------------- почиcтим за cобой ----------------------------------------------- */

for each locb-utd-lines
on error  undo, return error
:
  delete locb-utd-lines.
end.

for each locb-utd-err
on error  undo, return error
:
  delete locb-utd-err.
end.

for each locb-marking
on error  undo, return error
:
  delete locb-marking.
end.

for each locb-utd-marking-lines
on error  undo, return error
:
  delete locb-utd-marking-lines.
end.
release tb-utd.

for each locb-utd-lines-attr
on error  undo, return error
:
  delete locb-utd-lines-attr.
end.

for each locb-utd-err-attr
on error  undo, return error
:
  delete locb-utd-err-attr.
end.

for each locb-marking-attr
on error  undo, return error
:
  delete locb-marking-attr.
end.

for each locb-utd-marking-lines-attr
on error  undo, return error
:
  delete locb-utd-marking-lines-attr.
end.

for each locb-utd-attr
on error  undo, return error
:
  delete locb-utd-attr.
end.


/* $Workfile$ e n d */