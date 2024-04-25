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

define variable vFileReq1     as character no-undo. /* имя файла с логом */
define variable vFileReq2     as character no-undo. /* имя файла с логом */
define variable vFileReq3     as character no-undo. /* имя файла с логом */

define variable vFileReqPathArh1 as character no-undo. /* полное имя с путем файла с логом в каталоге для архивации */
define variable vFileReqPathArh2 as character no-undo. /* полное имя с путем файла с логом в каталоге для архивации */
define variable vFileReqPathArh3 as character no-undo. /* полное имя с путем файла с логом в каталоге для архивации */

define variable vFileReqPath1 as character no-undo. /* Полный путь к файлу логу */
define variable vFileReqPath2 as character no-undo. /* Полный путь к файлу логу */
define variable vFileReqPath3 as character no-undo. /* Полный путь к файлу логу */

define variable vFileArh     as character no-undo. /* имя файла архива */
define variable vFolderPath  as character no-undo. /* Путь к каталогу с архивами */
define variable vArchPath    as character no-undo. /* Полный путь каталога архива */
define variable vFileArhPath as character no-undo. /* Полный путь к архив-файлу */
define variable vArhName     as character no-undo. /* Имя каталога для архивации */
define variable vMyWorkDir   as character no-undo. /* Путь к каталогу */
define variable vFolder      as character no-undo. /* Каталог с архивом */
define variable vPathFolder  as character no-undo.
define variable vDirDelim    as character no-undo init "\":u.
define variable vPref        as character no-undo.

define stream FLStream.
define variable vDelFileName as character no-undo.
define variable vDelFullName as character no-undo.
define variable vDelFileType as character no-undo.
define variable vZipName     as character no-undo.
define variable vZipDate     as date      no-undo.
define variable vNumDate     as integer   no-undo.

define variable vDate as date no-undo.

assign
   vDate     = today - 1
   vFileReq1 = "GisMtReq-" + replace(string(vDate),"/","-") + ".log"   
   vFileReq2 = "GisMtCDN-" + replace(string(vDate),"/","-") + ".log"
   vFileReq3 = "sktsrv-" + replace(string(vDate),"/","-") + ".log"      
   vFolder   = "Архивы взаимодействия с ГИС МТ"
   vPref  = "Архив взаимодействия с ГИС МТ - "
   vArhName = vPref + replace(string(vDate),"/","-")    
   vNumDate  = 93
   .

/* архивируем лог и удаляем его */
vFileReqPath1 = searchFile(vFileReq1).
vFileReqPath2 = searchFile(vFileReq2).
vFileReqPath3 = searchFile(vFileReq3).                               
                                 
if vFileReqPath1 <> ? then do:
    assign
       vMyWorkDir = substring(vFileReqPath1,1,index(vFileReqPath1,vFileReq1) - 1)
       vFolderPath  = vMyWorkDir + vFolder
       vArchPath    = vFolderPath + vDirDelim + vArhName
       .
    entry(num-entries(vMyWorkDir,vDirDelim),vMyWorkDir,vDirDelim) = "".
    if objExists(vFolderPath,"D") eq ?  
       then os-create-dir VALUE(vFolderPath).    
    
    /* проверяем и создаем каталог для архивирования */    
    if objExists(vArchPath,"D") eq ?  
       then os-create-dir VALUE(vArchPath).
       
    /* полное имя файла в каталоге для архивации */   
    assign
       vFileReqPathArh1 = vArchPath + vDirDelim + vFileReq1
       vFileReqPathArh2 = vArchPath + vDirDelim + vFileReq2
       vFileReqPathArh3 = vArchPath + vDirDelim + vFileReq3              
       vFileArh         = vArchPath + ".zip"
       .
          
    /* копируем нужные файлы в каталог для архивации */
    copy-lob from file(vFileReqPath1) to file(vFileReqPathArh1) no-error.
    
    run write-to-log( substitute("Архивирование лога &1.log", 
                                 entry(1,vFileReqPath1,"."))).
    if vFileReqPath2 <> ? then do:    
       copy-lob from file(vFileReqPath2) to file(vFileReqPathArh2) no-error.
       run write-to-log( substitute("Архивирование лога &1.log", 
                                    entry(1,vFileReqPath2,"."))).
    end.   
    if vFileReqPath3 <> ? then do:   
       copy-lob from file(vFileReqPath3) to file(vFileReqPathArh3) no-error.
       run write-to-log( substitute("Архивирование лога &1.log", 
                                    entry(1,vFileReqPath3,"."))).
    end.   
                                                              
    run utl\arh7z.p(quoter(vFileArh),quoter(vArchPath)).
    
    vFileArhPath = searchFile(vFileArh).
    if vFileArhPath <> ? 
    then do:
       run write-to-log( substitute("Создан временный каталог для архивирования &1", vArchPath)) .
       run write-to-log( substitute("Создан архив &1.zip", entry(1,vFileArhPath,"."))) .
       
       os-delete value(vArchPath) recursive.
       if objExists(vArchPath,"D") = ? 
       then  run write-to-log( "Временный каталог для архивирования удален" ) .
       else  run write-to-log( "Не удалось удалить временный каталог для архивирования" ) .
       
       os-delete value (vFileReqPath1) no-error .
       /*os-delete value (vFileReqPathArh1) no-error .*/
       if searchFile(vFileReq1) = ? 
       then  run write-to-log( "Лог проверки марок успешно удален" ) .
       else  run write-to-log( "Не удалось удалить лог проверки марок" ) .
       
       if vFileReqPath2 <> ? then do:
           os-delete value (vFileReqPath2) no-error .
           /*os-delete value (vFileReqPathArh2) no-error .*/
           if searchFile(vFileReq2) = ? 
           then  run write-to-log( "Лог опроса CDN площадок успешно удален" ) .
           else  run write-to-log( "Не удалось удалить лог опроса CDN площадок" ) .
       end.
       if vFileReqPath3 <> ? then do:
           os-delete value (vFileReqPath3) no-error .
           /*os-delete value (vFileReqPathArh3) no-error .*/
           if searchFile(vFileReq3) = ? 
           then  run write-to-log( "Лог сокет-сервера успешно удален" ) .
           else  run write-to-log( "Не удалось удалить лог сокет-сервера" ) .
       end.    
                     
    end.
    else run write-to-log( "Произошла ошибка при архивировании логов").
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
