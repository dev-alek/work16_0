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
using ibs.th.bge.egais.*.
/* Parameters Definitions ---                                           */
define input parameter parparentproc as widget-handle no-undo .
define input parameter p-mode       as character no-undo .
define input parameter egais        as class EGAIS no-undo .
define input parameter v-ext-sys    as integer no-undo .
define input parameter v-fs-rar     as character no-undo .
define input parameter bh-act-header  as handle no-undo .
/* Local Variable Definitions ---                                       */
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "ЕГАИС Акт постановки на баланс".

define variable ii                  as integer no-undo .
define variable v-position_         as integer no-undo .
define variable v-date              as character no-undo .
define variable v-rid-list          as character no-undo .
define variable par-alcohol         as character no-undo .
define variable par-type            as character no-undo .
define variable v-attr-value        as character            no-undo .
define variable v-attr-type         as character            no-undo .

define variable glog        as logical no-undo .

define variable v-obj-uniq-key-rec as character no-undo .

define variable sw as handle no-undo .

define variable v-file              as character no-undo initial "ActChargeOn1.xml".

define variable qh-gds-act          as handle no-undo .
define variable bh-gds-act          as handle no-undo .
define variable brh-gds-act         as handle no-undo .

define variable v-gds-uniq-key-rec as character no-undo .

define variable v-part-num    as integer   no-undo .
define variable v-clob-db-num as integer   no-undo .
define variable v-int64-id    as int64     no-undo .
define variable v-info        as character no-undo .

DEFINE VARIABLE hDoc AS HANDLE NO-UNDO.
DEFINE VARIABLE hRoot AS HANDLE NO-UNDO.
DEFINE VARIABLE good AS LOGICAL NO-UNDO.

define variable v-longchar      as memptr no-undo .

define buffer buf_goods         for ub.goods .
define buffer buf_parts         for ub.parts .
define buffer buf_trn-doc       for ub.trn-doc .
define buffer x_ext-classif     for ub.ext-classif .
define buffer buf_clob-bind     for ub.clob-bind .
define buffer buf_clob-data     for ub.clob-data .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

{cmp/str-glbl.i}
{ gbl/color.i }
{ cmp/library.i  }
{ gbl/getcntxt.i def }
{ gbl/getcntxt.i get }
{ ref/extclass.i }
{ gbl/key-rec.i  }
{ gbl/thbjattr.i }
{ ref/gds-attr.i }
{ str/trdcalib.i   }
{ibs/th/bge/egais/ab-egais.i shared }

/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

DEFINE BUTTON b-cancel AUTO-END-KEY 
     LABEL "Выход" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .
     
DEFINE BUTTON b-good
     LABEL "Выбор товара" 
     SIZE 15 BY 1.14 TOOLTIP "Выбор товара"
     BGCOLOR 8 . 
     
DEFINE BUTTON b-marks
     LABEL "Ввести марки" 
     SIZE 15 BY 1.14 TOOLTIP "Ввести марки"
     BGCOLOR 8 .
     
DEFINE BUTTON b-del
     LABEL "Удалить строку" 
     SIZE 15 BY 1.14 TOOLTIP "Удалить строку акта"
     BGCOLOR 8 .  
     
DEFINE BUTTON b-save
     LABEL "Сохранить" 
     SIZE 15 BY 1.14 TOOLTIP "Сохранить в БД"
     BGCOLOR 8 . 
     
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-gds-act FOR 
      tt-gds-act SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-gds-act
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-gds-act Dialog-Frame _FREEFORM
  QUERY br-gds-act  DISPLAY
    tt-gds-act.position_
    tt-gds-act.doc-code
/*    tt-gds-act.part-code*/
    tt-gds-act.gds-code
    tt-gds-act.alc-code
    tt-gds-act.gds-name
    tt-gds-act.qnty
    tt-gds-act.A-qnty
    tt-gds-act.A-bottleDate
    tt-gds-act.A-ttnNumber
    tt-gds-act.A-ttnDate
    tt-gds-act.A-fixNumber
    tt-gds-act.A-fixDate
    tt-gds-act.marks-qnty
  ENABLE
    tt-gds-act.qnty
    tt-gds-act.A-qnty
    tt-gds-act.A-bottleDate
    tt-gds-act.A-ttnNumber
    tt-gds-act.A-ttnDate
    tt-gds-act.A-fixNumber
    tt-gds-act.A-fixDate
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 107 BY 20.2 FIT-LAST-COLUMN.  

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
    b-cancel at row 1.2 col 2
    b-good at row 1.2 col 17
    b-marks at row 1.2 col 32
    b-del at row 1.2 col 47
    b-save at row 1.2 col 95
    tt-act-header.num at row 2.5 col 2 format "X(20)"
    tt-act-header.date_ at row 2.5 col 32
    br-gds-act at row 4 col 2
     SPACE(0.5) SKIP(0.5)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Акт постановки товаров на баланс" WIDGET-ID 100.


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
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* <insert dialog title> */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-cancel Dialog-Frame
ON CHOOSE OF b-cancel IN FRAME Dialog-Frame /* - */
DO:
    if p-mode <> {&lookup} then do :
        message "Все несохранённые данные будут потеряны. Вы уверены, что хотите выйти?"
        view-as alert-box question buttons yes-no update glog.
        if not glog then return no-apply . 
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-del Dialog-Frame
ON CHOOSE OF b-del IN FRAME Dialog-Frame /* - */
DO:
    if not available tt-gds-act then do :
        message "Выберите строку" view-as alert-box .
        return no-apply.
    end.
    else do :
        delete tt-gds-act .
        open QUERY br-gds-act FOR each tt-gds-act exclusive-lock .
        find first tt-gds-act no-error.
        if not available tt-gds-act then enable b-good with frame {&FRAME-NAME}.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-act-header.num
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-act-header.num Dialog-Frame
ON "leave" of tt-act-header.num in FRAME Dialog-Frame /* <insert dialog title> */
/*or ON return of tt-act-header.num in FRAME Dialog-Frame*/
DO:
    assign tt-act-header.num .
    for each tt-gds-act exclusive-lock :
        assign tt-gds-act.num = tt-act-header.num .    
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-marks
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-marks Dialog-Frame
ON CHOOSE OF b-marks IN FRAME Dialog-Frame /* Создать */
DO:
    if not available tt-gds-act then do :
        message "Выберите строку" view-as alert-box .
        return no-apply.
    end. 
    run bge/egais-ab-marks.w (tt-gds-act.num, tt-gds-act.position_) .
    assign ii = 0 .
    for each tt-marks no-lock where tt-marks.num = tt-gds-act.num and tt-marks.gds-part-position_ = tt-gds-act.position_ :
        ii = ii + 1 .
    end.
    assign tt-gds-act.marks-qnty = ii .
    open QUERY br-gds-act FOR each tt-gds-act exclusive-lock .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME 

&Scoped-define SELF-NAME b-marks
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-marks Dialog-Frame
ON CHOOSE OF b-save IN FRAME Dialog-Frame /* Создать */
DO:
    find first tt-gds-act no-error .
    if not available tt-gds-act then do :
        message "В акте нет строк. Сохранение невозможно" view-as alert-box .
        return no-apply.
    end.
    run makeXML in this-procedure no-error.
    if error-status:error then return return-value .
    assign
        v-clob-db-num = ?
        v-int64-id = 0
        v-info = tt-act-header.num + {&delim-par} + string(tt-act-header.date_) + {&delim-par} + string(tt-act-header.is-sent) + {&delim-par} + tt-act-header.answer_
    .
    find first buf_clob-bind exclusive-lock where buf_clob-bind.uniq-key-rec = tt-act-header.num
                                              and buf_clob-bind.field-name_  = {&lob-egais-ab} no-error .
    if available buf_clob-bind then do :
        assign
            v-clob-db-num = buf_clob-bind.db-num
            v-int64-id = buf_clob-bind.int64-id
            v-part-num = buf_clob-bind.part-num
        .
        run gbl/file2clb.p ( input {&update}
                  ,input "add-new,no"
                  ,input ? /*p-bh*/
                  ,input tt-act-header.num /*p-uniq-key-rec*/
                  ,input {&lob-egais-ab} /*p-field-*/
                  ,input v-info /*p-descr*/
                  ,input-output v-part-num
                  ,input {&lob-egais-ab}
                  ,input-output v-clob-db-num
                  ,input-output v-int64-id
                  ,input search (v-file)
                  ,input '' /*p-src-encoding*/
                  ) no-error .
         if error-status:error then message return-value view-as alert-box.   
    end.
    else do :
        run gbl/file2clb.p ( input {&add-def}
                  ,input ",no"
                  ,input ? /*p-bh*/
                  ,input tt-act-header.num /*p-uniq-key-rec*/
                  ,input {&lob-egais-ab} /*p-field-*/
                  ,input v-info /*p-descr*/
                  ,input-output v-part-num
                  ,input {&lob-egais-ab}
                  ,input-output v-clob-db-num
                  ,input-output v-int64-id
                  ,input search (v-file)
                  ,input '' /*p-src-encoding*/
                  ) no-error .        
    end.
        
    message "Сохранение завершено" view-as alert-box.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME    

&Scoped-define SELF-NAME b-good
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-good Dialog-Frame
ON CHOOSE OF b-good IN FRAME Dialog-Frame /* Создать */
DO:
    run ref/gds-ref.p
    ( parparentproc
    ,'b-sel'
    ,?             /*p-stat */
    ,?             /*p-list  */
    ,?             /*p-cond  */
    ,?             /*p-rec   */
    ,?             /*p-grp   */
    ,?             /*p-cli-type */
    ,?             /*p-cli-code  */
    ,v-cntxt-obj-type    /*p-obj-type  */
    ,v-cntxt-obj-code     /*p-obj-code  */
    ,?             /*p-other     */
    , output v-rid-list) no-error.
    if v-rid-list = "" or v-rid-list = ? 
    then return no-apply.
    find buf_goods where recid (buf_goods) = integer (v-rid-list) no-lock.
    run gds-attr-value(
      buf_goods.gds-code,
      {&attr-alcohol-prod},
      output par-alcohol,
      output par-type
    ).
    if par-alcohol = "" or par-alcohol = "no" then 
    do :
        message "Выбранный товар не является алкогольной продукцией." view-as alert-box.
        return no-apply.
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
    if not available X_ext-classif or trim(X_ext-classif.charkey_one) = "" then do :  
        message "Выбранный товар не синхронизирован с ЕГАИС. (Нет алкогольного кода)" view-as alert-box.
        return no-apply.  
/*        assign tt-gds.alc-code = X_ext-classif.charkey_one .*/
    end.
    assign ii = 0 .  
    for each buf_parts no-lock where buf_parts.artic = buf_goods.artic 
                                and buf_parts.prod-type = buf_goods.prod-type 
                                and buf_parts.prod-code = buf_goods.prod-code 
                                and buf_parts.obj-type = v-cntxt-obj-type 
                                and buf_parts.obj-code = v-cntxt-obj-code 
                                and buf_parts.out-code = {&free-code} ,
    first buf_trn-doc no-lock where buf_trn-doc.doc-code = buf_parts.in-code :
        if buf_parts.qnty < 1 then next .
        assign ii = ii + 1 .                            
        create tt-gds-act.
        assign
            tt-gds-act.gds-code         = buf_goods.gds-code
            tt-gds-act.alc-code         = X_ext-classif.charkey_one
            tt-gds-act.gds-name         = buf_goods.gds-name
            tt-gds-act.doc-code         = buf_trn-doc.doc-code
            tt-gds-act.doc-date         = buf_trn-doc.fact-date
            tt-gds-act.num              = tt-act-header.num
            tt-gds-act.part-code        = buf_parts.part-code
            tt-gds-act.position_        = ii
            tt-gds-act.qnty             = buf_parts.qnty
            tt-gds-act.marks-qnty       = 0
            tt-gds-act.A-bottleDate     = buf_parts.alc-bottling-date
            tt-gds-act.A-qnty           = buf_parts.qnty 
        .
        if buf_parts.cst-code <> "" then do :
            assign tt-gds-act.A-ttnNumber      = buf_parts.cst-code .
        end.
        else do :
            { str/tdat-val.i
            buf_trn-doc.doc-code
            {&trdcattr-nids}
            v-attr-value
            v-attr-type
            }
            if v-attr-value <> "" and v-attr-value <> ? then do :
                assign tt-gds-act.A-ttnNumber  =  v-attr-value . 
                { str/tdat-val.i
                buf_trn-doc.doc-code
                {&trdcattr-dids}
                v-attr-value
                v-attr-type
                }
                assign tt-gds-act.A-ttnDate = if v-attr-value = "" or v-attr-value = ? then buf_trn-doc.doc-date else date( v-attr-value ) .
            end.
            else do :
                assign
                    tt-gds-act.A-ttnNumber  = buf_trn-doc.doc-code
                    tt-gds-act.A-ttnDate    = buf_trn-doc.doc-date
                .    
            end.      
        end. 
    end.
    open QUERY br-gds-act FOR each tt-gds-act exclusive-lock .
    find first tt-gds-act no-error.
    if available tt-gds-act then disable b-good with frame {&FRAME-NAME}.
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
    
/*    { gbl/ed_date.i tt-gds-act.A-bottleDate 'in browse br-gds-act' }*/
/*    { gbl/ed_date.i tt-gds-act.A-ttnDate 'in browse br-gds-act' }   */
/*    { gbl/ed_date.i tt-gds-act.A-fixDate 'in browse br-gds-act' }   */
       
    if p-mode = {&add-def} then do :
        v-date = substitute ("&1&2&3",string (year (now)), string (month (now)), string (day (now))).        
        create tt-act-header .
        assign
            tt-act-header.num = v-date + '-' + substring(v-cntxt-obj-type,1,1) + string(v-cntxt-obj-code) + '-'
            tt-act-header.date_ = TODAY
            tt-act-header.is-sent = no
        .
        display tt-act-header.num tt-act-header.date_ with frame {&FRAME-NAME}.
        enable  tt-act-header.num tt-act-header.date_ b-good with frame {&FRAME-NAME}.     
    end.
    
    if p-mode = {&update} or p-mode = {&lookup} then do :
        find last buf_clob-bind where buf_clob-bind.field-name_ = {&lob-egais-ab} and buf_clob-bind.uniq-key-rec = bh-act-header:buffer-field ("num"):buffer-value .
        find first buf_clob-data no-lock where buf_clob-data.db-num = buf_clob-bind.db-num and buf_clob-data.int64-id = buf_clob-bind.int64-id no-error.
        copy-lob
        from  object buf_clob-data.cdata
        to  file 'temp.xml'
        no-convert
        no-error .
        run parseXML in this-procedure .
        display tt-act-header.num tt-act-header.date_ with frame {&FRAME-NAME}.
        enable  tt-act-header.num tt-act-header.date_ with frame {&FRAME-NAME}.
        open QUERY br-gds-act FOR each tt-gds-act exclusive-lock .
        find first tt-gds-act no-error.
        if available tt-gds-act then disable b-good with frame {&FRAME-NAME}.
    end.
    
/*    create query qh-gds-act .*/
/*    qh-gds-act:set-buffers ()*/
    { gbl/diasize.i &browse-name=br-gds-act }
    run diasize_init in this-procedure .
    RUN enable_UI.
    WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

procedure makeXML :
    create sax-writer sw .
    
    sw:formatted = true.
    sw:set-output-destination ("file", v-file).
    sw:encoding = "UTF-8".
    sw:start-document () .
    sw:start-element ("ns:Documents") .
    sw:insert-attribute ("Version", "1.0") .
    sw:insert-attribute ("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance") .
    sw:insert-attribute ("xmlns:ns", "http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01") .
    sw:insert-attribute ("xmlns:oref", "http://fsrar.ru/WEGAIS/ClientRef") .
    sw:insert-attribute ("xmlns:pref", "http://fsrar.ru/WEGAIS/ProductRef") .
    sw:insert-attribute ("xmlns:ain", "http://fsrar.ru/WEGAIS/ActChargeOn") .
    sw:insert-attribute ("xmlns:iab", "http://fsrar.ru/WEGAIS/ActInventoryABInfo") . 
        sw:start-element ("ns:Owner") . 
            sw:write-data-element ("ns:FSRAR_ID", v-fs-rar) .
        sw:end-element ("ns:Owner") . 
        sw:start-element ("ns:Document") .
            sw:start-element ("ns:ActChargeOn") . 
                sw:start-element ("ain:Header") .
                    sw:write-data-element ("ain:Number", tt-act-header.num) .
                    sw:write-data-element ("ain:ActDate", string(iso-date(tt-act-header.date_))) no-error .
                    sw:write-data-element ("ain:Note", "Необходимо поставить товарные позиции на баланс") .
                sw:end-element ("ain:Header") .
                sw:start-element ("ain:Content") .
    for each tt-gds-act no-lock where tt-gds-act.num = tt-act-header.num :
        if tt-gds-act.qnty < 1 then next. 
                    sw:start-element ("ain:Position") .
                        sw:write-data-element ("ain:Identity", string(tt-gds-act.position_)) .
                        sw:start-element ("ain:Product") .
                            sw:write-data-element ("pref:Type", "АП") . 
                            sw:write-data-element ("pref:FullName", tt-gds-act.gds-name) .
                            sw:write-data-element ("pref:ShortName", "") . 
                            sw:write-data-element ("pref:AlcCode", tt-gds-act.alc-code) .
                            sw:write-data-element ("pref:Capacity", string(buf_goods.ms-base)) . 
                            sw:write-data-element ("pref:AlcVolume", string(buf_goods.proof)) . 
                        for first ub.alc-type-gds where ub.alc-type-gds.gds-code = buf_goods.gds-code no-lock,
                            first ub.alc-type where ub.alc-type.alc-type-inner-code = ub.alc-type-gds.alc-type-inner-code no-lock :
                            sw:write-data-element ("pref:ProductVCode", string(ub.alc-type.alc-type-code)) .
                            sw:start-element ("pref:Producer") .
                                find first ub.clients no-lock where ub.clients.obj-type = buf_goods.prod-type
                                                                and ub.clients.obj-code = buf_goods.prod-code .
                                find first ub.firm no-lock where ub.firm.firm-code = ub.clients.obj-code .
                                run gen-key-rec in this-procedure   ( input {&table_clients}
                                                                     ,input buffer ub.clients:handle
                                                                     ,output v-obj-uniq-key-rec).
                                find first X_ext-classif no-lock where X_ext-classif.classif-subject = {&table_clients}
                                                                   and X_ext-classif.classif-name = {&extclass_clients_esys}
                                                                   AND X_ext-classif.db-num = 0
                                                                   and X_ext-classif.key#_one = v-ext-sys
                                                                   and X_eXt-classif.uniq-key-rec = v-obj-uniq-key-rec
                                                                   no-error.
                                sw:write-data-element ("oref:INN", ub.firm.inn) .
                                sw:write-data-element ("oref:KPP", ub.firm.kpp) .
                                sw:write-data-element ("oref:ClientRegId", if available X_ext-classif then X_ext-classif.charkey_three else "" ) .
                                sw:write-data-element ("oref:FullName", ub.clients.obj-name) .
                                sw:write-data-element ("oref:ShortName", ub.clients.obj-name) .
                                sw:start-element ("oref:address") .
                                    find first ub.clients-attr no-lock where ub.clients-attr.obj-type = ub.clients.obj-type 
                                                                        and   ub.clients-attr.obj-code = ub.clients.obj-code
                                                                        and   ub.clients-attr.attr-code = {&attr-requisite-alc-decl} no-error.
                                    sw:write-data-element ("oref:Country", if available ub.clients-attr then entry( 3, ub.clients-attr.attr-value, "|") else "" ) .
                                    sw:write-data-element ("oref:description", (ub.firm.addres1 + ub.firm.addres2) ) .                                    
                                sw:end-element ("oref:address") .
                            sw:end-element ("pref:Producer") .
                        end.
                        sw:end-element ("ain:Product") .
                        sw:write-data-element ("ain:Quantity", string(tt-gds-act.qnty)) .
                        sw:start-element ("ain:InformAB") .
                            sw:start-element ("ain:InformABReg") . 
                                sw:start-element ("ain:InformA") .
                                    sw:write-data-element ("iab:Quantity", string(tt-gds-act.A-qnty)) .
                                    sw:write-data-element ("iab:BottlingDate", string(iso-date(tt-gds-act.A-bottleDate))) no-error .
                                    sw:write-data-element ("iab:TTNNumber", tt-gds-act.A-ttnNumber) .
                                    sw:write-data-element ("iab:TTNDate", string(iso-date(tt-gds-act.A-ttnDate))) no-error .
                                    sw:write-data-element ("iab:EGAISFixNumber", tt-gds-act.A-fixNumber) no-error .
                                    sw:write-data-element ("iab:EGAISFixDate", string(iso-date(tt-gds-act.A-fixDate))) no-error .
                                sw:end-element ("ain:InformA") .  
                            sw:end-element ("ain:InformABReg") .
                        sw:end-element ("ain:InformAB") .
                        sw:start-element ("ain:MarkCodeInfo") .
        for each tt-marks no-lock where tt-marks.num = tt-gds-act.num and tt-marks.gds-part-position_ = tt-gds-act.position_ :
                            sw:write-data-element ("ain:MarkCode", tt-marks.mark) .
        end.    
                        sw:end-element ("ain:MarkCodeInfo") .         
                    sw:end-element ("ain:Position") .                
    end. 
                sw:end-element ("ain:Content") .
            sw:end-element ("ns:ActChargeOn") .
        sw:end-element ("ns:Document") .
    sw:end-element ("ns:Documents") .
    sw:end-document () .
    delete object sw.
    
end procedure .

procedure parseXML :
    empty temp-table tt-act-header .
    empty temp-table tt-gds-act .
    empty temp-table tt-marks .
    
    CREATE X-DOCUMENT hDoc.
    CREATE X-NODEREF hRoot.
   
    hDoc:encoding = 'utf-8'.
    hDoc:LOAD("file", search("temp.xml"),FALSE).
   
    hDoc:GET-DOCUMENT-ELEMENT(hRoot).
    
    RUN GetChildren(hRoot, 1).

    DELETE OBJECT hDoc.
    DELETE OBJECT hRoot.    
end procedure .

procedure GetChildren :
    DEFINE INPUT PARAMETER hParent AS HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER level AS INTEGER NO-UNDO.
        
    DEFINE VARIABLE i AS INTEGER NO-UNDO.
    DEFINE VARIABLE hNoderef AS HANDLE NO-UNDO.
    DEFINE VARIABLE hText AS HANDLE NO-UNDO.
    
    CREATE X-NODEREF hNoderef.
    CREATE X-NODEREF hText .
    
    
    REPEAT i = 1 TO hParent:NUM-CHILDREN:
        good = hParent:GET-CHILD(hNoderef,i).
        IF NOT good THEN 
            LEAVE.
        IF hNoderef:SUBTYPE <> "element" THEN
            NEXT.
        
        hNoderef:GET-CHILD(hText, 1) no-error .    
        
/*        IF hNoderef:NAME = "ns:FSRAR_ID" THEN   */
/*            assign v-FS-RAR = hText:node-value .*/
        IF hNoderef:NAME = "ain:Header" THEN do :
            create tt-act-header .
            assign tt-act-header.is-sent = bh-act-header:buffer-field("is-sent"):buffer-value .
        end .
        .
        IF hNoderef:NAME = "ain:Number" THEN assign tt-act-header.num    = hText:node-value no-error .
        IF hNoderef:NAME = "ain:ActDate" THEN 
            assign tt-act-header.date_ = date(substring(hText:node-value, 9, 2) + "/" + substring(hText:node-value, 6, 2) + "/" + substring(hText:node-value, 1, 4)) no-error .    
            
        IF hNoderef:NAME = "ain:Position" THEN do :
            assign ii = 0 .
            create tt-gds-act .
            assign tt-gds-act.num = tt-act-header.num .
        end.
        IF hNoderef:NAME = "ain:Identity" THEN assign tt-gds-act.position_ = integer(hText:node-value) no-error .   
        IF hNoderef:NAME = "pref:AlcCode" THEN do :
            assign tt-gds-act.alc-code = hText:node-value no-error .
            find first X_ext-classif no-lock where X_ext-classif.classif-subject = {&table_goods} 
                                               and X_ext-classif.classif-name = {&extclass_goods_esys} 
                                               AND X_ext-classif.db-num = 0  
                                               and X_ext-classif.key#_two = v-ext-sys
                                               and X_ext-classif.charkey_one = tt-gds-act.alc-code 
                                               no-error. 
            if available X_ext-classif then do :
                find first buf_goods no-lock where buf_goods.gds-code = X_ext-classif.key#_one .    
            end.
            assign
                tt-gds-act.gds-code = buf_goods.gds-code
                tt-gds-act.gds-name = buf_goods.gds-name
            .        

        end. 
        IF hNoderef:NAME = "ain:Quantity" THEN assign tt-gds-act.qnty = integer(hText:node-value) no-error . 
        IF hNoderef:NAME = "iab:Quantity" THEN assign tt-gds-act.A-qnty = integer(hText:node-value) no-error .
        IF hNoderef:NAME = "iab:BottlingDate" THEN assign tt-gds-act.A-bottleDate = date(substring(hText:node-value, 9, 2) + "/" + substring(hText:node-value, 6, 2) + "/" + substring(hText:node-value, 1, 4)) no-error . 
        IF hNoderef:NAME = "iab:TTNNumber" THEN assign tt-gds-act.A-ttnNumber = hText:node-value no-error .
        IF hNoderef:NAME = "iab:TTNDate" THEN assign tt-gds-act.A-ttnDate = date(substring(hText:node-value, 9, 2) + "/" + substring(hText:node-value, 6, 2) + "/" + substring(hText:node-value, 1, 4)) no-error .
        IF hNoderef:NAME = "iab:EGAISFixNumber" THEN assign tt-gds-act.A-fixNumber = hText:node-value no-error . 
        IF hNoderef:NAME = "iab:EGAISFixDate" THEN assign tt-gds-act.A-fixDate = date(substring(hText:node-value, 9, 2) + "/" + substring(hText:node-value, 6, 2) + "/" + substring(hText:node-value, 1, 4)) no-error .
        
        find first buf_parts no-lock where buf_parts.cst-code = tt-gds-act.A-ttnNumber
                                       and buf_parts.artic = buf_goods.artic
                                        and buf_parts.prod-type = buf_goods.prod-type
                                        and buf_parts.prod-code = buf_goods.prod-code
                                        and buf_parts.obj-type = v-cntxt-obj-type
                                        and buf_parts.obj-code = v-cntxt-obj-code
                                        and buf_parts.out-code = {&free-code}
                                        no-error .
        if available buf_parts then do :
            assign
                tt-gds-act.part-code = buf_parts.part-code
                tt-gds-act.doc-code  = buf_parts.in-code    
            .
        end.
        else do :
            find first ub.doc-attr no-lock where ub.doc-attr.attr-code = {&trdcattr-nids} and ub.doc-attr.attr-value = tt-gds-act.A-ttnNumber no-error .
            if available ub.doc-attr then do :
                assign tt-gds-act.doc-code = ub.doc-attr.doc-code .    
            end.
            else do :
                find first buf_trn-doc no-lock where buf_trn-doc.doc-code = tt-gds-act.A-ttnNumber no-error .
                if available buf_trn-doc then do :
                    assign tt-gds-act.doc-code = buf_trn-doc.doc-code .    
                end.
            end.
        end.    
            
        IF hNoderef:NAME = "ain:MarkCode" THEN do :
            create tt-marks.
            assign
                tt-marks.num                    = tt-gds-act.num
                tt-marks.gds-part-position_     = tt-gds-act.position_
                tt-marks.mark                   = hText:node-value
                ii = ii + 1.
            . 
            assign tt-gds-act.marks-qnty = ii .   
        end.
             
        run GetChildren (hNoderef, (level + 1)).
        
    END.
    
    DELETE OBJECT hNoderef.
    DELETE OBJECT hText.
END procedure.

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
/*  DISPLAY                     */
/*      WITH FRAME Dialog-Frame.*/
  ENABLE b-cancel b-marks b-save br-gds-act b-del
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  
    if p-mode = {&lookup} then do :
        disable  tt-act-header.num tt-act-header.date_ with frame {&FRAME-NAME}.
        define variable hCol as handle no-undo .
        define variable hBr  as handle no-undo .
        define variable i    as integer no-undo .
        hBr = browse br-gds-act:handle .
        do i = 6 to 12 :
            hCol = hBr:GET-BROWSE-COLUMN(i). 
            hCol:read-only = true .   
        end.
        
        hide b-good b-marks b-save b-del in FRAME {&FRAME-NAME}.
    end.
    
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

