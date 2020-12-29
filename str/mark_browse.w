&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          ub               PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME d-mark
using ibs.th.gbl.sys.objsrv.
using ibs.th.str.marking.sts.*.
using ibs.th.str.marking.handlers.*.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DECLARATIONS d-mark 
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Проверка кодов маркировки

Автор: Шкляр Елена
Дата создания: 20/04/95
Author: Shklyar Elena
Creation date: 20/04/95

*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Проверка кодов маркировки".
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
{ gbl/key-rec.i  }
{ utl/gtin.i }

define input parameter parparentproc as widget-handle no-undo .
define input-output  PARAMETER TABLE FOR tt-marking-lines.
define input parameter p-mode as character no-undo .
define input parameter p-doc as character  no-undo . /*title*/
define input parameter p-type as integer   no-undo . /*тип документа 0 - все документы 1 - УТД со статусом 4 2 - внутренний приход 4 - чеки 5 - ЭДО в статусе новый 6 - серая зона*/ 
define input parameter p-type_mark as character   no-undo . /*тип продукции*/
/* Local Variable Definitions ---                                       */

define variable log-res     as log       no-undo.
define variable rr          as recid     no-undo.
define variable v_type      as char      no-undo.
define variable v-is-deploy as logical   no-undo .
define variable v-rid-list  as character no-undo .
define variable v-rid-list2 as character no-undo .
define variable v-db-list   as character no-undo .
define variable recid_mark  as integer   no-undo .
define variable title_name  as character no-undo .
define variable iLang       as integer   no-undo.
define variable Tree        as class     tree no-undo .
define variable ungroup     as logical   no-undo .
define variable jj          as integer   no-undo .
define variable v-qnty-mark as integer   no-undo .
define variable mark-parent as character no-undo .

define temp-table tt-gray-marking-lines like tt-marking-lines .

define buffer buf_marking           for ub.marking .
define buffer buf_utd-marking-lines for ub.utd-marking-lines .
define buffer bf_utd-marking-lines  for ub.utd-marking-lines .
define buffer buf_utd-lines         for ub.utd-lines .
define buffer buf_parts             for ub.parts . 
define buffer buf_goods             for ub.goods .
define buffer buf_utd-err           for ub.utd-err .
DEFINE BUFFER X_marking             FOR tt-marking-lines.
DEFINE BUFFER X_marking-line        FOR tt-marking-lines.

define variable v-scan-str       as character no-undo.
define variable v-manual         as logical   no-undo .
DEFINE VARIABLE v-timedelay as integer no-undo .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



def var objSrv as class ibs.th.gbl.sys.objsrv no-undo.
run gbl/getobjsrvhndl.p (input-output ObjSrv).
/* Temp-Table and Buffer definitions                                    */
/*DEFINE NEW SHARED BUFFER X_marking FOR marking.            */
/*DEFINE NEW SHARED BUFFER X_marking-lines FOR marking-lines.*/



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

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES X_marking X_marking-line

/* Definitions for BROWSE br-mark                                       */
&Scoped-define FIELDS-IN-QUERY-br-mark X_marking.gds-code ~
X_marking.mark-parent X_marking.mark X_marking.unit X_marking.sts 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-mark 
&Scoped-define QUERY-STRING-br-mark FOR EACH X_marking NO-LOCK where x_marking.doc-level = 1 and if Status_ <> 0 then if Status_ = 7 then x_marking.sts-utd =  else x_marking.sts-utd = 3 or X_marking.sts-utd = Status_ else x_marking.sts-utd <> 99 INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-mark OPEN QUERY br-mark FOR EACH X_marking NO-LOCK where x_marking.doc-level = 1 and if Status_ <> 0 then if Status_ = 7 then x_marking.sts-utd = Status_ else x_marking.sts-utd = 3 or X_marking.sts-utd = Status_ else x_marking.sts-utd <> 99 INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-mark X_marking
&Scoped-define FIRST-TABLE-IN-QUERY-br-mark X_marking


/* Definitions for BROWSE br-mark-item                                  */
&Scoped-define FIELDS-IN-QUERY-br-mark-item X_marking-line.gds-code ~
X_marking-line.mark-parent X_marking-line.mark X_marking-line.unit X_marking-line.sts 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-mark-item 
&Scoped-define QUERY-STRING-br-mark-item for each X_marking-line no-lock where X_marking-line.mark-parent = X_marking.mark and X_marking-line.doc-level = 2 and if Status_ <> 0 then if Status_ = 7 then x_marking-line.sts-utd = Status_ else x_marking-line.sts-utd = 3 or X_marking-line.sts-utd = Status_ else x_marking-line.sts <> 99 INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-mark-item OPEN QUERY br-mark-item for each X_marking-line no-lock where X_marking-line.mark-parent = X_marking.mark and X_marking-line.doc-level = 2 and if Status_ <> 0 then if Status_ = 7 then x_marking-line.sts-utd = Status_ else x_marking-line.sts-utd = 3 or X_marking-line.sts-utd = Status_ else x_marking-line.sts <> 99 INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-mark-item X_marking-line
&Scoped-define FIRST-TABLE-IN-QUERY-br-mark-item X_marking-line


/* Definitions for DIALOG-BOX d-mark                                    */
&Scoped-define OPEN-BROWSERS-IN-QUERY-d-mark ~
    ~{&OPEN-QUERY-br-mark}~
    ~{&OPEN-QUERY-br-mark-item}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-exit b_block b_error v-mark b-hist b-mark ~
b-del c-status b-change Status_ br-mark b-mark-2 c-status-2 b-change-2 ~
br-mark-item 
&Scoped-Define DISPLAYED-OBJECTS v-mark F-text c-status Status_ c-status-2 ~
qnty-mark-2 f-qnty-unit qnty-mark 

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
def    var      Marking     as class     mark no-undo .

/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-change 
     LABEL "&Поменять":L 
     SIZE 10 BY 1.

DEFINE BUTTON b-change-2 
     LABEL "&Поменять":L 
     SIZE 10 BY 1.

DEFINE BUTTON b-del 
     LABEL "&Удалить":L 
     SIZE 10 BY 1.

DEFINE BUTTON b-exit AUTO-GO 
     LABEL "&Выход ":L 
     SIZE 10 BY 1.

DEFINE BUTTON b-hist 
     IMAGE-UP FILE "cmp/b-hist.bmp":U
     IMAGE-DOWN FILE "cmp/b-hist.bmp":U
     IMAGE-INSENSITIVE FILE "cmp/b-hist.bmp":U NO-CONVERT-3D-COLORS
     LABEL "Ис&тория" 
     SIZE 3 BY 1.

DEFINE BUTTON b-mark 
     LABEL "&*" 
     SIZE 3 BY 1.

DEFINE BUTTON b-mark-2 
     LABEL "&*" 
     SIZE 3 BY 1.

DEFINE BUTTON bt-not-sel-all 
     LABEL "+" 
     SIZE 3 BY 1 TOOLTIP "Выбрать все".

DEFINE BUTTON bt-not-sel-all-2 
     LABEL "+" 
     SIZE 3 BY 1 TOOLTIP "Выбрать все".

DEFINE BUTTON bt-not-sel-desel-all 
     LABEL "-" 
     SIZE 3 BY 1 TOOLTIP "Отменить выбор".

DEFINE BUTTON bt-not-sel-desel-all-2 
     LABEL "-" 
     SIZE 3 BY 1 TOOLTIP "Отменить выбор".

DEFINE BUTTON b_block 
     LABEL "Проверка" 
     SIZE 10 BY 1.

DEFINE BUTTON b_error 
     LABEL "Ошибки" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-status AS INTEGER FORMAT "-999":U INITIAL 0 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Все",1,
                     "Получен от поставщика",2,
                     "Требует корректировки",3,
                     "Ожидает поставки",4,
                     "Требует подписания",5
     DROP-DOWN-LIST
     SIZE 29 BY 1 NO-UNDO.

DEFINE VARIABLE c-status-2 AS INTEGER FORMAT "-999":U INITIAL 0 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Все",1,
                     "Получен от поставщика",2,
                     "Требует корректировки",3,
                     "Ожидает поставки",4,
                     "Требует подписания",5
     DROP-DOWN-LIST
     SIZE 29 BY 1 NO-UNDO.

DEFINE VARIABLE f-qnty-unit AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Кол-во марок" 
     VIEW-AS FILL-IN 
     SIZE 5.5 BY 1 NO-UNDO.

DEFINE VARIABLE F-text AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 80.5 BY 1.25
     FGCOLOR 12  NO-UNDO.

DEFINE VARIABLE qnty-mark AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "из" 
     VIEW-AS FILL-IN 
     SIZE 5.5 BY 1 NO-UNDO.

DEFINE VARIABLE qnty-mark-2 AS INTEGER FORMAT "->,>>>>>9":U INITIAL 0 
     LABEL "Просканировано марок" 
     VIEW-AS FILL-IN 
     SIZE 5.5 BY 1 NO-UNDO.

DEFINE VARIABLE v-mark AS CHARACTER FORMAT "X(255)" 
     LABEL "Марка" 
     VIEW-AS FILL-IN 
     SIZE 74 BY 1.

DEFINE VARIABLE Status_ AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Все", 0,
"Ожидает проверку", 1,
"Проверен", 7
     SIZE 41 BY 1 NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD StatusTHName d-utd
FUNCTION StatusTHName RETURNS CHARACTER
  (input p-stsTH as integer)  .
  Return Marking:GetLabel(p-stsTH) .
END FUNCTION .
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-mark FOR 
  X_marking SCROLLING.

DEFINE QUERY br-mark-item FOR 
  X_marking-line SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-mark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-mark d-mark _STRUCTURED
  QUERY br-mark NO-LOCK DISPLAY
  X_marking.marking-string column-label "*" format "X(1)":U
  X_marking.gds-code COLUMN-LABEL "Код товара" FORMAT "999999999":U
  X_marking.gds-name COLUMN-LABEL "Наименование" FORMAT "x(210)":U width 15
  X_marking.mark COLUMN-LABEL "Марка" FORMAT "x(56)":U width 33
  X_marking.box-qnty column-label "Кол-во" format "->>>>>>9.99":U
  X_marking.stts COLUMN-LABEL "Текущий статус" FORMAT "X(30)":U width 20 
  X_marking.stts-utd COLUMN-LABEL "Статус" FORMAT "X(30)":U width 20
  X_marking.in-code COLUMN-LABEL "ПН" FORMAT "X(15)":U
  X_marking.out-code COLUMN-LABEL "РН" FORMAT "X(15)":U
  X_marking.site COLUMN-LABEL "" FORMAT "X(1)":U
  X_marking.unit COLUMN-LABEL "Ед.изм." FORMAT "x(8)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 123.5 BY 11 FIT-LAST-COLUMN.

DEFINE BROWSE br-mark-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-mark-item d-mark _STRUCTURED
  QUERY br-mark-item NO-LOCK DISPLAY
  X_marking-line.marking-string column-label "*" format "X(1)":U
  X_marking-line.gds-code COLUMN-LABEL "Код товара" FORMAT "999999999":U
  X_marking-line.gds-name COLUMN-LABEL "Наименование" FORMAT "x(210)":U width 15
  X_marking-line.mark COLUMN-LABEL "Марка" FORMAT "x(56)":U width 33
  X_marking-line.box-qnty column-label "Кол-во" format "->>>>>>9.99":U
  X_marking-line.stts COLUMN-LABEL "Текущий статус" FORMAT "X(30)":U width 20
  X_marking-line.stts-utd COLUMN-LABEL "Статус" FORMAT "X(30)":U width 20
  X_marking-line.in-code COLUMN-LABEL "ПН" FORMAT "X(15)":U
  X_marking-line.out-code COLUMN-LABEL "РН" FORMAT "X(15)":U
  X_marking-line.unit COLUMN-LABEL "Ед.изм." FORMAT "x(8)":U
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 123.5 BY 11.25 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME d-mark
     b-exit AT ROW 1 COL 1
     b_block AT ROW 1 COL 101.63 WIDGET-ID 290
     b_error AT ROW 1 COL 111.5 WIDGET-ID 282
     v-mark AT ROW 1.08 COL 18 COLON-ALIGNED WIDGET-ID 34
     b-hist AT ROW 1.08 COL 121.88 WIDGET-ID 64
     F-text AT ROW 2.33 COL 23 NO-LABEL WIDGET-ID 224
     bt-not-sel-all AT ROW 3.75 COL 1.63 WIDGET-ID 10 NO-TAB-STOP 
     bt-not-sel-desel-all AT ROW 3.75 COL 4.63 WIDGET-ID 12 NO-TAB-STOP 
     b-mark AT ROW 3.75 COL 7.63 WIDGET-ID 4
     b-del AT ROW 3.75 COL 10.88 WIDGET-ID 66
     c-status AT ROW 3.75 COL 22 COLON-ALIGNED NO-LABEL WIDGET-ID 72
     b-change AT ROW 3.75 COL 53.5 WIDGET-ID 68
     Status_ AT ROW 3.75 COL 84 NO-LABEL WIDGET-ID 24
     br-mark AT ROW 4.75 COL 1.5 WIDGET-ID 200
     bt-not-sel-all-2 AT ROW 16 COL 1.5 WIDGET-ID 80 NO-TAB-STOP 
     bt-not-sel-desel-all-2 AT ROW 16 COL 4.5 WIDGET-ID 82 NO-TAB-STOP 
     b-mark-2 AT ROW 16 COL 7.5 WIDGET-ID 78
     c-status-2 AT ROW 16 COL 21.88 COLON-ALIGNED NO-LABEL WIDGET-ID 84
     b-change-2 AT ROW 16 COL 53.38 WIDGET-ID 74
     qnty-mark-2 AT ROW 16 COL 107.25 COLON-ALIGNED WIDGET-ID 288
     f-qnty-unit AT ROW 16 COL 123.75 RIGHT-ALIGNED WIDGET-ID 284
     qnty-mark AT ROW 16 COL 117.38 COLON-ALIGNED WIDGET-ID 286
     br-mark-item AT ROW 17 COL 1.5 WIDGET-ID 300
     SPACE(0.99) SKIP(0.28)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Проверка кодов маркировки":L.


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
/* BROWSE-TAB br-mark Status_ d-mark */
/* BROWSE-TAB br-mark-item qnty-mark d-mark */
ASSIGN 
       FRAME d-mark:SCROLLABLE       = FALSE.

ASSIGN 
       br-mark:COLUMN-RESIZABLE IN FRAME d-mark       = TRUE.

ASSIGN 
       br-mark-item:COLUMN-RESIZABLE IN FRAME d-mark       = TRUE.

/* SETTINGS FOR BUTTON bt-not-sel-all IN FRAME d-mark
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-not-sel-all-2 IN FRAME d-mark
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-not-sel-desel-all IN FRAME d-mark
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-not-sel-desel-all-2 IN FRAME d-mark
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-qnty-unit IN FRAME d-mark
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN F-text IN FRAME d-mark
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN qnty-mark IN FRAME d-mark
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN qnty-mark-2 IN FRAME d-mark
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-mark d-mark       */
/*ON return OF br-mark IN FRAME d-mark                           */
/*  DO:                                                          */
/*  run scan-mark.                                               */
/*  END.                                                         */
/*                                                               */
/*/* _UIB-CODE-BLOCK-END */                                      */
/*&ANALYZE-RESUME                                                */
/*                                                               */
/*&Scoped-define SELF-NAME br-mark-item                          */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-mark-item d-mark  */
/*ON return OF br-mark-item IN FRAME d-mark /* Номер документа */*/
/*  DO:                                                          */
/*  run scan-mark.                                               */
/*  END.                                                         */
/*                                                               */
/*/* _UIB-CODE-BLOCK-END */                                      */
/*&ANALYZE-RESUME                                                */




/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-mark d-mark              */
/*ON any-printable OF br-mark IN FRAME d-mark                           */
/*  DO:                                                                 */
/*  run proc-any-key.                                                   */
/*  END.                                                                */
/*                                                                      */
/*/* _UIB-CODE-BLOCK-END */                                             */
/*&ANALYZE-RESUME                                                       */
/*                                                                      */
/*&Scoped-define SELF-NAME br-mark-item                                 */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-mark-item d-mark         */
/*ON any-printable OF br-mark-item IN FRAME d-mark /* Номер документа */*/
/*  DO:                                                                 */
/*  run proc-any-key.                                                   */
/*  END.                                                                */
/*                                                                      */
/*/* _UIB-CODE-BLOCK-END */                                             */
/*&ANALYZE-RESUME                                                       */




&Scoped-define SELF-NAME b-change
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-change d-mark
ON CHOOSE OF b-change IN FRAME d-mark /* Поменять */
DO:
    define variable ii         as integer no-undo .
    define variable recid_mark as integer no-undo .
find first tt-marking-lines where tt-marking-lines.marking-string = "*" and tt-marking-lines.doc-level = 1 no-error .
    if available (tt-marking-lines) then 
    do:
        for each X_marking where X_marking.marking-string = "*" and X_marking.doc-level = 1 :
          find first buf_marking exclusive-lock where buf_marking.mark = X_marking.mark no-error .
           if available (buf_marking) 
           then do: 
              buf_marking.sts = c-status .
              validate buf_marking.
              X_marking.sts = buf_marking.sts .
              X_marking.stts =  StatusTHName(X_marking.sts).
           end.
           find first buf_utd-marking-lines exclusive-lock where buf_utd-marking-lines.mark = X_marking.mark and buf_utd-marking-lines.db-num = X_marking.db-num and
             buf_utd-marking-lines.doc-id = X_marking.doc-id no-error .
           if available (buf_utd-marking-lines) 
           then do: 
              buf_utd-marking-lines.sts = c-status .
              validate buf_utd-marking-lines.
              X_marking.sts-utd = buf_utd-marking-lines.sts .
              X_marking.stts-utd =  StatusTHName(X_marking.sts-utd).
           end.
           X_marking.marking-string = "" .
        end.

      end.  
    
    else 
    do:
      recid_mark = recid(X_marking) .
      find first X_marking where recid (X_marking) = recid_mark no-error.
      if available (X_marking) then 
      do:
        
        
        find first buf_marking exclusive-lock where buf_marking.mark = X_marking.mark no-error .
        if available (buf_marking) 
        then do: 
           buf_marking.sts = c-status .
           validate buf_marking.
           X_marking.sts = buf_marking.sts .
           X_marking.stts =  StatusTHName(X_marking.sts).
        end.
        find first buf_utd-marking-lines exclusive-lock where buf_utd-marking-lines.mark = X_marking.mark and buf_utd-marking-lines.db-num = X_marking.db-num and
          buf_utd-marking-lines.doc-id = X_marking.doc-id no-error .
        if available (buf_utd-marking-lines) 
        then do: 
           buf_utd-marking-lines.sts = c-status .
           validate buf_utd-marking-lines.
           X_marking.sts-utd = buf_utd-marking-lines.sts .
           X_marking.stts-utd =  StatusTHName(X_marking.sts-utd).
        end.
      end.                  
      
    end.  
    {&OPEN-BROWSERS-IN-QUERY-d-mark}
    apply "entry" to {&browse-name} in frame {&frame-name}.

  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-change-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-change-2 d-mark
ON CHOOSE OF b-change-2 IN FRAME d-mark /* Поменять */
DO:
    define variable ii         as integer no-undo .
    define variable recid_mark as integer no-undo .
  
find first tt-marking-lines where tt-marking-lines.marking-string = "*" and tt-marking-lines.doc-level > 1 no-error .
    if available (tt-marking-lines) then 
    do:
        for each X_marking-line where X_marking-line.marking-string = "*" and tt-marking-lines.doc-level > 1:
          X_marking-line.sts-utd = c-status-2 .
          X_marking-line.stts-utd =  StatusTHName(X_marking-line.sts-utd).
          X_marking-line.sts = c-status-2 .
          X_marking-line.stts =  StatusTHName(X_marking-line.sts).
          find first buf_marking exclusive-lock where buf_marking.mark = X_marking-line.mark no-error .
          if available (buf_marking) then buf_marking.sts = X_marking-line.sts .
          find first buf_utd-marking-lines exclusive-lock where buf_utd-marking-lines.mark = X_marking-line.mark and buf_utd-marking-lines.db-num = X_marking-line.db-num and
            buf_utd-marking-lines.doc-id = X_marking-line.doc-id no-error .
          if available (buf_utd-marking-lines) then buf_utd-marking-lines.sts = X_marking-line.sts-utd .
       X_marking-line.marking-string = "" .
        end.
            
      end.  

    else 
    do:
      recid_mark = recid(X_marking-line) .
      find first X_marking-line where recid (X_marking-line) = recid_mark no-error.
      if available (X_marking-line) then 
      do:
        X_marking-line.sts-utd = c-status-2 .
        X_marking-line.stts-utd =  StatusTHName(X_marking-line.sts-utd).
        X_marking-line.sts = c-status-2 .
        X_marking-line.stts =  StatusTHName(X_marking-line.sts).
        find first buf_marking exclusive-lock where buf_marking.mark = X_marking-line.mark no-error .
        if available (buf_marking) then buf_marking.sts = X_marking-line.sts .
        find first buf_utd-marking-lines exclusive-lock where buf_utd-marking-lines.mark = X_marking-line.mark and buf_utd-marking-lines.db-num = X_marking-line.db-num and
          buf_utd-marking-lines.doc-id = X_marking-line.doc-id no-error .
        if available (buf_utd-marking-lines) then buf_utd-marking-lines.sts = X_marking-line.sts-utd .
      end.
    end. 
    {&OPEN-BROWSERS-IN-QUERY-d-mark}
    apply "entry" to {&browse-name} in frame {&frame-name}.

  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-del d-mark
ON CHOOSE OF b-del IN FRAME d-mark /* Удалить */
DO:
    define variable ii         as integer no-undo .
    define variable recid_mark as integer no-undo .

    if v-rid-list <> "" then 
    do:
      do ii = 1 to num-entries (v-rid-list):
        recid_mark = integer(entry(ii,v-rid-list)) .
        for first X_marking where recid (X_marking) = recid_mark:
          for first buf_marking exclusive-lock where buf_marking.mark = X_marking.mark:
            for first buf_utd-marking-lines exclusive-lock where buf_utd-marking-lines.mark = X_marking.mark:
              for first buf_utd-lines exclusive-lock where buf_utd-lines.LineNum = buf_utd-marking-lines.LineNum and buf_utd-lines.db-num = buf_utd-marking-lines.db-num
                and buf_utd-lines.doc-id = buf_utd-marking-lines.doc-id:
                buf_utd-lines.Quantity = buf_utd-lines.Quantity - buf_marking.box-qnty .
                delete X_marking.
                /*                delete buf_marking .*/
                delete buf_utd-marking-lines .
                v-qnty-mark = v-qnty-mark - buf_marking.box-qnty .
                if buf_utd-lines.Quantity = 0 then 
                do:
                  delete buf_utd-lines .
                end.  
              end.
            end.
          end.
        end.    
      end.  
    end.  
    else 
    do:
      recid_mark = recid(X_marking) .
      for first X_marking where recid (X_marking) = recid_mark:
        for first buf_marking exclusive-lock where buf_marking.mark = X_marking.mark:
          for first buf_utd-marking-lines exclusive-lock where buf_utd-marking-lines.mark = X_marking.mark:
            for first buf_utd-lines exclusive-lock where buf_utd-lines.LineNum = buf_utd-marking-lines.LineNum and buf_utd-lines.db-num = buf_utd-marking-lines.db-num
              and buf_utd-lines.doc-id = buf_utd-marking-lines.doc-id:
              buf_utd-lines.Quantity = buf_utd-lines.Quantity - buf_marking.box-qnty .
              delete X_marking.
              /*              delete buf_marking .*/
              delete buf_utd-marking-lines .
              v-qnty-mark = v-qnty-mark - buf_marking.box-qnty .
              if buf_utd-lines.Quantity = 0 then 
              do:
                delete buf_utd-lines .
              end.  
            end.
          end.
        end.
      end.                  
    end. 
  
    {&OPEN-BROWSERS-IN-QUERY-d-mark}
    apply "entry" to {&browse-name} in frame {&frame-name}.
    f-qnty-unit = v-qnty-mark .
    display f-qnty-unit with frame {&frame-name} .
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-exit d-mark
ON choose OF b-exit IN FRAME d-mark /* Выход  */
DO:
    define buffer buf_marking for ub.marking .
    define variable quest-ok as logical no-undo .
    define variable quest-scan as logical no-undo .
    
    if  p-type = 6 then 
    do:
      if X_marking.box-qnty = qnty-mark-2 then 
      do:
        find first buf_utd-marking-lines exclusive-lock where buf_utd-marking-lines.mark = X_marking.mark and buf_utd-marking-lines.db-num = X_marking.db-num and
          buf_utd-marking-lines.doc-id = X_marking.doc-id no-error .
        if available (buf_utd-marking-lines) then 
        do:
          buf_utd-marking-lines.sts = Marking:Checked_:KeyIntDB .
          buf_utd-marking-lines.doc-level = 1 .
          X_marking.sts-utd = Marking:Checked_:KeyIntDB .
          X_marking.stts-utd = StatusTHName(X_marking.sts-utd) .
        end.  
        for first buf_marking exclusive-lock where buf_marking.mark = buf_utd-marking-lines.mark :
          buf_marking.sts = Marking:Ungrouped:KeyIntDB .
          X_marking.sts = Marking:Ungrouped:KeyIntDB .
          X_marking.stts = StatusTHName(X_marking.sts) .
        end.
        run save-mark .
        for each X_marking-line where X_marking-line.mark <> X_marking.mark:
          for first buf_utd-marking-lines exclusive-lock where buf_utd-marking-lines.mark = X_marking-line.mark and 
            buf_utd-marking-lines.db-num = X_marking-line.db-num and
            buf_utd-marking-lines.doc-id = X_marking-line.doc-id:
          end.  
        end.    
      end .  
      else 
      do:
        message "Марки просканированы не полностью." skip
          "Должны быть просканированы все марки." skip
          "Продолжить сканирование?" skip
          "Да – возврат к сканированию" skip
          "Нет – сброс введенной информации" 
          view-as alert-box question buttons yes-no update quest-ok.
        if not quest-ok then 
        do:
            for each X_marking-line exclusive-lock where X_marking-line.doc-level > 1:
              find first buf_utd-marking-lines exclusive-lock where buf_utd-marking-lines.mark = X_marking-line.mark and buf_utd-marking-lines.db-num = X_marking-line.db-num and
              buf_utd-marking-lines.doc-id = X_marking-line.doc-id no-error .
              if available (buf_utd-marking-lines) then do:
              buf_utd-marking-lines.sts = Marking:PendingVerification:KeyIntDB .
              X_marking-line.sts-utd = Marking:PendingVerification:KeyIntDB .
              X_marking-line.stts-utd = StatusTHName(X_marking-line.sts-utd) .
              end.
              if X_marking-line.GrayZone = yes then 
              do:
                delete X_marking-line .
              end.  
            end.  

        end.
        else 
        do:
          return no-apply .
        end.  
      end. 
    end.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-hist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-hist d-mark
ON choose OF b-hist IN FRAME d-mark /* История */
DO:
    if available (X_marking) then 
    do:
      run str/mark_hist.w(input parparentproc,
        input X_marking.mark,
        input p-mode).
    end.
    else 
    do:
      if available (X_marking-line) then 
      do:
        run str/mark_hist.w(input parparentproc,
          input X_marking-line.mark,
          input p-mode).
      end.  
      else 
      do:
        message "Не выбрана марка"
          view-as alert-box.
      end.  
    end.   
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-mark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-mark d-mark
ON CHOOSE OF b-mark IN FRAME d-mark /* * */
DO:
    define variable loc#log     as logical no-undo .
    define variable row-marking as rowid   no-undo .
    if available X_marking then 
    do:
        if X_marking.marking-string = "*" then X_marking.marking-string = "" .
        else X_marking.marking-string = "*" . 
/*      { gbl/markstrn.i X_marking v-rid-list }*/
      row-marking = rowid(X_marking).
      loc#log = {&browse-name}:refresh() .
      reposition br-mark to rowid row-marking.
      
      loc#log = br-mark:refresh() .

      if last-event:function <> "MOUSE-SELECT-DBLCLICK" then 
      do:
        loc#log = br-mark:select-next-row () .
        apply "VALUE-CHANGED" to br-mark in frame {&frame-name} .
      end.
    end.
    apply "entry" to br-mark in frame {&frame-name}.

  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-mark-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-mark-2 d-mark
ON CHOOSE OF b-mark-2 IN FRAME d-mark /* * */
DO:
    define variable loc#log as logical no-undo .
    define variable row-marking as rowid   no-undo .
    apply "entry" to {&browse-name} in frame {&frame-name}.
    if available X_marking-line then 
    do:
        if X_marking-line.marking-string = "*" then X_marking-line.marking-string = "" .
        else X_marking-line.marking-string = "*" .
        row-marking = rowid(X_marking-line).
/*      { gbl/markstrn.i X_marking-line v-rid-list2 }*/
      loc#log = br-mark-item:refresh() .
      reposition br-mark-item to rowid row-marking.  
      if last-event:function <> "MOUSE-SELECT-DBLCLICK" then 
      do:
        loc#log = br-mark-item:select-next-row () .
        apply "VALUE-CHANGED" to br-mark-item in frame {&frame-name}.
      end.
    end.
    apply "entry" to br-mark-item in frame {&frame-name}.

  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-mark d-mark
ON value-changed OF br-mark IN FRAME d-mark
  DO:
    br-mark:refresh() no-error .
if p-type = 1 then do:
      if X_marking.sts = Marking:GrayZone:KeyIntDB then do:
      enable
        b_block
        with frame {&frame-name} .
      end.
      else do:
      disable b_block with frame {&frame-name} .
      end.   
end.
    {&OPEN-QUERY-br-mark-item} .
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME br-mark-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-mark-item d-mark
ON value-changed OF br-mark-item IN FRAME d-mark /* Номер документа */
  DO:

    br-mark-item:refresh () no-error .
    
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-mark d-mark
ON ROW-DISPLAY OF br-mark IN FRAME d-mark
DO:
    if p-type = 1 or p-type = 6 then 
    do:
      case X_marking.sts-utd:
        when Marking:Checked_:KeyIntDB then
          do:
            X_marking.gds-code:fGCOLOR in browse br-mark = CYAN_COLOR.
            X_marking.gds-name:fGCOLOR in browse br-mark = CYAN_COLOR.
            X_marking.mark:fGCOLOR in browse br-mark = CYAN_COLOR.
            X_marking.box-qnty:fGCOLOR in browse br-mark = CYAN_COLOR.
            X_marking.unit:fGCOLOR in browse br-mark = CYAN_COLOR.
            X_marking.stts:fGCOLOR in browse br-mark = CYAN_COLOR.
            X_marking.stts-utd:fGCOLOR in browse br-mark = CYAN_COLOR.
            X_marking.in-code:fGCOLOR in browse br-mark = CYAN_COLOR.
            X_marking.out-code:fGCOLOR in browse br-mark = CYAN_COLOR.
          end.
/*        when Marking:PendingVerification:KeyIntDB or                    */
/*        when Marking:DeliveryControl:KeyIntDB then                      */
/*          do:                                                           */
/*            X_marking.gds-code:BGCOLOR in browse br-mark = YELLOW_COLOR.*/
/*            X_marking.gds-name:BGCOLOR in browse br-mark = YELLOW_COLOR.*/
/*            X_marking.mark:BGCOLOR in browse br-mark = YELLOW_COLOR.    */
/*            X_marking.box-qnty:BGCOLOR in browse br-mark = YELLOW_COLOR.*/
/*            X_marking.unit:BGCOLOR in browse br-mark = YELLOW_COLOR.    */
/*            X_marking.stts:BGCOLOR in browse br-mark = YELLOW_COLOR.    */
/*            X_marking.stts-utd:BGCOLOR in browse br-mark = YELLOW_COLOR.*/
/*            X_marking.in-code:BGCOLOR in browse br-mark = YELLOW_COLOR. */
/*            X_marking.out-code:BGCOLOR in browse br-mark = YELLOW_COLOR.*/
/*          end.                                                          */
        when Marking:MarkError:KeyIntDB then
          do:
            X_marking.gds-code:fGCOLOR in browse br-mark = red_COLOR.
            X_marking.gds-name:fGCOLOR in browse br-mark = red_COLOR.
            X_marking.mark:fGCOLOR in browse br-mark = red_COLOR.
            X_marking.box-qnty:fGCOLOR in browse br-mark = red_COLOR.
            X_marking.unit:fGCOLOR in browse br-mark = red_COLOR.
            X_marking.stts:fGCOLOR in browse br-mark = red_COLOR.
            X_marking.stts-utd:fGCOLOR in browse br-mark = red_COLOR.
            X_marking.in-code:fGCOLOR in browse br-mark = red_COLOR.
            X_marking.out-code:fGCOLOR in browse br-mark = red_COLOR.
          end.    
      end case.
       if X_marking.sts = Marking:MarkError:KeyIntDB then 
          do:
            X_marking.gds-code:fGCOLOR in browse br-mark = red_COLOR.
            X_marking.gds-name:fGCOLOR in browse br-mark = red_COLOR.
            X_marking.mark:fGCOLOR in browse br-mark = red_COLOR.
            X_marking.box-qnty:fGCOLOR in browse br-mark = red_COLOR.
            X_marking.unit:fGCOLOR in browse br-mark = red_COLOR.
            X_marking.stts:fGCOLOR in browse br-mark = red_COLOR.
            X_marking.stts-utd:fGCOLOR in browse br-mark = red_COLOR.
            X_marking.in-code:fGCOLOR in browse br-mark = red_COLOR.
            X_marking.out-code:fGCOLOR in browse br-mark = red_COLOR.
          end.       
    end.
    else 
    do:
      case X_marking.sts:
        when Marking:MarkError:KeyIntDB then
          do:
            X_marking.gds-code:fGCOLOR in browse br-mark = red_COLOR.
            X_marking.gds-name:fGCOLOR in browse br-mark = red_COLOR.
            X_marking.mark:fGCOLOR in browse br-mark = red_COLOR.
            X_marking.box-qnty:fGCOLOR in browse br-mark = red_COLOR.
            X_marking.unit:fGCOLOR in browse br-mark = red_COLOR.
            X_marking.stts:fGCOLOR in browse br-mark = red_COLOR.
            X_marking.stts-utd:fGCOLOR in browse br-mark = red_COLOR.
            X_marking.in-code:fGCOLOR in browse br-mark = red_COLOR.
            X_marking.out-code:fGCOLOR in browse br-mark = red_COLOR.
          end.  
      end case.
    end.
   
  END .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-mark-item d-mark
ON ROW-DISPLAY OF br-mark-item IN FRAME d-mark
DO:
    if p-type = 1 or p-type = 6 then 
    do:
      case X_marking-line.sts-utd:
        when Marking:Checked_:KeyIntDB then
          do:
            X_marking-line.gds-code:fGCOLOR in browse br-mark-item = CYAN_COLOR.
            X_marking-line.gds-name:fGCOLOR in browse br-mark-item = CYAN_COLOR.
            X_marking-line.mark:fGCOLOR in browse br-mark-item = CYAN_COLOR.
            X_marking-line.box-qnty:fGCOLOR in browse br-mark-item = CYAN_COLOR.
            X_marking-line.unit:fGCOLOR in browse br-mark-item = CYAN_COLOR.
            X_marking-line.stts:fGCOLOR in browse br-mark-item = CYAN_COLOR.
            X_marking-line.stts-utd:fGCOLOR in browse br-mark-item = CYAN_COLOR.
            X_marking-line.in-code:fGCOLOR in browse br-mark-item = CYAN_COLOR.
            X_marking-line.out-code:fGCOLOR in browse br-mark-item = CYAN_COLOR.
          end.
/*        when Marking:PendingVerification:KeyIntDB or                              */
/*        when Marking:DeliveryControl:KeyIntDB then                                */
/*          do:                                                                     */
/*            X_marking-line.gds-code:BGCOLOR in browse br-mark-item = YELLOW_COLOR.*/
/*            X_marking-line.gds-name:BGCOLOR in browse br-mark-item = YELLOW_COLOR.*/
/*            X_marking-line.mark:BGCOLOR in browse br-mark-item = YELLOW_COLOR.    */
/*            X_marking-line.box-qnty:BGCOLOR in browse br-mark-item = YELLOW_COLOR.*/
/*            X_marking-line.unit:BGCOLOR in browse br-mark-item = YELLOW_COLOR.    */
/*            X_marking-line.stts:BGCOLOR in browse br-mark-item = YELLOW_COLOR.    */
/*            X_marking-line.stts-utd:BGCOLOR in browse br-mark-item = YELLOW_COLOR.*/
/*            X_marking-line.in-code:BGCOLOR in browse br-mark-item = YELLOW_COLOR. */
/*            X_marking-line.out-code:BGCOLOR in browse br-mark-item = YELLOW_COLOR.*/
/*          end.                                                                    */
        when Marking:MarkError:KeyIntDB then 
          do:
            X_marking-line.gds-code:fGCOLOR in browse br-mark-item = red_COLOR.
            X_marking-line.gds-name:fGCOLOR in browse br-mark-item = red_COLOR.
            X_marking-line.mark:fGCOLOR in browse br-mark-item = red_COLOR.
            X_marking-line.box-qnty:fGCOLOR in browse br-mark-item = red_COLOR.
            X_marking-line.unit:fGCOLOR in browse br-mark-item = red_COLOR.
            X_marking-line.stts:fGCOLOR in browse br-mark-item = red_COLOR.
            X_marking-line.stts-utd:fGCOLOR in browse br-mark-item = red_COLOR.
            X_marking-line.in-code:fGCOLOR in browse br-mark-item = red_COLOR.
            X_marking-line.out-code:fGCOLOR in browse br-mark-item = red_COLOR.
          end. 
      end case.
       if X_marking-line.sts = Marking:MarkError:KeyIntDB then 
          do:
            X_marking-line.gds-code:fGCOLOR in browse br-mark-item = red_COLOR.
            X_marking-line.gds-name:fGCOLOR in browse br-mark-item = red_COLOR.
            X_marking-line.mark:fGCOLOR in browse br-mark-item = red_COLOR.
            X_marking-line.box-qnty:fGCOLOR in browse br-mark-item = red_COLOR.
            X_marking-line.unit:fGCOLOR in browse br-mark-item = red_COLOR.
            X_marking-line.stts:fGCOLOR in browse br-mark-item = red_COLOR.
            X_marking-line.stts-utd:fGCOLOR in browse br-mark-item = red_COLOR.
            X_marking-line.in-code:fGCOLOR in browse br-mark-item = red_COLOR.
            X_marking-line.out-code:fGCOLOR in browse br-mark-item = red_COLOR.
          end. 

    end.
    else 
    do:
      case X_marking-line.sts:
        when Marking:MarkError:KeyIntDB then 
          do:
            X_marking-line.gds-code:fGCOLOR in browse br-mark-item = red_COLOR.
            X_marking-line.gds-name:fGCOLOR in browse br-mark-item = red_COLOR.
            X_marking-line.mark:fGCOLOR in browse br-mark-item = red_COLOR.
            X_marking-line.box-qnty:fGCOLOR in browse br-mark-item = red_COLOR.
            X_marking-line.unit:fGCOLOR in browse br-mark-item = red_COLOR.
            X_marking-line.stts:fGCOLOR in browse br-mark-item = red_COLOR.
            X_marking-line.stts-utd:fGCOLOR in browse br-mark-item = red_COLOR.
            X_marking-line.in-code:fGCOLOR in browse br-mark-item = red_COLOR.
            X_marking-line.out-code:fGCOLOR in browse br-mark-item = red_COLOR.
          end. 
      end case.
    end.  
    
    
  END .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-not-sel-all
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-not-sel-all d-mark
ON CHOOSE OF bt-not-sel-all IN FRAME d-mark /* + */
DO:
    define variable loc#log as logical no-undo .

    if available X_marking then 
    do:
      v-rid-list = "" .
      for each X_marking where X_marking.doc-level = 1:
          X_marking.marking-string = "*" .
/*        { gbl/markstrn.i X_marking v-rid-list }*/
        loc#log = br-mark:refresh() no-error.
      end.
    end.
    apply "entry" to br-mark in frame {&frame-name}.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-not-sel-all-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-not-sel-all-2 d-mark
ON CHOOSE OF bt-not-sel-all-2 IN FRAME d-mark /* + */
DO:
    define variable loc#log as logical no-undo .
    if available (X_marking) then 
    do:
     v-rid-list2 = "" .
      for each X_marking-line where X_marking.mark begins X_marking-line.mark-parent and X_marking-line.doc-level > 1:
          X_marking-line.marking-string = "*" .
/*        { gbl/markstrn.i X_marking-line v-rid-list2 }*/
        loc#log = br-mark-item:refresh() no-error.
      end.
    end.
    apply "entry" to br-mark-item in frame {&frame-name}.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-not-sel-desel-all
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-not-sel-desel-all d-mark
ON CHOOSE OF bt-not-sel-desel-all IN FRAME d-mark /* - */
DO:
    define variable loc#log as logical no-undo .
    v-rid-list = "" .
    For each X_marking where X_marking.marking-string = "*":
        X_marking.marking-string = "" .
    end.    
    loc#log = br-mark:refresh() no-error.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-not-sel-desel-all-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-not-sel-desel-all-2 d-mark
ON CHOOSE OF bt-not-sel-desel-all-2 IN FRAME d-mark /* - */
DO:
    define variable loc#log as logical no-undo .
    v-rid-list2 = "" .
    For each X_marking-line where X_marking-line.marking-string = "*":
        X_marking-line.marking-string = "" .
    end.
    loc#log = br-mark-item:refresh() .

  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_block
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_block d-mark
ON CHOOSE OF b_block IN FRAME d-mark /* Проверка */
DO:
/*вызов серой зоны*/
    define buffer gray_marking                for ub.marking .
    define buffer gray_unit-marking           for ub.marking .
    define buffer gray_utd-marking-lines      for ub.utd-marking-lines .
    define buffer gray_unit_utd-marking-lines for ub.utd-marking-lines .
    
                  for first gray_utd-marking-lines no-lock where gray_utd-marking-lines.db-num = X_marking.db-num and 
                                                                 gray_utd-marking-lines.doc-id = X_marking.doc-id and 
                                                                 gray_utd-marking-lines.LineNum = X_marking.LineNum and 
                                                                 gray_utd-marking-lines.mark = X_marking.mark:
                    for first gray_marking no-lock where gray_marking.mark = X_marking.mark :
                      create tt-gray-marking-lines .
                      assign
                        tt-gray-marking-lines.gds-name    = GdsName(gray_utd-marking-lines.gds-code)
                        tt-gray-marking-lines.stts-utd    = StatusTHName(gray_utd-marking-lines.sts)
                        tt-gray-marking-lines.stts        = StatusTHName(gray_marking.sts)
                        tt-gray-marking-lines.mark        = gray_marking.mark
                        tt-gray-marking-lines.mark-parent = gray_marking.mark-parent
                        tt-gray-marking-lines.gds-code    = gray_utd-marking-lines.gds-code
                        tt-gray-marking-lines.sts         = gray_marking.sts
                        tt-gray-marking-lines.sts-utd     = gray_utd-marking-lines.sts
                        tt-gray-marking-lines.unit        = gray_marking.unit
                        tt-gray-marking-lines.box-qnty    = gray_marking.box-qnty
                        tt-gray-marking-lines.LineNum     = gray_utd-marking-lines.LineNum
                        tt-gray-marking-lines.db-num      = gray_utd-marking-lines.db-num
                        tt-gray-marking-lines.doc-id      = gray_utd-marking-lines.doc-id
                        tt-gray-marking-lines.doc-level   = gray_utd-marking-lines.doc-level
                        .
                    end.
                    for each gray_unit-marking no-lock where gray_unit-marking.mark-parent = gray_utd-marking-lines.mark:
                    for first gray_unit_utd-marking-lines no-lock where gray_unit_utd-marking-lines.db-num = X_marking.db-num and gray_unit_utd-marking-lines.doc-id = X_marking.doc-id
                    and gray_unit_utd-marking-lines.LineNum = X_marking.LineNum and gray_unit_utd-marking-lines.mark = gray_unit-marking.mark:
                      create tt-gray-marking-lines .
                      assign
                        tt-gray-marking-lines.gds-name    = GdsName(gray_unit_utd-marking-lines.gds-code)
                        tt-gray-marking-lines.stts-utd    = StatusTHName(gray_unit_utd-marking-lines.sts)
                        tt-gray-marking-lines.stts        = StatusTHName(gray_unit-marking.sts)
                        tt-gray-marking-lines.mark        = gray_unit-marking.mark
                        tt-gray-marking-lines.mark-parent = gray_unit-marking.mark-parent
                        tt-gray-marking-lines.gds-code    = gray_unit_utd-marking-lines.gds-code
                        tt-gray-marking-lines.sts         = gray_unit-marking.sts
                        tt-gray-marking-lines.sts-utd     = gray_unit_utd-marking-lines.sts
                        tt-gray-marking-lines.unit        = gray_unit-marking.unit
                        tt-gray-marking-lines.unit-ext    = gray_unit-marking.unit-ext
                        tt-gray-marking-lines.box-qnty    = gray_unit-marking.box-qnty
                        tt-gray-marking-lines.LineNum     = gray_unit_utd-marking-lines.LineNum
                        tt-gray-marking-lines.db-num      = gray_unit_utd-marking-lines.db-num
                        tt-gray-marking-lines.doc-id      = gray_unit_utd-marking-lines.doc-id
                        tt-gray-marking-lines.doc-level   = gray_unit_utd-marking-lines.doc-level
                        .
                    end.
                    end.
                  end.
                          run str/mark_browse.w (input parparentproc,
                            input-output table tt-gray-marking-lines by-reference,
                            input p-mode,
                            input "Марки по товару " + string(X_marking.gds-code) + " " + GdsName(X_marking.gds-code) + " со статусом: " + StatusTHName(Marking:GrayZone:KeyIntDB),
                            input 6,
                            input "" /*тип продукции*/
                            ) no-error .
                  for each tt-gray-marking-lines no-lock:
                    find first tt-marking-lines exclusive-lock where tt-marking-lines.mark = tt-gray-marking-lines.mark no-error .
                    if not available (tt-marking-lines) then do:
                      create tt-marking-lines .
                      buffer-copy tt-gray-marking-lines to tt-marking-lines .
                      v-qnty-mark = v-qnty-mark + 1 .
                      f-qnty-unit = v-qnty-mark .
                    end.  
                    else do:
                      assign
                      tt-marking-lines.sts = tt-gray-marking-lines.sts
                      tt-marking-lines.stts = tt-gray-marking-lines.stts
                      tt-marking-lines.sts-utd = tt-gray-marking-lines.sts-utd
                      tt-marking-lines.stts-utd = tt-gray-marking-lines.stts-utd
                      .
                    end.  
                  end.   
                  recid_mark = recid (X_marking) .
                  empty temp-table tt-gray-marking-lines .
                  br-mark :refresh().
                  reposition br-mark to recid recid_mark no-error .
/*                  {&OPEN-BROWSERS-IN-QUERY-d-mark}*/
                  br-mark-item:refresh () no-error .

  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_error
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_error d-mark
ON CHOOSE OF b_error IN FRAME d-mark /* Ошибки */
DO:
    /*Ошибки по всем маркам документа*/
    define variable v-ok as logical no-undo .
    
    run ref/dialog-error.w (input X_marking.db-num, input X_marking.doc-id, input "utd-marking-lines") .
    if  error-status:error then 
    do: 
      return return-value .
    end.
    run enable_UI in this-procedure .
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-status
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-status d-mark
ON VALUE-CHANGED OF c-status IN FRAME d-mark
DO:
    assign c-status .
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-status-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-status-2 d-mark
ON VALUE-CHANGED OF c-status-2 IN FRAME d-mark
DO:
    assign c-status-2 .
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Status_
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Status_ d-mark
ON VALUE-CHANGED OF Status_ IN FRAME d-mark
DO:
    assign status_ .
    run init-temp in this-procedure .
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-mark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-mark d-mark
ON return OF v-mark IN FRAME d-mark /* Марка */
DO:
 run scan-mark .
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME v-mark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-mark d-mark
ON any-printable OF v-mark IN FRAME d-mark /*              */
do:
  run proc-any-key.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define BROWSE-NAME br-mark
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
  Marking = ObjSrv:Env:Marking:Sts:Mark .
  tree = ObjSrv:Lib:MarkingTree .
  run LoadKeyboardLayoutA (input v-scan-str, input 0, output iLang).
  run ActivateKeyboardLayout (input iLang, input 0).
  /*  /*  run gbl/inidebug.p.            */*/
/*       output to hhhhhhh.txt.       */
/*       for each tt-marking-lines:   */
/*           export tt-marking-lines .*/
/*       end.                         */
/*       output close.                */
   /*Проверка прав */
  { gbl/chk-actg.i
  v-cntxt-db-num
  v-cntxt-userid
  {&action-head-code-main}
  'actn_mark_stchange':U
  {&cntxt-firm}
  v-cntxt-host-code-obj
  '':U
  0
  0
  0
  0
  false
  log-res
}
  { gbl/brwrepos.i
  &browse-name = br-mark
  &line-num= 5
}
  { gbl/brwrepos.i
  &browse-name = br-mark-item
  &line-num= 5
}

  run init-temp in this-procedure .
  run enable_UI in this-procedure .
  apply "entry" to v-mark in FRAME {&FRAME-NAME}.
  if ObjSrv:Env:ParametrsOfSection:GetSectionEDO(v-cntxt-obj-type, v-cntxt-obj-code):IsManual
    then v-manual = yes .
    else do: 
    v-manual = no .
    v-mark:READ-ONLY IN FRAME {&frame-name}        = TRUE .
    end.
  WAIT-FOR GO OF FRAME {&FRAME-NAME} focus {&browse-name}.
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

  frame {&frame-name}:title = p-doc + " " + p-mode.
  ENABLE
    br-mark
    br-mark-item
    b-exit
    b-hist
    with frame {&frame-name} .  
  display f-text with frame {&frame-name} .
      
  if p-mode <> {&lookup} then 
  do:
    if p-type = 5 then 
    do:
      ENABLE
        b-del
        b-mark
        bt-not-sel-all
        bt-not-sel-desel-all
        with frame {&frame-name} .
    end.  
    ENABLE
      v-mark
      with frame {&frame-name} .
    /*проверка на права*/
    if log-res then 
    do:  
      enable
        c-status
        c-status-2
        b-change
        b-change-2
        b-mark
        b-mark-2
        bt-not-sel-all
        bt-not-sel-all-2
        bt-not-sel-desel-all
        bt-not-sel-desel-all-2
        WITH FRAME {&frame-name}.
    end.   
  end.
  else 
  do:
    display
      b-del
      b-mark
      b-mark-2
      bt-not-sel-all
      bt-not-sel-all-2
      bt-not-sel-desel-all
      bt-not-sel-desel-all-2
      c-status
      c-status-2
      b-change
      b-change-2
      c-status-2
      WITH FRAME {&frame-name}.
  end.  
  if p-type = 1 then 
  do:
    if p-mode <> {&lookup} then 
    do:
      enable
        Status_
        v-mark
        with frame {&frame-name} .
    end.
  end.
  else do:
    hide b_block in frame {&frame-name} .
  end.  
  if p-type = 0 then 
  do:
    browse br-mark:GET-BROWSE-COLUMN(7):VISIBLE = no.
    browse br-mark-item:GET-BROWSE-COLUMN(7):VISIBLE = no.
    hide 
      Status_
      v-mark
      in frame {&frame-name} .
  end.  
  if p-type <> 2 then 
  do:
    find first buf_utd-err no-lock where buf_utd-err.db-num = tt-marking-lines.db-num and buf_utd-err.doc-id = tt-marking-lines.doc-id and buf_utd-err.reckey begins "utd-marking-lines" no-error .
    if available (buf_utd-err) then 
      enable b_error with frame {&frame-name} .
  end.  
  if p-mode = {&lookup} then 
  do:
    enable v-mark with frame {&frame-name} .
  end.
  if p-type = 6 then 
  do:
    display qnty-mark with frame {&frame-name} .
    display qnty-mark-2 with frame {&frame-name} .
    hide f-qnty-unit in frame {&frame-name} .
  end.
  else 
  do:  
    display f-qnty-unit with frame {&frame-name} .
    hide qnty-mark   in frame {&frame-name} .
    hide qnty-mark-2 in frame {&frame-name} .
  end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE save-mark d-mark 
PROCEDURE save-mark :
/* --------------------------------------------------------------------
                      Purpose:     ENABLE the User Interface
                      Parameters:  <none>
                      Notes:       Here we display/view/enable the widgets in the
                                   user-interface.  In addition, OPEN all queries
                                   associated with each FRAME and BROWSE.
                                   These statements here are based on the "Other
                                   Settings" section of the widget Property Sheets.
                       -------------------------------------------------------------------- */
define variable v-GTIN as character no-undo .

for each X_marking-line no-lock where X_marking-line.GrayZone = yes:
          create buf_utd-marking-lines .
          assign
            buf_utd-marking-lines.db-num    = X_marking-line.db-num
            buf_utd-marking-lines.doc-id    = X_marking-line.doc-id
            buf_utd-marking-lines.doc-level = X_marking-line.doc-level
            buf_utd-marking-lines.gds-code  = X_marking-line.gds-code
            buf_utd-marking-lines.LineNum   = X_marking-line.LineNum
            buf_utd-marking-lines.mark      = X_marking-line.mark
            buf_utd-marking-lines.sts       = X_marking-line.sts-utd
            .
         find first ub.marking exclusive-lock where ub.marking.mark = X_marking-line.mark no-error . 
          if not available (ub.marking) then 
          do:
            create ub.marking .
            assign
              ub.marking.mark = X_marking-line.mark
              .
          end.  
          v-GTIN = getGtinByDM(X_marking-line.mark) .
          assign
            ub.marking.gds-code    = X_marking-line.gds-code
            ub.marking.sts         = X_marking-line.sts
            ub.marking.gds-ext-id  = v-gtin
            ub.marking.obj-code    = X_marking-line.obj-code
            ub.marking.obj-type    = X_marking-line.obj-type
            ub.marking.mark-parent = mark-parent
            .
          ub.marking.unit-ext  = getLevelMotpByCodId(X_marking-line.mark) .
          ub.marking.box-qnty  = getQntyUTDByCodId(X_marking-line.mark) .
/*          ub.marking.unit = getLevelUTDByDM(v-marking) .*/
 
end.  
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
  /*по товару*/
  define variable ii       as integer   no-undo .
  define variable Status_1 as character no-undo .
  define variable StatusTH as class     ibs.th.str.marking.sts no-undo .
  
  Status_1 = "" + {&comma-char} + '0':U .

  StatusTH = ObjSrv:Env:Marking:Sts .

  do ii = 1 to StatusTH:Mark:MarkMap:GetItem(ii):
    Status_1 = Status_1 + {&comma-char} + StatusTH:Mark:CurrMarkMapProp:Label_ + {&comma-char} + string(StatusTH:Mark:CurrMarkMapProp:KeyIntDB) .
  end.
  ASSIGN
    c-status:LIST-ITEM-PAIRS  in frame {&frame-name} = Status_1 .
  ASSIGN
    c-status-2:LIST-ITEM-PAIRS  in frame {&frame-name} = Status_1 .
  
  for each tt-marking-lines no-lock where tt-marking-lines.unit-ext = "UNIT":
    v-qnty-mark = v-qnty-mark + 1 .
  end.  
  f-qnty-unit = v-qnty-mark .
  if p-type = 6 then do:
  find first tt-marking-lines no-lock where tt-marking-lines.doc-level = 1 no-error .
  if available (tt-marking-lines) then do:
  qnty-mark = tt-marking-lines.box-qnty .
  mark-parent = tt-marking-lines.mark .
  end.
  f-text = "Упаковка с неполным составом марок, необходимо просканировать все марки упаковки" .
  end.
  {&OPEN-BROWSERS-IN-QUERY-d-mark}
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-temp-item d-mark 
PROCEDURE init-temp-item :
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
  define variable v-status as character no-undo .
  RETURN v-status.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME v-mark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-mark d-mark
ON ENTRY OF v-mark IN FRAME d-mark /* Марка */
  DO:
    run LoadKeyboardLayoutA (input v-scan-str, input 0, output iLang).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scan-mark d-mark 
PROCEDURE scan-mark :
define variable v_list      as character no-undo .
    define variable ii          as integer   no-undo .
    define variable v-marking   as character no-undo .
    define variable recid_mark1 as integer   no-undo .
    define variable v-GTIN      as character no-undo .
    define variable v-gds-code  as integer   no-undo .
    define VARIABLE vRecKeyLine as character no-undo .
    define buffer gray_marking                for ub.marking .
    define buffer gray_unit-marking           for ub.marking .
    define buffer gray_utd-marking-lines      for ub.utd-marking-lines .
    define buffer gray_unit_utd-marking-lines for ub.utd-marking-lines .
    define buffer buf_utd-lines for ub.utd-lines .
    define buffer buf_utd-marking-lines for ub.utd-marking-lines .
    define buffer X_utd-lines for tt-utd-lines .
    define buffer buf_utd-err for ub.utd-err .
    define buffer un_utd-marking-lines    for ub.utd-marking-lines .
    
   if v-mark:screen-value in frame {&frame-name} = ""
    then do:
      v-mark:screen-value in frame {&frame-name} = v-scan-str.
    end.
      v-scan-str = "". 
    assign 
    v-mark = v-mark:screen-value in frame {&frame-name}.
    v-marking = GetCodeIdent(v-mark) .
    
    f-text = "" .
    f-text:screen-value = "" .
/*    if v-marking = "" or v-marking = ? then RETurn no-apply .*/
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
    v-marking = GetCodeIdent(v-mark) .
    if v-marking = "" or v-marking = ? then 
    do:
        F-text = "            Просканирован штрих код, необходимо просканировать марку" .
        display F-text with frame {&frame-name}.
        v-mark:screen-value = "" .
        v-mark = "" .
        return no-apply.
    end.  
    if p-mode <> {&lookup} then 
    do:
      /*Режим Серая зона*/
      if p-type = 6 then 
      do:
        find first X_marking-line exclusive-lock where X_marking-line.mark begins v-marking no-error .
        if available (X_marking-line) then
        do:
          recid_mark = recid (X_marking-line) .
          if X_marking-line.sts-utd = Marking:Checked_:KeyIntDB then
          do:
            if qnty-mark = qnty-mark-2 then 
            do:
             F-text = "               Упаковка просканирована полностью".
             display F-text with frame {&frame-name}.
              v-mark:screen-value = "" .
              v-mark = "" . 
              return no-apply.              
            end.
            else 
            do:  
              F-text = "            Марка уже проверена, просканируйте следующую".
              display F-text with frame {&frame-name}.
              v-mark:screen-value = "" .
              v-mark = "" . 
              return no-apply.
            end.  
          end.  
          if X_marking-line.sts = Marking:GrayZone:KeyIntDB and X_marking-line.doc-level = 1 then 
          do:
            F-text = "      Это марка упаковки, просканируйте марку индивидуальной упаковки".
            display F-text with frame {&frame-name}.
            v-mark:screen-value = "" .
            v-mark = "" . 
            return no-apply.                  
          end.  
/*          if X_marking-line.sts > Marking:DemandInfo:KeyIntDB then do:           */
/*              F-text = "            Марка оприходована, просканируйте следующую".*/
/*              display F-text with frame {&frame-name}.                           */
/*              v-mark:screen-value = "" .                                         */
/*              v-mark = "" .                                                      */
/*              return no-apply.                                                   */
/*          end.                                                                   */
          find first buf_utd-marking-lines exclusive-lock where buf_utd-marking-lines.mark = X_marking-line.mark and buf_utd-marking-lines.db-num = X_marking-line.db-num and
            buf_utd-marking-lines.doc-id = X_marking-line.doc-id no-error .
          if available (buf_utd-marking-lines) then buf_utd-marking-lines.sts = Marking:Checked_:KeyIntDB .
          assign
            X_marking-line.sts-utd = Marking:Checked_:KeyIntDB .
            X_marking-line.stts-utd = StatusTHName(Marking:Checked_:KeyIntDB)
            .
          qnty-mark-2 = qnty-mark-2 + 1 .
          display qnty-mark-2 with frame {&frame-name} .
          br-mark-item :refresh().
          reposition br-mark-item to recid recid_mark no-error .

          v-mark:screen-value = "" .
          v-mark = "" .

        end.
        else 
        do:
          find first buf_utd-marking-lines exclusive-lock where buf_utd-marking-lines.mark begins v-marking and buf_utd-marking-lines.db-num = X_marking-line.db-num and
            buf_utd-marking-lines.doc-id = X_marking-line.doc-id no-error .
            if qnty-mark = qnty-mark-2 then 
            do:
             F-text = "               Упаковка просканирована полностью".
             display F-text with frame {&frame-name}.
              v-mark:screen-value = "" .
              v-mark = "" . 
              return no-apply.              
            end. 
            if v-qnty-mark = qnty-mark then do:
             F-text = "        Все неизвестные марки добавлены, просканируйте непроверенные марки".
             display F-text with frame {&frame-name}.
              v-mark:screen-value = "" .
              v-mark = "" . 
              return no-apply.              
            end.  
          if available (buf_utd-marking-lines) then 
          do:
            f-text = "                    Марка в документе уже есть".
            display F-text with frame {&frame-name}.
            v-mark:screen-value = "" .
            v-mark = "" .
            leave .
          end.   
          v-GTIN = getGtinByDM(v-marking) .
          v-gds-code = getGdsCodeByGtin(v-GTIN) .
          if v-gds-code <> X_marking.gds-code then 
          do:
            f-text = "                Марка не может относится к проверяемой упаковке ".
            display F-text with frame {&frame-name}.
            v-mark:screen-value = "" .
            v-mark = "" .
            leave .
          end.  
          find first ub.marking exclusive-lock where ub.marking.mark begins v-marking no-error .
          if available (ub.marking) then 
          do:
/*            if ub.marking.unit-ext <> "UNIT" or (ub.marking.mark-parent <> "" and ub.marking.mark-parent <> X_marking.mark) then*/
/*            do:                                                                                                                 */
              f-text = "              Марка оприходована, просканируйте следующую".
              display F-text with frame {&frame-name}.
              v-mark:screen-value = "" .
              v-mark = "" .
              leave .
/*            end.*/
          end.
          if qnty-mark-2 = X_marking.box-qnty then do:
            f-text = "                  Все неизвестные марки по упаковке добавлены" .
            display F-text with frame {&frame-name}.
            v-mark:screen-value = "" .
            v-mark = "" . 
            return no-apply.
          end.        
          /*добавляем марку*/
/*          create buf_utd-marking-lines .                               */
/*          assign                                                       */
/*            buf_utd-marking-lines.db-num    = X_marking.db-num         */
/*            buf_utd-marking-lines.doc-id    = X_marking.doc-id         */
/*            buf_utd-marking-lines.doc-level = 2                        */
/*            buf_utd-marking-lines.gds-code  = X_marking.gds-code       */
/*            buf_utd-marking-lines.LineNum   = X_marking.LineNum        */
/*            buf_utd-marking-lines.mark      = v-marking                */
/*            buf_utd-marking-lines.sts       = Marking:Checked_:KeyIntDB*/
/*            .                                                          */
/*          if not available (ub.marking) then                           */
/*          do:                                                          */
/*            create ub.marking .                                        */
/*            assign                                                     */
/*              ub.marking.mark = v-marking                              */
/*              .                                                        */
/*          end.                                                         */
/*          assign                                                       */
/*            ub.marking.gds-code    = buf_utd-marking-lines.gds-code    */
/*            ub.marking.sts         = Marking:DeliveryControl:KeyIntDB  */
/*            ub.marking.gds-ext-id  = v-GTIN                            */
/*            ub.marking.obj-code    = X_marking.obj-code                */
/*            ub.marking.obj-type    = X_marking.obj-type                */
/*            ub.marking.mark-parent = X_marking.mark                    */
/*            .                                                          */
/*          ub.marking.unit-ext  = getLevelMotpByDM(v-marking) .         */
/*          ub.marking.box-qnty  = getQntyUTDByDM(v-marking) .           */
/*/*          ub.marking.unit = getLevelUTDByDM(v-marking) .*/           */

          create X_marking-line .
          assign
            X_marking-line.db-num      = X_marking.db-num
            X_marking-line.doc-id      = X_marking.doc-id
            X_marking-line.doc-level   = 2
            X_marking-line.gds-code    = X_marking.gds-code
            X_marking-line.LineNum     = X_marking.LineNum
            X_marking-line.mark        = v-marking 
            X_marking-line.sts         = Marking:DeliveryControl:KeyIntDB
            X_marking-line.mark-parent = X_marking.mark
            X_marking-line.GrayZone    = yes
            .
            X_marking-line.gds-name    = GdsName(X_marking-line.gds-code) 
            .
            
            X_marking-line.box-qnty = getQntyUTDByCodId(v-marking) .
            X_marking-line.unit-ext  = getLevelMotpByCodId(v-marking) .
            X_marking-line.unit       = getLevelUTDByCodId(v-marking) .    
          assign
            X_marking-line.sts-utd = Marking:Checked_:KeyIntDB .
            X_marking-line.stts-utd = StatusTHName(Marking:Checked_:KeyIntDB) .
            X_marking-line.stts = StatusTHName(X_marking-line.sts)
            .
          qnty-mark-2 = qnty-mark-2 + 1 .
          v-qnty-mark = v-qnty-mark + 1 .
          display qnty-mark-2 with frame {&frame-name} .
                
/*          find first X_marking-line where X_marking-line.mark = ub.marking.mark no-error .*/
          recid_mark = recid(X_marking-line) .
          {&OPEN-BROWSERS-IN-QUERY-d-mark-item} /*переотрывает запрос*/
          br-mark-item:refresh () no-error . /*обновляет экран*/
          reposition br-mark-item to recid recid_mark no-error . /*позиционирует запись*/

          v-mark:screen-value = "" .
          v-mark = "" .
        end.  
      end.
      else /*не серая зона*/
      do:  
        find first X_marking exclusive-lock where X_marking.mark begins v-marking no-error .
        if available (X_marking) then
        do:
            for first buf_utd-marking-lines no-lock where buf_utd-marking-lines.doc-id = X_marking.doc-id
                                                       and buf_utd-marking-lines.db-num = X_marking.db-num
                                                       and buf_utd-marking-lines.mark = X_marking.mark,
                first buf_utd-lines no-lock where buf_utd-lines.db-num = buf_utd-marking-lines.db-num
                                              and buf_utd-lines.doc-id = buf_utd-marking-lines.doc-id
                                              and buf_utd-lines.LineNum = buf_utd-marking-lines.LineNum:   
                run gen-key-rec ("utd-lines", 
        input  buffer buf_utd-lines:handle, 
        output vRecKeyLine).

      find first buf_utd-err no-lock where buf_utd-err.doc-id = buf_utd-lines.doc-id and buf_utd-err.db-num = buf_utd-lines.db-num and buf_utd-err.reckey = vRecKeyLine no-error .
      if available (buf_utd-err) then 
      do:
          F-text = "Товар не подлежит приемке, т.к. не прошел проверку на корректность" .
            display F-text with frame {&frame-name}.
            v-mark:screen-value = "" .
            v-mark = "" .
            return no-apply.   
        end.
        
         end.
          recid_mark = recid (X_marking) .
          if X_marking.sts-utd = Marking:Checked_:KeyIntDB then
          do:
            f-text = "          Марка уже проверена, просканируйте следующую" .
            display F-text with frame {&frame-name}.
            v-mark:screen-value = "" .
            v-mark = "" . 
            return no-apply.
          end.
         
          else
          do:
            if X_marking.sts = Marking:MarkError:KeyIntDB  then do:
            F-text = "Товар не подлежит приемке, т.к. не прошел проверку на корректность" .
            display F-text with frame {&frame-name}.
            v-mark:screen-value = "" .
            v-mark = "" .
            return no-apply.              
            end.
               
            find first buf_utd-marking-lines exclusive-lock where buf_utd-marking-lines.mark = X_marking.mark and buf_utd-marking-lines.db-num = X_marking.db-num and
              buf_utd-marking-lines.doc-id = X_marking.doc-id no-error .
            if available (buf_utd-marking-lines) then 
            do:
                    /*просканирована марка с серой зоной*/
              if can-find (buf_marking where buf_marking.mark = buf_utd-marking-lines.mark and buf_marking.sts = Marking:GrayZone:KeyIntDB)
                then 
              do:
/*                message "Упаковка с неполным составом марок, необходимо просканировать все индивидуальные упаковки" skip*/
/*                  view-as alert-box.                                                                                    */
                v-mark:screen-value = "" .
                v-mark = "" . 
                  for first gray_utd-marking-lines no-lock where gray_utd-marking-lines.db-num = X_marking.db-num and 
                                                                 gray_utd-marking-lines.doc-id = X_marking.doc-id and 
                                                                 gray_utd-marking-lines.LineNum = X_marking.LineNum and 
                                                                 gray_utd-marking-lines.mark = buf_utd-marking-lines.mark:
                    for first gray_marking no-lock where gray_marking.mark = buf_utd-marking-lines.mark :
                      create tt-gray-marking-lines .
                      assign
                        tt-gray-marking-lines.gds-name    = GdsName(gray_utd-marking-lines.gds-code)
                        tt-gray-marking-lines.stts-utd    = StatusTHName(gray_utd-marking-lines.sts)
                        tt-gray-marking-lines.stts        = StatusTHName(gray_marking.sts)
                        tt-gray-marking-lines.mark        = gray_marking.mark
                        tt-gray-marking-lines.mark-parent = gray_marking.mark-parent
                        tt-gray-marking-lines.gds-code    = gray_utd-marking-lines.gds-code
                        tt-gray-marking-lines.sts         = gray_marking.sts
                        tt-gray-marking-lines.sts-utd     = gray_utd-marking-lines.sts
                        tt-gray-marking-lines.unit        = gray_marking.unit
                        tt-gray-marking-lines.box-qnty    = gray_marking.box-qnty
                        tt-gray-marking-lines.LineNum     = gray_utd-marking-lines.LineNum
                        tt-gray-marking-lines.db-num      = gray_utd-marking-lines.db-num
                        tt-gray-marking-lines.doc-id      = gray_utd-marking-lines.doc-id
                        tt-gray-marking-lines.doc-level   = gray_utd-marking-lines.doc-level
                        .
                    end.
                    for each gray_unit-marking no-lock where gray_unit-marking.mark-parent = gray_utd-marking-lines.mark:
                    for first gray_unit_utd-marking-lines no-lock where gray_unit_utd-marking-lines.db-num = X_marking.db-num and gray_unit_utd-marking-lines.doc-id = X_marking.doc-id
                    and gray_unit_utd-marking-lines.LineNum = X_marking.LineNum and gray_unit_utd-marking-lines.mark = gray_unit-marking.mark:
                      create tt-gray-marking-lines .
                      assign
                        tt-gray-marking-lines.gds-name    = GdsName(gray_unit_utd-marking-lines.gds-code)
                        tt-gray-marking-lines.stts-utd    = StatusTHName(gray_unit_utd-marking-lines.sts)
                        tt-gray-marking-lines.stts        = StatusTHName(gray_unit-marking.sts)
                        tt-gray-marking-lines.mark        = gray_unit-marking.mark
                        tt-gray-marking-lines.mark-parent = gray_unit-marking.mark-parent
                        tt-gray-marking-lines.gds-code    = gray_unit_utd-marking-lines.gds-code
                        tt-gray-marking-lines.sts         = gray_unit-marking.sts
                        tt-gray-marking-lines.sts-utd     = gray_unit_utd-marking-lines.sts
                        tt-gray-marking-lines.unit        = gray_unit-marking.unit
                        tt-gray-marking-lines.unit-ext    = gray_unit-marking.unit-ext
                        tt-gray-marking-lines.box-qnty    = gray_unit-marking.box-qnty
                        tt-gray-marking-lines.LineNum     = gray_unit_utd-marking-lines.LineNum
                        tt-gray-marking-lines.db-num      = gray_unit_utd-marking-lines.db-num
                        tt-gray-marking-lines.doc-id      = gray_unit_utd-marking-lines.doc-id
                        tt-gray-marking-lines.doc-level   = gray_unit_utd-marking-lines.doc-level
                        .
                    end.
                    end.
                  end.
                          run str/mark_browse.w (input parparentproc,
                            input-output table tt-gray-marking-lines by-reference,
                            input p-mode,
                            input "Марки по товару " + string(X_marking.gds-code) + " " + GdsName(X_marking.gds-code) + " со статусом: " + StatusTHName(Marking:GrayZone:KeyIntDB),
                            input 6,
                            input "" /*тип продукции*/
                            ) no-error .
                  for each tt-gray-marking-lines no-lock:
                    find first tt-marking-lines exclusive-lock where tt-marking-lines.mark = tt-gray-marking-lines.mark no-error .
                    if not available (tt-marking-lines) then do:
                      create tt-marking-lines .
                      buffer-copy tt-gray-marking-lines to tt-marking-lines .
                      v-qnty-mark = v-qnty-mark + 1 .
                      f-qnty-unit = v-qnty-mark .
                    end.  
                    else do:
                      assign
                      tt-marking-lines.sts = tt-gray-marking-lines.sts
                      tt-marking-lines.stts = tt-gray-marking-lines.stts
                      tt-marking-lines.sts-utd = tt-gray-marking-lines.sts-utd
                      tt-marking-lines.stts-utd = tt-gray-marking-lines.stts-utd
                      .
                    end.  
                  end.   
                  empty temp-table tt-gray-marking-lines .
                  br-mark :refresh().
                  reposition br-mark to recid recid_mark no-error .
                  br-mark-item:refresh () no-error .
display f-qnty-unit with frame {&frame-name} .
              end.      
              else do:      
              if buf_utd-marking-lines.doc-level > 1 then 
              do:
                if can-find (ub.marking where ub.marking.mark = buf_utd-marking-lines.mark and ub.marking.unit-ext <> "UNIT") then 
                do:
                  /*            if tree:LevelUpUTD(buf_utd-marking-lines.mark, buf_utd-marking-lines.doc-id, buf_utd-marking-lines.db-num) then do:*/
                  message "Разгруппировать упаковки?"
                    view-as alert-box question buttons yes-no update ungroup.
                  if ungroup then 
                  do:
                    if tree:UnGroupUTD(buf_utd-marking-lines.mark, buf_utd-marking-lines.doc-id, buf_utd-marking-lines.db-num) then 
                    do:
                      message "Упаковка с маркой " + buf_utd-marking-lines.mark + " разгруппирована."
                        view-as alert-box.
                    end.
                  /*              end.*/
                  end.  
                end.
                else 
                do:
                  f-text = "Марка входит в состав упаковки, просканируйте марку упаковки" . 
                  display F-text with frame {&frame-name}.
                  v-mark:screen-value = "" .
                  v-mark = "" .
                  return no-apply.
                end.     
              end.        
              if tree:LevelDownUTD(buf_utd-marking-lines.mark, buf_utd-marking-lines.doc-id, buf_utd-marking-lines.db-num) then 
              do:
                tree:StatusDownUTD(buf_utd-marking-lines.mark, buf_utd-marking-lines.doc-id, buf_utd-marking-lines.db-num, Marking:Checked_:KeyIntDB) .
                for each X_marking-line exclusive-lock where X_marking-line.mark-parent begins v-marking:
                  X_marking-line.sts-utd = Marking:Checked_:KeyIntDB .
                  X_marking-line.stts-utd = StatusTHName(Marking:Checked_:KeyIntDB) .
                end.
                assign
                  X_marking.sts-utd = Marking:Checked_:KeyIntDB .
                X_marking.stts-utd = StatusTHName(Marking:Checked_:KeyIntDB)
                  .
              end.
              for first bf_utd-marking-lines exclusive-lock where bf_utd-marking-lines.mark = buf_utd-marking-lines.mark and bf_utd-marking-lines.db-num = buf_utd-marking-lines.db-num and
                bf_utd-marking-lines.doc-id = buf_utd-marking-lines.doc-id:
                bf_utd-marking-lines.sts   = X_marking.sts-utd .  
              end.  

            end.  
            v-mark:screen-value = "" .
            v-mark = "" . 
          end.
          end.
          br-mark :refresh().
          reposition br-mark to recid recid_mark no-error .
          {&OPEN-BROWSERS-IN-QUERY-d-mark}
          br-mark-item:refresh () no-error .
        /*        reposition br-mark-item to recid recid_mark no-error .*/
        /*        {&OPEN-QUERY-br-mark-item}                            */
        end.
        else 
        do:
          find first X_marking-line exclusive-lock where X_marking-line.mark begins v-marking no-error .
          if available (X_marking-line) then
          do:
            recid_mark = recid (X_marking-line) .
            if X_marking-line.sts-utd = Marking:Checked_:KeyIntDB then
            do:
              F-text = "            Марка уже проверена, просканируйте следующую" .
              display F-text with frame {&frame-name}.
              /*            F-text = "            Марка уже проверена, просканируйте следующий" .*/
              /*            display F-text with frame {&frame-name}.                             */
              v-mark:screen-value = "" .
              v-mark = "" . 
              return no-apply.
            end.
            else
            do:
              assign
                X_marking-line.sts-utd  = Marking:Checked_:KeyIntDB
                X_marking-line.stts-utd = StatusTHName(Marking:Checked_:KeyIntDB)
                .
              find first buf_utd-marking-lines exclusive-lock where buf_utd-marking-lines.mark = X_marking-line.mark and buf_utd-marking-lines.db-num = X_marking-line.db-num and
                buf_utd-marking-lines.doc-id = X_marking-line.doc-id no-error .
              if available (buf_utd-marking-lines) then 
              do: 
                if buf_utd-marking-lines.doc-level <> 1 and buf_utd-marking-lines.doc-level <> 0 then 
                do:
                  if tree:LevelUpUTD(buf_utd-marking-lines.mark, buf_utd-marking-lines.doc-id, buf_utd-marking-lines.db-num) then 
                  do:
                    message "Разгруппировать упаковки?"
                      view-as alert-box question buttons yes-no update ungroup.
                    if ungroup then 
                    do:
                      if tree:UnGroupUTD(buf_utd-marking-lines.mark, buf_utd-marking-lines.doc-id, buf_utd-marking-lines.db-num) then 
                      do:
                        message "Упаковка с маркой " + buf_utd-marking-lines.mark + " разгруппирована."
                          view-as alert-box.
                      end.
                    end.  
                  end.  
                end.        
                if tree:LevelDownUTD(buf_utd-marking-lines.mark, buf_utd-marking-lines.doc-id, buf_utd-marking-lines.db-num) then 
                do:
                  tree:StatusDownUTD(buf_utd-marking-lines.mark, buf_utd-marking-lines.doc-id, buf_utd-marking-lines.db-num, Marking:Checked_:KeyIntDB) .
                end.
                for first bf_utd-marking-lines exclusive-lock where bf_utd-marking-lines.mark = buf_utd-marking-lines.mark and bf_utd-marking-lines.db-num = buf_utd-marking-lines.db-num and
                  bf_utd-marking-lines.doc-id = buf_utd-marking-lines.doc-id:
                  bf_utd-marking-lines.sts   = X_marking-line.sts-utd .  
                end.  
 
              end.           
              v-mark:screen-value = "" .
              v-mark = "" . 
            end.
            br-mark-item :refresh().
            reposition br-mark-item to recid recid_mark no-error .
            v-mark:screen-value = "" .
            v-mark = "" . 
          end.
          else 
          do:
            f-text = "              Марка не найдена в документе" .
            display F-text with frame {&frame-name}.
            v-mark = "" .
            v-mark:screen-value = "" .
            return no-apply .
          end.  
        end.     
      end.
    end.
    else 
    do:
      find first X_marking no-lock where X_marking.mark begins v-marking and X_marking.doc-level = 1 no-error .
      if available (X_marking) then
      do:
        recid_mark = recid (X_marking) .
        reposition br-mark to recid recid_mark no-error .
      end.
      else 
      do:  
        find first X_marking-line exclusive-lock where X_marking-line.mark begins v-marking no-error .
        if available (X_marking-line) then
        do:
          recid_mark1 = recid (X_marking-line) .
          reposition br-mark-item to recid recid_mark1 no-error .
          if error-status:error then 
          do:
            f-text = "            Марка не отображена в браузере" .
            display F-text with frame {&frame-name}.
          end.  
        end.
        else 
        do:
          f-text = "              Марка не найдена в документе" .
          display F-text with frame {&frame-name}.
        end. 
      end.
      v-mark:screen-value = "" .
      v-mark = "" .
    end.    
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-any-key Dialog-Frame 
PROCEDURE proc-any-key :
    if not v-manual
        then
        if v-scan-str = ""
            then etime(yes).
        else
            if etime > 500
                then v-scan-str = "".
    v-scan-str = v-scan-str + last-event:label.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

