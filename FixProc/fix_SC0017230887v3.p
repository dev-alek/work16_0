block-level on error undo, throw.
disable triggers for load of ub.price-doc .
disable triggers for load of ub.price-list .

{ utl/runpro.i }

define input parameter p-doc-num as character no-undo .
define input parameter p-gds-list as character no-undo .
define input parameter p-qnty-list as character no-undo .

define buffer price-doc for ub.price-doc .
define buffer price-list for ub.price-list .
define buffer parts for ub.parts .
define buffer prev_parts for ub.parts .

define variable v-doc-num as character no-undo .
define variable v-gds-code as integer no-undo .
define variable v-qnty as decimal no-undo .

define variable ii as integer no-undo .

if num-entries(p-gds-list) <> num-entries(p-qnty-list)
then do :
  message "Ошибка во входных параметрах!" view-as alert-box .
  return .
end .

v-doc-num = p-doc-num .

find first price-doc no-lock where price-doc.doc-num = v-doc-num no-error .
if not available price-doc
then do :
  message "Переоценка не найдена!" view-as alert-box .
  return .
end .

tr_ :
do trans :

do ii = 1 to num-entries(p-gds-list) :
  v-gds-code = integer(entry(ii, p-gds-list)) .
  v-qnty = decimal(entry(ii, p-qnty-list)) .
  find first price-list exclusive-lock where price-list.doc-num = price-doc.doc-num
                                         and price-list.b-code = v-gds-code
                                         no-error .
  if not available price-list
  then do :
    message substitute("Товар &1 в переоценке не найден!", v-gds-code) view-as alert-box .
    undo tr_, return .
  end .

  assign price-list.doc-qnty = v-qnty .

  find first parts exclusive-lock where parts.out-code  = price-doc.doc-num
                                    and parts.artic     = price-list.artic
                                    and parts.prod-type = price-list.prod-type
                                    and parts.prod-code = price-list.prod-code
                                    and parts.obj-type  = price-list.obj-type
                                    and parts.obj-code  = price-list.obj-code
                                    no-error .
  if available parts
  then do :
    assign
      parts.fact-qnty = v-qnty
      parts.qnty      = v-qnty
      parts.cli-qnty  = parts.fact-qnty / parts.cli-base-rate
    .
  end .
  else do :
    find last prev_parts no-lock where prev_parts.artic     = price-list.artic
                                   and prev_parts.prod-type = price-list.prod-type
                                   and prev_parts.prod-code = price-list.prod-code
                                   and prev_parts.obj-type  = price-list.obj-type
                                   and prev_parts.obj-code  = price-list.obj-code
                                   no-error .
    if available prev_parts
    then do :
      create parts .
      buffer-copy prev_parts to parts
      assign
        parts.out-code = price-doc.doc-num
        parts.doc-type = 'акт'
        parts.supp-type = price-doc.obj-type
        parts.supp-code = price-doc.obj-code
        parts.status_   = yes
        parts.rsrv-free = ?
        parts.fact-qnty = v-qnty
        parts.qnty      = v-qnty
        parts.cli-qnty  = parts.fact-qnty / parts.cli-base-rate
      .
    end .
    for each parts exclusive-lock where parts.out-code  = price-doc.doc-num
                                    and parts.artic     = price-list.artic
                                    and parts.prod-type = price-list.prod-type
                                    and parts.prod-code = price-list.prod-code
                                    and parts.obj-type  = price-list.obj-type
                                    and parts.obj-code <> price-list.obj-code
    :
      delete parts .
    end .
  end .
end .

end .

message "Готово!" view-as alert-box .

