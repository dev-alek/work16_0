&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          ub               PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DECLARATIONS Dialog-Frame 
{ref\ttprocbrow.i}
{cmp\str-glbl.i}
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* Temp-Table and Buffer definitions                                    */
define buffer tt-Param  for procparam.
define buffer tt-sespar for SesParam.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
define input  parameter iProcId as character no-undo.
define input  parameter dataset  for ds-asuncProc bind.
/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-Param tt-sespar

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 tt-Param.code tt-Param.CodeName 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH tt-Param where tt-Param.procid eq iProcId and tt-Param.paramhiden ne yes  NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH tt-Param where tt-Param.procid eq iProcId and tt-Param.paramhiden ne yes NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 tt-Param
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 tt-Param


/* Definitions for BROWSE BROWSE-3                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-3 tt-sespar.export_ tt-sespar.code ~
tt-sespar.CodeValue 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-3 tt-sespar.export_ 
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-3 tt-sespar
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-3 tt-sespar
&Scoped-define QUERY-STRING-BROWSE-3 FOR EACH tt-sespar NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-3 OPEN QUERY BROWSE-3 FOR EACH tt-sespar NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-3 tt-sespar
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-3 tt-sespar


/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Dialog-Frame ~
    ~{&OPEN-QUERY-BROWSE-2}~
    ~{&OPEN-QUERY-BROWSE-3}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_Cancel Btn_OK BROWSE-2 BROWSE-3 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
define button Btn_Cancel auto-end-key 
     label "Выход" 
     size 15 by 1.13
     bgcolor 8 .

define button Btn_OK auto-go 
     label "Выполнить" 
     size 15 by 1.13
     bgcolor 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
define query BROWSE-2 for 
      tt-Param scrolling.

define query BROWSE-3 for 
      tt-sespar scrolling.
&ANALYZE-RESUME

/* Browse definitions                                                   */
define browse BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 Dialog-Frame _STRUCTURED
  query BROWSE-2 no-lock display
      tt-Param.paramName column-label "Параметр" format "x(30)":U
      tt-Param.ParamValue column-label "Значение" format "x(60)":U width 55.63
      ENABLE
      tt-Param.ParamValue
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 90 BY 10.75 FIT-LAST-COLUMN.

define browse BROWSE-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-3 Dialog-Frame _STRUCTURED
  query BROWSE-3 no-lock display
      tt-sespar.parCheck  column-label "" format "yes/no":U width 4
            view-as toggle-box
      tt-sespar.parname column-label "Параметр" format "x(30)":U width 14.5
      tt-sespar.parvalue  column-label "Ключ запуска" format "x(200)":U width 44.63
  ENABLE
      tt-sespar.parCheck  tt-sespar.parvalue
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 90 BY 9 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

define frame Dialog-Frame
     Btn_Cancel at row 1.25 col 2
     Btn_OK at row 1.25 col 18
     BROWSE-2 at row 3 col 2 widget-id 200
     BROWSE-3 at row 15.25 col 2 widget-id 300
     "Добавить параметры" view-as text
          size 33 by .67 tooltip "Добавить параметры" at row 14.25 col 3.5 widget-id 8
     space(52.87) skip(9.99)
    with view-as dialog-box keep-tab-order 
         side-labels no-underline three-d  scrollable 
         title "Запуск сессии"
         default-button Btn_OK cancel-button Btn_Cancel widget-id 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-Param T "?" NO-UNDO ub Code
      TABLE: tt-sespar T "?" NO-UNDO ub Code
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-2 Btn_OK Dialog-Frame */
/* BROWSE-TAB BROWSE-3 BROWSE-2 Dialog-Frame */
assign 
       frame Dialog-Frame:SCROLLABLE       = false
       frame Dialog-Frame:HIDDEN           = true.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "Temp-Tables.tt-Param"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = Temp-Tables.tt-Param.paramName
     _FldNameList[2]   > Temp-Tables.tt-Param.ParamValue
"ParamValue" ? ? "character" ? ? ? ? ? ? no ? no no "55.63" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-3
/* Query rebuild information for BROWSE BROWSE-3
     _TblList          = "Temp-Tables.tt-sespar"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tt-sespar.parCheck
"parCheck" "" ? "logical" ? ? ? ? ? ? yes ? no no "4" yes no no "U" "" "" "TOGGLE-BOX" "," ? ? 5 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt-sespar.parname
"parname" ? ? "character" ? ? ? ? ? ? no ? no no "14.5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt-sespar.parvalue
"parvalue" ? ? "character" ? ? ? ? ? ? no ? no no "44.63" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-3 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
on window-close of frame Dialog-Frame /* <insert dialog title> */
do:
  apply "END-ERROR":U to self.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK C-Win
on choose of Btn_OK in frame Dialog-Frame /* Отказать в подписи */
  do:
    define buffer tt-Param for procparam.
    define buffer tt-sespar for SesParam.
    define buffer tt-procAsunc for procAsunc.
    
    define variable vParams as character no-undo.
    define variable vwaitfile as character no-undo.
    vParams = fill({&delim-par},25).
    for each tt-Param where tt-Param.procid eq iProcId
    no-lock:
       if     tt-Param.ParamType ne ""
          and tt-Param.ParamType ne ?
       then do:
          if tt-Param.ParamType begins "int"
          then
             int(tt-Param.ParamValue) no-error.
          else if tt-Param.ParamType begins "dec"
          then
             dec(tt-Param.ParamValue) no-error.
          else if tt-Param.ParamType begins "log"
          then
             logical(tt-Param.ParamValue) no-error.
          else if tt-Param.ParamType begins "date"
          then
             date(tt-Param.ParamValue) no-error.
          if error-status:error
          then do:
             message tt-Param.paramName skip
                     "должен быть типа " tt-Param.paramtype skip
                     error-status:get-message (1)
             view-as alert-box.
             return no-apply.
          end.
       end.
       entry(tt-Param.numparam,vParams,{&delim-par}) = tt-Param.ParamValue.
       
    end.
    vwaitfile = trim(vwaitfile,",").
    vParams = right-trim(vParams,{&delim-par}).
    define variable vasynchelper as class ibs.th.file.asynchelperTh no-undo.
    vAsyncHelper = new ibs.th.file.AsyncHelperth().
    vAsyncHelper:mProcPublish = this-procedure.
    vAsyncHelper:user-passwd = "current".
    vAsyncHelper:MyBachMode = session:batch-mode.
    vAsyncHelper:SaveFile = yes.
    
    for each tt-sespar where tt-sespar.parCheck
    no-lock:
       vAsyncHelper:paramSession = vAsyncHelper:paramSession + " " + tt-sespar.parvalue.
       if tt-sespar.parWaitFile ne "" and tt-sespar.parWaitFile ne ?
       then
          vwaitfile = vwaitfile +  "," + tt-sespar.parWaitFile.
    end.
    vwaitfile = trim(vwaitfile,",").
    vAsyncHelper:WaitFile = vwaitfile.
    find first tt-procAsunc where tt-procAsunc.procid eq iProcid no-lock.
    vAsyncHelper:AsyncProc(tt-procAsunc.procval, vParams,1).
    
            
    vAsyncHelper:waitfor (?, 1,tt-procAsunc.procname).
    
    message "Результаты выполнения находятся в " vAsyncHelper:SaveArh()
    view-as alert-box.
    delete object vAsyncHelper.
   
    
  end.

/* _UIB-CODE-BLOCK-END */

&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
if valid-handle(active-window) and frame {&FRAME-NAME}:PARENT eq ?
then frame {&FRAME-NAME}:PARENT = active-window.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
do on error   undo MAIN-BLOCK, leave MAIN-BLOCK
   on end-key undo MAIN-BLOCK, leave MAIN-BLOCK:
  run enable_UI.
  wait-for go of frame {&FRAME-NAME}.
end.
run disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
procedure disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  hide frame Dialog-Frame.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
procedure enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  enable Btn_Cancel Btn_OK BROWSE-2 BROWSE-3 
      with frame Dialog-Frame.
  view frame Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

