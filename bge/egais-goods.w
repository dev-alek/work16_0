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

define temp-table tt-gds no-undo
    field gds-code          like ub.goods.gds-code          label "Код товара в TH"
    field gds-name          like ub.goods.gds-name          label "Полное наименование" format "X(100)"
    field alc-code          as character                    label "Алкогольный код"
    field ms-base           like ub.goods.ms-base           label "Объем"               format ">>9.9<<"
    field alc-type-code     like ub.alc-type.alc-type-code  label "Код АП"
    field proof             like ub.goods.proof             label "Крепость"            format ">9.9"
    field fromEgais         as logical
    index pi as primary
        gds-code
    index name_
        gds-name
    index alc
        alc-code    
.    

define buffer old_tt-gds for tt-gds .

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
DEFINE BUFFER X_ext-classif FOR ub.ext-classif.

define variable select-list as character no-undo .
define variable ref-list    as character no-undo .
define variable ii          as integer   no-undo .
define variable v-rid       as recid     no-undo .
define variable par-alcohol as character no-undo .
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

define variable v-value-character  as character no-undo .
define variable v-value-decimal    as decimal   no-undo .
define variable v-value-integer    as integer   no-undo .
define variable v-value-logical    as logical   no-undo .
define variable v-value-type       as character no-undo .
define variable v-value-date       as date      no-undo .

define variable v-org as character no-undo .
define variable v-fs-rar as character no-undo .

FUNCTION get-mark RETURNS CHARACTER
(buffer local-gds for tt-gds ):
if lookup (string (recid (local-gds)), select-list) > 0  then return "*".
                                                           else return "".
end function.



&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME br-goods

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-objs

/* Definitions for BROWSE br-goods                                    */
&Scoped-define SELF-NAME br-goods
&Scoped-define QUERY-STRING-br-goods FOR EACH tt-gds
&Scoped-define OPEN-QUERY-br-goods OPEN QUERY {&SELF-NAME} FOR EACH tt-gds.
&Scoped-define TABLES-IN-QUERY-br-goods tt-gds
&Scoped-define FIRST-TABLE-IN-QUERY-br-goods tt-gds


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

define variable v-prod as character no-undo view-as text format "X(11)" label "Производитель" .
define variable v-prod-name as character no-undo view-as text format "X(30)" .

DEFINE BUTTON b-mark 
     LABEL "&*" 
     SIZE 3 BY 1.14 .
     
DEFINE BUTTON b-cancel AUTO-END-KEY 
     LABEL "Выход" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON b-load 
     LABEL "Запрос" 
     tooltip "Послать запрос в ЕГАИС"
     SIZE 15 BY 1.14
     BGCOLOR 8 .
     
DEFINE BUTTON b-save 
     LABEL "Сохранить" 
     tooltip "Записать данные в справочник"
     SIZE 15 BY 1.14
     BGCOLOR 8 .
     
DEFINE BUTTON b-answer 
     LABEL "Получить ответ" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .   
     
DEFINE BUTTON b-lkp 
     LABEL "Просмотр" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .
     
DEFINE BUTTON b-good 
     LABEL "Товар" 
     SIZE 10 BY 1.14
     BGCOLOR 8 .
     
DEFINE BUTTON b-connect 
     LABEL "Связать" 
     SIZE 13 BY 1.14
     BGCOLOR 8 . 
     
DEFINE BUTTON b-sel-all
     LABEL "&+":L
     SIZE 3 BY 1.14 TOOLTIP "Отметить все объекты".

DEFINE BUTTON b-unmark
     LABEL "&-":L
     SIZE 3 BY 1.14 TOOLTIP "Снять все отметки". 
     
DEFINE BUTTON b-prod
     IMAGE-UP FILE "btn-down-arrow":U
     IMAGE-DOWN FILE "btn-down-arrow":U
     IMAGE-INSENSITIVE FILE "btn-down-arrow":U
     LABEL "" 
     SIZE 3 BY 1.14 TOOLTIP "Выбор производителя".               

DEFINE VARIABLE rs-sort AS INTEGER
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS
        "&названию", 1,
        "&коду в TH", 2,
        "&алк. коду", 3
     SIZE 40 BY 1.14 NO-UNDO.
     
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-goods FOR 
      tt-gds SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-goods
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-goods Dialog-Frame _FREEFORM
  QUERY br-goods DISPLAY
    get-mark(BUFFER tt-gds) COLUMN-LABEL "*"  FORMAT "X(1)":U
    tt-gds.gds-code COLUMN-LABEL "Код товара в TH" FORMAT ">>>>>>>>9"
    tt-gds.gds-name COLUMN-LABEL "Наименование товара" FORMAT "X(100)":U width 35
    tt-gds.alc-code COLUMN-LABEL "Алкогольный код" FORMAT "X(25)":U 
    tt-gds.ms-base  COLUMN-LABEL "Объем" FORMAT ">>9.9<<"
    tt-gds.proof    COLUMN-LABEL "Крепость" FORMAT ">9.9"
    tt-gds.alc-type-code COLUMN-LABEL "Код АП" FORMAT "X(4)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 105 BY 20.2 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     b-mark AT ROW 1.24 COL 2
     b-sel-all AT ROW 1.24 COL 5
     b-unmark AT ROW 1.24 COL 8
     b-load AT ROW 1.24 COL 11
     b-answer AT ROW 1.24 COL 26
     b-save AT ROW 1.24 COL 41
     b-lkp AT ROW 1.24 COL 56
     b-good AT ROW 1.24 COL 71
     b-cancel AT ROW 1.24 COL 94
     v-prod AT ROW 2.7 COL 2
     b-prod AT ROW 2.5 COL 29
     v-prod-name AT ROW 2.7 COL 34 no-label
     "Сортировать по:" VIEW-AS TEXT
          SIZE 15 BY 1.14 AT ROW 3.6 COL 2 WIDGET-ID 18
     rs-sort AT ROW 3.6 COL 18 no-label   
     b-connect AT ROW 1.24 COL 81  
     br-goods AT ROW 5.16 COL 2 WIDGET-ID 200
     SPACE(1) SKIP(0.32)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Алкогольная продукция ЕГАИС"
         DEFAULT-BUTTON b-load CANCEL-BUTTON b-cancel WIDGET-ID 100.

assign br-goods:NUM-LOCKED-COLUMNS IN FRAME Dialog-Frame = 1 .

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
  if not available tt-gds then  return no-apply.
  if tt-gds.gds-code = 0  then  return no-apply.
  find first goods no-lock where goods.gds-code = tt-gds.gds-code .
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

&Scoped-define SELF-NAME b-good
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-good Dialog-Frame
ON CHOOSE OF b-good IN FRAME Dialog-Frame /* * */
DO:
    apply "F9" to frame Dialog-Frame .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Объекты ЕГАИС */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

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
  if not available tt-gds then return.
  for each tt-gds no-lock :
    { gbl/markstrn.i tt-gds select-list }
  end.
  {&browse-name}:refresh() in frame {&frame-name} .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-unmark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-unmark Dialog-Frame
ON CHOOSE OF b-unmark IN FRAME Dialog-Frame /* - */
DO:
  if not available tt-gds then return.
  select-list  = "".
  {&browse-name}:refresh() in frame {&frame-name} .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-prod Dialog-Frame
ON CHOOSE OF b-prod IN FRAME Dialog-Frame /* - */
DO:
    run sel-prod in this-procedure .
    assign
      rs-sort
    .
    run refresh-query in this-procedure.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME rs-sort
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-sort Dialog-Frame
ON VALUE-CHANGED OF rs-sort IN FRAME Dialog-Frame
DO:
  assign
    rs-sort
  .
  run refresh-query in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-connect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-connect Dialog-Frame
ON CHOOSE OF b-connect IN FRAME Dialog-Frame /* - */
DO:
    if not available tt-gds then return no-apply.
    assign v-rid = recid(tt-gds) .
    if tt-gds.gds-code = ? or tt-gds.gds-code = 0 then do :
        run ref/gds-ref.p (parparentproc, 'b-sel', ?, ?, ?, ?, ?, ?, ?, v-cntxt-obj-type, v-cntxt-obj-code, ?, output ref-list) no-error.
        if error-status:error or ref-list = ? or ref-list = "" then 
        do:
            message "Ошибка при выборе товара." view-as alert-box.
            return no-apply.
        end.
        find first buf_goods where recid(buf_goods) = integer(ref-list) no-error.
        assign tt-gds.gds-code = buf_goods.gds-code .
    end.
    else do :
        run bge/egais-select-good.w (input tt-gds.ms-base
                                    ,input tt-gds.proof
                                    ,input tt-gds.alc-type-code
                                    ,input bh-gds-egais:handle
                                    ,output v-alc-code) .
        if v-alc-code <> "" and v-alc-code <> ? then do :
            assign tt-gds.alc-code = v-alc-code .
        end.
    end.
    run refresh-query in this-procedure.
    reposition br-goods to recid v-rid .  
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
        for first tt-gds exclusive-lock where recid(tt-gds) = integer(entry(ii, select-list)) and tt-gds.gds-code > 0 :
            if tt-gds.alc-code <> "" and tt-gds.alc-code <> ? then do :
                bh-gds-egais:find-unique (substitute("where trim(tt-gds-EG.alc-code) = '&1'", trim(tt-gds.alc-code)), no-lock) no-error.
            end.
            else do :
                bh-gds-egais:find-unique (substitute("where trim(tt-gds-EG.gds-name) = '&1'", trim(tt-gds.gds-name)), no-lock) no-error.
            end.
            if bh-gds-egais:available and not bh-gds-egais:ambiguous then do transaction :
                if tt-gds.alc-type-code <> bh-gds-egais:buffer-field("alc-type-code"):buffer-value then do :                        
                    find first ub.alc-type no-lock
                         where ub.alc-type.alc-type-code = trim(bh-gds-egais:buffer-field("alc-type-code"):buffer-value) no-error .
                    if available ub.alc-type then do :
                        find first ub.alc-type-gds 
                             where ub.alc-type-gds.gds-code = tt-gds.gds-code
                               and ub.alc-type-gds.create-user-db-num = 0 EXCLUSIVE-LOCK no-error. 
                        if not available ub.alc-type-gds then do :
                            create ub.alc-type-gds.       
                        end.
                        assign
                            ub.alc-type-gds.gds-code            = tt-gds.gds-code
                            ub.alc-type-gds.alc-type-inner-code = ub.alc-type.alc-type-inner-code
                            ub.alc-type-gds.create-user-db-num  = 0
                        .
                    end.
                end.    
                buffer tt-gds:handle:buffer-copy (bh-gds-egais, "gds-code") .
                for first buf_goods exclusive-lock where buf_goods.gds-code = tt-gds.gds-code :
                    assign
                        buf_goods.gds-name = tt-gds.gds-name
                        buf_goods.ms-base  = tt-gds.ms-base
                        buf_goods.proof    = tt-gds.proof
                    .
                    if tt-gds.alc-code <> "" then do :
                        run gen-key-rec IN THIS-PROCEDURE (  input {&table_goods}
                                                            ,input (buffer buf_goods:handle)
                                                            ,output v-gds-uniq-key-rec).
                        find first X_ext-classif exclusive-lock  where X_ext-classif.classif-subject = {&table_goods} 
                                                                   and X_ext-classif.classif-name = {&extclass_goods_esys} 
                                                                   AND X_ext-classif.db-num = 0  
                                                                   and X_ext-classif.key#_one = buf_goods.gds-code
                                                                   and X_ext-classif.key#_two = v-ext-sys 
                                                                   and X_eXt-classif.uniq-key-rec = v-gds-uniq-key-rec
                                                                   no-error. 
                        if available X_ext-classif then do :    
                            assign X_ext-classif.charkey_one = tt-gds.alc-code .
                        end.                                    
                        else do :                                    
                            run ref/extclas1.p ( 
                                INPUT {&add-def}
                                ,INPUT yes /*p-silent*/
                                ,INPUT-OUTPUT v-rid
                                ,INPUT {&table_goods} /*p-classif-subject*/
                                ,INPUT {&extclass_goods_esys} /*p-classif-name*/
                                ,input 0  /*p-db-num*/
                                ,input buf_goods.gds-code  /*p-key#_one*/
                                ,input v-ext-sys /*p-Key#_Two*/
                                ,input 0 /*p-key#_Three*/
                                ,input tt-gds.alc-code  /*p-CharKey_One */
                                ,input '':U /*p-CharKey_two */
                                ,input buf_goods.gds-name /*p-CharKey_three */
                                ,input 0 /*p-nonunique */
                                ,input v-gds-uniq-key-rec ) no-error.
                            if error-status:error then
                            do:
                                if error-status:get-message(1) = "" then
                                    message "Ошибка добавления записи в справочник!" view-as alert-box .
                                else
                                    message error-status:get-message(1) view-as alert-box .
                                undo, return no-apply .
                            end.
                        end.    
                    end. /* if tt-gds.alc-code <> "" */
                end. /* for first buf_goods */
                find first old_tt-gds exclusive-lock where old_tt-gds.gds-code = tt-gds.gds-code
                                                       and recid(old_tt-gds) <> recid(tt-gds) no-error.
                if available old_tt-gds then do :
                    delete old_tt-gds .
                end. 
            end. /* if bh-gds-egais:available */
        end. /* for first tt-gds */
    end. /* do ii = 1 to num-entries(select-list) */
    run refresh-query in this-procedure.     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-lkp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-lkp Dialog-Frame
ON CHOOSE OF b-lkp IN FRAME Dialog-Frame /* - */
DO:
    if available tt-gds and tt-gds.gds-code <> 0 and valid-handle(bh-gds-egais) then do :
        bh-gds-egais:find-first (substitute("where trim(tt-gds-EG.gds-name) = '&1'", trim(tt-gds.gds-name)), no-lock) no-error.
        if bh-gds-egais:available then do :
            run bge/egais-gds-diff.w (input rowid(tt-gds), input buffer tt-gds:handle, input bh-gds-egais:handle).
        end.
        else do :
            message "Нет различий по данному товару" view-as alert-box.
            return no-apply.
        end.
    end.            
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
    qh-gds-egais:query-prepare ("for each tt-gds-eg").
    qh-gds-egais:query-open.
    _repeat:
    repeat:
        qh-gds-egais:get-next ().
        if qh-gds-egais:query-off-end then leave _repeat.
        find first tt-gds no-lock where trim(tt-gds.gds-name) = trim(bh-gds-egais:buffer-field ("gds-name"):buffer-value) and not tt-gds.fromEgais no-error.
        if not available tt-gds then do :
            create tt-gds.
            buffer tt-gds:handle:buffer-copy (bh-gds-egais) .
            assign tt-gds.fromEgais = yes .
        end.                               
    end.
    run refresh-query in this-procedure.
    apply "value-changed" to br-goods .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define BROWSE-NAME br-goods
&UNDEFINE SELF-NAME

on row-display of br-goods IN FRAME Dialog-Frame /* - */
DO:
    if tt-gds.gds-code = 0 then tt-gds.gds-code:bgcolor in browse br-goods = yellow_color .
    if valid-handle(bh-gds-egais) then do :
/*        bh-gds-egais:find-unique (substitute("where trim(tt-gds-EG.gds-name) = '&1'", trim(tt-gds.gds-name)), no-lock) no-error.*/
        bh-gds-egais:find-unique (substitute("where tt-gds-EG.gds-name = '&1'", tt-gds.gds-name), no-lock) no-error.
        if bh-gds-egais:available and not bh-gds-egais:ambiguous and not tt-gds.fromEgais then do :
            if bh-gds-egais:buffer-field ("ms-base"):buffer-value <> tt-gds.ms-base then tt-gds.ms-base:bgcolor in browse br-goods = red_color .
            if bh-gds-egais:buffer-field ("proof"):buffer-value <> tt-gds.proof then tt-gds.proof:bgcolor in browse br-goods = red_color .
            if bh-gds-egais:buffer-field ("alc-code"):buffer-value <> tt-gds.alc-code then tt-gds.alc-code:bgcolor in browse br-goods = red_color .
            if bh-gds-egais:buffer-field ("alc-type-code"):buffer-value <> tt-gds.alc-type-code then tt-gds.alc-type-code:bgcolor in browse br-goods = red_color .
        end.
    end.    
end.

on value-changed of br-goods IN FRAME Dialog-Frame /* - */
DO:
    if available tt-gds then do :
        if tt-gds.gds-code = ? or tt-gds.gds-code = 0 then do :
            disable b-good with frame Dialog-Frame .
            if tt-gds.fromEgais then enable b-connect with frame Dialog-Frame .
            else disable b-connect with frame Dialog-Frame .
        end.
        else do :
            enable b-good with frame Dialog-Frame .
            if valid-handle(bh-gds-egais) then enable b-connect with frame Dialog-Frame .
            else disable b-connect with frame Dialog-Frame .
        end.            
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
  assign
      rs-sort = 1
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
      ,input {&cmp}
      ,input v-cntxt-host-code-obj
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
  
  run adm/shattri.p (
       input "get":U
      ,input {&cmp}
      ,input v-cntxt-host-code-obj
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
/*  run fill-tt.*/
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
  if not available tt-gds then return.
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
  if not available tt-gds then do:
    message "Неправильный выбор строки.".
    return no-apply.
  end.
  { gbl/markstrn.i tt-gds select-list }
  {&browse-name}:refresh() in frame {&frame-name} .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fill-tt Dialog-Frame
PROCEDURE fill-tt :
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
    for each tt-gds :
        delete tt-gds .
    end. 
    if not available buf_clients then return.
    for each buf_goods no-lock where buf_goods.prod-code = buf_clients.obj-code
                                 and buf_goods.prod-type = buf_clients.obj-type :
        run gds-attr-value(
            buf_goods.gds-code,
            {&attr-alcohol-prod},
            output par-alcohol,
            output par-type
        ).
        if par-alcohol <> "" and par-alcohol <> "no" then do :
            create tt-gds .
            assign
                tt-gds.gds-code = buf_goods.gds-code
                tt-gds.gds-name = buf_goods.gds-name
                tt-gds.ms-base  = buf_goods.ms-base
                tt-gds.proof    = buf_goods.proof
            .
            for first ub.alc-type-gds where ub.alc-type-gds.gds-code = buf_goods.gds-code no-lock,
                first ub.alc-type where ub.alc-type.alc-type-inner-code = ub.alc-type-gds.alc-type-inner-code no-lock :
                assign tt-gds.alc-type-code = ub.alc-type.alc-type-code .    
            end.
            run gen-key-rec IN THIS-PROCEDURE ( input {&table_goods}
                                                ,input (buffer buf_goods:handle)
                                                ,output v-gds-uniq-key-rec).
            find first X_ext-classif no-lock where X_ext-classif.classif-subject = {&table_goods} 
                                               and X_ext-classif.classif-name = {&extclass_goods_esys} 
                                               AND X_ext-classif.db-num = 0  
                                               and X_ext-classif.key#_one = buf_goods.gds-code
                                               and X_ext-classif.key#_two = v-ext-sys 
                                               and X_eXt-classif.uniq-key-rec = v-gds-uniq-key-rec
                                               no-error. 
            if available X_ext-classif then do :    
                assign tt-gds.alc-code = X_ext-classif.charkey_one .
            end.                                    
        end.                             
    end.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refresh-query Dialog-Frame
PROCEDURE refresh-query :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  case rs-sort :
    when 1 then do:
      OPEN QUERY {&browse-name} FOR EACH tt-gds
                 by tt-gds.gds-name
                 indexed-reposition .
    end.
    when 2 then do:
      OPEN QUERY {&browse-name} FOR EACH tt-gds
                 by tt-gds.gds-code
                 indexed-reposition .
    end.
    OTHERWISE do:
      OPEN QUERY {&browse-name} FOR EACH tt-gds
                 by tt-gds.alc-code
                 indexed-reposition .
    end.
  end case.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

procedure sel-prod :
    assign
        ref-list = "":U
    .
    run ref/cli-all.w (
                       input parparentproc
                    ,  input "b-sel"
                    ,  input {&pro}
                    ,  input {&all}
                    ,  input {&current}
                    ,  input ?
                    ,  input ",,,,,,NO,,,"
                    ,  input ?
                    , output ref-list
                    ) .
    if ref-list = "":U then do:       
        RUN enable_UI IN THIS-PROCEDURE.
        return no-apply.
    end.
    find first buf_clients no-lock where recid(buf_clients) = integer(ref-list) . 
    if available buf_clients then do :
        find first buf_clients-attr no-lock where buf_clients-attr.obj-type  = buf_clients.obj-type 
                                            and   buf_clients-attr.obj-code  = buf_clients.obj-code 
                                            and   buf_clients-attr.attr-code = {&attr-cli-alc-producer} no-error.   
        if not available buf_clients-attr then do : 
            message 'У производителя должен быть атрибут "Производитель алкогольной продукции"' view-as alert-box.
            release buf_clients .
            run sel-prod .
/*            apply "choose":U to b-prod IN FRAME Dialog-Frame .*/
        end.    
    end.
    if available buf_clients then do :
        assign
            v-prod = buf_clients.obj-type + string(buf_clients.obj-code)
            v-prod-name = buf_clients.obj-name
        . 
        find first buf_firm no-lock where buf_firm.firm-code = buf_clients.obj-code no-error .
        if available buf_firm then do :
            egais:EGAISImpl = new DictGds(v-fs-rar, buf_firm.inn) .
        end.
    end.     
    display v-prod v-prod-name with frame Dialog-Frame.
    run fill-tt.
    run refresh-query in this-procedure .  
    apply "value-changed" to br-goods IN FRAME Dialog-Frame .
end procedure.    

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
    
  DISPLAY rs-sort
      WITH FRAME Dialog-Frame.
  ENABLE b-mark b-sel-all b-unmark b-load b-answer rs-sort b-save b-lkp b-cancel b-prod br-goods b-connect 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  br-goods:column-resizable in FRAME Dialog-Frame = true .
/*  if egais:IsSent then enable b-answer WITH FRAME Dialog-Frame.*/
/*  else disable b-answer WITH FRAME Dialog-Frame .              */
  run refresh-query in this-procedure .
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

