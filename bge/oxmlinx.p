/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Импорт из файла OpenXML

Автор: Бахтадзе Наталья Викторовна
Дата создания: 01/19/08
Author: Bakhtadze Natalya
Creation date: 01/19/08

Input:
    parparentproc     - handle главного окна
    p-parent-handle       - handle вызывающей процедуры
    p-log-handle          - handle для записи лога (в handl-е должна быть поцедура write-log)
    p-parameter-string    - Строка параметров, через запятую. Первый параметр должен быть номером БД.

Output:

*/
define input parameter parparentproc    as widget-handle    no-undo.
define input parameter p-parent-handle      as widget-handle    no-undo.
define input parameter p-log-handle         as handle           no-undo.
define input parameter p-parameter-string   as character        no-undo.


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Импорт из файла OpenXML".
{ cmp/vssrevis.i }
{ cmp/trg-def.i }
{ cmp/library.i  }
{ gbl/cur-time.i }
{ gbl/xmlchar.i  }
{ str/xmllib.i   }
{ cmp/ini-lib.i  }
{ rul/xmlischn.i "new shared" }
{ bge/oxml-def.i }
{ gbl/orapreps.i }
{ rul/ora-rcpt.i proc }
{ gbl/filelist.i }

define variable v-cur-db-num        as integer      no-undo.
define variable v-cr-db-num         as integer      no-undo.
define variable v-pack-num          as integer      no-undo.
define variable v-esys-id           as integer      no-undo.
define variable v-esys-db-num       as integer      no-undo init 0. /* Сейчас внешние системы заводятся только в ГБД. Однако уникальный индекс  */
define variable v-action            as character    no-undo.
define variable v-xml-file-name     as character    no-undo.
define variable v-log-file-name     as character    no-undo.
define variable v-list-file-name    as character    no-undo.
define variable v-source-dir        as character no-undo .
define variable v-target-dir        as character no-undo .
define variable v-temp-dir          as character no-undo .
define variable v-today             as date         no-undo.
define variable v-time              as integer      no-undo.
define variable v-parameter-list    as character    no-undo.
define variable v-file-name         as character    no-undo.
DEFINE VARIABLE v-full-path         as character    no-undo.
DEFINE VARIABLE v-file-name-no-ext  as character    no-undo.
DEFINE VARIABLE v-file-name-ext     as character    no-undo.
define variable v-path              as character    no-undo.
define variable v-success           as logical      no-undo.
define variable v-espr-pack-num     as integer      no-undo.
define variable v-espr-pack-name    as character    no-undo.
define variable v-rcvd-pack         as logical      no-undo.
define variable v-custom-pack-name  as character no-undo .
define variable v-custom-pack-flag  as logical   no-undo .
define variable v-err-msg as character no-undo .
define variable v-ver-num as character no-undo .
define variable add-log-file-name0 as character no-undo .
define variable v-err-type as character no-undo .
define variable v-cmd-proc-handle as handle no-undo .
define variable v-cmd-code as integer no-undo .
define variable v-exch-file-date as character no-undo .
define variable v-return-error as integer no-undo .
define variable v-extsys-list as character no-undo .
def var i as int.



define buffer buf_ext-system         for ub.ext-system.
define buffer buf_esys-pck-keys      for ub.esys-pck-keys.
define temp-table tt-espcknum no-undo
  field tt-espr-pack-num  as integer
  field tt-espr-pack-name as character
  field tt-espr-pack-date as datetime /*доп. поле для SAP ERP*/
  index inum tt-espr-pack-num ascending
  index idate tt-espr-pack-date     ascending
.

do
for buf_ext-system
on error undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
:

   run get-version-num in parparentproc
    ( output v-ver-num
    ).
    assign
        v-action = entry( 1, p-parameter-string )
        v-cur-db-num = integer( entry( 2, p-parameter-string ) )
    .
    if num-entries(p-parameter-string) > 2 then do:
      assign
      v-extsys-list =  entry( 3, p-parameter-string )
      v-esys-db-num  = integer( entry( 4, p-parameter-string ) )
      .
    end.
    v-pack-num = -1.
    if num-entries(p-parameter-string) > 4 then do:
      assign
      v-pack-num = integer( entry( 4, p-parameter-string ) )
      v-cr-db-num  = integer( entry( 5, p-parameter-string ) )
      .
    end.

    run write-log in p-log-handle (
          input 1
        , input substitute( "Загрузка данных из внешних систем..." )
    ).
    run xmlischn_fill in this-procedure ( input 4, input 2).
    run xmlischn_fill in this-procedure ( input 4, input 3).
    run xmlischn_fill in this-procedure ( input 11, input 4).
    run xmlischn_fill in this-procedure ( input 12, input 5).
    run xmlischn_fill in this-procedure ( input 13, input 4).
    run xmlischn_fill in this-procedure ( input 18, input 4).
    run xmlischn_fill in this-procedure ( input 18, input 8).
    run xmlischn_fill in this-procedure ( input 18, input 12).
    run xmlischn_fill in this-procedure ( input 18, input 16).
    run xmlischn_fill in this-procedure ( input 18, input 20).
    run xmlischn_fill in this-procedure ( input 18, input 24).
    run xmlischn_fill in this-procedure ( input 20, input 4).

    _ext-system:
    do i = 1 to num-entries(v-extsys-list)
    on error undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1)):
      v-esys-id = int(entry(i,v-extsys-list,';')).
      for each buf_ext-system no-lock
        where ( buf_ext-system.esys-have-import = yes
                and buf_ext-system.esys-db-num-imp = v-cur-db-num
            and (v-esys-id = 0
                or
                (buf_ext-system.esys-id = v-esys-id
                and
                buf_ext-system.db-num = v-esys-db-num)
                )
                )
          or
          (buf_ext-system.esys-have-export = yes
        and buf_ext-system.exp-conf-wait = integer({&openxml-exp-conf-wait})
        and buf_ext-system.esys-db-num-exp = v-cur-db-num
        and (v-esys-id = 0
          or
          (buf_ext-system.esys-id = v-esys-id
          and
          buf_ext-system.db-num = v-esys-db-num)
        ))

      on error undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
      :
        assign
        add-log-file-name = substring( log-file-name, 1, r-index( log-file-name, '.':u) - 1 ) + substitute( "-&1.LOG", buf_ext-system.esys-id )
        .
          v-success = no.
          assign
          g#esys-source-esys = buf_ext-system.esys-id
          .
          run bge/lockesys.p (
            input buf_ext-system.esys-id
            ,input buf_ext-system.db-num
            ,buffer buf_ext-system
            ,output v-success) no-error.
          if error-status:error
          or v-success = no
          then do:
              run write-log in p-log-handle (
                    input 2
                  , input return-value
              ).
              undo _ext-system, next _ext-system.
          end.
          if buf_ext-system.esys-have-import
          then do:
            case v-action:
              when "take":U then do:
                run write-log in p-log-handle (  input 2
                                                ,substitute("Прием пакетов данных из ВС &1 '&2'"
                                                          , buf_ext-system.esys-id
                                                          , buf_ext-system.esys-name ) ) .
              end.
              when "analys":U then do:
                run write-log in p-log-handle (  input 2
                                                ,substitute("Разбор данных из ВС &1 '&2'"
                                                        , buf_ext-system.esys-id
                                                        , buf_ext-system.esys-name ) ) .
              end.
              when "take+analys":U then do:
                run write-log in p-log-handle (  input 2
                                                ,substitute("Прием и разбор пакетов данных из ВС &1 '&2'"
                                                          , buf_ext-system.esys-id
                                                          , buf_ext-system.esys-name ) ) .

              end.
              otherwise do:
                message vss-workfile vss-revision vss-description skip
                        substitute( "Не предусмотрена операция &1", v-action )
                        view-as alert-box error.
                return error.
              end.
            end case.

            /*начинаем сканирование директории*/
            assign
              v-espr-pack-num = -1
              v-rcvd-pack = false
            .
            v-custom-pack-name = ''.
            run bge/espcknum.p ( input "get":U
                          ,input buf_ext-system.esys-id
                          ,input buf_ext-system.db-num
                          ,input buf_ext-system.delivery-method
                          ,input oxml-exch-dir
                          ,input oxml-heap-dir
                          ,input-output v-espr-pack-num
                          ,input-output v-custom-pack-name
                          ,output v-espr-pack-name
                          ,output v-source-dir
                          ,output v-target-dir
                          ,output v-temp-dir
                          ,output v-log-file-name
                          ,output v-list-file-name
                          ,output v-custom-pack-flag
                        ) no-error.
            if error-status:error then do:
              run write-log in p-log-handle (
                                              input 2
                                            , substitute("&1 Ошибка при генерации номера пакета.&2&3&2&4"
                                                          ,vss-workfile
                                                          ,{&new-line}
                                                        ,substitute( "&1", error-status:get-message(error-status:num-messages) )
                                                        ,substitute( "&1", return-value )
                                                        )
                              ) .
              undo _ext-system, next _ext-system.
            end.
            if lookup( v-action, "take,take+analys":U ) <> 0 then do:

              /* копируем скопом все файлы из exch в heap */
              /*очищаем таблицу - чтобы туда потом написать названия файлов - они могут понадобиться в методе EXITE*/
              run filelist-clear in this-procedure .
              run bge/sxg-pack.p (
                            input parparentproc
                            ,input this-procedure:handle /*p-parent-handle*/ /*место определения write-to-lo и write-to-screen*/
                            ,input p-log-handle /*место определения write-log-and-file*/
                            ,input "get":U
                            ,input true
                            ,input ?
                            ,input v-source-dir
                            ,input v-target-dir
                            ,input v-temp-dir
                            ,input v-espr-pack-num /*p-esps-pack-num <> 0 потому что если надо переименовыват файлы с кривыми именами*/
                            ,input buf_ext-system.esys-id
                            ,input buf_ext-system.db-num
                            ,input v-cr-db-num
                            ,input buf_ext-system.delivery-method
                            ) no-error.
              if error-status:error then do:
                run write-log in p-log-handle ( input 2
                                                ,input substitute("&1 &2"
                                                          ,vss-workfile
                                                          ,return-value )
                                              ).
                undo _ext-system, next _ext-system.
              end.
            end.
            /* получение всех файлов, находящихся в heap, 
            для внешней системы типа OR APM (SPAR) - разибарются все файлы находящиеся в heap
            в дальнейшем после удачного разбора в обязательном порядке удаляются*/
            if buf_ext-system.delivery-method = integer({&esys-dm-contour-edi})
            or buf_ext-system.delivery-method = integer({&esys-dm-erp-1C-RN})
            then do:
              run get-num-namepack in this-procedure
                ( input v-target-dir
                , input buf_Ext-system.esys-id
                , input buf_Ext-system.db-num
                , input buf_ext-system.delivery-method
                ) 
              no-error.
              if error-status:error then do:
                if return-value begins "№"
                then do:
                  run write-log in p-log-handle (
                                                  input 2
                                                , substitute("Пакет &1 уже существует, прием остановлен. &2"
                                                              ,return-value
                                                              ,vss-workfile
                                                            )
                                  ) .
                end.
                else do:
                  run write-log in p-log-handle (
                                                  input 2
                                                , substitute("&1 Ошибка при создание списка пакетов для приема. &2&3&2&4"
                                                              ,vss-workfile
                                                              ,{&new-line}
                                                            ,substitute( "&1", error-status:get-message(error-status:num-messages) )
                                                            ,substitute( "&1", return-value )
                                                            )
                                  ) .
                end.
                undo _ext-system, next _ext-system.
              end.
            end.
            
            if lookup( v-action, "analys,take+analys":U ) <> 0 then do:
              rcvd-pack:
              do while TRUE
              on error undo, return error
              :
              v-custom-pack-name = ''.
              v-espr-pack-num = - abs(v-espr-pack-num).
              if buf_ext-system.delivery-method = integer({&esys-dm-exite-edi}) then do:
                find first temp-filelist no-error.
                if not available temp-filelist then do:
                  leave rcvd-pack.
                end.
                assign
                v-custom-pack-name = temp-filelist.file-name.
                delete temp-filelist.
              end.
              if buf_ext-system.delivery-method = integer({&esys-dm-contour-edi}) then do:
                find first tt-espcknum use-index inum no-error.
                if not available tt-espcknum then do:
                  leave rcvd-pack.
                end.
                assign
                v-custom-pack-name = tt-espcknum.tt-espr-pack-name.
                delete tt-espcknum.
              end.
              if buf_ext-system.delivery-method = integer({&esys-dm-erp-1C-RN})
              then do:
                find last buf_esys-pck-keys no-lock use-index pi no-error.
                if available buf_esys-pck-keys then do:
                  find first tt-espcknum where tt-espcknum.tt-espr-pack-num > buf_esys-pck-keys.espr-pack-num use-index inum no-error.
                  if available tt-espcknum then do:
                    v-espr-pack-num = tt-espcknum.tt-espr-pack-num.
                  end.
                end.
                find first temp-filelist no-error.
                if not available temp-filelist then do:
                  leave rcvd-pack.
                end.
                for each temp-filelist no-lock :
                    if integer(entry(2, temp-filelist.file-name, "_")) = abs(v-espr-pack-num)
                    then do :
                        assign v-custom-pack-name = temp-filelist.file-name.
                        leave.
                    end.
                    delete temp-filelist.
                end.    
              end.
              run bge/espcknum.p ( input "get":U
                            ,input buf_ext-system.esys-id
                            ,input buf_ext-system.db-num
                            ,input buf_ext-system.delivery-method
                            ,input oxml-exch-dir
                            ,input oxml-heap-dir
                            ,input-output v-espr-pack-num
                            ,input-output v-custom-pack-name
                            ,output v-espr-pack-name
                            ,output v-source-dir
                            ,output v-target-dir
                            ,output v-temp-dir
                            ,output v-log-file-name
                            ,output v-list-file-name
                            ,output v-custom-pack-flag
                          ) no-error.
                if error-status:error then do:
                  run write-log in p-log-handle (
                                                  input 2
                                                , substitute("&1 Ошибка при генерации номера пакета.&2&3&2&4"
                                                              ,vss-workfile
                                                              ,{&new-line}
                                                            ,substitute( "&1", error-status:get-message(error-status:num-messages) )
                                                            ,substitute( "&1", return-value )
                                                            )
                                  ) .
                  undo _ext-system, next _ext-system.
                end.
                if v-espr-pack-name = '' then do:
                  next rcvd-pack.
                end.
                assign
                v-file-name = v-target-dir + {&back-slash-char} + v-espr-pack-name +
                            (if v-custom-pack-flag
                              then ''
                              else 'xml')
                .
                run gbl/filename.p (
                                      input v-file-name
                                      ,output v-full-path
                                      ,output v-path
                                      ,output v-file-name
                                      ,output v-file-name-no-ext
                                      ,output v-file-name-ext
                                      ) no-error .
                if error-status :error then do:
                  /* исходный файл не найден, значит он еще не пришел */
                  leave rcvd-pack.
                end.
                if buf_ext-system.delivery-method = integer({&esys-dm-oracle-retail}) then do:
                  assign
                  add-log-file-name0 = add-log-file-name
                  add-log-file-name = add-log-file-name0 + {&delim-nws} + v-log-file-name + {&back-slash-char} + ora-rcpt_get-rcpt-name(v-file-name-no-ext) + ".LOG"
                  .
                  run gbl/dir-cre.p (
                                      input v-log-file-name
                                      ) no-error.
                  os-delete value(v-log-file-name + {&back-slash-char} + ora-rcpt_get-rcpt-name(v-file-name-no-ext) + ".LOG").
                end.
                v-err-type = ''.
                v-return-error = 0.
                run bge/cmdeigen.p (
                                    input parparentproc
                                    ,input this-procedure:handle
                                    ,input p-log-handle
                                    ,input buf_ext-system.esys-id
                                    ,input buf_ext-system.db-num
                                    ,input v-cur-db-num
                                    ,input v-full-path
                                    ,input v-espr-pack-num
                                    ,input add-log-file-name
                                    ) no-error.
              if error-status:error then do:
                v-return-error = 1.
              end.
              if not can-find(first  ub.esys-pck-rcvd no-lock
                                where ub.esys-pck-rcvd.esys-id  = buf_Ext-system.esys-id
                                  and ub.esys-pck-rcvd.db-num   = buf_Ext-system.db-num
                                  and ub.esys-pck-rcvd.espr-cr-db-num   = g#db-num
                                  and ub.esys-pck-rcvd.espr-pack-num = v-espr-pack-num
                                  )  /*пакет принят неполностью*/
              then do:
                v-return-error = 2.
              end.
                if v-return-error > 0 then do:
                if v-err-type = '' then do:
                  assign
                  v-err-type = {&ora-err-type-PROCESSING}.
                end.
                v-err-msg = substitute( "Ошибка при разборе файла &1.&2&3&2&4"
                                        , v-file-name
                                        ,{&new-line}
                                        , return-value
                                        , (if v-return-error = 1
                                          then trim( error-status :get-message( 1 ) )
                                          else "Пакет принят неполностью")
                                      )         .
                run write-log in p-log-handle (
                                                input 2
                                                ,input v-err-msg ).
                  run send-msg-to-email in parparentproc
                      ( input substitute( "ТН (ver &2) БД &1. Ошибка OXML при импорте пакета из ВС &2"
                                        , v-ver-num
                                        , v-cur-db-num
                                        , buf_ext-system.esys-id )
                      ,input v-err-msg
                      ,input (if buf_ext-system.delivery-method = integer({&esys-dm-oracle-retail})
                              then entry(num-entries(add-log-file-name, {&delim-nws}), add-log-file-name, {&delim-nws})
                              else '')
                      ) no-error .
                  if error-status :error then do:
                    run write-log in p-log-handle (
                      input 2
                    , input substitute( "&1. &3&2&4", vss-workfile, {&new-line}, error-status:get-message(1), return-value )
                                                      ) .
                  end.
                end. /*if error-status:error*/
                if buf_ext-system.delivery-method = integer({&esys-dm-oracle-retail}) then do:
                  if v-exch-file-date = "" then do:
                    run cur-time in this-procedure ( output v-today, output v-time).
                    v-exch-file-date = string(datetime(v-today, mtime), "99/99/9999 HH:MM:SS").
                  end.
                  run rul/ora-rcpt.p (
                                        input parparentproc
                                      ,input this-procedure:handle
                                      ,input p-log-handle
                                      ,input v-cmd-proc-handle
                                      ,input v-cmd-code
                                      ,input buf_ext-system.esys-id
                                      ,input v-espr-pack-num
                                      ,input v-file-name
                                      ,input v-exch-file-date
                                      ,input entry(num-entries(add-log-file-name, {&delim-nws}), add-log-file-name, {&delim-nws})
                                      ,input v-err-type) no-error.
                  if error-status:error then do:
                    /*а непонятно что делать*/
                    v-err-msg = substitute( "Ошибка при разборе файла &1&2Не удалось сформировать квитанцию для пакета.&2&3&2&4"
                                            , v-file-name
                                            ,{&new-line}
                                            , return-value
                                            , error-status:get-message(1)
                                          )         .
                    os-delete value(entry(num-entries(add-log-file-name, {&delim-nws}), add-log-file-name, {&delim-nws})).
                    assign
                    add-log-file-name = add-log-file-name0
                    .
                    run write-log in p-log-handle (
                                                    input 2
                                                    ,input v-err-msg
                                                                      ).
                    run send-msg-to-email in parparentproc
                      ( input substitute( "ТН (ver &2) БД &1. Ошибка OXML при импорте пакета из ВС &2"
                                        , v-ver-num
                                        , v-cur-db-num
                                        , buf_ext-system.esys-id )
                      ,input v-err-msg
                      ,input (if buf_ext-system.delivery-method = integer({&esys-dm-oracle-retail})
                              then entry(num-entries(add-log-file-name, {&delim-nws}), add-log-file-name, {&delim-nws})
                              else '')
                      ) no-error .
                    if error-status :error then do:
                    run write-log in p-log-handle (
                      input 2
                    , input substitute( "&1. &3&2&4", vss-workfile, {&new-line}, error-status:get-message(1), return-value )
                                                      ) .
                    end.

                  end.
                  if v-err-type = '' then  do:
                    os-delete value(entry(num-entries(add-log-file-name, {&delim-nws}), add-log-file-name, {&delim-nws})).
                  end.
                  assign
                  add-log-file-name = add-log-file-name0
                  .
                end.
                if v-return-error > 0
                and buf_ext-system.delivery-method <> integer({&esys-dm-exite-edi})
                then do:
                  return error ''.
                end.
                assign
                  v-rcvd-pack = true
                  v-espr-pack-num = v-espr-pack-num + 1
                .
                if ( v-pack-num <> -1
                    and v-espr-pack-num > v-pack-num
                  )
                  or lookup( v-action, "analys":U ) <> 0
                then do:
                  leave rcvd-pack.
                end.
              end.
            end.
            run gbl/del-file.p ( input v-temp-dir ) no-error .
            if error-status:error then do:
              run write-to-log( vss-workfile + {&space-char}
                                + substitute( "&1", return-value )
                              ).
            end.

            case v-action:
              when "take":U then do:
                run write-log in p-log-handle (  input 2
                                                ,substitute("Завершен прием пакетов данных из ВС '&1'", buf_ext-system.esys-name ) ) .
              end.
              when "analys":U then do:
                run write-log in p-log-handle (  input 2
                                                ,substitute("Завершен разбор данных из ВС '&1'", buf_ext-system.esys-name ) ) .
              end.
              when "take+analys":U then do:
                run write-log in p-log-handle (  input 2
                                                ,substitute("Завершен прием и разбор пакетов данных из ВС '&1'", buf_ext-system.esys-name ) ) .

              end.
            end case.
        end. /*if buf_ext-system.esys-have-export = yes*/
        add-log-file-name = ?.
      end.        /* for each buf_ext-system */
    end.  /* v-extsys-list */
    run write-log in p-log-handle (
          input 1
        , input "Загрузка данных по внешним системам завершена."
    ).
end.

procedure get-log-file-name :
define output parameter p-log-file-name as character no-undo .

  do
  on error undo, return error
  :
    p-log-file-name = add-log-file-name.
  end.

end procedure. /* get-log-file-name */

procedure set-err-type :
define input parameter p-err-type as character no-undo .
if v-err-type = '' then v-err-type = p-err-type. /*только первую ошибку устанавливаем*/
end procedure. /* set-err-type */


procedure set-exch-date-time :
define input parameter p-exch-file-date as character no-undo .
v-exch-file-date = p-exch-file-date.
end procedure. /* set-exch-date-time */


procedure cb_fill-filelist :
define input parameter p-file-name as character no-undo .
define input parameter p-dm as integer no-undo .
define variable v-file-name as character no-undo .

do
on error undo, return error
:
  
  find first temp-filelist where
            temp-filelist.file-name = p-file-name no-error.
  
  if p-dm = integer({&esys-dm-contour-edi})
  then do:

    if not available temp-filelist then do:
      create temp-filelist.
      if num-entries(p-file-name, '.':u) > 1
      then do:
        /* файл имеет расширение */
        assign
          temp-filelist.file-extension = entry(num-entries(p-file-name, '.':u), p-file-name,  '.':u )
          temp-filelist.file-name-no-ext = entry(num-entries(p-file-name, '.':u) - 1, p-file-name, '.':u )
        .
      end.
      else do:
        /* файл имеет пустое расширение */
        assign
          temp-filelist.file-extension = ''
          temp-filelist.file-extension = p-file-name
        .
      end.
      assign
      temp-filelist.file-name = p-file-name.
      release temp-filelist.
    end.

    
    
  end.
  else do:
    if not available temp-filelist then do:
      v-file-name = p-file-name.
      entry(1, v-file-name, "_") = "".
      create temp-filelist.
      assign
      temp-filelist.file-name = p-file-name
      temp-filelist.full-name = v-file-name
      .
      release temp-filelist.
    end.
  end.
end.

end procedure. /* cb_fill-filelist */

procedure get-num-namepack : /*получение имени и номеров пакетов для OR APM (SPAR), которые будут обработаны*/
define input parameter p-target-dir as character no-undo .
define input parameter p-esys-id as integer no-undo .
define input parameter p-db-num as integer no-undo .
define input parameter p-ext-sys-met as integer no-undo .

define variable datestr as character no-undo.
define variable timestr as character no-undo.

do
on error undo, return error
:
  define variable xml-source as character no-undo.
  define variable xml-result as character no-undo. 
  define variable java as character no-undo.
  define variable saxon as character no-undo.
  define variable xsl as character no-undo.
  define variable v-l-err as logical no-undo.
  define variable ii as integer no-undo.    
  if p-ext-sys-met <> integer({&esys-dm-contour-edi})
  then do:
    run filelist-init in this-procedure
    (input p-target-dir
    ,input false
    ,input ""
    ,input ""
    ) no-error.
    if error-status:error then do:
      undo, return error .
    end.
  end.

  if p-ext-sys-met <> integer({&esys-dm-contour-edi}) then do:
    for each temp-filelist:
      create tt-espcknum.
      if p-ext-sys-met = integer({&esys-dm-erp-1C-RN}) then do:
/*
        if not temp-filelist.file-name begins "azs_up_th0" and not temp-filelist.file-name begins "o" then do:
          delete tt-espcknum .
          next.
        end.
        if temp-filelist.file-name begins "azs_up_th0" then do:
*/        if num-entries(temp-filelist.file-name, "_") <> 3 then do :
              delete temp-filelist.
              next.
          end.   
          if v-espr-pack-num > integer (entry (2, temp-filelist.file-name-no-ext, "_"))
          then next .  
          assign
            tt-espcknum.tt-espr-pack-name = temp-filelist.file-name
            tt-espcknum.tt-espr-pack-num = integer (entry (2, temp-filelist.file-name-no-ext, "_"))
          no-error.
          if error-status:error then do: /* ошибка возникнет при присвоение, если неверное имя пакета - например начинается не с номера пакета, пропускаем идем дальше.*/
            delete tt-espcknum .
          end.
          
/*
        end.
        else do:
          assign
            tt-espcknum.tt-espr-pack-name = temp-filelist.file-name-no-ext
            tt-espcknum.tt-espr-pack-num = integer (substring (temp-filelist.file-name-no-ext, 2))
          no-error.
          if error-status:error then do: /* ошибка возникнет при присвоение, если неверное имя пакета - например начинается не с номера пакета, пропускаем идем дальше.*/
            delete tt-espcknum .
          end.
          else do:
            if tt-espcknum.tt-espr-pack-name <> "o":U + string( tt-espcknum.tt-espr-pack-num, "999999999":U ) then delete tt-espcknum .
          end.
          next.
        end.
*/
      end.
    end.
    
  end.
  else do:
    ii = 0.
    for each temp-filelist where temp-filelist.file-name begins "fail" 
      and  not (temp-filelist.file-name matches "*Stsmsg*"
                or  temp-filelist.file-name matches "*unknown*") :
      ii = ii + 1.
      create tt-espcknum.
      assign
        tt-espcknum.tt-espr-pack-name = temp-filelist.file-name + "."
        tt-espcknum.tt-espr-pack-num = ii
      no-error.      
    end.
    for each temp-filelist where temp-filelist.file-name begins "ok" 
      and  not (temp-filelist.file-name matches "*Stsmsg*"
                or  temp-filelist.file-name matches "*unknown*") :
      ii = ii + 1.
      create tt-espcknum.
      assign
        tt-espcknum.tt-espr-pack-name = temp-filelist.file-name + "."
        tt-espcknum.tt-espr-pack-num = ii
      no-error.
    end.
    for each temp-filelist where temp-filelist.file-name begins "ORDRSP" :
      ii = ii + 1.
      create tt-espcknum.
      assign
        tt-espcknum.tt-espr-pack-name = temp-filelist.file-name + "."
        tt-espcknum.tt-espr-pack-num = ii
      no-error.
    end.
    for each temp-filelist where temp-filelist.file-name begins "DESADV" :
      ii = ii + 1.
      create tt-espcknum.
      assign
        tt-espcknum.tt-espr-pack-name = temp-filelist.file-name + "."
        tt-espcknum.tt-espr-pack-num = ii
      no-error.            
    end.
    
    
  end.
  for each temp-filelist where temp-filelist.file-name begins "ORDRSP" :
    ii = ii + 1.
    create tt-espcknum.
    assign
      tt-espcknum.tt-espr-pack-name = temp-filelist.file-name + "."
      tt-espcknum.tt-espr-pack-num = ii
    no-error.
  end.
  for each temp-filelist where temp-filelist.file-name begins "DESADV" :
    ii = ii + 1.
    create tt-espcknum.
    assign
      tt-espcknum.tt-espr-pack-name = temp-filelist.file-name + "."
      tt-espcknum.tt-espr-pack-num = ii
    no-error.            
  end.


  if v-l-err then
    run write-log in p-log-handle (
          input 1
        , input substitute( "При преобразовании файла(ов) возникли ошибки. Проверьте целостность xml пакетов.")
    ).

end.

end procedure. /* get-num-namepack */