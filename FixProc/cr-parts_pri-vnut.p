block-level on error undo, throw.
{ utl/runpro.i }
define input parameter p-doc-code as character no-undo .
define input parameter p-gds-code as character no-undo .
{ cmp/str-glbl.i }

define buffer buf_trn-doc for ub.trn-doc .
define buffer buf_goods for ub.goods .
define buffer buf_doc-line for ub.doc-line .
define buffer buf_parts for ub.parts .

find first buf_trn-doc no-lock where buf_trn-doc.doc-code = p-doc-code no-error .
if not available buf_trn-doc
then do :
  message "Не найден документ с номером " p-doc-code view-as alert-box .
  return .
end .

find first buf_goods no-lock where buf_goods.gds-code = integer(p-gds-code) no-error .
if not available buf_goods
then do :
  message "Не найден товар с кодом " p-gds-code view-as alert-box .
  return .
end .

find first buf_doc-line no-lock where buf_doc-line.doc-code = buf_trn-doc.doc-code
                                  and buf_doc-line.artic = buf_goods.artic
                                  and buf_doc-line.prod-type = buf_goods.prod-type
                                  and buf_doc-line.prod-code = buf_goods.prod-code
                                  no-error .
if not available buf_doc-line
then do :
  message "В документе " p-doc-code " не найдена строка с товаром " p-gds-code view-as alert-box .
  return .
end .


create buf_parts.
buffer-copy buf_doc-line except buf_doc-line.status_ to buf_parts .
assign
  buf_parts.prod-type      = buf_doc-line.prod-type
  buf_parts.prod-code      = buf_doc-line.prod-code
  buf_parts.artic          = buf_doc-line.artic
  buf_parts.in-code        = buf_trn-doc.doc-code
  buf_parts.out-code       = buf_trn-doc.doc-code

  buf_parts.price-cli      = buf_doc-line.price-cli
  buf_parts.price-rubl     = (buf_doc-line.price-cli  * buf_trn-doc.exch-rate / buf_trn-doc.exch-scale) / buf_parts.cli-base-rate
            
  buf_parts.price-base     = buf_parts.price-rubl / buf_trn-doc.base-rate * buf_trn-doc.base-scale
  buf_parts.qnty           = buf_doc-line.doc-qnty
  buf_parts.obj-type       = buf_trn-doc.obj-type
  buf_parts.obj-code       = buf_trn-doc.obj-code
  buf_parts.fact-date      = buf_trn-doc.fact-date
  buf_parts.fact-num       = buf_trn-doc.fact-num
  buf_parts.VAT-pc         = buf_doc-line.vat-pc
  buf_parts.part-code      = string(buf_doc-line.line-num)
  buf_parts.PS             = ""
  buf_parts.pay-code       = buf_trn-doc.pay-code
  buf_parts.status_        = no
  buf_parts.fact-qnty      = buf_doc-line.fact-qnty
  buf_parts.supp-type      = buf_trn-doc.cli-type
  buf_parts.supp-code      = buf_trn-doc.cli-code
  buf_parts.rsrv-free      = ?
  buf_parts.doc-type       = buf_trn-doc.doc-type
  buf_parts.cli-qnty       = buf_doc-line.cli-qnty
  buf_parts.pl-code        = 0
  buf_parts.VAT-type       = buf_trn-doc.vat-type
  buf_parts.exch-code      = 0
  buf_parts.cli-base-rate  = 1
  buf_parts.SLT-pc         = 0
  buf_parts.host-code      = buf_trn-doc.host-code
  buf_parts.is-supp        = yes
  buf_parts.SLT-type       = {&without-slt}
  buf_parts.cst-code       = ""
  buf_parts.last-date      = ?
  buf_parts.road-tax-base  = 0
  buf_parts.road-tax-rubl  = 0
  buf_parts.transport-base = 0
  buf_parts.transport-rubl = 0
  buf_parts.other-base     = 0
  buf_parts.other-rubl     = 0
  buf_parts.purch-code     = buf_trn-doc.purch-code
  buf_parts.contract-code  = buf_trn-doc.contract-code
.

message "Готово!" view-as alert-box .
