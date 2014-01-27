/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Заполнение временной таблицы по чекам для отчета о выручке

Автор: Бахтадзе Наталья Викторовна
Дата создания: 09/07/05
Author: Bakhtadze Natalya
Creation date: 09/07/05

*/

define input parameter cas-num as integer no-undo .
define input parameter t-time as logical no-undo .
define input parameter v-curr-r-b as character no-undo .
define output parameter AllDay-BaseSum as decimal no-undo .
define output parameter AllDay-RublSum as decimal no-undo .
define output parameter ObjAmount    as      integer no-undo.
define output parameter ChkAmount    as      integer no-undo.

{ cmp/str-glbl.i }
{ cmp/library.i }
{ cmp/r-page1.i }
{ rep/r-bentt.i shared }
{ rep/rep-bt.i }
{ gbl/waitfram.i }


&if "{1}" = "time" &then
{ rep/r-benttm.i shared }
&endif


define variable acc-curr-sum as decimal no-undo.
define variable acc-curr-base as decimal no-undo.
define variable acc-curr-rubl as decimal no-undo.
define variable acc-sub-curr-sum as decimal no-undo.
define variable acc-sub-curr-base as decimal no-undo.
define variable acc-sub-curr-rubl as decimal no-undo.
define variable acc-base as decimal no-undo.
define variable acc-rubl as decimal no-undo.
define variable acc-netto as decimal no-undo.
define variable acc-count as integer no-undo.
define variable acc-sub-netto as decimal no-undo.
define variable acc-sub-count as integer no-undo.
define variable acc-date-base as decimal no-undo.
define variable acc-date-rubl as decimal no-undo.
define variable acc-date-netto as decimal no-undo.
define variable acc-date-count as integer no-undo.
define variable acc-sub-date-base as decimal no-undo.
define variable acc-sub-date-rubl as decimal no-undo.
define variable acc-sub-date-netto as decimal no-undo.
define variable acc-sub-date-count as integer no-undo.
define variable acc-day-rubl as decimal no-undo .
define variable acc-day-base as decimal no-undo .
define variable acc-day-cnt as integer no-undo .
DEFINE VARIABLE is-counted as logical no-undo .

FOR EACH obj-list WHERE obj-list.obj-type = {&shop} NO-LOCK :
  ObjAmount = ObjAmount + 1.
  CASE X-Radio-task > 1 :
    WHEN YES THEN DO:
      _chk-doc:
      FOR EACH ub.chk-doc WHERE
                ub.chk-doc.obj-type = obj-list.obj-type AND
                ub.chk-doc.obj-code = obj-list.obj-code AND
              ( ub.chk-doc.shift-date >= x-date-start AND
                ub.chk-doc.shift-date <= x-date-end)
                AND
              (IF cas-num > 0 then ub.chk-doc.pay-desk = cas-num else TRUE)
                NO-LOCK
      BREAK
      BY ub.chk-doc.obj-type
      BY ub.chk-doc.obj-code
      BY ub.chk-doc.shift-date:
        is-counted = no.
        IF FIRST-OF(ub.chk-doc.shift-date) then do:
            assign
              acc-sub-date-netto = 0
              acc-sub-date-count = 0
          acc-date-netto = 0
          acc-date-count = 0
            .
        end.
        IF X-Radio-task = 3 AND
            ((ub.chk-doc.shift-date = x-date-start AND ub.chk-doc.shift-num < X-shift-start) OR
              (ub.chk-doc.shift-date = x-date-end AND  ub.chk-doc.shift-num > X-shift-end) ) THEN DO:
              assign
              acc-sub-date-netto = acc-sub-date-netto + ub.chk-doc.netto
              acc-sub-date-count = acc-sub-date-count + 1
              is-counted = yes
              .
        END.
        IF X-radio-task = 4 AND
        ub.chk-doc.shift-num <> X-Shift-Alone then DO:
              assign
              acc-sub-date-netto = acc-sub-date-netto + ub.chk-doc.netto
              acc-sub-date-count = acc-sub-date-count + 1
              is-counted = yes
              .
        END.
        if lookup(string(ub.chk-doc.chk-type), {&no-sale-receipt-codes}) > 0
&if "{1}" = "time" &then
        or T-time AND NOT is-counted AND
                      NOT can-find(FIRST times No-LOCK WHERE
                                        times.time1 <= ub.chk-doc.chk-time AND
                                        times.time2 >= ub.chk-doc.chk-time)
&endif
                                        then do:
          assign
          acc-sub-date-netto = acc-sub-date-netto + ub.chk-doc.netto
          acc-sub-date-count = acc-sub-date-count + 1
          .
        end.
        assign
        acc-date-netto = acc-date-netto + ub.chk-doc.netto
          acc-date-count = acc-date-count + 1
          .
        if last-of( ub.chk-doc.shift-date ) then  do:
          assign
          acc-netto = acc-netto + acc-date-netto
          acc-count = acc-count + acc-date-count
          acc-sub-netto = acc-sub-netto + acc-sub-date-netto
          acc-sub-count = acc-sub-count + acc-sub-date-count
          .
          create day_sum.
          assign
          day_sum.obj-type = obj-list.obj-type
          day_sum.obj-code = obj-list.obj-code
          day_sum.date = ub.chk-doc.shift-date
          day_sum.tot-base =  acc-date-netto - acc-sub-date-netto
          day_sum.chk-cnt  =  acc-date-count - acc-sub-date-count
          .
        end.
      END. /*FOR EACH ub.chk-doc*/
    END. /*WHEN YES*/
    WHEN NO THEN DO:
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
      BY ub.chk-doc.chk-date:
        IF FIRST-OF(ub.chk-doc.chk-date) then do:
          assign
          acc-sub-date-netto = 0
          acc-sub-date-count = 0
          acc-date-netto = 0
          acc-date-count = 0
          .
        end.
        if lookup(string(ub.chk-doc.chk-type), {&no-sale-receipt-codes}) > 0
&if "{1}" = "time" &then
        or (T-time AND NOT can-find(FIRST times No-LOCK WHERE
                                        times.time1 <= ub.chk-doc.chk-time AND
                                        times.time2 >= ub.chk-doc.chk-time))
&endif
                                        then do:
          assign
          acc-sub-date-netto = acc-sub-date-netto + ub.chk-doc.netto
          acc-sub-date-count = acc-sub-date-count + 1
         .
        end.
        assign
        acc-date-netto = acc-date-netto + ub.chk-doc.netto
          acc-date-count = acc-date-count + 1
          .
        if last-of( ub.chk-doc.chk-date) then  do:
          assign
          acc-netto = acc-netto + acc-date-netto
          acc-count = acc-count + acc-date-count
          acc-sub-netto = acc-sub-netto + acc-sub-date-netto
          acc-sub-count = acc-sub-count + acc-sub-date-count
          .
          create day_sum.
          assign
          day_sum.obj-type = obj-list.obj-type
          day_sum.obj-code = obj-list.obj-code
          day_sum.date = ub.chk-doc.chk-date
          day_sum.tot-base =  acc-date-netto - acc-sub-date-netto
          day_sum.chk-cnt  =  acc-date-count - acc-sub-date-count
          .
        end.
      END. /*FOR EACH ub.chk-doc*/
    END. /*WHEN NO*/
  END CASE.
END. /*FOR EACH obj-list*/
assign
ChkAmount = acc-count -  acc-sub-count
AllDay-BaseSUm = 0
.

FOR EACH obj-list WHERE
         obj-list.obj-type = {&shop} NO-LOCK :
  assign
  acc-day-base = 0
  acc-day-rubl = 0
  acc-day-cnt = 0
  acc-count = 0
  .

  CASE X-radio-task > 1:
    WHEN YES THEN DO:
      _chk-doc3:
      FOR EACH ub.chk-doc NO-LOCK WHERE
                ub.chk-doc.obj-type = obj-list.obj-type
            AND ub.chk-doc.obj-code = obj-list.obj-code
            AND ub.chk-doc.shift-date >= x-date-start
            AND ub.chk-doc.shift-date <= x-date-end
            AND (IF cas-num > 0 then ub.chk-doc.pay-desk = cas-num else TRUE),
      EACH ub.chk-pay No-LOCK WHERE
           ub.chk-pay.doc-code = ub.chk-doc.doc-code
      BREAK
      BY ub.chk-doc.obj-type
      BY ub.chk-doc.obj-code
      BY ub.chk-doc.shift-date
      BY ub.chk-pay.out-code
      BY ub.chk-pay.pay-code
      BY ub.chk-pay.curr-code :
        is-counted = yes.
        if FIRST-of( ub.chk-pay.curr-code ) then do:
          assign
          acc-sub-curr-sum = 0
          acc-sub-curr-base = 0
          acc-sub-curr-rubl = 0
          acc-curr-sum = 0
          acc-curr-base = 0
          acc-curr-rubl = 0
          .
        end.
        if first-of( ub.chk-doc.shift-date ) then do:
          assign
          acc-date-rubl = 0
          acc-date-base = 0
          acc-sub-date-rubl = 0
          acc-sub-date-base = 0
          .
        end.
        IF X-radio-task = 3 AND
        ((ub.chk-doc.shift-date = x-date-start AND ub.chk-doc.shift-num < X-shift-start) OR
          (ub.chk-doc.shift-date = x-date-end AND  ub.chk-doc.shift-num > X-shift-end) ) THEN DO:
          assign
          acc-sub-curr-sum = acc-sub-curr-sum + ub.chk-pay.tot-sum
          acc-sub-curr-base = acc-sub-curr-base + ub.chk-pay.tot-base
          acc-sub-curr-rubl = acc-sub-curr-rubl + ub.chk-pay.tot-rubl
          acc-sub-date-rubl = acc-sub-date-rubl + ub.chk-pay.tot-rubl
          acc-sub-date-base = acc-sub-date-base + ub.chk-pay.tot-base
          is-counted = yes
          .
        END.
        IF X-radio-task = 4 AND
        ub.chk-doc.shift-num <> X-Shift-Alone then DO:
          assign
          acc-sub-curr-sum = acc-sub-curr-sum + ub.chk-pay.tot-sum
          acc-sub-curr-base = acc-sub-curr-base + ub.chk-pay.tot-base
          acc-sub-curr-rubl = acc-sub-curr-rubl + ub.chk-pay.tot-rubl
          acc-sub-date-rubl = acc-sub-date-rubl + ub.chk-pay.tot-rubl
          acc-sub-date-base = acc-sub-date-base + ub.chk-pay.tot-base
          is-counted = yes
          .
        END.
        if lookup(string(ub.chk-doc.chk-type), {&no-sale-receipt-codes}) > 0
&if "{1}" = "time" &then
        or (T-time AND Not is-counted AND
                        NOT can-find(FIRST times No-LOCK WHERE
                                            times.time1 <= ub.chk-doc.chk-time AND
                                            times.time2 >= ub.chk-doc.chk-time))
&endif
                                              then do:
            assign
            acc-sub-curr-sum = acc-sub-curr-sum + ub.chk-pay.tot-sum
            acc-sub-curr-base = acc-sub-curr-base + ub.chk-pay.tot-base
            acc-sub-curr-rubl = acc-sub-curr-rubl + ub.chk-pay.tot-rubl
            acc-sub-date-rubl = acc-sub-date-rubl + ub.chk-pay.tot-rubl
            acc-sub-date-base = acc-sub-date-base + ub.chk-pay.tot-base
            .
          END.
        assign
        acc-curr-sum = acc-curr-sum + ub.chk-pay.tot-sum
        acc-curr-base = acc-curr-base + ub.chk-pay.tot-base
        acc-curr-rubl = acc-curr-rubl + ub.chk-pay.tot-rubl
        .
        { rep/e-bcrben.i ub.chk-doc.shift-date }
      END. /*FOR EACH ub.chk-doc*/
    END. /*WHEN YES*/
    WHEN NO THEN DO:
      _chk-doc4:
      FOR EACH ub.chk-pay No-LOCK WHERE
              ub.chk-pay.obj-type = obj-list.obj-type AND
              ub.chk-pay.obj-code = obj-list.obj-code AND
              ub.chk-pay.chk-date >= x-date-start AND
              ub.chk-pay.chk-date <= x-date-end,
          FIRST ub.chk-doc NO-LOCK WHERE
                    ub.chk-pay.doc-code = ub.chk-doc.doc-code  AND
                    (IF cas-num > 0 then ub.chk-doc.pay-desk = cas-num else TRUE)
      BREAK
      BY ub.chk-pay.obj-type
      BY ub.chk-pay.obj-code
      BY ub.chk-pay.chk-date
      BY ub.chk-pay.pay-code
      BY ub.chk-pay.curr-code :

        if FIRST-of( ub.chk-pay.curr-code ) then do:
          assign
          acc-sub-curr-sum = 0
          acc-sub-curr-base = 0
          acc-sub-curr-rubl = 0
          acc-curr-sum = 0
          acc-curr-base = 0
          acc-curr-rubl = 0
          .
        end.
        if first-of( ub.chk-pay.chk-date ) then do:
          assign
          acc-date-rubl = 0
          acc-date-base = 0
          acc-sub-date-rubl = 0
          acc-sub-date-base = 0
          .
        end.
        if lookup(string(ub.chk-doc.chk-type), {&no-sale-receipt-codes}) > 0
&if "{1}" = "time" &then
        or (T-time AND NOT can-find(FIRST times No-LOCK WHERE
                                          times.time1 <= ub.chk-doc.chk-time AND
                                          times.time2 >= ub.chk-doc.chk-time) )
&endif
                                          then do:
          assign
          acc-sub-curr-sum = acc-sub-curr-sum + ub.chk-pay.tot-sum
          acc-sub-curr-base = acc-sub-curr-base + ub.chk-pay.tot-base
          acc-sub-curr-rubl = acc-sub-curr-rubl + ub.chk-pay.tot-rubl
          acc-sub-date-rubl = acc-sub-date-rubl + ub.chk-pay.tot-rubl
          acc-sub-date-base = acc-sub-date-base + ub.chk-pay.tot-base
          .
        END.
        assign
        acc-curr-sum = acc-curr-sum + ub.chk-pay.tot-sum
        acc-curr-base = acc-curr-base + ub.chk-pay.tot-base
        acc-curr-rubl = acc-curr-rubl + ub.chk-pay.tot-rubl
        .
        { rep/e-bcrben.i ub.chk-pay.chk-date  }
      END. /*FOR EACH ub.chk-doc*/
    END. /*WHEN NO*/
  END CASE.
  CREATE all-days_sum .
  assign
  all-days_sum.obj-type = obj-list.obj-type
  all-days_sum.obj-code = obj-list.obj-code
  all-days_sum.tot-base = acc-day-base
  all-days_sum.tot-rubl = acc-day-rubl
  all-days_sum.tot-r-b  = (if v-curr-r-b = {&r-b-base}
                           then all-days_sum.tot-base
                           else all-days_sum.tot-rubl)
  all-days_sum.chk-cnt = acc-day-cnt
  AllDay-BaseSum = AllDay-BaseSum + (if v-curr-r-b = {&r-b-base}
                                     then acc-day-base
                                     else acc-day-rubl
                                     )
  AllDay-rublSum = AllDay-RublSum + acc-day-rubl
 .
END. /*FOR EACH obj-list*/

run waitfram-hide in this-procedure .
/* $Workfile$ e n d */