&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Экран просмотра дополнительной информации по приемке топлива

Автор: Уханов Дмитрий Юрьевич
Дата создания: 07/23/07
Author: Dmitry Ukhanov
Creation date: 07/23/07

Автор1: Суслов Алексей Юрьевич
Дата создания1: 09/12/05

*/
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Экран просмотра дополнительной информации по приемке топлива".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ cmp/showinf.i }
{ str/lib-calc.i }
{ ref/sr-izm.i sr-izmerenia ds}
{ ref/sr-izm.i " " proc }
{ gbl/ptrlprop.i def}
{ gbl/cur-time.i }
{ ref/gds-attr.i }
{ gbl/godendo.i}
{ gbl/sel-date.i}   
/* Parameters Definitions ---                                            */
define input        parameter parparentproc       as   handle                no-undo .
define input        parameter p-mode              as   character             no-undo .
define input        parameter p-doc-code          like ub.trn-doc.doc-code   no-undo .
define input        parameter p-gds-code          like ub.goods.gds-code     no-undo .
define input-output parameter p-car-vol           as   character             no-undo .
define input-output parameter p-tests             as   character             no-undo .
define input-output parameter p-time-pour         as   character             no-undo .
define input-output parameter p-tank-vol          as   character             no-undo .
define input-output parameter p-tank-temp         as   character             no-undo .
define input-output parameter p-tank-water        as   character             no-undo .
define input-output parameter p-tank-density      as   character             no-undo .
define input-output parameter p-tank-weight       as   character             no-undo .
define input-output parameter p-date-start        like ub.rvs-line.real-date no-undo .
define input-output parameter p-time-start        like ub.rvs-line.real-time no-undo .
define input-output parameter p-date-end          like ub.rvs-line.real-date no-undo .
define input-output parameter p-time-end          like ub.rvs-line.real-time no-undo .
define input-output parameter p-mouth             as   character             no-undo .
define input-output parameter p-a-b-tarir         as   character             no-undo .
define input-output parameter p-diameter          as   character             no-undo .
define input-output parameter p-place-si          as   character             no-undo .
define input-output parameter p-tank-density-pomi as   character             no-undo .
define input-output parameter p-tank-vol-pomi     as   character             no-undo .
define input-output parameter p-dens-temp         as   character             no-undo .
define input-output parameter p-certif-fuel       as   character             no-undo .
define input-output parameter p-norm-doc          as   character             no-undo .
define input-output parameter p-num-passport      as   character             no-undo .
define input-output parameter p-validity-certif   as   character             no-undo .
define input-output parameter p-num-plotn         as   character             no-undo . 
define input-output parameter p-passport-plotn    as   character             no-undo .

define input-output parameter p-date-pov-plotn    like ub.rvs-line.real-date no-undo .
define       output parameter p-was-setting       as   logical               no-undo initial no .

define variable rdcvalue      as char initial ? no-undo.
define variable rdctype       as char initial ? no-undo.
define variable v-log as logical no-undo .
define variable v-autoent-obj-type as character no-undo.
define variable v-autoent-obj-code as integer no-undo.
define variable v-last-gds-code like ub.goods.gds-code no-undo .
define variable v-fuel-type as character no-undo.
define variable v-gds-attr-value as character no-undo .
define variable v-gds-attr-type  as character no-undo .
define variable v-sr-type as integer no-undo.  
define variable rdc-dnstvalue as character no-undo.
define variable rdc-dnsttype  as character no-undo.
define buffer buf_clob-bind for ub.clob-bind.
define stream outstream.


/* Local Variable Definitions ---                                       */
{ str/valddnst.i def }

define buffer buf_goods for ub.goods .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 RECT-1 RECT-4 RECT-5 RECT-6 RECT-8 ~
b-save b-quit b-help f-tests f-car-vol f-size f-num-passport f-norm-doc ~
f-certif-fuel f-validity-certif f-a-b-tarir f-mouth f-tank-water ~
f-tank-temp f-tank-density f-dens-temp f-num-plotn f-date-pov-plotn ~
f-date-start f-hour-start f-min-start f-date-end f-hour-end f-min-end ~
f-hour-pour f-min-pour 
&Scoped-Define DISPLAYED-OBJECTS f-tests f-car-vol f-size ~
f-num-passport f-norm-doc f-certif-fuel f-validity-certif f-a-b-tarir ~
f-mouth f-tank-water f-tank-vol f-tank-temp f-tank-density f-dens-temp ~
f-tank-weight f-place-si f-num-plotn f-date-pov-plotn f-tank-density-pomi ~
f-tank-vol-pomi f-date-start f-hour-start f-min-start f-date-end f-hour-end ~
f-min-end f-hour-pour f-min-pour f-place-si-name 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-calc 
     LABEL "Рассчитать" 
     SIZE 15 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-choose-date-pov-plotn 
     IMAGE-UP FILE "btn-down-arrow":U
     IMAGE-DOWN FILE "btn-down-arrow":U
     IMAGE-INSENSITIVE FILE "btn-down-arrow":U
     LABEL "b-choose-date-pov-plotn" 
     SIZE 3 BY 1.

DEFINE BUTTON b-copy-iz 
     LABEL "Копировать" 
     SIZE 15 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-help 
     LABEL "&Помощь" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-quit AUTO-END-KEY 
     LABEL "&Отмена" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-save AUTO-GO 
     LABEL "&Сохранить" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON r-sr-izm 
     IMAGE-UP FILE "btn-down-arrow":U
     IMAGE-DOWN FILE "btn-down-arrow":U
     IMAGE-INSENSITIVE FILE "btn-down-arrow":U
     LABEL "r-sr-izm" 
     SIZE 3 BY 1.

DEFINE VARIABLE f-a-b-tarir AS DECIMAL FORMAT "->>>,>>9.99":U INITIAL 0 
     LABEL "Уровень цистерны относительно тарировочной планки" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE f-car-vol AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.999":U INITIAL 0 
     LABEL "Объем по паспорту в литрах" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE f-certif-fuel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY .89 NO-UNDO.

DEFINE VARIABLE f-date-end AS DATE FORMAT "99/99/99":U 
     LABEL "Дата конца слива" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .89 NO-UNDO.

DEFINE VARIABLE f-date-pov-plotn AS DATE FORMAT "99/99/99":U 
     LABEL "Дата поверки" 
     VIEW-AS FILL-IN 
     SIZE 10.75 BY 1 NO-UNDO.

DEFINE VARIABLE f-date-start AS DATE FORMAT "99/99/99":U 
     LABEL "Дата начала слива" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .89 NO-UNDO.

DEFINE VARIABLE f-dens-temp AS DECIMAL FORMAT "->9.999":U INITIAL ? 
     LABEL "Температура замера плотности" 
     VIEW-AS FILL-IN 
     SIZE 7.38 BY 1 NO-UNDO.

DEFINE VARIABLE f-size AS character init "0"
     LABEL "Размер горловины" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE f-hour-end AS INTEGER FORMAT "99":U INITIAL ? 
     LABEL "Время конца слива" 
     VIEW-AS FILL-IN 
     SIZE 3 BY 1 NO-UNDO.

DEFINE VARIABLE f-hour-pour AS INTEGER FORMAT "99":U INITIAL ? 
     LABEL "Время налива" 
     VIEW-AS FILL-IN 
     SIZE 3 BY 1 NO-UNDO.

DEFINE VARIABLE f-hour-start AS INTEGER FORMAT "99":U INITIAL ? 
     LABEL "Время начала слива" 
     VIEW-AS FILL-IN 
     SIZE 3 BY 1 NO-UNDO.

DEFINE VARIABLE f-min-end AS INTEGER FORMAT "99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 3 BY 1 NO-UNDO.

DEFINE VARIABLE f-min-pour AS INTEGER FORMAT "99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 3 BY 1 NO-UNDO.

DEFINE VARIABLE f-min-start AS INTEGER FORMAT "99":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 3 BY 1 NO-UNDO.

DEFINE VARIABLE f-mouth AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.999":U INITIAL 0 
     LABEL "Объем горловины" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE f-norm-doc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY .89 NO-UNDO.

DEFINE VARIABLE f-num-passport AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 61 BY .89 NO-UNDO.

DEFINE VARIABLE f-num-plotn AS CHARACTER FORMAT "X(256)":U 
     LABEL "Номер" 
     VIEW-AS FILL-IN 
     SIZE 54.5 BY .89 NO-UNDO.

DEFINE VARIABLE f-passport-plotn AS CHARACTER FORMAT "X(256)":U 
     LABEL "Паспорт плотномера №" 
     VIEW-AS FILL-IN 
     SIZE 20.75 BY 1 NO-UNDO.

DEFINE VARIABLE f-place-si AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "Средство измерения" 
     VIEW-AS FILL-IN 
     SIZE 5.63 BY 1 NO-UNDO.

DEFINE VARIABLE f-place-si-name AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 31.5 BY .78 NO-UNDO.

DEFINE VARIABLE f-tank-density AS DECIMAL FORMAT "9.9999999999":U INITIAL ? 
     LABEL "Плотность топлива" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE f-tank-density-pomi AS DECIMAL FORMAT "9.9999999999":U INITIAL ? 
     LABEL "Плотность приведенная" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE f-tank-temp AS DECIMAL FORMAT "->9.999":U INITIAL ? 
     LABEL "Температура замера объема" 
     VIEW-AS FILL-IN 
     SIZE 7.38 BY 1 NO-UNDO.

DEFINE VARIABLE f-tank-vol AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.999":U INITIAL 0 
     LABEL "Объем топлива" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE f-tank-vol-pomi AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.999":U INITIAL ? 
     LABEL "Объем топлива приведенный" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE f-tank-water AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.999":U INITIAL 0 
     LABEL "Объем воды" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE f-tank-weight AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.999":U INITIAL ? 
     LABEL "Вес топлива" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1
     FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE f-tests AS CHARACTER FORMAT "X(256)":U 
     LABEL "Номер пробы" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE f-validity-certif AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53.5 BY .89 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81.5 BY 2.74.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81.5 BY 3.74.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81.5 BY 7.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81.5 BY 4.15.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81.63 BY 6.74.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81.5 BY 2.59.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     b-save AT ROW 1 COL 2
     b-quit AT ROW 1 COL 12
     b-help AT ROW 1 COL 71
     f-tests AT ROW 2.52 COL 29 COLON-ALIGNED
     f-car-vol AT ROW 3.74 COL 29 COLON-ALIGNED
     f-size AT ROW 3.74 COL 65.75 COLON-ALIGNED WIDGET-ID 20
     f-num-passport AT ROW 5.3 COL 18 COLON-ALIGNED NO-LABEL WIDGET-ID 36
     f-norm-doc AT ROW 7.15 COL 20 NO-LABEL WIDGET-ID 38
     f-certif-fuel AT ROW 8.89 COL 20 NO-LABEL WIDGET-ID 44
     f-validity-certif AT ROW 10.7 COL 27.5 NO-LABEL WIDGET-ID 50
     f-a-b-tarir AT ROW 12.41 COL 65.5 COLON-ALIGNED WIDGET-ID 2
     f-mouth AT ROW 13.67 COL 19.5 COLON-ALIGNED
     f-tank-water AT ROW 13.67 COL 65.5 COLON-ALIGNED
     f-tank-vol AT ROW 15.04 COL 19.38 COLON-ALIGNED
     f-tank-temp AT ROW 15.15 COL 65.5 COLON-ALIGNED
     f-tank-density AT ROW 16.41 COL 19.38 COLON-ALIGNED
     f-dens-temp AT ROW 16.52 COL 65.5 COLON-ALIGNED WIDGET-ID 26
     f-tank-weight AT ROW 17.7 COL 19.38 COLON-ALIGNED
     f-place-si AT ROW 19.48 COL 18.25 COLON-ALIGNED WIDGET-ID 16
     r-sr-izm AT ROW 19.52 COL 26 WIDGET-ID 18
     b-copy-iz AT ROW 19.67 COL 66 WIDGET-ID 22
     f-num-plotn AT ROW 20.7 COL 7 COLON-ALIGNED WIDGET-ID 76
     f-date-pov-plotn AT ROW 21.74 COL 12.63 COLON-ALIGNED WIDGET-ID 64
     b-choose-date-pov-plotn AT ROW 21.74 COL 25.5 WIDGET-ID 72
     f-passport-plotn AT ROW 21.74 COL 57.5 COLON-ALIGNED WIDGET-ID 68
     f-tank-density-pomi AT ROW 23.3 COL 21 COLON-ALIGNED WIDGET-ID 24
     b-calc AT ROW 23.82 COL 66 WIDGET-ID 80
     f-tank-vol-pomi AT ROW 24.52 COL 25.5 COLON-ALIGNED WIDGET-ID 28
     f-date-start AT ROW 26.3 COL 19.38 COLON-ALIGNED
     f-hour-start AT ROW 26.3 COL 71.75 COLON-ALIGNED
     f-min-start AT ROW 26.3 COL 75.38 COLON-ALIGNED NO-LABEL
     f-date-end AT ROW 27.37 COL 19.38 COLON-ALIGNED
     f-hour-end AT ROW 27.37 COL 71.75 COLON-ALIGNED
     f-min-end AT ROW 27.37 COL 75.38 COLON-ALIGNED NO-LABEL
     f-hour-pour AT ROW 28.59 COL 71.63 COLON-ALIGNED
     f-min-pour AT ROW 28.59 COL 75.25 COLON-ALIGNED NO-LABEL
     f-place-si-name AT ROW 19.67 COL 29.63 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     "Паспорт качества №:" VIEW-AS TEXT
          SIZE 17 BY .67 AT ROW 5.44 COL 2.5 WIDGET-ID 58
     "топлива) из паспорта качества:" VIEW-AS TEXT
          SIZE 25 BY .67 AT ROW 10.74 COL 2.5 WIDGET-ID 54
     "Срок действия сертификата соответствия завода-изготовителя (на марку моторного" VIEW-AS TEXT
          SIZE 67.5 BY .67 AT ROW 10 COL 2.5 WIDGET-ID 52
     "Сертификат соответствия завода-изготовителя (на марку моторного топлива) № :" VIEW-AS TEXT
          SIZE 78.13 BY .67 AT ROW 8.19 COL 2.5 WIDGET-ID 46
     "из паспорта качества:" VIEW-AS TEXT
          SIZE 17.5 BY .67 AT ROW 7.19 COL 2.5 WIDGET-ID 42
     "Нормативный документ завода-изготовителя (ГОСТ, ТУ на марку моторного топлива)" VIEW-AS TEXT
          SIZE 78.13 BY .67 AT ROW 6.44 COL 2.5 WIDGET-ID 40
     RECT-3 AT ROW 19.3 COL 1
     RECT-1 AT ROW 2.26 COL 1
     RECT-4 AT ROW 12.15 COL 1 WIDGET-ID 30
     RECT-5 AT ROW 25.63 COL 1 WIDGET-ID 32
     RECT-6 AT ROW 5.15 COL 1 WIDGET-ID 34
     RECT-8 AT ROW 23.04 COL 1 WIDGET-ID 82
     SPACE(0.37) SKIP(4.43)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Дополнительная информация по приемке топлива"
         DEFAULT-BUTTON b-save CANCEL-BUTTON b-quit.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON b-calc IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b-choose-date-pov-plotn IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
ASSIGN 
       b-choose-date-pov-plotn:HIDDEN IN FRAME Dialog-Frame           = TRUE.

/* SETTINGS FOR BUTTON b-copy-iz IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-certif-fuel IN FRAME Dialog-Frame
   ALIGN-L                                                              */
ASSIGN 
       f-date-pov-plotn:HIDDEN IN FRAME Dialog-Frame           = TRUE.

/* SETTINGS FOR FILL-IN f-norm-doc IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN f-passport-plotn IN FRAME Dialog-Frame
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       f-passport-plotn:HIDDEN IN FRAME Dialog-Frame           = TRUE.

/* SETTINGS FOR FILL-IN f-place-si IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-place-si-name IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-tank-density-pomi IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-tank-vol IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-tank-vol-pomi IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-tank-weight IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-validity-certif IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR BUTTON r-sr-izm IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON GO OF FRAME Dialog-Frame /* Дополнительная информация по приемке топлива */
DO: 
  define variable stfactplvalue as character no-undo initial ? .
  define variable stfactpltype  as character no-undo initial ? .
  define variable v-update      as logical   no-undo initial true .
  define variable v-revision    as logical   no-undo initial false .
  define variable v-percrev     as decimal   no-undo initial ? .
  define variable v-auto-tank   as logical   no-undo initial false .
  define variable v-percauto    as decimal   no-undo initial ? .
  define variable v-inv         as logical   no-undo initial false .
  define variable v-percinv     as decimal   no-undo initial ? .
  define variable v-inv-set     as logical   no-undo initial false .

  { gbl/conf-rd.i
    "'stfactpl'"
    "''"
    "''"
    0
    "''"
    "''"
    "''"
    no
    stfactplvalue
    stfactpltype
    no-error
  }
  if error-status :error then do:
    /*да просто ничего не надо */
  end.
  if stfactplvalue <> "":U then do:
    { str/chkqtpl.i
      stfactplvalue
      v-update
      v-revision
      v-percrev
      v-auto-tank
      v-percauto
      v-inv
      v-percinv
      v-inv-set
    }
  end.
  if v-auto-tank = true
    or v-inv = true
  then do:
    if input frame {&frame-name} f-car-vol <= 0 or
       input frame {&frame-name} f-car-vol = ?
    then do:
      message "Объем по паспорту в литрах должен быть больше 0." view-as alert-box .
      apply "entry" to f-car-vol in frame {&frame-name} .
      return no-apply .
    end.
    if rdc-dnstvalue = "pomi-rn" then do:
        if input frame {&frame-name} f-certif-fuel = ""
        then do:
          message "Не заполнен Сертификат соответствия завода-изготовителя (на марку моторного топлива)." view-as alert-box .
          apply "entry" to f-certif-fuel in frame {&frame-name} .
          return no-apply .
        end.
        if input frame {&frame-name} f-norm-doc = ""
        then do:
          message "Не заполнен Нормативный документ завода-изготовителя." view-as alert-box .
          apply "entry" to f-norm-doc in frame {&frame-name} .
          return no-apply .
        end.
        if input frame {&frame-name} f-num-passport = ""
        then do:
          message "Не заполнен Номер паспорта качества." view-as alert-box .
          apply "entry" to f-num-passport in frame {&frame-name} .
          return no-apply .
        end.
        if input frame {&frame-name} f-validity-certif = ""
        then do:
          message "Не указан Срок действия сертификата соответствия завода-изготовителя." view-as alert-box .
          apply "entry" to f-validity-certif in frame {&frame-name} .
          return no-apply .
        end.        
        if input frame {&frame-name} f-tank-vol <= 0 or
           input frame {&frame-name} f-tank-vol  = ?
        then do:
          message "Объем топлива должен быть больше 0." view-as alert-box .
          apply "entry" to f-tank-vol in frame {&frame-name} .
          return no-apply .
        end.
        if input frame {&frame-name} f-tank-weight <= 0 or
           input frame {&frame-name} f-tank-weight  = ?
        then do:
          message "Вес топлива должен быть больше 0." view-as alert-box .
          apply "entry" to f-tank-weight in frame {&frame-name} .
          return no-apply .
        end.
        if input frame {&frame-name} f-tank-density = ?
          or Valid-Density( input frame {&frame-name} f-tank-density, (buf_goods.unit-base = buf_goods.unit-cli) ) <> yes
        then do:
          message "Плотность должна быть больше 0 и меньше 1." view-as alert-box .
          apply "entry" to f-tank-density in frame {&frame-name} .
          return no-apply .
        end.
        if input frame {&frame-name} f-place-si = 0
        then do:
          message "Введите средство измерения." view-as alert-box .
          apply "entry" to f-place-si in frame {&frame-name} .
          return no-apply .
        end.    
        if input frame {&frame-name} f-date-start = ""
        then do:
          message "Введите дату начала слива." view-as alert-box .
          apply "entry" to f-date-start in frame {&frame-name} .
          return no-apply .
        end.    
        if input frame {&frame-name} f-date-end = ""
        then do:
          message "Введите дату конца слива." view-as alert-box .
          apply "entry" to f-date-end in frame {&frame-name} .
          return no-apply .
        end.    
        if input frame {&frame-name} f-hour-start = ? or
           input frame {&frame-name} f-min-start = ?
        then do:
          message "Введите время начала слива." view-as alert-box .
          apply "entry" to f-hour-start in frame {&frame-name} .
          return no-apply .
        end.    
        if input frame {&frame-name} f-hour-end = ? or 
           input frame {&frame-name} f-min-end = ?
        then do:
          message "Введите время конца слива." view-as alert-box .
          apply "entry" to f-hour-end in frame {&frame-name} .
          return no-apply .
        end.    
        if input frame {&frame-name} f-hour-pour = ? or
           input frame {&frame-name} f-min-pour = ?
        then do:
          message "Введите время налива." view-as alert-box .
          apply "entry" to f-hour-pour in frame {&frame-name} .
          return no-apply .
        end.   
        if f-place-si:screen-value <> "" then do: 
           if v-sr-type = 1 or v-sr-type = 2 then do:
            if input frame {&frame-name} f-num-plotn = ""
            then do:
              message "Введите номер измерения." view-as alert-box .
              apply "entry" to f-num-plotn in frame {&frame-name} .
              return no-apply .
            end.
            if input frame {&frame-name} f-date-pov-plotn = ""
            then do:
              message "Введите дату поверки ." view-as alert-box .
              apply "entry" to f-date-pov-plotn in frame {&frame-name} .
              return no-apply .
            end.
           end. 
        end.     
        if f-place-si:screen-value <> "" then do:
           if v-sr-type = 3 or v-sr-type = 4 then do:
            if input frame {&frame-name} f-num-plotn = ""
            then do:
              message "Введите номер измерения." view-as alert-box .
              apply "entry" to f-num-plotn in frame {&frame-name} .
              return no-apply .
            end.
            if input frame {&frame-name} f-date-pov-plotn = ""
            then do:
              message "Введите дату поверки." view-as alert-box .
              apply "entry" to f-date-pov-plotn in frame {&frame-name} .
              return no-apply .
            end.
            if input frame {&frame-name} f-passport-plotn = ""
            then do:
              message "Введите номер паспорта плотномера." view-as alert-box .
              apply "entry" to f-passport-plotn in frame {&frame-name} .
              return no-apply .
            end.
          end.
        end.
      end.
  end.
/*    if input frame {&frame-name} f-tank-density <> ?                                                                  */
/*      and Valid-Density( input frame {&frame-name} f-tank-density, (buf_goods.unit-base = buf_goods.unit-cli) ) <> yes*/
/*    then do:                                                                                                          */
/*      message "Плотность должна быть больше 0 и меньше 1." view-as alert-box .                                        */
/*      apply "entry" to f-tank-density in frame {&frame-name} .                                                        */
/*      return no-apply .                                                                                               */
/*    end.                                                                                                              */
  if input frame {&frame-name} f-hour-pour <> ?
    and input frame {&frame-name} f-hour-pour > 24
  then do:
     message "Неверно заведено поле <<час>>." view-as alert-box .
     apply "entry" to f-hour-pour in frame {&frame-name} .
     return no-apply .
  end.
  if input frame {&frame-name} f-hour-start <> ?
    and input frame {&frame-name} f-hour-start > 24
  then do:
     message "Неверно заведено поле <<час>>." view-as alert-box .
     apply "entry" to f-hour-start in frame {&frame-name} .
     return no-apply .
  end.
  if input frame {&frame-name} f-hour-end > 24
  then do:
     message "Неверно заведено поле час." view-as alert-box .
     apply "entry" to f-hour-end in frame {&frame-name} .
     return no-apply .
  end.
  if input frame {&frame-name} f-min-pour > 60
  then do:
     message "Неверно заведено поле <<минуты>>." view-as alert-box .
     apply "entry" to f-min-pour in frame {&frame-name} .
     return no-apply .
  end.
  if input frame {&frame-name} f-min-start > 60
  then do:
     message "Неверно заведено поле <<минуты>>." view-as alert-box .
     apply "entry" to f-min-start in frame {&frame-name} .
     return no-apply .
  end.
  if input frame {&frame-name} f-min-end > 60
  then do:
     message "Неверно заведено поле <<минуты>>." view-as alert-box .
     apply "entry" to f-min-end in frame {&frame-name} .
     return no-apply .
  end.
  assign frame {&frame-name} f-car-vol f-tests
                             f-hour-pour f-min-pour
                             f-hour-start f-min-start
                             f-hour-end f-min-end
                             f-date-start f-date-end
                             f-tank-vol f-tank-temp
                             f-tank-water f-tank-density
                             f-mouth
                             f-a-b-tarir
                             f-tank-vol-pomi f-dens-temp
                             f-certif-fuel f-norm-doc
                             f-num-passport f-validity-certif
                             f-date-pov-plotn
                             f-passport-plotn f-num-plotn
  .
 
  assign
    p-car-vol          = string( f-car-vol )
    p-tests            = f-tests
    p-time-pour        = string( f-hour-pour,   "99":U ) + ":" + string( f-min-pour,   "99":U )
    p-time-start       = f-hour-start * 3600 + f-min-start * 60
    p-time-end         = f-hour-end   * 3600 + f-min-end   * 60
    p-date-start       = f-date-start
    p-date-end         = f-date-end
    p-mouth            = string( f-mouth )
    p-tank-vol         = string( f-tank-vol     )
    p-tank-temp        = string( f-tank-temp    )
    p-tank-vol-pomi         = string( f-tank-vol-pomi     )
    p-dens-temp        = string( f-dens-temp    )
    p-tank-water       = string( f-tank-water   )
    p-tank-density     = string( f-tank-density )
    p-tank-weight      = string( f-tank-weight  )
    p-a-b-tarir        = string( f-a-b-tarir    )
    p-diameter         = string( f-size     )
    p-place-si         = string( f-place-si     )
    p-tank-density-pomi = string( f-tank-density-pomi )
    p-tank-vol-pomi    = string( f-tank-vol-pomi     )
    p-dens-temp        = string( f-dens-temp    )
    p-certif-fuel      = string (f-certif-fuel)
    p-norm-doc         = string (f-norm-doc)
    p-num-passport     = string (f-num-passport)
    p-validity-certif  = string (f-validity-certif)
   no-error.
  if p-place-si <> "0" then do:
    if v-sr-type = 1 or v-sr-type = 2 then do:
      assign
      p-num-plotn = f-num-plotn
      p-date-pov-plotn = f-date-pov-plotn.
    end.
    if v-sr-type = 3 or v-sr-type = 4 then do:
      assign
      p-num-plotn = f-num-plotn
      p-passport-plotn = f-passport-plotn
      p-date-pov-plotn = f-date-pov-plotn.
    end.
  end.  
  assign
    p-was-setting = yes
  .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Дополнительная информация по приемке топлива */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-calc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-calc Dialog-Frame
ON CHOOSE OF b-calc IN FRAME Dialog-Frame /* Рассчитать */
DO:
  define variable ToolType                as integer no-undo.
  define variable DeltaAbs_R              as decimal no-undo.
  define variable DeltaAbs_Tv             as decimal no-undo.
  define variable DeltaAbs_Tr             as decimal no-undo.
  define variable temp-for-pomi           as integer no-undo.
  define variable error-string            as character no-undo.
  define variable v-mm as com-handle.
  define variable v-proc as character no-undo.
  define buffer buf_clob-bind    for ub.clob-bind.

  assign
  f-car-vol
  f-tank-vol
  f-a-b-tarir
  f-size
  f-tank-temp
  f-tank-density
  f-dens-temp
  f-place-si
  .


  case rdc-dnstvalue:
    when "pomi-rn" then do:
      _trpomi :
        do on error undo, return no-apply :
  

          /*данные по средству измерения резервуара для ПО МИ*/
        run sr-izmerenia_fill-sr-izm in this-procedure ( input {&lookup}
                                                    , buffer buf_clob-bind).
        find first sr-izmerenia no-lock where sr-izmerenia.node-code = f-place-si no-error.
        if error-status :error or not available sr-izmerenia then do :
  
          message
            substitute( 'Не найдено средство измерения с кодом &1', f-place-si ) skip
          view-as alert-box error.
          undo _trpomi, return no-apply  .
  
        end.
        else do :
          assign
            ToolType               = integer(sr-izmerenia.sr-type)
            DeltaAbs_R             = sr-izmerenia.sr-abs-err-dens
            DeltaAbs_Tv            = sr-izmerenia.sr-abs-err-temp-vol
            DeltaAbs_Tr            = sr-izmerenia.sr-abs-err-temp-dens
            .
        end.
        /*..........................................*/
        find first ub.trn-doc no-lock where ub.trn-doc.doc-code = p-doc-code no-error.
        { gbl/ptrlprop.i
          run
          trn-doc.obj-type
          trn-doc.obj-code
        }
        if not error-status :error then do:
          if ptrlprop-temp-for-pomi = 1 then temp-for-pomi = 15 .
                                        else temp-for-pomi = 20 .
        end.
        v-proc = "Rosneft.MethodOfMetering31" .
  
        RELEASE OBJECT v-mm NO-ERROR.
        v-mm = ?.
  
        CREATE value("Rosneft.MethodOfMetering31") v-mm no-error.
        IF ERROR-STATUS:ERROR
        OR NOT VALID-HANDLE(v-mm)
        THEN DO:
          RELEASE OBJECT v-mm NO-ERROR.
          v-mm = ?.
          message
            substitute( 'Не удается подключиться к COM-серверу библиотеки для работы с ПО МИ ' ) skip
          view-as alert-box error.
          undo _trpomi, return no-apply .
        END.
        ELSE DO :
          if f-car-vol = ? or f-car-vol = 0 then do :
            message
              "Заполнены не все поля, необходимые " skip
              "для работы библиотеки ПО МИ"         skip
              "Введите Объем по паспорту в литрах"  skip
            view-as alert-box error.
            apply "entry" to f-car-vol in frame {&frame-name} .
            undo _trpomi, return no-apply  .
          end.
          
          if f-a-b-tarir = ? then do :
            message
              "Заполнены не все поля, необходимые " skip
              "для работы библиотеки ПО МИ"         skip
              "Введите Уровень цистерны относительно тарировочной планки"  skip
            view-as alert-box error.
            apply "entry" to f-a-b-tarir in frame {&frame-name} .
            undo _trpomi, return no-apply  .
          end.
          assign
            f-size = string (decimal (f-size))
            f-size:screen-value = string (decimal (f-size)) 
          no-error.
          if f-size = ? or f-size = "0" then do :
            message
              "Заполнены не все поля, необходимые " skip
              "для работы библиотеки ПО МИ"         skip
              "Введите Внутренний диаметр горловины"  skip
            view-as alert-box error.
            apply "entry" to f-size in frame {&frame-name} .
            undo _trpomi, return no-apply  .
          end.
          if f-tank-temp = ? then do :
            message
              "Заполнены не все поля, необходимые " skip
              "для работы библиотеки ПО МИ"         skip
              "Введите Температуру"  skip
            view-as alert-box error.
            apply "entry" to f-tank-temp in frame {&frame-name} .
            undo _trpomi, return no-apply  .
          end.
          if f-tank-density = ? or f-tank-density = 0 then do :
            message
              "Заполнены не все поля, необходимые " skip
              "для работы библиотеки ПО МИ"         skip
              "Введите Плотность топлива для ПО МИ"  skip
            view-as alert-box error.
            apply "entry" to f-tank-density in frame {&frame-name} .
            undo _trpomi, return no-apply  .
          end.
          ASSIGN
            v-mm:V_real                 = f-car-vol
            v-mm:DeltaH                 = f-a-b-tarir
            v-mm:Dgor                   = decimal (f-size)
            v-mm:Tv                     = f-tank-temp
            v-mm:Tr                     = f-dens-temp
            v-mm:R                      = ( f-tank-density * 1000 )
            v-mm:Tcy                    = temp-for-pomi
            v-mm:ToolType               = ToolType
            v-mm:A_Reservoir            = 0.0000125
            v-mm:DeltaOtn_V             = 0.4
            v-mm:DeltaAbs_R             = DeltaAbs_R
            v-mm:DeltaAbs_Tv            = DeltaAbs_Tv
            v-mm:DeltaAbs_Tr            = DeltaAbs_Tr
          .
          output stream outstream to value ("pomi.log") append.
          put stream outstream
                                       cur-time-string()       skip
            'Процедура'                v-proc                  skip
            'V_real                 =' f-car-vol               skip
            'DeltaH                 =' f-a-b-tarir             skip
            'Dgor                   =' f-size              skip
            'Tv                     =' f-tank-temp             skip
            'Tr                     =' f-dens-temp             skip
            'R                      =' ( f-tank-density * 1000 ) skip
            'Tcy                    =' temp-for-pomi           skip
            'ToolType               =' ToolType                skip
            'A_Reservoir            =' 0.0000125               skip
            'DeltaOtn_V             =' 0.4                     skip
            'DeltaAbs_R             =' DeltaAbs_R              skip
            'DeltaAbs_Tv            =' DeltaAbs_Tv             skip
            'DeltaAbs_Tr            =' DeltaAbs_Tr             skip
          .
  
          output stream outstream close.
  
          v-mm:Exec() .
          if v-mm:Result <> 0 then do :
            error-string = v-mm:ResultDetail .
            output stream outstream to value ("pomi.log") append.
              put stream outstream error-string format "x(1024)" skip.
            output stream outstream close.
            RELEASE OBJECT v-mm NO-ERROR.
            v-mm = ?.
            message
              substitute('Ошибка работы библиотеки ПО МИ &1',error-string) skip
            view-as alert-box error.
            undo _trpomi, return no-apply  .
          end.
          else do :
            assign
              f-tank-density-pomi    = decimal(v-mm:Rcy) / 1000
              f-tank-vol-pomi        = v-mm:Vcy 
              f-tank-weight     = v-mm:Mcy
            .
            display
              f-tank-density-pomi
              f-tank-vol-pomi
              f-tank-weight
            with frame {&frame-name}.
            output stream outstream to value ("pomi.log") append.
              put stream outstream
              "v-mm:Rcy" f-tank-density-pomi      skip
              "v-mm:Vcy" f-tank-vol-pomi          skip
              "v-mm:Mcy" f-tank-weight       skip .
            output stream outstream close.
            RELEASE OBJECT v-mm NO-ERROR.
            v-mm = ?.
          end.
        END.
      end.
    end.
    when "th" then do:
      run gds-attr-value in this-procedure
        (  input p-gds-code
        ,  input {&attr-fuel-type}
        , output v-gds-attr-value
        , output v-gds-attr-type
        ) no-error .
      if not error-status:error and lookup (v-gds-attr-value, "petrol,diesel-sum,diesel-wint") > 0 then do:
        assign
          v-fuel-type = v-gds-attr-value.
        run str/rdcdnst.p (input f-tank-density * 1000
                      ,input f-dens-temp
                      ,input f-tank-vol
                      ,input f-tank-temp
                      ,input v-fuel-type
                      ,output f-tank-density-pomi 
                      ,output f-tank-vol-pomi)
        no-error.
        if not error-status:error then do:
          assign
            f-tank-weight     = f-tank-density-pomi * f-tank-vol-pomi
          .
          display
            f-tank-vol-pomi
            f-tank-density-pomi
            f-tank-weight
          with frame {&frame-name}.
        end.
        else do:
          message
            substitute('Ошибка при рассчете приведенных значений плотности и объема: &1', return-value) 
          view-as alert-box error.
          undo, return no-apply  .
        end.
      end.
      else do:
        message
          substitute('Ошибка определения типа топлива &1 или не верный тип товлива &2', return-value, v-gds-attr-value) 
        view-as alert-box error.
        undo, return no-apply  .
      end.
    end.
    
  end case.

  IF rdc-dnstvalue = "pomi-rn" THEN DO :

  END.
  enable
  f-tank-density
  with frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-choose-date-pov-plotn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-choose-date-pov-plotn Dialog-Frame
ON CHOOSE OF b-choose-date-pov-plotn IN FRAME Dialog-Frame /* b-choose-date-pov-plotn */
DO:
  { gbl/stdbtn.i }

  run sel-date in this-procedure
    ( input f-date-pov-plotn :handle
    , input "Дата поверки плотномера"
    ) .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-copy-iz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-copy-iz Dialog-Frame
ON CHOOSE OF b-copy-iz IN FRAME Dialog-Frame /* Копировать */
DO:

    run str/in-copy-iz.w
      ( input        parParentProc
       ,input        p-mode
       ,input        p-gds-code
       ,output       p-place-si
       ,output       p-num-plotn
       ,output       p-passport-plotn
       ,output       p-date-pov-plotn       
      ) no-error.


  f-place-si:screen-value = string(p-place-si).
    find first sr-izmerenia where sr-izmerenia.node-code = integer(p-place-si) no-error.
    if AVAILABLE sr-izmerenia then do:
    assign
          f-place-si-name:screen-value = sr-izmerenia.sr-model
          v-sr-type = integer(sr-izmerenia.sr-type).
    end.

  apply "leave" to f-place-si.

  
  f-num-plotn:SCREEN-VALUE = string(p-num-plotn).
  f-passport-plotn:SCREEN-VALUE = string(p-passport-plotn).
  f-date-pov-plotn:SCREEN-VALUE = string(p-date-pov-plotn).
  



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-save
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-save Dialog-Frame
ON CHOOSE OF b-save IN FRAME Dialog-Frame /* Сохранить */
DO:
  { gbl/stdbtn.i }

  apply "LEAVE":U to f-car-vol      in frame {&FRAME-NAME} . 
  apply "LEAVE":U to f-tank-density in frame {&FRAME-NAME} .
/*  apply "GO":U to frame {&FRAME-NAME} .*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-a-b-tarir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-a-b-tarir Dialog-Frame
ON LEAVE OF f-a-b-tarir IN FRAME Dialog-Frame /* Уровень цистерны относительно тарировочной планки */
DO:

    run calc-weight-vol in this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-car-vol
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-car-vol Dialog-Frame
ON LEAVE OF f-car-vol IN FRAME Dialog-Frame /* Объем по паспорту в литрах */
DO:

    run calc-weight-vol in this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-car-vol Dialog-Frame
ON return OF f-car-vol IN FRAME Dialog-Frame /* Объем по паспорту в литрах */
DO:
  apply "entry" to f-tests in frame {&frame-name}.
return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-car-vol Dialog-Frame
ON VALUE-CHANGED OF f-car-vol IN FRAME Dialog-Frame /* Объем по паспорту в литрах */
DO:
  assign
    f-tank-vol-pomi = ?
  .
  display
    f-tank-vol-pomi with frame {&frame-name}
  .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-certif-fuel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-certif-fuel Dialog-Frame
ON return OF f-certif-fuel IN FRAME Dialog-Frame
DO:

return no-apply.



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-date-end
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-date-end Dialog-Frame
ON return OF f-date-end IN FRAME Dialog-Frame /* Дата конца слива */
DO:
    apply "entry" to f-hour-end in frame {&frame-name}.
return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-date-start
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-date-start Dialog-Frame
ON return OF f-date-start IN FRAME Dialog-Frame /* Дата начала слива */
DO:
  apply "entry" to f-hour-start in frame {&frame-name}.
return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-dens-temp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-dens-temp Dialog-Frame
ON return OF f-dens-temp IN FRAME Dialog-Frame /* Температура замера плотности */
DO:
  return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-dens-temp Dialog-Frame
ON VALUE-CHANGED OF f-dens-temp IN FRAME Dialog-Frame /* Температура замера плотности */
DO:
  assign
    f-tank-density-pomi = ?
  .
  display
    f-tank-density-pomi
  .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-size
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-size Dialog-Frame
ON LEAVE OF f-size IN FRAME Dialog-Frame /* Диаметр горловины */
DO:

    run calc-weight-vol in this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-hour-end
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-hour-end Dialog-Frame
ON LEAVE OF f-hour-end IN FRAME Dialog-Frame /* Время конца слива */
DO:
  if input frame {&frame-name} f-hour-end > 24
  then do:
     message "Неверно заведено поле час." view-as alert-box .
     apply "entry" to f-hour-end in frame {&frame-name} .
     return no-apply .
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-hour-end Dialog-Frame
ON return OF f-hour-end IN FRAME Dialog-Frame /* Время конца слива */
DO:
    apply "entry" to f-min-end in frame {&frame-name}.
return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-hour-pour
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-hour-pour Dialog-Frame
ON LEAVE OF f-hour-pour IN FRAME Dialog-Frame /* Время налива */
DO:
  if input frame {&frame-name} f-hour-pour > 24
  then do:
     message "Неверно заведено поле <<час>>." view-as alert-box .
     apply "entry" to f-hour-pour in frame {&frame-name} .
     return no-apply .
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-hour-pour Dialog-Frame
ON return OF f-hour-pour IN FRAME Dialog-Frame /* Время налива */
DO:
      apply "entry" to f-min-pour in frame {&frame-name}.
return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-hour-start
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-hour-start Dialog-Frame
ON LEAVE OF f-hour-start IN FRAME Dialog-Frame /* Время начала слива */
DO:
  if input frame {&frame-name} f-hour-start > 24
  then do:
     message "Неверно заведено поле <<час>>." view-as alert-box .
     apply "entry" to f-hour-start in frame {&frame-name} .
     return no-apply .
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-hour-start Dialog-Frame
ON return OF f-hour-start IN FRAME Dialog-Frame /* Время начала слива */
DO:
apply "entry" to f-min-start in frame {&frame-name}.
return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-min-end
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-min-end Dialog-Frame
ON LEAVE OF f-min-end IN FRAME Dialog-Frame
DO:
  if input frame {&frame-name} f-min-end > 60
  then do:
     message "Неверно заведено поле <<минуты>>." view-as alert-box .
     apply "entry" to f-min-end in frame {&frame-name} .
     return no-apply .
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-min-end Dialog-Frame
ON return OF f-min-end IN FRAME Dialog-Frame
DO:
    apply "entry" to b-save in frame {&frame-name}.
return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-min-pour
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-min-pour Dialog-Frame
ON LEAVE OF f-min-pour IN FRAME Dialog-Frame
DO:
  if input frame {&frame-name} f-min-pour > 60
  then do:
     message "Неверно заведено поле <<минуты>>." view-as alert-box .
     apply "entry" to f-min-pour in frame {&frame-name} .
     return no-apply .
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-min-pour Dialog-Frame
ON return OF f-min-pour IN FRAME Dialog-Frame
DO:
apply "entry" to f-mouth in frame {&frame-name}.
return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-min-start
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-min-start Dialog-Frame
ON LEAVE OF f-min-start IN FRAME Dialog-Frame
DO:
  if input frame {&frame-name} f-min-start > 60
  then do:
     message "Неверно заведено поле <<минуты>>." view-as alert-box .
     apply "entry" to f-min-start in frame {&frame-name} .
     return no-apply .
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-min-start Dialog-Frame
ON return OF f-min-start IN FRAME Dialog-Frame
DO:
  apply "entry" to f-date-end in frame {&frame-name}.
return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-mouth
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-mouth Dialog-Frame
ON LEAVE OF f-mouth IN FRAME Dialog-Frame /* Объем горловины */
DO:
    
    run calc-weight-vol in this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-mouth Dialog-Frame
ON return OF f-mouth IN FRAME Dialog-Frame /* Объем горловины */
DO:
apply "entry" to f-tank-density in frame {&frame-name}.
return no-apply.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-mouth Dialog-Frame
ON VALUE-CHANGED OF f-mouth IN FRAME Dialog-Frame /* Объем горловины */
DO:
  assign
    f-tank-vol-pomi = ?
  .
  display
    f-tank-vol-pomi with frame {&frame-name}
  .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-norm-doc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-norm-doc Dialog-Frame
ON return OF f-norm-doc IN FRAME Dialog-Frame
DO:

return no-apply.



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-num-passport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-num-passport Dialog-Frame
ON return OF f-num-passport IN FRAME Dialog-Frame
DO:

return no-apply.



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-num-plotn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-num-plotn Dialog-Frame
ON return OF f-num-plotn IN FRAME Dialog-Frame /* Номер */
DO:

return no-apply.



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-place-si
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-place-si Dialog-Frame
ON LEAVE OF f-place-si IN FRAME Dialog-Frame /* Средство измерения */
DO:
define VARIABLE v-node-code as character no-undo.  

  
  if v-sr-type = 2 or v-sr-type = 1 then do:
      enable f-num-plotn
             f-date-pov-plotn 
             b-choose-date-pov-plotn
      with frame {&frame-name}.
      hide f-passport-plotn
           in frame {&frame-name}.
  end.
  if v-sr-type = 3 or v-sr-type = 4 then do:
      enable f-num-plotn
             f-date-pov-plotn 
             f-passport-plotn
             b-choose-date-pov-plotn
      with frame {&frame-name}.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-tank-density
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-tank-density Dialog-Frame
ON LEAVE OF f-tank-density IN FRAME Dialog-Frame /* Плотность топлива */
DO:
  
    run calc-weight-vol in this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-tank-density Dialog-Frame
ON return OF f-tank-density IN FRAME Dialog-Frame /* Плотность топлива */
DO:
      apply "entry" to f-tank-temp in frame {&frame-name}.
return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-tank-density Dialog-Frame
ON VALUE-CHANGED OF f-tank-density IN FRAME Dialog-Frame /* Плотность топлива */
DO:
  assign
    f-tank-density-pomi = ?
  .
  display
    f-tank-density-pomi
  .
  run calc-weight-vol in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-tank-density-pomi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-tank-density-pomi Dialog-Frame
ON LEAVE OF f-tank-density-pomi IN FRAME Dialog-Frame /* Плотность приведенная */
DO:
  
    run calc-weight-vol in this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-tank-temp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-tank-temp Dialog-Frame
ON return OF f-tank-temp IN FRAME Dialog-Frame /* Температура замера объема */
DO:
  return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-tank-temp Dialog-Frame
ON VALUE-CHANGED OF f-tank-temp IN FRAME Dialog-Frame /* Температура замера объема */
DO:
  assign
    f-tank-vol-pomi = ?
  .
  display
    f-tank-vol-pomi with frame {&frame-name}
  .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-tank-vol
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-tank-vol Dialog-Frame
ON return OF f-tank-vol IN FRAME Dialog-Frame /* Объем топлива */
DO:
      apply "entry" to f-tank-water in frame {&frame-name}.
return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-tank-vol-pomi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-tank-vol-pomi Dialog-Frame
ON LEAVE OF f-tank-vol-pomi IN FRAME Dialog-Frame /* Объем топлива приведенный */
DO:
  
    run calc-weight-vol in this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-tank-vol-pomi Dialog-Frame
ON return OF f-tank-vol-pomi IN FRAME Dialog-Frame /* Объем топлива приведенный */
DO:
      apply "entry" to f-tank-water in frame {&frame-name}.
return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-tank-water
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-tank-water Dialog-Frame
ON LEAVE OF f-tank-water IN FRAME Dialog-Frame /* Объем воды */
DO:
  assign
    f-tank-vol-pomi = ?
  .
  display
    f-tank-vol-pomi with frame {&frame-name}
  .
  run calc-weight-vol in this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-tank-water Dialog-Frame
ON return OF f-tank-water IN FRAME Dialog-Frame /* Объем воды */
DO:
      apply "entry" to f-tank-density in frame {&frame-name}.
return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-tank-weight
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-tank-weight Dialog-Frame
ON return OF f-tank-weight IN FRAME Dialog-Frame /* Вес топлива */
DO:
      apply "entry" to b-save in frame {&frame-name}.
return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-tests
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-tests Dialog-Frame
ON return OF f-tests IN FRAME Dialog-Frame /* Номер пробы */
DO:

return no-apply.



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-validity-certif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-validity-certif Dialog-Frame
ON return OF f-validity-certif IN FRAME Dialog-Frame
DO:

return no-apply.



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME r-sr-izm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL r-sr-izm Dialog-Frame
ON CHOOSE OF r-sr-izm IN FRAME Dialog-Frame /* r-sr-izm */
DO:
  define variable v-node-code as integer no-undo.
  
  v-node-code = 0 .
  run ref/sr-izm.w (input parparentproc ,
                    input ""            ,
                    input {&lookup}     ,
                    input-output v-node-code,
                    output v-sr-type) no-error.
  if v-node-code <> 0 and v-node-code <> ? then do :
    f-place-si = v-node-code.
    f-place-si:screen-value = string(v-node-code).
  find first sr-izmerenia where sr-izmerenia.node-code = v-node-code.
    f-place-si-name:screen-value = sr-izmerenia.sr-model.
  end.
  apply "leave" to f-place-si.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.
{ gbl/app_help.i }
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  find first buf_goods no-lock
    where buf_goods.gds-code = p-gds-code
    .
  if p-mode = "set-attr":U then do:
    run loc-get-set-attr in this-procedure
      ( input p-mode
      ) no-error .
    if error-status :error then do:
      message
        vss-workfile vss-revision vss-description skip
        "Ошибка при сохранении дополнительной информации" skip
        error-status :get-message(1) skip
        return-value skip
        view-as alert-box error .
    end.
    return .
  end.
  if p-mode = "get-attr":U then do:
    run loc-get-set-attr in this-procedure
      ( input p-mode
      ) no-error .
    if error-status :error then do:
      message
        vss-workfile vss-revision vss-description skip
        "Ошибка при чтении дополнительной информации" skip
        error-status :get-message(1) skip
        return-value skip
        view-as alert-box error .
    end.
    return .
  end.
  if can-find (first ub.doc-line no-lock where ub.doc-line.doc-code = p-doc-code and ub.doc-line.doc-density <> 0) then do:
    find first ub.doc-line no-lock where ub.doc-line.doc-code = p-doc-code
                                     and ub.doc-line.artic = buf_goods.artic
                                     and ub.doc-line.prod-code = buf_goods.prod-code
                                     and ub.doc-line.prod-type = buf_goods.prod-type no-error.
    if ub.doc-line.line-num > 1 then do :
      run loc-get-set-attr in this-procedure
        ( input "get-attr":U
        ) no-error .
      if error-status :error then do:
        message
          vss-workfile vss-revision vss-description skip
          "Ошибка при чтении дополнительной информации" skip
          error-status :get-message(1) skip
          return-value skip
          view-as alert-box error .
      end.
      if not ( 
               ( p-tests <> "" and p-tests <> "?" ) or
               ( p-car-vol <> "" and p-car-vol <> "?" )
               )
      then do :
        find first ub.doc-line no-lock where ub.doc-line.doc-code = p-doc-code
                                        and ub.doc-line.doc-density <> 0
                                        and ub.doc-line.line-num = 1 no-error.
        if available ub.doc-line then do:
          find first buf_goods where buf_goods.artic     = ub.doc-line.artic
                                and buf_goods.prod-code = ub.doc-line.prod-code
                                and buf_goods.prod-type = ub.doc-line.prod-type no-error.
          assign
          v-last-gds-code = p-gds-code.
          p-gds-code = buf_goods.gds-code
          .
  
          run loc-get-set-attr in this-procedure
            ( input "get-attr":U
            ) no-error .
          if error-status :error then do:
            message
              vss-workfile vss-revision vss-description skip
              "Ошибка при чтении дополнительной информации" skip
              error-status :get-message(1) skip
              return-value skip
              view-as alert-box error .
          end.
          assign
            p-car-vol      = "0"
            p-time-pour    = ?
            p-time-start   = ?
            p-time-end     = ?
            p-date-start   = ?
            p-date-end     = ?
            p-mouth        = ""
            p-tank-vol     = ""
            p-tank-temp    = ""
            p-tank-water   = ""
            p-tank-density = ""
            p-tank-weight  = ""
            p-a-b-tarir    = ""
            p-gds-code     = v-last-gds-code
            p-diameter     = ""
            p-place-si     = ""
            p-tank-density-pomi = ""
            p-tank-vol-pomi     = ""
            p-dens-temp    = ""
            p-certif-fuel  = ""
            p-norm-doc     = ""
            p-num-passport = ""
            p-validity-certif = ""
            v-sr-type = 0
            p-date-pov-plotn = ?
            p-passport-plotn = ""
            p-num-plotn = ""
          .
        end.
      end.
    end.
  end.
run sr-izmerenia_fill-sr-izm in this-procedure ( input p-mode
                                               , buffer buf_clob-bind).
  find first sr-izmerenia no-lock where sr-izmerenia.node-code = integer(p-place-si) no-error.
      if AVAILABLE sr-izmerenia then do:
        assign
        f-place-si-name = string(sr-izmerenia.sr-model)
        v-sr-type = integer(sr-izmerenia.sr-type).                           
      end.
     
  find first buf_goods no-lock
    where buf_goods.gds-code = p-gds-code
    .
  assign
    f-tests = p-tests
  .
  assign
    f-car-vol = decimal(p-car-vol) no-error
  .
  assign
    f-certif-fuel = p-certif-fuel
    f-norm-doc = p-norm-doc
    f-num-passport = p-num-passport
    f-validity-certif = p-validity-certif
    f-num-plotn = p-num-plotn
    f-date-pov-plotn = p-date-pov-plotn
    f-passport-plotn = p-passport-plotn.

  if error-status:error then
    message "Неверно задан объем автоцистерны по паспорту " p-car-vol " ."
    view-as alert-box error.
  assign
  f-tank-vol  = decimal(p-tank-vol) no-error.
  if error-status:error then
    message "Неверно определен объем в цистерне " p-tank-vol " . "
    view-as alert-box.
  assign
  f-tank-temp  = decimal(p-tank-temp) no-error.
  if error-status:error then
    message "Неверно определена температура в цистерне " p-tank-temp " . "
    view-as alert-box.
  assign
  f-tank-water  = decimal(p-tank-water) no-error.
  if error-status:error then
    message "Неверно определен объем воды в цистерне " p-tank-water " . "
    view-as alert-box.
  assign
  f-tank-density  = decimal(p-tank-density) no-error.
  if error-status:error then
    message "Неверно определена плотность в цистерне " p-tank-density " . "
    view-as alert-box.
  assign
  f-tank-weight  = decimal(p-tank-weight) no-error.
  if error-status:error then
    message "Неверно определен вес в цистерне " p-tank-weight " . "
    view-as alert-box.
  
  if f-hour-pour <> ? and f-min-pour <> ? then do:
      assign f-hour-pour = integer(substring(p-time-pour, 1, 2)) no-error.
      if error-status:error then do:
        message "Неверное время налива " p-time-pour
        view-as alert-box.
        assign f-hour-pour = ?
               f-min-pour  = ?.
      end.
      else do:
        assign f-min-pour = integer(substring(p-time-pour, 4, 2)) no-error.
        if error-status:error then do:
            message "Неверное время налива " p-time-pour
            view-as alert-box.
            assign f-hour-pour = ?
                  f-min-pour  = ?.
        end.
      end.
  end.
  
  assign
  f-date-start = p-date-start
  f-date-end   = p-date-end.
  if f-hour-start <> ? then do:
  f-hour-start = integer( truncate( p-time-start / 3600 , 0 ) ). end.
  if f-min-start <> ? then do:
  f-min-start  = integer( ( p-time-start - f-hour-start * 3600 ) / 60 ). end.
  if f-hour-end <> ? then do:
  f-hour-end   = integer( truncate( p-time-end / 3600 , 0 ) ). end.
  if f-min-end <> ? then do:
  f-min-end    = integer( ( p-time-end - f-hour-end * 3600 ) / 60). end.
  assign
    f-mouth = decimal (p-mouth) no-error.
  if error-status:error then
    message "Неверно определен объем топлива в горловине " p-mouth " . "
    view-as alert-box.
  assign
  f-a-b-tarir  = decimal(p-a-b-tarir) no-error.
  if error-status:error then
    message "Неверно определен уровень цистерны относительно тарировочной планки " p-a-b-tarir " . "
    view-as alert-box.
  assign
  f-size = p-diameter no-error.
  if error-status:error then
    message "Неверно определен внутренний диаметр горловины" p-diameter " . "
    view-as alert-box.
  assign
  f-place-si = integer(p-place-si) no-error.
  if error-status:error then
    message "Неверно определено средство измерения" p-place-si " . "
    view-as alert-box.
  f-tank-density-pomi = decimal(p-tank-density-pomi) no-error.
  if error-status:error then
    message "Неверно определена приведенная плотность" p-tank-density-pomi " . "
    view-as alert-box.
  assign
  f-tank-vol-pomi  = decimal(p-tank-vol-pomi) no-error.
  if error-status:error then
    message "Неверно определен объем в цистерне " p-tank-vol " . "
    view-as alert-box.
  assign
  f-dens-temp  = decimal(p-dens-temp) no-error.
  if error-status:error then
    message "Неверно определена температура в цистерне " p-tank-temp " . "
    view-as alert-box.


  RUN enable_UI.

    if v-sr-type = 0 then 
      do: 
        hide 
            f-num-plotn
            f-date-pov-plotn
            b-choose-date-pov-plotn
            f-passport-plotn
            in frame {&frame-name}.
      end.
      else do:
        if v-sr-type = 1 or v-sr-type = 2 then 
        do:
          enable
            f-num-plotn
            f-date-pov-plotn
            b-choose-date-pov-plotn
            with frame {&frame-name}.
          hide 
            f-passport-plotn
            in frame {&frame-name}.
        end.
        if v-sr-type = 3 or v-sr-type = 4 then 
        do:
            enable
              f-num-plotn
              f-date-pov-plotn
              b-choose-date-pov-plotn
              f-passport-plotn
              with frame {&frame-name}.
          end.
      end.
  display
    f-car-vol f-tests
    f-hour-pour f-min-pour
    f-date-start f-hour-start f-min-start
    f-date-end f-hour-end f-min-end
    f-tank-vol f-tank-temp f-tank-water f-tank-density
    f-tank-weight
    f-mouth
    f-a-b-tarir
    f-tank-vol-pomi f-dens-temp
    f-certif-fuel f-norm-doc 
    f-num-passport f-validity-certif
    with frame {&frame-name}.

  if p-mode <> {&update} then do:
    disable
      f-car-vol f-tests
      f-tank-vol f-tank-temp f-tank-water f-tank-density
      f-tank-weight f-hour-pour f-min-pour
      f-date-start f-hour-start f-min-start
      f-date-end f-hour-end f-min-end
      f-tank-vol-pomi f-dens-temp
      f-tank-density-pomi
      f-size
      f-place-si
      r-sr-izm
      b-calc
      b-copy-iz
      b-save
      f-mouth
      f-a-b-tarir
      f-certif-fuel f-norm-doc f-num-passport f-validity-certif
      f-date-pov-plotn b-choose-date-pov-plotn f-passport-plotn f-num-plotn
      with frame {&frame-name}.
  end.
  
  run gbl/conf-rd.p ("rdc-dnst", "", "", 0, "", "", "", no, output rdc-dnstvalue, output rdc-dnsttype) no-error.
  run gds-attr-value in this-procedure
    (  input p-gds-code
    ,  input {&attr-fuel-type}
    , output v-gds-attr-value
    , output v-gds-attr-type
    ) no-error .
  if error-status:error or lookup (v-gds-attr-value, "metan,propan") > 0 then do:
    rdc-dnstvalue = "not".
  end.
  if not error-status:error and rdc-dnstvalue <> "not" and p-mode <> {&lookup}  then do :
    disable
      f-mouth
      f-tank-density-pomi
      with frame {&frame-name}.
    display
      f-size
      f-place-si
      r-sr-izm
      f-tank-density-pomi
      b-calc
      b-copy-iz
      with frame {&frame-name}.
    enable
      f-size
      f-place-si
      r-sr-izm
      b-calc
      b-copy-iz
      with frame {&frame-name}.
  end.
  if not error-status:error and rdc-dnstvalue = "manual"
  then do:
    disable
      b-calc
    with frame {&frame-name}.
    enable
      f-tank-vol-pomi
      f-tank-density-pomi
      with frame {&frame-name}.
  
  end.
  if rdc-dnstvalue = "" or rdc-dnstvalue = ? or rdc-dnstvalue = "not" then do:
  rdc-dnstvalue = "not".
   disable
    f-tank-vol 
    f-tank-temp 
    f-tank-water
    f-tank-weight
    f-certif-fuel f-norm-doc 
    f-num-passport f-validity-certif
      with frame {&frame-name}.
    enable
    f-mouth
    f-a-b-tarir
    f-dens-temp
    f-tank-density
    f-car-vol f-tests
    f-hour-pour f-min-pour
    f-date-start f-hour-start f-min-start
    f-date-end f-hour-end f-min-end
      with frame {&frame-name}.
    hide
    f-tank-vol-pomi
    f-tank-density-pomi
    in frame {&frame-name}.
  end.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calc-weight-vol Dialog-Frame 
PROCEDURE calc-weight-vol :

define variable v-area as decimal no-undo.

assign frame {&frame-name}
      f-mouth
      f-a-b-tarir
      f-size
      f-tank-density
      f-tank-weight
      f-tank-vol
      f-tank-vol-pomi
      f-tank-density-pomi
      f-car-vol
      f-tank-water
    .
    
    assign
      f-size = string (decimal (f-size))
      f-size:screen-value = string (decimal (f-size)) 
    no-error.
    if error-status:error then do:
      assign
        v-area = decimal (entry (1,f-size, "/")) * decimal (entry (2,f-size, "/")) * 0.000001
      no-error.
      if error-status:error then do:
        message "Неверно указан размер горловины (либо значение диаметра, либо значение сторон для прямоугольной горолвины в виде a/b). Берется по умолчанию 0" view-as alert-box.
        f-size:screen-value in frame {&frame-name} = "0".
        v-area = 0.
      end.
    end.
    else do:
      v-area = 3.14159 * decimal (f-size) * decimal (f-size) * 0.000001 / 4 no-error.
    end.
     
    f-mouth = round (f-a-b-tarir * v-area, 3) .
    
    if f-mouth <> decimal (f-mouth:screen-value) then 
      apply "value-changed" to f-mouth in frame {&FRAME-NAME}.
      
    f-tank-vol = f-car-vol + f-mouth - f-tank-water.

    if rdc-dnstvalue = "not" then do:
        display input frame {&frame-name} f-tank-vol *
            input frame {&frame-name} f-tank-density @ f-tank-weight with frame {&frame-name}.
    end.
    else do:
        display input frame {&frame-name} f-tank-vol-pomi *
            input frame {&frame-name} f-tank-density-pomi @ f-tank-weight with frame {&frame-name}.
    end.
    assign
      f-tank-weight.
    
    do with frame {&frame-name}:
      assign
        f-mouth:screen-value in frame {&frame-name} = string (f-mouth)
        f-tank-vol:screen-value = string (f-tank-vol).
      .
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  DISPLAY f-tests f-car-vol f-size f-num-passport f-norm-doc f-certif-fuel 
          f-validity-certif f-a-b-tarir f-mouth f-tank-water f-tank-vol 
          f-tank-temp f-tank-density f-dens-temp f-tank-weight f-place-si 
          f-num-plotn f-date-pov-plotn f-passport-plotn f-tank-density-pomi f-tank-vol-pomi 
          f-date-start f-hour-start f-min-start f-date-end f-hour-end f-min-end 
          f-hour-pour f-min-pour f-place-si-name 
      WITH FRAME Dialog-Frame.
  ENABLE RECT-3 RECT-1 RECT-4 RECT-5 RECT-6 RECT-8 b-save b-quit b-help f-tests 
         f-car-vol f-size f-num-passport f-norm-doc f-certif-fuel 
         f-validity-certif f-a-b-tarir f-mouth f-tank-water f-tank-temp 
         f-tank-density f-dens-temp f-num-plotn f-date-pov-plotn f-passport-plotn f-date-start 
         f-hour-start f-min-start f-date-end f-hour-end f-min-end f-hour-pour 
         f-min-pour 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loc-get-set-attr Dialog-Frame 
PROCEDURE loc-get-set-attr :
define input  parameter p-mode-attr as character no-undo .

  &scop loc-find-attr ~
  find first buf_doc-line-attr ~
    where buf_doc-line-attr.doc-code  = p-doc-code ~
      and buf_doc-line-attr.gds-code  = p-gds-code ~
      and buf_doc-line-attr.attr-code = "~{&attr-name~}" ~
    no-error.

  &scop loc-get-attr ~
    if available buf_doc-line-attr then do: ~
      assign ~
        p-~{&attr-name~} = buf_doc-line-attr.attr-value ~
      . ~
    end.
  &scop loc-get-attr-int ~
    if available buf_doc-line-attr then do: ~
      assign ~
        p-~{&attr-name~} = integer( buf_doc-line-attr.attr-value ) no-error ~
      . ~
    end.
  &scop loc-get-attr-date ~
    if available buf_doc-line-attr then do: ~
      assign ~
        p-~{&attr-name~} = date( buf_doc-line-attr.attr-value ) ~
      . ~
    end.
  &scop loc-create-attr ~
    if not available buf_doc-line-attr then do: ~
      create buf_doc-line-attr . ~
      assign ~
        buf_doc-line-attr.doc-code  = p-doc-code ~
        buf_doc-line-attr.gds-code  = p-gds-code ~
        buf_doc-line-attr.attr-code = "~{&attr-name~}":U ~
      . ~
    end.

  &scop loc-set-attr ~
    assign ~
      buf_doc-line-attr.attr-value = substitute( "&1", p-~{&attr-name~} ) ~
    .
  &scop loc-set-attr-date ~
    assign ~
      buf_doc-line-attr.attr-value = string( p-~{&attr-name~}, "99/99/9999" )~
    .

  do
  on error  undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( error-status :num-messages ) )
  on stop   undo, return error substitute( "&1. stop", vss-workfile )
  on endkey undo, return error substitute( "&1. endkey", vss-workfile )
  :

    define buffer buf_doc-line-attr for ub.doc-line-attr .


    &scop attr-name car-vol
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name tests
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name certif-fuel
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.
    
    &scop attr-name norm-doc
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.
    
    &scop attr-name num-passport
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.
    
    &scop attr-name validity-certif
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.
    
    &scop attr-name passport-plotn
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.
    &scop attr-name date-pov-plotn
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr-date}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr-date}
    end.    

    &scop attr-name num-plotn
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.
    
    &scop attr-name time-pour
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name date-start
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr-date}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr-date}
    end.

    &scop attr-name time-start
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr-int}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name date-end
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr-date}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr-date}
    end.

    &scop attr-name time-end
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr-int}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name tank-vol
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name tank-temp
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name tank-water
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name tank-density
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name tank-weight
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name mouth
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name a-b-tarir
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name diameter
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name place-si
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name tank-density-pomi
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.
    
    &scop attr-name tank-vol-pomi
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name dens-temp
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.
    
    return .


  end.
END PROCEDURE.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

