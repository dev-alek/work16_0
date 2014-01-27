/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

отправка и прием пакета новостей (файла)

Автор: Бахтадзе Наталья Викторовна
Дата создания: 10/02/08
Author: Bakhtadze Natalya
Creation date: 10/02/08

*/

define input parameter parparentproc as widget-handle no-undo .
define input parameter p-parent-handle as handle no-undo .
define input parameter p-log-handle  as handle no-undo .
define input parameter p0-action     as character no-undo .
define input parameter p0-arch       as logical   no-undo .
define input parameter p0-file-name  as character no-undo .
define input parameter p0-source-dir as character no-undo .
define input parameter p0-target-dir as character no-undo .
define input parameter p0-temp-dir   as character no-undo .
define input parameter p-pck-num     as integer no-undo .
define input parameter p-esys-id     as integer no-undo .
define input parameter p-db-num      as integer no-undo .
define input parameter p-cr-db-num   as integer no-undo .
define input parameter p-delivery-method as integer no-undo .


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "отправка и прием пакета новостей (файла)".
{ cmp/vssrevis.i }
{ cmp/trg-def.i }
{ bge/esallatr.i  work }
{ bge/esysattr.i }
{ gbl/filelist.i }
{ gbl/ftp-fl.i }
{ gbl/ftp-df.i }
{ gbl/cur-time.i }
{ rul/ora-rcpt.i proc }
DEFINE VARIABLE v-today as date no-undo .
DEFINE VARIABLE v-time as integer no-undo .

do
on error undo, return error
:
  define stream FLStream.

  define variable v-filename         as character no-undo .
  define variable v-fullfilename     as character no-undo .
  define variable v-filetype         as character no-undo .
  define variable v-current-pack-num as integer no-undo .
  define variable v-ftp-ip as character no-undo .
  define variable v-ftp-login as character no-undo .
  define variable v-ftp-password as character no-undo .
  define variable v-ftp-path as character no-undo .
  define variable v-ftp-path-in as character no-undo .
  define variable v-ftp-path-out as character no-undo .
  define variable v-flags as character no-undo .
  define variable v-cmd-line as character no-undo .
  define variable l-res as integer no-undo .
  define variable v-type as character no-undo .
  define variable v-parameter as character no-undo .
  define variable log-file-name as character no-undo .

  define buffer buf_esys-all-attr for ub.esys-all-attr.
  define buffer buf_temp-filelist for temp-filelist.
  define buffer buf_esys-pck-sent for ub.esys-pck-sent.

  /* если каталога temp-dir нет, то создадим его */
  assign
    file-info:file-name = p0-temp-dir
  .
  if file-info:file-type = ?
    or not ( file-info:file-type begins "D":U )
  then do:
    os-create-dir value( p0-temp-dir ).
    if os-error <> 0 then do:
      return error substitute( "&1. Каталог &2 отсутствует, а создать его не удалось.", vss-workfile, p0-temp-dir ).
    end.
  end.
  case p-delivery-method:
    when integer({&esys-dm-CDash}) then do:
      p0-arch = no.
    end.
    when integer({&esys-dm-exite-edi}) then do:
      p0-arch = no.
    end.
  end.

  if p0-file-name <> ? then do:  /*при get так не бывает*/
    run file-s-g ( input p0-action
                  ,input p0-arch
                  ,input p0-file-name
                  ,input p0-source-dir
                  ,input p0-target-dir
                  ,input p0-temp-dir
                  ,input p-pck-num
                 ) no-error.
    if error-status :error then do:
      return error return-value.
    end.
  end.
  else do:
    if p-delivery-method = integer({&esys-dm-nn})
    or p-delivery-method = integer({&esys-dm-nnold})
    or p-delivery-method = integer({&esys-dm-exite-edi})
    then do:
      /*надо получить список файлов и всем сделать get*/
      run ext-system-attr-value in this-procedure ( input p-esys-id
                                                    ,input p-db-num
                                                    ,input {&attr-esys-ftp-ip}
                                                    ,output v-ftp-ip
                                                    ,output v-type) no-error.
      run ext-system-attr-value in this-procedure ( input p-esys-id
                                                    ,input p-db-num
                                                    ,input {&attr-esys-ftp-login}
                                                    ,output v-ftp-login
                                                    ,output v-type) no-error.
      run ext-system-attr-value in this-procedure ( input p-esys-id
                                                    ,input p-db-num
                                                    ,input {&attr-esys-ftp-password}
                                                    ,output v-ftp-password
                                                    ,output v-type) no-error.
      run ext-system-attr-value in this-procedure ( input p-esys-id
                                                    ,input p-db-num
                                                    ,input {&attr-esys-ftp-path}
                                                    ,output v-ftp-path
                                                    ,output v-type) no-error.
      if p-delivery-method = integer({&esys-dm-exite-edi}) then do:
        run ext-system-attr-value in this-procedure ( input p-esys-id
                                                      ,input p-db-num
                                                      ,input {&attr-esys-ftp-path-in}
                                                      ,output v-ftp-path-in
                                                      ,output v-type) no-error.
        run ext-system-attr-value in this-procedure ( input p-esys-id
                                                      ,input p-db-num
                                                      ,input {&attr-esys-ftp-path-out}
                                                      ,output v-ftp-path-out
                                                      ,output v-type) no-error.
        v-flags = string({&INTERNET_FLAG_PASSIVE}).
      end.
      else do:
        v-ftp-path-in = "in".
        v-ftp-path-out = "out".
        v-flags = string(0).
      end.
      run get-log-file-name in p-parent-handle ( output log-file-name) no-error.
      assign
      v-parameter = v-ftp-ip + {&delim-par} +
                    v-ftp-login + {&delim-par} +
                    v-ftp-password + {&delim-par} +
                    v-flags + {&delim-par} + /*flags*/
                    (if v-ftp-path <> ''
                    then (trim (trim (trim(v-ftp-path
                                    , {&back-slash-char})
                                ,{&slash-char})
                          ,{&back-slash-char}) + {&slash-char})
                    else '') +
                    v-ftp-path-in + {&delim-par} +
                    "ftp-fl_CreateFileList" + {&delim-par} +
                    log-file-name.
      .
      for each buf_temp-filelist :
        delete buf_temp-filelist.
      end.
      run gbl/ftp-ls.p ( input parparentproc
                        ,input this-procedure:handle
                        ,input p-log-handle
                        ,input v-parameter ) no-error.

      if not can-find(first buf_temp-filelist) then do:
        if p-delivery-method = integer({&esys-dm-exite-edi}) then do:
          define variable v-to-return as logical no-undo .
          v-to-return = yes.
        end.
        else do:
        return.
      end.
      end.
      if not v-to-return then do:
        assign
        v-parameter = v-ftp-ip + {&delim-par} +
                      v-ftp-login + {&delim-par} +
                      v-ftp-password + {&delim-par} +
                    v-flags + {&delim-par} + /*flags*/
                    '' + {&delim-par} +
                    '' + {&delim-par} +
                      string(yes) + {&delim-par} +
                    "cb_getnextfilename" + {&delim-par} +
                      "process-edoc.txt"
        .
        run gbl/ftp-get.p ( input parparentproc
                          ,input this-procedure:handle
                          ,input p-log-handle
                          ,input v-parameter ) no-error.
        if error-status:error then do:
          return error return-value.
        end.
      end.
    end.
    input stream FLStream from os-dir ( p0-source-dir ) .
    v-current-pack-num = p-pck-num - 1.
    repeat
    on error undo, return error
    :
      import stream FLStream v-filename v-fullfilename v-filetype.

      if v-filetype begins "F"
        and num-entries( v-filename, "." ) > 1
      then do:
        assign
          file-info:file-name = v-fullfilename
        .

        if lookup(entry( num-entries( v-filename, "." ), v-filename, "." ), "$$$") = 0
          and file-info:file-type MATCHES "*W*":U /* проверка на атрибут read-only */
          and file-info:file-type MATCHES "*R*":U /* проверка на возможность чтения файла */
          and not ( file-info:file-type MATCHES "*H*":U )
        then do:
          v-current-pack-num = v-current-pack-num + 1.
          run file-s-g ( input p0-action
                        ,input p0-arch
                        ,input v-filename
                        ,input p0-source-dir
                        ,input p0-target-dir
                        ,input p0-temp-dir
                        ,input v-current-pack-num
                      ) no-error.
          if error-status :error then do:
            return error return-value.
          end.
          if p-delivery-method = integer({&esys-dm-exite-edi}) then do:
            /* запишем в контенер список файлов  */
            define variable v-caller-handle as handle no-undo .
            v-caller-handle = this-procedure:instantiating-procedure.
            if lookup("cb_fill-filelist", v-caller-handle:internal-entries) > 0 then do:
              run cb_fill-filelist in v-caller-handle ( input v-filename) no-error.
            end.
          end.
        end.
      end.
    END.
    input stream FLStream close.

  end.

  return .

end.

procedure file-s-g :
  define input parameter p-action     as character no-undo .
  define input parameter p-arch       as logical   no-undo .
  define input parameter p-file-name  as character no-undo .
  define input parameter p-source-dir as character no-undo .
  define input parameter p-target-dir as character no-undo .
  define input parameter p-temp-dir   as character no-undo .
  define input parameter p-current-pack-num as integer no-undo .
  do
  on error undo, return error
  :
    define variable v-arch             as logical   no-undo .
    define variable v-arh-name         as character no-undo .
    define variable v-arh-type         as character no-undo .

    define variable v-file-source      as character no-undo .
    define variable v-file-source-arj  as character no-undo .
    define variable v-file-temp        as character no-undo .
    define variable v-file-target      as character no-undo .
    define variable v-file-source-all  as character no-undo .
    define variable v-log-file-source      as character no-undo .
    define variable v-log-file-source-arj  as character no-undo .
    define variable v-log-file-temp        as character no-undo .
    define variable v-log-file-target      as character no-undo .


    define variable v-file-name-no-ext as character no-undo .
    define variable v-ext-name         as character no-undo .

    define variable v-err-mess         as character no-undo .
    define variable v-send-log         as logical   no-undo .
    define buffer buf_esys-pck-rcvd for ub.esys-pck-rcvd.

    case p-delivery-method:
      when integer({&esys-dm-nn})
      or
      when integer({&esys-dm-nnold})
      or
      when integer({&esys-dm-exite-edi})
      then do:
      v-arh-name = ''.
      p-arch = no.
    end.
      when integer({&esys-dm-oracle-retail})
      then do:
        v-arh-name = search('exe/pkzipc.exe':U).
        v-arh-type = "zip".
      end.
      when integer({&esys-dm-cdash})
      then do:
        v-arh-name = "".
        v-arh-type = "".
      end.
      otherwise  do:
        assign
          v-arh-name = search( "exe/arj32.exe":U )
        .
        if v-arh-name = ? then do:
          assign
            v-arh-name = search( "exe/arj.exe":U )
          .
        end.
        v-arh-type = "arj".
      end.
    end case.
    if r-index( p-file-name, '.':u) > 0 then do:
      assign
        v-file-name-no-ext = substring( p-file-name, 1, r-index( p-file-name, '.':u) - 1 )
        v-ext-name         = entry( num-entries( p-file-name, "." ), p-file-name, "." )
      .
    end.
    else do:
      assign
        v-file-name-no-ext = p-file-name
        v-ext-name         = "":U
      .
    end.
    if p-action = "put"
    or p-action = "fput"
    or p-action = "fget"
    then do:
    assign
      v-file-source     = p-source-dir + {&back-slash-char} + p-file-name
      v-file-temp       = p-temp-dir   + {&back-slash-char} + p-file-name
        v-file-target     = p-target-dir + {&back-slash-char} + p-file-name
    .
      if p-action = "put" then do:
        case p-delivery-method:
          when integer({&esys-dm-oracle-retail}) then do:
            if search(p-source-dir + {&back-slash-char} + v-file-name-no-ext + ".LOG") <> ? then do:
              v-send-log = yes.
              assign
              v-log-file-source     = p-source-dir + {&back-slash-char} + v-file-name-no-ext + ".LOG"
              v-log-file-temp       = p-temp-dir   + {&back-slash-char} + v-file-name-no-ext + ".LOG"
              v-log-file-target     = p-target-dir + {&back-slash-char} + v-file-name-no-ext + ".LOG"
              .
            end.
          end.
          otherwise do:
          end.
        end case.
      end.
    end.
    else do:
      if p-delivery-method = integer({&esys-dm-nnold})
      or p-delivery-method = integer({&esys-dm-oracle-retail})
      or p-delivery-method = integer({&esys-dm-exite-edi})
      then do:
        find first buf_esys-all-attr share-lock where
                  buf_esys-all-attr.attr-code = {&attr-custom-pack-name}
              and buf_esys-all-attr.table-name = {&table_esys-pck-rcvd}
              and buf_esys-all-attr.key1 = p-current-pack-num
              and buf_esys-all-attr.key2 = p-esys-id
              and buf_esys-all-attr.key5 = p-db-num
              and buf_esys-all-attr.key6 = g#db-num
              no-error .
        if not available buf_esys-all-attr then do:
          create buf_esys-all-attr.
          assign
          buf_esys-all-attr.attr-code = {&attr-custom-pack-name}
          buf_esys-all-attr.table-name = {&table_esys-pck-rcvd}
          buf_esys-all-attr.key1 = p-current-pack-num
          buf_esys-all-attr.key2 = p-esys-id
          buf_esys-all-attr.key5 = p-db-num
          buf_esys-all-attr.key6 = g#db-num
          .
        end.
        if p-delivery-method = integer({&esys-dm-oracle-retail}) then do:
          buf_esys-all-attr.attr-value = v-file-name-no-ext + ".DAT".
        end.
        else do:
          buf_esys-all-attr.attr-value = p-file-name.
        end.
      end.
      assign
        v-file-source     = p-source-dir + {&back-slash-char} + p-file-name
        v-file-temp       = p-temp-dir   + {&back-slash-char} + p-file-name
        v-file-target     = p-target-dir + {&back-slash-char} + p-file-name
                            /*(if available buf_esys-all-attr
                            then  p-file-name
                            else ("o":U + string( p-current-pack-num, "999999999":U ) + ".xml":U)
                            )*/
      .
    end.

    /* проверим наличие исходного файла */
    assign
      file-info:file-name = v-file-source
    .
    if file-info:file-type = ?
      or not ( file-info:file-type begins "F":U )
    then do:
      return error substitute( "&1. Исходный файл &2 не найден.", vss-workfile, v-file-source ).
    end.
    if p-action = "put":U
    or p-action = "fput"
    then do:
      if p-arch = true then do:
        if v-arh-name = ? then do:
          return error substitute( "&1. Программа архиватор не найдена!", vss-workfile ).
        end.
        run write-to-log in p-parent-handle ( substitute( "Отправка файла &1 (&2)", v-file-source, v-arh-name ) ).

        if v-arh-type = "arj" then do:
        assign
          v-file-source-arj = p-source-dir + {&back-slash-char} + v-file-name-no-ext + ".arj":U
          v-file-temp       = p-temp-dir   + {&back-slash-char} + v-file-name-no-ext + ".arj":U
          v-file-target     = p-target-dir + {&back-slash-char} + v-file-name-no-ext + ".arj":U
        .
        os-command silent
          value( v-arh-name )
          value( "a -e -y":U )
          value( v-file-source-arj )
          value( v-file-source )
        .
      end.
        if v-arh-type = "zip" then do:
          case p-delivery-method:
            when integer({&esys-dm-oracle-retail}) then do:
              assign
                v-file-source-arj = p-source-dir + {&back-slash-char} + v-file-name-no-ext + "." + v-ext-name + ".zip":U
                v-file-temp       = p-temp-dir   + {&back-slash-char} + v-file-name-no-ext + "." + v-ext-name + ".zip":U
                v-file-target     = p-target-dir + {&back-slash-char} + v-file-name-no-ext + "." + v-ext-name + ".zip":U
              .
              if v-send-log then do:
                assign
                  v-log-file-source-arj = p-source-dir + {&back-slash-char} + v-file-name-no-ext + ".LOG" + ".zip":U
                  v-log-file-temp       = p-temp-dir   + {&back-slash-char} + v-file-name-no-ext + ".LOG" + ".zip":U
                  v-log-file-target     = p-target-dir + {&back-slash-char} + v-file-name-no-ext + ".LOG" + ".zip":U
                .
              end.
              os-command silent
                value( v-arh-name )
                value( "-add -path=none -span=700 ":U )
                value( v-file-source-arj )
                value( v-file-source )
              .
              if v-send-log then do:
                os-command silent
                  value( v-arh-name )
                  value( "-add -path=none -span=700 ":U )
                  value( v-log-file-source-arj )
                  value( v-log-file-source )
                .

              end.
            end.
            otherwise do:
          assign
            v-file-source-arj = p-source-dir + {&back-slash-char} + v-file-name-no-ext + ".zip":U
            v-file-temp       = p-temp-dir   + {&back-slash-char} + v-file-name-no-ext + ".zip":U
            v-file-target     = p-target-dir + {&back-slash-char} + v-file-name-no-ext + ".zip":U
            v-file-source-all = p-source-dir + {&back-slash-char} + v-file-name-no-ext + ".*":U
          .
          os-command silent
            value( v-arh-name )
            value( "-add -path=none -span=700 ":U )
            value( v-file-source-arj )
            value( v-file-source-all )
          .
        end.
      end.
        end.
      end. /*if p-arch = true then do:*/
      else do:
        assign
        v-file-source-arj = p-source-dir + {&back-slash-char} + v-file-name-no-ext + "." + v-ext-name
        v-file-temp       = p-temp-dir   + {&back-slash-char} + v-file-name-no-ext + "." + v-ext-name
        v-file-target     = p-target-dir + {&back-slash-char} + v-file-name-no-ext + "." + v-ext-name
        .
        run write-to-log in p-parent-handle ( substitute( "Отправка файла &1 (copy)", v-file-source ) ).
        assign
          v-file-source-arj = v-file-source
        .
      end.
      run del-file ( input v-file-temp ) no-error .
      if error-status :error then do:
        return error return-value .
      end.
      if v-send-log then do:
        run del-file ( input v-log-file-temp ) no-error .
        if error-status :error then do:
          return error return-value .
        end.
      end.
      os-copy value( v-file-source-arj ) value( v-file-temp ).
      if os-error <> 0 then do:
        run adm/os-err.p ( output v-err-mess ).
        return error substitute( "&1. Невозможно скопировать файл &2 в каталог &3&4&5", vss-workfile, v-file-temp, p-target-dir, {&new-line}, v-err-mess ) .
      end.
      if v-send-log then do:
        os-copy value( v-log-file-source-arj ) value( v-log-file-temp ).
        if os-error <> 0 then do:
          run adm/os-err.p ( output v-err-mess ).
          return error substitute( "&1. Невозможно скопировать файл &2 в каталог &3&4&5", vss-workfile, v-log-file-temp, p-target-dir, {&new-line}, v-err-mess ) .
        end.
      end.
      if p-arch = true then do:
        run del-file ( input v-file-source-arj ) no-error .
        if error-status :error then do:
          return error return-value .
        end.
        if v-send-log then do:
          run del-file ( input v-log-file-source-arj ) no-error .
          if error-status :error then do:
            return error return-value .
          end.
        end.
      end.

      run ren-file ( input v-file-temp
                    ,input v-file-target
                   ) no-error .
      if error-status :error then do:
        assign
          v-err-mess = return-value
        .
        run del-file ( input v-file-temp ) no-error .
        if error-status :error then do:
          assign
            v-err-mess = v-err-mess + {&new-line} + return-value
          .
        end.
        return error v-err-mess .
      end.
      if v-send-log then do:
        run ren-file ( input v-log-file-temp
                      ,input v-log-file-target
                    ) no-error .
        if error-status :error then do:
          assign
            v-err-mess = return-value
          .
          run del-file ( input v-log-file-temp ) no-error .
          if error-status :error then do:
            assign
              v-err-mess = v-err-mess + {&new-line} + return-value
            .
          end.
          return error v-err-mess .
        end.
      end.
      if p-action = "put"
      and (p-delivery-method = integer({&esys-dm-nn})
          OR
          p-delivery-method = integer({&esys-dm-nnold})
          OR
          p-delivery-method = integer({&esys-dm-exite-edi})
          )
      then do:
        run ext-system-attr-value in this-procedure ( input p-esys-id
                                                     ,input p-db-num
                                                     ,input {&attr-esys-ftp-ip}
                                                     ,output v-ftp-ip
                                                     ,output v-type) no-error.
        run ext-system-attr-value in this-procedure ( input p-esys-id
                                                     ,input p-db-num
                                                     ,input {&attr-esys-ftp-login}
                                                     ,output v-ftp-login
                                                     ,output v-type) no-error.
        run ext-system-attr-value in this-procedure ( input p-esys-id
                                                     ,input p-db-num
                                                     ,input {&attr-esys-ftp-password}
                                                     ,output v-ftp-password
                                                     ,output v-type) no-error.
        run ext-system-attr-value in this-procedure ( input p-esys-id
                                                     ,input p-db-num
                                                     ,input {&attr-esys-ftp-path}
                                                     ,output v-ftp-path
                                                     ,output v-type) no-error.
        if p-delivery-method = integer({&esys-dm-exite-edi}) then do:
          run ext-system-attr-value in this-procedure ( input p-esys-id
                                                        ,input p-db-num
                                                        ,input {&attr-esys-ftp-path-in}
                                                        ,output v-ftp-path-in
                                                        ,output v-type) no-error.
          run ext-system-attr-value in this-procedure ( input p-esys-id
                                                        ,input p-db-num
                                                        ,input {&attr-esys-ftp-path-out}
                                                        ,output v-ftp-path-out
                                                        ,output v-type) no-error.
          v-flags = string({&INTERNET_FLAG_PASSIVE}).
        end.
        else do:
          v-ftp-path-in = "in".
          v-ftp-path-out = "out".
          v-flags = string(0).
        end.
       run get-log-file-name in p-parent-handle ( output log-file-name) no-error.
        assign
        v-parameter = v-ftp-ip + {&delim-par} +
                      v-ftp-login + {&delim-par} +
                      v-ftp-password + {&delim-par} +
                      v-flags + {&delim-par} + /*flags*/
                      (if v-ftp-path <> ''
                      then (trim (trim (trim(v-ftp-path
                                      , {&back-slash-char})
                                  ,{&slash-char})
                            ,{&back-slash-char}) + {&slash-char})
                      else '') +
                      v-ftp-path-out + {&slash-char} + p-file-name  + {&delim-par} +
                      p-target-dir + {&slash-char} + p-file-name + {&delim-par} +
                      string(no) + {&delim-par} +
                      log-file-name
        .
        run gbl/ftp-put.p ( input parparentproc
                          ,input this-procedure:handle
                          ,input p-log-handle
                          ,input v-parameter ) no-error.
        if error-status:error then do:
           run write-to-log in p-parent-handle ( input  substitute("Ошибки при передаче файла &1 по FTP"
                                                                  , p-file-name
                                                                  )).
        end.
        else do:
          if p-delivery-method <> integer({&esys-dm-exite-edi}) then do:
          run cur-time in this-procedure ( output v-today, output v-time).
          find first buf_esys-pck-sent exclusive-lock where
                    buf_esys-pck-sent.esys-id = p-esys-id
                and buf_esys-pck-sent.db-num = p-db-num
                and buf_esys-pck-sent.esps-cr-db-num = p-cr-db-num
                and buf_esys-pck-sent.esps-pack-num = p-pck-num.
          assign
          buf_esys-pck-sent.esps-rcvd = yes
          buf_esys-pck-sent.esps-RcvdTimeInt    = v-time
          buf_esys-pck-sent.esps-RcvdTime       = string( v-time, "HH:MM:SS" )
          buf_esys-pck-sent.esps-rcvddate       = v-today
          .
        end.
        end.
        run del-file ( input v-file-target ) no-error .
        if error-status :error then do:
          return error return-value .
        end.
      end.
    end. /*if p-action = "put":U then do:*/
    if p-action = "get"
    or p-action = "fget"
    then do:
      if lookup( v-ext-name, "arj") <> 0
      or lookup( v-ext-name, "zip") <> 0
      then do:
        run write-to-log in p-parent-handle ( substitute( "Прием файла &1 (&2)", v-file-source, v-arh-name ) ) .
          assign
            v-arch = true
          .
        end.
        else do:
        run write-to-log in p-parent-handle ( substitute( "Прием файла &1 (copy)", v-file-source ) ) .
          assign
            v-arch = false
          .
        end.

        run ren-file ( input v-file-source
                      ,input v-file-temp
                    ) no-error .
        if error-status :error then do:
          return error return-value .
        end.

        run del-file ( input v-file-target ) no-error .
        if error-status :error then do:
          return error return-value .
        end.
        os-copy value( v-file-temp ) value( v-file-target ).

        if os-error <> 0 then do:
          run adm/os-err.p ( output v-err-mess ).
          return error substitute( "&1. Невозможно скопировать файл &2 в каталог &3&4&5", vss-workfile, v-file-temp, p-target-dir, {&new-line}, v-err-mess ).
        end.
        run del-file ( input v-file-temp ) no-error .
        if error-status :error then do:
          return error return-value .
        end.


        if v-arch then do:
          if v-arh-name = ? then do:
            return error substitute( "&1. Программа архиватор не найдена!", vss-workfile ).
          end.
        if lookup( v-ext-name, "zip") <> 0 then do:
          run write-to-log in p-parent-handle ( substitute( "Команда на распаковку zip: &1 -extract -silent -over=all &2 &3"
                                                          , v-arh-name
                                                          , v-file-target
                                                          , p-target-dir
                                                            ) ) .
          os-command silent
            value( v-arh-name )
            value( " -extract -silent -over=all ":U )
            value( v-file-target )
            value( p-target-dir )
          .

        end.
        if lookup( v-ext-name, "arj") <> 0 then do:
          os-command silent
            value( v-arh-name )
            value( "e -y":U )
            value( v-file-target )
            value( p-target-dir )
          .
        end.
          run del-file ( input v-file-target ) no-error .
          if error-status :error then do:
            return error return-value .
          end.
      end. /*if v-arch then do:*/
    end. /*else put*/
  end. /*doe*/
end procedure. /* file */

procedure del-file :
  define input parameter p-del-file-name as character no-undo .
  do
  on error undo, return error
  :
    define variable v-ind      as integer   no-undo .
    define variable v-err-code as integer   no-undo .
    define variable v-err-mess as character no-undo .
    define variable v-str      as character no-undo .

    assign
      file-info:file-name = p-del-file-name
    .
    if file-info:file-type <> ? then do:
      if file-info:file-type begins "F":U then do:
        assign
          v-str = "файл"
        .
      end.
      else do:
        if file-info:file-type begins "D":U then do:
          assign
            v-str = "каталог"
          .
        end.
        else do:
          assign
            v-str = "не знаю что"
          .
        end.
      end.

      bl1:
      do v-ind = 1 to 60 :
        os-delete value( p-del-file-name ).
        assign
          v-err-code = os-error
          file-info:file-name = p-del-file-name
        .
        if v-err-code = 0
          or file-info:file-type = ?
        then do:
          leave bl1 .
        end.
        pause 1 no-message .
      end.
      if os-error <> 0 then do:
        run adm/os-err.p ( output v-err-mess ).
        return error substitute( "&1. Невозможно удалить &2 &3&4&5", vss-workfile, v-str, p-del-file-name, {&new-line}, v-err-mess ).
      end.
    end.
  end.
  return.
end procedure. /* del-file */

procedure ren-file :
  define input parameter p-file-source as character no-undo .
  define input parameter p-file-target as character no-undo .
  do
  on error undo, return error
  :
    define variable v-ind      as integer   no-undo .
    define variable v-err-code as integer   no-undo .
    define variable v-err-mess as character no-undo .

    run del-file ( input p-file-target ) no-error .
    if error-status :error then do:
      return error return-value .
    end.

    bl1:
    do v-ind = 1 to 60 :
      os-rename value( p-file-source ) value( p-file-target ).
      assign
        v-err-code = os-error
        file-info:file-name = p-file-source
      .
      if v-err-code = 0
        or file-info:file-type = ?
      then do:
        leave bl1 .
      end.
      pause 1 no-message .
    end.

    if v-err-code <> 0 then do:
      run adm/os-err.p ( output v-err-mess ).
      return error substitute( "&1. Невозможно переименовать файл &2 в &3&4&5", vss-workfile, p-file-source, p-file-target, {&new-line}, v-err-mess ).
    end.
  end.
end procedure. /* ren-file */

procedure cb_getnextfilename :
define input-output parameter p-rfile-name as character no-undo .
define input-output parameter p-lfile-name as character no-undo .

define buffer buf_temp-filelist for temp-filelist.

do
on error undo, return error
:
  find first buf_temp-filelist where
            buf_temp-filelist.full-name > p-rfile-name no-error .
  if available buf_temp-filelist then do:
    assign
    p-rfile-name = buf_temp-filelist.full-name
    p-lfile-name =  p0-source-dir + {&slash-char} + buf_temp-filelist.file-name
    .
  end.
  else do:
    assign
    p-rfile-name = ''
    p-lfile-name = ''
    .
  end.
end.

end procedure. /* cb_getnextfilename */


/* $Workfile$ end */