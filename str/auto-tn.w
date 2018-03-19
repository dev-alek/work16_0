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

Справочник автотранспорта

Автор: Уханов Дмитрий Юрьевич
Дата создания: 08/16/07
Author: Dmitry Ukhanov
Creation date: 08/16/07

Автор: Перваков Михаил Сергеевич
Дата создания: 04/11/06
Author: Mikhail Pervakov
Creation date: 04/11/06

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
define variable vss-description as character no-undo init "Справочник автотранспорта".
{ cmp/vssrevis.i }
{ cmp/showinf.i  }
{ cmp/str-glbl.i }
{ gbl/flt-def.i  }
{ gbl/waitfram.i }
{ gbl/fltfield.i }
{ gbl/fltopend.i defproc }
define variable v-auto-firm as character no-undo format "x(14)":U.
define variable varauto-tank-rec as recid no-undo.
define variable v-log as logical no-undo .
define variable v-status_ like ub.auto-tank.status_ no-undo .

assign parrec-tank      = ?
       varauto-tank-rec = ?.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME brw-auto-tank

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES auto-tank auto-tank-attr

/* Definitions for BROWSE brw-auto-tank                                 */
&Scoped-define FIELDS-IN-QUERY-brw-auto-tank auto-tank.auto-num ~
auto-tank.name auto-tank.brutto-qnty 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brw-auto-tank
&Scoped-define QUERY-STRING-brw-auto-tank FOR EACH ub.auto-tank ~
      where index(ub.auto-tank.auto-num, "#") = 0 NO-LOCK.
&Scoped-define OPEN-QUERY-brw-auto-tank OPEN QUERY brw-auto-tank FOR EACH ub.auto-tank ~
      where index(ub.auto-tank.auto-num, "#") = 0 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brw-auto-tank ub.auto-tank
&Scoped-define FIRST-TABLE-IN-QUERY-brw-auto-tank ub.auto-tankr

/* Definitions for BROWSE brw-auto-tank-2                                 */
&Scoped-define FIELDS-IN-QUERY-brw-auto-tank-2 auto-tank.auto-num auto-tank.name auto-tank.brutto-qnty   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brw-auto-tank-2
&Scoped-define SELF-NAME brw-auto-tank-2
&Scoped-define QUERY-STRING-brw-auto-tank-2 FOR EACH ub.auto-tank WHERE INDEX(ub.auto-tank.auto-num, ~
       CHR(35)) = 0 NO-LOCK, ~
            first auto-tank-attr no-lock where auto-tank-attr.attr-code = "auto-firm"           and auto-tank-attr.attr-value = par-obj-type + string(par-obj-code) and auto-tank-attr.auto-num = ub.auto-tank.auto-num
&Scoped-define OPEN-QUERY-brw-auto-tank-2 OPEN QUERY brw-auto-tank-2 FOR EACH ub.auto-tank WHERE INDEX(ub.auto-tank.auto-num, ~
       CHR(35)) = 0 NO-LOCK, ~
            first auto-tank-attr no-lock where auto-tank-attr.attr-code = "auto-firm"           and auto-tank-attr.attr-value = par-obj-type + string(par-obj-code) and auto-tank-attr.auto-num = ub.auto-tank.auto-num.
&Scoped-define TABLES-IN-QUERY-brw-auto-tank-2 auto-tank auto-tank-attr
&Scoped-define FIRST-TABLE-IN-QUERY-brw-auto-tank-2 auto-tank
&Scoped-define SECOND-TABLE-IN-QUERY-brw-auto-tank-2 auto-tank-attr


/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Dialog-Frame ~
    ~{&OPEN-QUERY-brw-auto-tank}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-exit b-view B-hist b-help brw-auto-tank ~
brw-auto-tank-2 varps RS-status_ 
&Scoped-Define DISPLAYED-OBJECTS varps 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD get-auto-firm Dialog-Frame 
FUNCTION get-auto-firm RETURNS CHARACTER
  ( BUFFER buf_auto-tank FOR ub.auto-tank )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-add
     LABEL "&Добавить"
     SIZE 10 BY 1.

DEFINE BUTTON b-chg
     LABEL "&Изменить"
     SIZE 10 BY 1.

DEFINE BUTTON b-exit AUTO-END-KEY
     LABEL "&Выход"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-help
     LABEL "&Помощь"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON B-hist
     LABEL "Ис&тория"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-sel AUTO-GO
     LABEL "&Выбор"
     SIZE 10 BY 1.

DEFINE BUTTON b-view
     LABEL "&Просмотр"
     SIZE 10 BY 1.

DEFINE BUTTON b-del 
     LABEL "&Удалить" 
     SIZE 10 BY 1.

DEFINE VARIABLE varps AS CHARACTER
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 87 BY 2.25
     BGCOLOR 8  DROP-TARGET NO-UNDO.

DEFINE VARIABLE RS-status_ AS CHARACTER
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS
        "Item 1", "1",
        "Item 2", "2",
        "Item 3", "3"
     SIZE 33.5 BY 1 NO-UNDO.     

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brw-auto-tank FOR
      auto-tank SCROLLING.

DEFINE QUERY brw-auto-tank-2 FOR
      auto-tank, 
      auto-tank-attr SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brw-auto-tank
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brw-auto-tank Dialog-Frame _STRUCTURED
  QUERY brw-auto-tank DISPLAY
      auto-tank.auto-num FORMAT "X(20)":U Column-label "Гос.номер "
      auto-tank.name FORMAT "X(40)":U Column-label "Марка"
      auto-tank.brutto-qnty FORMAT "->>,>>>,>>9.<<<":U
      auto-tank.status_ FORMAT "X(10)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 87 BY 13.75.

DEFINE BROWSE brw-auto-tank-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brw-auto-tank-2 Dialog-Frame _FREEFORM
  QUERY brw-auto-tank-2 NO-LOCK DISPLAY
      auto-tank.auto-num FORMAT "X(20)":U
      auto-tank.name FORMAT "X(40)":U
      auto-tank.brutto-qnty FORMAT "->>,>>>,>>9.<<<":U
      auto-tank.status_ FORMAT "X(10)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 87 BY 13.75 ROW-HEIGHT-CHARS .58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     b-exit AT ROW 1 COL 2
     b-sel AT ROW 1 COL 12
     b-add AT ROW 1 COL 22
     b-chg AT ROW 1 COL 32
     b-view AT ROW 1 COL 42
     b-del AT ROW 1 COL 52
     b-hist at row 1 col 63
     b-help AT ROW 1 COL 68
     RS-status_ AT ROW 2 COL 2 NO-LABEL
     brw-auto-tank AT ROW 3.1 COL 2
     brw-auto-tank-2 AT ROW 3.1 COL 2
     varps AT ROW 17 COL 2 NO-LABEL
     SPACE(0.87) SKIP(0.44)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE
         TITLE "Справочник автотранспорта"
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
/* BROWSE-TAB brw-auto-tank-2 brw-auto-tank Dialog-Frame */
ASSIGN
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON b-add IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b-chg IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b-sel IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
ASSIGN
       varps:READ-ONLY IN FRAME Dialog-Frame        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brw-auto-tank
/* Query rebuild information for BROWSE brw-auto-tank
     _TblList          = "ub.auto-tank"
     _Where[1]         = "INDEX(auto-tank.auto-num, CHR(35)) = 0"
     _FldNameList[1]   = ub.auto-tank.auto-num
     _FldNameList[2]   = ub.auto-tank.name
     _FldNameList[3]   = ub.auto-tank.brutto-qnty
     _Query            is OPENED
*/  /* BROWSE brw-auto-tank */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brw-auto-tank-2
/* Query rebuild information for BROWSE brw-auto-tank-2
     _START_FREEFORM
OPEN QUERY brw-auto-tank-2 FOR EACH ub.auto-tank WHERE INDEX(ub.auto-tank.auto-num, CHR(35)) = 0 NO-LOCK,
     first auto-tank-attr no-lock where auto-tank-attr.attr-code = "auto-firm"
          and auto-tank-attr.attr-value = par-obj-type + string(par-obj-code) and auto-tank-attr.auto-num = ub.auto-tank.auto-num
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST"
     _Where[2]         = "where auto-tank-attr.attr-code = ""auto-firm"" and auto-tank-attr.attr-value = par-obj-type + string(par-obj-code) and auto-tank-attr.auto-num = ub.auto-tank.auto-num"
     _Query            is NOT OPENED
*/  /* BROWSE brw-auto-tank-2 */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Справочник автотранспорта */
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
    // find first ub.auto-tank exclusive-lock where recid(ub.auto-tank) = varauto-tank-rec.
      run local-enable_ui.
    end.
    else do:
    message "Не выбран автотранспорт." view-as alert-box error.
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
      parrec-tank = recid(ub.auto-tank).
 end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-hist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-hist Dialog-Frame
ON CHOOSE OF B-hist IN FRAME Dialog-Frame /* История */
DO:
  DEFINE VARIABLE v-rid-list AS CHARACTER NO-UNDO.
  IF AVAILABLE auto-tank THEN DO:

  run str/c-auto-tn.w (
                    INPUT parParentProc
                   ,input '':U /*bttns*/
                   ,input 'one':U /*p-mode*/
                   ,INPUT auto-tank.auto-num
                   ,INPUT-OUTPUT v-rid-list) NO-ERROR.

  END.
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
    message "Не выбрана автотранспорт." view-as alert-box error.
  end.
END.

&Scoped-define SELF-NAME b-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-del Dialog-Frame
ON CHOOSE OF b-del IN FRAME Dialog-Frame /* Просмотр */
DO:
  if available ub.auto-tank then do:
    find current ub.auto-tank exclusive-lock.
    if ub.auto-tank.status_ = {&current-status} then do :
        message "Вы действительно хотите удалить автотранспорт?" view-as alert-box question buttons yes-no update v-log.
        if v-log then ub.auto-tank.status_ = {&deleted-status} .
    end.
    else do:
        message "Восстановить автотранспорт?" view-as alert-box question buttons yes-no update v-log. 
        if v-log then ub.auto-tank.status_ = {&current-status} .
    end.
    brw-auto-tank:refresh().    
  end.
  else do:
    message "Не выбрана автотранспорта." view-as alert-box error.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME RS-status_
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RS-status_ Dialog-Frame
ON VALUE-CHANGED OF RS-status_ IN FRAME Dialog-Frame
DO:
  ASSIGN
  rs-status_
  v-status_ = rs-status_
    .
  RUN openbr IN THIS-PROCEDURE NO-ERROR.
  IF ERROR-STATUS:ERROR  THEN RETURN NO-APPLY.
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
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brw-auto-tank
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
  DISPLAY varps 
      WITH FRAME Dialog-Frame.
  ENABLE b-exit b-view b-hist b-help brw-auto-tank brw-auto-tank-2 varps RS-status_
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
  ASSIGN
    rs-status_:RADIO-BUTTONS IN FRAME {&FRAME-NAME}
                           = "Текущие&+" + {&comma-char} +  {&current-status} + {&comma-char} +
                           "Все&!" + {&comma-char} + {&all} + {&comma-char} +
                            "Удаленные&-" + {&comma-char} + {&deleted-status}
    rs-status_ = {&current-status}
  .  
  if lookup ("b-sel", parbuttons) > 0 then do:
    enable b-sel with frame {&frame-name}.
  end.
  if lookup ("b-add", parbuttons) > 0 then do:
    enable b-add with frame {&frame-name}.
  end.
  if lookup ("b-chg", parbuttons) > 0 then do:
    enable b-chg with frame {&frame-name}.
  end.
  if lookup ("b-del", parbuttons) > 0 then do:
    enable b-del with frame {&frame-name}.
  end.
  apply "value-changed" to brw-auto-tank in frame dialog-frame.
  disable brw-auto-tank-2 WITH FRAME {&frame-name}.
  brw-auto-tank-2:visible = false.
  display brw-auto-tank WITH FRAME {&frame-name}.
  /* Code placed here will execute AFTER standard behavior.    */
  if par-obj-type <> "" and par-obj-code <> 0 then do :
    brw-auto-tank:visible = false .
    brw-auto-tank-2:visible = true.
    enable brw-auto-tank-2 WITH FRAME Dialog-Frame.
    disable rs-status_ WITH FRAME Dialog-Frame.
    OPEN QUERY brw-auto-tank-2 FOR EACH ub.auto-tank where ub.auto-tank.status_ = {&current-status} NO-LOCK, first auto-tank-attr no-lock where auto-tank-attr.attr-code = "auto-firm"
          and auto-tank-attr.attr-value = par-obj-type + string(par-obj-code) and auto-tank-attr.auto-num = ub.auto-tank.auto-num.
    if varauto-tank-rec <> ? then do:
      reposition brw-auto-tank-2 to recid varauto-tank-rec.
      end.
    end.
  ASSIGN
    v-status_ = rs-status_
  .  
  
  RUN openbr IN THIS-PROCEDURE NO-ERROR.
  IF ERROR-STATUS:ERROR  THEN RETURN NO-APPLY.
  if varauto-tank-rec <> ? then do:
    reposition brw-auto-tank to recid varauto-tank-rec.
  end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION get-auto-firm Dialog-Frame 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenBr Dialog-Frame
PROCEDURE OpenBr :
define variable l-query-was-opened as logical no-undo .
run waitfram-show in this-procedure ("Ждите...").
define variable sort-column-phrase as character no-undo .


&scop flt-open-open-query OPEN QUERY brw-auto-tank FOR EACH ub.auto-tank

&scop flt-open-dyn_open-query FOR EACH ub.auto-tank

&scop flt-open-query-handle QUERY brw-auto-tank:handle

&scop flt-open-open-query-tail

&scop flt-open-query-was-opened  l-query-was-opened

&scop flt-open-sort-column-phrase sort-column-phrase

&scop flt-open-call-point "Список автотранспорта"

&scop flt-open-set-filter-name set-filter-name

&scop flt-open-indexed-reposition indexed-reposition

&scop flt-open-query yes

&scop flt-open-table-name ub.auto-tank

&scop flt-open-search-option no-lock

&scop flt-open-find-next no

&scop flt-open-find-recid varauto-tank-rec

&scop flt-open-find-condition ""

&scop flt-open-find-buffer-name ub.auto-tank

&scop flt-open-waitfram yes

define variable l-open-query as logical   no-undo .

define variable v-num as characte no-undo initial "#" .


 IF v-status_ = {&all} THEN DO:
     { gbl/fltopend.i
        &where-cond = " index(ub.auto-tank.auto-num, v-num) = 0 "
        &use-ind    = "  "
        &by         = "  " }

 END.
 ELSE DO:
   { gbl/fltopend.i
   &where-cond = " ub.auto-tank.status_ = v-status_ and index(ub.auto-tank.auto-num, v-num) = 0 "
   &dyn_where-cond = " substitute('ub.auto-tank.status_ = &1&2&1 and index(ub.auto-tank.auto-num, &1&3&1) = 0', ~{&double-quote~}, v-status_, v-num) "
   &use-ind    = "  "
   &by         = "  " }

 END.
    
/*IF v-status_ <> {&all}  THEN DO:                                                         */
/*    ASSIGN                                                                               */
/*    frame {&frame-name}:TITLE = (frame {&frame-name}:TITLE + {&space-char}  + v-status_).*/
/*                                                                                         */
/*END.                                                                                     */

run waitfram-hide in this-procedure .
APPLY "VALUE-CHANGED" TO brw-auto-tank in frame {&frame-name}.
APPLY "ENTRY" TO brw-auto-tank.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME