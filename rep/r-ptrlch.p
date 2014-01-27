/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Технологический отчет по АЗК - сбор данных и печать

Автор: Бахтадзе Наталья Викторовна
Дата создания: 10/16/05
Author: Bakhtadze Natalya
Creation date: 10/16/05

*/


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Технологический отчет по АЗК - сбор данных и печать".
{ cmp/vssrevis.i }

{ cmp/str-glbl.i }
{ cmp/library.i }
{ cmp/r-pril.i new }
{ cmp/r-page1.i }
{ gbl/waitfram.i }
{ gbl/prn-lib.i }
{ gbl/cur-time.i }


define variable Line   as character no-undo .
define variable date_string   as character no-undo .


define variable multi-obj as logical no-undo.
define variable obj-count as integer   no-undo .
define variable jj as integer   no-undo .
define variable v-chk-type like ub.chk-doc.chk-type no-undo .
define variable v-type-num as integer   no-undo .


define variable accum-pay-desk-doc-qnty as decimal no-undo .
define variable accum-pay-desk-sum-base as decimal no-undo .
define variable accum-pay-desk-trans-number as integer   no-undo .
define variable accum-gds-code-doc-qnty as decimal no-undo .
define variable accum-gds-code-sum-base as decimal no-undo .
define variable accum-gds-code-trans-number as integer   no-undo .
define variable accum-doc-qnty as decimal no-undo .
define variable accum-sum-base as decimal no-undo .
define variable accum-trans-number as integer   no-undo .

define buffer buf_chk-doc for ub.chk-doc.

define temp-table temp-petrol-chk no-undo
field obj-type like ub.chk-doc.obj-type init '':U
field obj-code like ub.chk-doc.obj-code init 0
field chk-type like ub.chk-doc.chk-type init 0
field pay-desk like ub.chk-doc.pay-desk init 0
field gds-code like ub.goods.gds-code
field pump like ub.chk-gds.pump         init 0
field pump-2 like ub.chk-gds.pump       init 0
field doc-qnty like ub.chk-gds.doc-qnty init 0
field sum-base like ub.chk-gds.sum-base init 0
field trans-number as integer
field prim as logical
index pi is unique primary
obj-type obj-code
chk-type
pay-desk
gds-code
pump
pump-2
index  ip
prim
.

define buffer buf_temp-petrol-chk for temp-petrol-chk.

define temp-table temp-goods no-undo
field gds-code like ub.goods.gds-code
field gds-name like ub.goods.gds-name
index pi is unique primary
gds-code.

define buffer buf_temp-goods for temp-goods.

DEFINE FRAME one-pump
buf_temp-petrol-chk.pay-desk column-label "Касса" format ">>>9"
buf_temp-goods.gds-name               column-label "Топливо" format "X(25)"
buf_temp-petrol-chk.pump     column-label "ТРК" format ">>>>9"
buf_temp-petrol-chk.doc-qnty column-label "Кол-во в л" format      "->>,>>>,>>9.9999999999"
buf_temp-petrol-chk.sum-base column-label "Сумма"      format "->>>,>>>,>>>,>>9.99"
buf_temp-petrol-chk.trans-number column-label "Кол-во чеков"      format ">>>,>>>"
HEADER  date_string format "X(50)" AT 5
"Страница " AT 95 PAGE-NUMBER(PrnLibStream) AT 105 FORMAT ">>>9" SKIP
Line format "X(123)"   AT 1
with width  {&A4_CW0} down stream-io use-text.

DEFINE FRAME two-pump
buf_temp-petrol-chk.pay-desk column-label "Касса" format ">>>9"
buf_temp-goods.gds-name               column-label "Топливо" format "X(25)"
buf_temp-petrol-chk.pump     column-label "Откуда:!№ ТРК" format ">>>>9"
buf_temp-petrol-chk.pump-2   column-label "Kуда:!№ ТРК" format ">>>>9"
buf_temp-petrol-chk.doc-qnty column-label "Кол-во в л" format      "->>,>>>,>>9.9999999999"
buf_temp-petrol-chk.sum-base column-label "Сумма"      format "->>>,>>>,>>>,>>9.99"
buf_temp-petrol-chk.trans-number column-label "Кол-во чеков"      format ">>>,>>>"
HEADER  date_string format "X(50)" AT 5
"Страница " AT 95 PAGE-NUMBER(PrnLibStream) AT 105 FORMAT ">>>9" SKIP
Line format "X(123)"   AT 1
with width  {&A4_CW0} down stream-io use-text.


FOR EACH temp-petrol-chk:
  delete temp-petrol-chk.
END.

run waitfram-show in this-procedure ("Ждите...").

for each obj-list No-LOCK:
  obj-count = obj-count + 1.
end.
if obj-count > 1 then do:
  multi-obj = yes.
end.



procedure fill-temp-table :
define input  parameter p-doc-code like ub.chk-doc.doc-code no-undo .
define input  parameter p-chk-type like ub.chk-doc.chk-type no-undo .
define variable v-pump as integer   no-undo .
define variable v-pump-2 as integer   no-undo .
define variable ii as integer   no-undo .
define variable v-qnty like ub.chk-gds.doc-qnty no-undo init 0.
define variable v-sum like ub.chk-gds.sum-base no-undo init 0.

define buffer buf_chk-gds for ub.chk-gds.
define buffer buf_bar-code for ub.bar-code.

define buffer buf_temp-petrol-chk for temp-petrol-chk.

  do
  on error undo, return error return-value
  :
    for each buf_chk-gds no-lock where
         buf_chk-gds.doc-code = buf_chk-doc.doc-code,
      first buf_bar-code no-lock where buf_bar-code.b-code = buf_chk-gds.b-code :
      ii = ii + 1.
      if p-chk-type = integer({&rcpt-trans-transfer}) then do:
        if buf_chk-gds.doc-qnty < 0 then
        assign
        v-pump = buf_chk-gds.pump
        v-qnty = abs(buf_chk-gds.doc-qnty)
        v-sum  = abs(buf_chk-gds.sum-base)
        .
        if buf_chk-gds.doc-qnty > 0 then
        assign
        v-pump-2 = buf_chk-gds.pump
        v-qnty = abs(buf_chk-gds.doc-qnty)
        v-sum  = abs(buf_chk-gds.sum-base)
        .
      end.
      else do:
        assign
        v-pump = buf_chk-gds.pump
        v-pump-2 = 0
        v-qnty = buf_chk-gds.doc-qnty
        v-sum  = (if buf_chk-gds.doc-qnty = 0 then 0 else buf_chk-gds.sum-base)
        .
      end.

      if p-chk-type <> integer({&rcpt-trans-transfer})
      or ii = 2 then do:
        find first buf_temp-petrol-chk where
                buf_temp-petrol-chk.chk-type = buf_chk-doc.chk-type
            AND buf_temp-petrol-chk.obj-type = buf_chk-doc.obj-type
            AND buf_temp-petrol-chk.obj-code = buf_chk-doc.obj-code
            AND buf_temp-petrol-chk.pay-desk = buf_chk-doc.pay-desk
            AND buf_temp-petrol-chk.gds-code = buf_bar-code.gds-code
            AND buf_temp-petrol-chk.pump     = v-pump
            AND buf_temp-petrol-chk.pump-2   = v-pump-2 no-error .
        if not available buf_temp-petrol-chk then do:
          create buf_temp-petrol-chk.
          assign
          buf_temp-petrol-chk.chk-type = buf_chk-doc.chk-type
          buf_temp-petrol-chk.obj-type = buf_chk-doc.obj-type
          buf_temp-petrol-chk.obj-code = buf_chk-doc.obj-code
          buf_temp-petrol-chk.pay-desk = buf_chk-doc.pay-desk
          buf_temp-petrol-chk.gds-code = buf_bar-code.gds-code
          buf_temp-petrol-chk.pump     = v-pump
          buf_temp-petrol-chk.pump-2   = v-pump-2
          buf_temp-petrol-chk.prim     = yes
          .
        end.
        assign
        buf_temp-petrol-chk.doc-qnty = buf_temp-petrol-chk.doc-qnty + v-qnty
        buf_temp-petrol-chk.sum-base = buf_temp-petrol-chk.sum-base + v-sum
        buf_temp-petrol-chk.trans-number = buf_temp-petrol-chk.trans-number + 1
        .
      end. /*if p-chk-type <> integer({&rcpt-trans-transfer})*/
    end. /*for each buf_chk-gds*/
  end. /*doe*/

end procedure. /* fill-temp-table */



procedure fill-sub-totals :
define buffer buf_temp-petrol-chk for temp-petrol-chk.

define buffer gds-obj_temp-petrol-chk for temp-petrol-chk.
/*итоги по товару по объекту pay-desk = 0 pump = 0 */

define buffer pay-desk_temp-petrol-chk for temp-petrol-chk.
/*итоги по всем типам чеков chk-type = 0 */


define buffer gds_temp-petrol-chk for temp-petrol-chk.
/*итоги по всем объектам по товару pay-desk = 0 pump = 0  obj-code = 0*/

define buffer gds-obj0_temp-petrol-chk for temp-petrol-chk.
/*итоги по всем типам чеков по товару по объекту pay-desk = 0 pump = 0 chk-type = 0*/

define buffer gds0_temp-petrol-chk for temp-petrol-chk.
/*итоги по всем типам чеков по товару по всем объектам pay-desk = 0 pump = 0  obj-code = 0 chk-type = 0*/

define buffer buf_goods for ub.goods.
define buffer buf_temp-goods for temp-goods.

  do
  on error undo, return error return-value
  :

    for each buf_temp-petrol-chk where buf_temp-petrol-chk.prim = yes:
      find first pay-desk_temp-petrol-chk where
              pay-desk_temp-petrol-chk.chk-type = 0
          AND pay-desk_temp-petrol-chk.obj-type = buf_temp-petrol-chk.obj-type
          AND pay-desk_temp-petrol-chk.obj-code = buf_temp-petrol-chk.obj-code
          AND pay-desk_temp-petrol-chk.pay-desk = buf_temp-petrol-chk.pay-desk
          AND pay-desk_temp-petrol-chk.gds-code = buf_temp-petrol-chk.gds-code
          AND pay-desk_temp-petrol-chk.pump     = buf_temp-petrol-chk.pump
          AND pay-desk_temp-petrol-chk.pump-2   = 0
          no-error .
      if not available pay-desk_temp-petrol-chk then do:
        create pay-desk_temp-petrol-chk.
        assign
        pay-desk_temp-petrol-chk.chk-type = 0
        pay-desk_temp-petrol-chk.obj-type = buf_temp-petrol-chk.obj-type
        pay-desk_temp-petrol-chk.obj-code = buf_temp-petrol-chk.obj-code
        pay-desk_temp-petrol-chk.pay-desk = buf_temp-petrol-chk.pay-desk
        pay-desk_temp-petrol-chk.gds-code = buf_temp-petrol-chk.gds-code
        pay-desk_temp-petrol-chk.pump     = buf_temp-petrol-chk.pump
        pay-desk_temp-petrol-chk.pump-2   = 0
        .
      end.
      assign
      pay-desk_temp-petrol-chk.doc-qnty = pay-desk_temp-petrol-chk.doc-qnty + buf_temp-petrol-chk.doc-qnty
      pay-desk_temp-petrol-chk.sum-base = pay-desk_temp-petrol-chk.sum-base + buf_temp-petrol-chk.sum-base
      pay-desk_temp-petrol-chk.trans-number = pay-desk_temp-petrol-chk.trans-number + buf_temp-petrol-chk.trans-number
      .

      find first gds-obj_temp-petrol-chk where
              gds-obj_temp-petrol-chk.chk-type = buf_temp-petrol-chk.chk-type
          AND gds-obj_temp-petrol-chk.obj-type = buf_temp-petrol-chk.obj-type
          AND gds-obj_temp-petrol-chk.obj-code = buf_temp-petrol-chk.obj-code
          AND gds-obj_temp-petrol-chk.pay-desk = 0
          AND gds-obj_temp-petrol-chk.gds-code = buf_temp-petrol-chk.gds-code
          AND gds-obj_temp-petrol-chk.pump     = 0
          AND gds-obj_temp-petrol-chk.pump-2   = 0 no-error .
      if not available gds-obj_temp-petrol-chk then do:
        create gds-obj_temp-petrol-chk.
        assign
        gds-obj_temp-petrol-chk.chk-type = buf_temp-petrol-chk.chk-type
        gds-obj_temp-petrol-chk.obj-type = buf_temp-petrol-chk.obj-type
        gds-obj_temp-petrol-chk.obj-code = buf_temp-petrol-chk.obj-code
        gds-obj_temp-petrol-chk.pay-desk = 0
        gds-obj_temp-petrol-chk.gds-code = buf_temp-petrol-chk.gds-code
        gds-obj_temp-petrol-chk.pump     = 0
        gds-obj_temp-petrol-chk.pump-2   = 0
        .
      end.
      assign
      gds-obj_temp-petrol-chk.doc-qnty = gds-obj_temp-petrol-chk.doc-qnty + buf_temp-petrol-chk.doc-qnty
      gds-obj_temp-petrol-chk.sum-base = gds-obj_temp-petrol-chk.sum-base + buf_temp-petrol-chk.sum-base
      gds-obj_temp-petrol-chk.trans-number = gds-obj_temp-petrol-chk.trans-number + buf_temp-petrol-chk.trans-number
      .
      find first gds-obj0_temp-petrol-chk where
              gds-obj0_temp-petrol-chk.chk-type = 0
          AND gds-obj0_temp-petrol-chk.obj-type = buf_temp-petrol-chk.obj-type
          AND gds-obj0_temp-petrol-chk.obj-code = buf_temp-petrol-chk.obj-code
          AND gds-obj0_temp-petrol-chk.pay-desk = 0
          AND gds-obj0_temp-petrol-chk.gds-code = buf_temp-petrol-chk.gds-code
          AND gds-obj0_temp-petrol-chk.pump     = 0
          AND gds-obj0_temp-petrol-chk.pump-2   = 0 no-error .
      if not available gds-obj0_temp-petrol-chk then do:
        /*найдем название товара - здесь на эту уйдет меньше всего времени*/
        find first buf_goods no-lock where
                  buf_goods.gds-code = buf_temp-petrol-chk.gds-code no-error .
        find first buf_temp-goods no-lock where
                buf_temp-goods.gds-code = buf_temp-petrol-chk.gds-code no-error.
        if not available buf_temp-goods then do:
          create buf_temp-goods.
          assign
          buf_temp-goods.gds-code = buf_temp-petrol-chk.gds-code
          buf_temp-goods.gds-name = (if available buf_goods
                                     then buf_goods.gds-name
                                     else substitute("Товар с кодом &1", buf_temp-petrol-chk.gds-code))
          .
        end.
        create gds-obj0_temp-petrol-chk.
        assign
        gds-obj0_temp-petrol-chk.chk-type = 0
        gds-obj0_temp-petrol-chk.obj-type = buf_temp-petrol-chk.obj-type
        gds-obj0_temp-petrol-chk.obj-code = buf_temp-petrol-chk.obj-code
        gds-obj0_temp-petrol-chk.pay-desk = 0
        gds-obj0_temp-petrol-chk.gds-code = buf_temp-petrol-chk.gds-code
        gds-obj0_temp-petrol-chk.pump     = 0
        gds-obj0_temp-petrol-chk.pump-2   = 0
        .
      end.
      assign
      gds-obj0_temp-petrol-chk.doc-qnty = gds-obj0_temp-petrol-chk.doc-qnty + buf_temp-petrol-chk.doc-qnty
      gds-obj0_temp-petrol-chk.sum-base = gds-obj0_temp-petrol-chk.sum-base + buf_temp-petrol-chk.sum-base
      gds-obj0_temp-petrol-chk.trans-number = gds-obj0_temp-petrol-chk.trans-number + buf_temp-petrol-chk.trans-number
      .
    end.
    if multi-obj then do:
      for each buf_temp-petrol-chk where
              buf_temp-petrol-chk.prim = no:
        if buf_temp-petrol-chk.pay-desk <> 0 then NEXT.
        if buf_temp-petrol-chk.gds-code = 0 then NEXT.
        if buf_temp-petrol-chk.obj-code = 0 then NEXT.
        find first gds_temp-petrol-chk where
                gds_temp-petrol-chk.chk-type = buf_temp-petrol-chk.chk-type
            AND gds_temp-petrol-chk.obj-type = '':U
            AND gds_temp-petrol-chk.obj-code = 0
            AND gds_temp-petrol-chk.pay-desk = 0
            AND gds_temp-petrol-chk.gds-code = buf_temp-petrol-chk.gds-code
            AND gds_temp-petrol-chk.pump     = 0
            AND gds_temp-petrol-chk.pump-2   = 0 no-error .
        if not available gds_temp-petrol-chk then do:
          create gds_temp-petrol-chk.
          assign
          gds_temp-petrol-chk.chk-type = buf_temp-petrol-chk.chk-type
          gds_temp-petrol-chk.obj-type = '':U
          gds_temp-petrol-chk.obj-code = 0
          gds_temp-petrol-chk.pay-desk = 0
          gds_temp-petrol-chk.gds-code = buf_temp-petrol-chk.gds-code
          gds_temp-petrol-chk.pump     = 0
          gds_temp-petrol-chk.pump-2   = 0
          .
        end.
        assign
        gds_temp-petrol-chk.doc-qnty = gds_temp-petrol-chk.doc-qnty + buf_temp-petrol-chk.doc-qnty
        gds_temp-petrol-chk.sum-base = gds_temp-petrol-chk.sum-base + buf_temp-petrol-chk.sum-base
        gds_temp-petrol-chk.trans-number = gds_temp-petrol-chk.trans-number + buf_temp-petrol-chk.trans-number
        .
      end. /*for each buf0_temp-petrol-chk*/
    end. /*if multi-obj*/
  end. /*doe*/

end procedure. /* fill-sub-totals */



FOR EACH obj-list No-LOCK:
  CASE X-Radio-Task > 1 :
    WHEN YES THEN DO:
      _shift-chk:
      FOR EACH buf_chk-doc NO-LOCK WHERE
              buf_chk-doc.obj-type = obj-list.obj-type
          AND buf_chk-doc.obj-code = obj-list.obj-code
          AND ( buf_chk-doc.shift-date >= X-date-start
                AND
                buf_chk-doc.shift-date <= X-date-end):
        IF X-Radio-Task = 3 AND
        ((buf_chk-doc.shift-date = X-date-start AND buf_chk-doc.shift-num < X-shift-Start)
         OR
         (buf_chk-doc.shift-date = X-date-end AND  buf_chk-doc.shift-num > X-shift-End) ) THEN NEXT _shift-chk.
        IF X-Radio-Task = 4
        AND (buf_chk-doc.shift-num <> X-shift-Alone ) THEN NEXT _shift-chk.
        if lookup(string(buf_chk-doc.chk-type), {&petrol-receipt-codes}) = 0
        or buf_chk-doc.office <> {&gds-goods}  then next _shift-chk.
        jj = jj + 1.
        IF jj MODULO 10 = 0 then
        run waitfram-show in this-procedure (substitute("Ждите... Обработано &1 технологических чеков по топливу", jj)).
        run fill-temp-table in this-procedure (input buf_chk-doc.doc-code, input buf_chk-doc.chk-type).
      END.
    END. /*WHEN YES*/
    WHEN NO THEN DO:
     if X-radio-task = 0 then do:
        _no-shift-chk:
        FOR EACH buf_chk-doc NO-LOCK WHERE
                buf_chk-doc.obj-type = obj-list.obj-type
            AND buf_chk-doc.obj-code = obj-list.obj-code
            AND buf_chk-doc.shift-date = X-date-start
            AND buf_chk-doc.shift-num = X-shift-alone:
          if lookup(string(buf_chk-doc.chk-type), {&petrol-receipt-codes}) = 0
          or buf_chk-doc.office <> {&gds-goods} then next _no-shift-chk.
          jj = jj + 1.
          IF jj MODULO 10 = 0 then
          run waitfram-show in this-procedure (substitute("Ждите... Обработано &1 технологических чеков по топливу", jj)).
          run fill-temp-table in this-procedure ( input buf_chk-doc.doc-code, input buf_chk-doc.chk-type).
        END.
      end.
      else do:
        _no-shift-chk:
        FOR EACH buf_chk-doc NO-LOCK WHERE
                buf_chk-doc.obj-type = obj-list.obj-type
            AND buf_chk-doc.obj-code = obj-list.obj-code
            AND buf_chk-doc.chk-date >= X-date-start
            AND buf_chk-doc.chk-date <= X-date-end:
          if lookup(string(buf_chk-doc.chk-type), {&petrol-receipt-codes}) = 0
          or buf_chk-doc.office <> {&gds-goods} then next _no-shift-chk.
          jj = jj + 1.
          IF jj MODULO 10 = 0 then
          run waitfram-show in this-procedure (substitute("Ждите... Обработано &1 технологических чеков по топливу", jj)).
          run fill-temp-table in this-procedure (input buf_chk-doc.doc-code, input buf_chk-doc.chk-type).
        END.
      end.
    END. /*WHEN NO*/
  END CASE.
END. /*for each obj-list*/
run fill-sub-totals in this-procedure .

run waitfram-hide in this-procedure .

Line = fill("-", 123).
date_string = cur-time-print() .

run waitfram-show in this-procedure ("Ждите...").
run prn-lib-open-stream  in this-procedure (
                                            input my-handle
                                            ,input {&CS_PS}
                                            ,input yes /*p-is-stream*/
                                            ,input no /*p-append*/
                                            ).
/*
  if v-chk-type = integer({&rcpt-trans-transfer}) then do:
    FORM with FRAME two-pump .
    view stream PrnLibStream frame two-pump .
  end.
  else do:
    FORM with FRAME one-pump.
    view stream PrnLibStream frame one-pump .
  END.
  */
do v-type-num = 1 to 5:
  CASE v-type-num:
    when 1 then do:
      assign
      v-chk-type = integer({&rcpt-trans-cancell})
      .
    end.
    when 2 then do:
      assign
      v-chk-type = integer({&rcpt-overflow})
      .
    end.
    when 3 then do:
      assign
      v-chk-type = integer({&rcpt-tech-refuell})
      .
    end.
    when 4 then do:
      assign
      v-chk-type = integer({&rcpt-trans-transfer})
      .
    end.
    when 5 then do:
      assign
      v-chk-type = 0
      .
    end.
  END CASE.
&scop receipt-code string(v-chk-type)
  PUT stream PrnLibStream UNFORMATTED
  skip(1)
  space(20)
  "Технологический отчет по ТРК" skip
  space(23) str1 skip(0)
  space(23)  (if v-chk-type = 0 then "По всем типам технологических чеков" else {&receipt-name}) skip(0)
  .
  if v-type-num = 1 then do:
    if v-chk-type = integer({&rcpt-trans-transfer}) then do:
      FORM with FRAME two-pump .
      view stream PrnLibStream frame two-pump .

    end.
    else do:
      FORM with FRAME one-pump.
      view stream PrnLibStream frame one-pump .
    END.
  end.

  run print-one-chk-type in this-procedure (input v-type-num, input v-chk-type).
  hide stream PrnLibStream frame one-pump .
  hide stream PrnLibStream frame two-pump .

  if v-type-num < 5 then do:
    page stream PrnLibStream.
    {&pageExcel}
  end.

end. /*do to 5*/

hide stream PrnLibStream frame one-pump .
hide stream PrnLibStream frame one-pump .

output  STREAM PrnLibStream CLOSE.
{&CloseExcel}
run waitfram-hide in this-procedure .

run prn-lib-prn-file in this-procedure (
                                          input my-handle
                                          ,input 0
                                          ).



procedure print-one-chk-type :
define input  parameter p-type-num as integer   no-undo .
define input  parameter p-chk-type like ub.chk-doc.chk-type no-undo .


define variable loc-obj-count as integer   no-undo .
define buffer bufo_temp-petrol-chk for temp-petrol-chk.
define buffer bufo_temp-goods for temp-goods.
define variable v-first-good as logical   no-undo init yes.


  do
  on error undo, return error return-value
  :
  if p-type-num > 1 then do:
    FInd first Sheetf where
                  Sheetf.sheet-num = p-type-num No-ERROR.
    if not avail sheetf then
    create sheetf.
    assign
    sheetf.sheet-num = p-type-num.
  end.
  &scop receipt-code string(p-chk-type)
  assign
  Sheetf.ColFOrmat = '1=@;2=@' + {&delim-par} +
                     '':U + {&delim-par} +
                     (if p-chk-type = 0
                     then "Все виды чеков"
                     else {&receipt-name})
  .
  assign
  sheetf.Excel-Column-Lable =
  "Касса"  + {&comma-char} +
  "Топливо"  + {&comma-char} +
  (if p-chk-type = integer({&rcpt-trans-transfer})
  then ("Откуда: № ТРК"  + {&comma-char} +
        "Куда: № ТРК"  + {&comma-char})
  else ("№ ТРК"  + {&comma-char})
  ) +
  "Кол-во в л"  + {&comma-char} +
  "Сумма в {&abbr_rub}."  + {&comma-char} +
  "Кол-во чеков"
  sheetf.sizes =
  "5"  + {&comma-char} +
  "25"  + {&comma-char} +
  (if p-chk-type = integer({&rcpt-trans-transfer})
  then ("8"  + {&comma-char} +
        "8"  + {&comma-char})
  else  ("7"  + {&comma-char})
  ) +
  "22"  + {&comma-char} +
  "20" + {&comma-char} +
  "10"
  sheetf.colformat = (if p-chk-type = integer({&rcpt-trans-transfer})
                      then "5=0.0000000000"
                      else "4=0.0000000000"
                      )
  str2 =
                     (if p-chk-type = 0
                     then "Все виды чеков"
                     else {&receipt-name})


  .


  run rep/extitle.p (p-type-num) .

  FORM HEADER
  Line format "X(123)"
  AT 1 SKIP
  string( "Продолжение - на следующей странице" ) FORMAT "X(35)" AT 30 SKIP
  with FRAME BottomFrame width  {&A4_CW0} PAGE-BOTTOM NO-LABELS NO-BOX .
  VIEW STREAM PrnLibStream FRAME BottomFrame .
  if v-type-num > 1 then do:
    if v-chk-type = integer({&rcpt-trans-transfer}) then do:
      FORM with FRAME two-pump .
      view stream PrnLibStream frame two-pump .

    end.
    else do:
      FORM with FRAME one-pump.
      view stream PrnLibStream frame one-pump .
    END.
  end.


  for each obj-list no-lock:
    loc-obj-count = loc-obj-count + 1.
    if loc-obj-count > 1 then do:
      Put Stream PrnLibStream UNFORMATTED
      skip(1).
      {&PutExcel} skip.
    end.
    Put Stream PrnLibStream UNFORMATTED
    substitute("Объект: &1", obj-list.obj-name) skip.
    {&PutExcel}
    substitute("Объект: &1", obj-list.obj-name) skip.

      for each buf_temp-petrol-chk where
            buf_temp-petrol-chk.obj-type = obj-list.obj-type
        AND buf_temp-petrol-chk.obj-code = obj-list.obj-code
        and buf_temp-petrol-chk.chk-type = p-chk-type
        and (buf_temp-petrol-chk.prim     = yes or p-chk-type = 0)
        ,
          first buf_temp-goods where
               buf_temp-goods.gds-code = buf_temp-petrol-chk.gds-code
      break
      by buf_temp-petrol-chk.pay-desk
      by buf_temp-petrol-chk.gds-code
      by buf_temp-petrol-chk.pump:
      if buf_temp-petrol-chk.pay-desk = 0 then NEXT.
      if first-of(buf_temp-petrol-chk.pay-desk) then do:
        assign
        accum-pay-desk-doc-qnty = 0
        accum-pay-desk-sum-base = 0
        accum-pay-desk-trans-number = 0
        .
      end.
      if first-of(buf_temp-petrol-chk.gds-code) then do:
        assign
        accum-gds-code-doc-qnty = 0
        accum-gds-code-sum-base = 0
        accum-gds-code-trans-number = 0
        .
      end.
      assign
      accum-pay-desk-doc-qnty     = accum-pay-desk-doc-qnty      + buf_temp-petrol-chk.doc-qnty
      accum-pay-desk-sum-base     = accum-pay-desk-sum-base      + buf_temp-petrol-chk.sum-base
      accum-pay-desk-trans-number = accum-pay-desk-trans-number  + buf_temp-petrol-chk.trans-number
      accum-gds-code-doc-qnty     = accum-gds-code-doc-qnty      + buf_temp-petrol-chk.doc-qnty
      accum-gds-code-sum-base     = accum-gds-code-sum-base      + buf_temp-petrol-chk.sum-base
      accum-gds-code-trans-number = accum-gds-code-trans-number  + buf_temp-petrol-chk.trans-number
      .

      if p-chk-type = integer({&rcpt-trans-transfer}) then do:
        DOWN 1 STREAM PrnLibStream
        with frame two-pump.
        display stream PrnLibStream
        buf_temp-petrol-chk.pay-desk when first-of(buf_temp-petrol-chk.pay-desk)
        buf_temp-goods.gds-name when first-of(buf_temp-petrol-chk.gds-code)
        buf_temp-petrol-chk.pump
        buf_temp-petrol-chk.pump-2
        buf_temp-petrol-chk.doc-qnty
        buf_temp-petrol-chk.sum-base
        buf_temp-petrol-chk.trans-number
        with frame two-pump.
        if last-of(buf_temp-petrol-chk.gds-code) then do:
          DOWN 1 STREAM PrnLibStream
          with frame two-pump.
          display stream PrnLibStream
          substitute("Итого по &1", buf_temp-goods.gds-name) @ buf_temp-goods.gds-name
          accum-gds-code-doc-qnty       @ buf_temp-petrol-chk.doc-qnty
          accum-gds-code-sum-base       @ buf_temp-petrol-chk.sum-base
          accum-gds-code-trans-number   @ buf_temp-petrol-chk.trans-number
          with frame two-pump.
        end.
        if last-of(buf_temp-petrol-chk.pay-desk) then do:
          DOWN 1 STREAM PrnLibStream
          with frame two-pump.
          display stream PrnLibStream
          substitute("Итого по кассе &1", buf_temp-petrol-chk.pay-desk) @ buf_temp-goods.gds-name
          accum-pay-desk-doc-qnty       @ buf_temp-petrol-chk.doc-qnty
          accum-pay-desk-sum-base       @ buf_temp-petrol-chk.sum-base
          accum-pay-desk-trans-number   @ buf_temp-petrol-chk.trans-number
          with frame two-pump.
        end.
      end.
      else do:
        DOWN 1 STREAM PrnLibStream
        with frame one-pump.
        display stream PrnLibStream
        buf_temp-petrol-chk.pay-desk when first-of(buf_temp-petrol-chk.pay-desk)
        buf_temp-goods.gds-name     when first-of(buf_temp-petrol-chk.gds-code)
        buf_temp-petrol-chk.pump
        buf_temp-petrol-chk.doc-qnty
        buf_temp-petrol-chk.sum-base
        buf_temp-petrol-chk.trans-number
        with frame one-pump.
        if last-of(buf_temp-petrol-chk.gds-code) then do:
          DOWN 1 STREAM PrnLibStream
          with frame one-pump.

          display stream PrnLibStream
          substitute("Итого по &1", buf_temp-goods.gds-name) @ buf_temp-goods.gds-name
          accum-gds-code-doc-qnty       @ buf_temp-petrol-chk.doc-qnty
          accum-gds-code-sum-base       @ buf_temp-petrol-chk.sum-base
          accum-gds-code-trans-number   @ buf_temp-petrol-chk.trans-number
          with frame one-pump.
        end.
        if last-of(buf_temp-petrol-chk.pay-desk) then do:
          DOWN 1 STREAM PrnLibStream
          with frame one-pump.

          display stream PrnLibStream
          substitute("Итого по кассе &1", buf_temp-petrol-chk.pay-desk) @ buf_temp-goods.gds-name
          accum-pay-desk-doc-qnty        @ buf_temp-petrol-chk.doc-qnty
          accum-pay-desk-sum-base        @ buf_temp-petrol-chk.sum-base
          accum-pay-desk-trans-number    @ buf_temp-petrol-chk.trans-number
          with frame one-pump.
        end.
      end.
      /*печатаем в excel*/
      if first-of(buf_temp-petrol-chk.pay-desk )
      or first-of(buf_temp-petrol-chk.gds-code)
      or (p-chk-type = 0 and not first-of(buf_temp-petrol-chk.gds-code))
      then
      {&PutExcel}
      buf_temp-petrol-chk.pay-desk                        {&tabulation}
      .
      else
      {&PutExcel}                                         {&tabulation}
      .
      if first-of(buf_temp-petrol-chk.gds-code )
      or p-chk-type = 0
      then
      {&PutExcel}
      buf_temp-goods.gds-name                             {&tabulation}.
      else
      {&PutExcel}                                         {&tabulation}
      .
      {&PutExcel}
      buf_temp-petrol-chk.pump                            {&tabulation}
      .
      if p-chk-type = integer({&rcpt-trans-transfer})
      then
      {&PutExcel}
      buf_temp-petrol-chk.pump-2                          {&tabulation}
      .
      {&PutExcel}
      buf_temp-petrol-chk.doc-qnty                        {&tabulation}
      buf_temp-petrol-chk.sum-base                        {&tabulation}
      buf_temp-petrol-chk.trans-number
      skip.


      if last-of(buf_temp-petrol-chk.gds-code) then do:
        {&PutExcel}
                                                          {&tabulation}
        substitute("Итого по &1", buf_temp-goods.gds-name)             {&tabulation}
                                                          {&tabulation}
        (if p-chk-type = integer({&rcpt-trans-transfer})
        then                                              {&tabulation}
        else                                              '':U)
        accum-gds-code-doc-qnty                           {&tabulation}
        accum-gds-code-sum-base                           {&tabulation}
        accum-gds-code-trans-number
        skip.
      end.
      if last-of(buf_temp-petrol-chk.pay-desk) then do:
        {&PutExcel}
                                                          {&tabulation}
        substitute("Итого по кассе &1", buf_temp-petrol-chk.pay-desk) {&tabulation}
                                                           {&tabulation}
        (if p-chk-type = integer({&rcpt-trans-transfer})
        then                                              {&tabulation}
        else                                              '':U)
        accum-pay-desk-doc-qnty                            {&tabulation}
        accum-pay-desk-sum-base                            {&tabulation}
        accum-pay-desk-trans-number
        skip.
      end.
      if last-of(buf_temp-petrol-chk.pay-desk)
      and last(buf_temp-petrol-chk.pay-desk)
      then do:

        /*итоги по видам топлива*/
        Put Stream PrnLibStream Unformatted
        "Итоги по видам топлива:"
        skip(0).
        {&PutExcel}
        "Итоги по видам топлива:"
        skip.
        assign
        accum-doc-qnty = 0
        accum-sum-base = 0
        accum-trans-number = 0
        .
        v-first-good = yes.
        for each bufo_temp-petrol-chk where
              bufo_temp-petrol-chk.chk-type = p-chk-type
          AND bufo_temp-petrol-chk.obj-type = obj-list.obj-type
          AND bufo_temp-petrol-chk.obj-code = obj-list.obj-cod
          and bufo_temp-petrol-chk.pay-desk = 0
          and bufo_temp-petrol-chk.pump = 0,
              first bufo_temp-goods where
                  bufo_temp-goods.gds-code = bufo_temp-petrol-chk.gds-code
          :

          assign
          accum-doc-qnty     = accum-doc-qnty      + bufo_temp-petrol-chk.doc-qnty
          accum-sum-base     = accum-sum-base      + bufo_temp-petrol-chk.sum-base
          accum-trans-number = accum-trans-number  + bufo_temp-petrol-chk.trans-number
          .

          if p-chk-type = integer({&rcpt-trans-transfer}) then do:
            if not v-first-good then do:
              DOWn 1 Stream PrnLibStream
              with frame two-pump.
            end.
            display stream PrnLibStream
            substitute("ИТОГО по &1", bufo_temp-goods.gds-name ) @ buf_temp-goods.gds-name
            bufo_temp-petrol-chk.doc-qnty     @ buf_temp-petrol-chk.doc-qnty
            bufo_temp-petrol-chk.sum-base     @ buf_temp-petrol-chk.sum-base
            bufo_temp-petrol-chk.trans-number @ buf_temp-petrol-chk.trans-number
            with frame two-pump.
          end.
          else do:
            if not v-first-good then do:
              DOWn 1 Stream PrnLibStream
              with frame one-pump.
            end.
            display stream PrnLibStream
            substitute("ИТОГО по &1", bufo_temp-goods.gds-name ) @ buf_temp-goods.gds-name
            bufo_temp-petrol-chk.doc-qnty        @ buf_temp-petrol-chk.doc-qnty
            bufo_temp-petrol-chk.sum-base        @ buf_temp-petrol-chk.sum-base
            bufo_temp-petrol-chk.trans-number    @ buf_temp-petrol-chk.trans-number
            with frame one-pump.
          end.
          /*печатаем в excel*/
          {&PutExcel}
                                                              {&tabulation}
          substitute("ИТОГО по &1", bufo_temp-goods.gds-name )              {&tabulation}
                                                              {&tabulation}
          (if p-chk-type = integer({&rcpt-trans-transfer})
          then
                                                              {&tabulation}
          else '':U
          )
          bufo_temp-petrol-chk.doc-qnty                        {&tabulation}
          bufo_temp-petrol-chk.sum-base                        {&tabulation}
          bufo_temp-petrol-chk.trans-number
          skip.
          v-first-good = no.
        end. /*по всем видам топлива по объекту*/


    &scop receipt-code string(p-chk-type)
        if p-chk-type = integer({&rcpt-trans-transfer}) then do:
          DOWn 2 Stream PrnLibStream
          with frame two-pump.
          display stream PrnLibStream
          substitute("ИТОГ по &1"
                    , (if p-chk-type = 0 then "всем типам чеков" else {&receipt-name})
                    ) @ buf_temp-goods.gds-name
          accum-doc-qnty @ buf_temp-petrol-chk.doc-qnty
          accum-sum-base @ buf_temp-petrol-chk.sum-base
          accum-trans-number @ buf_temp-petrol-chk.trans-number
          with frame two-pump.
        end.
        else do:
          DOWn 2 Stream PrnLibStream
          with frame one-pump.
          display stream PrnLibStream
          substitute("ИТОГ по &1"
                    , caps((if p-chk-type = 0 then "всем типам чеков" else {&receipt-name}))) @ buf_temp-goods.gds-name
          accum-doc-qnty @ buf_temp-petrol-chk.doc-qnty
          accum-sum-base @ buf_temp-petrol-chk.sum-base
          accum-trans-number @ buf_temp-petrol-chk.trans-number
          with frame one-pump.
        end.
        /*печатаем в excel*/
        {&PutExcel}
        skip(0)
                                                            {&tabulation}
        substitute("ИТОГ по &1", caps((if p-chk-type = 0 then "всем типам чеков" else {&receipt-name})))
                                                            {&tabulation}
                                                            {&tabulation}
        (if p-chk-type = integer({&rcpt-trans-transfer})
        then
                                                            {&tabulation}
        else '':U
        )
        accum-doc-qnty                        {&tabulation}
        accum-sum-base                        {&tabulation}
        accum-trans-number
        skip.
        /*по всем объектам в общем*/

        if multi-obj
        and loc-obj-count = obj-count
        then do:
          Put Stream PrnLibStream UNFORMATTED
          skip(1)
          substitute("ПО ВСЕМ ВЫБРАННЫМ ОБЪЕКТАМ") skip.
          {&Putexcel}
          substitute("ПО ВСЕМ ВЫБРАННЫМ ОБЪЕКТАМ") skip.

          assign
          accum-doc-qnty = 0
          accum-sum-base = 0
          accum-trans-number = 0
          .
          for each bufo_temp-petrol-chk where
                bufo_temp-petrol-chk.obj-type = '':U
            AND bufo_temp-petrol-chk.obj-code = 0
            and bufo_temp-petrol-chk.chk-type = p-chk-type,
                first bufo_temp-goods where
                    bufo_temp-goods.gds-code = bufo_temp-petrol-chk.gds-code

          break
          by bufo_temp-petrol-chk.pay-desk
          by bufo_temp-petrol-chk.gds-code
          :
            assign
            accum-doc-qnty     = accum-doc-qnty      + bufo_temp-petrol-chk.doc-qnty
            accum-sum-base     = accum-sum-base      + bufo_temp-petrol-chk.sum-base
            accum-trans-number = accum-trans-number  + bufo_temp-petrol-chk.trans-number
            .
            if p-chk-type = integer({&rcpt-trans-transfer}) then do:
              down 1 stream PrnLibStream
              with frame two-pump.
              display stream PrnLibStream
              bufo_temp-goods.gds-name          @  buf_temp-goods.gds-name
              bufo_temp-petrol-chk.doc-qnty     @  buf_temp-petrol-chk.doc-qnty
              bufo_temp-petrol-chk.sum-base     @  buf_temp-petrol-chk.sum-base
              bufo_temp-petrol-chk.trans-number @  buf_temp-petrol-chk.trans-number
              with frame two-pump.
            end.
            else do:
              down 1 stream PrnLibStream
              with frame one-pump.
              display stream PrnLibStream
              bufo_temp-goods.gds-name          @  buf_temp-goods.gds-name
              bufo_temp-petrol-chk.doc-qnty      @  buf_temp-petrol-chk.doc-qnty
              bufo_temp-petrol-chk.sum-base      @  buf_temp-petrol-chk.sum-base
              bufo_temp-petrol-chk.trans-number  @  buf_temp-petrol-chk.trans-number
              with frame one-pump.
            end.
            {&PutExcel}
                                                                {&tabulation}

            bufo_temp-goods.gds-name                             {&tabulation}
                                                                {&tabulation}
            (if p-chk-type = integer({&rcpt-trans-transfer})
            then
                                                                {&tabulation}
            else '':u)
            bufo_temp-petrol-chk.doc-qnty                        {&tabulation}
            bufo_temp-petrol-chk.sum-base                        {&tabulation}
            bufo_temp-petrol-chk.trans-number
            skip.
          end. /*for each buf_temp-petrol-chk wh*/
&scop receipt-code string(p-chk-type)
          Put Stream PrnLibStream UNFORMATTED
          skip(1)
          .
          if p-chk-type = integer({&rcpt-trans-transfer}) then do:
            down 1 stream PrnLibStream
            with frame two-pump.
            display stream PrnLibStream
            substitute("ИТОГ по &1", caps(if p-chk-type = 0 then "всем типам чеков" else {&receipt-name})) @ buf_temp-goods.gds-name
            accum-doc-qnty @ buf_temp-petrol-chk.doc-qnty
            accum-sum-base @ buf_temp-petrol-chk.sum-base
            accum-trans-number @ buf_temp-petrol-chk.trans-number
            with frame two-pump.
          end.
          else do:
            down 1 stream PrnLibStream
            with frame one-pump.
            display stream PrnLibStream
            substitute("ИТОГ по &1", caps(if p-chk-type = 0 then "всем типам чеков" else {&receipt-name})) @ buf_temp-goods.gds-name
            accum-doc-qnty @ buf_temp-petrol-chk.doc-qnty
            accum-sum-base @ buf_temp-petrol-chk.sum-base
            accum-trans-number @ buf_temp-petrol-chk.trans-number
            with frame one-pump.
          end.
          {&PutExcel}
          skip(1)
                                                              {&tabulation}
          substitute("ИТОГ по &1", caps(if p-chk-type = 0 then "всем типам чеков" else {&receipt-name}))
                                                              {&tabulation}
                                                              {&tabulation}
          (if p-chk-type = integer({&rcpt-trans-transfer})
          then
                                                              {&tabulation}
          else '':u)
          accum-doc-qnty                                      {&tabulation}
          accum-sum-base                                      {&tabulation}
          accum-trans-number
          skip.
        end. /*if multi-obj*/
      end. /**if last-of(buf_temp-petrol-chk) and last(buf_temp-pettrol-chk)*/
    end. /*for each buf_temp-petrol-chk*/
    if obj-count <> loc-obj-count then  do:
      if p-chk-type = integer({&rcpt-trans-transfer}) then do:
        down 1 stream PrnLibStream
        with frame two-pump.
      end.
      else do:
        DOWN 1 stream PrnLibStream
        with frame one-pump
        .
      end.
      {&PutExcel} skip.
    end.

  end. /*for each obj-list*/
  clear frame two-pump.
  clear frame one-pump.
  HIDE  STREAM PrnLibStream FRAME BottomFrame .
  /*if p-chk-type = integer({&rcpt-trans-transfer}) then*/
  HIDE  STREAM PrnLibStream FRAME two-pump.
  /*else*/
  HIDE  STREAM PrnLibStream FRAME one-pump.
  end.

end procedure. /* print-one-chk-type */