/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Статический класс со значениями параметров из ini-файла

Автор: Молотков Сергей
Дата создания: 14/02/18
Author: Molotkov Sergey
Creation date: 14/02/18

*/
/* 03/VIII-2018 Временно добавлены переменные для печати, чтобы исключить использование prn-lib.i.
                Из ini-файла не берутся.
                Когда их здесь наберётся достаточно много - подумаем, куда их вынести.
*/   
block-level on error undo, throw.

class ibs.th.gbl.gbl-inipar: 

  define static property conPar as character no-undo
    get.
    private set.
  define static property conParKeyName as character no-undo
    initial "секция REP-SETS ключ ConPar в .ini файле"
    get.
    
  define static property conParFlt as character no-undo
    get.
    private set.
  define static property conParFltKeyName as character no-undo
    initial "секция REP-SETS ключ ConParFlt в .ini файле"
    get.
    
  define static property logDir as character no-undo
    get.
    private set.
  define static property logDirKeyName as character no-undo
    initial "секция REP-SETS ключ logDir в .ini файле"
    get.
    
  define static property comstr as character no-undo
    get.
    private set.
  define static property comstrKeyName as character no-undo
    initial "секция revision ключ comstr в .ini файле"
    get.

  define static property dirflrvs as character no-undo
    get.
    private set.
  define static property dirflrvsKeyName as character no-undo
    initial "секция revision ключ dirflrvs в .ini файле"
    get.

  define static property dirflpmp as character no-undo
    get.
    private set.
  define static property dirflpmpKeyName as character no-undo
    initial "секция revision ключ dirflpmp в .ini файле"
    get.

  /* ----- переменные для печати ----- */
  define private static variable cntxt-report-num as integer no-undo initial 0 .
    // для формирования имени файла отчетов - обеспечивает уникальность имён временных файлов между сессиями
     
  /* ----- end_of переменные для печати ----- */   
    
  constructor static gbl-inipar():
    ibs.th.gbl.gbl-inipar:InitPar ( ) .
  end constructor.

  method public static void InitPar ( ) :
    get-key-value section "rep-sets" key "ConPar"    value conPar .
    get-key-value section "rep-sets" key "ConParFlt" value conParFlt .
    get-key-value section "rep-sets" key "logDir"    value logDir .
    get-key-value section "revision" key "comstr"    value comstr .
    get-key-value section "revision" key "dirflrvs"  value dirflrvs .
    get-key-value section "revision" key "dirflpmp"  value dirflpmp .
    if logDir = ?
    then do :
      logDir = ".\" .
    end .
    else do :
      logDir = right-trim(logDir, "\") .
      logDir = right-trim(logDir, "/") .
      logDir = logDir + "\" .
    end. 
  end method. // end_of InitPar

  /* ----- переменные для печати ----- */
  method public static character prn-lib-get-report-name ( ) :
  define variable v-report-name as character no-undo .
    v-report-name = prn-lib-get-report-name ("rpt") .
    return v-report-name .
  end method.
  method public static character prn-lib-get-report-name (input p-df-name as character) :
  define variable v-report-name as character no-undo .
    assign
      cntxt-report-num = dynamic-next-value( "next-report":U, "ubflt":U ) when cntxt-report-num = 0
    .
    v-report-name = substitute("&1&2&3", session:temp-directory, p-df-name, cntxt-report-num ) .
    return v-report-name .
  end method.
  
  method public static void prn-lib-reportviewer-report-name (input p-report-name-html as character) :
  define variable v-full-path-RepView as character no-undo.
  define variable ii                  as integer no-undo .
  define variable v-report-name       as character no-undo .
    v-full-path-RepView = search("exe\ReportViewer\reportviewer.exe").
    if v-full-path-RepView = ? then do :
      message "Отсутствует программа просмотра отчёта." view-as alert-box error.
      return .
    end .
    do ii = 1 to NUM-ENTRIES (p-report-name-html).
      v-report-name = ENTRY (ii,p-report-name-html).
      if search(v-report-name) = ? then do:
        message substitute("Отсутствует файл отчёта: &1", v-report-name) view-as alert-box error.
        return error.
      end.
    end.
    os-command no-wait value(substitute("&1 &2", v-full-path-RepView, p-report-name-html)).
  end method.
  /* ----- end_of переменные для печати ----- */   
  
end class.