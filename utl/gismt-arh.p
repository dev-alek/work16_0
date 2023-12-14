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
define variable vPathFolder  as character no-undo.
define variable vDirDelim    as character no-undo init "\":u.

define stream FLStream.
define variable vDelFileName as character no-undo.
define variable vDelFullName as character no-undo.
define variable vDelFileType as character no-undo.
define variable vZipName     as character no-undo.
define variable vZipDate     as date      no-undo.
define variable vNumDate     as integer   no-undo.
define variable vPref        as character no-undo.

define variable vDate as date no-undo.

assign
   vDate     = today - 1
   vPref     = "GisMtReq-"
   vFileName = vPref + replace(string(vDate),"/","-")
   vFileReq  = vfilename + ".log"
   vFileArh  = vfilename + ".zip"
   vFolder   = "GisMtReqArh"
   vNumDate  = 93
   .

/* архивируем лог и удаляем его */
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

/* удаляем старые архивы */
vPathFolder = objExists(vFolder,"D").
if vPathFolder <> ? then do:    
    input stream FLStream from os-dir (vPathFolder).
    repeat
       on error  undo, return  
       on stop   undo, return  
       :
       import stream FLStream vDelFileName vDelFullName vDelFileType.
       if vDelFileType begins "F"
         and vDelFileName begins vPref
         and num-entries( vDelFileName, "." ) > 1
         and entry(2,vDelFileName, "." ) = "zip" 
       then do:
         /* проверяем, что прошло больше заданного кол-ва дней */
         assign
            vZipName = entry(1, vDelFileName, "." )
            vZipDate = ?
            .
         if num-entries(vZipName,"-") = 4 then 
         vZipDate = date(entry(2,vZipName,"-") + "/" + entry(3,vZipName,"-") + "/" + entry(4,vZipName,"-")) no-error.
         if vZipDate <> ? and (vDate - vZipDate + 1) >= vNumDate 
         then do:
            /* удаляем этот файл */
            run write-to-log( substitute("Удаление архива &1.zip", entry(1,vDelFullName,"."))) .
            os-delete value (vDelFullName) no-error .
            if searchFile(vDelFullName) = ? 
            then  run write-to-log( "Архив успешно удален" ) .
            else  run write-to-log( substitute("Не удалось удалить архив &1.zip", entry(1,vDelFullName,"."))) .
         end.
       end.
    end.
    input stream FLStream close.

end.    
else run write-to-log( substitute("Не найден каталог архивов проверки марок &1", vFolder) ).
