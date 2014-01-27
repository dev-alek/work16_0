&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-login
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-login
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Окно входа в экран продавца

Автор: Суслов Алексей Юрьевич
Дата создания: 03/24/06
Author: Alexey Suslov
Creation date: 03/24/06

*/

/* ***************************  Definitions  ************************** */

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Окно входа в экран продавца".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/showinf.i }
{ adm/auto-def.i new }
define variable v-connection      as logical   no-undo .
define variable parobj-type as character no-undo.
define variable parobj-code as integer   no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME FRAME-A

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-1 name password b-OK b-quit

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-login AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-OK AUTO-GO
     LABEL "В&ход":L
     SIZE 10 BY 1.

DEFINE BUTTON b-quit AUTO-END-KEY
     LABEL "&Выход ":L
     SIZE 10 BY 1.

DEFINE VARIABLE name AS CHARACTER FORMAT "X(12)":U
     LABEL " Имя "
     VIEW-AS FILL-IN
     SIZE 13.13 BY 1 NO-UNDO.

DEFINE VARIABLE password AS CHARACTER FORMAT "X(8)":U
     LABEL "Пароль"
     VIEW-AS FILL-IN
     SIZE 13.13 BY 1 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "adeicon\freeze":U
     SIZE 8.25 BY 2.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME FRAME-A
     name AT ROW 5.75 COL 8.5 COLON-ALIGNED
     password AT ROW 7 COL 8.5 COLON-ALIGNED BLANK
     b-OK AT ROW 9 COL 7
     b-quit AT ROW 9 COL 17
     IMAGE-1 AT ROW 1.75 COL 12.5
    WITH 1 DOWN NO-BOX OVERLAY
         SIDE-LABELS THREE-D
         AT COL 1 ROW 1
         SIZE 30.88 BY 10.25.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-login ASSIGN
         HIDDEN             = YES
         TITLE              = "IBS TH Остатки товаров"
         COLUMN             = 29.25
         ROW                = 8.79
         HEIGHT             = 10.25
         WIDTH              = 30.88
         MAX-HEIGHT         = 24.21
         MAX-WIDTH          = 100
         VIRTUAL-HEIGHT     = 24.21
         VIRTUAL-WIDTH      = 100
         RESIZE             = no
         SCROLL-BARS        = yes
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR FRAME FRAME-A
   UNDERLINE                                                            */
/* SETTINGS FOR BUTTON b-OK IN FRAME FRAME-A
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON b-quit IN FRAME FRAME-A
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN name IN FRAME FRAME-A
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN password IN FRAME FRAME-A
   NO-DISPLAY                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-login)
THEN w-login:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b-OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-OK w-login
ON CHOOSE OF b-OK IN FRAME FRAME-A /* Вход */
DO:
  if name :screen-value = "" then do:
    message
      "Введите имя пользователя"
      view-as alert-box information .
    apply "entry" to name .
    return no-apply .
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-login


/* ***************************  Main Block  *************************** */

{ gbl/app_help.i &disable-button=yes &disable_diasize_init=true  }

on "ENTRY" of b-ok do:
  if lastkey = keycode ("RETURN") then apply "CHOOSE" to b-ok in frame {&frame-name}.
end.

on window-close of {&window-name} do:
  apply "end-error" to frame {&frame-name}.
end.

ASSIGN CURRENT-WINDOW             = {&WINDOW-NAME}
    SESSION:SYSTEM-ALERT-BOXES = (CURRENT-WINDOW:MESSAGE-AREA = NO).
    session:three-d = yes.
PAUSE 0 BEFORE-HIDE.

if session:date-format <> "dmy":U
  or session:numeric-decimal-point <> ".":U
  or session:numeric-separator <> ",":U
then do:
  message
    vss-workfile vss-revision vss-description skip
    "Неправильные установки сессии progress!" skip
    "Формат даты должен быть - " "'dmy'":U skip
    "Десятичный разделитель - " "'.'":U skip
    "Разделитель тысяч - " "','":U skip
    view-as alert-box error .
  quit.
end.

enable
  name password b-ok b-quit
  with frame {&frame-name} in window {&window-name} .
assign
  session :data-entry-return = yes
.

run gbl/font-chk.p no-error .
if error-status :error then do:
  message
    "Неправильные установки системных шрифтов" skip
    "Обратитесь к администратору" skip
    error-status :get-message(1) skip
    return-value skip
    view-as alert-box information .
end.

do1:
do
on error  undo, leave
on endkey undo, leave
on stop   undo, leave
:
  WAIT-FOR GO OF frame {&FRAME-NAME} focus name.
  assign
    name
    password
    v-connection = FALSE
  .
  run adm/autoinit.p ( input name
                  ,input password
                 ) no-error.
  if error-status :error then do:
    message
      "Ошибка инициализации переменных для системы автоматического запуска" skip
      return-value
      view-as alert-box error.
    leave do1.
  end.
  run adm/autoconn.p no-error.
  if error-status:error then do:
    message
      return-value
      view-as alert-box error.
    leave do1.
  end.
  /*Вызов основного экрана*/
  run str/stockscr.w (input name).

end.  /* do1:  on endkey ... */
assign
  session :data-entry-return = no
.
RUN disable_UI.

/* --------------------- Если произошло подключение к базе данных --------------------- */
run gbl/dbdiscon.p no-error.
quit. /* иначе будет после выхода из системы вылетать редактор */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-login  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-login)
  THEN DELETE WIDGET w-login.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-login  _DEFAULT-ENABLE
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
  ENABLE IMAGE-1 name password b-OK b-quit
      WITH FRAME FRAME-A IN WINDOW w-login.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-A}
  VIEW w-login.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME