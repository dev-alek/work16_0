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
USING Progress.Json.ObjectModel.*. 

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Загрузка данных из TH 15.0 через сокет-сервер".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i }
{ cmp/showinf.i }
{ str/placelib.i }
{ str/nzpl-spl.i }
{ trg/cplgdspm.i }
{ gbl/cd-attr.i }
{ gbl/getcntxt.i def }
{ gbl/waitfram.i }

&GLOBAL-DEFINE defined_parparentproc yes

{ str/ptrlv.i "def"}

procedure pumpav:
  define input parameter parobj-type  like ub.clients.obj-type   no-undo.
  define input parameter parobj-code  like ub.clients.obj-code   no-undo.
  define input parameter parpump-code like ub.pump.pump-code no-undo.

  define buffer bf_clients for ub.clients.
  define buffer bf_pump    for ub.pump.
  { str/ptrlv.i "ov+"}
  /*Проверяем то, что нет еще такого ТРК*/
  find first bf_pump no-lock
    where bf_pump.obj-type  = parobj-type
      and bf_pump.obj-code  = parobj-code
      and bf_pump.pump-code = parpump-code
    no-error.
  if available bf_pump then do:
    return error SUBSTITUTE("Уже есть ТРК с номером &1", parpump-code) {&str-obj}.
  end.
  create bf_pump.
  assign
    bf_pump.obj-type  = parobj-type
    bf_pump.obj-code  = parobj-code
    bf_pump.pump-code = parpump-code
  .
end procedure.

procedure nozzleav:
define input parameter parobj-type    like ub.clients.obj-type   no-undo.
define input parameter parobj-code    like ub.clients.obj-code   no-undo.
define input parameter parnozzle-code like ub.nozzle.nozzle-code no-undo.
define buffer bf_clients for ub.clients.
define buffer bf_nozzle  for ub.nozzle.
{ str/ptrlv.i "ov+"}
/*Проверяем то, что нет еще такого пистолета*/
find first bf_nozzle where bf_nozzle.obj-type    = parobj-type    and
                           bf_nozzle.obj-code    = parobj-code    and
                           bf_nozzle.nozzle-code = parnozzle-code no-lock no-error.
if available bf_nozzle then
             return error SUBSTITUTE("Уже есть пистолет с номером &1", parnozzle-code) {&str-obj}.
create bf_nozzle.
assign bf_nozzle.obj-type    = parobj-type
       bf_nozzle.obj-code    = parobj-code
       bf_nozzle.nozzle-code = parnozzle-code.
end procedure.

procedure pumpnzav:
define input parameter parobj-type    like ub.clients.obj-type    no-undo.
define input parameter parobj-code    like ub.clients.obj-code    no-undo.
define input parameter parpump-code   like ub.pump.pump-code      no-undo.
define input parameter parnozzle-code like ub.nozzle.nozzle-code  no-undo.
define input parameter paris-meas     like ub.pump-nozzle.is-meas no-undo.
define input parameter paref-nid      like ub.pump-nozzle.ef-nid no-undo.
define buffer bf_clients     for ub.clients.
define buffer bf_pump        for ub.pump.
define buffer bf_nozzle      for ub.nozzle.
define buffer bf_pump-nozzle for ub.pump-nozzle.
define buffer bf_rvs-doc     for ub.rvs-doc.
define buffer bf_icnt-doc    for ub.icnt-doc.
{ str/ptrlv.i "ov+"       }
{ str/ptrlv.i "ppv+"      }
{ str/ptrlv.i "nv+"       }
{ str/ptrlv.i "rvs-doc-"  }
{ str/ptrlv.i "icnt-doc-" }
/*Проверяем то, что нет еще такой записи ТРК-пистолет*/
find first bf_pump-nozzle where bf_pump-nozzle.obj-type    = parobj-type    and
                                bf_pump-nozzle.obj-code    = parobj-code    and
                                bf_pump-nozzle.pump-code   = parpump-code   and
                                bf_pump-nozzle.nozzle-code = parnozzle-code no-lock no-error.
if available bf_pump-nozzle then
             return error SUBSTITUTE ("Уже есть запись ТРК-пистолет с номером ТРК &1 и номером пистолета &2", parpump-code, parnozzle-code) {&str-obj}.
create bf_pump-nozzle.
assign bf_pump-nozzle.obj-type    = parobj-type
       bf_pump-nozzle.obj-code    = parobj-code
       bf_pump-nozzle.pump-code   = parpump-code
       bf_pump-nozzle.nozzle-code = parnozzle-code
       bf_pump-nozzle.is-meas     = paris-meas
       bf_pump-nozzle.ef-nid      = paref-nid
       .
end procedure.

procedure plpmnzav:
  define input parameter parobj-type    like ub.clients.obj-type   no-undo.
  define input parameter parobj-code    like ub.clients.obj-code   no-undo.
  define input parameter parpl-code     like ub.place.pl-code      no-undo.
  define input parameter parpump-code   like ub.pump.pump-code     no-undo.
  define input parameter parnozzle-code like ub.nozzle.nozzle-code no-undo.

  do
  on error undo, return error return-value
  :
    define buffer bf_clients              for ub.clients.
    define buffer bf_place                for ub.place.
    define buffer bf_pump                 for ub.pump.
    define buffer bf_nozzle               for ub.nozzle.
    define buffer bf_pl-pump              for ub.pl-pump.
    define buffer bf_pump-nozzle          for ub.pump-nozzle.
    define buffer bf_pl-pump-nozzle       for ub.pl-pump-nozzle.
    define buffer bf-other_pl-pump-nozzle for ub.pl-pump-nozzle.
    define buffer bf_rvs-doc              for ub.rvs-doc.
    define buffer bf_icnt-doc             for ub.icnt-doc.
    define buffer bf_pl-gds-pump          for ub.pl-gds-pump.
    define buffer bf-other_pl-gds-pump    for ub.pl-gds-pump.

    { str/ptrlv.i "ov+"       }
    { str/ptrlv.i "ppv+"      }
    { str/ptrlv.i "plv+"      }
    { str/ptrlv.i "nv+"       }
    { str/ptrlv.i "plppv+"    }
    { str/ptrlv.i "ppnv+"     }
    { str/ptrlv.i "rvs-doc-"  }
    { str/ptrlv.i "icnt-doc-" }
    /*Проверяем то, что нет еще такой связки резервуар-ТРК в журнале резервуар-ТРК-пистолет*/
    if nzpl-spl(parobj-type, parobj-code) <> yes then do:
      find first bf_pl-pump-nozzle no-lock
        where bf_pl-pump-nozzle.obj-type   = parobj-type
          and bf_pl-pump-nozzle.obj-code   = parobj-code
          and bf_pl-pump-nozzle.pl-code    = parpl-code
          and bf_pl-pump-nozzle.pump-code  = parpump-code
        no-error.
      if available bf_pl-pump-nozzle then do:
        return error substitute("Резервуар &1 уже связан с ТРК &2, через пистолет &3", parpl-code, parpump-code, bf_pl-pump-nozzle.nozzle-code) {&str-obj}.
      end.
    end.
    do /*transaction*/
    on error undo, return error return-value
    :
      /*Если есть привязка к топливу*/
      find first bf_pl-gds-pump no-lock
        where bf_pl-gds-pump.obj-type  = parobj-type
          and bf_pl-gds-pump.obj-code  = parobj-code
          and bf_pl-gds-pump.pl-code   = parpl-code
          and bf_pl-gds-pump.pump-code = parpump-code
        no-error.
      if available bf_pl-gds-pump then do:
        /*Если есть еще резервуар который льет такое же топливо через эту же ТРК*/
        find first bf-other_pl-gds-pump no-lock
          where bf-other_pl-gds-pump.obj-type  = bf_pl-gds-pump.obj-type
            and bf-other_pl-gds-pump.obj-code  = bf_pl-gds-pump.obj-code
            and bf-other_pl-gds-pump.gds-code  = bf_pl-gds-pump.gds-code
            and bf-other_pl-gds-pump.pump-code = bf_pl-gds-pump.pump-code
            and bf-other_pl-gds-pump.pl-code  <> bf_pl-gds-pump.pl-code
          no-error.

        if available bf-other_pl-gds-pump then do:
          if nzpl-spl(parobj-type, parobj-code) <> yes then do:
            /*А из какого резервуара он льет*/
            find first bf-other_pl-pump-nozzle no-lock
              where bf-other_pl-pump-nozzle.obj-type  = bf-other_pl-gds-pump.obj-type
                and bf-other_pl-pump-nozzle.obj-code  = bf-other_pl-gds-pump.obj-code
                and bf-other_pl-pump-nozzle.pl-code   = bf-other_pl-gds-pump.pl-code
                and bf-other_pl-pump-nozzle.pump-code = bf-other_pl-gds-pump.pump-code
              no-error.
            if available bf-other_pl-pump-nozzle then do:
              /*Из разных пистолетов на одной ТРК нельзя торговать одним и тем же топливом*/
              if bf-other_pl-pump-nozzle.nozzle-code <> parnozzle-code then do:
                return error substitute ("На объекте &1 &2 ТРК &3 через пистолет &4 торгует топливом с внутренним кодом &5 из резервуара &6.&7"
                                         + "КАСССА не возвращает номер пистолета в чеке, .&7"
                                         + "поэтому нельзя торговать одним и тем же топливом на одной ТРК через разные пистолеты.&7"
                                         , bf-other_pl-pump-nozzle.obj-type
                                         , bf-other_pl-pump-nozzle.obj-code
                                         , bf-other_pl-pump-nozzle.pump-code
                                         , bf-other_pl-pump-nozzle.nozzle-code
                                         , bf-other_pl-gds-pump.gds-code
                                         , bf-other_pl-gds-pump.pl-code
                                         , {&new-line}
                                        ).
              end.
            end.
          end.
          else do:
            find current bf_pl-gds-pump exclusive-lock.
            assign
              bf_pl-gds-pump.status_ = {&blocked-status}.
          end.
        end.
        /*Идем по остальным резервуарам льющим через данный пистолет на данной ТРК*/
        for each bf-other_pl-pump-nozzle where bf-other_pl-pump-nozzle.obj-type    = parobj-type
                                            and bf-other_pl-pump-nozzle.obj-code    = parobj-code
                                            and bf-other_pl-pump-nozzle.pump-code   = parpump-code
                                            and bf-other_pl-pump-nozzle.nozzle-code = parnozzle-code
                                            no-lock on error undo, return error return-value :
          find first bf-other_pl-gds-pump where bf-other_pl-gds-pump.obj-type  = bf-other_pl-pump-nozzle.obj-type
                                            and bf-other_pl-gds-pump.obj-code  = bf-other_pl-pump-nozzle.obj-code
                                            and bf-other_pl-gds-pump.pl-code   = bf-other_pl-pump-nozzle.pl-code
                                            and bf-other_pl-gds-pump.pump-code = bf-other_pl-pump-nozzle.pump-code no-lock no-error.
          if available bf-other_pl-gds-pump then do:
            if bf-other_pl-gds-pump.gds-code <> bf_pl-gds-pump.gds-code then do:
              return error substitute ("На объекте &1 &2 ТРК &3 через пистолет &4 торгует топливом с внутренним кодом &5 из резервуара &6. Вы хотите торговать топливом с внутренним кодом &7. Разными видами топлива через один пистолет на одной ТРК торговать нельзя.",
                                        bf-other_pl-pump-nozzle.obj-type,
                                        bf-other_pl-pump-nozzle.obj-code,
                                        bf-other_pl-pump-nozzle.pump-code,
                                        bf-other_pl-pump-nozzle.nozzle-code,
                                        bf-other_pl-gds-pump.gds-code,
                                        bf-other_pl-gds-pump.pl-code,
                                        bf_pl-gds-pump.gds-code).
            end.
          end.
        end.
      end.

      create bf_pl-pump-nozzle.
      assign
        bf_pl-pump-nozzle.obj-type    = parobj-type
        bf_pl-pump-nozzle.obj-code    = parobj-code
        bf_pl-pump-nozzle.pl-code     = parpl-code
        bf_pl-pump-nozzle.pump-code   = parpump-code
        bf_pl-pump-nozzle.nozzle-code = parnozzle-code
      .
    end. /*transaction*/
  end.
end procedure.

procedure plpumpav:
  define input parameter parobj-type  like ub.clients.obj-type no-undo.
  define input parameter parobj-code  like ub.clients.obj-code no-undo.
  define input parameter parpl-code   like ub.place.pl-code    no-undo.
  define input parameter parpump-code like ub.pump.pump-code   no-undo.

  define buffer bf_clients           for ub.clients.
  define buffer bf_pump              for ub.pump.
  define buffer bf_place             for ub.place.
  define buffer bf_pl-pump           for ub.pl-pump.
  define buffer bf_pl-gds            for ub.pl-gds.
  define buffer bf_goods             for ub.goods.
  define buffer bf_pl-gds-pump       for ub.pl-gds-pump.
  define buffer bf-other_pl-gds-pump for ub.pl-gds-pump.

  define variable varstatus as character no-undo.

  { str/ptrlv.i "ov+"}
  { str/ptrlv.i "ppv+"}
  { str/ptrlv.i "plv+"}
  /*Проверяем то, что нет еще такой записи резервуар-ТРК*/
  find first bf_pl-pump no-lock
    where bf_pl-pump.obj-type   = parobj-type
      and bf_pl-pump.obj-code   = parobj-code
      and bf_pl-pump.pl-code    = parpl-code
      and bf_pl-pump.pump-code  = parpump-code
    no-error.
  if available bf_pl-pump then do:
    return error SUBSTITUTE("Уже есть запись резервуар-ТРК с номером резервуара &1 и номером ТРК &2", parpl-code, parpump-code) {&str-obj}.
  end.
  /*Если есть в резервуаре бензин делаем проверку, что через данную ТРК не течет данный бензин
    и создаем связку с топливом*/
  find first bf_pl-gds no-lock
    where bf_pl-gds.obj-type = parobj-type
      and bf_pl-gds.obj-code = parobj-code
      and bf_pl-gds.pl-code  = parpl-code
    no-error.
  tr:
  do transaction
  on error undo tr, return error return-value
  :
    if available bf_pl-gds then do:
      find first bf_goods no-lock
        where bf_goods.gds-code = bf_pl-gds.gds-code
      .
      assign
        varstatus = {&current-status}
      .
      find first bf-other_pl-gds-pump no-lock
        where bf-other_pl-gds-pump.obj-type  = parobj-type
          and bf-other_pl-gds-pump.obj-code  = parobj-code
          and bf-other_pl-gds-pump.gds-code  = bf_goods.gds-code
          and bf-other_pl-gds-pump.pump-code = parpump-code
          and bf-other_pl-gds-pump.status_   = {&current-status}
        no-error.
      if available bf-other_pl-gds-pump
        and nzpl-spl(bf-other_pl-gds-pump.obj-type, bf-other_pl-gds-pump.obj-code) <> yes
      then do:
        message
          "Через ТРК с номером " parpump-code " уже продается топливо " bf_goods.artic " " bf_goods.prod-type " " bf_goods.prod-code " " bf_goods.gds-name
          " которое связано с резервуаром " bf-other_pl-gds-pump.pl-code "." skip
          "Данная привязка Резервуар-ТРК-Товар получит статус блокированный."
          view-as alert-box information.
        assign
          varstatus = {&blocked-status}
        .
      end.
      create bf_pl-gds-pump.
      assign
        bf_pl-gds-pump.obj-type  = parobj-type
        bf_pl-gds-pump.obj-code  = parobj-code
        bf_pl-gds-pump.pl-code   = parpl-code
        bf_pl-gds-pump.gds-code  = bf_goods.gds-code
        bf_pl-gds-pump.pump-code = parpump-code
        bf_pl-gds-pump.status_   = varstatus
      .
      run cplgdspm in this-procedure
        ( input bf_pl-gds-pump.obj-type
         ,input bf_pl-gds-pump.obj-code
         ,input bf_pl-gds-pump.pl-code
         ,input bf_pl-gds-pump.gds-code
         ,input bf_pl-gds-pump.pump-code
         ,input bf_pl-gds-pump.status_
        ) no-error.
      if error-status:error then do:
        undo tr, return error substitute ("Ошибка при смене статуса записи резервуар-ТРК-пистолет: &1 &2.", return-value, error-status:get-message(1)).
      end.
    end.
    create bf_pl-pump.
    assign
      bf_pl-pump.obj-type   = parobj-type
      bf_pl-pump.obj-code   = parobj-code
      bf_pl-pump.pl-code    = parpl-code
      bf_pl-pump.pump-code  = parpump-code
    .
  end. /*transaction*/
end procedure.
{ str/ptrlv.i "undef"}
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

define variable v-has-records as logical no-undo .
define variable glog        as logical   no-undo.

define variable cmd as character no-undo .
define variable vI    as int64    no-undo.
define variable vBuff as handle   no-undo.

DEFINE VARIABLE myParser        AS ObjectModelParser    NO-UNDO.
DEFINE VARIABLE myJsonObj       AS JsonObject           NO-UNDO.
DEFINE VARIABLE results-array   AS JsonArray            NO-UNDO.
DEFINE VARIABLE myResultObj     AS JsonObject           NO-UNDO.

DEFINE VARIABLE iPage       AS INTEGER  NO-UNDO.
DEFINE VARIABLE iLimit      AS INTEGER  NO-UNDO.

DEFINE VARIABLE iCount      AS INTEGER  NO-UNDO.
DEFINE VARIABLE iLength     AS INTEGER  NO-UNDO.

DEFINE STREAM lsIN.
DEFINE STREAM lsOUT.

define temp-table tt-cash-desk like ub.cash-desk .
define temp-table tt-cash-desk-attr like ub.cash-desk-attr
  field attr-value as character 
.
  
define temp-table tt-icnt-doc like ub.icnt-doc .
define temp-table tt-icnt-line like ub.icnt-line .

define temp-table tt-place like ub.place .
define temp-table tt-place-attr like ub.place-attr .
define temp-table tt-pump like ub.pump .
define temp-table tt-nozzle like ub.nozzle .
define temp-table tt-pl-pump like ub.pl-pump .
define temp-table tt-pump-nozzle like ub.pump-nozzle .
define temp-table tt-pl-pump-nozzle like ub.pl-pump-nozzle .
define temp-table tt-pl-level like ub.pl-level .
define temp-table tt-pl-gds like ub.pl-gds .
define temp-table tt-pl-gds-pump like ub.pl-gds-pump .

define temp-table tt-gds-prod
  field gds-code as integer
  field b-str as character
  index pi as primary unique
    gds-code
.

define temp-table tt-place-loc
  field pl-code as integer
  field loc1 as character
  index pi as primary unique
    pl-code
.
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS B-OK B-Cancel v-addr v-cashdesk v-schem ~
v-pumpdoc v-price v-file-path b-file
&Scoped-Define DISPLAYED-OBJECTS v-addr v-cashdesk v-schem v-pumpdoc v-price v-file-path

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-Cancel AUTO-END-KEY 
     LABEL "Отмена" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON B-OK AUTO-GO 
     LABEL "ВВОД" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE v-addr AS CHARACTER FORMAT "X(256)":U 
     LABEL "Адрес сокет-сервера" 
     VIEW-AS FILL-IN tooltip "Адрес сокет-сервера в формате ip:port"
     SIZE 38 BY 1 no-undo initial "localhost:8080" .

DEFINE VARIABLE v-cashdesk AS LOGICAL INITIAL no 
     LABEL "Кассы" 
     VIEW-AS TOGGLE-BOX
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE v-pumpdoc AS LOGICAL INITIAL no 
     LABEL "Инвентаризация счетчиков ТРК" 
     VIEW-AS TOGGLE-BOX
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE v-schem AS LOGICAL INITIAL no 
     LABEL "Топология" 
     VIEW-AS TOGGLE-BOX
     SIZE 60 BY 1 NO-UNDO.
     
DEFINE VARIABLE v-price AS LOGICAL INITIAL no 
     LABEL "Цены" 
     VIEW-AS TOGGLE-BOX
     SIZE 60 BY 1 NO-UNDO.
     
define variable v-file-path as character FORMAT "X(256)":U 
     LABEL "Файл соответствий" 
     VIEW-AS FILL-IN 
     SIZE 38 BY 1 no-undo.     
     
define button b-file  DEFAULT
     IMAGE-UP FILE "btn-down-arrow":U
     IMAGE-DOWN FILE "btn-down-arrow":U
     IMAGE-INSENSITIVE FILE "btn-down-arrow":U
     label ""
     SIZE 2.5 BY 1.08.     


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     B-OK AT ROW 1.2 COL 2
     B-Cancel AT ROW 1.2 COL 12
     v-addr AT ROW 2.4 COL 2 WIDGET-ID 2
     v-cashdesk AT ROW 3.6 COL 3 WIDGET-ID 4
     v-schem AT ROW 4.8 COL 3 WIDGET-ID 6
     v-pumpdoc AT ROW 6 COL 3 WIDGET-ID 8
     v-price AT ROW 7.2 COL 3 WIDGET-ID 10
     v-file-path at row 8.4 col 2 WIDGET-ID 12
     b-file at row 8.4 col 60
     SPACE(2) SKIP(0.5)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Загрузка данных из TH v15.0"
         DEFAULT-BUTTON B-OK CANCEL-BUTTON B-Cancel WIDGET-ID 100.


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

/* SETTINGS FOR FILL-IN v-addr IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Загрузка данных из TH v15.0 */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON value-changed of v-price in FRAME Dialog-Frame /* Загрузка данных из TH v15.0 */
DO:
  assign v-price.
  if v-price
  then do :
    enable v-file-path b-file with frame Dialog-Frame.
  end.
  else do :
    disable v-file-path b-file with frame Dialog-Frame.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME B-OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-OK Dialog-Frame
ON CHOOSE OF B-file IN FRAME Dialog-Frame /* ВВОД */
DO:
  system-dialog get-file v-file-path
    filters "Текстовые файлы (*.txt)" "*.txt",
            "Все файлы (*.*)" "*.*"
    title "Выберите файл соответсвий кодов товаров"
    update glog
  .
  if glog
  then do :
    v-file-path:screen-value = v-file-path .
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME B-OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-OK Dialog-Frame
ON CHOOSE OF B-OK IN FRAME Dialog-Frame /* ВВОД */
DO:
  
  ASSIGN
    v-addr
    v-cashdesk
    v-pumpdoc
    v-schem
    v-price
    v-file-path
  .
  if v-price and trim(v-file-path) = ""
  then do :
    message "Для загрузки цен необходимо выбрать файл с соответствиями кодов товаров!" view-as alert-box.
    return no-apply .
  end.
  if trim(v-file-path) <> ""
  then do :
    if search(v-file-path) = ?
    then do :
      message "Файл соответствий не найден!" view-as alert-box.
      return no-apply .
    end.  
    file-info:file-name = v-file-path .
    if file-info:file-size = 0
    then do :
      message "Файл соответствий пустой!" view-as alert-box.
      return no-apply .
    end. 
  end. 
  v-has-records = false.
  if v-cashdesk then do :
    for each ub.cash-desk no-lock where ub.cash-desk.db-num = v-cntxt-db-num-obj
                                    and ub.cash-desk.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    for each ub.cash-desk-attr no-lock where ub.cash-desk-attr.db-num = v-cntxt-db-num-obj
                                         and ub.cash-desk-attr.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    if v-has-records
    then do :
      message "Справочник касс и/или их атрибутов не пустой!" view-as alert-box.
      return no-apply .
    end.
  end.
  if v-schem then do :
    for each ub.place no-lock where ub.place.obj-type = v-cntxt-obj-type
                                and ub.place.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    for each ub.place-attr no-lock where ub.place-attr.obj-type = v-cntxt-obj-type
                                     and ub.place-attr.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    for each ub.pump no-lock where ub.pump.obj-type = v-cntxt-obj-type
                               and ub.pump.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    for each ub.nozzle no-lock where ub.nozzle.obj-type = v-cntxt-obj-type
                                 and ub.nozzle.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    for each ub.pump-nozzle no-lock where ub.pump-nozzle.obj-type = v-cntxt-obj-type
                                      and ub.pump-nozzle.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    for each ub.pl-pump-nozzle no-lock where ub.pl-pump-nozzle.obj-type = v-cntxt-obj-type
                                         and ub.pl-pump-nozzle.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    for each ub.pl-pump no-lock where ub.pl-pump.obj-type = v-cntxt-obj-type
                                  and ub.pl-pump.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    for each ub.pl-gds no-lock where ub.pl-gds.obj-type = v-cntxt-obj-type
                                 and ub.pl-gds.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    for each ub.pl-gds-pump no-lock where ub.pl-gds-pump.obj-type = v-cntxt-obj-type
                                      and ub.pl-gds-pump.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    if v-has-records
    then do :
      message "Топология не пустая!" view-as alert-box.
      return no-apply .
    end.
  end.
  if v-pumpdoc then do :
    for each ub.icnt-doc no-lock where ub.icnt-doc.obj-type = v-cntxt-obj-type
                                   and ub.icnt-doc.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    for each ub.icnt-line no-lock where ub.icnt-line.obj-type = v-cntxt-obj-type
                                    and ub.icnt-line.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.    
    end.
    if v-has-records
    then do :
      message "На объекте есть инвентаризации счетчиков ТРК!" view-as alert-box.
      return no-apply .
    end.
  end.
  if v-price then do :
    for each ub.price-doc no-lock where ub.price-doc.obj-type = v-cntxt-obj-type
                                    and ub.price-doc.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.
    end.
    for each ub.price-list no-lock where ub.price-list.obj-type = v-cntxt-obj-type
                                     and ub.price-list.obj-code = v-cntxt-obj-code :
      v-has-records = true .
      leave.
    end. 
    if v-has-records
    then do :
      message "На объекте есть переоценки!" view-as alert-box.
      return no-apply .
    end.                                 
  end.
  
  if v-cashdesk
  then do trans:
    run waitfram-show in this-procedure ( INPUT "Обработка: Кассы..." ).
    run load_cashdesk no-error .
    if error-status:error
    then do :
      run waitfram-hide in this-procedure .
      message ("Ошибка при загрузке Касс: " + return-value + {&new-line} + "Продолжить работу?") view-as alert-box question buttons yes-no update glog .
      if not glog then undo, return no-apply .
      undo .
    end.
  end.
  if v-schem
  then do trans:
    run waitfram-show in this-procedure ( INPUT "Обработка: Топология..." ).
    run load_schem no-error .
    if error-status:error
    then do :
      run waitfram-hide in this-procedure .
      message ("Ошибка при загрузке Топологии: " + return-value + {&new-line} + "Продолжить работу?") view-as alert-box question buttons yes-no update glog .
      if not glog then undo, return no-apply .
      undo .
    end.
  end.
  if v-pumpdoc
  then do trans:
    run waitfram-show in this-procedure ( INPUT "Обработка: Инвентаризация счетчиков ТРК" ).
    run load_pumpdoc no-error .
    if error-status:error
    then do :
      run waitfram-hide in this-procedure .
      message ("Ошибка при загрузке Инвентаризации счетчиков ТРК: " + return-value + {&new-line} + "Продолжить работу?") view-as alert-box question buttons yes-no update glog .
      if not glog then undo, return no-apply .
      undo .
    end.
  end.  
  if v-price
  then do trans:
    run waitfram-show in this-procedure ( INPUT "Обработка: Цены" ).
    run load_price no-error .
    if error-status:error
    then do :
      run waitfram-hide in this-procedure .
      message ("Ошибка при загрузке цен: " + return-value + {&new-line} + "Продолжить работу?") view-as alert-box question buttons yes-no update glog .
      if not glog then undo, return no-apply .
      undo .
    end.
  end.
  run waitfram-hide in this-procedure .
  message "ГОТОВО!" view-as alert-box.
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
  { gbl/getcntxt.i get }
  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

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
  DISPLAY v-addr v-cashdesk v-schem v-pumpdoc 
      WITH FRAME Dialog-Frame.
  ENABLE B-OK B-Cancel v-addr v-cashdesk v-schem v-pumpdoc v-price v-file-path b-file
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
  apply "value-changed" to v-price in frame Dialog-Frame .
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

procedure load_price :
  
  cmd = substitute ("&1 &2/THGetInfo?GetPrice >&3", search ("exe/curl.exe"), v-addr, "price-temp.json").
  os-command silent value (cmd).
  run fix-codepage_ (input "price-temp.json") .
  
  myParser = NEW ObjectModelParser().
  myJsonObj = CAST(myParser:ParseFile(search("price.json")), JsonObject).
  
/*  run parse-json(input temp-table tt-cash-desk:default-buffer-handle, input "cash-desk") .          */
/*  run parse-json(input temp-table tt-cash-desk-attr:default-buffer-handle, input "cash-desk-attr") .*/
  
  /* Delete all objects created by this procedure to avoid memory leaks */
  DELETE OBJECT myResultObj NO-ERROR.
  DELETE OBJECT results-array NO-ERROR.
  DELETE OBJECT myJsonObj NO-ERROR.
  DELETE OBJECT myParser    NO-ERROR.
end procedure .

procedure load_cashdesk :
  define variable v-rid as recid no-undo .
  
  
  cmd = substitute ("&1 &2/THGetInfo?GetCashDesk >&3", search ("exe/curl.exe"), v-addr, "cashdesk-temp.json").
  os-command silent value (cmd).
  run fix-codepage_ (input "cashdesk-temp.json") .
  
  myParser = NEW ObjectModelParser().
  myJsonObj = CAST(myParser:ParseFile(search("cashdesk.json")), JsonObject).
  
  run parse-json(input temp-table tt-cash-desk:default-buffer-handle, input "cash-desk") .
  run parse-json(input temp-table tt-cash-desk-attr:default-buffer-handle, input "cash-desk-attr") .
  
  /* Delete all objects created by this procedure to avoid memory leaks */
  DELETE OBJECT myResultObj NO-ERROR.
  DELETE OBJECT results-array NO-ERROR.
  DELETE OBJECT myJsonObj NO-ERROR.
  DELETE OBJECT myParser    NO-ERROR.
  
  for each tt-cash-desk where not tt-cash-desk.is-del exclusive-lock :
    tt-cash-desk.addr-path = replace(tt-cash-desk.addr-path, "|", chr(4)) .
    for first tt-cash-desk-attr no-lock where tt-cash-desk-attr.db-num = tt-cash-desk.db-num
                                         and tt-cash-desk-attr.obj-code = tt-cash-desk.obj-code
                                         and tt-cash-desk-attr.pos-type = tt-cash-desk.pos-type
                                         and tt-cash-desk-attr.cash-num = tt-cash-desk.cash-num
                                         and tt-cash-desk-attr.attr-code = "fr-type" :
      tt-cash-desk.fr-type = tt-cash-desk-attr.attr-value .                                    
    end.                                       
    run ref/cashdsk1.p (
     input-output v-rid
    ,input {&add-def}
    ,input v-cntxt-db-num-obj
    ,input v-cntxt-obj-code
    ,input tt-cash-desk.pos-type
    ,input tt-cash-desk.cash-num
    ,input tt-cash-desk.autonomy
    ,input tt-cash-desk.addr-path
    ,input tt-cash-desk.cash-on
    ,input tt-cash-desk.cash-os
    ,input tt-cash-desk.is-del
    ,input tt-cash-desk.remote
    ,input tt-cash-desk.version
    ,input tt-cash-desk.registration-code
    ,input tt-cash-desk.serial-code
    ,input tt-cash-desk.fr-type
    ) no-error .
    if error-status:error then do:
      undo, return error return-value.
    end.
    for each tt-cash-desk-attr no-lock where tt-cash-desk-attr.db-num = tt-cash-desk.db-num
                                         and tt-cash-desk-attr.obj-code = tt-cash-desk.obj-code
                                         and tt-cash-desk-attr.pos-type = tt-cash-desk.pos-type
                                         and tt-cash-desk-attr.cash-num = tt-cash-desk.cash-num :
      case tt-cash-desk-attr.attr-code :
        when "last-check-params"
        then do :
          run cd-attr-write in this-procedure (
                                  input v-cntxt-db-num-obj
                                ,input v-cntxt-obj-code
                                ,input tt-cash-desk-attr.pos-type
                                ,input tt-cash-desk-attr.cash-num
                                ,input  (if tt-cash-desk-attr.pos-type = {&cd-type-ibm-xml}
                                         then {&cda-IBM-XML_operative}
                                         else {&cda-AUTOTANK_operative})
                                ,input (if tt-cash-desk-attr.pos-type = {&cd-type-IBM-XML}
                                        then {&cda-IBM-XML_operative_last-check-params}
                                        else {&cda-AUTOTANK_operative_last-check-params})
                                ,input tt-cash-desk-attr.attr-value
                                ,input ? /*p-date*/
                                ,input 0 /*p-decimal*/
                                ,input 0 /*p-integer*/
                                ,input no /*p-logical*/
                                ) no-error.
        end.
        when "FO-version"
        then do :
/*          run cd-attr-write in this-procedure (                                            */
/*                                  input v-cntxt-db-num-obj                                 */
/*                                ,input v-cntxt-obj-code                                    */
/*                                ,input tt-cash-desk-attr.pos-type                          */
/*                                ,input tt-cash-desk-attr.cash-num                          */
/*                                ,input  (if tt-cash-desk-attr.pos-type = {&cd-type-ibm-xml}*/
/*                                         then {&cda-IBM-XML_operative}                     */
/*                                         else {&cda-AUTOTANK_operative})                   */
/*                                ,input (if tt-cash-desk-attr.pos-type = {&cd-type-IBM-XML} */
/*                                        then {&cda-IBM-XML_operative_fo-version}           */
/*                                        else {&cda-AUTOTANK_operative_fo-version})         */
/*                                ,input tt-cash-desk-attr.attr-value                        */
/*                                ,input ? /*p-date*/                                        */
/*                                ,input 0 /*p-decimal*/                                     */
/*                                ,input 0 /*p-integer*/                                     */
/*                                ,input no /*p-logical*/                                    */
/*                                ) no-error.                                                */
        end.                        
      end case.                                   
    end.                                       
  end.
   
end procedure.

procedure load_schem :
  define variable v-rep-rec as recid no-undo .
  define variable v-ok        as logical   no-undo.
  
  empty temp-table tt-gds-prod .
  
  cmd = substitute ("&1 &2/THGetInfo?GetSchem >&3", search ("exe/curl.exe"), v-addr, "schem-temp.json").
  os-command silent value (cmd).
  run fix-codepage_ (input "schem-temp.json") .
  
  myParser = NEW ObjectModelParser().
  myJsonObj = CAST(myParser:ParseFile(search("schem.json")), JsonObject).
  
  run parse-json(input temp-table tt-place:default-buffer-handle, input "place") .
  run parse-json(input temp-table tt-place-attr:default-buffer-handle, input "place-attr") .
  run parse-json(input temp-table tt-pump:default-buffer-handle, input "pump") .
  run parse-json(input temp-table tt-nozzle:default-buffer-handle, input "nozzle") .
  run parse-json(input temp-table tt-pl-pump:default-buffer-handle, input "pl-pump") .
  run parse-json(input temp-table tt-pump-nozzle:default-buffer-handle, input "pump-nozzle") .
  run parse-json(input temp-table tt-pl-pump-nozzle:default-buffer-handle, input "pl-pump-nozzle") .
  run parse-json(input temp-table tt-pl-level:default-buffer-handle, input "pl-level") .
  run parse-json(input temp-table tt-pl-gds:default-buffer-handle, input "pl-gds") .
  run parse-json(input temp-table tt-pl-gds-pump:default-buffer-handle, input "pl-gds-pump") .
  run parse-json(input temp-table tt-gds-prod:default-buffer-handle, input "tt-gds-prod") .
  
  /* Delete all objects created by this procedure to avoid memory leaks */
  DELETE OBJECT myResultObj NO-ERROR.
  DELETE OBJECT results-array NO-ERROR.
  DELETE OBJECT myJsonObj NO-ERROR.
  DELETE OBJECT myParser    NO-ERROR.
  
  for each tt-gds-prod no-lock :
    find first ub.prod-bc no-lock where ub.prod-bc.b-str = tt-gds-prod.b-str no-error.
    if not available ub.prod-bc
    then do :
      undo, return error ("Нет короткого кода " + tt-gds-prod.b-str) .
    end.
    find first ub.bar-code no-lock where ub.bar-code.b-code = ub.prod-bc.b-code no-error.
    if not available ub.bar-code
    then do :
      undo, return error ("Нет бар-кода для короткого кода " + tt-gds-prod.b-str) .
    end.
    find first ub.goods no-lock where ub.goods.gds-code = ub.bar-code.gds-code no-error.
    if not available ub.goods
    then do :
      undo, return error ("Нет товара с коротким кодом " + tt-gds-prod.b-str) .
    end.
  end. 
  
  
  for each tt-pump no-lock :
    run pumpav in this-procedure
      ( input v-cntxt-obj-type
       ,input v-cntxt-obj-code
       ,input tt-pump.pump-code
      ) no-error.
    if error-status:error then do:
       undo, return error return-value.
    end.
  end.
  
  for each tt-nozzle no-lock :
    run nozzleav (input v-cntxt-obj-type,
                        v-cntxt-obj-code,
                        tt-nozzle.nozzle-code) no-error.
    if error-status:error then do:
      undo, return error return-value.
    end.
  end.
  
  for each tt-pump-nozzle no-lock :
    run pumpnzav in this-procedure ( input v-cntxt-obj-type
                                     ,input v-cntxt-obj-code
                                     ,input tt-pump-nozzle.pump-code
                                     ,input tt-pump-nozzle.nozzle-code
                                     ,input tt-pump-nozzle.is-meas
                                     ,input ""
                        ) no-error.
    if error-status:error then do:
       undo, return error return-value.
    end.
  end.
  
  for each tt-place no-lock :
    if tt-place.status_ = "удал" then next . /* Удаленные не загружаем */
    run ref/place01.p
      ( input-output v-rep-rec
      , input {&add-def}
      , input yes /*silent*/
      , input v-cntxt-obj-type
      , input v-cntxt-obj-code
      , input 0
      , input tt-place.loc1
      , input tt-place.loc2
      , input tt-place.loc3
      , input tt-place.loc4
      , input tt-place.pl-name
      , input tt-place.ps
      , input tt-place.add-qnty
      , input tt-place.is-meas
      , input tt-place.max-qnty
      , input tt-place.issue-year
      , input tt-place.start-date
      , input yes
      ) no-error.
    if error-status:error then 
    do:
      undo, return error return-value.
    end.
    find first ub.place no-lock where recid(ub.place) = v-rep-rec .
    
    for each tt-place-attr no-lock where tt-place-attr.obj-type = tt-place.obj-type
                                     and tt-place-attr.obj-code = tt-place.obj-code
                                     and tt-place-attr.pl-code  = tt-place.pl-code :
      run placelib_write-attr  
        (input tt-place-attr.attr-code
        ,input v-cntxt-obj-code
        ,input v-cntxt-obj-type
        ,input ub.place.pl-code
        ,input tt-place-attr.attr-value
        ,output v-ok      )
      no-error.   
      if error-status:error then 
      do:
        undo, return error return-value.
      end.                              
    end.
    
    for each tt-pl-level no-lock where tt-pl-level.obj-type = tt-place.obj-type
                                   and tt-pl-level.obj-code = tt-place.obj-code
                                   and tt-pl-level.pl-code  = tt-place.pl-code :
      create ub.pl-level.
      assign
        ub.pl-level.obj-type  = v-cntxt-obj-type
        ub.pl-level.obj-code  = v-cntxt-obj-code
        ub.pl-level.pl-code   = ub.place.pl-code
        ub.pl-level.pl-level  = tt-pl-level.pl-level
        ub.pl-level.pl-qnty   = tt-pl-level.pl-qnty
      .
    end.
     
    for each tt-pl-gds no-lock where tt-pl-gds.obj-type = tt-place.obj-type
                                 and tt-pl-gds.obj-code = tt-place.obj-code
                                 and tt-pl-gds.pl-code  = tt-place.pl-code,
    first tt-gds-prod no-lock where tt-gds-prod.gds-code = tt-pl-gds.gds-code : 
      find first ub.prod-bc no-lock where ub.prod-bc.b-str = tt-gds-prod.b-str no-error.
      if not available ub.prod-bc
      then do :
        undo, return error "No short-code" .
      end.
      find first ub.bar-code no-lock where ub.bar-code.b-code = ub.prod-bc.b-code no-error.
      if not available ub.bar-code
      then do :
        undo, return error "No bar-code" .
      end.
      run trg/plgdpmvc.p (
          input  v-cntxt-obj-type,
          input  v-cntxt-obj-code,
          input  ub.place.pl-code,
          input  ub.bar-code.gds-code,
          output v-ok) no-error.
      if error-status:error then 
      do:
/*          message                                            */
/*              "Ошибка при привязке товара к резервуару." skip*/
/*              return-value skip                              */
/*              error-status:get-message(1)                    */
/*              view-as alert-box error.                       */
          undo, return error return-value.
      end.
      if not v-ok then 
      do:
/*          if return-value <> "" then                       */
/*              message return-value view-as alert-box ERROR.*/
/*          undo , next .                                    */
      end.
      
    end. 
    
    for each tt-pl-pump no-lock where tt-pl-pump.obj-type   = tt-place.obj-type
                                  and tt-pl-pump.obj-code   = tt-place.obj-code
                                  and tt-pl-pump.pl-code    = tt-place.pl-code :
      run plpumpav in this-procedure
               (input v-cntxt-obj-type,
                input v-cntxt-obj-code,
                input ub.place.pl-code,
                input tt-pl-pump.pump-code) no-error.  
      if error-status:error then do:
         undo, return error return-value.
      end.                                      
    end.  
    
    for each tt-pl-pump-nozzle no-lock where  tt-pl-pump-nozzle.obj-type   = tt-place.obj-type
                                          and tt-pl-pump-nozzle.obj-code   = tt-place.obj-code
                                          and tt-pl-pump-nozzle.pl-code    = tt-place.pl-code :     
      find first tt-pl-gds-pump where tt-pl-gds-pump.obj-type = tt-pl-pump-nozzle.obj-type and
                                              tt-pl-gds-pump.obj-code = tt-pl-pump-nozzle.obj-code and
                                              tt-pl-gds-pump.pl-code = tt-pl-pump-nozzle.pl-code and
                                              tt-pl-gds-pump.pump-code = tt-pl-pump-nozzle.pump-code and 
                                              tt-pl-gds-pump.status_ = 'тек'
                                              no-lock no-error.
      if not available tt-pl-gds-pump
      then do:
        next. /* Переносим только текущие связки рез-трк-пистолет */
      end.
      run plpmnzav in this-procedure
        ( input v-cntxt-obj-type
         ,input v-cntxt-obj-code
         ,input ub.place.pl-code
         ,input tt-pl-pump-nozzle.pump-code
         ,input tt-pl-pump-nozzle.nozzle-code
        ) no-error.
      if error-status:error then do:
         undo, return error return-value.
      end.
    end.                                                                                                             
  end.
  
  
end procedure.

procedure load_pumpdoc :
  define variable v-doc-code as character no-undo .
  define variable v-recid as recid no-undo .
  
  empty temp-table tt-gds-prod .
  empty temp-table tt-place-loc .
  
  cmd = substitute ("&1 &2/THGetInfo?GetPumpDoc >&3", search ("exe/curl.exe"), v-addr, "pumpdoc-temp.json").
  os-command silent value (cmd).
  run fix-codepage_ (input "pumpdoc-temp.json") .
  
  myParser = NEW ObjectModelParser().
  myJsonObj = CAST(myParser:ParseFile(search("pumpdoc.json")), JsonObject).
  
  run parse-json(input temp-table tt-icnt-doc:default-buffer-handle, input "icnt-doc") .
  run parse-json(input temp-table tt-icnt-line:default-buffer-handle, input "icnt-line") .
  run parse-json(input temp-table tt-gds-prod:default-buffer-handle, input "tt-gds-prod") .
  run parse-json(input temp-table tt-place-loc:default-buffer-handle, input "tt-place-loc") .
  
  DELETE OBJECT myResultObj NO-ERROR.
  DELETE OBJECT results-array NO-ERROR.
  DELETE OBJECT myJsonObj NO-ERROR.
  DELETE OBJECT myParser    NO-ERROR.
  
      
  for each tt-icnt-doc no-lock :
    for each tt-icnt-line exclusive-lock where tt-icnt-line.doc-code = tt-icnt-doc.doc-code :
      find first tt-gds-prod no-lock where tt-gds-prod.gds-code = tt-icnt-line.gds-code no-error.
      if not available tt-gds-prod
      then do :
        undo, return error "No gds-prod" .
      end.
       
      find first ub.prod-bc no-lock where ub.prod-bc.b-str = tt-gds-prod.b-str no-error.
      if not available ub.prod-bc
      then do :
        undo, return error "No short-code" .
      end.
      
      find first ub.bar-code no-lock where ub.bar-code.b-code = ub.prod-bc.b-code no-error.
      if not available ub.bar-code
      then do :
        undo, return error "No bar-code" .
      end.
      
      find first tt-place-loc no-lock where tt-place-loc.pl-code = tt-icnt-line.pl-code no-error.
      if not available tt-place-loc
      then do :
        undo, return error "No place-loc" .
      end.
      
      find first ub.place no-lock where ub.place.loc1 = tt-place-loc.loc1 no-error.
      if not available ub.place
      then do :
        undo, return error "No place" .
      end.
      
      assign
        tt-icnt-line.obj-code = v-cntxt-obj-code
        tt-icnt-line.obj-type = v-cntxt-obj-type
        tt-icnt-line.gds-code = ub.bar-code.gds-code
        tt-icnt-line.pl-code  = ub.place.pl-code
      .
    end.
    run str/icntdoc1.p (
                     INPUT {&add-def}
                    ,input yes /*p-silent*/
                    ,input-output v-recid
                    ,INPUT ""
                    ,input v-cntxt-obj-type
                    ,input v-cntxt-obj-code
                    ,input v-cntxt-host-code-obj
                    ,input {&icnt-doc}
                    ,input {&TDEICNT_Inv}
                    ,INPUT tt-icnt-doc.wrkr
                    ,INPUT tt-icnt-doc.agnt
                    ,INPUT tt-icnt-doc.boss
                    ,INPUT tt-icnt-doc.doc-date
                    ,input tt-icnt-doc.meas-el-cnt
                    ,input tt-icnt-doc.state-el-cnt
                    ,input tt-icnt-doc.state-mh-cnt
                    ,input tt-icnt-doc.PS
                    ,input tt-icnt-doc.creid
                    ,input '':U /*p-ptrlcheck*/
                    ,input table tt-icnt-line
                     ) NO-ERROR.
    if error-status:error then do:
      undo, return error return-value.
    end.
    run str/icntdoc2.p ( INPUT v-recid
                 ,INPUT yes /*p-silent*/
                 ) NO-ERROR.
    if error-status:error then do:
      undo, return error return-value.
    end.             
  end.

end procedure.

procedure parse-json :
  define input parameter pBuff as handle.
  define input parameter p-array-name as character.
  define variable v-data-type as character no-undo .
  
  results-array = myJsonObj:GetJsonArray(p-array-name) no-error.
  if error-status:error then return.
  iLength = results-array:LENGTH.
  DO iCount = 1 TO iLength:
      myResultObj = results-array:GetJsonObject(iCount).

      pBuff:buffer-create () .
      do vI = 1 to pBuff:num-fields:
        v-data-type = pBuff:buffer-field[vI]:data-type .
        case v-data-type :
          when "character" then do:
            pBuff:buffer-field[vI]:buffer-value = myResultObj:GetCharacter(pBuff:buffer-field[vI]:name) no-error .
          end.
          when "integer" then do:
            pBuff:buffer-field[vI]:buffer-value = integer(myResultObj:GetCharacter(pBuff:buffer-field[vI]:name)) no-error .
          end.
          when "decimal" then do:
            pBuff:buffer-field[vI]:buffer-value = decimal(myResultObj:GetCharacter(pBuff:buffer-field[vI]:name)) no-error .
          end.
          when "logical" then do:
            pBuff:buffer-field[vI]:buffer-value = logical(myResultObj:GetCharacter(pBuff:buffer-field[vI]:name)) no-error .
          end.
          when "date" then do:
            pBuff:buffer-field[vI]:buffer-value = date(myResultObj:GetCharacter(pBuff:buffer-field[vI]:name)) no-error .
          end.
        end.
      end.
  END.
  
end procedure .

procedure fix-codepage_ :
  define input parameter p-file as character no-undo .
  define variable vline as char no-undo .
  define variable vline2 as char no-undo .
  define variable v-out-file as character no-undo .
  
  case p-file :
    when "schem-temp.json" then v-out-file = "schem.json" .
    when "pumpdoc-temp.json" then v-out-file = "pumpdoc.json" .
    when "cashdesk-temp.json" then v-out-file = "cashdesk.json" .
    when "price-temp.json" then v-out-file = "price.json" .
  end case.
  
  input STREAM lsIN from value(search(p-file)) convert target "UTF-8" source "1251".
  output STREAM lsOUT to value(v-out-file).
  repeat:
    vline2 = vline.
    import STREAM lsIN unformatted vline.
    vLine = replace(vline, chr(4), "|") .
    if vline2 = vline and length(vline2) < 3 then leave.
    put STREAM lsOUT unformatted  vline skip .
  end.
  input STREAM lsIN close.
  output STREAM lsOUT close.
end procedure.  
