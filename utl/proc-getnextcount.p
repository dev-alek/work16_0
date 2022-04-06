
.session:debug-alert = yes.
{ utl/setpwd.i }
{cmp/trg-def.i }

output to "error.log".
   put unformatted "error   Не удалось получить счетсчи".
output close.
define variable mAsyncHelper as class ibs.th.file.AsyncHelperth. 
mAsyncHelper = new ibs.th.file.AsyncHelperth().
mAsyncHelper:creatProcInfo(1,1,1).
if    not mAsyncHelper:FileExists("stop.txt")
   or not mAsyncHelper:FileExists("param.txt")
then do:
   output to "error.log".
   put unformatted "error   Получение счетчика было преврвано пользователем или по TimeOut.".
   output close.
   output to "endproc.txt". 
   put unformatted "end" skip.
   output close.
   quit.      
   
end.

define variable  mfilename as character no-undo.
mfilename = mAsyncHelper:GetPARAM("param.txt", "ParamProc_1").
define variable mKey as character   no-undo.
mkey = mAsyncHelper:GetPARAM("param.txt", "ParamProc_2").
define variable  mCode as character no-undo.
mCode  = mAsyncHelper:GetPARAM("param.txt", "ParamProc_3").
delete object mAsyncHelper.
if     mfilename ne ? 
   and mkey      ne ? 
   and mCode     ne ?
then do:
   
 
   /*v-connpar = "-db ub -ld ub  -H localhost -S 44441 ".*/
   define variable mCounterValue as int64 no-undo.
   define variable mCounterStor as class ibs.th.ref.counter.counterstorage.
   mCounterStor = new ibs.th.ref.counter.counterstorage(). 
   mCounterValue = mCounterStor:GetNextcount(mFileName, mKey, mcode).
   delete object mCounterStor.

   output to "error.log". 
   put unformatted string(mCounterValue) skip.
   output close.
end.    



finally:
    output to "endproc.txt". 
    put unformatted "end" skip.
    output close.
    quit.      
end finally.    
