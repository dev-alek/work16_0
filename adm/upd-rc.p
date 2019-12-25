/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Обновление r-кодов, обновления должны лежать передаваемом в каталоге

Автор: Уханов Дмитрий Юрьевич
Дата создания: 01/22/08
Author: Dmitry Ukhanov
Creation date: 01/22/08


Автор1: Румянцев Юрий Александрович
Дата создания1: 02/16/06

*/

define input parameter p0-source-dir as character no-undo .

define variable vss-revision    as character no-undo init "$revision: 9 $":u .
define variable vss-author      as character no-undo init "$author: rumyantsev $":u .
define variable vss-date        as character no-undo init "$date: 23.03.07 13:37 $":u .
define variable vss-workfile    as character no-undo init "$workfile: upd-rc.p $":u .
define variable vss-archive     as character no-undo init "$archive: /ver14_0/adm/upd-rc.p $":u .
define variable vss-description as character no-undo init "Обновление r-кодов, обновления должны лежать передаваемом в каталоге".
{ cmp/vssrevis.i }
{ gbl/waitfram.i }

define variable p0-pathrc as character no-undo .
define variable v-pathrc         as character no-undo .
define variable v-filename         as character no-undo .
define variable v-fullfilename     as character no-undo .
define variable v-filetype         as character no-undo .
define variable v-copy-err         as logical no-undo .

define variable v-delfile as char no-undo.
define variable v-date   as date no-undo .
define variable v-txt   as char no-undo .
define variable v-arc   as char no-undo .

define stream flstream.

define temp-table upgfile-tbl no-undo
  field nameupgfile  as char
  field fullnameupgfile  as char
  field dateupg as date
  index dupg is unique primary dateupg
.

for each upgfile-tbl
:
  delete upgfile-tbl.
end.

define variable v-version           as character no-undo .
define variable v-locale            as character no-undo .
define variable v-SVNRev            as integer   no-undo .
define variable v-compilerVersion   as character no-undo .
define variable v-compile-date      as date      no-undo .
define variable v-time              as integer   no-undo .
define variable v-comment           as character no-undo .
define variable v-file-date         as date      no-undo .
define variable v-file-time         as integer   no-undo .

define variable v-program-tag     as character no-undo .

/* Дата компиляции */

run gbl/vertag.p (
      output v-version
    , output v-locale
    , output v-SVNRev
    , output v-compilerVersion
    , output v-compile-date
    , output v-time
    , output v-comment
    , output v-file-date
    , output v-file-time
) .

run waitfram-show in this-procedure ( input "Идет обновление программ ТН. Ждите..." ).

/* Ищем где лежат r-коды   */
assign
  p0-pathrc = search( "adm/upd-rc.r":U )
.
if p0-pathrc = ? then do:
  assign
    p0-pathrc = search( "adm/upd-rc.p":U )
  .
  if p0-pathrc = ? then do:
    return error "Не найден путь на программы ТН".
  end.
end.


/* Есть ли архиватор  */
assign
  v-arc = search( "exe/7z.exe":U )
.
if v-arc = ? then do:
  return error "Не найдена программа 7z.exe, раскрыть обновления невозможно" .
end.

assign
  v-pathrc = substring(p0-pathrc, 1, r-index(p0-pathrc, "\") - 1 )
  v-pathrc = substring(v-pathrc, 1, r-index(v-pathrc, "\") - 1 )
  p0-pathrc = substring(v-pathrc, 1, r-index(v-pathrc, "\") - 1 )
.


/* Выбираем из каталога с новостями файлы апгрейда r-кодов  */
input stream flstream from os-dir ( p0-source-dir ) .

repeat
on error undo, return error
:
  import stream flstream v-filename v-fullfilename v-filetype.

  if v-filetype begins "f" and num-entries( v-filename, "." ) > 1
    and ( ( v-filename begins "rc_20")
          or ( v-filename begins "update_20")
        )
  then do:
/*      Вызов этой программы происходит в  s-g-pack.p  ,причем там тоже стоит проверка на имя файла,*/
/*      если имена будем править здесь то надо поправить и там  */
    assign
      file-info:file-name = v-fullfilename
      v-txt = substring (v-filename,  index(v-filename, "_") + 6, 5).
      v-date = date( integer(substring(v-txt,1,2)), integer(substring(v-txt,4,2)), integer(substring(v-filename, index(v-filename, "_") + 1, 4)) )
    .
    find first upgfile-tbl no-lock
      where upgfile-tbl.dateupg = v-date
      no-error.
    if not available upgfile-tbl then do:
      /* Во временную таблицу запоминаем все файлы апгрейда  */
      create upgfile-tbl.
      assign
        upgfile-tbl.dateupg         = v-date
        upgfile-tbl.nameupgfile     = v-filename
        upgfile-tbl.fullnameupgfile = p0-pathrc + "/" + v-filename
      .

      os-command silent
        value( "copy" )
        value( v-fullfilename )
        value( p0-pathrc )
      .
      if os-error <> 0 then do:
        return error substitute("Невозможно скопировать файл &1 в каталог &2", v-fullfilename, v-pathrc) .
      end.
    end.
  end.  /*   if v-filetype begins "f" and  */
  
  /* Для кассы */
  if v-filetype begins "f" and num-entries( v-filename, "." ) > 1
  and ( v-filename begins "UFO-")
  then do:
      
      os-command silent
        value( "copy" )
        value( v-fullfilename )
        value( p0-pathrc )
      .
      if os-error <> 0 then do:
        return error substitute("Невозможно скопировать файл &1 в каталог &2", v-fullfilename, p0-pathrc) .
      end.
      
      if search (p0-pathrc + "/" + v-filename) = ?
      then
      v-copy-err = true .
      
      assign
        file-info:file-name = p0-pathrc + "\ufo_update"
      .
      if file-info:file-type = ? then do:
          os-create-dir value( p0-pathrc  + "\ufo_update" ). 
          if os-error <> 0 then do:
              return error string ( "Невозможно создать папку " + p0-pathrc  + "\ufo_update" ).
          end.
      end.
      else do :
          assign
            file-info:file-name = p0-pathrc + "\ufo_update-old"
          .
          if file-info:file-type <> ? then do:
              os-delete value ( p0-pathrc + "\ufo_update-old" ) recursive. 
              if os-error <> 0 then do:
                  os-rename  value ( p0-pathrc + "\ufo_update-old" ) value ( p0-pathrc + "\ufo_update-old1" ). 
                  if os-error <> 0 then do:
                      return error string ( "Невозможно удалить папку " + p0-pathrc + "\ufo_update-old, удалите ее сами" ).
                  end.
              end.
          end.
        
          os-rename  value ( p0-pathrc + "\ufo_update" ) value ( p0-pathrc + "\ufo_update-old" ). 
          if os-error <> 0 then do:
              return error string(( "Невозможно переименовать папку " + p0-pathrc + "\ufo_update для сохранности" )).
          end.
          os-create-dir value( p0-pathrc  + "\ufo_update" ). /* создаем rc */
          if os-error <> 0 then do:
              os-rename  value ( p0-pathrc  + "\ufo_update-old") value ( p0-pathrc  + "\ufo_update" ). /* переименовываем rc-old в rc при ошибке создания  rc*/
              return error string ( "Невозможно создать папку " + p0-pathrc  + "\ufo_update" ).
          end.
      end. 
      
      if not v-copy-err
      then do :
        v-txt = p0-pathrc + "\rc\exe\7z.exe" + " x -y -o" + p0-pathrc + "\ufo_update " +  p0-pathrc + "/" + v-filename.   
      end.
      else do :
        FILE-INFO:FILE-NAME = ".".
        v-txt = v-pathrc + "\exe\7z.exe" + " x -y -o" + p0-pathrc + "\ufo_update " +  FILE-INFO:FULL-PATHNAME + "/" + v-filename.  
      end.
      
      os-command silent value ( v-txt ) .
      
      v-pathrc = search( p0-source-dir + "/" + v-filename ).
      os-delete value ( v-pathrc ) recursive.
      
  end.    
end.  /*  repeat  on error undo   */
input stream flstream close.


for each upgfile-tbl no-lock
  where upgfile-tbl.dateupg > v-compile-date
on error undo, return error return-value
:

    if v-filename begins "rc_20" then do:
      assign
        file-info:file-name = v-pathrc + "-old"
      .
      if file-info:file-type <> ? then do:
          os-delete value ( v-pathrc + "-old" ) recursive. /* удаляем rc-old */
          if os-error <> 0 then do:
              os-rename  value ( v-pathrc + "-old" ) value ( v-pathrc + "-old1" ). /* переименовываем rc в rc-old */
              if os-error <> 0 then do:
                  return error string ( "Невозможно удалить папку " + v-pathrc + "-old, удалите ее сами" ).
              end.
          end.
      end.


      os-rename  value ( v-pathrc ) value ( v-pathrc + "-old" ). /* переименовываем rc в rc-old */
      if os-error <> 0 then do:
          return error string(( "Невозможно переименовать папку " + v-pathrc + " для сохранности" )).
      end.
      os-create-dir value( v-pathrc ). /* создаем rc */
      if os-error <> 0 then do:
          os-rename  value ( v-pathrc  + "-old") value ( v-pathrc ). /* переименовываем rc-old в rc при ошибке создания  rc*/
          return error string ( "Невозможно создать папку " + v-pathrc ).
      end.

      v-txt = "".
      v-txt = /* v-arc */ v-PathRC + "-old\exe\7z.exe" + " x -y -o" + v-PathRC + " " +  UpgFile-tbl.FullNameUpgFile.
    end.
    else do:
      v-txt = "".
      v-txt = v-PathRC + "\exe\7z.exe" + " x -y -o" + v-PathRC + " " +  UpgFile-tbl.FullNameUpgFile.
    end.

    os-command silent value ( v-txt ) .

    v-delfile = search( "!delfile.bat" ).
    if v-delfile <> ? then do:
        input from value ( v-delfile ) .
        repeat :
           import unformatted v-txt.
           if trim (v-txt) = "" then next.
           v-txt = trim(substring ( v-txt, r-index(v-txt, " ") )).
           if trim (v-txt) = "" then next.
           v-txt = search( v-txt ).
           os-delete value ( v-txt ) recursive.
        end.
        input close.
    end.  /*  if v-delfile <> ? then do:  */

    os-delete value ( v-delfile ) recursive. /* удаляем файл !delfile.bat */

end.  /*  for each upgfile-tbl where  */

/* Удаление апгрейдных файлов из каталога новостей, после того как все сделали */
for each upgfile-tbl :
    p0-pathrc = search( p0-source-dir + "/" + upgfile-tbl.nameupgfile ).
    os-delete value ( p0-pathrc ) recursive.
    delete upgfile-tbl.
end.



run waitfram-hide in this-procedure .
return "Установленны обновления программ ТН, чтобы они вступили в действие надо закрыть все программ ТН и запустить их снова" .