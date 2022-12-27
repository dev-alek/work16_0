define input parameter p-user-id    as character        no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Востановление аккаунт пользователя (user-account)".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }

define buffer buf_user-account for ub.user-account .
do transaction
on error undo, return error return-value
:
  find first buf_user-account exclusive-lock
       where buf_user-account.user-id = p-user-id
  no-error .
  if not available buf_user-account
  then do:
    message
      vss-workfile vss-revision vss-description skip
      "Ошибка задания входных параметров" skip
      "Не найден пользователь" skip
      "Идентификатор" p-user-id skip
      view-as alert-box error .
    undo, return error return-value .
  end.

  if buf_user-account.status_ <> {&bef-user-status-deleted} 
  then do:
    message
      "Невозможно востановить пользователя" skip
      "Идентификатор" buf_user-account.user-id skip
      "Статус" buf_user-account.status_ skip
      view-as alert-box error .
    undo, return error return-value .
  end.
  assign
    buf_user-account.status_ = {&bef-user-status-normal}
  .
end.