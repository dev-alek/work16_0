/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

отчет о выручке  - сбор данных по чекам - общая часть для первого прохода по чекам

Автор: Бахтадзе Наталья Викторовна
Дата создания: 10/18/05
Author: Bakhtadze Natalya
Creation date: 10/18/05

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

if last-of( chk-pay.curr-code ) then do:
    FIND FIRST ub.cash-pay WHERE
                        ub.cash-pay.cdpay-code = ub.chk-pay.pay-code AND
                        ub.cash-pay.curr-code = ub.chk-pay.curr-code
                        NO-LOCK NO-ERROR.
    FIND FIRST ub.currency WHERE currency.curr-code = ub.chk-pay.curr-code NO-LOCK NO-ERROR.
    if avail ub.cash-pay
    or (not avail ub.cash-pay
        and acc-curr-sum <> acc-sub-curr-sum) then do:
      create benefits.
      assign
      benefits.pay-desk = ub.chk-doc.pay-desk
      benefits.obj-type = obj-list.obj-type
      benefits.obj-code = obj-list.obj-code
      benefits.pay-code = if avail ub.cash-pay then ub.cash-pay.cdpay-code else ub.chk-pay.pay-code
      benefits.pay-name = if avail ub.cash-pay then ub.cash-pay.obj-name else "Неопознанная оплата"
      benefits.curr-code = if avail ub.currency then ub.currency.curr-code else chk-pay.curr-code
      benefits.curr-name = if avail ub.currency then ub.currency.curr-name else "Неопознанная валюта"
      benefits.tot-sum   = acc-curr-sum - acc-sub-curr-sum
      benefits.tot-base = acc-curr-base - acc-sub-curr-base
      benefits.tot-rubl = acc-curr-rubl - acc-sub-curr-rubl
      benefits.tot-r-b = if v-curr-r-b = {&r-b-base}
                          then benefits.tot-base
                          else benefits.tot-rubl
      .
   end.
end.
if last-of( ub.chk-doc.pay-desk ) then do:
    FIND FIRST day_sum WHERE
                day_sum.obj-type = obj-list.obj-type AND
                day_sum.obj-code = obj-list.obj-code AND
                day_sum.pay-desk = ub.chk-doc.pay-desk NO-ERROR.

    assign
  day_sum.tot-rubl = acc-desk-rubl  - acc-sub-desk-rubl
  day_sum.tot-base = acc-desk-base - acc-sub-desk-base
    day_sum.tot-r-b = (if v-curr-r-b = {&r-b-base} then day_sum.tot-base else day_sum.tot-rubl)
    .
  assign
  acc-day-rubl = acc-day-rubl + day_sum.tot-rubl
  acc-day-base = acc-day-base + day_sum.tot-base
  acc-day-cnt = acc-day-cnt + day_sum.chk-cnt
  .
end.

/* $Workfile$ e n d */