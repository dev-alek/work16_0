&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
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
define variable bcol                as handle    extent no-undo.
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
define variable glog                as logical   no-undo.
define variable v-uniq-key-rec      as character no-undo.
define variable v-trn-doc           as character no-undo.

define stream strlog.

define variable v-fs-rar as character no-undo view-as text format "X(15)" label "Код ФС РАР (FSRAR ID)" .

{ gbl/color.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ gbl/getcntxt.i def }
{ gbl/getcntxt.i get }
{ gbl/thbjattr.i }
{ibs/th/bge/egais/wb-egais.i}
{ str/trdcalib.i }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

define stream strlog.

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Sel Btn_Save Btn_dnlw Btn_conn ~
Btn_Del cb-1 f-date f-date-2 f-cli-name f-cli-code f-type 
&Scoped-Define DISPLAYED-OBJECTS cb-1 f-date f-date-2 f-cli-name f-cli-code ~
f-type 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
define button Btn_conn 
     label "Связать" 
     size 10 by 1.21.

define button Btn_Del 
     label "Отказ" 
     size 10 by 1.21.

define button Btn_dnlw 
     label "Загрузить" 
     size 10 by 1.21.

define button Btn_OK 
     label "Выход" 
     size 10 by 1.21
     bgcolor 8 .

define button Btn_Save 
     label "Сохранить" 
     size 10 by 1.21
     bgcolor 8 .

define button Btn_Sel 
     label "Изменить" 
     size 10 by 1.21
     bgcolor 8 .

define variable cb-1 as integer format "->,>>>,>>9" initial 1 
     view-as combo-box 
     list-item-pairs "Полученные",1,
                     "Закрытые на факт",2,
                     "Акты",3,
                     "Расход",4
     drop-down-list
     size 40 by 1 no-undo.

define variable f-type as character format "X(256)":U initial "Все" 
     label "Тип" 
     view-as combo-box 
     list-items "Все","приход вн.","возврат пост.","расход внутренний","расход внешний" 
     drop-down-list
     size 14 by 1 no-undo.

define variable f-cli-code as integer format "->>>>>>9":U initial 0 
     label "Код" 
     view-as fill-in 
     size 14 by 1 no-undo.

define variable f-cli-name as character format "x(256)":U 
     label "Контрагент" 
     view-as fill-in 
     size 14 by 1 no-undo.

define variable f-date as date format "99/99/99":U 
     label "Дата с" 
     view-as fill-in 
     size 9.5 by 1 no-undo.

define variable f-date-2 as date format "99/99/99":U 
     label "по" 
     view-as fill-in 
     size 9.5 by 1 no-undo.


/* ************************  Frame Definitions  *********************** */

define frame Dialog-Frame
     Btn_OK at row 1.21 col 2.63
     Btn_Sel at row 1.21 col 13.25 widget-id 6
     Btn_Save at row 1.21 col 24 widget-id 10
     Btn_dnlw at row 1.21 col 34.63 widget-id 12
     Btn_conn at row 1.21 col 45 widget-id 16
     Btn_Del at row 1.21 col 55.63 widget-id 14
     cb-1 at row 1.21 col 78.38 colon-aligned no-label widget-id 2
     f-date at row 2.5 col 8.63 colon-aligned widget-id 22
     f-date-2 at row 2.5 col 22.75 colon-aligned widget-id 26
     f-cli-name at row 2.5 col 45.25 colon-aligned widget-id 24
     f-cli-code at row 2.5 col 65.25 colon-aligned widget-id 30
     f-type at row 2.5 col 85 colon-aligned widget-id 28
     space(20.62) skip(24.72)
    with view-as dialog-box keep-tab-order 
         side-labels no-underline three-d  scrollable 
         title "Накладные/акты ЕГАИС" widget-id 100.


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
on window-close of frame Dialog-Frame /* Накладные/акты ЕГАИС */
do:
  apply "END-ERROR":U to self.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_conn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_conn Dialog-Frame
on choose of Btn_conn in frame Dialog-Frame /* Связать */
do:

  def var loc-ref-list as character no-undo.
  def var v-negais as character no-undo.
  
  bh-wb-gds-EG = ?.
  bh-wb-gds-EG-header = ?.
  bh-wb-gds-EG-header = egais:GetHndlTable(1, bh-wb-egais:buffer-field ("uniq-key-rec"):buffer-value).
  if egais:StatusErr
  then do:
    message egais:Msg view-as alert-box error.
    return no-apply.
  end.
  
  run str/all-docs.w
    (  input parparentproc,
        input v-cntxt-host-code-obj ,
        input v-cntxt-obj-type ,
        input v-cntxt-obj-code ,
        input {&choose},
        input ?,
        input {&income},
        input ?,
        input ?,
        input "b-sel":U,
        input {&TDEDT_Pri_Vnesh},
        input no,
        input ?,
        output loc-ref-list ).

  find first ub.trn-doc no-lock where recid (ub.trn-doc) = integer (loc-ref-list) no-error.
  
  if not available (ub.trn-doc) 
    then return.
  
  bh-wb-gds-EG = ?.
  bh-wb-gds-EG-header = ?.
  bh-wb-gds-EG-header = egais:GetHndlTable(1, bh-wb-egais:buffer-field ("uniq-key-rec"):buffer-value).
  bh-wb-gds-EG = egais:GetHndlTable(2, bh-wb-egais:buffer-field ("uniq-key-rec"):buffer-value).  
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
  
  egais:ConnWB(bh-wb-egais:buffer-field ("uniq-key-rec"):buffer-value, ub.trn-doc.doc-code).
  
  if egais:StatusErr
    then message egais:Msg view-as alert-box error.
  else do:
    message "Накладная связана" view-as alert-box.
  end.
  output stream strlog to value ("egaislog.txt") append. 
  export stream strlog egais:Msg.
  output stream strlog close.
  run f-query.
  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Del Dialog-Frame
on choose of Btn_Del in frame Dialog-Frame /* Отказ */
do:
  
  { gbl/chk-actg.i
    v-cntxt-db-num
    v-cntxt-userid
    {&action-head-code-main}
    'actn_egais-reject':U
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
  
  if not bh-wb-egais:available 
    then return no-apply.
  bh-wb-gds-EG-header = egais:GetHndlTable(1, bh-wb-egais:buffer-field ("uniq-key-rec"):buffer-value).
  if egais:StatusErr
  then do:
    message egais:Msg view-as alert-box error.
    return no-apply.
  end.
  if can-find (first ub.trn-doc where ub.trn-doc.doc-code = bh-wb-egais:buffer-field ("trn-doc-code"):buffer-value)
  then do:
    message substitute ( "Накладная с № &1 уже сформирована, нельзя отправить отказ", bh-wb-egais:buffer-field ("trn-doc-code"):buffer-value)
    view-as alert-box.
     return no-apply.
  end.
  egais:RejectWB(bh-wb-egais:buffer-field ("uniq-key-rec"):buffer-value).
  run f-query.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_dnlw
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_dnlw Dialog-Frame
on choose of Btn_dnlw in frame Dialog-Frame /* Загрузить */
do:
  egais:GetHndlTable(?, "AllWB").
  if egais:StatusErr 
  then do:
    message "Ошибка: " egais:Msg view-as alert-box error.
  end.
  run reopen-browse.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
on choose of Btn_OK in frame Dialog-Frame /* Выход */
do:
  apply "go" to frame {&FRAME-NAME}.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Save
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Save Dialog-Frame
on choose of Btn_Save in frame Dialog-Frame /* Сохранить */
do:
  
  def var v-doc-code as character no-undo.
  
  if not bh-wb-egais:available 
    then return no-apply.
  
  case cb-1: 
  when 1 then do:
    if can-find (first ub.trn-doc where ub.trn-doc.doc-code = bh-wb-egais:buffer-field ("trn-doc-code"):buffer-value)
    then do:
      message substitute ( "Накладная с № &1 уже сформирована", bh-wb-egais:buffer-field ("trn-doc-code"):buffer-value)
      view-as alert-box.
      return no-apply.
    end.
    if bh-wb-egais:buffer-field ("trn-doc-code"):buffer-value = 'отказ'
    then do:
      message "Накладная в статусе отказ. Нельзя сохранить."
      view-as alert-box.
      return no-apply.
    end.
    bh-wb-gds-EG = ?.
    bh-wb-gds-EG-header = ?.
    bh-wb-gds-EG-header = egais:GetHndlTable(1, bh-wb-egais:buffer-field ("uniq-key-rec"):buffer-value).
    bh-wb-gds-EG = egais:GetHndlTable(2, bh-wb-egais:buffer-field ("uniq-key-rec"):buffer-value).
    v-uniq-key-rec = bh-wb-egais:buffer-field ("uniq-key-rec"):buffer-value.
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
    run f-query.
  end.
  when 2 then do:
    
    
    { gbl/chk-actg.i
      v-cntxt-db-num
      v-cntxt-userid
      {&action-head-code-main}
      'actn_egais-accept':U
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
    
    bh-wb-gds-EG = ?.
    bh-wb-gds-EG-header = ?.
    bh-wb-gds-EG-header = egais:GetHndlTable({&wb-header}, bh-wb-egais:buffer-field ("uniq-key-rec"):buffer-value).
    v-uniq-key-rec = bh-wb-egais:buffer-field ("uniq-key-rec"):buffer-value.
    if egais:StatusErr
    then do:
      message egais:Msg view-as alert-box error.
      return no-apply.
    end.
    egais:SendRequestUTM().
    if egais:StatusErr
      then message egais:Msg view-as alert-box error.
      else message "Отправлен акт на накладную" view-as alert-box.
    
  end.
  when 4 then do:
    
    { gbl/chk-actg.i
      v-cntxt-db-num
      v-cntxt-userid
      {&action-head-code-main}
      'actn_egais-send-doc':U
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
    
    bh-wb-gds-EG = ?.
    bh-wb-gds-EG-header = ?.
    v-doc-code = bh-wb-egais:buffer-field ("trn-doc-code"):buffer-value.
    bh-wb-gds-EG-header = egais:GetHndlTable({&wb-ras-header}, bh-wb-egais:buffer-field ("trn-doc-code"):buffer-value).
    v-uniq-key-rec = bh-wb-egais:buffer-field ("uniq-key-rec"):buffer-value.
    if egais:StatusErr
    then do:
      message egais:Msg view-as alert-box error.
      return no-apply.
    end.
    egais:SendRequestUTM().
    if egais:StatusErr
      then message egais:Msg view-as alert-box error.
      else do:
        { str/tdat-wrt.i
          v-doc-code
          {&trdcattr-egais}
          {&egais-wb-send}
          no-error
        }
        message "Накладная отправлена" view-as alert-box.
      end.
  end.
  end case.
  run f-query.

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Sel Dialog-Frame
on choose of Btn_Sel in frame Dialog-Frame /* Изменить */
do:
  if not bh-wb-egais:available 
    then return no-apply.
  case cb-1: 
    when 1 then do:
      run bge/egais-wb.w (parparentproc, egais, bh-wb-egais:handle).
      v-uniq-key-rec = bh-wb-egais:buffer-field ("uniq-key-rec"):buffer-value.
    end.
    when 2 then do:
      run bge/egais-ticket.w (parparentproc, egais, bh-wb-egais:handle).
      v-uniq-key-rec = bh-wb-egais:buffer-field ("uniq-key-rec"):buffer-value.
    end.
    when 3 then do:
      run bge/egais-wb-act.w (parparentproc, egais, bh-wb-egais:handle).
    end.
    when 4 then do:
      run bge/egais-ticket.w (parparentproc, egais, bh-wb-egais:handle).
      v-trn-doc = bh-wb-egais:buffer-field ("trn-doc-code"):buffer-value.
    end.
  end case.
  run f-query.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-1 Dialog-Frame
on value-changed of cb-1 in frame Dialog-Frame
do:
  assign cb-1 .
  if cb-1 = 1
  then do:
    Btn_Save:label = "Сохранить".
    Btn_Del:hidden = false.
    Btn_conn:hidden = false.
  end.
  else do:
    Btn_Save:label = "Отправить".
    Btn_Del:hidden = true.
    Btn_conn:hidden = true.
  end.
  if cb-1 = 3
  then disable Btn_Save with frame {&FRAME-NAME}.
  else enable Btn_Save with frame {&FRAME-NAME}.
  run reopen-browse.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-cli-code
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-cli-code Dialog-Frame
on leave of f-cli-code in frame Dialog-Frame /* Код */
do:
  run f-query.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-cli-code Dialog-Frame
on return of f-cli-code in frame Dialog-Frame /* Код */
do:
  run f-query.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-cli-name
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-cli-name Dialog-Frame
on leave of f-cli-name in frame Dialog-Frame /* Контрагент */
do:
  run f-query.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-cli-name Dialog-Frame
on return of f-cli-name in frame Dialog-Frame /* Контрагент */
do:
  run f-query.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-date
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-date Dialog-Frame
on leave of f-date in frame Dialog-Frame /* Дата с */
do:
  run f-query.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-date Dialog-Frame
on return of f-date in frame Dialog-Frame /* Дата с */
do:
  run f-query.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-date-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-date-2 Dialog-Frame
on leave of f-date-2 in frame Dialog-Frame /* по */
do:
  run f-query.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-date-2 Dialog-Frame
on return of f-date-2 in frame Dialog-Frame /* по */
do:
  run f-query.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-type
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-type Dialog-Frame
on leave of f-type in frame Dialog-Frame /* Тип */
do:
  run f-query.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-type Dialog-Frame
on return of f-type in frame Dialog-Frame /* Тип */
do:
  run f-query.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-type Dialog-Frame
on value-changed of f-type in frame Dialog-Frame /* Тип */
do:
  run f-query.
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
  
  { gbl/getcurus.i
    v-db-num
    v-user-id
    no-error
  }
  { gbl/chk-actg.i
    v-cntxt-db-num
    v-cntxt-userid
    {&action-head-code-main}
    'actn_egais-doc':U
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
      y         = 70
      width     = 119
      height    = 24
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
  qh-wb-egais:query-prepare ("for each tt-wb-hndls by tt-wb-hndls.wb-date descending").
  qh-wb-egais:query-open.
  if not bh-wb-egais = ? 
  then do:
    extent (bcol) = bh-wb-egais:num-fields.
    do ii = 1 to bh-wb-egais:num-fields:
      bcol[ii] = browse-hdl-wb-egais:add-like-column('tt-wb-hndls' + '.' + bh-wb-egais:buffer-field (ii):name, 0, 'FILL-IN').
      if ii = 1 then bcol[ii]:width = 20.
      if ii = 4 then bcol[ii]:width = 12.
      if ii = 5 then bcol[ii]:width = 9.
      if ii = 6 then bcol[ii]:width = 20.
      if ii = 7 then bcol[ii]:width = 10.
      if ii = 9 then bcol[ii]:width = 5.
    end.
  end.
  f-date = date (now) - 31.
  f-date-2 = now.
  run f-query.
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
  display cb-1 f-date f-date-2 f-cli-name f-cli-code f-type 
      with frame Dialog-Frame.
  enable Btn_OK Btn_Sel Btn_Save Btn_dnlw Btn_conn Btn_Del cb-1 f-date f-date-2 
         f-cli-name f-cli-code f-type 
      with frame Dialog-Frame.
  view frame Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE f-query Dialog-Frame 
procedure f-query :
  def var v-proposition  as char no-undo.
  def var v-proposition1 as char no-undo.
  def var v-rowid as rowid no-undo.
  
  assign input frame {&FRAME-NAME}
    f-cli-name
    f-cli-code
    f-date
    f-date-2
    f-type
  .
  
  v-proposition = 
    (if f-date <> ? then "tt-wb-hndls.wb-date >= " + string (f-date) else "") +
    (if f-date-2 <> ? then " and tt-wb-hndls.wb-date <= " + string (f-date-2) else "") + 
    (if f-cli-name <> "" then " and tt-wb-hndls.cliname matches '*" + string (f-cli-name) + "*'" else "") + 
    (if f-type <> "" and f-type <> "Все" then " and tt-wb-hndls.wb-type matches '" + string (f-type) + "'" else "") +
    (if f-cli-code <> 0 and f-cli-code <> ? then " and tt-wb-hndls.cli matches '*" + string (f-cli-code) + "*'" else "")
    .
    
  v-proposition = left-trim (v-proposition, " and").
  v-proposition1 = v-proposition.
  v-proposition = "where " + v-proposition.

  case cb-1 :
    when 1 then 
    do:
      qh-wb-egais:query-close.
      qh-wb-egais:query-prepare ( substitute ("for each tt-wb-hndls &1 by tt-wb-hndls.wb-date descending", v-proposition) ).
      qh-wb-egais:query-open.
      bh-wb-egais:find-first ( "where (" + v-proposition1 + ")" + "and tt-wb-hndls.uniq-key-rec = " + "'" + v-uniq-key-rec + "'") no-error.
    end.
    when 2 then
    do:
      qh-wb-egais:query-close.
      qh-wb-egais:query-prepare ( substitute ("for each tt-wb-hndls &1 by tt-wb-hndls.wb-date descending", v-proposition) ).
      qh-wb-egais:query-open.
      bh-wb-egais:find-first ( "where (" + v-proposition1 + ")" + "and tt-wb-hndls.uniq-key-rec = " + "'" + v-uniq-key-rec + "'") no-error.
    end.
    when 3 then
    do:
      qh-wb-egais:query-close.
      qh-wb-egais:query-prepare ("for each tt-wb-act-hndls").
      qh-wb-egais:query-open.
    end.
    when 4 then
    do:
      qh-wb-egais:query-close.
      qh-wb-egais:query-prepare ( substitute ("for each tt-wb-hndls &1 by tt-wb-hndls.wb-date descending", v-proposition) ).
      qh-wb-egais:query-open.
      bh-wb-egais:find-first ( "where (" + v-proposition1 + ")" + "and tt-wb-hndls.trn-doc-code = " + "'" + v-trn-doc + "'") no-error.
    end.
  end case.
  if bh-wb-egais:available
    then qh-wb-egais:reposition-to-rowid ( bh-wb-egais:rowid ).
  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE msdblcl Dialog-Frame 
procedure msdblcl :
if cb-1 <> 1 and cb-1 <> 3 and cb-1 <> 2 and cb-1 <> 4
    then apply "choose" to Btn_Save in frame {&frame-name} .
    else apply "choose" to Btn_Sel in frame {&frame-name} .

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-row-leave Dialog-Frame 
procedure proc-row-leave :
if false then do:
    do ii = 1 to extent (bcol).  
      bcol[ii]:bgcolor = RED_COLOR.
    end.
  end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reopen-browse Dialog-Frame 
procedure reopen-browse :
if bh-wb-egais = ? 
    then return .

  case cb-1 :
    when 1 then 
    do:
      delete object browse-hdl-wb-egais.
      create browse browse-hdl-wb-egais
        assign 
          title     = 'Накладные ЕГАИС'
          frame     = frame {&FRAME-NAME}:handle
          query     = qh-wb-egais
          x         = 10
          y         = 70
          width     = 119
          height    = 24
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
      qh-wb-egais:query-prepare ("for each tt-wb-hndls by tt-wb-hndls.wb-date descending").
      qh-wb-egais:query-open.
      if not bh-wb-egais = ? 
      then do:
        do ii = 1 to bh-wb-egais:num-fields:
          bcol[ii] = browse-hdl-wb-egais:add-like-column('tt-wb-hndls' + '.' + bh-wb-egais:buffer-field (ii):name, 0, 'FILL-IN').
          if ii = 1 then bcol[ii]:width = 20.
          if ii = 4 then bcol[ii]:width = 12.
          if ii = 5 then bcol[ii]:width = 9.
          if ii = 6 then bcol[ii]:width = 20.
          if ii = 7 then bcol[ii]:width = 10.
          if ii = 9 then bcol[ii]:width = 5.
        end.
      end.
      run diasize_init in this-procedure .
      Btn_Sel:label = "Изменить".
      enable Btn_Sel with frame {&FRAME-NAME}.
    end.
    when 2  then 
    do:
      delete object browse-hdl-wb-egais.
      create browse browse-hdl-wb-egais
        assign 
          title     = 'Накладные TH'
          frame     = frame {&FRAME-NAME}:handle
          query     = qh-wb-egais
          x         = 10
          y         = 70
          width     = 119
          height    = 24
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
      qh-wb-egais:query-prepare ("for each tt-wb-hndls by tt-wb-hndls.wb-date descending").
      qh-wb-egais:query-open.
      if not bh-wb-egais = ? 
      then do:
        do ii = 1 to bh-wb-egais:num-fields:
          bcol[ii] = browse-hdl-wb-egais:add-like-column('tt-wb-hndls' + '.' + bh-wb-egais:buffer-field (ii):name, 0, 'FILL-IN').
          if ii = 1 then bcol[ii]:width = 20.
          if ii = 4 then bcol[ii]:width = 12.
          if ii = 5 then bcol[ii]:width = 9.
          if ii = 6 then bcol[ii]:width = 20.
          if ii = 7 then bcol[ii]:width = 10.
          if ii = 9 then bcol[ii]:width = 5.
        end.
      end.
      run diasize_init in this-procedure .
      Btn_Sel:label = "Просмотр".
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
          y         = 70
          width     = 119
          height    = 24
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
          if ii = 1 then bcol[ii]:width = 10.
        end.
      end.
      run diasize_init in this-procedure .
      Btn_Sel:label = "Просмотр". 
      enable Btn_Sel with frame {&FRAME-NAME}.
    end.
    when 4  then 
    do:
      delete object browse-hdl-wb-egais.
      create browse browse-hdl-wb-egais
        assign 
          title     = 'Расходные накладные'
          frame     = frame {&FRAME-NAME}:handle
          query     = qh-wb-egais
          x         = 10
          y         = 70
          width     = 119
          height    = 24
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
      bh-wb-egais = egais:GetHndlTable({&wb-ras}, "").
      qh-wb-egais:set-buffers (bh-wb-egais).
      qh-wb-egais:query-prepare ("for each tt-wb-hndls by tt-wb-hndls.wb-date descending").
      qh-wb-egais:query-open.
      if not bh-wb-egais = ? 
      then do:
        do ii = 1 to bh-wb-egais:num-fields:
          bcol[ii] = browse-hdl-wb-egais:add-like-column('tt-wb-hndls' + '.' + bh-wb-egais:buffer-field (ii):name, 0, 'FILL-IN').
          if ii = 1 then bcol[ii]:width = 20.
          if ii = 4 then bcol[ii]:width = 12.
          if ii = 5 then bcol[ii]:width = 9.
          if ii = 6 then bcol[ii]:width = 20.
          if ii = 7 then bcol[ii]:width = 10.
          if ii = 9 then bcol[ii]:width = 5.
        end.
      end.
      Btn_Sel:label = "Просмотр".
      enable Btn_Sel with frame {&FRAME-NAME}.
    end.
  end.
  
  if f-date-2 <> ? or f-date <> ? or f-cli-name <> "" or f-type <> ""
    then run f-query.
  
  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

