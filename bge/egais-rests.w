&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*------------------------------------------------------------------------

  File: bge/egais-goods.w

  Description: Настройки объектов ЕГАИС

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Slivenko Sergey

  Created: 16.11.2015
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

using ibs.th.bge.egais.*.

/* Parameters Definitions ---                                           */

define input parameter parparentproc as widget-handle no-undo .

/* Local Variable Definitions ---                                       */

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Настройки объектов ЕГАИС".

{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ str/lib-trn.i  }
{ cmp/showinf.i  }
{ gbl/getcntxt.i def }
{ gbl/getcntxt.i get }
{ gbl/thbjattr.i }
{ gbl/clntattr.i }
{ gbl/color.i    }
{ ref/extclass.i }
{ gbl/key-rec.i  }
{ gbl/attr-lib.i }
{ ref/gds-attr.i }

define temp-table tt-gds-rests no-undo
    field gds-code          like ub.goods.gds-code          label "Код товара в TH"
    field gds-name          like ub.goods.gds-name          label "Наименование товара" format "X(100)"
    field alc-code          as character                    label "Алкогольный код"     format "X(21)"
    field ms-base           like ub.goods.ms-base           label "Объем"               format ">>9.9<<"
    field alc-type-code     like ub.alc-type.alc-type-code  label "Код АП"
    field proof             like ub.goods.proof             label "Крепость"            format ">9.9"    
    field fromEgais         as logical
    field egais-name        as character                    label "Наименование ЕГАИС"  format "X(100)"
    field egais-qnty        as integer                      label "Остаток ЕГАИС"
    field informA_          as character                    label "ID справки А"        format "X(30)"
    field informB_          as character                    label "ID справки Б"        format "X(30)"
    field TH-qnty           as integer                      label "Остаток TH"   
    field prt-rec           as character       
    index pi as primary
        gds-code
    index name_ as word-index
        gds-name
    index alc
        alc-code    
.    

define buffer old_tt-gds-rests for tt-gds-rests .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

def var egais as class EGAIS.

def var bh-gds-egais as handle no-undo .
def var qh-gds-egais as handle no-undo .


define buffer buf_firm for ub.firm .
define buffer buf_clients for ub.clients .
define buffer buf_clients-attr for ub.clients-attr .
define buffer buf_goods for ub.goods .
define buffer buf_goods-attr for ub.goods-attr .
define buffer buf_parts for ub.parts .
DEFINE BUFFER X_ext-classif FOR ub.ext-classif.

define variable select-list as character no-undo .
define variable ref-list    as character no-undo .
define variable ii          as integer   no-undo .
define variable jj          as integer   no-undo .
define variable v-rid       as recid     no-undo .
define variable v-prt-rec   as recid     no-undo .
define variable par-alcohol as character no-undo .
define variable par-egais-name as character no-undo .
define variable par-type    as character no-undo .
define variable v-kpp       as character no-undo .
define variable v-org-inn   as character no-undo .
define variable v-isSent    as logical   no-undo .
define variable v-outId     as character no-undo .
define variable v-ext-sys   as integer   no-undo .
define variable v-replyId   as character no-undo .
define variable v-alc-code  as character no-undo .

define variable glog        as logical no-undo .

define variable v-gds-uniq-key-rec as character no-undo .

define variable saved as logical no-undo initial no .

define variable gds-rec as recid no-undo .
define variable tt-rec as recid no-undo .

define variable v-value-character  as character no-undo .
define variable v-value-decimal    as decimal   no-undo .
define variable v-value-integer    as integer   no-undo .
define variable v-value-logical    as logical   no-undo .
define variable v-value-type       as character no-undo .
define variable v-value-date       as date      no-undo .

define variable v-org as character no-undo .
define variable v-fs-rar as character no-undo .

define variable bh-act-header  as handle no-undo .
{ibs/th/bge/egais/awo-egais.i proc }

FUNCTION get-mark RETURNS CHARACTER
(buffer local-gds for tt-gds-rests ):
if lookup (string (recid (local-gds)), select-list) > 0  then return "*".
                                                           else return "".
end function.



&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME br-rests

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-objs

/* Definitions for BROWSE br-goods                                    */
&Scoped-define SELF-NAME br-goods
&Scoped-define QUERY-STRING-br-goods FOR EACH tt-gds-rest
&Scoped-define OPEN-QUERY-br-goods OPEN QUERY {&SELF-NAME} FOR EACH tt-gds-rests.
&Scoped-define TABLES-IN-QUERY-br-goods tt-gds-rests
&Scoped-define FIRST-TABLE-IN-QUERY-br-goods tt-gds-rests


/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Dialog-Frame ~
    ~{&OPEN-QUERY-br-goods}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-load b-cancel br-goods 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */

/*define variable v-prod as character no-undo view-as text format "X(11)" label "Производитель" .*/
/*define variable v-prod-name as character no-undo view-as text format "X(30)" .                 */

define menu m-func
    menu-item m-writeOff label "Сформировать акт о списании"
.    

DEFINE BUTTON b-mark 
     LABEL "&*" 
     SIZE 3 BY 1.14 .
     
DEFINE BUTTON b-cancel AUTO-END-KEY 
     LABEL "Выход" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON b-load 
     LABEL "Запрос" 
     tooltip "Отправить запрос в ЕГАИС"
     SIZE 15 BY 1.14
     BGCOLOR 8 .
     
DEFINE BUTTON b-save 
     LABEL "Сохранить" 
     tooltip "Записать данные о справках A/B в партию"
     SIZE 15 BY 1.14
     BGCOLOR 8 .
     
DEFINE BUTTON b-answer 
     LABEL "Получить ответ" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .   
     
     
DEFINE BUTTON b-del
     LABEL "Удалить связку"
     SIZE 15 BY 1.14
     BGCOLOR 8 .
     
DEFINE BUTTON b-connect 
     LABEL "Связать" 
     SIZE 15 BY 1.14
     BGCOLOR 8 . 
     
DEFINE BUTTON b-func 
     LABEL "Функции" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .      
     
DEFINE BUTTON b-sel-all
     LABEL "&+":L
     SIZE 3 BY 1.14 TOOLTIP "Отметить все объекты".

DEFINE BUTTON b-unmark
     LABEL "&-":L
     SIZE 3 BY 1.14 TOOLTIP "Снять все отметки". 

Define variable NameContext as character view-as fill-in size 30 by 1 fgcolor 12 no-undo.
define variable loc-alc  as character view-as fill-in size 25 by 1 fgcolor 12 no-undo format "x(25)":U.
define variable loc-code as character view-as fill-in size 20 by 1 fgcolor 12 no-undo. 

define variable a-n-c as character view-as radio-set horizontal radio-buttons
"Алк. Код","alc",
"Нач.слова","context",
"Код TH","code"
size 30 by 1    fgcolor 0 /* bgcolor 8 */ no-undo.    

     
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-rests FOR 
      tt-gds-rests SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-rests
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-rests Dialog-Frame _FREEFORM
  QUERY br-rests  DISPLAY
    get-mark(BUFFER tt-gds-rests) COLUMN-LABEL "*"  FORMAT "X(1)":U
    tt-gds-rests.alc-code COLUMN-LABEL "Алкогольный код" FORMAT "X(25)":U
    tt-gds-rests.gds-name COLUMN-LABEL "Наименование товара" FORMAT "X(100)":U width 39
    tt-gds-rests.gds-code COLUMN-LABEL "Код товара в TH" FORMAT ">>>>>>>>9"
/*    tt-gds-rests.ms-base  COLUMN-LABEL "Объем" FORMAT ">>9.9<<"*/
/*    tt-gds-rests.proof    COLUMN-LABEL "Крепость" FORMAT ">9.9"*/
    tt-gds-rests.alc-type-code COLUMN-LABEL "Код АП" FORMAT "X(4)":U
    tt-gds-rests.egais-qnty
    tt-gds-rests.informA_
    tt-gds-rests.informB_
    tt-gds-rests.TH-qnty
/*    tt-gds-rests.egais-name COLUMN-LABEL "Наименование в ЕГАИС" FORMAT "X(100)":U width 39*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 105 BY 20.2 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     b-mark AT ROW 2.5 COL 2
     b-sel-all AT ROW 2.5 COL 5
     b-unmark AT ROW 2.5 COL 8
     b-load AT ROW 1.24 COL 32
     b-answer AT ROW 1.24 COL 47
     b-save AT ROW 1.24 COL 17
     b-cancel AT ROW 1.24 COL 2
     v-fs-rar at row 2.7 col 17 label "ФСРАР ID"
     b-connect AT ROW 1.24 COL 62
     b-del at row 1.24 col 77 
     b-func at row 1.24 col 92 
     a-n-c at row 4 col 2 label "Поиск по"
     NameContext at row 4 col 50 label "Контекст"
     loc-alc at row 4 col 50 no-label
     loc-code at row 4 col 50 label "Код(весь)"
     br-rests AT ROW 5.3 COL 2 WIDGET-ID 200
     SPACE(1) SKIP(0.32)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Остатки ЕГАИС"
         DEFAULT-BUTTON b-load CANCEL-BUTTON b-cancel WIDGET-ID 100.

assign br-rests:NUM-LOCKED-COLUMNS IN FRAME Dialog-Frame = 1 .

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
/* BROWSE-TAB br-goods b-cancel Dialog-Frame */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-goods
/* Query rebuild information for BROWSE br-goods
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-gds.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-goods */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

on F9 of frame {&frame-name} anywhere do:
  if not available tt-gds-rests then  return no-apply.
  if tt-gds-rests.gds-code = 0  then  return no-apply.
  find first goods no-lock where goods.gds-code = tt-gds-rests.gds-code .
  gds-rec = recid(goods) .
  run ref/gds-form.w
    (input  parParentProc
    ,input  {&lookup}
    ,input  v-cntxt-obj-type
    ,input  v-cntxt-obj-code
    ,input ? /*p-call-handle*/
    ,input-output gds-rec
    ).

/*  apply "entry" to spec-List in frame {&frame-name}.*/
/*  return no-apply.                                  */
end.

/*&Scoped-define SELF-NAME b-good                              */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-good Dialog-Frame*/
/*ON CHOOSE OF b-good IN FRAME Dialog-Frame /* * */            */
/*DO:                                                          */
/*    apply "F9" to frame Dialog-Frame .                       */
/*END.                                                         */
/*                                                             */
/*/* _UIB-CODE-BLOCK-END */                                    */
/*&ANALYZE-RESUME                                              */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Объекты ЕГАИС */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME a-n-c
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL a-n-c Dialog-Frame
ON value-changed OF a-n-c in FRAME Dialog-Frame /* Объекты ЕГАИС */
DO:
    assign a-n-c .
    assign NameContext = "" loc-code = "" loc-alc = "" loc-alc:screen-value = "" .
    case a-n-c :
        when "alc" then do :
            OPEN QUERY {&browse-name} FOR EACH tt-gds-rests .
            hide NameContext loc-code in frame Dialog-Frame .
            display loc-alc with frame Dialog-Frame .
            apply "entry" to br-rests in frame Dialog-Frame .
        end.
        when "context" then do :
            hide loc-alc loc-code in frame Dialog-Frame .
            enable NameContext with frame Dialog-Frame .
            apply "entry" to NameContext in frame Dialog-Frame .
        end.
        when "code" then do :
            OPEN QUERY {&browse-name} FOR EACH tt-gds-rests .
            hide loc-alc NameContext in frame Dialog-Frame .
            enable loc-code with frame Dialog-Frame .
            apply "entry" to loc-code in frame Dialog-Frame .
        end.
    end case.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME NameContext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NameContext Dialog-Frame
ON return OF NameContext IN FRAME {&frame-name} do:
    define variable letter as character no-undo .
    assign NameContext.
    if trim(NameContext) = "" then do :
        OPEN QUERY {&browse-name} FOR EACH tt-gds-rests .
    end.
    else do :
        letter = substring(NameContext, length(NameContext), 1) .
        if letter = 'н'
        or letter = 'о'
        or letter = 'э'
        or letter = 'ю'
        or letter = 'я'
        then do :
            OPEN QUERY {&browse-name} FOR EACH tt-gds-rests where tt-gds-rests.gds-name contains (trim(NameContext)) INDEXED-REPOSITION .
        end.
        else do :
            OPEN QUERY {&browse-name} FOR EACH tt-gds-rests where tt-gds-rests.gds-name contains (trim(NameContext) + "*") INDEXED-REPOSITION .
        end.
    end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME loc-code
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL loc-code Dialog-Frame
ON return OF loc-code IN FRAME {&frame-name} do:
    assign loc-code.
    find first tt-gds-rests no-lock where tt-gds-rests.gds-code = integer(loc-code) no-error.
    if not available tt-gds-rests then do :
        message "Не найден товар с кодом " + loc-code view-as alert-box warning .
    end.
    else do :
        assign tt-rec = recid(tt-gds-rests) .
        reposition br-rests to recid tt-rec .
    end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME br-rests
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-rests Dialog-Frame
ON any-printable OF br-rests IN FRAME {&frame-name} do:
    if input frame {&frame-name} a-n-c = "alc" then do:
        if last-event:label = " " and
           loc-alc = "" then
        return no-apply.
        find first tt-gds-rests no-lock where tt-gds-rests.alc-code begins (loc-alc + last-event:label) no-error.
        if available tt-gds-rests then do :
            loc-alc = loc-alc + last-event:label.
            disp loc-alc with frame {&frame-name}.
            assign tt-rec = recid(tt-gds-rests) .
            reposition br-rests to recid tt-rec .
        end.
        else bell.
    end.
end.

ON backspace OF br-rests IN FRAME {&frame-name} do:
    if input frame {&frame-name} a-n-c = "alc" then do:
        if loc-alc = "" then
          return no-apply.
        loc-alc = substr (loc-alc, 1, length (loc-alc) - 1).
        find first tt-gds-rests no-lock where tt-gds-rests.alc-code begins loc-alc no-error.
        if available tt-gds-rests then do :
            disp loc-alc with frame {&frame-name}.
            assign tt-rec = recid(tt-gds-rests) .
            reposition br-rests to recid tt-rec .
        end.
    end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-mark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-mark Dialog-Frame
ON CHOOSE OF b-mark IN FRAME Dialog-Frame /* * */
DO:
/*  {&stdbtn}*/
  run proc-b-mark in this-procedure no-error.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-sel-all
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-sel-all Dialog-Frame
ON CHOOSE OF b-sel-all IN FRAME Dialog-Frame /* + */
DO:
  assign select-list = "".
  if not available tt-gds-rests then return.
  for each tt-gds-rests no-lock :
    { gbl/markstrn.i tt-gds-rests select-list }
  end.
  {&browse-name}:refresh() in frame {&frame-name} .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-unmark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-unmark Dialog-Frame
ON CHOOSE OF b-unmark IN FRAME Dialog-Frame /* - */
DO:
  if not available tt-gds-rests then return.
  select-list  = "".
  {&browse-name}:refresh() in frame {&frame-name} .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-cancel Dialog-Frame
ON CHOOSE OF b-cancel IN FRAME Dialog-Frame /* - */
DO:
    message "Все несохранённые данные будут потеряны. Вы уверены, что хотите выйти?"
    view-as alert-box question buttons yes-no update glog.
    if not glog then return no-apply . 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&Scoped-define SELF-NAME b-connect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-connect Dialog-Frame
ON CHOOSE OF b-connect IN FRAME Dialog-Frame /* - */
DO:
    if not available tt-gds-rests then return no-apply.
    if tt-gds-rests.gds-code = 0 or tt-gds-rests.gds-code = ? then do :
        message "Данный товар не синхронизирован с ЕГАИС" view-as alert-box .
        return no-apply .
    end.
    assign v-rid = recid(tt-gds-rests) .
    run str/parts-l.w
     (
        input parparentproc
     ,  input v-cntxt-obj-type                /* v-obj-type   */
     ,  input v-cntxt-obj-code                /* v-obj-code   */
     ,  input tt-gds-rests.gds-code      /* p-gds-code   */
     ,  input "":U                      /* p-doc-code   */
     ,  input {&lookup}                 /* p-edit-mode  */
     ,  input {&parts-l_parts-free}     /* p-r-parts    */
     ,  input {&parts-l_object-current} /* p-one-all    */
     ,  input {&choose}                 /* p-call-point */
     , output v-prt-rec                   /* part-recid   */
     ) .
    for first buf_parts no-lock where recid(buf_parts) = v-prt-rec :
        if not can-do(tt-gds-rests.prt-rec,string(recid(buf_parts))) then
        assign
            tt-gds-rests.prt-rec = if tt-gds-rests.prt-rec = "" then string(recid(buf_parts)) else tt-gds-rests.prt-rec + ',' + string(recid(buf_parts))
            tt-gds-rests.TH-qnty = tt-gds-rests.TH-qnty + buf_parts.fact-qnty
        .
    end.
    OPEN QUERY {&browse-name} FOR EACH tt-gds-rests .
    reposition br-rests to recid v-rid .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-save
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-save Dialog-Frame
ON CHOOSE OF b-save IN FRAME Dialog-Frame /* - */
DO:
    if select-list = "" then do :
        message "Не выбрано ни одной строки" view-as alert-box .
        return no-apply.
    end.
    do ii = 1 to num-entries(select-list) :
        for first tt-gds-rests exclusive-lock where recid(tt-gds-rests) = integer(entry(ii, select-list))
                                                and tt-gds-rests.gds-code > 0
                                                and tt-gds-rests.prt-rec <> ? :
            do jj = 1 to num-entries(tt-gds-rests.prt-rec) :                                        
                for first parts no-lock where recid(parts) = integer(entry(jj,tt-gds-rests.prt-rec)) :                                        
                    run trg/partps.p ( input tt-gds-rests.gds-code
                                   , input parts.in-code
                                   , input {&free-code}
                                   , input parts.part-code
                                   , input v-cntxt-db-num-obj
                                   , input parts.mark-code
                                   , input parts.alc-bottling-date
                                   , input tt-gds-rests.informA_ + ',' + tt-gds-rests.informB_ + ',' + tt-gds-rests.alc-code + ',' + tt-gds-rests.alc-type-code
                                   , input parts.alc-quality-certif-path
                                   , input parts.alc-certif-path
                                   , input parts.alc-imp-type
                                   , input parts.alc-imp-code
                                   ) no-error .  
                end. 
            end.                                
        end. /* for first tt-gds-rests */
    end. /* do ii = 1 to num-entries(select-list) */
    message "Сохранение завершено" view-as alert-box.
    br-rests:refresh () .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-del Dialog-Frame
ON CHOOSE OF b-del IN FRAME Dialog-Frame /* - */
DO:
    if not available tt-gds-rests then return no-apply.
    message "Вы уверены?"
    view-as alert-box question buttons yes-no update glog.
    if not glog then return no-apply .
    do jj = 1 to num-entries(tt-gds-rests.prt-rec) :                                        
        for first parts no-lock where recid(parts) = integer(entry(jj,tt-gds-rests.prt-rec)) :                                        
            run trg/partps.p ( input tt-gds-rests.gds-code
                           , input parts.in-code
                           , input {&free-code}
                           , input parts.part-code
                           , input v-cntxt-db-num-obj
                           , input parts.mark-code
                           , input parts.alc-bottling-date
                           , input ""
                           , input parts.alc-quality-certif-path
                           , input parts.alc-certif-path
                           , input parts.alc-imp-type
                           , input parts.alc-imp-code
                           ) no-error .  
        end. 
    end.
    assign
        tt-gds-rests.prt-rec = ""
        tt-gds-rests.TH-qnty = 0
    .
    br-rests:refresh () .
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-load
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-load Dialog-Frame
ON CHOOSE OF b-load IN FRAME Dialog-Frame /* - */
DO:

    egais:SendRequestUTM() .
    glog = egais:IsSent .
    if glog then enable b-answer WITH FRAME Dialog-Frame.
    else disable b-answer WITH FRAME Dialog-Frame .
    glog = egais:StatusErr .
    if glog then do :
        message egais:Msg view-as alert-box.
        return no-apply.
    end.
    else do :
        v-replyId = egais:ReplyId.
    end.
        
/*    if not requestDictOrg:SendRequestUTM() then message requestDictOrg:Msg view-as alert-box.*/
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-answer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-answer Dialog-Frame
ON CHOOSE OF b-answer IN FRAME Dialog-Frame /* - */
DO:
    empty temp-table tt-gds-rests .
    bh-gds-egais = egais:GetHndlTable() .
    glog = egais:StatusErr .
    if glog then do :
        message egais:Msg view-as alert-box.
        return no-apply.
    end.
    if not valid-handle(bh-gds-egais) then do :
        message "Ошибка при получении ответа от ЕГАИС" view-as alert-box error .
        return no-apply .
    end.
    create query qh-gds-egais .
    qh-gds-egais:set-buffers (bh-gds-egais) .
    qh-gds-egais:query-prepare ("for each tt-gds-rests-eg").
    qh-gds-egais:query-open.
    _repeat:
    repeat:
        qh-gds-egais:get-next ().
        if qh-gds-egais:query-off-end then leave _repeat.
        create tt-gds-rests.
        buffer tt-gds-rests:handle:buffer-copy (bh-gds-egais) .
        assign tt-gds-rests.fromEgais = yes .
        find first X_ext-classif no-lock where X_ext-classif.classif-subject = {&table_goods} 
                                           and X_ext-classif.classif-name = {&extclass_goods_esys} 
                                           AND X_ext-classif.db-num = 0
                                           and X_ext-classif.key#_two = v-ext-sys
                                           and X_ext-classif.charkey_one = tt-gds-rests.alc-code
                                           no-error.
        if available X_ext-classif then do :
            find first buf_goods no-lock where buf_goods.gds-code = X_ext-classif.key#_one .
            assign
                tt-gds-rests.gds-code   = buf_goods.gds-code
                tt-gds-rests.gds-name   = buf_goods.gds-name
            .
        end.
        if available buf_goods then do :
            for each buf_parts no-lock where buf_parts.artic      = buf_goods.artic
                                           and buf_parts.prod-type  = buf_goods.prod-type
                                           and buf_parts.prod-code  = buf_goods.prod-code
                                           and buf_parts.out-code   = {&free-code}
                                           and entry(1, buf_parts.alc-ref-ab-path) = tt-gds-rests.informA_
                                           and entry(2, buf_parts.alc-ref-ab-path) = tt-gds-rests.informB_ :
                                           
                assign tt-gds-rests.TH-qnty = tt-gds-rests.TH-qnty + buf_parts.fact-qnty .
                assign tt-gds-rests.prt-rec = if tt-gds-rests.prt-rec = "" then string(recid(buf_parts)) else tt-gds-rests.prt-rec + ',' + string(recid(buf_parts)) .
            end.
        end. 
    end.
    OPEN QUERY {&browse-name} FOR EACH tt-gds-rests .
    apply "value-changed" to br-rests .
    enable a-n-c with FRAME {&FRAME-NAME}.
    apply "value-changed" to a-n-c in FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME m-writeOff
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m-witeOff Dialog-Frame
ON CHOOSE OF menu-item m-writeOff in menu m-func /* - */
DO:
    define variable v-awo-num as character no-undo .
    define variable v-awo-date as date no-undo .
    define variable v-awo-type as character no-undo .
    define variable v-ok as logical no-undo .
    define variable v-position as integer no-undo .
    define variable v-part-num    as integer   no-undo .
    define variable v-clob-db-num as integer   no-undo .
    define variable v-int64-id    as int64     no-undo .
    define variable v-info        as character no-undo .
    
    if select-list = "" then do :
        message "Не выбрано ни одной строки" view-as alert-box .
        return no-apply.
    end.  
    run bge/egais-makeWriteOff.w  (input parparentproc, 
                                   output v-awo-num,
                                   output v-awo-date,
                                   output v-awo-type,
                                   output v-ok) .
    if not v-ok then return no-apply .
    create tt-act-header.
    assign
        tt-act-header.num   = v-awo-num
        tt-act-header.date_ = v-awo-date
        tt-act-header.type_ = v-awo-type
        tt-act-header.is-sent = no
        v-position = 0
    .
    
    do ii = 1 to num-entries(select-list) :
        for first tt-gds-rests exclusive-lock where recid(tt-gds-rests) = integer(entry(ii, select-list)) :
            assign v-position = v-position + 1 .
            create tt-gds-act.
            assign
                tt-gds-act.num          = tt-act-header.num
                tt-gds-act.position_    = v-position
                tt-gds-act.alc-code     = tt-gds-rests.alc-code
                tt-gds-act.gds-code     = tt-gds-rests.gds-code
                tt-gds-act.gds-name     = tt-gds-rests.gds-name
                tt-gds-act.inform-B     = tt-gds-rests.informB_
                tt-gds-act.qnty         = tt-gds-rests.egais-qnty - tt-gds-rests.TH-qnty
            .  
        end.
    end.
    
    run makeXML in this-procedure .
    assign
        v-clob-db-num = ?
        v-int64-id = 0
        v-info = tt-act-header.num + {&delim-par} + string(tt-act-header.date_) + {&delim-par} + tt-act-header.type_ + {&delim-par} + string(tt-act-header.is-sent) + {&delim-par} + tt-act-header.answer_
    .
    run gbl/file2clb.p ( input {&add-def}
                          ,input ",no"
                          ,input ? /*p-bh*/
                          ,input tt-act-header.num /*p-uniq-key-rec*/
                          ,input {&lob-egais-awo} /*p-field-*/
                          ,input v-info /*p-descr*/
                          ,input-output v-part-num
                          ,input {&lob-egais-awo}
                          ,input-output v-clob-db-num
                          ,input-output v-int64-id
                          ,input search (v-file)
                          ,input '' /*p-src-encoding*/
                          ) no-error .
    message "Акт сформирован. Вы можете отправить его или изменить количества из интерфейса 'Акты о списании товаров'" view-as alert-box .                      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define BROWSE-NAME br-rests
&UNDEFINE SELF-NAME

/*on row-display of br-goods IN FRAME Dialog-Frame /* - */                                                                                                          */
/*DO:                                                                                                                                                               */
/*    if tt-gds.gds-code = 0 then tt-gds.gds-code:bgcolor in browse br-goods = yellow_color .                                                                       */
/*    if valid-handle(bh-gds-egais) then do :                                                                                                                       */
/*        if tt-gds.alc-code <> ? and tt-gds.alc-code <> "" then do :                                                                                               */
/*            bh-gds-egais:find-unique (substitute("where tt-gds-EG.alc-code = '&1'", tt-gds.alc-code), no-lock) no-error.                                          */
/*        end.                                                                                                                                                      */
/*        else do :                                                                                                                                                 */
/*            bh-gds-egais:find-unique (substitute("where tt-gds-EG.gds-name = '&1'", tt-gds.gds-name), no-lock) no-error.                                          */
/*        end.                                                                                                                                                      */
/*        if bh-gds-egais:available and not bh-gds-egais:ambiguous and not tt-gds.fromEgais then do :                                                               */
/*            if bh-gds-egais:buffer-field ("gds-name"):buffer-value <> tt-gds.gds-name then tt-gds.gds-name:bgcolor in browse br-goods = red_color .               */
/*            if bh-gds-egais:buffer-field ("ms-base"):buffer-value <> tt-gds.ms-base then tt-gds.ms-base:bgcolor in browse br-goods = red_color .                  */
/*            if bh-gds-egais:buffer-field ("proof"):buffer-value <> tt-gds.proof then tt-gds.proof:bgcolor in browse br-goods = red_color .                        */
/*            if bh-gds-egais:buffer-field ("alc-code"):buffer-value <> tt-gds.alc-code then tt-gds.alc-code:bgcolor in browse br-goods = red_color .               */
/*            if bh-gds-egais:buffer-field ("alc-type-code"):buffer-value <> tt-gds.alc-type-code then tt-gds.alc-type-code:bgcolor in browse br-goods = red_color .*/
/*        end.                                                                                                                                                      */
/*    end.                                                                                                                                                          */
/*end.                                                                                                                                                              */

on value-changed of br-rests IN FRAME Dialog-Frame /* - */
DO:
    if available tt-gds-rests then do :
        if trim(tt-gds-rests.prt-rec) = "" then disable b-del with frame {&FRAME-NAME} .
        else enable b-del with frame {&FRAME-NAME} .
    end.
    if not available tt-gds-rests or recid(tt-gds-rests) <> tt-rec then do :
        hide loc-alc in frame {&frame-name}.
        loc-alc = "".
    end.
end.

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
/*  { gbl/chk-actg.i          */
/*    v-cntxt-db-num          */
/*    v-cntxt-userid          */
/*    {&action-head-code-main}*/
/*    'actn_egais-ref':U      */
/*    {&cntxt-object}         */
/*    v-cntxt-host-code-obj   */
/*    v-cntxt-obj-type        */
/*    v-cntxt-obj-code        */
/*    0                       */
/*    0                       */
/*    0                       */
/*    true                    */
/*    glog                    */
/*  }                         */
/*  if not glog then  return .*/
/*  assign                    */
/*      rs-sort = 1           */
/*  .                         */

  assign
    b-func:popup-menu in frame {&FRAME-NAME} = menu m-func:handle
    b-func:menu-mouse = 1
  .

  find first buf_clients no-lock where buf_clients.obj-type = {&cmp} and buf_clients.obj-code = v-cntxt-host-code-obj.
  find first buf_firm no-lock where buf_firm.firm-code = v-cntxt-host-code-obj.
  if valid-handle(bh-gds-egais) then do :
      delete object bh-gds-egais .
  end.
  if valid-handle(qh-gds-egais) then do :
      delete object qh-gds-egais .
  end.
  empty temp-table thbjattr_thbj-attr .
  run adm/shattri.p (
       input "get":U
      ,input v-cntxt-obj-type
      ,input v-cntxt-obj-code
      ,input {&attr-egais-host}
      ,input {&attr-egais-host_egais-fsrar}
      ,output v-value-character
      ,output v-value-date
      ,output v-value-decimal
      ,output v-value-integer
      ,output v-value-logical
      ,output v-value-type
      ,INPUT-OUTPUT TABLE thbjattr_thbj-attr
      ) no-error .
  assign
    v-org = buf_clients.obj-name
    v-fs-rar = v-value-character
    v-org-inn = buf_firm.inn
  .
  egais = new EGAIS(v-cntxt-db-num, v-cntxt-userid).
  display v-fs-rar format "X(30)" with frame {&FRAME-NAME}.
  run adm/shattri.p (
       input "get":U
      ,input '':U
      ,input 0
      ,input {&attr-egais-host}
      ,input {&attr-egais-host_egais-exsys}
      ,output v-value-character
      ,output v-value-date
      ,output v-value-decimal
      ,output v-value-integer
      ,output v-value-logical
      ,output v-value-type
      ,INPUT-OUTPUT TABLE thbjattr_thbj-attr
      ) no-error .
  assign v-ext-sys = v-value-integer .
  release buf_clients .
  egais:EGAISImpl = new Rests(v-cntxt-obj-type, v-cntxt-obj-code, v-fs-rar, v-org-inn) .
/*  run fill-tt.*/
  { gbl/diasize.i &browse-name=br-rests }
  run diasize_init in this-procedure .
  RUN enable_UI.
  
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-b-mark Dialog-Frame
PROCEDURE proc-b-mark :
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
  define variable varlog as logical   no-undo .
  if not available tt-gds-rests then return.
  run local-mark in this-procedure.
  assign varlog = {&browse-name} :select-next-row( ) in frame {&frame-name}.
  apply "ENTRY":U to {&browse-name} in frame {&frame-name}.
  {&browse-name}:refresh() in frame {&frame-name} .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-mark Dialog-Frame
PROCEDURE local-mark :
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
  if not available tt-gds-rests then do:
    message "Неправильный выбор строки.".
    return no-apply.
  end.
  { gbl/markstrn.i tt-gds-rests select-list }
  {&browse-name}:refresh() in frame {&frame-name} .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
    
  ENABLE b-mark b-sel-all b-unmark b-load b-save b-cancel br-rests  b-connect b-del b-func
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  hide NameContext loc-alc loc-code in FRAME Dialog-Frame.
  br-rests:column-resizable in FRAME Dialog-Frame = true .
  glog = egais:IsSent .
  if glog then enable b-answer WITH FRAME Dialog-Frame.
/*  if egais:IsSent then enable b-answer WITH FRAME Dialog-Frame.*/
/*  else disable b-answer WITH FRAME Dialog-Frame .              */
  OPEN QUERY {&browse-name} FOR EACH tt-gds-rests .
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

