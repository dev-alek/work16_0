/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Определения временных таблиц для отчета по выручке

Автор: Бахтадзе Наталья Викторовна
Дата создания: 03/24/06
Author: Bakhtadze Natalya
Creation date: 03/24/06

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

define {1} temp-table benefits no-undo
field obj-type  like    ub.clients.obj-type
field obj-code  like    ub.clients.obj-code
field date_      like    ub.chk-pay.chk-date
field pay-code   like    ub.cash-pay.cdpay-code
field pay-name   like    ub.cash-pay.obj-name
field curr-code  like    ub.currency.curr-code
field curr-name  like    ub.currency.curr-name
field tot-sum    like    ub.chk-pay.tot-sum
field tot-base   like    ub.chk-pay.tot-base
field tot-rubl   like    ub.chk-pay.tot-rubl
field tot-r-b     like    ub.chk-pay.tot-rubl
field pcnt          as      decimal
field pay-desk like ub.chk-doc.pay-desk
INDEX pi IS PRIMARY     obj-type obj-code date_  pay-desk ASCENDING
INDEX pc                         pay-code curr-code
.

define {1} temp-table inkas-num no-undo
field inkas-code like ub.inkas.inkas-code
field counted as logical
INDEX pi IS PRIMARY inkas-code.

define {1} temp-table day_sum no-undo
field obj-type   like    ub.clients.obj-type
field obj-code   like    ub.clients.obj-code
field date_      like   ub.chk-pay.chk-date
field tot-base   like   ub.chk-pay.tot-base
field tot-rubl   like   ub.chk-pay.tot-rubl
field tot-r-b    like   ub.chk-pay.tot-rubl
field chk-cnt as integer
field pay-desk   like ub.chk-doc.pay-desk
INDEX pi IS PRIMARY     obj-type obj-code date_ pay-desk ASCENDING .

define {1} temp-table all-days_sum no-undo
field obj-type   like    ub.clients.obj-type
field obj-code   like    ub.clients.obj-code
field tot-base   like   ub.chk-pay.tot-base
field tot-rubl   like   ub.chk-pay.tot-rubl
field tot-r-b    like   ub.chk-pay.tot-rubl
field chk-cnt    as integer
field pay-desk   like ub.chk-doc.pay-desk
INDEX pi IS PRIMARY     obj-type obj-code ASCENDING .


/* $Workfile$ e n d */