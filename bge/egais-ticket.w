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

Список квитанций по накладным ЕГАИС

  Author: 
    Автор: Морозов Александр Сергеевич
    Дата создания: 15/01/27
    Author: Alexandr Morozov
    Creation date: 15/01/27
    
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

using ibs.th.bge.egais.*.

/* Parameters Definitions ---                                           */
define input parameter parparentproc as widget-handle no-undo .
define input parameter egais as class EGAIS no-undo.
define input parameter bh-wb-egais as handle no-undo.

/* Local Variable Definitions ---                                       */

define variable qh-ticket-egais         as handle no-undo.
define variable browse-hdl-ticket-egais as handle no-undo.
define variable bh-ticket-egais         as handle no-undo.
define variable bcol                    as handle extent no-undo.
{ibs/th/bge/egais/wb-egais.i}
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
&Scoped-Define ENABLED-OBJECTS Btn_OK 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-1 FILL-IN-3 FILL-IN-2 FILL-IN-4 ~
FILL-IN-5 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Выход" 
     SIZE 15 BY 1.13
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 119.25 BY 1
     FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 119.25 BY 1
     FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 119.25 BY 1
     FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-4 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 119.25 BY 1
     FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 119.25 BY 1
     FGCOLOR 4  NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     Btn_OK AT ROW 1.25 COL 1.5
     FILL-IN-1 AT ROW 14.71 COL 1.75 NO-LABEL WIDGET-ID 2
     FILL-IN-3 AT ROW 15.71 COL 1.75 NO-LABEL WIDGET-ID 6
     FILL-IN-2 AT ROW 16.71 COL 1.75 NO-LABEL WIDGET-ID 4
     FILL-IN-4 AT ROW 17.71 COL 1.75 NO-LABEL WIDGET-ID 8
     FILL-IN-5 AT ROW 18.71 COL 1.75 NO-LABEL WIDGET-ID 10
     SPACE(0.37) SKIP(0.11)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Квитанция по накладной"
         DEFAULT-BUTTON Btn_OK WIDGET-ID 100.


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

/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME Dialog-Frame
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME Dialog-Frame
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-3 IN FRAME Dialog-Frame
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-4 IN FRAME Dialog-Frame
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-5 IN FRAME Dialog-Frame
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Квитанция по накладной */
DO:
  APPLY "END-ERROR":U TO SELF.
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

  def var ii as int no-undo.

  create query qh-ticket-egais.
  create browse browse-hdl-ticket-egais
    assign 
      title     = 'Связанные документы ЕГАИС'
      frame     = frame {&FRAME-NAME}:handle
      query     = qh-ticket-egais
      x         = 6
      y         = 38
      width     = 119
      height    = 12
      visible   = true
      read-only = true
      sensitive = true
      separators = true
      column-resizable = true
      column-scrolling = true
      triggers:
        on value-changed persistent run local-value-changed.
      end triggers
  .
  if bh-wb-egais = ? then return.
  if bh-wb-egais:buffer-field ("wb-type"):buffer-value begins "расход" or bh-wb-egais:buffer-field ("wb-type"):buffer-value begins "возврат"
  then do:
    bh-ticket-egais = egais:GetHndlTable({&ticket-ras}, bh-wb-egais:buffer-field ("trn-doc-code"):buffer-value).
  end.
  else do:
    bh-ticket-egais = egais:GetHndlTable({&ticket}, bh-wb-egais:buffer-field ("wbregid"):buffer-value).
  end.
  if egais:StatusErr
  then do:
    message egais:Msg view-as alert-box error.
    return.
  end.

  qh-ticket-egais:set-buffers (bh-ticket-egais).
  qh-ticket-egais:query-prepare ("for each tt-ticket").
  qh-ticket-egais:query-open.
  if not bh-ticket-egais = ? 
  then do:
    extent (bcol) = bh-ticket-egais:num-fields.
    do ii = 1 to bh-ticket-egais:num-fields:
      bcol[ii] = browse-hdl-ticket-egais:add-like-column('tt-ticket' + '.' + bh-ticket-egais:buffer-field (ii):name, 0, 'FILL-IN').
      if ii = 5 then bcol[ii]:width = 80.
    end.
  end.

  RUN enable_UI.
  run local-value-changed.
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
  DISPLAY FILL-IN-1 FILL-IN-3 FILL-IN-2 FILL-IN-4 FILL-IN-5 
      WITH FRAME Dialog-Frame.
  ENABLE Btn_OK 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-value-changed Dialog-Frame 
PROCEDURE local-value-changed :
define variable v-str1 as character no-undo.
  define variable v-str2 as character no-undo.
  define variable v-str3 as character no-undo.
  define variable v-str4 as character no-undo.
  define variable v-str5 as character no-undo.
  
  if not bh-ticket-egais:available 
    then return no-apply.
  
  v-str1 = substring (bh-ticket-egais:buffer-field ("comment"):buffer-value, 1, 115).
  v-str2 = substring (bh-ticket-egais:buffer-field ("comment"):buffer-value, 116, 115).
  v-str3 = substring (bh-ticket-egais:buffer-field ("comment"):buffer-value, 231, 115).
  v-str4 = substring (bh-ticket-egais:buffer-field ("comment"):buffer-value, 346, 115).
  v-str5 = substring (bh-ticket-egais:buffer-field ("comment"):buffer-value, 461, 115).
  
  display v-str1 @ fill-in-1 with frame {&frame-name}.
  display v-str2 @ fill-in-3 with frame {&frame-name}.
  display v-str3 @ fill-in-2 with frame {&frame-name}.
  display v-str4 @ fill-in-4 with frame {&frame-name}.
  display v-str5 @ fill-in-5 with frame {&frame-name}.

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

