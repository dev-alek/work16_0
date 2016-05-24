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

Список задвоиных записей.

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
define variable vss-description            as character no-undo init "Журнал запросов ЕГАИС".

define variable bh-wb-analiz       as handle    no-undo.
define variable browse-hdl-analiz  as handle    no-undo.
define variable qh-analiz          as handle    no-undo.
define variable bcolmark           as handle    no-undo.
define variable bcolnn             as handle    no-undo.
define variable bcol               as handle    no-undo. 
define variable v-db-num           as integer   no-undo .
define variable v-user-id          as character no-undo .
define variable v-user-select      as character no-undo .
define variable v-select-obj-type  as character no-undo .
define variable v-select-obj-code  as integer   no-undo .
define variable v-obj-uniq-key-rec as character no-undo .
define variable v-gds-uniq-key-rec as character no-undo .
define variable v-ext-sys          as integer   no-undo .
define variable v-fs-rar           as character no-undo. 
define variable v-rid              as recid     no-undo .
define variable v-uniq-key-rec     as character no-undo .
define variable url_               as character no-undo .
define variable AdmUtmObj          as class     admutm no-undo .
define variable v-value-character  as character no-undo .
define variable v-value-decimal    as decimal   no-undo .
define variable v-value-integer    as integer   no-undo .
define variable v-value-logical    as logical   no-undo .
define variable v-value-type       as character no-undo .
define variable select-list        as character no-undo .
define variable v-value-date       as date      no-undo .
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
&Scoped-Define ENABLED-OBJECTS Btn_Cancel btn_del btn_dwl btn_look Btn_mark ~
Btn_markall Btn_desmark f_date 
&Scoped-Define DISPLAYED-OBJECTS f_date 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
define button Btn_Cancel auto-end-key 
     label "Выход" 
     size 15 by 1.13
     bgcolor 8 .

define button btn_del 
     label "Удалить" 
     size 15 by 1.13 tooltip "Безвозвратное удаления записи с УТМ".

define button Btn_desmark 
     label "-" 
     size 3.5 by 1.13.

define button btn_dwl 
     label "Загрузить" 
     size 15 by 1.13.

define button btn_look 
     label "Просмотр" 
     size 15 by 1.13.

define button Btn_mark 
     label "*" 
     size 3.5 by 1.13.

define button Btn_markall 
     label "+" 
     size 3.5 by 1.13.

define variable f_date as date format "99/99/99":U 
     label "До даты" 
     view-as fill-in 
     size 9 by 1 no-undo.


/* ************************  Frame Definitions  *********************** */

define frame Dialog-Frame
     Btn_Cancel at row 1.25 col 2
     btn_del at row 1.25 col 17.75
     btn_dwl at row 1.25 col 33 widget-id 2
     btn_look at row 1.25 col 48.63 widget-id 14
     Btn_mark at row 2.63 col 2.5 widget-id 4
     Btn_markall at row 2.63 col 6.75 widget-id 6
     Btn_desmark at row 2.63 col 11 widget-id 8
     f_date at row 2.63 col 22.5 colon-aligned widget-id 12
     space(76.49) skip(22.10)
    with view-as dialog-box keep-tab-order 
         side-labels no-underline three-d  scrollable 
         title "Содержимое УТМ"
         cancel-button Btn_Cancel widget-id 100.


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
assign 
       frame Dialog-Frame:SCROLLABLE       = false
       frame Dialog-Frame:HIDDEN           = true.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
on window-close of frame Dialog-Frame /* Содержимое УТМ */
do:
    apply "END-ERROR":U to self.
  end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_del Dialog-Frame
on choose of btn_del in frame Dialog-Frame /* Удалить */
do:

  def var cmd as char no-undo.
  def var qh-del as handle no-undo.

  create query qh-del.
  qh-del:set-buffers (bh-wb-analiz).
  qh-del:query-prepare ("for each tt-alldoc where tt-alldoc.mark = '*' ").
  qh-del:query-open.

  if not qh-del:get-first () 
  then do:
    message "Выделите записи для удаления." view-as alert-box information.
    return no-apply.
  end.
  
  /*if not isSave
  then do:
    message "Перед удалением нужно выполнить загрузку. Для загрузки нажмите загрузить и дождитесь окончания." view-as alert-box information.
    return no-apply.
  end.*/
  
  message "Вы уверены что хотите удалить запись/и?" view-as alert-box question buttons yes-no update isChoise as log.
  
  if isChoise
  then do:
  if qh-del:get-first ()
    then do:
      url_ = bh-wb-analiz:buffer-field ('url_'):buffer-value ().
      AdmUtmObj:DelRecord(url_).
      bh-wb-analiz:buffer-delete ().
    end.
  
    do while qh-del:get-next ():
      url_ = bh-wb-analiz:buffer-field ('url_'):buffer-value ().
      AdmUtmObj:DelRecord(url_).
      bh-wb-analiz:buffer-delete ().
    end.
  end.
  else do:
    return no-apply.
  end.
  run refresh-view.

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_desmark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_desmark Dialog-Frame
on choose of Btn_desmark in frame Dialog-Frame /* - */
do:
  
  if qh-analiz:get-first ()
    then bh-wb-analiz:buffer-field (1):buffer-value () = "".
  do while qh-analiz:get-next ():
    bh-wb-analiz:buffer-field (1):buffer-value () = "".
  end.
  
  if qh-analiz:get-first () 
    then browse-hdl-analiz:refresh ().

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_dwl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_dwl Dialog-Frame
on choose of btn_dwl in frame Dialog-Frame /* Загрузить */
do:
  AdmUtmObj:SaveRecords().
  if AdmUtmObj:StatusErr 
    then do:
      message AdmUtmObj:Msg view-as alert-box.
      isSave = false.
    end.
    else isSave = true.
  run refresh-view.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_look
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_look Dialog-Frame
on choose of btn_look in frame Dialog-Frame /* Просмотр */
do:

  if not qh-analiz:get-current () 
    then return no-apply.
  url_ = bh-wb-analiz:buffer-field ('url_'):buffer-value ().
  AdmUtmObj:LookRec(url_).
  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_mark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_mark Dialog-Frame
on choose of Btn_mark in frame Dialog-Frame /* * */
do:

  if bh-wb-analiz:available
  then do:
    if bcolmark:screen-value = "*"
      then
        assign 
          bh-wb-analiz:buffer-field (1):buffer-value () = ""
          bcolmark:screen-value = ""
          .
      else
        assign 
          bh-wb-analiz:buffer-field (1):buffer-value () = "*"
          bcolmark:screen-value = "*"
          .
  end.


end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_markall
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_markall Dialog-Frame
on choose of Btn_markall in frame Dialog-Frame /* + */
do:
  
  if qh-analiz:get-first ()
    then bh-wb-analiz:buffer-field (1):buffer-value () = "*".
  do while qh-analiz:get-next ():
    bh-wb-analiz:buffer-field (1):buffer-value () = "*".
  end.
  
  if qh-analiz:get-first () 
    then browse-hdl-analiz:refresh ().
  
  /*isMarkALL = true.
  if qh-analiz:get-first () 
    then browse-hdl-analiz:refresh ().
  isMarkALL = ?.  */
   
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f_date
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f_date Dialog-Frame
on leave of f_date in frame Dialog-Frame /* До даты */
do:
  run refresh-view.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f_date Dialog-Frame
on return of f_date in frame Dialog-Frame /* До даты */
do:
  run refresh-view.
end.

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
  
  create browse browse-hdl-analiz
    assign 
    title     = 'Записи'
    frame     = frame {&FRAME-NAME}:handle
    query     = qh-analiz
    x         = 10
    y         = 70
    width     = 100
    height    = 21
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

  AdmUtmObj = new admutm (v-cntxt-obj-type, v-cntxt-obj-code, v-fs-rar).

  bh-wb-analiz = AdmUtmObj:GetHndlTable().
  create query qh-analiz.
  qh-analiz:set-buffers (bh-wb-analiz).
  qh-analiz:query-prepare ("for each tt-alldoc").
  qh-analiz:query-open.

  browse-hdl-analiz:query = qh-analiz.
  
/*  bcolmark = browse-hdl-analiz:add-calc-column('char', 'x(1)', "", "*", 0, 'FILL-IN').*/
  
  do ii = 1 to bh-wb-analiz:num-fields:
    if ii = 1 
      then bcolmark = browse-hdl-analiz:add-like-column('tt-alldoc' + '.' + bh-wb-analiz:buffer-field (ii):name, 0, 'FILL-IN').
      else bcol = browse-hdl-analiz:add-like-column('tt-alldoc' + '.' + bh-wb-analiz:buffer-field (ii):name, 0, 'FILL-IN').
    if ii = 2 
      then bcol:width = 50.
  end.
  { gbl/diasize.i &br-hndl=browse-hdl-analiz }
  run diasize_init in this-procedure .
  run enable_UI.  
  bh-wb-analiz:find-first ("", no-lock) no-error.
  wait-for go of frame {&FRAME-NAME}.
  
end.
run disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
procedure disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  hide frame Dialog-Frame.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
procedure enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  display f_date 
      with frame Dialog-Frame.
  enable Btn_Cancel btn_del btn_dwl btn_look Btn_mark Btn_markall Btn_desmark 
         f_date 
      with frame Dialog-Frame.
  view frame Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE msdblcl Dialog-Frame 
procedure msdblcl :
/*if cb-1 <> 1 and cb-1 <> 3 and cb-1 <> 2 and cb-1 <> 4      */
/*    then apply "choose" to Btn_Save in frame {&frame-name} .*/
/*    else apply "choose" to Btn_Sel in frame {&frame-name} . */

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-row-disp Dialog-Frame 
procedure proc-row-disp :
  
  /*if valid-handle (bcolmark) and isMarkALL <> ?
  then do: 
    bcolmark:buffer-value () = if isMarkALL then "*" else "".
  end.*/
  
  /*if valid-handle (browse-hdl-analiz:buffer-field) and valid-handle (bcolmark) and bcolmark:screen-value = "*"
    then v-nn-list = v-nn-list + "," + browse-hdl-analiz:buffer-field ("nnOrder"):buffer-value ().*/
  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refresh-view Dialog-Frame 
procedure refresh-view :
def var v-proposition  as char no-undo.
  
  assign input frame {&FRAME-NAME}
    f_date
  .
  
  v-proposition = (if f_date <> ? then "(tt-alldoc.date_ = ? or tt-alldoc.date_ < " + string (f_date) + ")" else "").
  
  if v-proposition <> "" then v-proposition = "where " + v-proposition.
  
  display Btn_Cancel with frame Dialog-Frame.
  enable Btn_Cancel btn_del
    with frame Dialog-Frame.
  view frame Dialog-Frame.
  qh-analiz:query-close.
  qh-analiz:query-prepare ("for each tt-alldoc " + v-proposition).
  qh-analiz:query-open.
  if qh-analiz:get-first () 
    then browse-hdl-analiz:refresh ().
  
  apply "choose" to Btn_desmark in frame {&FRAME-NAME}.
  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


