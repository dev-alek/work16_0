/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Процедура обработки строки 03 в спул IBM-XML

Автор: Бахтадзе Наталья Викторовна
Дата создания: 10/30/05
Author: Bakhtadze Natalya
Creation date: 10/30/05

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

procedure proc-03 :
define input parameter par-mode as integer no-undo .
define input parameter loc-exist as logical no-undo .
define variable lnp-spl as integer no-undo .
define buffer buf_temp-temp for temp-temp.

/*0 - ub.chk-doc  ub.chk-pay
  1- ub.chk-doc ub.chk-pay
*/
/*Переменные для записи в таблицу chk-pay-attr*/
define variable c-attr-code  as character no-undo.
define variable c-attr-value as character no-undo.

  _proc-03:
  do
  on error undo, return error
  :

    if not loc-exist then do:
      for each buf_temp-temp where
              buf_temp-temp.record-name = "CPay":U
        AND buf_temp-temp.id = v-id:
        CASE buf_temp-temp.field-name:
          when "CPCode":U then do:
            if p-pos-type = {&cd-type-IBM-XML} then do:
              assign
              pay_code = integer(buf_temp-temp.field-value)
              no-error .
            end.
            else do:
              assign
              pay_code = convert-pay-code(p-pos-type, integer(buf_temp-temp.field-value), output curr_code)
              no-error .
            end.
          end.
          when "CPCurr":U then do:
            if p-pos-type = {&cd-type-IBM-XML} then
            assign
            curr_code = if kassa-rub-code = integer(buf_temp-temp.field-value)
                        then 0
                        else integer(buf_temp-temp.field-value)
            no-error .
            if p-pos-type = {&cd-type-autotank} then do:
              /*только нац вал!!! - это зашито в shattr41.w*/
              assign
              curr_code = 0 no-error.
            end.
          end.
          when "CPTotal":U then do:
            assign
            tot_sum = fdecimal(buf_temp-temp.field-value)
            no-error .
          end.
          when "CPCard":U then do:
            assign
            pay-card_ = trim(buf_temp-temp.field-value)
            no-error .
          end.
          when "CPRate":U then do:
            assign
            cass-rate = fdecimal(buf_temp-temp.field-value)
            rate-por = 0
            no-error .
          end.
          when "CPCBR":U then do:
            assign
            bank-rate_ = fdecimal(buf_temp-temp.field-value)
            no-error .
          end.
          when "CPMCBR":U then do:
            assign
            bank-scale_ = integer(buf_temp-temp.field-value)
            no-error .
          end.
          when "CPString":U then do:
            assign
            lnp-spl = integer(buf_temp-temp.field-value)
            no-error .
          end.
          when "CPSHandCard":u then do:
            assign
            pass-pay_ =   (if integer(buf_temp-temp.field-value) = 1
                          then 1
                          else 0)
            no-error .
          end.
          when "CPDOC":U then do:
            case true:
              when buf_temp-temp.field-value begins "RRN" then do:
                    c-attr-code  = "RRN-VBRR".
                    c-attr-value = replace(buf_temp-temp.field-value,"RRN=","").
              end.
              when buf_temp-temp.field-value begins "RTA_RefundExport" then do:
                    c-attr-code  = "RTA_RefundExport".
                    c-attr-value = replace(buf_temp-temp.field-value,"RTA_RefundExport=","").
              end.
              otherwise do:
                    c-attr-code  = "CPDOC".
                    c-attr-value = buf_temp-temp.field-value.               
              end.
            end case.
          end. /*when "CPDOC":U then do:*/

          otherwise do:
            error-status:error = no.
          end.
        END CASE.
        if error-status:error then do:
          {&error-in-file-format}
        end.
        delete buf_temp-temp.
      end. /*for each buf_temp-temp*/
      assign
      time-oper_ =  v-time
      no-error
      .
      if error-status:error then do:
        {&error-in-file-format}
      end.
      
      find first ub.chk-pay-attr where 
            ub.chk-pay-attr.doc-code   = ub.chk-doc.doc-code
        and ub.chk-pay-attr.line-num   = lnp-spl
        and ub.chk-pay-attr.attr-code  = 'RTA_RefundExport' no-error.
      if available ub.chk-pay-attr then do:
        assign
          ub.chk-pay-attr.attr-value = ub.chk-pay-attr.attr-value + c-attr-value
          no-error.
        leave _proc-03.      
      end.
      
      CASE par-mode:
        when 0
        or when 1
        then do:
          FIND ub.chk-pay WHERE
                ub.chk-pay.doc-code = ub.chk-doc.doc-code
            AND ub.chk-pay.curr-code = curr_code
            AND ub.chk-pay.pay-code = pay_code
            and ub.chk-pay.line-num = lnp-spl
            NO-ERROR.
          if NOT available ub.chk-pay
          then  do:
            CREATE ub.chk-pay .
            assign
            ub.chk-pay.doc-code = ub.chk-doc.doc-code
            ub.chk-pay.line-num = lnp-spl
            ub.chk-pay.chk-date = ub.chk-doc.chk-date
            ub.chk-pay.obj-code = shop-code
            ub.chk-pay.obj-type = shop-type
            ub.chk-pay.tot-rubl = 0
            ub.chk-pay.tot-sum = 0
            ub.chk-pay.tot-base = 0
            ub.chk-pay.pay-code = pay_code
            ub.chk-pay.curr-code = curr_code
            ub.chk-pay.time-oper = time-oper_
            cass-rate = cass-rate * exp( 10, int( rate-por ) )
            ub.chk-pay.cash-rate = cass-rate
            ub.chk-pay.bank-rate = bank-rate_
            ub.chk-pay.bank-scale = bank-scale_
            ub.chk-pay.pass-pay = pass-pay_
            ub.chk-pay.pay-card = pay-card_
            ub.chk-pay.line-type = "":U
            ub.chk-pay.line-sign = (if ub.chk-doc.chk-type = integer({&rcpt-sale})
                                then (chk-pay.tot-sum >= 0)
                                else (chk-pay.tot-sum <= 0)
                                )
            ub.chk-pay.is-error = no
            .
          create ub.chk-pay-attr.
          assign 
          ub.chk-pay-attr.doc-code   = ub.chk-doc.doc-code
          ub.chk-pay-attr.line-num   = lnp-spl
          ub.chk-pay-attr.attr-code  = c-attr-code
          ub.chk-pay-attr.attr-value = c-attr-value
          no-error.
          end.
          assign
          chk-pay.tot-sum = chk-pay.tot-sum + tot_sum
          .
        end.


      END CASE.
    end. /* if not loc-exist */
  end.

end procedure. /* proc-03 */

procedure proc-cash :
define input parameter loc-exist as logical no-undo .
define variable par-val_ as decimal no-undo .
define variable lnp-spl as integer no-undo .
define variable tot_rubl as decimal no-undo .
define variable tot_base as decimal no-undo .
define buffer buf_temp-temp for temp-temp.

  do
  on error undo, return error
  :
    if not loc-exist then do:
      for each buf_temp-temp where
              buf_temp-temp.record-name = "Cash":U
        AND buf_temp-temp.id = v-id:
        CASE buf_temp-temp.field-name:
          when "CSValue":U then do:
            assign
            tot_sum = fdecimal(buf_temp-temp.field-value)
            no-error .
          end.
          when "CCCode":U then do:
            assign
            curr_code = if kassa-rub-code = integer(buf_temp-temp.field-value)
                        then 0
                        else integer(buf_temp-temp.field-value)
            no-error .
          end.
          when "CAMount":U then do:
            assign
            curr-string-qnty = fdecimal(buf_temp-temp.field-value)
            no-error .
          end.
          when "CValue":u then do:
            assign
            par-val_ =   fdecimal(buf_temp-temp.field-value)
            no-error .
          end.
          when "CPString":u then do:
            assign
            lnc =   integer(buf_temp-temp.field-value)
            no-error .
          end.
          when "CString":u then do:
            assign
            lnp-spl =   integer(buf_temp-temp.field-value)
            no-error .
          end.
          when "CPayCode":U then do:
            if p-pos-type = {&cd-type-IBM-XML}
            or p-pos-type = {&cd-type-autotank}
            then do:
              assign
              pay_code = integer(buf_temp-temp.field-value)
              no-error .
            end.
          end.
          when "CCCode":U then do:
            if p-pos-type = {&cd-type-IBM-XML}
            or p-pos-type = {&cd-type-autotank}
            then
            assign
            curr_code = if kassa-rub-code = integer(buf_temp-temp.field-value)
                        then 0
                        else integer(buf_temp-temp.field-value)
            no-error .
          end.
          when "CRate":U then do:
            assign
            rate-por = 0
            cass-rate = fdecimal(buf_temp-temp.field-value)
            no-error .
          end.
          when "CSBase" then do:
            assign
            tot_base = fdecimal(buf_temp-temp.field-value)
            no-error .
          end.
          when "CSNat" then do:
            assign
            tot_rubl = fdecimal(buf_temp-temp.field-value)
            no-error .
          end.
          otherwise do:
            error-status:error = no.
          end.
        END CASE.
        if error-status:error then do:
          {&error-in-file-format}
        end.
        delete buf_temp-temp.
      end. /*for each buf_temp-temp*/
      assign
      time-oper_ =  v-time
      no-error
      .
      if par-val_ = 0
      and ub.chk-doc.chk-type = integer({&cd-drawer}) then do:
      end.
      else do:
      FIND ub.chk-pay WHERE
            ub.chk-pay.doc-code = ub.chk-doc.doc-code
        AND ub.chk-pay.curr-code = curr_code
        AND ub.chk-pay.pay-code = pay_code
        and ub.chk-pay.line-num = lnp-spl
        and ub.chk-pay.src-val = par-val_
        NO-ERROR.
      if NOT available ub.chk-pay then  do:
        CREATE ub.chk-pay .
        assign
        ub.chk-pay.doc-code = ub.chk-doc.doc-code
        ub.chk-pay.line-num = lnp-spl
        ub.chk-pay.chk-date = ub.chk-doc.chk-date
        ub.chk-pay.obj-code = shop-code
        ub.chk-pay.obj-type = shop-type
        ub.chk-pay.tot-rubl = 0
        ub.chk-pay.tot-sum = 0
        ub.chk-pay.tot-base = 0
        ub.chk-pay.pay-code = pay_code
        ub.chk-pay.curr-code = curr_code
        ub.chk-pay.time-oper = time-oper_
        cass-rate = cass-rate * exp( 10, int( rate-por ) )
        ub.chk-pay.cash-rate = cass-rate
        ub.chk-pay.bank-rate = 1
        ub.chk-pay.bank-scale = 1
        /*
        ub.chk-pay.bank-rate = bank-rate_
        ub.chk-pay.bank-scale = bank-scale_
        */
        ub.chk-pay.pass-pay = 1
        ub.chk-pay.pay-card = ''
        ub.chk-pay.line-type = "":U
        ub.chk-pay.line-sign = (if ub.chk-doc.chk-type = integer({&encashment})
                              or ub.chk-doc.chk-type =  integer({&cd-expense}
                              )
                            then (chk-pay.tot-sum <= 0)
                            else (chk-pay.tot-sum >= 0)
                            )
        ub.chk-pay.is-error = no
        .
      end.
      assign
      ub.chk-pay.tot-sum = ub.chk-pay.tot-sum + (if par-val_ = 0
                                     then tot_sum
                                     else 0)
      .
      if par-val_ > 0
      or curr-string-qnty <> 0 then do:
        assign
        ub.chk-pay.src-qnty = curr-string-qnty
        ub.chk-pay.src-val  = par-val_
        ub.chk-pay.tot-sum = par-val_ * curr-string-qnty
        .
      end.
      end. /*else if par-val_ = 0 */
    end. /* not loc-exist*/
  end.

end procedure. /* proc-cash */


/* $Workfile$ e n d */