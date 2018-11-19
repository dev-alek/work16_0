&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          ub               PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME shattrpt


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER locked_thbj-attr FOR thbj-attr.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS shattrpt 
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Экран настроек работы с топливном

Автор: Уханов Дмитрий Юрьевич
Дата создания: 10/09/08
Author: Dmitry Ukhanov
Creation date: 10/09/08

*/
/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER parparentproc AS WIDGET-HANDLE       NO-UNDO.
DEFINE INPUT PARAMETER p-mode        AS CHARACTER           NO-UNDO.
DEFINE INPUT PARAMETER p-obj-type  LIKE ub.clients.obj-type NO-UNDO.
DEFINE INPUT PARAMETER p-obj-code  LIKE ub.shop.obj-code    NO-UNDO.

/* Local Variable Definitions ---                                       */
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Экран настроек работы с топливном".
{ cmp/vssrevis.i }
{ gbl/waitfram.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ gbl/clntattr.i }
{ gbl/thbjattr.i }
{ cmp/showinf.i  }
{ gbl/getcntxt.i def }
{ gbl/color.i    }
{ gbl/twowin.i   }
{ str/trdcalib.i }

define temp-table temp-thbj-attr no-undo like ub.thbj-attr.

define variable v-tth           as   handle       no-undo .
define variable v-to-create     as   logical      no-undo .
DEFINE VARIABLE v-db-num        like ub.db.db-num no-undo.

define variable v-list-dop-info-full as character    no-undo.
define variable v-list-dop-info      as character    no-undo.

define temp-table temp_twowin_itemsSelected_col no-undo
    field its-key   as integer
    field itm-key   as integer
    field itmExtKey as character

    index pi is primary unique
      its-key
    index im
      itm-key
.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME shattrpt

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS B-exit b-quit B-Help RECT-1 RECT-2 RECT-3 ~
RECT-4 RECT-5 RECT-6 t-autopump-izm t-autopump t-avtinvpm t-olddens ~
r-expptrl r-inpptrl dop-info rvs-wt-email B-set_dop-info r-algrvspt ~
t-rvsnmter t-invclipt f-invclipt b-invclipt r-temp-for-pomi r-denstclc ~
mass-proc r-algoincptrl t-mand-chioce-autocar otkl-fact-volue delta-horiz ~
delta-vert otkl-temp otkl-density otkl-water v-dop-info 
&Scoped-Define DISPLAYED-OBJECTS t-autopump-izm t-autopump t-avtinvpm ~
t-olddens r-expptrl r-inpptrl dop-info rvs-wt-email r-algrvspt t-rvsnmter ~
t-invclipt f-invclipt r-temp-for-pomi r-denstclc mass-proc r-algoincptrl ~
t-mand-chioce-autocar otkl-fact-volue delta-horiz delta-vert otkl-temp ~
otkl-density otkl-water v-dop-info f-invclipt-name 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-exit AUTO-GO 
     LABEL "&Ввод" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON B-Help 
     LABEL "Помо&щь" 
     SIZE 3 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-invclipt 
     IMAGE-UP FILE "btn-down-arrow":U
     IMAGE-DOWN FILE "btn-down-arrow":U
     IMAGE-INSENSITIVE FILE "btn-down-arrow":U
     LABEL "":L 
     SIZE 3 BY .92.

DEFINE BUTTON b-quit AUTO-END-KEY 
     LABEL "&Отмена" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON B-set_dop-info 
     IMAGE-UP FILE "cmp/update.bmp":U
     LABEL "" 
     SIZE 2.63 BY 1.08.

DEFINE VARIABLE delta-horiz AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 20 BY 5 NO-UNDO.

DEFINE VARIABLE delta-vert AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 20 BY 5 NO-UNDO.

DEFINE VARIABLE dop-info AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 28.5 BY 4.5 NO-UNDO.

DEFINE VARIABLE f-invclipt LIKE clients.obj-code
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE f-invclipt-name AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 78 BY 1 NO-UNDO.

DEFINE VARIABLE mass-proc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Допустимый % расхождения массы в резервуаре" 
     VIEW-AS FILL-IN 
     SIZE 14.5 BY 1 NO-UNDO.

DEFINE VARIABLE otkl-density AS DECIMAL FORMAT "->>,>>9.999":U INITIAL 0 
     LABEL "Плотности" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE otkl-fact-volue AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Фактического объема" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE otkl-temp AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Температуры" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE otkl-water AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Воды" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE rvs-wt-email AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 60 BY .96 NO-UNDO.

DEFINE VARIABLE v-dop-info AS CHARACTER FORMAT "X(256)":U INITIAL "Обязательные поля доп.инфо. ПН по НП" 
      VIEW-AS TEXT 
     SIZE 37.5 BY 1 NO-UNDO.

DEFINE VARIABLE r-algoincptrl AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "стандарт", 1,
"с комиссионным приемом", 2
     SIZE 37 BY 1 NO-UNDO.

DEFINE VARIABLE r-algrvspt AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Алгоритм N1", 1,
"Алгоритм N2", 2
     SIZE 16 BY 1.75 NO-UNDO.

DEFINE VARIABLE r-denstclc AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "среднее по сменной сверке и внеш.приходам (shft_rvs-inc)", "shft_rvs-inc",
"среднее по сверкам (avrg-rvs)", "avrg-rvs",
"среднеарифметическое значение окаймляющих сверок (avrg-chk)", "avrg-chk",
"среднее значение по расчетно-книжным данным (shft_sys-inc)", "shft_sys-inc",
"плотность, аппроксимирующая расчетно-книжные остатки к фактическим (fact-approx)", "fact-approx"
     SIZE 84.5 BY 2.5 NO-UNDO.

DEFINE VARIABLE r-expptrl AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Масса", "weight",
"Объем", "volume"
     SIZE 23.5 BY .83 NO-UNDO.

DEFINE VARIABLE r-inpptrl AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Масса+плотность", "weight",
"Объем+плотность", "volume",
"Масса+объем", "weight+",
"Объем+масса", "volume+"
     SIZE 66 BY .83 NO-UNDO.

DEFINE VARIABLE r-temp-for-pomi AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "15°С", 1,
"20°С", 2
     SIZE 17 BY .75 TOOLTIP "Используется только при передаче в ПО к МИ" NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 96.5 BY 3.75.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 96.5 BY 7.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 96.5 BY 7.5.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL   
     SIZE 96.5 BY 4.17.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43.5 BY 7.25.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 52.5 BY 7.25.

DEFINE VARIABLE t-autopump AS LOGICAL INITIAL no 
     LABEL "Автоматические сверки создавать с чтением всех счетчиков ТРК" 
     VIEW-AS TOGGLE-BOX
     SIZE 82.5 BY .83 NO-UNDO.

DEFINE VARIABLE t-autopump-izm AS LOGICAL INITIAL no 
     LABEL "Автоматические сверки создавать только по измеряемым резервуарам" 
     VIEW-AS TOGGLE-BOX
     SIZE 82.5 BY .83 NO-UNDO.

DEFINE VARIABLE t-avtinvpm AS LOGICAL INITIAL no 
     LABEL "Автомат. создание инв. счетчиков ТРК при переполнении разрядности эл. счетчика" 
     VIEW-AS TOGGLE-BOX
     SIZE 82.5 BY .83 TOOLTIP "если включено, то контроль и создание происходит при закрытии сверки" NO-UNDO.

DEFINE VARIABLE t-invclipt AS LOGICAL INITIAL no 
     LABEL "Контрагент для списания ЕУ при инвентаризации топлива по сверке:" 
     VIEW-AS TOGGLE-BOX
     SIZE 83 BY .83 NO-UNDO.

DEFINE VARIABLE t-mand-chioce-autocar AS LOGICAL INITIAL no 
     LABEL "Обязательный выбор автотранспорта из справочника" 
     VIEW-AS TOGGLE-BOX
     SIZE 60.5 BY .79 NO-UNDO.

DEFINE VARIABLE t-olddens AS LOGICAL INITIAL no 
     LABEL "В документы по умолчанию ставится плотность и темп. из предыдущего документа" 
     VIEW-AS TOGGLE-BOX
     SIZE 81.5 BY .83 NO-UNDO.

DEFINE VARIABLE t-rvsnmter AS LOGICAL INITIAL no 
     LABEL "Расхождение в инвентаризации по сверке делать без учета погрешности измерения" 
     VIEW-AS TOGGLE-BOX
     SIZE 82.5 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME shattrpt
     B-exit AT ROW 1 COL 1 WIDGET-ID 2
     b-quit AT ROW 1 COL 11 WIDGET-ID 6
     B-Help AT ROW 1 COL 96 WIDGET-ID 4
     t-autopump-izm AT ROW 2.75 COL 3 WIDGET-ID 40
     t-autopump AT ROW 3.75 COL 3 WIDGET-ID 40
     t-avtinvpm AT ROW 4.75 COL 3 WIDGET-ID 42
     t-olddens AT ROW 5.75 COL 3 WIDGET-ID 76
     r-expptrl AT ROW 7.25 COL 72.5 NO-LABEL WIDGET-ID 50
     r-inpptrl AT ROW 8.92 COL 4 NO-LABEL WIDGET-ID 44
     dop-info AT ROW 9.5 COL 69.5 NO-LABEL WIDGET-ID 492
     rvs-wt-email AT ROW 11.75 COL 3.5 NO-LABEL WIDGET-ID 90
     B-set_dop-info AT ROW 13 COL 41 WIDGET-ID 496
     r-algrvspt AT ROW 15.83 COL 3.5 NO-LABEL WIDGET-ID 80
     t-rvsnmter AT ROW 17.83 COL 3.5 WIDGET-ID 58
     t-invclipt AT ROW 18.83 COL 3.5 WIDGET-ID 74
     f-invclipt AT ROW 19.83 COL 3 COLON-ALIGNED HELP
          "" NO-LABEL WIDGET-ID 60
     b-invclipt AT ROW 19.83 COL 15.5 WIDGET-ID 68
     r-temp-for-pomi AT ROW 21.33 COL 64 NO-LABEL WIDGET-ID 96
     r-denstclc AT ROW 23.25 COL 3.5 NO-LABEL WIDGET-ID 32
     mass-proc AT ROW 26.5 COL 46.75 COLON-ALIGNED WIDGET-ID 100
     r-algoincptrl AT ROW 28.38 COL 38.13 NO-LABEL WIDGET-ID 118
     t-mand-chioce-autocar AT ROW 29.33 COL 3.63 WIDGET-ID 106
     otkl-fact-volue AT ROW 32.5 COL 72.63 COLON-ALIGNED WIDGET-ID 506
     delta-horiz AT ROW 32.71 COL 3.5 NO-LABEL WIDGET-ID 110
     delta-vert AT ROW 32.71 COL 25 NO-LABEL WIDGET-ID 122
     otkl-temp AT ROW 33.58 COL 72.63 COLON-ALIGNED WIDGET-ID 508
     otkl-density AT ROW 34.71 COL 72.63 COLON-ALIGNED WIDGET-ID 510
     otkl-water AT ROW 35.79 COL 72.63 COLON-ALIGNED WIDGET-ID 512
     v-dop-info AT ROW 13 COL 3.5 NO-LABEL WIDGET-ID 498
     f-invclipt-name AT ROW 19.83 COL 17 COLON-ALIGNED NO-LABEL WIDGET-ID 72
     "Максимально допустимые отклонения:" VIEW-AS TEXT
          SIZE 33.75 BY .79 AT ROW 31.25 COL 82.63 RIGHT-ALIGNED WIDGET-ID 504
     "Настройки инвентаризации по сверке" VIEW-AS TEXT
          SIZE 35.5 BY .67 AT ROW 15.08 COL 3 WIDGET-ID 78
     "Алгоритм вычисления плотности топлива для продаж :" VIEW-AS TEXT
          SIZE 50.5 BY .63 AT ROW 22.58 COL 3.5 WIDGET-ID 36
     "горизонтальных" VIEW-AS TEXT
          SIZE 17.5 BY .67 AT ROW 31.88 COL 3.5 WIDGET-ID 126
     "Алгоритм принятия топлива к учету:" VIEW-AS TEXT
          SIZE 34.5 BY 1 AT ROW 28.38 COL 3.63 WIDGET-ID 116
     "на список почтовых адресов(разделять адреса запятыми):" VIEW-AS TEXT
          SIZE 62.5 BY .96 AT ROW 10.79 COL 3.5 WIDGET-ID 94
     "При приеме новостей, если в сверке вода, отправлять сообщения" VIEW-AS TEXT
          SIZE 64.5 BY .96 AT ROW 10.08 COL 3.5 WIDGET-ID 92
     "Тип ввода топлива в документах прихода внешнего :" VIEW-AS TEXT
          SIZE 49 BY .83 AT ROW 7.92 COL 3.5 WIDGET-ID 48
     "Погрешность изм. массы для резервуаров" VIEW-AS TEXT
          SIZE 42 BY .67 AT ROW 30.92 COL 3.5 WIDGET-ID 112
     "вертикальных" VIEW-AS TEXT
          SIZE 17.5 BY .67 AT ROW 31.88 COL 25 WIDGET-ID 124
     "Температура, к которой приводиться плотность и объем °С :" VIEW-AS TEXT
          SIZE 58 BY .83 AT ROW 21.25 COL 3.5 WIDGET-ID 516
     "Тип ввода топлива во всех документах кроме прихода внешнего :" VIEW-AS TEXT
          SIZE 63 BY .83 AT ROW 7.13 COL 3.5 WIDGET-ID 514
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE  WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME shattrpt
     "Источник для фактического количества топлива в ПН :" VIEW-AS TEXT
          SIZE 52 BY .63 AT ROW 27.63 COL 3.5 WIDGET-ID 86
     RECT-1 AT ROW 22.33 COL 2.5 WIDGET-ID 38
     RECT-2 AT ROW 14.71 COL 2.5 WIDGET-ID 64
     RECT-3 AT ROW 7 COL 2.5 WIDGET-ID 66
     RECT-4 AT ROW 26.33 COL 2.5 WIDGET-ID 84
     RECT-5 AT ROW 30.75 COL 2.63 WIDGET-ID 500
     RECT-6 AT ROW 30.75 COL 46.5 WIDGET-ID 502
     SPACE(1.24) SKIP(0.12)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Настройки работы с ТОПЛИВНЫМ товаром" WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Temp-Tables and Buffers:
      TABLE: locked_thbj-attr B "?" ? ub thbj-attr
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX shattrpt
   FRAME-NAME                                                           */
ASSIGN 
       FRAME shattrpt:SCROLLABLE       = FALSE.

ASSIGN 
       dop-info:READ-ONLY IN FRAME shattrpt        = TRUE.

/* SETTINGS FOR FILL-IN f-invclipt IN FRAME shattrpt
   LIKE = ub.clients.obj-code EXP-LABEL EXP-HELP EXP-SIZE               */
/* SETTINGS FOR FILL-IN f-invclipt-name IN FRAME shattrpt
   NO-ENABLE                                                            */
ASSIGN 
       f-invclipt-name:READ-ONLY IN FRAME shattrpt        = TRUE.

/* SETTINGS FOR FILL-IN rvs-wt-email IN FRAME shattrpt
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN v-dop-info IN FRAME shattrpt
   ALIGN-L                                                              */
/* SETTINGS FOR TEXT-LITERAL "Максимально допустимые отклонения:"
          SIZE 33.75 BY .79 AT ROW 31.25 COL 82.63 RIGHT-ALIGNED        */

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX shattrpt
/* Query rebuild information for DIALOG-BOX shattrpt
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX shattrpt */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME shattrpt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL shattrpt shattrpt
ON WINDOW-CLOSE OF FRAME shattrpt /* Настройки работы с ТОПЛИВНЫМ товаром */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-exit shattrpt
ON CHOOSE OF B-exit IN FRAME shattrpt /* Ввод */
DO:
  RUN proc-save IN THIS-PROCEDURE NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-invclipt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-invclipt shattrpt
ON CHOOSE OF b-invclipt IN FRAME shattrpt
DO:
  define variable rid-list as character no-undo .
  define buffer buf_clients for ub.clients.

    run ref/cli-all.w
      ( input parParentProc
      , input "b-sel"
      , input {&cmp}
      , input {&all}
      , input {&current}
      , input ?
      , input "yes,yes,yes,,,,ИЛИ"
      , input "lock-cli-type":U
      , output rid-list
      ) .

    find first buf_clients no-lock
      where recid(buf_clients) = integer( rid-list )
      no-error.
    if available buf_clients then do:
      assign
        f-invclipt      = buf_clients.obj-code
        f-invclipt-name = buf_clients.obj-name
      .
    end.
    else do:
      assign
        f-invclipt      = ?
        f-invclipt-name = "":U
      .
    end.

    display
      f-invclipt
      f-invclipt-name
      with frame {&frame-name} .

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-set_dop-info
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-set_dop-info shattrpt
ON CHOOSE OF B-set_dop-info IN FRAME shattrpt
DO:
  run select-dop-info in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME t-invclipt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t-invclipt shattrpt
ON VALUE-CHANGED OF t-invclipt IN FRAME shattrpt /* Контрагент для списания ЕУ при инвентаризации топлива по сверке: */
DO:
  assign
    t-invclipt
  .
  if t-invclipt = true then do:
    enable
      f-invclipt
      b-invclipt
      with frame {&frame-name} .
    display
      f-invclipt-name
      with frame {&frame-name} .
  end.
  else do:
    assign
      f-invclipt       = ?
      f-invclipt-name = "":U
    .
    display
      f-invclipt
      f-invclipt-name
      with frame {&frame-name} .
    hide
      f-invclipt
      b-invclipt
      f-invclipt
      in frame {&frame-name} .
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK shattrpt 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

{ gbl/app_help.i }
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  define buffer buf_shop    for ub.shop .
  define buffer buf_store   for ub.store .
  define buffer buf_sysconf for ub.sysconf .
  define buffer buf_clients for ub.clients .

  { gbl/getcntxt.i get }

  if p-mode <> {&lookup}
    and p-mode <> {&update}
  then do:
    message
    vss-workfile vss-revision vss-description skip
    "Неверное значение параметра p-mode" p-mode
    view-as alert-box error.
    undo, return error.
  end.

  if p-obj-type <> {&shop}
    and p-obj-type <> {&stock}
    and p-obj-type <> {&cmp}
    and p-obj-type <> '':U
  then do:
      message
        vss-workfile vss-revision vss-description skip
        "Неверное значение параметра p-obj-type" p-obj-type
        view-as alert-box error.
      undo, return error.
  end.

  case p-obj-type :
    when {&shop} then do:
      find first buf_shop no-lock
        where buf_shop.obj-code = p-obj-code
        no-error.
      if not available buf_shop then do:
        message
          vss-workfile vss-revision vss-description skip
          substitute( "Неверное значение параметра p-obj-code" ) skip
          substitute( "Магазин с кодом &1 не найден", p-obj-code ) skip
          view-as alert-box error.
        undo, return error.
      end.
    end.
    when {&stock} then do:
      find first buf_store no-lock
        where buf_store.obj-code = p-obj-code
        no-error.
      if not available buf_store then do:
        message
          vss-workfile vss-revision vss-description skip
          substitute( "Неверное значение параметра p-obj-code" ) skip
          substitute( "Склад с кодом &1 не найден", p-obj-code ) skip
          view-as alert-box error.
        undo, return error.
      end.
    end.
    when {&cmp} then do:
      find first buf_sysconf no-lock
        where buf_sysconf.host-code = p-obj-code
        no-error.
      if not available buf_sysconf then do:
        message
          vss-workfile vss-revision vss-description skip
          substitute( "Неверное значение параметра p-obj-code" ) skip
          substitute( "Фирма с кодом &1 не найдена", p-obj-code ) skip
          view-as alert-box error.
        undo, return error.
      end.
    end.
  end case.

  if p-mode <> {&lookup}
    and v-cntxt-db-num <> 0
  then do:
    case trim( p-obj-type ) :
      when '':U then do:
        message
          "Нельзя менять ГЛОБАЛЬНЫЕ параметры в УБД" Skip
          view-as alert-box error.
        undo, return error.
      end.
      when {&shop}
      or when {&stock}
      then do:
        { gbl/objdbnum.i p-obj-type p-obj-code v-db-num }
        if v-db-num <> v-cntxt-db-num then do:
          message
            "Нельзя менять параметры объекта в чужой БД" skip
            "объект принадлежит БД" v-db-num "текущая БД" v-cntxt-db-num
            view-as alert-box error.
          undo, return error.
        end.
      end.
      when {&cmp} then do:
        message
          "Нельзя менять параметры ФИРМЫ в УБД" Skip
          view-as alert-box error.
        undo, return error.
      end.
    end case.
  end.

/*  if p-obj-type = {&db} then*/
/*   frame {&frame-name}:title = substitute( "&1. БД &2", frame {&frame-name}:title,  p-obj-code) .*/

  if p-mode = {&update} then do:
    find first locked_thbj-attr exclusive-lock
      where locked_thbj-attr.obj-type = p-obj-type
        and locked_thbj-attr.obj-code = p-obj-code
        and locked_thbj-attr.upper-prop-code = {&attr-petrol}
        and locked_thbj-attr.prop-code = "":u
    no-wait no-error.
    if locked locked_thbj-attr then do:
      message
        vss-workfile vss-revision vss-description skip
        "Запись ПАРАМЕТРЫ(АТРИБУТЫ) занята"
      view-as alert-box error .
      undo, return error.
    end.
  end.
  else do:
    find first locked_thbj-attr no-lock
      where locked_thbj-attr.obj-type = p-obj-type
        and locked_thbj-attr.obj-code = p-obj-code
        and locked_thbj-attr.upper-prop-code = {&attr-petrol}
        and locked_thbj-attr.prop-code = '':u
      no-error.
  end.
  if not available locked_thbj-attr then do:
    assign
      v-to-create  = yes
    .
    message
      substitute ("Внимание!!!&1Параметра НЕТ в БД!&1Будут показаны ЗНАЧЕНИЯ ПО УМОЛЧАНИЮ", {&new-line} )
    view-as alert-box WARNING.
  end.

  assign
    v-tth = buffer thbjattr_thbj-attr:table-handle
  .

  run fill-widgets in this-procedure no-error.
  if error-status:error then undo, return error.

  find first buf_clients no-lock
    where buf_clients.obj-code = f-invclipt
      and buf_clients.obj-type = {&cmp}
    no-error.
  if available buf_clients then do:
    assign
      t-invclipt      = true
      f-invclipt-name = buf_clients.obj-name
    .
  end.
  else do:
    assign
      t-invclipt      = false
      f-invclipt-name = "":U
    .
  end.

  RUN proc-init-dop-info.
  RUN enable_UI.

  apply "value-changed" to t-invclipt in frame {&frame-name} .

  if p-mode = {&lookup} then do:
    disable
      all
      with frame {&frame-name} .
    enable
      b-quit
      B-set_dop-info
      with frame {&frame-name} .
  end.
  hide dop-info in frame {&frame-name} .
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI shattrpt  _DEFAULT-DISABLE
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
  HIDE FRAME shattrpt.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI shattrpt  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY t-autopump-izm t-autopump t-avtinvpm t-olddens r-expptrl r-inpptrl 
          dop-info rvs-wt-email r-algrvspt t-rvsnmter t-invclipt f-invclipt 
          r-temp-for-pomi r-denstclc mass-proc r-algoincptrl 
          t-mand-chioce-autocar otkl-fact-volue delta-horiz delta-vert otkl-temp 
          otkl-density otkl-water v-dop-info f-invclipt-name 
      WITH FRAME shattrpt.
  ENABLE B-exit b-quit B-Help RECT-1 RECT-2 RECT-3 RECT-4 RECT-5 RECT-6 
         t-autopump-izm t-autopump t-avtinvpm t-olddens r-expptrl r-inpptrl 
         dop-info rvs-wt-email B-set_dop-info r-algrvspt t-rvsnmter t-invclipt 
         f-invclipt b-invclipt r-temp-for-pomi r-denstclc mass-proc 
         r-algoincptrl t-mand-chioce-autocar otkl-fact-volue delta-horiz 
         delta-vert otkl-temp otkl-density otkl-water v-dop-info 
      WITH FRAME shattrpt.
  {&OPEN-BROWSERS-IN-QUERY-shattrpt}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fill-widgets shattrpt 
PROCEDURE fill-widgets :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
define variable v-param-type      as character  no-undo .
define variable v-value-character as character  no-undo .
define variable v-value-date      as date       no-undo .
define variable v-value-decimal   as decimal    no-undo .
define variable v-value-integer   as integer    no-undo .
define variable v-value-logical   as logical    no-undo .
define variable v-entry           as character  no-undo .


do
on error undo, return error return-value
:
  for each thbjattr_thbj-attr
  :
    delete thbjattr_thbj-attr .
  end.
  for each temp-thbj-attr
  :
    delete temp-thbj-attr .
  end.
  run adm/shattri.p
    ( input "init":U
    , input p-obj-type
    , input p-obj-code
    , input {&attr-petrol}
    , input "":U
    , output v-value-character
    , output v-value-date
    , output v-value-decimal
    , output v-value-integer
    , output v-value-logical
    , output v-param-type
    , input-output table-handle v-tth
    ) no-error .
    
  if error-status:error
    and not available locked_thbj-attr
  then do:
    message
    "Не удалось получить начальные значения настроек" skip
    error-status:get-message(1) return-value
    view-as alert-box error .
    undo, return error .
  end.

  for each thbjattr_thbj-attr:
    assign
      v-entry = thbjattr_thbj-attr.prop-code
    .
    case v-entry:
      when {&attr-petrol_denstclc} then do:
        assign
          r-denstclc = thbjattr_thbj-attr.property-value-character
          r-denstclc :private-data in frame {&frame-name} = "recid=" + string(recid(thbjattr_thbj-attr))
        .
      end.
    
      when {&attr-petrol_autopump} then do:
        assign
          t-autopump = thbjattr_thbj-attr.property-value-logical
          t-autopump :private-data in frame {&frame-name} = "recid=" + string(recid(thbjattr_thbj-attr))
        .
      end.
        when {&attr-petrol_autopump-izm} then do: 
          assign t-autopump-izm =  thbjattr_thbj-attr.property-value-logical
             t-autopump-izm :private-data in frame {&frame-name} = "recid=" + string(recid(thbjattr_thbj-attr))
        .
          end.
      when {&attr-petrol_avtinvpm} then do:
        assign
          t-avtinvpm = thbjattr_thbj-attr.property-value-logical
          t-avtinvpm :private-data in frame {&frame-name} = "recid=" + string(recid(thbjattr_thbj-attr))
        .
      end.
      when {&attr-petrol_expptrl} then do:
        assign
          r-expptrl = thbjattr_thbj-attr.property-value-character
          r-expptrl :private-data in frame {&frame-name} = "recid=" + string(recid(thbjattr_thbj-attr))
        .
      end.
      when {&attr-petrol_inpptrl} then do:
        assign
          r-inpptrl = thbjattr_thbj-attr.property-value-character
          r-inpptrl :private-data in frame {&frame-name} = "recid=" + string(recid(thbjattr_thbj-attr))
        .
      end.
      when {&attr-petrol_rvsnmter} then do:
        assign
          t-rvsnmter = thbjattr_thbj-attr.property-value-logical
          t-rvsnmter :private-data in frame {&frame-name} = "recid=" + string(recid(thbjattr_thbj-attr))
        .
      end.
      when {&attr-petrol_invclipt} then do:
        assign
          f-invclipt = thbjattr_thbj-attr.property-value-integer
          f-invclipt :private-data in frame {&frame-name} = "recid=" + string(recid(thbjattr_thbj-attr))
        .
      end.
      when {&attr-petrol_olddens} then do:
        assign
          t-olddens = thbjattr_thbj-attr.property-value-logical
          t-olddens :private-data in frame {&frame-name} = "recid=" + string(recid(thbjattr_thbj-attr))
        .
      end.
      when {&attr-petrol_algrvspt} then do:
        assign
          r-algrvspt = thbjattr_thbj-attr.property-value-integer
          r-algrvspt :private-data in frame {&frame-name} = "recid=" + string(recid(thbjattr_thbj-attr))
        .
      end.

      when {&attr-petrol_temp-for-pomi} then do:
        assign
          r-temp-for-pomi = thbjattr_thbj-attr.property-value-integer
          r-temp-for-pomi :private-data in frame {&frame-name} = "recid=" + string(recid(thbjattr_thbj-attr))
        .
      end.
      when {&attr-petrol_rvs-wt-email} then do:
        assign
          rvs-wt-email = thbjattr_thbj-attr.property-value-character
          rvs-wt-email :private-data in frame {&frame-name} = "recid=" + string(recid(thbjattr_thbj-attr))
        .
      end.
      when {&attr-petrol_CriticalDif} then 
          do:
            assign 
              mass-proc = thbjattr_thbj-attr.property-value-character 
              mass-proc :private-data in frame {&frame-name} = "recid=" + string(recid(thbjattr_thbj-attr))
            .  
          end.
      when {&attr-petrol_algoincome} then 
          do: 
            assign
              r-algoincptrl = thbjattr_thbj-attr.property-value-integer 
              r-algoincptrl :private-data in frame {&frame-name} = "recid=" + string(recid(thbjattr_thbj-attr))
              .
          end.
      when {&attr-petrol_otkl-fact-volue} then 
          do: 
            assign
              otkl-fact-volue = thbjattr_thbj-attr.property-value-decimal 
              otkl-fact-volue :private-data in frame {&frame-name} = "recid=" + string(recid(thbjattr_thbj-attr))
              .
          end.
      when {&attr-petrol_otkl-temp} then 
          do: 
            assign
              otkl-temp = thbjattr_thbj-attr.property-value-decimal 
              otkl-temp :private-data in frame {&frame-name} = "recid=" + string(recid(thbjattr_thbj-attr))
              .
          end.          
      when {&attr-petrol_otkl-density} then 
          do: 
            assign
              otkl-density = thbjattr_thbj-attr.property-value-decimal 
              otkl-density :private-data in frame {&frame-name} = "recid=" + string(recid(thbjattr_thbj-attr))
              .
          end.          
      when {&attr-petrol_otkl-water} then 
          do: 
            assign
              otkl-water = thbjattr_thbj-attr.property-value-decimal 
              otkl-water :private-data in frame {&frame-name} = "recid=" + string(recid(thbjattr_thbj-attr))
              .
          end.                                            
      when {&attr-petrol_mand-choice-autocar} then 
          do: 
            assign
              t-mand-chioce-autocar = thbjattr_thbj-attr.property-value-logical 
              t-mand-chioce-autocar :private-data in frame {&frame-name} = "recid=" + string(recid(thbjattr_thbj-attr))
            .  
          end.
       when {&attr-petrol_Delta-mass-horiz} then 
          do:
            assign 
              delta-horiz = thbjattr_thbj-attr.property-value-character 
              delta-horiz :private-data in frame {&frame-name} = "recid=" + string(recid(thbjattr_thbj-attr))
            .  
          end.
        when {&attr-petrol_Delta-mass-vert} then 
          do:
            assign 
              delta-vert = thbjattr_thbj-attr.property-value-character 
              delta-vert :private-data in frame {&frame-name} = "recid=" + string(recid(thbjattr_thbj-attr))
            .  
          end.
        when {&attr-petrol_dop-info} then 
          do:
            assign 
              dop-info = thbjattr_thbj-attr.property-value-character 
              dop-info :private-data in frame {&frame-name} = "recid=" + string(recid(thbjattr_thbj-attr))
            .  
          end.              
    end case.
    create temp-thbj-attr.
    buffer-copy thbjattr_thbj-attr to temp-thbj-attr.
  end.

  
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-init-dop-info shattrpt 
PROCEDURE proc-init-dop-info :
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/


   assign
      v-list-dop-info      = {&trdcattr-car-num} + "," + {&trdcattr-fio-driver} + "," + {&trdcattr-time-income} + "," + {&trdcattr-time-pour} + "," + {&trdcattr-date-pour} + "," + {&trdcattr-inspection-cert} + ","
      + {&trdcattr-date-cert} + "," + {&trdcattr-condition} + "," + {&trdcattr-seals-condition} + "," + {&trdcattr-acc-ship} + "," + {&trdcattr-doc-not} + "," + {&trdcattr-spisok-not-doc} + "," + {&trdcattr-ptbobj} + 
      "," + {&trdcattr-ptb-item-pour} + "," + {&trdcattr-autoent}.
      v-list-dop-info-full = {&label-trdcattr-car-num} + "," + {&label-trdcattr-fio-driver} + "," + {&label-trdcattr-time-income} + "," + {&label-trdcattr-time-pour} + "," + {&label-trdcattr-date-pour} + "," + {&label-trdcattr-inspection-cert} + ","
      + {&label-trdcattr-date-cert} + "," + {&label-trdcattr-condition} + "," + {&label-trdcattr-seals-condition} + "," + {&label-trdcattr-acc-ship} + "," + {&label-trdcattr-doc-not} + "," + {&label-trdcattr-spisok-not-doc} +
       "," + {&label-trdcattr-ptbobj} + "," + {&label-trdcattr-ptb-item-pour} + "," + {&label-trdcattr-autoent}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-save shattrpt 
PROCEDURE proc-save :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
define variable v-value-character as character      no-undo .
define variable v-value-date      as date           no-undo .
define variable v-value-decimal   as decimal        no-undo .
define variable v-value-integer   as integer        no-undo .
define variable v-value-logical   as logical        no-undo .
define variable v-sale-add        as character      no-undo .
define variable v-param-type      as character      no-undo .
define variable wh                as widget-handle  no-undo .
define variable fh                as widget-handle  no-undo .
define variable v-same            as logical        no-undo .

do
on error undo, return error return-value
:
display dop-info with frame {&frame-name} .
hide dop-info in frame {&frame-name} .

  if p-mode = {&lookup} then do:
    return error.
  end.

  define buffer buf_clients for ub.clients .

  assign
    frame {&frame-name} t-invclipt
    frame {&frame-name} f-invclipt
/*    frame {&frame-name} r-denstclc*/
    fh = frame {&frame-name}:first-child
    wh = fh:first-child
  .

  if t-invclipt = true then do:
    find first buf_clients no-lock
      where buf_clients.obj-code = f-invclipt
        and buf_clients.obj-type = {&cmp}
      no-error.
    if not available buf_clients then do:
      message
        "Некорректное значение НАСТРОЙКИ"    skip
        t-invclipt:label                     skip
        view-as alert-box error .
      undo, return error .
    end.
  end.

  do while valid-handle(wh):
    if wh:private-data begins "recid=" then do:
      find first thbjattr_thbj-attr
        where recid(thbjattr_thbj-attr) = integer(entry(2, wh:private-data, '='))
      .
      assign
        buffer thbjattr_thbj-attr:buffer-field("property-value-" + wh:data-type):buffer-value = wh:input-value
      .
    end.
    wh = wh:next-sibling.
  end.

  assign
    v-same = yes
  .

  for each thbjattr_thbj-attr,
      first temp-thbj-attr
        where temp-thbj-attr.obj-type         = thbjattr_thbj-attr.obj-type
          and temp-thbj-attr.obj-code         = thbjattr_thbj-attr.obj-code
          and temp-thbj-attr.upper-prop-code  = thbjattr_thbj-attr.upper-prop-code
          and temp-thbj-attr.prop-code        = thbjattr_thbj-attr.prop-code
  :
    buffer-compare thbjattr_thbj-attr to temp-thbj-attr save result in v-same.
    
/*    message  thbjattr_thbj-attr.prop-code "tt"  thbjattr_thbj-attr.upper-prop-code "oo" v-same view-as alert-box.*/
    if v-same = false then do:
      leave.
    end.
  end.

/*  if v-same = false                            */
/*    and v-to-create = true                     */
/*    and p-obj-type <> '':U                     */
/*  then do:                                     */
/*    message                                    */
/*      "вы действительно хотите сохранить набор"*/
/*      view-as alert-box.                       */
/*    assign                                     */
/*      v-same = true                            */
/*    .                                          */
/*  end.                                         */

  if v-same = true
    and v-to-create = false
  then do:
    return.
  end.
  /*проверим корректность*/
  run adm/shattri.p
    ( input "check":U
    , input p-obj-type
    , input p-obj-code
    , input {&attr-petrol}
    , INPUT '':U
    , output v-value-character
    , output v-value-date
    , output v-value-decimal
    , output v-value-integer
    , output v-value-logical
    , output v-param-type  
    , input-output table-handle v-tth
    ) no-error .


  if error-status :error then do:
    message
      "Некорректное значение ПАРАМЕТРОВ"  skip
      error-status:get-message(1)         skip
      return-value
    view-as alert-box error .
    undo, return error .
  end.


  run thbjattr_set-section in this-procedure
    ( input p-obj-type
    , input p-obj-code
    , input {&attr-petrol}
    , input table thbjattr_thbj-attr
    ) no-error.
  if error-status:error then do:
    message
      error-status:get-message(1)  skip
      return-value
    view-as alert-box.
    undo, return error.
  end.

end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE select-dop-info shattrpt 
PROCEDURE select-dop-info :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

define variable v-counter       as integer      no-undo.
define variable v-label         as character    no-undo.
define variable v-value         as character    no-undo.
define variable v-list          as character    no-undo.
define variable v-changed       as logical    no-undo.
define variable v-accepted      as logical    no-undo.
define variable v-mode          as integer    no-undo.
define variable V-EX as logical   no-undo .

do
with frame {&frame-name}
on error undo, return error
:
if p-mode = {&lookup} then v-mode = 0 .
else v-mode = 1 .

    run twowin_clear in this-procedure.

    do v-counter = 1 to num-entries( v-list-dop-info-full )
    on error undo, return error
    :
        assign
            v-label = entry( v-counter, v-list-dop-info-full )
            v-value = entry( v-counter, v-list-dop-info )
            v-ex = false
        .
           if  lookup (v-value , dop-info ) > 0 then  v-ex = true .
           else v-ex = false .
        run twowin_add-item in this-procedure (
              input v-value
            , input v-label
            , input substitute( "Обязательные поля: &1", v-VALUE)
            , input  V-EX
        ).
    end.        /* do */
    run gbl/twowin.w (
          input ?
        , input v-mode
        , input "Выбор обязательного поля доп.инфо ПН":U
        , input "":U
        , input "&Тест"
        , input table temp_twowin_items
        , output table temp_twowin_itemsSelected_col
        , output v-changed
        , output v-accepted
    ).
    if v-changed then do:
        dop-info = "" .
        for each temp_twowin_itemsSelected_col :
        dop-info = dop-info +  temp_twowin_itemsSelected_col.itmExtKey + "," .
        end.
        dop-info = trim(dop-info, ",") .
        display dop-info with frame {&frame-name} .
                    hide dop-info in frame {&frame-name} .
    end.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

