&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Справочник средств измерений

Автор: Шальнев Иван Сергеевич
Дата создания: 28/12/11
Author: Shalnev Ivan
Creation date: 28/12/11

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER parparentproc AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER bttns AS character NO-UNDO.
DEFINE INPUT PARAMETER p-mode AS character NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-node-code AS INTEGER NO-UNDO.

/* Local Variable Definitions ---                                       */
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Справочник средств измерений".
{ cmp/vssrevis.i }
{ gbl/waitfram.i }
{ cmp/str-glbl.i }
{ cmp/showinf.i }
{ gbl/getcntxt.i DEF}
{ gbl/color.i }
{ ref/sr-izm.i sr-izmerenia ds}
{ ref/sr-izm.i dop-sr-izm }
{ ref/sr-izm.i " " proc }

DEFINE VARIABLE v-max-node-code AS INTEGER NO-UNDO.
DEFINE VARIABLE v-node-code AS INTEGER NO-UNDO.
define variable v-edit-mode as logical no-undo .
define buffer buf_clob-bind for ub.clob-bind.

&scoped-define view-dop-sr-izm ~
DISPLAY ~
dop-sr-izm.node-code             AT ROW 18 COL 5 LEFT-ALIGNED  SKIP ~
dop-sr-izm.sr-model              AT ROW 19 COL 5 LEFT-ALIGNED  SKIP ~
dop-sr-izm.sr-type               AT ROW 20 COL 5 LEFT-ALIGNED  SKIP ~
dop-sr-izm.sr-abs-err-neft-water AT ROW 21 COL 5 LEFT-ALIGNED  SKIP ~
dop-sr-izm.sr-abs-err-water      AT ROW 22 COL 5 LEFT-ALIGNED  SKIP ~
dop-sr-izm.sr-abs-err-dens       AT ROW 23 COL 5 LEFT-ALIGNED  SKIP ~
dop-sr-izm.sr-abs-err-temp-vol   AT ROW 24 COL 5 LEFT-ALIGNED  SKIP ~
dop-sr-izm.sr-abs-err-temp-dens  AT ROW 25 COL 5 LEFT-ALIGNED  SKIP ~
dop-sr-izm.sr-otnos              AT ROW 26 COL 5 LEFT-ALIGNED  SKIP ~
dop-sr-izm.sr-temp-line          AT ROW 27 COL 5 LEFT-ALIGNED  ~
with FRAME ~{&FRAME-NAME~}

&SCOPED-DEFINE hide-dop-sr-izm ~
hide ~
dop-sr-izm.node-code             ~
in FRAME {&FRAME-NAME} ~
dop-sr-izm.sr-model              ~
dop-sr-izm.sr-type               ~
dop-sr-izm.sr-abs-err-neft-water ~
dop-sr-izm.sr-abs-err-water      ~
dop-sr-izm.sr-abs-err-dens       ~
dop-sr-izm.sr-abs-err-temp-vol   ~
dop-sr-izm.sr-abs-err-temp-dens  ~
dop-sr-izm.sr-otnos              ~
dop-sr-izm.sr-temp-line          ~
in FRAME {&FRAME-NAME}

&SCOPED-DEFINE disable-dop-sr-izm ~
disable ~
dop-sr-izm.node-code             ~
dop-sr-izm.sr-model              ~
dop-sr-izm.sr-type               ~
dop-sr-izm.sr-abs-err-neft-water ~
dop-sr-izm.sr-abs-err-water      ~
dop-sr-izm.sr-abs-err-dens       ~
dop-sr-izm.sr-abs-err-temp-vol   ~
dop-sr-izm.sr-abs-err-temp-dens  ~
dop-sr-izm.sr-otnos              ~
dop-sr-izm.sr-temp-line          ~
with FRAME {&FRAME-NAME}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME BR-sr-izm

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES sr-izmerenia

/* Definitions for BROWSE BR-msf                                        */
&Scoped-define FIELDS-IN-QUERY-BR-sr-izm sr-izmerenia.node-code sr-izmerenia.sr-model sr-izmerenia.sr-type sr-izmerenia.sr-abs-err-neft-water sr-izmerenia.sr-abs-err-water sr-izmerenia.sr-abs-err-dens sr-izmerenia.sr-abs-err-temp-vol sr-izmerenia.sr-abs-err-temp-dens sr-izmerenia.sr-otnos sr-izmerenia.sr-temp-line
&Scoped-define ENABLED-FIELDS-IN-QUERY-BR-sr-izm
&Scoped-define SELF-NAME BR-sr-izm
&Scoped-define QUERY-STRING-BR-sr-izm FOR EACH sr-izmerenia NO-LOCK
&Scoped-define OPEN-QUERY-BR-sr-izm OPEN QUERY {&SELF-NAME} FOR EACH sr-izmerenia NO-LOCK .
&Scoped-define TABLES-IN-QUERY-BR-sr-izm sr-izmerenia
&Scoped-define FIRST-TABLE-IN-QUERY-BR-sr-izm sr-izmerenia



/* Definitions for DIALOG-BOX Dialog-Frame                              */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS B-exit b-quit b-add b-del b-sel B-Help BR-sr-izm

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */


/* Definitions of the field level widgets                               */
DEFINE BUTTON b-add
     LABEL "&Добавить"
     SIZE 10 BY 1.

DEFINE BUTTON b-cancel
     LABEL "Отмена"
     SIZE 10 BY 1.

DEFINE BUTTON b-del
     LABEL "&Удалить"
     SIZE 10 BY 1.

DEFINE BUTTON b-sel
     LABEL "&Выбор"
     SIZE 10 BY 1.

DEFINE BUTTON B-exit AUTO-GO
     LABEL "&Сохранить"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON B-Help
     LABEL "Помо&щь"
     SIZE 3 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-ok
     LABEL "&Ввод"
     SIZE 10 BY 1.

DEFINE BUTTON b-quit AUTO-GO
     LABEL "&Отмена"
     SIZE 10 BY 1
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BR-sr-izm FOR
      sr-izmerenia SCROLLING.
&ANALYZE-RESUME


/* Browse definitions                                                   */
DEFINE BROWSE BR-sr-izm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BR-sr-izm Dialog-Frame _FREEFORM
   QUERY BR-sr-izm NO-LOCK DISPLAY
      sr-izmerenia.node-code
      sr-izmerenia.sr-model
      sr-izmerenia.sr-type
      sr-izmerenia.sr-abs-err-neft-water
      sr-izmerenia.sr-abs-err-water
      sr-izmerenia.sr-abs-err-dens
      sr-izmerenia.sr-abs-err-temp-vol
      sr-izmerenia.sr-abs-err-temp-dens
      sr-izmerenia.sr-otnos
      sr-izmerenia.sr-temp-line
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 142 BY 13 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     B-exit AT ROW 1 COL 1 WIDGET-ID 2
     b-quit AT ROW 1 COL 11 WIDGET-ID 6
     b-sel at row 1 col 26  WIDGET-ID 10
     b-add AT ROW 1 COL 45 WIDGET-ID 14
     b-del AT ROW 1 COL 55 WIDGET-ID 22
     B-Help AT ROW 1 COL 140.5
     BR-sr-izm AT ROW 4.25 COL 1.5 WIDGET-ID 200
     b-ok AT ROW 18 COL 78 WIDGET-ID 30
     b-cancel AT ROW 18 COL 88 WIDGET-ID 26
     SPACE(45.87) SKIP(8.74)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE
         TITLE "Справочник средств измерений" WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
/* BROWSE-TAB BR-sr-izm B-Help Dialog-Frame */
ASSIGN
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON b-cancel IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
ASSIGN
       b-cancel:HIDDEN IN FRAME Dialog-Frame           = TRUE.

/* SETTINGS FOR BUTTON b-ok IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
ASSIGN
       b-ok:HIDDEN IN FRAME Dialog-Frame           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Справочник средств измерений */
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


&Scoped-define SELF-NAME b-cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-cancel Dialog-Frame
ON CHOOSE OF b-cancel IN FRAME Dialog-Frame /* Отмена */
DO:
  RUN proc-undo-record IN THIS-PROCEDURE NO-ERROR.
  IF ERROR-STATUS:ERROR THEN do:
    enable
    b-add when v-edit-mode
    b-del when v-edit-mode
    with frame {&frame-name} .
    RETURN NO-APPLY.
  end.
  enable
  b-add when v-edit-mode
  b-del when v-edit-mode
  with frame {&frame-name} .

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-del Dialog-Frame
ON CHOOSE OF b-del IN FRAME Dialog-Frame /* Удалить */
DO:
  IF NOT AVAILABLE sr-izmerenia  THEN RETURN NO-APPLY.
  RUN proc-b-del IN THIS-PROCEDURE NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-exit Dialog-Frame
ON CHOOSE OF B-exit IN FRAME Dialog-Frame /* Сохранить */
DO:
DEFINE VARIABLE glog AS LOGICAL NO-UNDO.
  MESSAGE
  "Вы уверены, что хотите сохранить классификатор в таком виде в БД?" SKIP
  "УДАЛЕНИЕ ДОБАВЛЕННЫХ ЗАПИСЕЙ (если Вы их добавляли) ПОСЛЕ ЭТОГО СТАНЕТ НЕВОЗМОЖНЫМ!"
  VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE glog.
  if not glog then return no-apply.
  RUN proc-save-all IN THIS-PROCEDURE NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME B-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-sel Dialog-Frame
ON CHOOSE OF B-sel IN FRAME Dialog-Frame /* Выбор */
DO:
  if available sr-izmerenia then do :
    p-node-code = sr-izmerenia.node-code .
  end.
  else p-node-code = ? .
  IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
  apply "choose" to b-quit .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&Scoped-define SELF-NAME b-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-ok Dialog-Frame
ON CHOOSE OF b-ok IN FRAME Dialog-Frame /* Ввод */
DO:
  RUN proc-save-record (input {&add-def}) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN do:
    enable
    b-add when v-edit-mode
    b-del when v-edit-mode
    B-exit when v-edit-mode
    with frame {&frame-name} .
    RETURN NO-APPLY.
  end.
  enable
  b-add when v-edit-mode
  b-del when v-edit-mode
  B-exit when v-edit-mode
  with frame {&frame-name} .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BR-sr-izm
&Scoped-define SELF-NAME BR-sr-izm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BR-sr-izm Dialog-Frame
ON VALUE-CHANGED OF BR-sr-izm IN FRAME Dialog-Frame
DO:
  if b-ok:visible in frame {&frame-name}
  or b-cancel:visible in frame {&frame-name}  then do:
    return no-apply.
  end.
  IF AVAILABLE sr-izmerenia THEN do:
    ASSIGN
    dop-sr-izm.node-code             = sr-izmerenia.node-code
    dop-sr-izm.sr-model              = sr-izmerenia.sr-model
    dop-sr-izm.sr-type               = sr-izmerenia.sr-type
    dop-sr-izm.sr-abs-err-neft-water = sr-izmerenia.sr-abs-err-neft-water
    dop-sr-izm.sr-abs-err-water      = sr-izmerenia.sr-abs-err-water
    dop-sr-izm.sr-abs-err-dens       = sr-izmerenia.sr-abs-err-dens
    dop-sr-izm.sr-abs-err-temp-vol   = sr-izmerenia.sr-abs-err-temp-vol
    dop-sr-izm.sr-abs-err-temp-dens  = sr-izmerenia.sr-abs-err-temp-dens
    dop-sr-izm.sr-otnos              = sr-izmerenia.sr-otnos
    dop-sr-izm.sr-temp-line          = sr-izmerenia.sr-temp-line
    .
    {&view-dop-sr-izm}.
  END.
  ELSE DO:
    {&view-dop-sr-izm}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame


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
{ gbl/getcntxt.i GET }
  IF LOOKUP(p-mode, {&UPDATE} + {&comma-char} + {&LOOKUP}) = 0  THEN DO:
    MESSAGE
    substitute("Неверное значение параметров p-mode = &1"
    , p-mode)
    VIEW-AS alert-box.
    UNDO, RETURN ERROR.
  END.
  IF p-mode = {&UPDATE}
  AND LOOKUP("b-sel", bttns) > 0   THEN DO:
    MESSAGE
    substitute("Неверное значение параметров bttns = &1 и/или p-mode = &2"
               , bttns
               , p-mode)
    VIEW-AS alert-box.
    UNDO, RETURN ERROR.
  END.
  if p-mode = {&update}
  and v-cntxt-db-num > 0 then do:
    MESSAGE
    substitute("Нельзя редактировать справочник в УБД")
    VIEW-AS alert-box.
    UNDO, RETURN ERROR.
  end.
  v-node-code = p-node-code.
  RUN fill-tables in THIS-PROCEDURE.
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
  ENABLE B-exit b-quit b-sel b-add b-del B-Help
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fill-tables Dialog-Frame
PROCEDURE fill-tables :
run sr-izmerenia_fill-sr-izm in this-procedure ( input p-mode
                                               , buffer buf_clob-bind).

CREATE dop-sr-izm.
RELEASE dop-sr-izm.
FIND LAST sr-izmerenia NO-ERROR.
IF AVAILABLE sr-izmerenia THEN DO:
   ASSIGN
   v-max-node-code = sr-izmerenia.node-code.
END.
ELSE DO:
    ASSIGN
    v-max-node-code = 0.

END.
release sr-izmerenia NO-ERROR.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MyEnable Dialog-Frame
PROCEDURE MyEnable :
assign
  FRAME Dialog-Frame:visible = true
.
if (lookup("b-add", bttns) > 0 AND v-cntxt-db-num = 0 AND NOT TRANSACTION AND p-mode = {&UPDATE}) then do:
  v-edit-mode = yes.
end.
FIND FIRST dop-sr-izm.
enable
br-sr-izm
b-add WHEN v-edit-mode
b-del WHEN v-edit-mode
b-help
b-exit WHEN v-edit-mode
b-quit
b-sel when not v-edit-mode
WITH FRAME {&FRAME-NAME}
.
IF p-mode <> {&UPDATE} THEN DO:
  HIDE
  b-exit
  IN FRAME {&FRAME-NAME}.
  b-quit:COLUMN  = 1.
  b-quit:label in frame {&frame-name} = "&Выход".

END.
{&OPEN-QUERY-{&BROWSE-NAME}}
APPLY "value-changed" TO BROWSE br-sr-izm.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-b-add Dialog-Frame
PROCEDURE proc-b-add :
DEFINE VARIABLE v-node-code AS INTEGER NO-UNDO.
DEFINE BUFFER buf_sr-izm FOR sr-izmerenia.
FIND LAST buf_sr-izm NO-ERROR.
IF AVAILABLE buf_sr-izm  THEN DO:
    ASSIGN
   v-node-code = buf_sr-izm.node-code + 1.
END.
ELSE DO:
   v-node-code = 1.
END.
DISPLAY
b-ok
b-cancel
WITH FRAME {&FRAME-NAME}.
ENABLE
b-ok
b-cancel
WITH FRAME {&FRAME-NAME}.
disable
b-add
b-exit
b-del
with frame {&frame-name} .
do transaction:
  delete dop-sr-izm.
  CREATE dop-sr-izm.
  ASSIGN
  dop-sr-izm.node-code = v-node-code
  .
end.
DISPLAY
dop-sr-izm.node-code             SKIP
dop-sr-izm.sr-model              SKIP
dop-sr-izm.sr-type               SKIP
dop-sr-izm.sr-abs-err-neft-water SKIP
dop-sr-izm.sr-abs-err-water      SKIP
dop-sr-izm.sr-abs-err-dens       SKIP
dop-sr-izm.sr-abs-err-temp-vol   SKIP
dop-sr-izm.sr-abs-err-temp-dens  SKIP
dop-sr-izm.sr-otnos              SKIP
dop-sr-izm.sr-temp-line          SKIP
WITH FRAME {&FRAME-NAME}
.
enable
dop-sr-izm.sr-model
dop-sr-izm.sr-type
dop-sr-izm.sr-abs-err-neft-water
dop-sr-izm.sr-abs-err-water
dop-sr-izm.sr-abs-err-dens
dop-sr-izm.sr-abs-err-temp-vol
dop-sr-izm.sr-abs-err-temp-dens
dop-sr-izm.sr-otnos
dop-sr-izm.sr-temp-line
WITH FRAME {&FRAME-NAME}
.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-b-del Dialog-Frame
PROCEDURE proc-b-del :
DEFINE BUFFER buf_sr-izm FOR sr-izmerenia.
IF sr-izmerenia.node-code <= v-max-node-code  THEN DO:
  MESSAGE
  "К сожалению, удалить эту запись уже невозможно!!!" SKIP
  "Она сохранена в БД"
   VIEW-AS ALERT-BOX.
   undo, return error .
END.
FIND FIRST buf_sr-izm WHERE RECID(buf_sr-izm) = RECID(sr-izmerenia) NO-ERROR.
DELETE buf_sr-izm .
{&OPEN-QUERY-{&BROWSE-NAME}}
APPLY "value-changed" TO BROWSE br-sr-izm.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-save-all Dialog-Frame
PROCEDURE proc-save-all :
DEFINE VARIABLE glog AS LOGICAL NO-UNDO.
define variable v-part-num as integer no-undo .
define variable v-mode as character no-undo .
define variable v-clob-mode as character no-undo .
define variable v-clob-db-num as integer no-undo .
define variable v-int64-id as int64 no-undo .
define variable v-path                    as character                no-undo .
DEFINE VARIABLE v-full-path               as character                no-undo .
DEFINE VARIABLE v-file-name               as character                no-undo .
DEFINE VARIABLE v-file-name-no-ext        as character                no-undo .
DEFINE VARIABLE v-file-name-ext           as character                no-undo .

DEFINE BUFFER buf_sr-izm FOR sr-izmerenia.
FOR EACH buf_sr-izm WHERE buf_sr-izm.node-code < 0:
    DELETE buf_sr-izm.
END.
find last buf_sr-izm no-error.
if (available buf_sr-izm
and buf_sr-izm.node-code = v-max-node-code )
or (not available buf_sr-izm
and v-max-node-code  = 0)
then do:
  message
  "Справочник не изменился" skip
  "сохранение не требуется"
  view-as alert-box warning
  .
  return.
end.
run gbl/_tmpfile.p ( input ""
                    ,input "xml"
                    ,output v-file-name) .
output to value(v-file-name).
put 1 skip.
output close.
run gbl/filename.p (
               input v-file-name
              ,output v-full-path
              ,output v-path
              ,output v-file-name
              ,output v-file-name-no-ext
              ,output v-file-name-ext
              ) no-error .
if error-status:error then do:
  undo, return error .
end.
glog = DATASET sr-izmerenia-ds:HANDLE:write-XML("FILE"
                                           , v-full-path
                                            , YES /*lformatted*/
                                            , "windows-1251"
                                            , ?
                                            , YES /*write-xml-schema*/
                                             ,NO /*min-schema*/ ) NO-ERROR.

if error-status:error or not glog then do:
  os-delete value(v-full-path) no-error.
  MESSAGE
  ERROR-STATUS:GET-MESSAGE(1) SKIP
  RETURN-VALUE
  VIEW-AS ALERT-BOX ERROR.
  UNDO, RETURN ERROR.
end.
assign
v-part-num = 1.
if not available buf_clob-bind then do:
  v-mode = {&add-def}.
  v-clob-mode = "".
  v-clob-db-num = ?.
  v-int64-id = 0.
end.
else do:
  v-mode = {&update}.
  v-clob-mode = "add-new".
  v-clob-db-num = buf_clob-bind.db-num.
  v-int64-id = buf_clob-bind.int64-id.
end.
run gbl/file2clb.p ( input v-mode
                    ,input v-clob-mode
                    ,input ? /*p-bh*/
                    ,input "sr-izmerenia.xml" /*p-uniq-key-rec*/
                    ,input '' /*p-field-*/
                    ,input frame {&frame-name}:title /*p-descr*/
                    ,input-output v-part-num
                    ,input {&lob-res-ref}
                    ,input-output v-clob-db-num
                    ,input-output v-int64-id
                    ,input v-full-path
                    ,input ? /*p-src-encoding*/
                    ) no-error .
IF ERROR-STATUS:ERROR THEN DO:
  MESSAGE
  ERROR-STATUS:GET-MESSAGE(1) SKIP
  RETURN-VALUE
  VIEW-AS ALERT-BOX ERROR.
  os-delete value(v-full-path) no-error.
  UNDO, RETURN ERROR.  
END.
os-delete value(v-full-path) no-error.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-save-record Dialog-Frame
PROCEDURE proc-save-record :
define input parameter p-action as character no-undo.
define variable v-rec as recid no-undo .
DEFINE BUFFER buf_sr-izm FOR sr-izmerenia.
ASSIGN
FRAME {&FRAME-NAME}
dop-sr-izm.node-code
dop-sr-izm.sr-model
dop-sr-izm.sr-type
dop-sr-izm.sr-abs-err-neft-water
dop-sr-izm.sr-abs-err-water
dop-sr-izm.sr-abs-err-dens
dop-sr-izm.sr-abs-err-temp-vol
dop-sr-izm.sr-abs-err-temp-dens
dop-sr-izm.sr-otnos
dop-sr-izm.sr-temp-line
.
if dop-sr-izm.sr-abs-err-neft-water > 3 or dop-sr-izm.sr-abs-err-neft-water < - 3 then do :
  message
    "Абсолютная погрешность измерений"         skip
    "уровня нефтепродукта и подтоварной воды " skip
    "выходит за границы допустимого диапазона (+/-)3 мм" skip
  view-as alert-box error.
  apply "entry" to dop-sr-izm.sr-abs-err-neft-water in frame {&frame-name} .
  return no-apply.
end.
if dop-sr-izm.sr-abs-err-water > 3 or dop-sr-izm.sr-abs-err-water < - 3 then do :
  message
    "Абсолютная погрешность измерений уровня подтоварной воды" skip
    "выходит за границы допустимого диапазона (+/-)3 мм"         skip
  view-as alert-box error.
  apply "entry" to dop-sr-izm.sr-abs-err-water in frame {&frame-name} .
  return no-apply.
end.
if dop-sr-izm.sr-abs-err-dens > 0.5 or dop-sr-izm.sr-abs-err-dens < - 0.5 then do :
  message
    "Абсолютная погрешность измерений плотности нефтепродукта"    skip
    "ареометром выходит за границы допустимого диапазона (+/-)0.5 кг/м3" skip
  view-as alert-box error.
  apply "entry" to dop-sr-izm.sr-abs-err-dens in frame {&frame-name} .
  return no-apply.
end.
if dop-sr-izm.sr-abs-err-temp-vol > 0.5 or dop-sr-izm.sr-abs-err-temp-vol < - 0.5 then do :
  message
    "Абсолютная погрешность измерений температуры нефтепродукта при измерении"    skip
    "его объема выходит за границы допустимого диапазона (+/-)0.5 °С" skip
  view-as alert-box error.
  apply "entry" to dop-sr-izm.sr-abs-err-temp-vol in frame {&frame-name} .
  return no-apply.
end.
if dop-sr-izm.sr-abs-err-temp-dens > 0.5 or dop-sr-izm.sr-abs-err-temp-dens < - 0.5 then do :
  message
    "Абсолютная погрешность измерений температуры нефтепродукта при измерении"    skip
    "его плотности выходит за границы допустимого диапазона (+/-)0.5 °С" skip
  view-as alert-box error.
  apply "entry" to dop-sr-izm.sr-abs-err-temp-dens in frame {&frame-name} .
  return no-apply.
end.
if dop-sr-izm.sr-otnos > 0.05 or dop-sr-izm.sr-otnos < - 0.05 then do :
  message
    "Предел допускаемой относительной погрешности средства обработки"    skip
    "результатов измерений выходит за границы допустимого диапазона (+/-)0.05 %" skip
  view-as alert-box error.
  apply "entry" to dop-sr-izm.sr-otnos in frame {&frame-name} .
  return no-apply.
end.
FIND FIRST buf_sr-izm  WHERE
    buf_sr-izm.node-code = dop-sr-izm.node-code NO-ERROR.
IF AVAILABLE buf_sr-izm THEN DO:
  if p-action  = {&add-def} then do :
    ASSIGN
    dop-sr-izm.node-code = 0
    .
    MESSAGE
    substitute("Уже есть запись с таким вн. кодом &1", dop-sr-izm.node-code)
    VIEW-AS ALERT-BOX ERROR.
    RUN proc-undo-record IN this-procedure.
    RETURN.
  end.
END.
FIND FIRST buf_sr-izm  WHERE
        buf_sr-izm.node-code              =  dop-sr-izm.node-code
    AND buf_sr-izm.sr-model               =  dop-sr-izm.sr-model
    AND buf_sr-izm.sr-type                =  dop-sr-izm.sr-type
    AND buf_sr-izm.sr-abs-err-neft-water  =  dop-sr-izm.sr-abs-err-neft-water
    AND buf_sr-izm.sr-abs-err-water       =  dop-sr-izm.sr-abs-err-water
    AND buf_sr-izm.sr-abs-err-dens        =  dop-sr-izm.sr-abs-err-dens
    AND buf_sr-izm.sr-abs-err-temp-vol    =  dop-sr-izm.sr-abs-err-temp-vol
    AND buf_sr-izm.sr-abs-err-temp-dens   =  dop-sr-izm.sr-abs-err-temp-dens
    AND buf_sr-izm.sr-otnos               =  dop-sr-izm.sr-otnos
    AND buf_sr-izm.sr-temp-line           =  dop-sr-izm.sr-temp-line
    NO-ERROR.
IF AVAILABLE buf_sr-izm THEN DO:
  MESSAGE
  substitute("Уже есть запись с такими характеристиками")
  VIEW-AS ALERT-BOX ERROR.
  return.
END.
DO TRANSACTION
ON error UNDO, RETURN ERROR :
    CREATE buf_sr-izm.
    BUFFER-COPY dop-sr-izm TO buf_sr-izm  .
    DELETE dop-sr-izm.
    CREATE dop-sr-izm.
    FIND FIRST dop-sr-izm.
    v-rec = RECID(buf_sr-izm).
    RELEASE buf_sr-izm.
END.
{&disable-dop-sr-izm}.
HIDE b-ok b-cancel IN FRAME {&FRAME-NAME}.
{&OPEN-QUERY-{&BROWSE-NAME}}
REPOSITION br-sr-izm TO RECID v-rec.
APPLY "value-changed" TO br-sr-izm.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-undo-record Dialog-Frame
PROCEDURE proc-undo-record :
delete dop-sr-izm.
create dop-sr-izm.
RELEASE dop-sr-izm.
FIND FIRST dop-sr-izm.
{&disable-dop-sr-izm}.
HIDE b-ok b-cancel IN FRAME {&FRAME-NAME}.
APPLY "VALUE-CHANGED" TO br-sr-izm IN FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
