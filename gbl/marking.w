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

Редактирование секции параметры для Электронный документооборот

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
define variable vss-description as character no-undo init "Редактирование секции параметры для для Электронный документооборот" .
{ cmp/vssrevis.i }
{ cmp/trg-def.i  }
{ cmp/library.i  }
{ cmp/showinf.i  }
{ gbl/thbjattr.i }

def var ObjSrv as class ibs.th.gbl.sys.objsrv no-undo.
run gbl/getobjsrvhndl.p (input-output ObjSrv).

define temp-table temp-thbj-attr no-undo like ub.thbj-attr.

define variable v-tth     as handle no-undo .

define variable v-tth-host as handle no-undo .
define variable v-to-create-host as logical no-undo.
define variable str-attr as character no-undo .

assign
v-tth      = buffer temp-thbj-attr:table-handle .


/*if p-obj-type = "" then do:                                     */
/*if g#db-num <> 0  and p-obj-type = "" then  p-mode = {&lookup} .*/
/*end.                                                            */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS B-exit B-quit RECT-1 t-edo t-manual ~
cb-gray_zone_qnty S-type S-type-edo 
&Scoped-Define DISPLAYED-OBJECTS t-edo t-manual cb-gray_zone_qnty ~
S-type S-type-edo 

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

DEFINE BUTTON B-quit AUTO-END-KEY 
     LABEL "&Отмена" 
     SIZE 10 BY 1.

DEFINE VARIABLE cb-gray_zone_qnty AS INTEGER FORMAT "->>9":U INITIAL 0 
     LABEL "Допустимое отсутствие КМ для ~"Серой зоны~"" 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "0" ,
     "1",
     "2",
     "3",
     "4",
     "5",
     "6",
     "7",
     "8",
     "9",
     "10",
     "100"     
     DROP-DOWN-LIST
     SIZE 27.75 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 9.75.

DEFINE VARIABLE S-type AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-VERTICAL 
     LIST-ITEM-PAIRS "","",
                     "Табачная продукция","tabak",
                     "Обувь","shoes",
                     "Духи и парфюмерия","perfume",
                     "Легпром","industry",
                     "Шины","tires",
                     "Лекарства","apteka",
                     "Фотокамеры/фотовспышки","photo" 
     SIZE 31 BY 5 NO-UNDO.

DEFINE VARIABLE S-type-edo AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-VERTICAL 
     LIST-ITEM-PAIRS "","",
                     "Табачная продукция","tabak",
                     "Обувь","shoes",
                     "Духи и парфюмерия","perfume",
                     "Легпром","industry",
                     "Шины","tires",
                     "Лекарства","apteka",
                     "Фотокамеры/фотовспышки","photo" 
     SIZE 31 BY 5 NO-UNDO.

DEFINE VARIABLE t-edo AS LOGICAL INITIAL no 
     LABEL "Включена работа с ЭДО" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.5 BY .83 NO-UNDO.

DEFINE VARIABLE t-manual AS LOGICAL INITIAL no 
     LABEL "Ручной ввод марок" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.5 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     B-exit AT ROW 1 COL 1
     B-quit AT ROW 1 COL 11
     t-edo AT ROW 2.79 COL 5.75 WIDGET-ID 142
     t-manual AT ROW 3.88 COL 5.75 WIDGET-ID 148
     cb-gray_zone_qnty AT ROW 5 COL 49.25 COLON-ALIGNED WIDGET-ID 150
     S-type AT ROW 7.25 COL 51.5 NO-LABEL WIDGET-ID 144
     S-type-edo AT ROW 12.46 COL 51.5 NO-LABEL WIDGET-ID 152
     "Типы маркировки для помарочного учета:" VIEW-AS TEXT
     SIZE 39 BY .67 AT ROW 7.5 COL 6 WIDGET-ID 146
     "Типы маркировки для оприходования по ЭДО:" VIEW-AS TEXT
     SIZE 41.5 BY .67 AT ROW 12.71 COL 6 WIDGET-ID 154
     RECT-1 AT ROW 2.25 COL 1.5 WIDGET-ID 116
     SPACE(1.87) SKIP(0.41)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Настройки для Электронного документооборота"
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

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON GO OF FRAME Dialog-Frame /* Настройки для Электронного документооборота */
DO:
  run save-proc in this-procedure no-error.
  if error-status :error then return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Настройки для Электронного документооборота */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-gray_zone_qnty
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-gray_zone_qnty Dialog-Frame
ON VALUE-CHANGED OF cb-gray_zone_qnty IN FRAME Dialog-Frame /* Допустимое отсутствие КМ для "Серой зоны" */
DO:
  assign cb-gray_zone_qnty .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME S-type
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL S-type Dialog-Frame
ON VALUE-CHANGED OF S-type IN FRAME Dialog-Frame
DO:
  assign S-type.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME S-type-edo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL S-type-edo Dialog-Frame
ON VALUE-CHANGED OF S-type-edo IN FRAME Dialog-Frame
DO:
  assign S-type-edo.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME t-edo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t-edo Dialog-Frame
ON VALUE-CHANGED OF t-edo IN FRAME Dialog-Frame /* Включена работа с ЭДО */
DO:
  assign t-edo .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME t-manual
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t-manual Dialog-Frame
ON VALUE-CHANGED OF t-manual IN FRAME Dialog-Frame /* Ручной ввод марок */
DO:
  assign t-manual .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  if p-obj-type <> "" then do:
     FRAME {&FRAME-NAME}:TITLE = FRAME {&FRAME-NAME}:TITLE + (if p-obj-type = {&cmp} then " фирма" else " маг") + STRING(p-obj-code) .
  end.
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
  DISPLAY t-edo t-manual cb-gray_zone_qnty S-type S-type-edo  
      WITH FRAME Dialog-Frame.
  ENABLE B-exit B-quit RECT-1 t-edo t-manual cb-gray_zone_qnty 
         S-type S-type-edo  
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

  if p-mode = {&update} then 
  do:
    ENABLE S-type S-type-edo t-edo cb-gray_zone_qnty t-manual
      WITH FRAME Dialog-Frame.
  end.  
  else do:
    Display S-type S-type-edo t-edo cb-gray_zone_qnty t-manual
      WITH FRAME Dialog-Frame.
   end.  
run adm/shattri.p (
    input "init":U
  , input p-obj-type
  , input p-obj-code
  , input {&attr-marking}
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
    IF temp-thbj-attr.prop-code = {&attr-marking_marking-EDO} THEN DO:
      t-edo = temp-thbj-attr.property-value-logical .
      display t-edo with frame {&frame-name} .
    END.
    IF temp-thbj-attr.prop-code = {&attr-marking_marking-manual} THEN DO:
      t-manual = temp-thbj-attr.property-value-logical .
      display t-manual with frame {&frame-name} .
    END.
    
    IF temp-thbj-attr.prop-code = {&attr-marking_marking-type} THEN DO:
       S-type = temp-thbj-attr.property-value-character .
       display s-type with frame {&frame-name} .
    END.
    IF temp-thbj-attr.prop-code = {&attr-marking_marking-type-edo} THEN DO:
       S-type-edo = temp-thbj-attr.property-value-character .
       display S-type-edo with frame {&frame-name} .
    END.
    IF temp-thbj-attr.prop-code = {&attr-marking_gray_zone_qnty} THEN DO:
       cb-gray_zone_qnty = temp-thbj-attr.property-value-integer .
       display cb-gray_zone_qnty with frame {&frame-name} .
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
    t-edo
    S-type
    S-type-edo
    t-manual
    cb-gray_zone_qnty
    .
    find first temp-thbj-attr where temp-thbj-attr.prop-code = {&attr-marking_marking-edo} .
    temp-thbj-attr.property-value-logical = t-edo.
    find first temp-thbj-attr where temp-thbj-attr.prop-code = {&attr-marking_marking-manual} .
    temp-thbj-attr.property-value-logical = t-manual.
    find first temp-thbj-attr where temp-thbj-attr.prop-code = {&attr-marking_marking-type} .
    temp-thbj-attr.property-value-character = trim(s-type,",").
    find first temp-thbj-attr where temp-thbj-attr.prop-code = {&attr-marking_marking-type-edo} .
    temp-thbj-attr.property-value-character = trim(S-type-edo,",").
    find first temp-thbj-attr where temp-thbj-attr.prop-code = {&attr-marking_gray_zone_qnty} .
    temp-thbj-attr.property-value-integer = cb-gray_zone_qnty.    
    
    do transaction:
        RUN thbjattr_set-section IN THIS-PROCEDURE (
             input p-obj-type
            ,input p-obj-code
            ,input {&attr-marking}
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

