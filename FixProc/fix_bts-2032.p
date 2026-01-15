block-level on error undo, throw.
{ utl/runpro.i }
define input parameter p-doc-code as character no-undo .

{ cmp/str-glbl.i }

define buffer buf_trn-doc  for ub.trn-doc .
define buffer buf_doc-line for ub.doc-line .
define variable fact-order like ub.doc-line.fact-order .

find first buf_trn-doc no-lock where buf_trn-doc.doc-code = p-doc-code no-error .
if not available buf_trn-doc
    then 
do :
    message "Не найден документ с номером " p-doc-code view-as alert-box .
    return .
end .

find first ub.doc-line no-lock where ub.doc-line.doc-code = buf_trn-doc.doc-code and ub.doc-line.status_ = {&fact} no-error .
if available (ub.doc-line) then fact-order = ub.doc-line.fact-order .

    for each buf_doc-line exclusive-lock where buf_doc-line.doc-code = buf_trn-doc.doc-code and
        buf_doc-line.status_ <> buf_trn-doc.status_:
            assign
            buf_doc-line.status_ = buf_trn-doc.status_ 
            buf_doc-line.fact-order = fact-order .
    end.           



message "Готово!" view-as alert-box .
