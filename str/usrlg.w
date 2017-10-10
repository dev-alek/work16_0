&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases
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

История пользователя - просмотр

Автор: Белоусов Илья Александрович
Дата создания: 04/04/08
Author: Ilia Belousov
Creation date: 04/04/08

Input:

Output:

*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
define temp-table temp_userhist     no-undo
    field ush-key   as integer
    field ushDate   as date
    field ushtime   as integer
    field ushTable  as character
    field ushDesc   as character

    index pi is primary unique
        ush-key
.
define temp-table temp_userhist-line     no-undo
    field usl-key       as integer
    field ush-key       as integer
    field uslDesc  as character

    index pi is primary unique
        usl-key
.
define variable v-usrlg-ush-key    as integer      no-undo.
define variable v-usrlg-usl-key    as integer      no-undo.

/* Parameters Definitions ---                                           */
define input parameter parparentproc    as handle           no-undo.
define input parameter p-userid         as character        no-undo.

/* Local Variable Definitions ---                                       */
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "История пользователя - просмотр".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ gbl/key-rec.i  }
{ cmp/showinf.i  }
define buffer buf_head_c-user-log        for c-user-log.
define buffer buf_line_c-user-log        for c-user-log.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME br-head

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES buf_head_c-user-log buf_line_c-user-log

/* Definitions for BROWSE br-head                                       */
&Scoped-define FIELDS-IN-QUERY-br-head buf_head_c-user-log.corr-date string( buf_head_c-user-log.corr-time, "hh:mm:ss" ) buf_head_c-user-log.head-table buf_head_c-user-log.des get-unique-key( buf_head_c-user-log.uniq-key-rec )
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-head
&Scoped-define SELF-NAME br-head
&Scoped-define OPEN-QUERY-br-head run local-open-query-head in this-procedure. /* OPEN QUERY {&SELF-NAME} FOR EACH buf_head_c-user-log NO-LOCK INDEXED-REPOSITION. */.
&Scoped-define TABLES-IN-QUERY-br-head buf_head_c-user-log
&Scoped-define FIRST-TABLE-IN-QUERY-br-head buf_head_c-user-log


/* Definitions for BROWSE br-line                                       */
&Scoped-define FIELDS-IN-QUERY-br-line buf_line_c-user-log.corr-date string( buf_line_c-user-log.corr-time, "hh:mm:ss" ) buf_line_c-user-log.des get-unique-key( buf_line_c-user-log.uniq-key-rec )
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-line
&Scoped-define SELF-NAME br-line
&Scoped-define OPEN-QUERY-br-line run local-open-query-line in this-procedure. /* OPEN QUERY {&SELF-NAME} FOR EACH buf_line_c-user-log NO-LOCK INDEXED-REPOSITION. */.
&Scoped-define TABLES-IN-QUERY-br-line buf_line_c-user-log
&Scoped-define FIRST-TABLE-IN-QUERY-br-line buf_line_c-user-log


/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Dialog-Frame ~
    ~{&OPEN-QUERY-br-head}~
    ~{&OPEN-QUERY-br-line}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-exit b-cancel fi-date-to bt-doc-hist ~
b-help br-head br-line
&Scoped-Define DISPLAYED-OBJECTS fi-date-to

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD get-unique-key Dialog-Frame
FUNCTION get-unique-key RETURNS CHARACTER
  ( p-unique-key-rec as character )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-cancel AUTO-END-KEY
     LABEL "&Отмена"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-exit AUTO-GO
     LABEL "В&ыход"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-help
     LABEL "Помо&щь"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-doc-hist
     LABEL "Документ"
     SIZE 10 BY 1.

DEFINE VARIABLE fi-date-to AS DATE FORMAT "99.99.9999":U
     LABEL "До даты"
     VIEW-AS FILL-IN
     SIZE 14 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-head FOR
      buf_head_c-user-log SCROLLING.

DEFINE QUERY br-line FOR
      buf_line_c-user-log SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-head
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-head Dialog-Frame _FREEFORM
  QUERY br-head NO-LOCK DISPLAY
      buf_head_c-user-log.corr-date FORMAT "99.99.9999":U
      string( buf_head_c-user-log.corr-time, "hh:mm:ss" ) FORMAT "X(9)":U column-label "Время"
      buf_head_c-user-log.head-table FORMAT "x(20)":U
      buf_head_c-user-log.des FORMAT "x(40)":U
      get-unique-key( buf_head_c-user-log.uniq-key-rec ) FORMAT "x(30)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 98.5 BY 13.5 FIT-LAST-COLUMN.

DEFINE BROWSE br-line
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-line Dialog-Frame _FREEFORM
  QUERY br-line NO-LOCK DISPLAY
      buf_line_c-user-log.corr-date FORMAT "99.99.9999":U
      string( buf_line_c-user-log.corr-time, "hh:mm:ss" ) FORMAT "X(9)":U  column-label "Время"
      buf_line_c-user-log.des FORMAT "x(40)":U
      get-unique-key( buf_line_c-user-log.uniq-key-rec ) FORMAT "x(30)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 98.5 BY 7.75 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     b-exit AT ROW 1 COL 1
     b-cancel AT ROW 1 COL 11
     fi-date-to AT ROW 1 COL 31 COLON-ALIGNED WIDGET-ID 2
     bt-doc-hist AT ROW 1 COL 79 WIDGET-ID 4
     b-help AT ROW 1 COL 89.5
     br-head AT ROW 2.25 COL 1 WIDGET-ID 200
     br-line AT ROW 15.75 COL 1 WIDGET-ID 300
     SPACE(0.37) SKIP(0.12)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE
         TITLE "История действий пользователя"
         CANCEL-BUTTON b-cancel WIDGET-ID 100.


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
/* BROWSE-TAB br-head b-help Dialog-Frame */
/* BROWSE-TAB br-line br-head Dialog-Frame */
ASSIGN
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-head
/* Query rebuild information for BROWSE br-head
     _START_FREEFORM
run local-open-query-head in this-procedure. /* OPEN QUERY {&SELF-NAME} FOR EACH buf_head_c-user-log NO-LOCK INDEXED-REPOSITION. */
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-head */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-line
/* Query rebuild information for BROWSE br-line
     _START_FREEFORM
run local-open-query-line in this-procedure. /* OPEN QUERY {&SELF-NAME} FOR EACH buf_line_c-user-log NO-LOCK INDEXED-REPOSITION. */
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-line */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* История действий пользователя */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-exit Dialog-Frame
ON CHOOSE OF b-exit IN FRAME Dialog-Frame /* Выход */
DO:
{ gbl/stdbtn.i }

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-head
&Scoped-define SELF-NAME br-head
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-head Dialog-Frame
ON VALUE-CHANGED OF br-head IN FRAME Dialog-Frame
DO:
    {&OPEN-QUERY-br-line}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-doc-hist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-doc-hist Dialog-Frame
ON CHOOSE OF bt-doc-hist IN FRAME Dialog-Frame /* Документ */
DO:
    if available buf_head_c-user-log
    then do:
        run str/usrlgd.p (
              input parparentproc
            , input buf_head_c-user-log.head-table
            , input buf_head_c-user-log.head-table-key
        ) no-error.
        if error-status :error
        then do:
            message
                     vss-workfile vss-revision vss-description
                skip(1)
                skip "Ошибка вызова истории по документу"
                skip return-value
                skip trim( error-status :get-message( 1 ) )
                     trim( error-status :get-message( 2 ) )
                     trim( error-status :get-message( 3 ) )
            view-as alert-box error.
            undo, return no-apply substitute( "Ошибка вызова истории по документу. &1. &2"
                                        , return-value
                                        , trim( error-status :get-message( 1 ) ) ).
        end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-date-to
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-date-to Dialog-Frame
ON RETURN OF fi-date-to IN FRAME Dialog-Frame /* До даты */
DO:
    assign
        fi-date-to
    .
    {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame


/* ***************************  Main Block  *************************** */

{ gbl/app_help.i }
{ gbl/ed_date.i fi-date-to }
/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    run init-fields in this-procedure .
    RUN enable_UI.
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
  DISPLAY fi-date-to
      WITH FRAME Dialog-Frame.
  ENABLE b-exit b-cancel fi-date-to bt-doc-hist b-help br-head br-line
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-unique-key-proc Dialog-Frame
PROCEDURE get-unique-key-proc :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p-unique-key-rec    AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER p-unique-key-string AS CHARACTER   NO-UNDO.

    define variable v-field-list        as character    no-undo.
    define variable v-field-value-list  as character    no-undo.
do
on error undo, return error
:
    run gen-key-fv in this-procedure (
          input p-unique-key-rec
        , output v-field-list
        , output v-field-value-list
    ).
    assign
        p-unique-key-string = replace( v-field-value-list, {&delim-key}, ",":U )
    .
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-fields Dialog-Frame
PROCEDURE init-fields :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
do
on error undo, return error
:
end.
END PROCEDURE. /* init-fields */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query-head Dialog-Frame
PROCEDURE local-open-query-head :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
do
on error undo, return error
:
    OPEN QUERY br-head
      FOR EACH buf_head_c-user-log NO-LOCK
         where buf_head_c-user-log.corr-user-name = p-userid
           and buf_head_c-user-log.corr-date     <= ( if fi-date-to = ? then 12/31/5000 else fi-date-to )
           and buf_head_c-user-log.head-table-key = buf_head_c-user-log.uniq-key-rec
      by buf_head_c-user-log.corr-date descending
      by buf_head_c-user-log.corr-time descending
    INDEXED-REPOSITION.
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query-line Dialog-Frame
PROCEDURE local-open-query-line :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
do
on error undo, return error
:
    if available buf_head_c-user-log
    then do:
        OPEN QUERY br-line
          FOR EACH buf_line_c-user-log NO-LOCK
              where buf_line_c-user-log.corr-user-name = p-userid
                and buf_line_c-user-log.head-table-key = buf_head_c-user-log.uniq-key-rec
        INDEXED-REPOSITION.
    end.
    else do:
        OPEN QUERY br-line
          FOR EACH buf_line_c-user-log NO-LOCK
              where buf_line_c-user-log.head-table-key = "-1":U
        INDEXED-REPOSITION.
    end.
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION get-unique-key Dialog-Frame
FUNCTION get-unique-key RETURNS CHARACTER
  ( p-unique-key-rec as character ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
    DEFINE variable v-unique-key-string     AS CHARACTER   NO-UNDO.

    run get-unique-key-proc in this-procedure (
          input p-unique-key-rec
        , output v-unique-key-string
    ).
  RETURN v-unique-key-string.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
