&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          ub               PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME d-utd
using ibs.th.gbl.sys.objsrv.
using ibs.th.str.marking.sts.*.
using ibs.th.str.marking.handlers.*.
using ibs.th.str.utd.sts.*.
using ibs.th.bge.is_motp.*.
/* Temp-Table and Buffer definitions                                    */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DECLARATIONS d-utd 
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Проверка кодов маркировки

Автор: Шкляр Елена
Дата создания: 20/04/95
Author: Shklyar Elena
Creation date: 20/04/95

*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

define input parameter parparentproc as widget-handle no-undo .
define input parameter p-doc-id as integer no-undo .
define input parameter p-db-num as integer   no-undo .
define input parameter p-type   as integer  no-undo .
define input parameter p-mode as character no-undo .
define input parameter p-connect as com-handle no-undo .
define variable p-host-code     as integer   no-undo .


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Проверка кодов маркировки".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i  }
{ cmp/library.i }
{ cmp/showinf.i }
{ cmp/r-pril.i new }
{ gbl/userobjs.i }
{ gbl/cur-time.i }
{ gbl/getcntxt.i def }
{ gbl/prn-lib.i }
{ gbl/waitfram.i }
{ cmp/mrk-strf.i }
{ gbl/color.i }
{ str/temp_upd.i }
{ gbl/key-rec.i  }
{ str/edo.i }
{cmp\trg-def.i}

/* Local Variable Definitions ---                                       */

define variable log-res-statch   as log       no-undo.
define variable rr               as recid     no-undo.
define variable v_type           as char      no-undo.
define variable v-is-deploy      as logical   no-undo .
define variable v-rid-list       as character no-undo .
define variable v-db-list        as character no-undo .
define variable v-comment        as character no-undo .
define variable gds-rec          as integer   no-undo .
define variable recid_utd        as integer   no-undo . 
define variable v-GTIN           as character no-undo .
define variable v-gds-code       as integer   no-undo .
define variable type_mark        as integer   no-undo .
define variable iLang            as integer   no-undo .
define variable Tree             as class     tree no-undo .

/*define variable Check_      as class     check_ no-undo .*/
define variable ungroup          as logical   no-undo .

define variable line-num-error   as integer   no-undo .
define variable qnty-gray        as integer   no-undo .
define variable qnty-check       as integer   no-undo .
define variable v-pred-status    as integer   no-undo .
define variable v-obj-active     as logical   no-undo .

define variable mRecKey-line as character no-undo.
define buffer buf_clients           for ub.clients .
define buffer X_utd-lines           for tt-utd-lines .
define buffer buf_utd               for ub.utd .
define buffer buf_utd-attr          for ub.utd-attr .
define buffer buf_utd-lines         for ub.utd-lines .
define buffer bf_utd-lines          for ub.utd-lines .
define buffer buf_contract          for ub.contract .
define buffer buf_utd-marking-lines for ub.utd-marking-lines .
define buffer bf_utd-marking-lines  for ub.utd-marking-lines .
define buffer buf_goods             for ub.goods .
define buffer buf_marking           for ub.marking .
define buffer buf_utd-err           for ub.utd-err .

define variable v-scan-str  as character no-undo.
define variable v-manual    as logical   no-undo .
DEFINE VARIABLE v-timedelay as integer   no-undo .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS d-utd 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 14/02/20 - 10:57 am

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */



&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME d-utd
&Scoped-define BROWSE-NAME br-utd

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES X_utd-lines

/* Definitions for BROWSE br-utd                                        */
&Scoped-define FIELDS-IN-QUERY-br-utd X_utd-lines.LineId ~
X_utd-lines.gds-code X_utd-lines.GdsName X_utd-lines.UnitCode ~
X_utd-lines.Quantity X_utd-lines.Article X_utd-lines.sts 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-utd 

&Scoped-define QUERY-STRING-br-utd FOR EACH X_utd-lines NO-LOCK where if r-error = 2 then X_utd-lines.stts = "Ожидает проверку" or X_utd-lines.stts = "Ошибка" else X_utd-lines.sts = 0 INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-utd if r-error = 2 then OPEN QUERY br-utd FOR EACH X_utd-lines no-lock where X_utd-lines.stts <> "Проверен" INDEXED-REPOSITION. else ~
if r-error-2 = 2 then OPEN QUERY br-utd FOR EACH X_utd-lines no-lock where X_utd-lines.stts = "Ошибка" INDEXED-REPOSITION.  else ~
OPEN QUERY br-utd FOR EACH X_utd-lines no-lock INDEXED-REPOSITION.

&Scoped-define TABLES-IN-QUERY-br-utd X_utd-lines
&Scoped-define FIRST-TABLE-IN-QUERY-br-utd X_utd-lines


/* Definitions for DIALOG-BOX d-utd                                     */
&Scoped-define OPEN-BROWSERS-IN-QUERY-d-utd ~
    ~{&OPEN-QUERY-br-utd}
    
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-exit b-cancel b-save b_servis b_error ~
B_mark B_mark-utd RECT-1 R-TH f-num f-date c-type ~
f-obj-type-TH f-obj-code-TH r-obj-TH f-obj-name-TH FILL-IN-1 f-supp-type-TH ~
f-supp-code-TH r-supp-TH f-supp-name-TH FILL-IN-2 FILL-IN-3 f-contr-TH ~
r-contr-TH f-contr-name-TH f-contr-name f-status c-status-edi c-status ~
f-comment r-wrkr r-agnt f-info r-boss v-mark a-n-c b_error_line br-utd ~
b_prov-finish b_recheck b_correct b_back-check ~
b_finish b_write-cancel b_deliv-cancel wrkr-name agnt-name boss-name f-wrkr f-agnt f-boss 
&Scoped-Define DISPLAYED-OBJECTS f-num f-date c-type f-obj-type-TH ~
f-obj-code-TH f-obj-name-TH f-obj-name-2 FILL-IN-1 f-supp-type-TH ~
f-supp-code-TH f-supp-name-TH FILL-IN-2 FILL-IN-3 f-contr-TH ~
f-contr-name-TH f-contr-name f-status c-status-edi c-status f-comment ~
f-info v-mark a-n-c a-n-c-name F-text wrkr-name agnt-name boss-name 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CliName d-utd 
FUNCTION CliName RETURNS CHARACTER
    (input p-cli-code as integer, input p-cli-type as character)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ContName d-utd 
FUNCTION ContName RETURNS CHARACTER
    ( input p-contract-code as integer, input p-host-code as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GdsName d-utd 
FUNCTION GdsName RETURNS CHARACTER
    ( input p-gds-code as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD StatusName d-utd 
FUNCTION StatusName RETURNS CHARACTER
    ( input p-doc-id as integer,
    input p-db-num as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Menu Definitions                                                     */
DEFINE MENU m_error 
    MENU-ITEM m_error-utd    LABEL "Ошибки по документу"
    MENU-ITEM m_error-lines  LABEL "Ошибки по строке".

DEFINE MENU m_marks 
    MENU-ITEM m_marks-utd    LABEL "Марки по документу"
    MENU-ITEM m_marks-lines  LABEL "Марки по строке".

DEFINE MENU POPUP-MENU-b-servis 
    MENU-ITEM m_choose-status LABEL "Сменить статус документа"
    MENU-ITEM m_check-akt    LABEL "Проверить по Акту приема-передачи".


/* Definitions of the field level widgets                               */
DEFINE BUTTON b-cancel AUTO-ENDKEY 
    LABEL "&Отмена":L 
    SIZE 15 BY 1.

DEFINE BUTTON b-exit AUTO-GO 
    LABEL "&Выход ":L 
    SIZE 15 BY 1.

DEFINE BUTTON b-save AUTO-GO 
    LABEL "&Ввод ":L 
    SIZE 15 BY 1.

DEFINE BUTTON b-servis 
    LABEL "Сервис" 
    SIZE 15 BY 1.

DEFINE BUTTON b_anul 
    LABEL "Аннулировать" 
    SIZE 36 BY 1.25.

DEFINE BUTTON b_back-check 
    LABEL "Продолжить проверку" 
    SIZE 36 BY 1.25.

DEFINE BUTTON b_correct 
    LABEL "Запрос на изменение" 
    SIZE 36 BY 1.25.

DEFINE BUTTON b_deliv-cancel 
    LABEL "Отказать в поставке" 
    SIZE 36 BY 1.25.

DEFINE BUTTON b_error 
    LABEL "Ошибки/проблемы" 
    SIZE 20 BY 1.

DEFINE BUTTON b_finish 
    LABEL "Ввод в оборот" 
    SIZE 36 BY 1.25.

DEFINE BUTTON B_mark 
    LABEL "Марки" 
    SIZE 15 BY 1.

DEFINE BUTTON b_prov-finish 
    LABEL "Проверка завершена" 
    SIZE 36 BY 1.25.

DEFINE BUTTON b_recheck 
    LABEL "Повторно проверить" 
    SIZE 36 BY 1.25.

DEFINE BUTTON b_write-cancel 
    LABEL "Отказать в подписи" 
    SIZE 36 BY 1.25.

DEFINE BUTTON r-agnt 
    IMAGE-UP FILE "btn-down-arrow":U
    IMAGE-DOWN FILE "btn-down-arrow":U
    IMAGE-INSENSITIVE FILE "btn-down-arrow":U
    LABEL "r-acc" 
    SIZE 3 BY 1.

DEFINE BUTTON r-boss 
    IMAGE-UP FILE "btn-down-arrow":U
    IMAGE-DOWN FILE "btn-down-arrow":U
    IMAGE-INSENSITIVE FILE "btn-down-arrow":U
    LABEL "r-acc" 
    SIZE 3 BY 1.

DEFINE BUTTON r-contr-TH 
    IMAGE-UP FILE "btn-down-arrow":U
    IMAGE-DOWN FILE "btn-down-arrow":U
    IMAGE-INSENSITIVE FILE "btn-down-arrow":U
    LABEL "" 
    SIZE 3 BY 1.

DEFINE BUTTON r-obj-TH 
    IMAGE-UP FILE "btn-down-arrow":U
    IMAGE-DOWN FILE "btn-down-arrow":U
    IMAGE-INSENSITIVE FILE "btn-down-arrow":U
    LABEL "" 
    SIZE 3 BY 1.

DEFINE BUTTON r-supp-TH 
    IMAGE-UP FILE "btn-down-arrow":U
    IMAGE-DOWN FILE "btn-down-arrow":U
    IMAGE-INSENSITIVE FILE "btn-down-arrow":U
    LABEL "" 
    SIZE 3 BY 1.

DEFINE BUTTON r-wrkr 
    IMAGE-UP FILE "btn-down-arrow":U
    IMAGE-DOWN FILE "btn-down-arrow":U
    IMAGE-INSENSITIVE FILE "btn-down-arrow":U
    LABEL "r-acc" 
    SIZE 3 BY 1.

DEFINE VARIABLE c-status        AS INTEGER   FORMAT "-999":U INITIAL 0 
    VIEW-AS COMBO-BOX INNER-LINES 5
    LIST-ITEM-PAIRS "Все",0,
    "Получен от поставщика",2,
    "Требует корректировки",3,
    "Ожидает поставки",4,
    "Требует подписания",5
    DROP-DOWN-LIST
    SIZE 55.5 BY 1 NO-UNDO.

DEFINE VARIABLE c-status-edi    AS INTEGER   FORMAT "-999":U INITIAL 352 
    VIEW-AS COMBO-BOX INNER-LINES 5
    LIST-ITEM-PAIRS "Все",0,
    "Получен от поставщика",2,
    "Требует корректировки",3,
    "Ожидает поставки",4,
    "Требует подписания",5
    DROP-DOWN-LIST
    SIZE 58.5 BY 1 NO-UNDO.

DEFINE VARIABLE c-type          AS INTEGER   FORMAT "-999":U INITIAL 0 
    LABEL "Тип" 
    VIEW-AS COMBO-BOX INNER-LINES 5
    LIST-ITEM-PAIRS "Все",0,
    "Получен от поставщика",2,
    "Требует корректировки",3,
    "Ожидает поставки",4,
    "Требует подписания",5
    DROP-DOWN-LIST
    SIZE 42 BY 1 NO-UNDO.

DEFINE VARIABLE f-comment       AS CHARACTER 
    VIEW-AS EDITOR SCROLLBAR-VERTICAL
    SIZE 100 BY 1.46 NO-UNDO.

DEFINE VARIABLE f-info          AS CHARACTER 
    VIEW-AS EDITOR SCROLLBAR-VERTICAL
    SIZE 100 BY 1.96 NO-UNDO.

DEFINE VARIABLE f-obj-name-2    AS CHARACTER 
    VIEW-AS EDITOR SCROLLBAR-VERTICAL
    SIZE 70.5 BY 2.17 NO-UNDO.

DEFINE VARIABLE a-n-c-name      AS CHARACTER FORMAT "X(256)":U 
    VIEW-AS FILL-IN 
    SIZE 45 BY 1
    FGCOLOR 12 NO-UNDO.

DEFINE VARIABLE agnt-name       AS CHARACTER FORMAT "x(256)":U 
    VIEW-AS TEXT 
    SIZE 11 BY 1
    BGCOLOR 15 NO-UNDO.

DEFINE VARIABLE boss-name       AS CHARACTER FORMAT "x(256)":U 
    VIEW-AS TEXT 
    SIZE 11 BY 1
    BGCOLOR 15 NO-UNDO.

DEFINE VARIABLE f-agnt          AS INTEGER   FORMAT ">>>>>>>>>>>9":U INITIAL 0 
    VIEW-AS FILL-IN 
    SIZE 11.25 BY 1
    BGCOLOR 15 NO-UNDO.

DEFINE VARIABLE f-agnt-name     AS CHARACTER FORMAT "X(256)":U INITIAL "Исп:" 
    VIEW-AS FILL-IN 
    SIZE 4.88 BY 1 NO-UNDO.

DEFINE VARIABLE f-boss          AS INTEGER   FORMAT ">>>>>>>>>>>9":U INITIAL 0 
    VIEW-AS FILL-IN 
    SIZE 11.25 BY 1
    BGCOLOR 15 NO-UNDO.

DEFINE VARIABLE f-boss-name     AS CHARACTER FORMAT "X(256)":U INITIAL "М-р:" 
    VIEW-AS FILL-IN 
    SIZE 4.88 BY 1 NO-UNDO.

DEFINE VARIABLE f-comment-name  AS CHARACTER FORMAT "X(256)":U INITIAL "Комментарий:" 
    VIEW-AS FILL-IN 
    SIZE 12.88 BY 1 NO-UNDO.

DEFINE VARIABLE f-contr-name    AS CHARACTER FORMAT "X(150)" 
    VIEW-AS FILL-IN 
    SIZE 35.25 BY 1.

DEFINE VARIABLE f-contr-name-TH AS CHARACTER FORMAT "X(100)" 
    VIEW-AS FILL-IN 
    SIZE 48.5 BY 1.

DEFINE VARIABLE f-contr-TH      AS INTEGER   FORMAT ">>>>>>>>>>>>>>>>>>>>>>9" INITIAL 0 
    VIEW-AS FILL-IN 
    SIZE 19.5 BY 1.

DEFINE VARIABLE f-date          AS DATE      FORMAT "99/99/9999":U 
    VIEW-AS FILL-IN 
    SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE f-date-2        AS DATE      FORMAT "99/99/9999":U 
    VIEW-AS FILL-IN 
    SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE f-date-name     AS CHARACTER FORMAT "X(256)":U INITIAL "Дата:" 
    VIEW-AS FILL-IN 
    SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE f-date-name-2   AS CHARACTER FORMAT "X(256)":U INITIAL "Дата:" 
    VIEW-AS FILL-IN 
    SIZE 6 BY 1 NO-UNDO.

DEFINE VARIABLE f-gruz          AS CHARACTER FORMAT "X(256)":U INITIAL "Грузополучатель:" 
    VIEW-AS FILL-IN 
    SIZE 17.38 BY .92 NO-UNDO.

DEFINE VARIABLE f-info-name     AS CHARACTER FORMAT "X(256)":U INITIAL "Доп.инфо:" 
    VIEW-AS FILL-IN 
    SIZE 9.88 BY 1 NO-UNDO.

DEFINE VARIABLE f-mark          AS CHARACTER FORMAT "X(256)":U INITIAL "Марка:" 
    VIEW-AS FILL-IN 
    SIZE 6.7 BY 1 NO-UNDO.

DEFINE VARIABLE f-num           AS CHARACTER FORMAT "X(256)":U 
    VIEW-AS FILL-IN 
    SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE f-num-2         AS CHARACTER FORMAT "X(256)":U 
    LABEL "№" 
    VIEW-AS FILL-IN 
    SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE f-num-name      AS CHARACTER FORMAT "X(256)":U INITIAL "№ документа:" 
    VIEW-AS FILL-IN 
    SIZE 12.5 BY 1 NO-UNDO.

DEFINE VARIABLE f-num-name-2    AS CHARACTER FORMAT "X(256)":U INITIAL "№:" 
    VIEW-AS FILL-IN 
    SIZE 3.25 BY 1 NO-UNDO.

DEFINE VARIABLE f-obj-code-TH   AS INTEGER   FORMAT ">>>>>>>>>>9" INITIAL 0 
    VIEW-AS FILL-IN 
    SIZE 14.75 BY 1.

DEFINE VARIABLE f-obj-name      AS CHARACTER FORMAT "X(256)":U INITIAL "Объект:" 
    VIEW-AS FILL-IN 
    SIZE 14 BY .75 NO-UNDO.

DEFINE VARIABLE f-obj-name-TH   AS CHARACTER FORMAT "X(100)" 
    VIEW-AS FILL-IN 
    SIZE 48.5 BY 1.

DEFINE VARIABLE f-obj-type-TH   AS CHARACTER FORMAT "X(3)" 
    VIEW-AS FILL-IN 
    SIZE 4.13 BY 1.

DEFINE VARIABLE f-status-EDI    AS CHARACTER FORMAT "X(256)":U INITIAL "Статус EDI:" 
    VIEW-AS FILL-IN 
    SIZE 11.75 BY 1 NO-UNDO.

DEFINE VARIABLE f-status-TH     AS CHARACTER FORMAT "X(256)":U INITIAL "Статус ТН:" 
    VIEW-AS FILL-IN 
    SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE f-supp-code-TH  AS INTEGER   FORMAT ">>>>>>>>>>9" INITIAL 0 
    VIEW-AS FILL-IN 
    SIZE 14.75 BY 1.

DEFINE VARIABLE f-supp-name-TH  AS CHARACTER FORMAT "X(100)" 
    VIEW-AS FILL-IN 
    SIZE 48.5 BY 1.

DEFINE VARIABLE f-supp-type-TH  AS CHARACTER FORMAT "X(3)" 
    VIEW-AS FILL-IN 
    SIZE 4.13 BY 1.

DEFINE VARIABLE F-text          AS CHARACTER FORMAT "X(256)":U 
    VIEW-AS FILL-IN 
    SIZE 90.5 BY 1.25
    FGCOLOR 12 NO-UNDO.

DEFINE VARIABLE f-total         AS DECIMAL   FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0 
    LABEL "Общая сумма" 
    VIEW-AS FILL-IN 
    SIZE 16.75 BY 1 NO-UNDO.

DEFINE VARIABLE f-vat           AS DECIMAL   FORMAT "->>,>>9.99":U INITIAL 0 
    LABEL "Сумма НДС" 
    VIEW-AS FILL-IN 
    SIZE 16.75 BY 1 NO-UNDO.

DEFINE VARIABLE f-wrkr          AS INTEGER   FORMAT ">>>>>>>>>>>9":U INITIAL 0 
    VIEW-AS FILL-IN 
    SIZE 11.25 BY 1
    BGCOLOR 15 NO-UNDO.

DEFINE VARIABLE f-wrkr-name     AS CHARACTER FORMAT "X(256)":U INITIAL "Кл-к:" 
    VIEW-AS FILL-IN 
    SIZE 5.88 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-1       AS CHARACTER FORMAT "X(256)":U INITIAL "Поставщик:" 
    VIEW-AS FILL-IN 
    SIZE 14 BY .75 NO-UNDO.

DEFINE VARIABLE FILL-IN-2       AS CHARACTER FORMAT "X(256)":U INITIAL "Договор:" 
    VIEW-AS FILL-IN 
    SIZE 14 BY .75 NO-UNDO.

DEFINE VARIABLE FILL-IN-3       AS CHARACTER FORMAT "X(256)":U INITIAL "Договор:" 
    VIEW-AS FILL-IN 
    SIZE 14 BY .75 NO-UNDO.

DEFINE VARIABLE v-mark          AS CHARACTER FORMAT "X(255)" 
    VIEW-AS FILL-IN 
    SIZE 100 BY 1.

DEFINE VARIABLE wrkr-name       AS CHARACTER FORMAT "x(256)":U 
    VIEW-AS TEXT 
    SIZE 11 BY 1
    BGCOLOR 15 NO-UNDO.

DEFINE VARIABLE a-n-c           AS CHARACTER 
    VIEW-AS RADIO-SET HORIZONTAL
    RADIO-BUTTONS 
    "Код", "code",
    "Нач.назв", "name",
    "Нач.слова", "context"
    SIZE 37.63 BY 1 NO-UNDO.

DEFINE VARIABLE R-error         AS INTEGER 
    VIEW-AS RADIO-SET HORIZONTAL
    RADIO-BUTTONS 
    "Все", 1,
    "Не проверено", 2
    SIZE 25.38 BY 1 NO-UNDO.

DEFINE VARIABLE R-error-2       AS INTEGER 
    VIEW-AS RADIO-SET HORIZONTAL
    RADIO-BUTTONS 
    "Все", 1,
    "Ошибки", 2
    SIZE 25.38 BY 1 NO-UNDO.

DEFINE RECTANGLE R-TH
    EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
    SIZE 73.5 BY 6.75 TOOLTIP "Данные ТН".

DEFINE RECTANGLE RECT-1
    EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
    SIZE 147.5 BY 3.25.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-utd FOR 
    X_utd-lines SCROLLING.
&ANALYZE-RESUME

/*def var objSrv as class objsrv no-undo.*/
/*run gbl/getobjsrvhndl.p (input-output ObjSrv).*/
def var Marking as class mark no-undo .

/* Browse definitions                                                   */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD StatusTHName d-utd
FUNCTION StatusTHName RETURNS CHARACTER
    (input p-stsTH as integer)  .
    Return Marking:GetLabel(p-stsTH) .
END FUNCTION .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD EdoTypeName d-utd 
FUNCTION EdoTypeName RETURNS CHARACTER
    (input p-stsTH as integer)  .
    Return ObjSrv:Env:Utd:EDocType:GetLabel(p-stsTH) .
END FUNCTION .  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-utd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-utd d-utd _STRUCTURED
    QUERY br-utd NO-LOCK DISPLAY
    X_utd-lines.LineNum COLUMN-LABEL "№ п/п" FORMAT ">>>9":U
    X_utd-lines.gds-code COLUMN-LABEL "Код товара" FORMAT "999999999":U
    X_utd-lines.ProductCode COLUMN-LABEL "Наименование" FORMAT "x(40)":U width 25
    X_utd-lines.gds-name COLUMN-LABEL "Наименование ТН" FORMAT "x(40)":U width 25
    X_utd-lines.Quantity COLUMN-LABEL "Кол-во!марк. прод-ции" FORMAT "->>,>>9.999":U
    X_utd-lines.Price COLUMN-LABEL "Цена!(без НДC)" FORMAT "->>>>>>>>>>99.99":U width 10
    X_utd-lines.Total COLUMN-LABEL "Сумма!(с НДС)" FORMAT "->>>>>>>>>>>>>>99.99":U width 10
    X_utd-lines.TaxRate_ COLUMN-LABEL "НДС" FORMAT "X(5)":U
    X_utd-lines.fact-qnty COLUMN-LABEL "Остаток" FORMAT "->>>>>>>>>>>>>>9.99":U width 10
    X_utd-lines.qnty-mark COLUMN-LABEL "Кол-во!марок" FORMAT "->>>9":U
    X_utd-lines.qnty-scan COLUMN-LABEL "Кол-во!проскан." FORMAT "->>>9":U
    X_utd-lines.stts COLUMN-LABEL "Статус" FORMAT "x(20)":U WIDTH 18.13
    X_utd-lines.UnitCode COLUMN-LABEL "ед.!изм" FORMAT "x(5)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 147.5 BY 10.88 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME d-utd
    b-exit AT ROW 1 COL 2
    b-cancel AT ROW 1 COL 2
    b-save AT ROW 1 COL 17
    b-servis AT ROW 1 COL 99.88 WIDGET-ID 288
    b_error AT ROW 1 COL 114.88 WIDGET-ID 282
    B_mark AT ROW 1 COL 148.88 RIGHT-ALIGNED WIDGET-ID 80
    c-type AT ROW 2.25 COL 5.13 COLON-ALIGNED WIDGET-ID 240
    f-num-name AT ROW 2.25 COL 53.75 NO-LABEL WIDGET-ID 328
    f-num AT ROW 2.25 COL 64.5 COLON-ALIGNED NO-LABEL WIDGET-ID 284
    f-date-name AT ROW 2.25 COL 81.13 NO-LABEL WIDGET-ID 330
    f-date AT ROW 2.25 COL 85.25 COLON-ALIGNED NO-LABEL WIDGET-ID 286
    f-num-name-2 AT ROW 2.25 COL 110.5 NO-LABEL WIDGET-ID 334
    f-num-2 AT ROW 2.25 COL 112 COLON-ALIGNED NO-LABEL WIDGET-ID 314
    f-date-name-2 AT ROW 2.25 COL 128.63 NO-LABEL WIDGET-ID 332
    f-date-2 AT ROW 2.25 COL 132.75 COLON-ALIGNED NO-LABEL WIDGET-ID 312
    f-obj-name AT ROW 4.38 COL 2.5 NO-LABEL WIDGET-ID 326
    f-obj-type-TH AT ROW 5.21 COL 5.88 RIGHT-ALIGNED NO-LABEL WIDGET-ID 102
    f-obj-code-TH AT ROW 5.21 COL 21.25 RIGHT-ALIGNED NO-LABEL WIDGET-ID 98
    r-obj-TH AT ROW 5.21 COL 22.5 WIDGET-ID 104
    f-obj-name-TH AT ROW 5.21 COL 73.25 RIGHT-ALIGNED NO-LABEL WIDGET-ID 100
    f-gruz AT ROW 5.25 COL 77.13 NO-LABEL WIDGET-ID 310
    f-obj-name-2 AT ROW 6.17 COL 77.25 NO-LABEL WIDGET-ID 270
    FILL-IN-1 AT ROW 6.5 COL 2.5 NO-LABEL WIDGET-ID 242
    f-supp-type-TH AT ROW 7.29 COL 5.88 RIGHT-ALIGNED NO-LABEL WIDGET-ID 96
    f-supp-code-TH AT ROW 7.29 COL 21.25 RIGHT-ALIGNED NO-LABEL WIDGET-ID 86
    r-supp-TH AT ROW 7.29 COL 22.5 WIDGET-ID 92
    f-supp-name-TH AT ROW 7.29 COL 73.25 RIGHT-ALIGNED NO-LABEL WIDGET-ID 88
    f-total AT ROW 8.42 COL 129 COLON-ALIGNED WIDGET-ID 320
    FILL-IN-2 AT ROW 8.5 COL 2.5 NO-LABEL WIDGET-ID 244
    FILL-IN-3 AT ROW 8.5 COL 77.13 NO-LABEL WIDGET-ID 248
    f-contr-TH AT ROW 9.29 COL 21.25 RIGHT-ALIGNED NO-LABEL WIDGET-ID 106
    r-contr-TH AT ROW 9.29 COL 22.5 WIDGET-ID 110
    f-contr-name-TH AT ROW 9.29 COL 73.25 RIGHT-ALIGNED NO-LABEL WIDGET-ID 212
    f-contr-name AT ROW 9.29 COL 77.25 NO-LABEL WIDGET-ID 214
    f-vat AT ROW 9.5 COL 129 COLON-ALIGNED WIDGET-ID 322
    f-status-TH AT ROW 11.17 COL 5.88 NO-LABEL WIDGET-ID 336
    c-status AT ROW 11.17 COL 15 COLON-ALIGNED NO-LABEL WIDGET-ID 238
    f-status-EDI AT ROW 11.17 COL 77.63 NO-LABEL WIDGET-ID 338
    c-status-edi AT ROW 11.17 COL 87.5 COLON-ALIGNED NO-LABEL WIDGET-ID 234
    f-comment AT ROW 12.25 COL 17 NO-LABEL WIDGET-ID 266
    f-wrkr-name AT ROW 12.25 COL 117.25 NO-LABEL WIDGET-ID 346
    f-wrkr AT ROW 12.25 COL 121.25 COLON-ALIGNED NO-LABEL WIDGET-ID 304
    r-wrkr AT ROW 12.25 COL 145.5 WIDGET-ID 302
    f-comment-name AT ROW 12.42 COL 4 NO-LABEL WIDGET-ID 340
    f-agnt-name AT ROW 13.46 COL 118.25 NO-LABEL WIDGET-ID 348
    f-agnt AT ROW 13.46 COL 121.25 COLON-ALIGNED NO-LABEL WIDGET-ID 290
    r-agnt AT ROW 13.46 COL 145.5 WIDGET-ID 298
    f-info AT ROW 13.71 COL 17 NO-LABEL WIDGET-ID 268
    f-info-name AT ROW 14.04 COL 7 NO-LABEL WIDGET-ID 342
    f-boss-name AT ROW 14.67 COL 118.25 NO-LABEL WIDGET-ID 350
    f-boss AT ROW 14.67 COL 121.25 COLON-ALIGNED NO-LABEL WIDGET-ID 294
    r-boss AT ROW 14.67 COL 145.5 WIDGET-ID 300
    f-mark AT ROW 15.67 COL 10 NO-LABEL WIDGET-ID 344
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS THREE-D  SCROLLABLE .

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME d-utd
    v-mark AT ROW 15.67 COL 15 COLON-ALIGNED NO-LABEL WIDGET-ID 34
    a-n-c AT ROW 16.71 COL 2.38 NO-LABEL WIDGET-ID 272
    a-n-c-name AT ROW 16.75 COL 39.5 COLON-ALIGNED NO-LABEL WIDGET-ID 278
    R-error AT ROW 16.79 COL 124.63 NO-LABEL WIDGET-ID 316
    R-error-2 AT ROW 16.79 COL 124.63 NO-LABEL WIDGET-ID 316
    br-utd AT ROW 17.75 COL 2
    F-text AT ROW 28.75 COL 35.5 NO-LABEL WIDGET-ID 224
    b_prov-finish AT ROW 30.5 COL 2.75 WIDGET-ID 70
    b_recheck AT ROW 30.5 COL 39.5 WIDGET-ID 228
    b_correct AT ROW 30.5 COL 76.13 WIDGET-ID 230
    b_anul AT ROW 30.5 COL 112.75 WIDGET-ID 324
    b_back-check AT ROW 31.88 COL 2.75 WIDGET-ID 236
    b_finish AT ROW 31.88 COL 39.5 WIDGET-ID 252
    b_write-cancel AT ROW 31.88 COL 76.13 WIDGET-ID 232
    b_deliv-cancel AT ROW 31.88 COL 112.75 WIDGET-ID 230
    wrkr-name AT ROW 12.25 COL 132.88 COLON-ALIGNED NO-LABEL WIDGET-ID 306
    agnt-name AT ROW 13.46 COL 132.88 COLON-ALIGNED NO-LABEL WIDGET-ID 292
    boss-name AT ROW 14.67 COL 132.88 COLON-ALIGNED NO-LABEL WIDGET-ID 296
    "Доп.инфо:" VIEW-AS TEXT
    SIZE 9.5 BY .67 AT ROW 14.17 COL 7 WIDGET-ID 264
    "Объект:" VIEW-AS TEXT
    SIZE 8 BY .67 AT ROW 4.42 COL 3 WIDGET-ID 182
    "Данные ТН:" VIEW-AS TEXT
    SIZE 11 BY .67 AT ROW 3.75 COL 32.63 WIDGET-ID 180
    RECT-1 AT ROW 30.25 COL 2 WIDGET-ID 64
    R-TH AT ROW 4 COL 2 WIDGET-ID 112
    SPACE(74.51) SKIP(23.07)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS THREE-D  SCROLLABLE 
    TITLE "Проверка кодов маркировки":L.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Temp-Tables and Buffers:
      TABLE: X_utd-lines B "NEW SHARED" ? ub utd-lines
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX d-utd
   FRAME-NAME UNDERLINE                                                 */
/* BROWSE-TAB br-utd R-error-2 d-utd */
ASSIGN 
    FRAME d-utd:SCROLLABLE = FALSE.

/* SETTINGS FOR FILL-IN a-n-c-name IN FRAME d-utd
   NO-ENABLE                                                            */
ASSIGN 
    b-servis:POPUP-MENU IN FRAME d-utd = MENU POPUP-MENU-b-servis:HANDLE.
ASSIGN 
    b-servis:MENU-MOUSE = 1.
ASSIGN 
    br-utd:COLUMN-RESIZABLE IN FRAME d-utd = TRUE.

ASSIGN 
    b_error:POPUP-MENU IN FRAME d-utd = MENU m_error:HANDLE.
ASSIGN 
    b_error:MENU-MOUSE = 1.

/* SETTINGS FOR BUTTON B_mark IN FRAME d-utd
   ALIGN-R                                                              */
ASSIGN 
    B_mark:POPUP-MENU IN FRAME d-utd = MENU m_marks:HANDLE.
ASSIGN 
    b_mark:MENU-MOUSE = 1.
/* SETTINGS FOR BUTTON B_mark-utd IN FRAME d-utd
   ALIGN-R                                                              */

/* SETTINGS FOR FILL-IN f-agnt-name IN FRAME d-utd
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN f-boss-name IN FRAME d-utd
   ALIGN-L                                                              */
ASSIGN 
    f-comment:READ-ONLY IN FRAME d-utd = TRUE.

/* SETTINGS FOR FILL-IN f-comment-name IN FRAME d-utd
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN f-contr-name IN FRAME d-utd
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN f-contr-name-TH IN FRAME d-utd
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN f-contr-TH IN FRAME d-utd
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN f-date-name IN FRAME d-utd
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN f-date-name-2 IN FRAME d-utd
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN f-gruz IN FRAME d-utd
   ALIGN-L                                                              */
ASSIGN 
    f-info:READ-ONLY IN FRAME d-utd = TRUE.

/* SETTINGS FOR FILL-IN f-info-name IN FRAME d-utd
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN f-mark IN FRAME d-utd
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN f-num-name IN FRAME d-utd
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN f-num-name-2 IN FRAME d-utd
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN f-obj-code-TH IN FRAME d-utd
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN f-obj-name IN FRAME d-utd
   ALIGN-L                                                              */
/* SETTINGS FOR EDITOR f-obj-name-2 IN FRAME d-utd
   NO-ENABLE                                                            */
ASSIGN 
    f-obj-name-2:READ-ONLY IN FRAME d-utd = TRUE.

/* SETTINGS FOR FILL-IN f-obj-name-TH IN FRAME d-utd
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN f-obj-type-TH IN FRAME d-utd
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN f-status-EDI IN FRAME d-utd
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN f-status-TH IN FRAME d-utd
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN f-supp-code-TH IN FRAME d-utd
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN f-supp-name-TH IN FRAME d-utd
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN f-supp-type-TH IN FRAME d-utd
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN F-text IN FRAME d-utd
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN f-wrkr-name IN FRAME d-utd
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME d-utd
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME d-utd
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME d-utd
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-utd
/* Query rebuild information for BROWSE br-utd
     _TblList          = "X_utd-lines"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.X_utd-lines.LineId
"X_utd-lines.LineId" "№ п/п" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.X_utd-lines.gds-code
"X_utd-lines.gds-code" "Код товара" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.X_utd-lines.GdsName
"X_utd-lines.GdsName" "Наименование" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.X_utd-lines.UnitCode
"X_utd-lines.UnitCode" "ед.измерения" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.X_utd-lines.Quantity
"X_utd-lines.Quantity" "Кол-во по ТТН" ? "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.X_utd-lines.Article
"X_utd-lines.Article" "Кол-во просканировано" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.X_utd-lines.sts
"X_utd-lines.sts" "Статус" ? "character" ? ? ? ? ? ? no ? no no "18.13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-utd */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX d-utd
/* Query rebuild information for DIALOG-BOX d-utd
     _TblList          = "Temp-Tables.t-doc"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX d-utd */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME a-n-c
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL a-n-c d-utd
ON VALUE-CHANGED OF a-n-c IN FRAME d-utd
    DO:
        assign a-n-c .
        apply "TAB":U to self .
        return no-apply .
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-cancel d-utd
ON choose OF b-cancel IN FRAME d-utd /* Отмена */
    DO:
        if p-mode = {&add-def} and available (buf_utd) then 
        do:
            /*      for each buf_utd-lines where buf_utd-lines.db-num = buf_utd.db-num and buf_utd-lines.doc-id = buf_utd.doc-id:                                                        */
            /*        for each buf_utd-marking-lines where buf_utd-marking-lines.db-num = buf_utd-lines.db-num and buf_utd-marking-lines.doc-id = buf_utd-lines.doc-id:                  */
            /*          for each buf_marking where buf_marking.mark = buf_utd-marking-lines.mark and buf_marking.obj-code = buf_utd.obj-code and buf_marking.obj-type = buf_utd.obj-type:*/
            /*            delete buf_marking .                                                                                                                                           */
            /*          end.                                                                                                                                                             */
            /*          delete buf_utd-marking-lines .                                                                                                                                   */
            /*        end.                                                                                                                                                               */
            /*        delete buf_utd-lines .                                                                                                                                             */
            /*      end.                                                                                                                                                                 */
            delete buf_utd .
        end.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-exit d-utd
ON choose OF b-exit IN FRAME d-utd /* Выход  */
    DO:
    /*    if f-status <> ObjSrv:Env:Utd:Sts:EDI:GetLabel(buf_utd.sts-edi) then buf_utd.sts-edi = "" .*/
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-save
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-save d-utd
ON choose OF b-save IN FRAME d-utd /* Ввод  */
    DO:
        define variable v-ok as logical no-undo .
        if p-mode <> {&lookup} and type_mark = 1 then 
        do:
            run save_mol. 
        end .  
        if p-mode <> {&lookup} then 
        do:
            /*Сохранение данных*/
            if f-obj-type-th = "" then 
            do:
                message "Не выбран объект"
                    view-as alert-box.
                return no-apply .
            end.
            if c-type = 0 then 
            do:
                message "Не выбран тип документа"
                    view-as alert-box.
                return no-apply .
            end.  
            if available (buf_utd) then 
            do:
                assign
                    buf_utd.obj-code = f-obj-code-TH
                    buf_utd.obj-type = f-obj-type-TH
                    .
            end.
            if f-contr-TH <> 0 and f-contr-TH <> ? then 
            do:
                assign
                    buf_utd.contract-code = f-contr-TH
                    .  
            end.
            else 
            do:
                if c-type = objSrv:Env:Utd:EDocType:AKT:KeyIntDB then 
                do: 
                    message "Не заполнен номер договора"
                        view-as alert-box.
                    return no-apply .
                end.
            end.  
            if f-obj-code-TH <> 0 and f-obj-code-TH <> ? then 
            do:
                assign
                    buf_utd.obj-code = f-obj-code-TH
                    buf_utd.obj-type = f-obj-type-TH
                    .
            end.  
            else 
            do:
                if c-type = objSrv:Env:Utd:EDocType:AKT:KeyIntDB then 
                do:
                    message "Не заполнен объект"
                        view-as alert-box.
                    return no-apply .
                end.
            end.        
            if f-supp-code-TH <> 0 and f-supp-code-TH <> ? then 
            do:
                assign
                    buf_utd.cli-code = f-supp-code-TH
                    buf_utd.cli-type = f-supp-type-TH
                    .
            end.
            else 
            do:
                if c-type = objSrv:Env:Utd:EDocType:AKT:KeyIntDB then 
                do:
                    message "Не заполнен поставщик"
                        view-as alert-box.
                    return no-apply .
                end .
            end.  
            if c-type = objSrv:Env:Utd:EDocType:AKT:KeyIntDB then 
            do:
                if f-num = "" then 
                do:
                    message "Заполните номер документа"
                        view-as alert-box.
                    return no-apply .
                end.   
  
                assign
                    buf_utd.DocumentNumber = f-num
                    buf_utd.DocumentDate   = f-date
                    buf_utd.sts-edi        = ObjSrv:Env:Utd:Sts:EDI:RecipientResponseStatusNotAccep:KeyIntDB  
                    .  
                for each buf_utd-marking-lines no-lock where buf_utd-marking-lines.doc-id = buf_utd.doc-id
                    and buf_utd-marking-lines.db-num = buf_utd.db-num,
                    first buf_marking EXCLUSIVE-LOCK where buf_marking.mark begins buf_utd-marking-lines.mark:
                    buf_marking.sts = Marking:PendingVerification:KeyIntDB .                                                       
                end.                                                        
            end.  
            if c-type = objSrv:Env:Utd:EDocType:Introduce:KeyIntDB and p-mode = {&add-def} then 
            do:
                if buf_utd.DocumentNumber = "" then buf_utd.DocumentNumber = string(buf_utd.doc-id) .
                assign
                    buf_utd.sts-edi = ObjSrv:Env:Utd:Sts:EDI:RecipientResponseStatusNotAccep:KeyIntDB
                    .  
            end.   

        end.
    
    
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-utd
&Scoped-define SELF-NAME br-utd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-utd d-utd
ON ROW-DISPLAY OF br-utd IN FRAME d-utd
    DO:
        case X_utd-lines.stts:
            when "Проверен" then
                do:
                    if type_mark = 1 then 
                    do:
                        X_utd-lines.LineNum:fGCOLOR in browse br-utd = CYAN_COLOR.
                        X_utd-lines.gds-code:fGCOLOR in browse br-utd = CYAN_COLOR.
                        X_utd-lines.ProductCode:fGCOLOR in browse br-utd = CYAN_COLOR.
                        X_utd-lines.Gds-Name:fGCOLOR in browse br-utd = CYAN_COLOR.
                        X_utd-lines.UnitCode:fGCOLOR in browse br-utd = CYAN_COLOR.
                        X_utd-lines.Quantity:fGCOLOR in browse br-utd = CYAN_COLOR.
                        X_utd-lines.price:fGCOLOR in browse br-utd = CYAN_COLOR.
                        X_utd-lines.total:fGCOLOR in browse br-utd = CYAN_COLOR.
                        X_utd-lines.TaxRate_:fgCOLOR in browse br-utd = CYAN_COLOR.
                        X_utd-lines.qnty-scan:fGCOLOR in browse br-utd = CYAN_COLOR.
                        X_utd-lines.fact-qnty:fGCOLOR in browse br-utd = CYAN_COLOR.
                        X_utd-lines.qnty-mark:fGCOLOR in browse br-utd = CYAN_COLOR.
                        X_utd-lines.stts:fGCOLOR in browse br-utd = CYAN_COLOR.
                    end.
                end.
            /*      when "Ожидает проверку" then                                          */
            /*        do:                                                                 */
            /*          if type_mark = 1 then                                             */
            /*          do:                                                               */
            /*            X_utd-lines.LineNum:fGCOLOR in browse br-utd = YELLOW_COLOR.    */
            /*            X_utd-lines.gds-code:fGCOLOR in browse br-utd = YELLOW_COLOR.   */
            /*            X_utd-lines.ProductCode:fGCOLOR in browse br-utd = YELLOW_COLOR.*/
            /*            X_utd-lines.Gds-Name:fGCOLOR in browse br-utd = YELLOW_COLOR.   */
            /*            X_utd-lines.UnitCode:fGCOLOR in browse br-utd = YELLOW_COLOR.   */
            /*            X_utd-lines.Quantity:fGCOLOR in browse br-utd = YELLOW_COLOR.   */
            /*            X_utd-lines.price:fGCOLOR in browse br-utd = YELLOW_COLOR.      */
            /*            X_utd-lines.total:fGCOLOR in browse br-utd = YELLOW_COLOR.      */
            /*            X_utd-lines.TaxRate_:fGCOLOR in browse br-utd = YELLOW_COLOR.   */
            /*            X_utd-lines.qnty-scan:fGCOLOR in browse br-utd = YELLOW_COLOR.  */
            /*            X_utd-lines.fact-qnty:fGCOLOR in browse br-utd = YELLOW_COLOR.  */
            /*            X_utd-lines.qnty-mark:fGCOLOR in browse br-utd = YELLOW_COLOR.  */
            /*            X_utd-lines.stts:fGCOLOR in browse br-utd = YELLOW_COLOR.       */
            /*          end.                                                              */
            /*        end.                                                                */
            when "Ошибка" then 
                do:
                    X_utd-lines.LineNum:fGCOLOR in browse br-utd = red_COLOR.
                    X_utd-lines.gds-code:fGCOLOR in browse br-utd = red_COLOR.
                    X_utd-lines.ProductCode:fGCOLOR in browse br-utd = red_COLOR.
                    X_utd-lines.Gds-Name:fGCOLOR in browse br-utd = red_COLOR.
                    X_utd-lines.UnitCode:fGCOLOR in browse br-utd = red_COLOR.
                    X_utd-lines.Quantity:fGCOLOR in browse br-utd = red_COLOR.
                    X_utd-lines.price:fGCOLOR in browse br-utd = red_COLOR.
                    X_utd-lines.total:fGCOLOR in browse br-utd = red_COLOR.
                    X_utd-lines.TaxRate_:fGCOLOR in browse br-utd = red_COLOR.
                    X_utd-lines.qnty-scan:fGCOLOR in browse br-utd = red_COLOR.
                    X_utd-lines.fact-qnty:fGCOLOR in browse br-utd = red_COLOR.
                    X_utd-lines.qnty-mark:fGCOLOR in browse br-utd = red_COLOR.
                    X_utd-lines.stts:fGCOLOR in browse br-utd = red_COLOR.
                end.      
        end case.
    END .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-utd d-utd
ON VALUE-CHANGED OF br-utd IN FRAME d-utd
    DO:

        f-info = "" .
        define variable vRecKey as character no-undo.
        define variable vRecKey-line as character no-undo.
        define variable vRecKey-markLine as character no-undo.
        if available (X_utd-lines) and available (buf_utd) then 
        do:
            br-utd :refresh() no-error .
            run gen-key-rec ("utd", 
                input  buffer buf_utd:handle, 
                output vRecKey).

            run gen-key-rec ("utd-lines", 
                input  buffer X_utd-lines:handle, 
                output vRecKey-line).
            mRecKey-line = vRecKey-line.
            vRecKey-markLine = replace(vRecKey-line,"utd-lines","utd-marking-lines") + {&delim-key}.
            menu-item m_error-lines:sensitive in menu m_error = yes.
            for each buf_utd-err no-lock where buf_utd-err.doc-id = X_utd-lines.doc-id
                and buf_utd-err.db-num = X_utd-lines.db-num
                and (buf_utd-err.reckey = vRecKey-line
                or buf_utd-err.reckey begins vRecKey-markLine or buf_utd-err.reckey = vRecKey):

                /*        menu-item m_error-lines:sensitive in menu m_error = yes.*/
                if f-info = "" then f-info = GetTextError(buf_utd-err.CheckType,buf_utd-err.CodeErr,buf_utd-err.CheckObj) + {&new-line} no-error.
                else do:
                    if length (f-info) >= 2000 then leave .
                f-info = f-info + GetTextError(buf_utd-err.CheckType,buf_utd-err.CodeErr,buf_utd-err.CheckObj) + {&new-line} no-error.
                end.

            end.
            line-num-error = X_utd-lines.LineNum .
        /*      else                                                     */
        /*      do:                                                      */
        /*        menu-item m_error-lines:sensitive in menu m_error = no.*/
        /*      end.                                                     */
        end.  
        display f-info with frame {&frame-name} .
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_back-check
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_back-check d-utd
ON CHOOSE OF b_back-check IN FRAME d-utd /* Продолжить на проверку */
    DO:
        if c-status = ObjSrv:Env:Utd:Sts:TH:LoadError:KeyIntDB then 
        do:
            c-status = ObjSrv:Env:Utd:Sts:TH:ReceivedFromSupplier:KeyIntDB .
        end.  
        else if c-status = ObjSrv:Env:Utd:Sts:TH:LackOfMarkingCodesInCirculation:KeyIntDB then 
            do:
                c-status = ObjSrv:Env:Utd:Sts:TH:VerificationPassed:KeyIntDB .
            /*    c-status-edi = ObjSrv:Env:Utd:Sts:EDI:Verification:KeyIntDB .*/
            end.  
            else 
            do:
                /*      if c-status = ObjSrv:Env:Utd:Sts:TH:InconsistencyWithSupplyContract:KeyIntDB then do:                                                     */
                /*              /*Перевод статуса марок*/                                                                                                         */
                /*      for each bf_utd-marking-lines no-lock where bf_utd-marking-lines.db-num = buf_utd.db-num and bf_utd-marking-lines.doc-id = buf_utd.doc-id,*/
                /*        first buf_marking exclusive-lock where buf_marking.mark = bf_utd-marking-lines.mark:                                                    */
                /*          if bf_utd-marking-lines.sts <> Marking:MarkError:KeyIntDB then do:                                                                    */
                /*              buf_marking.sts = Marking:DeliveryControl:KeyIntDB .                                                                              */
                /*          end.                                                                                                                                  */
                /*      end.                                                                                                                                      */
                /*      end.                                                                                                                                      */
                c-status = ObjSrv:Env:Utd:Sts:TH:AwaitingDelivery:KeyIntDB .
            /*    c-status-edi = ObjSrv:Env:Utd:Sts:EDI:Verification:KeyIntDB .*/

            end. 
        buf_utd.sts = integer(c-status).
        /*    buf_utd.sts-edi = integer(c-status-edi).*/
        buf_utd.comment = "" .
        f-comment:screen-value = "" .
        display c-status with frame {&frame-name} .
        run enable_UI in this-procedure .
        disable          
            b_correct
            b_recheck
            b_anul
            b_write-cancel
            b_finish
            b_prov-finish
            b_back-check
            b_deliv-cancel
            with frame {&frame-name} .  
    /*    run enable_BUTTON .*/
      
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_correct
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_correct d-utd
ON CHOOSE OF b_correct IN FRAME d-utd /* Запрос на изменение */
    DO:
        define variable v-ok as logical no-undo . 

        run ref/dialog-upd.w (input buf_utd.comment, input buf_utd.db-num, input buf_utd.doc-id, output v-comment, output v-ok) no-error.
        if  error-status:error then 
        do: 
            return return-value .
        end.
        if v-ok then 
        do:
            if buf_utd.comment <> "" then buf_utd.comment = buf_utd.comment + {&delim-cmd} + v-comment .
            else buf_utd.comment = v-comment .
            f-comment = buf_utd.comment .
            display f-comment with frame {&frame-name} . 
  
            if available (buf_utd) then 
            do:
                if p-connect <> ? then 
                do:
          
                    run Sendansver( buf_utd.db-num, buf_utd.doc-id, "CorrectionRequest", v-comment) no-error.    
                    if  error-status:error then 
                    do: 
                        return return-value .
                    end.
                end.
                else  
                    assign
                        buf_utd.sts     = ObjSrv:Env:Utd:Sts:TH:CorrectionRequested:KeyIntDB 
                        buf_utd.sts-edi = ObjSrv:Env:Utd:Sts:EDI:SignatureAdjustment:KeyIntDB 
                        .
                c-status = buf_utd.sts.
                c-status-edi = buf_utd.sts-edi.
            end.
        end.   
        display c-status c-status-edi with frame {&frame-name} .
        run enable_UI in this-procedure .
        disable          
            b_correct
            b_anul
            b_recheck
            b_write-cancel
            b_prov-finish
            b_finish
            b_prov-finish
            b_back-check
            b_deliv-cancel
            with frame {&frame-name} .
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b_anul
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_anul d-utd
ON CHOOSE OF b_anul IN FRAME d-utd /* Аннулировать */
    DO:
        c-status = ObjSrv:Env:Utd:Sts:TH:Canceled:KeyIntDB .
        buf_utd.sts = integer(c-status).
        run enable_UI in this-procedure .
        disable          
            b_correct
            b_recheck
            b_anul
            b_write-cancel
            b_prov-finish
            b_finish
            b_back-check
            b_deliv-cancel
            with frame {&frame-name} .  
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME m_error-utd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_error-utd m_error
ON CHOOSE OF MENU-ITEM m_error-utd /* Ошибки */
    DO:
        define variable v-ok as logical no-undo . 
    
        run ref/dialog-error.w (input buf_utd.db-num, input buf_utd.doc-id, input "" , input 0) .
        if  error-status:error then 
        do: 
            return return-value .
        end.
        run enable_UI in this-procedure .
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_error-lines
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_error-lines m_error
ON CHOOSE OF MENU-ITEM m_error-lines /* Ошибки товара */
    DO:
        define variable v-ok as logical no-undo . 
   
        run ref/dialog-error.w (input buf_utd.db-num, input buf_utd.doc-id, input mRecKey-line, input line-num-error ) .
        if  error-status:error then 
        do: 
            return return-value .
        end.
        run enable_UI in this-procedure .
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_finish
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_finish d-utd
ON CHOOSE OF b_finish IN FRAME d-utd /* Ввод в оборот */
    DO:
        define variable Log-Res  as logical no-undo.
        define variable quest-ok as logical no-undo .
        /*Проверка прав */
        { gbl/chk-actg.i
  v-cntxt-db-num
  v-cntxt-userid
  {&action-head-code-main}
  'actn_mark_befree':U
  {&cntxt-firm}
  v-cntxt-host-code-obj
  '':U
  0
  0
  0
  0
  true
  log-res
}
 
        if available (buf_utd) and log-res then 
        do:
            message "Уверены, что продажи по маркированной продукции закрыты?"
                view-as alert-box question buttons yes-no update quest-ok.
            if quest-ok then 
            do:
                run utl/utd-mark-introduce.p (input buf_utd.db-num, input buf_utd.doc-id) no-error.
                if  error-status:error then 
                do: 
                    return return-value .
                end.
                assign
                    c-status     = buf_utd.sts
                    c-status-edi = buf_utd.sts-edi 
                    .

            end.
        end.
        run enable_UI in this-procedure .
        disable          
            b_correct
            b_recheck
            b_anul
            b_write-cancel
            b_prov-finish
            b_finish
            b_prov-finish
            b_back-check
            b_deliv-cancel
            with frame {&frame-name} .  
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_marks-lines
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_marks-lines m_marks
ON CHOOSE OF menu-item m_marks-lines  /* Марки */
    DO:
        apply "entry" to br-utd in frame {&frame-name}.
        if available (X_utd-lines) then 
        do:
            recid_utd = recid(X_utd-lines) .
            run temp-mark (input 1) .  
            if available (tt-marking-lines) then 
            do:
                run str/mark_browse.w (input parparentproc,
                    input-output table tt-marking-lines by-reference,
                    input p-mode,
                    input "Марки по: " + EdoTypeName(buf_utd.EDocType) + " " + buf_utd.DocumentNumber + " по товару " + string(X_utd-lines.gds-code) + " " + GdsName(X_utd-lines.gds-code),
                    input type_mark,
                    input "" /*тип продукции*/
                    ) no-error .
                { gbl/brwrepos.i
              &line-num= 5
            }
            empty temp-table tt-marking-lines .
                run mark-temp .
                run enable_BUTTON .
                if c-status = ObjSrv:Env:Utd:Sts:TH:AwaitingDelivery:KeyIntDB then 
                do:
                    find first X_utd-lines no-lock where X_utd-lines.stts <> "Проверен" no-error .
                    if available (X_utd-lines) then 
                    do:
                        F-text = "                            Просканируйте марку" .
                        f-text:screen-value = "" .
                        display F-text with frame {&frame-name} .
                    end.
                    else 
                    do:
                        F-text = "" .
                        f-text:screen-value = "" .
                        display F-text with frame {&frame-name} .
                    end.  
                end.
            end.
            else 
            do:
                message "Нет марок"
                    view-as alert-box.
            end.    
            br-utd :refresh() no-error .
            
            reposition br-utd to recid recid_utd no-error .

        end.
        else message "Нет марок"
                view-as alert-box.  
        return no-apply .

    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_marks-utd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_marks-utd m_marks
ON CHOOSE OF menu-item m_marks-utd /* Марки по документу */
    DO:
        apply "entry" to br-utd in frame {&frame-name}.
        recid_utd = recid (X_utd-lines) .
        run temp-mark (input 2) .
        if available (tt-marking-lines) then 
        do:
            run str/mark_browse.w (input parparentproc,
                input-output table tt-marking-lines by-reference,
                input p-mode,
                input "Марки по документу: " + EdoTypeName(buf_utd.EDocType) + " " + buf_utd.DocumentNumber,
                input type_mark,
                input "" /*тип продукции*/
                ) no-error .
            empty temp-table tt-marking-lines .
            run mark-temp .
            run enable_BUTTON .
            if c-status = ObjSrv:Env:Utd:Sts:TH:AwaitingDelivery:KeyIntDB then 
            do:
                find first X_utd-lines no-lock where X_utd-lines.stts <> "Проверен" no-error .
                if available (X_utd-lines) then 
                do:
                    F-text = "                            Просканируйте марку" .
                    f-text:screen-value = "" .
                    display F-text with frame {&frame-name} .
                end.
                else 
                do:
                    F-text = "" .
                    f-text:screen-value = "" .
                    display F-text with frame {&frame-name} .
                end.  
            end.
            br-utd :refresh() no-error.
 
            reposition br-utd to recid recid_utd no-error .
        end.
        else 
        do:
            message "Нет марок по документу УПД"
                view-as alert-box.
        end.    
        run enable_UI in this-procedure .
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_prov-finish
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_prov-finish d-utd
ON CHOOSE OF b_prov-finish IN FRAME d-utd /* Проверка завершена */
    DO:
        define variable v-ok        as logical no-undo .
        define variable v-check     as logical no-undo .
        define variable v-qnty-mark as integer no-undo .
        define variable v-fact-qnty as integer no-undo .
        define buffer bf_utd-marking-lines for ub.utd-marking-lines .
        define buffer bf_utd-lines-attr    for ub.utd-lines-attr .
        define buffer bf_utd-lines         for ub.utd-lines .
        define buffer bf_marking           for ub.marking .
        define variable v-not-mark as integer no-undo .

        find first buf_utd-marking-lines no-lock where buf_utd-marking-lines.db-num = buf_utd.db-num and 
            buf_utd-marking-lines.doc-id = buf_utd.doc-id no-error .
        if not available (buf_utd-marking-lines) then 
        do:
            message "В документе нет марок"
                view-as alert-box.
            return no-apply .
        end.  

        if c-status = ObjSrv:Env:Utd:Sts:TH:AwaitingDelivery:KeyIntDB then 
        do:
            /*Проверка МОЛ проверяется только в статусе Ожидает проверку*/
            run check_mol (output v-check).
            if not v-check then return no-apply .
            run save_mol.
        end.
    
        for each X_utd-lines where X_utd-lines.qnty-mark <> X_utd-lines.qnty-scan:
            v-ok = yes .
        end.       
        for each X_utd-lines where X_utd-lines.Quantity = 0 or X_utd-lines.Quantity = ?:
             v-ok = yes . 
        end.
        if v-ok and (c-type = objSrv:Env:Utd:EDocType:UTD:KeyIntDB or c-type = objSrv:Env:Utd:EDocType:EDoc:KeyIntDB) then 
        do:  
            run ref/dialog-ok.w (output v-comment
                ) no-error .
            if v-comment = "" then return NO-APPLY .  
        end .  
        /*Если тип УПД*/
    
        if c-type = objSrv:Env:Utd:EDocType:UTD:KeyIntDB or c-type = objSrv:Env:Utd:EDocType:EDoc:KeyIntDB then 
        do:
            /*Если не допоставка статус - Несоответствие кодов маркировки при поставке */
            if v-ok then c-status = ObjSrv:Env:Utd:Sts:TH:DeliveryCodeMismatch:KeyIntDB . 
            /*Если все хорошо - Требует подписания*/
            else c-status = ObjSrv:Env:Utd:Sts:TH:SignatureRequired:KeyIntDB .
            /*Перевод статуса марок*/
            for each bf_utd-marking-lines no-lock where bf_utd-marking-lines.db-num = buf_utd.db-num and bf_utd-marking-lines.doc-id = buf_utd.doc-id,
                first buf_marking exclusive-lock where buf_marking.mark = bf_utd-marking-lines.mark:
                case bf_utd-marking-lines.sts:
                    when Marking:Checked_:KeyIntDB then 
                        do:
                            if buf_marking.sts <> Marking:MarkError:KeyIntDB then
                                buf_marking.sts = Marking:Checked_:KeyIntDB .
                        end.
                    when Marking:MarkError:KeyIntDB then 
                        do:
                        end.    
                    otherwise 
                    do:
                        if buf_marking.sts <> Marking:MarkError:KeyIntDB then  
                            buf_marking.sts = Marking:NotAvailable:KeyIntDB .
                    end.  
                end.  
            end.
        
        end.
        else 
        do:  
            /*Если тип АКТ*/
            if c-type = objSrv:Env:Utd:EDocType:AKT:KeyIntDB then 
            do:
                /*Статус - подтвержден*/
                c-status = ObjSrv:Env:Utd:Sts:TH:Confirmed:KeyIntDB .
            end.
            /*Если тип - первоначальный ввод*/
            if c-type =  objSrv:Env:Utd:EDocType:Introduce:KeyIntDB then 
            do: 
                /*Поменять статус*/
                /*Статус - Ожидает подтверждения МОТП*/
                c-status = ObjSrv:Env:Utd:Sts:TH:AwaitingConfirmation:KeyIntDB .
                /*Сохраняем кол-во не маркированной продукции*/
                for each bf_utd-lines no-lock where bf_utd-lines.doc-id = buf_utd.doc-id and
                    bf_utd-lines.db-num = buf_utd.db-num:
                    v-qnty-mark = 0 .
                    v-fact-qnty = 0 .
                    for each bf_utd-marking-lines no-lock where bf_utd-marking-lines.doc-id = bf_utd-lines.doc-id and
                        bf_utd-marking-lines.db-num = bf_utd-lines.db-num and
                        bf_utd-marking-lines.gds-code = bf_utd-lines.gds-code and
                        bf_utd-marking-lines.LineNum = bf_utd-lines.LineNum,
                        first bf_marking no-lock where bf_marking.mark = bf_utd-marking-lines.mark:
                                                         
                        /*          for each bf_marking no-lock where bf_marking.gds-code = bf_utd-lines.gds-code and*/
                        /*                                            bf_marking.obj-code = buf_utd.obj-code and     */
                        /*                                            bf_marking.obj-type = buf_utd.obj-type and     */
                        /*                                            bf_marking.unit-ext = "UNIT":                  */
                        /*Кол-во марок по товару*/
                        v-qnty-mark = v-qnty-mark + bf_marking.box-qnty .
                    end.  
                    for first bf_utd-lines-attr exclusive-lock where bf_utd-lines-attr.db-num = bf_utd-lines.db-num and
                        bf_utd-lines-attr.doc-id = bf_utd-lines.doc-id and
                        bf_utd-lines-attr.LineNum = bf_utd-lines.LineNum and
                        bf_utd-lines-attr.attr-code = "utd-fact-qnty":
                        /*Кол-во всего товара*/
                        v-fact-qnty = integer(bf_utd-lines-attr.attr-value) . 
                    end.
                    /*Кол-во не маркированного товара*/
                    v-not-mark = v-fact-qnty - v-qnty-mark .      
                    find first bf_utd-lines-attr exclusive-lock where bf_utd-lines-attr.doc-id = bf_utd-lines.doc-id and
                        bf_utd-lines-attr.db-num = bf_utd-lines.db-num and
                        bf_utd-lines-attr.LineNum = bf_utd-lines.LineNum and
                        bf_utd-lines-attr.attr-code = "NoMarking" no-error .
                    if not available (bf_utd-lines-attr) then 
                    do:
                        create bf_utd-lines-attr .
                        assign
                            bf_utd-lines-attr.doc-id    = bf_utd-lines.doc-id
                            bf_utd-lines-attr.db-num    = bf_utd-lines.db-num
                            bf_utd-lines-attr.LineNum   = bf_utd-lines.LineNum
                            bf_utd-lines-attr.attr-code = "NoMarking"
                            .
                    end.                                    
                    assign
                        bf_utd-lines-attr.attr-value = string(v-not-mark) .
                    .                                                             
                end.   
            end.
        end.
        buf_utd.sts = integer(c-status).
  
        run enable_UI in this-procedure .
        buf_utd.comment = v-comment .
        f-comment = v-comment .
    
        display f-comment c-status with frame {&frame-name}.
        apply "choose" to b-save in frame {&frame-name}. 
    
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_recheck
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_recheck d-utd
ON CHOOSE OF b_recheck IN FRAME d-utd /* Повторно проверить */
    DO:
        define variable Log-Res as logical no-undo.
    
        if available (buf_utd)
            then 
        do:
            /*Проверка прав */
            { gbl/chk-actg.i
        v-cntxt-db-num
        v-cntxt-userid
        {&action-head-code-main}
        'actn_edi-doc_recheck':U
        {&cntxt-firm}
        v-cntxt-host-code-obj
        '':U
        0
        0
        0
        0
        true
        log-res
      }  

            if log-res 
                then 
            do:
                Recheck(buf_utd.db-num, buf_utd.doc-id).
                assign
                    c-status     = buf_utd.sts
                    c-status-edi = buf_utd.sts-edi
                    f-comment    = buf_utd.comment
                    .
                display f-info c-status c-status-edi f-comment with frame {&frame-name} .
                run enable_UI in this-procedure .
                run mark-temp .
                {&OPEN-QUERY-br-utd}
                run enable_BUTTON in this-procedure .
            end.
        end.
    end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_write-cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_write-cancel d-utd
ON CHOOSE OF b_write-cancel IN FRAME d-utd /* Отказать в подписи */
    DO:
        define variable v-ok as logical no-undo .
        if available (buf_utd) then 
        do:
            run ref/dialog-upd.w (input buf_utd.comment, input buf_utd.db-num, input buf_utd.doc-id, output v-comment, output v-ok) no-error.
            if  error-status:error then 
            do: 
                return return-value .
            end.
            if v-ok then 
            do:
                if buf_utd.comment <> "" then buf_utd.comment = buf_utd.comment + {&delim-cmd} + v-comment .
                else buf_utd.comment = v-comment .
                f-comment = buf_utd.comment .
                display f-comment with frame {&frame-name} .
                if p-connect <> ? then 
                do: 
                    run SendResponse( buf_utd.db-num, buf_utd.doc-id, no, no) no-error.    
                    if  error-status:error then 
                    do: 
                        return return-value .
                    end.
                end.
                else 
                do: 
                    buf_utd.sts = ObjSrv:Env:Utd:Sts:TH:RejectionUtd:KeyIntDB.
                    buf_utd.sts-edi = ObjSrv:Env:Utd:Sts:EDI:AutoRejected:KeyIntDB.
        
                end.
         
            end.
            assign
                c-status     = buf_utd.sts
                c-status-edi = buf_utd.sts-edi 
                .
            display c-status c-status-edi with frame {&frame-name} .     
            /*    run enable_BUTTON .*/
            disable          
                b_correct
                b_recheck
                b_anul
                b_write-cancel
                b_prov-finish
                b_finish
                b_back-check
                b_deliv-cancel
                with frame {&frame-name} .
        end.
      
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b_deliv-cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_deliv-cancel d-utd
ON CHOOSE OF b_deliv-cancel IN FRAME d-utd /* Отказать в подписи */
    DO:
        define variable v-ok as logical no-undo .
        if available (buf_utd) then 
        do:
            run ref/dialog-upd.w (input buf_utd.comment, input buf_utd.db-num, input buf_utd.doc-id, output v-comment, output v-ok) no-error.
            if  error-status:error then 
            do: 
                return return-value .
            end.
            if v-ok then 
            do:
                if buf_utd.comment <> "" then buf_utd.comment = buf_utd.comment + {&delim-cmd} + v-comment .
                else buf_utd.comment = v-comment .
                f-comment = buf_utd.comment .
                display f-comment with frame {&frame-name} . 
      
                if p-connect <> ? then 
                do: 
                    run SendAnsver(buf_utd.db-num, buf_utd.doc-id,"AcceptDocumentNotAccepted", "") no-error.
                    if  error-status:error then 
                    do: 
                        return return-value .
                    end.
                end.
                else 
                do: 
                    buf_utd.sts = ObjSrv:Env:Utd:Sts:TH:RejectionUtd:KeyIntDB.
                    buf_utd.sts-edi = ObjSrv:Env:Utd:Sts:EDI:SignatureNotAccepted:KeyIntDB.
    
                end.
                validate buf_utd no-error.
                assign
                    c-status     = buf_utd.sts
                    c-status-edi = buf_utd.sts-edi 
                    .
            end.
        end.
        display c-status c-status-edi with frame {&frame-name} .     
        disable          
            b_correct
            b_recheck
            b_anul
            b_write-cancel
            b_prov-finish
            b_finish
            b_back-check
            b_deliv-cancel
            with frame {&frame-name} .  
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-status
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-status d-utd
ON VALUE-CHANGED OF c-status IN FRAME d-utd /* Статус ТН */
    DO:
        assign c-status .
        if c-type = 0 then 
        do:
            message "Укажите тип документа"
                view-as alert-box.
        end.  
    
        buf_utd.sts = integer(c-status).
        validate buf_utd no-error.
        c-status = buf_utd.sts.
        c-status-edi = buf_utd.sts-edi.
        display c-status c-status-edi with frame {&frame-name} .
        run enable_BUTTON .
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-status-edi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-status-edi d-utd
ON VALUE-CHANGED OF c-status-edi IN FRAME d-utd /* Статус EDI */
    DO:
        assign c-status-edi .
        if c-type = 0 then 
        do:
            message "Укажите тип документа"
                view-as alert-box.
        end.  
    
        buf_utd.sts-edi = integer(c-status-edi).
        validate buf_utd no-error.
        c-status = buf_utd.sts.
        c-status-edi = buf_utd.sts-edi.
        display c-status c-status-edi with frame {&frame-name} .
        run enable_BUTTON .
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-type
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-type d-utd
ON VALUE-CHANGED OF c-type IN FRAME d-utd /* Тип */
    DO:
        assign c-type .
        if available (buf_utd) then buf_utd.EDocType = c-type .
        F-text = "                            Просканируйте марку" . 
        display f-text with frame {&frame-name} .
        if c-type <> objSrv:Env:Utd:EDocType:Introduce:KeyIntDB then 
        do:
            browse br-utd:GET-BROWSE-COLUMN(10):VISIBLE = no no-error. 
        end.
        else browse br-utd:GET-BROWSE-COLUMN(10):VISIBLE = yes no-error.
        run enable_UI .
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-agnt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-agnt d-utd
ON leave OF f-agnt IN FRAME d-utd /* Исп */
    DO:
        define buffer buf_clients for ub.clients .
        assign f-agnt .
        find first buf_clients no-lock where buf_clients.obj-code = f-agnt and buf_clients.obj-type = {&prs} no-error . 
        IF NOT AVAILABLE buf_clients THEN 
        do:
            f-agnt = ? .
        end.  
        else 
        do:
            ASSIGN
                f-agnt    = buf_clients.obj-code
                agnt-name = buf_clients.obj-name
                .
        end. 
        display f-agnt agnt-name  with frame {&frame-name}.

    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-boss
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-boss d-utd
ON leave OF f-boss IN FRAME d-utd /* М-р */
    DO:
        define buffer buf_clients for ub.clients .
        assign f-boss .
        find first buf_clients no-lock where buf_clients.obj-code = f-boss and buf_clients.obj-type = {&prs} no-error . 
        IF NOT AVAILABLE buf_clients THEN 
        do:
            f-boss = ? .
        end.  
        else 
        do:
            ASSIGN
                f-boss    = buf_clients.obj-code
                boss-name = buf_clients.obj-name
                .
        end.   
        display f-boss boss-name  with frame {&frame-name}.

    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-wrkr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-wrkr d-utd
ON leave OF f-wrkr IN FRAME d-utd /* Кл-к */
    DO:
        define buffer buf_clients for ub.clients .
        assign f-wrkr .
        find first buf_clients no-lock where buf_clients.obj-code = f-wrkr and buf_clients.obj-type = {&prs} no-error . 
        IF NOT AVAILABLE buf_clients THEN 
        do:
            f-wrkr = ? .
        end.  
        else 
        do:
            ASSIGN
                f-wrkr    = buf_clients.obj-code
                wrkr-name = buf_clients.obj-name
                .
        end. 
        display f-wrkr wrkr-name  with frame {&frame-name}.

    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_choose-status
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_choose-status d-utd
ON CHOOSE OF MENU-ITEM m_choose-status /* Сменить статус документа */
    DO:
        enable c-status with frame {&frame-name} . 
        if c-type = objSrv:Env:Utd:EDocType:UTD:KeyIntDB or c-type = objSrv:Env:Utd:EDocType:EDoc:KeyIntDB then enable c-status-edi with frame {&frame-name} . 
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME m_check-akt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_check-akt d-utd
ON CHOOSE OF MENU-ITEM m_check-akt /* Проверить по Акту приема-передачи */
    DO:
        define buffer bf_utd for ub.utd .
        define variable v-rec-list as character no-undo .
        define buffer buf_utd-marking-lines for ub.utd-marking-lines .
        define buffer bf_utd-marking-lines  for ub.utd-marking-lines .
        define buffer bf_marking            for ub.marking .
    
        find first bf_utd exclusive-lock where bf_utd.DocumentNumber = buf_utd.DocumentNumber and 
            bf_utd.DocumentDate = buf_utd.DocumentDate and bf_utd.edoctype = objSrv:Env:Utd:EDocType:AKT:KeyIntDB no-error .
        if not available (bf_utd) then 
        do:
            define variable vconnect as com-handle no-undo.
            run str/UPD.w ( parparentproc, {&select}, objSrv:Env:Utd:EDocType:AKT:KeyIntDB, "", input-output vconnect, output v-rec-list)  no-error .
  
            find first bf_utd exclusive-lock where recid(bf_utd) = integer(v-rec-list) no-error .
        end.  
        if available (bf_utd) then 
        do:
            /*Ищем, все ли марки есть в УПД*/
            for each bf_utd-marking-lines no-lock where bf_utd-marking-lines.db-num = bf_utd.db-num 
                and bf_utd-marking-lines.doc-id = bf_utd.doc-id:
                define variable vmark as character no-undo.
                vmark = getcodeident(bf_utd-marking-lines.mark).
                find first buf_utd-marking-lines no-lock where buf_utd-marking-lines.db-num = buf_utd.db-num 
                    and buf_utd-marking-lines.doc-id = buf_utd.doc-id 
                    and buf_utd-marking-lines.mark begins vmark no-error .
                if not available (buf_utd-marking-lines) then 
                do:
                    message "В документе неполный состав марок. Просканируйте марки вручную." 
                        view-as alert-box.
                    return .
                end.  
            end. 
            
            qnty-gray = 0 .
            qnty-check = 0 .
            for each bf_utd-marking-lines exclusive-lock where bf_utd-marking-lines.db-num = bf_utd.db-num 
                and bf_utd-marking-lines.doc-id = bf_utd.doc-id, 
                first buf_utd-marking-lines exclusive-lock where buf_utd-marking-lines.db-num = buf_utd.db-num 
                and buf_utd-marking-lines.doc-id = buf_utd.doc-id 
                and buf_utd-marking-lines.mark begins bf_utd-marking-lines.mark
                and buf_utd-marking-lines.doc-level = 1  :
                if length (buf_utd-marking-lines.mark) > length(bf_utd-marking-lines.mark)
                then do:
                   find first bf_marking where bf_marking.mark eq buf_utd-marking-lines.mark
                   no-lock no-error.
                   if available bf_marking
                   then do:
                      find first bf_marking where bf_marking.mark eq bf_utd-marking-lines.mark
                      exclusive-lock no-error.
                      if available bf_marking
                      then do:
                         g#auto = yes.
                         delete bf_marking.
                         g#auto = no.
                      end.
                   end.
                   bf_utd-marking-lines.mark = buf_utd-marking-lines.mark.
                end.
                find first buf_marking no-lock where buf_marking.mark = buf_utd-marking-lines.mark 
                                                 and (   buf_marking.sts = Marking:GrayZone:KeyIntDB
                                                      or buf_marking.sts = Marking:MarkError:KeyIntDB) no-error .
                if not available (buf_marking) then 
                do:
                    if tree:LevelDownUTD(buf_utd-marking-lines.mark, buf_utd-marking-lines.doc-id, buf_utd-marking-lines.db-num) then 
                    do:
                        tree:StatusDownUTD(buf_utd-marking-lines.mark, buf_utd-marking-lines.doc-id, buf_utd-marking-lines.db-num, Marking:Checked_:KeyIntDB) .
                    end.
                    for first buf_marking exclusive-lock where buf_marking.mark = buf_utd-marking-lines.mark:
                        qnty-check = qnty-check + buf_marking.box-qnty .
                        buf_marking.sts = Marking:Checked_:KeyIntDB.
                        buf_utd-marking-lines.sts = Marking:Checked_:KeyIntDB.
                    
                    end.  
                end.
            end.   
            for each buf_utd-marking-lines exclusive-lock where buf_utd-marking-lines.db-num = buf_utd.db-num 
                 and buf_utd-marking-lines.doc-id = buf_utd.doc-id 
                 and buf_utd-marking-lines.sts <> Marking:Checked_:KeyIntDB
                 and buf_utd-marking-lines.doc-level = 1  :
               find first buf_marking no-lock where buf_marking.mark = buf_utd-marking-lines.mark no-error.
               find first bf_utd-marking-lines exclusive-lock where bf_utd-marking-lines.db-num = bf_utd.db-num 
                      and bf_utd-marking-lines.doc-id = bf_utd.doc-id
                      and bf_utd-marking-lines.mark begins buf_utd-marking-lines.mark.
               if not available bf_utd-marking-lines
               then do:
                  qnty-gray = qnty-gray + buf_marking.box-qnty .
               end.
               else do:
                  if length (buf_utd-marking-lines.mark) < length(bf_utd-marking-lines.mark)
                  then do:
                     find first bf_marking where bf_marking.mark eq buf_utd-marking-lines.mark
                        no-lock no-error.
                     if available bf_marking
                     then do:
                        find first bf_marking where bf_marking.mark eq bf_utd-marking-lines.mark
                        exclusive-lock no-error.
                        if available bf_marking
                        then do:
                           g#auto = yes.
                           delete bf_marking.
                           g#auto = no.
                        end.
                     end.
                     bf_utd-marking-lines.mark = buf_utd-marking-lines.mark.
                  end.
                  if    buf_marking.sts = Marking:GrayZone:KeyIntDB
                     or buf_marking.sts = Marking:MarkError:KeyIntDB 
                  then do:
                     qnty-gray = qnty-gray + buf_marking.box-qnty .
                  end.
                  else do:
                     qnty-check = qnty-check + buf_marking.box-qnty .
                     buf_marking.sts = Marking:Checked_:KeyIntDB.
                     buf_utd-marking-lines.sts = Marking:Checked_:KeyIntDB.
                  end.
               end.
            end. 
            /*Запишем номер УПД в акт*/
            bf_utd.doc-code = buf_utd.DocumentNumber .        
            message "Проверка завершена" skip
                "Успешно проверено марок - " + string (qnty-check) skip
                "Не проверено марок - " + string (qnty-gray) skip
                view-as alert-box.
            if qnty-gray <> 0 then 
            do:
                F-text = "                            Просканируйте марку" .
                display F-text with frame {&frame-name} .
            end.
        end.
        run mark-temp .
        {&OPEN-QUERY-br-utd}

    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME r-agnt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL r-agnt d-utd
ON CHOOSE OF r-agnt IN FRAME d-utd /* r-acc */
    DO:
        run ref/cli-all.w (
            input parparentproc
            ,input "b-sel"
            ,input {&prs}
            ,input {&all}
            ,input {&current}
            ,input ?
            ,input ",,,,,,NO,,"
            ,input ""
            ,output v-rid-list ) NO-ERROR.
        IF v-rid-list = '':U THEN RETURN NO-APPLY.
        FIND FIRST buf_clients NO-LOCK WHERE
            recid(buf_clients) = INTEGER(v-rid-list) NO-ERROR.
        IF NOT AVAILABLE buf_clients THEN RETURN NO-APPLY.
        ASSIGN
            f-agnt    = buf_clients.obj-code
            agnt-name = buf_clients.obj-name
            .
        display f-agnt agnt-name  with frame {&frame-name}.

    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME r-boss
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL r-boss d-utd
ON CHOOSE OF r-boss IN FRAME d-utd /* r-acc */
    DO:
        run ref/cli-all.w (
            input parparentproc
            ,input "b-sel"
            ,input {&prs}
            ,input {&all}
            ,input {&current}
            ,input ?
            ,input ",,,,,,NO,,"
            ,input ""
            ,output v-rid-list ) NO-ERROR.
        IF v-rid-list = '':U THEN RETURN NO-APPLY.
        FIND FIRST buf_clients NO-LOCK WHERE
            recid(buf_clients) = INTEGER(v-rid-list) NO-ERROR.
        IF NOT AVAILABLE buf_clients THEN RETURN NO-APPLY.
        ASSIGN
            f-boss    = buf_clients.obj-code
            boss-name = buf_clients.obj-name
            .
        display f-boss boss-name  with frame {&frame-name}.

    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME r-contr-TH
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL r-contr-TH d-utd
ON CHOOSE OF r-contr-TH IN FRAME d-utd
    DO:
    define buffer buf_contract for ub.contract.
    define buffer buf_contract-attr for ub.contract-attr .
    define variable agnt-list as character no-undo .
    if f-supp-code-TH <> 0 then 
    do:
      /*Если есть поставщик*/
      run str/cont-all.w ( input  parParentProc, input v-cntxt-host-code-obj, input "b-sel":U, input {&company}, input f-supp-type-TH, input f-supp-code-TH, input  ?, input  ?, input  "current", input {&income} , input-output agnt-list   ) no-error .
      find first buf_contract no-lock where RECID(buf_contract) = int (agnt-list) no-error.
      if not available buf_contract then 
      do:
        assign
          f-contr-TH      = 0
          /*      v-contr-host = 0*/
          f-contr-name-TH = ""
          .
        display f-contr-TH f-contr-name-TH  with frame {&frame-name}.
        return.
      end.
      /*Если АКТ*/
      if c-type = objSrv:Env:Utd:EDocType:AKT:KeyIntDB then 
      do:
        define variable v-tth             as handle    no-undo .
        define variable v-value-character as character no-undo.
        define variable v-value-date      as date      no-undo.
        define variable v-value-decimal   as decimal   no-undo.
        define variable v-value-integer   as integer   no-undo.
        define variable v-param-type      as character no-undo.
        define variable v-FlagEdo         as logical   no-undo.
        run adm/shattri.p (
          input "get":U
          ,input  buf_utd.obj-type /*p-obj-type*/
          ,input  buf_utd.obj-code /*p-obj-code*/
          ,input  {&attr-marking}
          ,input  {&attr-marking_marking-EDO} /*p-param-code*/
          ,output v-value-character
          ,output v-value-date
          ,output v-value-decimal
          ,output v-value-integer
          ,output v-FlagEdo
          ,output v-param-type
          ,input-output table-handle v-tth
          ) no-error .
 /*Если есть параметр*/
        if v-FlagEdo then 
        do:
          find first buf_contract-attr exclusive-lock where buf_contract-attr.contract-code = buf_contract.contract-code
            and buf_contract-attr.host-code = buf_contract.host-code and buf_contract-attr.attr-code = "contract-edi" no-error .
          if not available (buf_contract-attr) then do:
            message "У договора " + buf_contract.contract-prn-code + " нет признака - 'Поставки через ЭДО'"
              view-as alert-box.
            return no-apply .
          end.  
          if buf_contract-attr.attr-value = "yes" then 
          do:
            assign
              f-contr-TH      = buf_contract.contract-code
              /*    v-contr-host   = buf_contract.host-code*/
              f-contr-name-TH = buf_contract.contract-prn-code + " от " + string(buf_contract.contract-date,"99/99/9999")
              .
          end.
          else 
          do:
            message "У договора " + buf_contract.contract-prn-code + " нет признака - 'Поставки через ЭДО'"
              view-as alert-box.
            return no-apply .
          end.    
      
        end.  
        else 
        do:
          assign
            f-contr-TH      = buf_contract.contract-code
            /*    v-contr-host   = buf_contract.host-code*/
            f-contr-name-TH = buf_contract.contract-prn-code + " от " + string(buf_contract.contract-date,"99/99/9999")
            .
        end.
      end.    
      /*Если нет параметра*/  
      else 
      do:  
        assign
          f-contr-TH      = buf_contract.contract-code
          /*    v-contr-host   = buf_contract.host-code*/
          f-contr-name-TH = buf_contract.contract-prn-code + " от " + string(buf_contract.contract-date,"99/99/9999")
          .
      end.
      display f-contr-TH f-contr-name-TH  with frame {&frame-name}.
      if c-type <> objSrv:Env:Utd:EDocType:AKT:KeyIntDB then
      disable r-contr-TH with frame {&frame-name} .
    end.
    /*Нет поставщика*/
    else message "Поставщик договора не известен"
        view-as alert-box.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME r-obj-TH
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL r-obj-TH d-utd
ON CHOOSE OF r-obj-TH IN FRAME d-utd
    DO:
        run ref/cli-all.w (
            input parparentproc
            ,input "b-sel"
            ,input {&shop}
            ,input {&all}
            ,input {&current}
            ,input ?
            ,input ",,,,,,NO,,"
            ,input ""
            ,output v-rid-list ) NO-ERROR.
        IF v-rid-list = '':U THEN RETURN NO-APPLY.
        FIND FIRST buf_clients NO-LOCK WHERE
            recid(buf_clients) = INTEGER(v-rid-list) NO-ERROR.
        IF NOT AVAILABLE buf_clients THEN RETURN NO-APPLY.
        ASSIGN
            f-obj-type-TH = buf_clients.obj-type
            f-obj-code-TH = buf_clients.obj-code
            f-obj-name-TH = buf_clients.obj-name
            .
        display f-obj-code-TH f-obj-type-TH f-obj-name-TH  with frame {&frame-name}.
        disable r-obj-TH with frame {&frame-name} .
        run enable_BUTTON .
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME r-supp-TH
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL r-supp-TH d-utd
ON CHOOSE OF r-supp-TH IN FRAME d-utd
    DO:
        run ref/cli-all.w (
            input parparentproc
            ,input "b-sel"
            ,input {&cmp}
            ,input {&all}
            ,input {&current}
            ,input ?
            ,input ",,,,,,NO,,"
            ,input ""
            ,output v-rid-list ) NO-ERROR.
        IF v-rid-list = '':U THEN RETURN NO-APPLY.
        FIND FIRST buf_clients NO-LOCK WHERE
            recid(buf_clients) = INTEGER(v-rid-list) NO-ERROR.
        IF NOT AVAILABLE buf_clients THEN RETURN NO-APPLY.
        ASSIGN
            f-supp-type-TH = buf_clients.obj-type
            f-supp-code-TH = buf_clients.obj-code
            f-supp-name-TH = buf_clients.obj-name
            .
        display f-supp-type-TH f-supp-code-TH f-supp-name-TH with frame {&frame-name} .
        if c-type <> objSrv:Env:Utd:EDocType:AKT:KeyIntDB then 
            disable r-supp-TH with frame {&frame-name} .
            run enable_BUTTON .
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME R-error
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-error d-utd
ON value-changed OF R-error IN FRAME d-utd
    DO:
        assign R-error .
        {&OPEN-QUERY-br-utd}
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME R-error-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-error-2 d-utd
ON value-changed OF R-error-2 IN FRAME d-utd
    DO:
        assign R-error-2 .
        {&OPEN-QUERY-br-utd}
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME f-num
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-num d-utd
ON value-changed OF f-num IN FRAME d-utd
    DO:
        assign f-num .
        display f-num with frame {&frame-name} .
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME F-date
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-date d-utd
ON RETURN OF F-date IN FRAME d-utd
    DO:
        apply "TAB":U to self .
        return no-apply .
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-date d-utd
ON TAB OF F-date IN FRAME d-utd
    DO:
        assign f-date .
        display f-date with frame {&frame-name} .
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-num d-utd
ON leave OF F-num IN FRAME d-utd
    DO:
        assign f-num .
        if f-date:SCREEN-VALUE <> "" and f-num:SCREEN-VALUE <> "" then 
        do:
            find first ub.utd no-lock where ub.utd.DocumentNumber = f-num
                and ub.utd.DocumentDate = f-date 
                and (ub.utd.EDocType = objSrv:Env:Utd:EDocType:AKT:KeyIntDB
                or ub.utd.EDocType = objSrv:Env:Utd:EDocType:UTD:KeyIntDB)no-error .
            if AVAILABLE (ub.utd) then 
            do:
                MESSAGE "Документ с № " + ub.utd.DocumentNumber + " от даты: " + string(ub.utd.DocumentDate) + " уже заведен в системе." skip
                    VIEW-AS ALERT-BOX.
                return NO-APPLY .
            end.    
        end.      
        display f-num with frame {&frame-name} .
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-date d-utd
ON leave OF F-date IN FRAME d-utd
    DO:
        assign f-date .
        if f-num:SCREEN-VALUE <> "" and f-num:SCREEN-VALUE <> ? then 
        do:
            find first ub.utd no-lock where ub.utd.DocumentNumber = f-num
                and ub.utd.DocumentDate = f-date 
                and (ub.utd.EDocType = objSrv:Env:Utd:EDocType:AKT:KeyIntDB
                or ub.utd.EDocType = objSrv:Env:Utd:EDocType:UTD:KeyIntDB)no-error .
            if AVAILABLE (ub.utd) then 
            do:
                MESSAGE "Документ с № " + ub.utd.DocumentNumber + " от даты: " + string(ub.utd.DocumentDate) + " уже заведен в системе." skip
                    VIEW-AS ALERT-BOX.
                return NO-APPLY .
            end.    
        end.      
        display f-date with frame {&frame-name} .
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME r-wrkr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL r-wrkr d-utd
ON CHOOSE OF r-wrkr IN FRAME d-utd /* r-acc */
    DO:
        run ref/cli-all.w (
            input parparentproc
            ,input "b-sel"
            ,input {&prs}
            ,input {&all}
            ,input {&current}
            ,input ?
            ,input ",,,,,,NO,,"
            ,input ""
            ,output v-rid-list ) NO-ERROR.
        IF v-rid-list = '':U THEN RETURN NO-APPLY.
        FIND FIRST buf_clients NO-LOCK WHERE
            recid(buf_clients) = INTEGER(v-rid-list) NO-ERROR.
        IF NOT AVAILABLE buf_clients THEN RETURN NO-APPLY.
        ASSIGN
            f-wrkr    = buf_clients.obj-code
            wrkr-name = buf_clients.obj-name
            .
        display f-wrkr wrkr-name  with frame {&frame-name}.

    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-mark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-mark d-utd
ON ENTRY OF v-mark IN FRAME d-utd /* Марка */
    DO:
        run LoadKeyboardLayoutA (input v-scan-str, input 0, output iLang).
        run ActivateKeyboardLayout (input iLang, input 0).
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-mark d-utd
ON leave OF v-mark IN FRAME d-utd /* Марка */
    DO:
        v-mark = "" .
        if f-text <> "                            Просканируйте марку" then 
        do:
            F-text = "" .
            f-text:screen-value = "" .
        end.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-mark d-utd*/
/*ON return OF br-utd IN FRAME d-utd /* Марка */        */
/*  DO:                                                 */
/*  run save_mark .                                     */
/*  END.                                                */
/*                                                      */
/*/* _UIB-CODE-BLOCK-END */                             */
/*&ANALYZE-RESUME                                       */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-mark d-utd
ON return OF v-mark IN FRAME d-utd /* Марка */
    DO:
        run save_mark .
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-mark d-utd*/
/*ON return OF c-type IN FRAME d-utd /* Марка */        */
/*  DO:                                                 */
/*  run save_mark .                                     */
/*  END.                                                */
/*                                                      */
/*/* _UIB-CODE-BLOCK-END */                             */
/*&ANALYZE-RESUME                                       */

/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-mark d-utd*/
/*ON any-printable OF c-type IN FRAME d-utd /* Марка */ */
/*  DO:                                                 */
/*  run proc-any-key .                                  */
/*  END.                                                */
/*                                                      */
/*/* _UIB-CODE-BLOCK-END */                             */
/*&ANALYZE-RESUME*/

&Scoped-define SELF-NAME v-mark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-mark d-utd
ON any-printable OF v-mark IN FRAME d-utd /*              */
    do:
        run proc-any-key.
    end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/*&Scoped-define SELF-NAME b_back-check                                     */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_back-check d-utd              */
/*ON any-printable OF b_back-check IN FRAME d-utd /* Вернуть на проверку */ */
/*  DO:                                                                     */
/*run proc-any-key.                                                         */
/*  END.                                                                    */
/*                                                                          */
/*/* _UIB-CODE-BLOCK-END */                                                 */
/*&ANALYZE-RESUME                                                           */
/*                                                                          */
/*                                                                          */
/*&Scoped-define SELF-NAME b_correct                                        */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_correct d-utd                 */
/*ON any-printable OF b_correct IN FRAME d-utd /* Запрос на изменение */    */
/*  DO:                                                                     */
/*run proc-any-key.                                                         */
/*  END.                                                                    */
/*                                                                          */
/*/* _UIB-CODE-BLOCK-END */                                                 */
/*&ANALYZE-RESUME                                                           */
/*                                                                          */
/*&Scoped-define SELF-NAME b_anul                                           */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_anul d-utd                    */
/*ON any-printable OF b_anul IN FRAME d-utd /* Аннулировать */              */
/*  DO:                                                                     */
/*run proc-any-key.                                                         */
/*  END.                                                                    */
/*                                                                          */
/*/* _UIB-CODE-BLOCK-END */                                                 */
/*&ANALYZE-RESUME                                                           */
/*                                                                          */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-mark d-utd                    */
/*ON any-printable OF br-utd IN FRAME d-utd /* Марка */                     */
/*  DO:                                                                     */
/*  run proc-any-key .                                                      */
/*  END.                                                                    */
/*                                                                          */
/*/* _UIB-CODE-BLOCK-END */                                                 */
/*&ANALYZE-RESUME                                                           */
/*                                                                          */
/*&Scoped-define SELF-NAME b_finish                                         */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_finish d-utd                  */
/*ON any-printable OF b_finish IN FRAME d-utd /* Ввод в оборот */           */
/*  DO:                                                                     */
/*run proc-any-key.                                                         */
/*                                                                          */
/*  END.                                                                    */
/*                                                                          */
/*/* _UIB-CODE-BLOCK-END */                                                 */
/*&ANALYZE-RESUME                                                           */
/*                                                                          */
/*                                                                          */
/*&Scoped-define SELF-NAME b_prov-finish                                    */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_prov-finish d-utd             */
/*ON any-printable OF b_prov-finish IN FRAME d-utd /* Проверка завершена */ */
/*  DO:                                                                     */
/*run proc-any-key.                                                         */
/*  END.                                                                    */
/*                                                                          */
/*/* _UIB-CODE-BLOCK-END */                                                 */
/*&ANALYZE-RESUME                                                           */
/*                                                                          */
/*                                                                          */
/*&Scoped-define SELF-NAME b_recheck                                        */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_recheck d-utd                 */
/*ON any-printable OF b_recheck IN FRAME d-utd /* Повторно проверить */     */
/*  DO:                                                                     */
/*run proc-any-key.                                                         */
/*  END.                                                                    */
/*                                                                          */
/*/* _UIB-CODE-BLOCK-END */                                                 */
/*&ANALYZE-RESUME                                                           */
/*                                                                          */
/*                                                                          */
/*&Scoped-define SELF-NAME b_write-cancel                                   */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_write-cancel d-utd            */
/*ON any-printable OF b_write-cancel IN FRAME d-utd /* Отказать в подписи */*/
/*  DO:                                                                     */
/*run proc-any-key.                                                         */
/*  END.                                                                    */
/*                                                                          */
/*/* _UIB-CODE-BLOCK-END */                                                 */
/*&ANALYZE-RESUME                                                           */
/*                                                                          */
/*&Scoped-define SELF-NAME b_deliv-cancel                                   */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_deliv-cancel d-utd            */
/*ON any-printable OF b_deliv-cancel IN FRAME d-utd /* Отказать в подписи */*/
/*  DO:                                                                     */
/*run proc-any-key.                                                         */
/*  END.                                                                    */
/*                                                                          */
/*/* _UIB-CODE-BLOCK-END */                                                 */
/*&ANALYZE-RESUME                                                           */
/*                                                                          */
/*                                                                          */
/*&Scoped-define SELF-NAME b_back-check                                     */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_back-check d-utd              */
/*ON return OF b_back-check IN FRAME d-utd /* Вернуть на проверку */        */
/*  DO:                                                                     */
/*  run save_mark .                                                         */
/*  END.                                                                    */
/*                                                                          */
/*/* _UIB-CODE-BLOCK-END */                                                 */
/*&ANALYZE-RESUME                                                           */
/*                                                                          */
/*                                                                          */
/*&Scoped-define SELF-NAME b_correct                                        */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_correct d-utd                 */
/*ON return OF b_correct IN FRAME d-utd /* Запрос на изменение */           */
/*  DO:                                                                     */
/*  run save_mark .                                                         */
/*  END.                                                                    */
/*                                                                          */
/*/* _UIB-CODE-BLOCK-END */                                                 */
/*&ANALYZE-RESUME                                                           */
/*                                                                          */
/*&Scoped-define SELF-NAME b_anul                                           */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_anul d-utd                    */
/*ON return OF b_anul IN FRAME d-utd /* Аннулировать */                     */
/*  DO:                                                                     */
/*  run save_mark .                                                         */
/*  END.                                                                    */
/*                                                                          */
/*/* _UIB-CODE-BLOCK-END */                                                 */
/*&ANALYZE-RESUME                                                           */
/*                                                                          */
/*&Scoped-define SELF-NAME b_finish                                         */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_finish d-utd                  */
/*ON return OF b_finish IN FRAME d-utd /* Ввод в оборот */                  */
/*  DO:                                                                     */
/*  run save_mark .                                                         */
/*  END.                                                                    */
/*                                                                          */
/*/* _UIB-CODE-BLOCK-END */                                                 */
/*&ANALYZE-RESUME                                                           */
/*                                                                          */
/*                                                                          */
/*&Scoped-define SELF-NAME b_prov-finish                                    */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_prov-finish d-utd             */
/*ON return OF b_prov-finish IN FRAME d-utd /* Проверка завершена */        */
/*  DO:                                                                     */
/*  run save_mark .                                                         */
/*  END.                                                                    */
/*                                                                          */
/*/* _UIB-CODE-BLOCK-END */                                                 */
/*&ANALYZE-RESUME                                                           */
/*                                                                          */
/*                                                                          */
/*&Scoped-define SELF-NAME b_recheck                                        */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_recheck d-utd                 */
/*ON return OF b_recheck IN FRAME d-utd /* Повторно проверить */            */
/*  DO:                                                                     */
/*  run save_mark .                                                         */
/*  END.                                                                    */
/*                                                                          */
/*/* _UIB-CODE-BLOCK-END */                                                 */
/*&ANALYZE-RESUME                                                           */
/*                                                                          */
/*                                                                          */
/*&Scoped-define SELF-NAME b_write-cancel                                   */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_write-cancel d-utd            */
/*ON return OF b_write-cancel IN FRAME d-utd /* Отказать в подписи */       */
/*  DO:                                                                     */
/*  run save_mark .                                                         */
/*  END.                                                                    */
/*                                                                          */
/*/* _UIB-CODE-BLOCK-END */                                                 */
/*&ANALYZE-RESUME                                                           */
/*                                                                          */
/*&Scoped-define SELF-NAME b_deliv-cancel                                   */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_deliv-cancel d-utd            */
/*ON return OF b_deliv-cancel IN FRAME d-utd /* Отказать в подписи */       */
/*  DO:                                                                     */
/*  run save_mark .                                                         */
/*  END.                                                                    */
/*                                                                          */
/*/* _UIB-CODE-BLOCK-END */                                                 */
/*&ANALYZE-RESUME                                                           */
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK d-utd 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
    THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} 
    do:
        APPLY "CLOSE":U TO THIS-PROCEDURE.
        if p-mode = {&add-def} and available (buf_utd) then 
        do:
            /*      for each buf_utd-lines where buf_utd-lines.db-num = buf_utd.db-num and buf_utd-lines.doc-id = buf_utd.doc-id:                                                        */
            /*        for each buf_utd-marking-lines where buf_utd-marking-lines.db-num = buf_utd-lines.db-num and buf_utd-marking-lines.doc-id = buf_utd-lines.doc-id:                  */
            /*          for each buf_marking where buf_marking.mark = buf_utd-marking-lines.mark and buf_marking.obj-code = buf_utd.obj-code and buf_marking.obj-type = buf_utd.obj-type:*/
            /*            delete buf_marking .                                                                                                                                           */
            /*          end.                                                                                                                                                             */
            /*          delete buf_utd-marking-lines .                                                                                                                                   */
            /*        end.                                                                                                                                                               */
            /*        delete buf_utd-lines .                                                                                                                                             */
            /*      end.                                                                                                                                                                 */
            delete buf_utd .
        end.
  
    end.
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    { gbl/brwrepos.i
    &browse-name = br-utd
  &line-num= 5
}
    { gbl/getcntxt.i get }
    mDiadocConnection = p-connect . 
    Tree = ObjSrv:Lib:MarkingTree .
    Marking = ObjSrv:Env:Marking:Sts:Mark.
   
    run LoadKeyboardLayoutA (input v-scan-str, input 0, output iLang).
    run ActivateKeyboardLayout (input iLang, input 0).  
  
    /*Проверка прав */
    { gbl/chk-actg.i
  v-cntxt-db-num
  v-cntxt-userid
  {&action-head-code-main}
  'actn_edi-doc_statchange':U
  {&cntxt-firm}
  v-cntxt-host-code-obj
  '':U
  0
  0
  0
  0
  false
  log-res-statch
}
    { gbl/objat.i
      v-cntxt-obj-type
      v-cntxt-obj-code
      "'active=request'"
      v-obj-active
}
    run init-temp in this-procedure .
    if available (buf_utd) then 
    do:
        assign
            frame {&frame-name}:title = EdoTypeName(buf_utd.EDocType) + "_____№ " + string (buf_utd.DocumentNumber) + "_____" + p-mode.
    end.
    {  gbl/diasize.i }
    run diasize_init in this-procedure .
    if ObjSrv:Env:ParametrsOfSection:GetSectionEDO(v-cntxt-obj-type, v-cntxt-obj-code):IsManual
        then v-manual = yes . 
    else v-manual = no .
    run enable_UI in this-procedure .
    run enable_BUTTON in this-procedure .
    apply "entry" to v-mark in FRAME {&FRAME-NAME}.
    on F9 of frame {&frame-name} anywhere 
        do:
            if not available X_utd-lines then  return no-apply.
            find first goods no-lock where goods.gds-code = X_utd-lines.gds-code .
            gds-rec = recid(goods) .
            run ref/gds-form.w
                (input  parParentProc
                ,input  {&lookup}
                ,input  v-cntxt-obj-type
                ,input  v-cntxt-obj-code
                ,input ? /*p-call-handle*/
                ,input-output gds-rec
                ).

            apply "entry" to br-utd in frame {&frame-name}.
            return no-apply.
        end.

   
    WAIT-FOR GO OF FRAME {&FRAME-NAME} focus {&browse-name}.
END.
run disable_UI in this-procedure .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI d-utd  _DEFAULT-DISABLE
PROCEDURE disable_UI :
    /*------------------------------------------------------------------------------
      Purpose:     DISABLE the User Interface
      Parameters:  <none>
      Notes:       Here we clean-up the user-interface by deleting
                   dynamic widgets we have created and/or hide 
                   frames.  This procedure is usually called when
                   we are ready to "clean-up" after running.
    ------------------------------------------------------------------------------*/
    /* Hide all frames. */
    HIDE FRAME d-utd.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_BUTTON d-utd 
PROCEDURE enable_BUTTON :
    /* --------------------------------------------------------------------
                                Purpose:     ENABLE the User Interface
                                Parameters:  <none>
                                Notes:       Here we display/view/enable the widgets in the
                                             user-interface.  In addition, OPEN all queries
                                             associated with each FRAME and BROWSE.
                                             These statements here are based on the "Other
                                             Settings" section of the widget Property Sheets.
                                 -------------------------------------------------------------------- */
    define buffer cancel_utd-marking-lines for ub.utd-marking-lines .
    define buffer cancel_marking           for ub.marking .
    define variable v-write-cancel as logical no-undo .
    v-write-cancel = false .
  
    for each cancel_utd-marking-lines where cancel_utd-marking-lines.doc-id = p-doc-id and cancel_utd-marking-lines.db-num = p-db-num, 
        first cancel_marking where cancel_marking.mark = cancel_utd-marking-lines.mark and (cancel_marking.sts = Marking:PendingVerification:KeyIntDB or cancel_marking.sts = Marking:DeliveryControl:KeyIntDB): 
        v-write-cancel = true .
        leave .
    end.
    if p-mode <> {&lookup} then 
    do:
        if (c-status < ObjSrv:Env:Utd:Sts:TH:SignatureRequired:KeyIntDB or 
            c-status = ObjSrv:Env:Utd:Sts:TH:DeliveryCodeMismatch:KeyIntDB or
            c-status = ObjSrv:Env:Utd:Sts:TH:InconsistencyWithSupplyContract:KeyIntDB or
            c-status = ObjSrv:Env:Utd:Sts:TH:LoadError:KeyIntDB ) 
            and
            (c-type = objSrv:Env:Utd:EDocType:UTD:KeyIntDB or
            c-type = objSrv:Env:Utd:EDocType:EDoc:KeyIntDB)
            then 
        do:
            enable
                b_deliv-cancel
                with frame {&frame-name} .
        end.  
        if c-status = ObjSrv:Env:Utd:Sts:TH:LoadError:KeyIntDB or
            c-status = ObjSrv:Env:Utd:Sts:TH:LackOfMarkingCodesInCirculation:KeyIntDB or
            c-status = ObjSrv:Env:Utd:Sts:TH:DeliveryCodeMismatch:KeyIntDB or
            c-status = ObjSrv:Env:Utd:Sts:TH:InconsistencyWithSupplyContract:KeyIntDB then
        do:
            if f-contr-TH <> 0 and f-obj-code-TH <> 0 and f-supp-code-TH <> 0 then 
            do:
                find first ub.utd-err-attr no-lock where ub.utd-err.db-num = p-db-num and ub.utd-err.doc-id = p-doc-id
                    and (ub.utd-err.CodeErr = "NoSuppForId" 
                    or ub.utd-err.CodeErr = "NoFirmForId"
                    or ub.utd-err.CodeErr = "NoContForFirmId" 
                    or ub.utd-err.CodeErr = "NoShopForKpp"
                    or ub.utd-err.CodeErr = "NoEdoDoc" 
                    or ub.utd-err.CodeErr = "SpecifErr"
                    or ub.utd-err.CodeErr = "ContrDate") no-error .
                if not available (ub.utd-err) then 
                do:
                    enable
                        b_back-check
                        with frame {&frame-name} .
                end.
                else 
                do:
                    disable
                        b_back-check
                        with frame {&frame-name} .                      
                end.                            
            end.
            else 
            do:
                disable
                    b_back-check
                    with frame {&frame-name} .                        
            end. 
         
        end.     
        case c-status:
            when ObjSrv:Env:Utd:Sts:TH:NewStatus:KeyIntDB then /*Новый*/
                do:
                    enable
                        b_prov-finish
                        with frame {&frame-name} .
                end.  
            when ObjSrv:Env:Utd:Sts:TH:AwaitingDelivery:KeyIntDB then /*Ожидает поставку*/
                do:
                    enable
                        b_correct
                        b_write-cancel
                        b_prov-finish
                        with frame {&frame-name} .
                    if v-write-cancel then 
                    do:
                        DISABLE
                            b_correct
/*                            b_write-cancel*/
                            with frame {&frame-name} .
                    end.    
                end. 
            when ObjSrv:Env:Utd:Sts:TH:InconsistencyWithSupplyContract:KeyIntDB or /*Несоответствие договору поставки*/
            when ObjSrv:Env:Utd:Sts:TH:LoadError:KeyIntDB then /*Ошибка загрузки*/
                do:
                    enable
                        b_correct
                        b_write-cancel
                        b_recheck
                        with frame {&frame-name} .
                    if v-write-cancel then 
                    do:
                        DISABLE
/*                            b_write-cancel*/
                            b_correct
                            with frame {&frame-name} .
                    end.   
                end.
            when ObjSrv:Env:Utd:Sts:TH:VerificationPassed:KeyIntDB or /*Пройдена проверка МОТП*/
            when ObjSrv:Env:Utd:Sts:TH:RequiresAdjustment:KeyIntDB or /*Требуется корректировка*/
            when ObjSrv:Env:Utd:Sts:TH:LackOfMarkingCodesInCirculation:KeyIntDB or /*Отсутствие КМ в обороте*/
            when ObjSrv:Env:Utd:Sts:TH:DeliveryCodeMismatch:KeyIntDB then /*Несоответствие кодов маркировки при поставке*/
                do:
                    enable
                        b_correct
                        b_write-cancel
                        /*            b_back-check*/
                        with frame {&frame-name} .
                    if v-write-cancel then 
                    do:
                        DISABLE
/*                            b_write-cancel*/
                            b_correct
                            with frame {&frame-name} .
                    end.   
                end. 
            /*      when ObjSrv:Env:Utd:Sts:TH:Rejection:KeyIntDB then /*Отказ*/*/
            /*        do:                                                       */
            /*          enable                                                  */
            /*            b_back-check                                          */
            /*            with frame {&frame-name} .                            */
            /*        end.                                                      */
            when ObjSrv:Env:Utd:Sts:TH:SignatureRequired:KeyIntDB then /*Требует подписания*/
                do:
                    disable
                        b_write-cancel
                        with frame {&frame-name} .
                end.  
            otherwise 
            do:
                display
                    b_correct
                    b_recheck
                    b_write-cancel
                    b_prov-finish
                    with frame {&frame-name} .
            end.  
        end case .  
        if c-type = objSrv:Env:Utd:EDocType:AKT:KeyIntDB then 
        do:
            disable
                b_correct
                b_recheck
                b_write-cancel
                with frame {&frame-name} .
        end.  
        if c-type <> objSrv:Env:Utd:EDocType:Introduce:KeyIntDB then 
        do:
            disable
                b_finish
                with frame {&frame-name} .
        end.  
        if c-type = objSrv:Env:Utd:EDocType:Introduce:KeyIntDB then 
        do:
            disable
                b_correct
                b_write-cancel        
                with frame {&frame-name} .
            if c-status <> ObjSrv:Env:Utd:Sts:TH:NewStatus:KeyIntDB then 
            do:
                enable
                    b_finish
                    with frame {&frame-name} .         
            end.
        end.  
        if p-connect = ? then 
        do:
            display
                b_correct
                b_recheck
                with frame {&frame-name} .
        end.   
    end.
    if v-cntxt-db-num <> 0 then 
    do:
        disable
            b_write-cancel
            b_back-check
            b_correct
            with frame {&frame-name} .
    end. 
    if not v-obj-active then 
    do:
        disable
            /*      b_back-check */
            b_prov-finish
            with frame {&frame-name} .
    end.     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI d-utd 
PROCEDURE enable_UI :
    /* --------------------------------------------------------------------
                                Purpose:     ENABLE the User Interface
                                Parameters:  <none>
                                Notes:       Here we display/view/enable the widgets in the
                                             user-interface.  In addition, OPEN all queries
                                             associated with each FRAME and BROWSE.
                                             These statements here are based on the "Other
                                             Settings" section of the widget Property Sheets.
                                 -------------------------------------------------------------------- */

    p-type = c-type .
    enable
        B_mark
        br-utd
        f-comment
        f-info
        a-n-c-name
        a-n-c
        b_error
        with frame {&frame-name} .
    display
        f-comment-name
        f-info-name
        f-status-TH
        f-num-name
        f-date-name
        f-wrkr-name
        f-agnt-name
        f-boss-name
        with frame {&frame-name} .  
    case p-mode:
        when {&update} then 
            do:
                if p-type <> objSrv:Env:Utd:EDocType:UTD:KeyIntDB and p-type <> objSrv:Env:Utd:EDocType:UCD:KeyIntDB and p-type <> objSrv:Env:Utd:EDocType:EDoc:KeyIntDB then 
                do:
                    ENABLE
                        b-save
                        b-cancel
                        b-servis
                        f-obj-code-TH
                        f-obj-name-TH
                        f-obj-type-TH
                        R-TH
                        WITH FRAME {&frame-name}.
                    display 
                        f-obj-name
                        with frame {&frame-name} .  
                    hide 
                        f-contr-TH
                        b-exit
                        f-contr-name
                        f-contr-name-TH
                        f-supp-code-TH
                        f-supp-name-TH
                        f-supp-type-TH
                        c-status-edi
                        r-contr-TH
                        r-supp-TH
                        RECT-1
                        in frame {&frame-name} .
                    display
                        c-type
                        with frame {&frame-name} .
                    if f-obj-type-TH <> "" then display r-obj-TH with frame {&frame-name} .
                    else enable r-obj-TH with frame {&frame-name} .
                end.
                if p-type = objSrv:Env:Utd:EDocType:UTD:KeyIntDB or p-type = objSrv:Env:Utd:EDocType:EDoc:KeyIntDB or p-type = objSrv:Env:UTD:EDocType:UCD:KeyIntDB then 
                do:
                    ENABLE
                        b-exit
                        b-save
                        b-servis
                        f-contr-TH
                        f-contr-name-TH
                        f-obj-code-TH
                        f-obj-name-TH
                        f-obj-type-TH
                        f-supp-code-TH
                        f-supp-name-TH
                        f-supp-type-TH
                        R-TH
                        WITH FRAME {&frame-name}.
                    hide 
                        b-cancel
                        in frame {&frame-name} .
                    display
                        FILL-IN-1
                        c-type                 
                        FILL-IN-2
                        FILL-IN-3
                        c-status-edi
                        f-status-EDI
                        b_finish
                        with frame {&frame-name} .

                    if f-obj-type-TH <> "" then display r-obj-TH with frame {&frame-name} .
                    else enable r-obj-TH with frame {&frame-name} .
                    if f-supp-type-TH <> "" then display r-supp-TH with frame {&frame-name} .
                    else enable r-supp-TH with frame {&frame-name} .
                    if f-contr-TH <> ? and f-contr-TH <> 0 then display r-contr-TH with frame {&frame-name} .
                    else enable r-contr-TH with frame {&frame-name} .
                    if c-status = ObjSrv:Env:Utd:Sts:TH:AwaitingDelivery:KeyIntDB then 
                    do:
                        for first X_utd-lines no-lock where X_utd-lines.stts <> "Проверен" :
                            F-text = "                            Просканируйте марку" .
                            f-text:screen-value = "" .
                            display F-text with frame {&frame-name} .
                        end.
                    end.
                end.
                if p-type = objSrv:Env:Utd:EDocType:returns:KeyIntDB then 
                do:
                    enable 
                        b_anul
                        with frame {&frame-name} .
                end.  
                if p-type = objSrv:Env:Utd:EDocType:AKT:KeyIntDB then 
                do:
                    ENABLE
                        b-save
                        b-cancel
                        b-servis
                        b_prov-finish
                        WITH FRAME {&frame-name}.
                    hide 
                        b-exit
                        RECT-1
                        c-status-edi
                        f-status-edi
                        in frame {&frame-name} .
                    display
                        FILL-IN-1
                        FILL-IN-2
                        f-obj-code-TH
                        f-obj-name-TH
                        f-obj-type-TH
                        R-TH
                        c-type
                        f-contr-TH
                        f-contr-name-TH
                        f-supp-code-TH
                        f-supp-name-TH
                        f-supp-type-TH
                        r-contr-TH
                        f-num
                        f-num-name
                        f-date
                        f-date-name
                        r-supp-TH
                        with frame {&frame-name} .
                    disable
                        b_finish
                        b_correct
                        b_recheck
                        b_write-cancel
                        with frame {&frame-name} .
                end.  
                if p-type = objSrv:Env:Utd:EDocType:AKT:KeyIntDB then
                menu-item m_check-akt:sensitive in menu POPUP-MENU-b-servis = no.
            end.
        when {&lookup} then 
            do:
                if p-type <> objSrv:Env:Utd:EDocType:UTD:KeyIntDB and  p-type <> objSrv:Env:Utd:EDocType:UCD:KeyIntDB and p-type <> objSrv:Env:Utd:EDocType:EDoc:KeyIntDB then 
                do:
                    ENABLE
                        b-cancel
                        v-mark
                        WITH FRAME {&frame-name}.
                    display
                        b_prov-finish
                        f-mark
                        b_correct
                        b_recheck
                        b_write-cancel
                        f-obj-code-TH
                        f-obj-name-TH
                        f-obj-type-TH
                        r-obj-TH
                        R-TH
                        b_finish
                        c-type
                        c-status
                        f-status-TH
                        b-servis
                        with frame {&frame-name} .  
                    hide 
                        f-contr-TH
                        b-exit
                        f-contr-name
                        f-contr-name-TH
                        f-supp-code-TH
                        f-supp-name-TH
                        f-supp-type-TH
                        r-contr-TH
                        b-save
                        r-supp-TH
                        c-status-edi
                        f-status-EDI
                        RECT-1
                        in frame {&frame-name} .
                end.
                if p-type = objSrv:Env:Utd:EDocType:UTD:KeyIntDB or p-type = objSrv:Env:Utd:EDocType:UCD:KeyIntDB or p-type = objSrv:Env:Utd:EDocType:EDoc:KeyIntDB then 
                do:
                    enable
                        b-exit
                        with frame {&frame-name} .
                    display
                        b_prov-finish
                        b_correct
                        b_recheck
                        b_write-cancel
                        f-contr-TH
                        f-contr-name-TH
                        f-obj-code-TH
                        f-obj-name-TH
                        b_finish
                        f-obj-type-TH
                        f-supp-code-TH
                        f-supp-name-TH
                        b-save
                        f-supp-type-TH
                        c-status-edi
                        f-status-edi
                        r-contr-TH
                        r-obj-TH
                        r-supp-TH
                        R-TH
                        v-mark
                        f-mark
                        c-type
                        WITH FRAME {&frame-name}.
                    hide 
                        b-save
                        b-cancel
                        in frame {&frame-name} .
                    display
                        FILL-IN-1
                        FILL-IN-2
                        FILL-IN-3
                        with frame {&frame-name} .
                end.
                if p-type = objSrv:Env:Utd:EDocType:AKT:KeyIntDB then 
                do:
                    ENABLE
                        b-save
                        b-cancel
                        b-servis
                        WITH FRAME {&frame-name}.
                    hide 
                        b-exit
                        RECT-1
                        c-status-edi
                        f-status-edi
                        in frame {&frame-name} .
                    display
                        FILL-IN-1
                        FILL-IN-2
                        f-obj-code-TH
                        f-obj-name-TH
                        f-obj-type-TH
                        R-TH
                        c-type
                        f-contr-TH
                        f-contr-name-TH
                        f-supp-code-TH
                        f-supp-name-TH
                        f-supp-type-TH
                        r-contr-TH
                        f-num
                        f-num-name
                        f-date
                        f-date-name
                        r-supp-TH
                        with frame {&frame-name} .
                    disable
                        b_finish
                        b_correct
                        b_recheck
                        b_write-cancel
                        b_prov-finish
                        with frame {&frame-name} . 
                end.  
            end.  
        when {&add-def} then 
            do:
                if p-type = 0 then 
                do:
                    ENABLE
                        b-save
                        b-cancel
                        b-servis
                        f-obj-code-TH
                        f-obj-name-TH
                        f-obj-type-TH
                        R-TH
                        c-type
                        WITH FRAME {&frame-name}.
                    hide 
                        f-contr-TH
                        b-exit
                        f-contr-name
                        f-contr-name-TH
                        f-supp-code-TH
                        f-supp-name-TH
                        f-supp-type-TH
                        r-contr-TH
                        r-supp-TH
                        v-mark
                        f-mark
                        RECT-1
                        c-status-edi
                        f-status-edi
                        in frame {&frame-name} .
                    if f-obj-type-TH <> "" then display r-obj-TH with frame {&frame-name} .
                    else enable r-obj-TH with frame {&frame-name} .
                end.        
                if p-type = objSrv:Env:Utd:EDocType:Introduce:KeyIntDB then 
                do:
                    ENABLE
                        b-save
                        b-cancel
                        b-servis
                        v-mark
                        f-obj-code-TH
                        f-obj-name-TH
                        f-obj-type-TH
                        R-TH
                        c-type
                        WITH FRAME {&frame-name}.
                    hide 
                        f-contr-TH
                        b-exit
                        f-contr-name
                        f-contr-name-TH
                        f-supp-code-TH
                        f-supp-name-TH
                        f-supp-type-TH
                        r-contr-TH
                        r-supp-TH
                        RECT-1
                        c-status-edi
                        f-status-edi
                        in frame {&frame-name} .
                    display f-mark with frame {&frame-name} .
                    if f-obj-type-TH <> "" then display r-obj-TH with frame {&frame-name} .
                    else enable r-obj-TH with frame {&frame-name} .
                end.
                if p-type = objSrv:Env:Utd:EDocType:AKT:KeyIntDB then 
                do:
                    ENABLE
                        b-save
                        b-cancel
                        b-servis
                        f-obj-code-TH
                        f-obj-name-TH
                        f-obj-type-TH
                        R-TH
                        c-type
                        v-mark
                        f-contr-TH
                        f-contr-name-TH
                        f-supp-code-TH
                        f-supp-name-TH
                        f-supp-type-TH
                        r-contr-TH
                        b_prov-finish
                        f-num
                        f-date
                        r-supp-TH
                        WITH FRAME {&frame-name}.
                    hide 
                        b-exit
                        RECT-1
                        c-status-edi
                        f-status-edi
                        in frame {&frame-name} .
                    display
                        f-mark
                        f-num-name
                        f-date-name
                        FILL-IN-1
                        FILL-IN-2
                        with frame {&frame-name} .
                    disable
                        b_finish
                        b_correct
                        b_recheck
                        b_write-cancel
                        with frame {&frame-name} . 
                    if f-obj-type-TH <> "" then display r-obj-TH with frame {&frame-name} .
                    else enable r-obj-TH with frame {&frame-name} .
                end.        
            end.
    end case .  
    if type_mark <> 1 then 
    do:
        enable R-error-2 with frame {&frame-name} .
        hide R-error in frame {&frame-name} .
   
        browse br-utd:GET-BROWSE-COLUMN(11):VISIBLE = no no-error.
        browse br-utd:GET-BROWSE-COLUMN(12):VISIBLE = no no-error.
        if p-type <> objSrv:Env:Utd:EDocType:UTD:KeyIntDB then 
        do:
            browse br-utd:GET-BROWSE-COLUMN(6):VISIBLE = no no-error.
        end.
        hide
            v-mark
            in frame {&frame-name} .
        if p-mode <> {&lookup} and buf_utd.sts = ObjSrv:Env:Utd:Sts:TH:NewStatus:KeyIntDB and c-type <> 0 then 
        do:
            enable 
                v-mark
                with frame {&frame-name} .
            display
                f-mark
                with frame {&frame-name} .   
        end.  
        else 
        do:
            hide
                v-mark
                f-mark
                in frame {&frame-name} .
        end.  
    end.
    else 
    do:
        enable R-error with frame {&frame-name} .
        hide R-error-2 in frame {&frame-name} .
        if p-mode = {&update} then 
        do:
            enable 
                v-mark
                r-wrkr
                r-agnt
                r-boss
                f-wrkr
                f-agnt
                f-boss
                with frame {&frame-name} .
            display
                f-mark
                f-wrkr-name
                f-agnt-name
                f-boss-name
                with frame {&frame-name} .  
        end.  
    end.  
    if c-type <> objSrv:Env:Utd:EDocType:Introduce:KeyIntDB then 
    do:
        browse br-utd:GET-BROWSE-COLUMN(10):VISIBLE = no no-error. 
    end.
    if c-type = objSrv:Env:Utd:EDocType:Introduce:KeyIntDB then 
    do:
        browse br-utd:GET-BROWSE-COLUMN(11):VISIBLE = no no-error. 
    end.
  
    if f-num-2 = "" then 
    do:
        hide 
            f-num-2
            f-num-name-2
            f-date-2
            f-date-name-2
            in frame {&frame-name} .
    end.  
    else 
    do:
        display 
            f-num-name-2
            f-date-name-2
            with frame {&frame-name} .      
    end.      
    if f-total = 0 then 
    do:
        hide 
            f-total
            f-vat
            in frame {&frame-name} .
    end.  
    if log-res-statch then 
    do:
        menu-item m_choose-status:sensitive in menu POPUP-MENU-b-servis = yes.
    end.  
    else 
    do:
        menu-item m_choose-status:sensitive in menu POPUP-MENU-b-servis = no.
    end.  
    if not v-manual then 
    do:
        v-mark:READ-ONLY IN FRAME d-utd        = TRUE .
    end.

    apply "VALUE-CHANGED" to br-utd in frame {&frame-name}.      

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-temp d-utd 
PROCEDURE init-temp :
    /* --------------------------------------------------------------------
                              Purpose:     ENABLE the User Interface
                              Parameters:  <none>
                              Notes:       Here we display/view/enable the widgets in the
                                           user-interface.  In addition, OPEN all queries
                                           associated with each FRAME and BROWSE.
                                           These statements here are based on the "Other
                                           Settings" section of the widget Property Sheets.
                               -------------------------------------------------------------------- */
  
    define variable ii           as integer   no-undo .
    define variable Status_      as character no-undo .
    define variable StatusTH     as class     ibs.th.str.utd.sts.th   no-undo .
    define variable Status_EDI   as character no-undo .
    define variable StatusEDI    as class     ibs.th.str.utd.sts.edi  no-undo .
    define variable Type_        as character no-undo .
    define variable TypeTH       as class     ibs.th.str.utd.edoctype no-undo .
    define variable v-StatusName as character no-undo .

    Status_ = " " + {&comma-char} + '-1':U .

    StatusTH = ObjSrv:Env:Utd:Sts:TH.

    do ii = 1 to StatusTH:THMap:GetItem(ii):
        Status_ = Status_ + {&comma-char} + StatusTH:CurrTHMapProp:Label_ + {&comma-char} + string(StatusTH:CurrTHMapProp:KeyIntDB) .
    end.

    ASSIGN
        c-status:LIST-ITEM-PAIRS  in frame {&frame-name} = Status_ .

    Status_EDI = " " + {&comma-char} + '-1':U .

    StatusEDI = ObjSrv:Env:Utd:Sts:EDI.

    do ii = 1 to StatusEDI:EDIMap:GetItem(ii):
        if StatusEDI:CurrEDIMapProp:KeyIntDB = ObjSrv:Env:Utd:Sts:EDI:WithRecipientSignature:KeyIntDB then 
        do:
            if available (buf_utd) then 
            do:
                v-StatusName = StatusName(buf_utd.doc-id, buf_utd.db-num) . 
                Status_EDI = Status_EDI + {&comma-char} + StatusEDI:CurrEDIMapProp:Label_ + " " + v-StatusName + {&comma-char} + string(StatusEDI:CurrEDIMapProp:KeyIntDB) .
            end.
            else 
            do:
                Status_EDI = Status_EDI + {&comma-char} + StatusEDI:CurrEDIMapProp:Label_ + {&comma-char} + string(StatusEDI:CurrEDIMapProp:KeyIntDB) .
            end.
        end.
        else 
        do:
            Status_EDI = Status_EDI + {&comma-char} + StatusEDI:CurrEDIMapProp:Label_ + {&comma-char} + string(StatusEDI:CurrEDIMapProp:KeyIntDB) .
        end.
    end.

    ASSIGN
        c-status-edi:LIST-ITEM-PAIRS  in frame {&frame-name} = Status_EDI .

    Type_ = " " + {&comma-char} + '0':U .
  
    TypeTH = objSrv:Env:Utd:EDocType .
  
    do ii = 1 to TypeTH:EDocTypeMap:GetItem(ii):
        if p-mode = {&add-def} then 
        do:
            if ii = 2 or ii = 6 then 
            do:
                Type_ = Type_ + {&comma-char} + TypeTH:CurrEDocTypeMapProp:Label_ + {&comma-char} + string(TypeTH:CurrEDocTypeMapProp:KeyIntDB) .
            end.
        end.
        else 
        do:
            Type_ = Type_ + {&comma-char} + TypeTH:CurrEDocTypeMapProp:Label_ + {&comma-char} + string(TypeTH:CurrEDocTypeMapProp:KeyIntDB) .
        end.  
    end.  
  
    ASSIGN
        c-type:LIST-ITEM-PAIRS  in frame {&frame-name} = Type_ .
    if p-mode = {&add-def} then 
    do:
        if not available (buf_utd) then 
        do:
            create buf_utd .
            assign
                buf_utd.DocumentDate = today
                buf_utd.sts          = ObjSrv:Env:Utd:Sts:TH:NewStatus:KeyIntDB
                buf_utd.obj-code     = v-cntxt-obj-code
                buf_utd.obj-type     = v-cntxt-obj-type
                buf_utd.host-code    = v-cntxt-host-code-obj
                .
            validate buf_utd .
        end.      
    end.
    else 
    do:
        if p-mode = {&lookup} then find first buf_utd no-lock where buf_utd.doc-id = p-doc-id and buf_utd.db-num = p-db-num no-error .
        if p-mode = {&update} then find first buf_utd exclusive-lock where buf_utd.doc-id = p-doc-id and buf_utd.db-num = p-db-num no-wait no-error .
        if  error-status:error then 
        do: 
            message "Документ занят другим пользователем"
                view-as alert-box.
            p-mode = {&lookup} .
            find first buf_utd no-lock where buf_utd.doc-id = p-doc-id and buf_utd.db-num = p-db-num no-error .
        end.
    end.
    if available (buf_utd) then 
    do:
        assign
            f-num           = buf_utd.DocumentNumber
            f-date          = buf_utd.DocumentDate
            f-contr-name    = buf_utd.BaseDocumentNumber
            f-contr-TH      = buf_utd.contract-code
            f-contr-name-TH = ContName(buf_utd.contract-code, buf_utd.host-code)
            c-status        = buf_utd.sts
            .
        /*      f-status        = ObjSrv:Env:Utd:Sts:TH:GetLabel(buf_utd.sts)*/
        c-status-edi = buf_utd.sts-edi .
        /*      if buf_utd.sts-edi = ObjSrv:Env:Utd:Sts:EDI:WithRecipientSignature:KeyIntDB then do: */
        /*        c-status-edi = buf_utd.sts-edi + " " + StatusName(buf_utd.doc-id, buf_utd.db-num) .*/
        /*      end.                                                                                 */
        /*      else c-status-edi    = buf_utd.sts-edi .                                             */
        assign
            f-obj-code-TH  = buf_utd.obj-code
            f-obj-type-TH  = buf_utd.obj-type
            f-obj-name-TH  = CliName(buf_utd.obj-code, buf_utd.obj-type)
            f-supp-code-TH = buf_utd.cli-code
            f-supp-type-TH = buf_utd.cli-type
            f-supp-name-TH = CliName(buf_utd.cli-code, buf_utd.cli-type)
            f-obj-name-2   = buf_utd.obj-info
            /*      f-supp-name     = buf_utd.cli-FnsParticipantId*/
            /*      f-supp-name-2   = buf_utd.cli-info*/
            /*      f-info          = buf_utd.AdditInfo*/
            c-type         = buf_utd.EDocType
            f-total        = buf_utd.total
            f-vat          = buf_utd.vat
            v-pred-status  = buf_utd.sts
            /*        f-contr-name = entry(1,buf_utd.,"@")*/
            f-comment      = buf_utd.comment
            .

        for first ub.utd no-lock where ub.utd.DocumentExt = buf_utd.parentDocumentExt and 
            ub.utd.OrganizationExt = buf_utd.parentOrganizationExt and 
            buf_utd.DocumentExt <> "" and buf_utd.parentDocumentExt <> "":
            if ub.utd.DocumentNumber <> buf_utd.documentNumber then 
            do:
                f-num-2           = ub.utd.DocumentNumber .
                f-date-2          = ub.utd.DocumentDate .
                display 
                    f-num-2
                    f-date-2
                    with frame {&frame-name} .
            end.  
            else 
            do:
                hide 
                    f-num-2
                    f-date-2
                    in frame {&frame-name} .

            end.  
        end.         
        for each buf_utd-attr no-lock where buf_utd-attr.db-num = buf_utd.db-num and buf_utd-attr.doc-id = buf_utd.doc-id:
            case buf_utd-attr.attr-code:
                when "wrkr" then 
                    do:
                        f-wrkr = integer(buf_utd-attr.attr-value) .
                        wrkr-name = CliName(integer(buf_utd-attr.attr-value), {&prs}) .
                    end.  
                when "agnt" then 
                    do:
                        f-agnt = integer(buf_utd-attr.attr-value) .
                        agnt-name = CliName(integer(buf_utd-attr.attr-value), {&prs}) .
                    end.  
                when "boss" then 
                    do:
                        f-boss = integer(buf_utd-attr.attr-value) .
                        boss-name = CliName(integer(buf_utd-attr.attr-value), {&prs}) .
                    end.  

            end case .  
        end.         
        /*надпись взависимости от статуса*/
        if buf_utd.sts-edi <> 0 then 
        do:
        /*    F-text = "                 Просканируйте Data Matrix блока из поставки" .*/
        end.
        if buf_utd.sts = ObjSrv:Env:Utd:Sts:TH:AwaitingDelivery:KeyIntDB and (buf_utd.EDocType = objSrv:Env:Utd:EDocType:UTD:KeyIntDB or buf_utd.EdocType = objSrv:Env:Utd:EDocType:EDoc:KeyIntDB) then type_mark = 1 . 
        else 
        do:
            if c-status = ObjSrv:Env:Utd:Sts:TH:NewStatus:KeyIntDB then type_mark = 5 . 
            else type_mark = 0 .  
        end.  
    end.
    if type_mark = 1 then 
    do:
        R-error = 2 .
        display R-error with frame {&frame-name} .
    end.

    display 
        F-text
        f-num
        f-date
        f-contr-TH
        f-total
        f-vat
        f-contr-name-TH
        f-contr-name
        f-wrkr
        f-agnt
        f-boss
        wrkr-name
        agnt-name
        boss-name
        f-info
        c-type
        f-obj-name-2
        f-gruz
        c-status-edi
        c-status
        f-obj-code-TH
        f-obj-type-TH
        f-obj-name-TH
        f-supp-code-TH
        f-supp-type-TH
        f-supp-name-TH
        f-comment
        with frame {&frame-name}.

    run mark-temp .
  
    {&OPEN-QUERY-br-utd}
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mark-temp d-utd 
PROCEDURE mark-temp :
    /* --------------------------------------------------------------------
                                Purpose:     ENABLE the User Interface
                                Parameters:  <none>
                                Notes:       Here we display/view/enable the widgets in the
                                             user-interface.  In addition, OPEN all queries
                                             associated with each FRAME and BROWSE.
                                             These statements here are based on the "Other
                                             Settings" section of the widget Property Sheets.
                                 -------------------------------------------------------------------- */
    /*  define input parameter p-id as integer no-undo .*/

    define buffer buf_marking           for ub.marking .
    define buffer buf_utd-marking-lines for ub.utd-marking-lines .
    define buffer buf_utd-lines-attr    for ub.utd-lines-attr .
    define variable v-db-num       as integer   no-undo .
    define variable v-doc-id       as integer   no-undo .
    define variable vRecKeyLine    as character no-undo .
    define variable vRecKeyUTDLine as character no-undo .
        
    for each buf_utd-lines no-lock where buf_utd-lines.doc-id = buf_utd.doc-id and buf_utd-lines.db-num = buf_utd.db-num:
        find first X_utd-lines EXCLUSIVE-LOCK where buf_utd-lines.doc-id = X_utd-lines.doc-id and buf_utd-lines.db-num = X_utd-lines.db-num and buf_utd-lines.LineNum = X_utd-lines.LineNum no-error . 
        buffer-copy buf_utd-lines to X_utd-lines .

        if buf_utd.EdocType = objSrv:Env:Utd:EDocType:Introduce:KeyIntDB then 
        do: 
            for first buf_utd-lines-attr exclusive-lock where buf_utd-lines-attr.db-num = X_utd-lines.db-num and
                buf_utd-lines-attr.doc-id = X_utd-lines.doc-id and
                buf_utd-lines-attr.LineNum = X_utd-lines.LineNum and
                buf_utd-lines-attr.attr-code = "utd-fact-qnty":
 
                X_utd-lines.fact-qnty = integer(buf_utd-lines-attr.attr-value) . 
            end.
        end.    

        run gen-key-rec ("utd-lines", 
            input  buffer X_utd-lines:handle, 
            output vRecKeyLine).

        vRecKeyUTDLine = replace(vRecKeyLine,"utd-lines","utd-marking-lines") + {&delim-key}.  
      
        if CAN-FIND (first buf_utd-err no-lock where buf_utd-err.doc-id = X_utd-lines.doc-id and buf_utd-err.db-num = X_utd-lines.db-num and buf_utd-err.reckey = vRecKeyLine) then 
            X_utd-lines.sts_err = yes .
        else 
        do:
            if CAN-FIND (first buf_utd-err no-lock where buf_utd-err.doc-id = X_utd-lines.doc-id and buf_utd-err.db-num = X_utd-lines.db-num and buf_utd-err.reckey begins vRecKeyUTDLine) then 
                X_utd-lines.sts_err = yes .
        end.    

              
        /*Определить какие должны быть ошибочные статусы*/
        find first buf_utd-marking-lines no-lock where buf_utd-marking-lines.db-num = buf_utd-lines.db-num and
            buf_utd-marking-lines.doc-id = buf_utd-lines.doc-id and buf_utd-marking-lines.LineNum = buf_utd-lines.LineNum and buf_utd-marking-lines.sts = Marking:MarkError:KeyIntDB no-error .
        if available (buf_utd-marking-lines) 
            then X_utd-lines.stts = "Ошибка" .
        else 
        do:
            find first buf_utd-marking-lines no-lock where buf_utd-marking-lines.db-num = buf_utd-lines.db-num and
                buf_utd-marking-lines.doc-id = buf_utd-lines.doc-id and buf_utd-marking-lines.LineNum = buf_utd-lines.LineNum and buf_utd-marking-lines.sts <> Marking:Checked_:KeyIntDB no-error .
            if available (buf_utd-marking-lines) then  X_utd-lines.stts = "Ожидает проверку" .
            else 
            do:
                find first buf_utd-marking-lines no-lock where buf_utd-marking-lines.db-num = buf_utd-lines.db-num and
                    buf_utd-marking-lines.doc-id = buf_utd-lines.doc-id and buf_utd-marking-lines.LineNum = buf_utd-lines.LineNum and buf_utd-marking-lines.sts = Marking:Checked_:KeyIntDB no-error .
                if available (buf_utd-marking-lines) then  X_utd-lines.stts = "Проверен" .
            end.  
        end.
        X_utd-lines.qnty-mark = 0 .
        X_utd-lines.qnty-scan = 0 .
        for each buf_utd-marking-lines no-lock where buf_utd-marking-lines.db-num = buf_utd-lines.db-num and
            buf_utd-marking-lines.doc-id = buf_utd-lines.doc-id and buf_utd-marking-lines.LineNum = buf_utd-lines.LineNum:
            find first buf_marking no-lock where buf_marking.mark begins buf_utd-marking-lines.mark no-error .
            if buf_utd-marking-lines.doc-level = 1 then 
            do:
                X_utd-lines.qnty-mark = X_utd-lines.qnty-mark + 1 .
                if buf_utd-marking-lines.sts = Marking:Checked_:KeyIntDB then X_utd-lines.qnty-scan = X_utd-lines.qnty-scan + 1 .
            end .
            if buf_marking.sts = Marking:GrayZone:KeyIntDB or 
                buf_marking.sts = Marking:UnknowSts:KeyIntDB or 
                buf_marking.sts = Marking:MarkError:KeyIntDB then X_utd-lines.stts = "Ошибка" .
        
        end.        
        X_utd-lines.gds-name = GdsName(X_utd-lines.gds-code) .
        X_utd-lines.taxRate_ = string(X_utd-lines.TaxRate) + " %" .
        if X_utd-lines.sts_err then X_utd-lines.stts = "Ошибка" .
    end.    
    for each X_utd-lines:
        if not CAN-FIND (ub.utd-lines where ub.utd-lines.db-num = X_utd-lines.db-num and ub.utd-lines.doc-id = X_utd-lines.doc-id and ub.utd-lines.LineNum = X_utd-lines.LineNum) then 
            delete X_utd-lines .
    end.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE temp-mark d-utd 
PROCEDURE temp-mark :
    /* --------------------------------------------------------------------
                            Purpose:     ENABLE the User Interface
                            Parameters:  <none>
                            Notes:       Here we display/view/enable the widgets in the
                                         user-interface.  In addition, OPEN all queries
                                         associated with each FRAME and BROWSE.
                                         These statements here are based on the "Other
                                         Settings" section of the widget Property Sheets.
                             -------------------------------------------------------------------- */
    define input parameter p-id as integer no-undo .
    define buffer buf_marking for ub.marking .
    empty temp-table tt-marking-lines .
    
    if p-id = 1 then 
    do:
        for each buf_utd-marking-lines no-lock where buf_utd-marking-lines.db-num = X_utd-lines.db-num and buf_utd-marking-lines.doc-id = X_utd-lines.doc-id
            and buf_utd-marking-lines.LineNum = X_utd-lines.LineNum:
            for first buf_marking no-lock where buf_marking.mark begins buf_utd-marking-lines.mark :
                create tt-marking-lines .
                assign
                    tt-marking-lines.gds-name    = GdsName(buf_utd-marking-lines.gds-code)
                    tt-marking-lines.stts-utd    = StatusTHName(buf_utd-marking-lines.sts)
                    tt-marking-lines.stts        = StatusTHName(buf_marking.sts)
                    tt-marking-lines.mark        = buf_marking.mark
                    tt-marking-lines.mark-parent = buf_marking.mark-parent
                    tt-marking-lines.gds-code    = buf_utd-marking-lines.gds-code
                    tt-marking-lines.sts         = buf_marking.sts
                    tt-marking-lines.sts-utd     = buf_utd-marking-lines.sts
                    tt-marking-lines.unit        = buf_marking.unit
                    tt-marking-lines.unit-ext    = buf_marking.unit-ext
                    tt-marking-lines.box-qnty    = buf_marking.box-qnty
                    tt-marking-lines.LineNum     = buf_utd-marking-lines.LineNum
                    tt-marking-lines.db-num      = buf_utd-marking-lines.db-num
                    tt-marking-lines.doc-id      = buf_utd-marking-lines.doc-id
                    tt-marking-lines.doc-level   = buf_utd-marking-lines.doc-level
                    tt-marking-lines.site        = buf_utd-marking-lines.site
                    .
            end.   
        end.  
    end.
    else 
    do:
        for each buf_utd-marking-lines no-lock where buf_utd-marking-lines.db-num = buf_utd.db-num and buf_utd-marking-lines.doc-id = buf_utd.doc-id and buf_utd-marking-lines.mark <> "",
            first buf_marking no-lock where buf_marking.mark begins buf_utd-marking-lines.mark:
            create tt-marking-lines .
            assign
                tt-marking-lines.gds-name    = GdsName(buf_utd-marking-lines.gds-code)
                tt-marking-lines.stts-utd    = StatusTHName(buf_utd-marking-lines.sts)
                tt-marking-lines.stts        = StatusTHName(buf_marking.sts)
                tt-marking-lines.mark        = buf_marking.mark
                tt-marking-lines.mark-parent = buf_marking.mark-parent
                tt-marking-lines.gds-code    = buf_utd-marking-lines.gds-code
                tt-marking-lines.sts         = buf_marking.sts
                tt-marking-lines.sts-utd     = buf_utd-marking-lines.sts
                tt-marking-lines.unit        = buf_marking.unit
                tt-marking-lines.unit-ext    = buf_marking.unit-ext
                tt-marking-lines.box-qnty    = buf_marking.box-qnty
                tt-marking-lines.LineNum     = buf_utd-marking-lines.LineNum
                tt-marking-lines.db-num      = buf_utd-marking-lines.db-num
                tt-marking-lines.doc-id      = buf_utd-marking-lines.doc-id
                tt-marking-lines.doc-level   = buf_utd-marking-lines.doc-leve
                tt-marking-lines.site        = buf_utd-marking-lines.site
                . 
        end.   
    end.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE check_mol d-utd 
PROCEDURE check_mol :
    /* --------------------------------------------------------------------
                            Purpose:     ENABLE the User Interface
                            Parameters:  <none>
                            Notes:       Here we display/view/enable the widgets in the
                                         user-interface.  In addition, OPEN all queries
                                         associated with each FRAME and BROWSE.
                                         These statements here are based on the "Other
                                         Settings" section of the widget Property Sheets.
                             -------------------------------------------------------------------- */
    define output parameter p-ok as logical no-undo .
    define variable varchk-prs      as character no-undo .
    define variable varchk-prs-type as character no-undo .

    { gbl/conf-rd.i
    "'chk-prs'"
    "''"
    "''"
    0
    "''"
    "''"
    "''"
    no
    varchk-prs
    varchk-prs-type
    no-error
  }
 
    if varchk-prs <> "no" then 
    do:
        if f-agnt = 0 or f-agnt = ? then 
        do:
            message "Не указан исполнитель " f-agnt view-as alert-box error.
            p-ok = false .
            return.
        end.
        if f-boss = 0 or f-boss = ? then 
        do:
            message "Не указан менеджер " f-boss view-as alert-box error.
            p-ok = false .
            return.
        end.
        if f-wrkr = 0 or f-wrkr = ? then 
        do:
            message "Не указан кладовщик " f-wrkr view-as alert-box error.
            p-ok = false .
            return.
        end.
        p-ok = true .
    end.
    else p-ok = true .
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE save_mark d-utd 
PROCEDURE save_mark :
    /* --------------------------------------------------------------------
                              Purpose:     ENABLE the User Interface
                              Parameters:  <none>
                              Notes:       Here we display/view/enable the widgets in the
                                           user-interface.  In addition, OPEN all queries
                                           associated with each FRAME and BROWSE.
                                           These statements here are based on the "Other
                                           Settings" section of the widget Property Sheets.
                               -------------------------------------------------------------------- */
    define variable v_list    as character no-undo .
    define variable ii        as integer   no-undo .
    define variable jj        as integer   no-undo .
    define variable v-marking as character no-undo .
    define buffer buf_parts                   for ub.parts .
    define buffer gray_marking                for ub.marking .
    define buffer gray_unit-marking           for ub.marking .
    define buffer gray_utd-marking-lines      for ub.utd-marking-lines .
    define buffer gray_unit_utd-marking-lines for ub.utd-marking-lines .
    define buffer buf_utd-lines-attr          for ub.utd-lines-attr .
    define VARIABLE v-qnty     as decimal   no-undo .
    define VARIABLE v-rowid    as rowid     no-undo .
    define VARIABLE v-tbl-name as character no-undo .
    
    if p-mode = {&lookup} then 
    do:
        v-mark:screen-value in frame {&frame-name} = "" .
        v-mark = "" .
    end .
    if v-mark:screen-value in frame {&frame-name} = ""
        then 
    do:
        v-mark:screen-value in frame {&frame-name} = v-scan-str.
    end.

    v-scan-str = "". 
    assign 
        v-mark = v-mark:screen-value in frame {&frame-name}.

    F-text = "" .
    f-text:screen-value = "" .
    v-GTIN = "" .
    v-gds-code = 0 .
    ASSIGN 
        v_list = 'Ё,Й,Ц,У,К,Е,Н,Г,Ш,Щ,З,Х,Ъ,Ф,Ы,В,А,П,Р,О,Л,Д,Ж,Э,Я,Ч,С,М,И,Т,Ь,Б,Ю':U .
  
    /*проверка на русские буквы*/
    do ii = 1 to length (v-mark):
        if LOOKUP( SUBSTRING( v-mark, ii, 1 ), v_list )  > 1 then
        do:
            message "Не корректно считана акцизная марка, перед считыванием переключите клавиатуру на английскую раскладку."
                view-as alert-box.
            v-mark:screen-value = "" .
            v-mark = "" .    
            return no-apply.  
        end.
    end.
    mMRCCode  = yes.
    v-marking = GetCodeIdent(v-mark) .
    mMRCCode = no.
    if v-marking = "" or v-marking = ? then 
    do:
        F-text = "            Просканирован штрих код, необходимо просканировать марку" .
        display F-text with frame {&frame-name}.
        v-mark:screen-value = "" .
        v-mark = "" .
        return no-apply.
    end.  
    /*УПД проверка марок*/
    if p-type = objSrv:Env:Utd:EDocType:UTD:KeyIntDB then 
    do:
        /*Проверка марки*/
        /*           f-text = check_:CheckMarkUTD(v-mark, buf_utd.doc-id, buf_utd.db-num) .                                                                      */
        /*      if F-text = "" then do:                                                                                                                          */
        /*        for first buf_utd-marking-lines exclusive-lock where buf_utd-marking-lines.mark begins v-mark and buf_utd-marking-lines.db-num = buf_utd.doc-id*/
        /*        and buf_utd-marking-lines.doc-id = buf_utd.db-num, first X_utd-lines exclusive-lock where X_utd-lines.LineNum = buf_utd-marking-lines.LineNum: */
        /*          recid_utd = recid (X_utd-lines) .                                                                                                            */
        /*          X_utd-lines.qnty-scan     = X_utd-lines.qnty-scan + 1  .                                                                                     */
        /*                                                                                                                                                       */
        /*      f-text = check_:CheckMarkUTD(v-mark, buf_utd.doc-id, buf_utd.db-num) .*/
        /*      if F-text = "" then do:                                               */

        find first buf_utd-marking-lines exclusive-lock where buf_utd-marking-lines.mark begins v-marking and buf_utd-marking-lines.db-num = p-db-num 
            and buf_utd-marking-lines.doc-id = buf_utd.doc-id no-error .
        if available (buf_utd-marking-lines) then
        do:
            find first X_utd-lines exclusive-lock where X_utd-lines.LineNum = buf_utd-marking-lines.LineNum no-error .
            if available (X_utd-lines) then
            do:  
             
                if X_utd-lines.sts_err then 
                do:
                    F-text = "Товар не подлежит приемке, т.к. не прошел проверку на корректность" .
                    display F-text with frame {&frame-name}.
                    v-mark:screen-value = "" .
                    v-mark = "" .
                    return no-apply.  
                end.  
                if buf_utd-marking-lines.sts = Marking:Checked_:KeyIntDB then
                do:
                    F-text = "            Марка уже проверена, просканируйте следующую" .
                    display F-text with frame {&frame-name}.
                    v-mark:screen-value = "" .
                    v-mark = "" .
                    return no-apply.
                end.
                else
                do:
                    if can-find (buf_marking where buf_marking.mark = buf_utd-marking-lines.mark and buf_marking.sts = Marking:MarkError:KeyIntDB)
                        then 
                    do:
                        F-text = "Товар не подлежит приемке, т.к. не прошел проверку на корректность" .
                        display F-text with frame {&frame-name}.
                        v-mark:screen-value = "" .
                        v-mark = "" .
                        return no-apply.
                    end.                  
            
                    if can-find (buf_marking where buf_marking.mark = buf_utd-marking-lines.mark and buf_marking.sts = Marking:GrayZone:KeyIntDB)
                        then 
                    do:
                        /*            message "Упаковка с неполным составом марок, необходимо просканировать все индивидуальные упаковки"*/
                        /*            view-as alert-box.                                                                                 */

                        for first gray_utd-marking-lines no-lock where gray_utd-marking-lines.db-num = X_utd-lines.db-num and gray_utd-marking-lines.doc-id = X_utd-lines.doc-id
                            and gray_utd-marking-lines.LineNum = X_utd-lines.LineNum and gray_utd-marking-lines.mark = buf_utd-marking-lines.mark:
                            for first gray_marking no-lock where gray_marking.mark = buf_utd-marking-lines.mark :
                                create tt-marking-lines .
                                assign
                                    tt-marking-lines.gds-name    = GdsName(gray_utd-marking-lines.gds-code)
                                    tt-marking-lines.stts-utd    = StatusTHName(gray_utd-marking-lines.sts)
                                    tt-marking-lines.stts        = StatusTHName(gray_marking.sts)
                                    tt-marking-lines.mark        = gray_marking.mark
                                    tt-marking-lines.mark-parent = gray_marking.mark-parent
                                    tt-marking-lines.gds-code    = gray_utd-marking-lines.gds-code
                                    tt-marking-lines.sts         = gray_marking.sts
                                    tt-marking-lines.sts-utd     = gray_utd-marking-lines.sts
                                    tt-marking-lines.unit        = gray_marking.unit
                                    tt-marking-lines.box-qnty    = gray_marking.box-qnty
                                    tt-marking-lines.LineNum     = gray_utd-marking-lines.LineNum
                                    tt-marking-lines.db-num      = gray_utd-marking-lines.db-num
                                    tt-marking-lines.doc-id      = gray_utd-marking-lines.doc-id
                                    tt-marking-lines.doc-level   = gray_utd-marking-lines.doc-level
                                    .
                            end.
                            for each gray_unit-marking no-lock where gray_unit-marking.mark-parent = gray_utd-marking-lines.mark:
                                for first gray_unit_utd-marking-lines no-lock where gray_unit_utd-marking-lines.db-num = X_utd-lines.db-num and gray_unit_utd-marking-lines.doc-id = X_utd-lines.doc-id
                                    and gray_unit_utd-marking-lines.LineNum = X_utd-lines.LineNum and gray_unit_utd-marking-lines.mark = gray_unit-marking.mark:
                                    create tt-marking-lines .
                                    assign
                                        tt-marking-lines.gds-name    = GdsName(gray_unit_utd-marking-lines.gds-code)
                                        tt-marking-lines.stts-utd    = StatusTHName(gray_unit_utd-marking-lines.sts)
                                        tt-marking-lines.stts        = StatusTHName(gray_unit-marking.sts)
                                        tt-marking-lines.mark        = gray_unit-marking.mark
                                        tt-marking-lines.mark-parent = gray_unit-marking.mark-parent
                                        tt-marking-lines.gds-code    = gray_unit_utd-marking-lines.gds-code
                                        tt-marking-lines.sts         = gray_unit-marking.sts
                                        tt-marking-lines.sts-utd     = gray_unit_utd-marking-lines.sts
                                        tt-marking-lines.unit        = gray_unit-marking.unit
                                        tt-marking-lines.unit-ext    = gray_unit-marking.unit-ext
                                        tt-marking-lines.box-qnty    = gray_unit-marking.box-qnty
                                        tt-marking-lines.LineNum     = gray_unit_utd-marking-lines.LineNum
                                        tt-marking-lines.db-num      = gray_unit_utd-marking-lines.db-num
                                        tt-marking-lines.doc-id      = gray_unit_utd-marking-lines.doc-id
                                        tt-marking-lines.doc-level   = gray_unit_utd-marking-lines.doc-level
                                        .
                                end.
                            end.
                        end.
                        run str/mark_browse.w (input parparentproc,
                            input-output table tt-marking-lines by-reference,
                            input p-mode,
                            input "Марки по товару " + string(X_utd-lines.gds-code) + " " + GdsName(X_utd-lines.gds-code) + " со статусом: " + StatusTHName(Marking:GrayZone:KeyIntDB),
                            input 6,
                            input "" /*тип продукции*/
                            ) no-error .
                        { gbl/brwrepos.i
              &line-num= 5
            }
                    end.
                    else 
                    do:
                        if buf_utd-marking-lines.doc-level > 1 then 
                        do:
                            /*                            if can-find (ub.marking where ub.marking.mark = buf_utd-marking-lines.mark and ub.marking.unit-ext <> "UNIT") then*/
                            /*                            do:                                                                                                               */
                            /*            if tree:LevelUpUTD(buf_utd-marking-lines.mark, buf_utd-marking-lines.doc-id, buf_utd-marking-lines.db-num) then do:*/
                            find first buf_marking no-lock where buf_marking.mark = buf_utd-marking-lines.mark no-error .
                            if available (buf_marking) then 
                            do:
                                if can-find (ub.marking where ub.marking.mark = buf_marking.mark-parent and ub.marking.sts <> Marking:GrayZone:KeyIntDB) then 
                                do:
                                    message "Разгруппировать упаковки?"
                                        view-as alert-box question buttons yes-no update ungroup.
                                    if ungroup then 
                                    do:
                                        if tree:UnGroupUTD(buf_utd-marking-lines.mark, buf_utd-marking-lines.doc-id, buf_utd-marking-lines.db-num) then 
                                        do:
                                            message "Упаковка с маркой " + buf_utd-marking-lines.mark + " разгруппирована."
                                                view-as alert-box.
                                        end.
                                    end.
                                    else 
                                    do:
                                        F-text = "                            Просканируйте марку" .
                                        display F-text with frame {&frame-name} .
                                        v-mark:screen-value = "" .
                                        v-mark = "" .
                                        return no-apply.
                                    end.
                                end.
                                else
                                do:
                                    message " Марка входит в состав упаковки c серой зоной, разгруппировать упаковки?"
                                        view-as alert-box question buttons yes-no update ungroup.
                                    if ungroup then 
                                    do:
                                        if tree:UnGroupUTD(buf_utd-marking-lines.mark, buf_utd-marking-lines.doc-id, buf_utd-marking-lines.db-num) then 
                                        do:
                                            message "Упаковка с маркой " + buf_utd-marking-lines.mark + " разгруппирована."
                                                view-as alert-box.
                                        end.
                                        
                                    end.
                                    /*                                F-text = "            Марка входит в состав упаковки, просканируйте марку упаковки" .*/
                                    /*                                display F-text with frame {&frame-name}.                                             */
                                    /*                                v-mark:screen-value = "" .                                                           */
                                    /*                                v-mark = "" .                                                                        */
                                    /*                                return no-apply.                                                                     */

                                    else 
                                    do:
                                        F-text = "                            Просканируйте марку" .
                                        display F-text with frame {&frame-name} .
                                        v-mark:screen-value = "" .
                                        v-mark = "" .
                                        return no-apply.
                                    end.
                                end.
                            end.
                        end.
                    end.  
                    if tree:LevelDownUTD(buf_utd-marking-lines.mark, buf_utd-marking-lines.doc-id, buf_utd-marking-lines.db-num) then 
                    do:
                        tree:StatusDownUTD(buf_utd-marking-lines.mark, buf_utd-marking-lines.doc-id, buf_utd-marking-lines.db-num, Marking:Checked_:KeyIntDB) .
                    end.
                    for first bf_utd-marking-lines exclusive-lock where bf_utd-marking-lines.mark = buf_utd-marking-lines.mark and bf_utd-marking-lines.db-num = buf_utd-marking-lines.db-num and
                        bf_utd-marking-lines.doc-id = buf_utd-marking-lines.doc-id:
                        bf_utd-marking-lines.sts   = Marking:Checked_:KeyIntDB .  
                        X_utd-lines.qnty-scan     = X_utd-lines.qnty-scan + 1  .
                    end.  
                /*            if available (gray_marking) then do:                                               */
                /*              gray_marking.box-qnty = gray_marking.box-qnty - 1 .                              */
                /*              bf_utd-marking-lines.doc-level = bf_utd-marking-lines.doc-level - 1 .            */
                /*              if gray_marking.box-qnty = 0 then do:                                            */
                /*                    buf_utd-marking-lines.sts = ObjSrv:Env:Marking:Sts:Mark:Ungrouped:KeyIntDB.*/
                /*                    buf_utd-marking-lines.doc-level = 0 .                                      */
                /*              end.                                                                             */
                /*            end.                                                                               */
                end.
                /*          end.*/
                run mark-temp .
                find first buf_utd-marking-lines exclusive-lock where buf_utd-marking-lines.mark begins v-marking and buf_utd-marking-lines.db-num = p-db-num 
                    and buf_utd-marking-lines.doc-id = buf_utd.doc-id 
/*                    and buf_utd-marking-lines.sts <> Marking:Checked_:KeyIntDB*/
                     no-error .
                if available (buf_utd-marking-lines) then
                do:
                    find first X_utd-lines exclusive-lock where X_utd-lines.LineNum = buf_utd-marking-lines.LineNum no-error .
                    if available (X_utd-lines) then
          
                        recid_utd = recid (X_utd-lines) .
                end.
                else 
                do:
                    find first X_utd-lines exclusive-lock where X_utd-lines.LineNum = 1 no-error .
                    if available (X_utd-lines) then
          
                        recid_utd = recid (X_utd-lines) .
                end.    

                br-utd :refresh() no-error.
                reposition br-utd to recid recid_utd no-error .
                v-mark:screen-value = "" .
                v-mark = "" .
            end.
        end.
        else 
        do:
            find first buf_utd-marking-lines exclusive-lock where buf_utd-marking-lines.mark begins v-marking and buf_utd-marking-lines.db-num = p-db-num
                and buf_utd-marking-lines.doc-id <> p-doc-id no-error .
            if available (buf_utd-marking-lines) then 
            do:
                F-text = "             Товар поставлен на АЗС ранее, верните его на склад" .
                display F-text with frame {&frame-name}.
                v-mark:screen-value = "" .
                v-mark = "" .    
                return no-apply.  
            end. 
            else 
            do:
                F-text = "              Товар отсутствует в поставке. Верните товар поставщику" .
                display F-text with frame {&frame-name}.
                v-mark:screen-value = "" .
                v-mark = "" .    
                return no-apply.
            end.         
        end. 
    end.
    /*АКТ-приема*/
    if p-type = objSrv:Env:Utd:EDocType:AKT:KeyIntDB and buf_utd.sts = ObjSrv:Env:Utd:Sts:TH:NewStatus:KeyIntDB then 
    do:

        if f-obj-type-th = "" then 
        do:
            message "Не выбран объект"
                view-as alert-box.
            v-mark:screen-value = "" .
            v-mark = "" .    
            return no-apply .
        end.
        if c-type = 0 then 
        do:
            message "Не выбран тип документа"
                view-as alert-box.
            v-mark:screen-value = "" .
            v-mark = "" .    
            return no-apply .
        end. 
  
        if CAN-FIND (first buf_utd-marking-lines where buf_utd-marking-lines.mark begins v-marking and buf_utd-marking-lines.db-num = buf_utd.db-num
            and buf_utd-marking-lines.doc-id = buf_utd.doc-id ) then 
        do:
            F-text = "                        Марка уже просканирована в этом документе " .
            display F-text with frame {&frame-name}.
            v-mark:screen-value = "" .
            v-mark = "" .  
            return.
        end.    
        for first buf_marking no-lock where buf_marking.mark begins v-marking and buf_marking.sts > Marking:UnknowSts:KeyIntDB:
            if buf_marking.loc-key begins "utd" then 
            do:
                run gen-row-keyr in this-procedure (
                    input buf_marking.loc-key /*uniq-key-rec смены*/
                    ,input ? /*p-key-handle буфер записи которую будем искать. если ищем по key-rec то ? */
                    ,input "ub"
                    ,input ? /*p-tt-handle буфер таблицы - если надо найти во временной таблице. если ищем в БД то ? */
                    ,input no-lock
                    ,output v-rowid
                    ,output v-tbl-name ) .
                if v-rowid <> ? then 
                do:
                    find first ub.utd no-lock where rowid(ub.utd) = v-rowid no-error .
                    F-text = "               Найдено УПД " + string(ub.utd.DocumentNumber) + " на поставку данной марки. Марка не может быть принята по Акту" .
                end.  
                else  F-text = "               Марка не может быть принята по Акту. Заблокирована" + buf_marking.loc-key . 
                /*                F-text = "               Найдено УПД " + string(ub.utd.DocumentNumber) + " на поставку данной марки. Марка не может быть принята по Акту" .*/
                display F-text with frame {&frame-name}.
                v-mark:screen-value = "" .
                v-mark = "" .    
                return.              
            end.
            if buf_marking.loc-key <> "" 
                or buf_marking.sts = Marking:Reserved:KeyIntDB 
                or buf_marking.sts = Marking:FreeZone:KeyIntDB 
                or buf_marking.sts = Marking:Checked_:KeyIntDB then 
            do:
                F-text = "        Марка зарегистрирована в системе. Статус марки " +  StatusTHName(buf_marking.sts).
                display F-text with frame {&frame-name}.
                v-mark:screen-value = "" .
                v-mark = "" .    
                return.              
            end.          

        end.  
        /*Создание марок*/
        v-GTIN = getGtinByDM(v-marking) .
        if v-GTIN <> "" or c-type = objSrv:Env:Utd:EDocType:AKT:KeyIntDB then 
        do:
            v-gds-code = getGdsCodeByGtin(v-GTIN) .

            find first buf_goods no-lock where buf_goods.gds-code = v-gds-code no-error .
          
            if available (buf_goods) or c-type = objSrv:Env:Utd:EDocType:AKT:KeyIntDB then 
            do:
              
                find first buf_utd-lines where buf_utd-lines.doc-id = buf_utd.doc-id and buf_utd-lines.db-num = buf_utd.db-num
                    and buf_utd-lines.gds-code = v-gds-code no-error .
                if not available (buf_utd-lines) then 
                do:           
                    find last X_utd-lines no-lock no-error . 
                    if not available (X_utd-lines) then jj = 0 .
                    else jj = X_utd-lines.LineNum .
                    create buf_utd-lines .
                    assign
                        buf_utd-lines.GdsName  = GdsName(v-gds-code)
                        buf_utd-lines.db-num   = buf_utd.db-num
                        buf_utd-lines.doc-id   = buf_utd.doc-id
                        buf_utd-lines.LineNum  = jj + 1
                        buf_utd-lines.gds-code = v-gds-code
                        buf_utd-lines.sts      = ObjSrv:Env:Utd:Sts:TH:ReceivedFromSupplier:KeyIntDB .
                    buf_utd-lines.UnitCode = if available (buf_goods) then buf_goods.unit-base else ""
                        .
                    if available (buf_goods) or c-type = objSrv:Env:Utd:EDocType:AKT:KeyIntDB then 
                    do:  
                        create  X_utd-lines .
                        buffer-copy buf_utd-lines to X_utd-lines .
                        assign
                            X_utd-lines.stts = StatusTHName(buf_utd-lines.sts).
                        X_utd-lines.gds-name = GdsName(v-gds-code)
                            .
                
                        for each buf_parts no-lock where  buf_parts.artic = buf_goods.artic and
                            buf_parts.prod-code = buf_goods.prod-code and
                            buf_parts.prod-type = buf_goods.prod-type and 
                            buf_parts.out-code = {&free-code} and
                            buf_parts.obj-code = buf_utd.obj-code and
                            buf_parts.obj-type = buf_utd.obj-type : 
                            X_utd-lines.fact-qnty = X_utd-lines.fact-qnty + buf_parts.fact-qnty .
                        end.       
                    end.         
                    find first buf_utd-lines-attr exclusive-lock where buf_utd-lines-attr.db-num = X_utd-lines.db-num and
                        buf_utd-lines-attr.doc-id = X_utd-lines.doc-id and
                        buf_utd-lines-attr.LineNum = X_utd-lines.LineNum and
                        buf_utd-lines-attr.attr-code = "utd-fact-qnty" no-error .
                    if not available (buf_utd-lines-attr) then 
                    do:
                        create buf_utd-lines-attr .
                        assign
                            buf_utd-lines-attr.db-num    = X_utd-lines.db-num
                            buf_utd-lines-attr.doc-id    = X_utd-lines.doc-id
                            buf_utd-lines-attr.LineNum   = X_utd-lines.LineNum
                            buf_utd-lines-attr.attr-code = "utd-fact-qnty"
                            .
                    end.                                              
                    buf_utd-lines-attr.attr-value = string(X_utd-lines.fact-qnty) .                                     
                end.  
                recid_utd = recid(X_utd-lines) .
                create buf_utd-marking-lines .
                assign
                    buf_utd-marking-lines.db-num    = buf_utd.db-num
                    buf_utd-marking-lines.doc-id    = buf_utd.doc-id
                    buf_utd-marking-lines.gds-code  = buf_utd-lines.gds-code
                    buf_utd-marking-lines.LineNum   = buf_utd-lines.LineNum
                    buf_utd-marking-lines.mark      = v-marking
                    buf_utd-marking-lines.sts       = ObjSrv:Env:Utd:Sts:TH:ReceivedFromSupplier:KeyIntDB
                    buf_utd-marking-lines.doc-level = 1
                    .
                find first buf_marking exclusive-lock where buf_marking.mark begins v-marking no-error .
                if not available (buf_marking) then 
                do:            
                    create buf_marking .
                    assign
                        buf_marking.gds-code   = buf_utd-marking-lines.gds-code
                        buf_marking.mark       = v-marking
                        buf_marking.sts        = Marking:UnknowSts:KeyIntDB
                        buf_marking.gds-ext-id = v-GTIN
                        buf_marking.obj-code   = buf_utd.obj-code
                        buf_marking.obj-type   = buf_utd.obj-type
                        .
                    buf_marking.unit-ext  = getLevelMotpBycodid(v-marking) .
                    buf_marking.box-qnty  = getQntyUTDBycodid(v-marking) .
                    buf_marking.unit = getLevelUTDBycodid(v-marking) .
                end.
                else 
                do:
                    buf_marking.sts      = Marking:UnknowSts:KeyIntDB .
                end.    
                if buf_marking.box-qnty = ? or buf_marking.box-qnty = 0 then 
                do:
                    v-qnty = 0 .
                    run gbl/d-prompt.w (
                        'title=':u + "Ввод количества" + '\':u
                        + 'text1=':u + "Введите количество:" + '\':u
                        + 'format=' + ">>>>>9.99" + '\':u
                        + 'type=' + {&type-dec} + '\':u
                        + 'fillin_row=3\':u
                        + 'fillin_col=6\':u
                        + 'fillin_width=17\':u
                        + 'fillin_height=1\':u
                        + 'max-chars=17\':u     /*- максимальное количество символов для редактора*/
                        + 'readonly=no\':u
                        , input-output v-qnty
                        ).
                    buf_marking.box-qnty = v-qnty .
                    buf_marking.unit  = if available (buf_goods) then buf_goods.unit-base else "".
                    buf_marking.unit-ext = "UNIT" .

                end.
                find first X_utd-lines exclusive-lock where X_utd-lines.gds-code = buf_utd-lines.gds-code and X_utd-lines.lineNum = buf_utd-lines.LineNum
                    and X_utd-lines.db-num = buf_utd-lines.db-num and X_utd-lines.doc-id = buf_utd-lines.doc-id no-error .
                buf_utd-lines.Quantity  = buf_utd-lines.Quantity  + buf_marking.box-qnty .
                X_utd-lines.qnty-scan = X_utd-lines.qnty-scan + buf_marking.box-qnty .
                X_utd-lines.Quantity  = X_utd-lines.Quantity  + buf_marking.box-qnty .
                X_utd-lines.qnty-mark = X_utd-lines.qnty-mark + 1 .
                br-utd:refresh () no-error .
                reposition br-utd to recid recid_utd no-error . 
                v-mark:screen-value = "" .
                v-mark = "" .           
            end.
            else 
            do:
                F-text = "                GTIN - " + v-GTIN + " не привязан к товару в базе".
                display F-text with frame {&frame-name}.
                v-mark:screen-value = "" .
                v-mark = "" .
                return.  
            end.    
        end.
        else 
        do:
            F-text = "                              Нет возможности получить GTIN " .
            display F-text with frame {&frame-name}.
            v-mark:screen-value = "" .
            v-mark = "" .
            return.  
        end.    
    end. /*АКТ-Приема*/
        
    /*Первоначальный ввод*/
    if p-type = objSrv:Env:Utd:EDocType:Introduce:KeyIntDB and buf_utd.sts = ObjSrv:Env:Utd:Sts:TH:NewStatus:KeyIntDB then 
    do:

        if f-obj-type-th = "" then 
        do:
            message "Не выбран объект"
                view-as alert-box.
            v-mark:screen-value = "" .
            v-mark = "" .    
            return no-apply .
        end.
        if c-type = 0 then 
        do:
            message "Не выбран тип документа"
                view-as alert-box.
            v-mark:screen-value = "" .
            v-mark = "" .    
            return no-apply .
        end. 
  
        find first buf_utd-marking-lines exclusive-lock where buf_utd-marking-lines.mark begins v-marking and buf_utd-marking-lines.db-num = buf_utd.db-num
            and buf_utd-marking-lines.doc-id = buf_utd.doc-id no-error .
        if available (buf_utd-marking-lines) then 
        do:
            F-text = "                        Марка уже просканирована в этом документе " .
            display F-text with frame {&frame-name}.
            v-mark:screen-value = "" .
            v-mark = "" .  
            return.
        end.    
        find first buf_marking no-lock where buf_marking.mark begins v-marking and buf_marking.sts >= Marking:OutZone:KeyIntDB no-error .
        if available (buf_marking) then 
        do:
            F-text = "                      Марка находится в обороте , статус марки –" + StatusTHName(buf_marking.sts) .
            display F-text with frame {&frame-name}.
            v-mark:screen-value = "" .
            v-mark = "" .    
            return.
        end.                                    
        else 
        do:
            find first buf_marking no-lock where buf_marking.mark begins v-marking no-error .
            if available (buf_marking) then 
            do:
                if buf_marking.sts < Marking:Received:KeyIntDB and buf_marking.loc-key <> "" and c-type <> objSrv:Env:Utd:EDocType:AKT:KeyIntDB then 
                do:

                    F-text = "                                      Марка занята" .
                    display F-text with frame {&frame-name}.
                    v-mark:screen-value = "" .
                    v-mark = "" .
                    return.
                end.
                if buf_marking.sts = Marking:DeliveryControl:KeyIntDB and c-type = objSrv:Env:Utd:EDocType:AKT:KeyIntDB then 
                do:
                    F-text = "               Найдено УПД на поставку данной марки. Марка не может быть принята по Акту" .
                    display F-text with frame {&frame-name}.
                    v-mark:screen-value = "" .
                    v-mark = "" .    
                    return.              
                end.
                if buf_marking.sts <> Marking:UnknowSts:KeyIntDB then 
                do:
                    F-text = "        Марка зарегистрирована в системе. Статус марки " +  StatusTHName(buf_marking.sts).
                    display F-text with frame {&frame-name}.
                    v-mark:screen-value = "" .
                    v-mark = "" .    
                    return.              
                end.          
            end.
        end.  

        v-GTIN = getGtinByDM(v-marking) .
        if v-GTIN <> "" or c-type = objSrv:Env:Utd:EDocType:AKT:KeyIntDB then 
        do:
            v-gds-code = getGdsCodeByGtin(v-GTIN) .

            find first buf_goods no-lock where buf_goods.gds-code = v-gds-code no-error .
          
            if available (buf_goods) or c-type = objSrv:Env:Utd:EDocType:AKT:KeyIntDB then 
            do:
              
                find first buf_utd-lines where buf_utd-lines.doc-id = buf_utd.doc-id and buf_utd-lines.db-num = buf_utd.db-num
                    and buf_utd-lines.gds-code = v-gds-code no-error .
                if not available (buf_utd-lines) then 
                do:           
                    find last X_utd-lines no-lock no-error . 
                    if not available (X_utd-lines) then jj = 0 .
                    else jj = X_utd-lines.LineNum .
                    create buf_utd-lines .
                    assign
                        buf_utd-lines.GdsName  = GdsName(v-gds-code)
                        buf_utd-lines.db-num   = buf_utd.db-num
                        buf_utd-lines.doc-id   = buf_utd.doc-id
                        buf_utd-lines.LineNum  = jj + 1
                        buf_utd-lines.gds-code = v-gds-code
                        buf_utd-lines.sts      = ObjSrv:Env:Utd:Sts:TH:ReceivedFromSupplier:KeyIntDB .
                    buf_utd-lines.UnitCode = if available (buf_goods) then buf_goods.unit-base else ""
                        .
                    if available (buf_goods) or c-type = objSrv:Env:Utd:EDocType:AKT:KeyIntDB then 
                    do:  
                        create  X_utd-lines .
                        buffer-copy buf_utd-lines to X_utd-lines .
                        assign
                            X_utd-lines.stts = StatusTHName(buf_utd-lines.sts).
                        X_utd-lines.gds-name = GdsName(v-gds-code)
                            .
                
                        for each buf_parts no-lock where  buf_parts.artic = buf_goods.artic and
                            buf_parts.prod-code = buf_goods.prod-code and
                            buf_parts.prod-type = buf_goods.prod-type and 
                            buf_parts.out-code = {&free-code} and
                            buf_parts.obj-code = buf_utd.obj-code and
                            buf_parts.obj-type = buf_utd.obj-type : 
                            X_utd-lines.fact-qnty = X_utd-lines.fact-qnty + buf_parts.fact-qnty .
                        end.       
                    end.         
                    find first buf_utd-lines-attr exclusive-lock where buf_utd-lines-attr.db-num = X_utd-lines.db-num and
                        buf_utd-lines-attr.doc-id = X_utd-lines.doc-id and
                        buf_utd-lines-attr.LineNum = X_utd-lines.LineNum and
                        buf_utd-lines-attr.attr-code = "utd-fact-qnty" no-error .
                    if not available (buf_utd-lines-attr) then 
                    do:
                        create buf_utd-lines-attr .
                        assign
                            buf_utd-lines-attr.db-num    = X_utd-lines.db-num
                            buf_utd-lines-attr.doc-id    = X_utd-lines.doc-id
                            buf_utd-lines-attr.LineNum   = X_utd-lines.LineNum
                            buf_utd-lines-attr.attr-code = "utd-fact-qnty"
                            .
                    end.                                              
                    buf_utd-lines-attr.attr-value = string(X_utd-lines.fact-qnty) .                                     
                end.  
                recid_utd = recid(X_utd-lines) .
                create buf_utd-marking-lines .
                assign
                    buf_utd-marking-lines.db-num    = buf_utd.db-num
                    buf_utd-marking-lines.doc-id    = buf_utd.doc-id
                    buf_utd-marking-lines.gds-code  = buf_utd-lines.gds-code
                    buf_utd-marking-lines.LineNum   = buf_utd-lines.LineNum
                    buf_utd-marking-lines.mark      = v-marking
                    buf_utd-marking-lines.sts       = ObjSrv:Env:Utd:Sts:TH:ReceivedFromSupplier:KeyIntDB
                    buf_utd-marking-lines.doc-level = 1
                    .
                find first buf_marking exclusive-lock where buf_marking.mark begins v-marking no-error .
                if not available (buf_marking) then 
                do:            
                    create buf_marking .
                    assign
                        buf_marking.gds-code   = buf_utd-marking-lines.gds-code
                        buf_marking.mark       = v-marking
                        buf_marking.sts        = Marking:PendingVerification:KeyIntDB
                        buf_marking.gds-ext-id = v-GTIN
                        buf_marking.obj-code   = buf_utd.obj-code
                        buf_marking.obj-type   = buf_utd.obj-type
                        .
                    buf_marking.unit-ext  = getLevelMotpBycodid(v-marking) .
                    buf_marking.box-qnty  = getQntyUTDBycodid(v-marking) .
                    buf_marking.unit = getLevelUTDBycodid(v-marking) .
                end.
                else 
                do:
                    buf_marking.sts      = Marking:PendingVerification:KeyIntDB .
                end.    
                if buf_marking.box-qnty = ? or buf_marking.box-qnty = 0 then 
                do:
                    v-qnty = 0 .   
                    run gbl/d-prompt.w (
                        'title=':u + "Ввод количества" + '\':u
                        + 'text1=':u + "Введите количество:" + '\':u
                        + 'format=' + ">>>>>9.99" + '\':u
                        + 'type=' + {&type-dec} + '\':u
                        + 'fillin_row=3\':u
                        + 'fillin_col=6\':u
                        + 'fillin_width=17\':u
                        + 'fillin_height=1\':u
                        + 'max-chars=17\':u     /*- максимальное количество символов для редактора*/
                        + 'readonly=no\':u
                        , input-output v-qnty
                        ).
                    buf_marking.box-qnty = v-qnty .
                    buf_marking.unit  = if available (buf_goods) then buf_goods.unit-base else "".
                    buf_marking.unit-ext = "UNIT" .

                end.
                find first X_utd-lines exclusive-lock where X_utd-lines.gds-code = buf_utd-lines.gds-code and X_utd-lines.lineNum = buf_utd-lines.LineNum
                    and X_utd-lines.db-num = buf_utd-lines.db-num and X_utd-lines.doc-id = buf_utd-lines.doc-id no-error .
                buf_utd-lines.Quantity  = buf_utd-lines.Quantity  + buf_marking.box-qnty .
                X_utd-lines.qnty-scan = X_utd-lines.qnty-scan + buf_marking.box-qnty .
                X_utd-lines.Quantity  = X_utd-lines.Quantity  + buf_marking.box-qnty .
                X_utd-lines.qnty-mark = X_utd-lines.qnty-mark + 1 .
                br-utd:refresh () no-error .
                reposition br-utd to recid recid_utd no-error . 
                v-mark:screen-value = "" .
                v-mark = "" .           
            end.
            else 
            do:
                F-text = "                GTIN - " + v-GTIN + " не привязан к товару в базе".
                display F-text with frame {&frame-name}.
                v-mark:screen-value = "" .
                v-mark = "" .
                return.  
            end.    
        end.
        else 
        do:
            F-text = "                              Нет возможности получить GTIN " .
            display F-text with frame {&frame-name}.
            v-mark:screen-value = "" .
            v-mark = "" .
            return.  
        end.    
    end. /*Первоначальный ввод*/
    if c-status = ObjSrv:Env:Utd:Sts:TH:AwaitingDelivery:KeyIntDB then 
    do:
        find first X_utd-lines no-lock where X_utd-lines.stts <> "Проверен" no-error .
        if available (X_utd-lines) then 
        do:
            F-text = "                            Просканируйте марку" .
            f-text:screen-value = "" .
            display F-text with frame {&frame-name} .
        end.
        else 
        do:
            F-text = "" .
            f-text:screen-value = "" .
            display F-text with frame {&frame-name} .
        end.  
    end. 
    display F-text with frame {&frame-name}.
    v-mark:screen-value = "" .
    v-mark = "" .
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE save_mol d-utd 
PROCEDURE save_mol :
    /* --------------------------------------------------------------------
                              Purpose:     ENABLE the User Interface
                              Parameters:  <none>
                              Notes:       Here we display/view/enable the widgets in the
                                           user-interface.  In addition, OPEN all queries
                                           associated with each FRAME and BROWSE.
                                           These statements here are based on the "Other
                                           Settings" section of the widget Property Sheets.
                               -------------------------------------------------------------------- */
    find first buf_utd-attr exclusive-lock where buf_utd-attr.db-num = buf_utd.db-num and buf_utd-attr.doc-id = buf_utd.doc-id and buf_utd-attr.attr-code = "wrkr" no-error .
    if not available (buf_utd-attr) then 
    do:
        create buf_utd-attr .
        assign
            buf_utd-attr.db-num    = buf_utd.db-num
            buf_utd-attr.doc-id    = buf_utd.doc-id
            buf_utd-attr.attr-code = "wrkr"
            .
    end.  
    buf_utd-attr.attr-value = string(f-wrkr) .
    find first buf_utd-attr exclusive-lock where buf_utd-attr.db-num = buf_utd.db-num and buf_utd-attr.doc-id = buf_utd.doc-id and buf_utd-attr.attr-code = "agnt" no-error .
    if not available (buf_utd-attr) then 
    do:
        create buf_utd-attr .
        assign
            buf_utd-attr.db-num    = buf_utd.db-num
            buf_utd-attr.doc-id    = buf_utd.doc-id
            buf_utd-attr.attr-code = "agnt"
            .
    end.  
    buf_utd-attr.attr-value = string(f-agnt) .
    find first buf_utd-attr exclusive-lock where buf_utd-attr.db-num = buf_utd.db-num and buf_utd-attr.doc-id = buf_utd.doc-id and buf_utd-attr.attr-code = "boss" no-error .
    if not available (buf_utd-attr) then 
    do:
        create buf_utd-attr .
        assign
            buf_utd-attr.db-num    = buf_utd.db-num
            buf_utd-attr.doc-id    = buf_utd.doc-id
            buf_utd-attr.attr-code = "boss"
            .
    end.  
    buf_utd-attr.attr-value = string(f-boss) .
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LoadKeyboardLayoutA d-utd
procedure LoadKeyboardLayoutA external "user32" :
    define input  parameter P1 as char.
    define input  parameter P2 as LONG.
    define return parameter pret as LONG.
end procedure.
        
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ActivateKeyboardLayout d-utd 
procedure ActivateKeyboardLayout external "user32" :
    define input parameter P1 as LONG.
    define input parameter P2 as LONG.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-any-key Dialog-Frame 
PROCEDURE proc-any-key :
    if not v-manual
        then
        if v-scan-str = ""
            then etime(yes).
        else
            if etime > 500
                then 
            do:
                v-scan-str = "".
                etime(yes).
            end.
    v-scan-str = v-scan-str + last-event:label.
    
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CliName d-utd 
FUNCTION CliName RETURNS CHARACTER
    (input p-cli-code as integer, input p-cli-type as character) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/
    define variable v-cli-name as character no-undo .
    find first buf_clients no-lock where buf_clients.obj-code = p-cli-code
        and buf_clients.obj-type = p-cli-type no-error .
    if available (buf_clients) then v-cli-name = buf_clients.obj-name .
    RETURN v-cli-name.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ContName d-utd 
FUNCTION ContName RETURNS CHARACTER
    ( input p-contract-code as integer, input p-host-code as integer ) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/
    define variable v-contract-name as character no-undo .
    find first buf_contract no-lock where buf_contract.contract-code = p-contract-code and buf_contract.host-code = p-host-code no-error .
    if available (buf_contract) then v-contract-name = buf_contract.contract-name .
    RETURN v-contract-name.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GdsName d-utd 
FUNCTION GdsName RETURNS CHARACTER
    ( input p-gds-code as integer) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/
    define variable v-gds-name as character no-undo .
    define buffer buf_goods for ub.goods .
  
    find first buf_goods no-lock where buf_goods.gds-code = p-gds-code no-error .
    if available (buf_goods) then v-gds-name = buf_goods.gds-name .
    RETURN v-gds-name.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION StatusName d-utd 
FUNCTION StatusName RETURNS CHARACTER
    ( input p-doc-id as integer,
    input p-db-num as integer) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/
    define variable v-status-name as character no-undo .
    define buffer buf_utd-attr for ub.utd-attr .
  
    find first buf_utd-attr no-lock where buf_utd-attr.doc-id = p-doc-id and
        buf_utd-attr.db-num = p-db-num and
        buf_utd-attr.attr-code = "sendcode"  no-error .
    if available (buf_utd-attr) then 
    do:
        case buf_utd-attr.attr-value:
            when "2" then 
                do:
                    v-status-name = "(С расхождением)" .
                end.
            when "3" then 
                do:
                    v-status-name = "(Не принято)" .
                end.
            otherwise 
            do:
                v-status-name = "" .
            end.       
        end case .   
    end.           
    else v-status-name = "" .                                
    RETURN v-status-name.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

