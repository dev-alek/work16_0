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

Справочник товаров ЕГАИС.

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
define variable vss-revision               as character no-undo init "$Revision$":U .
define variable vss-author                 as character no-undo init "$Author$":U .
define variable vss-date                   as character no-undo init "$Date$":U .
define variable vss-workfile               as character no-undo init "$Workfile$":U .
define variable vss-archive                as character no-undo init "$Archive$":U .
define variable vss-description            as character no-undo init "Справочник товаров ЕГАИС.".

define variable bh-egais-goods       as handle    no-undo.
define variable browse-hdl-egais-goods  as handle    no-undo.
define variable qh-egais-goods          as handle    no-undo.
define variable bcol               as handle    no-undo extent. 
define variable v-db-num           as integer   no-undo .
define variable v-user-id          as character no-undo .
define variable v-user-select      as character no-undo .
define variable v-select-obj-type  as character no-undo .
define variable v-select-obj-code  as integer   no-undo .
define variable v-obj-uniq-key-rec as character no-undo .
define variable v-gds-uniq-key-rec as character no-undo .
define variable v-ext-sys          as integer   no-undo .
define variable v-fs-rar           as character no-undo. 
define variable extGdsObj          as class     ExtGds no-undo .
define variable v-value-character  as character no-undo .
define variable v-value-decimal    as decimal   no-undo .
define variable v-value-integer    as integer   no-undo .
define variable v-value-logical    as logical   no-undo .
define variable v-value-type       as character no-undo .
define variable v-value-date       as date      no-undo .
define variable select-list        as character no-undo .
define variable v-rec-list         as character no-undo .
define variable isMarkALL          as logical   no-undo init ?.
define variable isSave             as logical   no-undo.

define buffer buf_clients   for ub.clients .
define buffer x_ext-classif for ub.ext-classif.
define buffer buf_goods     for ub.goods .

{cmp/str-glbl.i}
{ gbl/color.i }
{ cmp/library.i  }
{ gbl/getcntxt.i def }
{ gbl/getcntxt.i get }
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
&Scoped-Define ENABLED-OBJECTS Btn_Cancel btn_refresh btn_look btn_del ~
f-gds f-alcgds f-gdsname t-incorr 
&Scoped-Define DISPLAYED-OBJECTS f-gds f-alcgds f-gdsname t-incorr 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Выход" 
     SIZE 10 BY 1.13
     BGCOLOR 8 .

DEFINE BUTTON btn_del 
     LABEL "Удалить" 
     SIZE 15 BY 1.13.

DEFINE BUTTON btn_look 
     LABEL "Просмотр" 
     SIZE 15 BY 1.13.

DEFINE BUTTON btn_refresh 
     LABEL "Обновить" 
     SIZE 15 BY 1.13.

DEFINE VARIABLE f-alcgds AS CHARACTER FORMAT "X(256)":U 
     LABEL "Алк. код товара" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE f-gds AS CHARACTER FORMAT "X(256)":U 
     LABEL "Код товара" 
     VIEW-AS FILL-IN 
     SIZE 15.13 BY 1 NO-UNDO.

DEFINE VARIABLE f-gdsname AS CHARACTER FORMAT "X(256)":U 
     LABEL "Назв. товара" 
     VIEW-AS FILL-IN 
     SIZE 17.63 BY 1 NO-UNDO.

DEFINE VARIABLE t-incorr AS LOGICAL INITIAL no 
     LABEL "Некорр." 
     VIEW-AS TOGGLE-BOX
     SIZE 11.13 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     Btn_Cancel AT ROW 1.25 COL 2
     btn_refresh AT ROW 1.25 COL 12.5 WIDGET-ID 18
     btn_look AT ROW 1.25 COL 28 WIDGET-ID 14
     btn_del AT ROW 1.25 COL 43.75
     f-gds AT ROW 2.75 COL 12.38 COLON-ALIGNED WIDGET-ID 20
     f-alcgds AT ROW 2.75 COL 45.13 COLON-ALIGNED WIDGET-ID 22
     f-gdsname AT ROW 2.75 COL 75.25 COLON-ALIGNED WIDGET-ID 24
     t-incorr AT ROW 2.75 COL 95.75 WIDGET-ID 28
     SPACE(2.36) SKIP(22.16)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Справочник товаров ЕГАИС"
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
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

ASSIGN 
       btn_del:HIDDEN IN FRAME Dialog-Frame           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON window-close OF FRAME Dialog-Frame /* Справочник товаров ЕГАИС */
do:
    apply "END-ERROR":U to self.
  end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_del Dialog-Frame
ON choose OF btn_del IN FRAME Dialog-Frame /* Удалить */
do:

  def var cmd as char no-undo.
  def var qh-del as handle no-undo.
  run refresh-view.

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_look
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_look Dialog-Frame
ON choose OF btn_look IN FRAME Dialog-Frame /* Просмотр */
do:

  run msdblcl.
    
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_refresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_refresh Dialog-Frame
ON CHOOSE OF btn_refresh IN FRAME Dialog-Frame /* Обновить */
DO:
  extGdsObj:GetHndlTable(0, "", output bh-egais-goods).
  run refresh-view.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-alcgds
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-alcgds Dialog-Frame
ON leave OF f-alcgds IN FRAME Dialog-Frame /* Алк. код товара */
do:
  run refresh-view.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-alcgds Dialog-Frame
ON return OF f-alcgds IN FRAME Dialog-Frame /* Алк. код товара */
do:
  run refresh-view.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-gds
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-gds Dialog-Frame
ON leave OF f-gds IN FRAME Dialog-Frame /* Код товара */
do:
  run refresh-view.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-gds Dialog-Frame
ON return OF f-gds IN FRAME Dialog-Frame /* Код товара */
do:
  run refresh-view.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-gdsname
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-gdsname Dialog-Frame
ON leave OF f-gdsname IN FRAME Dialog-Frame /* Назв. товара */
do:
  run refresh-view.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-gdsname Dialog-Frame
ON return OF f-gdsname IN FRAME Dialog-Frame /* Назв. товара */
do:
  run refresh-view.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME t-incorr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t-incorr Dialog-Frame
ON VALUE-CHANGED OF t-incorr IN FRAME Dialog-Frame /* Некорр. */
DO:
  run refresh-view.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
if valid-handle(active-window) and frame {&FRAME-NAME}:PARENT eq ?
  then frame {&FRAME-NAME}:PARENT = active-window.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
do on error   undo MAIN-BLOCK, leave MAIN-BLOCK
  on end-key undo MAIN-BLOCK, leave MAIN-BLOCK:

  def var ii as int no-undo.
  def var v-windth as integer no-undo.
  def var v-isDisp as character no-undo. 

  { gbl/getcurus.i
    v-db-num
    v-user-id
    no-error
  }
  { gbl/getcntxt.i get }


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
      ,input-output TABLE thbjattr_thbj-attr
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
      ,input-output TABLE thbjattr_thbj-attr
      ) no-error .
  assign v-ext-sys = v-value-integer.   
  
  create browse browse-hdl-egais-goods
    assign 
    title     = 'Товары'
    frame     = frame {&FRAME-NAME}:handle
    query     = qh-egais-goods
    x         = 10
    y         = 70
    width     = 107
    height    = 21.5
    visible   = true
    read-only = true
    sensitive = true
    separators = true
    column-resizable = true
    triggers:
      on mouse-move-dblclick persistent run msdblcl.
      on row-display persistent run proc-row-disp.
    end triggers
    .

  extGdsObj = new ExtGds (yes).

  extGdsObj:DbNum = v-db-num.
/*  extGdsObj:User_Id = v-user-id.*/

  extGdsObj:GetHndlTable(0, "", output bh-egais-goods).
  
  create query qh-egais-goods.
  qh-egais-goods:set-buffers (bh-egais-goods).

  browse-hdl-egais-goods:query = qh-egais-goods.
  
  extent (bcol) = bh-egais-goods:num-fields.
  do ii = 1 to bh-egais-goods:num-fields:
    bcol[ii] = browse-hdl-egais-goods:add-like-column('tt-egaisgds-hndls' + '.' + bh-egais-goods:buffer-field (ii):name, 0, 'FILL-IN').
    if entry (ii, extGdsObj:SettingsTTList, ';') <> ""
    then do:
      v-windth = integer (entry (1, entry (ii, extGdsObj:SettingsTTList, ';'))).
      v-isDisp = entry (2, entry (ii, extGdsObj:SettingsTTList, ';')).
      assign
        bcol[ii]:width = v-windth when v-windth > 0
        bcol[ii]:visible = false when v-isDisp = "no"
      .
    end.
  end.
  { gbl/diasize.i &br-hndl=browse-hdl-egais-goods }
  run diasize_init in this-procedure .
  run enable_UI.
  run refresh-view.
  bh-egais-goods:find-first ("", no-lock) no-error.
ASSIGN 
       btn_del:HIDDEN IN FRAME Dialog-Frame           = TRUE.
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
  DISPLAY f-gds f-alcgds f-gdsname t-incorr 
      WITH FRAME Dialog-Frame.
  ENABLE Btn_Cancel btn_refresh btn_look btn_del f-gds f-alcgds f-gdsname 
         t-incorr 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE msdblcl Dialog-Frame 
PROCEDURE msdblcl :
define variable v-prod-full-name as character no-undo .
  define variable v-import-full-name as character no-undo .
  define variable v-gds-code as int no-undo .
  define variable v-gds-name as character no-undo .
  define variable v-alc-code as char no-undo.

  v-gds-code = bh-egais-goods:buffer-field ("gdsCode"):buffer-value.
  v-alc-code = bh-egais-goods:buffer-field ("alcCode"):buffer-value.

  if not bh-egais-goods:available 
    then return no-apply.

  run bge/egais-goods-mark.w ( 
                              input parparentproc, 
                              input {&lookup}, 
                              input-output v-alc-code, 
                              input-output v-gds-code, 
                              output v-gds-name, 
                              output v-prod-full-name, 
                              output v-import-full-name )  .  

  if bh-egais-goods:available
    then qh-egais-goods:reposition-to-rowid ( bh-egais-goods:rowid ).

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-row-disp Dialog-Frame 
PROCEDURE proc-row-disp :
def var ii as int no-undo.
  
  do ii = 1 to extent (bcol).  
    if valid-handle (bcol[ii]) 
      then 
        assign
          bcol[ii]:bgcolor = bh-egais-goods:buffer-field ("ColorNum"):buffer-value
        .
  end.
  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refresh-view Dialog-Frame 
PROCEDURE refresh-view :
def var v-proposition  as char no-undo.
  
  assign input frame {&FRAME-NAME}
    f-gds
    f-gdsname
    f-alcgds
    t-incorr
  .
 
  if f-gds <> ""
  then do:
    v-proposition = substitute ("string(gdsCode) matches '*&1*' and ", f-gds).
  end. 

  if f-alcgds <> ""
  then do:
    v-proposition = v-proposition + substitute ("alcCode matches '*&1*' and ", f-alcgds).
  end. 

  if f-gdsname <> ""
  then do:
    v-proposition = v-proposition + substitute ("gdsName matches '*&1*' and ", f-gdsname).
  end. 

  if t-incorr = true
  then do:
    v-proposition = v-proposition + substitute ("ColorNum <> ?").
  end. 

  v-proposition = right-trim (v-proposition, " and ").
  if v-proposition <> "" then v-proposition = "where " + v-proposition.
  
  display Btn_Cancel with frame Dialog-Frame.
  enable Btn_Cancel
    with frame Dialog-Frame.
  view frame Dialog-Frame.
  qh-egais-goods:query-close.
  qh-egais-goods:query-prepare ("for each tt-egaisgds-hndls " + v-proposition).
  qh-egais-goods:query-open.
  if qh-egais-goods:get-first () 
    then browse-hdl-egais-goods:refresh ().
  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

