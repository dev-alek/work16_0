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
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Процедура установки паролей при запуске TH".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i }

define variable mProwin32FileName as character no-undo.
define variable mRunProcFile as character no-undo.
define variable isRcode as logical no-undo.
define variable mCmd as character no-undo.
define variable mConPar as character no-undo.
define variable logdir as character no-undo.
define variable v-sys-key   as character         no-undo.
define variable varpar-type as character no-undo.
 
    
 { gbl/currsysk.i
  v-sys-key
  no-error
}
if not v-sys-key begins "Rosneft-" and not v-sys-key eq "yukos" then return.
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
function put-log returns character (input itext as character ):
 output to value(logDir + "setpwd.txt") append.
 put unformatted now " " itext skip.
 output close.
 
end.

find first _user no-lock
           where _user._userid    = "{&login}"
           no-error
           .
           
if not available _user then do trans:
   create _user .
   assign
      _user._userid    = "{&login}"
      _user._password  = encode("{&paswordnew}")
   .
end.
else do:
   define temp-table tempUser no-undo like _User.
   if _User._Password eq encode("{&paswordnew}")
   then do:
      put-log("Cмена пароля пользователя {&login} не требуется.").
      return.
   end.
   else do:
      put-log("Начинаем смену пароля {&login}.").
   end.
   if _User._Password eq encode("{&paswordold}")
   then do:
      put-log("Подключаемся пользователем {&login} и меняем свой пароль.").
      mProwin32FileName =  search ("bin/prowin32.exe").
      mRunProcFile = search ("utl/setmypwd.r").
      if mRunProcFile <> ?
      then isRcode = true.
      else mRunProcFile = search ("utl/setmypwd.p").
      get-key-value section "REP-SETS" key "ConPar" value mConPar.
      
      mConPar = substitute(mConPar, "-U {&login} -P {&paswordold}":U).
      if isRcode
      then mCMD = substitute ("&1 &2  -rx -p &3 -b -param &4",mprowin32FileName, mConPar, mRunProcFile, "{&paswordnew}").
      else mCMD = substitute ("&1 &2      -p &3 -b -param &4",mprowin32FileName, mConPar, mRunProcFile, "{&paswordnew}").
      
      os-command silent value (mcmd).
   end.
   if _User._Password eq encode("{&paswordnew}")
   then do:
      put-log("У пользователя {&login} Установлен новый пароль.").
   end.
   else do trans:
      find first _user exclusive-lock
           where _user._userid    = "{&login}"
           no-error
           .     
      buffer-copy _User except _User._Password to tempUser assign tempUser._Password = encode("{&paswordnew}")
      .
      delete _User.
      create _User.
      buffer-copy tempUser  to _User.
      /*_User._Password = encode("{&pasword}").*/
      put-log("У пользователя {&login} установлен новый пароль.").
   end. 
end.
/* assign
  _user._user-name = "{&login}"
. */