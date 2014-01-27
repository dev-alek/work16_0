/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отправка заказов в новости

Автор: Чернова Светлана Александровна
Дата создания: 03/21/06
Author: Svetlana Chernova
Creation date: 03/21/06

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отправка заказов в новости".
{ cmp/vssrevis.i }
{ cmp/trg-def.i  }

define variable v-ind as integer   no-undo .
define variable lok   as logical   no-undo .

if g#db-num = 0 then do:
  message
    "Отправка в новости закрытых заказов возможна только из УБД" skip
    view-as alert-box error .
  return.
end.

assign
  lok = false
  v-ind = 0
.
message
  "Будут отправлены в новости все закрытые заказов по всем объектам БД" skip
  "Продолжить?" skip
  view-as alert-box buttons yes-no update lok .
if lok <> true then do:
  return .
end.

for each ub.ord-doc no-lock
  where ub.ord-doc.status_ = {&fact}
    and ub.ord-doc.flag_   = TRUE
:
  run str/callnews.p
    (input "ord-doc"
    ,input (buffer ub.ord-doc:handle)
    ) no-error .
  if error-status :error then do:
    message
      vss-workfile vss-revision vss-description skip
      "Невозможно маршрутизировать ord-doc для отправки в новости" skip
      error-status :get-message(1) skip
      return-value skip
      view-as alert-box error .
    return.
  end.
  assign
    v-ind = v-ind + 1
  .

end.

message
  "Отправка закрытых заказов по всем объектам БД завершена" skip
  "Оправлено записей" v-ind  skip
  "Cформируйте и отправте пакеты новосей" skip
  view-as alert-box information .