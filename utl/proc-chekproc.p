
.session:debug-alert = yes.

define variable mFileHelper as class ibs.th.file.filehelperth. 
mFileHelper = new ibs.th.file.filehelperth().
mFileHelper:creatProcInfo(1,1,1).
if    not mFileHelper:FileExists("stop.txt")
   or not mFileHelper:FileExists("param.txt")
then do:
   output to "error.log".
   put unformatted "error   Получение проверка была преврвана пользователем или по TimeOut.".
   output close.
   return.
end.
define variable v-num-parameters as integer no-undo.
define variable mProc-name as character no-undo.
define variable mparparentproc as logical   no-undo.
define variable mKey as integer  no-undo.
define variable MChekSum as character no-undo.
define variable m-parameter1 as character no-undo.
define variable m-parameter2 as character no-undo.
define variable m-parameter3 as character no-undo.
mProc-name = mFileHelper:GetPARAM("param.txt", "ParamProc_1").
v-num-parameters = int(mFileHelper:GetPARAM("param.txt", "ParamProc_2")).
mparparentproc = logical (mFileHelper:GetPARAM("param.txt", "ParamProc_3")).
mkey  = int(mFileHelper:GetPARAM("param.txt", "ParamProc_4")).
m-parameter1  = mFileHelper:GetPARAM("param.txt", "ParamProc_5").
m-parameter2  = mFileHelper:GetPARAM("param.txt", "ParamProc_6").
m-parameter3  = mFileHelper:GetPARAM("param.txt", "ParamProc_7").

delete object mFileHelper.
if     v-num-parameters ne ? 
   and mparparentproc   ne ? 
   and mkey     ne ?
then do:
   case v-num-parameters :
      when 0
      then do:
         if mparparentproc
         then do:
            run value (mProc-name)
                   (input  mkey,
                    output MChekSum,
                    input ?
                   ) no-error.
         end.
         else do:
            run value (mProc-name)
                   (input  mkey,
                    output MChekSum
                    )no-error.
         end.
      end.
      when 1
      then do:
         if mparparentproc
         then do:
              run value (mproc-name)
                (input  mkey,
                 output MChekSum,
                 input  ?
                ,input  m-parameter1
                )no-error.
         end.
         else do:
            run value (mproc-name)
                (input  mkey,
                 output MChekSum,
                 input m-parameter1
                )no-error.
         end.
      end.
      when 2
      then do:
         if mparparentproc 
         then do:
            run value (mproc-name)
                (input  mkey
                ,output MChekSum
                ,input ?
                ,input m-parameter1
                ,input m-parameter2
                )no-error.
         end.
         else do:
            run value (mproc-name)
                (input  mkey
                ,output MChekSum
                ,input m-parameter1
                ,input m-parameter2
                )no-error.
         end.
      end.
      when 3
      then do:
         if mparparentproc
         then do:
            run value (mproc-name)
                (input  mkey
                ,output MChekSum
                ,input ?
                ,input m-parameter1
                ,input m-parameter2
                ,input m-parameter3
                )no-error.
         end.
         else do:
            run value (mproc-name)
                (input  mkey
                ,output MChekSum
                ,input m-parameter1
                ,input m-parameter2
                ,input m-parameter3
                )no-error.
         end.
      end.
   end case.
    
   output to "error.log". 
   put unformatted (if error-status:error then "error " + error-status:get-message (1) else MChekSum )skip.
   output close.
end.    



finally:
    output to "endproc.txt". 
    put unformatted "end" skip.
    output close.
    quit.      
end finally.    
