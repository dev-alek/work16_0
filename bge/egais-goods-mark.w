&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*------------------------------------------------------------------------

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Товары по акцизной марке

Автор: Шкляр Елена 
Дата создания: 01/16/07
Author: Elena Shklyar
Creation date: 01/16/07
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
using ibs.th.bge.egais.*.
/* Parameters Definitions ---                                           */

define input  parameter parparentproc as handle no-undo.
define input  parameter p-mode     as character   no-undo.
define input  parameter p-alc-code as character   no-undo.
define output parameter p-gds-code like ub.goods.gds-code  no-undo.
define output parameter p-gds-name like ub.goods.gds-name  no-undo.
define output parameter p-prod-full-name as character  no-undo.
define output parameter p-import-full-name as character  no-undo.

/* Local Variable Definitions ---                                       */
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Товары по акцизной марке".

define temp-table tt-goods
  field gds-code         like goods.gds-code
  field artic            like goods.artic
  field gds-name         like goods.gds-name
  field import-full-name as character label "Импортер"
  field prod-full-name   as character label "Производитель"
  index pi as primary unique gds-code .
    
    
define variable extGdsObj  as class   extgds.
define variable ii         as integer no-undo .
define variable v-gds-code as integer no-undo .
  
{ cmp/vssrevis.i }
{bge/egais-mark.i}
{ cmp/showinf.i  }
{ gbl/color.i }
{ gbl/getcntxt.i def }
{ gbl/getcntxt.i get }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME br-goods

/* Definitions for DIALOG-BOX Dialog-Frame                              */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Cancel Btn_add Btn_del br-goods 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



  /* ***********************  Control Definitions  ********************** */

  /* Define a dialog box                                                  */

  /* Definitions of the field level widgets                               */
  DEFINE BUTTON Btn_add  
    LABEL "Добавить" 
    SIZE 15 BY 1.13
    BGCOLOR 8 .

  DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
    LABEL "Отмена" 
    SIZE 15 BY 1.13
    BGCOLOR 8 .

  DEFINE BUTTON Btn_del 
    LABEL "Удалить" 
    SIZE 15 BY 1.13
    BGCOLOR 8 .

  DEFINE BUTTON Btn_OK AUTO-GO 
    LABEL "Ввод" 
    SIZE 15 BY 1.13
    BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
  DEFINE QUERY br-goods FOR 
    tt-goods SCROLLING.
&ANALYZE-RESUME

  /* Browse definitions                                                   */
  DEFINE BROWSE br-goods
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 Dialog-Frame _STRUCTURED
    QUERY br-goods  DISPLAY
    tt-goods.gds-code 
    WIDTH 20
    tt-goods.artic 
    WIDTH 20
    tt-goods.gds-name 
    WIDTH 30
    tt-goods.import-full-name
    WIDTH 30
    tt-goods.prod-full-name
    WIDTH 30
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 88 BY 17.5 FIT-LAST-COLUMN.


  /* ************************  Frame Definitions  *********************** */

  DEFINE FRAME Dialog-Frame
    Btn_OK AT ROW 1.25 COL 1.5
    Btn_Cancel AT ROW 1.25 COL 16.5
    Btn_add AT ROW 1.25 COL 31.5 WIDGET-ID 4
    Btn_del AT ROW 1.25 COL 46.5 WIDGET-ID 2
    br-goods AT ROW 3 COL 1.5 WIDGET-ID 200
    SPACE(0.12) SKIP(0.20)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
    SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
    TITLE "Товары по акцизным маркам"
    DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
  /* SETTINGS FOR DIALOG-BOX Dialog-Frame
     FRAME-NAME                                                           */
  /* BROWSE-TAB br-goods Btn_del Dialog-Frame */
  ASSIGN 
    FRAME Dialog-Frame:SCROLLABLE       = FALSE
    FRAME Dialog-Frame:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
  ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Товары по акцизным маркам */
    DO:
      APPLY "END-ERROR":U TO SELF.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
  ON choose OF Btn_OK IN FRAME Dialog-Frame /* Ввод */
    DO:
      assign
        p-gds-code = tt-goods.gds-code
        p-gds-name = tt-goods.gds-name
        p-import-full-name = tt-goods.import-full-name
        p-prod-full-name   = tt-goods.prod-full-name
        .  

      RUN disable_UI.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME Btn_add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_add Dialog-Frame
  ON choose OF Btn_add IN FRAME Dialog-Frame /* Добавить */
    DO:
      define variable ref-list as character no-undo .
      define variable v-cntxt-obj-code as integer no-undo .
      define variable v-cntxt-obj-type as character no-undo .
      define variable extGdsValueObjnew as class ExtGdsValue.
      define variable v-GdsCode as integer no-undo .
      define variable v-GdsCodenew as integer no-undo .  

      run ref/gds-ref.p
        ( input parparentproc
        ,input "b-sel,b-add"
        ,input {&current}
        ,input {&all}
        ,input {&all}
        ,input ?
        ,input ?
        ,input ?
        ,input ?
        ,input v-cntxt-obj-type
        ,input v-cntxt-obj-code
        ,input ?
        ,output ref-list).
      find first ub.goods where recid (ub.goods) = integer (ref-list) no-lock no-error .
      if extGdsObj:NumBundles > 0 then 
        do:
          do ii = 1 to extGdsObj:NumBundles:
            v-gds-code = extGdsObj:GetExtGdsValue(ii):GdsCode .
            v-GdsCodenew = ub.goods.gds-code .
            if v-GdsCodenew = v-Gds-Code then do:
              message "Такой товар уже есть"
              view-as alert-box.
              return no-apply.
            end.
          end.  
        end.  

      extGdsValueObjnew = new ExtGdsValue () . 
      extGdsObj:CopyEgaisInfo(extGdsObj:GetExtGdsValue(), extGdsValueObjnew).
      extGdsValueObjnew:GdsCode = v-GdsCodenew.
      extGdsValueObjnew:AlcCode = p-alc-code.
      extGdsObj:CreateExtGds (extGdsValueObjnew).
      
      create tt-goods .
      
        tt-goods.gds-code = extGdsValueObjnew:GdsCode .
        tt-goods.gds-name = ub.goods.gds-name .
        tt-goods.artic    = ub.goods.artic .
        tt-goods.import-full-name = extGdsValueObjnew:FullNameImpor .
        tt-goods.prod-full-name   = extGdsValueObjnew:FullNameProd .
        .
  
      
      open query br-goods for each tt-goods .
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_del Dialog-Frame
ON choose OF Btn_del IN FRAME Dialog-Frame /* Удалить */
DO:
      extGdsObj:DeleteExtGds (tt-goods.gds-code, p-alc-code).
      delete tt-goods.
      open query br-goods for each tt-goods .
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON choose OF Btn_OK IN FRAME Dialog-Frame /* Ввод */
DO:
      assign
        p-gds-code = tt-goods.gds-code
        p-gds-name = tt-goods.gds-name
        p-import-full-name = tt-goods.import-full-name
        p-prod-full-name   = tt-goods.prod-full-name
        .  

      RUN disable_UI.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-goods
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
    RUN enable_UI.
    RUN enable_goods.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_goods Dialog-Frame 
PROCEDURE enable_goods :
/*------------------------------------------------------------------------------
    Purpose:     
    Parameters:  <none>
    Notes:       
  ------------------------------------------------------------------------------*/
  extGdsObj = new ExtGds (true).
  extGdsObj:OpenQueryExtGds(0, p-alc-code). 
  if extGdsObj:NumBundles > 0 then 
  do:
    do ii = 1 to extGdsObj:NumBundles:
      v-gds-code = extGdsObj:GetExtGdsValue(ii):GdsCode .
      find first ub.goods where ub.goods.gds-code = v-gds-code no-lock no-error.
      create tt-goods .
      
        tt-goods.gds-code = extGdsObj:GetExtGdsValue(ii):GdsCode .
        tt-goods.gds-name = ub.goods.gds-name . 
        tt-goods.artic    = ub.goods.artic .
        tt-goods.import-full-name = extGdsObj:GetExtGdsValue(1):FullNameImpor .
        tt-goods.prod-full-name   = extGdsObj:GetExtGdsValue(1):FullNameProd .
        .
    end.  
  end.    
  open query br-goods for each tt-goods .

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
  ENABLE Btn_OK Btn_Cancel Btn_add Btn_del br-goods
      WITH FRAME Dialog-Frame.
  if p-mode = {&lookup} then do:
  DISABLE Btn_add Btn_del 
      WITH FRAME Dialog-Frame.
  end.      
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

