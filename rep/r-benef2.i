/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Печать отчета о выручке  BreakByCass

Автор: Бахтадзе Наталья Викторовна
Дата создания: 10/19/05
Author: Bakhtadze Natalya
Creation date: 10/19/05

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

define variable acc-netto as decimal no-undo.
define variable acc-count as integer no-undo.
define variable acc-base as decimal no-undo.
define variable acc-rubl as decimal no-undo.
define variable acc-sub-netto as decimal no-undo.
define variable acc-sub-count as integer no-undo.
define variable acc-desk-netto as decimal no-undo.
define variable acc-desk-count as integer no-undo.
define variable acc-sub-desk-netto as decimal no-undo.
define variable acc-sub-desk-count as integer no-undo.
define variable acc-sub-curr-sum as decimal no-undo.
define variable acc-sub-curr-base as decimal no-undo.
define variable acc-sub-curr-rubl as decimal no-undo.
define variable acc-desk-rubl as decimal no-undo.
define variable acc-desk-base as decimal no-undo.
define variable acc-sub-desk-rubl as decimal no-undo.
define variable acc-sub-desk-base as decimal no-undo.
define variable acc-day-rubl as decimal no-undo .
define variable acc-day-base as decimal no-undo .
define variable acc-day-cnt as integer no-undo .
define variable acc-curr-sum as decimal no-undo.
define variable acc-curr-base as decimal no-undo.
define variable acc-curr-rubl as decimal no-undo.


DEFINE VARIABLE is-counted as logical no-undo .
 { gbl/cur-time.i }

&global-define  no-benefits    "Не было никакой выручки на выбранных объектах ~
в течение заданного Вами периода времени."


assign
date_string = cur-time-print()
Line = fill( "-", 140 ).

for each benefits:
    delete benefits.
end.

for each inkas-num:
    delete inkas-num.
end.

for each day_sum:
    delete day_sum.
end.

for each all-days_sum:
    delete all-days_sum.
end.

if v-curr-r-b = {&r-b-base} then do:
&if "{1}" = "rubl" &then
sale-price-type = "{&abbr_rubley}".
&else
sale-price-type = base-type.
&endif
end.
else sale-price-type = "{&abbr_rubley}".

run no-benq(output found).

run waitfram-hide in this-procedure .
if not found then do:
  message {&no-benefits} view-as alert-box information .
  return.
end.
CASE X-Radio-Task > 1:
  WHEN YES THEN DO:
    FOR EACH obj-list WHERE
            obj-list.obj-type = {&shop} NO-LOCK :
      ObjAmount = ObjAmount + 1.
      _chk-doc:
      FOR EACH ub.chk-doc WHERE
               ub.chk-doc.obj-type = obj-list.obj-type AND
              ub.chk-doc.obj-code = obj-list.obj-code AND
              ub.chk-doc.shift-date >= x-date-start AND
              ub.chk-doc.shift-date <= x-date-end AND
              (IF cas-num > 0 then ub.chk-doc.pay-desk = cas-num else TRUE)
              NO-LOCK
      BREAK
      BY ub.chk-doc.obj-type
      BY ub.chk-doc.obj-code
      BY ub.chk-doc.pay-desk:
        is-counted = no.
        IF FIRST-OF(ub.chk-doc.pay-desk) then do:
          assign
          acc-sub-desk-netto = 0
          acc-sub-desk-count = 0
          acc-desk-netto = 0
          acc-desk-count = 0
          .
        end.
        IF X-Radio-Task = 3 AND
        ((ub.chk-doc.shift-date = X-date-start AND ub.chk-doc.shift-num < X-shift-Start) OR
          (ub.chk-doc.shift-date = X-date-end AND  ub.chk-doc.shift-num > X-shift-End) ) THEN DO:
          assign
          acc-sub-desk-netto = acc-sub-desk-netto + ub.chk-doc.netto
          acc-sub-desk-count = acc-sub-desk-count + 1
          is-counted = yes
          .
        END.
        IF X-Radio-Task = 4 AND
        (ub.chk-doc.shift-num <> X-shift-Alone ) THEN DO:
          assign
          acc-sub-desk-netto = acc-sub-desk-netto + ub.chk-doc.netto
          acc-sub-desk-count = acc-sub-desk-count + 1
          is-counted = yes
          .
        END.
        if lookup(string(ub.chk-doc.chk-type), {&no-sale-receipt-codes}) > 0
&if "{2}" = "time" &then
        or (T-time and NOT is-counted AND
                      NOT can-find(FIRST times where
                                        times.time1  <= ub.chk-doc.chk-time AND
                                        times.time2 >= ub.chk-doc.chk-time))
&endif
                                          then do:
          assign
          acc-sub-desk-netto = acc-sub-desk-netto + ub.chk-doc.netto
          acc-sub-desk-count = acc-sub-desk-count + 1
          .
        end.
        assign
        acc-desk-netto = acc-desk-netto + ub.chk-doc.netto
        acc-desk-count = acc-desk-count + 1
        .
        if last-of( ub.chk-doc.pay-desk ) then do:
          assign
          acc-netto = acc-netto + acc-desk-netto
          acc-count = acc-count + acc-desk-count
          acc-sub-netto = acc-sub-netto + acc-sub-desk-netto
          acc-sub-count = acc-sub-count + acc-sub-desk-count
          .
          create day_sum.
          assign
          day_sum.obj-type = obj-list.obj-type
          day_sum.obj-code = obj-list.obj-code
          day_sum.pay-desk = ub.chk-doc.pay-desk
          day_sum.tot-rubl = (if v-curr-r-b = {&r-b-base}
                              then day_sum.tot-rubl
                              else acc-desk-netto - acc-sub-desk-netto)
          day_sum.tot-base = (if v-curr-r-b = {&r-b-rubl}
                              then day_sum.tot-base
                              else acc-desk-netto - acc-sub-desk-netto)
          day_sum.tot-r-b  = (if v-curr-r-b = {&r-b-base}
                              then day_sum.tot-base
                              else day_sum.tot-rubl)
          day_sum.chk-cnt =  acc-desk-count -  acc-sub-desk-count
          .
        end.
      END.
    END.
  END.
  WHEN NO THEN DO:
    FOR EACH obj-list WHERE
             obj-list.obj-type = {&shop} NO-LOCK :
      ACCUMULATE obj-list.obj-code ( COUNT ) .
      _chk-doc2:
      FOR EACH ub.chk-doc WHERE
               ub.chk-doc.obj-type = obj-list.obj-type AND
              ub.chk-doc.obj-code = obj-list.obj-code AND
              ub.chk-doc.chk-date >= x-date-start AND
              ub.chk-doc.chk-date <= x-date-end AND
              (IF cas-num > 0 then ub.chk-doc.pay-desk = cas-num else TRUE)
              NO-LOCK
      BREAK
      BY ub.chk-doc.obj-type
      BY ub.chk-doc.obj-code
      BY ub.chk-doc.pay-desk:
        IF FIRST-OF(ub.chk-doc.pay-desk) then do:
            assign
            acc-sub-desk-netto = 0
            acc-sub-desk-count = 0
            acc-desk-netto = 0
            acc-desk-count = 0
            .
        end.
        if lookup(string(ub.chk-doc.chk-type), {&no-sale-receipt-codes}) > 0
&if "{2}" = "time" &then
        or (T-time and NOT can-find(FIRST times where
                                          times.time1  <= ub.chk-doc.chk-time AND
                                          times.time2 >= ub.chk-doc.chk-time))
&endif
                                          then do:
            assign
          acc-sub-desk-netto = acc-sub-desk-netto + ub.chk-doc.netto
          acc-sub-desk-count = acc-sub-desk-count + 1
          .
        end.
        assign
        acc-desk-netto = acc-desk-netto + ub.chk-doc.netto
        acc-desk-count = acc-desk-count + 1
        .
        if last-of( chk-doc.pay-desk ) then do:
          assign
          acc-netto = acc-netto + acc-desk-netto
          acc-count = acc-count + acc-desk-count
          acc-sub-netto = acc-sub-netto + acc-sub-desk-netto
          acc-sub-count = acc-sub-count + acc-sub-desk-count
          .
          create day_sum.
          assign
          day_sum.obj-type = obj-list.obj-type
          day_sum.obj-code = obj-list.obj-code
          day_sum.pay-desk = ub.chk-doc.pay-desk
          day_sum.tot-rubl = (if v-curr-r-b = {&r-b-base}
                              then day_sum.tot-rubl
                              else acc-desk-netto - acc-sub-desk-netto)
          day_sum.tot-base = (if v-curr-r-b = {&r-b-rubl}
                              then day_sum.tot-base
                              else acc-desk-netto - acc-sub-desk-netto)
          day_sum.tot-r-b  = (if v-curr-r-b = {&r-b-base}
                              then day_sum.tot-base
                              else day_sum.tot-rubl)
          day_sum.chk-cnt =  acc-desk-count -  acc-sub-desk-count
            .
        end.
      END.
    END.
  END.
END CASE.
assign
ChkAmount = acc-count - acc-sub-count
AllDay-BaseSum = 0
AllDay-RublSum = 0
.

FOR EACH obj-list WHERE obj-list.obj-type = {&shop} NO-LOCK :
  assign
  acc-day-base = 0
  acc-day-rubl = 0
  acc-day-cnt = 0
  acc-count = 0
  .
  CASE X-radio-Task > 1 :
    WHEN YES THEN DO:
      _chk-doc3:
      FOR EACH ub.chk-doc WHERE
                ub.chk-doc.obj-type = obj-list.obj-type AND
              ub.chk-doc.obj-code = obj-list.obj-code AND
              ub.chk-doc.shift-date >= x-date-start AND
              ub.chk-doc.shift-date <= x-date-end AND
              (IF cas-num > 0 then ub.chk-doc.pay-desk = cas-num else TRUE) NO-LOCK,
          EACH ub.chk-pay WHERE ub.chk-pay.doc-code = ub.chk-doc.doc-code  NO-LOCK
      BREAK
      by ub.chk-doc.obj-type
      by ub.chk-doc.obj-code
      by ub.chk-doc.shift-date
      BY ub.chk-pay.out-code
      BY ub.chk-pay.pay-code
      BY ub.chk-pay.curr-code:
        acc-count = acc-count + 1.
        if (acc-count modulo 25 ) = 0
        AND acc-count >= 25
        then do:
        run waitfram-show in this-procedure ( obj-list.obj-type + string( obj-list.obj-code ) +
                      ", обработано строк чеков : " +
                        string( acc-count ) ) .
        end.
        is-counted = no.
        IF X-Radio-Task = 3 AND
          ((ub.chk-doc.shift-date = X-date-start AND ub.chk-doc.shift-num < X-shift-Start) OR
            (ub.chk-doc.shift-date = X-date-end AND  ub.chk-doc.shift-num > X-shift-End) ) THEN DO:
          is-counted = yes
          .
          END.
          IF X-Radio-Task = 4 AND
            (ub.chk-doc.shift-num <> X-shift-Alone ) THEN DO:
            is-counted = yes
            .
          END.
          if lookup(string(ub.chk-doc.chk-type), {&no-sale-receipt-codes}) > 0
&if "{2}" = "time" &then
          or (T-time and NOT is-counted AND
                        NOT can-find(FIRST times where
                                            times.time1  <= ub.chk-doc.chk-time AND
                                            times.time2 >= ub.chk-doc.chk-time))
&endif
                                            then do:
            is-counted = yes.
          end.
          if not is-counted then do:
            find first benefits where
                    benefits.pay-desk = ub.chk-doc.pay-desk
                and benefits.obj-type = obj-list.obj-type
                and benefits.obj-code = obj-list.obj-code
                and benefits.pay-code = ub.chk-pay.pay-code
                and benefits.curr-code = ub.chk-pay.curr-code no-error.
            if not available benefits then do:
              FIND FIRST ub.cash-pay WHERE
                        ub.cash-pay.cdpay-code = ub.chk-pay.pay-code
                    AND ub.cash-pay.curr-code = ub.chk-pay.curr-code  NO-LOCK NO-ERROR.
              FIND FIRST ub.currency WHERE
                      ub.currency.curr-code = ub.chk-pay.curr-code NO-LOCK NO-ERROR.
              create benefits.
              assign
              benefits.pay-desk = ub.chk-doc.pay-desk
              benefits.obj-type = obj-list.obj-type
              benefits.obj-code = obj-list.obj-code
              benefits.pay-code = if avail ub.cash-pay then ub.cash-pay.cdpay-code else ub.chk-pay.pay-code
              benefits.pay-name = if avail ub.cash-pay then ub.cash-pay.obj-name else "Неопознанная оплата"
              benefits.curr-code = if avail ub.currency then ub.currency.curr-code else ub.chk-pay.curr-code
              benefits.curr-name = if avail ub.currency then ub.currency.curr-name else "Неопознанная валюта"
              .
            end.
            assign
            benefits.tot-sum   = benefits.tot-sum + ub.chk-pay.tot-sum
            benefits.tot-base  = benefits.tot-base + ub.chk-pay.tot-base
            benefits.tot-rubl  = benefits.tot-rubl + ub.chk-pay.tot-rubl
            benefits.tot-r-b = if v-curr-r-b = {&r-b-base}
                                then benefits.tot-base
                                else benefits.tot-rubl
            .
            assign
            acc-day-rubl = acc-day-rubl + ub.chk-pay.tot-rubl
            acc-day-base = acc-day-base + ub.chk-pay.tot-base
            acc-day-cnt = acc-day-cnt + ub.chk-pay.tot-base
              .
          end.
        END.
      END. /*when YES*/
      WHEN NO THEN DO:
        _chk-doc4:
        FOR EACH ub.chk-doc WHERE
                  ub.chk-doc.obj-type = obj-list.obj-type AND
                ub.chk-doc.obj-code = obj-list.obj-code AND
                ub.chk-doc.chk-date >= x-date-start AND
                ub.chk-doc.chk-date <= x-date-end AND
                (IF cas-num > 0 then ub.chk-doc.pay-desk = cas-num else TRUE) NO-LOCK,
            EACH ub.chk-pay WHERE ub.chk-pay.doc-code = ub.chk-doc.doc-code  NO-LOCK
        BREAK
        BY ub.chk-pay.obj-type
        BY ub.chk-pay.obj-code
        BY ub.chk-doc.pay-desk
        BY ub.chk-pay.pay-code
        BY ub.chk-pay.curr-code:

          if FIRST-of( ub.chk-pay.curr-code ) then do:
              assign
              acc-sub-curr-sum = 0
              acc-sub-curr-base = 0
              acc-sub-curr-rubl = 0
            acc-curr-sum = 0
            acc-curr-base = 0
            acc-curr-rubl = 0
              .
          END.
          IF FIRST-OF(ub.chk-doc.pay-desk) then do:
              assign
              acc-sub-desk-rubl = 0
            acc-sub-desk-base = 0
            acc-desk-rubl = 0
            acc-desk-base = 0
              .
          end.
          assign
          acc-curr-sum = acc-curr-sum + ub.chk-pay.tot-sum
          acc-curr-base = acc-curr-base + ub.chk-pay.tot-base
          acc-curr-rubl = acc-curr-rubl + ub.chk-pay.tot-rubl
          acc-desk-base = acc-desk-base + ub.chk-pay.tot-base
          acc-desk-rubl = acc-desk-rubl + ub.chk-pay.tot-rubl
          acc-rubl = acc-rubl + ub.chk-pay.tot-rubl
          acc-count = acc-count + 1
          .

          if ( acc-count modulo 25 ) = 0
          AND  acc-count >= 25
          then do:
          run waitfram-show in this-procedure ( obj-list.obj-type + string( obj-list.obj-code ) +
                          ", обработано строк чеков : " +
                            string( acc-count ) ) .
          end.
          if lookup(string(ub.chk-doc.chk-type), {&no-sale-receipt-codes}) > 0
&if "{2}" = "time" &then
          or (T-time and NOT can-find(FIRST times where
                                            times.time1  <= ub.chk-doc.chk-time AND
                                            times.time2 >= ub.chk-doc.chk-time))
&endif
                                            then do:
            assign
            acc-sub-curr-sum = acc-sub-curr-sum + ub.chk-pay.tot-sum
            acc-sub-curr-base = acc-sub-curr-base + ub.chk-pay.tot-base
            acc-sub-curr-rubl = acc-sub-curr-rubl + ub.chk-pay.tot-rubl
            acc-sub-desk-rubl = acc-sub-desk-rubl + ub.chk-pay.tot-rubl
            acc-sub-desk-base = acc-sub-desk-base + ub.chk-pay.tot-base
            .
          end.
          { rep/e-bcrbnp.i  }
        END.
      END. /*when no*/
    END CASE.
    CREATE all-days_sum .
    assign
    all-days_sum.obj-type = obj-list.obj-type
    all-days_sum.obj-code = obj-list.obj-code
    all-days_sum.tot-base = acc-day-base
    all-days_sum.tot-rubl = acc-day-rubl
    all-days_sum.tot-r-b = (if v-curr-r-b = {&r-b-rubl}
                            then all-days_sum.tot-rubl
                            else all-days_sum.tot-base)
    all-days_sum.chk-cnt  = acc-day-cnt
    all-days_sum.pay-desk = ub.chk-doc.pay-desk
    AllDay-BaseSum = AllDay-BaseSum + acc-day-base
    AllDay-RublSum = AllDay-RublSum + acc-day-rubl
    .
END. /*FOR EACH OBJ-LIST*/

run waitfram-hide in this-procedure .

if x-date-start = x-date-end then
choice = TRUE .
else
choice = HowBreak .

&if "{1}" = "tot" &then
run prn-lib-open-stream  in this-procedure (
                                             input parParentProc
                                            ,input {&LS_PS_A4}
                                            ,input yes /*p-is-stream*/
                                            ,input no /*p-append*/
                                            ).
&else
run prn-lib-open-stream  in this-procedure (
                                             input parParentProc
                                            ,input {&LS_PS_A4}
                                            ,input yes /*p-is-stream*/
                                            ,input no /*p-append*/
                                            ).
&endif


FORM HEADER
Line format "X(136)" AT 1 SKIP
"Продолжение - на следующей странице" AT 30 SKIP
with FRAME BottomFrame width {&A4_CW} PAGE-BOTTOM NO-LABELS NO-BOX .
VIEW stream PrnLibStream FRAME BottomFrame .
PUT stream PrnLibStream UNFORMATTED
space(5) string( "ОТЧЕТ  О  ВЫРУЧКЕ " + str1) format "X(120)" SKIP(1)
str4 skip(0)
space(5)
(IF NotInc
  then
  "( сформирован по ВСЕМ ЧЕКАМ " + (IF cas-num = 0 then "ВСЕХ КАСС" ELSE
    ("КАССЫ " + string(cas-num))) + " , включая невошедшие в отчеты о продажах )"
  else
  "( сформирован по ВСЕМ ЧЕКАМ " + (IF cas-num = 0 then "ВСЕХ КАСС" ELSE
    ("КАССЫ " + string(cas-num) ) ) + ")"
  ) format "x(80)" skip
space(5) string( "( всего чеков : " + string( ChkAmount ) +
", в среднем " + string( (if ChkAmount > 0 then  round((if v-curr-r-b = {&r-b-rubl}
                                                        then AllDay-RublSum
                                                        else AllDay-BaseSum)
                                                        / ChkAmount, 2 ) else 0) ) +
" " + sale-price-type + " / на чек )" ) format "x(80)" skip(1)
.
&if "{2}" = "time" &then
IF T-time then do:
  PUT stream PrnLibStream UNFORMATTED
  "Выборочно по времени: ".
  FOR EACH times No-LOCK :
    PUT stream PrnLibStream UNFORMATTED
    times
    {&space-char}
    .
  END.
  PUT stream PrnLibStream UNFORMATTED
  SKIP (1).
end.
&endif

if choice then do:
  FORM with frame Benefit-{1}.
end.
else do:
  FORM with FRAME PayCodes-{1} .
end.
FOR EACH obj-list WHERE
          obj-list.obj-type = {&shop} ,
    EACH all-days_sum WHERE
          all-days_sum.obj-type = obj-list.obj-type AND
          all-days_sum.obj-code = obj-list.obj-code
BREAK
BY obj-list.obj-type
BY obj-list.obj-code :
  ACCUMULATE
  all-days_sum.tot-base ( TOTAL )
  all-days_sum.tot-rubl ( TOTAL )
  all-days_sum.tot-r-b ( TOTAL )
  obj-list.obj-code ( COUNT ) .
  if choice then do:
    FOR EACH benefits WHERE
              benefits.obj-type = obj-list.obj-type AND
              benefits.obj-code = obj-list.obj-code
    BREAK
    BY benefits.obj-type
    BY benefits.obj-code
    BY benefits.pay-desk
    BY benefits.pay-code
    BY benefits.curr-code :
      if first( benefits.obj-code ) then do:
        FIND FIRST clients WHERE
                    clients.obj-type = obj-list.obj-type  AND
                    clients.obj-code = obj-list.obj-code  NO-LOCK .
        DOWN stream PrnLibStream 1 with frame Benefit-{1} .
        PUT stream PrnLibStream space(10) clients.obj-name format "x(60)" skip.

        UNDERLINE stream PrnLibStream
        benefits.pay-name
&if "{1}" = "tot" &then
        benefits.curr-name
        benefits.tot-base
&endif
&if "{1}" = "base" &then
        benefits.tot-r-b
&else
        benefits.tot-rubl
&endif
        benefits.pcnt
        with frame Benefit-{1}.
      end.
      if first-of( benefits.pay-desk ) then do:
        FIND FIRST day_sum WHERE
                    day_sum.obj-type = obj-list.obj-type AND
                    day_sum.obj-code = obj-list.obj-code AND
                    day_sum.pay-desk = benefits.pay-desk NO-ERROR.
        DatePrinted = FALSE .
      end.
&if "{1}" = "rubl" &then
      benefits.pcnt = round( benefits.tot-rubl / day_sum.tot-rubl * 100 , 2 ) .
&else
      benefits.pcnt = round( benefits.tot-r-b / day_sum.tot-r-b * 100 , 2 ) .
&endif
      if benefits.tot-base  <> 0
      or day_sum.chk-cnt <> 0
      then do:
        if DatePrinted then do:
          DISPLAY stream PrnLibStream
          sym1
          " " format "X(8)" @ benefits.date_ column-label "Касса"
          sym2 benefits.pay-name
&if "{1}" = "tot" &then
          sym3 benefits.curr-name
          sym4 benefits.tot-sum
          sym5 benefits.tot-base
&endif
&if "{1}" = "base" &then
          sym6 benefits.tot-r-b
&else
          sym6 benefits.tot-rubl
&endif
          sym7 benefits.pcnt
          sym8
          with frame Benefit-{1} .
          DOWN stream PrnLibStream 1 with frame Benefit-{1} .
        end.
        else do:
          DISPLAY stream PrnLibStream
          sym1 benefits.pay-desk @ benefits.date_ column-label "Касса"
          sym2 benefits.pay-name
&if "{1}" = "tot" &then
          sym3 benefits.curr-name
          sym4 benefits.tot-sum
          sym5 benefits.tot-base
&endif
&if "{1}" = "base" &then
          sym6 benefits.tot-r-b
&else
          sym6 benefits.tot-rubl
&endif
          sym7 benefits.pcnt
          sym8
          with frame Benefit-{1} .
          DOWN stream PrnLibStream 1 with frame Benefit-{1}.
          DatePrinted = TRUE .
        end.
      end.
      if last-of( benefits.pay-desk ) then do:
        ACCUMULATE
        day_sum.tot-base ( TOTAL )
        day_sum.tot-rubl ( TOTAL )
        day_sum.tot-r-b ( TOTAL )
        day_sum.chk-cnt ( TOTAL )
        .
        if day_sum.chk-cnt <> 0 then do:
          UNDERLINE stream PrnLibStream
          benefits.pay-name
&if "{1}" = "tot" &then
          benefits.curr-name
          benefits.tot-base
&endif
&if "{1}" = "base" &then
          benefits.tot-r-b
&else
          benefits.tot-rubl
&endif
          benefits.pcnt
          with frame Benefit-{1} .
&if "{1}" = "tot" &then
          DISPLAY stream PrnLibStream
          sym1
          ("чеков: " + string(day_sum.chk-cnt, ">>>>>") + ",")
            @ benefits.pay-name
          (string( ROUND(day_sum.tot-base / day_sum.chk-cnt , 2) ,
                  "->>>,>>9.99" ) + "/ чек" ) @ benefits.curr-name
          day_sum.tot-base  @ benefits.tot-base
          day_sum.tot-rubl  @ benefits.tot-rubl
          "100.00%" @ benefits.pcnt
          sym8
          with frame Benefit-{1} .
&endif
&if "{1}" = "base" &then
          DISPLAY stream PrnLibStream
          sym1
          ("чеков: " + string(day_sum.chk-cnt, ">>>>>") +
          ", в среднем " +
          string( ROUND(day_sum.tot-r-b / day_sum.chk-cnt , 2) ,
                "->>>,>>9.99" ) +
            "/ чек" ) @ benefits.pay-name
          day_sum.tot-r-b  @ benefits.tot-r-b
          "100.00%" @ benefits.pcnt
          sym8
          with frame Benefit-{1} .
&endif
&if "{1}" = "rubl" &then
          DISPLAY stream PrnLibStream
          sym1
          ("чеков: " + string(day_sum.chk-cnt, ">>>>>") +
          ", в среднем " +
          string( ROUND(day_sum.tot-rubl / day_sum.chk-cnt , 2) ,
                "->>>,>>9.99" ) +
            "/ чек" ) @ benefits.pay-name
          day_sum.tot-rubl  @ benefits.tot-rubl
          "100.00%" @ benefits.pcnt
          sym8
          with frame Benefit-{1} .
&endif
          UNDERLINE stream PrnLibStream
          benefits.pay-name
&if "{1}" = "tot" &then
          benefits.curr-name
          benefits.tot-base
&endif
&if "{1}" = "base" &then
          benefits.tot-r-b
&else
          benefits.tot-rubl
&endif
          benefits.pcnt
          with frame Benefit-{1} .
        end.
      end.
      if last( benefits.pay-desk ) AND ( x-date-start <> x-date-end ) then do:
        UNDERLINE stream PrnLibStream
        benefits.pay-name
&if "{1}" = "tot" &then
        benefits.curr-name
        benefits.tot-base
&endif
&if "{1}" = "base" &then
        benefits.tot-r-b
&else
        benefits.tot-rubl
&endif
        benefits.pcnt
        with frame Benefit-{1} .
&if "{1}" = "tot" &then
        DISPLAY stream PrnLibStream
        (" ИТОГО  чеков: " + string(ACCUM TOTAL day_sum.chk-cnt) )  @ benefits.pay-name
        ACCUM TOTAL day_sum.tot-base  @ benefits.tot-base
        ACCUM TOTAL day_sum.tot-rubl  @ benefits.tot-rubl
        with frame Benefit-{1} .
        DOWN stream PrnLibStream 1 with frame Benefit-{1}.
&endif
&if "{1}" = "base" &then
        DISPLAY stream PrnLibStream
        (" ИТОГО чеков: " + string(ACCUM TOTAL day_sum.chk-cnt) )  @ benefits.pay-name
        ACCUM TOTAL day_sum.tot-r-b  @ benefits.tot-r-b
        with frame Benefit-{1} .
&endif
&if "{1}" = "rubl" &then
        DISPLAY stream PrnLibStream
        (" ИТОГО чеков: " + string(ACCUM TOTAL day_sum.chk-cnt) )  @ benefits.pay-name
        ACCUM TOTAL day_sum.tot-rubl  @ benefits.tot-rubl
        with frame Benefit-{1} .
&endif
        DOWN stream PrnLibStream 1 with frame Benefit-{1}.
        if NOT last( obj-list.obj-code ) then do:
          UNDERLINE stream PrnLibStream
          benefits.pay-name
&if "{1}" = "tot" &then
          benefits.curr-name
          benefits.tot-base
&endif
&if "{1}" = "base" &then
          benefits.tot-r-b
&else
          benefits.tot-rubl
&endif
          benefits.pcnt
          with frame Benefit-{1} .
        end.
      end.
    END.
  end.
  if last( obj-list.obj-code ) AND ( ACCUM COUNT obj-list.obj-code ) > 1 then do:
&if "{1}" = "tot" &then
    DISPLAY stream PrnLibStream
    "ИТОГО по всем" @ benefits.pay-name
    ACCUM TOTAL all-days_sum.tot-base @ benefits.tot-base
    ACCUM TOTAL all-days_sum.tot-rubl @ benefits.tot-rubl
    with FRAME Benefit-{1} .
&endif
&if "{1}" = "base" &then
    DISPLAY stream PrnLibStream
    "ИТОГО по всем" @ benefits.pay-name
    ( ACCUM TOTAL all-days_sum.tot-r-b ) @ benefits.tot-r-b
    with FRAME Benefit-{1} .
&endif
&if "{1}" = "rubl" &then
    DISPLAY stream PrnLibStream
    "ИТОГО по всем" @ benefits.pay-name
    ( ACCUM TOTAL all-days_sum.tot-rubl ) @ benefits.tot-rubl
    with FRAME Benefit-{1} .
&endif
  end.
END.    /* FOR EACH obj-list ... */

if  ObjAmount > 1  then do:
  FORM with frame ZUM-PayCodes-{1} .
  FOR EACH benefits
  BREAK
  BY benefits.pay-code
  BY benefits.curr-code
  :
    ACCUMULATE
    benefits.tot-sum ( SUB-TOTAL BY benefits.curr-code )
    benefits.tot-base ( SUB-TOTAL BY benefits.curr-code )
    benefits.tot-rubl ( SUB-TOTAL BY benefits.curr-code )
    benefits.tot-r-b ( SUB-TOTAL BY benefits.curr-code )
    .
    if last-of( benefits.curr-code ) AND
      ( ACCUM SUB-TOTAL BY benefits.curr-code benefits.tot-base ) <> 0 then dO:
&if "{1}" = "tot" &then
      DISPLAY stream PrnLibStream
      ( "/итого по " + benefits.pay-name ) @ benefits.pay-name
      ( ACCUM SUB-TOTAL BY benefits.curr-code benefits.tot-base ) @ benefits.tot-base
      ( ACCUM SUB-TOTAL BY benefits.curr-code benefits.tot-rubl ) @ benefits.tot-rubl
      with frame ZUM-PayCodes-{1}.
&endif
&if "{1}" = "base" &then
      DISPLAY stream PrnLibStream
      ( "/итого по " + benefits.pay-name ) @ benefits.pay-name
      ( ACCUM SUB-TOTAL BY benefits.curr-code benefits.tot-r-b ) @ benefits.tot-r-b
      with frame ZUM-PayCodes-{1}.
&endif
&if "{1}" = "rubl" &then
      DISPLAY stream PrnLibStream
      ( "/итого по " + benefits.pay-name ) @ benefits.pay-name
      ( ACCUM SUB-TOTAL BY benefits.curr-code benefits.tot-rubl ) @ benefits.tot-rubl
      with frame ZUM-PayCodes-{1}.
&endif
      DOWN stream PrnLibStream 1 with frame ZUM-PayCodes-{1} .

    end.
  END.
end.

HIDE stream PrnLibStream FRAME BottomFrame .
&if "{1}" = "tot" &then
PUT stream PrnLibStream Line format "X(136)" SKIP(1) .
&else
PUT stream PrnLibStream Line format "X(82)" SKIP(1) .
&endif
if ( ACCUM COUNT obj-list.obj-code ) < 2 then do:
  if ( line-counter( PrnLibStream ) + 9 ) > page-size( PrnLibStream ) then page stream PrnLibStream.
  PUT stream PrnLibStream
  space(10) "Директор _______________" format "X(30)"
  "Старший продавец ______________" format "X(30)" SKIP(2)
  space(10) "Бухгалтер ______________" format "X(30)"
  "Кассир ________________________" format "X(30)" SKIP .
  end.
  output stream PrnLibStream CLOSE.
/*
assign
g#rep-tblname = ""
g#rep-tblrid = -101
g#rep-updflds = string( "Отчет о выручке|" + str1 ) .
*/

&if "{1}" = "tot" &then
run prn-lib-prn-file in this-procedure (
                                          input parParentProc
                                          ,input 8
                                          ).
&else
run prn-lib-prn-file in this-procedure (
                                          input parParentProc
                                          ,input 9
                                          ).

&endif

/* $Workfile$ e n d */