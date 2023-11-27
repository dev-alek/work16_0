/*
$Revision:$
$Author:$
$Date:$
$Workfile:$
$Archive:$

Архивирование лога проверки марок в ГИС МТ за вчерашний день

Автор: Белова Марина Михайловна
Дата создания: 3 ноября 2023 г.
Author:  Belova Marina Michaelovna
Creation date: 3 ноября 2023 г.

*/
define variable vss-revision    as character no-undo init "$Revision:$":U .
define variable vss-author      as character no-undo init "$Author:$":U .
define variable vss-date        as character no-undo init "$Date:$":U .
define variable vss-workfile    as character no-undo init "$Workfile:$":U .
define variable vss-archive     as character no-undo init "$Archive:$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }

{ nws/nws-def.i  }  
{ utl/search.i   }

define variable vFileName    as character no-undo. /* название лога */
define variable vFileReq     as character no-undo. /* имя файла с логом */
define variable vFileArh     as character no-undo. /* имя файла архива */
define variable vFileReqPath as character no-undo. /* Полный путь к файлу логу */
define variable vFileArhPath as character no-undo. /* Полный путь к архив-файлу */
define variable vMyWorkDir   as character no-undo. /* Путь к каталогу */
define variable vFolder      as character no-undo. /* Каталог с архивом */
define variable vDirDelim    as character no-undo init "\":u.

define variable vDate as date no-undo.

assign
   vDate      = today - 1
   vFileName = "GisMtReq-" + replace(string(vDate),"/","-")
   vFileReq   = vfilename + ".log"
   vFileArh   = vfilename + ".zip"
   vFolder    = "GisMtReqArh"
   .

vFileReqPath = searchFile(vFileReq).

if vFileReqPath <> ? then do:
    vMyWorkDir = vFileReqPath.
    entry(num-entries(vMyWorkDir,vDirDelim),vMyWorkDir,vDirDelim) = "".
    if objExists(vMyWorkDir + vFolder,"D") eq ?  
       then os-create-dir VALUE(vMyWorkDir + vFolder ).
    vFileArhPath = vMyWorkDir + vFolder + vDirDelim + vFileArh.
    run write-to-log( substitute("Архивирование лога проверки марок &1.log", entry(1,vFileReqPath,"."))) .
    run utl\arh7z.p(vFileArhPath,vFileReqPath).
    vFileArhPath = searchFile(vFileArhPath).
    if vFileArhPath <> ? 
    then do:
       run write-to-log( substitute("Создан архив &1.zip", entry(1,vFileArhPath,"."))) .
       os-delete value (vFileReqPath) no-error .
       if searchFile(vFileReq) = ? 
       then  run write-to-log( "Лог проверки марок успешно удален" ) .
       else  run write-to-log( "Не удалось удалить лог проверки марок" ) .
    end.
    else run write-to-log( "Произошла ошибка при архивировании лога").
end.    
