/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Выравнивание статусов в партиии документа и строк после закрыти

Автор: Чернова Светлана Александровна
Дата создания: 11/21/07
Author: Svetlana Chernova
Creation date: 11/21/07

*/
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Выравнивание статусов в партиии документа и строк после закрыти ".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }

define input  parameter p-doc-code as character no-undo .

find first ub.trn-doc no-lock where
           ub.trn-doc.doc-code = p-doc-code and
           ub.trn-doc.status_ = {&fact} no-error .

if not available ub.trn-doc then do:
   message "Нет документа закрытого на факт" p-doc-code view-as alert-box information .
   return.
end.

for each ub.parts exclusive-lock where
         ub.parts.out-code = ub.trn-doc.doc-code and
         ub.parts.obj-type = ub.trn-doc.obj-type and
         ub.parts.obj-code = ub.trn-doc.obj-code and
         ub.parts.status_   = false :

   ub.parts.status_   = true  .
end.

for each ub.doc-line exclusive-lock where
         ub.doc-line.doc-code = ub.trn-doc.doc-code and
         ub.doc-line.status_  <> ub.trn-doc.status_ :

   ub.doc-line.status_   = ub.trn-doc.status_  .
end.

message 'Все по документу' p-doc-code view-as alert-box information  .
