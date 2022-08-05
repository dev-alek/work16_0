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

define input  parameter p-loghand as handle no-undo.
define input  parameter p-list-db       as character no-undo .




def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Работа с ФГИС Меркурий".
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
vAsyncHelper:MyBachMode = no.

   vAsyncHelper:AsyncProc("utl/proc-merc", substitute("&1":U ,p-list-db),1).
   if num-entries (p-list-db) > 30
   then
      run ibs\th\file\waithelper.p (vAsyncHelper,"proc-merc", 1,substitute("Получение данных из Меркурий. По &1 БД .",num-entries (p-list-db))).
   else
      run ibs\th\file\waithelper.p (vAsyncHelper,"proc-merc", 1,substitute("Получение данных из Меркурий. По БД &1.",p-list-db)).
   
   vlogfile = vAsyncHelper:getlog("proc-merc").
   if vAsyncHelper:FileExists(vlogfile)
   then do:
      input stream sReadfile FROM  VALUE(vlogfile).
      repeat:
         import stream sReadfile unformatted vText.
         if vtext begins "error" 
         then assign
                 vtext = substring(vtext,7)
   /*             vError = yes*/
              .
         if valid-handle (p-logHand)
         then
            run write-to-log in p-logHand (vtext).
      end.
      input stream sReadfile close  .
   end.
   else do:
       assign
           vtext = "Процедура обработки данных не завершена"
           vError = yes.
       if valid-handle (p-logHand)
       then
          run write-to-log in p-logHand (vtext).
   end.
   vlog = vlog + (if vlog eq "" then "" else ", ") + vtext no-error.  


vAsyncHelper:delworkdir().
delete object vAsyncHelper.
return vlog. 
   
   
/* $Workfile$ end */