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

Создание и редактирование типов алкогол

Автор: Белоусов Илья Александрович
Дата создания:
Author: Ilia Belousov
Creation date:

*/

define input  parameter parParentProc  as widget-handle no-undo.
define input  parameter p-def          as character no-undo.
define input-output parameter  p-rr    as recid no-undo.


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Создание и редактирование типов алкогол" .

{ cmp/vssrevis.i }
{ cmp/showinf.i  }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ gbl/getcntxt.i def }


define buffer buf_alc-type for ub.alc-type .
{ gbl/getcntxt.i get }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-exit b-quit B-Help v-name v-code ~
v-inner-code
&Scoped-Define DISPLAYED-OBJECTS v-name v-code v-inner-code

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-exit AUTO-GO
     LABEL "&Ввод"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON B-Help
     LABEL "&Помощь"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-quit AUTO-END-KEY
     LABEL "&Отмена"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE v-code AS CHARACTER FORMAT "x(8)":U
     LABEL "Код"
     VIEW-AS FILL-IN
     SIZE 8.9 BY 1 NO-UNDO.

DEFINE VARIABLE v-inner-code AS INTEGER FORMAT ">>>9":U INITIAL 0
     LABEL "Код внут."
      VIEW-AS TEXT
     SIZE 14 BY .67
     FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE v-name AS CHARACTER FORMAT "X(80)":U
     LABEL "Название"
     VIEW-AS FILL-IN
     SIZE 80 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     b-exit AT ROW 1 COL 1
     b-quit AT ROW 1 COL 11
     B-Help AT ROW 1 COL 83.5
     v-name AT ROW 3.13 COL 11.5 COLON-ALIGNED
     v-code AT ROW 4.2 COL 11.5 COLON-ALIGNED
     v-inner-code AT ROW 2.33 COL 11.5 COLON-ALIGNED
     SPACE(66.49) SKIP(2.66)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE
         TITLE " видов алкоголя"
         DEFAULT-BUTTON b-exit CANCEL-BUTTON b-quit.


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

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /*  типов алкоголя */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-exit Dialog-Frame
ON CHOOSE OF b-exit IN FRAME Dialog-Frame /* Ввод */
DO:
   Assign /*frame {&frame-name}*/
      v-inner-code
      v-code
      v-name
   .

   if p-def = {&add-def} then do:
      FIND FIRST buf_alc-type WHERE buf_alc-type.alc-type-code   = v-code
                                AND buf_alc-type.alc-type-status = 0
                              NO-LOCK
                              NO-ERROR
                              .
      IF AVAILABLE buf_alc-type
      THEN DO:
         MESSAGE "Введенный код вида алкоголя уже существует" buf_alc-type.alc-type-name " ! " VIEW-AS  ALERT-BOX  ERROR.
         APPLY "entry"  TO v-code .
         RETURN NO-APPLY.
      END.
   END. /* {&add-def} */

   if p-def = {&add-def} OR p-def = {&update}  then DO:
      if v-name = "" then do:
         message "Введите название вида алкоголя! "
         view-as  alert-box  error.
         apply "entry"  to v-name .
         return no-apply.
      end.

      if v-code = "" then do:
         message "Введите код вида алкоголя! "
         view-as  alert-box  error.
         apply "entry"  to v-code .
         return no-apply.
      end.

      if p-def = {&add-def} then do:
         v-inner-code = next-value ( s-alc-type , {&db-name_schema}).
         create buf_alc-type.
         Assign
            buf_alc-type.alc-type-inner-code = v-inner-code
            buf_alc-type.create-user-db-num  = v-cntxt-db-num
            buf_alc-type.create-date         = TODAY
            buf_alc-type.create-time         = TIME
            buf_alc-type.create-user-db-num  = v-cntxt-db-num
            buf_alc-type.create-user         = v-cntxt-userid
            p-rr                             = recid(buf_alc-type)
         .
      end.

      Assign
         buf_alc-type.alc-type-name  = v-name
         buf_alc-type.alc-type-code  = v-code
         buf_alc-type.corr-date      = TODAY
         buf_alc-type.corr-time      = TIME
         buf_alc-type.corr-user-name = v-cntxt-userid
      .
   END. /* {&add-def} OR {&update} */
END. /* ON CHOOSE OF b-exit */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.
{ gbl/app_help.i }

assign frame {&frame-name}:title = p-def + " вида алкоголя  " .

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  run local-init in this-procedure.
  run enable_UI in this-procedure .

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
run disable_UI in this-procedure .

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
  DISPLAY v-name v-code v-inner-code
      WITH FRAME Dialog-Frame.
  ENABLE b-exit b-quit B-Help v-name v-code v-inner-code
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-init Dialog-Frame
PROCEDURE local-init :
if Lookup(p-def, {&add-def} + "," + {&Lookup} + "," +  {&update})  = 0 then DO:
      return error.
   end.

   if p-def = {&update} then do:
      find first buf_alc-type
            where recid(buf_alc-type) = p-rr
            exclusive-lock
            no-error .
      if not available buf_alc-type then do:
         return error.
      end.
   end.
   if p-def = {&lookup} then do:
      find first buf_alc-type
            where recid(buf_alc-type) = p-rr
            no-lock
            no-error .
         if not available buf_alc-type then DO:
            return error.
         end.
   end.
   if available buf_alc-type then do:
      assign
         v-inner-code = buf_alc-type.alc-type-inner-code
         v-name       = buf_alc-type.alc-type-name
         v-code       = buf_alc-type.alc-type-code
         /*!!!*/
         .
   end.
   else do:
      if p-def = {&add-def} then do:
      /*???
         v-inner-code = next-value ( s-alc-type ).
      */
      end.
   end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
