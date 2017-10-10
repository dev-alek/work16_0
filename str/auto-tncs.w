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

Информация по секциям автоцистерн


Автор: Кривошеин Александр
Дата создания: 14/07/10
Author: Mikhail Pervakov
Creation date: 14/07/10

*/

/* ***************************  Definitions  ************************** */
/* Parameters Definitions ---                                           */
define input parameter parmode as character no-undo.
define input parameter parnum-tank as CHARACTER no-undo.
define input-output parameter parsec-num as CHARACTER no-undo.

/* Local Variable Definitions ---                                       */
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Измерение по резервуару".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/showinf.i  }

DEFINE BUFFER buf_auto-tank FOR auto-tank.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-cancel b-help 
&Scoped-Define DISPLAYED-OBJECTS varsec-num varsec-qnty varsec-min ~
varsec-max varsec-diam 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-cancel AUTO-END-KEY 
     LABEL "&Отмена" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-help 
     LABEL "Помо&щь" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-save AUTO-GO 
     LABEL "&Ввод" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE varsec-diam AS CHARACTER FORMAT "x(8)" 
     LABEL "Диаметр горловины, мм" 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE varsec-max AS DECIMAL FORMAT "->>>,>>>,>>9.999" INITIAL 0 
     LABEL "Максимальный уровень взлива, мм" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE varsec-min AS DECIMAL FORMAT "->>>,>>>,>>9.999" INITIAL 0 
     LABEL "Минимальный уровень взлива, мм" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE varsec-num AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Номер секции" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE varsec-qnty AS DECIMAL FORMAT "->>>,>>>,>>9.999" INITIAL 0 
     LABEL "Вместимость, л" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     b-save AT ROW 1 COL 1 WIDGET-ID 2
     b-cancel AT ROW 1 COL 11 WIDGET-ID 4
     b-help AT ROW 1 COL 21 WIDGET-ID 6
     varsec-num AT ROW 2.25 COL 34.5 COLON-ALIGNED WIDGET-ID 8
     varsec-qnty AT ROW 3.5 COL 34.5 COLON-ALIGNED WIDGET-ID 10
     varsec-min AT ROW 4.75 COL 34.5 COLON-ALIGNED WIDGET-ID 12
     varsec-max AT ROW 6 COL 34.5 COLON-ALIGNED WIDGET-ID 14
     varsec-diam AT ROW 7.25 COL 3.5 WIDGET-ID 16
     SPACE(0.62) SKIP(0.20)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Данные по секции"
         DEFAULT-BUTTON b-save CANCEL-BUTTON b-cancel.


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
   FRAME-NAME                                                           */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON b-save IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN varsec-diam IN FRAME Dialog-Frame
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN varsec-max IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN varsec-min IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN varsec-num IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN varsec-qnty IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Данные по секции */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-save
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-save Dialog-Frame
ON CHOOSE OF b-save IN FRAME Dialog-Frame /* Ввод */
DO:
  IF input frame {&frame-name} varsec-num <= 0 THEN DO:
    message "Номер секции указан неверно." view-as alert-box error.
    RETURN no-apply.
  END.

  if (input frame {&frame-name} varsec-qnty <> 0 OR 
      input frame {&frame-name} varsec-min <> 0 OR 
      input frame {&frame-name} varsec-max <> 0 OR 
      input frame {&frame-name} varsec-diam <> '') AND (parmode = {&add-def} or
     parmode = {&update}) then do:

     IF AVAILABLE auto-tank THEN
        IF CAN-FIND(buf_auto-tank WHERE buf_auto-tank.auto-num = parnum-tank + '#' + STRING(input frame {&frame-name} varsec-num)
                                    AND RECID(buf_auto-tank) <> RECID(auto-tank)) THEN DO:
            message "Секция с таким номером уже существует." view-as alert-box error.
            RETURN.
        END. ELSE.
     ELSE
        IF CAN-FIND(buf_auto-tank WHERE buf_auto-tank.auto-num = parnum-tank + '#' + STRING(input frame {&frame-name} varsec-num)) THEN DO:
            message "Секция с таким номером уже существует." view-as alert-box error.
            RETURN.
        END.

     IF NOT AVAILABLE auto-tank THEN DO:
        create auto-tank.
     END.
     assign
        parsec-num = STRING(input frame {&frame-name} varsec-num)
        auto-tank.auto-num = parnum-tank + '#' + STRING(input frame {&frame-name} varsec-num)
        auto-tank.brutto-qnty = input frame {&frame-name} varsec-qnty
        auto-tank.NAME = STRING(input frame {&frame-name} varsec-min) + {&delim-par} + 
                         STRING(input frame {&frame-name} varsec-max) + {&delim-par} + 
                         input frame {&frame-name} varsec-diam.
  end.
  else do :
      message "Введите данные!" view-as alert-box.
      return no-apply.
  end.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME varsec-diam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL varsec-diam Dialog-Frame
ON ANY-KEY OF varsec-diam IN FRAME Dialog-Frame /* Диаметр горловины, мм */
DO:
    IF NOT (LASTKEY >= 47 AND LASTKEY <= 57) AND NOT LASTKEY = KEYCODE("BACKSPACE") AND NOT LASTKEY = KEYCODE("TAB") THEN
        RETURN NO-APPLY.
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
  if parmode = {&lookup} then do:
    find first auto-tank where auto-tank.auto-num = parnum-tank + '#' + parsec-num NO-LOCK NO-ERROR.
  end.
  if parmode = {&update} then do:
    do transaction:
      find first auto-tank where auto-tank.auto-num = parnum-tank + '#' + parsec-num EXCLUSIVE-LOCK NO-ERROR.
    end.
  end.
  if parmode = {&add-def} then do:
    varsec-num = 0.
  end.
  ELSE varsec-num = INTEGER(parsec-num).

  if AVAILABLE auto-tank AND
     (parmode = {&lookup} or
      parmode = {&update}) then do:
    assign
      varsec-qnty   = auto-tank.brutto-qnty
      varsec-min    = DECIMAL(ENTRY(1, auto-tank.NAME, {&delim-par}))
      varsec-max    = DECIMAL(ENTRY(2, auto-tank.NAME, {&delim-par}))
      varsec-diam   = ENTRY(3, auto-tank.NAME, {&delim-par})
      .
  END.
  ELSE DO:
      assign
        varsec-qnty   = 0
        varsec-min    = 0
        varsec-max    = 0
        varsec-diam   = ''
        .
  END.
  RUN local-enable_UI.
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
  DISPLAY varsec-num varsec-qnty varsec-min varsec-max varsec-diam 
      WITH FRAME Dialog-Frame.
  ENABLE b-cancel b-help 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable_UI Dialog-Frame 
PROCEDURE local-enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN enable_ui.
  if parmode = {&add-def} or
     parmode = {&update} then do:
     enable varsec-num varsec-qnty varsec-max varsec-min varsec-diam b-save with frame {&frame-name}.
  end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

