
.session:debug-alert = yes.

{cmp/trg-def.i new }
run gbl/set-gbl.p (yes,"sysadm","sysadm").
output to "error.log".
   put unformatted "error   Не удалось получить счетсчи".
output close.
define variable mFileHelper as class ibs.th.file.filehelperth. 
mFileHelper = new ibs.th.file.filehelperth().
mFileHelper:creatProcInfo(1,1,1).
    
define variable  mfilename as character no-undo.
mfilename = mFileHelper:GetPARAM("param.txt", "ParamProc_1").
define variable mKey as character   no-undo.
mkey = mFileHelper:GetPARAM("param.txt", "ParamProc_2").
define variable  mCode as character no-undo.
mCode  = mFileHelper:GetPARAM("param.txt", "ParamProc_3").
delete object mFileHelper.
/*v-connpar = "-db ub -ld ub  -H localhost -S 44441 ".*/
define variable mCounterValue as int64 no-undo.
define variable mCounterStor as class ibs.th.ref.counter.counterstorage.
mCounterStor = new ibs.th.ref.counter.counterstorage(). 
mCounterValue = mCounterStor:GetNextcount(mFileName, mKey, mcode).
delete object mCounterStor.

    output to "error.log". 
    put unformatted string(mCounterValue) skip.
    output close.
    
    output to "endproc.txt". 
    put unformatted "end" skip.
    output close.


quit.