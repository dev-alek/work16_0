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
define shared temp-table tt-dens-temp no-undo
  field ii as integer
  field key_ as character
  field density as decimal format "9.9999999999"
  field temperature as decimal format "->>>9.<<"
  index pi 
    as primary unique
    ii
.
/* Parameters Definitions ---                                           */
define input parameter p-sr-izm-type as integer no-undo .
define input parameter p-diameter   as decimal no-undo .
define input parameter p-fuel-level as decimal no-undo .
define output parameter p-avg-density as decimal no-undo .
define output parameter p-avg-temperature as decimal no-undo .
define output parameter p-ok as logical no-undo .
/* Local Variable Definitions ---                                       */

{ cmp/showinf.i  }

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

define query br-dens-temp for tt-dens-temp .
define browse br-dens-temp query br-dens-temp exclusive-lock
  display
    tt-dens-temp.key_        label "Уровень " format "X(4)"
    tt-dens-temp.density     label "Значение,г/см3" format "9.9999"
    tt-dens-temp.temperature label "t измер. р,°C" format "->>9.9"
  enable
    tt-dens-temp.density
    tt-dens-temp.temperature
  with size 41 by 10 separators
.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     b-ok AT ROW 1.24 COL 2
     b-cancel AT ROW 1.24 COL 17
     br-dens-temp at row 2.5 col 1
     SPACE(1) SKIP(1)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Таблица измерений плотности"
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
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Таблица измерений плотности */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

on choose of b-ok in frame Dialog-Frame
do :
  define buffer buf1_tt-dens-temp for tt-dens-temp .
  define buffer buf2_tt-dens-temp for tt-dens-temp .
  define buffer buf3_tt-dens-temp for tt-dens-temp .
  case p-sr-izm-type :
    when 3
    then do :
      find first buf1_tt-dens-temp where buf1_tt-dens-temp.ii = 1 .
      find first buf2_tt-dens-temp where buf2_tt-dens-temp.ii = 2 no-error .
      find first buf3_tt-dens-temp where buf3_tt-dens-temp.ii = 3 no-error .
      
      p-avg-density = buf1_tt-dens-temp.density .
      p-avg-temperature = buf1_tt-dens-temp.temperature .
      
      if available buf2_tt-dens-temp
      and not available buf3_tt-dens-temp
      then do :
        p-avg-density = (buf1_tt-dens-temp.density + (3 * buf2_tt-dens-temp.density)) / 4 .
        p-avg-temperature = (buf1_tt-dens-temp.temperature + (3 * buf2_tt-dens-temp.temperature)) / 4 .
      end .
      if available buf2_tt-dens-temp
      and available buf3_tt-dens-temp
      then do :
        p-avg-density = (buf1_tt-dens-temp.density + (6 * buf2_tt-dens-temp.density) + buf3_tt-dens-temp.density) / 8 .  
        p-avg-temperature = (buf1_tt-dens-temp.temperature + (6 * buf2_tt-dens-temp.temperature) + buf3_tt-dens-temp.temperature) / 8 .
      end .
    end .
  end case .
  p-ok = true .
end .

on return of tt-dens-temp.density in browse br-dens-temp
do :
  apply "leave" to self .
end .

on leave of tt-dens-temp.density in browse br-dens-temp
do :
  define variable is-empty as logical no-undo .
  define buffer buf_tt-dens-temp for tt-dens-temp .
  if decimal(tt-dens-temp.density:screen-value in browse br-dens-temp) >= 1
  then do :
    message "Неверное значение плотности!" view-as alert-box .
    return no-apply .
  end .
  assign tt-dens-temp.density = decimal(tt-dens-temp.density:screen-value in browse br-dens-temp) .
  if tt-dens-temp.ii = 1
  then do :
    is-empty = yes .
    for each buf_tt-dens-temp where buf_tt-dens-temp.ii > 1 :
      if buf_tt-dens-temp.density <> 0
      then do :
        is-empty = no .
        leave .
      end . 
    end .
    if is-empty
    then do :
      for each buf_tt-dens-temp where buf_tt-dens-temp.ii > 1 :
        buf_tt-dens-temp.density = decimal(tt-dens-temp.density:screen-value in browse br-dens-temp) .
      end .
      br-dens-temp:refresh() in frame Dialog-Frame .
    end .
  end .
end .

on return of tt-dens-temp.temperature in browse br-dens-temp
do :
  apply "leave" to self .
end .

on leave of tt-dens-temp.temperature in browse br-dens-temp
do :
  define variable is-empty as logical no-undo .
  define buffer buf_tt-dens-temp for tt-dens-temp .
  assign tt-dens-temp.temperature = decimal(tt-dens-temp.temperature:screen-value in browse br-dens-temp) .
  if tt-dens-temp.ii = 1
  then do :
    is-empty = yes .
    for each buf_tt-dens-temp where buf_tt-dens-temp.ii > 1 :
      if buf_tt-dens-temp.temperature <> 0
      then do :
        is-empty = no .
        leave .
      end . 
    end .
    if is-empty
    then do :
      for each buf_tt-dens-temp where buf_tt-dens-temp.ii > 1 :
        buf_tt-dens-temp.temperature = decimal(tt-dens-temp.temperature:screen-value in browse br-dens-temp) .
      end .
      br-dens-temp:refresh() in frame Dialog-Frame .
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
    when 3
    then do :
      find first tt-dens-temp where tt-dens-temp.key_ = "P1" no-error .
      if available tt-dens-temp
      then do :
        empty temp-table tt-dens-temp .
      end .
      find first tt-dens-temp no-error .
      if not available tt-dens-temp
      then do :
        create tt-dens-temp .
        assign
          tt-dens-temp.ii = 1
          tt-dens-temp.key_ = "Pн"
        .
        if (p-diameter >= 2500 and p-fuel-level >= (p-diameter / 2))
        or (p-diameter < 2500 and p-fuel-level >= 500)
        or (p-fuel-level >= 500 and p-fuel-level <= (p-diameter / 2))
        then do :
          create tt-dens-temp .
          assign
            tt-dens-temp.ii = 2
            tt-dens-temp.key_ = "Pср"
          .
        end .
        if (p-diameter >= 2500 and p-fuel-level >= (p-diameter / 2))
        then do :
          create tt-dens-temp .
          assign
            tt-dens-temp.ii = 3
            tt-dens-temp.key_ = "Pв"
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
  ENABLE b-ok b-cancel br-dens-temp
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  open query br-dens-temp for each tt-dens-temp .
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

