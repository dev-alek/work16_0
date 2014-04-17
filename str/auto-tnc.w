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

Данные по автоцистерне

Автор: Уханов Дмитрий Юрьевич
Дата создания: 08/16/07
Author: Dmitry Ukhanov
Creation date: 08/16/07

Автор1: Перваков Михаил Сергеевич
Дата создания1: 04/11/06

*/

/* ***************************  Definitions  ************************** */
/* Parameters Definitions ---                                           */
define input parameter parparentproc as widget-handle no-undo.
define input parameter parmode as character no-undo.
define input-output parameter parrecid as recid no-undo.

/* Local Variable Definitions ---                                       */
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Данные по автоцистерне".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/showinf.i  }

define variable ref-list as character no-undo.
define variable v-af-obj-code like ub.clients.obj-code no-undo.
define variable v-af-obj-type like ub.clients.obj-type no-undo.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-cancel b-help b-choose-auto-firm varPS
&Scoped-Define DISPLAYED-OBJECTS varauto-num varname varbrutto-qnty ~
varauto-firm varPS

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

DEFINE BUTTON b-choose-auto-firm
     IMAGE-UP FILE "btn-down-arrow":U
     IMAGE-DOWN FILE "btn-down-arrow":U
     IMAGE-INSENSITIVE FILE "btn-down-arrow":U
     LABEL "b-choose-auto-firm"
     SIZE 3 BY .88.

DEFINE BUTTON b-help
     LABEL "&Помощь"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-save AUTO-GO
     LABEL "&Ввод"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE varPS AS CHARACTER
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 42.13 BY 2.88 DROP-TARGET NO-UNDO.

DEFINE VARIABLE varauto-firm AS CHARACTER FORMAT "X(256)"
     LABEL "Автопредприятие"
     VIEW-AS FILL-IN
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE varauto-num AS CHARACTER FORMAT "X(20)"
     LABEL "Номер машины"
     VIEW-AS FILL-IN
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE varbrutto-qnty AS DECIMAL FORMAT "->>,>>>,>>9.<<<" INITIAL 0
     LABEL "Вместимость"
     VIEW-AS FILL-IN
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE varname AS CHARACTER FORMAT "X(40)"
     LABEL "Название"
     VIEW-AS FILL-IN
     SIZE 42 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     b-save AT ROW 1 COL 1
     b-cancel AT ROW 1 COL 11
     b-help AT ROW 1 COL 21
     varauto-num AT ROW 2.54 COL 13.5 COLON-ALIGNED
     varname AT ROW 3.67 COL 13.38 COLON-ALIGNED
     varbrutto-qnty AT ROW 4.88 COL 13.38 COLON-ALIGNED
     varauto-firm AT ROW 6.25 COL 16.5 COLON-ALIGNED WIDGET-ID 2
     b-choose-auto-firm AT ROW 6.25 COL 30 WIDGET-ID 4
     varPS AT ROW 7.5 COL 15.13 NO-LABEL
     "Примечание" VIEW-AS TEXT
          SIZE 11.88 BY .88 AT ROW 7.63 COL 2.75
     SPACE(43.86) SKIP(2.15)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE
         TITLE "Данные по автоцистерне"
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
/* SETTINGS FOR FILL-IN varauto-firm IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
ASSIGN
       varauto-firm:READ-ONLY IN FRAME Dialog-Frame        = TRUE.

/* SETTINGS FOR FILL-IN varauto-num IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN varbrutto-qnty IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN varname IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
ASSIGN
       varPS:RETURN-INSERTED IN FRAME Dialog-Frame  = TRUE
       varPS:READ-ONLY IN FRAME Dialog-Frame        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Данные по автоцистерне */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-choose-auto-firm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-choose-auto-firm Dialog-Frame
ON CHOOSE OF b-choose-auto-firm IN FRAME Dialog-Frame /* b-choose-auto-firm */
DO:
  run ref/cli-all.w
  ( parparentproc
    , input  "b-sel"
    , ?
    , ?
    , ?
    , ?
    , ?
    , ?
  ,output ref-list
  ).
  If ref-list <> "" then do :
    find first ub.clients no-lock
         where recid(ub.clients) = integer(ref-list) no-error.
    if available ub.clients then do :
      varauto-firm = ub.clients.obj-type + string(ub.clients.obj-code) .
    end.
  end.
  else do :
    varauto-firm = "".
  end.
  display varauto-firm WITH FRAME Dialog-Frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-save
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-save Dialog-Frame
ON CHOOSE OF b-save IN FRAME Dialog-Frame /* Ввод */
DO:
  if parmode = {&add-def} then do:
    create ub.auto-tank.
    assign parrecid = recid(ub.auto-tank).
  end.
  if parmode = {&add-def} or
     parmode = {&update} then do:
     assign
       ub.auto-tank.auto-num    = input frame {&frame-name} varauto-num
       ub.auto-tank.name        = input frame {&frame-name} varname
       ub.auto-tank.brutto-qnty = input frame {&frame-name} varbrutto-qnty
       ub.auto-tank.ps          = input frame {&frame-name} varps
.
  end.
  if parmode = {&add-def} then do :
    if varauto-firm <> "" then do :
      create ub.auto-tank-attr.
      assign
        ub.auto-tank-attr.auto-num  = ub.auto-tank.auto-num
        ub.auto-tank-attr.attr-code = "auto-firm"
        ub.auto-tank-attr.attr-value = input frame {&frame-name} varauto-firm
      .
    end.
  end.
  if parmode = {&update} then do:
    if varauto-firm <> "" then do :
      if available ub.auto-tank-attr then ub.auto-tank-attr.attr-value = input frame {&frame-name} varauto-firm .
      else do :
        create ub.auto-tank-attr.
        assign
          ub.auto-tank-attr.auto-num  = ub.auto-tank.auto-num
          ub.auto-tank-attr.attr-code = "auto-firm"
          ub.auto-tank-attr.attr-value = input frame {&frame-name} varauto-firm
        .
      end.
    end.
    else do :
      if available ub.auto-tank-attr then delete ub.auto-tank-attr.
    end.
  end.
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
    find first ub.auto-tank where recid(ub.auto-tank) = parrecid no-lock.
    find first ub.auto-tank-attr no-lock
         where ub.auto-tank-attr.auto-num = ub.auto-tank.auto-num
           and ub.auto-tank-attr.attr-code = "auto-firm" no-error.
  end.
  if parmode = {&update} then do:
    do transaction:
      find first ub.auto-tank where recid(ub.auto-tank) = parrecid exclusive-lock.
      find first ub.auto-tank-attr exclusive-lock
          where ub.auto-tank-attr.auto-num = ub.auto-tank.auto-num
            and ub.auto-tank-attr.attr-code = "auto-firm" no-error.
    end.
  end.
  if parmode = {&lookup} or
     parmode = {&update} then do:
    assign
      varauto-num    = ub.auto-tank.auto-num
      varname        = ub.auto-tank.name
      varbrutto-qnty = ub.auto-tank.brutto-qnty
      varps          = ub.auto-tank.ps.
    if available ub.auto-tank-attr then varauto-firm = ub.auto-tank-attr.attr-value.
  end.
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
  DISPLAY varauto-num varname varbrutto-qnty varauto-firm varPS
      WITH FRAME Dialog-Frame.
  ENABLE b-cancel b-help b-choose-auto-firm varPS
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
     enable varauto-num varname varbrutto-qnty varauto-firm b-save with frame {&frame-name}.
     assign varps:read-only = no.
  end.


  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
