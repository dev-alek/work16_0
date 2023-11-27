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

Редактирование секции Настройки для подключения к ГИС МТ и проверки КМ

Автор: Шкляр Елена Львовна
Дата создания: 15/11/03
Author: Elena Shklyar
Creation date: 15/11/03

This .W file was created with the Progress AppBuilder.

*/

define input parameter parparentproc as widget-handle no-undo.
define input parameter p-mode     as character no-undo.
define input parameter p-obj-type like ub.clients.obj-type no-undo.
define input parameter p-obj-code like ub.clients.obj-code no-undo.



define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-Workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Редактирование секции Настройки для подключения к ГИС МТ и проверки КМ" .
{ cmp/vssrevis.i }
{ cmp/trg-def.i  }
{ cmp/library.i  }
{ cmp/showinf.i  }
{ gbl/thbjattr.i }
{ gbl/onewin.i   }

define temp-table temp-thbj-attr no-undo like ub.thbj-attr.

define variable v-tth     as handle no-undo .

define variable v-tth-host as handle no-undo .
define variable v-to-create-host as logical no-undo.
define variable str-attr as character no-undo .

assign
v-tth      = buffer temp-thbj-attr:table-handle .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS B-exit B-quit B-Help RECT-1 RECT-2 ~
registrationKey adressPort login password dopParam waitTime maxTime ~
timeFalStart crashSituat banDate 
&Scoped-Define DISPLAYED-OBJECTS registrationKey adressPort login password ~
dopParam waitTime maxTime timeFalStart crashSituat banDate 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-exit AUTO-GO 
     LABEL "&Ввод" 
     SIZE 10 BY 1.

DEFINE BUTTON B-Help 
     LABEL "&Help" 
     SIZE 10 BY 1.

DEFINE BUTTON B-quit AUTO-END-KEY 
     LABEL "&Отмена" 
     SIZE 10 BY 1.

DEFINE VARIABLE adressPort AS CHARACTER FORMAT "X(256)":U 
     LABEL "Адрес и порт" 
     VIEW-AS FILL-IN 
     SIZE 64 BY 1 NO-UNDO.

DEFINE VARIABLE banDate AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 5 
     LABEL "Опережение срабатывания запрета по сроку годности в минутах" 
     VIEW-AS FILL-IN 
     SIZE 6.5 BY 1 NO-UNDO.

DEFINE VARIABLE dopParam AS CHARACTER FORMAT "X(256)":U 
     LABEL "Дополнительные параметры запроса" 
     VIEW-AS FILL-IN 
     SIZE 47 BY 1 NO-UNDO.

DEFINE VARIABLE gisAdress AS CHARACTER FORMAT "X(256)":U 
     LABEL "Адрес ГИС МТ" 
     VIEW-AS FILL-IN 
     SIZE 64 BY 1 NO-UNDO.

DEFINE VARIABLE login AS CHARACTER FORMAT "X(256)":U 
     LABEL "Логин" 
     VIEW-AS FILL-IN 
     SIZE 27 BY 1 NO-UNDO.

DEFINE VARIABLE maxTime AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 72 
     LABEL "Макс. допустимое время разрешения продажи при сбое онлайн проверки (часы)" 
     VIEW-AS FILL-IN 
     SIZE 6.5 BY 1 NO-UNDO.

DEFINE VARIABLE password AS CHARACTER FORMAT "X(256)":U 
     LABEL "Пароль" 
     VIEW-AS FILL-IN 
     SIZE 27 BY 1 NO-UNDO.

DEFINE VARIABLE registrationKey AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ключ авторизации" 
     VIEW-AS FILL-IN 
     SIZE 64 BY 1 NO-UNDO.

DEFINE VARIABLE timeFalStart AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 2 
     LABEL "Время с момента сбоя до начала уведомления персонала (часы)" 
     VIEW-AS FILL-IN 
     SIZE 6.5 BY 1 NO-UNDO.

DEFINE VARIABLE waitTime AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 1.5 
     LABEL "Длительность ожидания ответа ГИС МТ (секунды)" 
     VIEW-AS FILL-IN 
     SIZE 6.5 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 15.75.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82.5 BY 3.25.

DEFINE VARIABLE crashSituat AS LOGICAL INITIAL no 
     LABEL "Аварийная ситуация в ГИС МТ" 
     VIEW-AS TOGGLE-BOX
     SIZE 48 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     B-exit AT ROW 1 COL 1
     B-quit AT ROW 1 COL 11
     B-Help AT ROW 1 COL 74.63
     gisAdress AT ROW 3.13 COL 18.5 COLON-ALIGNED WIDGET-ID 118
     registrationKey AT ROW 4.25 COL 18.5 COLON-ALIGNED WIDGET-ID 142
     adressPort AT ROW 6.63 COL 18.5 COLON-ALIGNED WIDGET-ID 144
     login AT ROW 7.79 COL 18.5 COLON-ALIGNED WIDGET-ID 146
     password AT ROW 7.79 COL 83.5 RIGHT-ALIGNED WIDGET-ID 148 PASSWORD-FIELD 
     dopParam AT ROW 9.88 COL 3.5 WIDGET-ID 154
     waitTime AT ROW 11.25 COL 83.5 RIGHT-ALIGNED WIDGET-ID 156
     maxTime AT ROW 12.54 COL 83.5 RIGHT-ALIGNED WIDGET-ID 168
     timeFalStart AT ROW 13.88 COL 83.5 RIGHT-ALIGNED WIDGET-ID 170
     crashSituat AT ROW 15.25 COL 17.5 WIDGET-ID 174
     banDate AT ROW 16.46 COL 83.5 RIGHT-ALIGNED WIDGET-ID 172
     "Проски-сервер" VIEW-AS TEXT
          SIZE 14 BY .67 AT ROW 5.75 COL 39.5 WIDGET-ID 152
     RECT-1 AT ROW 2.75 COL 2 WIDGET-ID 116
     RECT-2 AT ROW 6.25 COL 3.5 WIDGET-ID 150
     SPACE(1.12) SKIP(9.20)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Настройки для подключения к ГИС МТ и проверки КМ"
         DEFAULT-BUTTON B-exit CANCEL-BUTTON B-quit WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN banDate IN FRAME Dialog-Frame
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN dopParam IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN gisAdress IN FRAME Dialog-Frame
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       gisAdress:HIDDEN IN FRAME Dialog-Frame           = TRUE.

/* SETTINGS FOR FILL-IN maxTime IN FRAME Dialog-Frame
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN password IN FRAME Dialog-Frame
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN timeFalStart IN FRAME Dialog-Frame
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN waitTime IN FRAME Dialog-Frame
   ALIGN-R                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON GO OF FRAME Dialog-Frame /* Настройки для подключения к ГИС МТ и проверки КМ */
DO:
  run save-proc in this-procedure no-error.
  if error-status :error then return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Настройки для подключения к ГИС МТ и проверки КМ */
DO:
  APPLY "END-ERROR":U TO SELF.
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

    RUN init-tt.
    RUN enable_UI.
    RUN fill-widgets.

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
  DISPLAY registrationKey adressPort login password dopParam waitTime maxTime 
          timeFalStart crashSituat banDate gisAdress
      WITH FRAME Dialog-Frame.
  ENABLE B-exit B-quit B-Help RECT-1 RECT-2 registrationKey adressPort login 
         password dopParam waitTime maxTime timeFalStart crashSituat banDate gisAdress
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
define variable v-param-type as character no-undo .
define variable v-param-value as character no-undo .

for each temp-thbj-attr:
  delete temp-thbj-attr.
end.

run adm/shattri.p (
    input "init":U
  , input p-obj-type
  , input p-obj-code
  , input {&attr-gisMT}
  , input "":U
  , output v-value-character
  , output v-value-date
  , output v-value-decimal
  , output v-value-integer
  , output v-value-logical
  , output v-param-type
  , input-output TABLE-HANDLE v-tth
  ) no-error .
if error-status:error then do:
  message
  "Не удалось получить начальные значения настроек" skip
  error-status:get-message(1) return-value
  view-as alert-box error .
  undo, return error .
end.


FOR EACH temp-thbj-attr
  :
    IF temp-thbj-attr.prop-code = {&attr-gisMT_adressPort} THEN DO:
       adressPort = temp-thbj-attr.property-value-character.
       display adressPort with frame {&frame-name} .
    END.
    IF temp-thbj-attr.prop-code = {&attr-gisMT_dopParam} THEN DO:
       dopParam = temp-thbj-attr.property-value-character.
       display dopParam with frame {&frame-name} .
    END.
    IF temp-thbj-attr.prop-code = {&attr-gisMT_gisAdress} THEN DO:
       gisAdress = temp-thbj-attr.property-value-character.
       display gisAdress with frame {&frame-name} .
    END.
    IF temp-thbj-attr.prop-code = {&attr-gisMT_proxyLogin} THEN DO:
       login = temp-thbj-attr.property-value-character.
       display login with frame {&frame-name} .
    END.
    IF temp-thbj-attr.prop-code = {&attr-gisMT_proxyPswd} THEN DO:
       password = temp-thbj-attr.property-value-character.
       display password with frame {&frame-name} .
    END.
    IF temp-thbj-attr.prop-code = {&attr-gisMT_maxTime} THEN DO:
       maxTime = temp-thbj-attr.property-value-integer.
       display maxTime with frame {&frame-name} .
    END.
    IF temp-thbj-attr.prop-code = {&attr-gisMT_regKey} THEN DO:
       registrationKey = temp-thbj-attr.property-value-character.
       display registrationKey with frame {&frame-name} .
    END.
    IF temp-thbj-attr.prop-code = {&attr-gisMT_timeFalStart} THEN DO:
       timeFalStart = temp-thbj-attr.property-value-integer.
       display timeFalStart with frame {&frame-name} .
    END.
    IF temp-thbj-attr.prop-code = {&attr-gisMT_waitTime} THEN DO:
       waitTime = temp-thbj-attr.property-value-decimal.
       display waitTime with frame {&frame-name} .
    END.
    IF temp-thbj-attr.prop-code = {&attr-gisMT_crashSituat} THEN DO:
       crashSituat = temp-thbj-attr.property-value-logical.
       display crashSituat with frame {&frame-name} .
    END.
    IF temp-thbj-attr.prop-code = {&attr-gisMT_banDate} THEN DO:
       banDate = temp-thbj-attr.property-value-integer.
       display banDate with frame {&frame-name} .
    END.    
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-tt Dialog-Frame 
PROCEDURE init-tt :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE save-proc Dialog-Frame 
PROCEDURE save-proc :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
define variable v-value-character as character no-undo .
define variable v-value-date as date no-undo .
define variable v-value-decimal as decimal no-undo .
define variable v-value-integer as INTEGER no-undo .
define variable v-value-logical AS LOGICAL no-undo .
define variable v-param-type as character no-undo .
define variable v-gds-copy-list as character no-undo .
define variable v-gdsreffi as character no-undo .
define variable wh as widget-handle no-undo .
define variable fh as widget-handle no-undo .
define variable v-same as logical no-undo .

define buffer buf_temp-thbj-attr for temp-thbj-attr .

IF p-mode = {&LOOKUP} THEN RETURN ERROR.

ASSIGN FRAME {&FRAME-NAME}
    adressPort 
    dopParam
    gisAdress
    login
    password
    maxTime
    registrationKey
    timeFalStart
    waitTime
    crashSituat
    banDate
    .
    find first temp-thbj-attr where temp-thbj-attr.prop-code = {&attr-gisMT_adressPort} .
    temp-thbj-attr.property-value-character = adressPort.

    find first temp-thbj-attr where temp-thbj-attr.prop-code = {&attr-gisMT_dopParam} .
    temp-thbj-attr.property-value-character = dopParam.
    
    find first temp-thbj-attr where temp-thbj-attr.prop-code = {&attr-gisMT_gisAdress} .
    temp-thbj-attr.property-value-character = gisAdress.
    
    find first temp-thbj-attr where temp-thbj-attr.prop-code = {&attr-gisMT_proxyLogin} .
    temp-thbj-attr.property-value-character = login.

    find first temp-thbj-attr where temp-thbj-attr.prop-code = {&attr-gisMT_proxyPswd} .
    temp-thbj-attr.property-value-character = password.
    
    find first temp-thbj-attr where temp-thbj-attr.prop-code = {&attr-gisMT_maxTime} .
    temp-thbj-attr.property-value-integer = maxTime.

    find first temp-thbj-attr where temp-thbj-attr.prop-code = {&attr-gisMT_regKey} .
    temp-thbj-attr.property-value-character = registrationKey.

    find first temp-thbj-attr where temp-thbj-attr.prop-code = {&attr-gisMT_timeFalStart} .
    temp-thbj-attr.property-value-integer = timeFalStart.
    
    find first temp-thbj-attr where temp-thbj-attr.prop-code = {&attr-gisMT_waitTime} .
    temp-thbj-attr.property-value-decimal = waitTime.
    
    find first temp-thbj-attr where temp-thbj-attr.prop-code = {&attr-gisMT_crashSituat} .
    temp-thbj-attr.property-value-logical = crashSituat.

    find first temp-thbj-attr where temp-thbj-attr.prop-code = {&attr-gisMT_banDate} .
    temp-thbj-attr.property-value-integer = banDate.

    do transaction:
        RUN thbjattr_set-section IN THIS-PROCEDURE (
             input p-obj-type
            ,input p-obj-code
            ,input {&attr-gisMT}
            ,INPUT table temp-thbj-attr
        ) NO-ERROR.
        if error-status:error then do:
            message "Не удалось сохранить настройки"
            view-as alert-box.
            undo, return error.
        end.
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

