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

Выполнить процедуру

Автор: Перваков Михаил Сергеевич
Дата создания: 04/12/06
Author: Mikhail Pervakov
Creation date: 04/12/06

*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Выполнить процедуру".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/showinf.i  }
define stream sReadfile.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_Cancel Btn_OK b-help proc-name Btn_Get
&Scoped-Define DISPLAYED-OBJECTS proc-name

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-help
     LABEL "Помо&щь"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_Cancel AUTO-END-KEY
     LABEL "&Выход"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_Get
     IMAGE-UP FILE "btn-down-arrow":U
     IMAGE-DOWN FILE "btn-down-arrow":U
     IMAGE-INSENSITIVE FILE "btn-down-arrow":U
     LABEL ""
     SIZE 3 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO DEFAULT
     LABEL "Вы&полнить"
     SIZE 12 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE proc-name AS CHARACTER FORMAT "X(256)":U
     LABEL "&Имя процедуры"
     VIEW-AS FILL-IN
     SIZE 55.25 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     Btn_Cancel AT ROW 1 COL 1
     Btn_OK AT ROW 1 COL 11
     b-help AT ROW 1 COL 23
     proc-name AT ROW 2.75 COL 15.5 COLON-ALIGNED
     Btn_Get AT ROW 2.75 COL 74
     SPACE(1.87) SKIP(0.87)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE
         TITLE "Выполнить процедуру"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
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
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Выполнить процедуру */
DO:
    APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Get
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Get Dialog-Frame
ON CHOOSE OF Btn_Get IN FRAME Dialog-Frame
DO: /* Browse */
    DEF VAR v_os-file   AS CHAR NO-UNDO INIT "":U.
    DEF VAR ll_commit AS LOG    NO-UNDO INIT NO.

    SYSTEM-DIALOG GET-FILE v_os-file
        TITLE "Выберите процедуру для запуска"
        FILTERS
          " Все Progress-файлы (*.i *.p *.w *.r) " "*.i,*.p,*.w,*.r",
          " Только исполняемые коды (*.r) "        "*.r",
          " Только программы (*.p) "               "*.p",
          " Только диалоги (*.w) "                 "*.w",
          " Только include-файлы (*.i) "           "*.i",
          " Все файлы (*.*) "                      "*.*"
        INITIAL-FILTER 1
        DEFAULT-EXTENSION ".p"
        USE-FILENAME
        MUST-EXIST
        UPDATE ll_commit.

    IF ll_commit <> YES THEN do:
       RETURN NO-APPLY.
    end.
    IF v_os-file = PROGRAM-NAME( 1 ) THEN DO:
        BELL.
        MESSAGE "Рекурсия!" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    ASSIGN proc-name = ( IF SEARCH( v_os-file ) = ? THEN v_os-file ELSE SEARCH( v_os-file ) ).
    DISP proc-name WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* Выполнить */
DO:
    ASSIGN proc-name.
    IF proc-name = ? OR proc-name = "":U THEN DO:
        BELL.
        MESSAGE "Не задано имя процедуры!" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    IF SEARCH( proc-name ) = ? OR SEARCH( proc-name ) = "":U THEN DO:
        BELL.
        MESSAGE "Процедура ~"" + proc-name + "~" не найдена!" VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
    END.
    define variable VRcode as logical no-undo.
    define variable vKey as integer no-undo.
    define variable vtext as character no-undo.
    define variable vlogfile as character no-undo.
    define variable vCheksum as character no-undo.
    define variable vError as logical no-undo.
    VRcode = search("gbl/d-runpro.r") ne ?.
    if VRcode
    then do:
       vKey = random(1,999999999).
       define variable vAsyncHelper as class ibs.th.file.AsyncHelperth no-undo.
       vAsyncHelper = new ibs.th.file.AsyncHelperth().
       vAsyncHelper:user-passwd = "".
       vAsyncHelper:MyBachMode = no.
       vAsyncHelper:AsyncProc("utl/proc-chekproc", substitute("&1":U  +  {&delim-par}  + "&2":U + {&delim-par} + "&3":U + {&delim-par} + "&4":U + {&delim-par} + "&5":U + {&delim-par} + "&6":U + {&delim-par} + "&7":U  + {&delim-par} + "&9":U 
                                                                    , search(proc-name) ,"0", no, vKey,"","","" ),1).
       vAsyncHelper:myTimeOut = 300.
       
       vAsyncHelper:WaitFor("proc-chekproc", 1,"Проверка процедуры.").
       vtext = "Процедура имеет не правильную подпись.".
       vlogfile = vAsyncHelper:myWorkDir + "proc-chekprocerror.log".
       if vAsyncHelper:FileExists(vlogfile)
       then do:
          input stream sReadfile FROM  VALUE(vlogfile).
          repeat:
             import stream sReadfile unformatted vText.
             if vtext begins "error" 
             then assign
                vtext = substring(vtext,7)
   /*                   vError = yes*/
             .
             else do: 
                vCheksum = vText.
                
                if (vCheksum ne {utl/chekproc.i vKey})
                then assign
                   vtext = "Процедура имеет не правильную подпись."
   /*                      vError = yes*/
                .
                else
                   vError = no.
             end.    
          end.
          input stream sReadfile close  .
          os-delete value(vlogfile).
       end.
       else assign
           vtext = "Не получен результат проверки."
           vError = yes.
       vAsyncHelper:delworkdir().
       delete object vAsyncHelper.
    end.
    else
       vError = no.
    if vError
    then do:
        run trg/userlog.p (
                input 'run-proc'
                , input (substitute( "&1. Не прошла проверка подписи. &2", vss-workfile, vtext)  + {&delim-key} + proc-name )
                , input ?
                , input ?
                , input "") no-error.
           message substitute( "&1. Не прошла проверка подписи. &2", vss-workfile, vtext) 
           view-as alert-box.
       return no-apply.
    end.           
    RUN VALUE( proc-name )(input vkey
                         ,output vCheksum )no-error .
    if not error-status :error
    then do:
       run trg/userlog.p (
                input 'run-proc'
                , input ("Выполнена процедура"  + {&delim-key} + proc-name )
                , input ?
                , input ?
                , input "") no-error. 
       return.
    end.
    else if  vrcode
    then do:
       run trg/userlog.p (
                input 'run-proc'
                , input ("Не выполнена процедура"  + {&delim-key} + proc-name )
                , input ?
                , input ?
                , input "") no-error. 
       message substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( 1 ) ) 
       view-as alert-box. 
       return no-apply.
    end. 
    message "Данная процедура не запустится у клиент."
        view-as alert-box warning .
    run trg/userlog.p (
                input 'run-proc'
                , input ("Выполнена процедура"  + {&delim-key} + proc-name )
                , input ?
                , input ?
                , input "") no-error.
    RUN VALUE( proc-name ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME proc-name
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL proc-name Dialog-Frame
ON LEAVE OF proc-name IN FRAME Dialog-Frame /* Имя процедуры */
DO: /* Имя процедуры */
    ASSIGN proc-name.
    IF R-INDEX( proc-name, "." ) = 0 THEN ASSIGN proc-name = proc-name + ".p".
    IF SEARCH( proc-name ) <> ? AND SEARCH( proc-name ) <> "":U THEN DO:
        ASSIGN FILE-INFO:FILE-NAME = proc-name.
        IF FILE-INFO:FULL-PATHNAME <> ? THEN ASSIGN proc-name = FILE-INFO:FULL-PATHNAME.
        DISP proc-name WITH FRAME {&FRAME-NAME}.
    END.
    APPLY "TAB":U TO proc-name IN FRAME {&FRAME-NAME}.
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

ASSIGN
  proc-name  :TOOLTIP = "Имя выполняемой процедуры"
  Btn_Get    :TOOLTIP = "Выбор файла с процедурой, которую Вы хотите выполнить"
  Btn_OK     :TOOLTIP = "Выполнить процедуру"
  Btn_Cancel :TOOLTIP = "Выход и отказ от выполнения"
  b-help     :TOOLTIP = "Помощь"
.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  define variable l-permit as logical no-undo .

  run gbl/authoriz.p
    (input "Run procedure"
    ,output l-permit
    ).

  if l-permit <> true then do:
    undo main-block, leave main-block .
  end.

  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME} focus proc-name.
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
  DISPLAY proc-name
      WITH FRAME Dialog-Frame.
  ENABLE Btn_Cancel Btn_OK b-help proc-name Btn_Get
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
