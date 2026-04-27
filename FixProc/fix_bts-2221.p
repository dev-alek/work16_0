disable triggers for load of ub.price-doc .
disable triggers for load of ub.price-list .
disable triggers for load of ub.doc-attr .
disable triggers for load of ub.price-list-attr .
disable triggers for load of ub.price-doc-forming .

{ utl/runpro.i }

define buffer price-doc for ub.price-doc .
define buffer price-list for ub.price-list .
define buffer doc-attr for ub.doc-attr .
define buffer price-list-attr for ub.price-list-attr .
define buffer price-doc-forming for ub.price-doc-forming .

find first price-doc exclusive-lock where price-doc.status_ = "приказ"
                                      and price-doc.doc-date = 12.01.2026 no-error .
if not available price-doc
then do :
  message 'Не найдена переоценка в статусе "приказ" с датой 01.12.2026 ' view-as alert-box .
  return .
end .
for each price-list exclusive-lock where price-list.doc-num = price-doc.doc-num :
  delete price-list.
end .
for each doc-attr exclusive-lock where doc-attr.doc-code = price-doc.doc-num :
  delete doc-attr.
end.
for each price-list-attr exclusive-lock where price-list-attr.doc-num = price-doc.doc-num :
  delete price-list-attr.
end.
for each price-doc-forming exclusive-lock where price-doc-forming.pdf-id = price-doc.pdf-id
						   and price-doc-forming.pdf-db = price-doc.pdf-db
						   and price-doc-forming.plt-id = price-doc.plt-id
						   and price-doc-forming.plt-db-num = price-doc.plt-db-num :
  delete  price-doc-forming .                        
end.
delete price-doc .

message "Готово!" view-as alert-box .
