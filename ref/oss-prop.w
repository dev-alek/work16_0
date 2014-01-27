&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

Свойства платежа Оператору сотовой связи

Автор: Бахтадзе Наталья Викторовна
Дата создания: 11/11/05
Author: Bakhtadze Natalya
Creation date: 11/11/05

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p-parentproc AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-mode AS character NO-UNDO.
DEFINE INPUT PARAMETER p-gds-code AS integer NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-value AS CHARACTER NO-UNDO.

/* Local Variable Definitions ---                                       */
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Свойства платежа Оператору сотовой связи".
{ cmp/vssrevis.i }
{ gbl/waitfram.i }
{ cmp/str-glbl.i }
{ cmp/library.i }
{ cmp/showinf.i }
{ ref/gds-attr.i }
{ ref/ossprpdf.i }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS B-exit b-quit B-Help f-oper-code f-oper-name ~
f-min-digit-nums f-max-digit-nums f-min-sum f-max-sum f-warning-lim-sum ~
Rs-comission f-comission-pcnt f-comission-sum t-authorization t-slip ~
f-slip-file Rs-billing-type
&Scoped-Define DISPLAYED-OBJECTS f-oper-code f-oper-name f-min-digit-nums ~
f-max-digit-nums f-min-sum f-max-sum f-warning-lim-sum Rs-comission ~
f-comission-pcnt f-comission-sum t-authorization t-slip f-slip-file ~
Rs-billing-type

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
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-quit AUTO-END-KEY
     LABEL "&Отмена"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE f-comission-pcnt AS DECIMAL FORMAT ">9.99":U INITIAL 0
     LABEL "% комиссии"
     VIEW-AS FILL-IN
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE f-comission-sum AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0
     LABEL "Сумма комиссии"
     VIEW-AS FILL-IN
     SIZE 13 BY 1 NO-UNDO.

DEFINE VARIABLE f-max-digit-nums AS INTEGER FORMAT ">9":U INITIAL 0
     LABEL "Максимальное кол-во цифр для ввода номера"
     VIEW-AS FILL-IN
     SIZE 4 BY 1 TOOLTIP "Максимальное кол-во цифр для ввода номера телефона или счета" NO-UNDO.

DEFINE VARIABLE f-max-sum AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0
     LABEL "Максимальная сумма начисления"
     VIEW-AS FILL-IN
     SIZE 13 BY 1 TOOLTIP "в национальной валюте" NO-UNDO.

DEFINE VARIABLE f-min-digit-nums AS INTEGER FORMAT ">9":U INITIAL 0
     LABEL "Минимальное кол-во цифр для ввода номера"
     VIEW-AS FILL-IN
     SIZE 4 BY 1 TOOLTIP "Минимальное кол-во цифр для ввода номера телефона или счета" NO-UNDO.

DEFINE VARIABLE f-min-sum AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0
     LABEL "Минимальная сумма начисления"
     VIEW-AS FILL-IN
     SIZE 13 BY 1 TOOLTIP "в национальной валюте" NO-UNDO.

DEFINE VARIABLE f-oper-code AS INTEGER FORMAT ">>9":U INITIAL 0
     LABEL "Код оператора"
     VIEW-AS FILL-IN
     SIZE 4 BY 1 TOOLTIP "Присваивается Системой приема платежей" NO-UNDO.

DEFINE VARIABLE f-oper-name AS CHARACTER FORMAT "X(15)":U
     LABEL "Название оператора"
     VIEW-AS FILL-IN
     SIZE 26.5 BY 1 TOOLTIP "Для печати на слипе" NO-UNDO.

DEFINE VARIABLE f-slip-file AS CHARACTER FORMAT "X(256)":U
     LABEL "Имя файла образа конечного слипа"
     VIEW-AS FILL-IN
     SIZE 23.5 BY 1 NO-UNDO.

DEFINE VARIABLE f-warning-lim-sum AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0
     LABEL "Порог суммы для выдачи предупреждения"
     VIEW-AS FILL-IN
     SIZE 13 BY 1 TOOLTIP "в национальной валюте" NO-UNDO.

DEFINE VARIABLE Rs-billing-type AS INTEGER
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS
          "Item 1", 1,
"Item 2", 2,
"Item 3", 3
     SIZE 74 BY 2.88 NO-UNDO.

DEFINE VARIABLE Rs-comission AS INTEGER
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS
          "Item 0", 0,
"Item 1", 1,
"Item 2", 2,
"Item 3", 3,
"Item 4", 4
     SIZE 65.5 BY 4.54 NO-UNDO.

DEFINE VARIABLE t-authorization AS LOGICAL INITIAL no
     LABEL "Авторизация неоходима"
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY 1.08 NO-UNDO.

DEFINE VARIABLE t-slip AS LOGICAL INITIAL no
     LABEL "Печать слипа необходима"
     VIEW-AS TOGGLE-BOX
     SIZE 28.5 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     B-exit AT ROW 1 COL 1
     b-quit AT ROW 1 COL 11
     B-Help AT ROW 1 COL 54.88
     f-oper-code AT ROW 2.5 COL 15.5 COLON-ALIGNED
     f-oper-name AT ROW 3.75 COL 20 COLON-ALIGNED
     f-min-digit-nums AT ROW 5 COL 42 COLON-ALIGNED
     f-max-digit-nums AT ROW 6.25 COL 42 COLON-ALIGNED
     f-min-sum AT ROW 7.42 COL 42 COLON-ALIGNED
     f-max-sum AT ROW 8.5 COL 42 COLON-ALIGNED
     f-warning-lim-sum AT ROW 9.75 COL 42 COLON-ALIGNED
     Rs-comission AT ROW 10.88 COL 2.5 NO-LABEL
     f-comission-pcnt AT ROW 10.88 COL 82.5 COLON-ALIGNED
     f-comission-sum AT ROW 11.92 COL 82.5 COLON-ALIGNED
     t-authorization AT ROW 15.92 COL 2.5
     t-slip AT ROW 17 COL 2.5
     f-slip-file AT ROW 17 COL 63.5 COLON-ALIGNED
     Rs-billing-type AT ROW 18.08 COL 26.5 NO-LABEL
     "Тип расчета с оператором" VIEW-AS TEXT
          SIZE 24.5 BY .79 AT ROW 18.08 COL 1.5
     SPACE(74.79) SKIP(2.07)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE
         TITLE "Настройки платежа оператора сотовой связи"
         DEFAULT-BUTTON B-exit CANCEL-BUTTON b-quit.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
ASSIGN
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Настройки платежа оператора сотовой связи */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-exit Dialog-Frame
ON CHOOSE OF B-exit IN FRAME Dialog-Frame /* Ввод */
DO:
  RUN proc-save IN THIS-PROCEDURE NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Rs-comission
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Rs-comission Dialog-Frame
ON VALUE-CHANGED OF Rs-comission IN FRAME Dialog-Frame
DO:
  ASSIGN
  rs-comission.
  CASE rs-comission:
    WHEN 0 THEN DO:
       ASSIGN
       f-comission-pcnt = 0
       f-comission-sum = 0
       .
       DISPLAY
       f-comission-pcnt
       f-comission-sum
       WITH FRAME {&FRAME-NAME}.
       DISABLE
       f-comission-pcnt
       f-comission-sum
       WITH FRAME {&FRAME-NAME}.
    END.
    WHEN 1
    or
    WHEN 2 THEN DO:
        ASSIGN
        f-comission-pcnt = 0
        .
        DISPLAY
        f-comission-sum
        WITH FRAME {&FRAME-NAME}.

        DISABLE
        f-comission-sum
        WITH FRAME {&FRAME-NAME}.
        ENABLE
        f-comission-SUM
        WITH FRAME {&FRAME-NAME}.
    END.
    WHEN 3
    or
    WHEN 4 THEN DO:
        ASSIGN
        f-comission-pcnt = 0
        .
        DISPLAY
        f-comission-pcnt

        WITH FRAME {&FRAME-NAME}.

        DISABLE
        f-comission-pcnt
        WITH FRAME {&FRAME-NAME}.
        ENABLE
        f-comission-sum
        WITH FRAME {&FRAME-NAME}.

    END.

  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME t-slip
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t-slip Dialog-Frame
ON VALUE-CHANGED OF t-slip IN FRAME Dialog-Frame /* Печать слипа необходима */
DO:
  ASSIGN
  t-slip.
  IF t-slip THEN DO:
      ENABLE
      f-slip-file
      WITH FRAME {&FRAME-NAME}.
  END.
  ELSE DO:
      ASSIGN
      f-slip-file = '':U.
      DISPLAY
      f-slip-file
      WITH FRAME {&FRAME-NAME}.
      disABLE
      f-slip-file
      WITH FRAME {&FRAME-NAME}.

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
  RUN fill-table IN THIS-PROCEDURE.
  RUN Myenable IN THIS-PROCEDURE.
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
  DISPLAY f-oper-code f-oper-name f-min-digit-nums f-max-digit-nums f-min-sum
          f-max-sum f-warning-lim-sum Rs-comission f-comission-pcnt
          f-comission-sum t-authorization t-slip f-slip-file Rs-billing-type
      WITH FRAME Dialog-Frame.
  ENABLE B-exit b-quit B-Help f-oper-code f-oper-name f-min-digit-nums
         f-max-digit-nums f-min-sum f-max-sum f-warning-lim-sum Rs-comission
         f-comission-pcnt f-comission-sum t-authorization t-slip f-slip-file
         Rs-billing-type
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fill-table Dialog-Frame
PROCEDURE fill-table :
DEFINE VARIABLE v-num-entries AS INTEGER NO-UNDO.
DEFINE VARIABLE v-ii AS INTEGER NO-UNDO.
DEFINE VARIABLE v-entry AS character NO-UNDO.
define variable v-value as character no-undo .
define buffer buf_goods for ub.goods.
find first buf_goods no-lock where
          buf_goods.gds-code = p-gds-code no-error .
if not available buf_goods then do:
  message
  substitute("Платеж оператору сотовой связи: Не найдена услуга с кодом &1", p-gds-code)
  view-as alert-box error .
  return error.
end.
if buf_goods.gds-type <> {&gds-office}
or buf_goods.unit-base <> "{&abbr_rub}" then do:
  message
  substitute("Платеж оператору сотовой связи должен быть услугой&1," +
            "с единицей измерения равной единице измерения национальной валюты (&2)"
             , {&new-line}
             , "{&abbr_rub}"
             )
  view-as alert-box error .
end.

ASSIGN
v-num-entries = NUM-ENTRIES( p-value, {&delim-par})
.
DO v-ii = 1 TO v-num-entries:
  ASSIGN
  v-entry = ENTRY(v-ii, p-value, {&delim-par})
  v-value = (if num-entries(v-entry, '=') > 1
             then left-trim(v-entry, entry(1, v-entry, '=':U) + '=':U)
             else '':U)
  .
  IF v-entry BEGINS ({&oper-code} + '=':U) THEN DO:
     ASSIGN
     f-oper-code = INTEGER(v-value)
     NO-ERROR.
  END.
  IF v-entry BEGINS ({&oper-name} + '=':U) THEN DO:
     ASSIGN
     f-oper-name = v-value
     NO-ERROR.
  END.
  IF v-entry BEGINS ({&min-digit-nums}  + '=':U) THEN DO:
     ASSIGN
     f-min-digit-nums = INTEGER(v-value)
     NO-ERROR.
  END.
  IF v-entry BEGINS ({&max-digit-nums}  + '=':U) THEN DO:
     ASSIGN
     f-max-digit-nums = INTEGER(v-value)
     NO-ERROR.
  END.
  IF v-entry BEGINS ({&min-sum}  + '=':U) THEN DO:
     ASSIGN
     f-min-sum = DECIMAL(v-value)
     NO-ERROR.
  END.
  IF v-entry BEGINS ({&max-sum}  + '=':U) THEN DO:
     ASSIGN
     f-max-sum = DECIMAL(v-value)
     NO-ERROR.
  END.
  IF v-entry BEGINS ({&warning-lim-sum}  + '=':U) THEN DO:
     ASSIGN
     f-warning-lim-sum = DECIMAL(v-value)
     NO-ERROR.
  END.
  IF v-entry BEGINS ({&comission-type}  + '=':U) THEN DO:
     ASSIGN
     rs-comission = integer(v-value)
     NO-ERROR.
  END.
  IF v-entry BEGINS ({&comission-pcnt}  + '=':U) THEN DO:
     ASSIGN
     f-comission-pcnt = decimal(v-value)
     NO-ERROR.
  END.
  IF v-entry BEGINS ({&comission-sum}  + '=':U) THEN DO:
     ASSIGN
     f-comission-sum = decimal(v-value)
     NO-ERROR.
  END.
  IF v-entry BEGINS ({&need-authorization}  + '=':U) THEN DO:
     ASSIGN
     t-authorization = logical(v-value)
     NO-ERROR.
  END.
  IF v-entry BEGINS ({&need-slip-print}  + '=':U) THEN DO:
     ASSIGN
     t-slip = logical(v-value)
     NO-ERROR.
  END.
  IF v-entry BEGINS ({&slip-file}  + '=':U) THEN DO:
     ASSIGN
     f-slip-file = v-entry
     NO-ERROR.
  END.
  IF v-entry BEGINS ({&billing-type}  + '=':U) THEN DO:
     ASSIGN
     rs-billing-type = integer(v-value)
     NO-ERROR.
  END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MyEnable Dialog-Frame
PROCEDURE MyEnable :
ASSIGN
Rs-comission:RADIO-BUTTONS in frame {&frame-name} =
    "Комиссия не взимается" + {&comma-char} + STRING(0) + {&comma-char} +
    "Комиссия (%) включена в вводимую сумму" + {&comma-char} + STRING(1) + {&comma-char} +
    "Комиссия (%) начисляется сверх вводимой суммы" + {&comma-char} + STRING(2) + {&comma-char} +
    "Комиссия (сумма) включена в вводимую сумму" + {&comma-char} + STRING(3) + {&comma-char} +
    "Комиссия (сумма) начисляется сверх вводимой суммы" + {&comma-char} + STRING(4)
rs-billing-type:RADIO-BUTTONS =
    "Оплата сотовой связи (запрашивается № телефона)" + {&comma-char} + STRING(1) + {&comma-char} +
    "Оплата по договору (запрашивается № договора)" + {&comma-char} + STRING(2) + {&comma-char} +
    "Оплата счета (запрашивается № счета)" + {&comma-char} + STRING(3)
    .
DISPLAY
f-oper-code
f-oper-name
f-min-digit-nums
f-max-digit-nums
f-min-sum
f-max-sum
f-warning-lim-sum
Rs-comission
f-comission-pcnt
f-comission-sum
t-slip
f-slip-file
t-authorization
Rs-billing-type
WITH FRAME {&frame-name}.
IF p-mode = {&UPDATE} THEN do:
  ENABLE
  B-exit
  b-quit
  B-Help
  f-oper-code
  f-oper-name
  f-min-digit-nums
  f-max-digit-nums
  f-min-sum
  f-max-sum
  f-warning-lim-sum
  Rs-comission
  f-comission-pcnt
  f-comission-sum
  t-slip
  f-slip-file
  t-authorization
  Rs-billing-type
  WITH FRAME {&frame-name}.
end.
else do:
  assign
  b-quit:label = "&Выход"
  b-quit:column = 1
 .
  enable
  b-quit
  b-help
  with frame {&frame-name} .
end.
VIEW FRAME {&frame-name}.
if p-mode <> {&lookup} then do:
  APPLY "VALUE-CHANGED"  TO rs-comission.
  APPLY "VALUE-CHANGED"  TO t-slip.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-save Dialog-Frame
PROCEDURE proc-save :

DEFINE VARIABLE v-value AS CHARACTER NO-UNDO.
define variable v-type as character no-undo .

define buffer buf_goods for ub.goods.

find first buf_goods no-lock where
          buf_goods.gds-code = p-gds-code no-error .
if not available buf_goods then do:
  message
  substitute("Платеж оператору сотовой связи: Не найдена услуга с кодом &1", p-gds-code)
  view-as alert-box error .
  return error.
end.
/*проверим ГЛОБАЛЬНЫЙ атрибут товара*/
run gds-attr-value in this-procedure (
                                       input  p-gds-code
                                      ,input  {&attr-is-oss-payment}
                                      ,output v-value
                                      ,output v-type ) no-error .
if logical(v-value) <> yes then do:
  message
  substitute("Перед заданием свойств платежа оператору сотовой связи&1" +
             "Необходимо привязать к товару глобальный атрибут <ПЛАТЕЖ ОСС>"
             , {&new-line})
  view-as alert-box error .
  undo, return error .
end.

if buf_goods.gds-type <> {&gds-office}
or buf_goods.unit-base <> "{&abbr_rub}" then do:
  message
  substitute("Платеж оператору сотовой связи должен быть услугой&1," +
            "с единицей измерения равной единице измерения национальной валюты (&2)"
             , {&new-line}
             , "{&abbr_rub}"
             )
  view-as alert-box error .
end.


ASSIGN
FRAME {&FRAME-NAME}
f-oper-code
f-oper-name
f-min-digit-nums
f-max-digit-nums
f-min-sum
f-max-sum
f-warning-lim-sum
Rs-comission
f-comission-pcnt
f-comission-sum
t-authorization
t-slip
f-slip-file
Rs-billing-type
.

ASSIGN
v-value = {&oper-code} + '=':U + STRING(f-oper-code) + {&delim-par} +
          {&oper-name} + '=':U + STRING(f-oper-name) + {&delim-par} +
          {&min-digit-nums} + '=':U + STRING(f-min-digit-nums) + {&delim-par} +
          {&max-digit-nums} + '=':U + STRING(f-max-digit-nums) + {&delim-par} +
          {&min-sum} + '=':U + STRING(f-min-sum) + {&delim-par} +
          {&max-sum} + '=':U + STRING(f-max-sum) + {&delim-par} +
          {&warning-lim-sum} + '=':U + STRING(f-warning-lim-sum) + {&delim-par} +
          {&comission-type} + '=':U + STRING(rs-comission) + {&delim-par} +
          {&comission-pcnt} + '=':U + STRING(f-comission-pcnt) + {&delim-par} +
          {&comission-sum} + '=':U + STRING(f-comission-sum) + {&delim-par} +
          {&need-authorization} + '=':U + STRING(t-authorization) + {&delim-par} +
          {&need-slip-print} + '=':U + STRING(t-slip) + {&delim-par} +
          {&slip-file} + '=':U + STRING(f-slip-file) + {&delim-par} +
          {&billing-type} + '=':U + STRING(rs-billing-type) .
IF v-value = ? THEN DO:
    MESSAGE
    "Все поля должны  быть определены"
    VIEW-AS ALERT-BOX ERROR.
    RETURN error.
END.
p-value = v-value.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME