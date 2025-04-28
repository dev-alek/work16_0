disable triggers for load of ub.parts-attr .

{ utl/runpro.i }

define buffer buf_parts-attr for ub.parts-attr .
define buffer buf_trn-doc for ub.trn-doc .

for each buf_parts-attr exclusive-lock where buf_parts-attr.fact-order = 0 :
  for first buf_trn-doc no-lock where buf_trn-doc.doc-code = replace(buf_parts-attr.out-code, "-", "=") :
    buf_parts-attr.fact-order = buf_trn-doc.fact-order .
  end .
end .

message "Готово!" view-as alert-box .
