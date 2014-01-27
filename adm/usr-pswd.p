/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Изменить пароль для текущего пользовател

Автор: Белоусов Илья Александрович
Дата создания: 05/08/07
Author: Ilia Belousov
Creation date: 05/08/07

Автор1: Перваков Михаил Сергеевич
Дата создания: 01/30/07


*/

define input  parameter parParentProc  as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Изменить пароль для текущего пользователя".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ cmp/showinf.i  }
{ gbl/getcntxt.i def }


DO
ON ERROR UNDO, RETURN ERROR RETURN-VALUE
:
  { gbl/getcntxt.i get }

  define variable v-user-adm as logical   no-undo .
  DEFINE VARIABLE v-encode-password AS CHARACTER NO-UNDO .
  DEFINE VARIABLE v-password        AS CHARACTER NO-UNDO .

  define buffer lock_user-login for ub.user-login .

  { gbl/user-adm.i
    v-cntxt-db-num
    v-cntxt-userid
    v-user-adm
  }
  DO
  TRANSACTION
  ON ERROR UNDO, RETURN ERROR RETURN-VALUE
  :
    FIND FIRST lock_user-login
         WHERE lock_user-login.db-num  = v-cntxt-db-num
           AND lock_user-login.user-id = v-cntxt-userid
         EXCLUSIVE-LOCK
         NO-ERROR
         .
    IF NOT AVAILABLE lock_user-login
    THEN DO:
      MESSAGE
        vss-workfile vss-revision vss-description SKIP
        "Ошибка задания входных параметров" SKIP
        "Не найден логин пользователя" SKIP
        "БД" v-cntxt-db-num SKIP
        "Идентификатор" v-cntxt-userid SKIP
        VIEW-AS ALERT-BOX ERROR .
      UNDO, RETURN ERROR RETURN-VALUE .
    END.
  END.

  run adm/chg-pswd.w ( INPUT  parParentProc
                     , INPUT  v-cntxt-db-num
                     , INPUT  v-cntxt-userid
                     , INPUT  ""             /* p-name */
                     , INPUT  v-user-adm
                     , INPUT  lock_user-login.user-password-encoded
                     , OUTPUT v-password
                     ) NO-ERROR.
  IF ERROR-STATUS:ERROR
  then do:
     message
        vss-workfile vss-revision vss-description skip
        "Ошибка при смене пароля. Пароль не сменен" skip
        error-status :get-message(1) skip
        return-value skip
        view-as alert-box error .
     return.
  end.
  IF v-password = ?
  then do:
     return.
  end.

  DO
  TRANSACTION
  ON ERROR UNDO, RETURN ERROR RETURN-VALUE
  :
    FIND CURRENT lock_user-login
         EXCLUSIVE-LOCK
      .
    ASSIGN
      lock_user-login.user-password-encoded = v-password
    .
    RELEASE lock_user-login .
  END.


  MESSAGE
    "Пароль успешно изменен"
    view-as alert-box information
  .


END. /* DO ON ERROR */