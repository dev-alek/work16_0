&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases
          ub               PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER locked_thbj-attr FOR ub.thbj-attr.
DEFINE TEMP-TABLE tt-cash-pay-autotank NO-UNDO LIKE ub.cash-pay
       field autotank-cdpay-code like ub.cash-pay.cdpay-code
       field autotank-obj-name as character
       index pi is unique primary autotank-cdpay-code.
DEFINE BUFFER X_shop FOR ub.shop.
DEFINE BUFFER X_sysconf FOR ub.sysconf.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Редактирование атрибута магазина (thbj-attr) "cd-type-Autotank"

Автор: Бахтадзе Наталья Викторовна
Дата создания: 10/12/10
Author: Bakhtadze Natalya
Creation date: 10/12/10

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER parparentproc AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-mode AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-obj-type LIKE ub.clients.obj-type NO-UNDO.
DEFINE INPUT PARAMETER p-obj-code LIKE ub.shop.obj-code NO-UNDO.

/* Local Variable Definitions ---                                       */
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Редактирование атрибута магазина (thbj-attr) 'cd-type-Autotank'".
{ cmp/vssrevis.i }
{ gbl/waitfram.i }
{ cmp/str-glbl.i }
{ cmp/library.i }
{ gbl/thbjattr.i }
{ cmp/showinf.i  }
{ ref/cgrplbfn.i }
{ gbl/windtfrm.i }
{ gbl/getcntxt.i def }
DEFINE VARIABLE v-db-num LIKE ub.db.db-num NO-UNDO.
DEFINE VARIABLE v-tab-order AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-to-create AS logical NO-UNDO.
DEFINE VARIABLE v-host-code LIKE ub.shop.host-code NO-UNDO.
DEFINE VARIABLE v-base-code LIKE ub.sysconf.base-code NO-UNDO.
DEFINE VARIABLE v-r-b-code LIKE ub.currency.curr-code NO-UNDO.
DEFINE BUFFER buf_currency FOR ub.currency.
DEFINE BUFFER buf_cash-pay-nal FOR ub.cash-pay.
DEFINE BUFFER buf_cash-pay-ntnl FOR ub.cash-pay.
define BUFFER buf_cli-grp FOR ub.cli-grp.
define temp-table temp-thbj-attr no-undo like ub.thbj-attr.
define variable v-tth as handle no-undo .
assign
v-tth = buffer thbjattr_thbj-attr:table-handle .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME BR-cash-pay

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-cash-pay-autotank

/* Definitions for BROWSE BR-cash-pay                                   */
&Scoped-define FIELDS-IN-QUERY-BR-cash-pay autotank-cdpay-code ~
tt-cash-pay-autotank.cdpay-code tt-cash-pay-autotank.curr-code ~
autotank-obj-name tt-cash-pay-autotank.obj-name
&Scoped-define ENABLED-FIELDS-IN-QUERY-BR-cash-pay
&Scoped-define QUERY-STRING-BR-cash-pay FOR EACH tt-cash-pay-autotank NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BR-cash-pay OPEN QUERY BR-cash-pay FOR EACH tt-cash-pay-autotank NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BR-cash-pay tt-cash-pay-autotank
&Scoped-define FIRST-TABLE-IN-QUERY-BR-cash-pay tt-cash-pay-autotank


/* Definitions for DIALOG-BOX Dialog-Frame                              */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS B-exit b-quit B-Help b-chg BR-cash-pay B-ok ~
B-no-ok

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-chg
     LABEL "&Изменить"
     SIZE 10 BY 1.

DEFINE BUTTON B-exit AUTO-GO
     LABEL "&Ввод"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON B-Help
     LABEL "Помо&щь"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON B-no-ok
     LABEL "Отмена"
     SIZE 10 BY 1.

DEFINE BUTTON B-ok
     LABEL "Ввод"
     SIZE 10 BY 1.

DEFINE BUTTON b-quit AUTO-END-KEY
     LABEL "&Отмена"
     SIZE 10 BY 1
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BR-cash-pay FOR
      tt-cash-pay-autotank SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BR-cash-pay
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BR-cash-pay Dialog-Frame _STRUCTURED
  QUERY BR-cash-pay NO-LOCK DISPLAY
      autotank-cdpay-code COLUMN-LABEL "Код платежа!autotank" FORMAT ">>>>9":U
      tt-cash-pay-autotank.cdpay-code COLUMN-LABEL "Код платежа!IBS TH" FORMAT ">>>9":U
      tt-cash-pay-autotank.curr-code COLUMN-LABEL "Код валюты!IBS TH" FORMAT ">>9":U
      autotank-obj-name COLUMN-LABEL "Название типа!кассового платежа!AUTOTANK" FORMAT "X(27)":U
      tt-cash-pay-autotank.obj-name COLUMN-LABEL "Название типа!кассового платежа!IBS TH" FORMAT "X(30)":U
            WIDTH 34.7
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 98 BY 7.6
         TITLE "Соответствие кодов типов кассовых платежей" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     B-exit AT ROW 1 COL 1
     b-quit AT ROW 1 COL 11
     B-Help AT ROW 1 COL 71
     b-chg AT ROW 2 COL 71 WIDGET-ID 2
     BR-cash-pay AT ROW 3 COL 1
     B-ok AT ROW 10.6 COL 79
     B-no-ok AT ROW 10.6 COL 89
     SPACE(0.24) SKIP(5.89)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE
         TITLE "Параметры POS Касса autotank"
         DEFAULT-BUTTON B-exit CANCEL-BUTTON b-quit.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
   Temp-Tables and Buffers:
      TABLE: locked_thbj-attr B "?" ? ub thbj-attr
      TABLE: tt-cash-pay-autotank T "?" NO-UNDO ub cash-pay
      ADDITIONAL-FIELDS:
          field autotank-cdpay-code like ub.cash-pay.cdpay-code
          field autotank-obj-name as character
          index pi is unique primary autotank-cdpay-code
      END-FIELDS.
      TABLE: X_shop B "?" ? ub shop
      TABLE: X_sysconf B "?" ? ub sysconf
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
/* BROWSE-TAB BR-cash-pay b-chg Dialog-Frame */
ASSIGN
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

ASSIGN
       B-no-ok:HIDDEN IN FRAME Dialog-Frame           = TRUE.

ASSIGN
       B-ok:HIDDEN IN FRAME Dialog-Frame           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BR-cash-pay
/* Query rebuild information for BROWSE BR-cash-pay
     _TblList          = "Temp-Tables.tt-cash-pay-autotank"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"autotank-cdpay-code" "Код платежа!autotank" ">>>>9" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-cash-pay-autotank.cdpay-code
"tt-cash-pay-autotank.cdpay-code" "Код платежа!IBS TH" ">>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-cash-pay-autotank.curr-code
"tt-cash-pay-autotank.curr-code" "Код валюты!IBS TH" ? "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"autotank-obj-name" "Название типа!кассового платежа!AUTOTANK" "X(27)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt-cash-pay-autotank.obj-name
"tt-cash-pay-autotank.obj-name" "Название типа!кассового платежа!IBS TH" "X(30)" "character" ? ? ? ? ? ? no ? no no "34.7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BR-cash-pay */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Параметры POS Касса autotank */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-chg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-chg Dialog-Frame
ON CHOOSE OF b-chg IN FRAME Dialog-Frame /* Изменить */
DO:
  IF NOT AVAILABLE tt-cash-PAY-autotank THEN DO:
    RETURN NO-APPLY.
  END.
  RUN proc-b-chg IN THIS-PROCEDURE NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-exit Dialog-Frame
ON CHOOSE OF B-exit IN FRAME Dialog-Frame /* Ввод */
DO:
  RUN proc-save IN THIS-PROCEDURE  NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-no-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-no-ok Dialog-Frame
ON CHOOSE OF B-no-ok IN FRAME Dialog-Frame /* Отмена */
DO:
    { gbl/stdbtn.i }
  RUN proc-b-no-ok IN THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BR-cash-pay
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
{ gbl/getcntxt.i get }
{ ref/tabhndmv.i v-tab-order underline-tb }
{ gbl/rethndmv.i v-tab-order underline-tb "APPLY 'CHOOSE' TO b-exit in frame {&frame-name}." }
  IF p-mode <> {&lookup}
  and p-mode <> {&update} THEN DO:
      MESSAGE
      vss-workfile vss-revision vss-description skip
      "Неверное значение параметра p-mode" p-mode
      VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN ERROR.
  END.
  IF p-obj-type <> {&shop}
  and p-obj-type <> {&cmp}
  and p-obj-type <> '':U
  THEN DO:
      MESSAGE
      vss-workfile vss-revision vss-description skip
      "Неверное значение параметра p-obj-type" p-obj-type
      VIEW-AS ALERT-BOX ERROR.
      UNDO, RETURN ERROR.
  END.
  if p-obj-type = {&shop} then do:
    FIND FIRST X_shop NO-LOCK WHERE X_shop.obj-code = p-obj-code NO-ERROR.
    IF NOT AVAILABLE X_shop THEN DO:
        MESSAGE
        vss-workfile vss-revision vss-description skip
        "Неверное значение параметра p-obj-code" p-obj-code
        VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN ERROR.
    END.
    { gbl/objdbnum.i ~{&shop~} p-obj-code v-db-num }
    IF v-db-num <> v-cntxt-db-num
    AND v-cntxt-db-num <> 0
    and p-mode <> {&lookup}
    THEN DO:
        MESSAGE
        "Нельзя менять параметры магазина в чужой БД" skip
        "магазин принадлежит БД" v-db-num "текущая БД" v-cntxt-db-num
        VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN ERROR.
    END.
    { gbl/hostcode.i p-obj-type p-obj-code v-host-code }
  end.
  if p-obj-type = {&cmp} then do:
    FIND FIRST X_sysconf NO-LOCK WHERE X_sysconf.host-code = p-obj-code NO-ERROR.
    IF NOT AVAILABLE X_sysconf THEN DO:
        MESSAGE
        vss-workfile vss-revision vss-description skip
        "Неверное значение параметра p-obj-code" p-obj-code
        VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN ERROR.
    END.
    if v-cntxt-db-num <> 0
    and p-mode <> {&lookup}
    then do:
        MESSAGE
        "Нельзя менять параметры ФИРМЫ в УБД" skip
        VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN ERROR.
    end.
    v-host-code = p-obj-code.
  end.
  if p-obj-type = '':U then do:
    if v-cntxt-db-num <> 0
    and p-mode <> {&lookup}
    then do:
        MESSAGE
        "Нельзя менять ГЛОБАЛЬНЫЕ параметры в УБД" skip
        VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN ERROR.
    end.
  end.
  IF p-mode = {&UPDATE} THEN DO:
    FIND FIRST LOCKED_thbj-attr EXCLUSIVE-LOCK WHERE
              LOCKED_thbj-attr.obj-type = p-obj-type
        AND   LOCKED_thbj-attr.obj-code = p-obj-code
        AND   LOCKED_thbj-attr.upper-prop-code = {&attr-cd-type-Autotank}
        AND   locked_thbj-attr.prop-code = '':U NO-WAIT NO-ERROR.
     if locked locked_thbj-attr then do:
        message
        vss-workfile vss-revision vss-description skip
         "Запись ПАРАМЕТРЫ(АТРИБУТЫ) МАГАЗИНА занята"
        view-as alert-box error .
        undo, return error.
      end.
  END.
  ELSE DO:
      FIND FIRST LOCKED_thbj-attr no-LOCK WHERE
          LOCKED_thbj-attr.obj-type = p-obj-type
    AND   LOCKED_thbj-attr.obj-code = p-obj-code
    AND   LOCKED_thbj-attr.upper-prop-code = {&attr-cd-type-Autotank}
    AND   locked_thbj-attr.prop-code = '':U NO-ERROR.
  END.
  if not available locked_thbj-attr then do:
    ASSIGN
    v-to-create  = YES.
    message
    substitute ("Внимание!!!&1Параметра НЕТ в БД!&1Будут показаны ЗНАЧЕНИЯ ПО УМОЛЧАНИЮ",
                {&new-line})
    view-as alert-box WARNING.

  end.
  { gbl/r-b-curr.i v-host-code v-r-b-code }
  FIND FIRST buf_currency NO-LOCK WHERE
        buf_currency.curr-code = v-r-b-code .

  RUN FILL-WIDGETS IN THIS-PROCEDURE NO-ERROR.
  IF ERROR-STATUS:ERROR THEN UNDO, RETURN ERROR.

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
  ENABLE B-exit b-quit B-Help b-chg BR-cash-pay B-ok B-no-ok
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fill-widgets Dialog-Frame
PROCEDURE fill-widgets :
define variable v-value-character as character no-undo .
define variable v-value-date as date no-undo .
define variable v-value-decimal as decimal no-undo .
define variable v-value-integer as INTEGER no-undo .
define variable v-value-logical AS LOGICAL no-undo .
DEFINE VARIABLE ii AS INTEGER NO-UNDO.
DEFINE VARIABLE v-entry AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-cash-pay-list AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-cdpay-code LIKE ub.cash-pay.cdpay-code NO-UNDO.
DEFINE VARIABLE v-curr-code LIKE ub.cash-pay.curr-code NO-UNDO.
DEFINE VARIABLE v-cdpay-code-autotank LIKE ub.cash-pay.cdpay-code NO-UNDO.
define variable v-autotank-obj-name as character no-undo .

DEFINE BUFFER buf_cash-pay FOR ub.cash-pay.
define variable v-param-type as character no-undo .
define variable v-param-value as character no-undo .
FOR EACH thbjattr_thbj-attr:
  delete thbjattr_thbj-attr.
end.
FOR EACH temp-thbj-attr:
  delete temp-thbj-attr.
end.
run adm/shattri.p (
              input "init":U
            , input p-obj-type
            , input p-obj-code
            , input {&attr-cd-type-Autotank}
            , input "":U
            , output v-value-character
            , output v-value-date
            , output v-value-decimal
            , output v-value-integer
            , output v-value-logical
            , output v-param-type
            , INPUT-OUTPUT TABLE-handle v-tth
            ) no-error .
if error-status:error
and not available locked_thbj-attr then do:
  message
  "Не удалось получить начальные значения настроек" skip
  error-status:get-message(1) return-value
  view-as alert-box error .
  undo, return error .
end.
FOR EACH thbjattr_thbj-attr:
  ASSIGN
  v-entry = thbjattr_thbj-attr.prop-code.
  IF v-entry = {&attr-cd-type-Autotank_cash-pay-list} THEN DO:
    ASSIGN
    v-cash-pay-list = thbjattr_thbj-attr.property-value-character.
  END.
  create temp-thbj-attr.
  buffer-copy thbjattr_thbj-attr to temp-thbj-attr.

END.
if v-cash-pay-list <> "":U then do:
_ii:
DO ii = 1 TO  NUM-ENTRIES(v-cash-pay-list, ";"):
  ASSIGN
  v-entry = entry(ii, v-cash-pay-list, ";":U)
  v-cdpay-code-autotank = integer(entry(1, entry(1, v-entry, {&slash-char}), {&comma-char}))
  v-autotank-obj-name = entry(2, entry(1, v-entry, {&slash-char}), {&comma-char})
  v-cdpay-code = integer(entry(1, entry(2, v-entry, {&slash-char}), {&comma-char}))
  v-curr-code = integer(entry(2, entry(2, v-entry, {&slash-char}), {&comma-char}))
  .
  FIND FIRST buf_cash-pay NO-LOCK WHERE
                buf_cash-pay.cdpay-code = v-cdpay-code
        AND buf_cash-pay.curr-code = v-curr-code  NO-ERROR.
  CREATE tt-cash-pay-autotank.
  if available buf_cash-pay then do:
    BUFFER-COPY buf_cash-pay TO tt-cash-pay-autotank.
  end.
  else do:
    ASSIGN
    tt-cash-pay-autotank.cdpay-code = 0
    .
  end.
  ASSIGN
  tt-cash-pay-autotank.autotank-cdpay-code = v-cdpay-code-autotank
  tt-cash-pay-autotank.autotank-obj-name = v-autotank-obj-name
  .
END.
end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MyEnable Dialog-Frame
PROCEDURE MyEnable :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEFINE BUFFER buf_currency FOR ub.currency.

ASSIGN
FRAME {&FRAME-NAME}:TITLE = FRAME {&FRAME-NAME}:TITLE + (if p-obj-type = {&cmp} then " фирма" else " маг") + STRING(p-obj-code)
tt-cash-pay-autotank.obj-name:resizable in browse br-cash-pay = yes
tt-cash-pay-autotank.autotank-obj-name:resizable in browse br-cash-pay = yes
v-tab-order = "b-add-cash-pay,b-del-cash-pay".
ENABLE
B-exit WHEN p-mode = {&UPDATE}
b-quit
B-Help
br-cash-pay
b-chg WHEN p-mode = {&UPDATE}
WITH FRAME {&frame-name}.
VIEW FRAME {&frame-name}.
IF p-mode = {&LOOKUP} THEN DO:
    HIDE
    b-exit

    IN FRAME {&FRAME-NAME}.
    ASSIGN
    b-quit:LABEL = "&Выход"
    .
END.
RUN openbrcash-pay IN THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenBrcash-pay Dialog-Frame
PROCEDURE OpenBrcash-pay :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
OPEN QUERY br-cash-pay FOR EACH tt-cash-pay-autotank SHARE-LOCK.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-b-chg Dialog-Frame
PROCEDURE proc-b-chg :
DEFINE VARIABLE v-value AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-log AS logical NO-UNDO.
DEFINE variable v-rid AS RECID NO-UNDO.
DEFINE VARIABLE v-rid-list AS CHARACTER NO-UNDO.
define variable v-cdpay-code as integer no-undo .
DEFINE BUFFER buf_tt-cash-pay-autotank FOR tt-cash-pay-autotank.
DEFINE BUFFER buf_cash-pay FOR ub.cash-pay.
if not available tt-cash-pay-autotank then return error.
FIND FIRST buf_tt-cash-PAY-autotank NO-LOCK WHERE
        buf_tt-cash-pay-autotank.autotank-cdpay-code = tt-cash-pay-autotank.autotank-cdpay-code  NO-ERROR.
IF buf_tt-cash-pay-autotank.cdpay-code <> 0 THEN DO:
  MESSAGE
  SUBSTITUTE("Уже задано правило соответствия для типа кассового платежа,&1" +
              "у которого код платежа на AUTOTANK &2"
              , {&new-line}
              , tt-cash-pay-autotank.autotank-cdpay-code
              ) skip
  "Изменить?"
  VIEW-AS ALERT-BOX question buttons yes-no update v-log.
  if not v-log then return .
END.
run ref/cashpays.w (
           input parparentproc
          ,input  "b-sel":U
          ,input  {&all}
          ,input (if p-obj-type = {&cmp} then p-obj-code else v-host-code)
          ,input (if p-obj-type = {&cmp} then '':U else p-obj-type)
          ,input (if p-obj-type = {&cmp} then 0 else p-obj-code)
          ,OUTPUT v-rid-list) NO-ERROR.
IF ERROR-STATUS:ERROR THEN RETURN error.
if v-rid-list = "":U then do:
  message
  "Вы не выбрали соответствующий тип кассового платежа в IBS TH" skip(0)
  "Значит ли это, что Вы хотите удалить соответствие?"
  view-as alert-box question buttons yes-no update v-log.
  if v-log = no then return.
  else do:
    ASSIGN
    buf_tt-cash-pay-autotank.cdpay-code = 0
    buf_tt-cash-pay-autotank.curr-code = 0
    buf_tt-cash-pay-autotank.obj-name = ''
    v-rid = RECID(buf_tt-cash-pay-autotank)
    .
  end.
end.
else do:
  FIND FIRST buf_cash-pay NO-LOCK WHERE
          RECID(buf_cash-pay) = INTEGER(ENTRY(1, v-rid-list)) NO-ERROR.
  IF NOT AVAILABLE buf_cash-pay  THEN RETURN error.
  if buf_cash-pay.curr-code <> 0 then do:
    message
    "Нельзя выбрать типа кассового платежа с валютой отличной от национальной!"
    view-as alert-box error .
    undo, return error.
  end.
  ASSIGN
  buf_tt-cash-pay-autotank.cdpay-code = buf_cash-pay.cdpay-code
  buf_tt-cash-pay-autotank.curr-code = buf_cash-pay.curr-code
  buf_tt-cash-pay-autotank.obj-name = buf_cash-pay.obj-name
  v-rid = RECID(buf_tt-cash-pay-autotank)
  .
end.
RUN openbrcash-pay IN THIS-PROCEDURE.
REPOSITION br-cash-pay TO RECID v-rid.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-save Dialog-Frame
PROCEDURE proc-save :
define variable v-same as logical no-undo .
define variable v-value-character as character no-undo .
define variable v-value-date as date no-undo .
define variable v-value-decimal as decimal no-undo .
define variable v-value-integer as INTEGER no-undo .
define variable v-value-logical AS LOGICAL no-undo .
define variable v-param-type as character no-undo .
DEFINE VARIABLE v-cash-pay-list AS CHARACTER NO-UNDO.
DEFINE BUFFER buf_tt-cash-pay-autotank FOR tt-cash-pay-autotank.
IF p-mode = {&LOOKUP} THEN RETURN ERROR.

FOR EACH tt-cash-pay-autotank BY tt-cash-pay-autotank.autotank-cdpay-code:
  ASSIGN
  v-cash-pay-list = v-cash-pay-list + (IF v-cash-pay-list = "":U THEN "":U ELSE ";") +
                    STRING(tt-cash-pay-autotank.autotank-cdpay-code) + {&comma-char} +
                    STRING(tt-cash-pay-autotank.autotank-obj-name) +
                    {&slash-char} +
                    STRING(tt-cash-pay-autotank.cdpay-code) + {&comma-char} +
                    STRING(tt-cash-pay-autotank.curr-code)
  .
END.
find first thbjattr_thbj-attr where thbjattr_thbj-attr.prop-code = {&attr-cd-type-Autotank_cash-pay-list}.
assign
thbjattr_thbj-attr.property-value-character = v-cash-pay-list.

v-same = yes.
for each thbjattr_thbj-attr,
    first temp-thbj-attr where
          temp-thbj-attr.obj-type = thbjattr_thbj-attr.obj-type
      and temp-thbj-attr.obj-code = thbjattr_thbj-attr.obj-code
      and temp-thbj-attr.upper-prop-code = thbjattr_thbj-attr.upper-prop-code
      and temp-thbj-attr.prop-code = thbjattr_thbj-attr.prop-code:
   buffer-compare
   thbjattr_thbj-attr
   to temp-thbj-attr
   save result in v-same.
   if not v-same then leave.
end.
v-same = no.
IF v-same  and not v-to-create THEN RETURN.
/*проверим корректность*/
run adm/shattri.p (
              input "check":U
            , input p-obj-type
            , input p-obj-code
            , input {&attr-cd-type-Autotank}
            , INPUT '':U
             , output v-value-character
             , output v-value-date
             , output v-value-decimal
             , output v-value-integer
             , output v-value-logical
             , output v-param-type
             , input-output TABLE-handle v-tth
             ) no-error .

if error-status:error then do:
  message
  "Некорректное значение ПАРАМЕТРОВ" skip
  error-status:get-message(1) skip
  return-value
  view-as alert-box error .
  undo, return error .
end.
do TRANSACTION
on error undo, return error return-value
:
  RUN thbjattr_set-section IN THIS-PROCEDURE (
       input p-obj-type
      ,input p-obj-code
      ,input {&attr-cd-type-Autotank}
      ,INPUT table thbjattr_thbj-attr
  ) NO-ERROR.
  IF ERROR-STATUS:error THEN do:
    MESSAGE ERROR-STATUS:get-message(1)  SKIP
    RETURN-VALUE
    VIEW-AS ALERT-BOX.
    UNDO, RETURN ERROR.
  END.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME