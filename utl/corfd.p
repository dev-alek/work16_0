/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Исправление даты-факт для незакрытого документа

Автор: Чернова Светлана Александровна
Дата создания: 05/02/07
Author: Svetlana Chernova
Creation date: 05/02/07

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Исправление даты-факт для незакрытого документа".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }

define variable  p-doc-code as character no-undo .

run gbl/d-prompt.w (
    'title=Корректировка факт-даты\'
        + 'text1=':U + "Введите номер документа" + '\':u
        + 'format=' + "X(20)" + '\':u
        + 'type=C\':u
  + 'fillin_width=20\'
  + 'fillin_height=1\'
  , input-output p-doc-code).

define buffer buf_trn-doc for ub.trn-doc  .
find first buf_trn-doc exclusive-lock where
           buf_trn-doc.doc-code = p-doc-code  no-error .
if not available buf_trn-doc then do:
   message
   "Не найден документ с номером" p-doc-code
   view-as alert-box information .
   return .
end.
if buf_trn-doc.status_ = {&fact}  then do:
   message
   "Документ с номером" p-doc-code "закрыт на ФАКТ"
   view-as alert-box information .
   return .
end.
assign
  buf_trn-doc.fact-date = ?
  buf_trn-doc.fact-num = 0
  buf_trn-doc.fact-order = 0
.
message "Все"
   view-as alert-box information .
   return .
