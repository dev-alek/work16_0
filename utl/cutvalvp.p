/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Проверка наличия документов внутреннего перемещени

Автор: Чернова Светлана Александровна
Дата создания: 04/27/07
Author: Svetlana Chernova
Creation date: 04/27/07

*/

define input  parameter p-cut-date as date no-undo . /* дата обрезания */
define output parameter p-ok as logical   no-undo .
define output parameter p-mess as character no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Проверка наличия документов внутреннего перемещени ".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
define buffer pri_trn-doc for ub.trn-doc  .
define buffer ras_trn-doc for ub.trn-doc  .
define buffer buf_clients for ub.clients  .

p-ok = true .
for each buf_clients no-lock where buf_clients.host-code > 0 :
for each ras_trn-doc no-lock where
         ras_trn-doc.obj-type     = buf_clients.obj-type and
         ras_trn-doc.obj-code     = buf_clients.obj-code and
         ras_trn-doc.status_      = {&fact} and
         ras_trn-doc.ext-doc-type = {&TDEDT_ras_Perem} and
         ras_trn-doc.fact-date   >= p-cut-date
        :
    find first pri_trn-doc no-lock where
        pri_trn-doc.out-code = ras_trn-doc.doc-code and
        pri_trn-doc.status_  = {&fact} no-error .
    if not available pri_trn-doc then do:
        p-ok = false .
        p-mess = substitute("Есть незакрытые внутренние приходы по документу &1 до даты обрезания " , ras_trn-doc.doc-code ) .
        leave.
    end.
end.

for each ras_trn-doc no-lock where
         ras_trn-doc.obj-type     = buf_clients.obj-type and
         ras_trn-doc.obj-code     = buf_clients.obj-code and
         ras_trn-doc.status_      = {&fact} and
         ras_trn-doc.fact-date   >= p-cut-date and
         ras_trn-doc.ext-doc-type = {&TDEDT_Ras_Vnesh} and
         ras_trn-doc.hold-obj-code > 0
        :
    find first pri_trn-doc no-lock where
        pri_trn-doc.out-code = ras_trn-doc.doc-code and
        pri_trn-doc.status_  = {&fact} no-error .
    if not available pri_trn-doc then do:
        p-ok = false .
        p-mess = substitute("Есть незакрытые МФ приходы по документу &1 до даты обрезания " , ras_trn-doc.doc-code ) .
        leave.
    end.
end.
end.