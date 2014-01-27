/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Проверить, что базу можно выгрузить

Автор: Белоусов Илья Александрович
Дата создания: 07/30/07
Author: Ilia Belousov
Creation date: 07/30/07

Автор1: Перваков Михаил Сергеевич
Дата создания: 10/26/06

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ cmp/showinf.i  }

define input  parameter p-db-num     as integer   no-undo .
define output parameter p-can-unload as logical   no-undo .
define output parameter p-message    as character no-undo .

define buffer buf_clients    for ub.clients .
define buffer buf_user-login for ub.user-login .

do
on error undo, return error return-value
:
  find first buf_clients no-lock
    where buf_clients.db-num = p-db-num
    no-error .
  if not available buf_clients
  then do:
    assign
      p-can-unload = false
      p-message = "В базе данных нет ни одного объекта"
    .
    return . /* --->>>--- */
  end.

  /*
  find first buf_user-login no-lock
    where buf_user-login.db-num = p-db-num
      and buf_user-login.user-administrator = true
    no-error .
  if not available buf_user-login
  then do:
    assign
      p-can-unload = false
      p-message = "В базе данных нет ни одного пользователя с правами администратора"
    .
    return . /* --->>>--- */
  end.
  */

  assign
    p-can-unload = true
    p-message    = '':u
  .
end.