&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
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

define shared temp-table tt-temps no-undo
  field ii as integer
  field key_ as character
  field temperature as decimal format "->>>9.<<"
  index pi 
    as primary unique
    ii
.

/* Parameters Definitions ---                                           */
define input parameter p-sr-izm-type as integer no-undo .
define input parameter p-diameter   as decimal no-undo .
define input parameter p-fuel-level as decimal no-undo .
define output parameter p-avg-temperature as decimal no-undo .
define output parameter p-ok as logical no-undo .
/* Local Variable Definitions ---                                       */

{ cmp/showinf.i  }

define variable v-num-izm     as integer no-undo .
define variable v-temps-sum   as decimal no-undo .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-ok b-cancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-cancel AUTO-END-KEY 
     LABEL "Отмена" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON b-ok AUTO-GO 
     LABEL "Ввод" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

define query br-temp for tt-temps .
define browse br-temp query br-temp exclusive-lock
  display
    tt-temps.key_         label "Уровень " format "X(4)"
    tt-temps.temperature  label "Значение,°C" format "->>9.9"
  enable
    tt-temps.temperature
  with size 30 by 10 separators
.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     b-ok AT ROW 1.24 COL 2
     b-cancel AT ROW 1.24 COL 17
     br-temp at row 2.5 col 1
     SPACE(1) SKIP(1)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Таблица измерений температуры"
         DEFAULT-BUTTON b-ok CANCEL-BUTTON b-cancel WIDGET-ID 100.


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
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Таблица измерений температуры */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

on choose of b-ok in frame Dialog-Frame
do :
  define buffer buf_tt-temps for tt-temps .
  define buffer buf1_tt-temps for tt-temps .
  define buffer buf2_tt-temps for tt-temps .
  define buffer buf3_tt-temps for tt-temps .
  case p-sr-izm-type :
    when 2 
    then do :
      v-temps-sum = 0 .
      for each buf_tt-temps :
        v-temps-sum = v-temps-sum + buf_tt-temps.temperature .
      end .
      p-avg-temperature = v-temps-sum / v-num-izm .
    end .
    when 3
    then do :
      find first buf1_tt-temps where buf1_tt-temps.ii = 1 .
      find first buf2_tt-temps where buf2_tt-temps.ii = 2 no-error .
      find first buf3_tt-temps where buf3_tt-temps.ii = 3 no-error .
      
      p-avg-temperature = buf1_tt-temps.temperature .
      
      if available buf2_tt-temps
      and not available buf3_tt-temps
      then
        p-avg-temperature = (buf1_tt-temps.temperature + (3 * buf2_tt-temps.temperature)) / 4 .
      
      if available buf2_tt-temps
      and available buf3_tt-temps
      then
        p-avg-temperature = (buf1_tt-temps.temperature + (6 * buf2_tt-temps.temperature) + buf3_tt-temps.temperature) / 8 .  
    end .
  end case .
  p-ok = true .
end .

on return of tt-temps.temperature in browse br-temp
do :
  apply "leave" to self .
end .

on leave of tt-temps.temperature in browse br-temp
do :
  define variable is-empty as logical no-undo .
  define buffer buf_tt-temps for tt-temps .
  assign tt-temps.temperature = decimal(tt-temps.temperature:screen-value in browse br-temp) .
  if tt-temps.ii = 1
  then do :
    is-empty = yes .
    for each buf_tt-temps where buf_tt-temps.ii > 1 :
      if buf_tt-temps.temperature <> 0
      then do :
        is-empty = no .
        leave .
      end . 
    end .
    if is-empty
    then do :
      for each buf_tt-temps where buf_tt-temps.ii > 1 :
        buf_tt-temps.temperature = decimal(tt-temps.temperature:screen-value in browse br-temp) .
      end .
      br-temp:refresh() in frame Dialog-Frame .
    end .
  end .    
end .

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
  p-ok = false .
  run fill-tt .
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

procedure fill-tt :
  define variable ii as integer no-undo .
  case p-sr-izm-type :
    when 2 
    then do :
      v-num-izm = integer(p-fuel-level / 500) .
      if v-num-izm = 0 then v-num-izm = 1 .
      find first tt-temps where tt-temps.key_ = "tн" no-error .
      if available tt-temps
      then do :
        empty temp-table tt-temps .
      end .
      find first tt-temps no-error .
      if not available tt-temps
      then do ii = 1 to v-num-izm :
        create tt-temps .
        assign
          tt-temps.ii = ii
          tt-temps.key_ = "t" + string(ii)
        .        
      end .
    end .
    when 3
    then do :
      find first tt-temps where tt-temps.key_ = "t1" no-error .
      if available tt-temps
      then do :
        empty temp-table tt-temps .
      end .
      find first tt-temps no-error .
      if not available tt-temps
      then do :
        create tt-temps .
        assign
          tt-temps.ii = 1
          tt-temps.key_ = "tн"
        .
        if (p-diameter >= 2500 and p-fuel-level >= (p-diameter / 2))
        or (p-diameter < 2500 and p-fuel-level >= 500)
        or (p-fuel-level >= 500 and p-fuel-level <= (p-diameter / 2))
        then do :
          create tt-temps .
          assign
            tt-temps.ii = 2
            tt-temps.key_ = "tср"
          .
        end .
        if (p-diameter >= 2500 and p-fuel-level >= (p-diameter / 2))
        then do :
          create tt-temps .
          assign
            tt-temps.ii = 3
            tt-temps.key_ = "tв"
          .
        end .
      end .
    end .
  end case .
  
end procedure .

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
  ENABLE b-ok b-cancel br-temp
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  open query br-temp for each tt-temps .
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

