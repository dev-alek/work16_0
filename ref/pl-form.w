&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          ub               PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME d-pl-form


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER locked_place FOR place.
DEFINE TEMP-TABLE tt-place NO-UNDO LIKE place.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS d-pl-form 
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Карточка складского места

Автор: Бахтадзе Наталья Викторовна
Дата создания: 04/10/06
Author: Bakhtadze Natalya
Creation date: 04/10/06

*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
define input parameter parparentproc as widget-handle no-undo .
define input parameter p-mode        as character no-undo.
define input parameter p-obj-type like ub.clients.obj-type no-undo .
define input parameter p-obj-code like ub.clients.obj-code no-undo .
define input parameter p-pl-code like ub.clients.obj-code no-undo .
define input-output parameter p-rep-rec     as recid no-undo .
/* Local Variable Definitions ---                                       */
define variable vss-revision    as character no-undo init "$Revision$":u .
define variable vss-author      as character no-undo init "$Author$":u .
define variable vss-date        as character no-undo init "$Date$":u .
define variable vss-workfile    as character no-undo init "$Workfile$":u .
define variable vss-archive     as character no-undo init "$Archive$":u .
define variable vss-description as character no-undo init "Карточка складского места" .
{ cmp/vssrevis.i }

{ cmp/str-glbl.i }
{ cmp/library.i }
{ cmp/showinf.i }
{ str/placelib.i }


define variable v-tab-order AS CHARACTER NO-UNDO.
define variable v-code      as character no-undo.
define variable v-value     as character no-undo.
define variable v-ok        as logical   no-undo.
define variable ii          as integer   no-undo .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME d-pl-form

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-place.loc1 tt-place.loc2 tt-place.loc3 ~
tt-place.loc4 tt-place.pl-name tt-place.is-meas tt-place.issue-year ~
tt-place.start-date tt-place.add-qnty tt-place.max-qnty tt-place.PS 
&Scoped-define ENABLED-TABLES tt-place
&Scoped-define FIRST-ENABLED-TABLE tt-place
&Scoped-Define ENABLED-OBJECTS b-exit b-quit B-hist b-help t-place-virtual ~
rvd-dnstv rvd-lvl rvd-tmp place-type place-locat error-mass place-si ~
r-sr-izm dead-balance place-diameter place-ratio-error dens-prov ~
place-twice-code t-chk-max-qnty 
&Scoped-Define DISPLAYED-FIELDS tt-place.loc1 tt-place.loc2 tt-place.loc3 ~
tt-place.loc4 tt-place.pl-name tt-place.is-meas tt-place.pl-code ~
tt-place.issue-year tt-place.start-date tt-place.add-qnty tt-place.max-qnty ~
tt-place.PS 
&Scoped-define DISPLAYED-TABLES tt-place
&Scoped-define FIRST-DISPLAYED-TABLE tt-place
&Scoped-Define DISPLAYED-OBJECTS t-place-virtual t-asi-srtif rvd-dnstv ~
rvd-lvl rvd-tmp place-type place-locat error-mass place-si dead-balance ~
place-diameter place-ratio-error dens-prov place-twice-code t-chk-max-qnty 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-exit AUTO-GO 
     LABEL "&Ввод" 
     SIZE 10 BY 1.

DEFINE BUTTON b-help 
     LABEL "Помо&щь" 
     SIZE 10 BY 1.

DEFINE BUTTON B-hist 
     LABEL "Ис&тория" 
     SIZE 10 BY 1.

DEFINE BUTTON b-quit AUTO-END-KEY 
     LABEL "&Отмена" 
     SIZE 10 BY 1.

DEFINE BUTTON r-sr-izm 
     IMAGE-UP FILE "btn-down-arrow":U
     IMAGE-DOWN FILE "btn-down-arrow":U
     IMAGE-INSENSITIVE FILE "btn-down-arrow":U
     LABEL "r-sr-izm" 
     SIZE 3 BY .88.

DEFINE VARIABLE dead-balance AS DECIMAL FORMAT "->>,>>>,>>9.<<<":U INITIAL 0 
     LABEL "Мертвый остаток" 
     VIEW-AS FILL-IN 
     SIZE 11.63 BY 1 NO-UNDO.

DEFINE VARIABLE dens-prov AS DECIMAL FORMAT "9.9999999999" INITIAL 0 
     LABEL "Плотность при поверке резервуара" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE error-mass AS DECIMAL FORMAT "9.99":U INITIAL 0.15 
     LABEL "Погр.изм.массы в трубопр. (%)" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 93 BY 24 NO-UNDO.

DEFINE VARIABLE place-diameter AS DECIMAL FORMAT ">,>>>,>>9":U INITIAL 0 
     LABEL "Диаметр резервуара(мм)" 
     VIEW-AS FILL-IN 
     SIZE 11.63 BY 1 NO-UNDO.

DEFINE VARIABLE place-ratio-error AS DECIMAL FORMAT "9.99":U INITIAL 0.25 
     LABEL "Относительная погрешность составления калибровочной таблицы" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE place-si AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "Средство измерения" 
     VIEW-AS FILL-IN 
     SIZE 8.63 BY 1 NO-UNDO.

DEFINE VARIABLE place-twice-code AS CHARACTER FORMAT "x(8)" 
     LABEL "Код сдвоенного резервуара" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE place-locat AS INTEGER INITIAL 2 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Наземный", 1,
"Подземный", 2
     SIZE 25.5 BY .92 NO-UNDO.

DEFINE VARIABLE place-type AS INTEGER initial 2
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Вертикальный", 1,
"Горизонтальный", 2
     SIZE 34.5 BY .92 NO-UNDO.

DEFINE VARIABLE rvd-dnstv AS LOGICAL INITIAL no 
     LABEL "Плотность" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.13 BY 1 NO-UNDO.

DEFINE VARIABLE rvd-lvl AS LOGICAL INITIAL no 
     LABEL "Уровень" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.13 BY 1 NO-UNDO.

DEFINE VARIABLE rvd-tmp AS LOGICAL INITIAL no 
     LABEL "Температура" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.5 BY 1 NO-UNDO.

DEFINE VARIABLE t-asi-srtif AS LOGICAL INITIAL no 
     LABEL "АСИ сертифицировано" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.13 BY 1 NO-UNDO.

DEFINE VARIABLE t-chk-max-qnty AS LOGICAL INITIAL no 
     LABEL "Проверять макс. допустимое кол-во товара на месте хранения" 
     VIEW-AS TOGGLE-BOX
     SIZE 62.63 BY .83 NO-UNDO.

DEFINE VARIABLE t-place-virtual AS LOGICAL INITIAL no 
     LABEL "Виртуальный резервуар" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME d-pl-form
     b-exit AT ROW 1 COL 2
     b-quit AT ROW 1 COL 12
     B-hist AT ROW 1 COL 66.63
     b-help AT ROW 1 COL 76.63
     tt-place.loc1 AT ROW 3 COL 10 COLON-ALIGNED
          LABEL "Коорд&1"
          VIEW-AS FILL-IN 
          SIZE 11.63 BY 1
     tt-place.loc2 AT ROW 3 COL 30.63 COLON-ALIGNED
          LABEL "Коорд&2"
          VIEW-AS FILL-IN 
          SIZE 11.63 BY 1
     tt-place.loc3 AT ROW 3 COL 52.5 COLON-ALIGNED
          LABEL "Коорд&3"
          VIEW-AS FILL-IN 
          SIZE 11.63 BY 1
     tt-place.loc4 AT ROW 3 COL 88.01 RIGHT-ALIGNED
          LABEL "Коорд&4"
          VIEW-AS FILL-IN 
          SIZE 11.63 BY 1
     tt-place.pl-name AT ROW 4.25 COL 10 COLON-ALIGNED
          LABEL "Название"
          VIEW-AS FILL-IN 
          SIZE 77 BY 1
     t-place-virtual AT ROW 5.46 COL 35.5 WIDGET-ID 28
     t-asi-srtif AT ROW 5.46 COL 66.88 WIDGET-ID 22
     tt-place.is-meas AT ROW 5.5 COL 10
          LABEL "Измеряется приборами"
          VIEW-AS TOGGLE-BOX
          SIZE 23.63 BY 1
     tt-place.pl-code AT ROW 6.75 COL 5.63 COLON-ALIGNED
          LABEL "Код"
          VIEW-AS FILL-IN 
          SIZE 10.63 BY 1
     rvd-dnstv AT ROW 6.75 COL 35.5 WIDGET-ID 40
     rvd-lvl AT ROW 6.75 COL 51.38 WIDGET-ID 44
     rvd-tmp AT ROW 6.75 COL 66.88 WIDGET-ID 46
     tt-place.issue-year AT ROW 8.71 COL 21.63 COLON-ALIGNED
          LABEL "Год выпуска"
          VIEW-AS FILL-IN 
          SIZE 11.63 BY 1
     place-type AT ROW 8.71 COL 88 RIGHT-ALIGNED NO-LABEL WIDGET-ID 8
     tt-place.start-date AT ROW 9.71 COL 21.63 COLON-ALIGNED
          LABEL "Ввод в эксплуатацию"
          VIEW-AS FILL-IN 
          SIZE 11.63 BY 1
     place-locat AT ROW 9.71 COL 88 RIGHT-ALIGNED NO-LABEL WIDGET-ID 30
     tt-place.add-qnty AT ROW 11.92 COL 30.63 COLON-ALIGNED
          LABEL "Доп. кол-во (в трубопроводе)"
          VIEW-AS FILL-IN 
          SIZE 11.63 BY 1
     error-mass AT Y 262 X 703 RIGHT-ALIGNED WIDGET-ID 38
     tt-place.max-qnty AT ROW 12.92 COL 30.63 COLON-ALIGNED
          LABEL "Максимальное количество"
          VIEW-AS FILL-IN 
          SIZE 11.63 BY 1
     place-si AT ROW 12.92 COL 75.38 COLON-ALIGNED WIDGET-ID 16
     r-sr-izm AT ROW 12.92 COL 88.5 RIGHT-ALIGNED
     dead-balance AT ROW 13.92 COL 30.63 COLON-ALIGNED WIDGET-ID 18
     place-diameter AT ROW 13.92 COL 75.38 COLON-ALIGNED WIDGET-ID 18
     place-ratio-error AT ROW 16.25 COL 88 RIGHT-ALIGNED WIDGET-ID 20
     dens-prov AT ROW 17.25 COL 88 RIGHT-ALIGNED
     place-twice-code AT ROW 18.25 COL 88 RIGHT-ALIGNED WIDGET-ID 24
     t-chk-max-qnty AT ROW 20.25 COL 3 WIDGET-ID 2
     tt-place.PS AT ROW 22.58 COL 2 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 87 BY 4
     "Тип резервуара:" VIEW-AS TEXT
          SIZE 15.63 BY .75 AT ROW 8.71 COL 37 WIDGET-ID 12
     "РВД:" VIEW-AS TEXT
          SIZE 8 BY 1 AT ROW 6.75 COL 27 WIDGET-ID 42
     "Расположение резервуара:" VIEW-AS TEXT
          SIZE 24.75 BY .92 AT ROW 9.75 COL 37 WIDGET-ID 34
     SPACE(30.12) SKIP(16.65)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Складское место".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Temp-Tables and Buffers:
      TABLE: locked_place B "?" ? ub place
      TABLE: tt-place T "?" NO-UNDO ub place
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX d-pl-form
   FRAME-NAME                                                           */
ASSIGN 
       FRAME d-pl-form:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN tt-place.add-qnty IN FRAME d-pl-form
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN dens-prov IN FRAME d-pl-form
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN error-mass IN FRAME d-pl-form
   ALIGN-R                                                              */
/* SETTINGS FOR TOGGLE-BOX tt-place.is-meas IN FRAME d-pl-form
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-place.issue-year IN FRAME d-pl-form
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-place.loc1 IN FRAME d-pl-form
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-place.loc2 IN FRAME d-pl-form
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-place.loc3 IN FRAME d-pl-form
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-place.loc4 IN FRAME d-pl-form
   ALIGN-R EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN tt-place.max-qnty IN FRAME d-pl-form
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-place.pl-code IN FRAME d-pl-form
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN tt-place.pl-name IN FRAME d-pl-form
   EXP-LABEL                                                            */
/* SETTINGS FOR RADIO-SET place-locat IN FRAME d-pl-form
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN place-ratio-error IN FRAME d-pl-form
   ALIGN-R                                                              */
ASSIGN 
       place-ratio-error:READ-ONLY IN FRAME d-pl-form        = TRUE.

/* SETTINGS FOR FILL-IN place-twice-code IN FRAME d-pl-form
   ALIGN-R                                                              */
/* SETTINGS FOR RADIO-SET place-type IN FRAME d-pl-form
   ALIGN-R                                                              */
/* SETTINGS FOR BUTTON r-sr-izm IN FRAME d-pl-form
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN tt-place.start-date IN FRAME d-pl-form
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX t-asi-srtif IN FRAME d-pl-form
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX d-pl-form
/* Query rebuild information for DIALOG-BOX d-pl-form
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX d-pl-form */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-exit d-pl-form
ON CHOOSE OF b-exit IN FRAME d-pl-form /* Ввод */
DO:
  { gbl/stdbtn.i }
  assign
    tt-place.pl-name
    tt-place.loc1
    tt-place.loc2
    tt-place.loc3
    tt-place.loc4
    tt-place.ps
    tt-place.add-qnty
    tt-place.is-meas
    tt-place.max-qnty
    tt-place.start-date
    tt-place.issue-year
    t-chk-max-qnty
    t-place-virtual
    t-asi-srtif
    place-locat
    error-mass
    rvd-dnstv
    rvd-lvl
    rvd-tmp
  .
if input frame {&frame-name} dens-prov <> dens-prov then 
do:
  if input frame {&frame-name} dens-prov = ?
    or (  input frame {&frame-name} dens-prov <= 0
    or input frame {&frame-name} dens-prov >= 1
    )
    then 
  do:
    message "Неверно определена плотность при поверке резервуара" view-as alert-box error.
    apply "entry" to dens-prov .
    return no-apply.
  end.

  assign frame {&frame-name} dens-prov.
end.

run ref/place01.p
  ( input-output p-rep-rec
  , input p-mode
  , input no /*silent*/
  , input tt-place.obj-type
  , input tt-place.obj-code
  , input tt-place.pl-code
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
  , input t-chk-max-qnty
  ) no-error.
if error-status:error then 
do:
  { gbl/reterhnd.i no-apply }
  undo, return no-apply.
end.
else 
do :
  ii = 0.
  do ii = 1 to num-entries({&list-place-attr},','):
    v-code = entry(ii,{&list-place-attr}) .
      case v-code :
          when {&place-type} then 
              do :
                  v-value = place-type:screen-value .
              end.
          when {&place-SI} then 
              do :
                  v-value = place-si:screen-value .
              end.
          when {&place-diameter} then 
              do :
                  v-value =  place-diameter:screen-value.
              end.
          when {&dead-balance} then 
              do :
                  v-value =  dead-balance:screen-value.
              end.
          when {&place-ratio-error} then 
              do :
                  v-value = place-ratio-error:screen-value .
              end.
          when {&place-dens-prov} then 
              do :
                  v-value = dens-prov:screen-value .
              end.
          when {&place-virtual} then 
              do :
                  v-value = t-place-virtual:screen-value .
              end.
          when {&place-twice-code} then 
              do: 
                  v-value = place-twice-code:screen-value .
              end.
/*          when {&place-sert-urov} then                */
/*              do:                                     */
/*                  v-value = t-sert-urov:screen-value .*/
/*              end.                                    */
          when {&place-error-mass} then 
              do: 
                  v-value = error-mass:screen-value .
              end.
          when {&place-local} then 
              do: 
                  v-value = place-locat:screen-value .
              end.
          when {&place-asi-sertif} then 
              do: 
                  v-value = t-asi-srtif:screen-value .
              end.       
          when {&place-rvd-dnsty} then 
              do: 
                  v-value = rvd-dnstv:screen-value .
              end.       
          when {&place-rvd-lvl} then 
              do: 
                  v-value = rvd-lvl:screen-value .
              end.       
          when {&place-rvd-tmp} then 
              do: 
                  v-value = rvd-tmp:screen-value .
              end.       
                                                           
      end case.
    find first ub.place no-lock where recid(ub.place) = p-rep-rec .
    run placelib_write-attr  (input v-code
      ,input p-obj-code
      ,input p-obj-type
      ,input ub.place.pl-code
      ,input v-value
      ,output v-ok      ) no-error.

  end.
  end.
if AVAILABLE (ub.place) then 
do:
{ gbl/rum-runa.i
    ?
    this-procedure:handle
    ?
    {&thref-proc_ref-event}
    " buffer ub.place:handle "
    " buffer ub.place:handle "
    ''
    ''
    no-error
  }
  if error-status :error
    then
  do:
    message
      error-status:get-message(1) skip
      return-value
      view-as alert-box error .

    return no-apply .

  end.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-hist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-hist d-pl-form
ON CHOOSE OF B-hist IN FRAME d-pl-form /* История */
DO:
    define variable v-rid-list as character no-undo.
    run ref/cplchist.w
      ( input parparentproc
      , input p-obj-type
      , input p-obj-code
      , input "":u /*bttns  */
      , input "one":u /*p-mode*/
      , input tt-place.obj-type
      , input tt-place.obj-code
      , input tt-place.pl-code
      , input 0 /*p-gds-code*/
      , input 0 /*p-pump-code*/
      , input 0 /*p-nozzle-code*/
      , input '':u /*p-subject*/
      , input-output v-rid-list
      ) no-error .

  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-quit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-quit d-pl-form
ON CHOOSE OF b-quit IN FRAME d-pl-form /* Отмена */
DO:
    p-rep-rec = ?.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dens-prov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dens-prov d-pl-form
ON LEAVE OF dens-prov IN FRAME d-pl-form /* Плотность при поверке резервуара */
DO:
  if input frame {&frame-name} {&self-name} <> {&self-name} then do:
    if input frame {&frame-name} dens-prov = ?
      or (  input frame {&frame-name} dens-prov <= 0
            or input frame {&frame-name} dens-prov >= 1
              )
    then do:
      message "Неверно определена плотность при поверке резервуара" view-as alert-box error.
      apply "entry" to dens-prov .
      return no-apply.
    end.

    assign frame {&frame-name} dens-prov.
  end.
if AVAILABLE (ub.place) then 
do:
{ gbl/rum-runa.i
    ?
    this-procedure:handle
    ?
    {&thref-proc_ref-event}
    " buffer ub.place:handle "
    " buffer ub.place:handle "
    ''
    ''
    no-error
  }
  if error-status :error
    then
  do:
    message
      error-status:get-message(1) skip
      return-value
      view-as alert-box error .

    return no-apply .

  end.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-place.is-meas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-place.is-meas d-pl-form
ON VALUE-CHANGED OF tt-place.is-meas IN FRAME d-pl-form /* Измеряется приборами */
DO:
  if tt-place.is-meas:screen-value = "yes" then do:
    enable t-asi-srtif with frame {&frame-name} .
  end.  
  else do:
    disable t-asi-srtif with frame {&frame-name} .
  end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME place-locat
&Scoped-define SELF-NAME place-type
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL place-type d-pl-form
ON value-changed OF place-type IN FRAME d-pl-form
DO:
    if place-type:screen-value = "1" then place-ratio-error:screen-value = "0.20" .
    if place-type:screen-value = "2" then place-ratio-error:screen-value = "0.25" .
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME r-sr-izm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL r-sr-izm d-pl-form
ON CHOOSE OF r-sr-izm IN FRAME d-pl-form /* r-sr-izm */
DO:
  define variable v-node-code as integer no-undo.
  define variable v-sr-type as character no-undo.
  v-node-code = 0 .
  run ref/sr-izm.w (input parparentproc ,
                    input ""            ,
                    input {&lookup}     ,
                    input-output v-node-code,
                    output v-sr-type) no-error.
  if v-node-code <> 0 and v-node-code <> ? then do :
    place-si = v-node-code.
    place-si:screen-value = string(v-node-code).
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK d-pl-form 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
  THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.
{ gbl/app_help.i }
/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} 
  APPLY "END-ERROR":U TO SELF.

on end-error of frame {&frame-name} 
  apply "choose" to b-quit in frame {&frame-name}.
{ ref/tabhndmv.i v-tab-order underline-tb }
{ gbl/rethndmv.i v-tab-order underline-tb "APPLY 'CHOOSE' TO b-exit in frame {&frame-name}." }


MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
  ON STOP    UNDO MAIN-BLOCK,  LEAVE MAIN-BLOCK
  ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  if p-mode <> {&update}
    and p-mode <> {&add-def}
    and p-mode <> {&lookup} then 
  do:
    message
      vss-workfile vss-revision vss-description skip
      "Неверный параметр вызова p-mode" p-mode
      view-as alert-box ERROR.
    return error.
  end.

  case p-mode:
    when {&update} then do:
      find first locked_place exclusive-lock
        where recid (locked_place) = p-rep-rec
        no-error .
    end.
    when {&lookup} then do:
      find first locked_place no-lock
        where recid( locked_place ) = p-rep-rec
        no-error .
      if not available locked_place then do:
        find first locked_place no-lock
          where locked_place.obj-type = p-obj-type
            and locked_place.obj-code = p-obj-code
            and locked_place.pl-code  = p-pl-code
          no-error .
      end.
    end.
  end case.
  if not available locked_place
    and  p-mode <> {&add-def}
    then 
  do:
    message
      vss-workfile vss-revision vss-description skip
      substitute ("Не найдена запись СКЛАДСКОГО МЕСТА &1 &2&3", p-pl-code, p-obj-type, p-obj-code ) skip
      view-as alert-box error .
    undo, return error.
  end.

  for each tt-place:
    delete tt-place.
  end.
  create tt-place.
  if p-mode = {&add-def} then 
  do:
    assign
      tt-place.obj-type = p-obj-type
      tt-place.obj-code = p-obj-code
      .
  end.
  else 
  do:
    buffer-copy locked_place to tt-place.
  end.
  if p-mode <> {&lookup} then 
  do :
    if ( tt-place.max-qnty = 0
      or tt-place.max-qnty = ?
      )
      then 
    do:
      assign
        t-chk-max-qnty = false
        .
    end.
    else 
    do:
      assign
        t-chk-max-qnty = (if locked_place.whole-send-news = 0 then true else false)
        .
    end.
  end.
  ii = 0.
  do ii = 1 to num-entries({&list-place-attr},','):
    v-code = entry(ii,{&list-place-attr}) .
    run placelib_get-attr  ( input v-code
      ,input p-obj-code
      ,input p-obj-type
      ,input locked_place.pl-code
      ,output v-value
      ,output v-ok      ) no-error.
    case v-code :
      when {&place-type} then do :
        if v-ok then place-type = integer(v-value) .
      end.
      when {&place-SI} then do :
        if v-ok then place-si = integer(v-value) .
      end.
      when {&place-diameter} then do :
        if v-ok then place-diameter = decimal(v-value) .
      end.
       when {&dead-balance} then do :
        if v-ok then dead-balance = decimal(v-value) .
      end.
      when {&place-ratio-error} then do :
        if v-ok then place-ratio-error = decimal(v-value) .
      end.
      when {&place-dens-prov} then do :
        if v-ok then dens-prov = decimal(v-value) .
      end.
      when {&place-virtual} then do :
        if v-ok then t-place-virtual = logical(v-value) .
      end.
      when {&place-twice-code} then do: 
        if v-ok then place-twice-code = v-value .
      end.
/*      when {&place-sert-urov} then do :              */
/*        if v-ok then t-sert-urov = logical(v-value) .*/
/*      end.                                           */
      when {&place-local} then do :
        if v-ok then place-locat = integer(v-value) .
      end.  
      when {&place-error-mass} then do :
        if v-value = "" then 
        do:
          v-value = "0.15" .
          run placelib_write-attr  (input v-code
            ,input p-obj-code
            ,input p-obj-type
            ,input locked_place.pl-code
            ,input v-value
            ,output v-ok      ) no-error.
        end.  
        if v-ok then error-mass = decimal(v-value) . 
      end.  
      when {&place-asi-sertif} then do :
        if v-ok then t-asi-srtif = logical(v-value) .
      end.              
      when {&place-rvd-dnsty} then do :
        if v-ok then rvd-dnstv = logical(v-value) .
      end.
      when {&place-rvd-lvl} then do :
        if v-ok then rvd-lvl = logical(v-value) .
      end.        
      when {&place-rvd-tmp} then do :
        if v-ok then rvd-tmp = logical(v-value) .
      end.                
    end case.
  end.
  run Myenable in this-procedure .
  wait-for go of frame {&frame-name}.
end.
run disable_UI in this-procedure .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI d-pl-form  _DEFAULT-DISABLE
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
  HIDE FRAME d-pl-form.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI d-pl-form  _DEFAULT-ENABLE
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
  DISPLAY t-place-virtual t-asi-srtif rvd-dnstv rvd-lvl rvd-tmp place-type 
          place-locat error-mass place-si dead-balance place-diameter 
          place-ratio-error dens-prov place-twice-code t-chk-max-qnty 
      WITH FRAME d-pl-form.
  IF AVAILABLE tt-place THEN 
    DISPLAY tt-place.loc1 tt-place.loc2 tt-place.loc3 tt-place.loc4 
          tt-place.pl-name tt-place.is-meas tt-place.pl-code tt-place.issue-year 
          tt-place.start-date tt-place.add-qnty tt-place.max-qnty tt-place.PS 
      WITH FRAME d-pl-form.
  ENABLE b-exit b-quit B-hist b-help tt-place.loc1 tt-place.loc2 tt-place.loc3 
         tt-place.loc4 tt-place.pl-name t-place-virtual tt-place.is-meas 
         rvd-dnstv rvd-lvl rvd-tmp tt-place.issue-year place-type 
         tt-place.start-date place-locat tt-place.add-qnty error-mass 
         tt-place.max-qnty place-si r-sr-izm dead-balance place-diameter 
         place-ratio-error dens-prov place-twice-code t-chk-max-qnty 
         tt-place.PS 
      WITH FRAME d-pl-form.
  {&OPEN-BROWSERS-IN-QUERY-d-pl-form}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Myenable d-pl-form 
PROCEDURE Myenable :
/* */
  run enable_UI in this-procedure .
  assign
    v-tab-order = "loc1,loc2,loc3,loc4,pl-name,is-meas,"
                  + "issue-year,start-date,add-qnty,max-qnty,t-chk-max-qnty,"
                  + "ps,place-type,place-SI,r-sr-izm,place-diameter,dead-balance,place-ratio-error,dens-prov,t-place-virtual,place-twice-code,t-sert-urov".
  if p-mode = {&lookup} then do:
    disable
      all
      with frame {&frame-name} .
    hide
      b-exit
      in frame {&frame-name} .
    assign
      b-quit:label  = "&Выход"
      b-quit:column = 1
      .
  end.
  if p-mode = {&add-def} then 
  do:
    hide
      tt-place.pl-code
      in frame {&frame-name} .
  end.
  assign
    frame {&frame-name}:title = substitute("Складское место &1 на объекте : &2&3 &4", tt-place.pl-code, p-obj-type, p-obj-code, p-mode)
    .
  if tt-place.is-meas then do:
    enable t-asi-srtif with frame {&frame-name} .
  end.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

