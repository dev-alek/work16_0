&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
using ibs.th.gbl.sys.objsrv.
using ibs.th.str.utd.edoctype .
using ibs.th.str.marking.sts.*.
/* Connected Databases 
          ub               PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME d-utd



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS d-utd 
/*------------------------------------------------------------------------

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Сбор марок

Автор: Шкляр Елена
Дата создания: 20/04/95
Author: Shklyar Elena
Creation date: 20/04/95

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
define input parameter  parparentproc as widget-handle no-undo .
define input parameter p-mode as character no-undo .
define output parameter p-rid-list as character no-undo .


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Список УПД".
{ cmp/vssrevis.i }
{ cmp/trg-def.i  }
{ cmp/showinf.i }
{ cmp/r-pril.i new }
{ gbl/userobjs.i }
{ gbl/cur-time.i }
define variable v-obj-active            as logical     no-undo .
{ gbl/getcntxt.i def }
{ gbl/getcntxt.i get }
    { gbl/objat.i
      v-cntxt-obj-type
      v-cntxt-obj-code
      "'active=request'"
      v-obj-active
}
{ gbl/prn-lib.i }
{ gbl/waitfram.i }
{ cmp/mrk-strf.i }
{ gbl/color.i }
{ str/edo.i }
{ str/temp_upd.i }
{ bge/esysattr.i }

/* Local Variable Definitions ---                                       */
define variable log-res-Token           as log         no-undo.
define variable log-res-recheck         as logical     no-undo .
define variable varlog                  as logical     no-undo .
define variable rr                      as recid       no-undo.
define variable v_type                  as char        no-undo.
define variable v-is-deploy             as logical     no-undo .
define variable v-rid-list              as character   no-undo .
define variable v-db-list               as character   no-undo .
define variable Vflaginout as logical no-undo.
define variable row_utd                 as rowid       no-undo .
define variable recid_utd               as integer     no-undo .
define variable ii                      as integer     no-undo .
define variable v-time                  as integer     no-undo .
define variable time_old_start          as datetime-tz no-undo.
define variable vtime                   as int64       no-undo.
define variable mflagExit               as logical     no-undo.
define variable v-flag                  as logical     no-undo .
define variable v-void-logical          as logical     no-undo .
define variable v-current-sort-string   as character   no-undo .
define variable v-current-sertif-string as character   no-undo .
define variable mode-erprn              as logical     no-undo .
define variable conf-par                as character   no-undo .
define variable par-type                as character   no-undo .

define variable StatusTH  as class ibs.th.str.utd.sts.th   no-undo .
define variable EdocType  as class ibs.th.str.utd.edoctype no-undo .

define buffer buf_utd     for ub.utd .  
define buffer buf_clients for ub.clients .
define buffer buf_utd-lines-attr    for ub.utd-lines-attr .

def    var      Marking   as class mark                    no-undo .

/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER X_utd FOR tt-utd.


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME d-utd
&Scoped-define BROWSE-NAME br-utd

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES X_utd

/* Definitions for BROWSE br-utd                                        */
&Scoped-define FIELDS-IN-QUERY-br-utd X_utd.DocumentNumber X_utd.EDocType ~
X_utd.DocumentDate X_utd.stts X_utd.scan-qnty X_utd.free-qnty
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-utd 
&Scoped-define QUERY-STRING-br-utd FOR EACH X_utd NO-LOCK by X_utd.DocumentDate desc INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-utd OPEN QUERY br-utd FOR EACH X_utd NO-LOCK by X_utd.DocumentDate desc by X_utd.Timestamp desc INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-utd X_utd
&Scoped-define FIRST-TABLE-IN-QUERY-br-utd X_utd


/* Definitions for DIALOG-BOX d-utd                                     */
&Scoped-define OPEN-BROWSERS-IN-QUERY-d-utd ~
    ~{&OPEN-QUERY-br-utd}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-exit b-sel b-update b-utd b-add b-del ~
B-refresh b-hist F-date-to F-date-from RADIO-SET-1 ~
RADIO-SET-2 f-DocumentNumber br-utd 
&Scoped-Define DISPLAYED-OBJECTS F-date-to F-date-from RADIO-SET-1 ~
RADIO-SET-2 f-DocumentNumber 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CliName d-utd 

FUNCTION CliName RETURNS CHARACTER
    (input p-cli-code as integer, input p-cli-type as character)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CliName d-utd 
FUNCTION CliName RETURNS CHARACTER
    (input p-cli-code as integer, input p-cli-type as character)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD EdoTypeName d-utd 
FUNCTION EdoTypeName RETURNS CHARACTER
    ( input p-stsTH as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD StatusTHName d-utd 
FUNCTION StatusTHName RETURNS CHARACTER
    ( input p-stsTH as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Menu Definitions                                                     */


/* Definitions of the field level widgets                               */
DEFINE BUTTON b-add 
     LABEL "&Добавить":L 
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

DEFINE BUTTON B-refresh 
     LABEL "Обновить" 
     SIZE 10 BY 1.

DEFINE BUTTON b-sel AUTO-GO 
     LABEL "&Выбор":L 
     SIZE 10 BY 1.

DEFINE BUTTON b-update 
     LABEL "&Изменить":L 
     SIZE 10 BY 1.

DEFINE BUTTON b-utd 
     LABEL "&Просмотр":L 
     SIZE 10 BY 1.

DEFINE VARIABLE F-date-from AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 10.8 BY 1 NO-UNDO.

DEFINE VARIABLE F-date-to AS DATE FORMAT "99/99/9999":U 
     LABEL "За период с" 
     VIEW-AS FILL-IN 
     SIZE 10.8 BY 1 NO-UNDO.

DEFINE VARIABLE f-DocumentNumber AS CHARACTER FORMAT "X(256)":U 
     LABEL "Номер документа" 
     VIEW-AS FILL-IN 
     SIZE 28 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Все", 0,
"Новый", 2,
"Подтвержден", 1
     SIZE 44.4 BY 1.24 NO-UNDO.

DEFINE VARIABLE RADIO-SET-2 AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Все", 0,
"Сбор марок", 1,
"Первоначальный сбор марок", 2
     SIZE 58.4 BY 1.24 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-utd FOR 
      X_utd SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-utd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-utd d-utd _STRUCTURED
  QUERY br-utd NO-LOCK DISPLAY
      X_utd.DocumentNumber COLUMN-LABEL "Номер!документа" FORMAT "x(32)":U width 14
      X_utd.DocumentDate COLUMN-LABEL "Дата документа" FORMAT "99/99/9999":U
      X_utd.stts COLUMN-LABEL "Статус" FORMAT "X(40)":U width 14
      X_utd.is-initial COLUMN-LABEL "Первоначальный" FORMAT "X(40)":U width 15
      X_utd.scan-qnty COLUMN-LABEL "Итого просканировано" FORMAT "->>>>>>9"
      X_utd.free-qnty COLUMN-LABEL "Итого остаток" FORMAT "->>>>>>9"
      X_utd.comment COLUMN-LABEL "Комментарий" FORMAT "X(256)":U width 40
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 131 BY 14.76 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME d-utd
     b-exit AT ROW 1 COL 1.6
     b-sel AT ROW 1 COL 11.6 WIDGET-ID 222
     b-update AT ROW 1 COL 11.6 WIDGET-ID 222
     b-utd AT ROW 1 COL 21.6 WIDGET-ID 230
     b-add AT ROW 1 COL 31.6 WIDGET-ID 266
     b-del AT ROW 1 COL 41.6 WIDGET-ID 280
     B-refresh AT ROW 1 COL 118 WIDGET-ID 286
     b-hist AT ROW 1 COL 129 WIDGET-ID 64
     F-date-to AT ROW 2.29 COL 13.6 COLON-ALIGNED WIDGET-ID 238
     F-date-from AT ROW 2.29 COL 28 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     RADIO-SET-1 AT ROW 3.52 COL 2.6 NO-LABEL WIDGET-ID 250
     RADIO-SET-2 AT ROW 4.62 COL 2.6 NO-LABEL WIDGET-ID 282
     f-DocumentNumber AT ROW 5.81 COL 49 RIGHT-ALIGNED WIDGET-ID 276
     br-utd AT ROW 7.19 COL 1.6
     "по" VIEW-AS TEXT
          SIZE 2.6 BY .67 AT ROW 2.48 COL 27 WIDGET-ID 38
     SPACE(102.99) SKIP(19.03)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Список сборов марок":L.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Temp-Tables and Buffers:
      TABLE: X_utd B "NEW SHARED" ? ub utd
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX d-utd
   FRAME-NAME                                                           */
/* BROWSE-TAB br-utd f-DocumentNumber d-utd */
ASSIGN 
       FRAME d-utd:SCROLLABLE       = FALSE.

ASSIGN 
       br-utd:COLUMN-RESIZABLE IN FRAME d-utd       = TRUE.

/* SETTINGS FOR FILL-IN f-DocumentNumber IN FRAME d-utd
   ALIGN-R                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-utd
/* Query rebuild information for BROWSE br-utd
     _TblList          = "X_utd"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.X_utd.DocumentNumber
"DocumentNumber" "Номер!документа" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.X_utd.DocumentDate
"DocumentDate" "Дата документа" ? "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.X_utd.sts
"sts" "Статус ТН" ? "integer" ? ? ? ? ? ? no ? no no "76.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br-utd */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX d-utd
/* Query rebuild information for DIALOG-BOX d-utd
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX d-utd */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME d-utd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d-utd d-utd
ON GO OF FRAME d-utd /* Список УПД */
DO:
/*    p-rid-list = v-rid-list.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-add d-utd
ON choose OF b-add IN FRAME d-utd /* Добавить */
DO:
    subscribe "getNextseq" anywhere run-procedure "MySeqForUtd".
    MySeqUtd = ?.
    run str/Mark_Collect.w (input parparentproc,
        input ?,
        input ?,
        input {&add-def}
        ) no-error.
    run init-sort .
    unsubscribe "getNextseq".
    {&OPEN-QUERY-br-utd}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-del d-utd
ON choose OF b-del IN FRAME d-utd /* Удалить */
DO:
    define buffer bf_utd               for ub.utd .
    define buffer bf_utd-lines         for ub.utd-lines .
    define buffer bf_utd-marking-lines for ub.utd-marking-lines .
    define buffer bf_marking           for ub.marking .
    define variable Log-Res as logical no-undo.
    define variable undelete as logical no-undo .
    define variable v-auto as logical no-undo .
    if AVAILABLE (X_utd)
    then do:
        find first bf_utd exclusive-lock where bf_utd.db-num = X_utd.db-num and bf_utd.doc-id = X_utd.doc-id no-wait no-error .
        if locked bf_utd
        then do :
          message "Документ занят другим пользователем!" view-as alert-box .
          return no-apply .
        end .
        if X_utd.db-num = v-cntxt-db-num 
        and X_utd.sts = ObjSrv:Env:Utd:Sts:TH:NewStatus:KeyIntDB
        then do :
          message "Удалить документ " + X_utd.DocumentNumber + "?"
          view-as alert-box question buttons yes-no update undelete.
          if undelete 
          then do:                            
            for each bf_utd-marking-lines where bf_utd-marking-lines.db-num = X_utd.db-num
                                            and bf_utd-marking-lines.doc-id = X_utd.doc-id
                                            and bf_utd-marking-lines.sts = 0
            :
              v-auto = g#auto .
              g#auto = true .
              for each bf_marking where bf_marking.mark = bf_utd-marking-lines.mark
                                    and bf_marking.sts = objSrv:Env:Marking:Sts:Mark:FreeZone:KeyIntDB
              :
                delete bf_marking .
              end.
              g#auto = v-auto .
            end.
            delete bf_utd .
          end. /*if undelete then*/
        end.
        else do:
          message "Документ " + string (X_utd.DocumentNumber) + " не может быть удален"
          view-as alert-box.
        end.                     
        run init-sort .
        {&OPEN-QUERY-br-utd}
    end.
    else do:
        message "Нет документа для удаления"
            view-as alert-box.
    end.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-exit d-utd
ON CHOOSE OF b-exit IN FRAME d-utd /* Выход  */
DO:
/*        if v-current-sort-string <> "" then                                               */
/*        do:                                                                               */
/*            RADIO-SET-1 = integer(entry(1,v-current-sort-string,{&delim-key})) .          */
/*            RADIO-SET-2 = integer(entry(2,v-current-sort-string,{&delim-key})) .          */
/*        end.                                                                              */
/*        v-current-sort-string = string(RADIO-SET-1) + {&delim-key} + string (RADIO-SET-2).*/
/*                                                                                          */
 
    assign
      mflagExit = yes
    .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-hist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-hist d-utd
ON choose OF b-hist IN FRAME d-utd /* История */
DO:
    define variable v-rid-list as character no-undo.
    if available (X_utd) then 
    do:
        row_utd = rowid (X_utd) .
        run ref/cutdhist.w (
            X_utd.db-num, 
            X_utd.doc-id,
            parparentproc,
            0,
            "",
            0,
            "",
            "one",
            ?,
            "",
            "" ,
            v-cntxt-db-num,
            ?,
            input-output v-rid-list ) .
        br-utd:refresh ().
        reposition br-utd to rowid row_utd.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-refresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-refresh d-utd
ON CHOOSE OF B-refresh IN FRAME d-utd /* Обновить */
DO:
    f-date-from = date(f-date-from:screen-value) .
    f-date-to   = date(f-date-to:screen-value) .
    run init-sort .
    {&OPEN-QUERY-br-utd}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-sel d-utd
ON CHOOSE OF b-sel IN FRAME d-utd /* Выбор */
DO:
    define buffer buf_utd for ub.utd .
    if v-rid-list = "" then 
    do:
        if available (X_utd) then 
        do:
            find first buf_utd no-lock where buf_utd.doc-id = X_utd.doc-id and buf_utd.db-num = X_utd.db-num no-error .
            v-rid-list = string(recid(buf_utd)) .
        end.  
    end.  
    p-rid-list = v-rid-list .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-update
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-update d-utd
ON CHOOSE OF b-update IN FRAME d-utd /* Изменить */
DO:
    define buffer bf_tt-utd for tt-utd .
  
    define variable doc-id   like ub.utd.doc-id no-undo .
    define variable db-num   like ub.utd.db-num no-undo .
    define variable EDocType like ub.utd.EDocType no-undo .
    define variable Log-Res  as logical no-undo.
    if available (x_utd) 
    then do:
      if X_utd.db-num = v-cntxt-db-num 
      and X_utd.sts = ObjSrv:Env:Utd:Sts:TH:NewStatus:KeyIntDB
      then do :
        row_utd = rowid(X_utd) . 
        assign
          doc-id   = x_utd.doc-id
          db-num   = x_utd.db-num
          EDocType = x_utd.EDocType
        .
        subscribe "getNextseq" anywhere run-procedure "MySeqForUtd".
        run str/Mark_Collect.w (input parparentproc,
            input x_utd.doc-id,
            input x_utd.db-num,
            input {&update}
            )  .
        unsubscribe "getNextseq".  
        
        run init-id (doc-id, db-num).
        run init-sort .
        {&OPEN-QUERY-br-utd}

        for first bf_tt-utd no-lock where rowid(bf_tt-utd) = row_utd :
          reposition br-utd to rowid row_utd .
        end .
      end .
      else do :
        message "Можно изменять документ только в статусе <Новый>" view-as alert-box.  
        return no-apply .
      end .
    end.  
    else do: 
      message "Не выбран документ" view-as alert-box.  
      return no-apply .
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-utd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-utd d-utd
ON choose OF b-utd IN FRAME d-utd /* Просмотр */
DO:
    define variable Log-Res as logical no-undo.
    if available (x_utd) then 
    do:
        row_utd = rowid (X_utd) .
        subscribe "getNextseq" anywhere run-procedure "MySeqForUtd".
        MySeqUtd = ?.
        run str/Mark_Collect.w (input parparentproc,
            input x_utd.doc-id,
            input x_utd.db-num,
            input {&lookup}
            )  .
        unsubscribe "getNextseq".
        
        reposition br-utd to rowid row_utd no-error .
    end.  
    else 
    do: 
        message "Не выбран документ"
            view-as alert-box.  
        return no-apply .
    end.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-utd
&Scoped-define SELF-NAME br-utd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-utd d-utd
ON entry OF br-utd IN FRAME d-utd
DO:
    /*  f-DocumentNumber = "" .                            */
    /*  display f-DocumentNumber with frame {&frame-name} .*/
    /*  run init-sort .                                    */
    /*  {&OPEN-QUERY-br-utd}                               */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-utd d-utd
ON mouse-select-dblclick OF br-utd IN FRAME d-utd
DO:
    if AVAILABLE (X_utd) then 
    do:         
        if v-obj-active or X_utd.sts = ObjSrv:Env:Utd:Sts:TH:NewStatus:KeyIntDB then 
        do: 
            apply "Choose" to b-update in frame {&frame-name}.
        end.
        else 
        do:
            apply "Choose" to b-utd in frame {&frame-name}.
        end.  
    end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-utd d-utd
ON ROW-DISPLAY OF br-utd IN FRAME d-utd
DO:
    if AVAILABLE (X_utd) then 
    do:      
        /*    if X_utd.sts-edi = ObjSrv:Env:Utd:Sts:EDI:HaveToCreateReceipt:KeyIntDB or      */
        /*       X_utd.sts-edi = ObjSrv:Env:Utd:Sts:EDI:RequestsMyRevocation:KeyIntDB or     */
        /*       X_utd.sts-edi = ObjSrv:Env:Utd:Sts:EDI:WaitingForRecipientSignature:KeyIntDB*/
        /*    then do:                                                                       */
        /*          X_utd.DocumentNumber:fGCOLOR in browse br-utd = CYAN_COLOR.              */
        /*          X_utd.EDoTypeName:fGCOLOR in browse br-utd = CYAN_COLOR.                 */
        /*          X_utd.DocumentDate:fGCOLOR in browse br-utd = CYAN_COLOR.                */
        /*          X_utd.cli-code:fGCOLOR in browse br-utd = CYAN_COLOR.                    */
        /*          X_utd.cli-name:fGCOLOR in browse br-utd = CYAN_COLOR.                    */
        /*          X_utd.total:fGCOLOR in browse br-utd = CYAN_COLOR.                       */
        /*          X_utd.vat:fGCOLOR in browse br-utd = CYAN_COLOR.                         */
        /*          X_utd.stts:fGCOLOR in browse br-utd = CYAN_COLOR.                        */
        /*          X_utd.stts-edi:fGCOLOR in browse br-utd = CYAN_COLOR.                    */
        /*          X_utd.ModifyTime_:fGCOLOR in browse br-utd = CYAN_COLOR.                 */
        /*          X_utd.doc-code:fGCOLOR in browse br-utd = CYAN_COLOR.                    */
        /*          X_utd.orig-code:fGCOLOR in browse br-utd = CYAN_COLOR.                   */
        /*          X_utd.LoadDate:fGCOLOR in browse br-utd = CYAN_COLOR.                    */
        /*          X_utd.DocumentExt:fGCOLOR in browse br-utd = CYAN_COLOR.                 */
        /*          X_utd.doc-id:fGCOLOR in browse br-utd = CYAN_COLOR.                      */
        /*    end.                                                                           */
        if X_utd.GrayZone then 
        do:
            X_utd.DocumentNumber:bGCOLOR in browse br-utd = GRAY_COLOR.
        end.  
    end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-utd d-utd
ON value-changed OF br-utd IN FRAME d-utd
DO:
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-date-from
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-date-from d-utd
ON RETURN OF F-date-from IN FRAME d-utd
DO:
    apply "TAB":U to self .
    return no-apply .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-date-from d-utd
ON TAB OF F-date-from IN FRAME d-utd
DO:
    if string(F-date-from) <> F-date-from:screen-value then 
    do:
        assign F-date-from .
    end.
    if F-date-from < F-date-to then 
    do:
        message "Дата начала не может быть больше конечной даты"
            view-as alert-box.
        return no-apply .       
    end.
    run init-sort .
    {&OPEN-QUERY-br-utd}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME F-date-to
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-date-to d-utd
ON RETURN OF F-date-to IN FRAME d-utd /* За период с */
DO:
    apply "TAB":U to self .
    return no-apply .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-date-to d-utd
ON TAB OF F-date-to IN FRAME d-utd /* За период с */
DO:
    if string(F-date-from) <> F-date-from:screen-value then 
    do:
        assign F-date-to .
    end.
    if F-date-from < F-date-to then 
    do:
        message "Дата начала не может быть больше конечной даты"
            view-as alert-box.
        return no-apply .       
    end.
    run init-sort .
    {&OPEN-QUERY-br-utd}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-DocumentNumber
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-DocumentNumber d-utd
ON value-changed OF f-DocumentNumber IN FRAME d-utd /* Номер документа */
DO:
    assign f-DocumentNumber .
    run init-sort .
    {&OPEN-QUERY-br-utd}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-1 d-utd
ON value-changed OF RADIO-SET-1 IN FRAME d-utd
DO:
    assign RADIO-SET-1 .
    run init-sort .
    {&OPEN-QUERY-br-utd}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-2 d-utd
ON value-changed OF RADIO-SET-2 IN FRAME d-utd
DO:
    assign RADIO-SET-2 .
    run init-sort .
    {&OPEN-QUERY-br-utd}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK d-utd 


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
    { gbl/brwrepos.i
      &line-num= 9
    }

    
    { gbl/ed_date.i f-date-from }
    { gbl/ed_date.i f-date-to }

/*    run uf-get (                        */
/*        input {&uf-UPD}                 */
/*        , input  v-cntxt-userid         */
/*        , output v-current-sertif-string*/
/*        , output v-current-sort-string  */
/*        , output v-void-logical         */
/*        , output v-void-logical         */
/*        , output v-void-logical         */
/*        , output v-void-logical         */
/*        ) no-error.                     */
        
    Marking = ObjSrv:Env:Marking:Sts:Mark.

    { gbl/conf-rd.i
        "'is-erpRN'"
          0
          "''"
          0
          "''"
          "''"
          "''"
          NO
          conf-par
          par-type
          no-error
          }
    if not error-status:error and conf-par = "yes":U then mode-erprn = yes.
    else mode-erprn = no.

    StatusTH = ObjSrv:Env:Utd:Sts:TH.
    EdocType = ObjSrv:Env:Utd:EDocType.      

    F-date-to = today - 30.
    F-date-from = today .

    run init-temp in this-procedure .
    { gbl/diasize.i }
    run diasize_init in this-procedure .
    run enable_UI in this-procedure .
    apply "value-changed" to br-utd IN FRAME {&frame-name}.
    WAIT-FOR GO OF FRAME {&FRAME-NAME} .
END.
run disable_UI in this-procedure .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI d-utd  _DEFAULT-DISABLE
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
  HIDE FRAME d-utd.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI d-utd 
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
    if p-mode = "" then 
    do:
        ENABLE
            br-utd
            b-exit
            b-update
            b-utd
            b-hist
            b-del
            b-refresh
            RADIO-SET-1
            F-date-from
            F-date-to
            f-DocumentNumber
            radio-set-2
            WITH FRAME {&frame-name}.
        display
            F-date-from
            F-date-to
            with frame {&frame-name} .
        if v-obj-active then enable b-add with frame {&frame-name} .    
    end.
/*    if p-mode = {&select} then                          */
/*    do:                                                 */
/*        ENABLE                                          */
/*            b-inout                                     */
/*            b-mark                                      */
/*            bt-not-sel-all                              */
/*            b-sel                                       */
/*            br-utd                                      */
/*            b-exit                                      */
/*            b-utd                                       */
/*            bt-not-sel-desel-all                        */
/*            R-obj                                       */
/*            radio-set-2                                 */
/*            c-status                                    */
/*            c-status-edi                                */
/*            RADIO-SET-1                                 */
/*            c-type                                      */
/*            F-date-from                                 */
/*            F-date-to                                   */
/*            f-DocumentNumber                            */
/*            f-mark                                      */
/*            WITH FRAME {&frame-name}.                   */
/*        display     F-date-from                         */
/*            b-inout                                     */
/*            F-date-to                                   */
/*            with frame {&frame-name} .                  */
/*        disable                                         */
/*            b-hist                                      */
/*            b-del                                       */
/*            b-refresh                                   */
/*            B-write-Token                               */
/*            b_anul                                      */
/*            B-write-cancel                              */
/*            b_oneUtd                                    */
/*            B-write-sertif                              */
/*            F-sertif                                    */
/*            mark-num                                    */
/*            b-choose-sertif                             */
/*            f-mark                                      */
/*            with frame {&frame-name} .                  */
/*        hide b-update b_cl_mark in frame {&Frame-name} .*/
/*    end.                                                */
  
  if mode-erprn then 
  do:
    browse br-utd:GET-BROWSE-COLUMN(11):VISIBLE = no no-error.
  end.  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-id d-utd 
PROCEDURE init-id :
/* --------------------------------------------------------------------
                        Purpose:     ENABLE the User Interface
                        Parameters:  <none>
                        Notes:       Here we display/view/enable the widgets in the
                                     user-interface.  In addition, OPEN all queries
                                     associated with each FRAME and BROWSE.
                                     These statements here are based on the "Other
                                     Settings" section of the widget Property Sheets.
                         -------------------------------------------------------------------- */
    define input parameter p-doc-id as integer no-undo .
    define input parameter p-db-num as integer no-undo .
    define buffer buf_utd-lines         for ub.utd-lines .
    define buffer buf_utd-marking-lines for ub.utd-marking-lines .
    define buffer buf_gds-obj           for ub.gds-obj .
    define buffer buf_utd-attr          for ub.utd-attr .
    define variable vGtin               as character no-undo .
    define variable vGtinQnty           as decimal no-undo .

    find first X_utd exclusive-lock where X_utd.doc-id = p-doc-id and X_utd.db-num = p-db-num no-error .
    if available (X_utd) then 
    do: 
        X_utd.GrayZone = no .
        for first buf_utd no-lock where buf_utd.doc-id = p-doc-id
                                    and buf_utd.db-num = p-db-num
        :
          assign
            X_utd.sts = buf_utd.sts 
            X_utd.stts = StatusTHName(buf_utd.sts)
            X_utd.doc-code = buf_utd.doc-code
            X_utd.DocumentDate = buf_utd.DocumentDate
            X_utd.scan-qnty = 0
            X_utd.free-qnty = 0
          .
          find first buf_utd-attr no-lock where buf_utd-attr.db-num = X_utd.db-num
                                            and buf_utd-attr.doc-id = X_utd.doc-id
                                            and buf_utd-attr.attr-code = "is-initial-set"
                                            no-error .
          if available buf_utd-attr
          and logical(buf_utd-attr.attr-value)
          then do :
            X_utd.is-initial = "Да" .
          end .
          else do :
            X_utd.is-initial = "Нет" .
          end .
          for each buf_utd-lines no-lock where buf_utd-lines.db-num = buf_utd.db-num 
                                           and buf_utd-lines.doc-id = buf_utd.doc-id
          :
            for each buf_utd-marking-lines no-lock where buf_utd-marking-lines.db-num = buf_utd-lines.db-num 
                                                     and buf_utd-marking-lines.doc-id = buf_utd-lines.doc-id
                                                     and buf_utd-marking-lines.LineNum = buf_utd-lines.LineNum
                                                     and buf_utd-marking-lines.doc-level = 1
                                                     and buf_utd-marking-lines.site <> "only-send"
            :
              vGtin = getGtinByDM(buf_utd-marking-lines.mark) .
              vGtinQnty = getQntyCodeByGtin(vGtin) .
              X_utd.scan-qnty = X_utd.scan-qnty + vGtinQnty .
            end .
            if buf_utd.sts = ObjSrv:Env:Utd:Sts:TH:Confirmed:KeyIntDB
            then do :
              for first buf_utd-lines-attr no-lock where buf_utd-lines-attr.doc-id = buf_utd-lines.doc-id
                                                     and buf_utd-lines-attr.db-num = buf_utd-lines.db-num
                                                     and buf_utd-lines-attr.LineNum = buf_utd-lines.LineNum 
                                                     and buf_utd-lines-attr.attr-code = "comfimed-free-qnty"
              :
                X_utd.free-qnty = X_utd.free-qnty + decimal(buf_utd-lines-attr.attr-value) .
              end .
            end .
            else do :
              for first buf_gds-obj no-lock where buf_gds-obj.obj-type = buf_utd.obj-type
                                              and buf_gds-obj.obj-code = buf_utd.obj-code
                                              and buf_gds-obj.gds-code = buf_utd-lines.gds-code
              :
                X_utd.free-qnty = X_utd.free-qnty + buf_gds-obj.free-qnty .
              end .
            end .
          end .                                         
        end.
    end.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-sort d-utd 
PROCEDURE init-sort :
/* --------------------------------------------------------------------
                        Purpose:     ENABLE the User Interface
                        Parameters:  <none>
                        Notes:       Here we display/view/enable the widgets in the
                                     user-interface.  In addition, OPEN all queries
                                     associated with each FRAME and BROWSE.
                                     These statements here are based on the "Other
                                     Settings" section of the widget Property Sheets.
                         -------------------------------------------------------------------- */

    define variable p-ok    as logical no-undo .
    define variable v-days  as integer no-undo .
    define variable v-days1 as integer no-undo .
    define variable v-days2 as integer no-undo .
    if AVAILABLE (X_utd) then empty temp-table X_utd .
  
    define variable mQuery as handle    no-undo.
    define variable vqry   as character no-undo.
    create query mQuery.
    mQuery:set-buffers(buffer buf_utd:HANDLE).
    
    define variable vGdsCode  as integer   no-undo.
    define variable vGtin     as character no-undo.
    define variable vGtinQnty as decimal   no-undo.
    define variable vMark     as character no-undo.
    define variable vMarkGtin as character no-undo.
    define variable vInt      as logical   no-undo.
    define variable vi        as integer   no-undo.
    
    define buffer buf_utd-attr          for ub.utd-attr .
    define buffer buf_utd-lines         for ub.utd-lines .
    define buffer buf_utd-marking-lines for ub.utd-marking-lines .
    define buffer buf_gds-obj           for ub.gds-obj .
    
    assign
       vGdsCode = 0
       vGtin    = ""
       vMark    = ""
    .
    vqry = substitute("FOR EACH buf_utd where buf_utd.EDocType = &1 and buf_utd.DocumentDate >= &2 and buf_utd.DocumentDate <= &3 no-lock" , EdocType:Mark_Collect:KeyIntDB,f-date-to,f-date-from).
    
    mQuery:query-prepare(vqry).
    mQuery:query-open ().
    mQuery:get-first ().
                                                                         
    do while not mQuery:query-off-end:
        create X_utd .
        buffer-copy buf_utd to X_utd . 
        X_utd.stts = StatusTHName(X_utd.sts).
        X_utd.cli-name = CliName(X_utd.cli-code, X_utd.cli-type).
        X_utd.EdoTypeName = EdoTypeName(X_utd.EDocType).
        X_utd.GrayZone = no .
        X_utd.obj-name = buf_utd.obj-type + " " + string(buf_utd.obj-code) .
        find first buf_utd-attr no-lock where buf_utd-attr.db-num = X_utd.db-num
                                          and buf_utd-attr.doc-id = X_utd.doc-id
                                          and buf_utd-attr.attr-code = "is-initial-set"
                                          no-error .
        if available buf_utd-attr
        and logical(buf_utd-attr.attr-value)
        then do :
          X_utd.is-initial = "Да" .
        end .
        else do :
          X_utd.is-initial = "Нет" .
        end .
        for each buf_utd-lines no-lock where buf_utd-lines.db-num = buf_utd.db-num 
                                         and buf_utd-lines.doc-id = buf_utd.doc-id
        :
          for each buf_utd-marking-lines no-lock where buf_utd-marking-lines.db-num = buf_utd-lines.db-num 
                                                   and buf_utd-marking-lines.doc-id = buf_utd-lines.doc-id
                                                   and buf_utd-marking-lines.LineNum = buf_utd-lines.LineNum
                                                   and buf_utd-marking-lines.doc-level = 1
                                                   and buf_utd-marking-lines.site <> "only-send"
          :
            vGtin = getGtinByDM(buf_utd-marking-lines.mark) .
            vGtinQnty = getQntyCodeByGtin(vGtin) .
            X_utd.scan-qnty = X_utd.scan-qnty + vGtinQnty .
          end .
          if buf_utd.sts = ObjSrv:Env:Utd:Sts:TH:Confirmed:KeyIntDB
          then do :
            for first buf_utd-lines-attr no-lock where buf_utd-lines-attr.doc-id = buf_utd-lines.doc-id
                                                   and buf_utd-lines-attr.db-num = buf_utd-lines.db-num
                                                   and buf_utd-lines-attr.LineNum = buf_utd-lines.LineNum 
                                                   and buf_utd-lines-attr.attr-code = "comfimed-free-qnty"
            :
              X_utd.free-qnty = X_utd.free-qnty + decimal(buf_utd-lines-attr.attr-value) .
            end .
          end .
          else do :
            for first buf_gds-obj no-lock where buf_gds-obj.obj-type = buf_utd.obj-type
                                            and buf_gds-obj.obj-code = buf_utd.obj-code
                                            and buf_gds-obj.gds-code = buf_utd-lines.gds-code
            :
              X_utd.free-qnty = X_utd.free-qnty + buf_gds-obj.free-qnty .
            end .
          end .
        end . 
        mQuery:get-next ().
    end.
    delete object mQuery.
    case RADIO-SET-1:
      when 1
      then do:
        for each X_utd where X_utd.sts = ObjSrv:Env:Utd:Sts:TH:NewStatus:KeyIntDB :
          delete X_utd .
        end.  
      end.  
      when 2
      then do:
        for each X_utd where X_utd.sts = ObjSrv:Env:Utd:Sts:TH:Confirmed:KeyIntDB:
          delete X_utd .
        end.  
      end.  
    end case.
    case RADIO-SET-2:
      when 1
      then do:
        for each X_utd where X_utd.is-initial = "Да" :
          delete X_utd .
        end.  
      end.  
      when 2
      then do:
        for each X_utd where X_utd.is-initial = "Нет" :
          delete X_utd .
        end. 
      end.  
    end case.  
    if f-DocumentNumber <> ""
    then do:
      for each X_utd :
        if X_utd.DocumentNumber begins f-DocumentNumber
        then next.
        delete X_utd .
      end.
    end.  
    apply "value-changed" to br-utd IN FRAME {&frame-name}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-temp d-utd 
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
    RADIO-SET-1 = 2 .  
    radio-set-1:screen-value in frame {&frame-name} = "2" .
    run init-sort .
    {&OPEN-QUERY-br-utd}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CliName d-utd 
FUNCTION CliName RETURNS CHARACTER
    (input p-cli-code as integer, input p-cli-type as character) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/
    define variable v-cli-name as character no-undo .
    find first buf_clients no-lock where buf_clients.obj-code = p-cli-code
        and buf_clients.obj-type = p-cli-type no-error .
    if available (buf_clients) then v-cli-name = buf_clients.obj-name .
    RETURN v-cli-name.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION EdoTypeName d-utd 
FUNCTION EdoTypeName RETURNS CHARACTER
    ( input p-stsTH as integer ) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/

    RETURN EdocType:GetLabel(p-stsTH) .   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION StatusTHName d-utd 
FUNCTION StatusTHName RETURNS CHARACTER
    ( input p-stsTH as integer ) :
    /*------------------------------------------------------------------------------
      Purpose:  
        Notes:  
    ------------------------------------------------------------------------------*/

    RETURN StatusTH:GetLabel(p-stsTH) .   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

