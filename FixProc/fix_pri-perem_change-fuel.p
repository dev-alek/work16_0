disable triggers for load of ub.trn-doc .

{ utl/runpro.i }

define input parameter p-doc-code as character no-undo .

find first trn-doc exclusive-lock where trn-doc.doc-code = p-doc-code no-error.
if not available trn-doc
then do :
  message "Не найден документ с кодом " p-doc-code view-as alert-box.
  return.
end.
if trn-doc.ext-doc-type = 'iv'
then do :
  assign
    trn-doc.ext-doc-type = 'ie'
    trn-doc.internal     = false
    trn-doc.rcv-code = ""
    trn-doc.flag_ = no  
  .
end .
else do :
  message "Выбран НЕ внутренний документ!" view-as alert-box .
  return .
end .
release trn-doc .
message "Успешно! Теперь найдите документ во внешнем приходе и удалите его " view-as alert-box .
