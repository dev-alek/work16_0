block-level on error undo, throw.
{ utl/runpro.i}
define input parameter p-doc-code as character no-undo .
define input parameter p-gds-code as character no-undo .

{ cmp/trg-def.i  }

define buffer new_parts-attr for ub.parts-attr .
define buffer buf_parts for ub.parts .
define buffer buf_trn-doc for ub.trn-doc .
define buffer buf_goods for ub.goods .
define buffer buf_doc-line for ub.doc-line .

{ str/in-vatp.i def }

find first buf_trn-doc no-lock where buf_trn-doc.doc-code = p-doc-code no-error .
if not available buf_trn-doc
then do :
  message ("Не найден документ с номером " + p-doc-code) view-as alert-box .
  return .
end .

find first buf_goods no-lock where buf_goods.gds-code = integer(p-gds-code) no-error .
if not available buf_goods
then do :
  message ("Не найден товар с кодом " + p-gds-code) view-as alert-box .
  return .
end .

find first buf_doc-line no-lock where buf_doc-line.doc-code = buf_trn-doc.doc-code
                                  and buf_doc-line.artic = buf_goods.artic
                                  and buf_doc-line.prod-type = buf_goods.prod-type
                                  and buf_doc-line.prod-code = buf_goods.prod-code
                                  no-error .
if not available buf_doc-line
then do :
  message ("Не найдена строка в документе " + p-doc-code + " с товаром " + p-gds-code) view-as alert-box .
  return .
end .

for each buf_parts no-lock where buf_parts.out-code = buf_trn-doc.doc-code
                               and buf_parts.artic = buf_goods.artic
                               and buf_parts.prod-type = buf_goods.prod-type
                               and buf_parts.prod-code = buf_goods.prod-code
:
  find first new_parts-attr no-lock where new_parts-attr.in-code   = buf_parts.in-code
                                      and new_parts-attr.gds-code  = buf_goods.gds-code
                                      and new_parts-attr.part-code = buf_parts.part-code
                                      no-error .
  if not available new_parts-attr
  then do :

    create new_parts-attr .
    
    assign
      new_parts-attr.in-code              = buf_parts.in-code
      new_parts-attr.gds-code             = buf_goods.gds-code
      new_parts-attr.part-code            = buf_parts.part-code
      new_parts-attr.orig-in-code         = buf_parts.in-code
      new_parts-attr.orig-gds-code        = buf_goods.gds-code
      new_parts-attr.orig-part-code       = buf_parts.part-code
      new_parts-attr.income-in-code       = buf_parts.in-code
      new_parts-attr.income-gds-code      = buf_goods.gds-code
      new_parts-attr.income-part-code     = buf_parts.part-code
      new_parts-attr.supp-type            = buf_parts.supp-type
      new_parts-attr.supp-code            = buf_parts.supp-code
      new_parts-attr.pay-code             = buf_parts.pay-code
      new_parts-attr.purch-code           = buf_parts.purch-code
      new_parts-attr.cli-qnty             = buf_parts.cli-qnty
      new_parts-attr.price-cli            = buf_parts.price-cli
      new_parts-attr.unit-cli             = buf_doc-line.unit-cli
      new_parts-attr.exch-code            = buf_parts.exch-code
      new_parts-attr.exch-rate            = buf_trn-doc.exch-rate
      new_parts-attr.exch-scale           = buf_trn-doc.exch-scale
      new_parts-attr.cli-base-rate        = buf_parts.cli-base-rate
      new_parts-attr.doc-qnty             = buf_parts.qnty
      new_parts-attr.fact-qnty            = buf_parts.fact-qnty
      new_parts-attr.real-qnty            = buf_parts.real-qnty
      new_parts-attr.price-base           = buf_parts.price-base
      new_parts-attr.price-rubl           = buf_parts.price-rubl
      new_parts-attr.base-rate            = buf_trn-doc.base-rate
      new_parts-attr.base-scale           = buf_trn-doc.base-scale
      new_parts-attr.vat-type             = buf_parts.vat-type
      new_parts-attr.vat-pc               = buf_parts.vat-pc
      new_parts-attr.SLT-type             = buf_parts.SLT-type
      new_parts-attr.SLT-pc               = buf_parts.SLT-pc
      new_parts-attr.road-tax-base        = buf_parts.road-tax-base
      new_parts-attr.road-tax-rubl        = buf_parts.road-tax-rubl
      new_parts-attr.transport-base       = buf_parts.transport-base
      new_parts-attr.transport-rubl       = buf_parts.transport-rubl
      new_parts-attr.other-base           = buf_parts.other-base
      new_parts-attr.other-rubl           = buf_parts.other-rubl
      new_parts-attr.density              = buf_doc-line.doc-density
      new_parts-attr.temperature          = buf_doc-line.temperature
      new_parts-attr.is-supp              = buf_parts.is-supp
      new_parts-attr.cst-code             = buf_parts.cst-code
      new_parts-attr.last-date            = buf_parts.last-date
      new_parts-attr.line-cli-qnty        = buf_doc-line.cli-qnty
      new_parts-attr.line-doc-qnty        = buf_doc-line.doc-qnty
      new_parts-attr.line-fact-qnty       = buf_doc-line.fact-qnty
      new_parts-attr.wt-brutto            = buf_doc-line.wt-brutto
      new_parts-attr.num-place            = buf_doc-line.num-place
      new_parts-attr.country-code         = 0
      new_parts-attr.obj-type             = buf_trn-doc.obj-type
      new_parts-attr.obj-code             = buf_trn-doc.obj-code
      new_parts-attr.PS                   = buf_parts.PS
      new_parts-attr.fact-date            = buf_trn-doc.fact-date
      new_parts-attr.fact-time            = buf_trn-doc.fact-time
      new_parts-attr.fact-order           = buf_trn-doc.fact-order
      new_parts-attr.shift-num            = buf_trn-doc.shift-num
      new_parts-attr.shift-name           = buf_trn-doc.shift-name
      new_parts-attr.shift-date           = buf_trn-doc.shift-date
      new_parts-attr.ext-doc-type         = buf_trn-doc.ext-doc-type
      new_parts-attr.wrkr                 = buf_trn-doc.wrkr
      new_parts-attr.agnt                 = buf_trn-doc.agnt
      new_parts-attr.boss                 = buf_trn-doc.boss
      new_parts-attr.creid                = buf_trn-doc.creid
      new_parts-attr.out-code             = buf_trn-doc.out-code
      new_parts-attr.inv-num              = buf_trn-doc.inv-num
      new_parts-attr.cli-name             = buf_trn-doc.cli-name
      new_parts-attr.ord-num              = buf_trn-doc.ord-num
      new_parts-attr.is-back-date         = buf_trn-doc.is-back-date
      new_parts-attr.is-corr              = buf_trn-doc.is-corr
      new_parts-attr.is-del               = buf_trn-doc.is-del
      new_parts-attr.contract-code        = buf_parts.contract-code
      new_parts-attr.hold-doc-code-child  = buf_trn-doc.hold-doc-code-child
      new_parts-attr.hold-doc-code-parent = buf_trn-doc.hold-doc-code-parent
    .
    
    { str/in-vatp.i calc-parts buf_parts. " " loc}
    
    assign
      new_parts-attr.vat-base         = vat-base-loc
      new_parts-attr.vat-rubl         = vat-rubl-loc
      new_parts-attr.slt-base         = slt-base-loc
      new_parts-attr.slt-rubl         = slt-rubl-loc
      new_parts-attr.discnt-base      = 0
      new_parts-attr.discnt-rubl      = 0
    .
  
  end .
end .

message "Готово!" view-as alert-box .
