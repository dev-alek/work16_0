/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Работа с ФГИС меркурий

Автор: Сливенко Сергей
Дата создания: 05/28/18
Author: Slivenko Sergey
Creation date: 05/28/18

*/

/*define input  parameter p-user-login    as character no-undo .
define input  parameter p-user-password as character no-undo .*/
define input  parameter p-loghand as handle no-undo.
define input  parameter p-list-db       as character no-undo .




def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Работа с ФГИС Диадок".
define variable vlogfile as character no-undo.
define variable vText as character no-undo.
define variable vError as logical no-undo.
define stream sReadfile.
{ cmp/vssrevis.i }

{ adm/auto-def.i }
 
define variable vasynchelper as class ibs.th.file.asynchelperTh no-undo.
define variable mi as integer no-undo.
define variable vlog as character no-undo.

vAsyncHelper = new ibs.th.file.AsyncHelperth().
vAsyncHelper:mProcPublish = this-procedure.
vAsyncHelper:setCurrentUserPasswd().
vAsyncHelper:MyBachMode = yes.
vAsyncHelper:WritelogInter = 5.
/* vAsyncHelper:myTimeOut  = 60 * 60. */
p-list-db = trim(p-list-db,",").
do mi = 1 to num-entries (p-list-db):
/*   vAsyncHelper:AsyncProc("Diadoc" +  string(mi),"utl/proc-diadoc", substitute("&1":U ,entry(mi,p-list-db)),1).*/
     vAsyncHelper:AddTask("Diadoc","utl/proc-diadoc", substitute("&1":U ,entry(mi,p-list-db))).

end.

subscribe "PutFileLogAsunc" anywhere run-procedure "WriteLog".         
run ibs\th\file\waithelper.p (vAsyncHelper,?, 1,substitute("Получение данных из Диадок. По БД &1.", p-list-db)).
unsubscribe "PutFileLogAsunc".

vAsyncHelper:delworkdir().
delete object vAsyncHelper.
return vlog. 
   
procedure WriteLog:
   define input  parameter iFile as character no-undo.
   if vAsyncHelper:FileExists(iFile)
   then do:
  
   
      input stream sReadfile FROM  VALUE(iFile).
      repeat:
         import stream sReadfile unformatted vText.
         if valid-handle (p-logHand)
         then
            run write-to-log-notime in p-logHand (vtext).
      end.
      input stream sReadfile close  .

   end.
   else do:
       assign
           vtext = substitute ("Процедура закачки данных не завершена. &1",ifile).
           vError = yes.
       if valid-handle (p-logHand)
       then
          run write-to-log in p-logHand (vtext).
   end.
end.
/* $Workfile$ end */