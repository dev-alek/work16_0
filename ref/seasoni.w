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

Корректировка сезона

Автор: Чернова Светлана Александровна
Дата создания: 03/19/02
Author: Svetlana Chernova
Creation date: 03/19/02

*/

define input  parameter parParentProc  as widget-handle no-undo.
define input  parameter p-def          as character no-undo.
define input-output parameter  rr      as recid no-undo.


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Корректировка сезона" .

{ cmp/vssrevis.i }
{ cmp/showinf.i  }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ gbl/getcntxt.i def }


define buffer buf1_season for ub.season .
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
&Scoped-Define ENABLED-OBJECTS B-OK B-Cancel B-Help loc-name loc-month-1 ~
loc-month-2 loc-code
&Scoped-Define DISPLAYED-OBJECTS loc-name loc-month-1 loc-month-2 loc-code

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-Cancel AUTO-END-KEY
     LABEL "&Отмена"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON B-Help
     LABEL "&Помощь"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON B-OK AUTO-GO
     LABEL "&Ввод"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE loc-month-1 AS INTEGER FORMAT ">>9":U INITIAL 1
     LABEL "с"
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "1","2","3","4","5","6","7","8","9","10","11","12"
     DROP-DOWN-LIST
     SIZE 6.88 BY 1 NO-UNDO.

DEFINE VARIABLE loc-month-2 AS INTEGER FORMAT ">>9":U INITIAL 1
     LABEL "по"
     VIEW-AS COMBO-BOX INNER-LINES 12
     LIST-ITEMS "1","2","3","4","5","6","7","8","9","10","11","12"
     DROP-DOWN-LIST
     SIZE 6.88 BY 1 NO-UNDO.

DEFINE VARIABLE loc-code AS INTEGER FORMAT ">>>>>>>>>9":U INITIAL 0
     LABEL "Код"
      VIEW-AS TEXT
     SIZE 14 BY .67
     FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE loc-name AS CHARACTER FORMAT "X(256)":U
     LABEL "Название"
     VIEW-AS FILL-IN
     SIZE 47.13 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     B-OK AT ROW 1 COL 1
     B-Cancel AT ROW 1 COL 11
     B-Help AT ROW 1 COL 21
     loc-name AT ROW 4.5 COL 11.25 COLON-ALIGNED
     loc-month-1 AT ROW 5.79 COL 11 COLON-ALIGNED
     loc-month-2 AT ROW 5.83 COL 23.13 COLON-ALIGNED
     loc-code AT ROW 3.5 COL 11.25 COLON-ALIGNED
     SPACE(38.74) SKIP(4.86)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE
         TITLE "Сезон"
         DEFAULT-BUTTON B-OK CANCEL-BUTTON B-Cancel.


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
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Сезон */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-OK Dialog-Frame
ON CHOOSE OF B-OK IN FRAME Dialog-Frame /* Ввод */
DO:
  Assign frame {&frame-name}
  loc-code loc-month-1 loc-month-2 loc-name.
  if loc-month-1 > loc-month-2 Then do:
     message "В интервале месяцов первый должен быть меньше второго ! " view-as  alert-box  error.
      apply "entry"  to loc-month-1 .
      return no-apply.
     end.
  if p-def = {&add-def} then do:
  if can-find( first buf1_season where
      buf1_season.sea-month-1 <= loc-month-1 and
      buf1_season.sea-month-2 >= loc-month-1 no-lock  ) then do:
      find first buf1_season where
      buf1_season.sea-month-1 <= loc-month-1 and
      buf1_season.sea-month-2 >= loc-month-1 no-lock  no-error .
      message "Введенный интервал пересекается с уже существующем сезоном " buf1_season.sea-name " ! " view-as  alert-box  error.
      apply "entry"  to loc-month-1 .
      return no-apply.
      end.

  if can-find( first buf1_season where
      buf1_season.sea-month-1 <= loc-month-2 and
      buf1_season.sea-month-2 >= loc-month-2 no-lock  ) then do:
      find first buf1_season where
      buf1_season.sea-month-1 <= loc-month-2 and
      buf1_season.sea-month-2 >= loc-month-2 no-lock  no-error .
      message "Введенный интервал пересекается с уже существующем сезоном " buf1_season.sea-name " ! " view-as  alert-box  error.
      apply "entry"  to loc-month-2 .
      return no-apply.
      end.


  if can-find( first buf1_season where
      buf1_season.sea-month-1 >= loc-month-1 and
      buf1_season.sea-month-2 <= loc-month-2 no-lock  ) then do:
      find first buf1_season where
      buf1_season.sea-month-1 >= loc-month-1 and
      buf1_season.sea-month-2 <= loc-month-2 no-lock  no-error .
      message "Введенный интервал пересекается с уже существующем сезоном " buf1_season.sea-name " ! " view-as  alert-box  error.
      apply "entry"  to loc-month-1 .
      return no-apply.
      end.
    end.

    if loc-name = "" then do:
      message "Введите название сезона ! " view-as  alert-box  error.
      apply "entry"  to loc-name .
      return no-apply.
      end.


    if p-def = {&add-def} then do:
       create ub.season.
       Assign
         ub.season.sea-code = loc-code
         ub.season.db-num   = v-cntxt-db-num
         .
    end.

    if p-def = {&add-def} OR p-def = {&update}  then
       Assign
        ub.season.sea-name = loc-name
        ub.season.sea-month-1 = loc-month-1
        ub.season.sea-month-2 = loc-month-2
        rr = recid(ub.season)
        .
    else rr = ? .

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

assign frame {&frame-name}:title = "Сезон - " + p-def.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  run local-init in this-procedure  no-error .
      if error-status :error then return error.
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
  DISPLAY loc-name loc-month-1 loc-month-2 loc-code
      WITH FRAME Dialog-Frame.
  ENABLE B-OK B-Cancel B-Help loc-name loc-month-1 loc-month-2 loc-code
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-init Dialog-Frame
PROCEDURE local-init :
if Lookup(p-def, {&add-def} + "," + {&Lookup} + "," +  {&update})  = 0 then return error.

  if p-def = {&update} then do:
     find first ub.season where recid(ub.season) = rr  exclusive-lock  no-error .
      if error-status :error then return error.
  end.
  if p-def = {&lookup} then do:
     find first ub.season where recid(ub.season) = rr  no-lock  no-error .
      if error-status :error then return error.
  end.

    if available ub.season then do:
        assign
          loc-code    = ub.season.sea-code
          loc-name    = ub.season.sea-name
          loc-month-1 = ub.season.sea-month-1
          loc-month-2 = ub.season.sea-month-2
          .
    end.
    else do:
        if p-def = {&add-def} then do:
          loc-code = next-value ( s-casm , {&db-name_schema} ) .
        end.
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
