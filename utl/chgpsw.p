{ utl/setpwd.i}
  
/*
$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Процедура установки паролей при запуске TH

Автор: Уханов Дмитрий Юрьевич
Дата создания: 03/22/00
Author: Dmitry Ukhanov
Creation date: 03/22/00

*/  
/*define input  parameter parparentproc as handle no-undo.
define input  parameter IMode as integer no-undo. /* 1 - смена пароля sys-adm и создание нового пользователя если задан &mylogin
                                                     * - смена пароля если старый пароль равен &defaultPas */*/
define variable vss-revision    as character no-undo init "$Revision$":U . 
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Процедура установки паролей при запуске TH".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i }
{ cmp/trg-def.i }
define variable mProwin32FileName as character no-undo.
define variable mRunProcFile as character no-undo.
define variable isRcode as logical no-undo.
define variable mCmd as character no-undo.
define variable mConPar as character no-undo.
define variable logdir as character no-undo.
define variable v-sys-key   as character         no-undo.
define variable varpar-type as character no-undo.
function put-log returns character (input itext as character ) forward. 
define temp-table tempUserCopy no-undo like _User.
 
procedure SetPwdsysadm :
   
      get-key-value section "rep-sets" key "logDir"    value logDir .
      if logDir = ?
      then do :
         logDir = ".\" .
      end .
      else do :
         logDir = right-trim(logDir, "\") .
         logDir = right-trim(logDir, "/") .
         logDir = logDir + "\" .
      end.
         
         
      find first _user no-lock
                    where _user._userid    = {&login}
                    no-error
                    .
                    
      if not available _user 
      then do trans:
         create _user .
         assign
            _user._userid    = {&login}
            _user._password  = encode({&paswordnew})
         .
      end.
      else do:
         
         if _User._Password eq encode({&paswordnew})
         then do:
            put-log("Cмена пароля пользователя " + {&login} + " не требуется.").
            
            return.
         end.
         else do:
            put-log("Начинаем смену пароля " + {&login} + ".").
         end.
         if _User._Password eq encode({&paswordCur})
         then do:
            put-log("Подключаемся пользователем " + {&login} + " и меняем свой пароль.").
            mProwin32FileName =  search ("bin/prowin32.exe").
            mRunProcFile = search ("utl/setmypwd.r").
            if mRunProcFile <> ?
            then 
               isRcode = true.
            else 
               mRunProcFile = search ("utl/setmypwd.p").
            get-key-value section "REP-SETS" key "ConPar" value mConPar.
              
            release _User.
            mConPar = substitute(mConPar, "-U ":U + {&login} + " -P " + {&paswordCur}).
            if isRcode
            then mCMD = substitute ("&1 &2  -rx -p &3 -b -param &4",mprowin32FileName, mConPar, mRunProcFile, {&paswordnew}).
            else mCMD = substitute ("&1 &2      -p &3 -b -param &4",mprowin32FileName, mConPar, mRunProcFile, {&paswordnew}).
               
            os-command silent value (mcmd).
         end.
         find first _user no-lock
                    where _user._userid    = {&login}
                    no-error
                    .
         if _User._Password eq encode({&paswordnew})
         then do:
            run trg/userlog.p (
                  input 'sysadm-pwd'
                , input ("Изменен пароль пользователя " + {&login} + {&delim-key} + _user._userid )
                , input ?
                , input ?
                , input "") no-error.
            put-log("У пользователя {&login} Установлен новый пароль.").
         end.
         else do trans:
            find first _user exclusive-lock
                 where _user._userid    = {&login}
            no-error.     
            buffer-copy _User except _User._TenantId _User._Password to tempUserCopy 
            assign tempUserCopy._Password = encode({&paswordnew}).
            delete _User.
            create _User.
            buffer-copy tempUserCopy except tempUserCopy._TenantId to _User.
            run trg/userlog.p (
                  input 'sysadm-pwd'
                , input ("Изменен пароль пользователя " + {&login} + {&delim-key} + _user._userid )
                , input ?
                , input ?
                , input "") no-error.
            put-log("У пользователя " + {&login} + " установлен новый пароль.").
         end. 
      end.
   
end.
 { gbl/currsysk.i
      v-sys-key 
      no-error
   }
   if v-sys-key begins "Rosneft-" or v-sys-key eq "yukos"
   then do:
   run SetPwdsysadm .
   {&login} = "odbc".
   run SetPwdsysadm .
   
   
   find first _file where _file._file-name eq "_user"
   no-lock.
   if    can-do(_file._Can-Create,"odbc") 
      or can-do(_file._Can-delete,"odbc") 
   then do trans:
      find first _file where _file._file-name eq "_user"
      exclusive-lock.
      if can-do(_file._Can-Create,"odbc") 
      then
         _file._Can-Create = "!odbc," + _file._Can-Create.
   
      if can-do(_file._Can-delete,"odbc") 
      then
         _file._Can-delete = "!odbc," + _file._Can-delete.

   end.
   do trans:
      find first _user exclusive-lock
                       where _user._userid    = "usr-flt"
                  no-error.
      if available _user
      then
         delete _user.
   end.
end.
find first sys-ctrl  no-lock.
run  procedure-user-login-change-password in this-procedure (sys-ctrl.db-num,userid ("ub")) no-error.
if error-status:error
then return error return-value.
&if "{&mylogin}" ne ""
&then
do trans:
   /* _________________ инициализация пользователя системы 'адм' ______________________*/
   define variable v-encode-value as character no-undo .
   define variable v-user-id      as character no-undo .
   
   disable triggers for  load   of user-login .
   disable triggers for  load   of user-account .
   find first user-login
        where user-login.db-num     = sys-ctrl.db-num
          and user-login.user-login = "{&mylogin }"
   exclusive-lock no-wait no-error.
   if not available user-login and not locked user-login 
   then do:
      
      
             /* пробуем найти по аккаунту */
      define variable v-count    as integer      no-undo.
   
      for each  user-account
          where user-account.user-id begins ( substitute ( '&1-':U
                                                         ,  sys-ctrl.db-num
                                                         )
                                            )
      no-lock:
         if v-count < INTEGER(entry(2, user-account.user-id, "-")) 
         then 
            v-count = integer(entry(2, user-account.user-id, "-")).
         
      end.
      if v-count <= current-value(s-user-id, ub) 
      then do:
         v-count = next-value(s-user-id, ub).
      end.
      else do:
         current-value(s-user-id, ub) = v-count.
      end.
      v-user-id = substitute ( '&1-&2':U
                              , sys-ctrl.db-num
                              , v-count
                              ) .
      create user-account .
      assign
         user-account.user-id      = v-user-id
         user-account.last-name    = "System Administrator":U
         user-account.nik          = "System Administrator":U
         user-account.check-parent = false
      .
      create user-login.
      assign
         user-login.db-num                = sys-ctrl.db-num
         user-login.user-id               = v-user-id
      .
      /* даже если уже существует, принудительно прописываем */
      run adm/pswd-enc.p ( input  encode( "{&mylogin}" )
                         , output v-encode-value
                         ) .
      v-encode-value = encode( v-encode-value ).
     
      assign
         user-login.user-login              = "{&mylogin}"
         user-login.user-password-encoded   = v-encode-value
         user-login.user-administrator      = true
         user-login.status_                 = {&bef-user-status-normal}
         user-account.status_               = {&bef-user-status-normal}
      .
      { trg/user.i ub }
   end. /* NOT AVAILABLE user-login */
end.
&endif

procedure procedure-user-login-change-password :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
   define input parameter p-db-num         as integer          no-undo.
   define input parameter p-user-id        as character        no-undo.
   
   define variable v-can-edit         as logical   no-undo .
   define variable v-encoded-pass     as character no-undo .
   define variable v-encoded-pass-old as character no-undo .
   define variable v-nextcon          as logical   no-undo .
   
   define buffer buf_lock_user-login for user-login.
   define buffer buf_init_user-account for user-account.
   
   /* define variable vHidn as logical no-undo.
   vHidn = current-window:hidden.
      current-window:hidden = yes. */
   find first _user no-lock
        where _user._userid    = p-user-id
        no-error
        .
   if available  _User
   then do:
      find first buf_lock_user-login where buf_lock_user-login.user-login eq p-user-id
                                       and buf_lock_user-login.db-num     eq p-db-num
      no-lock.
      
      find first user-login-attr where user-login-attr.user-id      eq buf_lock_user-login.user-id
                                       and user-login-attr.db-num   eq buf_lock_user-login.db-num
                                       and user-login-attr.attr-code = "ChangPwdNextConect"
      no-lock no-error.
      define variable vfl as logical no-undo.
      vfl = logical(user-login-attr.attr-value) no-error. 
      if vfl eq yes
      then do: 
          find first buf_init_user-account where buf_init_user-account.user-id = buf_lock_user-login.user-id
          no-lock.
          assign
          v-encoded-pass-old = buf_lock_user-login.user-password-encoded
          v-encoded-pass     = buf_lock_user-login.user-password-encoded.
          
          
             
          do while v-encoded-pass = v-encoded-pass-old or v-encoded-pass eq ?:
             v-encoded-pass = v-encoded-pass-old. 
          
             
             run adm/chg-pswd.w ( input  this-procedure
                                , input  p-db-num
                                , input  _user._userid
                                , input  substitute('&1 &2 &3':U, buf_init_user-account.last-name
                                                                , buf_init_user-account.first-name
                                                                , buf_init_user-account.second-name
                                       )
                                , input  yes
                                , input  buf_lock_user-login.user-password-encoded
                                , yes 
                                , output v-encoded-pass
                                , output v-nextcon
                                ) no-error .
            if error-status :error
            then do:
              message
                 vss-workfile vss-revision vss-description skip
                 "Ошибка при вызове процедуры" 'adm/chg-pswd.w':U skip
                 error-status :get-message(1) skip
                 return-value skip
                 view-as alert-box error .
                 /*current-window:hidden = vHidn.*/
              undo, return error return-value .
             end.                 
             if    v-encoded-pass = v-encoded-pass-old
                
             then do:
                 message
                    vss-workfile vss-revision vss-description skip
                    "Старый пароль и новый равны. Смените пароль.":U skip
                    error-status :get-message(1) skip
                    return-value skip
                    view-as alert-box error .
                 
             end.
             else if v-encoded-pass eq ?
             then do:
                message  "Отказ от смены пароля. Работа дальше не возможна"
                view-as alert-box error. 
                return error "Отказ от смены пароля. Работа дальше не возможна".
             end.   
          end.  
                         
          
          if v-encoded-pass <> ? then
          do trans:
            /* run gbl/set-gbl.p (no,buf_lock_user-login.user-login,buf_lock_user-login.user-password-encoded).*/
             find current buf_lock_user-login
                   exclusive-lock
                .
             assign
                buf_lock_user-login.user-password-encoded = v-encoded-pass
             .
             
             find first user-login-attr where user-login-attr.user-id   eq buf_lock_user-login.user-id
                                          and user-login-attr.db-num    eq buf_lock_user-login.db-num
                                          and user-login-attr.attr-code eq "ChangPwdNextConect"
             exclusive-lock no-error.
             if available user-login-attr
             then
                delete user-login-attr.
             release buf_lock_user-login .
             message
                "Пароль успешно изменен"
                view-as alert-box information
             .
             
          end.
       end.  
   end.   
   /*current-window:hidden = vHidn.*/

end procedure. /* procedure-user-login-change-password */

function put-log returns character (input itext as character ):
    output to value(logDir + "setpwd.txt") append.
    put unformatted now " " itext skip.
    output close.
    
end.