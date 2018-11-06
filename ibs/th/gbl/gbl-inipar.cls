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
&scoped-define txt-sec секция
&scoped-define txt-key параметр
&scoped-define txt-ini в .ini файле

class ibs.th.gbl.gbl-inipar: 

  /* REP-SETS */
  define static property conPar as character no-undo
    get.
    private set.
  define static property conParKeyName as character no-undo
    initial "{&txt-sec} REP-SETS {&txt-key} ConPar {&txt-ini}"
    get.
    
  define static property conParFlt as character no-undo
    get.
    private set.
  define static property conParFltKeyName as character no-undo
    initial "{&txt-sec} REP-SETS {&txt-key} ConParFlt {&txt-ini}"
    get.
    
  define static property logDir as character no-undo
    get.
    private set.
  define static property logDirKeyName as character no-undo
    initial "{&txt-sec} REP-SETS {&txt-key} logDir {&txt-ini}"
    get.
    
  /* revision */
  define static property comstr as character no-undo
    get.
    private set.
  define static property comstrKeyName as character no-undo
    initial "{&txt-sec} revision {&txt-key} comstr {&txt-ini}"
    get.

  define static property dirflrvs as character no-undo
    get.
    private set.
  define static property dirflrvsKeyName as character no-undo
    initial "{&txt-sec} revision {&txt-key} dirflrvs {&txt-ini}"
    get.

  define static property dirflpmp as character no-undo
    get.
    private set.
  define static property dirflpmpKeyName as character no-undo
    initial "{&txt-sec} revision {&txt-key} dirflpmp {&txt-ini}"
    get.

  /* BGE */
  define static property dirfrgAcc as character no-undo
    get.
    private set.
  define static property dirfrgAccKeyName as character no-undo
    initial "{&txt-sec} BGE {&txt-key} Dirfrg-acc {&txt-ini}"
    get.

  /* OXML */
  define static property oxmlDir as character no-undo // значение для переменной oxml-heap-dir
    get.
    private set.
  define static property oxmlDirKeyName as character no-undo
    initial "{&txt-sec} OXML {&txt-key} oxml-dir {&txt-ini}"
    get.

  define static property oxmlExchDir as character no-undo // значение для переменной oxml-exch-dir
    get.
    private set.
  define static property oxmlExchDirKeyName as character no-undo
    initial "{&txt-sec} OXML {&txt-key} oxml-exch-dir {&txt-ini}"
    get.
/* 29/VIII-2018  параметры настройки ЭЦП перенесены из ini-файла в настройки внешней системы
  define static property certSign as logical no-undo
    get.
    private set.
  define static property certSignKeyName as character no-undo
    initial "{&txt-sec} OXML {&txt-key} cert-sign {&txt-ini}"
    get.

  define static property certSignSubject as character no-undo
    get.
    private set.
  define static property certSignSubjectKeyName as character no-undo
    initial "{&txt-sec} OXML {&txt-key} cert-sign-subject {&txt-ini}"
    get.

  define static property certSignIssuer as character no-undo
    get.
    private set.
  define static property certSignIssuerKeyName as character no-undo
    initial "{&txt-sec} OXML {&txt-key} cert-sign-issuer {&txt-ini}"
    get.

  define static property certFileExt as character no-undo // расширение для файлов с цифровой подписью
    get.
    private set.
  define static property certFileExtKeyName as character no-undo
    initial "{&txt-sec} OXML {&txt-key} cert-file-ext {&txt-ini}"
    get.
*/

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
    if logDir = ?
    then do :
      logDir = ".\" .
    end .
    else do :
      logDir = right-trim(logDir, "\") .
      logDir = right-trim(logDir, "/") .
      logDir = logDir + "\" .
    end.
    get-key-value section "revision" key "comstr"    value comstr .
    get-key-value section "revision" key "dirflrvs"  value dirflrvs .
    get-key-value section "revision" key "dirflpmp"  value dirflpmp .
    get-key-value section "bge" key "dirfrg-acc"     value dirfrgAcc .
    get-key-value section "oxml" key "oxml-dir"      value oxmlDir .
    get-key-value section "oxml" key "oxml-exch-dir" value oxmlExchDir .
/* 29/VIII-2018  параметры настройки ЭЦП перенесены из ini-файла в настройки внешней системы
    define variable v-cert-sign as character no-undo .
    get-key-value section "oxml" key "cert-sign"         value v-cert-sign .
    certSign = logical (v-cert-sign) no-error .
    get-key-value section "oxml" key "cert-sign-subject" value certSignSubject .
    get-key-value section "oxml" key "cert-sign-issuer"  value certSignIssuer .
    get-key-value section "oxml" key "cert-file-ext"     value certFileExt .
    if certFileExt = ?
    then do :
      certFileExt = "p7s" .
    end .
*/    
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
  
    /* Получение полного пути к исполняемому файлу просмотровщика отчётов RV.exe */
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