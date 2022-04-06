/*
$Revision:$
$Author:$
$Date:$
$Workfile:$
$Archive:$

Автор: Рубан Дмитрий Андреевич 
Дата создания: 9 марта 2020 г.
Author:  Ruban Dmitriy Andreevich
Creation date: 9 марта 2020 г.

*/
define variable vss-revision    as character no-undo init "$Revision:$":U .
define variable vss-author      as character no-undo init "$Author:$":U .
define variable vss-date        as character no-undo init "$Date:$":U .
define variable vss-workfile    as character no-undo init "$Workfile:$":U .
define variable vss-archive     as character no-undo init "$Archive:$":U .
define variable vss-description as character no-undo init "".
define variable mError as logical no-undo.
{ cmp/vssrevis.i }

{cmp/str-glbl.i}
{utl/search.i}
define stream Ostream.
/*log-file-name = "any.log".*/
session:system-alert-boxes = no.
session:appl-alert-boxes = no.
session:debug-alert = no.
function StopChek  returns logical forward.
&glob xdebug yes
define variable mAsyncHelper as class ibs.th.file.AsyncHelperth. 
mAsyncHelper = new ibs.th.file.AsyncHelperth().
&if defined (debug) eq 0
&then
    output to "error.log".
&endif
run SetStat (substitute("Запущен процесс обновления болванки")).
define variable mCommand as character no-undo.
define variable m7z as character no-undo.
define variable mUbexe as character no-undo.
define variable mDirUb as character no-undo.
define variable mDbConnet as character no-undo.
define variable mVer      as character no-undo.

run gbl/getvers.p (OUTPUT mVer).
mVer = replace(mVer,".","_").
m7z    = search("exe\7z.exe").
mUbexe = search("exe\ub" + mVer + ".exe").
os-create-dir value("ub" + mVer) .
if os-error <> 0 then do:
   run SetStat (substitute("Невозможно создать директорию ub&1",mVer)).
   
end.
else do:
   mDirUb = objExists ("ub" + mVer,"d").
   mCommand = substitute('&1 x &2 -o"&3" &4 rem del &2',m7z ,mubexe, mdirub, {&ampersand}).
   if session:system-alert-boxes
   then do:
      output stream Ostream to "1extr.bat".
      put stream Ostream unformatted replace (mCommand,{&ampersand},{&carriage-return} + {&new-line}).
      output stream Ostream close.
   end. 
   run SetStat (substitute("Распаковываем болванку ")).
   os-command silent value (mCommand).
   mDbConnet = substitute("-db &1\ub.db -ld ub -1 -U sysadm -P sysadm ", mdirub).
   run SetStat (substitute("Распаковка болванки завершена.")).
   if not StopChek ()
   then do:
   do:
      connect value(mDbConnet) no-error.
      if error-status:error
      then do:
        def var vtext as char no-undo.
        vtext =  substitute( "Не удалось подключиться к основной БД с параметрами: &1  Ошибка &2"
                             ,mDbConnet
                             ,error-status :get-message(1)
                              ).
         run SetStat ("Error " + vtext).
      end.
      else if StopChek ()
      then do:
         disconnect ub no-error .
      end.
      else do:
         subscribe "PutStat" anywhere run-procedure "SetErr".
         run utl\ubexeupddb.p (this-procedure,mDbConnet) no-error.
         unsubscribe "PutStat".
         if error-status:error
         then do:
            vtext =  substitute( "Ошибка при обновлении болванки &1"
                             ,error-status :get-message(1)
                              ).
            run SetStat ("Error " + vtext).
         end.
         disconnect ub no-error .
         if     not mError
            and not StopChek () 
         then do:
            mCommand = substitute('del /Q &2 &4 del /Q &3\ub.lg &4 &1 u -mx9 -r0 -sfx &2 &3\* &4 del /Q &3 &4 exit',m7z ,mubexe, mdirub, {&ampersand}).
            if session:system-alert-boxes
            then do:
               output stream Ostream to "2pack.bat".
               put stream Ostream unformatted replace (mCommand,{&ampersand},{&carriage-return} + {&new-line}).
               output stream Ostream close.
            end.
            run SetStat (substitute("Запаковываем болванку ")).
            os-command value (mCommand).
            run SetStat (substitute("Запаковка болванки завершена.")).
         end.
      end.
   end.
end.
delete object mAsyncHelper.
&if defined (debug) eq 0
&then
    output close.
&endif
 quit.  
 
  
define variable mfirst as logical no-undo init yes.
 procedure SetStat:
    define input  parameter Itext as character no-undo.
    mAsyncHelper:putStatus(Itext).
    run SetErr(Itext).
end.

 procedure SetErr:
    define input  parameter Itext as character no-undo.
    
      
&if defined (debug) ne 0
&then
    if mfirst
    then do:
      mfirst = no.
      output to "error.log".
      output close.
    end.
    output to "error.log" append.
&endif
    if Itext begins "error"
    then
       mError = yes.
    
    put unformatted now " " Itext skip .
&if defined (debug) ne 0
&then
    output close.
&endif
    
end.
define variable mstop as logical no-undo.
function StopChek returns logical:
    define var oFlag as logical no-undo.
    if mstop
    then 
       oFlag = mstop.
    else do:
       oFlag = mAsyncHelper:CheckStop().
       mstop = oFlag.
    end.
    if mstop
    then
        run SetStat ("Error Операция прервана пользователем").
    return oFlag.
end.