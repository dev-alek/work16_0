&glob defonly yes
{ adm/auto-def.i new}
{ cmp/trg-def.i new }
define variable mAsyncHelper as class ibs.th.file.AsyncHelperth. 
mAsyncHelper = new ibs.th.file.AsyncHelperth().
define variable mnum   as integer no-undo.
define variable mCount as integer no-undo.
define variable mUserDb as logical no-undo.
define variable mName as character no-undo.
define variable mpassword as character no-undo.

mNum   = int(mAsyncHelper:GetPARAM("numSession")).
mCount = int(mAsyncHelper:GetPARAM("countSession")).
mAsyncHelper:creatProcInfo(1,mNum,mCount).
mUserDB = logical(mAsyncHelper:GetPARAM("UserDb")).
if mUserDB
then do:
   if userid( "ub") ne ""
   then do:
      run utl\getuser.p (output mname) no-error.
      mpassword = mAsyncHelper:GetStartupParam("-P").
   end.
end.   
delete object mAsyncHelper.

define variable mProc as character no-undo.
define variable mParam as character no-undo.
define variable mParamName as character no-undo.
define variable mParamValue as character no-undo.
define variable mNumEntries as integer no-undo.
define variable mI      as integer no-undo.
if     session:parameter <> "":U
   and session:parameter <> ?
then do:
   mNumEntries = num-entries( session:parameter, ",":U ).
   do mI = 1 to mNumEntries :
      mparam = entry( mi, session:parameter, ",":U ).
      if num-entries( mparam, ":":U ) > 1 
      then do:
         assign
            mParamName  = entry( 1, mParam, ":":U )
            mParamValue = substring( mParam, length( mParamName ) + 2 )
         .
         case mParamName :
            when "U":U then do:
               mname = mParamValue.
            end.
            when "P":U then do:
               mpassword = mParamValue.
            end.
            when "R":U then do:
               mProc = mParamValue.
            end.
            when "M":U then do:
            end.
            when "A":U then .
            otherwise do:
               run SetErr substitute("Неизвестный параметр сессии: &1. Параметр игнорируется.", Mparam) .
            end.
         end case.
      end.
      else do:
         run SetErr substitute("Неизвестный параметр сессии: &1. Параметр игнорируется.", Mparam) .
      end.
   end.
   
   if    ( mname <> "":U
       and mpassword <> "":U )
      or mUserDB
   then do:
      if not mUserDB
      then
         run adm/autoinit.p ( input mname
                             ,input mpassword
                     ) no-error.
      else
         error-status :error = no.
      if error-status :error then do:
         run SetErr ("Error " + error-status:get-message (1)).
      end.
      else do:
         if not mUserDB
         then
            run adm/autoconn.p no-error.
         if error-status :error 
         then do:
            run SetErr ("Error Не удалось подключиться к БД: " + return-value) .
         end.
         else do:
            if mname ne ""
            then
            run gbl/set-gbl.p
               (input  true
               ,input  mName
               ,input  mpassword
               ).
            if            mProc  ne ""
               and search(mProc) ne ?
            then
               run value(mProc).
         end.
      end.
   end.
   else do:
      run SetErr ("Error Не задан пользователь или пароль.") .
   end.
end.
else
   run SetErr ("Error Не переданы параметры.") .
quit. 


procedure SetErr:
    define input  parameter Itext as character no-undo.
    output to "error.log" append.
/*    if Itext begins "error"
    then
       mError = yes. */
    put unformatted Itext skip .
    output close.
end.
