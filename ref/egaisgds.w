&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases
          ub               PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER X_egais-gds FOR ub.egais-gds.
DEFINE BUFFER X_rcs-retail1product FOR ub.rcs-retail1product.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Привязка ЕГАИС классификатора клиентов к справочнику товаров

Автор: Хныкин Павел Андреевич
Дата создания: 12/18/07
Author: Pavel Khnykin
Creation date: 12/18/07
*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
define input  parameter parparentproc as handle    no-undo .

/* Local Variable Definitions ---                                       */
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Привязка ЕГАИС классификатора алкогольной продукции к справочнику товаров".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ gbl/waitfram.i }
{ cmp/showinf.i  }
{ gbl/color.i    }
{ gbl/flt-def.i  }
{ gbl/fltfield.i }
{ gbl/fltopend.i defproc }

define variable sort-column-name as character no-undo.
define variable filter-point     as character NO-UNDO INIT "egaisgds".
define variable filter-label     as character NO-UNDO INIT "Привязка алкогольной продукции к ЕГАИС-классификатору".
define variable filter-point0    as character NO-UNDO INIT "egaisgds".
define variable filter-label0    as character NO-UNDO INIT "Привязка алкогольной продукции к ЕГАИС-классификатору".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME br-alc-gds

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES X_egais-gds

/* Definitions for BROWSE br-alc-gds                                    */
&Scoped-define FIELDS-IN-QUERY-br-alc-gds X_egais-gds.alpr-code-egais ~
X_egais-gds.producer-name get-artic(X_egais-gds.gds-code) ~
X_egais-gds.volume
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-alc-gds
&Scoped-define QUERY-STRING-br-alc-gds FOR EACH X_egais-gds NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-alc-gds OPEN QUERY br-alc-gds FOR EACH X_egais-gds NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-alc-gds X_egais-gds
&Scoped-define FIRST-TABLE-IN-QUERY-br-alc-gds X_egais-gds


/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Dialog-Frame ~
    ~{&OPEN-QUERY-br-alc-gds}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-exit b-gds b-unlink b-sch b-help ~
br-alc-gds ed-gds
&Scoped-Define DISPLAYED-OBJECTS ed-gds

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD get-artic Dialog-Frame
FUNCTION get-artic RETURNS CHARACTER
  ( p-gds-code as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-exit AUTO-GO
     LABEL "&Выход"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-gds
     LABEL "&Товар"
     SIZE 10 BY 1.

DEFINE BUTTON b-help
     LABEL "&Помощь"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-sch
     LABEL "Фильтр"
     SIZE 10 BY 1.

DEFINE BUTTON b-unlink
     LABEL "&Снять"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE ed-gds AS CHARACTER
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 90 BY 3.75
     FGCOLOR 4  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-alc-gds FOR
      X_egais-gds SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-alc-gds
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-alc-gds Dialog-Frame _STRUCTURED
  QUERY br-alc-gds NO-LOCK DISPLAY
      X_egais-gds.alpr-code-egais COLUMN-LABEL "Код ЕГАИС" FORMAT "x(20)":U
      X_egais-gds.producer-name COLUMN-LABEL "Производитель" FORMAT "x(30)":U
      get-artic(X_egais-gds.gds-code) COLUMN-LABEL "Артикул" FORMAT "X(16)":U
      X_egais-gds.volume COLUMN-LABEL "Объем" FORMAT "->,>>>,>>9.999":U
            WIDTH 19
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 90 BY 16.25 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     b-exit AT ROW 1 COL 1
     b-gds AT ROW 1 COL 21
     b-unlink AT ROW 1 COL 31
     b-sch AT ROW 1 COL 66 WIDGET-ID 12
     b-help AT ROW 1 COL 76
     br-alc-gds AT ROW 3 COL 1
     ed-gds AT ROW 19.25 COL 1 NO-LABEL
     SPACE(0.00) SKIP(0.07)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE
         TITLE "Классификатор ЕГАИС алкогольной продукции".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Temp-Tables and Buffers:
      TABLE: X_egais-gds B "?" ? ub egais-gds
      TABLE: X_rcs-retail1product B "?" ? ub rcs-retail1product
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
/* BROWSE-TAB br-alc-gds b-help Dialog-Frame */
ASSIGN
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

ASSIGN
       ed-gds:READ-ONLY IN FRAME Dialog-Frame        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-alc-gds
/* Query rebuild information for BROWSE br-alc-gds
     _TblList          = "X_egais-gds"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.X_egais-gds.alpr-code-egais
"X_egais-gds.alpr-code-egais" "Код ЕГАИС" "x(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.X_egais-gds.producer-name
"X_egais-gds.producer-name" "Производитель" "x(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"get-artic(X_egais-gds.gds-code)" "Артикул" "X(16)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.X_egais-gds.volume
"X_egais-gds.volume" "Объем" "->,>>>,>>9.999" "decimal" ? ? ? ? ? ? no ? no no "19" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-alc-gds */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Классификатор ЕГАИС алкогольной продукции */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-gds
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-gds Dialog-Frame
ON CHOOSE OF b-gds IN FRAME Dialog-Frame /* Товар */
DO:
  { gbl/stdbtn.i }

  if not available X_egais-gds then return no-apply.
  run proc-b-gds in this-procedure no-error .
  if error-status :error then return no-apply.
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

  if not available X_egais-gds then return no-apply.
  do on error undo, return no-apply :
    run proc-b-unlink in this-procedure .
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-alc-gds
&Scoped-define SELF-NAME br-alc-gds
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-alc-gds Dialog-Frame
ON VALUE-CHANGED OF br-alc-gds IN FRAME Dialog-Frame
DO:
  if not available X_egais-gds then return no-apply.
   assign
    ed-gds:screen-value = substitute("Код ЕГАИС: &1&2Артикул: &3 Производитель: &4&2Объем: &5&2Описание: &6"
                                    , X_egais-gds.alpr-code-egais
                                    , {&new-line}
                                    , get-artic(X_egais-gds.gds-code)
                                    , X_egais-gds.producer-name
                                    , trim(string( X_egais-gds.volume , "->>>,>>>,>>>,>>9.999" ))
                                    , X_egais-gds.alpr-name
                                    )
  .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame


{ gbl/app_help.i }
{ gbl/hot-key.i b-exit }
{ gbl/setfltnm.i }

{ gbl/brwrepos.i &browse-name="br-alc-gds" &line-num=9 }


/*перемещение колонок*/
{ gbl/mv-clmn.i
  &browse-name = "br-alc-gds"
  &frame-name = "{&frame-name}"
  &ext-col = 4
  &start-column = 2
}

{ gbl/brwrefre.i "run open-br in this-procedure ( input yes, input no, input '':u) no-error." }


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  run my-enable in this-procedure .
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
  DISPLAY ed-gds
      WITH FRAME Dialog-Frame.
  ENABLE b-exit b-gds b-unlink b-sch b-help br-alc-gds ed-gds
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
    ed-gds
  with frame {&frame-name}.
  enable
    b-exit
    b-gds
    b-unlink
    b-sch
    b-help
    br-alc-gds
    ed-gds
  with frame {&frame-name}.
  view frame {&frame-name}.
  run open-br in this-procedure ( input yes, input no, input '':u) .
  if available X_rcs-retail1product then do:
    apply "entry":U to br-alc-gds.
  end.
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
  run waitfram-show in this-procedure ("Подождите...").

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

  &scop flt-open-open-query         open query br-alc-gds for each X_egais-gds no-lock

  &scop flt-open-dyn_open-query     for each X_egais-gds no-lock

  &scop flt-open-query-handle      QUERY br-alc-gds:handle

  &scop flt-open-query-was-opened   l-query-was-opened

  &scop flt-open-sort-column-phrase sort-column-phrase

  &scop flt-open-call-point         filter-point

  &scop flt-open-set-filter-name    set-filter-name

  &scop flt-open-indexed-reposition INDEXED-REPOSITION

  filter-point = filter-point0 .

  title0 = "Привязка алкогольной продукции к ЕГАИС-классификатору".


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

  apply "entry" to br-alc-gds.
  if available x_egais-gds then do:
      apply "value-changed":u to {&browse-name}.
  end.

  run waitfram-hide in this-procedure .
end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-b-gds Dialog-Frame
PROCEDURE proc-b-gds :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  define buffer buf_goods     for ub.goods.
  define buffer buf_egais-gds  for ub.egais-gds.
  define buffer sch_egais-gds  for ub.egais-gds.

  define variable v-gds-recid-list  as character no-undo .
  define variable v-gds-recid       as recid     no-undo .

  find first buf_goods no-lock
    where buf_goods.gds-code = X_egais-gds.gds-code
  no-error .
  assign
    v-gds-recid = if available buf_goods then recid( buf_goods ) else ?
  .

  run ref/gds-ref.p ( input parparentproc
                    , input "b-sel"
                    , input {&current}
                    , input {&all}
                    , input ?
                    , input v-gds-recid
                    , input ?
                    , input ?
                    , input ?
                    , input ?
                    , input ?
                    , input ?
                    , output v-gds-recid-list
                    ).

  if v-gds-recid-list <> '' then do:
      assign
          v-gds-recid = integer( entry( 1, v-gds-recid-list ) )
      .
      find first buf_goods no-lock
        where recid(buf_goods) = v-gds-recid
      no-error .
      if available buf_goods then do:
        find first sch_egais-gds no-lock
          where sch_egais-gds.gds-code = buf_goods.gds-code
        no-error.
        if available sch_egais-gds
        then do:
        message
          substitute( "Уже есть запись в классификаторе ЕГАИС (код: &1 ) &2,&3привязаная к товару &4."
                    , sch_egais-gds.alpr-code-egais
                    , sch_egais-gds.alpr-name
                    , {&new-line}
                    , buf_goods.artic
                    )
        view-as alert-box error.
        return error.

        end.

        find first buf_egais-gds exclusive-lock
          where recid(buf_egais-gds) = recid(X_egais-gds)
        .
        if available buf_egais-gds then do:
          assign
            buf_egais-gds.gds-code = buf_goods.gds-code
          .
          release buf_egais-gds.
          br-alc-gds:refresh() in frame {&frame-name}.
          apply "value-changed":U to br-alc-gds in frame {&frame-name}.
        end.
      end.
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
    v-ri = (if avail X_egais-gds then rowid(X_egais-gds) else ?)
    tbl = {&table_egais-gds}
    join-tbl = 'X_egais-gds'
    fld = ""
    lab = ""
    spr = ""
    dim = '0'
  .


  run fltfield-add in this-procedure('alpr-code-egais', 'Код ЕГАИС', '',
  input-output fld, input-output lab, input-output spr, input-output dim)  no-error.

  run fltfield-add in this-procedure('alpr-name', 'Название', '',
  input-output fld, input-output lab, input-output spr, input-output dim)  no-error.

  run fltfield-add in this-procedure('producer-name', 'Производитель', '',
  input-output fld, input-output lab, input-output spr, input-output dim)  no-error.

  run fltfield-add in this-procedure('volume', 'Объем', '',
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
      reposition br-alc-gds to rowid v-ri no-error.
    end.
    apply "entry" to br-alc-gds in frame {&frame-name} .
    apply "value-changed" to br-alc-gds.
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
  define buffer buf_egais-gds  for ub.egais-gds.

  define variable v-gds-code like ub.goods.gds-code no-undo .

do on error undo, return error :

  find first buf_egais-gds exclusive-lock
    where recid(buf_egais-gds) = recid(X_egais-gds)
  .
  if available buf_egais-gds then do:
    assign
      buf_egais-gds.gds-code = ?
    .
    release buf_egais-gds.
    br-alc-gds:refresh() in frame {&frame-name}.
    apply "value-changed":U to br-alc-gds in frame {&frame-name}.
  end.
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-get-artic Dialog-Frame
PROCEDURE proc-get-artic :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
define input  parameter p-gds-code as integer   no-undo .
define output parameter p-artic    as character no-undo .

define buffer buf_goods for ub.goods.

  find first buf_goods no-lock
    where buf_goods.gds-code = p-gds-code
  no-error .
  assign
    p-artic = if available buf_goods then buf_goods.artic else ""
  .
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION get-artic Dialog-Frame
FUNCTION get-artic RETURNS CHARACTER
  ( p-gds-code as integer ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
  define variable v-artic as character no-undo .

  run proc-get-artic in this-procedure ( input p-gds-code
                                       , output v-artic
                                       ) .
  RETURN v-artic.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
