&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases
          ub               PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER buf_rcs-retail1product FOR ub.rcs-retail1product.
DEFINE BUFFER buf_rcs-retail1subject FOR ub.rcs-retail1subject.
DEFINE BUFFER X_egais-clients FOR ub.egais-clients.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Привязка ЕГАИС классификатора клиентов к справочнику клиентов

Автор: Хныкин Павел Андреевич
Дата создания: 12/17/07
Author: Pavel Khnykin
Creation date: 12/17/07

*/
/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
define input  parameter parparentproc as handle    no-undo .
/*define input  parameter p-supp-code   as character no-undo . /* если не ?, то позиционировать на запись */*/

/* Local Variable Definitions ---                                       */
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Привязка ЕГАИС классификатора клиентов к справочнику клиентов".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ gbl/waitfram.i }
{ cmp/showinf.i  }
{ gbl/flt-def.i  }
{ gbl/fltfield.i }
{ gbl/fltopend.i defproc }

define variable sort-column-name as character no-undo.
define variable filter-point     as character NO-UNDO INIT "egaiscli".
define variable filter-label     as character NO-UNDO INIT "Привязка клиентов к ЕГАИС-классификатору поставщиков".
define variable filter-point0    as character NO-UNDO INIT "egaiscli".
define variable filter-label0    as character NO-UNDO INIT "Привязка клиентов к ЕГАИС-классификатору поставщиков".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME br-cli

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES X_egais-clients

/* Definitions for BROWSE br-cli                                        */
&Scoped-define FIELDS-IN-QUERY-br-cli X_egais-clients.supp-code-egais ~
X_egais-clients.supp-name ~
(STRING(X_egais-clients.obj-code , "999999999")  +  " "  +  TRIM (X_egais-clients.obj-type)) ~
X_egais-clients.supp-inn
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-cli
&Scoped-define QUERY-STRING-br-cli FOR EACH X_egais-clients NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-cli OPEN QUERY br-cli FOR EACH X_egais-clients NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-cli X_egais-clients
&Scoped-define FIRST-TABLE-IN-QUERY-br-cli X_egais-clients


/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Dialog-Frame ~
    ~{&OPEN-QUERY-br-cli}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-exit b-cli b-unlink b-sch b-help br-cli ~
ed-cli
&Scoped-Define DISPLAYED-OBJECTS ed-cli

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-cli
     LABEL "П&оставщик"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-exit AUTO-GO
     LABEL "&Выход"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-help
     LABEL "Помо&щь"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-sch
     LABEL "Фильтр"
     SIZE 10 BY 1.

DEFINE BUTTON b-unlink
     LABEL "&Снять"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE ed-cli AS CHARACTER
     VIEW-AS EDITOR
     SIZE 90 BY 3.25
     FGCOLOR 4  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-cli FOR
      X_egais-clients SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-cli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-cli Dialog-Frame _STRUCTURED
  QUERY br-cli NO-LOCK DISPLAY
      X_egais-clients.supp-code-egais COLUMN-LABEL "Код ЕГАИС" FORMAT "X(20)":U
      X_egais-clients.supp-name COLUMN-LABEL "Официальное название" FORMAT "x(30)":U
      (STRING(X_egais-clients.obj-code , "999999999")  +  " "  +  TRIM (X_egais-clients.obj-type)) COLUMN-LABEL "Контрагент TH" FORMAT "X(13)":U
      X_egais-clients.supp-inn COLUMN-LABEL "ИНН" FORMAT "x(8)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 90 BY 16.75 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     b-exit AT ROW 1 COL 1
     b-cli AT ROW 1 COL 21
     b-unlink AT ROW 1 COL 31
     b-sch AT ROW 1 COL 66 WIDGET-ID 12
     b-help AT ROW 1 COL 76
     br-cli AT ROW 3 COL 1
     ed-cli AT ROW 19.75 COL 1 NO-LABEL
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE
         TITLE "Классификатор ЕГАИС"
         DEFAULT-BUTTON b-exit.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Temp-Tables and Buffers:
      TABLE: buf_rcs-retail1product B "?" ? ub rcs-retail1product
      TABLE: buf_rcs-retail1subject B "?" ? ub rcs-retail1subject
      TABLE: X_egais-clients B "?" ? ub egais-clients
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
/* BROWSE-TAB br-cli b-help Dialog-Frame */
ASSIGN
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

ASSIGN
       br-cli:COLUMN-MOVABLE IN FRAME Dialog-Frame         = TRUE.

ASSIGN
       ed-cli:READ-ONLY IN FRAME Dialog-Frame        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-cli
/* Query rebuild information for BROWSE br-cli
     _TblList          = "X_egais-clients"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.X_egais-clients.supp-code-egais
"X_egais-clients.supp-code-egais" "Код ЕГАИС" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.X_egais-clients.supp-name
"X_egais-clients.supp-name" "Официальное название" "x(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"(STRING(X_egais-clients.obj-code , ""999999999"")  +  "" ""  +  TRIM (X_egais-clients.obj-type))" "Контрагент TH" "X(13)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.X_egais-clients.supp-inn
"X_egais-clients.supp-inn" "ИНН" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-cli */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Классификатор ЕГАИС */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-cli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-cli Dialog-Frame
ON CHOOSE OF b-cli IN FRAME Dialog-Frame /* Поставщик */
DO:
  { gbl/stdbtn.i }

  if not available X_egais-clients then return no-apply.
  do on error undo, return no-apply :
    run proc-b-cli in this-procedure .
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-sch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-sch Dialog-Frame
ON CHOOSE OF b-sch IN FRAME Dialog-Frame /* Фильтр */
DO:
  run proc-b-sch IN THIS-PROCEDURE NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-unlink
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-unlink Dialog-Frame
ON CHOOSE OF b-unlink IN FRAME Dialog-Frame /* Снять */
DO:
  { gbl/stdbtn.i }

  if not available X_egais-clients then return no-apply.

  do on error undo, return no-apply :
    run proc-b-unlink in this-procedure .
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-cli
&Scoped-define SELF-NAME br-cli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-cli Dialog-Frame
ON VALUE-CHANGED OF br-cli IN FRAME Dialog-Frame
DO:
  run proc-val-change-br-cli in this-procedure no-error .
  if error-status :error then return no-apply.
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
{ gbl/setfltnm.i }
{ gbl/hot-key.i b-exit }
{ gbl/brwrepos.i &browse-name="br-cli" &line-num=9 }


/*перемещение колонок*/
{ gbl/mv-clmn.i
  &browse-name = "br-cli"
  &frame-name = "{&frame-name}"
  &ext-col = 4
  &start-column = 2
}

{ gbl/brwrefre.i "run open-br in this-procedure ( input yes, input no, input '':U ) no-error." }


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN my-enable in this-procedure .
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
  DISPLAY ed-cli
      WITH FRAME Dialog-Frame.
  ENABLE b-exit b-cli b-unlink b-sch b-help br-cli ed-cli
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE my-enable Dialog-Frame
PROCEDURE my-enable :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  display
    ed-cli
  with frame {&frame-name}.
  enable
    b-exit
    b-cli
    b-unlink
    b-sch
    b-help
    br-cli
    ed-cli
  with frame {&frame-name}.
  view frame {&frame-name}.
  run open-br in this-procedure ( input yes, input no, input '':U ).

  apply "entry" to br-cli in frame {&frame-name}.
  run proc-val-change-br-cli in this-procedure .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE open-br Dialog-Frame
PROCEDURE open-br :
  define input  parameter p-open-query     as logical   no-undo .
  define input  parameter p-find-next      as logical   no-undo .
  define input  parameter p-find-condition as character no-undo .

  define variable sort-column-phrase  as character  no-undo .
  define variable l-query-was-opened  as logical    no-undo .
  define variable title0              as character  no-undo .

do
on error undo, return error return-value
:
  run waitfram-show in this-procedure ( "Подождите..." ) .

  case sort-column-name :
    when "" then do:
      assign
        sort-column-phrase = ""
      .
    end.
    otherwise do:
      assign
        sort-column-phrase = "by " + sort-column-name
      .
    end.
  end case.

  &scop flt-open-debug-file

  &scop flt-open-open-query         open query br-cli for each X_egais-clients no-lock

  &scop flt-open-dyn_open-query     for each X_egais-clients no-lock

  &scop flt-open-query-handle      QUERY br-cli:handle

  &scop flt-open-query-was-opened   l-query-was-opened

  &scop flt-open-sort-column-phrase sort-column-phrase

  &scop flt-open-call-point         filter-point

  &scop flt-open-set-filter-name    set-filter-name

  &scop flt-open-indexed-reposition INDEXED-REPOSITION

  filter-point = filter-point0 .

  title0 = "Привязка клиентов к ЕГАИС-классификатору поставщиков".


  assign
  frame {&frame-name}:title = substitute("&1", title0)
  filter-label = substitute("&1"
                            , frame {&frame-name}:title
                            )
  .
  { gbl/fltopend.i
        &where-cond = " yes "
        &dyn_where-cond = " substitute('yes') "
        &use-ind    = "  "
        &by         = "  "
  }

  apply "entry" to br-cli.
  if available x_egais-clients then do:
      apply "value-changed":u to {&browse-name}.
  end.

  run waitfram-hide in this-procedure .

end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-b-cli Dialog-Frame
PROCEDURE proc-b-cli :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  define buffer buf_egais-clients  for ub.egais-clients .
  define buffer sch_egais-clients  for ub.egais-clients .
  define buffer buf_clients        for ub.clients.

  define variable v-rid-list as character no-undo .
  define variable v-rid      as recid     no-undo .

  find first buf_clients no-lock
    where buf_clients.obj-type =  X_egais-clients.obj-type
      and buf_clients.obj-code =  X_egais-clients.obj-code
  no-error .
  assign
    v-rid = if available buf_clients then recid(buf_clients) else ?
  .
  run ref/cli-all.w ( parparentproc
                    , input "b-sel"
                    , {&cmp}
                    , ?
                    , ?
                    , v-rid
                    , ?
                    , ?
                    , output  v-rid-list
                    ) .
  find first buf_clients no-lock
    where recid(buf_clients) = integer(v-rid-list)
  no-error .
  if available buf_clients then do:
    find first sch_egais-clients no-lock
      where sch_egais-clients.supp-id <> X_egais-clients.supp-id
        and sch_egais-clients.obj-type = buf_clients.obj-type
        and sch_egais-clients.obj-code = buf_clients.obj-code
    no-error .
    if available sch_egais-clients then do:
        message
          substitute( "Уже есть запись в классификаторе ЕГАИС (код: &1 , &2) &3 привязаная к клиенту &4 &5."
                    , sch_egais-clients.supp-code-egais
                    , sch_egais-clients.supp-name
                    , {&new-line}
                    , buf_clients.obj-type
                    , buf_clients.obj-code
                    )
        view-as alert-box error.
        return error.
    end.
    find first buf_egais-clients exclusive-lock
      where recid(buf_egais-clients) = recid(X_egais-clients)
    .
    assign
      buf_egais-clients.obj-type = buf_clients.obj-type
      buf_egais-clients.obj-code = buf_clients.obj-code
    .
    release buf_egais-clients.
    br-cli :refresh() in frame {&frame-name}.
    apply "entry" to br-cli in frame {&frame-name}.
    run proc-val-change-br-cli in this-procedure .
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-b-sch Dialog-Frame
PROCEDURE proc-b-sch :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
define variable v-ri as rowid     no-undo .

do
on error undo, return error return-value
:
  assign
    v-ri = (if avail X_egais-clients then rowid(X_egais-clients) else ?)
    tbl = {&table_egais-clients}
    join-tbl = 'X_egais-clients'
    fld = ""
    lab = ""
    spr = ""
    dim = '0'
  .

  run fltfield-add in this-procedure('supp-code-egais', 'Код ЕГАИС', '',
  input-output fld, input-output lab, input-output spr, input-output dim)  no-error.

  run fltfield-add in this-procedure('supp-name', 'Официальное название', '',
  input-output fld, input-output lab, input-output spr, input-output dim)  no-error.

  run fltfield-add in this-procedure('supp-inn', 'ИНН', '',
  input-output fld, input-output lab, input-output spr, input-output dim)  no-error.

  run fltfield-add in this-procedure('obj-type{&delim-flt}obj-code', 'Клиент', 'cli',
  input-output fld, input-output lab, input-output spr, input-output dim)  no-error.



do on stop undo, leave:
    run gbl/filter.w ( input parparentproc
                     , input filter-point + {&delim-par} + filter-label
                     , input tbl
                     , input join-tbl
                     , input fld
                     , input lab
                     , input spr
                     , input dim
                     ) .
    run open-br in this-procedure ( input yes, input no, input '':u).
    if v-ri <> ? then do:
      reposition br-cli to rowid v-ri no-error.
    end.
    apply "entry" to br-cli in frame {&frame-name} .
    apply "value-changed" to br-cli.
end .

end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-b-unlink Dialog-Frame
PROCEDURE proc-b-unlink :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  define buffer buf_egais-clients  for ub.egais-clients .

  define variable v-obj-type  like ub.clients.obj-type no-undo .
  define variable v-obj-code  like ub.clients.obj-code no-undo .

do on error undo, return error :
    find first buf_egais-clients exclusive-lock
      where recid(buf_egais-clients) = recid(X_egais-clients)
    .
    assign
      buf_egais-clients.obj-type = v-obj-type
      buf_egais-clients.obj-code = v-obj-code
    .
    release buf_egais-clients.
    br-cli :refresh() in frame {&frame-name}.
    apply "entry" to br-cli in frame {&frame-name}.
    run proc-val-change-br-cli in this-procedure .
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-val-change-br-cli Dialog-Frame
PROCEDURE proc-val-change-br-cli :
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
  define buffer buf_clients for ub.clients.

  define variable  v-str  as character no-undo .

  if available X_egais-clients then do:
    if X_egais-clients.obj-type <> "" then do:
      find first buf_clients no-lock
        where buf_clients.obj-type = X_egais-clients.obj-type
          and buf_clients.obj-code = X_egais-clients.obj-code
      no-error .
    end.
    assign
      ed-cli:screen-value in frame {&frame-name} = substitute( "&1&2Код ЕГАИС: &3&2Контрагент TH: &4&2&5&2&6"
                                            , X_egais-clients.supp-name
                                            , {&new-line}
                                            , X_egais-clients.supp-code-egais
                                            , (string(X_egais-clients.obj-code , "999999999")  +  " "  +  trim (X_egais-clients.obj-type)) +
                                              ( if available buf_clients then string( " - " + buf_clients.obj-name ) else "" )
                                            , trim(X_egais-clients.supp-adr-ur)
                                            , trim(X_egais-clients.supp-head-fio)
                                            )
    .

  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME