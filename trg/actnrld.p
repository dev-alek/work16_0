/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Триггер на удаление роли

Автор: Белоусов Илья Александрович
Дата создания: 07/16/07
Author: Ilia Belousov
Creation date: 07/16/07

Автор1: Перваков Михаил Сергеевич
Дата создания: 04/05/06

*/

TRIGGER PROCEDURE FOR DELETE OF ub.action-role .


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Триггер на удаление action-role".
{ cmp/vssrevis.i }
{ cmp/trg-def.i  }
{ gbl/cur-time.i }

main-block:
do transaction
on error   undo main-block, return error substitute('actnrld error main-block,&1', return-value )
on end-key undo main-block, return error substitute('actnrld end-key main-block,&1', return-value )
:
  define buffer buf_user-login-action-role    for ub.user-login-action-role .

  FOR EACH  buf_user-login-action-role
      where buf_user-login-action-role.action-head-code = ub.action-role.action-head-code
        AND buf_user-login-action-role.db-num           = ub.action-role.db-num
        AND buf_user-login-action-role.action-role-code = ub.action-role.action-role-code
      exclusive-lock
      :
      DELETE buf_user-login-action-role .
  END.
  run nws/cmd-del.p
    ( input {&table_action-role}
      ,input (buffer ub.action-role:handle)
      ,input "":U
    ) no-error .
  if error-status :error then do:
    undo, return error substitute( "&1. Ошибка при отправке в новости команды на удаление записи. &2&3&2&4", vss-workfile, {&new-line}, return-value, error-status :get-message ( error-status :num-messages ) ).
  end.
    if g#oxml = yes
    then do:
    run str/calloxml.p (
          input {&nwsdochs_action_delete}
        , input {&table_action-role}
        , input ( buffer ub.action-role:handle )
    ) no-error.
    if error-status :error
    then do:
        undo, return error substitute( "&2&1Ошибка при отправке в систему OpenXML команды на удаление записи&1&3&1&4"
                            , {&new-line}
                            , vss-workfile
                            , return-value
                            , error-status :get-message ( 1 ) ).
    end.
    end.
end.