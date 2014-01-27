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

Окно входа в систему IBS Trade House

Автор: Белоусов Илья Александрович
Дата создания: 05/08/07
Author: Ilia Belousov
Creation date: 05/08/07

Автор1: Перваков Михаил Сергеевич
Дата создания: 04/05/06


*/

/* ***************************  Definitions  ************************** */

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Окно входа в систему".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/showinf.i }

define variable v-cConnect          as character no-undo .
define variable v-fltConnect        as character no-undo .
define variable v-user-entered      as logical   no-undo init false .
define variable v-name-for-load-cfg as character no-undo .
define variable v-name-for-init-db  as character no-undo .
define variable v-fname-cfg         as character no-undo .
define variable v-err-code          as integer   no-undo .
define variable v-try-connect       as logical   no-undo init false .
define variable v-is-copy           as logical   no-undo init false .
define variable v-load-cfg          as logical      no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-l-i

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-OK IMAGE-1 name b-quit password 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-login AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-OK AUTO-GO  NO-FOCUS
     LABEL "&Ввод":L 
     SIZE 10 BY 1
     BGCOLOR 15 .

DEFINE BUTTON b-quit AUTO-END-KEY  NO-FOCUS
     LABEL "&Отмена":L 
     SIZE 10 BY 1.

DEFINE VARIABLE name AS CHARACTER FORMAT "X(12)":U 
     LABEL "Имя" 
     VIEW-AS FILL-IN 
     SIZE 13.5 BY 1 NO-UNDO.

DEFINE VARIABLE password AS CHARACTER FORMAT "X(12)":U 
     LABEL "Пароль" 
     VIEW-AS FILL-IN 
     SIZE 13.5 BY 1 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "cmp/ith.bmp":U
     STRETCH-TO-FIT RETAIN-SHAPE
     SIZE 24.75 BY 3.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-l-i
     b-OK AT ROW 9.04 COL 13
     name AT ROW 5.79 COL 14.5 COLON-ALIGNED
     b-quit AT ROW 9.04 COL 23
     password AT ROW 7 COL 14.5 COLON-ALIGNED PASSWORD-FIELD 
     IMAGE-1 AT ROW 1.79 COL 10
    WITH 1 DOWN NO-BOX OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 41.5 BY 10.27.


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
         TITLE              = "IBS Trade House 15.1"
         COLUMN             = 25.25
         ROW                = 8.5
         HEIGHT             = 10.25
         WIDTH              = 41.5
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
/* SETTINGS FOR FRAME f-l-i
   FRAME-NAME UNDERLINE                                                 */
/* SETTINGS FOR BUTTON b-OK IN FRAME f-l-i
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON b-quit IN FRAME f-l-i
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN name IN FRAME f-l-i
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN password IN FRAME f-l-i
   NO-DISPLAY                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-login)
THEN w-login:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-l-i
/* Query rebuild information for FRAME f-l-i
     _Query            is NOT OPENED
*/  /* FRAME f-l-i */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-login
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-login w-login
ON WINDOW-CLOSE OF w-login /* IBS Trade House 15.1 */
DO:
  apply "end-error" to frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-OK w-login
ON CHOOSE OF b-OK IN FRAME f-l-i /* Ввод */
DO:
  if name :screen-value = ""
  then do:
    message
      "Введите имя пользователя"
      view-as alert-box information .
    apply "entry" to name .
    return no-apply .
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-OK w-login
ON ENTRY OF b-OK IN FRAME f-l-i /* Ввод */
DO:
  if lastkey = keycode ("RETURN") then do:
    apply "CHOOSE" to b-ok in frame {&frame-name}.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME name
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL name w-login
ON RETURN OF name IN FRAME f-l-i /* Имя */
DO:
  apply "entry" to password in frame {&frame-name} .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME password
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL password w-login
ON RETURN OF password IN FRAME f-l-i /* Пароль */
DO:
  apply "CHOOSE" to b-ok in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-login 


/* ***************************  Main Block  *************************** */

{ gbl/app_help.i &disable-button=yes }

ASSIGN
  CURRENT-WINDOW             = {&WINDOW-NAME}
  SESSION:SYSTEM-ALERT-BOXES = (CURRENT-WINDOW:MESSAGE-AREA = NO)
  session:three-d = yes
.

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

IMAGE-1 :load-image("cmp/ith.bmp") .

enable
  name password b-ok b-quit
  with frame {&frame-name} in window {&window-name} .
assign
  session :data-entry-return = yes
.

run gbl/font-chk.p no-error .
if error-status :error
then do:
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
  if lookup( '.', propath) > 0
  then do:
    /* если в пути присутствует текущая директория, */
    /* то определяем её абсолютный путь */
    /* и заменяем символ точка в Propath на абсолютный путь текущей директории */
    /* это делается для того, чтобы в случае когда изменитcя текущая директория */
    /* *.r коды, которые там находились продолжали бы выполняться */

    define variable v-home-directory as character no-undo .
    define variable v-ind as integer   no-undo .
    define variable v-num-entries-propath as integer   no-undo .
    define variable v-old-propath         as character no-undo .
    define variable v-new-propath         as character no-undo .
    define variable v-path-item           as character no-undo .

    assign
      file-info :file-name = '.'
      v-home-directory = file-info :full-pathname
    .

    assign
      v-old-propath = propath
      v-new-propath = ''
    .
    assign
      v-num-entries-propath = num-entries(v-old-propath)
    .

    do v-ind = 1 to v-num-entries-propath
    :
      assign
        v-path-item = entry(v-ind, v-old-propath)
      .
      if v-path-item = '.'
      then do:
        assign
          v-path-item = v-home-directory
        .
      end.
      assign
        v-new-propath = v-new-propath
                      + (if v-new-propath <> '' then ',' else '')
                      + v-path-item
      .
    end.

    assign
      propath = v-new-propath
    .
  end.

  run enable_ui in this-procedure .

  WAIT-FOR GO OF frame {&FRAME-NAME} focus name.
  assign
    name
    password .
  GET-KEY-VALUE SECTION "REP-SETS" KEY "ConPar" VALUE v-cConnect.
  if v-cConnect = ?
  or trim (v-cConnect) = ""
  then do:
    message
      "Не указаны параметры подключения к БД"
      "(секция REP-SETS ключ ConPar в .ini файле)."
      view-as alert-box error .
    undo do1, leave.
  end.
  if index(v-cConnect, '&1':u) = 0
  then do:
    message
      "В строке подключения к БД не указан комбинация символов &1"
      "(секция REP-SETS ключ ConPar в .ini файле)."
      view-as alert-box error .
    undo do1, leave.
  end.

  assign
    v-name-for-load-cfg  = "адм" + '2':U
    v-load-cfg           = false
  .
  if name = v-name-for-load-cfg
  then do:
    assign
      name     = "адм"
      v-load-cfg = true
    .
  end.

  GET-KEY-VALUE SECTION "REP-SETS":U KEY "ConParFlt":U VALUE v-fltConnect .
  if trim (v-fltConnect) = "":U
    or trim( v-fltConnect ) = trim( v-cConnect )
  then do:
    assign
      v-fltConnect = ?
    .
  end.
  else do:
    if index(v-fltConnect, '&1':u) = 0
    then do:
      message
        "В строке подключения к БД параметров не указана комбинация символов &1"
        "(секция REP-SETS ключ ConParFlt в .ini файле)."
        view-as alert-box error .
      undo do1, leave.
    end.
  end.

  assign
    v-try-connect = true
  .
  run gbl/dbconn.p
    (input v-cConnect
    ,input v-fltConnect
    ,input name
    ,input password
    ,input-output v-user-entered
    ) .
  if userid('{&db-name_schema}':U) = '':U
  then do:
    message
      "Ошибка при подключении к базе данных" skip
      "Неизвестный пользователь" skip
      view-as alert-box error .
    disconnect ub no-error .
    quit.
  end.
end. /* do1 */

assign
  session :data-entry-return = no
.
RUN disable_UI.

/* --------------------- Если произошло подключение к базе данных --------------------- */
if v-user-entered
then
DO2:
do
:
  run adm/unloaddb.w
    (input  name
    ,input  password
    ,output v-is-copy
    ) .
  if v-is-copy = false
  then do:
    run adm/chk-db.p no-error .
    if error-status :error then do:
      message
        error-status :get-message(1) skip
        return-value skip
        view-as alert-box error .
    end.
    else do:
      if v-load-cfg = true then do:
        /* зашли только для загрузки парамеметров */
        run adm/checkcnf.p
          ( input "cfg-load":U
          ) no-error .
        if error-status :error
          and error-status :get-message(1) <> ""
        then do:
          message
            vss-workfile vss-revision vss-description skip
            error-status :get-message(1) skip
            return-value skip
            view-as alert-box error .
        end.
      end.
      else do: /* зашли для работы */
        run adm/chkdbkey.p no-error .
        if error-status :error then do:
         /* ошибка проверки кодировки ключей БД - не запускаем систему */
          if error-status :get-message(1) <> "" then do:
              message
                vss-workfile vss-revision vss-description skip
                error-status :get-message(1) skip
                return-value skip
                view-as alert-box error .
          end.
        end.
        else do:
          run adm/checkcnf.p
            ( input "cfg-check":U
            ) no-error .
          if error-status :error then do:
              /* ошибка проверки параметров - не запускаем систему */
            if error-status :get-message(1) <> "" then do:
              message
                vss-workfile vss-revision vss-description skip
                error-status :get-message(1) skip
                return-value skip
                view-as alert-box error .
            end.
          end.
          else do:
            run gbl/sys-main.p
              (input name
              ,input password
              ) no-error .
            if error-status :error then do:
              message
                vss-workfile vss-revision vss-description skip
                error-status :get-message(1) skip
                return-value skip
                view-as alert-box error .
              LEAVE DO2.
            end.
          end.
        end.
      end.
    end.
  end.
end.
else do:
  if v-try-connect = true
  then do:
     if error-status :error then do:
        message
           "Ошибка при подключении к БД" skip
           error-status :get-message(1) skip
           return-value skip
           view-as alert-box error .
        disconnect ub no-error .
        quit.
     end.
     ELSE DO:
        message
           "Ошибка при подключении к базе данных" skip
           "Обратитесь к администратору" skip
           "Строка подключения к БД:" skip
           v-cConnect skip
           view-as alert-box error .
     end.
  end.
end.
disconnect ub no-error .
quit. /* иначе будет после выхода из системы вылетать редактор */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ARM-users w-login 
PROCEDURE ARM-users :
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  ENABLE b-OK IMAGE-1 name b-quit password 
      WITH FRAME f-l-i IN WINDOW w-login.
  {&OPEN-BROWSERS-IN-QUERY-f-l-i}
  VIEW w-login.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

