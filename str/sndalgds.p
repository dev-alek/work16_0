/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Пересылка товаров на кассу всех товаров одним списокм - например для ПАССАЖА

Автор: Бахтадзе Наталья Викторовна
Дата создания: 03/24/06
Author: Bakhtadze Natalya
Creation date: 03/24/06

*/

define input parameter parparentproc as widget-handle no-undo .
define input parameter p-parent-handle  as widget-handle no-undo .
define input parameter p-log-handle  as handle no-undo .
define input parameter p-parameter   as character no-undo .

/*
p-parameter включает

def input parameter i-obj-code like shop.obj-code no-undo.

*/


&SCOPED-DEFINE called sndalgds

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Пересылка товаров на кассу всех товаров одним списком":U.
{ cmp/vssrevis.i }
{ cmp/trg-def.i  }
{ gbl/getcntxt.i def }

define variable i-obj-code like ub.clients.obj-code no-undo.
define variable  action as char no-undo init "U".

assign
i-obj-code = integer(entry(1, p-parameter, {&delim-par}))
no-error
.
if error-status:error then return error.

{ gbl/getcntxt.i get }
{ str/sendgood.i }