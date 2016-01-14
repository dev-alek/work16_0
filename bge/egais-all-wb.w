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
/* Local Variable Definitions ---                                       */
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Журнал запросов ЕГАИС".

define variable th-wb-egais         as handle    no-undo.
define variable bh-wb-egais         as handle    no-undo.
define variable qh-wb-egais         as handle    no-undo.
define variable browse-hdl-wb-egais as handle    no-undo.
define variable bcol                as handle    extent 11 no-undo.
define variable egais               as class     EGAIS no-undo.
define variable v-db-num            as integer   no-undo .
define variable v-user-id           as character no-undo .
define variable qh-wb-gds-EG-header as handle    no-undo.
define variable qh-wb-gds-EG        as handle    no-undo.
define variable bh-wb-gds-EG-header as handle    no-undo.
define variable bh-wb-gds-EG        as handle    no-undo.

define variable v-value-character   as character no-undo .
define variable v-value-decimal     as decimal   no-undo .
define variable v-value-integer     as integer   no-undo .
define variable v-value-logical     as logical   no-undo .
define variable v-value-type        as character no-undo .
define variable v-value-date        as date      no-undo .
define variable v-ext-sys           as integer   no-undo .

define variable v-fs-rar as character no-undo view-as text format "X(15)" label "Код ФС РАР (FSRAR ID)" .

{ gbl/color.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ gbl/getcntxt.i def }
{ gbl/getcntxt.i get }
{ gbl/thbjattr.i }
{ibs/th/bge/egais/wb-egais.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Sel Btn_Save Btn_dnlw Btn_Del ~
RADIO-SET-1 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Del 
     LABEL "Отказ" 
     SIZE 7.5 BY 1.13.

DEFINE BUTTON Btn_dnlw 
     LABEL "Загрузить" 
     SIZE 15 BY 1.13.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Выход" 
     SIZE 15 BY 1.13
     BGCOLOR 8 .

DEFINE BUTTON Btn_Save 
     LABEL "Сохранить" 
     SIZE 15 BY 1.13
     BGCOLOR 8 .

DEFINE BUTTON Btn_Sel 
     LABEL "Изменить" 
     SIZE 15 BY 1.13
     BGCOLOR 8 .

DEFINE VARIABLE RADIO-SET-1 AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Полученные", 1,
"Закрытые на факт", 2,
"Акты", 3
     SIZE 40 BY 1.25 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     Btn_OK AT ROW 1.21 COL 2.63
     Btn_Sel AT ROW 1.21 COL 18.63 WIDGET-ID 6
     Btn_Save AT ROW 1.21 COL 34.38 WIDGET-ID 10
     Btn_dnlw AT ROW 1.21 COL 50 WIDGET-ID 12
     Btn_Del AT ROW 1.21 COL 65.5 WIDGET-ID 14
     RADIO-SET-1 AT ROW 1.21 COL 80.38 NO-LABEL WIDGET-ID 2
     SPACE(1.24) SKIP(25.27)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Накладные/акты ЕГАИС"
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

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON window-close OF FRAME Dialog-Frame /* Накладные/акты ЕГАИС */
do:
  apply "END-ERROR":U to self.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Del Dialog-Frame
ON CHOOSE OF Btn_Del IN FRAME Dialog-Frame /* - */
DO:
  if bh-wb-egais = ? 
    then return no-apply.
  if can-find (first ub.trn-doc where ub.trn-doc.doc-code = bh-wb-egais:buffer-field ("trn-doc-code"):buffer-value)
  then do:
    message substitute ( "Накладная с № &1 уже сформирована, нельзя отправить отказ", bh-wb-egais:buffer-field ("trn-doc-code"):buffer-value)
    view-as alert-box.
     return no-apply.
  end.
  egais:RejectWB(bh-wb-egais:buffer-field ("uniq-key-rec"):buffer-value).
  run refresh-query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_dnlw
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_dnlw Dialog-Frame
ON CHOOSE OF Btn_dnlw IN FRAME Dialog-Frame /* Загрузить */
DO:
  egais:GetHndlTable(?, "AllWB").
  if egais:StatusErr 
  then do:
    message "Ошибка: " egais:Msg view-as alert-box error.
  end.
  run refresh-query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Save
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Save Dialog-Frame
ON CHOOSE OF Btn_Save IN FRAME Dialog-Frame /* Сохранить */
DO:
  if bh-wb-egais = ? 
    then return no-apply.
  
  if RADIO-SET-1 = 1 
    then do:
    if can-find (first ub.trn-doc where ub.trn-doc.doc-code = bh-wb-egais:buffer-field ("trn-doc-code"):buffer-value)
    then do:
      message substitute ( "Накладная с № &1 уже сформирована", bh-wb-egais:buffer-field ("trn-doc-code"):buffer-value)
      view-as alert-box.
       return no-apply.
    end.
    bh-wb-gds-EG = ?.
    bh-wb-gds-EG-header = ?.
    bh-wb-gds-EG = egais:GetHndlTable(2, bh-wb-egais:buffer-field ("uniq-key-rec"):buffer-value).  
    bh-wb-gds-EG-header = egais:GetHndlTable(1, bh-wb-egais:buffer-field ("uniq-key-rec"):buffer-value).
    find first ub.clients 
      where ub.clients.obj-type = bh-wb-gds-EG-header:buffer-field ("cli-type"):buffer-value
        and ub.clients.obj-code = integer (bh-wb-gds-EG-header:buffer-field ("cli-code"):buffer-value) no-error.
    if not available (ub.clients)
    then do:
      message "Не найден клиент TH для EGAIS контрагентa regID: " + bh-wb-gds-EG-header:buffer-field ('regId-Ship'):buffer-value view-as alert-box.
      return no-apply.
    end.
    find first ub.clients 
      where ub.clients.obj-type = bh-wb-gds-EG-header:buffer-field ("obj-type"):buffer-value
        and ub.clients.obj-code = integer (bh-wb-gds-EG-header:buffer-field ("obj-code"):buffer-value) no-error.
    if not available (ub.clients)
    then do:
      message "Не найден объект TH для EGAIS получателя regID: " + bh-wb-gds-EG-header:buffer-field ('regId-Cons'):buffer-value view-as alert-box.
      return no-apply.
    end.
    bh-wb-gds-EG:find-first ("where tt-wb-gds-EG.gds-code = ?", no-lock) no-error.
    if bh-wb-gds-EG:available then do:
      message "Не найден товар TH для EGAIS товара AlcCode: " + bh-wb-gds-EG:buffer-field ('alc-code'):buffer-value view-as alert-box.
      return no-apply.
    end.
    
    egais:SaveWB(bh-wb-egais:buffer-field ("uniq-key-rec"):buffer-value).
    if egais:StatusErr
      then message egais:Msg view-as alert-box error.
      else message "Создание накладной завершено" view-as alert-box.
    run refresh-query.
  end.
  else do:
    bh-wb-gds-EG = ?.
    bh-wb-gds-EG-header = ?.
    bh-wb-gds-EG-header = egais:GetHndlTable(1, bh-wb-egais:buffer-field ("uniq-key-rec"):buffer-value).
    if egais:StatusErr
    then do:
      message egais:Msg view-as alert-box error.
      return no-apply.
    end.
    egais:SendRequestUTM().
    if egais:StatusErr
      then message egais:Msg view-as alert-box error.
      else message "Накладная отправлена" view-as alert-box.
    
  end.
  run refresh-query.
    
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Sel Dialog-Frame
ON CHOOSE OF Btn_Sel IN FRAME Dialog-Frame /* Изменить */
DO:
  if bh-wb-egais = ? 
    then return no-apply.
  if RADIO-SET-1 = 1 then run bge/egais-wb.w (parparentproc, egais, bh-wb-egais:handle).
  else run bge/egais-wb-act.w (parparentproc, egais, bh-wb-egais:handle).
  run refresh-query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-1 Dialog-Frame
ON value-changed OF RADIO-SET-1 IN FRAME Dialog-Frame
do:
  assign RADIO-SET-1 .
  if RADIO-SET-1 = 1
  then do:
    Btn_Save:label = "Сохранить".
    Btn_Del:hidden = false.
  end.
  else do:
    Btn_Save:label = "Отправить".
    Btn_Del:hidden = true.
  end.
  if RADIO-SET-1 = 3
  then disable Btn_Save with frame {&FRAME-NAME}.
  else enable Btn_Save with frame {&FRAME-NAME}.
  run refresh-query.
end.

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
  def var glog as  log no-undo.
  
  { gbl/getcurus.i
    v-db-num
    v-user-id
    no-error
  }
  { gbl/chk-actg.i
    v-cntxt-db-num
    v-cntxt-userid
    {&action-head-code-main}
    'actn_egais-ref':U
    {&cntxt-object}
    v-cntxt-host-code-obj
    v-cntxt-obj-type
    v-cntxt-obj-code
    0
    0
    0
    true
    glog
  }
  
  if not glog then  return .

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
    v-fs-rar = v-value-character 
  .
  
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
  
  egais = new EGAIS(v-db-num, v-user-id).
  
  egais:EGAISImpl = new WayBill (v-cntxt-obj-type, v-cntxt-obj-code, v-fs-rar, v-ext-sys).
  create query qh-wb-egais.
  create browse browse-hdl-wb-egais
    assign 
      title     = 'Накладные ЕГАИС'
      frame     = frame {&FRAME-NAME}:handle
      query     = qh-wb-egais
      x         = 10
      y         = 42
      width     = 119
      height    = 25
      visible   = true
      read-only = true
      sensitive = true
      separators = true
      column-resizable = true
      column-scrolling = true
      triggers:
        on mouse-move-dblclick persistent run msdblcl.
/*        on row-leave persistent run proc-row-leave.*/
      end triggers
  .
  bh-wb-egais = egais:GetHndlTable({&wb-clob}, "").
  qh-wb-egais:set-buffers (bh-wb-egais).
  qh-wb-egais:query-prepare ("for each tt-wb-hndls").
  qh-wb-egais:query-open.
  if not bh-wb-egais = ? 
  then do:
    do ii = 1 to bh-wb-egais:num-fields:
      bcol[ii] = browse-hdl-wb-egais:add-like-column('tt-wb-hndls' + '.' + bh-wb-egais:buffer-field (ii):name, 0, 'FILL-IN').
    end.
  end.
  { gbl/diasize.i &br-hndl=browse-hdl-wb-egais }
  run diasize_init in this-procedure .
  run enable_UI.  

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
  DISPLAY RADIO-SET-1 
      WITH FRAME Dialog-Frame.
  ENABLE Btn_OK Btn_Sel Btn_Save Btn_dnlw Btn_Del RADIO-SET-1 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE msdblcl Dialog-Frame 
PROCEDURE msdblcl :
if RADIO-SET-1 <> 1 and RADIO-SET-1 <> 3  
    then apply "choose" to Btn_Save in frame {&frame-name} .
    else apply "choose" to Btn_Sel in frame {&frame-name} .

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-row-leave Dialog-Frame 
PROCEDURE proc-row-leave :
if false then do:
    do ii = 1 to extent (bcol).  
      bcol[ii]:bgcolor = RED_COLOR.
    end.
  end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refresh-query Dialog-Frame 
PROCEDURE refresh-query :
if bh-wb-egais = ? 
    then return .

  case RADIO-SET-1 :
    when 1  then 
    do:
      delete object browse-hdl-wb-egais.
      create browse browse-hdl-wb-egais
        assign 
          title     = 'Накладные ЕГАИС'
          frame     = frame {&FRAME-NAME}:handle
          query     = qh-wb-egais
          x         = 10
          y         = 42
          width     = 119
          height    = 25
          visible   = true
          read-only = true
          sensitive = true
          separators = true
          column-resizable = true
          column-scrolling = true
          triggers:
            on mouse-move-dblclick persistent run msdblcl.
          end triggers
      .
      bh-wb-egais = egais:GetHndlTable({&wb-clob}, "").
      qh-wb-egais:set-buffers (bh-wb-egais).
      qh-wb-egais:query-prepare ("for each tt-wb-hndls").
      qh-wb-egais:query-open.
      if not bh-wb-egais = ? 
      then do:
        do ii = 1 to bh-wb-egais:num-fields:
          bcol[ii] = browse-hdl-wb-egais:add-like-column('tt-wb-hndls' + '.' + bh-wb-egais:buffer-field (ii):name, 0, 'FILL-IN').
        end.
      end.
      run diasize_init in this-procedure .
      enable Btn_Sel with frame {&FRAME-NAME}.
    end.
    when 2  then 
    do:
      delete object browse-hdl-wb-egais.
      create browse browse-hdl-wb-egais
        assign 
          title     = 'Накладные ЕГАИС'
          frame     = frame {&FRAME-NAME}:handle
          query     = qh-wb-egais
          x         = 10
          y         = 42
          width     = 119
          height    = 25
          visible   = true
          read-only = true
          sensitive = true
          separators = true
          column-resizable = true
          column-scrolling = true
          triggers:
            on mouse-move-dblclick persistent run msdblcl.
          end triggers
      .
      bh-wb-egais = egais:GetHndlTable({&wb-fact}, "").
      qh-wb-egais:set-buffers (bh-wb-egais).
      qh-wb-egais:query-prepare ("for each tt-wb-hndls").
      qh-wb-egais:query-open.
      if not bh-wb-egais = ? 
      then do:
        do ii = 1 to bh-wb-egais:num-fields:
          bcol[ii] = browse-hdl-wb-egais:add-like-column('tt-wb-hndls' + '.' + bh-wb-egais:buffer-field (ii):name, 0, 'FILL-IN').
        end.
      end.
      run diasize_init in this-procedure .
      disable Btn_Sel with frame {&FRAME-NAME}.
    end.
    when 3  then 
    do:
      delete object browse-hdl-wb-egais.
      create browse browse-hdl-wb-egais
        assign 
          title     = 'Акты ЕГАИС'
          frame     = frame {&FRAME-NAME}:handle
          query     = qh-wb-egais
          x         = 10
          y         = 42
          width     = 119
          height    = 25
          visible   = true
          read-only = true
          sensitive = true
          separators = true
          column-resizable = true
          column-scrolling = true
          triggers:
            on mouse-move-dblclick persistent run msdblcl.
          end triggers
      .
      bh-wb-egais = egais:GetHndlTable({&wb-clob-act}, "").
      qh-wb-egais:set-buffers (bh-wb-egais).
      qh-wb-egais:query-prepare ("for each tt-wb-act-hndls").
      qh-wb-egais:query-open.
      if not bh-wb-egais = ? 
      then do:
        do ii = 1 to bh-wb-egais:num-fields:
          bcol[ii] = browse-hdl-wb-egais:add-like-column('tt-wb-act-hndls' + '.' + bh-wb-egais:buffer-field (ii):name, 0, 'FILL-IN').
        end.
      end.
      run diasize_init in this-procedure .
      disable Btn_Sel with frame {&FRAME-NAME}.
    end.
    /*when 4  then 
    do:
      bh-wb-egais = egais:GetHndlTable({&wb-ras}, "").
      qh-wb-egais:set-buffers (bh-wb-egais).
      qh-wb-egais:query-prepare ("for each tt-wb-hndls").
      qh-wb-egais:query-open.
      disable Btn_Sel with frame {&FRAME-NAME}.
    end.*/
  end.

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

