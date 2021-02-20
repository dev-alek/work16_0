/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Программа формирования файла Excel из шаблона.

Автор: Белоусов Илья Александрович
Дата создания: 04/12/06
Author: Ilia Belousov
Creation date: 04/12/06

Input:

Output:

*/

{ gbl/paramls.i  }
define input-output parameter table for temp-param .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Программа формирования файла Excel из шаблона.".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }

&scop xlMinimized  -4140
&scop xlNormal     -4143

define buffer buf_temp-param for temp-param .

    define variable v-macroxlt-counter          as integer          no-undo .

    define variable chExcelApp                  as com-handle       no-undo .
    define variable chWorkBook                  as com-handle       no-undo .
    define variable chCodeModule                as com-handle       no-undo .

    define variable v-counter                   as integer          no-undo .
    define variable v-excel-file-name           as character        no-undo .
    define variable v-read-password             as character        no-undo .
    define variable v-write-password            as character        no-undo .
    define variable v-excel-dir-name            as character        no-undo .

    define variable v-ind                       as integer          no-undo .
    define variable v-excel-macro-file          as character        no-undo .
    define variable v-ok                        as logical          no-undo .
    define variable v-column-list               as character        no-undo .
    define variable v-excel-visible-char        as character        no-undo .
    define variable v-template-file-name        as character        no-undo .
    define variable v-vb-file-name              as character        no-undo .
    define variable v-default-excel-file-name   as character        no-undo .
    define variable v-data-header-filename      as character        no-undo .
    define variable v-data-filename             as character        no-undo .
    define variable v-temp-string               as character        no-undo .
    define variable v-version                   as character        no-undo .
    define variable v-version-dec               as decimal          no-undo .
    define variable v-found-reg-entry           as logical          no-undo .
    define variable v-trusted                   as character        no-undo .

do
on error undo, return error
:
    /* определяем имя файла и параметры сохранения */
    run paramls-read in this-procedure (
          input {&paramls-saveas}
        , input {&paramls-excel-file-name}
        , input "":U
        , output v-excel-file-name
    ).
    run paramls-read in this-procedure (
          input {&paramls-saveas}
        , input {&paramls-saveas-read-password}
        , input  "":U
        , output v-read-password
    ).

    run paramls-read in this-procedure (
          input  {&paramls-saveas}
        , input  {&paramls-saveas-write-password}
        , input  "":U
        , output v-write-password
    ).
    run paramls-read in this-procedure (
          input {&paramls-option}
        , input {&paramls-option-visible}
        , input "true":U
        , output v-excel-visible-char
    ).
    run paramls-read (
          input {&paramls-template}
        , input {&paramls-template-file-name}
        , input "":U
        , output v-template-file-name
    ) .
    run paramls-read (
          input {&paramls-template}
        , input {&paramls-vb-file-name}
        , input "":U
        , output v-vb-file-name
    ) .
    run paramls-read (
          input {&paramls-data}
        , input {&paramls-data-header-filename}
        , input "":U
        , output v-data-header-filename
    ) .
    run paramls-read (
          input {&paramls-data}
        , input {&paramls-data-filename}
        , input "":U
        , output v-data-filename
    ) .
    define variable v-file-no-open-string   as character    no-undo.
    define variable v-file-no-open          as logical      no-undo.
    run paramls-read (
          input {&paramls-file}
        , input {&paramls-file-no-open}
        , input "yes":U
        , output v-file-no-open-string
    ) .
    assign
        v-file-no-open = ( v-file-no-open-string = "yes":U )
    .
    create "Excel.Application" chExcelApp no-error .
    if error-status :error then do:
        message
        "Ошибка при запуске Excel" skip
        error-status :get-message(1) skip
        view-as alert-box error .
        undo, return error .
    end.
/*    assign*/
/*        chExcelApp :Visible = lookup(v-excel-visible-char, "true,yes":U) > 0*/
/*    .*/
    assign
/*        chExcelApp :WindowState = {&xlNormal}*/
        chExcelApp :WindowState = {&xlMinimized}
/*        chExcelApp :Visible     = True*/
        chExcelApp :Visible     = False
        chExcelApp :Interactive = False
    .
      assign
        v-version = chExcelApp :version
      no-error.
      assign
        v-version-dec = decimal(v-version)
      no-error .
      if error-status:error then do:
        message
        "Не удалось определить версию Excel"
        view-as alert-box error .
        release object chCodeModule no-error .
        release object chWorkBook   no-error .
        release object chExcelApp   no-error .
        undo, return error .
      end.
      if v-version-dec > 9 then do:
        run gbl/getregvl.p
                        ( "HKEY_CURRENT_USER":U
                        , "SOFTWARE":U
                        , "Microsoft\Office\" + string(v-version-dec, ">9.9":U) + "\Excel\Security":U
                        , "AccessVBOM":U
                        , output v-found-reg-entry
                        , OUTPUT v-trusted) no-error .
        if error-status:error then do:
          message
          "Не удалось определить политику безопасности для данной версии Excel"
          view-as alert-box error .
          release object chCodeModule no-error .
          release object chWorkBook   no-error .
          release object chExcelApp   no-error .
          undo, return error .
        end.
        if not v-found-reg-entry
        or trim(v-trusted) = "0":U then do:
          message
          "На Вашей машине запрещен программный доступ к VisualBasicProject" skip
          "В связи с этим вывод в EXCEL невозможен" skip
          "возможное решение проблемы:" skip
          "открыть в EXCEL диалог <Сервис\Макрос\Безопасность> (<Tools\Macro\Security>)" skip
          "выбрать закладку <Надежные источники> (<Trusted Sources>)  и включить галочку" skip
          "<Доверять доступ Visual Basic Project> (<Trust access to Visual Basic Project>)" skip
          "Затем закрыть Excel"
          view-as alert-box ERROR.
          release object chCodeModule no-error .
          release object chWorkBook   no-error .
          release object chExcelApp   no-error .
          undo, return error .
        end.
      end.

    /* Ни в коем случае нельзя запускать EXCEL в невидимом режиме */
    /* он в этом случае работает в 4 раза медленнее. */
    /* Почему это происходит неизвестно. */
    /* Кроме того, при выводе отчета в строке состояния Excel будет выводиться */
    /* количество обработанных команд */
    /*  assign*/
    /*    chExcelApp :WindowState = {&xlMinimized}*/
    /*    chExcelApp :Visible     = False*/
    /*    chExcelApp :Interactive = False*/
    /*  .*/

    assign
        v-temp-string        = v-template-file-name
        v-template-file-name = search( v-template-file-name )
    .
    if v-vb-file-name = ?
    then do:
        message
                 vss-workfile vss-revision vss-description
            skip "Не найден шаблон Excel."
            skip(1)
            skip "Необходим шаблон:" v-temp-string
        view-as alert-box error.
        undo, return error .
    end.
/*    assign*/
/*        chExcelApp :Visible = lookup(v-excel-visible-char, "true,yes") > 0*/
/*    .*/
    assign
        chWorkBook = chExcelApp :Workbooks :Add( v-template-file-name )
    .
    assign
        chCodeModule = chWorkbook :VBProject :VBComponents :Item(1) :CodeModule
    .
    define variable v-book-name    as character    no-undo.
    assign
        v-book-name = chWorkBook :CodeName
    .
    assign
        v-temp-string  = v-vb-file-name
        v-vb-file-name = search( v-vb-file-name )
    .
    if v-vb-file-name = ?
    then do:
        message
                 vss-workfile vss-revision vss-description
            skip "Не найдена программа обработки шаблона Excel."
            skip(1)
            skip "Шаблон:" v-template-file-name
            skip "Необходима программа:" v-temp-string
        view-as alert-box error.
        undo, return error .
    end.
    run load-basic in this-procedure (
          input v-vb-file-name
        , input v-book-name
        , input v-template-file-name
        , input v-data-header-filename
        , input v-data-filename
    ).

    assign
        v-ok = chWorkbook :LoadBasic
    .
    assign
        v-ok = chWorkbook :StartApp
    .

    for each buf_temp-param
       where buf_temp-param.param-code = {&paramls-command}
    by buf_temp-param.param-sub-code
    on error undo, leave
    :
        assign
            v-ok = chWorkbook :DDEExecCommand( buf_temp-param.param-value )
        .
    end.

    /*run clear-macro in this-procedure .*/
    /*
      Ставим no-error - гасим возможные ошибки доступа к свойствам ком-объектов
      Microsoft утверждает что иногда доступа нет, рекомендует молча проглатывать ошибки
      http://support.microsoft.com/kb/165435
    */
    assign
        chExcelApp:DisplayAlerts = False
    no-error .
    assign
        v-default-excel-file-name = chWorkBook:FullName
    no-error .
    /*
        xpression.SaveAs
        (Filename
        ,FileFormat
        ,Password
        ,WriteResPassword
        ,ReadOnlyRecommended
        ,CreateBackup
        ,AddToMru
        ,TextCodePage
        ,TextVisualLayout
        )

    */
/*    assign*/
/*        chExcelApp :WindowState = {&xlMinimized}*/
/*    .*/
    if v-excel-file-name = "":U
    or v-excel-file-name = ?
    then do:
        run gbl/_tmpfile.p (
              input  ""
            , input  ".xls"
            , output v-excel-file-name
        ).
        run gbl/d-file.p (
              input-output v-excel-file-name       /* p-file-id           */
            , input-output v-excel-dir-name        /* p-file-directory    */
            , input  (" Все файлы EXCEL (*.xls) ") /* p-filter-names      */
            , input  ("*.xls":U)                   /* p-filter-values     */
            , input  {&comma-char}                 /* p-filter-delimiter  */
            , input  (".xls":U)                    /* p-default-extension */
            , input  no                            /* p-must-exist        */
            , input  yes                           /* p-save-as           */
            , input  yes                           /* p-use-filename      */
            , input  "Введите имя файла"           /* p-title             */
            , output v-ok                          /* p-choose            */
        ) .
        if v-ok <> true
        then do:
            assign
                chWorkBook :Saved = true
            .
            assign
                v-ok = chWorkBook :close no-error 
            .
            release object chCodeModule no-error .
            release object chWorkBook   no-error .
            assign
                v-ok = chExcelApp:Quit()
            no-error.
            release object chExcelApp   no-error .
            undo, return error "quit":U .
        end.
        if search( v-excel-file-name ) <> ?
        then do:
            os-delete value( v-excel-file-name ).
        end.
    end.
    if v-read-password <> "":U
    and v-write-password <> "":U
    then do:
        assign
            v-ok = chWorkBook :SaveAs( v-excel-file-name, {&xlNormal}, v-read-password, v-write-password , , , ) no-error
        .
    end.
    else do:
        if v-write-password <> "":U
        then do:
            assign
                v-ok = chWorkBook :SaveAs( v-excel-file-name, {&xlNormal}, , v-write-password , , , ) no-error
            .
        end.
        else do:
            assign
                v-ok = chWorkBook :SaveAs( v-excel-file-name, {&xlNormal} , , , , , ) no-error
            .
        end.
    end.
    assign
        chExcelApp :DisplayAlerts = True
    .
    assign
        v-excel-file-name = chWorkBook :FullName
    .
    if v-excel-file-name = v-default-excel-file-name
    or v-excel-file-name = ?
    then do:
        release object chCodeModule no-error .
        release object chWorkBook   no-error .
        release object chExcelApp   no-error .

        message
            "Ошибка при сохранении файла"
            skip "Сохраните Excel файл вручную"
        view-as alert-box information .
    end.
    else do:
        assign
            chWorkBook :Saved = true
        .
        assign
            v-ok = chWorkBook :close no-error
        .
        release object chCodeModule no-error .
        release object chWorkBook   no-error .
        assign
            v-ok = chExcelApp:Quit()
        no-error.
        release object chExcelApp   no-error .
        run paramls-append in this-procedure (
              input {&paramls-file}
            , input {&paramls-file-out-list}
            , input v-excel-file-name
        ).
        if v-file-no-open = no
        then do:
            define variable v-excel-file-list    as character    no-undo.
            define variable v-excel-file-count   as integer      no-undo.
            run paramls-read in this-procedure (
                  input {&paramls-file}
                , input {&paramls-file-out-list}
                , input "":U
                , output v-excel-file-list
            ).
            assign
                v-excel-file-count = num-entries( v-excel-file-list )
            .
            do v-counter = 1 to v-excel-file-count
            :
                assign
                    v-excel-file-name = entry( v-counter, v-excel-file-list )
                .
                run rep/killspac.p (
                    input-output v-excel-file-name
                ).
                run gbl/open_url.p (
                    input v-excel-file-name
                ).
            end.
        end.
    end.

end.


procedure append-macro-line :
define input  parameter p-macro-str as character no-undo .

do
on error undo, return error return-value
:
    assign
        v-macroxlt-counter = v-macroxlt-counter + 1
    .
    assign
        v-ok = chCodeModule :InsertLines( v-macroxlt-counter, p-macro-str )
    .
end.

end procedure. /* append-macro-line */

procedure export-test-macro :

  assign
    v-ind = 0
  .

  do
  on error undo, return error return-value
  :
    run append-macro-line (input 'Sub HelloWorld()').
    run append-macro-line (input '  MsgBox "HelloWorld"').
    run append-macro-line (input 'End Sub').
  end.

end procedure. /* export-test-macro */

procedure load-basic :
define input parameter p-vb-file-name           as character        no-undo.
define input parameter p-book-name              as character        no-undo.
define input parameter p-template-file-name     as character        no-undo.
define input parameter p-data-header-filename   as character        no-undo.
define input parameter p-data-filename          as character        no-undo.

    define variable v-command-string    as character    no-undo.

  assign
    v-ind = 0
  .
  do
  on error undo, return error return-value
  :
    run append-macro-line ( input 'Sub LoadBasic').
/*    run append-macro-line ( input '  Application.ScreenUpdating = False').*/
/*    run append-macro-line ( input '  Application.Interactive = False').*/
    assign
        v-command-string = substitute( '  VBAProject.&1.VBProject.VBComponents.Import "&2"'
                                , p-book-name
                                , p-vb-file-name
                           )
    .
    run append-macro-line ( input v-command-string ).
    run append-macro-line ( input '  Application.Interactive = True').
    run append-macro-line ( input '  Application.ScreenUpdating = True').
    run append-macro-line ( input 'End Sub').
    run append-macro-line ( input 'Sub StartApp').
    run append-macro-line ( input 'Dim mModule As Object').
    run append-macro-line ( input 'Dim liCount As Long').
    run append-macro-line ( input '  Application.ScreenUpdating = False').
    run append-macro-line ( input '  Application.Interactive = False').
    assign
        v-command-string = substitute( '  call VBAProject.startFormFromTemplate ("&1", "&2")'
                                , p-data-header-filename
                                , p-data-filename
                           )
    .
    run append-macro-line ( input v-command-string ).
    run append-macro-line ( input substitute( 'For Each mModule In VBAProject.&1.VBProject.VBComponents', p-book-name ) ).
    run append-macro-line ( input 'If mModule.Type = 1 Then').
    run append-macro-line ( input substitute( '    VBAProject.&1.VBProject.VBComponents.Remove VBAProject.&1.VBProject.VBComponents(mModule.Name)', p-book-name ) ).
    run append-macro-line ( input 'End If').
    run append-macro-line ( input 'Next mModule').
    run append-macro-line ( input '  Application.Interactive = True').
    run append-macro-line ( input '  Application.ScreenUpdating = True').
    run append-macro-line ( input substitute( 'For Each mModule In VBAProject.&1.VBProject.VBComponents', p-book-name ) ).
    run append-macro-line ( input '    liCount = mModule.CodeModule.CountOfLines').
    run append-macro-line ( input '    mModule.CodeModule.DeleteLines 1, liCount').
    run append-macro-line ( input 'Next mModule').
    run append-macro-line ( input 'End Sub').
  end.

end procedure. /* load-basic */


procedure clear-macro :

  /* удалить все макросы в составе файла */

  define variable v-num-lines as integer   no-undo .

  do
  on error undo, return error return-value
  :
    assign
      v-num-lines = chCodeModule :CountOfLines
    .
    chCodeModule :DeleteLines(1, v-num-lines) .
  end.

end procedure. /* clear-macro */