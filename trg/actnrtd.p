/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Триггер на удаление содержания роли

Автор: Белоусов Илья Александрович
Дата создания: 07/16/07
Author: Ilia Belousov
Creation date: 07/16/07

Автор1: Перваков Михаил Сергеевич
Дата создания: 04/05/06

*/

TRIGGER PROCEDURE FOR DELETE OF ub.action-role-item .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Триггер на удаление action-role-item".
{ cmp/vssrevis.i }
{ cmp/trg-def.i  }
{ gbl/cur-time.i }

define buffer buf_action-role-item-gds       for ub.action-role-item-gds .
define buffer buf_action-role-item-gds-grp   for ub.action-role-item-gds-grp .

main-block:
do transaction
on error   undo main-block, return error substitute('actnrtd error main-block,&1', return-value )
on end-key undo main-block, return error substitute('actnrtd end-key main-block,&1', return-value )
:

  FOR EACH  buf_action-role-item-gds-grp
      where buf_action-role-item-gds-grp.db-num                = ub.action-role-item.db-num
      and   buf_action-role-item-gds-grp.action-head-code      = ub.action-role-item.action-head-code
      and   buf_action-role-item-gds-grp.action-role-code      = ub.action-role-item.action-role-code
      and   buf_action-role-item-gds-grp.action-role-item-code = ub.action-role-item.action-role-item-code
      exclusive-lock
      :
      DELETE buf_action-role-item-gds-grp.
  end.

  FOR EACH  buf_action-role-item-gds
      where buf_action-role-item-gds.db-num                = ub.action-role-item.db-num
      and   buf_action-role-item-gds.action-head-code      = ub.action-role-item.action-head-code
      and   buf_action-role-item-gds.action-role-code      = ub.action-role-item.action-role-code
      and   buf_action-role-item-gds.action-role-item-code = ub.action-role-item.action-role-item-code
      exclusive-lock
      :
      DELETE buf_action-role-item-gds.
  end.
if not g#news then do:
  run nws/cmd-del.p
    ( input {&table_action-role-item}
      ,input (buffer ub.action-role-item:handle)
      ,input "":U
    ) no-error .
  if error-status :error then do:
    undo, return error substitute( "&1. Ошибка при отправке в новости команды на удаление записи. &2&3&2&4", vss-workfile, {&new-line}, return-value, error-status :get-message ( error-status :num-messages ) ).
  end.
end.  
    if g#oxml = yes
    then do:
    run str/calloxml.p (
          input {&nwsdochs_action_delete}
        , input {&table_action-role-item}
        , input ( buffer ub.action-role-item:handle )
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