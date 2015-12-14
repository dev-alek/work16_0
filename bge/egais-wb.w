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

Список накладных ЕГАИС

  Author: 
    Автор: Морозов Александр Сергеевич
    Дата создания: 15/11/03
    Author: Alexandr Morozov
    Creation date: 15/11/03
 
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
define variable vss-revision               as character no-undo init "$Revision$":U .
define variable vss-author                 as character no-undo init "$Author$":U .
define variable vss-date                   as character no-undo init "$Date$":U .
define variable vss-workfile               as character no-undo init "$Workfile$":U .
define variable vss-archive                as character no-undo init "$Archive$":U .
define variable vss-description            as character no-undo init "Журнал запросов ЕГАИС".

define variable th-wb-egais                as handle    no-undo.
define variable gh-wb-egais                as handle    no-undo.
define variable bh-wb-gds-EG               as handle    no-undo.
define variable browse-hdl-wb-egais        as handle    no-undo.
define variable th-wb-egais-header         as handle    no-undo.
define variable gh-wb-egais-header         as handle    no-undo.
define variable bh-wb-gds-EG-header        as handle    no-undo.
define variable browse-hdl-wb-egais-header as handle    no-undo.
define variable bcol                       as handle    extent no-undo.
define variable v-db-num                   as integer   no-undo .
define variable v-user-id                  as character no-undo .
define variable v-user-select              as character no-undo .
define variable v-select-obj-type          as character no-undo .
define variable v-select-obj-code          as integer   no-undo .
define variable v-obj-uniq-key-rec         as character no-undo .
define variable v-gds-uniq-key-rec         as character no-undo .
define variable v-ext-sys                  as integer   no-undo .
define variable v-rid                      as recid     no-undo .
define variable v-identity                 as character no-undo .

define buffer buf_clients   for ub.clients .
define buffer x_ext-classif for ub.ext-classif.
define buffer buf_goods     for ub.goods .


{cmp/str-glbl.i}
{ gbl/color.i }
{ cmp/library.i  }
{ gbl/getcntxt.i def }
{ ref/extclass.i }
{ gbl/key-rec.i  }
{ gbl/thbjattr.i }
{ ref/gds-attr.i }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_Cancel btn_conn F-ship f-cons 
&Scoped-Define DISPLAYED-OBJECTS F-ship f-cons 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 b-choose-ship b-choose-cons 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-choose-cons 
  IMAGE-UP FILE "btn-down-arrow":U
  IMAGE-DOWN FILE "btn-down-arrow":U
  IMAGE-INSENSITIVE FILE "btn-down-arrow":U
  LABEL "b-choose-date-pov-plotn" 
  SIZE 3 BY 1.

DEFINE BUTTON b-choose-ship 
  IMAGE-UP FILE "btn-down-arrow":U
  IMAGE-DOWN FILE "btn-down-arrow":U
  IMAGE-INSENSITIVE FILE "btn-down-arrow":U
  LABEL "b-choose-ship" 
  SIZE 3 BY 1.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
  LABEL "Выход" 
  SIZE 15 BY 1.13
  BGCOLOR 8 .

DEFINE BUTTON btn_conn 
  LABEL "Связать" 
  SIZE 15 BY 1.13.

DEFINE VARIABLE f-cons AS CHARACTER FORMAT "X(256)":U 
  LABEL "Объект" 
  VIEW-AS FILL-IN 
  SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE F-ship AS CHARACTER FORMAT "X(256)":U 
  LABEL "Контрагент" 
  VIEW-AS FILL-IN 
  SIZE 14 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
  Btn_Cancel AT ROW 1.25 COL 2
  btn_conn AT ROW 1.25 COL 18.5 WIDGET-ID 78
  b-choose-ship AT ROW 1.25 COL 61 WIDGET-ID 76
  F-ship AT ROW 1.29 COL 44.5 COLON-ALIGNED WIDGET-ID 2
  f-cons AT ROW 1.29 COL 72.38 COLON-ALIGNED WIDGET-ID 4
  b-choose-cons AT ROW 1.29 COL 89.5 WIDGET-ID 74
  SPACE(29.00) SKIP(25.28)
  WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
  SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
  TITLE "Накладная ЕГАИС"
  CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


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
  FRAME Dialog-Frame:SCROLLABLE = FALSE
  FRAME Dialog-Frame:HIDDEN     = TRUE.

/* SETTINGS FOR BUTTON b-choose-cons IN FRAME Dialog-Frame
   NO-ENABLE 1                                                          */
ASSIGN 
  b-choose-cons:HIDDEN IN FRAME Dialog-Frame = TRUE.

/* SETTINGS FOR BUTTON b-choose-ship IN FRAME Dialog-Frame
   NO-ENABLE 1                                                          */
ASSIGN 
  b-choose-ship:HIDDEN IN FRAME Dialog-Frame = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON window-close OF FRAME Dialog-Frame /* Накладная ЕГАИС */
  do:
    apply "END-ERROR":U to self.
  end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-choose-cons
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-choose-cons Dialog-Frame
ON CHOOSE OF b-choose-cons IN FRAME Dialog-Frame /* b-choose-date-pov-plotn */
  DO:

    run gbl/userobjs.w (
      input parparentproc /* parparentproc        */
      , input this-procedure :handle  /* p-callback-handle    */
      , input v-db-num                /* p-db-num             */
      , input v-user-id               /* p-user-id            */
      , input v-cntxt-host-code-obj   /* p-curr-host-code-obj */
      , input v-cntxt-obj-type        /* p-curr-obj-type      */
      , input v-cntxt-obj-code        /* p-curr-obj-code      */
      , input 'b-sel'
      , output v-user-select          /* p-user-select        */
      , output v-select-obj-type      /* p-select-obj-type    */
      , output v-select-obj-code      /* p-select-obj-code    */
      ) no-error.
    find first buf_clients no-lock where buf_clients.obj-type = v-select-obj-type and buf_clients.obj-code = v-select-obj-code .
    if not available (buf_clients) 
      then return no-apply.
    run gen-key-rec in this-procedure   ( input {&table_clients}
      ,input buffer buf_clients:handle
      ,output v-obj-uniq-key-rec).
    find first X_ext-classif exclusive-lock  where X_ext-classif.classif-subject = {&table_clients}
      and X_ext-classif.classif-name = {&extclass_clients_esys}
      and X_ext-classif.db-num = 0
      and X_ext-classif.key#_one = v-ext-sys
      and X_eXt-classif.uniq-key-rec = v-obj-uniq-key-rec
      no-error.
    if available X_ext-classif then 
    do :
      assign 
        X_ext-classif.charkey_three = bh-wb-gds-EG-header:buffer-field ("regID-cons"):buffer-value .
    end.
    else 
    do :
      run ref/extclas1.p ( input {&add-def}
        ,input yes /*p-silent*/
        ,input-output v-rid
        ,input {&table_clients} /*p-classif-subject*/
        ,input {&extclass_clients_esys} /*p-classif-name*/
        ,input 0 /*p-db-num*/
        ,input v-ext-sys  /*p-key#_one*/
        ,input 0 /*p-Key#_Two*/
        ,input 0 /*p-key#_Three*/
        ,input '':U  /*p-CharKey_One */
        ,input '':U /*p-CharKey_two */
        ,input bh-wb-gds-EG-header:buffer-field ("regID-cons"):buffer-value /*p-CharKey_three */
        ,input 0 /*p-nonunique */
        ,input v-obj-uniq-key-rec ) no-error.
      if error-status:error then 
      do:
        message return-value " " error-status:get-message(1) view-as alert-box .
        undo, return no-apply .
      end.
    end.
    bh-wb-gds-EG-header = egais:GetHndlTable(1, v-identity).
    gh-wb-egais-header:set-buffers (bh-wb-gds-EG-header).
    gh-wb-egais-header:query-prepare ("for each tt-wb-header").
    gh-wb-egais-header:query-open.

    run refresh-view.

  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-choose-ship
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-choose-ship Dialog-Frame
ON CHOOSE OF b-choose-ship IN FRAME Dialog-Frame /* b-choose-ship */
  DO:

    def var v-rid-list as character no-undo.
  
    run ref/cli-all.w (
      input parparentproc
      ,input "b-sel"
      ,input {&g___object}
      ,input {&all}
      ,input {&current}
      ,input ?
      ,input ",,,,,,NO,,"
      ,input "lock-cli-type"
      ,output v-rid-list ) no-error.
    if v-rid-list = '':U then return no-apply.
    find first buf_clients no-lock where
      recid( buf_clients) = INTEGER( v-rid-list ) no-error.
    if not available buf_clients then 
    do:
      return no-apply.
    end.

    run gen-key-rec in this-procedure   ( input {&table_clients}
      ,input buffer buf_clients:handle
      ,output v-obj-uniq-key-rec).
    find first X_ext-classif exclusive-lock  where X_ext-classif.classif-subject = {&table_clients}
      and X_ext-classif.classif-name = {&extclass_clients_esys}
      and X_ext-classif.db-num = 0
      and X_ext-classif.key#_one = v-ext-sys
      and X_eXt-classif.uniq-key-rec = v-obj-uniq-key-rec
      no-error.
    if available X_ext-classif then 
    do :
      assign 
        X_ext-classif.charkey_three = bh-wb-gds-EG-header:buffer-field ("regID-ship"):buffer-value .
    end.
    else 
    do :
      run ref/extclas1.p ( input {&add-def}
        ,input yes /*p-silent*/
        ,input-output v-rid
        ,input {&table_clients} /*p-classif-subject*/
        ,input {&extclass_clients_esys} /*p-classif-name*/
        ,input 0 /*p-db-num*/
        ,input v-ext-sys  /*p-key#_one*/
        ,input 0 /*p-Key#_Two*/
        ,input 0 /*p-key#_Three*/
        ,input '':U  /*p-CharKey_One */
        ,input '':U /*p-CharKey_two */
        ,input bh-wb-gds-EG-header:buffer-field ("regID-ship"):buffer-value /*p-CharKey_three */
        ,input 0 /*p-nonunique */
        ,input v-obj-uniq-key-rec ) no-error.
      if error-status:error then 
      do:
        message return-value " " error-status:get-message(1) view-as alert-box .
        undo, return no-apply .
      end.
    end.
    bh-wb-gds-EG-header = egais:GetHndlTable(1, v-identity).
    gh-wb-egais-header:set-buffers (bh-wb-gds-EG-header).
    gh-wb-egais-header:query-prepare ("for each tt-wb-header").
    gh-wb-egais-header:query-open.

    run refresh-view.

  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_conn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_conn Dialog-Frame
ON CHOOSE OF btn_conn IN FRAME Dialog-Frame /* Связать */
  DO:
  
    if bh-wb-gds-EG = ?
      then 
    do:
      message "Не выбран товар" view-as alert-box.
      return no-apply.
    end.
    run msdblcl.
  
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
if valid-handle(active-window) and frame {&FRAME-NAME}:PARENT eq ?
  then frame {&FRAME-NAME}:PARENT = active-window.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
do on error   undo MAIN-BLOCK, leave MAIN-BLOCK
  on end-key undo MAIN-BLOCK, leave MAIN-BLOCK:

  def var ii as int no-undo.

  { gbl/getcurus.i
    v-db-num
    v-user-id
    no-error
  }
  { gbl/getcntxt.i get }

  find first ub.ext-system where ub.ext-system.whole-send-news = integer ({&esys-dm-egais}).
  
  assign 
    v-ext-sys = ub.ext-system.esys-id .  
  
  create browse browse-hdl-wb-egais-header
    assign 
    title     = 'Накладная ЕГАИС'
    frame     = frame {&FRAME-NAME}:handle
    query     = gh-wb-egais
    x         = 10
    y         = 42
    width     = 119
    height    = 5
    visible   = true
    read-only = true
    sensitive = true
    separators = true
    column-resizable = true
    .
  
  create browse browse-hdl-wb-egais
    assign 
    title     = 'Список товаров ЕГАИС'
    frame     = frame {&FRAME-NAME}:handle
    query     = gh-wb-egais
    x         = 10
    y         = 102
    width     = 119
    height    = 22
    visible   = true
    read-only = true
    sensitive = true
    separators = true
    column-resizable = true
    triggers:
      on mouse-move-dblclick persistent run msdblcl.
      on row-display persistent run proc-row-leave.
    end triggers
      .



  
  bh-wb-gds-EG = egais:GetHndlTable(2, bh-wb-egais:buffer-field ("Identity"):buffer-value).

  create query gh-wb-egais.
  gh-wb-egais:set-buffers (bh-wb-gds-EG).
  gh-wb-egais:query-prepare ("for each tt-wb-gds-EG").
  gh-wb-egais:query-open.

  browse-hdl-wb-egais:query = gh-wb-egais.

  extent (bcol) = bh-wb-gds-EG:num-fields.
  do ii = 1 to bh-wb-gds-EG:num-fields:
    bcol[ii] = browse-hdl-wb-egais:add-like-column('tt-wb-gds-EG' + '.' + bh-wb-gds-EG:buffer-field (ii):name, 0, 'FILL-IN').
  end.
  
  bh-wb-gds-EG-header = egais:GetHndlTable(1, bh-wb-egais:buffer-field ("Identity"):buffer-value).
  create query gh-wb-egais-header.
  gh-wb-egais-header:set-buffers (bh-wb-gds-EG-header).
  gh-wb-egais-header:query-prepare ("for each tt-wb-header").
  gh-wb-egais-header:query-open.

  browse-hdl-wb-egais-header:query = gh-wb-egais-header.

  do ii = 1 to 9 /*bh-wb-gds-EG-header:num-fields*/ :
    browse-hdl-wb-egais-header:add-like-column('tt-wb-header' + '.' + bh-wb-gds-EG-header:buffer-field (ii):name, 0, 'FILL-IN').
  end.
  run enable_UI.  
  bh-wb-gds-EG:find-first ("", no-lock) no-error.
  run refresh-view.
  
  v-identity = bh-wb-egais:buffer-field ("Identity"):buffer-value.
  
  wait-for go of frame {&FRAME-NAME}.
end.
run disable_UI.

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
  DISPLAY F-ship f-cons 
    WITH FRAME Dialog-Frame.
  ENABLE Btn_Cancel btn_conn F-ship f-cons 
    WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE msdblcl Dialog-Frame 
PROCEDURE msdblcl :
  def    var      v-rid-list  as character no-undo.
  define variable par-alcohol as character no-undo .
  define variable par-type    as character no-undo .
  
  if bh-wb-gds-EG:buffer-field ("gds-code"):buffer-value <> "" and bh-wb-gds-EG:buffer-field ("gds-code"):buffer-value <> ?
    then 
  do:
    message "Товар уже имеет связку" view-as alert-box.
    return no-apply.
  end.
  
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
  if available X_ext-classif then 
  do :
    message substitute ("Товар &1 уже связан", buf_goods.gds-code) view-as alert-box.  
    /*assign 
      X_ext-classif.charkey_one = bh-wb-gds-EG:buffer-field ("alc-code"):buffer-value .*/
  end.                                    
  else 
  do :                                    
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
      ,input bh-wb-gds-EG:buffer-field ("alc-code"):buffer-value /*p-CharKey_One */
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

  bh-wb-gds-EG = egais:GetHndlTable(2, v-identity).
  create query gh-wb-egais.
  gh-wb-egais:set-buffers (bh-wb-gds-EG).
  gh-wb-egais:query-prepare ("for each tt-wb-gds-EG").
  gh-wb-egais:query-open.

  run refresh-view.

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refresh-view Dialog-Frame 
PROCEDURE refresh-view :

  f-cons = bh-wb-gds-EG-header:buffer-field ("clientCons"):buffer-value.
  f-ship = bh-wb-gds-EG-header:buffer-field ("client"):buffer-value.
  display Btn_Cancel b-choose-cons b-choose-ship btn_conn f-cons F-ship with frame Dialog-Frame.
  ENABLE Btn_Cancel b-choose-cons b-choose-ship btn_conn
    WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  bh-wb-gds-EG:find-first ().
  if bh-wb-gds-EG-header:buffer-field ("client"):buffer-value <> "" 
    then disable b-choose-ship with frame Dialog-Frame.
  if bh-wb-gds-EG-header:buffer-field ("clientCons"):buffer-value <> "" 
    then disable b-choose-cons with frame Dialog-Frame.
  browse-hdl-wb-egais:refresh ().
  browse-hdl-wb-egais-header:refresh ().
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-row-leave Dialog-Frame 
PROCEDURE proc-row-leave :
  
  def var ii as int no-undo.
  
  if bh-wb-gds-EG:buffer-field ("gds-code"):buffer-value = "" or bh-wb-gds-EG:buffer-field ("gds-code"):buffer-value = ? then 
  do:
    do ii = 1 to extent (bcol):  
      if valid-handle (bcol[ii]) 
        then bcol[ii]:bgcolor = RED_COLOR.
    end.
  end.
end.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME