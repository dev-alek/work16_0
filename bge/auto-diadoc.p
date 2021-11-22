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
vAsyncHelper:user-passwd = "current".
vAsyncHelper:MyBachMode = yes.
vAsyncHelper:paramSession = " -clientlog  mylog.lg -logginglevel 4 -logentrytypes 4GLTrace ".
vAsyncHelper:SaveFile = yes .
/* vAsyncHelper:myTimeOut  = 60 * 60. */
do mi = 1 to num-entries (p-list-db):
   vAsyncHelper:AsyncProc("utl/proc-diadoc", substitute("&2&1&3":U ,{&delim-par},entry(mi,p-list-db),yes),1).
   /*vAsyncHelper:myTimeOut = 00.*/
           
   run ibs\th\file\waithelper.p (vAsyncHelper,"proc-diadoc", 1,substitute("Получение данных из Диадок. По БД &1.",entry(mi,p-list-db))).
   .
   run write-to-log in p-logHand (substitute("Результат сохранет в &1.",vAsyncHelper:SaveArh("-db-" + entry(mi,p-list-db)))).
   vlogfile = vAsyncHelper:geterrlog("proc-diadoc").
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
        /* else do: 
            vCheksum = vText.
            if (vCheksum ne {utl/chekproc.i vKey})
            then assign
                    vtext = "Процедура имеет не правильную подпись."
   /*               vError = yes*/
                 .
            else
               vError = no.
         end.*/    
      end.
      input stream sReadfile close  .
      /*os-delete value(vAsyncHelper:getProcDir("proc-diadoc")) RECURSIVE.*/
   end.
   else do:
       assign
           vtext = "Процедура закачки данных не завершена"
           vError = yes.
       if valid-handle (p-logHand)
       then
          run write-to-log in p-logHand (vtext).
   end.
   vlog = vlog + (if vlog eq "" then "" else ", ") + vtext no-error.  
end.

if valid-handle (p-logHand)
       then

vAsyncHelper:delworkdir().
delete object vAsyncHelper.
return vlog. 
   
   
/* $Workfile$ end */