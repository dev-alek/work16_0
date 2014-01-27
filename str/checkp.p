/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Печать одного чека

Автор: Бахтадзе Наталья Викторовна
Дата создания: 09/08/05
Author: Bakhtadze Natalya
Creation date: 09/08/05

*/

define input parameter parparentproc as widget-handle no-undo .
DEFINE INPUT PARAMETER cdoc like ub.chk-doc.doc-code.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Печать одного чека".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i  }
{ cmp/library.i }
{ gbl/cur-time.i }
{ cmp/r-pril.i new }
{ gbl/prn-lib.i }
{ str/shftnmef.i chk-doc shift-name }

define variable sym1   as char format "X(1)" init ":".
define variable sym10 as char format "X(1)" init ":".
define variable date_string     as      char    no-undo.
define variable Line                as      char    no-undo.
define variable for-time as char.
define variable for-gds-sum like ub.chk-doc.netto no-undo.
define variable for-gds-price like ub.chk-gds.price-base no-undo.
define variable fgds-discnt-pc as decimal no-undo.
define variable accum-pay-r-b as decimal no-undo .
define variable v-curr-r-b as character no-undo .
define variable v-is-write-off as logical no-undo .

DEFINE FRAME Goods-Frame
ub.chk-gds.line-num    column-label "NN"  format "->>>>9"
ub.chk-gds.b-code      column-label "Код" FORMAT "-9999999999"
ub.goods.artic
ub.goods.gds-name   COLUMN-LABEL "Название/!Производитель" FORMAT "X(30)"
ub.chk-gds.is-error COLUMN-LABEL "Ош" FORMAT "+/ "
ub.chk-gds.src-code Column-label "Код в спул-файле" FORMAT "X(16)"
ub.chk-gds.pump column-label "ТРК!Пист!Рез" FORMAT ">>9"
ub.chk-gds.doc-qnty
ub.bar-code.unit-cli     COLUMN-LABEL "Изм" FORMAT "X(3)"
ub.chk-gds.price-base
ub.chk-gds.discnt
fgds-discnt-pc COLUMn-LABEL "% ск"  FORMAT "->9.99%"
for-gds-price COLUMN-LABEL "Цена нетто"
for-gds-sum COLUMN-LABEL "Сумма по строке"
ub.chk-gds.road-tax  FORMAT "->>>,>>9.99"
v-is-write-off COLUMN-LABEL "Спи" format "+/ "
with width {&DOS_CW_2} down stream-io use-text    .


DEFINE FRAME Pay-Frame
ub.chk-pay.line-num    column-label "NN"  format ">>9"
ub.chk-pay.curr-code column-label "Код. вал"
ub.currency.curr-name column-label "Валюта" FORMAT "X(15)"
ub.chk-pay.pay-code Column-label "Код платежа"
ub.cash-pay.obj-name COLUMn-LABEL "Платеж"
ub.chk-pay.tot-sum COLUMN-LABEL "Сумма в вал. платежа"
ub.chk-pay.tot-base COLUMN-LABEL "Сумма в баз.вал"
ub.chk-pay.tot-rubl  COLUMN-LABEL "Сумма в {&abbr_rublyah}"
with width {&DOS_CW_2} down stream-io use-text    .

{ gbl/curr-r-b.i
  v-curr-r-b
}


run prn-lib-open-stream  in this-procedure (
                                             input parParentProc
                                            ,input {&LS_PS_A4}
                                            ,input yes /*p-is-stream*/
                                            ,input no /*p-append*/
                                            ).



VIEW  STREAM PrnLibStream FRAME BottomFrame .

FORM with FRAME Goods-Frame  .

FIND FIRST ub.chk-doc NO-LOCK WHERE ub.chk-doc.doc-code = cdoc NO-ERROR.
IF NOT avail ub.chk-doc then return.

FOR EACH ub.chk-pay No-LOCK where ub.chk-pay.doc-code = ub.chk-doc.doc-code:
  assign
  accum-pay-r-b = accum-pay-r-b +
              (if v-curr-r-b = {&r-b-base}
                then chk-pay.tot-base
                else chk-pay.tot-rubl)
                 .
END.

if NOT chk-doc.d-card = "" then do:
    FIND FIRST ub.dis-card NO-LOCK WHERE ub.dis-card.d-card = ub.chk-doc.d-card NO-ERROR.
    IF avail ub.dis-card then do:
        FIND FIRST ub.clients where ub.clients.obj-type = ub.dis-card.cli-type AND
                                                  ub.clients.obj-code = ub.dis-card.cli-code No-ERROR.
    END.
end.

Line = fill("-", 198).
date_string = cur-time-print() .


PUT STREAM PrnLibStream UNFORMATTED
line skip(0)
date_string skip(0)
"Чек N "
chk-doc.doc-code SPace(1)
"Магазин N " string(chk-doc.obj-code, ">>>>9") space(1)
"Дата: " string(chk-doc.chk-date, "99/99/9999") space(1)
"Время: " string(chk-doc.chk-time, "HH:MM") space(1)
"Дата смены: " string(chk-doc.shift-date, "99/99/9999") space(1)
"Номер смены: " shift-name-no-err(buffer chk-doc) format "X(6)" space(1)
 skip(0)
"Касса N" string(chk-doc.pay-desk, ">>>>9") space(1)
"Номер по кассе " string(chk-doc.chk-num, "-9999999") space(1)
"Кассир: " string(chk-doc.cashier, ">>>>9") space(1)
"Продавец: " string(chk-doc.sales-man, ">>>>9") skip(0)
(if NOT chk-doc.d-card = "" then
    ("Дисконтная карта N: " + chk-doc.d-card +
    (if avail clients then (" Клиент: " + clients.obj-name) else "")
     + {&new-line} )
else "")
"Сумма товарная: " string(chk-doc.tot-doc, "->>>,>>>,>>9.99") skip(0)
"Скидка общая  : " string(chk-doc.discnt, "->>>,>>>,>>9.99") space(1)
(If chk-doc.sub-discnt <> 0
        then ("Списания: " + string(chk-doc.sub-discnt, "->>>,>>>,>>9.99") + ") ")
        else "")
"Процент скидки: " string( ( if chk-doc.tot-doc = 0 then 0 else ( chk-doc.discnt / chk-doc.tot-doc * 100 ) ), "->9.99%") skip(0)
"Сумма нетто   : " string(chk-doc.netto, "->>>,>>>,>>9.99") space(1)
"Сумма оплат  : " string(ACCUM-pay-r-b, "->>>,>>>,>>9.99") skip(1)
"ТОВАРЫ ПО ЧЕКУ:" skip(0)
.
FOR EACH ub.chk-gds No-LOCK where
        ub.chk-gds.doc-code = ub.chk-doc.doc-code
by abs(ub.CHk-gds.line-num ):
    FIND FIRST ub.bar-code No-LOCK WHERE ub.bar-code.b-code = ub.chk-gds.b-code NO-ERROR.
    IF AVAIL ub.bar-code then do:
      FIND FIRST ub.goods NO-LOCK WHERE
                ub.goods.gds-code = ub.bar-code.gds-code NO-ERROR.
      FIND FIRST  ub.clients NO-LOCK WHERE
                  ub.clients.obj-type = ub.goods.prod-type AND
                  ub.clients.obj-code = ub.goods.prod-code NO-ERROR.
      FIND FIRST ub.gds-prt No-LOCK where ub.gds-prt.upper-code = ub.goods.prt-root NO-ERROR.
    end.

    assign
    fgds-discnt-pc = (ub.chk-gds.discnt / (ub.chk-gds.price-base + ub.chk-gds.price-service) * 100)
    for-gds-sum = (ub.chk-gds.price-base + ub.chk-gds.price-service - ub.chk-gds.discnt) * ub.chk-gds.doc-qnty
    for-gds-price = ub.chk-gds.price-base + ub.chk-gds.price-service - ub.chk-gds.discnt
    .
    DISPLAY STREAM PrnLibStream
    ub.chk-gds.line-num
    ub.chk-gds.b-code
    if avail ub.bar-code then ub.goods.artic else "" @ ub.goods.artic
    if avail ub.bar-code then ub.goods.gds-name else "" @ ub.goods.gds-name
    ub.chk-gds.is-error
    ub.chk-gds.src-code
    ub.chk-gds.pump
    ub.chk-gds.doc-qnty
    if avail ub.bar-code then ub.bar-code.unit-cli else "" @ ub.bar-code.unit-cli
    (ub.chk-gds.price-base + ub.chk-gds.price-service) @ ub.chk-gds.price-base
    ub.chk-gds.discnt
    fgds-discnt-pc
    for-gds-price
    for-gds-sum
    ub.chk-gds.road-tax
    (if ub.chk-gds.write-off-code <> ?
     and ub.chk-gds.write-off-code <> 0
    then yes
    else no) @ v-is-write-off
    WITH FRAME Goods-Frame.
    DOWN 1 stream PrnLibStream
    WITH FRAME Goods-Frame.
    DISPLAY STREAM PrnLibStream
    IF avail ub.bar-code then (IF ( ub.gds-prt.node-name <> {&empty-scale})  then ub.gds-prt.f-name  else "" ) else "" @ ub.goods.artic
    if avail ub.bar-code then ub.clients.obj-name else "" @ ub.goods.gds-name
    WITH FRAME Goods-Frame.
    if ub.chk-gds.nozzle-code <> 0 then do:
      DISPLAY STREAM PrnLibStream
      ub.chk-gds.nozzle-code @ ub.chk-gds.pump
      WITH FRAME Goods-Frame.
      if ub.chk-gds.loc1 <> '':u then do:
        DOWN 1 stream PrnLibStream
        WITH FRAME Goods-Frame.
      end.
    end.
    if ub.chk-gds.loc1 <> '':u then
    DISPLAY STREAM PrnLibStream
    integer(ub.chk-gds.loc1)  @ ub.chk-gds.pump
    WITH FRAME Goods-Frame.
    ACCUMULATE
    ub.chk-gds.doc-qnty (TOTAL)
    (ub.chk-gds.price-base + ub.chk-gds.price-service) * ub.chk-gds.doc-qnty (TOTAL)
    ub.chk-gds.discnt * ub.chk-gds.doc-qnty (TOTAL)
    (ub.chk-gds.price-base + ub.chk-gds.price-service - ub.chk-gds.discnt) * ub.chk-gds.doc-qnty (TOTAL).
    DOWN STREAM PrnLibStream
    WITH FRAME GOods-Frame.
END.
UNDERLINE STREAM PrnLibStream
ub.chk-gds.line-num
ub.chk-gds.b-code
ub.goods.artic
ub.goods.gds-name
ub.chk-gds.is-error
ub.chk-gds.src-code
ub.chk-gds.pump
ub.chk-gds.doc-qnty
ub.bar-code.unit-cli
ub.chk-gds.price-base
ub.chk-gds.discnt
fgds-discnt-pc
for-gds-price
for-gds-sum
ub.chk-gds.road-tax
v-is-write-off
WITH FRAME Goods-Frame.
DOWN STREAM PrnLibStream
WITH FRAME GOods-Frame.
DISPLAY STREAM PrnLibStream
(ACCUM TOTAL ub.chk-gds.doc-qnty) @ ub.chk-gds.doc-qnty
(ACCUM TOTAL (ub.chk-gds.price-base + ub.chk-gds.price-service) * ub.chk-gds.doc-qnty) @ ub.chk-gds.price-base
(ACCUM TOTAL ub.chk-gds.discnt * ub.chk-gds.doc-qnty) @ ub.chk-gds.discnt
((ACCUM TOTAL ub.chk-gds.discnt * ub.chk-gds.doc-qnty) /
(ACCUM TOTAL (ub.chk-gds.price-base + ub.chk-gds.price-service)  *  ub.chk-gds.doc-qnty) * 100) @ fgds-discnt-pc
(ACCUM TOTAL (ub.chk-gds.price-base + ub.chk-gds.price-service - ub.chk-gds.discnt) * ub.chk-gds.doc-qnty) @ for-gds-sum
WITH FRAME Goods-Frame.

HIDE  STREAM PrnLibStream FRAME GOODS-Frame.
FORM with FRAME PAY-Frame  .


PUT STREAM PrnLibStream
SKIP(1)
"ОПЛАТЫ ПО ЧЕКУ:" skip(0)
.

FOR EACH ub.chk-pay No-LOCK WHERE
        ub.chk-pay.doc-code = ub.chk-doc.doc-code
by ub.CHk-pay.line-num :
    FIND FIRST ub.currency No-LOCK WHERE ub.currency.curr-code = ub.chk-pay.curr-code NO-ERROR.
    FIND FIRST ub.cash-pay No-LOCK WHERE
                        ub.cash-pay.cdpay-code = ub.chk-pay.pay-code AND
                        ub.cash-pay.curr-code = ub.chk-pay.curr-code No-ERROR.
    DISPLAY STREAM PrnLibStream
    ub.chk-pay.line-num
    ub.chk-pay.curr-code
    if avail ub.currency then ub.currency.curr-name else "НЕОПОЗНАННАЯ ВАЛЮТА" @ ub.currency.curr-name
    ub.chk-pay.pay-code
    if avail ub.cash-pay then ub.cash-pay.obj-name else "НЕОПОЗНАННАЯ ОПЛАТА" @ ub.cash-pay.obj-name
    ub.chk-pay.tot-sum
    ub.chk-pay.tot-base
    ub.chk-pay.tot-rubl
    WITH FRAME Pay-Frame.
    DOWN STREAM PrnLibStream
    WITH FRAME Pay-Frame.
    ACCUMULATE
    ub.chk-pay.tot-sum (TOTAL)
    ub.chk-pay.tot-base (TOTAL)
    ub.chk-pay.tot-rubl (TOTAL).
END.
UNDERLINE STREAM PrnLibStream
ub.chk-pay.line-num
ub.chk-pay.curr-code
ub.currency.curr-name
ub.chk-pay.pay-code
ub.cash-pay.obj-name
ub.chk-pay.tot-sum
ub.chk-pay.tot-base
ub.chk-pay.tot-rubl
WITH FRAME Pay-Frame.
DOWN STREAM PrnLibStream
WITH FRAME Pay-Frame.
DISPLAY Stream PrnLibStream
ACCUM TOTAL ub.chk-pay.tot-base @ ub.chk-pay.tot-base
ACCUM TOTAL ub.chk-pay.tot-rubl @ ub.chk-pay.tot-rubl
WITH FRAME Pay-Frame.

HIDE  STREAM PrnLibStream FRAME Pay-Frame.
HIDE  STREAM PrnLibStream FRAME Bottom-Frame.

output  STREAM PrnLibStream CLOSE.
/*
assign
g#rep-tblname = ""
g#rep-tblrid = -117
g#rep-updflds =  "Чек" + chk-doc.doc-code.
*/
run prn-lib-prn-file in this-procedure (
                                          input parParentProc
                                          ,input 8
                                          ).