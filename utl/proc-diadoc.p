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
{ cmp/trg-def.i }

session:system-alert-boxes = yes.
session:appl-alert-boxes = yes.
session:debug-alert = yes.

&glob xdebug yes
define variable mAsyncHelper as class ibs.th.file.AsyncHelperth. 
mAsyncHelper = new ibs.th.file.AsyncHelperth().
{str/edo.i}
mPublishHand = this-procedure .
define variable mParam as character no-undo.
mParam = mAsyncHelper:GetPARAM( "ParamProc_1").
if mParam eq ? then do:
   run SetErr( "error   Получение данных было преврвано пользователем." ).
   
   delete object mAsyncHelper.
   output to "endproc.txt". 
   put unformatted "end" skip.
   output close.
   quit.
end.
mdb-num-local  = int(mParam).
define variable MdebugStr as character no-undo. 
MdebugStr = mAsyncHelper:GetPARAM( "ParamProc_2").
if MdebugStr ne ? 
then
   mdebug = logical(MdebugStr) no-error.
if mdebug eq ?
then
   mdebug = no.

&if defined (debug) eq 0
&then
output to "error.log".
&endif
if mDiadocApi eq ?
then
   run SetErr(substitute("Error Не удалось создать объект Diadoc.DiadocClient. Проверьте установку библиоткеки Diadoc.") ).
 
else do:
   
   define variable mFirst as logical no-undo init no.
   run SetErr(substitute("Загрузка данных по БД &1",mdb-num-local) ).
   g#esys = yes.
   Block-extsys:   
   for each ext-system  where ext-system.db-num  eq mdb-num-local
                          and ext-system.esys-type eq {&bef-openxml-type-is_diadoc}
   no-lock,
      first ext-system-attr where ext-system-attr.db-num  eq ext-system.db-num
                                       and ext-system-attr.esys-id eq ext-system.esys-id
                                       and ext-system-attr.esya-attr-code eq {&attr-esys-host-code}
   no-lock:
      mFirst = yes.
      run SetErr(substitute("Загрузка данных по ВС &1",ext-system.esys-id) ).
      v-cntxt-host-code-obj = int(ext-system-attr.esya-attr-value).
      g#esys-source-esys = ext-system.esys-id.
      mext-sys = ext-system.esys-id.
      if    mAsyncHelper:CheckStop()
      then 
         leave Block-extsys.
      subscribe "PutErr" anywhere run-procedure "SetErr".
      subscribe "StopProc" anywhere run-procedure "StopChek".
      
      mDiadocConnection = conectbylogin().
      if mDiadocConnection eq ?
      then do:
         run SetErr ( substitute("error Не удалось подключиться к серверу Диадок в БД &1 ВС &2" ,
                                  mAsyncHelper:GetPARAM("param.txt", "ParamProc_1"), mext-sys)) .
         
      end.
      else do:
         run getNewUpd.
      end.
         unsubscribe "StopProc".
         unsubscribe "PutErr".
      
      if    mAsyncHelper:CheckStop()
      then 
         leave Block-extsys.
      run SetErr(substitute("Загрузка данных по ВС &1 завершена.",ext-system.esys-id) ).
   end.
   if    mAsyncHelper:CheckStop()
   then .
   else if not mFirst
   then
      run SetErr( substitute("Нет ВС Диадок для БД &1" , mAsyncHelper:GetPARAM("param.txt", "ParamProc_1"))).
   else if not mError
   then do: 
      run SetErr( substitute("Данные загруженны в БД &1" , mAsyncHelper:GetPARAM("param.txt", "ParamProc_1"))).
   end.
   else
      run SetErr( substitute("Данные загруженны в БД &1 загружены с ошибками." , mAsyncHelper:GetPARAM("param.txt", "ParamProc_1"))).
end.
if    mAsyncHelper:CheckStop()
then do:
   run SetErr( "error   Получение данных было преврвано пользователем." ).
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