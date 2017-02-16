/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Пересылка и удаление товаров из переоценок

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
define input parameter  action as character no-undo .
define input parpameter p-doc-num like ub.price-doc.doc-num.
define input parameter i-obj-code like ub.clients.obj-code no-undo.
*/

&SCOPED-DEFINE called   in-ov

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Пересылка и удаление товаров из переоценок".
{ cmp/vssrevis.i }
{ cmp/trg-def.i  }
{ gbl/getcntxt.i def }
{ gbl/clntattr.i }

define variable action as character no-undo .
define variable p-doc-num like ub.price-doc.doc-num no-undo .
define variable i-obj-code like ub.clients.obj-code no-undo.
define buffer p-doc for ub.price-doc .

assign
action = entry(1, p-parameter, {&delim-par})
p-doc-num = entry(2, p-parameter, {&delim-par})
i-obj-code = integer(entry(3, p-parameter, {&delim-par}))
no-error
.
if error-status:error then return error .
find first p-doc no-lock where
         p-doc.doc-num = p-doc-num no-error .
if not available p-doc then return error.

{ gbl/getcntxt.i get }

{ str/sendgood.i }