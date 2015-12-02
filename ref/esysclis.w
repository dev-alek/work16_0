&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases
          ub               PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER X_clients FOR ub.clients.
DEFINE BUFFER X_ext-classif FOR ub.ext-classif.
DEFINE BUFFER X_ext-system FOR ub.ext-system.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Коды объектов внешней системы

Автор: Бахтадзе Наталья Викторовна
Дата создания: 07/31/07
Author: Bakhtadze Natalya
Creation date: 07/31/07

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER parparentproc AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER bttns AS character NO-UNDO.
DEFINE INPUT PARAMETER p-list-mode AS character NO-UNDO.
define input parameter p-esys-id as integer no-undo .
DEFINE INPUT-OUTPUT PARAMETER p-rid-list AS character NO-UNDO.

/* Local Variable Definitions ---                                       */
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Коды объектов внешней системы".
{ cmp/vssrevis.i }
{ gbl/waitfram.i }
{ cmp/str-glbl.i }
{ cmp/showinf.i }
{ cmp/library.i }
{ gbl/getcntxt.i def }
{ gbl/key-rec.i }
{ gbl/flt-def.i  }
{ gbl/fltfield.i }
{ cmp/mrk-strf.i }
{ ref/extclass.i }
{ gbl/cur-time.i }
{ cmp/r-pril.i }
{ gbl/prn-lib.i }
{ gbl/fltopend.i defproc }
define variable sort-column-name as character no-undo.
define variable filter-point     as character NO-UNDO INIT "esysclis".
define variable filter-label     as character NO-UNDO INIT "Коды объектов внешней системы".
define variable filter-point0     as character NO-UNDO INIT "esysclis".
define variable filter-label0     as character NO-UNDO INIT "Коды объектов внешней системы".
DEFINE VARIABLE v-rid-list AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME br-esys-cli

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES X_ext-classif X_clients

/* Definitions for BROWSE br-esys-cli                                   */
&Scoped-define FIELDS-IN-QUERY-br-esys-cli mark-string(recid(X_ext-classif), v-rid-list) X_ext-classif.KEY#_one get-esys-name(X_ext-classif.KEY#_one) X_ext-classif.charkey_one X_ext-classif.KEY#_two X_clients.obj-type X_clients.obj-code X_clients.obj-name
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-esys-cli
&Scoped-define SELF-NAME br-esys-cli
&Scoped-define QUERY-STRING-br-esys-cli FOR EACH X_ext-classif NO-LOCK, ~
       FIRST X_clients NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-esys-cli OPEN QUERY {&SELF-NAME} FOR EACH X_ext-classif NO-LOCK, ~
       FIRST X_clients NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-esys-cli X_ext-classif X_clients
&Scoped-define FIRST-TABLE-IN-QUERY-br-esys-cli X_ext-classif
&Scoped-define SECOND-TABLE-IN-QUERY-br-esys-cli X_clients


/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Dialog-Frame ~
    ~{&OPEN-QUERY-br-esys-cli}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-quit B-mark B-sel b-add b-del b-cli b-esys ~
b-sch b-print B-Help br-esys-cli mark-num
&Scoped-Define DISPLAYED-OBJECTS mark-num

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD get-cli-name Dialog-Frame
FUNCTION get-cli-name RETURNS CHARACTER
  ( INPUT p-uniq-key-rec AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD get-cli-type-code Dialog-Frame
FUNCTION get-cli-type-code RETURNS CHARACTER
  ( INPUT p-uniq-key-rec AS character )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD get-esys-name Dialog-Frame
FUNCTION get-esys-name RETURNS CHARACTER
  ( INPUT p-esys-id AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-add
     LABEL "&Добавить"
     SIZE 10 BY 1.

DEFINE BUTTON b-cli
     LABEL "Объект"
     SIZE 10 BY 1.

DEFINE BUTTON b-del
     LABEL "&Удалить"
     SIZE 10 BY 1.

DEFINE BUTTON b-esys
     LABEL "ВС"
     SIZE 10 BY 1.

DEFINE BUTTON B-Help
     LABEL "Помо&щь"
     SIZE 3 BY 1
     BGCOLOR 8 .

DEFINE BUTTON B-mark
     LABEL "&*"
     SIZE 3 BY 1.

DEFINE BUTTON b-print
     LABEL "&Печать"
     SIZE 3 BY 1.

DEFINE BUTTON b-quit AUTO-END-KEY
     LABEL "&Выход"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-sch
     LABEL "Фильтр"
     SIZE 3 BY 1.

DEFINE BUTTON B-sel AUTO-GO
     LABEL "Вы&бор"
     SIZE 10 BY 1.

DEFINE VARIABLE mark-num AS CHARACTER FORMAT "X(256)":U
      VIEW-AS TEXT
     SIZE 6 BY 1
     FGCOLOR 4  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-esys-cli FOR X_ext-classif, X_clients SCROLLING.

&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-esys-cli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-esys-cli Dialog-Frame _FREEFORM
  QUERY br-esys-cli NO-LOCK DISPLAY
      mark-string(recid(X_ext-classif), v-rid-list) COLUMN-LABEL "" FORMAT "X(1)"
X_ext-classif.KEY#_one  COLUMN-LABEL "Код!внешней!системы" FORMAT ">>>>>>>>9"
get-esys-name(X_ext-classif.KEY#_one) COLUMN-LABEL "Внешняя система" FORMAT "X(30)"
X_ext-classif.charkey_one  COLUMN-LABEL "Тип!объ!во!внеш.!сист." FORMAT "X(3)"
X_ext-classif.charkey_three  COLUMN-LABEL "Код!объ.!во!внеш.!сист." FORMAT "X(16)"
X_clients.obj-type COLUMN-LABEL "Тип!объекта" FORMAT "X(3)"
X_clients.obj-code COLUMN-LABEL "Код!объекта" FORMAT ">>>>>>>>9"
X_clients.obj-name COLUMN-LABEL "Название объекта" FORMAT "X(60)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 98.3 BY 20.37 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     b-quit AT ROW 1 COL 1
     B-mark AT ROW 1 COL 11 WIDGET-ID 4
     B-sel AT ROW 1 COL 21 WIDGET-ID 6
     b-add AT ROW 1 COL 31 WIDGET-ID 14
     b-del AT ROW 1 COL 41 WIDGET-ID 16
     b-cli AT ROW 1 COL 51 WIDGET-ID 2
     b-esys AT ROW 1 COL 61 WIDGET-ID 18
     b-sch AT ROW 1 COL 86 WIDGET-ID 12
     b-print AT ROW 1 COL 89 WIDGET-ID 10
     B-Help AT ROW 1 COL 95
     br-esys-cli AT ROW 2.87 COL 1.5 WIDGET-ID 100
     mark-num AT ROW 1 COL 12.5 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     SPACE(79.30) SKIP(21.26)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE
         TITLE ""
         CANCEL-BUTTON b-quit.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
   Temp-Tables and Buffers:
      TABLE: X_clients B "?" ? ub clients
      TABLE: X_ext-classif B "?" ? ub ext-classif
      TABLE: X_ext-system B "?" ? ub ext-system
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
/* BROWSE-TAB br-esys-cli B-Help Dialog-Frame */
ASSIGN
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-esys-cli
/* Query rebuild information for BROWSE br-esys-cli
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH X_ext-classif NO-LOCK, FIRST X_clients NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _START_FREEFORM_DEFINE
DEFINE QUERY br-esys-cli FOR X_ext-classif, X_clients SCROLLING.
     _END_FREEFORM_DEFINE
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-esys-cli */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-add Dialog-Frame
ON CHOOSE OF b-add IN FRAME Dialog-Frame /* Добавить */
DO:
  RUN proc-b-add IN THIS-PROCEDURE NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-cli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-cli Dialog-Frame
ON CHOOSE OF b-cli IN FRAME Dialog-Frame /* Объект */
DO:
  IF NOT AVAILABLE X_clients THEN RETURN NO-APPLY.
  run ref/showcli.p ( INPUT parparentproc
                     ,INPUT X_clients.obj-type
                     ,INPUT X_clients.obj-code) NO-ERROR.
  APPLY "entry" TO br-esys-cli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-del Dialog-Frame
ON CHOOSE OF b-del IN FRAME Dialog-Frame /* Удалить */
DO:
  IF NOT AVAILABLE X_ext-classif THEN RETURN NO-APPLY.
  RUN proc-b-del IN THIS-PROCEDURE NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-esys
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-esys Dialog-Frame
ON CHOOSE OF b-esys IN FRAME Dialog-Frame /* ВС */
DO:
define variable v-have-rights    as logical        no-undo.
define variable v-success    as logical        no-undo.
define variable v-esys-id   as integer        no-undo.
  IF NOT AVAILABLE X_ext-classif THEN RETURN NO-APPLY.
 ASSIGN
 v-esys-id = X_ext-classif.key#_one.
    { gbl/chk-actg.i
    v-cntxt-db-num
    v-cntxt-userid
    {&action-head-code-main}
    'actn_openxml-subsystem_lookup':U
    {&cntxt-global}
    0
    '':U
    0
    0
    0
    0
    yes
    v-have-rights
    }
    if v-have-rights = yes
    then do:
                  run bge/oxmlspci.w (
                input parparentproc
              , input {&lookup}
              , input-output v-esys-id
              , input 0 /*v-db-num*/
              , output v-success
          ) no-error.
 end.

  APPLY "entry" TO br-esys-cli.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-mark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-mark Dialog-Frame
ON CHOOSE OF B-mark IN FRAME Dialog-Frame /* * */
DO:
  define variable loc#log as logical no-undo .
  if available X_ext-classif then do:
    { gbl/markstrn.i X_ext-classif v-rid-list }
    loc#log = br-esys-cli:refresh() .

    if last-event:function <> "MOUSE-SELECT-DBLCLICK" then do:
        loc#log = br-esys-cli:select-next-row ().
        apply "VALUE-CHANGED" to br-esys-cli in frame {&frame-name}.
    end.
    if num-entries( v-rid-list ) = 0
    then
        hide mark-num in frame {&frame-name}.
    else
        disp num-entries( v-rid-list ) @ mark-num with frame {&frame-name}.
  end.
  apply "entry" to br-esys-cli in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-print Dialog-Frame
ON CHOOSE OF b-print IN FRAME Dialog-Frame /* Печать */
DO:
  run proc-b-print IN THIS-PROCEDURE NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-sch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-sch Dialog-Frame
ON CHOOSE OF b-sch IN FRAME Dialog-Frame /* Фильтр */
DO:
  run proc-b-sch IN THIS-PROCEDURE NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-sel Dialog-Frame
ON CHOOSE OF B-sel IN FRAME Dialog-Frame /* Выбор */
DO:
    if ( available X_ext-classif ) then do:
    if  ( v-rid-list = "" ) or b-mark:sensitive = no
    then
    v-rid-list = string( recid( X_ext-classif ) ) .
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-esys-cli
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.
{ gbl/app_help.i }
{ gbl/setfltnm.i }

{ gbl/hot-key.i b-print }
{ gbl/hot-key.i b-add }
{ gbl/hot-key.i b-del }
{ gbl/hot-key.i b-mark }
{ gbl/hot-key.i b-sel }
&scop b-quit ~{&b-exit~}
{ gbl/hot-key.i b-quit }



/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
 { gbl/getcntxt.i get }
  v-rid-list = p-rid-list.
  if not (p-list-mode = {&all}
         or
         p-list-mode = "one") then  do:
    message
    substitute("Неверное значение параметра p-list-mode=&1", p-list-mode)
    view-as alert-box error .
    undo, return error .
  end.
  if p-list-mode = "one" then do:
    find first X_ext-system no-lock where
              X_ext-system.db-num = 0
          and X_ext-system.esys-id = p-esys-id no-error.
    if not available X_ext-system then do:
      message
      substitute("Неверное значение параметра p-esys-id=&1&2" +
                  "Нет внешней системы &1 с db-num = 0"
                , p-esys-id)
      view-as alert-box error .
      undo, return error .
    end.
  end.
  RUN Myenable.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
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
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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
  DISPLAY mark-num
      WITH FRAME Dialog-Frame.
  ENABLE b-quit B-mark B-sel b-add b-del b-cli b-esys b-sch b-print B-Help
         br-esys-cli mark-num
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MyEnable Dialog-Frame
PROCEDURE MyEnable :
ENABLE
b-quit
b-cli
b-print
b-add when (v-cntxt-db-num = 0 and lookup("b-add", bttns) > 0 and not transaction)
b-del when (v-cntxt-db-num = 0 and lookup("b-add", bttns) > 0 and not transaction)
b-esys
b-sch
B-Help
br-esys-cli
WITH FRAME {&frame-name}.
VIEW FRAME {&frame-name}.
RUN Openbr IN THIS-PROCEDURE ( INPUT YES, INPUT NO, INPUT '':U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenBr Dialog-Frame
PROCEDURE OpenBr :
define input  parameter p-open-query     as logical   no-undo .
define input  parameter p-find-next      as logical   no-undo .
define input  parameter p-find-condition as character no-undo .
define variable sort-column-phrase as character no-undo .
define variable l-query-was-opened as logical no-undo .
define variable title0 as character no-undo .
define buffer buf_clients for ub.clients.

case sort-column-name :
  when "" then do:
    assign
      sort-column-phrase = ""
    .
  end.
  otherwise do:
    assign
      sort-column-phrase = "by " + sort-column-name
    .
  end.
end case.
&scop flt-open-debug-file

&scop flt-open-open-query         OPEN QUERY br-esys-cli FOR EACH X_ext-classif

&scop flt-open-dyn_open-query     FOR EACH X_ext-classif

&scop flt-open-query-handle       QUERY br-esys-cli:handle

&scop flt-open-open-query-tail  , FIRST X_clients NO-LOCK WHERE ~
                                  X_clients.obj-type = ENTRY(2, X_eXt-classif.uniq-key-rec, {&delim-key}) AND ~
                                  X_clients.obj-code = integer(ENTRY(3, X_eXt-classif.uniq-key-rec, {&delim-key}))


&scop flt-open-query-was-opened   l-query-was-opened

&scop flt-open-sort-column-phrase sort-column-phrase

&scop flt-open-call-point         filter-point

&scop flt-open-set-filter-name    set-filter-name

&scop flt-open-indexed-reposition INDEXED-REPOSITION
filter-point = filter-point0 + p-list-mode .

case p-list-mode :
  when {&all} then do:
    title0 = "Объекты всех внешних систем".
    ASSIGN
    frame {&frame-name}:title = substitute("&1", title0)
    filter-label = SUBSTITUTE("&1"
                              , frame {&frame-name}:title
                              )
    .
    { gbl/fltopend.i
      &where-cond = " X_ext-classif.classif-subject = ~{&table_clients~} ~
                      and X_ext-classif.classif-name = ~{&extclass_clients_esys~} ~
                      AND X_ext-classif.db-num = 0"
      &dyn_where-cond = " substitute('X_ext-classif.classif-subject = &1&2&1 ~
                      and X_ext-classif.classif-name = &1&3&1 ~
                      AND X_ext-classif.db-num = 0', ~{&double-quote~}, ~{&table_clients~}, ~{&extclass_clients_esys~})"

      &use-ind    = "  "
      &by         = "  " }
  end.
  when "one" then do:
    title0 = substitute("Объекты внешней системы &1", p-esys-id).
    ASSIGN
    frame {&frame-name}:title = substitute("&1", title0)
    filter-label = SUBSTITUTE("&1"
                              , frame {&frame-name}:title
                              )
    .
    { gbl/fltopend.i
      &where-cond = " X_ext-classif.classif-subject = ~{&table_clients~} ~
                      and X_ext-classif.classif-name = ~{&extclass_clients_esys~} ~
                      AND X_ext-classif.db-num = 0 ~
                      AND X_ext-classif.key#_one = p-esys-id"
      &dyn_where-cond = " substitute('X_ext-classif.classif-subject = &1&2&1 ~
                      and X_ext-classif.classif-name = &1&3&1 ~
                      AND X_ext-classif.db-num = 0 ~
                      AND X_ext-classif.key#_one = &4', ~{&double-quote~}, ~{&table_clients~}, ~{&extclass_clients_esys~}, p-esys-id)"

      &use-ind    = "  "
      &by         = "  " }

  end.
end case.
APPLY "entry" TO br-esys-cli.
if available X_ext-classif then do:
    APPLY "VALUE-CHANGED":U to {&browse-name}.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-b-add Dialog-Frame
PROCEDURE proc-b-add :
DEFINE VARIABLE v-rid-list AS CHARACTER NO-UNDO.
define variable v-rid as recid no-undo .
DEFINE VARIABLE v-ok AS logical NO-UNDO.
define variable v-esys-id as integer no-undo .
DEFINE VARIABLE v-value-character2 AS character NO-UNDO.
define variable v-value-character as character no-undo .
define variable v-uniq-key-rec as character no-undo .
define variable v-esys-uniq-key-rec as character no-undo .
define variable v-tbl-row as rowid no-undo .
define variable v-tbl-name as character no-undo .
define buffer buf_clients for ub.clients.
define buffer buf_ext-system for ub.ext-system.
if not available X_ext-system then do:
  message
  "Выберите внешнюю систему, для которой Вы хотите добавить запись объекта"
  view-as alert-box .
  run bge/oxmlexts.p (
        input parparentproc
      , input 2                         /* 2- Единичный выбор - 0. Множественный - 1*/
      , input substitute("esys-type > &1", {&openxml-type-ordinal}) /*p-where-string*/
      , input v-esys-uniq-key-rec        /* То, что уже выбрано (список) */
      , output v-rid-list          /* Список выбранных подсистем ( string( db-num ) + chr(6) + string( esys-id ) )*/
      , output v-ok               /* yes, если выбор был сделан. no - Если был отказ от выбора */
  ).
  if v-ok then do:
    run gen-row-keyr in this-procedure
      ( input v-rid-list
        ,input ?
        ,input "ub"
        ,input ?
        ,input no-lock
        ,output v-tbl-row
        ,output v-tbl-name
      ).
    find first buf_ext-system no-lock where
              rowid(buf_ext-system) = v-tbl-row.
  end.
  else do:
   undo, return error .
  end.
end.
else do:
    find first buf_ext-system no-lock where
              rowid(buf_ext-system) = rowid(X_ext-system).
end.
message
"Выберите объект, для которого Вы хотите добавить запись во внешней системе"
view-as alert-box .
run ref/cli-all.w (   input parparentproc
                  ,input "b-sel"
                  ,input {&g___object}
                  ,input {&all}
                  ,input {&current}
                  ,input ?
                  ,input ",,,,,,NO,,"
                  ,input "lock-cli-type":U
                  ,output v-rid-list) no-error.
if v-rid-list = '':U then return no-apply.
find first buf_clients where recid (buf_clients) = integer (v-rid-list) no-lock no-error.
if not (buf_clients.obj-type = {&shop}
       or
       buf_clients.obj-type = {&stock}) then do:
  message
  "Можно выбрать только МАГАЗИН или СКЛАД"
  view-as alert-box error .
  undo, return error .
end.
assign
v-value-character = buf_clients.obj-type
v-value-character2 = string(buf_clients.obj-code)
.
run ref/esysclii.w ( input {&add-def}
                   ,input substitute("Добавление кода объекта во внешней системе &1 для &2&3"
                              ,buf_ext-system.esys-name
                              ,buf_clients.obj-type
                              ,buf_clients.obj-code)
                   ,input-output v-value-character
                   ,input-output v-value-character2
                   ,output v-ok) no-error.
if not v-ok then return error.
run gen-key-rec IN THIS-PROCEDURE ( input {&table_clients}
                               ,input (buffer buf_clients:handle)
                               ,output v-uniq-key-rec).
run ref/extclas1.p ( INPUT {&add-def}
                    ,INPUT NO /*p-silent*/
                    ,INPUT-OUTPUT v-rid
                    ,INPUT {&table_clients} /*p-classif-subject*/
                    ,INPUT {&extclass_clients_esys} /*p-classif-name*/
                    ,input 0 /*p-db-num*/
                    ,input buf_ext-system.esys-id  /*p-key#_one*/
                    ,input 0 /*p-Key#_Two*/
                    ,input 0 /*p-key#_Three*/
                    ,input v-value-character  /*p-CharKey_One */
                    ,input '':U /*p-CharKey_two */
                    ,input v-value-character2 /*p-CharKey_three */
                    ,input 0 /*p-nonunique */
                    ,input v-uniq-key-rec ) no-error.
if error-status:error then do:
  message error-status:get-message(1) view-as alert-box .
  undo, return error .
end.
if v-rid <> ? then do:
  run openbr in this-procedure ( input yes, input no, input '':U).
  reposition br-esys-cli to recid v-rid no-error .
  apply "entry" to br-esys-cli in frame {&frame-name} .
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-b-del Dialog-Frame
PROCEDURE proc-b-del :
DEFINE VARIABLE v-rec AS RECID NO-UNDO.
DEFINE VARIABLE glog AS logical NO-UNDO.
IF NOT AVAILABLE X_ext-classif THEN UNDO, RETURN ERROR.
v-rec = recid(X_ext-classif).
MESSAGE
"Вы действительно хотите удалить эту запись?"
VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE glog.
IF NOT glog THEN RETURN ERROR.
run ref/extclas3.p ( INPUT NO /*p-silent*/
                    ,INPUT v-rec) NO-ERROR.
if not error-status:error then do:
  run openbr in this-procedure ( input yes, input no, input '':U).
  reposition br-esys-cli to row 1 no-error .
  apply "entry" to br-esys-cli in frame {&frame-name} .
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-b-print Dialog-Frame
PROCEDURE proc-b-print :
DEFINE VARIABLE date_string              as   character no-undo .
DEFINE VARIABLE Line                     as   character no-undo .
DEFINE VARIABLE for-time                 as   character no-undo .
DEFINE VARIABLE accum-count              as   integer   no-undo .
define variable v-rid                    as   recid no-undo .
DEFINE VARIABLE v-esys-name AS CHARACTER NO-UNDO.
DEFINE FRAME list1
X_ext-classif.KEY#_one  COLUMN-LABEL "Код!внешней!системы" FORMAT ">>>>>>>>9"
v-esys-name COLUMN-LABEL "Внешняя система" FORMAT "X(30)"
X_ext-classif.charkey_one  COLUMN-LABEL "Тип!объ!во вн.!сист." FORMAT "X(3)"
X_ext-classif.KEY#_two  COLUMN-LABEL "Код!объекта!во вн.!сист." FORMAT ">>>>>>>>9"
X_clients.obj-type COLUMN-LABEL "Тип!объекта" FORMAT "X(3)"
X_clients.obj-code COLUMN-LABEL "Код!объекта" FORMAT ">>>>>>>>9"
X_clients.obj-name COLUMN-LABEL "Название объекта" FORMAT "X(60)"
HEADER  date_string AT 5 format "X(35)"
string( "Страница " ) format "X(9)" AT 75 PAGE-NUMBER(PrnLibStream) AT 85 FORMAT ">>9" SKIP
Line format "X(192)" AT 1
with width {&DOS_CW_2} down stream-io use-text    .

Line = fill("-", 121).
date_string = cur-time-print() .

run prn-lib-open-stream  in this-procedure (
                                             input parParentProc
                                            ,input  {&CS_PS}
                                            ,input yes /*p-is-stream*/
                                            ,input no /*p-append*/
                                            ).

PUT  STREAM PrnLibStream
SPACE(25) ( frame {&frame-name}:title )
format "x(90)" SKIP(1) .
FORM HEADER
Line format "X(177)" AT 1 SKIP
"Продолжение - на следующей странице" AT 30 SKIP
with FRAME BottomFrame width {&DOS_CW_2} PAGE-BOTTOM NO-LABELS NO-BOX .
VIEW  STREAM PrnLibStream FRAME BottomFrame .
v-rid = recid(X_ext-classif).
FORM with FRAME List1.
run waitfram-show in this-procedure ( input "Ждите...").
DO WHILE available X_ext-classif :
   GET prev br-esys-cli.
END.
GET next br-esys-cli.
DO WHILE available X_ext-classif :
  v-esys-name = get-esys-name(X_ext-classif.key#_one).
  Display STREAM PrnLibStream
  X_ext-classif.KEY#_one
  v-esys-name
  X_ext-classif.charKEY_one
  X_ext-classif.KEY#_two
  X_clients.obj-type
  X_clients.obj-code
  X_clients.obj-name
  with FRAME List1.
  DOWN STREAM PrnLibStream
  1
  with FRAME List1.
  assign
  accum-count = accum-count + 1
  .
  GET next br-esys-cli.
END.
UNDERLINE  STREAM PrnLibStream
v-esys-name
X_ext-classif.KEY#_one
X_ext-classif.charKEY_one
X_ext-classif.KEY#_two
X_clients.obj-type
X_clients.obj-code
X_clients.obj-name
with FRAME List1.
DISPLAY STREAM PrnLibStream
accum-count @ X_ext-classif.key#_one
with frame List1.
HIDE  STREAM PrnLibStream FRAME BottomFrame .
HIDE  STREAM PrnLibStream FRAME List1.
output  STREAM PrnLibStream CLOSE.
reposition br-esys-cli to recid v-rid no-error .
apply "ENTRY" to br-esys-cli in frame {&frame-name} .
run waitfram-hide in this-procedure .
run prn-lib-prn-file in this-procedure (
                                          input parParentProc
                                          ,input 0
                                          ).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-b-sch Dialog-Frame
PROCEDURE proc-b-sch :
define variable v-ri as recid no-undo .
assign
v-ri = (if avail X_ext-classif then recid(X_ext-classif) else ?)
.
assign
tbl = {&table_ext-classif}
join-tbl = 'X_ext-classif'
fld = ""
lab = ""
spr = ""
dim = '0'
.

run fltfield-add in this-procedure('key#_one', 'Код внешней системы', '',
input-output fld, input-output lab, input-output spr, input-output dim)  no-error.
run fltfield-add in this-procedure('key#_two', 'Код объекта во внешней системе', '',
input-output fld, input-output lab, input-output spr, input-output dim)  no-error.
run fltfield-add in this-procedure('charkey_one', 'Тип объекта во внешней системе', '',
input-output fld, input-output lab, input-output spr, input-output dim)  no-error.

DO on stop undo, leave:
    run gbl/filter.w ( INPUT parparentproc
                 ,INPUT filter-point + {&delim-par} + filter-label
                 ,INPUT tbl
                 ,INPUT join-tbl
                 ,INPUT fld
                 ,INput lab
                 ,INPUT spr
                 ,INPUT  dim).
    run OpenBr IN THIS-PROCEDURE ( INPUT YES, INPUT NO, INPUT '':U).
    if v-ri <> ? then do:
      reposition br-esys-cli to recid v-ri no-error.
    end.
    APPLY "ENTRY" to br-esys-cli in frame {&frame-name} .
    APPLY "VALUE-CHANGED" to br-esys-cli.
END .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION get-cli-name Dialog-Frame
FUNCTION get-cli-name RETURNS CHARACTER
  ( INPUT p-uniq-key-rec AS CHARACTER ) :
DEFINE VARIABLE v-rowid AS ROWID NO-UNDO.
DEFINE VARIABLE v-tbl-name AS character NO-UNDO.
DEFINE BUFFER buf_clients FOR ub.clients.
RUN gen-row-keyr IN THIS-PROCEDURE ( INPUT p-uniq-key-rec
                                    ,input ?
                                    ,INPUT "ub"
                                    ,INPUT ? /*p-bh-handle*/
                                    ,INPUT NO-LOCK
                                    ,OUTPUT v-rowid
                                    ,OUTPUT v-tbl-name) no-error.
if error-status :error then do:
  message
    vss-workfile vss-revision vss-description skip
    error-status :get-message(1)
    error-status :get-message(2)
  view-as alert-box error.
  undo, return error.
end.
IF v-rowid = ? THEN RETURN 'НЕИЗВЕСТНЫЙ КЛИЕНТ'.

FIND FIRST buf_clients NO-LOCK WHERE ROWID(buf_clients) = v-rowid.
RETURN buf_clients.obj-name.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION get-cli-type-code Dialog-Frame
FUNCTION get-cli-type-code RETURNS CHARACTER
  ( INPUT p-uniq-key-rec AS character ) :
DEFINE VARIABLE v-rowid AS ROWID NO-UNDO.
DEFINE VARIABLE v-tbl-name AS character NO-UNDO.
DEFINE BUFFER buf_clients FOR ub.clients.

    RUN gen-row-keyr IN THIS-PROCEDURE ( INPUT p-uniq-key-rec
                                        ,INPUT ?
                                        ,INPUT "ub"
                                        ,INPUT ? /*p-bh-handle*/
                                        ,INPUT NO-LOCK
                                        ,OUTPUT v-rowid
                                        ,OUTPUT v-tbl-name) NO-ERROR.
    if error-status :error then do:
      message
        vss-workfile vss-revision vss-description skip
        error-status :get-message(1)
        error-status :get-message(2)
      view-as alert-box error.
      undo, return error.
    end.

    IF v-rowid = ? THEN RETURN ''.

    FIND FIRST buf_clients NO-LOCK WHERE ROWID(buf_clients) = v-rowid.
    RETURN substitute("&1&2"
                      ,buf_clients.obj-type
                      ,buf_Clients.obj-code).   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION get-esys-name Dialog-Frame
FUNCTION get-esys-name RETURNS CHARACTER
  ( INPUT p-esys-id AS INTEGER ) :
DEFINE BUFFER buf_ext-system FOR ub.ext-system.
FIND FIRST buf_ext-system NO-LOCK WHERE
          buf_Ext-system.db-num = 0
      AND buf_Ext-system.esys-id = p-esys-id NO-ERROR.
IF AVAILABLE buf_ext-system THEN DO:
   RETURN buf_ext-system.esys-name.
END.
RETURN "!!Неизвестная внешняя система".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
