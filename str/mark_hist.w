&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
using ibs.th.gbl.sys.objsrv.
using ibs.th.str.marking.sts.*.
/* Connected Databases 
          ub               PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME d-mark

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DECLARATIONS d-mark 
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

История движения марки

Автор: Шкляр Елена
Дата создания: 20/04/95
Author: Shklyar Elena
Creation date: 20/04/95

*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

define input parameter parparentproc as widget-handle no-undo .
define input parameter p-mark as character no-undo .
define input parameter p-mode as character no-undo .

/*define var p-mark as character no-undo .*/
/*define var p-mode as character no-undo .*/


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "История движения марки".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i  }
{ cmp/library.i }
{ cmp/showinf.i }
{ cmp/r-pril.i new }
{ gbl/userobjs.i }
{ gbl/cur-time.i }
{ gbl/getcntxt.i def }
{ gbl/prn-lib.i }
{ gbl/waitfram.i }
{ cmp/mrk-strf.i }
{ gbl/color.i }
{ str/temp_upd.i }
{ utl/gtin.i }
{ rep/gn-extp.i }
/* Local Variable Definitions ---                                       */

define variable log-res     as log       no-undo.
define variable rr          as recid     no-undo.
define variable v_type      as char      no-undo.
define variable v-is-deploy as logical   no-undo .
define variable v-rid-list  as character no-undo .
define variable v-db-list   as character no-undo .
define variable iLang            as integer   no-undo.
define variable v-marking   as character no-undo .

define buffer buf_marking       for ub.marking .
define buffer buf_marking-lines for ub.marking-lines .
define buffer buf_utd-marking-lines for ub.utd-marking-lines .
define buffer buf_parts         for ub.parts . 
define buffer buf_goods         for ub.goods .
define buffer buf_trn-doc       for ub.trn-doc .
define buffer buf_utd           for ub.utd .
DEFINE BUFFER X_marking-line    FOR tt-mark-line.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* Temp-Table and Buffer definitions                                    */



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS d-mark 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 16/02/20 - 12:57 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME d-mark
&Scoped-define BROWSE-NAME br-mark

/* Definitions for BROWSE br-mark-item                                  */
&Scoped-define FIELDS-IN-QUERY-br-mark X_marking-line.gds-code ~
X_marking-line.mark-parent X_marking-line.mark X_marking-line.unit X_marking-line.sts 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-mark 
&Scoped-define QUERY-STRING-br-mark FOR EACH X_marking-line NO-LOCK by X_marking-line.fact-order desc by X_marking-line.date_ desc INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-mark OPEN QUERY br-mark FOR EACH X_marking-line NO-LOCK by X_marking-line.fact-order desc by X_marking-line.date_ desc INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-mark X_marking-line
&Scoped-define FIRST-TABLE-IN-QUERY-br-mark X_marking-line


/* Definitions for DIALOG-BOX d-mark                                    */
&Scoped-define OPEN-BROWSERS-IN-QUERY-d-mark ~
    ~{&OPEN-QUERY-br-mark}
    
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-exit B-1 v-mark v-mark-2 Btn_rn br-mark ~
Btn_pn 
&Scoped-Define DISPLAYED-OBJECTS v-mark v-mark-2 f-status f-GTIN f-gds-code ~
f-gds-name f-obj-code f-obj-type f-rn f-unit f-unit-2 f-pn 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GdsName d-mark 
FUNCTION GdsName RETURNS CHARACTER
  ( input p-gds-code as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD StatusName d-mark 
FUNCTION StatusName RETURNS CHARACTER
  ( input p-sts as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-1 
     LABEL "Button 1" 
     SIZE 10 BY 1.

DEFINE BUTTON b-exit AUTO-GO 
     LABEL "&Выход ":L 
     SIZE 10 BY 1.

DEFINE BUTTON Btn_pn 
     IMAGE-UP FILE "cmp/btn-fnd.bmp":U
     IMAGE-DOWN FILE "cmp/btn-fnd.bmp":U
     IMAGE-INSENSITIVE FILE "cmp/btn-fnd.bmp":U NO-CONVERT-3D-COLORS
     LABEL "" 
     SIZE 3 BY 1.

DEFINE BUTTON Btn_rn 
     IMAGE-UP FILE "cmp/btn-fnd.bmp":U
     IMAGE-DOWN FILE "cmp/btn-fnd.bmp":U
     IMAGE-INSENSITIVE FILE "cmp/btn-fnd.bmp":U NO-CONVERT-3D-COLORS
     LABEL "" 
     SIZE 3 BY 1.

DEFINE VARIABLE f-gds-code AS CHARACTER FORMAT "X(256)":U 
     LABEL "Код" 
     VIEW-AS FILL-IN 
     SIZE 21 BY 1 NO-UNDO.

DEFINE VARIABLE f-gds-name AS CHARACTER FORMAT "X(256)":U 
     LABEL "Наименование" 
     VIEW-AS FILL-IN 
     SIZE 44 BY 1 NO-UNDO.

DEFINE VARIABLE f-GTIN AS CHARACTER FORMAT "X(256)":U 
     LABEL "GTIN" 
     VIEW-AS FILL-IN 
     SIZE 44 BY 1 NO-UNDO.

DEFINE VARIABLE f-obj-code AS INTEGER FORMAT ">>>>>>>>>>>9":U INITIAL 0 
     LABEL "Объект" 
     VIEW-AS FILL-IN 
     SIZE 7.5 BY 1 NO-UNDO.

DEFINE VARIABLE f-obj-type AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 7.5 BY 1 NO-UNDO.

DEFINE VARIABLE f-pn AS CHARACTER FORMAT "X(256)":U 
     LABEL "ПН" 
     VIEW-AS FILL-IN 
     SIZE 21 BY 1 NO-UNDO.

DEFINE VARIABLE f-rn AS CHARACTER FORMAT "X(256)":U 
     LABEL "Документ" 
     VIEW-AS FILL-IN 
     SIZE 21 BY 1 NO-UNDO.

DEFINE VARIABLE f-status AS CHARACTER FORMAT "X(256)":U 
     LABEL "Статус" 
     VIEW-AS FILL-IN 
     SIZE 44 BY 1 
     NO-UNDO.

DEFINE VARIABLE f-unit AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ед.изм. EDO" 
     VIEW-AS FILL-IN 
     SIZE 7.5 BY 1 NO-UNDO.

DEFINE VARIABLE f-unit-2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ед.изм." 
     VIEW-AS FILL-IN 
     SIZE 7.5 BY 1 NO-UNDO.

DEFINE VARIABLE v-mark AS CHARACTER FORMAT "X(255)" 
     LABEL "Марка" 
     VIEW-AS FILL-IN 
     SIZE 78.5 BY 1.

DEFINE VARIABLE v-mark-2 AS CHARACTER FORMAT "X(255)" 
     LABEL "Марка" 
     VIEW-AS FILL-IN 
     SIZE 95.5 BY 1.



def var objSrv as class objsrv no-undo.
run gbl/getobjsrvhndl.p (input-output ObjSrv).
def var Marking as class mark no-undo .

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD EdoTypeName d-utd 
FUNCTION EdoTypeName RETURNS CHARACTER
  (input p-stsTH as integer)  .
  Return ObjSrv:Env:Utd:EDocType:GetLabel(p-stsTH) .
END FUNCTION .  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-mark FOR 
  X_marking-line SCROLLING.
&ANALYZE-RESUME
/* Browse definitions                                                   */
DEFINE BROWSE br-mark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-mark d-mark _STRUCTURED
  QUERY br-mark NO-LOCK DISPLAY
  X_marking-line.doc-type COLUMN-LABEL "Тип" FORMAT "X(35)":U
  X_marking-line.date_ COLUMN-LABEL "Дата" FORMAT "99.99.9999":U width 30
  X_marking-line.out-code COLUMN-LABEL "Номер документа" FORMAT "x(30)":U
  string(X_marking-line.obj-code) + " " + X_marking-line.obj-type COLUMN-LABEL "Объект" FORMAT "x(20)":U 
  X_marking-line.doc-level COLUMN-LABEL "Уровень" FORMAT "-99":U
  /*  StatusName(integer(X_marking-line.sts)) COLUMN-LABEL "Статус" FORMAT "X(45)":U*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 106.5 BY 12.75 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME d-mark
     b-exit AT ROW 1 COL 1.38
     B-1 AT ROW 1 COL 11.5 WIDGET-ID 248
     v-mark AT ROW 1.08 COL 27.5 COLON-ALIGNED WIDGET-ID 34
     v-mark-2 AT ROW 2.33 COL 10.5 COLON-ALIGNED WIDGET-ID 252
     f-status AT ROW 3.5 COL 10.5 COLON-ALIGNED WIDGET-ID 218
     f-GTIN AT ROW 3.5 COL 62 COLON-ALIGNED WIDGET-ID 220
     f-gds-code AT ROW 4.75 COL 10.5 COLON-ALIGNED WIDGET-ID 224
     f-gds-name AT ROW 4.75 COL 62 COLON-ALIGNED WIDGET-ID 222
     f-obj-code AT ROW 5.88 COL 10.5 COLON-ALIGNED WIDGET-ID 256
     f-obj-type AT ROW 5.88 COL 18.75 COLON-ALIGNED NO-LABEL WIDGET-ID 258
     f-rn AT ROW 7 COL 10.5 COLON-ALIGNED WIDGET-ID 246
     Btn_rn AT ROW 7 COL 32.75 WIDGET-ID 250
     f-unit AT ROW 7 COL 81.13 COLON-ALIGNED WIDGET-ID 226
     f-unit-2 AT ROW 7 COL 107 RIGHT-ALIGNED WIDGET-ID 254
     br-mark AT ROW 8 COL 1.5 WIDGET-ID 200
     f-pn AT ROW 21.25 COL 81 COLON-ALIGNED WIDGET-ID 244
     Btn_pn AT ROW 21.25 COL 104.75 WIDGET-ID 68
     SPACE(0.87) SKIP(0.24)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Движение марки":L.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Temp-Tables and Buffers:
      TABLE: X_marking B "NEW SHARED" ? ub marking
      TABLE: X_marking-lines B "NEW SHARED" ? ub marking-lines
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX d-mark
   FRAME-NAME                                                           */
/* BROWSE-TAB br-mark f-unit-2 d-mark */
ASSIGN 
       FRAME d-mark:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN f-gds-code IN FRAME d-mark
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-gds-name IN FRAME d-mark
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-GTIN IN FRAME d-mark
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-obj-code IN FRAME d-mark
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-obj-type IN FRAME d-mark
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-pn IN FRAME d-mark
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-rn IN FRAME d-mark
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-status IN FRAME d-mark
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-unit IN FRAME d-mark
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-unit-2 IN FRAME d-mark
   NO-ENABLE ALIGN-R                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME br-mark
&Scoped-define SELF-NAME br-mark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-mark d-mark
ON value-changed OF br-mark IN FRAME d-mark
DO:
    run enable_mark .
  END .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_pn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_pn d-mark
ON CHOOSE OF Btn_pn IN FRAME d-mark
DO:
    { gbl/stdbtn.i }
run show-in-code in this-procedure .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_rn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_rn d-mark
ON CHOOSE OF Btn_rn IN FRAME d-mark
DO:
        { gbl/stdbtn.i }
if X_marking-line.type <> 1  then do:

run show-out-code in this-procedure .
end.
else do:
        run str/upd_browse.w (input parparentproc,
        input x_marking-line.doc-id,
        input x_marking-line.db-num,
        input x_marking-line.EDocType,
        input {&lookup},
        input ?
        ) no-error .
end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-mark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-mark d-mark
ON return OF v-mark IN FRAME d-mark /* Марка */
DO:
    define variable v_list as character no-undo .
    define variable ii     as integer   no-undo.
    assign 
      v-mark = v-mark:screen-value .

    ASSIGN 
      v_list = 'Ё,Й,Ц,У,К,Е,Н,Г,Ш,Щ,З,Х,Ъ,Ф,Ы,В,А,П,Р,О,Л,Д,Ж,Э,Я,Ч,С,М,И,Т,Ь,Б,Ю':U .
  
    /*проверка на русские буквы*/
    do ii = 1 to length (v-mark):
      if LOOKUP( SUBSTRING( v-mark, ii, 1 ), v_list )  > 1 then
      do:
        message "Не корректно считана акцизная марка, перед считыванием переключите клавиатуру на английскую раскладку."
          view-as alert-box.
        v-mark:screen-value = "" .
        v-mark = "" . 
        return .  
      end.
    end.
  
    /*Проверка марки*/
    run init-temp .
    run enable_mark .
    v-mark:screen-value = "" .
    v-mark = "" . 
    display 
      with frame {&frame-name} .
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK d-mark 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
  THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} 
  APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
  ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  { gbl/getcntxt.i get }
  Marking = ObjSrv:Env:Marking:Sts:Mark. .
  if p-mark <> "" then v-mark = p-mark .
  run LoadKeyboardLayoutA (input v-mark, input 0, output iLang).
  run ActivateKeyboardLayout (input iLang, input 0).   
  run init-temp in this-procedure .
  run enable_UI in this-procedure .
  run enable_mark in this-procedure .
  apply "entry" to v-mark in FRAME {&FRAME-NAME}.
  if p-mark <> "" then WAIT-FOR GO OF FRAME {&FRAME-NAME} focus {&browse-name}.
  else WAIT-FOR GO OF FRAME {&FRAME-NAME} FOCUS v-mark.
  
END.
run disable_UI in this-procedure .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI d-mark  _DEFAULT-DISABLE
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
  HIDE FRAME d-mark.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_mark d-mark 
PROCEDURE enable_mark :
/* --------------------------------------------------------------------
                  Purpose:     ENABLE the User Interface
                  Parameters:  <none>
                  Notes:       Here we display/view/enable the widgets in the
                               user-interface.  In addition, OPEN all queries
                               associated with each FRAME and BROWSE.
                               These statements here are based on the "Other
                               Settings" section of the widget Property Sheets.
                   -------------------------------------------------------------------- */
  display 
    f-status
    f-gds-code
    f-obj-code
    f-obj-type
    f-gds-name
    f-unit
    f-unit-2
    f-GTIN
    v-mark-2
    with frame {&frame-name} .
  if available (buf_marking) and buf_marking.sts = Marking:MarkError:KeyIntDB then do:
    f-status:fgcolor in frame {&frame-name} = 12.
  end.   
  if available (X_marking-line) then 
  do:

    f-pn = X_marking-line.in-code .
    f-rn = X_marking-line.out-code .
    display
      f-pn
      f-rn
      with frame {&frame-name} .   
    if f-pn <> "" and f-pn <> {&free-code} and f-pn <> {&output-code} then 
    do:
      display
        f-pn
        with frame {&frame-name} .
      enable 
        Btn_pn
        with frame {&frame-name} .
    end.  
    if f-rn <> "" and f-rn <> {&free-code} and f-rn <> {&output-code} then 
    do:
      display
        f-rn
        with frame {&frame-name} .
      enable 
        Btn_rn
        with frame {&frame-name} .
    end. 
    end. 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI d-mark 
PROCEDURE enable_UI :
/* --------------------------------------------------------------------
                  Purpose:     ENABLE the User Interface
                  Parameters:  <none>
                  Notes:       Here we display/view/enable the widgets in the
                               user-interface.  In addition, OPEN all queries
                               associated with each FRAME and BROWSE.
                               These statements here are based on the "Other
                               Settings" section of the widget Property Sheets.
                   -------------------------------------------------------------------- */

  ENABLE
    br-mark
    b-exit
    WITH FRAME {&frame-name}.
  hide B-1 in frame {&frame-name} .
  if p-mark <> "" then 
  do:
    hide
      v-mark
      in FRAME {&FRAME-NAME} .
  end.  
  else 
  do:
    enable
      v-mark
      WITH FRAME {&FRAME-NAME} .
  end.  
  if f-pn <> "" and f-pn <> {&free-code} and f-pn <> {&output-code} then
  do:
    display
      f-pn
      with frame {&frame-name} .
    enable 
      Btn_pn
      with frame {&frame-name} .
  end.  
  if f-rn <> "" and f-rn <> {&free-code} and f-rn <> {&output-code} then 
  do:
    display
      f-rn
      with frame {&frame-name} .
    enable 
      Btn_rn
      with frame {&frame-name} .
  end.

  display
    f-gds-name
    f-status
    f-obj-code
    f-obj-type
    f-gds-code
    f-unit
    f-unit-2
    f-GTIN
    v-mark-2
    with frame {&frame-name} .    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-temp d-mark 
PROCEDURE init-temp :
/* --------------------------------------------------------------------
                  Purpose:     ENABLE the User Interface
                  Parameters:  <none>
                  Notes:       Here we display/view/enable the widgets in the
                               user-interface.  In addition, OPEN all queries
                               associated with each FRAME and BROWSE.
                               These statements here are based on the "Other
                               Settings" section of the widget Property Sheets.
                   -------------------------------------------------------------------- */
  /*GTIN в любом случае показывать*/
  empty temp-table X_marking-line.
  
  /*  f-GTIN:screen-value =*/

  if v-mark <> "" then 
  do:
  v-marking = GetCodeIdent(v-mark) .

  v-mark-2   = v-marking .
  if v-marking <> "" and v-marking <> ? then do:
    find first buf_marking no-lock where buf_marking.mark begins v-marking 
/*    and buf_marking.obj-code = v-cntxt-obj-code and buf_marking.obj-type = v-cntxt-obj-type*/
    no-error .
    if available (buf_marking) then 
    do:
      f-status = StatusName(buf_marking.sts) .
      /*соответствие товаров*/
      f-gds-code = string(buf_marking.gds-code) .
      f-gds-name = GdsName(buf_marking.gds-code) .
      f-unit     = buf_marking.unit-ext .     
      f-GTIN     = buf_marking.gds-ext-id .
      f-unit-2   = buf_marking.unit . 
      f-obj-code = buf_marking.obj-code .
      f-obj-type = buf_marking.obj-type .
    
      for each buf_marking-lines no-lock where buf_marking-lines.mark = buf_marking.mark:
        /*      if NumUPD = "" then NumUPD = buf_marking-lines.DocumentExt .*/
        create X_marking-line .
        buffer-copy buf_marking-lines to X_marking-line .
        X_marking-line.gds-code = buf_marking.gds-code .
    
        find first buf_trn-doc no-lock where buf_trn-doc.doc-code = if buf_marking-lines.out-code <> {&output-code} and buf_marking-lines.out-code <> {&free-code} then buf_marking-lines.out-code else buf_marking-lines.in-code no-error .
        if available (buf_trn-doc) then do:
        X_marking-line.date_ = buf_trn-doc.doc-date .
        X_marking-line.doc-type = func-get-name-from-ext-type(buf_trn-doc.ext-doc-type,no) .
        if X_marking-line.fact-order = 0 then X_marking-line.fact-order = 1 .
        end.
        
      end.  
      for each buf_utd-marking-lines no-lock where buf_utd-marking-lines.mark = buf_marking.mark:
        for first buf_utd no-lock where buf_utd.doc-id = buf_utd-marking-lines.doc-id and buf_utd.db-num = buf_utd-marking-lines.db-num:  
        create X_marking-line .
        assign
          X_marking-line.doc-type    = EdoTypeName(buf_utd.EDocType)
          X_marking-line.mark        = buf_marking.mark
          X_marking-line.out-code    = buf_utd.DocumentNumber
          X_marking-line.date_       = buf_utd.DocumentDate
          X_marking-line.sts         = buf_utd-marking-lines.sts
          X_marking-line.type        = 1
          X_marking-line.obj-code    = buf_utd.obj-code
          X_marking-line.obj-type    = buf_utd.obj-type
          X_marking-line.doc-id      = buf_utd.doc-id
          X_marking-line.db-num      = buf_utd.db-num
          X_marking-line.EdocType    = buf_utd.EdocType
        .
        end.
      end.  
    end.
    else do:
      f-GTIN = getGtinByDM(v-mark) .
      f-gds-code = string(getGdsCodeByGtin(f-GTIN)) .
      f-gds-name = GdsName(integer(f-gds-code)) .
      f-status = "" .
      /*соответствие товаров*/
      f-unit     = "" .     
      f-unit-2   = "" . 
      f-obj-code = ? .
      f-obj-type = "" .        
    end.  
  end.   
  else do:
      f-GTIN = "" .
      f-gds-code = "" .
      f-gds-name = "" .
      f-status = "" .
      /*соответствие товаров*/
      f-unit     = "" .     
      f-unit-2   = "" . 
      f-obj-code = ? .
      f-obj-type = "" .   

  end. 
  end.  
  else do:
      f-GTIN = "" .
      f-gds-code = "" .
      f-gds-name = "" .
      f-status = "" .
      /*соответствие товаров*/
      f-unit     = "" .     
      f-unit-2   = "" . 
      f-obj-code = ? .
      f-obj-type = "" .   
      v-mark-2 = "" .
  end.      
  {&OPEN-QUERY-br-mark}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE show-in-code d-mark 
PROCEDURE show-in-code :
/* -----------------------------------------------------------
    Purpose:
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/
  /* показать складской документ */
  for first ub.marking-lines no-lock where ub.marking-lines.mark = buf_marking.mark,
    first ub.goods no-lock where ub.goods.gds-code = ub.marking-lines.gds-code:

    run str/showdoc.p
      (input parparentproc      /* parparentproc */
      ,input f-pn   /* p-doc-code    */
      ,input ub.goods.artic     /* p-artic       */
      ,input ub.goods.prod-type /* p-prod-type   */
      ,input ub.goods.prod-code /* p-prod-code   */
      ,input true               /* p-doc-type    */
      ).
  end.
  apply "entry":u to br-mark in frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE show-out-code d-mark 
PROCEDURE show-out-code :
/* -----------------------------------------------------------
    Purpose:
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/
  /* показать складской документ */
  for first ub.marking-lines no-lock where ub.marking-lines.mark = buf_marking.mark,
    first ub.goods no-lock where ub.goods.gds-code = ub.marking-lines.gds-code:

    run str/showdoc.p
      (input parparentproc      /* parparentproc */
      ,input f-rn   /* p-doc-code    */
      ,input ub.goods.artic     /* p-artic       */
      ,input ub.goods.prod-type /* p-prod-type   */
      ,input ub.goods.prod-code /* p-prod-code   */
      ,input true               /* p-doc-type    */
      ).
  
    apply "entry":u to br-mark in frame {&frame-name}.
  end.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GdsName d-mark 
FUNCTION GdsName RETURNS CHARACTER
  ( input p-gds-code as integer ) :
  /*------------------------------------------------------------------------------
    Purpose:  
      Notes:  
  ------------------------------------------------------------------------------*/
  define buffer buf_goods for ub.goods .
  define variable v-gds-name as character no-undo . 
  find first buf_goods no-lock where buf_goods.gds-code = p-gds-code no-error .
  if available (buf_goods) then v-gds-name = buf_goods.gds-name .
  RETURN v-gds-name.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION StatusName d-mark 
FUNCTION StatusName RETURNS CHARACTER
  ( input p-sts as integer ) :
  /*------------------------------------------------------------------------------
    Purpose:  
      Notes:  
  ------------------------------------------------------------------------------*/

  Return Marking:GetLabel(p-sts) .  


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME v-mark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-mark d-mark
ON ENTRY OF v-mark IN FRAME d-mark /* Марка */
DO:
            run LoadKeyboardLayoutA (input v-mark, input 0, output iLang).
            run ActivateKeyboardLayout (input iLang, input 0).
        END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LoadKeyboardLayoutA d-utd
procedure LoadKeyboardLayoutA external "user32" :
    define input  parameter P1 as char.
    define input  parameter P2 as LONG.
    define return parameter pret as LONG.
end procedure.
        
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ActivateKeyboardLayout d-utd 
procedure ActivateKeyboardLayout external "user32" :
    define input parameter P1 as LONG.
    define input parameter P2 as LONG.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME