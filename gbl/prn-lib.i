/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Библиотека процедур для печати

Автор: Бахтадзе Наталья Викторовна
Дата создания: 10/17/03
Author: Bakhtadze Natalya
Creation date: 10/17/03

*/

&if defined(prn-lib_i) = 0 &then
&glob prn-lib_i

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

&if "{2}" = "" &then
  &scoped-define PrnLibStream PrnLibStream
&else
  &scoped-define PrnLibStream {2}
&endif

define {1} stream {&PrnLibStream}.

procedure prn-lib-get-report-name :
define input parameter parParentProc  AS WIDGET-HANDLE NO-UNDO.
define output parameter p-report-name as character no-undo .

define variable v-report-num as integer no-undo .

  do
  on error undo, return error
  :
    run get-report-num  in parParentProc(output v-report-num).
&if defined(DF_NAME) = 0 &then
&global-define DF_Name        "rpt"
&endif
    assign
    p-report-name = string( session:temp-directory +
                           {&DF_Name} + string( v-report-num ) )
    .

  end.

end procedure. /* prn-lib-get-report-name */

procedure prn-lib-prn-file :
define input parameter parParentProc  AS WIDGET-HANDLE NO-UNDO.
define input parameter p-DIsabledoptions as integer no-undo .

define variable v-report-name as character no-undo .
define variable v-user-action as character no-undo .
define variable v-printed as logical no-undo .
define variable v-exist as logical no-undo .

  do
  on error undo, return error
  :
    
    run prn-lib-get-report-name  in this-procedure (
                                                      input parParentProc
                                                      ,output v-report-name
                                                    ).

    /* Проверка на пустой файл */
    { gbl/filenmln.i v-report-name 2 v-exist }

    if NOT v-exist then DO:
      Message
      "Нет заданий на печать ! "
      view-as alert-box .
      Return  .
    End.

    run gbl/prnfilen.w
      (input  ""
      ,input  p-DisabledOptions
      ,input  string(v-report-name )
      ,input  7
      ,output v-user-action
      ,output v-printed
      ) .

    /* возвращаем признак того, была ли напечатана форма */
    if v-printed then do:
      return "YES" .
    end.
    else do:
      return "NO" .
    end.
  end. /*doe*/

end procedure. /* prn-lib-prn-file */

procedure prn-lib-open-stream :
define input parameter parParentProc  AS WIDGET-HANDLE NO-UNDO.
define input parameter p-page-size    as integer no-undo .
define input parameter p-is-stream    as logical no-undo .
define input parameter p-append       as logical no-undo .


define variable v-report-name as character no-undo .

  do
  on error undo, return error
  :

    run prn-lib-get-report-name  in this-procedure (
                                                       input parParentProc
                                                      ,output v-report-name
                                                    ).

    if p-is-stream then do:
      if p-append then do:
        output stream {&PrnLibStream} to value( v-report-name )
        page-size value(p-page-size) append .
      end.
      if not p-append then do:
        output stream {&PrnLibStream} to value( v-report-name )
        page-size value(p-page-size) .
      end.
    end.
    if not p-is-stream then do:
      if p-append then do:
        output to value( v-report-name )
        page-size value(p-page-size) append .
      end.
      if not p-append then do:
        output to value( v-report-name )
        page-size value(p-page-size) .
      end.
    end.
  end.

end procedure. /* prn-lib-open-stream */


procedure prn-lib-open-exp :
define input parameter parParentProc  AS WIDGET-HANDLE NO-UNDO.
define input parameter p-is-stream    as logical no-undo .
define input parameter p-is-append    as logical no-undo .
define output parameter p-ReportFileName as char init "report" no-undo.
define output parameter p-process as logical no-undo .


define variable glog as logical no-undo .

  do
  on error undo, return error
  :

      SYSTEM-DIALOG GET-FILE p-ReportFileName
              TITLE      "Укажите путь"
              FILTERS "Текстовый файл (*.txt)"   "*.txt"
              ASK-OVERWRITE
              CREATE-TEST-FILE
              SAVE-AS
              USE-FILENAME
              DEFAULT-EXTENSION "txt"
              UPDATE glog
              .
     if not glog then  return.
    p-ReportFileName = trim( string( p-ReportFileName ) ) .
    if p-is-stream then do:
       if p-is-append then do:
         OUTPUT stream {&PrnLibStream} TO value ( p-ReportFileName ) PAGE-SIZE 0 append.
       end.
       else do:
         OUTPUT stream {&PrnLibStream} TO value ( p-ReportFileName ) PAGE-SIZE 0.
       end.
    end.
    else do:
       if p-is-append then do:
         OUTPUT TO value ( p-ReportFileName ) PAGE-SIZE 0 append.
       end.
       else do:
         OUTPUT TO value ( p-ReportFileName ) PAGE-SIZE 0.
       end.
    end.
    p-process = yes.
  end.

end procedure. /* prn-lib-open-exp */


procedure prn-lib-reportviewer-report-name :
  define input parameter parParentProc  AS WIDGET-HANDLE NO-UNDO.
  define input parameter p-report-name-html as character no-undo .
  define variable ii                  as integer no-undo .
  define variable v-report-name       as character no-undo .
  define variable v-fill-path-RepView as character no-undo.
  
  if search("exe\ReportViewer\reportviewer.exe") <> ? then
  do:
    v-fill-path-RepView = search("exe\ReportViewer\reportviewer.exe").
  end.
  else
  do:
    message "Не найдена программа просмотра отчёта!" view-as alert-box error.
  end.

  do ii = 1 to NUM-ENTRIES (p-report-name-html).
    v-report-name = ENTRY (ii,p-report-name-html).
    if search(v-report-name) = ? then
    do:
      message "Не найден файл отчёта: " v-report-name view-as alert-box error.
      return error.
    end.
  end.

  os-command no-wait value(v-fill-path-RepView + " " + p-report-name-html).

end procedure. /* prn-lib-reportviewer-report-name */

&endif

/* $Workfile$ e n d */