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
define input  parameter p-log-handle  as handle no-undo.
define input  parameter p-list-db       as character no-undo .
define input  parameter iasyncProc as integer no-undo.
define input  parameter iparamSession as character no-undo.
define input  parameter iWaitFile as character no-undo.
define input  parameter iSave as logical no-undo.

define variable log-file-name                as character      no-undo init "".

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

define variable vasynchelper as class ibs.th.file.asynchelperTh no-undo.
define variable mi as integer no-undo.
define variable vlog as character no-undo.
if p-list-db eq "*"
then do:
   run bge\auto-nws-db.p(output p-list-db).
end.
 vAsyncHelper = new ibs.th.file.AsyncHelperth().
vAsyncHelper:mProcPublish = this-procedure.
vAsyncHelper:setCurrentUserPasswd().
vAsyncHelper:MyBachMode = yes.
vAsyncHelper:WritelogInter = 5.
vAsyncHelper:MyBachMode = yes.
vAsyncHelper:maxproc = iasyncProc.
if     iparamSession ne ?
   and iparamSession ne ""
then
   vAsyncHelper:paramSession = iparamSession.

if     iWaitFile ne ?
   and iWaitFile ne ""
then
   vAsyncHelper:WaitFile = iWaitFile.
vAsyncHelper:SaveFile =iSave.
/* vAsyncHelper:myTimeOut  = 60 * 60. */
define variable mFirst as logical no-undo init yes.
define variable mDB as character no-undo.
do mi = 1 to num-entries (p-list-db):
   mDB = entry(mi,p-list-db).
   if     mdb ne ""
      and mdb ne ?
   then do:
      if mfirst
      then do:
         vAsyncHelper:AsyncProc("NWS","utl/proc-nws", mdb,1).
         mfirst = no.
      end.
      else do:
         vAsyncHelper:AddTask("NWS", "utl/proc-nws", mdb).
      end.
   end.
end.

subscribe "PutFileLogAsunc" anywhere run-procedure "WriteLog".         
run ibs\th\file\waithelper.p (vAsyncHelper,?, 1,substitute("Обработка новостей. По БД &1.", p-list-db)).
unsubscribe "PutFileLogAsunc".
if iSave
then
   message "Результаты выполнения находятся в " vAsyncHelper:SaveArh()
   view-as alert-box.
vAsyncHelper:delworkdir().

delete object vAsyncHelper.
return vlog. 
   
procedure WriteLog:
   define input  parameter iText as character no-undo.
   if vAsyncHelper:FileExists(iText)
   then do:
  
   
      input stream sReadfile FROM  VALUE(iText).
      repeat:
         import stream sReadfile unformatted vText.
         if valid-handle (p-log-handle)
         then
/*         run write-to-log (vtext).*/

            run write-to-log-notime in p-log-handle (vtext).
      end.
      input stream sReadfile close  .

   end.
   else do:
       assign
           vtext = substitute ("Процедура Обмена новостями не завершина. &1",iText).
           vError = yes.
       if valid-handle (p-log-handle)
       then
          run write-to-log in p-log-handle (vtext).
   end.
end.
/* $Workfile$ end */