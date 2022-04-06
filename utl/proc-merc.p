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
{ gbl/getcntxt.i def }
{ cmp/trg-def.i  new}

session:system-alert-boxes = yes.
session:appl-alert-boxes = yes.
session:debug-alert = yes.


define variable mAsyncHelper as class ibs.th.file.AsyncHelperth. 
mAsyncHelper = new ibs.th.file.AsyncHelperth().
define variable mParam as character no-undo.
mParam = mAsyncHelper:GetPARAM( "ParamProc_1").
if mParam eq ? then do:
   run SetStat( "error   Получение данных было преврвано пользователем." ).
   
   delete object mAsyncHelper.
   output to "endproc.txt". 
   put unformatted "end" skip.
   output close.
   quit.
end.
if mParam eq "*"
then do:
   for each db no-lock:
      mParam = (if mParam eq "*" then "" else ( mParam + ",")) + string(db.db-num). 
   end.
end.
&if defined (debug) eq 0
&then
output to "error.log".
&endif
   run bge\auto-merc.p(this-procedure, mParam) no-error.
   if error-status:error
   then
      run SetStat( "error  Произошли ошибки при выполнение."  ).
if    mAsyncHelper:CheckStop()
then do:
   run SetStat( "error   Получение данных было преврвано пользователем." ).
end.
&if defined (debug) eq 0
&then
output close.
&endif
 output to "endproc.txt". 
 put unformatted "end" skip.
 output close.
 delete object mAsyncHelper.
 quit.      
 procedure SetStat:
    define input  parameter Itext as character no-undo.
&if defined (debug) ne 0
&then
    output to "error.log" append.
&endif
    if Itext begins "error"
    then
       mError = yes.
    put unformatted Itext skip .
    mAsyncHelper:putStatus(Itext).
&if defined (debug) ne 0
&then
    output close.
&endif
    
end.

define variable mstop as logical no-undo.
procedure StopChek:
    define output  parameter oFlag as logical no-undo.
    if mstop
    then 
       oFlag = mstop.
    else do:
       oFlag = mAsyncHelper:CheckStop().
       mstop = oFlag.
    end.
end.