/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Простая пересылка товаров на кассу по списку товаров

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
def input param i-obj-code like ub.clients.obj-code no-undo.
def input param action  as char no-undo.
*/


&SCOPED-DEFINE called send-gds
&SCOPED-DEFINE dop-called s-cgds

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Простая пересылка товаров на кассу по списку товаров".
{ cmp/vssrevis.i }
{ cmp/trg-def.i  }
{ gbl/getcntxt.i def }

define variable i-obj-code like ub.clients.obj-code no-undo.
define variable action  as char no-undo.
define variable p-batch as logical no-undo init no.
define variable p-other    as character no-undo .

assign
i-obj-code = integer(entry(1, p-parameter, {&delim-par}))
action = entry(2, p-parameter, {&delim-par})
no-error
.
if error-status:error then return error.

{ gbl/getcntxt.i get }

{ cmp/gds-list.i gds-list def shared }
{ str/sendgood.i }