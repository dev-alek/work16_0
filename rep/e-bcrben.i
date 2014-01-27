/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет о выручке  - сбор данных по чекам - общая часть для второго прохода по чекам

Автор: Бахтадзе Наталья Викторовна
Дата создания: 04/10/06
Author: Bakhtadze Natalya
Creation date: 04/10/06

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

assign
acc-date-base  = acc-date-base   + chk-pay.tot-base
acc-date-rubl  = acc-date-rubl   + chk-pay.tot-rubl
acc-base       = acc-base        + chk-pay.tot-base
acc-rubl       = acc-rubl        + chk-pay.tot-rubl
acc-count      = acc-count       + 1
.
if (acc-count modulo 25 ) = 0
AND acc-count >= 25
then do:
run waitfram-show in this-procedure ( obj-list.obj-type + string( obj-list.obj-code ) +
                                ", обработано строк чеков : " +
                                  string( ACC-count) ) .
end.
if last-of( chk-pay.curr-code )
and (acc-curr-sum - acc-sub-curr-sum) <> 0
then do:
  find first benefits where
            benefits.obj-type = obj-list.obj-type
        and benefits.obj-code = obj-list.obj-code
        and benefits.pay-code =  chk-pay.pay-code
        and benefits.curr-code = chk-pay.curr-code
        and benefits.date = {1}
  no-error.
  if not available benefits then do:
    FIND FIRST ub.cash-pay WHERE
                        ub.cash-pay.cdpay-code = chk-pay.pay-code AND
                        ub.cash-pay.curr-code = chk-pay.curr-code
                      NO-LOCK NO-ERROR.
    FIND FIRST ub.currency WHERE ub.currency.curr-code = chk-pay.curr-code NO-LOCK NO-ERROR.
    create benefits.
    assign
    benefits.date = {1}
    benefits.obj-type = obj-list.obj-type
    benefits.obj-code = obj-list.obj-code
    benefits.pay-code = if avail ub.cash-pay then ub.cash-pay.cdpay-code else chk-pay.pay-code
    benefits.pay-name = if avail ub.cash-pay then ub.cash-pay.obj-name else "Неопознанная оплата"
    benefits.curr-code = if avail ub.currency then ub.currency.curr-code else chk-pay.curr-code
    benefits.curr-name = if avail ub.currency then ub.currency.curr-name else "Неопознанная валюта"
    .
  end.
  assign
  benefits.tot-sum  = benefits.tot-sum + acc-curr-sum - acc-sub-curr-sum
  benefits.tot-base = benefits.tot-base + acc-curr-base - acc-sub-curr-base
  benefits.tot-rubl = benefits.tot-rubl + acc-curr-rubl - acc-sub-curr-rubl
  benefits.tot-r-b  = (if v-curr-r-b = {&r-b-base} then benefits.tot-base else benefits.tot-rubl)
  .
end.

if last-of( {1} ) then do:
    FIND FIRST day_sum where
                        day_sum.obj-type = chk-pay.obj-type AND
                        day_sum.obj-code = chk-pay.obj-code AND
                        day_sum.date = {1} NO-ERROR.
   IF AVAIL day_sum then do:
   assign
    day_sum.tot-rubl = acc-date-rubl - acc-sub-date-rubl
    day_sum.tot-base = acc-date-base - acc-sub-date-base
   day_sum.tot-r-b  = (if v-curr-r-b = {&r-b-base} then day_sum.tot-base else day_sum.tot-rubl)
   .
    assign
    acc-day-rubl = acc-day-rubl + day_sum.tot-rubl
    acc-day-base = acc-day-base + day_sum.tot-base
    acc-day-cnt = acc-day-cnt + day_sum.chk-cnt
    .
   end.
end.


/* $Workfile$ e n d */