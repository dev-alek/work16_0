&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases
          ub               PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Справочник автоцистерн

Автор: Уханов Дмитрий Юрьевич
Дата создания: 08/16/07
Author: Dmitry Ukhanov
Creation date: 08/16/07

Автор1: Перваков Михаил Сергеевич
Дата создания1: 04/11/06

*/

/* ***************************  Definitions  ************************** */
/* Parameters Definitions ---                                           */
define input  parameter parparentproc as widget-handle no-undo.
define input  parameter parbuttons  as character no-undo.
define input  parameter par-obj-type as character no-undo.
define input  parameter par-obj-code as integer no-undo.
define output parameter parrec-tank as recid     no-undo.
define output parameter parrec-meas as recid     no-undo.


/* Local Variable Definitions ---                                       */
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Справочник автоцистерн".
{ cmp/vssrevis.i }
{ cmp/showinf.i  }
{ cmp/str-glbl.i }
define variable v-auto-firm as character no-undo format "x(14)":U.
define variable varauto-tank-rec as recid no-undo.
define variable varauto-meas-rec as recid no-undo.
assign parrec-tank      = ?
       parrec-meas      = ?
       varauto-tank-rec = ?
       varauto-meas-rec = ?.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME brw-auto-meas

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ub.auto-tank-meas ub.auto-tank ub.auto-tank-attr

/* Definitions for BROWSE brw-auto-meas                                 */
&Scoped-define FIELDS-IN-QUERY-brw-auto-meas ub.auto-tank-meas.meas-label ~
ub.auto-tank-meas.meas-qnty
&Scoped-define ENABLED-FIELDS-IN-QUERY-brw-auto-meas
&Scoped-define QUERY-STRING-brw-auto-meas FOR EACH ub.auto-tank-meas ~
      WHERE ub.auto-tank-meas.auto-num = ub.auto-tank.auto-num NO-LOCK
&Scoped-define OPEN-QUERY-brw-auto-meas OPEN QUERY brw-auto-meas FOR EACH ub.auto-tank-meas ~
      WHERE ub.auto-tank-meas.auto-num = ub.auto-tank.auto-num NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brw-auto-meas ub.auto-tank-meas
&Scoped-define FIRST-TABLE-IN-QUERY-brw-auto-meas ub.auto-tank-meas


/* Definitions for BROWSE brw-auto-tank                                 */
&Scoped-define FIELDS-IN-QUERY-brw-auto-tank ub.auto-tank.auto-num ~
ub.auto-tank.name ub.auto-tank.brutto-qnty get-auto-firm (buffer auto-tank) @ v-auto-firm
&Scoped-define ENABLED-FIELDS-IN-QUERY-brw-auto-tank
&Scoped-define QUERY-STRING-brw-auto-tank FOR EACH ub.auto-tank NO-LOCK
&Scoped-define OPEN-QUERY-brw-auto-tank OPEN QUERY brw-auto-tank FOR EACH ub.auto-tank NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brw-auto-tank ub.auto-tank
&Scoped-define FIRST-TABLE-IN-QUERY-brw-auto-tank ub.auto-tank

/* Definitions for BROWSE brw-auto-tank-2                                 */
&Scoped-define FIELDS-IN-QUERY-brw-auto-tank-2 ub.auto-tank.auto-num ~
ub.auto-tank.name ub.auto-tank.brutto-qnty ub.auto-tank-attr.attr-value
&Scoped-define ENABLED-FIELDS-IN-QUERY-brw-auto-tank-2
&Scoped-define QUERY-STRING-brw-auto-tank-2 FOR EACH ub.auto-tank NO-LOCK,~
                                          first auto-tank-attr no-lock where auto-tank-attr.attr-code = "auto-firm"~
                                                                    and auto-tank-attr.attr-value = par-obj-type + string(par-obj-code)~
                                                                    and auto-tank-attr.auto-num = ub.auto-tank.auto-num
&Scoped-define OPEN-QUERY-brw-auto-tank-2 OPEN QUERY brw-auto-tank-2 FOR EACH ub.auto-tank NO-LOCK,~
                                          first auto-tank-attr no-lock where auto-tank-attr.attr-code = "auto-firm"~
                                                                    and auto-tank-attr.attr-value = par-obj-type + string(par-obj-code)~
                                                                    and auto-tank-attr.auto-num = ub.auto-tank.auto-num
&Scoped-define TABLES-IN-QUERY-brw-auto-tank-2 ub.auto-tank ub.auto-tank-attr
&Scoped-define FIRST-TABLE-IN-QUERY-brw-auto-tank-2 ub.auto-tank
&Scoped-define SECOND-TABLE-IN-QUERY-brw-auto-tank-2 ub.auto-tank-attr


/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Dialog-Frame ~
    ~{&OPEN-QUERY-brw-auto-meas}~
    ~{&OPEN-QUERY-brw-auto-tank}~
/*    ~{&OPEN-QUERY-brw-auto-tank-2}*/

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-exit b-view b-help brw-auto-tank varps ~
b-view-meas brw-auto-meas varps-meas
&Scoped-Define DISPLAYED-OBJECTS varps varps-meas

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD get-action-role-context Dialog-Frame
FUNCTION get-auto-firm RETURNS CHARACTER
  ( BUFFER buf_auto-tank FOR auto-tank )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-add
     LABEL "&Добавить"
     SIZE 10 BY 1.

DEFINE BUTTON b-add-meas
     LABEL "Д&обавить"
     SIZE 10 BY 1.

DEFINE BUTTON b-chg
     LABEL "&Изменить"
     SIZE 10 BY 1.

DEFINE BUTTON b-chg-meas
     LABEL "И&зменить"
     SIZE 10 BY 1.

DEFINE BUTTON b-exit AUTO-END-KEY
     LABEL "&Выход"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-help
     LABEL "&Помощь"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-sel AUTO-GO
     LABEL "&Выбор"
     SIZE 10 BY 1.

DEFINE BUTTON b-sel-meas AUTO-GO
     LABEL "&Выбор"
     SIZE 10 BY 1.

DEFINE BUTTON b-view
     LABEL "&Просмотр"
     SIZE 10 BY 1.

DEFINE BUTTON b-view-meas
     LABEL "П&росмотр"
     SIZE 10 BY 1.

DEFINE VARIABLE varps AS CHARACTER
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 76 BY 2.25
     BGCOLOR 8  DROP-TARGET NO-UNDO.

DEFINE VARIABLE varps-meas AS CHARACTER
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 49.5 BY 3.25
     BGCOLOR 8  DROP-TARGET NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brw-auto-meas FOR
      ub.auto-tank-meas SCROLLING.

DEFINE QUERY brw-auto-tank FOR
      ub.auto-tank SCROLLING.
&ANALYZE-RESUME

DEFINE QUERY brw-auto-tank-2 FOR
      ub.auto-tank,
      ub.auto-tank-attr SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brw-auto-meas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brw-auto-meas Dialog-Frame _STRUCTURED
  QUERY brw-auto-meas DISPLAY
      ub.auto-tank-meas.meas-label FORMAT "X(30)":U
      ub.auto-tank-meas.meas-qnty FORMAT "->>>,>>>,>>9.999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 49.5 BY 4.5.

DEFINE BROWSE brw-auto-tank
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brw-auto-tank Dialog-Frame _STRUCTURED
  QUERY brw-auto-tank DISPLAY
      ub.auto-tank.auto-num FORMAT "X(20)":U
      ub.auto-tank.name FORMAT "X(40)":U
      ub.auto-tank.brutto-qnty FORMAT "->>,>>>,>>9.<<<":U
      get-auto-firm (BUFFER auto-tank) @ v-auto-firm column-label "Автопредприятие" format "x(14)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 76 BY 5.96.

DEFINE BROWSE brw-auto-tank-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brw-auto-tank-2 Dialog-Frame _STRUCTURED
  QUERY brw-auto-tank-2 DISPLAY
      ub.auto-tank.auto-num FORMAT "X(20)":U
      ub.auto-tank.name FORMAT "X(40)":U
      ub.auto-tank.brutto-qnty FORMAT "->>,>>>,>>9.<<<":U
      ub.auto-tank-attr.attr-value column-label "Автопредприятие" format "x(14)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 76 BY 5.96.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     b-exit AT ROW 1 COL 2
     b-sel AT ROW 1 COL 12
     b-add AT ROW 1 COL 22
     b-chg AT ROW 1 COL 32
     b-view AT ROW 1 COL 42
     b-help AT ROW 1 COL 68
     brw-auto-tank AT ROW 2 COL 2
     brw-auto-tank-2 AT ROW 2 COL 2
     varps AT ROW 8 COL 2 NO-LABEL
     b-sel-meas AT ROW 10.75 COL 2
     b-add-meas AT ROW 10.75 COL 12
     b-chg-meas AT ROW 10.75 COL 22
     b-view-meas AT ROW 10.75 COL 32
     brw-auto-meas AT ROW 11.75 COL 2
     varps-meas AT ROW 16.25 COL 2 NO-LABEL
     SPACE(27.37) SKIP(0.28)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE
         TITLE "Справочник автоцистерн"
         CANCEL-BUTTON b-exit.


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
/* BROWSE-TAB brw-auto-tank b-help Dialog-Frame */
/* BROWSE-TAB brw-auto-meas b-view-meas Dialog-Frame */
ASSIGN
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON b-add IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b-add-meas IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b-chg IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b-chg-meas IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b-sel IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b-sel-meas IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
ASSIGN
       varps:READ-ONLY IN FRAME Dialog-Frame        = TRUE.

ASSIGN
       varps-meas:READ-ONLY IN FRAME Dialog-Frame        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brw-auto-meas
/* Query rebuild information for BROWSE brw-auto-meas
     _TblList          = "ub.auto-tank-meas"
     _Where[1]         = "ub.auto-tank-meas.auto-num = ub.auto-tank.auto-num"
     _FldNameList[1]   = ub.auto-tank-meas.meas-label
     _FldNameList[2]   = ub.auto-tank-meas.meas-qnty
     _Query            is OPENED
*/  /* BROWSE brw-auto-meas */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brw-auto-tank
/* Query rebuild information for BROWSE brw-auto-tank
     _TblList          = "ub.auto-tank"
     _FldNameList[1]   = ub.auto-tank.auto-num
     _FldNameList[2]   = ub.auto-tank.name
     _FldNameList[3]   = ub.auto-tank.brutto-qnty
     _Query            is OPENED
*/  /* BROWSE brw-auto-tank */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Справочник автоцистерн */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-add Dialog-Frame
ON CHOOSE OF b-add IN FRAME Dialog-Frame /* Добавить */
DO:
  assign
    varauto-tank-rec = ?
  .
  run str/auto-tnc.w
    ( input parparentproc
     ,input {&add-def}
     ,input-output varauto-tank-rec
    ) no-error.
  run local-enable_ui.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-add-meas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-add-meas Dialog-Frame
ON CHOOSE OF b-add-meas IN FRAME Dialog-Frame /* Добавить */
DO:
if available ub.auto-tank then do:
 assign
   varauto-tank-rec = recid (ub.auto-tank)
   varauto-meas-rec = ?.
  run str/auto-tnm.w
    ( input {&add-def}
     ,input varauto-tank-rec
     ,input-output varauto-meas-rec
    ).
  run local-enable_ui.
end.
else do:
  message "Не выбрана автоцистерна." view-as alert-box error.
end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-chg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-chg Dialog-Frame
ON CHOOSE OF b-chg IN FRAME Dialog-Frame /* Изменить */
DO:
  if available ub.auto-tank then do:
    assign
      varauto-tank-rec = recid(ub.auto-tank)
    .
    run str/auto-tnc.w
      (input parparentproc
       ,input {&update}
       ,input-output varauto-tank-rec
      ) no-error.
    run local-enable_ui.
  end.
  else do:
    message "Не выбрана автоцистерна." view-as alert-box error.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-chg-meas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-chg-meas Dialog-Frame
ON CHOOSE OF b-chg-meas IN FRAME Dialog-Frame /* Изменить */
DO:
  if available ub.auto-tank then do:
    if available ub.auto-tank-meas then do:
      assign
        varauto-tank-rec = recid(ub.auto-tank)
        varauto-meas-rec = recid(ub.auto-tank-meas)
      .
      run str/auto-tnm.w
        ( input        {&update}
         ,input        varauto-tank-rec
         ,input-output varauto-meas-rec
        ) no-error.
      run local-enable_ui.
    end.
    else do:
      message "Не выбрано измерение по автоцистерне." view-as alert-box error.
    end.
  end.
  else do:
    message "Не выбрана автоцистерна." view-as alert-box error.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-sel Dialog-Frame
ON CHOOSE OF b-sel IN FRAME Dialog-Frame /* Выбор */
DO:
  if available ub.auto-tank then do:
    assign
      parrec-tank = recid(ub.auto-tank)
      parrec-meas = ?.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-sel-meas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-sel-meas Dialog-Frame
ON CHOOSE OF b-sel-meas IN FRAME Dialog-Frame /* Выбор */
DO:
 if available ub.auto-tank-meas then do:
   assign
      parrec-tank = recid(ub.auto-tank)
      parrec-meas = recid(ub.auto-tank-meas).
 end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-view
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-view Dialog-Frame
ON CHOOSE OF b-view IN FRAME Dialog-Frame /* Просмотр */
DO:
  if available ub.auto-tank then do:
    assign
      varauto-tank-rec = recid(ub.auto-tank).
    run str/auto-tnc.w (input parparentproc,input {&lookup}, input-output varauto-tank-rec) no-error.
  end.
  else do:
    message "Не выбрана автоцистерна." view-as alert-box error.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-view-meas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-view-meas Dialog-Frame
ON CHOOSE OF b-view-meas IN FRAME Dialog-Frame /* Просмотр */
DO:
  if available ub.auto-tank then do:
    if available ub.auto-tank-meas then do:
    assign
      varauto-tank-rec = recid(ub.auto-tank)
      varauto-meas-rec = recid(ub.auto-tank-meas).
    run str/auto-tnm.w (input {&lookup},
                    input varauto-tank-rec,
                    input-output varauto-meas-rec) no-error.
    end.
    else do:
      message "Не выбрано измерение по автоцистерне." view-as alert-box error.
    end.
  end.
  else do:
    message "Не выбрана автоцистерна." view-as alert-box.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brw-auto-meas
&Scoped-define SELF-NAME brw-auto-meas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brw-auto-meas Dialog-Frame
ON VALUE-CHANGED OF brw-auto-meas IN FRAME Dialog-Frame
DO:
  if available ub.auto-tank-meas then do:
    assign
      varps-meas = ub.auto-tank-meas.ps
    .
  end.
  else do:
    assign
      varps-meas = "":U
    .
  end.
  display
    varps-meas
    with frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brw-auto-tank
&Scoped-define SELF-NAME brw-auto-tank
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brw-auto-tank Dialog-Frame
ON VALUE-CHANGED OF brw-auto-tank IN FRAME Dialog-Frame
DO:
  if available ub.auto-tank then do:
    assign
      varps = ub.auto-tank.ps
    .
  end.
  else do:
    assign
      varps = "":U
    .
  end.
  display
    varps
    with frame {&frame-name}
  .
  {&OPEN-QUERY-brw-auto-meas}
  apply "value-changed" to brw-auto-meas in frame dialog-frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define BROWSE-NAME brw-auto-tank-2
&Scoped-define SELF-NAME brw-auto-tank-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brw-auto-tank-2 Dialog-Frame
ON VALUE-CHANGED OF brw-auto-tank-2 IN FRAME Dialog-Frame
DO:
  if available ub.auto-tank then do:
    assign
      varps = ub.auto-tank.ps
    .
  end.
  else do:
    assign
      varps = "":U
    .
  end.
  display
    varps
    with frame {&frame-name}
  .
  {&OPEN-QUERY-brw-auto-meas}
  apply "value-changed" to brw-auto-meas in frame dialog-frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&Scoped-define BROWSE-NAME brw-auto-meas
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
  DISPLAY varps varps-meas
      WITH FRAME Dialog-Frame.
  ENABLE b-exit b-view b-help brw-auto-tank varps b-view-meas brw-auto-meas
         varps-meas
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
  RUN enable_ui IN THIS-PROCEDURE.
  if varauto-tank-rec <> ? then do:
    reposition brw-auto-tank to recid varauto-tank-rec.
    if varauto-meas-rec <> ? then do:
      reposition brw-auto-meas to recid varauto-meas-rec.
    end.
  end.
  if lookup ("b-sel", parbuttons) > 0 then do:
    enable b-sel b-sel-meas with frame {&frame-name}.
  end.
  if lookup ("b-add", parbuttons) > 0 then do:
    enable b-add b-add-meas with frame {&frame-name}.
  end.
  if lookup ("b-chg", parbuttons) > 0 then do:
    enable b-chg b-chg-meas with frame {&frame-name}.
  end.
  apply "value-changed" to brw-auto-meas in frame dialog-frame.
  apply "value-changed" to brw-auto-tank in frame dialog-frame.
  disable brw-auto-tank-2 WITH FRAME {&frame-name}.
  brw-auto-tank-2:visible = false.
  display brw-auto-tank WITH FRAME {&frame-name}.
  /* Code placed here will execute AFTER standard behavior.    */
  if par-obj-type <> "" and par-obj-code <> 0 then do :
    brw-auto-tank:visible = false .
    brw-auto-tank-2:visible = true.
    enable brw-auto-tank-2 WITH FRAME Dialog-Frame.
    {&OPEN-QUERY-brw-auto-tank-2}.
    if varauto-tank-rec <> ? then do:
      reposition brw-auto-tank-2 to recid varauto-tank-rec.
      if varauto-meas-rec <> ? then do:
        reposition brw-auto-meas to recid varauto-meas-rec.
      end.
    end.
  end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION get-action-role-context Dialog-Frame
FUNCTION get-auto-firm RETURNS CHARACTER
  ( BUFFER buf_auto-tank FOR ub.auto-tank ) :
/*------------------------------------------------------------------------------
   Purpose:
    Notes:
------------------------------------------------------------------------------*/

  define variable v-return-value as character no-undo .
  find first ub.auto-tank-attr no-lock where ub.auto-tank-attr.attr-code = "auto-firm"
                                         and ub.auto-tank-attr.auto-num = ub.auto-tank.auto-num  no-error.
  if available ub.auto-tank-attr then do :
    v-return-value = ub.auto-tank-attr.attr-value.
  end.
  else do :
    v-return-value = "".
  end.
  return v-return-value .

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
