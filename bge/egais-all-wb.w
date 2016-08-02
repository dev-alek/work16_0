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
define variable egais               as class     EGAIS   no-undo.
define variable egaisWBAdv          as class     WayBill no-undo.
define variable v-db-num            as integer   no-undo .
define variable v-user-id           as character no-undo .
define variable qh-wb-gds-EG-header as handle    no-undo.
define variable qh-wb-gds-EG        as handle    no-undo.
define variable bh-wb-gds-EG-header as handle    no-undo.
define variable bh-wb-gds-EG        as handle    no-undo.
define variable bh-analiz           as handle    no-undo.

define variable v-value-character   as character no-undo .
define variable v-value-decimal     as decimal   no-undo .
define variable v-value-integer     as integer   no-undo .
define variable v-value-logical     as logical   no-undo .
define variable v-value-type        as character no-undo .
define variable v-value-date        as date      no-undo .
define variable v-ext-sys           as integer   no-undo .
define variable glog                as logical   no-undo.
define variable actnEGAISAdm        as logical   no-undo.
define variable v-uniq-key-rec      as character no-undo.
define variable v-trn-doc           as character no-undo.
define variable v-width             as decimal   no-undo.
define variable v-height            as decimal   no-undo.

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


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Sel Btn_Save Btn_dnlw Btn_conn ~
Btn_Del btn_ticket Btn_accept Btn_delclob cb-1 f-date f-date-2 f-cli-name ~
f-cli-code f-type TOGGLE_NotConn 
&Scoped-Define DISPLAYED-OBJECTS cb-1 f-date f-date-2 f-cli-name f-cli-code ~
f-type TOGGLE_NotConn 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_accept 
     LABEL "Подтв." 
     SIZE 10 BY 1.21.

DEFINE BUTTON Btn_conn 
     LABEL "Связать" 
     SIZE 10 BY 1.21.

DEFINE BUTTON Btn_Del 
     LABEL "Отказ" 
     SIZE 10 BY 1.21.

DEFINE BUTTON Btn_delclob 
     LABEL "Удалить" 
     SIZE 10 BY 1.21 TOOLTIP "Удаляет из базы TH. Если данные в УТМ остались, то будет загружено повторно.".

DEFINE BUTTON Btn_dnlw 
     LABEL "Загрузить" 
     SIZE 10 BY 1.21.

DEFINE BUTTON Btn_OK 
     LABEL "Выход" 
     SIZE 10 BY 1.21
     BGCOLOR 8 .

DEFINE BUTTON Btn_Save 
     LABEL "Сохранить" 
     SIZE 10 BY 1.21
     BGCOLOR 8 .

DEFINE BUTTON Btn_Sel 
     LABEL "Изменить" 
     SIZE 10 BY 1.21
     BGCOLOR 8 .

DEFINE BUTTON btn_ticket 
     LABEL "Просмотр" 
     SIZE 10 BY 1.21.

DEFINE VARIABLE cb-1 AS INTEGER FORMAT "->,>>>,>>9" INITIAL 1 
     VIEW-AS COMBO-BOX 
     LIST-ITEM-PAIRS "Полученные",1,
                     "Закрытые на факт",2,
                     "Акты",3,
                     "Расход",4
     DROP-DOWN-LIST
     SIZE 19.88 BY 1 NO-UNDO.

DEFINE VARIABLE f-type AS CHARACTER FORMAT "X(256)":U INITIAL "Все" 
     LABEL "Тип" 
     VIEW-AS COMBO-BOX 
     LIST-ITEMS "Все","приход вн.","возврат пост.","расход внутренний","расход внешний" 
     DROP-DOWN-LIST
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE f-cli-code AS INTEGER FORMAT "->>>>>>9":U INITIAL 0 
     LABEL "Код" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE f-cli-name AS CHARACTER FORMAT "x(256)":U 
     LABEL "Контрагент" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE f-date AS DATE FORMAT "99/99/99":U 
     LABEL "Дата с" 
     VIEW-AS FILL-IN 
     SIZE 9.5 BY 1 NO-UNDO.

DEFINE VARIABLE f-date-2 AS DATE FORMAT "99/99/99":U 
     LABEL "по" 
     VIEW-AS FILL-IN 
     SIZE 9.5 BY 1 NO-UNDO.

DEFINE VARIABLE TOGGLE_NotConn AS LOGICAL INITIAL no 
     LABEL "Не связ." 
     VIEW-AS TOGGLE-BOX
     SIZE 11.13 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     Btn_OK AT ROW 1.21 COL 2.63
     Btn_Sel AT ROW 1.21 COL 13.25 WIDGET-ID 6
     Btn_Save AT ROW 1.21 COL 24 WIDGET-ID 10
     Btn_dnlw AT ROW 1.21 COL 34.63 WIDGET-ID 12
     Btn_conn AT ROW 1.21 COL 45 WIDGET-ID 16
     Btn_Del AT ROW 1.21 COL 55.63 WIDGET-ID 14
     btn_ticket AT ROW 1.21 COL 66 WIDGET-ID 36
     Btn_accept AT ROW 1.21 COL 76.63 WIDGET-ID 32
     Btn_delclob AT ROW 1.21 COL 86.88 WIDGET-ID 38
     cb-1 AT ROW 1.21 COL 98.5 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     f-date AT ROW 2.5 COL 8.63 COLON-ALIGNED WIDGET-ID 22
     f-date-2 AT ROW 2.5 COL 22.75 COLON-ALIGNED WIDGET-ID 26
     f-cli-name AT ROW 2.5 COL 45.25 COLON-ALIGNED WIDGET-ID 24
     f-cli-code AT ROW 2.5 COL 65.25 COLON-ALIGNED WIDGET-ID 30
     f-type AT ROW 2.5 COL 85 COLON-ALIGNED WIDGET-ID 28
     TOGGLE_NotConn AT ROW 2.5 COL 101.75 WIDGET-ID 34
     SPACE(8.74) SKIP(25.23)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Накладные/акты ЕГАИС" WIDGET-ID 100.


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


&Scoped-define SELF-NAME Btn_accept
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_accept Dialog-Frame
ON CHOOSE OF Btn_accept IN FRAME Dialog-Frame /* Подтв. */
DO:
  
  if not bh-wb-egais:available 
    then return no-apply.
  
  if actnEGAISAdm then do:
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
    
    message  substitute ("Вы уверены, что хотите подтвердить накладную &1/&2 без проверок?", bh-wb-egais:buffer-field ("trn-doc-code"):buffer-value, entry (1, bh-wb-egais:buffer-field ("uniq-key-rec"):buffer-value, {&delim-cmd}) ) view-as alert-box question buttons yes-no
      title "" update isChoise as logical.
    
    if not isChoise
      then return no-apply.
    
    bh-wb-gds-EG = ?.
    bh-wb-gds-EG-header = ?.
    bh-wb-gds-EG-header = egais:GetHndlTable({&wb-header}, bh-wb-egais:buffer-field ("uniq-key-rec"):buffer-value).
    v-uniq-key-rec = bh-wb-egais:buffer-field ("uniq-key-rec"):buffer-value.
    if egais:StatusErr
    then do:
      message egais:Msg view-as alert-box error.
      return no-apply.
    end.
    egaisWBAdv:SendForceAccept().
    if egaisWBAdv:StatusErr
      then message egaisWBAdv:Msg view-as alert-box error.
      else do:
        { str/tdat-wrt.i
          bh-wb-egais:buffer-field('trn-doc-code'):buffer-value
          {&trdcattr-egais}
          {&egais-act-send}
          no-error
        }
        message "Отправлен акт на накладную" view-as alert-box.
      end.
    run f-query.
  end.
  else do:
    message "Отсутсвуют права для данной операции." view-as alert-box.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_conn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_conn Dialog-Frame
ON choose OF Btn_conn IN FRAME Dialog-Frame /* Связать */
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
ON choose OF Btn_Del IN FRAME Dialog-Frame /* Отказ */
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
    message substitute ( "Накладная с № &1 уже сформирована, все равно отправить отказ", bh-wb-egais:buffer-field ("trn-doc-code"):buffer-value)
    view-as alert-box question buttons yes-no update isChoise as logical.
    if not isChoise 
      then return no-apply.
  end.
  else do:
    message "Отправить отказ?" view-as alert-box question buttons yes-no update isChoise.
    if not isChoise 
      then return no-apply.
  end.
  egais:RejectWB(bh-wb-egais:buffer-field ("uniq-key-rec"):buffer-value).
  if egais:StatusErr
  then do:
    message egais:Msg view-as alert-box error.
    return no-apply.
  end.
  else run f-query.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_delclob
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_delclob Dialog-Frame
ON CHOOSE OF Btn_delclob IN FRAME Dialog-Frame /* Удалить */
DO:
  if not bh-wb-egais:available 
    then return no-apply.
  { gbl/chk-actg.i
    v-cntxt-db-num
    v-cntxt-userid
    {&action-head-code-main}
    'actn_egais-adm':U
    {&cntxt-object}
    v-cntxt-host-code-obj
    v-cntxt-obj-type
    v-cntxt-obj-code
    0
    0
    0
    false
    glog
  }
  
  if not glog then return no-apply.
  
  if bh-wb-egais:buffer-field ('DbNum'):buffer-value () <>  v-cntxt-db-num
  then do:
    message "Нельзя удалять накладную полученную в другой БД " + bh-wb-egais:buffer-field ('DbNum'):buffer-value ().
    return no-apply.
  end.
  
  message "Вы уверены что хотите удалить накладную - " bh-wb-egais:buffer-field ('num'):buffer-value () "?" view-as alert-box buttons yes-no update isChoise as logical.
  
  if not isChoise then return no-apply.
  
  do trans:
  
    for each ub.clob-bind exclusive-lock where ub.clob-bind.uniq-key-rec = bh-wb-egais:buffer-field ('uniq-key-rec'):buffer-value () and ub.clob-bind.db-num = bh-wb-egais:buffer-field ('DbNum'):buffer-value ():
      
      delete ub.clob-bind.
      
    end.
  
  end.
  
  run reopen-browse.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_dnlw
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_dnlw Dialog-Frame
ON choose OF Btn_dnlw IN FRAME Dialog-Frame /* Загрузить */
do:
  
  if not search ( v-FS-RAR + '_ReceiptListOfQuery.xml' ) = ?
  then do:
  
    message "Выполнить полную загрузка (переодически рекомендуется выполнять полную загрузку)?" view-as alert-box question buttons yes-no update isChoise as logical.
    if isChoise 
      then egaisWBAdv:FastDwnl = false.
      else egaisWBAdv:FastDwnl = true.
    
  end. 
  
  egaisWBAdv:GetDocUTM().
  if egaisWBAdv:StatusErr 
  then do:
    message "Ошибка: " egaisWBAdv:Msg view-as alert-box error.
  end.
  
  bh-analiz = egaisWBAdv:HndlAnaliz.
  if bh-analiz <> ? 
  then do: 
    bh-analiz:find-first ("where isMany") no-error.
    if bh-analiz:available
    then do:
      message "Имеются накладные с одинаковыми номерами. Посмотреть?" view-as alert-box question buttons yes-no update isChoise.
      if isChoise 
        then run bge/egais-analiz.w (input parparentproc, input egaisWBAdv).
    end.
  end.
  run reopen-browse.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON choose OF Btn_OK IN FRAME Dialog-Frame /* Выход */
do:
  apply "go" to frame {&FRAME-NAME}.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Save
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Save Dialog-Frame
ON choose OF Btn_Save IN FRAME Dialog-Frame /* Сохранить */
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
    find first ub.clients no-lock 
      where ub.clients.obj-type = bh-wb-gds-EG-header:buffer-field ("cli-type"):buffer-value
        and ub.clients.obj-code = integer (bh-wb-gds-EG-header:buffer-field ("cli-code"):buffer-value) no-error.
    if not available (ub.clients)
    then do:
      message "Не найден клиент TH для EGAIS контрагентa regID: " + bh-wb-gds-EG-header:buffer-field ('regId-Ship'):buffer-value view-as alert-box.
      return no-apply.
    end.
    find first ub.clients no-lock
      where ub.clients.obj-type = bh-wb-gds-EG-header:buffer-field ("obj-type"):buffer-value
        and ub.clients.obj-code = integer (bh-wb-gds-EG-header:buffer-field ("obj-code"):buffer-value) no-error.
    if not available (ub.clients)
    then do:
      message "Не найден объект TH для EGAIS получателя regID: " + bh-wb-gds-EG-header:buffer-field ('regId-Cons'):buffer-value view-as alert-box.
      return no-apply.
    end.
    bh-wb-gds-EG:find-first ("where tt-wb-gds-EG.gds-code = ? or tt-wb-gds-EG.gds-code = 0", no-lock) no-error.
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
      else do:
        { str/tdat-wrt.i
          bh-wb-egais:buffer-field('trn-doc-code'):buffer-value
          {&trdcattr-egais}
          {&egais-act-send}
          no-error
        }
        message "Отправлен акт на накладную" view-as alert-box.
      end.
    
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
ON choose OF Btn_Sel IN FRAME Dialog-Frame /* Изменить */
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


&Scoped-define SELF-NAME btn_ticket
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_ticket Dialog-Frame
ON CHOOSE OF btn_ticket IN FRAME Dialog-Frame /* Просмотр */
DO:
  if not bh-wb-egais:available 
    then return no-apply.
  run bge/egais-ticket.w (parparentproc, egais, bh-wb-egais:handle).
  v-uniq-key-rec = bh-wb-egais:buffer-field ("uniq-key-rec"):buffer-value.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-1 Dialog-Frame
ON value-changed OF cb-1 IN FRAME Dialog-Frame
do:
  assign cb-1 .
  if (cb-1 = 2 or cb-1 = 1) and actnEGAISAdm 
    then Btn_accept:hidden = false.
    else Btn_accept:hidden = true.
  if cb-1 = 1
  then do:
    Btn_Save:label = "Сохранить".
    Btn_Del:hidden = false.
    Btn_conn:hidden = false.
    btn_ticket:hidden = false.
    Btn_delclob:hidden = false.
  end.
  else do:
    Btn_Save:label = "Отправить".
    Btn_Del:hidden = true.
    Btn_conn:hidden = true.
    btn_ticket:hidden = true.
    Btn_delclob:hidden = true.
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
ON leave OF f-cli-code IN FRAME Dialog-Frame /* Код */
do:
  run f-query.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-cli-code Dialog-Frame
ON return OF f-cli-code IN FRAME Dialog-Frame /* Код */
do:
  run f-query.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-cli-name
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-cli-name Dialog-Frame
ON leave OF f-cli-name IN FRAME Dialog-Frame /* Контрагент */
do:
  run f-query.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-cli-name Dialog-Frame
ON return OF f-cli-name IN FRAME Dialog-Frame /* Контрагент */
do:
  run f-query.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-date
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-date Dialog-Frame
ON leave OF f-date IN FRAME Dialog-Frame /* Дата с */
do:
  run f-query.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-date Dialog-Frame
ON return OF f-date IN FRAME Dialog-Frame /* Дата с */
do:
  run f-query.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-date-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-date-2 Dialog-Frame
ON leave OF f-date-2 IN FRAME Dialog-Frame /* по */
do:
  run f-query.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-date-2 Dialog-Frame
ON return OF f-date-2 IN FRAME Dialog-Frame /* по */
do:
  run f-query.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-type
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-type Dialog-Frame
ON leave OF f-type IN FRAME Dialog-Frame /* Тип */
do:
  run f-query.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-type Dialog-Frame
ON return OF f-type IN FRAME Dialog-Frame /* Тип */
do:
  run f-query.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-type Dialog-Frame
ON value-changed OF f-type IN FRAME Dialog-Frame /* Тип */
do:
  run f-query.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE_NotConn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE_NotConn Dialog-Frame
ON VALUE-CHANGED OF TOGGLE_NotConn IN FRAME Dialog-Frame /* Не связ. */
DO:
  run f-query.
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

  { gbl/chk-actg.i
    v-cntxt-db-num
    v-cntxt-userid
    {&action-head-code-main}
    'actn_egais-adm':U
    {&cntxt-object}
    v-cntxt-host-code-obj
    v-cntxt-obj-type
    v-cntxt-obj-code
    0
    0
    0
    false
    glog
  }
  
  actnEGAISAdm = if glog then true else false.

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
  
  egaisWBAdv = cast (egais:EGAISImpl, ibs.th.bge.egais.WayBill).
  egaisWBAdv:ActnEGAISAdm = actnEGAISAdm.
  
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
        on row-display persistent run proc-row-disp.
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
  f-date-2 = ?.
  run f-query.
  { gbl/diasize.i &br-hndl=browse-hdl-wb-egais }
  run diasize_init in this-procedure .
  run enable_UI.
  Btn_accept:hidden = false.
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
  DISPLAY cb-1 f-date f-date-2 f-cli-name f-cli-code f-type TOGGLE_NotConn 
      WITH FRAME Dialog-Frame.
  ENABLE Btn_OK Btn_Sel Btn_Save Btn_dnlw Btn_conn Btn_Del btn_ticket 
         Btn_accept Btn_delclob cb-1 f-date f-date-2 f-cli-name f-cli-code 
         f-type TOGGLE_NotConn 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE f-query Dialog-Frame 
PROCEDURE f-query :
  
  def var v-proposition  as char no-undo.
  def var v-proposition1 as char no-undo.
  def var v-rowid as rowid no-undo.
  
  assign input frame {&FRAME-NAME}
    f-cli-name
    f-cli-code
    f-date
    f-date-2
    f-type
    TOGGLE_NotConn
  .
  
  v-proposition = 
    (if f-date <> ? then "tt-wb-hndls.wb-date >= " + string (f-date) else "") +
    (if f-date-2 <> ? then " and tt-wb-hndls.wb-date <= " + string (f-date-2) else "") + 
    (if f-cli-name <> "" then " and tt-wb-hndls.cliname matches '*" + string (f-cli-name) + "*'" else "") + 
    (if f-type <> "" and f-type <> "Все" then " and tt-wb-hndls.wb-type matches '" + string (f-type) + "'" else "") +
    (if f-cli-code <> 0 and f-cli-code <> ? then " and tt-wb-hndls.cli matches '*" + string (f-cli-code) + "*'" else "") +
    (if logical (TOGGLE_NotConn) then " and not tt-wb-hndls.isWB" else  "") 
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
PROCEDURE msdblcl :
if cb-1 <> 1 and cb-1 <> 3 and cb-1 <> 2 and cb-1 <> 4
    then apply "choose" to Btn_Save in frame {&frame-name} .
    else apply "choose" to Btn_Sel in frame {&frame-name} .

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-row-disp Dialog-Frame 
PROCEDURE proc-row-disp :
def var ii as int no-undo.
  
  if cb-1 = 1 then do:
    do ii = 1 to extent (bcol).  
      if valid-handle (bcol[ii]) 
        then 
          assign
            bcol[ii]:bgcolor = DARK_GRAY_COLOR when not bh-wb-egais:buffer-field ("isWb"):buffer-value
            bcol[ii]:bgcolor = RED_COLOR when bh-wb-egais:buffer-field ("EGAISSts"):buffer-value = 'Rejected'
            bcol[ii]:bgcolor = CYAN_COLOR when bh-wb-egais:buffer-field ("trn-doc-code"):buffer-value = 'отказ'
          .
    end.
  end.
  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reopen-browse Dialog-Frame 
PROCEDURE reopen-browse :

  if bh-wb-egais = ? 
      then return .

  if valid-handle (browse-hdl-wb-egais) then do: /*для правильной работы изменения размеров окна и browse.*/
    v-width  = browse-hdl-wb-egais:width-chars.
    v-height = browse-hdl-wb-egais:height-chars.
  end.

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
          width     = if v-width <> 0 then v-width else 119
          height    = if v-height <> 0 then v-height else 24
          visible   = true
          read-only = true
          sensitive = true
          separators = true
          column-resizable = true
          column-scrolling = true
          triggers:
            on mouse-move-dblclick persistent run msdblcl.
            on row-display persistent run proc-row-disp.
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
      Btn_Sel:label = "Изменить".
      enable Btn_Sel with frame {&FRAME-NAME}.
      v-diasize-browse-handle = browse-hdl-wb-egais.
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
          width     = if v-width <> 0 then v-width else 119
          height    = if v-height <> 0 then v-height else 24
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
      Btn_Sel:label = "Просмотр".
      v-diasize-browse-handle = browse-hdl-wb-egais.
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
          width     = if v-width <> 0 then v-width else 119
          height    = if v-height <> 0 then v-height else 24
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
      Btn_Sel:label = "Просмотр". 
      enable Btn_Sel with frame {&FRAME-NAME}.
      v-diasize-browse-handle = browse-hdl-wb-egais.
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
          width     = if v-width <> 0 then v-width else 119
          height    = if v-height <> 0 then v-height else 24
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
      v-diasize-browse-handle = browse-hdl-wb-egais.
    end.
  end.
  
  if f-date-2 <> ? or f-date <> ? or f-cli-name <> "" or f-type <> ""
    then run f-query.
  
  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

