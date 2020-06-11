&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Синхранизация товаров с Меркурием

Автор: Шкляр Елена  
Дата создания: 10/10/08
Author: Shklyar Elena
Creation date: 10/10/08
*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&ANALYZE-SUSPEND _EXPORT-NUMBER AB_v10r12
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 


/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gds-mercury

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-3 f-guid B-exit b-quit B-Help 
&Scoped-Define DISPLAYED-OBJECTS f-guid 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */

&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES

/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
/* BROWSE-TAB BROWSE-3 1 Dialog-Frame */
/* SETTINGS FOR FILL-IN f-guid IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
/*&ANALYZE-RESUME*/

using ibs.th.str.gds.*.
using ibs.th.str.mercury.*.
using ibs.th.bge.mercury.*.
using ibs.th.gbl.storage.*.
using ibs.th.str.clients.*.


/* Parameters Definitions ---                                           */

define input parameter parparentproc as widget-handle no-undo .

/* Local Variable Definitions ---                                       */

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Синхранизация товаров с Меркурием".

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
{ cmp/gds-list.i gds-list def "new shared" }
{ str/temp_merq.i}

define temp-table tt-gds like ub.gds-mercury 
  field gds-name as character label "Наименование в ТН"
  field units-th as character label "Ед.измерения в ТН"
  field units    as character label "Ед.измерения".

define temp-table tt-gds-units no-undo 
  field GUID_    as character
  field units    as character 
  .

define variable gdsMercsubsObj as class     gdsmercsubs.
define variable gdsMercObj     as class     gdsmercsub.
define variable gdsmercstrObj  as class     gdsmercstr.
define variable parser         as class     ParserXMLGds.

define variable v-login        as character no-undo .
define variable v-password     as character no-undo .
define variable v-server       as character no-undo .

define variable v-proxy-login     as character no-undo .
define variable v-proxy-pswd      as character no-undo .
define variable v-proxy-addres    as character no-undo .


define variable par-type       as character no-undo.

define buffer buf_tt-gds       for tt-gds .
define buffer buf_gds-mercury  for ub.gds-mercury .

define buffer buf_clients      for ub.clients .
define buffer buf_clients-attr for ub.clients-attr .
define buffer buf_goods        for ub.goods .
define buffer buf_goods-attr   for ub.goods-attr .

define variable select-list       as longchar  no-undo .
define variable v-select-list     as character no-undo .
define variable ref-list          as character no-undo .
define variable rid-list          as character no-undo .
define variable v-rid             as recid     no-undo .
define variable ii                as integer   no-undo .
define variable v-list            as character no-undo .
define variable v-gds-code        as integer   no-undo .

define variable glog              as logical   no-undo .

define variable gds-rec           as recid     no-undo .

define variable v-value-character as character no-undo .
define variable v-value-decimal   as decimal   no-undo .
define variable v-value-integer   as integer   no-undo .
define variable v-value-logical   as logical   no-undo .
define variable v-value-type      as character no-undo .
define variable v-value-date      as date      no-undo .

define variable gdsTHObj          as class     gdssub.

define variable vsdsTHObj         as class     vsdsubs.

define variable vsdStorage        as class     vsdtostorage.

function get-mark returns character
  (buffer local-gds for tt-gds ):
  if lookup (string (recid (local-gds)), select-list) > 0  then return "*".
  else return "".
end function.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME br-goods

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-gds

/* Definitions for BROWSE br-goods                                      */
&Scoped-define FIELDS-IN-QUERY-br-goods get-mark(BUFFER tt-gds) tt-gds.gds-code tt-gds.merc-name tt-gds.gds-name tt-gds.GUID tt-gds.UUID tt-gds.units tt-gds.units_th tt-gds.prod-type tt-gds.cr-date tt-gds.update-date   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-goods   
&Scoped-define SELF-NAME br-goods
&Scoped-define QUERY-STRING-br-goods FOR EACH tt-gds
&Scoped-define OPEN-QUERY-br-goods OPEN QUERY {&SELF-NAME} FOR EACH tt-gds.
&Scoped-define TABLES-IN-QUERY-br-goods tt-gds
&Scoped-define FIRST-TABLE-IN-QUERY-br-goods tt-gds


/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Dialog-Frame ~
    ~{&OPEN-QUERY-br-goods}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-cancel b-load b-lkp b-update b-del ~
b-connect b-import r-type b-mark b-sel-all b-unmark rs-sort br-goods 
&Scoped-Define DISPLAYED-OBJECTS r-type rs-sort 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Menu Definitions                                                     */
define menu POPUP-MENU-b-import 
  menu-item m_item_import  label "Импорт товаров"
  menu-item m_item_send    label "Передача данных в УБД".


/* Definitions of the field level widgets                               */
define button b-cancel auto-end-key 
  label "Выход" 
  size 13 by 1.13
  bgcolor 8 .

define button b-connect 
  label "Связать" 
  size 13 by 1.13
  bgcolor 8 .

define button b-del 
  label "Удалить" 
  size 13 by 1.13
  bgcolor 8 .

define button b-import 
  label "Сервис" 
  size 13 by 1.13 tooltip "Импорт"
  bgcolor 8 .

define button b-lkp 
  label "Просмотр" 
  size 13 by 1.13
  bgcolor 8 .

define button b-load 
  label "Запрос" 
  size 13 by 1.13 tooltip "Отправить запрос в Меркурий"
  bgcolor 8 .

define button b-mark 
  label "&*" 
  size 3 by 1.13.
  
define button b-alt-units 
  label "Доп. ед. изм." 
  size 14 by 1.13
  bgcolor 8 .

define button b-prod 
  image-up file "btn-down-arrow":U
  image-down file "btn-down-arrow":U
  image-insensitive file "btn-down-arrow":U
  label "" 
  size 3 by 1.13 tooltip "Выбор производителя".

define button b-sel-all 
  label "&+":L 
  size 3 by 1.13 tooltip "Отметить все объекты".

define button b-spisok 
  image-up file "btn-down-arrow":U
  image-down file "btn-down-arrow":U
  image-insensitive file "btn-down-arrow":U
  label "Товары" 
  size 3 by 1.13 tooltip "Выбор товаров".

define button b-unmark 
  label "&-":L 
  size 3 by 1.13 tooltip "Снять все отметки".

define button b-update 
  label "Изменить" 
  size 13 by 1.13
  bgcolor 8 .

define variable v-prod      as character format "X(11)" 
  label "Производитель" 
  view-as text 
  size 11 by .67 no-undo.

define variable v-prod-name as character format "X(30)" 
  view-as text 
  size 30 by .67 no-undo.

define variable r-type      as integer   initial 1 
  view-as radio-set vertical
  radio-buttons 
  "По производителю", 1,
  "По списку товаров", 2
  size 26 by 1.75 no-undo.

define variable rs-sort     as integer   initial 3 
  view-as radio-set horizontal
  radio-buttons 
  "&связан", 1,
  "&не связан", 2,
  "&все", 3
  size 40 by 1.13 no-undo.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
define query br-goods for 
  tt-gds scrolling.
&ANALYZE-RESUME

/* Browse definitions                                                   */
define browse br-goods
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-goods Dialog-Frame _FREEFORM
  query br-goods display
  get-mark(BUFFER tt-gds) column-label "*"  format "X(1)":U
  tt-gds.gds-code column-label "Код товара" format ">>>>>>>>9"
  tt-gds.merc-name column-label "Наименование товара" format "X(100)":U width 28
  tt-gds.gds-name column-label "Наим. товара в ТН" format "X(100)":U width 28
  tt-gds.GUID column-label "GUID" format "X(36)":U
  tt-gds.UUID column-label "UUID" format "X(36)":U
  tt-gds.units column-label "Ед.измерения" format "X(5)":U
  tt-gds.units-th column-label "Ед.измерения в ТН" format "X(5)":U 
  tt-gds.prod-type column-label "Тип продукции" format "X(36)":U
  tt-gds.cr-date column-label "Дата создания" format "99.99.9999":U
  tt-gds.update-date column-label "Дата последнего изменения в ТН" format "99.99.9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 105 BY 20.21 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

define frame Dialog-Frame
  b-cancel at row 1.25 col 2
  b-load at row 1.25 col 15
  b-lkp at row 1.25 col 28
  b-update at row 1.25 col 41
  b-del at row 1.25 col 54
  b-connect at row 1.25 col 67
  b-alt-units at row 1.25 col 80
  b-import at row 1.25 col 94
  r-type at row 2.5 col 2.25 no-label widget-id 20
  b-prod at row 2.5 col 71.5
  b-spisok at row 3.25 col 22.25 widget-id 26
  b-mark at row 4.5 col 2
  b-sel-all at row 4.5 col 5 widget-id 28
  b-unmark at row 4.5 col 8 widget-id 30
  rs-sort at row 4.54 col 28 no-label
  br-goods at row 5.79 col 2 widget-id 200
  v-prod at row 2.71 col 57.5 colon-aligned
  v-prod-name at row 2.71 col 74.5 colon-aligned no-label
  "Сортировать по:" view-as text
  size 15 by 1.13 at row 4.54 col 12 widget-id 18
  space(81.00) skip(20.65)
  with view-as dialog-box keep-tab-order 
  side-labels no-underline three-d  scrollable 
  title "Синхронизация товаров с Меркурием"
  default-button b-load cancel-button b-cancel widget-id 100.


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
/* BROWSE-TAB br-goods rs-sort Dialog-Frame */
assign 
  frame Dialog-Frame:SCROLLABLE = false
  frame Dialog-Frame:HIDDEN     = true.

assign 
  b-import:POPUP-MENU in frame Dialog-Frame = menu POPUP-MENU-b-import:HANDLE.
b-import:MENU-MOUSE = 1.
/* SETTINGS FOR BUTTON b-prod IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
assign 
  b-prod:HIDDEN in frame Dialog-Frame = true.

/* SETTINGS FOR BUTTON b-spisok IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
assign 
  b-spisok:HIDDEN in frame Dialog-Frame = true.

assign 
  br-goods:COLUMN-RESIZABLE in frame Dialog-Frame = true.

/* SETTINGS FOR FILL-IN v-prod IN FRAME Dialog-Frame
   NO-DISPLAY NO-ENABLE                                                 */
assign 
  v-prod:HIDDEN in frame Dialog-Frame = true.

/* SETTINGS FOR FILL-IN v-prod-name IN FRAME Dialog-Frame
   NO-DISPLAY NO-ENABLE                                                 */
assign 
  v-prod-name:HIDDEN in frame Dialog-Frame = true.

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

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
on window-close of frame Dialog-Frame /* Синхронизация товаров с Меркурием */
  do:
    apply "END-ERROR":U to self.
  end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-cancel Dialog-Frame
on choose of b-cancel in frame Dialog-Frame /* Выход */
  do:
    for each tt-gds:
      delete tt-gds .
    end.
  end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-connect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-connect Dialog-Frame
on choose of b-connect in frame Dialog-Frame /* Связать */
  do:
    if not available tt-gds then 
    do:
      message "Не выбран товар" view-as alert-box.
      return no-apply.
    end.
    v-rid = recid (tt-gds) .
    run ref/merq-connect.w (parparentproc, 
      input-output tt-gds.gds-code) no-error .
    run fill-tt .
    run refresh-query in this-procedure.
    reposition br-goods to recid v-rid .
  end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-del Dialog-Frame
on choose of b-del in frame Dialog-Frame /* Удалить */
  do:
    define variable choice         as logical no-undo .
    define variable ii             as integer no-undo .
    define variable jj             as integer no-undo .
    define variable gdsMercsubsObj as class   gdsmercsubs.
    define variable gdsmercstrObj  as class   gdsmercstr.
    
    if not available tt-gds then 
    do:
      message "Не выбран товар" view-as alert-box.
      return no-apply.
    end.
    v-rid = recid(tt-gds) .
    gdsMercsubsObj = new gdsmercsubs ().
    gdsmercstrObj = new gdsmercstr ().
    if select-list = "" then 
    do:
      gdsMercsubsObj = gdsmercstrObj:getgdsmercs(tt-gds.gds-code).
      message
        "Удалить связку товара с Меркурием?"
        view-as alert-box question buttons yes-no update choice.
      if choice then 
      do:
        if valid-object (gdsMercsubsObj:GdsMercsubsCurr) then 
        do:
          do ii = 1 to gdsMercsubsObj:GetItem (ii): 
            gdsMercObj = gdsMercsubsObj:GdsMercsubsCurr.
          end.
          gdsmercstrObj:deleteDB(gdsMercObj).         
        end.
        else 
        do:
          message "У товара нет привязки к Меркурию"
            view-as alert-box.
        end.  
      end.
    end.
    else 
    do:
      select-list = trim(select-list) .
      message
        "Удалить связки выбранных товаров с Меркурием?"
        view-as alert-box question buttons yes-no update choice.
      if choice then 
      do:
        do jj = 1 to num-entries (select-list):
          v-list = entry(jj,select-list) no-error .
          for first tt-gds exclusive-lock where recid(tt-gds) = integer(v-list):
            gdsMercsubsObj = gdsmercstrObj:getgdsmercs(tt-gds.gds-code).

            if valid-object (gdsMercsubsObj:GdsMercsubsCurr) then 
            do:
              do ii = 1 to gdsMercsubsObj:GetItem (ii): 
                gdsMercObj = gdsMercsubsObj:GdsMercsubsCurr.
              end.
              gdsmercstrObj:deleteDB(gdsMercObj).         
            end.
          end.
        end.
      end.  
    end.  

    delete object gdsMercObj no-error .
    delete object gdsmercstrObj no-error .
    delete object gdsMercsubsObj no-error .
    run fill-tt.
    run refresh-query in this-procedure.   
    reposition br-goods to recid v-rid .
  end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-lkp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-lkp Dialog-Frame
on choose of b-lkp in frame Dialog-Frame /* Просмотр */
  do:
    if not available tt-gds then 
    do:
      message "Не выбран товар" view-as alert-box.
      return no-apply.
    end.
    v-rid = recid(tt-gds) .
    run ref/merq-gds.w (
      parparentproc
      ,input-output tt-gds.gds-code
      ,input {&lookup}
      ) no-error .
    
    run refresh-query in this-procedure.    
    reposition br-goods to recid v-rid .
     
  end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-load
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-load Dialog-Frame
on choose of b-load in frame Dialog-Frame /* Запрос */
  do:
    
    define variable cmd        as character no-undo .
    define variable sw         as handle    no-undo .
    define variable v-file     as character no-undo initial "getProductItemList_.xml".
    define variable v-file-gds as character no-undo initial "getItemList_.xml".
    define buffer buf_ext-classif for ub.ext-classif.
    define buffer buf_ext-system  for ub.ext-system.
    define variable v-prod-guid as character no-undo .
    define variable v-gds-guid  as character no-undo .
    define variable jj          as integer   no-undo . 
    define variable Msg         as character no-undo .
    gdsMercsubsObj = new gdsmercsubs ().
    gdsmercstrObj = new gdsmercstr ().
    
    if not available tt-gds then 
    do:
      message "Не выбран товар" view-as alert-box.
      return no-apply.
    end.
    
    if select-list = "" and v-prod = "" then select-list = string(recid(tt-gds)) .
    
    if select-list <> "" then 
    do:
      select-list = trim (select-list) .
      do jj = 1 to num-entries (select-list):
        v-list = (entry(jj, select-list)).
        for first tt-gds exclusive-lock where recid(tt-gds) = integer(v-list) :
          if tt-gds.GUID <> "" then 
          do:
            gdsMercsubsObj = gdsmercstrObj:getgdsmercs(tt-gds.gds-code).

            if valid-object (gdsMercsubsObj:GdsMercsubsCurr) then
            do:
              v-gds-guid = gdsMercsubsObj:GdsMercsubsCurr:GUID_ .
              create sax-writer sw .
    
              sw:formatted = true.
              sw:set-output-destination ("file", v-file-gds).
              sw:encoding = "UTF-8".
    
              sw:start-document () .
              sw:start-element ("se:Envelope") .
    
              sw:insert-attribute ("xmlns:se", "http://schemas.xmlsoap.org/soap/envelope/") .
              sw:insert-attribute ("xmlns:ws", "http://api.vetrf.ru/schema/cdm/registry/ws-definitions/v2") .
              sw:insert-attribute ("xmlns:bs", "http://api.vetrf.ru/schema/cdm/base") .
              sw:insert-attribute ("xmlns:dt", "http://api.vetrf.ru/schema/cdm/dictionary/v2") .
    
              sw:start-element ("se:Body") .
              sw:start-element ("ws:getProductItemByGuidRequest") .
              sw:write-data-element ("bs:guid", v-gds-guid) .
              sw:end-element ("ws:getProductItemByGuidRequest") .
              sw:end-element ("se:Body") .
    
              sw:end-element ("se:Envelope") .
              sw:end-document () .
    

              if trim(v-proxy-addres) <> "" and v-proxy-addres <> ?
              then do :
                cmd = substitute ("&1 -x &7 -U &8:&9 -u &4:&5 -d @&2 &6/platform/services/2.0/ProductService >&3",
                                search ("exe/curl.exe"), search (v-file-gds), "ItemList_.xml", v-login, v-password, v-server, v-proxy-addres, v-proxy-login, v-proxy-pswd).
              end.
              else do :
                cmd = substitute ("&1 -u &4:&5 -d @&2 &6/platform/services/2.0/ProductService >&3", search ("exe/curl.exe"), search (v-file-gds), "ItemList_.xml", v-login, v-password, v-server).
              end.
              os-command silent value (cmd). /*закрытие окна*/
          
              parser = new parserXmlGDS().
              parser:ParseResponse
                (search("ItemList_.xml")
                ,input-output TABLE tt-gds-merq
                ,output Msg) no-error.
              if Msg <> "" then 
              do:
                message Msg
                  view-as alert-box.
              end.  
              else 
              do:
                find first tt-gds-merq no-lock no-error .
                if available (tt-gds-merq) then 
                do:
    
                  gdsMercsubsObj = gdsmercstrObj:getguidmercs(tt-gds-merq.GUID_). /*исправить на GUID*/
                  if valid-object (gdsMercsubsObj:GdsMercsubsCurr) then 
                  do:
                    do ii = 1 to gdsMercsubsObj:GetItem (ii): 
                      gdsMercObj = gdsMercsubsObj:GdsMercsubsCurr. /* выдернула конкретны объект*/
                    end.            
                    create tt-gds-units .
                    assign
                      gdsMercObj:MercName    = tt-gds-merq.merc-name
                      gdsMercObj:UUID        = tt-gds-merq.UUID
                      gdsMercObj:DateCr      = tt-gds-merq.crDate
                      gdsMercObj:DateUpdate  = tt-gds-merq.update_Date
                      gdsMercObj:ProdType    = string (tt-gds-merq.prod-type)
                      gdsMercObj:GUIDType    = tt-gds-merq.GUID-type
                      gdsMercObj:GUIDSubType = tt-gds-merq.GUID-subtype
                      tt-gds-units.units     = tt-gds-merq.units
                      tt-gds-units.GUID_     = tt-gds-merq.GUID_
                      .
                    gdsmercstrObj:updateDB(gdsMercObj). /*измение записи в бд */
                  end. /*if VALID-OBJECT (gdsMercsubsObj:GdsMercsubsCurr) then */
                end. /*if AVAILABLE (tt-gds-merq) then */
              end.
            end. /*if VALID-OBJECT (gdsMercsubsObj:GdsMercsubsCurr) then*/
          end. /*if tt-gds.GUID <> "" then */
        end. /*do jj = 1 to NUM-ENTRIES (select-list):*/
      end. /*if select-list <> "" then */
      run fill-tt .
      run refresh-query in this-procedure.
    end.
    else 
    do:  

      find first buf_ext-system no-lock where buf_ext-system.esys-type = integer({&openxml-type-mercury}) no-error.
      if not available buf_ext-system
        then 
      do :
      end.
      find first buf_ext-classif no-lock 
        where buf_ext-classif.classif-subject = {&table_clients}
        and buf_ext-classif.classif-name = {&extclass_clients_esys}
        and buf_ext-classif.db-num = 0
        and buf_ext-classif.key#_one = buf_ext-system.esys-id
        and buf_ext-classif.uniq-key-rec = {&table_clients} + {&delim-key} + buf_clients.obj-type + {&delim-key} + string (buf_clients.obj-code)
        no-error.
      if not available  buf_ext-classif
        then 
      do :
      
      end.     
      v-prod-guid = entry(2, buf_ext-classif.charKey_Two, {&delim-cmd}) no-error.      
      create sax-writer sw .
    
      sw:formatted = true.
      sw:set-output-destination ("file", v-file).
      sw:encoding = "UTF-8".
    
      sw:start-document () .
      sw:start-element ("se:Envelope") .
    
      sw:insert-attribute ("xmlns:se", "http://schemas.xmlsoap.org/soap/envelope/") .
      sw:insert-attribute ("xmlns:ws", "http://api.vetrf.ru/schema/cdm/registry/ws-definitions/v2") .
      sw:insert-attribute ("xmlns:bs", "http://api.vetrf.ru/schema/cdm/base") .
      sw:insert-attribute ("xmlns:dt", "http://api.vetrf.ru/schema/cdm/dictionary/v2") .
    
      sw:start-element ("se:Body") .
      sw:start-element ("ws:getProductItemListRequest") .
      sw:start-element ("bs:listOptions") .
      sw:write-data-element ("bs:count", "1000") .
      sw:write-data-element ("bs:offset", "0") .
      sw:end-element ("bs:listOptions") .
      sw:start-element ("dt:enterprise") .
      sw:write-data-element ("bs:guid", v-prod-guid) .
      sw:end-element ("dt:enterprise") .  
      sw:end-element ("ws:getProductItemListRequest") .
      sw:end-element ("se:Body") .
    
      sw:end-element ("se:Envelope") .
      sw:end-document () .
    
      if trim(v-proxy-addres) <> "" and v-proxy-addres <> ?
      then do :
        cmd = substitute ("&1 -x &7 -U &8:&9 -u &4:&5 -d @&2 &6/platform/services/2.0/ProductService >&3",
                        search ("exe/curl.exe"), search (v-file-gds), "ItemList_.xml", v-login, v-password, v-server, v-proxy-addres, v-proxy-login, v-proxy-pswd).
      end.
      else do :
        cmd = substitute ("&1 -u &4:&5 -d @&2 &6/platform/services/2.0/ProductService >&3", search ("exe/curl.exe"), search (v-file-gds), "ItemList_.xml", v-login, v-password, v-server).
      end.
      os-command silent value (cmd).
    end.
    
    delete object gdsMercObj no-error .
    delete object gdsmercstrObj no-error .
    delete object gdsMercsubsObj no-error .
  end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-mark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-mark Dialog-Frame
on choose of b-mark in frame Dialog-Frame /* * */
  do:
    
    run proc-b-mark in this-procedure no-error.

  end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-prod Dialog-Frame
on choose of b-prod in frame Dialog-Frame
  do:
    os-delete value( search("ItemList_.xml")) no-error .
    run sel-prod in this-procedure .
    assign
      rs-sort
      .
    run refresh-query in this-procedure.   
  end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-alt-units
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-alt-units Dialog-Frame
on choose of b-alt-units in frame Dialog-Frame
do:
define variable v-ret-unit-name  as character no-undo .
define variable v-ret-unit-coeff as decimal no-undo .  
  if not available tt-gds then return no-apply .
  
  run ref\alt-units.w (input parparentproc,
                       input (if v-cntxt-db-num = 0 then {&update} else {&lookup}),
                       input tt-gds.gds-code,
                       input "", /* ограничение списка выбора */
                       output v-ret-unit-name,
                       output v-ret-unit-coeff) . 
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-sel-all
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-sel-all Dialog-Frame
on choose of b-sel-all in frame Dialog-Frame /* + */
  do:
    assign 
      select-list = "".
    if not available tt-gds then return.
    for each tt-gds no-lock :
      { gbl/markstrn.i tt-gds select-list }
    end.
    {&browse-name}:refresh() in frame {&frame-name} .
  end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-spisok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-spisok Dialog-Frame
on choose of b-spisok in frame Dialog-Frame /* Товары */
  do:
    run sel-goods in this-procedure .
    assign
      rs-sort
      .
      
    run refresh-query in this-procedure.   
  end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-unmark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-unmark Dialog-Frame
on choose of b-unmark in frame Dialog-Frame /* - */
  do:
    if not available tt-gds then return.
    select-list  = "".
    {&browse-name}:refresh() in frame {&frame-name} .
  end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-update
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-update Dialog-Frame
on choose of b-update in frame Dialog-Frame /* Изменить */
  do:
    if not available tt-gds then 
    do:
      message "Не выбран товар" view-as alert-box.
      return no-apply.
    end.
    
    v-rid = recid(tt-gds) .
    run ref/merq-gds.w (
      parparentproc
      ,input-output tt-gds.gds-code
      ,input {&update}
      ) no-error .

    run fill-tt .
    run refresh-query in this-procedure.
      
    reposition br-goods to recid v-rid .

  end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_item_import
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_item_import Dialog-Frame
on choose of menu-item m_item_import /* Импорт товаров */
  do:
    define variable jj as integer no-undo .
    v-select-list = "" .
    run ref/merq-import.w (parparentproc, 
      output v-select-list) no-error .
    if v-select-list <> "" then 
    do:
      assign 
        r-type = 2 .
      run ini_enable .
      run fill-tt .
      run refresh-query in this-procedure.
    end.
  end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_item_send
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_item_send Dialog-Frame
on choose of menu-item m_item_send /* Передача данных в УБД */
  do:
    for each ub.gds-mercury exclusive-lock:
      run str/callnews.p
        (input {&table_gds-mercury}
        ,input (buffer ub.gds-mercury:handle)
        ) no-error .

      if error-status :error then 
      do:
        message
          error-status :get-message(1) skip
          return-value skip
          view-as alert-box.
        return no-apply.
      end.
    end. 
    message "Передача данных в УБД - выполнена"
      view-as alert-box. 
  end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME r-type
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL r-type Dialog-Frame
on value-changed of r-type in frame Dialog-Frame
  do:
    assign
      v-prod:SCREEN-VALUE      = "" 
      v-prod-name:SCREEN-VALUE = ""
      .
    assign
      r-type
      .
      
    run ini_enable.
    for each tt-gds:
      delete tt-gds .
    end.  
    run refresh-query in this-procedure.
  end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-sort
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-sort Dialog-Frame
on value-changed of rs-sort in frame Dialog-Frame
  do:
    assign
      rs-sort
      .
    run refresh-query in this-procedure.
  end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-goods
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
  { gbl/diasize.i &browse-name=br-goods }
  run diasize_init in this-procedure .
  run enable_UI.
  run ini_enable.
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
  display r-type rs-sort 
    with frame Dialog-Frame.
  enable b-cancel b-load b-lkp b-update b-del b-connect b-import r-type b-mark 
    b-sel-all b-unmark rs-sort br-goods b-alt-units
    with frame Dialog-Frame.
  view frame Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fill-tt Dialog-Frame 
procedure fill-tt :
  /* -----------------------------------------------------------
          Purpose:
          Parameters:  <none>
          Notes:
        -------------------------------------------------------------*/
  define buffer buf_goods       for ub.goods .
  define buffer buf_goods-attr  for ub.goods-attr .
  define buffer buf_gds-mercury for ub.gds-mercury .
  define variable ii             as integer no-undo .
  define variable i              as integer no-undo .
  define variable jj             as integer no-undo .
  define variable gdsMercsubsObj as class   gdsmercsubs.
  define variable gdsmercstrObj  as class   gdsmercstr.

  /*получение, создание, апдейте справочника товаров всд*/
  gdsMercsubsObj = new gdsmercsubs ().
  gdsmercstrObj = new gdsmercstr ().
  
  for each tt-gds:
    delete tt-gds .
  end .  

  case r-type :
    when 1 then
      do:
        ii = 0 .
        if v-prod <> "" then
        do:
          /*Товары по выбранному производителю*/
          for each buf_goods-attr no-lock where buf_goods-attr.attr-code = {&attr-mercur_FGIS}
            and buf_goods-attr.attr-value = "yes",
            each buf_goods no-lock where buf_goods.gds-code = buf_goods-attr.gds-code and buf_goods.prod-code = INTEGER (entry(2,v-prod)) and buf_goods.prod-type = ENTRY (1,v-prod) and buf_goods.stts = 0:
            ii = ii + 1.

            gdsMercsubsObj = gdsmercstrObj:getgdsmercs(buf_goods.gds-code).

            if valid-object (gdsMercsubsObj:GdsMercsubsCurr) then
            do:

              create tt-gds .
              do i = 1 to gdsMercsubsObj:GetItem (i):
                find first tt-gds-units no-lock where tt-gds-units.GUID_ = gdsMercsubsObj:GdsMercsubsCurr:GUID_ no-error .
                  if available (tt-gds-units) then tt-gds.units = tt-gds-units.units .
                tt-gds.ID           = ii .
                tt-gds.gds-code     = gdsMercsubsObj:GdsMercsubsCurr:GdsCode .
                tt-gds.prod-type    = gdsMercsubsObj:GdsMercsubsCurr:ProdType .
                tt-gds.db-num       = gdsMercsubsObj:GdsMercsubsCurr:DBNum .
                tt-gds.gds-name     = buf_goods.gds-name .
                tt-gds.units-th     = buf_goods.unit-base .
                tt-gds.merc-name    = gdsMercsubsObj:GdsMercsubsCurr:MercName .
                tt-gds.cr-date      = gdsMercsubsObj:GdsMercsubsCurr:DateCr .
                tt-gds.update-date  = gdsMercsubsObj:GdsMercsubsCurr:DateUpdate .
                tt-gds.GUID-type    = gdsMercsubsObj:GdsMercsubsCurr:GUIDType .
                tt-gds.GUID-subtype = gdsMercsubsObj:GdsMercsubsCurr:GUIDSubType .
                tt-gds.GUID         = gdsMercsubsObj:GdsMercsubsCurr:GUID_ .
                tt-gds.UUID         = gdsMercsubsObj:GdsMercsubsCurr:UUID .
                
              end.
            end.
            else 
            do:
              create tt-gds .
              tt-gds.ID = ii .
              tt-gds.gds-code   = buf_goods.gds-code .
              tt-gds.gds-name   = buf_goods.gds-name .
              tt-gds.units-th   = buf_goods.unit-base .
            end.
          end.
        end.
      end.
    when 2 then 
      do:
        if select-list <> "" then 
        do:
          select-list = trim (select-list) no-error .
          do jj = 1 to num-entries (select-list):
            v-list = (entry(jj, select-list)) no-error.
            for first tt-gds exclusive-lock where recid(tt-gds) = integer(v-list):
              for each buf_goods no-lock where buf_goods.gds-code = integer(entry(jj,v-list)),
                first buf_goods-attr no-lock where buf_goods-attr.attr-code = {&attr-mercur_FGIS}
                and buf_goods-attr.attr-value = "yes" and buf_goods-attr.gds-code = buf_goods.gds-code:
                gdsMercsubsObj = gdsmercstrObj:getgdsmercs(buf_goods.gds-code).

                if valid-object (gdsMercsubsObj:GdsMercsubsCurr) then
                do:
                  do i = 1 to gdsMercsubsObj:GetItem (i):
                    find first tt-gds-units no-lock where tt-gds-units.GUID_ = gdsMercsubsObj:GdsMercsubsCurr:GUID_ no-error .
                    if available (tt-gds-units) then tt-gds.units = tt-gds-units.units .
                    tt-gds.prod-type    = gdsMercsubsObj:GdsMercsubsCurr:ProdType .
                    tt-gds.db-num       = gdsMercsubsObj:GdsMercsubsCurr:DBNum .
                    tt-gds.gds-name     = buf_goods.gds-name .
                    tt-gds.units-th     = buf_goods.unit-base .
                    tt-gds.merc-name    = gdsMercsubsObj:GdsMercsubsCurr:MercName .
                    tt-gds.cr-date      = gdsMercsubsObj:GdsMercsubsCurr:DateCr .
                    tt-gds.update-date  = gdsMercsubsObj:GdsMercsubsCurr:DateUpdate .
                    tt-gds.GUID-type    = gdsMercsubsObj:GdsMercsubsCurr:GUIDType .
                    tt-gds.GUID-subtype = gdsMercsubsObj:GdsMercsubsCurr:GUIDSubType .
                    tt-gds.GUID         = gdsMercsubsObj:GdsMercsubsCurr:GUID_ .
                    tt-gds.UUID         = gdsMercsubsObj:GdsMercsubsCurr:UUID .
                  end.
                end.
                else 
                do:
                  tt-gds.gds-code   = buf_goods.gds-code .
                  tt-gds.gds-name   = buf_goods.gds-name .
                  tt-gds.units-th   = buf_goods.unit-base .
                end.
              end.
            end.
          end.
        end.
        if v-select-list <> "" then 
        do:
          v-select-list = trim (v-select-list) no-error .
          do jj = 1 to num-entries (v-select-list):
            for each buf_goods no-lock where buf_goods.gds-code = integer(entry(jj,v-select-list)),
              first buf_goods-attr no-lock where buf_goods-attr.attr-code = {&attr-mercur_FGIS}
              and buf_goods-attr.attr-value = "yes" and buf_goods-attr.gds-code = buf_goods.gds-code:
              gdsMercsubsObj = gdsmercstrObj:getgdsmercs(buf_goods-attr.gds-code).

              if valid-object (gdsMercsubsObj:GdsMercsubsCurr) then
              do:
                do i = 1 to gdsMercsubsObj:GetItem (i):
                  create tt-gds .
                  find first tt-gds-units no-lock where tt-gds-units.GUID_ = gdsMercsubsObj:GdsMercsubsCurr:GUID_ no-error .
                  if available (tt-gds-units) then tt-gds.units = tt-gds-units.units .
                  tt-gds.ID           = jj .
                  tt-gds.gds-code     = gdsMercsubsObj:GdsMercsubsCurr:GdsCode .
                  tt-gds.prod-type    = gdsMercsubsObj:GdsMercsubsCurr:ProdType .
                  tt-gds.db-num       = gdsMercsubsObj:GdsMercsubsCurr:DBNum .
                  tt-gds.gds-name     = buf_goods.gds-name .
                  tt-gds.units-th     = buf_goods.unit-base .
                  tt-gds.merc-name    = gdsMercsubsObj:GdsMercsubsCurr:MercName .
                  tt-gds.cr-date      = gdsMercsubsObj:GdsMercsubsCurr:DateCr .
                  tt-gds.update-date  = gdsMercsubsObj:GdsMercsubsCurr:DateUpdate .
                  tt-gds.GUID-type    = gdsMercsubsObj:GdsMercsubsCurr:GUIDType .
                  tt-gds.GUID-subtype = gdsMercsubsObj:GdsMercsubsCurr:GUIDSubType .
                  tt-gds.GUID         = gdsMercsubsObj:GdsMercsubsCurr:GUID_ .
                  tt-gds.UUID         = gdsMercsubsObj:GdsMercsubsCurr:UUID .
                end.
              end.
              else 
              do:
                create tt-gds .
                tt-gds.ID = jj .
                tt-gds.gds-code  = buf_goods.gds-code .
                tt-gds.gds-name = buf_goods.gds-name .
                tt-gds.units-th     = buf_goods.unit-base .
              end.
            end.
          end.
        end. 
      end.
  end case .
  
  delete object gdsMercsubsObj no-error .    
  delete object gdsmercstrObj no-error .
  
  select-list = "" .

end procedure.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refresh-query Dialog-Frame
procedure refresh-query :
  /*------------------------------------------------------------------------------
    Purpose:
    Parameters:  <none>
    Notes:
  ------------------------------------------------------------------------------*/
  case rs-sort :
    when 1 then 
      do:
        open query {&browse-name} for each tt-gds where tt-gds.uuid <> ""
          by tt-gds.gds-code indexed-reposition .
      end.
    when 2 then 
      do:
        open query {&browse-name} for each tt-gds where tt-gds.uuid = ""
          by tt-gds.gds-code indexed-reposition .
      end.
    otherwise 
    do:
      open query {&browse-name} for each tt-gds
        by tt-gds.gds-code indexed-reposition .
    end.
  end case.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-mark Dialog-Frame 
procedure local-mark :
  /* -----------------------------------------------------------
          Purpose:
          Parameters:  <none>
          Notes:
        -------------------------------------------------------------*/
  
  if not available tt-gds then 
  do:
    message "Неправильный выбор строки.".
    return no-apply.
  end.
  { gbl/markstrn.i tt-gds select-list }

  {&browse-name}:refresh() in frame {&frame-name} .

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-b-mark Dialog-Frame 
procedure proc-b-mark :
  /* -----------------------------------------------------------
          Purpose:
          Parameters:  <none>
          Notes:
        -------------------------------------------------------------*/
  define variable varlog as logical no-undo .
  if not available tt-gds then return.
  run local-mark in this-procedure.
  assign 
    varlog = {&browse-name} :select-next-row( ) in frame {&frame-name}.
  apply "ENTRY":U to {&browse-name} in frame {&frame-name}.
  {&browse-name}:refresh() in frame {&frame-name} .

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sel-goods Dialog-Frame 
procedure sel-goods :
  v-select-list = "" .
  run str/gds-list.w (
    input parparentproc
    , input v-cntxt-host-code-obj
    , input v-cntxt-obj-type
    , input v-cntxt-obj-code) no-error.

  for each gds-list no-lock:
    v-select-list = v-select-list + "," + string(gds-list.gds-code) no-error.
  end.
  if v-select-list <> "" then 
  do:
    v-select-list = trim (v-select-list) no-error.
    run fill-tt.
    run refresh-query in this-procedure .  
    apply "value-changed" to br-goods in frame Dialog-Frame .
  end .
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sel-prod Dialog-Frame 
procedure sel-prod :
  assign
    ref-list = "":U
    .
  run ref/cli-all.w (
    input parparentproc
    ,  input "b-sel"
    ,  input {&all}
    ,  input {&all}
    ,  input {&current}
    ,  input ?
    ,  input ",,,,,,NO,,,"
    ,  input ?
    , output ref-list
    ) .
  if ref-list = "":U then 
  do:       
    run enable_UI in this-procedure.
    return no-apply.
  end.
  find first buf_clients no-lock where recid(buf_clients) = integer(ref-list) no-error. 
  if available buf_clients then 
  do :
    assign
      v-prod      = buf_clients.obj-type + "," + string(buf_clients.obj-code)
      v-prod-name = buf_clients.obj-name
      . 
  end.     
  display v-prod v-prod-name with frame Dialog-Frame.
  run fill-tt.
  run refresh-query in this-procedure .  
  apply "value-changed" to br-goods in frame Dialog-Frame .
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ini_enable Dialog-Frame  _DEFAULT-ENABLE
procedure ini_enable :
  case r-type :
    when 1 then 
      do:
        enable 
          v-prod
          v-prod-name
          b-prod
          b-connect 
          with frame {&frame-name}.
        hide
          b-spisok
          in frame {&frame-name} .
        disable
          b-mark
          b-sel-all
          b-unmark
          with frame {&frame-name} .           
      end.
    when 2 then 
      do:
        hide
          v-prod
          v-prod-name
          b-prod
          in frame {&frame-name}.
        enable
          b-spisok
          b-mark
          b-sel-all
          b-unmark
          with frame {&frame-name} .
        disable
          b-connect

          with frame {&frame-name} .  
      end.
  end case .
  if v-cntxt-db-num <> 0 then 
  do:
    disable
      b-update
      b-connect
      b-import
      b-del
      b-load
      with frame {&frame-name} .        
  end.
  else 
  do:
    SECURITY-POLICY:SYMMETRIC-ENCRYPTION-KEY = GENERATE-PBE-KEY("sysadm").
    
    { gbl/getsect.i run v-cntxt-obj-type v-cntxt-obj-code {&attr-mercur} }

    for each thbjattr_thbj-attr :
      case thbjattr_thbj-attr.prop-code : 
        when "login" then 
          v-login = thbjattr_thbj-attr.property-value-character .
        when "password" then 
          v-password = thbjattr_thbj-attr.property-value-character .
        when "server" then 
          do:
            case thbjattr_thbj-attr.property-value-integer :
              when 1 then 
                do:
                  v-server = "https://api2.vetrf.ru:8002" .
                end.
              when 2 then 
                do:
                  v-server = "https://api.vetrf.ru" .
                end.    
            end case .  
          end.
        when "proxy-addres" then 
          v-proxy-addres = thbjattr_thbj-attr.property-value-character .
        when "proxy-login" then
          do:
            if thbjattr_thbj-attr.property-value-character <> ""
            then do :
              {gbl/pdecrypt.i thbjattr_thbj-attr.property-value-character v-proxy-login no-error}
            end.
          end. 
        when "proxy-pswd" then
          do:
            if thbjattr_thbj-attr.property-value-character <> ""
            then do :
              {gbl/pdecrypt.i thbjattr_thbj-attr.property-value-character v-proxy-pswd no-error}
            end.  
          end.            
      end case.
    end.
    
  end.  
end procedure.
  /* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME