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

{ cmp/trg-def.i }

{ adm/auto-def.i}
log-file-name = "any.log".
session:system-alert-boxes = yes.
session:appl-alert-boxes = yes.
session:debug-alert = yes.
&glob xdebug yes

define variable mAsyncHelper as class ibs.th.file.AsyncHelperth. 
mAsyncHelper = new ibs.th.file.AsyncHelperth().
define variable mProcedure as character no-undo.
mProcedure = mAsyncHelper:GetPARAM( "ParamProc_1").
if mProcedure eq ? then do:
   
   run SetErr( "error   Получение данных было преврвано пользователем." ).
   delete object mAsyncHelper.
   output to "endproc.txt". 
   put unformatted "end" skip.
   output close.
   quit.
end.




&if defined (debug) eq 0
&then
output to "error.log".
&endif

run RUN_IO_Params  (mProcedure) no-error.
run SetErr(return-value).
if    mAsyncHelper:CheckStop()
then do:
   run SetErr( "error   Процесс прерван." ).
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
 
 /* Запуск процедуры с произвольным видом параметров */
procedure RUN_IO_Params.
   
   define input        parameter iProcedure as character no-undo.
/* define input        parameter vInHandle  as handle    no-undo. */  
   define variable vNumParams   as integer   no-undo init 1.
   define variable vParam       as character no-undo .
   define variable vType        as character no-undo init "i" .
   define variable vParVal      as character no-undo extent 100.
   define variable vParType     as character no-undo extent 100.
   define variable vResult      as character no-undo.
   define variable vCallObjHand as handle    no-undo.
   define variable vi           as integer   no-undo.
   define variable vIsError     as logical   no-undo.
     
   Block-Par:
   do while true:
      vParam = mAsyncHelper:GetPARAM( "ParamProc_" + string(vNumParams + 1)).
      if vParam eq ?
      then 
         leave Block-Par.
      
      vParVal  [vNumParams] = vParam.
      vParType [vNumParams] = if vType eq "o" then "OUTPUT" else if vType eq "io" then "INPUT-OUTPUT" else "INPUT".
      vNumParams = vNumParams + 1.
   end.
   vNumParams = vNumParams - 1.
   /* Создаем объект */
   create call vCallObjHand.
     
   /* Инициализируем вызов */
   vCallObjHand:call-name = iProcedure.

   /* if PP eq "" then 
      vCallObjHand:in-handle = vInHandle.*/

   /* Устанавливаем количество параметров */
   vCallObjHand:num-parameters = vNumParams.
/*   message           */
/*   view-as alert-box.*/
   /* Параметры вызова - по списку */
   do vi = 1 to vNumParams:
      vCallObjHand:set-parameter (vi,
                                  "CHAR",
                                  vParType [vi],
                                  vParVal  [vi]).
   end.
   

   /* Вызов */
   vCallObjHand:invoke() no-error.
   if error-status:error then
      assign
         vresult  = if error-status:num-messages gt 0
                    then error-status:get-message (1)
                    else return-value
         vIsError = yes
      .
   else do:
      /* если имеются возвращаемые параметры соберем их */
      do vi = 1 to vNumParams:
         vresult = vresult + "," + vParType [vi] + " " + vParVal  [vi].
        
      end.
      vresult = "return-value " + return-value + vresult.
   end.

   delete object vCallObjHand no-error.
   if vIsError 
   then return error vresult.
   else return       vresult.
end procedure.
 
     
 procedure SetErr:
    define input  parameter Itext as character no-undo.
&if defined (debug) ne 0
&then
    output to "error.log" append.
&endif
    if Itext begins "error"
    then
       mError = yes.
    put unformatted Itext skip .
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