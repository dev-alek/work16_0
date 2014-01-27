/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Продажа топлива по видам платежа

Автор: Бахтадзе Наталья Викторовна
Дата создания: 09/07/05
Author: Bakhtadze Natalya
Creation date: 09/07/05

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Продажи топлива по видам платежа".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i  }
{ cmp/library.i }
{ gbl/cur-time.i }
{ cmp/r-pril.i new }
{ gbl/prn-lib.i }
{ cmp/r-page1.i  }
{ ref/gdsoattr.i }
{ gbl/waitfram.i }
{ rep/rep-bt.i }


&global-define  no-benefits    "Не было никакой выручки  ~
в течение заданного Вами периода времени."

define variable     NotInc          as  log     no-undo.

define variable Line                as      char    no-undo.
define variable date_string     as      char    no-undo.

define var for-pay-name like ub.cash-pay.obj-name no-undo.

define var cas-num as integer no-undo.
define SHARED var method as character no-undo.
define var my-set_val_type as integer no-undo.
def SHARED var cas-shft as logical no-undo init no.


define variable found as logical init yes no-undo.
define variable bad-chk-str as character no-undo .

define temp-table benefits no-undo
Field b-code like ub.bar-code.b-code
field gds-name like ub.goods.gds-name
field qnty as decimal format "->>>,>>>,>>9.999"
field pay-code  like    ub.cash-pay.cdpay-code
field curr-code like ub.cash-pay.curr-code
field tot-sum   like    ub.chk-pay.tot-sum
field tot-base like    ub.chk-pay.tot-base
field tot-rubl   like    ub.chk-pay.tot-rubl
field pay-desk like ub.chk-doc.pay-desk
field is-real-top as integer
INDEX pi IS PRIMARY     b-code pay-code curr-code ASCENDING
INDEX pc                         pay-code b-code ASCENDING
.

define temp-table pays no-undo
field qnty as decimal format "->>>,>>>,>>9.999"
field pay-code  like    ub.cash-pay.cdpay-code
field curr-code like ub.cash-pay.curr-code
field pay-name like ub.cash-pay.obj-name
field tot-sum   like    ub.chk-pay.tot-sum
field tot-base like    ub.chk-pay.tot-base
field tot-rubl   like    ub.chk-pay.tot-rubl
field pay-desk like ub.chk-doc.pay-desk
INDEX pi IS PRIMARY     pay-code curr-code ASCENDING
.

define temp-table b-codes no-undo
field qnty as decimal format "->>>,>>>,>>9.999"
field b-code  like    ub.bar-code.b-code
field gds-name like ub.goods.gds-name
field tot-sum   like    ub.chk-pay.tot-sum
field tot-base like    ub.chk-pay.tot-base
field tot-rubl   like    ub.chk-pay.tot-rubl
field pay-desk like ub.chk-doc.pay-desk
INDEX pi IS PRIMARY     b-code ASCENDING
.

define temp-table bad-chk no-undo
field doc-code like ub.chk-doc.doc-code
field delta as decimal
INDEX pi IS PRIMARY   doc-code ASCENDING
.


define variable sym1 as char init ":"   no-undo.
define variable sym2 as char init ":"   no-undo.
define variable sym3 as char init ":"   no-undo.
define variable sym4 as char init ":"   no-undo.
define variable sym5 as char init ":"   no-undo.
define variable sym6 as char init ":"   no-undo.
define variable sym7 as char init ":"   no-undo.
define variable sym8 as char init ":"   no-undo.

define variable     FrameType as      char        no-undo.

define variable     DatePrinted     as      logical     no-undo.

define buffer benBuffer for benefits.
define buffer b-inkas for ub.inkas .
define buffer b-inkas-pay for ub.inkas-pay .
def buffer buf_goods for ub.goods.
def buffer buf_chk-gds-pay for ub.chk-gds-pay.


define variable sale-price-type as character.
define variable attr-value as character no-undo .
define variable attr-type as character no-undo .
define variable v-header-base-curr as character no-undo .
define variable v-curr-r-b as character no-undo .
{ gbl/curr-r-b.i
  v-curr-r-b
}
if v-curr-r-b = {&r-b-base} then do:
  assign
  v-header-base-curr = string( "( Б.Вал. - " + caps( base-type ) + " )" )
  .
end.


DEFINE FRAME Benefit-Base
sym1 column-label ":"format "X(1)"
benefits.b-code column-label "Код"
benefits.gds-name column-label "Вид топлива" format "X(30)"
benefits.pay-code column-label "  " format ">>9"
benefits.curr-code column-label "Вал" format ">>9"
for-pay-name column-label "Метод !платежа" format "X(20)"
sym6 column-label ":" format "X(1)"
benefits.qnty column-label "Литры"
benefits.tot-base column-label "Сумма" format "->,>>>,>>>,>>>,>>9.99"
sym7 column-label ":" format "X(1)"
HEADER  date_string AT 5 format "X(35)"
v-header-base-curr        format "X(20)" AT 42
"Страница " AT 65 PAGE-NUMBER( PrnLibStream )  AT 75 FORMAT ">>9" SKIP
Line format "X(114)" AT 1
with width {&DOS_CW_2} down stream-io use-text .


DEFINE FRAME Benefit-Tot
sym1 column-label ":!:" format "X(1)"
benefits.b-code column-label "Код"
benefits.gds-name column-label "Вид топлива" format "X(30)"
benefits.pay-code column-label "  " format ">>9"
benefits.curr-code column-label "Вал" format ">>9"
for-pay-name column-label "Метод !платежа" format "X(20)"
sym3 column-label ":!:" format "X(1)"
benefits.qnty column-label "Литры"
benefits.tot-sum column-label "Сумма!в валюте" format "->>>>,>>>,>>>,>>9.99"
sym5 column-label ":!:" format "X(1)"
benefits.tot-base column-label "Сумма!в Б.Вал."
        format "->>>>>,>>>,>>9.99"
sym6 column-label ":!:" format "X(1)"
benefits.tot-rubl column-label "Сумма!в {&abbr_rublyah}" format "->>>>,>>>,>>>,>>9.99"
sym7 column-label ":!:" format "X(1)"
HEADER  date_string AT 5 format "X(35)"
string( "( Б.Вал. - " + caps( trim( base-type ) ) + " )" ) format "X(20)" AT 42
"Страница " AT 115 PAGE-NUMBER( PrnLibStream ) AT 125 FORMAT ">>9" SKIP
 Line format "X(143)" AT 1
with width {&DOS_CW_2} down stream-io use-text .

DEFINE FRAME Pay-Base
sym1 column-label ":"format "X(1)"
benefits.pay-code column-label "  " format ">>9"
benefits.curr-code column-label "Вал" format ">>9"
for-pay-name column-label "Метод !платежа" format "X(20)"
benefits.b-code column-label "Код"
benefits.gds-name column-label "Вид топлива" format "X(30)"
sym6 column-label ":" format "X(1)"
benefits.qnty column-label "Литры"
benefits.tot-base column-label "Сумма" format "->,>>>,>>>,>>>,>>9.99"
sym7 column-label ":" format "X(1)"
HEADER  date_string AT 5 format "X(35)"
v-header-base-curr        format "X(20)" AT 42
"Страница " AT 65 PAGE-NUMBER( PrnLibStream )  AT 75 FORMAT ">>9" SKIP
Line format "X(114)" AT 1
with width {&DOS_CW_2} down stream-io use-text .


DEFINE FRAME Pay-Tot
sym1 column-label ":!:" format "X(1)"
benefits.pay-code column-label "  " format ">>9"
benefits.curr-code column-label "Вал" format ">>9"
for-pay-name column-label "Метод !платежа" format "X(20)"
benefits.b-code column-label "Код"
benefits.gds-name column-label "Вид топлива" format "X(30)"
sym3 column-label ":!:" format "X(1)"
benefits.qnty column-label "Литры"
benefits.tot-sum column-label "Сумма!в валюте" format "->>>>,>>>,>>>,>>9.99"
sym5 column-label ":!:" format "X(1)"
benefits.tot-base column-label "Сумма!в Б.Вал."
        format "->>>>>,>>>,>>9.99"
sym6 column-label ":!:" format "X(1)"
benefits.tot-rubl column-label "Сумма!в {&abbr_rublyah}" format "->>>>,>>>,>>>,>>9.99"
sym7 column-label ":!:" format "X(1)"
HEADER  date_string AT 5 format "X(35)"
string( "( Б.Вал. - " + caps( trim( base-type ) ) + " )" ) format "X(20)" AT 42
"Страница " AT 115 PAGE-NUMBER( PrnLibStream ) AT 125 FORMAT ">>9" SKIP
Line format "X(143)" AT 1
with width {&DOS_CW_2} down stream-io use-text .

{ rep/e-nobenq.i }

assign
date_string = cur-time-print()
Line = fill( "-", 142 )
my-set_val_type = if x-set_Val_Type = 0 then {&v-base} else x-Set_val_type.


run no-benq(output found).

run no-benqi(output NotInc).

if not found then do:
  run waitfram-hide in this-procedure .
  message {&no-benefits} view-as alert-box information .
  return.
end.

run waitfram-show in this-procedure ( {&MyWaitMess} ) .
Run ByTemp.

PROCEDURE ByTemp :
if v-curr-r-b = {&r-b-base} then do:
  sale-price-type = base-type.
end.
else do:
  sale-price-type = "{&abbr_rubley}".
end.

run t-beneq.

IF method = "b-code":U then RUN Proc-b-code.
else RUN Proc-pay-code.
/*
assign
g#rep-tblname = ""
g#rep-tblrid = -101
g#rep-updflds = string( (if method = "b-code":U
                                      then 'Продажи топлива по видам оплаты'
                                      else 'Топливные платежи по видам топлива')
                                      + str1) .
*/
run prn-lib-prn-file in this-procedure (
                                          input my-handle
                                          ,input 0
                                          ).


END PROCEDURE.


PROCEDURE Proc-b-code:

run waitfram-hide in this-procedure .
run prn-lib-open-stream  in this-procedure (
                                             input my-handle
                                            ,input {&LS_PS_A4}
                                            ,input yes /*p-is-stream*/
                                            ,input no /*p-append*/
                                            ).


FORM HEADER
Line format "X(114)" AT 1 SKIP
"Продолжение - на следующей странице" AT 30 SKIP
with FRAME BottomFrame width {&DOS_CW_2} PAGE-BOTTOM NO-LABELS NO-BOX .
VIEW stream PrnLibStream FRAME BottomFrame .

FIND FIRST ub.clients No-LOCK WHERE ub.clients.obj-type = v-cntxt-obj-type
                             AND ub.clients.obj-code = v-cntxt-obj-code No-ERROR.

PUT stream PrnLibStream space(5)  "ОТЧЕТ  ПО  ВИДАМ ТОПЛИВА С РАЗБИВКОЙ ПО ТИПАМ ОПЛАТЫ" skip(1).
PUT stream PrnLibStream UNFORMATTED str4 skip(0).
PUT stream PrnLibStream str1  format "X(120)" SKIP(1)
space(5) (
IF NotInc then
"( сформирован по ВСЕМ ЧЕКАМ " + (IF cas-num = 0 then "ВСЕХ КАСС" ELSE
("КАССЫ " + string(cas-num))) + " , включая невошедшие в отчеты о продажах )"
else
"( сформирован по ВСЕМ ЧЕКАМ " + (IF cas-num = 0 then "ВСЕХ КАСС" ELSE
("КАССЫ " + string(cas-num) ) ) + ")"
 )
format "x(80)" skip
.
CASE my-set_val_type :
  when {&v-base} then
    FORM with frame Benefit-Base .
  when {&v-all} then
    FORM with frame Benefit-Tot .
END CASE .
_benefits:
FOR EACH benefits
BREAk
BY benefits.b-code
BY benefits.pay-code :
  if benefits.is-real-top <> 0 then do:
    ACCUMULATE
    benefits.qnty (total BY benefits.b-code)
    benefits.tot-base (total BY benefits.b-code)
    benefits.tot-rubl (total BY benefits.b-code).
    FIND FIRST ub.cash-pay No-LOCK WHERE ub.cash-pay.cdpay-code = benefits.pay-code No-ERROR.
    IF AVAIL ub.cash-pay
    then do:
      for-pay-name = ub.cash-pay.obj-name.
    end.
    else do:
      if benefits.pay-code = 0 then do:
        for-pay-name = "Нетопливные платежи".
      end.
      else do:
        for-pay-name = "Неопознанный платеж".
      end.
    end.
    FIND FIRST pays WHERE
              pays.pay-code = benefits.pay-code NO-ERROR.
    IF NOT AVAIL pays then do:
      create pays.
      assign
      pays.pay-code = benefits.pay-code
      pays.pay-name = for-pay-name
      .
    end.
    assign
    pays.qnty = pays.qnty  + benefits.qnty
    pays.tot-rubl = pays.tot-rubl  + benefits.tot-rubl
    pays.tot-base = pays.tot-base  + benefits.tot-base
    .
  end.
  IF FIRST-OF(benefits.b-code) then do:
    if benefits.is-real-top <> 0 then do:
      CASE my-set_val_type :
        when {&v-base} then do:
          DISPLAY stream PrnLibStream
          benefits.b-code
          benefits.gds-name
          benefits.pay-code
          benefits.curr-code
          for-pay-name
          benefits.qnty
          (if v-curr-r-b = {&r-b-base}
          then benefits.tot-base
          else benefits.tot-rubl) @  benefits.tot-base
          sym1
          sym6
          sym7
          with frame Benefit-Base .
          DOWN stream PrnLibStream 1 with frame Benefit-Base .
        end.
        when {&v-all} then do:
          DISPLAY stream PrnLibStream
          benefits.b-code
          benefits.gds-name
          benefits.pay-code
          benefits.curr-code
          for-pay-name
          benefits.qnty
          benefits.tot-rubl
          benefits.tot-base
          sym1
          sym6
          sym7
          with frame Benefit-Tot .
          DOWN stream PrnLibStream 1 with frame Benefit-Tot .
        end.
      END CASE .
    end. /*if benefits.is-real-top <> 0 then do:*/
  END.
  ELSE do:
    if benefits.is-real-top <> 0 then do:
      CASE my-set_val_type :
        when {&v-base} then do:
          DISPLAY stream PrnLibStream
          " " @ benefits.b-code
          " " @ benefits.gds-name
          benefits.pay-code
          benefits.curr-code
          for-pay-name
          benefits.qnty
          (if v-curr-r-b = {&r-b-base}
          then benefits.tot-base
          else benefits.tot-rubl) @  benefits.tot-base
          sym1
          sym6
          sym7
          with frame Benefit-Base .
          DOWN stream PrnLibStream 1 with frame Benefit-Base .
        end.
        when {&v-all} then do:
          DISPLAY stream PrnLibStream
          " " @ benefits.b-code
          " " @ benefits.gds-name
          benefits.pay-code
          benefits.curr-code
          for-pay-name
          benefits.qnty
          benefits.tot-rubl
          benefits.tot-base
          sym1
          sym6
          sym7
          with frame Benefit-Tot .
          DOWN stream PrnLibStream 1 with frame Benefit-Tot .
        end.
      END CASE .
    end. /*if benefits.is-real-top <> 0 then do:*/
  END.
  IF LAST-OF(benefits.b-code) then do:
    if benefits.is-real-top <> 0 then do:
      CASE my-set_val_type :
        when {&v-base} then do:
          DISPLAY stream PrnLibStream
          " " @ benefits.b-code
          " " @ benefits.gds-name
          " " @ benefits.pay-code
          "   " @ benefits.curr-code
          "            Итого" @ for-pay-name
          ACCUM total BY benefits.b-code benefits.qnty @ benefits.qnty
          (if v-curr-r-b = {&r-b-base}
          then  ACCUM total BY benefits.b-code benefits.tot-base
          else  ACCUM total BY benefits.b-code benefits.tot-rubl)  @ benefits.tot-base
          with frame Benefit-Base .
          DOWN stream PrnLibStream 1 with frame Benefit-Base .
          UNDERLINE stream PrnLibStream
          benefits.b-code
          benefits.gds-name
          benefits.pay-code
          benefits.curr-code
          for-pay-name
          benefits.qnty
          benefits.tot-base
          with frame Benefit-Base .
        end.
        when {&v-all} then do:
          DISPLAY stream PrnLibStream
          " " @ benefits.b-code
          " " @ benefits.gds-name
          " " @ benefits.pay-code
          "   " @ benefits.curr-code
          "            Итого" @ for-pay-name
          ACCUM total BY benefits.b-code benefits.qnty  @ benefits.qnty
          ACCUM total BY benefits.b-code benefits.tot-rubl @ benefits.tot-rubl
          ACCUM total BY benefits.b-code benefits.tot-base @ benefits.tot-base
          with frame Benefit-Tot .
          DOWN stream PrnLibStream 1 with frame Benefit-Tot .
          UNDERLINE stream PrnLibStream
          benefits.b-code
          benefits.gds-name
          benefits.pay-code
          benefits.curr-code
          for-pay-name
          benefits.qnty
          benefits.tot-rubl
          benefits.tot-base
          with frame Benefit-Tot .
        end.
      END CASE .
    end. /*if benefits.is-real-top <> 0 then do:*/
  end.
  IF LAST(benefits.b-code) then do:
    FOR EACH pays No-LOCK
    BREAK
    BY PAYS.PAY-CODE:
      CASE my-set_val_type :
        when {&v-base} then do:
          DISPLAY stream PrnLibStream
          " " @ benefits.b-code
          IF FIRST(pays.pay-code) then "Всего по методам платежа "  else " "
          @ benefits.gds-name
          pays.pay-code @ benefits.pay-code
          pays.curr-code @ benefits.curr-code
          pays.pay-name @ for-pay-name
          pays.qnty @ benefits.qnty
          (if v-curr-r-b = {&r-b-base}
          then pays.tot-base
          else pays.tot-rubl ) @ benefits.tot-base
          with frame Benefit-Base .
          DOWN stream PrnLibStream 1 with frame Benefit-Base .
          IF LAST( pays.pay-code) then
          UNDERLINE stream PrnLibStream
          benefits.b-code
          benefits.gds-name
          benefits.pay-code
          benefits.curr-code
          for-pay-name
          benefits.qnty
          benefits.tot-base
          with frame Benefit-Base .
        end.
        when {&v-all} then do:
          DISPLAY stream PrnLibStream
          " " @ benefits.b-code
          IF FIRST(pays.pay-code) then "Всего по методам платежа "  else " "
          @ benefits.gds-name
          pays.pay-code @ benefits.pay-code
          pays.curr-code @ benefits.curr-code
          pays.pay-name @ for-pay-name
          pays.qnty @ benefits.qnty
          pays.tot-rubl @ benefits.tot-rubl
          pays.tot-base @ benefits.tot-base
          with frame Benefit-Tot .
          DOWN stream PrnLibStream 1 with frame Benefit-Tot .
          IF LAST( pays.pay-code) then
          UNDERLINE stream PrnLibStream
          benefits.b-code
          benefits.gds-name
          benefits.pay-code
          benefits.curr-code
          for-pay-name
          benefits.qnty
          benefits.tot-rubl
          benefits.tot-base
          with frame Benefit-Tot .
        end.
      END CASE .
    END.

    CASE my-set_val_type :
      when {&v-base} then do:
        DISPLAY stream PrnLibStream
        " " @ benefits.b-code
        "ВСЕГО ПРОДАНО ТОПЛИВА" @ benefits.gds-name
        " "  @ for-pay-name
        ACCUM TOTAL benefits.qnty @ benefits.qnty
        (if v-curr-r-b = {&r-b-base}
        then  ACCUM TOTAL benefits.tot-base
        else  ACCUM TOTAL benefits.tot-rubl) @ benefits.tot-base
        with frame Benefit-Base .
        DOWN stream PrnLibStream 1 with frame Benefit-Base .
      end.
      when {&v-all} then do:
        DISPLAY stream PrnLibStream
        " " @ benefits.b-code
        "ВСЕГО ПРОДАНО ТОПЛИВА" @ benefits.gds-name
        " "  @ for-pay-name
        ACCUM TOTAL benefits.qnty @ benefits.qnty
        ACCUM TOTAL benefits.tot-rubl @ benefits.tot-rubl
        ACCUM TOTAL benefits.tot-base @ benefits.tot-base
        with frame Benefit-Tot .
        DOWN stream PrnLibStream 1 with frame Benefit-Tot .
      end.
    END CASE .
  END.
END.

if  my-set_val_type = {&v-all} then
    PUT stream PrnLibStream Line format "X(147)" SKIP(1) .
else
    PUT stream PrnLibStream Line format "X(114)" SKIP(1) .

if can-find(FIRST bad-chk) then do:
  FOR EACH bad-chk No-LOCK:
    if length(bad-chk-str) + length(bad-chk.doc-code + {&space-char} +
                                  "погрешн." +  {&space-char} + string(bad-chk.delta) + {&new-line}) > 31900 then do:
      bad-chk-str = bad-chk-str + " .....".
      leave.
    end.
    assign
    bad-chk-str = bad-chk-str + bad-chk.doc-code + {&space-char} +
                  "погрешность" +  {&space-char} + string(bad-chk.delta) + {&new-line}
    .
  END.
  run gbl/d-prompt.w (
      'title="Чеки, в которых топливными платежами оплачены нетопливные товары (в отчет не вошли):"\'
    + 'type=editor\'
    + 'fillin_width=96\'
    + 'fillin_height=15\'
    + 'readonly=yes\'
    , input-output bad-chk-str ).
/*          if return-value = 'false':u then do:*/
/*            return error.*/
/*          end.*/
end.

if ( line-counter( PrnLibStream ) + 9 ) > page-size( PrnLibStream ) then  page .

PUT stream PrnLibStream
space(10)
"Директор _______________" format "X(30)"
"Старший продавец ______________" format "X(30)" SKIP(2)
space(10)
"Бухгалтер ______________" format "X(30)"
"Кассир ________________________" format "X(30)" SKIP .

HIDE stream PrnLibStream FRAME BottomFrame.

output stream PrnLibStream CLOSE.



END PROCEDURE .


PROCEDURE Proc-pay-code:

run waitfram-hide in this-procedure .
run prn-lib-open-stream  in this-procedure (
                                             input my-handle
                                            ,input {&LS_PS_A4}
                                            ,input yes /*p-is-stream*/
                                            ,input no /*p-append*/
                                            ).


FORM HEADER
Line format "X(114)" AT 1 SKIP
"Продолжение - на следующей странице" AT 30 SKIP
with FRAME BottomFrame1 width {&DOS_CW_2} PAGE-BOTTOM NO-LABELS NO-BOX .
VIEW stream PrnLibStream FRAME BottomFrame1 .

FIND FIRST ub.clients No-LOCK WHERE
          ub.clients.obj-type = v-cntxt-obj-type
     AND  ub.clients.obj-code = v-cntxt-obj-code No-ERROR.
PUT stream PrnLibStream unformatted space(5)
"ОТЧЕТ  ПО  ТИПАМ ОПЛАТ С РАЗБИВКОЙ ПО ВИДАМ ТОПЛИВА И ТОВАРАМ ТОПЛИВНОГО КОШЕЛЬКА" skip(1).
PUT stream PrnLibStream UNFORMATTED str4 skip(0).
PUT stream PrnLibStream str1  format "X(120)" SKIP(1)
space(5) (
IF NotInc then
"( сформирован по ВСЕМ ЧЕКАМ " + (IF cas-num = 0 then "ВСЕХ КАСС" ELSE
("КАССЫ " + string(cas-num))) + " , включая невошедшие в отчеты о продажах )"
else
"( сформирован по ВСЕМ ЧЕКАМ " + (IF cas-num = 0 then "ВСЕХ КАСС" ELSE
("КАССЫ " + string(cas-num) ) ) + ")"
 )
format "x(80)" skip
.
CASE my-set_val_type :
        when {&v-base} then
            FORM with frame Pay-Base .
        when {&v-all} then
            FORM with frame Pay-Tot .
END CASE .
FOR EACH benefits BREAk BY benefits.pay-code BY benefits.b-code  :
        ACCUMULATE
        benefits.qnty (total BY benefits.pay-code)
        benefits.tot-base (total BY benefits.pay-code)
        benefits.tot-rubl (total BY benefits.pay-code).

        FIND FIRST ub.cash-pay No-LOCK WHERE ub.cash-pay.cdpay-code = benefits.pay-code No-ERROR.
        IF AVAIL ub.cash-pay then for-pay-name = ub.cash-pay.obj-name.
        else if benefits.pay-code = 0
                then
                for-pay-name = "Нетопливные платежи".
                else
                for-pay-name = "Неопознанный платеж".
        FIND FIRST pays WHERE pays.pay-code = benefits.pay-code NO-ERROR.
        IF NOT AVAIL pays then do:
            create b-codes.
            assign b-codes.b-code = benefits.b-code
                        b-codes.gds-name = benefits.gds-name.
        end.
        assign
        b-codes.qnty = b-codes.qnty  + benefits.qnty
        b-codes.tot-rubl = b-codes.tot-rubl  + benefits.tot-rubl
        b-codes.tot-base = b-codes.tot-base  + benefits.tot-base.

        IF FIRST-OF(benefits.pay-code) then do:
            CASE my-set_val_type :
                    when {&v-base} then do:
                        DISPLAY stream PrnLibStream
                        benefits.b-code
                        benefits.gds-name
                        benefits.pay-code
                        benefits.curr-code
                        for-pay-name
                        benefits.qnty
                        (if v-curr-r-b = {&r-b-base}
                        then  benefits.tot-base
                        else benefits.tot-rubl
                        ) @ benefits.tot-base
                        sym1
                        sym6
                        sym7
                        with frame Pay-Base .
                        DOWN stream PrnLibStream 1 with frame Pay-Base .
                    end.
                    when {&v-all} then do:
                        DISPLAY stream PrnLibStream
                        benefits.b-code
                        benefits.gds-name
                        benefits.pay-code
                        benefits.curr-code
                        for-pay-name
                        benefits.qnty
                        benefits.tot-rubl
                        benefits.tot-base
                        sym1
                        sym6
                        sym7
                        with frame Pay-Tot .
                        DOWN stream PrnLibStream 1 with frame Pay-Tot .
                    end.
             END CASE .
        END.
        ELSE do:
            CASE my-set_val_type :
                    when {&v-base} then do:
                        DISPLAY stream PrnLibStream
                        benefits.b-code
                        benefits.gds-name
                        " " @ benefits.pay-code
                        "   " @ benefits.curr-code
                        " " @ for-pay-name
                        benefits.qnty
                        (if v-curr-r-b = {&r-b-base}
                        then  benefits.tot-base
                        else benefits.tot-rubl
                        ) @ benefits.tot-base
                        sym1
                        sym6
                        sym7
                        with frame Pay-Base .
                        DOWN stream PrnLibStream 1 with frame Pay-Base .
                    end.
                    when {&v-all} then do:
                        DISPLAY stream PrnLibStream
                        benefits.b-code
                        benefits.gds-name
                        " " @ benefits.pay-code
                        "   " @ benefits.curr-code
                        " " @ for-pay-name
                        benefits.qnty
                        benefits.tot-rubl
                        benefits.tot-base
                        sym1
                        sym6
                        sym7
                        with frame Pay-Tot .
                        DOWN stream PrnLibStream 1 with frame Pay-Tot .
                    end.
             END CASE .
        END.
        IF LAST-OF(benefits.pay-code) then do:
    CASE my-set_val_type :
                    when {&v-base} then do:
                        DISPLAY stream PrnLibStream
                        " " @ benefits.b-code
                        "            Итого" @ benefits.gds-name
                        " " @ benefits.pay-code
                        "   " @ benefits.curr-code
                         " " @ for-pay-name
                        ACCUM total BY benefits.pay-code benefits.qnty @ benefits.qnty
                        (if v-curr-r-b = {&r-b-base}
                        then ACCUM total BY benefits.pay-code benefits.tot-base
                        else ACCUM total BY benefits.pay-code benefits.tot-rubl) @ benefits.tot-base
                        with frame Pay-Base .
                        DOWN stream PrnLibStream 1 with frame Pay-Base .
                        UNDERLINE stream PrnLibStream
                        benefits.b-code
                        benefits.gds-name
                        benefits.pay-code
                        benefits.curr-code
                        for-pay-name
                        benefits.qnty
                        benefits.tot-base
                        with frame Pay-Base .
                    end.
                    when {&v-all} then do:
                        DISPLAY stream PrnLibStream
                        " " @ benefits.b-code
                        "            Итого" @ benefits.gds-name
                        " " @ benefits.pay-code
                        "   " @ benefits.curr-code
                         " " @ for-pay-name
                        ACCUM total BY benefits.pay-code benefits.qnty  @ benefits.qnty
                        ACCUM total BY benefits.pay-code benefits.tot-rubl @ benefits.tot-rubl
                        ACCUM total BY benefits.pay-code benefits.tot-base @ benefits.tot-base
                        with frame Pay-Tot .
                        DOWN stream PrnLibStream 1 with frame Pay-Tot .
                        UNDERLINE stream PrnLibStream
                        benefits.b-code
                        benefits.gds-name
                        benefits.pay-code
                        benefits.curr-code
                        for-pay-name
                        benefits.qnty
                        benefits.tot-rubl
                        benefits.tot-base
                        with frame Pay-Tot .
                    end.
             END CASE .
        end.
        IF LAST(benefits.b-code) then do:
            FOR EACH pays No-LOCK BREAK BY b-codes.b-code:
                CASE my-set_val_type :
                        when {&v-base} then do:
                            DISPLAY stream PrnLibStream
                            b-codes.b-code @ benefits.b-code
                            IF FIRST(b-codes.b-code) then "Всего по видам топлива "  else " "
                            @ for-pay-name
                            " " @ benefits.pay-code
                            "   " @ benefits.curr-code
                            b-codes.gds-name @ benefits.gds-name
                            b-codes.qnty @ benefits.qnty
                            (if v-curr-r-b = {&r-b-base}
                            then b-codes.tot-base
                            else b-codes.tot-rubl) @ benefits.tot-base
                            with frame Pay-Base .
                            DOWN stream PrnLibStream 1 with frame Pay-Base .
                            IF LAST( b-codes.b-code) then
                            UNDERLINE stream PrnLibStream
                            benefits.b-code
                            benefits.gds-name
                            benefits.pay-code
                            benefits.curr-code
                            for-pay-name
                            benefits.qnty
                            benefits.tot-base
                            with frame Pay-Base .
                        end.
                            when {&v-all} then do:
                            DISPLAY stream PrnLibStream
                            b-codes.b-code @ benefits.b-code
                            IF FIRST(b-codes.b-code) then "Всего по видам топлива "  else " "
                            @ for-pay-name
                            " " @ benefits.pay-code
                            "   " @ benefits.curr-code
                            b-codes.gds-name @ benefits.gds-name
                            b-codes.qnty @ benefits.qnty
                            b-codes.tot-rubl @ benefits.tot-rubl
                            b-codes.tot-base @ benefits.tot-base
                            with frame Pay-Tot .
                            DOWN stream PrnLibStream 1 with frame Pay-Tot .
                            IF LAST( b-codes.b-code) then
                            UNDERLINE stream PrnLibStream
                            benefits.b-code
                            benefits.gds-name
                            benefits.pay-code
                            benefits.curr-code
                            for-pay-name
                            benefits.qnty
                            benefits.tot-rubl
                            benefits.tot-base
                            with frame Pay-Tot .
                        end.
                 END CASE .
            END.

            CASE my-set_val_type :
                    when {&v-base} then do:
                        DISPLAY stream PrnLibStream
                        " " @ benefits.b-code
                        "ВСЕГО ПРОДАНО ТОПЛИВА" @ benefits.gds-name
                        " "  @ for-pay-name
                        ACCUM TOTAL benefits.qnty @ benefits.qnty
                        (if v-curr-r-b = {&r-b-base}
                        then ACCUM TOTAL benefits.tot-base
                        else ACCUM TOTAL benefits.tot-rubl) @ benefits.tot-base
                        with frame Pay-Base .
                        DOWN stream PrnLibStream 1 with frame Pay-Base .
                    end.
                    when {&v-all} then do:
                        DISPLAY stream PrnLibStream
                        " " @ benefits.b-code
                        "ВСЕГО ПРОДАНО ТОПЛИВА" @ benefits.gds-name
                        " "  @ for-pay-name
                        ACCUM TOTAL benefits.qnty @ benefits.qnty
                        ACCUM TOTAL benefits.tot-rubl @ benefits.tot-rubl
                        ACCUM TOTAL benefits.tot-base @ benefits.tot-base
                        with frame Pay-Tot .
                        DOWN stream PrnLibStream 1 with frame Pay-Tot .
                    end.
             END CASE .
        END.
END.


        if my-set_val_type = {&v-all} then
            PUT stream PrnLibStream Line format "X(147)" SKIP(1) .
        else
            PUT stream PrnLibStream Line format "X(114)" SKIP(1) .
        if can-find(first bad-chk) then dO:
        PUT STREAM PrnLibStream UNFORMATTED
        "Чеки, в которых топливными платежами оплачены нетопливные товары (в отчет не вошли):" skip.
        FOR EACH bad-chk No-LOCK:
            PUT STREAM PrnLibStream UNFORMATTED
            bad-chk.doc-code " ".
            accumulate bad-chk.doc-code(COUNT).
            if (accum count bad-chk.doc-code) Modulo 5 = 0 then
            PUT STREAM PrnLibStream skip.
        END.
        PUT STREAM PrnLibStream UNFORMATTED skip.
        if ( line-counter( PrnLibStream ) + 9  +
             (accum count bad-chk.doc-code) / 5 + (accum count bad-chk.doc-code) Modulo 5  + 2
            ) > page-size( PrnLibStream ) then  page .

        end.
        else do:
                if ( line-counter( PrnLibStream ) + 9 ) > page-size( PrnLibStream ) then  page .
        end.
        PUT stream PrnLibStream space(10) "Директор _______________" format "X(30)"
                                "Старший продавец ______________" format "X(30)" SKIP(2)
                            space(10) "Бухгалтер ______________" format "X(30)"
                                "Кассир ________________________" format "X(30)" SKIP .

        HIDE stream PrnLibStream FRAME BottomFrame1 .

        output stream PrnLibStream CLOSE.




END PROCEDURE .


PROCEDURE t-beneq.
define var sum-list as character no-undo.
define var pay-code-list as character no-undo.
define var curr-code-list as character no-undo.
define var atr64-list as character no-undo.
define var exch-list as character no-undo.
define var for-sum as decimal no-undo.
define var b-sum as decimal no-undo.
define var dop-sum as decimal no-undo.
define var dop-sum2 as decimal no-undo.
define var b-qnty as decimal no-undo.
/*чек включает нетопливный товар*/
define variable nottopgood as logical no-undo.
define variable is-real-top as logical no-undo .
/*сумма нетопливного товара*/
define variable nottopsum as decimal no-undo.
/*сумма нетопливных платежей*/
define variable nottoppaysum as decimal no-undo.
define variable nottoppaysum-rubl as decimal no-undo.
define variable nottoppaysum-base as decimal no-undo.
define variable nottoppayexch as decimal no-undo.
define variable curr-b-code like ub.bar-code.b-code no-undo.
define variable curr-is-real-top as integer no-undo .
define variable  b-name like ub.goods.gds-name no-undo.
define variable  b-price as decimal no-undo.
define variable b-pricen as decimal no-undo.
define variable b-code-list as char no-undo.
define variable b-sum-list as char no-undo.
define variable b-price-list as char no-undo.
define variable b-pricen-list as char no-undo.
define variable b-name-list as char no-undo.
define variable b-qnty-list as char no-undo.
define variable is-real-top-list as character no-undo .
define variable entry-num as integer no-undo.
define variable ii as integer no-undo.
DEFINE VARIABLE sign as integer no-undo .

for each units no-lock where
      lookup( {&petrolium}, units.type) > 0,
  each buf_goods no-lock where
        buf_goods.unit-base = units.unit-name  , first bar-code no-lock where bar-code.gds-code  = buf_goods.gds-code
        :
      FOR EACH obj-list WHERE obj-list.obj-type = {&shop} NO-LOCK :
        ACCUMULATE obj-list.obj-code ( COUNT ) .
/*НАДО УБЕДИТЬСЯ ЧТО ВСЕ РАЗМАЗАНО!!*/
run rep/rpychk0.p ( input "r-shftc2"
                    ,input obj-list.obj-type
                    ,input obj-list.obj-code
                    ,input ? /*p-date-from*/
                    ,input ? /*p-date-to*/
                    ,input X-date-start /*p-shift-date-from*/
                    ,input X-date-end /*p-shift-date-to*/
                    ,input 1 /*p-shift-num-start*/
                    ,input 99 /*p-shift-num-end*/
                    ,input ? /*p-inkas-code*/
                    ) no-error.
if error-status:error then do:
  message error-status:get-message(1) view-as alert-box.
end.

        CASE (X-radio-task > 1)  :
          WHEN yes THEN DO:
              for each buf_chk-gds-pay no-lock where buf_chk-gds-pay.b-code = bar-code.b-code  and
                buf_chk-gds-pay.obj-type = obj-list.obj-type AND
                buf_chk-gds-pay.obj-code = obj-list.obj-code AND
                (
                buf_chk-gds-pay.shift-date >= X-date-start AND
                buf_chk-gds-pay.shift-date <= X-date-end) :
                IF X-radio-task = 3 AND
                    ((buf_chk-gds-pay.shift-date = X-date-start AND buf_chk-gds-pay.shift-num < X-shift-start) OR
                      (buf_chk-gds-pay.shift-date = X-date-end AND  buf_chk-gds-pay.shift-num > X-shift-end) ) THEN NEXT.
                IF X-radio-task = 4 and buf_chk-gds-pay.shift-num <> x-shift-alone THEN NEXT.

                run  fill-behefit.
              end.

          end.
          WHEN no THEN DO:
              for each buf_chk-gds-pay no-lock where buf_chk-gds-pay.b-code = bar-code.b-code  and
                buf_chk-gds-pay.obj-type = obj-list.obj-type AND
                buf_chk-gds-pay.obj-code = obj-list.obj-code AND
                buf_chk-gds-pay.chk-date >= X-date-start AND
                buf_chk-gds-pay.chk-date <= X-date-end :
                run  fill-behefit.
              end.

          end.

        END. /*CASE*/
      END. /*FOR EACH obj-list*/

end.
         /*
FOR EACH obj-list WHERE obj-list.obj-type = {&shop} NO-LOCK :
  ACCUMULATE obj-list.obj-code ( COUNT ) .

  CASE (X-radio-task > 1) :
    WHEN YES THEN DO:
_chk-doc1:
      FOR EACH ub.chk-doc WHERE
                ub.chk-doc.obj-type = obj-list.obj-type AND
              ub.chk-doc.obj-code = obj-list.obj-code AND
                (
                ub.chk-doc.shift-date >= X-date-start AND
                ub.chk-doc.shift-date <= X-date-end)
                AND
              (IF cas-num > 0 then ub.chk-doc.pay-desk = cas-num else TRUE)
              NO-LOCK use-index shift,
          EACH ub.chk-gds NO-LOCK WHERE
                ub.chk-doc.doc-code = ub.chk-gds.doc-code /*AND chk-gds.pump > 0*/
      BREAK
      BY ub.chk-doc.doc-code
      BY ub.chk-gds.b-code:
        if lookup(string(ub.chk-doc.chk-type), {&no-sale-receipt-codes}) > 0 then next _chk-doc1.
        IF X-radio-task = 3 AND
            ((chk-doc.shift-date = X-date-start AND chk-doc.shift-num < X-shift-start) OR
              (chk-doc.shift-date = X-date-end AND  chk-doc.shift-num > X-shift-end) ) THEN NEXT.
        IF X-radio-task = 4 and chk-doc.shift-num <> x-shift-alone THEN NEXT.
        assign
        sign = if chk-doc.netto >=0 then 1 else - 1
        .
        { rep/e-toppyq.i _chk-doc1}
      END. /*FOR EACH chk-doc*/
    END. /*WHEN YES*/
    WHEN NO THEN DO:
_chk-doc2:
      FOR EACH chk-doc WHERE
              chk-doc.obj-type = obj-list.obj-type AND
              chk-doc.obj-code = obj-list.obj-code AND
              chk-doc.chk-date >= X-date-start AND
              chk-doc.chk-date <= X-date-end AND
              (IF cas-num > 0 then chk-doc.pay-desk = cas-num else TRUE)
              NO-LOCK,
          EACH chk-gds NO-LOCK WHERE
                chk-doc.doc-code = chk-gds.doc-code /*AND chk-gds.pump > 0*/
      BREAK
      BY chk-doc.doc-code
      BY chk-gds.b-code:
        if lookup(string(chk-doc.chk-type), {&no-sale-receipt-codes}) > 0 then next _chk-doc2.
        assign
        sign = if chk-doc.netto >=0 then 1 else - 1
        .
        { rep/e-toppyq.i _chk-doc2}
      END. /*FOR EACH chk-doc*/
    END. /*WHEN NO*/
  END. /*CASE*/
END. /*FOR EACH obj-list*/
*/
END PROCEDURE.
PROCEDURE fill-behefit:
                  CASE entry(1, buf_chk-gds-pay.line-type, {&delim-par}):
                    WHEN {&petrolium} then do:

                        FIND FIRST benefits No-LOCK WHERE
                                  benefits.b-code = bar-code.b-code
                              AND benefits.pay-code = buf_chk-gds-pay.pay-code
                              AND benefits.curr-code = buf_chk-gds-pay.curr-code
                              No-ERROR.
                        IF NOT AVAIL benefits then do:
                          create benefits.
                          assign
                          benefits.b-code = bar-code.b-code
                          benefits.pay-code = buf_chk-gds-pay.pay-code
                          benefits.curr-code = buf_chk-gds-pay.curr-code
                          benefits.gds-name = buf_goods.gds-name
                          benefits.tot-sum = 0
                          benefits.tot-base = 0
                          benefits.tot-rubl = 0
                          benefits.is-real-top = 1
                          .
                        END.

                        assign
                        benefits.tot-base = benefits.tot-base +
                                                        (if v-curr-r-b = {&r-b-base}

                                                        then buf_chk-gds-pay.tot-r-b
                                                        else (if  buf_chk-gds-pay.tot-r-b = 0
                                                              then 0
                                                              else buf_chk-gds-pay.tot-r-b / buf_chk-gds-pay.eff-base-rate))
                        benefits.qnty =  benefits.qnty +  buf_chk-gds-pay.eff-doc-qnty
                        benefits.tot-rubl = benefits.tot-base.
                        .
                      end.
                  end.

end procedure.