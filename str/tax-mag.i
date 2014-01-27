/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

отчет о налогах по релизации в магазине - кусок

Автор: Бахтадзе Наталья Викторовна
Дата создания: 01/13/06
Author: Bakhtadze Natalya
Creation date: 01/13/06

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

_docline:
FOR EACH ub.doc-line WHERE ub.doc-line.doc-code = doc-num NO-LOCK:
  PROCESS EVENTS.
  jj = jj + 1 .
  if ( jj  modulo 10 ) = 0  then
  run waitfram-show in this-procedure (input ("Обработано строк накладных : " +   string(  jj ) ) ).

  IF good-choice  AND NOT (can-find(FIRST gds-list WHERE
                                    gds-list.artic = ub.doc-line.artic AND
                                    gds-list.prod-type = ub.doc-line.prod-type AND
                                    gds-list.prod-code = ub.doc-line.prod-code)) THEN NEXT.

  run clcprtsl_calc-line in this-procedure (input recid (ub.doc-line)).
  assign
  s-price = 0
  cur-quant = 0
  varsum-dsc-r-b-acc   = 0
  varvat-r-b-acc       = 0
  var-qnty                = 0
  varvat-r-b-doc       = 0
  varslt-r-b-doc       = 0
  .
  find first tt-allsum-line where
             tt-allsum-line.sum-type = {&sum-general} no-error .
  if not available tt-allsum-line then do:
  end.
  else do:
   assign
   varsum-dsc-r-b-acc   = (if v-curr-r-b = {&r-b-rubl} then tt-allsum-line.sum-dsc-rubl-acc else tt-allsum-line.sum-dsc-base-acc)
   varvat-r-b-acc       = (if v-curr-r-b = {&r-b-rubl} then tt-allsum-line.vat-rubl-acc else tt-allsum-line.vat-base-acc)
   var-qnty                = ub.doc-line.fact-qnty
   varvat-r-b-doc       = (if v-curr-r-b = {&r-b-rubl} then tt-allsum-line.vat-rubl-doc else tt-allsum-line.vat-base-doc)
   varslt-r-b-doc       = (if v-curr-r-b = {&r-b-rubl} then tt-allsum-line.slt-rubl-doc else tt-allsum-line.slt-rubl-doc)
   cur-quant = is-out * ub.doc-line.fact-qnty
   s-price = ( varsum-dsc-r-b-acc - varvat-r-b-acc ) / var-qnty
   .
  end.

  if NOT offc AND cur-quant = 0 and negparts then next _docline.
  FOR EACH ub.gds-dtl WHERE
          ub.gds-dtl.doc-code = doc-num AND
          ub.gds-dtl.artic = ub.doc-line.artic AND
          ub.gds-dtl.prod-type = ub.doc-line.prod-type AND
          ub.gds-dtl.prod-code = ub.doc-line.prod-code
          NO-LOCK:

    if method = "b-code":U then do:
      FIND FIRST ub.goods No-LOCK WHERE
                ub.goods.artic = ub.gds-dtl.artic AND
                ub.goods.prod-type = ub.gds-dtl.prod-type AND
                ub.goods.prod-code = ub.gds-dtl.prod-code No-ERROR.
      FIND FIRST ub.bar-code WHERE
                ub.bar-code.gds-code = ub.goods.gds-code AND
                ub.bar-code.in-code = "" AND
                ub.bar-code.unit-cli = ub.goods.unit-base AND
                ub.bar-code.part-code = "" AND
                ub.bar-code.node-code = ub.gds-dtl.prt-code
                NO-LOCK   NO-ERROR.
    end.

    assign
    cur-discnt = (if v-curr-r-b = {&r-b-rubl} then ub.gds-dtl.discnt-rubl else ub.gds-dtl.discnt-base)
    .
    CASE method :
      when "b-code":U THEN dO:
        FIND FIRST sj-goods WHERE
                  sj-goods.b-code = ub.bar-code.b-code AND
                  sj-goods.VAT-pc = ub.doc-line.VAT-pc AND
                  sj-goods.SLT-pc = ub.doc-line.SLT-pc AND
                  sj-goods.is-out = (is-out > 0) NO-ERROR .
      END.
      when "artic":U THEN DO:
        FIND FIRST sj-goods WHERE
                  sj-goods.artic = ub.doc-line.artic AND
                  sj-goods.prod-type = ub.doc-line.prod-type AND
                  sj-goods.prod-code = ub.doc-line.prod-code AND
                  sj-goods.VAT-pc = ub.doc-line.VAT-pc AND
                  sj-goods.SLT-pc = ub.doc-line.SLT-pc AND
                  sj-goods.is-out = (is-out > 0) USE-INDEX p3 NO-ERROR .
      END.
      otherwise do:
        FIND FIRST sj-goods WHERE
                  sj-goods.VAT-pc = ub.doc-line.VAT-pc AND
                  sj-goods.SLT-pc = ub.doc-line.SLT-pc AND
                  sj-goods.is-out = (is-out > 0) NO-ERROR .
      end.
    END CASE.

    if NOT available sj-goods then do:
      FIND ub.goods WHERE
          ub.goods.prod-type = ub.doc-line.prod-type AND
          ub.goods.prod-code = ub.doc-line.prod-code AND
          ub.goods.artic = ub.doc-line.artic NO-LOCK .
      if method = "artic":U then do:
        /*найдем самый основной корневой бар-код*/
        { gbl/gdsbcode.i ub.goods.gds-code ? r-bar-code no-error }
        if error-status:error then NEXT _docline.
      end.
      CREATE sj-goods.
      CASE method:
        WHEN  "b-code":U then DO:
          assign
          sj-goods.b-code = ub.bar-code.b-code
          sj-goods.name = ub.goods.gds-name
          sj-goods.artic = ub.goods.artic
          sj-goods.VAT-pc = ub.doc-line.VAT-pc
          sj-goods.SLT-pc = ub.doc-line.SLT-pc
          sj-goods.unit  = ub.goods.unit-base
          sj-goods.is-out = (is-out > 0)
            .
        END.
        WHEN "artic":U then do:
          assign
          sj-goods.b-code = r-bar-code
          sj-goods.name = ub.goods.gds-name
          sj-goods.artic = ub.goods.artic
          sj-goods.prod-type = ub.goods.prod-type
          sj-goods.prod-code = ub.goods.prod-code
          sj-goods.VAT-pc = ub.doc-line.VAT-pc
          sj-goods.SLT-pc = ub.doc-line.SLT-pc
          sj-goods.unit  = ub.goods.unit-base
          sj-goods.is-out = (is-out > 0)
            .
        END.
        WHEN "TOTALS":U then do:
          assign
          sj-goods.VAT-pc = ub.doc-line.VAT-pc
          sj-goods.SLT-pc = ub.doc-line.SLT-pc
          sj-goods.is-out = (is-out > 0)
          .
        END.
      END CASE.
    &if "{1}" = "grp" &then
      sj-goods.grp-code = ub.goods.grp-code.
      sj-goods.grp-name = ub.goods.grp-name.
    &endif
    end.
    { str/out-vatp.i calc-gds-dtl ub.doc-line. t-doc. gds-dtl. }
    assign
    cur-quant = is-out * gds-dtl.fact-qnty
    slt-calc = (if v-curr-r-b = {&r-b-rubl} then slt-rubl-sale else slt-base-sale) * cur-quant
    vat-cost = (if v-curr-r-b = {&r-b-rubl} then vat-rubl-sale else vat-base-sale) * cur-quant
    slt-calc = if ub.gds-dtl.fact-qnty = 0 then 0 else slt-calc
    vat-cost = if ub.gds-dtl.fact-qnty = 0 then 0 else vat-cost
    sj-goods.qnty = sj-goods.qnty + cur-quant
    sj-goods.brutto-sum = sj-goods.brutto-sum + ( cur-quant * (if v-curr-r-b = {&r-b-rubl} then ub.gds-dtl.price-rubl else ub.gds-dtl.price-base))
    sj-goods.discnt-sum = sj-goods.discnt-sum + ( cur-discnt * cur-quant )
    sj-goods.uchet-with-vat-sum = sj-goods.uchet-with-vat-sum + (if var-qnty = 0
                                                                 then 0
                                                                 else (varsum-dsc-r-b-acc / var-qnty) * cur-quant)
    sj-goods.uchet-sum = sj-goods.uchet-sum + s-price * cur-quant
    sj-goods.SLT-r-b = sj-goods.SLT-r-b + slt-calc
    sj-goods.VAT-r-b = sj-goods.VAT-r-b + vat-cost
    .
  END. /*FOR EACH GDS-DTL*/
END. /*FOR EACH doc-line*/

/* $Workfile$ e n d */