/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Утилита пересчета дополнительных сумм по одной инвентаризации

Автор: Гридчина Полина Дмитриевна
Дата создания: 12/04/11
Author: Alexey Suslov
Creation date: 12/04/11


*/

define input parameter pardoc-code               like ub.trn-doc.doc-code no-undo.

define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo initial "Утилита по расчету дополнительных сумм по документу":U .

def var p-ok as log no-undo.
for first ub.trn-doc where ub.trn-doc.doc-code = pardoc-code:
   p-ok = yes.
   for each ub.doc-line-sum where  ub.doc-line-sum.doc-code = pardoc-code:
      delete ub.doc-line-sum.
   end.
   run utl/uaddsum.p(pardoc-code,no,?,?) no-error.
   if error-status:error then do:
       message error-status:get-message(1) view-as alert-box.
       return.
   end.
end.
  if not p-ok then message "Документ не найден" view-as alert-box error.