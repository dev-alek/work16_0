&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          ub               PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-rvs-line NO-UNDO LIKE rvs-line
field meas-calc-qnty     AS DECIMAL FORMAT "->>,>>>,>>9":U INITIAL 0
field meas-calc-dens     AS DECIMAL FORMAT "9.9999":U INITIAL 0
field meas-cli-calc-qnty AS DECIMAL FORMAT "->>,>>>,>>9":U INITIAL 0
field izmer-density      AS DECIMAL FORMAT "9.9999":U INITIAL 0
field calc-add-mass      AS DECIMAL FORMAT "->>,>>>,>>9.9":U INITIAL 0
field calc-vol           AS DECIMAL FORMAT "->>,>>>,>>9":U INITIAL 0
field sum-mass           AS DECIMAL FORMAT "->>,>>>,>>9.9":U INITIAL 0
field sum-vol            AS DECIMAL FORMAT "->>,>>>,>>9":U INITIAL 0
field fact-calc-add-mass AS DECIMAL FORMAT "->>,>>>,>>9.9":U INITIAL 0
field fact-calc-vol      AS DECIMAL FORMAT "->>,>>>,>>9":U INITIAL 0
field fact-sum-mass      AS DECIMAL FORMAT "->>,>>>,>>9.9":U INITIAL 0
field fact-sum-vol       AS DECIMAL FORMAT "->>,>>>,>>9":U INITIAL 0 
field temp-izm-vol       as decimal format "->>>9.9":U initial ?
.

define new shared temp-table tt-temps no-undo
  field ii as integer
  field key_ as character
  field temperature as decimal format "->>>9.9"
  index pi 
    as primary unique
    ii
.

define new shared temp-table tt-dens no-undo
  field ii as integer
  field key_ as character
  field density as decimal format "9.9999"
  index pi 
    as primary unique
    ii
.

define new shared temp-table tt-dens-temp no-undo
  field ii as integer
  field key_ as character
  field density as decimal format "9.9999"
  field temperature as decimal format "->>>9.9"
  index pi 
    as primary unique
    ii
.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Экран работы со строкой сверки

Автор: Уханов Дмитрий Юрьевич
Дата создания: 07/23/07
Author: Dmitry Ukhanov
Creation date: 07/23/07

Автор1: Суслов Алексей Юрьевич
Дата создания1: 09/12/05

*/

define  input parameter parparentproc   as handle    no-undo .
define  input parameter parrec-rvs-line as recid     no-undo .
define  input parameter parmode         as character no-undo .
define  input parameter partitle        as character no-undo .

define variable vss-revision    as character no-undo initial "$Revision$":U.
define variable vss-author      as character no-undo initial "$Author$":U.
define variable vss-date        as character no-undo initial "$Date$":U.
define variable vss-workfile    as character no-undo initial "$Workfile$":U.
define variable vss-archive     as character no-undo initial "$Archive$":U.
define variable vss-description as character no-undo initial "Экран работы со строкой сверки":U.

{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/showinf.i  }
{ cmp/library.i  }
{ str/lib-trn.i  }
{ gbl/getcntxt.i def }
{ ref/gds-attr.i }
{ str/placelib.i }
/*{ ref/sr-izm.i sr-izmerenia ds}*/
/*{ ref/sr-izm.i " " proc }*/
{ gbl/ptrlprop.i def}
{ gbl/cur-time.i }
{ cmp/trg-def.i  }
{ gbl/getsect.i def }
{ str/initiator.i }



define variable g-log        as logical   no-undo.
define variable varlog       as logical   no-undo.
define variable v-return-val as character no-undo initial "":U .
define variable v-min-dens   as decimal   no-undo.
define variable v-max-dens   as decimal   no-undo.
define variable v-attr-type  as character no-undo.
define variable v-gds-ptrl-densities as character no-undo.
define variable rdc-value as character no-undo .
define variable rdc-type  as character no-undo.
define variable tarir-value as character no-undo .
define variable tarir-type  as character no-undo.
define variable pl-asi-sertif as logical no-undo .
define variable pl-rvd-dens as logical no-undo .
define variable pl-rvd-lvl as logical no-undo .
define variable pl-rvd-temp as logical no-undo .
define variable pl-error-mass as decimal no-undo .
define variable v-hand-input as logical no-undo initial no .

define variable place-diameter    as decimal no-undo .
define variable pl-dens-sr-izm    as integer no-undo .
define variable pl-level-sr-izm   as integer no-undo .
define variable pl-temp-sr-izm    as integer no-undo .

define variable place-SI          as integer no-undo.

define variable v-POkMI-result-attr     as character no-undo.

define variable v-value           as character no-undo.
define variable v-ok              as logical   no-undo.
define VARIABLE ii as integer no-undo .


define buffer buf_goods        for ub.goods .
define buffer buf_rvs-doc      for ub.rvs-doc.
define buffer buf_rvs-line     for ub.rvs-line .
define buffer bf_pl-level     for ub.pl-level.
define buffer buf-nxt_pl-level for ub.pl-level.
define buffer buf2_place       for ub.place.
define stream sinp .

define stream outstream.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-rvs-line

/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define FIELDS-IN-QUERY-Dialog-Frame tt-rvs-line.system-qnty ~
tt-rvs-line.system-cli-qnty tt-rvs-line.orig-system-qnty ~
tt-rvs-line.orig-system-cli-qnty tt-rvs-line.measure-qnty ~
tt-rvs-line.state-measure-qnty tt-rvs-line.meas-calc-qnty ~
tt-rvs-line.measure-tc-qnty ~
tt-rvs-line.state-measure-tc-qnty tt-rvs-line.density ~
tt-rvs-line.state-density tt-rvs-line.meas-calc-dens ~
tt-rvs-line.izmer-density tt-rvs-line.add-qnty tt-rvs-line.state-add-qnty ~
tt-rvs-line.brutto-qnty tt-rvs-line.state-brutto-qnty ~
tt-rvs-line.brutto-tc-qnty tt-rvs-line.state-brutto-tc-qnty ~
tt-rvs-line.measure-cli-qnty tt-rvs-line.state-measure-cli-qnty ~
tt-rvs-line.meas-cli-calc-qnty tt-rvs-line.temp-izm-vol ~
tt-rvs-line.brutto-cli-qnty tt-rvs-line.state-brutto-cli-qnty ~
tt-rvs-line.level-petrol tt-rvs-line.state-level-petrol ~
tt-rvs-line.level-total tt-rvs-line.state-level-total ~
tt-rvs-line.level-water tt-rvs-line.state-level-water ~
tt-rvs-line.temperature tt-rvs-line.state-temperature ~
tt-rvs-line.meas-mh-qnty ~
tt-rvs-line.state-mh-qnty tt-rvs-line.meas-am-qnty ~
tt-rvs-line.state-am-qnty tt-rvs-line.meas-cf-qnty ~
tt-rvs-line.state-cf-qnty
&Scoped-define ENABLED-FIELDS-IN-QUERY-Dialog-Frame ~
tt-rvs-line.state-measure-qnty tt-rvs-line.meas-calc-qnty ~
tt-rvs-line.state-density tt-rvs-line.state-add-qnty ~
tt-rvs-line.state-brutto-qnty tt-rvs-line.state-brutto-cli-qnty ~
tt-rvs-line.state-level-petrol tt-rvs-line.state-level-total ~
tt-rvs-line.state-temperature
&Scoped-define ENABLED-TABLES-IN-QUERY-Dialog-Frame tt-rvs-line
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-Dialog-Frame tt-rvs-line
&Scoped-define QUERY-STRING-Dialog-Frame FOR EACH tt-rvs-line SHARE-LOCK
&Scoped-define OPEN-QUERY-Dialog-Frame OPEN QUERY Dialog-Frame FOR EACH tt-rvs-line SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Dialog-Frame tt-rvs-line
&Scoped-define FIRST-TABLE-IN-QUERY-Dialog-Frame tt-rvs-line


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-rvs-line.state-measure-qnty ~
tt-rvs-line.meas-calc-qnty tt-rvs-line.state-density ~
tt-rvs-line.state-add-qnty tt-rvs-line.state-brutto-qnty ~
tt-rvs-line.state-brutto-cli-qnty tt-rvs-line.state-level-petrol ~
tt-rvs-line.state-level-total tt-rvs-line.state-temperature 
&Scoped-define ENABLED-TABLES tt-rvs-line
&Scoped-define FIRST-ENABLED-TABLE tt-rvs-line
&Scoped-Define ENABLED-OBJECTS b-save RECT-2 RECT-3 b-cancel b-help b-calc ~
delta-mass-qnty CriticalDif /* mass-float-cov */
&Scoped-Define DISPLAYED-FIELDS tt-rvs-line.system-qnty ~
tt-rvs-line.system-cli-qnty tt-rvs-line.orig-system-qnty ~
tt-rvs-line.orig-system-cli-qnty tt-rvs-line.measure-qnty ~
tt-rvs-line.state-measure-qnty tt-rvs-line.meas-calc-qnty ~
tt-rvs-line.measure-tc-qnty tt-rvs-line.temp-izm-vol ~
tt-rvs-line.state-measure-tc-qnty tt-rvs-line.density ~
tt-rvs-line.state-density tt-rvs-line.meas-calc-dens ~
tt-rvs-line.izmer-density tt-rvs-line.add-qnty tt-rvs-line.state-add-qnty ~
tt-rvs-line.brutto-qnty tt-rvs-line.state-brutto-qnty ~
tt-rvs-line.brutto-tc-qnty tt-rvs-line.state-brutto-tc-qnty ~
tt-rvs-line.measure-cli-qnty tt-rvs-line.state-measure-cli-qnty ~
tt-rvs-line.meas-cli-calc-qnty ~
tt-rvs-line.brutto-cli-qnty tt-rvs-line.state-brutto-cli-qnty ~
tt-rvs-line.level-petrol tt-rvs-line.state-level-petrol ~
tt-rvs-line.level-total tt-rvs-line.state-level-total ~
tt-rvs-line.level-water tt-rvs-line.state-level-water ~
tt-rvs-line.temperature tt-rvs-line.state-temperature ~
tt-rvs-line.meas-mh-qnty ~
tt-rvs-line.state-mh-qnty tt-rvs-line.meas-am-qnty ~
tt-rvs-line.state-am-qnty tt-rvs-line.meas-cf-qnty ~
tt-rvs-line.state-cf-qnty 
&Scoped-define DISPLAYED-TABLES tt-rvs-line
&Scoped-define FIRST-DISPLAYED-TABLE tt-rvs-line
&Scoped-Define DISPLAYED-OBJECTS varmeasure-water-qnty varstate-water-qnty ~
varmeasure-water-cli-qnty varstate-water-cli-qnty CriticalDif ~
varstate-sum-vol varsum-vol
/*mass-float-cov*/

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 Dialog-Frame tt-rvs-line.measure-qnty ~
tt-rvs-line.density tt-rvs-line.add-qnty tt-rvs-line.brutto-qnty ~
tt-rvs-line.measure-cli-qnty tt-rvs-line.brutto-cli-qnty ~
tt-rvs-line.level-petrol tt-rvs-line.level-total tt-rvs-line.level-water ~
tt-rvs-line.temperature tt-rvs-line.meas-mh-qnty tt-rvs-line.meas-am-qnty ~
tt-rvs-line.meas-cf-qnty tt-rvs-line.meas-calc-qnty tt-rvs-line.meas-calc-dens ~
tt-rvs-line.meas-cli-calc-qnty
&Scoped-define List-2 tt-rvs-line.state-measure-qnty ~
tt-rvs-line.state-measure-tc-qnty tt-rvs-line.state-density ~
tt-rvs-line.state-add-qnty tt-rvs-line.state-brutto-qnty ~
tt-rvs-line.state-brutto-tc-qnty tt-rvs-line.state-measure-cli-qnty ~
tt-rvs-line.state-brutto-cli-qnty tt-rvs-line.state-level-petrol ~
tt-rvs-line.state-level-total tt-rvs-line.state-level-water ~
tt-rvs-line.state-temperature tt-rvs-line.temp-izm-vol ~
tt-rvs-line.state-mh-qnty tt-rvs-line.state-am-qnty ~
tt-rvs-line.state-cf-qnty tt-rvs-line.izmer-density
&Scoped-define List-3 tt-rvs-line.state-measure-tc-qnty ~
tt-rvs-line.state-add-qnty tt-rvs-line.state-brutto-tc-qnty ~
tt-rvs-line.state-temperature  

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-calc 
     LABEL "Рассчитать" 
     SIZE 13 BY .88.
     
DEFINE BUTTON b-POkMI-result 
     LABEL "Результаты ПОкМИ" 
     SIZE 17 BY 1 .

DEFINE BUTTON b-cancel AUTO-END-KEY 
     LABEL "&Отмена" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-help 
     LABEL "&Помощь" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-save AUTO-GO 
     LABEL "&Ввод" 
     SIZE 10 BY 1
     BGCOLOR 8 .
     
DEFINE BUTTON b-temperature 
     IMAGE-UP FILE "btn-down-arrow":U
     IMAGE-DOWN FILE "btn-down-arrow":U
     IMAGE-INSENSITIVE FILE "btn-down-arrow":U
     LABEL "Установка температуры" 
     SIZE 3 BY .87.
     
DEFINE BUTTON b-density 
     IMAGE-UP FILE "btn-down-arrow":U
     IMAGE-DOWN FILE "btn-down-arrow":U
     IMAGE-INSENSITIVE FILE "btn-down-arrow":U
     LABEL "Установка плотности" 
     SIZE 3 BY .87.

DEFINE VARIABLE delta-mass-qnty AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Отн. погр. изм. массы НП (ПО к МИ)" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.
     
DEFINE VARIABLE abs-delta-mass-qnty AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Абс. погр. изм. массы НП (ПО к МИ)" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.
     
DEFINE VARIABLE abs-delta-mass-add-qnty AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Абс. погр. изм. массы в трубопр." 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

/*DEFINE VARIABLE mass-float-cov AS DECIMAL FORMAT ">>,>>9.999":U INITIAL 0*/
/*     LABEL "Масса плавающего покрытия"                                   */
/*     VIEW-AS FILL-IN                                                     */
/*     SIZE 13 BY .88 NO-UNDO.                                             */

DEFINE VARIABLE CriticalDif AS DECIMAL FORMAT "->>,>>>,>>9.9":U INITIAL ?
     LABEL "Сверхнормативные расхождения" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE varmeasure-water-cli-qnty AS DECIMAL FORMAT "->>,>>>,>>9.9":U INITIAL 0 
     LABEL "Масса воды (кг)" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE varmeasure-water-qnty AS DECIMAL FORMAT "->>,>>>,>>9":U INITIAL 0 
     LABEL "Объем воды (л)" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE varstate-water-cli-qnty AS DECIMAL FORMAT "->>,>>>,>>9.9":U INITIAL 0 
     LABEL "Факт масса воды (кг)" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.
     
DEFINE VARIABLE varsum-vol AS DECIMAL FORMAT "->>,>>>,>>9":U INITIAL 0 
     LABEL "Объем наполнения (л)" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE varstate-sum-vol AS DECIMAL FORMAT "->>,>>>,>>9":U INITIAL 0 
     LABEL "Объем наполнения (л)" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE varstate-water-qnty AS DECIMAL FORMAT "->>,>>>,>>9":U INITIAL 0 
     LABEL "Объем воды (л)" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 52.25 BY 21.71.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47.88 BY 21.75.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Dialog-Frame FOR 
      tt-rvs-line SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     b-save AT ROW 1 COL 1
     b-cancel AT ROW 1 COL 11
     b-help AT ROW 1 COL 21
     b-POkMI-result at row 1 col 87
     tt-rvs-line.system-qnty AT ROW 2.25 COL 34 COLON-ALIGNED
          FORMAT "->>,>>>,>>9":U 
          LABEL "Объем расчетно-книжный (л)"
          VIEW-AS FILL-IN 
          SIZE 19 BY .88
     tt-rvs-line.system-cli-qnty AT ROW 2.25 COL 76 COLON-ALIGNED
          FORMAT "->>,>>>,>>9.9":U
          LABEL "Масса расчетно-книжная (кг)"
          VIEW-AS FILL-IN 
          SIZE 19 BY .88
     tt-rvs-line.orig-system-qnty AT ROW 3.25 COL 34 COLON-ALIGNED
          FORMAT "->>,>>>,>>9":U
          LABEL "Первоначально (л)"
          VIEW-AS FILL-IN 
          SIZE 19 BY .88
          FGCOLOR 4 
     tt-rvs-line.orig-system-cli-qnty AT ROW 3.25 COL 76 COLON-ALIGNED
          FORMAT "->>,>>>,>>9.9":U
          LABEL "Первоначально (кг)"
          VIEW-AS FILL-IN 
          SIZE 19 BY .88
          FGCOLOR 4 
     tt-rvs-line.measure-qnty AT ROW 5.75 COL 28.25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-rvs-line.state-measure-qnty AT ROW 5.75 COL 73.25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-rvs-line.meas-calc-qnty AT ROW 6.75 COL 34 COLON-ALIGNED WIDGET-ID 20
          LABEL "Остаток рассчит. по измер."
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-rvs-line.measure-tc-qnty AT ROW 7.75 COL 28.25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-rvs-line.state-measure-tc-qnty AT ROW 7.75 COL 73.25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-rvs-line.density AT ROW 17.75 COL 32 COLON-ALIGNED FORMAT "9.9999"
          LABEL "Измер. Плотность НП (г/см3)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-rvs-line.state-density AT ROW 17.75 COL 85 COLON-ALIGNED FORMAT "9.9999"
          LABEL "Плотность НП (г/см3)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     b-calc AT ROW 9.75 COL 65 WIDGET-ID 6
     tt-rvs-line.meas-calc-dens AT ROW 9.75 COL 35 /* COLON-ALIGNED */ WIDGET-ID 8
          FORMAT "9.9999"
          LABEL "Плотность расчит. по измер. (г/см3)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-rvs-line.izmer-density AT ROW 8.75 COL 79 COLON-ALIGNED WIDGET-ID 4
          FORMAT "9.9999"
          LABEL "Плотность измер. для ПО к МИ (г/см3)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     b-density at row 8.75 col 97
     tt-rvs-line.temp-izm-vol AT ROW 10.75 COL 79 COLON-ALIGNED WIDGET-ID 4
          LABEL "Температура изм. Объема (°С)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     b-temperature at row 10.75 col 97     
     tt-rvs-line.add-qnty AT ROW 11.75 COL 35 COLON-ALIGNED
          FORMAT "->>,>>>,>>9":U
          LABEL "Объем в трубопроводе (л)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-rvs-line.calc-add-mass AT ROW 12.75 COL 35 COLON-ALIGNED
          LABEL "Рассч. Масса в трубопроводе (кг)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-rvs-line.fact-calc-add-mass AT ROW 12.75 COL 85 COLON-ALIGNED
          LABEL "Рассч. Масса в трубопроводе (кг)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     abs-delta-mass-add-qnty AT ROW 13.75 COL 85 COLON-ALIGNED
     tt-rvs-line.state-add-qnty AT ROW 11.75 COL 85 COLON-ALIGNED
          FORMAT "->>,>>>,>>9":U
          LABEL "Объем в трубопроводе (л)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-rvs-line.brutto-qnty AT ROW 11.75 COL 28.13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-rvs-line.state-brutto-qnty AT ROW 11.75 COL 73.5 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-rvs-line.brutto-tc-qnty AT ROW 12.75 COL 28.13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-rvs-line.state-brutto-tc-qnty AT ROW 12.75 COL 73.5 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     varmeasure-water-qnty AT ROW 24.75 COL 28.13 COLON-ALIGNED
     varstate-water-qnty AT ROW 24.75 COL 85 COLON-ALIGNED
     varsum-vol AT ROW 25.75 COL 28.13 COLON-ALIGNED
     varstate-sum-vol AT ROW 25.75 COL 85 COLON-ALIGNED
     tt-rvs-line.calc-vol AT ROW 15.75 COL 32 COLON-ALIGNED
          LABEL "Рассч. Объем НП (л)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-rvs-line.fact-calc-vol AT ROW 15.75 COL 85 COLON-ALIGNED
          LABEL "Объем НП (л)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-rvs-line.measure-cli-qnty AT ROW 16.75 COL 32 COLON-ALIGNED
          FORMAT "->>,>>>,>>9.9":U
          LABEL "Измер. Масса НП (кг)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-rvs-line.state-measure-cli-qnty AT ROW 16.75 COL 85 COLON-ALIGNED
          FORMAT "->>,>>>,>>9.9":U
          LABEL "Масса НП (кг)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         CANCEL-BUTTON b-cancel.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME Dialog-Frame
     tt-rvs-line.meas-cli-calc-qnty AT ROW 15.75 COL 34 COLON-ALIGNED WIDGET-ID 10
          LABEL "Масса расчит. по измер. (кг)"
          VIEW-AS FILL-IN
          SIZE 13 BY .88
     tt-rvs-line.brutto-cli-qnty AT ROW 16.75 COL 28.13 COLON-ALIGNED
          FORMAT "->>,>>>,>>9.9":U
          LABEL "Измер. брутто масса (кг)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-rvs-line.state-brutto-cli-qnty AT ROW 16.75 COL 73.5 COLON-ALIGNED
          FORMAT "->>,>>>,>>9.9":U
          LABEL "Факт брутто масса (кг)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-rvs-line.sum-vol AT ROW 21.75 COL 28.13 COLON-ALIGNED
          LABEL "Общий Объем НП (л)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-rvs-line.sum-mass AT ROW 22.75 COL 28.13 COLON-ALIGNED
          LABEL "Общая Масса НП (кг)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-rvs-line.fact-sum-vol AT ROW 21.75 COL 85 COLON-ALIGNED
          LABEL "Общий Объем НП (л)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     tt-rvs-line.fact-sum-mass AT ROW 22.75 COL 85 COLON-ALIGNED
          LABEL "Общая Масса НП (кг)"
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     varmeasure-water-cli-qnty AT ROW 24.75 COL 28.13 COLON-ALIGNED
     varstate-water-cli-qnty AT ROW 24.75 COL 85 COLON-ALIGNED
     tt-rvs-line.level-petrol AT ROW 18.75 COL 30 COLON-ALIGNED
          FORMAT ">>,>>9.9":U
          LABEL "Измер. уровень топлива (см)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     tt-rvs-line.state-level-petrol AT ROW 18.75 COL 73.5 COLON-ALIGNED
          FORMAT ">>,>>9.9":U
          LABEL "Факт уровень топлива (см)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     tt-rvs-line.level-total AT ROW 5.75 COL 28 COLON-ALIGNED
          FORMAT ">>,>>9.9":U
          LABEL "Измер. общий уровень (см)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     tt-rvs-line.state-level-total AT ROW 5.75 COL 75.5 COLON-ALIGNED
          FORMAT ">>,>>9.9":U
          LABEL "Факт общий уровень (см)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .88 
     tt-rvs-line.level-water AT ROW 6.75 COL 28 COLON-ALIGNED
          FORMAT ">>,>>9.9":U
          LABEL "Измер. уровень воды (см)"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-rvs-line.state-level-water AT ROW 6.75 COL 75.5 COLON-ALIGNED
          FORMAT ">>,>>9.9":U
          LABEL "Факт уровень воды (см)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     tt-rvs-line.temperature AT ROW 7.75 COL 28 COLON-ALIGNED
          FORMAT "->>9.9":U
          LABEL "Измер. Температура (°С)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     tt-rvs-line.state-temperature AT ROW 7.75 COL 75.5 COLON-ALIGNED
          FORMAT "->>9.9":U
          LABEL "Температура (°С)"
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
/*     tt-rvs-line.temp-layer1 AT ROW 5.75 COL 41 COLON-ALIGNED      */
/*          LABEL "T1"                                               */
/*          VIEW-AS FILL-IN                                          */
/*          SIZE 6 BY .88                                            */
/*     tt-rvs-line.temp-layer2 AT ROW 6.75 COL 41 COLON-ALIGNED      */
/*          LABEL "T2"                                               */
/*          VIEW-AS FILL-IN                                          */
/*          SIZE 6 BY .88                                            */
/*     tt-rvs-line.temp-layer3 AT ROW 7.75 COL 41 COLON-ALIGNED      */
/*          LABEL "T3"                                               */
/*          VIEW-AS FILL-IN                                          */
/*          SIZE 6 BY .88                                            */
/*     tt-rvs-line.state-temp-layer1 AT ROW 5.75 COL 91 COLON-ALIGNED*/
/*          VIEW-AS FILL-IN                                          */
/*          SIZE 8 BY .88                                            */
/*     tt-rvs-line.state-temp-layer2 AT ROW 6.75 COL 91 COLON-ALIGNED*/
/*          VIEW-AS FILL-IN                                          */
/*          SIZE 8 BY .88                                            */
/*     tt-rvs-line.state-temp-layer3 AT ROW 7.75 COL 91 COLON-ALIGNED*/
/*          VIEW-AS FILL-IN                                          */
/*          SIZE 8 BY .88                                            */
     tt-rvs-line.meas-mh-qnty AT ROW 23.75 COL 28.13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     tt-rvs-line.state-mh-qnty AT ROW 28.25 COL 15.5 COLON-ALIGNED
          LABEL "Оборот по ТРК"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-rvs-line.meas-am-qnty AT ROW 24.75 COL 28.13 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     tt-rvs-line.state-am-qnty AT ROW 28.25 COL 55.5 COLON-ALIGNED
          LABEL "Сумма оборота по ТРК"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-rvs-line.meas-cf-qnty AT ROW 25.75 COL 29.13 COLON-ALIGNED
          LABEL "Измеренное кол-во наливов"
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         CANCEL-BUTTON b-cancel.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME Dialog-Frame
     tt-rvs-line.state-cf-qnty AT ROW 28.25 COL 95.5 COLON-ALIGNED
          LABEL "Количество наливов"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     delta-mass-qnty AT ROW 18.75 COL 85 COLON-ALIGNED  WIDGET-ID 22
     abs-delta-mass-qnty AT ROW 19.75 COL 85 COLON-ALIGNED  WIDGET-ID 22
     CriticalDif AT ROW 4.25 COL 34 COLON-ALIGNED WIDGET-ID 2
/*     mass-float-cov AT ROW 26.5 COL 54 COLON-ALIGNED WIDGET-ID 2*/
/*       "Погр. изм." VIEW-AS TEXT                             */
/*          SIZE 12.5 BY .75 AT ROW 24.75 COL 88.5 WIDGET-ID 24*/
     
     RECT-2 AT ROW 5.54 COL 50.25
     RECT-3 AT ROW 5.5 COL 2
     SPACE(58.61) SKIP(2.74)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Документ сверки"
         CANCEL-BUTTON b-cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
   Temp-Tables and Buffers:
      TABLE: tt-rvs-line T "?" NO-UNDO ub rvs-line
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME 1                                                         */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN tt-rvs-line.add-qnty IN FRAME Dialog-Frame
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN tt-rvs-line.brutto-cli-qnty IN FRAME Dialog-Frame
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN tt-rvs-line.brutto-qnty IN FRAME Dialog-Frame
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN tt-rvs-line.brutto-tc-qnty IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-rvs-line.density IN FRAME Dialog-Frame
   NO-ENABLE 1 EXP-FORMAT                                               */
/* SETTINGS FOR FILL-IN tt-rvs-line.izmer-density IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-rvs-line.level-petrol IN FRAME Dialog-Frame
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN tt-rvs-line.level-total IN FRAME Dialog-Frame
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN tt-rvs-line.level-water IN FRAME Dialog-Frame
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN tt-rvs-line.meas-am-qnty IN FRAME Dialog-Frame
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN tt-rvs-line.meas-calc-dens IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-rvs-line.meas-cf-qnty IN FRAME Dialog-Frame
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN tt-rvs-line.meas-cli-calc-qnty IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-rvs-line.meas-mh-qnty IN FRAME Dialog-Frame
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN tt-rvs-line.measure-cli-qnty IN FRAME Dialog-Frame
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN tt-rvs-line.measure-qnty IN FRAME Dialog-Frame
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN tt-rvs-line.measure-tc-qnty IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-rvs-line.orig-system-cli-qnty IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN tt-rvs-line.orig-system-qnty IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN tt-rvs-line.state-add-qnty IN FRAME Dialog-Frame
   2 3                                                                  */
/* SETTINGS FOR FILL-IN tt-rvs-line.state-am-qnty IN FRAME Dialog-Frame
   NO-ENABLE 2 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN tt-rvs-line.state-brutto-cli-qnty IN FRAME Dialog-Frame
   2 EXP-LABEL                                                          */
/* SETTINGS FOR FILL-IN tt-rvs-line.state-brutto-qnty IN FRAME Dialog-Frame
   2                                                                    */
/* SETTINGS FOR FILL-IN tt-rvs-line.state-brutto-tc-qnty IN FRAME Dialog-Frame
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN tt-rvs-line.state-cf-qnty IN FRAME Dialog-Frame
   NO-ENABLE 2 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN tt-rvs-line.state-density IN FRAME Dialog-Frame
   2 EXP-FORMAT                                                         */
/* SETTINGS FOR FILL-IN tt-rvs-line.state-level-petrol IN FRAME Dialog-Frame
   2 EXP-LABEL                                                          */
/* SETTINGS FOR FILL-IN tt-rvs-line.state-level-total IN FRAME Dialog-Frame
   2 EXP-LABEL                                                          */
/* SETTINGS FOR FILL-IN tt-rvs-line.state-level-water IN FRAME Dialog-Frame
   NO-ENABLE 2 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN tt-rvs-line.state-measure-cli-qnty IN FRAME Dialog-Frame
   NO-ENABLE 2 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN tt-rvs-line.state-measure-qnty IN FRAME Dialog-Frame
   2                                                                    */
/* SETTINGS FOR FILL-IN tt-rvs-line.state-measure-tc-qnty IN FRAME Dialog-Frame
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN tt-rvs-line.state-mh-qnty IN FRAME Dialog-Frame
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN tt-rvs-line.state-temp-layer1 IN FRAME Dialog-Frame
   2 3                                                                  */
/* SETTINGS FOR FILL-IN tt-rvs-line.state-temp-layer2 IN FRAME Dialog-Frame
   2 3                                                                  */
/* SETTINGS FOR FILL-IN tt-rvs-line.state-temp-layer3 IN FRAME Dialog-Frame
   2 3                                                                  */
/* SETTINGS FOR FILL-IN tt-rvs-line.state-temperature IN FRAME Dialog-Frame
   2 3                                                                  */
/* SETTINGS FOR FILL-IN tt-rvs-line.system-cli-qnty IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN tt-rvs-line.system-qnty IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN tt-rvs-line.temp-layer1 IN FRAME Dialog-Frame
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN tt-rvs-line.temp-layer2 IN FRAME Dialog-Frame
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN tt-rvs-line.temp-layer3 IN FRAME Dialog-Frame
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN tt-rvs-line.temperature IN FRAME Dialog-Frame
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN varmeasure-water-cli-qnty IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN varmeasure-water-qnty IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN varstate-water-cli-qnty IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN varstate-water-qnty IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Dialog-Frame
/* Query rebuild information for DIALOG-BOX Dialog-Frame
     _TblList          = "Temp-Tables.tt-rvs-line"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX Dialog-Frame */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Документ сверки */
DO:
  assign
    v-return-val = "cancel"
  .
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-cancel Dialog-Frame
ON CHOOSE OF b-cancel IN FRAME Dialog-Frame /* Отмена */
DO:
  { gbl/stdbtn.i }
  assign
    v-return-val = "cancel"
  .
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-POkMI-result
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-POkMI-result Dialog-Frame
ON CHOOSE OF b-POkMI-result IN FRAME Dialog-Frame /* Отмена */
DO:
  message v-POkMI-result-attr view-as alert-box information .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-calc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-calc Dialog-Frame
ON CHOOSE OF b-calc IN FRAME Dialog-Frame /* Рассчитать */
DO:

define variable v-mm as com-handle.
define variable v-proc as character no-undo.
define variable v-mm57       as com-handle.

define variable v-code            as character no-undo.
define variable ii                as integer   no-undo.

define variable place-type        as integer no-undo.

define variable place-ratio-error as decimal no-undo.
define variable dens-prov         as decimal no-undo format "9.9999999999":U.

define variable CalibTable        as character no-undo initial "".
define variable ToolType          as integer no-undo.
define variable LevelToolType          as integer no-undo.
define variable A_LevelMeasurementTool  as decimal no-undo.
define variable DeltaAbs_H              as decimal no-undo.
define variable DeltaAbs_H_Water        as decimal no-undo.
define variable DeltaAbs_R              as decimal no-undo.
define variable DeltaAbs_Tv             as decimal no-undo.
define variable DeltaAbs_Tr             as decimal no-undo.
define variable DeltaOtn_N              as decimal no-undo.
define variable DeltaOtn_K              as decimal no-undo.
define variable A_Reservoir             as decimal no-undo init 0.0000125 .
define variable DeadZone_Reservoir      as decimal no-undo.
define variable DeltaOtn_H              as decimal no-undo.
define variable DeltaOtn_H_Water        as decimal no-undo.
define variable DeltaOtn_R              as decimal no-undo.
define variable temp-for-pomi           as integer no-undo.
define variable error-string            as character no-undo.
define variable v-is-meas               as logical no-undo.
define variable v-mm-density            as decimal no-undo.

define variable v-POkMI-result          as character no-undo.

define buffer buf_sr-izmerenia for sr-izmerenia .
define buffer dens_sr-izmerenia for sr-izmerenia .
define buffer temp_sr-izmerenia for sr-izmerenia .
define buffer level_sr-izmerenia for sr-izmerenia .
define buffer buf_place     for ub.place.

define buffer water1_pl-level  for ub.pl-level .
define buffer water2_pl-level  for ub.pl-level .
define buffer total1_pl-level  for ub.pl-level .
define buffer total2_pl-level  for ub.pl-level .
define buffer buf_pl-level-attr for ub.pl-level-attr .

define buffer bf_goods for ub.goods .
define buffer bf_place for ub.place .


  assign frame {&frame-name} tt-rvs-line.state-level-total   .
  assign frame {&frame-name} tt-rvs-line.state-level-water   .
/*  assign frame {&frame-name} tt-rvs-line.state-temp-layer1   .*/
/*  assign frame {&frame-name} tt-rvs-line.state-temp-layer2   .*/
/*  assign frame {&frame-name} tt-rvs-line.state-temp-layer3   .*/
  assign frame {&frame-name} tt-rvs-line.state-temperature   .
  assign frame {&frame-name} tt-rvs-line.izmer-density       .
  assign frame {&frame-name} tt-rvs-line.temp-izm-vol       .
/*  assign frame {&frame-name} mass-float-cov                  .*/
  assign frame {&frame-name} CriticalDif .
  assign frame {&frame-name} delta-mass-qnty . 
  _trpomi :
    do on error undo, return no-apply :
    
    if tt-rvs-line.izmer-density = ? or tt-rvs-line.izmer-density = 0 then do :
      message
        "Заполнены не все поля, необходимые" skip
        "для работы библиотеки ПО МИ"        skip
        "Введите плотность измер.для ПО МИ"
      view-as alert-box error.
      apply "entry" to tt-rvs-line.izmer-density in frame {&frame-name}.
      undo _trpomi, return .
    end.
    if tt-rvs-line.state-level-total = ? then do :
      message
        "Заполнены не все поля, необходимые" skip
        "для работы библиотеки ПО МИ"        skip
        "Введите факт. общий уровень"
      view-as alert-box error.
      apply "entry" to tt-rvs-line.state-level-total in frame {&frame-name}.
      undo _trpomi, return .
    end.
    if tt-rvs-line.state-level-water = ? then do :
      message
        "Заполнены не все поля, необходимые" skip
        "для работы библиотеки ПО МИ"        skip
        "Введите факт. уровень топлива"
      view-as alert-box error.
      apply "entry" to tt-rvs-line.state-level-water in frame {&frame-name}.
      undo _trpomi, return .
    end.
    if tt-rvs-line.state-temperature = ? then do :
      message
        "Заполнены не все поля, необходимые" skip
        "для работы библиотеки ПО МИ"        skip
        "Введите температуру"
      view-as alert-box error.
      apply "entry" to tt-rvs-line.state-temperature in frame {&frame-name}.
      undo _trpomi, return .
    end.
    
    /*данные по резервуару для ПО МИ*/
    do ii = 1 to num-entries({&list-place-attr},','):
      v-code = entry(ii,{&list-place-attr}) .
      run placelib_get-attr  ( input v-code
                              ,input tt-rvs-line.obj-code
                              ,input tt-rvs-line.obj-type
                              ,input tt-rvs-line.pl-code
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
/*        when {&place-ratio-error} then do :                  */
/*          if v-ok then place-ratio-error = decimal(v-value) .*/
/*        end.                                                 */
        when {&place-dens-prov} then do :
          if v-ok then dens-prov = decimal(v-value) .
        end.
        when {&place-temp-coef} then do :
          if v-ok then A_Reservoir = decimal(v-value) .
        end.
        when {&place-dead-high} then do :
          if v-ok then DeadZone_Reservoir = decimal(v-value) .
        end.
      end case.
    end.
    /*..........................................*/

    /*градуировочная таблица резервуара для ПО МИ*/
/*    for last pl-level no-lock                                                                                                */
/*        where pl-level.pl-code  = tt-rvs-line.pl-code                                                                        */
/*          and pl-level.obj-code = tt-rvs-line.obj-code                                                                       */
/*          and pl-level.obj-type = tt-rvs-line.obj-type by pl-level.pl-level                                                  */
/*          :                                                                                                                  */
/*          CalibTable = Substitute("&1=&2","1",(pl-level.pl-qnty / (pl-level.pl-level))) .                                    */
/*    end.                                                                                                                     */
/*    for each  pl-level no-lock                                                                                               */
/*        where pl-level.pl-code  = tt-rvs-line.pl-code                                                                        */
/*          and pl-level.obj-code = tt-rvs-line.obj-code                                                                       */
/*          and pl-level.obj-type = tt-rvs-line.obj-type by pl-level.pl-level                                                  */
/*          :                                                                                                                  */
/*          if CalibTable = "" then CalibTable = Substitute("&1=&2",(pl-level.pl-level ),pl-level.pl-qnty ) .                  */
/*                            else CalibTable = CalibTable + ";" + Substitute("&1=&2",(pl-level.pl-level ),pl-level.pl-qnty ) .*/
/*    end.                                                                                                                     */
/*                                                                                                                             */
/*    CalibTable = CalibTable + ";" + fill({&space-char},(2048 - length(CalibTable))).                                         */
    
    if tt-rvs-line.state-level-water > 0
    then do :
      find last water1_pl-level no-lock where water1_pl-level.pl-code  = tt-rvs-line.pl-code
                                          and water1_pl-level.obj-code = tt-rvs-line.obj-code
                                          and water1_pl-level.obj-type = tt-rvs-line.obj-type
                                          and water1_pl-level.pl-level <= tt-rvs-line.state-level-water
                                          no-error .
      if available water1_pl-level 
      and water1_pl-level.pl-level <> tt-rvs-line.state-level-water
      then do :
        find first water2_pl-level no-lock where water2_pl-level.pl-code  = tt-rvs-line.pl-code
                                            and water2_pl-level.obj-code = tt-rvs-line.obj-code
                                            and water2_pl-level.obj-type = tt-rvs-line.obj-type
                                            and water2_pl-level.pl-level >= tt-rvs-line.state-level-water
                                            no-error .
      end .
    end .  
    find last total1_pl-level no-lock where total1_pl-level.pl-code  = tt-rvs-line.pl-code
                                        and total1_pl-level.obj-code = tt-rvs-line.obj-code
                                        and total1_pl-level.obj-type = tt-rvs-line.obj-type
                                        and total1_pl-level.pl-level <= tt-rvs-line.state-level-total
                                        no-error . 
    if not available total1_pl-level
    then do :
      find first bf_goods no-lock where bf_goods.gds-code = tt-rvs-line.gds-code no-error .
      find first bf_place no-lock where bf_place.pl-code = tt-rvs-line.pl-code no-error .
      message 
        substitute( 'Для резервуара &1 (&2 &3) не заполнена градуировочная таблица. Запуск ПОкМИ невозможен.'
                   ,(if available bf_place then bf_place.loc1 else "?")
                   ,(if available bf_goods then string(bf_goods.gds-code) else "?")
                   ,(if available bf_goods then bf_goods.gds-name else "?") )
      view-as alert-box .
      undo _trpomi, return .
    end .
    DeltaOtn_K = ? .                                    
    for first buf_pl-level-attr no-lock where buf_pl-level-attr.pl-code  = total1_pl-level.pl-code
                                          and buf_pl-level-attr.obj-code = total1_pl-level.obj-code
                                          and buf_pl-level-attr.obj-type = total1_pl-level.obj-type
                                          and buf_pl-level-attr.pl-level = total1_pl-level.pl-level
                                          and buf_pl-level-attr.attr-code = "tarir-delta"
                                          :      
      DeltaOtn_K = decimal(buf_pl-level-attr.attr-value) . 
    end .   
    if DeltaOtn_K = ? then DeltaOtn_K = 0.25 .                              
    find first total2_pl-level no-lock where total2_pl-level.pl-code  = tt-rvs-line.pl-code
                                        and total2_pl-level.obj-code = tt-rvs-line.obj-code
                                        and total2_pl-level.obj-type = tt-rvs-line.obj-type
                                        and total2_pl-level.pl-level > tt-rvs-line.state-level-total
                                        no-error .   
    if not available total2_pl-level
    then do :
      find first bf_goods no-lock where bf_goods.gds-code = tt-rvs-line.gds-code no-error .
      find first bf_place no-lock where bf_place.pl-code = tt-rvs-line.pl-code no-error .
      message 
        substitute( 'Для резервуара &1 (&2 &3) не заполнена градуировочная таблица. Запуск ПОкМИ невозможен.'
                   ,(if available bf_place then bf_place.loc1 else "?")
                   ,(if available bf_goods then string(bf_goods.gds-code) else "?")
                   ,(if available bf_goods then bf_goods.gds-name else "?") )
      view-as alert-box .
      undo _trpomi, return .
    end .                                    
    if available water1_pl-level
    then do :
      CalibTable = Substitute("&1=&2", water1_pl-level.pl-level, (water1_pl-level.pl-qnty / 1000)) + {&new-line} .
    end . 
    if available water2_pl-level
    then do :
      CalibTable = CalibTable + Substitute("&1=&2", water2_pl-level.pl-level, (water2_pl-level.pl-qnty / 1000)) + {&new-line} .
    end .  
    CalibTable = CalibTable + Substitute("&1=&2", total1_pl-level.pl-level, (total1_pl-level.pl-qnty / 1000)) + {&new-line} . 
    CalibTable = CalibTable + Substitute("&1=&2", total2_pl-level.pl-level, (total2_pl-level.pl-qnty / 1000)) .

    /*..........................................*/

    /*данные по средству измерения резервуара для ПО МИ*/

    if pl-rvd-lvl
    and pl-rvd-dens
    and pl-rvd-temp
    then do : end .
    else do :
      if place-si = 0
      or place-si = ?
      then do :
        message
          substitute ("Для складского места &1 не заданно средство измерения",tt-rvs-line.pl-code)
        view-as alert-box error.
        undo _trpomi, return no-apply.
      end.
      else do :
        find first buf_sr-izmerenia no-lock where buf_sr-izmerenia.node-code = place-si no-error.
        if not available buf_sr-izmerenia then do :
          message
          "Ошибка работы с библиотекой ПО МИ"
          substitute( 'Не найдено средство измерения с кодом &1', place-si ) skip
          view-as alert-box error.
          undo _trpomi, return no-apply.
        end.
        else do :
          assign
            ToolType               = buf_sr-izmerenia.sr-type-id
            A_LevelMeasurementTool = buf_sr-izmerenia.sr-temp-line
            DeltaAbs_H             = buf_sr-izmerenia.sr-abs-err-neft-water
            DeltaAbs_H_Water       = buf_sr-izmerenia.sr-abs-err-water
            DeltaAbs_R             = buf_sr-izmerenia.sr-abs-err-dens
            DeltaAbs_Tv            = buf_sr-izmerenia.sr-abs-err-temp-vol
            DeltaAbs_Tr            = buf_sr-izmerenia.sr-abs-err-temp-dens
            DeltaOtn_N             = 0.05
            DeltaOtn_H             = buf_sr-izmerenia.sr-relative-err-neft-water
            DeltaOtn_H_Water       = buf_sr-izmerenia.sr-relative-err-water
            DeltaOtn_R             = buf_sr-izmerenia.sr-relative-err-dens
          .
        end.
      end.
    end.
    
    if pl-rvd-lvl
    then do :
      if pl-level-sr-izm = 0
      or pl-level-sr-izm = ?
      then do :
        message
          substitute ("Для складского места &1 не заданно дополнительное средство измерения уровня",tt-rvs-line.pl-code)
        view-as alert-box error.
        undo _trpomi, return no-apply.
      end .
      else
      if pl-level-sr-izm <> place-si
      or not available buf_sr-izmerenia
      then do :
        find first level_sr-izmerenia no-lock where level_sr-izmerenia.node-code = pl-level-sr-izm no-error.
        if not available level_sr-izmerenia then do :
          message
          "Ошибка работы с библиотекой ПО МИ"
          substitute( 'Не найдено средство измерения с кодом &1', pl-level-sr-izm ) skip
          view-as alert-box error.
          undo _trpomi, return no-apply.
        end.
        else do :
          assign
            A_LevelMeasurementTool = level_sr-izmerenia.sr-temp-line
            DeltaAbs_H             = level_sr-izmerenia.sr-abs-err-neft-water
            DeltaAbs_H_Water       = level_sr-izmerenia.sr-abs-err-water
            DeltaOtn_H             = level_sr-izmerenia.sr-relative-err-neft-water
            DeltaOtn_H_Water       = level_sr-izmerenia.sr-relative-err-water
          .
        end.
      end .
    end .
    
    if pl-rvd-dens
    then do :
      if pl-dens-sr-izm = 0
      or pl-dens-sr-izm = ?
      then do :
        message
          substitute ("Для складского места &1 не заданно дополнительное средство измерения плотности",tt-rvs-line.pl-code)
        view-as alert-box error.
        undo _trpomi, return no-apply.
      end .
      else
      if pl-dens-sr-izm <> place-si 
      or not available buf_sr-izmerenia
      then do :
        find first dens_sr-izmerenia no-lock where dens_sr-izmerenia.node-code = pl-dens-sr-izm no-error.
        if not available dens_sr-izmerenia then do :
          message
          "Ошибка работы с библиотекой ПО МИ"
          substitute( 'Не найдено средство измерения с кодом &1', pl-dens-sr-izm ) skip
          view-as alert-box error.
          undo _trpomi, return no-apply.
        end.
        else do :
          assign
            ToolType               = dens_sr-izmerenia.sr-type-id
            DeltaAbs_R             = dens_sr-izmerenia.sr-abs-err-dens
            DeltaOtn_R             = dens_sr-izmerenia.sr-relative-err-dens
          .
        end.
      end .
    end .
    
    if pl-rvd-temp
    then do :
      if pl-temp-sr-izm = 0
      or pl-temp-sr-izm = ?
      then do :
        message
          substitute ("Для складского места &1 не заданно дополнительное средство измерения температуры",tt-rvs-line.pl-code)
        view-as alert-box error.
        undo _trpomi, return no-apply.
      end .
      else
      if pl-temp-sr-izm <> place-si 
      or not available buf_sr-izmerenia
      then do :
        find first temp_sr-izmerenia no-lock where temp_sr-izmerenia.node-code = pl-temp-sr-izm no-error.
        if not available temp_sr-izmerenia then do :
          message
          "Ошибка работы с библиотекой ПО МИ"
          substitute( 'Не найдено средство измерения с кодом &1', pl-temp-sr-izm ) skip
          view-as alert-box error.
          undo _trpomi, return no-apply.
        end.
        else do :
          assign
            DeltaAbs_Tv            = temp_sr-izmerenia.sr-abs-err-temp-vol
            DeltaAbs_Tr            = temp_sr-izmerenia.sr-abs-err-temp-dens
          .
        end.
      end .
    end .
    
    if available level_sr-izmerenia
    then
      LevelToolType = level_sr-izmerenia.sr-type-level-measuring .
    else
      LevelToolType = buf_sr-izmerenia.sr-type-level-measuring .
      
    if available dens_sr-izmerenia
    and dens_sr-izmerenia.sr-type-izm = 3
    and dens_sr-izmerenia.sr-temperature
    then do :
      DeltaAbs_Tr = dens_sr-izmerenia.sr-abs-err-temp-dens .
    end .
    
    if DeltaAbs_H       = ? then DeltaAbs_H = 0 .
    if DeltaAbs_H_Water = ? then DeltaAbs_H_Water = 0 .
    if DeltaAbs_R       = ? then DeltaAbs_R = 0 .
    if DeltaAbs_Tv      = ? then DeltaAbs_Tv = 0 .
    if DeltaAbs_Tr      = ? then DeltaAbs_Tr = 0 .
    if DeltaOtn_N       = ? then DeltaOtn_N = 0 .
    if DeltaOtn_H       = ? then DeltaOtn_H = 0 .
    if DeltaOtn_H_Water = ? then DeltaOtn_H_Water = 0 .
    if DeltaOtn_R       = ? then DeltaOtn_R = 0 .
    if LevelToolType    = ? then LevelToolType = 0 .
    if ToolType         = ? then ToolType = 0 .
    if A_LevelMeasurementTool = ? then A_LevelMeasurementTool = 0 .
    
    /*..........................................*/
    
    if LevelToolType > 0
    then do :
      RELEASE OBJECT v-mm57 NO-ERROR.
      v-mm57 = ?.

      CREATE value("ADMM.CMethodOfMetering57") v-mm57 no-error.
      IF ERROR-STATUS:ERROR
      OR NOT VALID-HANDLE(v-mm57)
      THEN DO:
        RELEASE OBJECT v-mm57 NO-ERROR.
        v-mm57 = ?.
        message substitute( 'Не удается подключиться к COM-серверу библиотеки для работы с ПО МИ ' ) view-as alert-box .
        undo _trpomi, return no-apply  .
      END.
      ELSE DO :
        assign
          v-mm57:H        = tt-rvs-line.state-level-total * 10
          v-mm57:ToolType = LevelToolType
        .
        OUTPUT stream outstream to value ("pomi.log") append.
        PUT STREAM outstream unformatted
                    "    " SKIP
                    "    " SKIP
                    cur-time-string()           FORMAT "x(16)"    SKIP
                    'Процедура             "Rosneft.MethodOfMetering57"'       SKIP
                    'CODE_PL                = ' tt-rvs-line.pl-code                           SKIP
                    'H                      = ' v-mm57:H                  SKIP
                    'ToolType               = ' v-mm57:ToolType                                      SKIP
                        SKIP SKIP 
        .
        output stream outstream close.
        
        v-mm57:Exec() no-error.
        if v-mm57:Result <> 0 then do :
          error-string = v-mm57:ResultDetail .
          output stream outstream to value ("pomi.log")  append.
          put stream outstream error-string format "X(1024)" skip.
          RELEASE OBJECT v-mm57 NO-ERROR.
          v-mm57 = ?.
          output stream outstream close.
          message substitute('Ошибка работы библиотеки ПО МИ &1',error-string) view-as alert-box .
          undo _trpomi, return no-apply .
        end.
        else do :
          DeltaAbs_H = v-mm57:DeltaAbs_H .
          OUTPUT stream outstream to value ("pomi.log")  append.
          PUT STREAM outstream unformatted
              "v-mm:DeltaAbs_H = " v-mm57:DeltaAbs_H  SKIP
          .
          OUTPUT stream outstream close.
          RELEASE OBJECT v-mm57 NO-ERROR.
          v-mm57 = ?.
        end .
      end .
    end .
    /*..........................................*/

    { gbl/ptrlprop.i
      run
      tt-rvs-line.obj-type
      tt-rvs-line.obj-code
    }
    if not error-status :error then do:
      if ptrlprop-temp-for-pomi = 1 then temp-for-pomi = 15 .
                                    else temp-for-pomi = 20 .
    end.
    /*метод применяемый к данному типу резервуара и */
    find first buf_place no-lock
         where buf_place.obj-code = tt-rvs-line.obj-code
           and buf_place.obj-type = tt-rvs-line.obj-type
           and buf_place.pl-code  = tt-rvs-line.pl-code no-error.
    if buf_place.is-meas  = yes then do :
      if place-type = 1 then do :
        v-proc = "ADMM.CMethodOfMetering13" .
/*        DeltaOtn_K = 0.20 .*/
      end.
      else do :
        v-proc = "ADMM.CMethodOfMetering6" .
/*        DeltaOtn_K = place-ratio-error .*/
      end.
    end.
    else do :
      if place-type = 1 then do :
        v-proc = "ADMM.CMethodOfMetering13" .
/*        DeltaOtn_K = 0.20 .*/
      end.
      else do :
        v-proc = "ADMM.CMethodOfMetering6" .
/*        DeltaOtn_K = place-ratio-error .*/
      end.
    end.
    /*..............................................*/


    RELEASE OBJECT v-mm NO-ERROR.
    v-mm = ?.

    CREATE value(v-proc) v-mm no-error.
    IF ERROR-STATUS:ERROR
    OR NOT VALID-HANDLE(v-mm)
    THEN DO:
      message
      "Не удается подключиться к COM-серверу библиотеки для работы с ПО МИ "
      view-as alert-box error.
      enable
        tt-rvs-line.state-density
/*        tt-rvs-line.state-measure-qnty*/
      with frame Dialog-Frame.
      RELEASE OBJECT v-mm NO-ERROR.
      v-mm = ?.
      undo _trpomi, return no-apply .
    END.
    ELSE DO :
      ASSIGN
        v-mm:H                      = tt-rvs-line.state-level-total * 10
        v-mm:H_water                = tt-rvs-line.state-level-water * 10
        v-mm:CalibrationTable       = CalibTable
        v-mm:Tr                     = tt-rvs-line.state-temperature
        v-mm:Tv                     = if tt-rvs-line.temp-izm-vol <> ? then tt-rvs-line.temp-izm-vol else tt-rvs-line.state-temperature 
        v-mm:R                      = ( tt-rvs-line.izmer-density * 1000 )
        v-mm:Tcy                    = temp-for-pomi
        v-mm:ToolType               = ToolType
        v-mm:DeltaOtn_K             = DeltaOtn_K
        v-mm:DeadZone_Reservoir     = DeadZone_Reservoir
        v-mm:A_LevelMeasurementTool = A_LevelMeasurementTool
        v-mm:DeltaAbs_H             = DeltaAbs_H
        v-mm:DeltaAbs_H_Water       = DeltaAbs_H_Water
        v-mm:DeltaAbs_R             = DeltaAbs_R
        v-mm:DeltaAbs_Tv            = DeltaAbs_Tv
        v-mm:DeltaAbs_Tr            = DeltaAbs_Tr
        v-mm:DeltaOtn_H             = DeltaOtn_H
        v-mm:DeltaOtn_H_Water       = DeltaOtn_H_Water
        v-mm:DeltaOtn_R             = DeltaOtn_R
        v-mm:DeltaOtn_N             = DeltaOtn_N
      .
/*      v-mm:Set_A_Reservoir(replace(string(A_Reservoir), ".", ",")).*/

      OUTPUT stream outstream to value ("pomi.log") append.
              PUT STREAM outstream unformatted
              "    " SKIP
              "    " SKIP
              cur-time-string()           FORMAT "x(16)"    SKIP
              'Процедура'                 v-proc                      FORMAT "x(128)"   SKIP
              'CODE_PL                = ' tt-rvs-line.pl-code                           SKIP
              'H                      = ' v-mm:H                                             SKIP
              'H_water                = ' v-mm:H_water                                       SKIP
              'CalibrationTable       = ' v-mm:CalibrationTable                              SKIP
              'Tr                     = ' v-mm:Tr                                            SKIP
              'Tv                     = ' v-mm:Tv                                            SKIP
              'R                      = ' v-mm:R                                             SKIP
              'Tcy                    = ' v-mm:Tcy                                           SKIP
              'ToolType               = ' v-mm:ToolType                                      SKIP
              'DeadZone_Reservoir     = ' v-mm:DeadZone_Reservoir                            SKIP
              'DeltaOtn_K             = ' v-mm:DeltaOtn_K                                    SKIP
              'A_Reservoir            = ' v-mm:A_Reservoir                                   SKIP
              'A_LevelMeasurementTool = ' v-mm:A_LevelMeasurementTool                        skip
              'DeltaAbs_H             = ' v-mm:DeltaAbs_H                                    SKIP
              'DeltaAbs_H_Water       = ' v-mm:DeltaAbs_H_Water                              SKIP
              'DeltaAbs_R             = ' v-mm:DeltaAbs_R                                    SKIP
              'DeltaAbs_Tv            = ' v-mm:DeltaAbs_Tv                                   SKIP
              'DeltaAbs_Tr            = ' v-mm:DeltaAbs_Tr                                   SKIP
              'DeltaOtn_H             = ' v-mm:DeltaOtn_H                                    SKIP
              'DeltaOtn_H_Water       = ' v-mm:DeltaOtn_H_Water                              SKIP
              'DeltaOtn_R             = ' v-mm:DeltaOtn_R                                    SKIP
              'DeltaOtn_N             = ' v-mm:DeltaOtn_N                                    SKIP
      .
      
      output stream outstream close.
      v-mm:Exec() .
      if v-mm:Result <> 0 then do :
        error-string = v-mm:ResultDetail .
        output stream outstream to value ("pomi.log")  append.
        put stream outstream error-string format "X(1024)" skip.
        message
        substitute('Ошибка работы библиотеки ПО МИ. &1',error-string)
        view-as alert-box error.
        RELEASE OBJECT v-mm NO-ERROR.
        v-mm = ?.
        output stream outstream close.
        undo _trpomi, return no-apply .
      end.
      else do :
        v-mm-density = decimal(v-mm:Rv) / 1000 .
        varstate-water-qnty = v-mm:V_water * 1000 .
        assign        
        tt-rvs-line.state-measure-qnty     = v-mm:V * 1000       
        tt-rvs-line.state-measure-cli-qnty = v-mm:M        
        tt-rvs-line.state-brutto-qnty      = tt-rvs-line.state-measure-qnty + varstate-water-qnty
        tt-rvs-line.state-density          = v-mm-density
        .
        
        assign
          tt-rvs-line.fact-calc-add-mass = tt-rvs-line.state-add-qnty * tt-rvs-line.state-density  
          tt-rvs-line.fact-calc-vol = tt-rvs-line.state-measure-qnty 
          tt-rvs-line.fact-sum-vol = tt-rvs-line.fact-calc-vol + tt-rvs-line.state-add-qnty 
          tt-rvs-line.fact-sum-mass = tt-rvs-line.fact-calc-add-mass + tt-rvs-line.state-measure-cli-qnty 
          varstate-sum-vol = varstate-water-qnty + tt-rvs-line.fact-calc-vol 
        .
        
        abs-delta-mass-add-qnty = tt-rvs-line.fact-calc-add-mass * pl-error-mass / 100 .
        
/*        if density = ? then density = tt-rvs-line.state-density .                   */
/*        tt-rvs-line.state-brutto-cli-qnty  = tt-rvs-line.state-brutto-qnty * density*/
        tt-rvs-line.state-brutto-cli-qnty  = tt-rvs-line.state-brutto-qnty * tt-rvs-line.state-density .
        
        if v-mm:DeltaOtn_M > 0.65 then delta-mass-qnty = 0.65. else delta-mass-qnty = v-mm:DeltaOtn_M  .
        
        abs-delta-mass-qnty = tt-rvs-line.state-measure-cli-qnty * delta-mass-qnty / 100 .
        
        display
          delta-mass-qnty 
  /*        tt-rvs-line.state-brutto-qnty    */
  /*        tt-rvs-line.state-brutto-cli-qnty*/
  /*        tt-rvs-line.state-measure-qnty*/
          tt-rvs-line.state-density
  /*        tt-rvs-line.state-measure-cli-qnty*/
          tt-rvs-line.fact-calc-vol
          tt-rvs-line.fact-sum-vol
          tt-rvs-line.fact-sum-mass
          tt-rvs-line.fact-calc-add-mass
          abs-delta-mass-add-qnty
          abs-delta-mass-qnty
          varstate-sum-vol
          varstate-water-qnty
        with frame {&frame-name} .
        
        assign
          v-POkMI-result =
            "MM:V_total             = " + v-mm:V_total     + {&new-line} +
            "MM:V_water             = " + v-mm:V_water     + {&new-line} +
            "MM:DeltaV              = " + v-mm:DeltaV     + {&new-line} +
            "MM:Vcy                 = " + v-mm:Vcy     + {&new-line} +
            "MM:Rcy                 = " + v-mm:Rcy          + {&new-line} +
            "MM:Mcy                 = " + v-mm:Mcy + {&new-line} +
            "MM:V_product           = " + v-mm:V_product  + {&new-line} +
            "MM:V                   = " + v-mm:V  + {&new-line} + 
            "MM:Rv                  = " + v-mm:Rv  + {&new-line} +
            "MM:M                   = " + v-mm:M  + {&new-line} +
            "MM:CTL_base_alt        = " + v-mm:CTL_base_alt  + {&new-line} +
            "MM:CPL_base_alt        = " + v-mm:CPL_base_alt + {&new-line} +
            "MM:CTPL_base_alt       = " + v-mm:CTPL_base_alt  + {&new-line} +
            "MM:Fp_base_alt         = " + v-mm:Fp_base_alt  + {&new-line} +
            "MM:CTL_obs_base        = " + v-mm:CTL_obs_base + {&new-line} +
            "MM:CPL_obs_base        = " + v-mm:CPL_obs_base  + {&new-line} +
            "MM:CTPL_obs_base       = " + v-mm:CTPL_obs_base  + {&new-line} +
            "MM:Fp_obs_base         = " + v-mm:Fp_obs_base  + {&new-line} +
            "MM:DeltaOtn_Vcy        = " + v-mm:DeltaOtn_Vcy  + {&new-line} +
            "MM:DeltaOtn_Vm         = " + v-mm:DeltaOtn_Vm  + {&new-line} +
            "MM:DeltaOtn_M          = " + v-mm:DeltaOtn_M  + {&new-line} +
            "MM:VolumetricExpansion = " + v-mm:VolumetricExpansion
        .
        OUTPUT stream outstream to value ("pomi.log")  append.
        PUT STREAM outstream unformatted v-POkMI-result skip .
        OUTPUT stream outstream close.
        
        assign
          v-POkMI-result-attr = 
            "Масса НП, кг: " + string(v-mm:M, "->>,>>>,>>9.9":U) + {&new-line} +
            "Относительная погрешность измерения массы нефтепродукта, %: "  + string(v-mm:DeltaOtn_M, "->>,>>9.99":U) + {&new-line} +
            "Плотность, приведенная к стандартным условиям, г/см3: " + string((v-mm:Rcy / 1000), "9.9999":U) + {&new-line} +
            "Объем, приведенный к стандартным условиям, л: " + string((v-mm:Vcy * 1000), "->>,>>>,>>9":U) + {&new-line} +
            "Объем НП при температуре его измерения, л: " + string((v-mm:V * 1000), "->>,>>>,>>9":U) + {&new-line} +
            "Объем воды, л: " + string((v-mm:V_water * 1000), "->>,>>>,>>9":U)
        .
        
        RELEASE OBJECT v-mm NO-ERROR.
        v-mm = ?.
        
        find first rvs-line-attr exclusive-lock
              where rvs-line-attr.obj-code  = tt-rvs-line.obj-code
                and rvs-line-attr.obj-type  = tt-rvs-line.obj-type
                and rvs-line-attr.gds-code  = tt-rvs-line.gds-code
                and rvs-line-attr.pl-code   = tt-rvs-line.pl-code
                and rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
                and rvs-line-attr.attr-code = "POkMI-result" no-error.
        if available rvs-line-attr then do :
          rvs-line-attr.attr-value = v-POkMI-result-attr .
        end.
        else do :
          create rvs-line-attr.
          assign
            rvs-line-attr.obj-code  = tt-rvs-line.obj-code
            rvs-line-attr.obj-type  = tt-rvs-line.obj-type
            rvs-line-attr.gds-code  = tt-rvs-line.gds-code
            rvs-line-attr.pl-code   = tt-rvs-line.pl-code
            rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
            rvs-line-attr.attr-code = "POkMI-result"
            rvs-line-attr.attr-value = v-POkMI-result-attr
          .
        end.
        
        enable
          b-POkMI-result
        with frame Dialog-Frame.
        
        run volume-water no-error.
        if error-status :error then do :
                                 undo _trpomi, return .
                               end.
        run chg-density no-error.
        if error-status :error then do :
                                 undo _trpomi, return .
                               end.
        run weath-water no-error.
        if error-status:error then do :
                                undo _trpomi, return .
                              end.
      end.
    END.
  end.
  
  find first rvs-line-attr exclusive-lock
       where rvs-line-attr.obj-code  = tt-rvs-line.obj-code
         and rvs-line-attr.obj-type  = tt-rvs-line.obj-type
         and rvs-line-attr.gds-code  = tt-rvs-line.gds-code
         and rvs-line-attr.pl-code   = tt-rvs-line.pl-code
         and rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
         and rvs-line-attr.attr-code = "is-calc" no-error.
  if not available rvs-line-attr then do :
    create rvs-line-attr.
    assign
      rvs-line-attr.obj-code  = tt-rvs-line.obj-code
      rvs-line-attr.obj-type  = tt-rvs-line.obj-type
      rvs-line-attr.gds-code  = tt-rvs-line.gds-code
      rvs-line-attr.pl-code   = tt-rvs-line.pl-code
      rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
      rvs-line-attr.attr-code = "is-calc"
    .
  end.
  rvs-line-attr.attr-value = "yes" .
  release rvs-line-attr no-error .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-temperature
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-temperature Dialog-Frame
ON CHOOSE OF b-temperature IN FRAME Dialog-Frame /* Ввод */
DO:
  define buffer temp_sr-izmerenia for sr-izmerenia .
  define buffer dens_sr-izmerenia for sr-izmerenia .
  define variable vOk as logical no-undo .
  define variable v-out-temp as decimal no-undo .
  define variable v-izm-temps as character no-undo .
  
  if pl-rvd-temp
  then do :
    find first temp_sr-izmerenia no-lock where temp_sr-izmerenia.node-code = pl-temp-sr-izm no-error.  
  end .
  else do :
    find first temp_sr-izmerenia no-lock where temp_sr-izmerenia.node-code = place-si no-error.
  end .
  if not available temp_sr-izmerenia
  then do :
    message "Для резервуара не задано основное средство измерения или средство измерения температуры!" view-as alert-box .
    return no-apply .
  end .
  if not temp_sr-izmerenia.sr-temperature
  then do :
    message "Средство измерения " string(temp_sr-izmerenia.node-code) " не может измерять температуру!" view-as alert-box .
    return no-apply .
  end . 
  if temp_sr-izmerenia.sr-type-izm = 2 /* 2 - Измерительная система */
  then do :
    message "Средство измерения температуры " string(temp_sr-izmerenia.node-code) " является измерительной системой! Значение температуры определяется показателями СИ." view-as alert-box .
    return no-apply .
  end .                  
  run str/rvs-lin-temperature.w (input temp_sr-izmerenia.sr-type-izm,
                                 input place-diameter,
                                 input tt-rvs-line.state-level-total * 10,
                                 output v-out-temp,
                                 output vOk)
                                 .
  if vOk
  then do :      
    tt-rvs-line.temp-izm-vol = v-out-temp .                        
    display tt-rvs-line.temp-izm-vol with frame Dialog-Frame .
    
    if pl-rvd-temp
    and not pl-rvd-dens
    then do :
      tt-rvs-line.state-temperature = v-out-temp .
      display tt-rvs-line.state-temperature with frame Dialog-Frame .
    end . 
    
    if pl-rvd-temp
    and pl-rvd-dens
    then do :
      find first rvs-line-attr no-lock
           where rvs-line-attr.obj-code  = tt-rvs-line.obj-code
             and rvs-line-attr.obj-type  = tt-rvs-line.obj-type
             and rvs-line-attr.gds-code  = tt-rvs-line.gds-code
             and rvs-line-attr.pl-code   = tt-rvs-line.pl-code
             and rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
             and rvs-line-attr.attr-code = "state-temp-changed" no-error.
      if available rvs-line-attr
      and logical(rvs-line-attr.attr-value)
      then do : end .
      else do :
        tt-rvs-line.state-temperature = v-out-temp .
        display tt-rvs-line.state-temperature with frame Dialog-Frame .
      end .       
    end .
    
    if pl-rvd-dens
    then do :
      find first dens_sr-izmerenia no-lock where dens_sr-izmerenia.node-code = pl-dens-sr-izm no-error.
    end .
    else do :
      find first dens_sr-izmerenia no-lock where dens_sr-izmerenia.node-code = place-si no-error.
    end .
  
    if available dens_sr-izmerenia
    and dens_sr-izmerenia.sr-type-izm = 0 /* 0 - Автоматизированное СИ */
    then do :
/*      tt-rvs-line.state-temperature = v-out-temp .                   */
/*      display tt-rvs-line.state-temperature with frame Dialog-Frame .*/
      
      v-izm-temps = string(dens_sr-izmerenia.sr-type-izm) + ";" .
      for each tt-temps no-lock by tt-temps.ii descending :
        v-izm-temps = v-izm-temps + string(tt-temps.temperature) + "," .
      end .
      v-izm-temps = trim(v-izm-temps, ",") .
      find first rvs-line-attr exclusive-lock
           where rvs-line-attr.obj-code  = tt-rvs-line.obj-code
             and rvs-line-attr.obj-type  = tt-rvs-line.obj-type
             and rvs-line-attr.gds-code  = tt-rvs-line.gds-code
             and rvs-line-attr.pl-code   = tt-rvs-line.pl-code
             and rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
             and rvs-line-attr.attr-code = "izm-temps" no-error.
      if not available rvs-line-attr then do :
        create rvs-line-attr.
        assign
          rvs-line-attr.obj-code  = tt-rvs-line.obj-code
          rvs-line-attr.obj-type  = tt-rvs-line.obj-type
          rvs-line-attr.gds-code  = tt-rvs-line.gds-code
          rvs-line-attr.pl-code   = tt-rvs-line.pl-code
          rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
          rvs-line-attr.attr-code = "izm-temps"
          rvs-line-attr.attr-value = v-izm-temps
        .
      end.
      else do :
        rvs-line-attr.attr-value = v-izm-temps .
      end.
    end .
  end .                              
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-density
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-density Dialog-Frame
ON CHOOSE OF b-density IN FRAME Dialog-Frame /* Ввод */
DO:
  define buffer dens_sr-izmerenia for sr-izmerenia .
  define variable vOk as logical no-undo .
  define variable v-out-dens as decimal no-undo .
  define variable v-out-temp as decimal no-undo .
  define variable v-izm-temps as character no-undo .
  define variable v-izm-denses as character no-undo .
  
  if pl-rvd-dens
  then do :
    find first dens_sr-izmerenia no-lock where dens_sr-izmerenia.node-code = pl-dens-sr-izm no-error.
  end .
  else do :
    find first dens_sr-izmerenia no-lock where dens_sr-izmerenia.node-code = place-si no-error.
  end .   
  if not available dens_sr-izmerenia
  then do :
    message "Для резервуара не задано основное средство измерения или средство измерения плотности!" view-as alert-box .
    return no-apply .
  end .
  if not dens_sr-izmerenia.sr-density
  then do :
    message "Средство измерения " string(dens_sr-izmerenia.node-code) " не может измерять плотность!" view-as alert-box .
    return no-apply .
  end .
  if dens_sr-izmerenia.sr-type-izm = 2 /* 2 - Измерительная система*/
  then do :
    message "Средство измерения плотности " string(dens_sr-izmerenia.node-code) " является измерительной системой! Значение плотности определяется показателями СИ." view-as alert-box .
    return no-apply .
  end .
  if dens_sr-izmerenia.sr-type-izm = 0 /* 0 - Автоматизированное СИ */
  then do :                    
    run str/rvs-lin-density.w (input dens_sr-izmerenia.sr-type-izm,
                               input place-diameter,
                               input tt-rvs-line.state-level-total * 10,
                               output v-out-dens,
                               output vOk)
                               .
    if vOk
    then do :
      assign
        tt-rvs-line.izmer-density = v-out-dens                          
        tt-rvs-line.state-density = tt-rvs-line.izmer-density
      .                           
      display tt-rvs-line.izmer-density tt-rvs-line.state-density with frame Dialog-Frame . 
      
      v-izm-denses = string(dens_sr-izmerenia.sr-type-izm) + ";" .
      for each tt-dens no-lock by tt-dens.ii descending :
        v-izm-denses = v-izm-denses + string(tt-dens.density) + "," .
      end .
      v-izm-denses = trim(v-izm-denses, ",") .
      find first rvs-line-attr exclusive-lock
           where rvs-line-attr.obj-code  = tt-rvs-line.obj-code
             and rvs-line-attr.obj-type  = tt-rvs-line.obj-type
             and rvs-line-attr.gds-code  = tt-rvs-line.gds-code
             and rvs-line-attr.pl-code   = tt-rvs-line.pl-code
             and rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
             and rvs-line-attr.attr-code = "izm-denses" no-error.
      if not available rvs-line-attr then do :
        create rvs-line-attr.
        assign
          rvs-line-attr.obj-code  = tt-rvs-line.obj-code
          rvs-line-attr.obj-type  = tt-rvs-line.obj-type
          rvs-line-attr.gds-code  = tt-rvs-line.gds-code
          rvs-line-attr.pl-code   = tt-rvs-line.pl-code
          rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
          rvs-line-attr.attr-code = "izm-denses"
          rvs-line-attr.attr-value = v-izm-denses
        .
      end.
      else do :
        rvs-line-attr.attr-value = v-izm-denses .
      end.
    end .
  end .
  if dens_sr-izmerenia.sr-type-izm = 1 /* 1 - Неавтоматизированное СИ */
  then do :                    
    run str/rvs-lin-dens-temp.w (input dens_sr-izmerenia.sr-type-izm,
                               input place-diameter,
                               input tt-rvs-line.state-level-total * 10,
                               output v-out-dens,
                               output v-out-temp,
                               output vOk)
                               .
    if vOk
    then do : 
      assign      
        tt-rvs-line.izmer-density = v-out-dens                    
        tt-rvs-line.state-density = tt-rvs-line.izmer-density
      .                           
      display tt-rvs-line.izmer-density tt-rvs-line.state-density with frame Dialog-Frame . 
      
      tt-rvs-line.state-temperature = v-out-temp .
      display tt-rvs-line.state-temperature with frame Dialog-Frame .
      
      find first rvs-line-attr exclusive-lock
           where rvs-line-attr.obj-code  = tt-rvs-line.obj-code
             and rvs-line-attr.obj-type  = tt-rvs-line.obj-type
             and rvs-line-attr.gds-code  = tt-rvs-line.gds-code
             and rvs-line-attr.pl-code   = tt-rvs-line.pl-code
             and rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
             and rvs-line-attr.attr-code = "state-temp-changed" no-error.
      if not available rvs-line-attr then do :
        create rvs-line-attr.
        assign
          rvs-line-attr.obj-code  = tt-rvs-line.obj-code
          rvs-line-attr.obj-type  = tt-rvs-line.obj-type
          rvs-line-attr.gds-code  = tt-rvs-line.gds-code
          rvs-line-attr.pl-code   = tt-rvs-line.pl-code
          rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
          rvs-line-attr.attr-code = "state-temp-changed"
          rvs-line-attr.attr-value = string(yes)
        .
      end.
      else do :
        rvs-line-attr.attr-value = string(yes) .
      end.
      
      v-izm-temps = string(dens_sr-izmerenia.sr-type-izm) + ";" .
      v-izm-denses = string(dens_sr-izmerenia.sr-type-izm) + ";" .
      for each tt-dens-temp no-lock by tt-dens-temp.ii :
        v-izm-temps = v-izm-temps + string(tt-dens-temp.temperature) + "," .
        v-izm-denses = v-izm-denses + string(tt-dens-temp.density) + "," .
      end .
      v-izm-temps = trim(v-izm-temps, ",") .
      v-izm-denses = trim(v-izm-denses, ",") .
      
      find first rvs-line-attr exclusive-lock
           where rvs-line-attr.obj-code  = tt-rvs-line.obj-code
             and rvs-line-attr.obj-type  = tt-rvs-line.obj-type
             and rvs-line-attr.gds-code  = tt-rvs-line.gds-code
             and rvs-line-attr.pl-code   = tt-rvs-line.pl-code
             and rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
             and rvs-line-attr.attr-code = "izm-temps" no-error.
      if not available rvs-line-attr then do :
        create rvs-line-attr.
        assign
          rvs-line-attr.obj-code  = tt-rvs-line.obj-code
          rvs-line-attr.obj-type  = tt-rvs-line.obj-type
          rvs-line-attr.gds-code  = tt-rvs-line.gds-code
          rvs-line-attr.pl-code   = tt-rvs-line.pl-code
          rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
          rvs-line-attr.attr-code = "izm-temps"
          rvs-line-attr.attr-value = v-izm-temps
        .
      end.
      else do :
        rvs-line-attr.attr-value = v-izm-temps .
      end.
      
      find first rvs-line-attr exclusive-lock
           where rvs-line-attr.obj-code  = tt-rvs-line.obj-code
             and rvs-line-attr.obj-type  = tt-rvs-line.obj-type
             and rvs-line-attr.gds-code  = tt-rvs-line.gds-code
             and rvs-line-attr.pl-code   = tt-rvs-line.pl-code
             and rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
             and rvs-line-attr.attr-code = "izm-denses" no-error.
      if not available rvs-line-attr then do :
        create rvs-line-attr.
        assign
          rvs-line-attr.obj-code  = tt-rvs-line.obj-code
          rvs-line-attr.obj-type  = tt-rvs-line.obj-type
          rvs-line-attr.gds-code  = tt-rvs-line.gds-code
          rvs-line-attr.pl-code   = tt-rvs-line.pl-code
          rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
          rvs-line-attr.attr-code = "izm-denses"
          rvs-line-attr.attr-value = v-izm-denses
        .
      end.
      else do :
        rvs-line-attr.attr-value = v-izm-denses .
      end.
    end .
  end .                              
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-save
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-save Dialog-Frame
ON CHOOSE OF b-save IN FRAME Dialog-Frame /* Ввод */
DO:
  define variable v-water     as decimal   no-undo .
  define variable v-water-cli as decimal   no-undo .
define variable v-vid-action        as integer no-undo .
define variable v-vid-param         as longchar no-undo .
  { gbl/stdbtn.i }
define variable v-shift-date like ub.shift-obj.shift-date no-undo .
define variable v-shift-num  like ub.shift-obj.shift-num no-undo .
define variable v-shift-name like ub.shift-obj.shift-name no-undo.

define buffer olddens-rvs-line-attr for ub.rvs-line-attr .
define variable v-is-olddens as logical no-undo initial no .
    
{ gbl/curshift.i
        buf_rvs-doc.obj-type
        buf_rvs-doc.obj-code
        v-shift-date
        v-shift-num
        v-shift-name
        no-error
      }
  
  if input frame {&frame-name} tt-rvs-line.state-measure-qnty >
     input frame {&frame-name} tt-rvs-line.state-brutto-qnty  then do:
     message "Объем топлива больше общего объема."
     view-as alert-box error.
     apply "entry" to tt-rvs-line.state-measure-qnty in frame {&frame-name}.
     return no-apply.
  end.
  
  
  if rdc-value = "pomi-rn" then do :
    if tt-rvs-line.izmer-density = ? or tt-rvs-line.izmer-density = 0
    then do :
      message "Сохранение введенных параметров НП невозможно." skip (1)
              "Плотность НП унаследована у предыдущего документа сверки." skip
              'Введите измеренную плотность и нажмите кнопку "Рассчитать".'
      view-as alert-box information.
      apply "entry" to tt-rvs-line.izmer-density in frame {&frame-name}.
      return no-apply.
    end.
    
    find first rvs-line-attr exclusive-lock
         where rvs-line-attr.obj-code  = tt-rvs-line.obj-code
           and rvs-line-attr.obj-type  = tt-rvs-line.obj-type
           and rvs-line-attr.gds-code  = tt-rvs-line.gds-code
           and rvs-line-attr.pl-code   = tt-rvs-line.pl-code
           and rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
           and rvs-line-attr.attr-code = "is-calc" no-error.
    if not available rvs-line-attr
    or (available rvs-line-attr and rvs-line-attr.attr-value <> "yes") 
    then do :
      message "Сохранение введенных параметров НП невозможно." skip (1)
              "Не выполнено приведение параметров НП к стандартной температуре." skip
              'Нажмите кнопку "Рассчитать" и повторите попытку.'
      view-as alert-box information.
      apply "entry" to b-calc in frame {&frame-name}.
      return no-apply.
    end.  
  end.    

/*  assign                                                                                                                                    */
/*    v-water     = input frame {&frame-name} tt-rvs-line.state-brutto-qnty - input frame {&frame-name} tt-rvs-line.state-measure-qnty        */
/*    v-water-cli = input frame {&frame-name} tt-rvs-line.state-brutto-cli-qnty - input frame {&frame-name} tt-rvs-line.state-measure-cli-qnty*/
/*  .                                                                                                                                         */
/*                                                                                                                                            */
/*  if ( v-water <> ?                                                                                                                         */
/*       and v-water <> 0                                                                                                                     */
/*       and ( v-water-cli = ?                                                                                                                */
/*             or v-water-cli = 0                                                                                                             */
/*           )                                                                                                                                */
/*     )                                                                                                                                      */
/*     or                                                                                                                                     */
/*     ( v-water-cli <> ?                                                                                                                     */
/*       and v-water-cli <> 0                                                                                                                 */
/*       and ( v-water = ?                                                                                                                    */
/*             or v-water = 0                                                                                                                 */
/*           )                                                                                                                                */
/*     )                                                                                                                                      */
/*  then do:                                                                                                                                  */
/*     message                                                                                                                                */
/*       substitute( "Объем воды (&1) не соответствует его весу (&2)!", v-water, v-water-cli )                                                */
/*       view-as alert-box error.                                                                                                             */
/*     return no-apply.                                                                                                                       */
/*  end.                                                                                                                                      */

  find first buf_rvs-line
    where recid(buf_rvs-line) =  parrec-rvs-line
    no-error.
  /* Все validation */
  run level-water in this-procedure
    ( input yes
    ) no-error.
  if error-status :error then do:
    apply "ENTRY":U to tt-rvs-line.state-level-total in frame {&frame-name}.
    return no-apply.
  end.
  run volume-water in this-procedure               no-error.
  if error-status :error then do: return no-apply. end.
  run chg-density  in this-procedure               no-error.
  if error-status :error then do: return no-apply. end.
  run weath-water  in this-procedure               no-error.
  if error-status :error then do: return no-apply. end.
  assign frame {&frame-name} {&list-3}.
  assign tt-rvs-line.state-level-petrol = tt-rvs-line.state-level-total - tt-rvs-line.state-level-water .
  buffer-copy tt-rvs-line to buf_rvs-line.

  find first rvs-line-attr exclusive-lock
       where rvs-line-attr.obj-code  = tt-rvs-line.obj-code
         and rvs-line-attr.obj-type  = tt-rvs-line.obj-type
         and rvs-line-attr.gds-code  = tt-rvs-line.gds-code
         and rvs-line-attr.pl-code   = tt-rvs-line.pl-code
         and rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
         and rvs-line-attr.attr-code = "izmer-density" no-error.
  if not available rvs-line-attr then do :
    create rvs-line-attr.
    assign
      rvs-line-attr.obj-code  = tt-rvs-line.obj-code
      rvs-line-attr.obj-type  = tt-rvs-line.obj-type
      rvs-line-attr.gds-code  = tt-rvs-line.gds-code
      rvs-line-attr.pl-code   = tt-rvs-line.pl-code
      rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
      rvs-line-attr.attr-code = "izmer-density"
      rvs-line-attr.attr-value = string(tt-rvs-line.izmer-density)
    .
  end.
  else do :
    rvs-line-attr.attr-value = string(tt-rvs-line.izmer-density) .
  end.
  
  find first rvs-line-attr exclusive-lock
       where rvs-line-attr.obj-code  = tt-rvs-line.obj-code
         and rvs-line-attr.obj-type  = tt-rvs-line.obj-type
         and rvs-line-attr.gds-code  = tt-rvs-line.gds-code
         and rvs-line-attr.pl-code   = tt-rvs-line.pl-code
         and rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
         and rvs-line-attr.attr-code = "temp-izm-vol" no-error.
  if not available rvs-line-attr then do :
    create rvs-line-attr.
    assign
      rvs-line-attr.obj-code  = tt-rvs-line.obj-code
      rvs-line-attr.obj-type  = tt-rvs-line.obj-type
      rvs-line-attr.gds-code  = tt-rvs-line.gds-code
      rvs-line-attr.pl-code   = tt-rvs-line.pl-code
      rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
      rvs-line-attr.attr-code = "temp-izm-vol"
      rvs-line-attr.attr-value = string(tt-rvs-line.temp-izm-vol)
    .
  end.
  else do :
    rvs-line-attr.attr-value = string(tt-rvs-line.temp-izm-vol) .
  end.
 
  find first rvs-line-attr exclusive-lock
       where rvs-line-attr.obj-code  = tt-rvs-line.obj-code
         and rvs-line-attr.obj-type  = tt-rvs-line.obj-type
         and rvs-line-attr.gds-code  = tt-rvs-line.gds-code
         and rvs-line-attr.pl-code   = tt-rvs-line.pl-code
         and rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
         and rvs-line-attr.attr-code = "input-type" no-error.
  if not available rvs-line-attr then do :
    create rvs-line-attr.
    assign
      rvs-line-attr.obj-code  = tt-rvs-line.obj-code
      rvs-line-attr.obj-type  = tt-rvs-line.obj-type
      rvs-line-attr.gds-code  = tt-rvs-line.gds-code
      rvs-line-attr.pl-code   = tt-rvs-line.pl-code
      rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
      rvs-line-attr.attr-code = "input-type"
    .
  end.
  if buf_rvs-line.density = ? or buf_rvs-line.density = 0
  then do :
    rvs-line-attr.attr-value = "р" .
  end.
  else do :
    if v-hand-input /* Плотность редактировалась */
    then do :
      if rvs-line-attr.attr-value = "а" then rvs-line-attr.attr-value = "ак" .
      if rvs-line-attr.attr-value = "ф" then rvs-line-attr.attr-value = "фк" .
    end.
    else do :
      find first olddens-rvs-line-attr no-lock
           where olddens-rvs-line-attr.obj-code  = tt-rvs-line.obj-code
             and olddens-rvs-line-attr.obj-type  = tt-rvs-line.obj-type
             and olddens-rvs-line-attr.gds-code  = tt-rvs-line.gds-code
             and olddens-rvs-line-attr.pl-code   = tt-rvs-line.pl-code
             and olddens-rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
             and olddens-rvs-line-attr.attr-code = "is-olddens" no-error.
      if available olddens-rvs-line-attr
      then do :
        v-is-olddens = logical(olddens-rvs-line-attr.attr-value) no-error.
        if error-status:error then v-is-olddens = no .
      end.
      else do :
        v-is-olddens = no .
      end.
      if v-is-olddens and 
      (rvs-line-attr.attr-value = "а" or rvs-line-attr.attr-value = "ф")
      then rvs-line-attr.attr-value = "п" .
    end.
  end.
/*  find first rvs-line-attr exclusive-lock                        */
/*       where rvs-line-attr.obj-code  = tt-rvs-line.obj-code      */
/*         and rvs-line-attr.obj-type  = tt-rvs-line.obj-type      */
/*         and rvs-line-attr.gds-code  = tt-rvs-line.gds-code      */
/*         and rvs-line-attr.pl-code   = tt-rvs-line.pl-code       */
/*         and rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code      */
/*         and rvs-line-attr.attr-code = "mass-float-cov" no-error.*/
/*  if not available rvs-line-attr then do :                       */
/*    create rvs-line-attr.                                        */
/*    assign                                                       */
/*      rvs-line-attr.obj-code  = tt-rvs-line.obj-code             */
/*      rvs-line-attr.obj-type  = tt-rvs-line.obj-type             */
/*      rvs-line-attr.gds-code  = tt-rvs-line.gds-code             */
/*      rvs-line-attr.pl-code   = tt-rvs-line.pl-code              */
/*      rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code             */
/*      rvs-line-attr.attr-code = "mass-float-cov"                 */
/*      rvs-line-attr.attr-value = string(mass-float-cov) .        */
/*    .                                                            */
/*  end.                                                           */
/*  else do :                                                      */
/*    rvs-line-attr.attr-value = string(mass-float-cov) .          */
/*  end.                                                           */

find first rvs-line-attr exclusive-lock
    where rvs-line-attr.obj-code  = tt-rvs-line.obj-code
    and rvs-line-attr.obj-type  = tt-rvs-line.obj-type
    and rvs-line-attr.gds-code  = tt-rvs-line.gds-code
    and rvs-line-attr.pl-code   = tt-rvs-line.pl-code
    and rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
    and rvs-line-attr.attr-code = "delta-mass-qnty" no-error.
if available rvs-line-attr then
do :
    rvs-line-attr.attr-value = string(delta-mass-qnty)  .
end.
else
do :
    create rvs-line-attr.
    assign
        rvs-line-attr.obj-code   = tt-rvs-line.obj-code
        rvs-line-attr.obj-type   = tt-rvs-line.obj-type
        rvs-line-attr.gds-code   = tt-rvs-line.gds-code
        rvs-line-attr.pl-code    = tt-rvs-line.pl-code
        rvs-line-attr.rvs-code   = tt-rvs-line.rvs-code
        rvs-line-attr.attr-code  = "delta-mass-qnty"
        rvs-line-attr.attr-value = string( delta-mass-qnty)
        .
end.

find first rvs-line-attr exclusive-lock
    where rvs-line-attr.obj-code  = tt-rvs-line.obj-code
    and rvs-line-attr.obj-type  = tt-rvs-line.obj-type
    and rvs-line-attr.gds-code  = tt-rvs-line.gds-code
    and rvs-line-attr.pl-code   = tt-rvs-line.pl-code
    and rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
    and rvs-line-attr.attr-code = "hand-save" no-error.
if available rvs-line-attr then
do :
    rvs-line-attr.attr-value = string(yes)  .
end.
else
do :
    create rvs-line-attr.
    assign
        rvs-line-attr.obj-code   = tt-rvs-line.obj-code
        rvs-line-attr.obj-type   = tt-rvs-line.obj-type
        rvs-line-attr.gds-code   = tt-rvs-line.gds-code
        rvs-line-attr.pl-code    = tt-rvs-line.pl-code
        rvs-line-attr.rvs-code   = tt-rvs-line.rvs-code
        rvs-line-attr.attr-code  = "hand-save"
        rvs-line-attr.attr-value = string(yes)
        .
end.

release rvs-line-attr no-error .
/*  find first rvs-doc where rvs-doc.rvs-code = tt-rvs-line.rvs-code no-lock no-error.*/
      v-vid-action = 56 .
    v-vid-param = 
          "Initiator=" + v-initiator + {&delim-par} +
          "SHOP_NUM=" + string(buf_rvs-doc.obj-code) + {&delim-par} +
          "DocType=" + string(buf_rvs-doc.rvs-type) + {&delim-par} +
          "DocNum=" + string(buf_rvs-doc.rvs-code) + {&delim-par} +
/*            "ShiftNum=" + string(bf_rvs-doc.shift-num) + {&delim-par} +  */
/*            "ShiftDate=" + string(bf_rvs-doc.shift-date) + {&delim-par} +*/
          "SHIFT_NUM_DOC=" + (if string(buf_rvs-doc.shift-num) = ? then '' else string(buf_rvs-doc.shift-num)) + (if string(buf_rvs-doc.shift-date) = ? then '' else string(buf_rvs-doc.shift-date, "99999999")) + {&delim-par} +  
          "SHIFT_NUM=" + (if string(v-shift-num) = ? then '' else string(v-shift-num)) + (if string(v-shift-date) = ? then '' else string(v-shift-date, "99999999")) + {&delim-par} +

          
          "PlCode=" + string( tt-rvs-line.pl-code) + {&delim-par} +
          "RESULT=0" + {&delim-par} +
/*            "Density=" + string(  tt-rvs-line.density ) + {&delim-par} +*/
          "Temperature=" +  (if string(tt-rvs-line.state-temperature) = ? then '' else string(tt-rvs-line.state-temperature)) + {&delim-par} +
          
          "StateDensity="        +  (if string(tt-rvs-line.state-density) = ? then '' else string(tt-rvs-line.state-density)) + {&delim-par} +
          
          "StateMeasureQnty="    +  (if string( tt-rvs-line.state-measure-qnty) = ? then '' else string( tt-rvs-line.state-measure-qnty)) + {&delim-par} +
          "StateBruttoQnty="  +  (if string(  tt-rvs-line.state-brutto-qnty) = ? then '' else string(  tt-rvs-line.state-brutto-qnty)) + {&delim-par} +

          "StateMeasureCliQnty=" +  (if string(  tt-rvs-line.state-measure-cli-qnty) = ? then '' else string(  tt-rvs-line.state-measure-cli-qnty)) + {&delim-par} +

          "StateBruttoCliQnty=" +  (if string(  tt-rvs-line.state-brutto-cli-qnty) = ? then '' else string(   tt-rvs-line.state-brutto-cli-qnty)) + {&delim-par} +

          "StateLevelTotal="  +  (if string(  tt-rvs-line.state-level-total) = ? then '' else string(  tt-rvs-line.state-level-total)) + {&delim-par} +
          "StateLevelPetrol=" +  (if string(  tt-rvs-line.state-level-petrol) = ? then '' else string( tt-rvs-line.state-level-petrol)) + {&delim-par} +

          "StateLevelWater=" +  (if string(  tt-rvs-line.state-level-water) = ? then '' else string(  tt-rvs-line.state-level-water)) + {&delim-par} +
          
          "StateMeasureTcQnty="  +  (if string(  tt-rvs-line.state-measure-tc-qnty  ) = ? then '' else string(   tt-rvs-line.state-measure-tc-qnty  )) + {&delim-par} + 
          "StateBruttoTcQnty="  +  (if string(  tt-rvs-line.state-brutto-tc-qnty  ) = ? then '' else string(    tt-rvs-line.state-brutto-tc-qnty  )) + {&delim-par} + 
                      
          "Description=".
            
    run trg/userlog.p (
        input {&nwsdochs_action_create}
        , input {&table_rvs-doc}
        , input ( buffer buf_rvs-doc:handle )
        , input v-vid-action
        , input v-vid-param
        ) no-error.
    if error-status :error
        then
    do:
             message substitute( "&2&1Ошибка при записи истории пользователя&1&3&1&4"
              , {&new-line}
              , vss-workfile
              , return-value
              , error-status :get-message ( 1 ) ) 
              view-as alert-box.
          return no-apply.
    end.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-rvs-line.state-add-qnty
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-add-qnty Dialog-Frame
ON LEAVE OF tt-rvs-line.state-add-qnty IN FRAME Dialog-Frame /* Факт в трубопроводе */
DO:
  assign frame {&frame-name} {&self-name}.
  assign tt-rvs-line.fact-sum-vol = tt-rvs-line.fact-calc-vol + tt-rvs-line.state-add-qnty .
  display tt-rvs-line.fact-sum-vol with frame {&frame-name} .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-add-qnty Dialog-Frame
ON return OF tt-rvs-line.state-add-qnty IN FRAME Dialog-Frame /* Факт в трубопроводе */
DO:
  apply "entry" to tt-rvs-line.state-brutto-qnty in frame {&frame-name}.
  return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-rvs-line.state-brutto-cli-qnty
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-brutto-cli-qnty Dialog-Frame
ON LEAVE OF tt-rvs-line.state-brutto-cli-qnty IN FRAME Dialog-Frame /* Факт брутто вес */
DO:
if input frame {&frame-name} {&self-name} <> {&self-name} then do:
  run weath-water no-error.
  if error-status:error then return no-apply.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-brutto-cli-qnty Dialog-Frame
ON return OF tt-rvs-line.state-brutto-cli-qnty IN FRAME Dialog-Frame /* Факт брутто вес */
DO:
  apply "entry" to tt-rvs-line.state-level-petrol in frame {&frame-name}.
  return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-rvs-line.state-brutto-qnty
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-brutto-qnty Dialog-Frame
ON LEAVE OF tt-rvs-line.state-brutto-qnty IN FRAME Dialog-Frame /* Факт брутто */
DO:
if input frame {&frame-name} {&self-name} <> {&self-name} then do:
  run volume-water no-error.
  if error-status:error then return no-apply.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-brutto-qnty Dialog-Frame
ON return OF tt-rvs-line.state-brutto-qnty IN FRAME Dialog-Frame /* Факт брутто */
DO:
  apply "entry" to tt-rvs-line.state-measure-tc-qnty in frame {&frame-name}.
  return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-rvs-line.state-brutto-tc-qnty
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-brutto-tc-qnty Dialog-Frame
ON LEAVE OF tt-rvs-line.state-brutto-tc-qnty IN FRAME Dialog-Frame /* Факт брутто(tc) */
DO:
  assign frame {&frame-name} tt-rvs-line.state-brutto-tc-qnty.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-brutto-tc-qnty Dialog-Frame  */
/*ON return OF tt-rvs-line.state-brutto-tc-qnty IN FRAME Dialog-Frame /* Факт брутто(tc) */*/
/*DO:                                                                                      */
/*  apply "entry" to tt-rvs-line.state-brutto-cli-qnty in frame {&frame-name}.             */
/*  return no-apply.                                                                       */
/*END.                                                                                     */
/*                                                                                         */
/*/* _UIB-CODE-BLOCK-END */                                                                */
/*&ANALYZE-RESUME                                                                          */


&Scoped-define SELF-NAME tt-rvs-line.state-density
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-density Dialog-Frame
ON LEAVE OF tt-rvs-line.state-density IN FRAME Dialog-Frame /* Плотность */
DO:
  if input frame {&frame-name} {&self-name} <> {&self-name} then do:
     run chg-density no-error.
     if error-status:error then return no-apply.
     run weath-water no-error.
     if error-status:error then return no-apply.
     if tarir-value = 'yes'
     then do :
       run local-tarir("state-level-total") .
     end.
     assign v-hand-input = true .
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME varstate-water-qnty
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL varstate-water-qnty Dialog-Frame
ON LEAVE OF varstate-water-qnty IN FRAME Dialog-Frame /* Плотность */
DO:
  if input frame {&frame-name} {&self-name} <> {&self-name} then do:
     assign varstate-sum-vol = input frame {&frame-name} tt-rvs-line.fact-calc-vol + input frame {&frame-name} {&self-name} .
     display varstate-sum-vol with frame {&frame-name}.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-rvs-line.fact-calc-vol
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.fact-calc-vol Dialog-Frame
ON LEAVE OF tt-rvs-line.fact-calc-vol IN FRAME Dialog-Frame /* Плотность */
DO:
  if input frame {&frame-name} {&self-name} <> {&self-name} then do:
     tt-rvs-line.state-measure-qnty = input frame {&frame-name} {&self-name} .
     tt-rvs-line.fact-sum-vol = input frame {&frame-name} {&self-name} + input frame {&frame-name} tt-rvs-line.state-add-qnty .
     varstate-sum-vol = input frame {&frame-name} {&self-name} + (if input frame {&frame-name} varstate-water-qnty = ? then 0 else input frame {&frame-name} varstate-water-qnty) .
     display tt-rvs-line.fact-sum-vol varstate-sum-vol with frame {&frame-name}.
     run volume-water no-error.
     if error-status:error then return no-apply.
     if tt-rvs-line.state-density <> 0 and
        tt-rvs-line.state-density <> ? then do:
        run chg-density no-error.
        if error-status:error then return no-apply.
        run weath-water no-error.
        if error-status:error then return no-apply.
     end.
     tt-rvs-line.fact-sum-mass = tt-rvs-line.fact-calc-add-mass + tt-rvs-line.state-measure-cli-qnty .
     abs-delta-mass-add-qnty = tt-rvs-line.fact-calc-add-mass * pl-error-mass / 100 no-error .
     display tt-rvs-line.fact-sum-mass abs-delta-mass-add-qnty with frame {&frame-name}.
     assign tt-rvs-line.fact-calc-vol .
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-density Dialog-Frame
ON return OF tt-rvs-line.state-density IN FRAME Dialog-Frame /* Плотность */
DO:
  apply "entry" to tt-rvs-line.state-add-qnty in frame {&frame-name}.
  return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME tt-rvs-line.izmer-density
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.izmer-density Dialog-Frame
ON LEAVE OF tt-rvs-line.izmer-density IN FRAME Dialog-Frame /* Плотность */
DO:
  if input frame {&frame-name} {&self-name} <> {&self-name} then do:
    if input frame {&frame-name} tt-rvs-line.izmer-density = ?
      or ( buf_goods.unit-base <> buf_goods.unit-cli
          and ( input frame {&frame-name} tt-rvs-line.izmer-density < 0
                or input frame {&frame-name} tt-rvs-line.izmer-density >= 1
              )
        )
      or ( buf_goods.unit-base = buf_goods.unit-cli
          and input frame {&frame-name} tt-rvs-line.izmer-density <> 1
        )
    then do:
      message "Неверно определена плотность топлива измер. для ПО МИ." view-as alert-box error.
      apply "entry" to tt-rvs-line.izmer-density .
      return no-apply.
    end.

    assign frame {&frame-name} tt-rvs-line.izmer-density.
    
    assign v-hand-input = true .
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/*&Scoped-define SELF-NAME tt-rvs-line.izmer-density                              */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.izmer-density Dialog-Frame*/
/*ON RETURN OF tt-rvs-line.izmer-density IN FRAME Dialog-Frame /* Плотность */    */
/*DO:                                                                             */
/*  apply "entry" to tt-rvs-line.state-level-petrol in frame {&frame-name}.       */
/*  return no-apply.                                                              */
/*END.                                                                            */
/*                                                                                */
/*/* _UIB-CODE-BLOCK-END */                                                       */
/*&ANALYZE-RESUME                                                                 */




&Scoped-define SELF-NAME tt-rvs-line.state-level-water
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-level-water Dialog-Frame
ON LEAVE OF tt-rvs-line.state-level-water IN FRAME Dialog-Frame /* Факт уровень топлива */
DO:
  if input frame {&frame-name} {&self-name} <> {&self-name} then do:
          run level-water in this-procedure ( input no ) /* no-error */ .
      
    RUN local-tarir ("state-level-total").
    /* if error-status :error then do: return no-apply. end. */
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-level-petrol Dialog-Frame
ON return OF tt-rvs-line.state-level-petrol IN FRAME Dialog-Frame /* Факт уровень топлива */
DO:
  apply "entry" to tt-rvs-line.state-level-total in frame {&frame-name}.
  return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-rvs-line.state-level-total
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-level-total Dialog-Frame
ON LEAVE OF tt-rvs-line.state-level-total IN FRAME Dialog-Frame /* Факт общий уровень */
DO:
  if input frame {&frame-name} tt-rvs-line.state-level-total <> ?
  and input frame {&frame-name} tt-rvs-line.state-level-total > 0
  then do :
    if pl-rvd-temp
    and rdc-value = "pomi-rn"
    then do :
      enable b-temperature with frame {&frame-name}. 
    end .
    if pl-rvd-dens
    and rdc-value = "pomi-rn"
    then do :
      enable b-density with frame {&frame-name}. 
    end .
  end .
  else do :
    disable b-temperature with frame {&frame-name} .
    disable b-density with frame {&frame-name} .
  end .
  if input frame {&frame-name} {&self-name} <> {&self-name} then do:
    empty temp-table tt-temps .
    empty temp-table tt-dens .
    empty temp-table tt-dens-temp .
    run level-water in this-procedure ( input no ) /* no-error */ .
      
    RUN local-tarir ("state-level-total").
    /* if error-status :error then do: return no-apply. end. */
  end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-level-total Dialog-Frame
ON return OF tt-rvs-line.state-level-total IN FRAME Dialog-Frame /* Факт общий уровень */
DO:
/*  apply "entry" to tt-rvs-line.state-temperature in frame {&frame-name}.*/
  return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/*&Scoped-define SELF-NAME tt-rvs-line.state-measure-cli-qnty                              */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-measure-cli-qnty Dialog-Frame*/
/*ON return OF tt-rvs-line.state-measure-cli-qnty IN FRAME Dialog-Frame /* Факт вес */     */
/*DO:                                                                                      */
/*  apply "entry" to tt-rvs-line.state-brutto-cli-qnty in frame {&frame-name}.             */
/*  return no-apply.                                                                       */
/*END.                                                                                     */
/*                                                                                         */
/*/* _UIB-CODE-BLOCK-END */                                                                */
/*&ANALYZE-RESUME                                                                          */


&Scoped-define SELF-NAME tt-rvs-line.state-measure-qnty
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-measure-qnty Dialog-Frame
ON LEAVE OF tt-rvs-line.state-measure-qnty IN FRAME Dialog-Frame /* Факт остаток */
DO:
  if input frame {&frame-name} {&self-name} <> {&self-name} then do:
     run volume-water no-error.
     if error-status:error then return no-apply.
     if tt-rvs-line.state-density <> 0 and
        tt-rvs-line.state-density <> ? then do:
        run chg-density no-error.
        if error-status:error then return no-apply.
        run weath-water no-error.
        if error-status:error then return no-apply.
     end.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-measure-qnty Dialog-Frame
ON return OF tt-rvs-line.state-measure-qnty IN FRAME Dialog-Frame /* Факт остаток */
DO:
  apply "entry" to tt-rvs-line.state-measure-tc-qnty in frame {&frame-name}.
  return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-rvs-line.state-measure-tc-qnty
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-measure-tc-qnty Dialog-Frame
ON LEAVE OF tt-rvs-line.state-measure-tc-qnty IN FRAME Dialog-Frame /* Факт остаток(tc) */
DO:
  assign frame {&frame-name} tt-rvs-line.state-measure-tc-qnty.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-measure-tc-qnty Dialog-Frame
ON return OF tt-rvs-line.state-measure-tc-qnty IN FRAME Dialog-Frame /* Факт остаток(tc) */
DO:
  apply "entry" to tt-rvs-line.state-density in frame {&frame-name}.
  return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/*
&Scoped-define SELF-NAME tt-rvs-line.state-temp-layer1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-temp-layer1 Dialog-Frame
ON LEAVE OF tt-rvs-line.state-temp-layer1 IN FRAME Dialog-Frame /* T1 */
DO:
    assign frame {&frame-name} {&self-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-temp-layer1 Dialog-Frame
ON return OF tt-rvs-line.state-temp-layer1 IN FRAME Dialog-Frame /* T1 */
DO:
  apply "entry" to tt-rvs-line.state-temp-layer2 in frame {&frame-name}.
  return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-rvs-line.state-temp-layer2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-temp-layer2 Dialog-Frame
ON LEAVE OF tt-rvs-line.state-temp-layer2 IN FRAME Dialog-Frame /* T2 */
DO:
    assign frame {&frame-name} {&self-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-temp-layer2 Dialog-Frame
ON return OF tt-rvs-line.state-temp-layer2 IN FRAME Dialog-Frame /* T2 */
DO:
  apply "entry" to tt-rvs-line.state-temp-layer3 in frame {&frame-name}.
  return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-rvs-line.state-temp-layer3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-temp-layer3 Dialog-Frame
ON LEAVE OF tt-rvs-line.state-temp-layer3 IN FRAME Dialog-Frame /* T3 */
DO:
    assign frame {&frame-name} {&self-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-temp-layer3 Dialog-Frame
ON return OF tt-rvs-line.state-temp-layer3 IN FRAME Dialog-Frame /* T3 */
DO:
  

    IF rdc-value = "pomi-rn" THEN do: 
/*    apply "entry" to mass-float-cov in frame {&frame-name}.*/
    return no-apply.
  end.
  else do :
    apply "entry" to b-save in frame {&frame-name}.
    return no-apply.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
*/
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mass-float-cov Dialog-Frame            */
/*ON return OF mass-float-cov IN FRAME Dialog-Frame /* масса плавающего покрытия */*/
/*DO:                                                                              */
/*  apply "entry" to b-calc in frame {&frame-name}.                                */
/*  return no-apply.                                                               */
/*END.                                                                             */
/*                                                                                 */
/*/* _UIB-CODE-BLOCK-END */                                                        */
/*&ANALYZE-RESUME                                                                  */


&Scoped-define SELF-NAME tt-rvs-line.state-temperature
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-temperature Dialog-Frame
ON LEAVE OF tt-rvs-line.state-temperature IN FRAME Dialog-Frame /* Температура */
DO:
    assign frame {&frame-name} {&self-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-rvs-line.state-temperature Dialog-Frame
ON return OF tt-rvs-line.state-temperature IN FRAME Dialog-Frame /* Температура */
DO:
/*  apply "entry" to tt-rvs-line.state-temp-layer1 in frame {&frame-name}.*/
  return no-apply.
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
  { gbl/getcntxt.i get }

  if parmode = {&update} then do:
    find first buf_rvs-line exclusive-lock
      where recid(buf_rvs-line) = parrec-rvs-line
      no-error.
  end.
  else do:
    find first buf_rvs-line no-lock
      where recid(buf_rvs-line) = parrec-rvs-line
      no-error.
  end.
  if not available buf_rvs-line then do:
     message "Неверно переданы параметры."
             "Не найдена строка сверки с recid " parrec-rvs-line " ."
     view-as alert-box error.
     return error.
  end.
  create tt-rvs-line.
  buffer-copy buf_rvs-line to tt-rvs-line.

  find first buf_rvs-doc exclusive-lock
    where buf_rvs-doc.rvs-code = tt-rvs-line.rvs-code
    .
    
  RUN enable_UI IN THIS-PROCEDURE.

  if tt-rvs-line.system-qnty <> tt-rvs-line.orig-system-qnty
    and tt-rvs-line.system-cli-qnty <> tt-rvs-line.orig-system-cli-qnty
  then do:
    assign
      tt-rvs-line.orig-system-cli-qnty :label in frame Dialog-Frame = "":U
    .
  end.
  if tt-rvs-line.system-qnty <> tt-rvs-line.orig-system-qnty then do:
    display
      tt-rvs-line.orig-system-qnty
      with frame Dialog-Frame.
  end.
  else do:
    hide
      tt-rvs-line.orig-system-qnty
      in frame Dialog-Frame.
  end.
  if tt-rvs-line.system-cli-qnty <> tt-rvs-line.orig-system-cli-qnty then do:
    display
      tt-rvs-line.orig-system-cli-qnty
      with frame Dialog-Frame.
  end.
  else do:
    hide
      tt-rvs-line.orig-system-cli-qnty
      in frame Dialog-Frame.
  end.
  
  run placelib_get-attr  ( input {&place-rvd-dnsty}
                            ,input tt-rvs-line.obj-code
                            ,input tt-rvs-line.obj-type
                            ,input tt-rvs-line.pl-code
                            ,output v-value
                            ,output v-ok      ) no-error.
  if not v-ok then pl-rvd-dens = no.
  else pl-rvd-dens = logical(v-value) .
  
  run placelib_get-attr  ( input {&place-rvd-lvl}
                            ,input tt-rvs-line.obj-code
                            ,input tt-rvs-line.obj-type
                            ,input tt-rvs-line.pl-code
                            ,output v-value
                            ,output v-ok      ) no-error.
  if not v-ok then pl-rvd-lvl = no.
  else pl-rvd-lvl = logical(v-value) .
  
  run placelib_get-attr  ( input {&place-rvd-tmp}
                            ,input tt-rvs-line.obj-code
                            ,input tt-rvs-line.obj-type
                            ,input tt-rvs-line.pl-code
                            ,output v-value
                            ,output v-ok      ) no-error.
  if not v-ok then pl-rvd-temp = no.
  else pl-rvd-temp = logical(v-value) .

  if parmode <> {&update} then do:
     disable {&list-2} with frame {&frame-name}.
  end.
  else
    do:
      find first buf2_place no-lock where
                 buf2_place.obj-code = tt-rvs-line.obj-code and
                 buf2_place.obj-type = tt-rvs-line.obj-type and
                 buf2_place.pl-code  = tt-rvs-line.pl-code
      no-error.  
      case buf_rvs-doc.rvs-type:
        when {&rvs-before-doc} or when {&rvs-after-doc} then
        do: 
          if available buf2_place then
          do:
            if buf2_place.is-meas = yes then
            do:
              { gbl/chk-actg.i
                v-cntxt-db-num
                v-cntxt-userid
                {&action-head-code-main}
                'actn_rvs-on-doc_upd-revision':U
                {&cntxt-object}
                buf_rvs-doc.host-code
                buf_rvs-doc.obj-type
                buf_rvs-doc.obj-code
                0
                0
                0
                false
                g-log
               }
             end.
             else
             do:
               g-log = yes.
             end.
          end.
        end.
        when {&rvs-shift}
        then do:
            if available buf2_place then do :  
                if buf2_place.is-meas
                and not pl-rvd-dens
                and not pl-rvd-lvl
                and not pl-rvd-temp
                then do :
                  { gbl/chk-actg.i
                    v-cntxt-db-num
                    v-cntxt-userid
                    {&action-head-code-main}
                    'actn_rvs-shift_upd-revision':U
                    {&cntxt-object}
                    buf_rvs-doc.host-code
                    buf_rvs-doc.obj-type
                    buf_rvs-doc.obj-code
                    0
                    0
                    0
                    false
                    g-log
                  }
                end.
                else do :
                  { gbl/chk-actg.i
                    v-cntxt-db-num
                    v-cntxt-userid
                    {&action-head-code-main}
                    'actn_rvs-shift_upd-immeas':U
                    {&cntxt-object}
                    buf_rvs-doc.host-code
                    buf_rvs-doc.obj-type
                    buf_rvs-doc.obj-code
                    0
                    0
                    0
                    false
                    g-log
                  } 
                end. 
            end.        
        end.
        when {&rvs-control}
        then do:
            if available buf2_place then do :  
                if buf2_place.is-meas
                and not pl-rvd-dens
                and not pl-rvd-lvl
                and not pl-rvd-temp
                then do :
                  { gbl/chk-actg.i
                    v-cntxt-db-num
                    v-cntxt-userid
                    {&action-head-code-main}
                    'actn_rvs-control_upd-revision':U
                    {&cntxt-object}
                    buf_rvs-doc.host-code
                    buf_rvs-doc.obj-type
                    buf_rvs-doc.obj-code
                    0
                    0
                    0
                    false
                    g-log
                  }
                end.
                else do :
                  { gbl/chk-actg.i
                    v-cntxt-db-num
                    v-cntxt-userid
                    {&action-head-code-main}
                    'actn_rvs-control_upd-immeas':U
                    {&cntxt-object}
                    buf_rvs-doc.host-code
                    buf_rvs-doc.obj-type
                    buf_rvs-doc.obj-code
                    0
                    0
                    0
                    false
                    g-log
                  } 
                end.
            end.         
        end.
        otherwise do:
          message
            vss-workfile vss-revision vss-description skip
            "Неизвестный тип сверки" skip
            "Тип документа" buf_rvs-doc.rvs-type skip
            "Код документа" buf_rvs-doc.rvs-code skip
            view-as alert-box error .
          undo, return error return-value .
        end.
      end case .
     if not g-log then do:
        disable {&list-2} with frame {&frame-name}.
     end.
  end.
  if parmode <> {&update} then do:
    disable b-save with frame {&frame-name}.
  end.
  run volume-measure-water in this-procedure                 no-error.
  run weath-measure-water  in this-procedure                 no-error.
  run level-measure-water  in this-procedure                 no-error.
  run volume-water         in this-procedure                 no-error.
  run weath-water          in this-procedure                 no-error.
  run level-water          in this-procedure ( input no ) /* no-error */ .
  find first buf_goods no-lock
    where buf_goods.gds-code = tt-rvs-line.gds-code
    .
  if buf_goods.unit-base = buf_goods.unit-cli then do:
    assign
      tt-rvs-line.density       = 1.0
      tt-rvs-line.state-density = 1.0
    .
    disable
      tt-rvs-line.density
      tt-rvs-line.state-density
      with frame {&frame-name}.
  end.
  /*   Отключили определение параметра использования ПО к МИ, т.к. приведение плотности теперь работает только при приемки    
  run gbl/conf-rd.p ("pomi-lic", "", "", 0, "", "", "", no, output pomi-licvalue, output pomi-lictype) no-error.
  
  if error-status:error or
  */
      RUN gbl/conf-rd.p ("rdc-dnst", "", "", 0, "", "", "", NO, OUTPUT rdc-value, OUTPUT rdc-type) NO-ERROR.
      
      run gbl/conf-rd.p ("tarir", "", "", 0, "", "", "", no, output tarir-value, output tarir-type) no-error.
  hide
      tt-rvs-line.meas-calc-qnty
      tt-rvs-line.meas-calc-dens
      tt-rvs-line.meas-cli-calc-qnty
      /* ДОРАБОТКИ ПО ЛНД */
      tt-rvs-line.meas-am-qnty
      tt-rvs-line.meas-cf-qnty
      tt-rvs-line.meas-mh-qnty
      tt-rvs-line.level-petrol
      tt-rvs-line.state-level-petrol
      tt-rvs-line.brutto-cli-qnty
      tt-rvs-line.state-brutto-cli-qnty
      tt-rvs-line.meas-cli-calc-qnty
      varmeasure-water-cli-qnty
      varstate-water-cli-qnty
      tt-rvs-line.brutto-tc-qnty
      tt-rvs-line.state-brutto-tc-qnty
      tt-rvs-line.brutto-qnty
      tt-rvs-line.state-brutto-qnty
      tt-rvs-line.meas-calc-dens
      tt-rvs-line.measure-tc-qnty
      tt-rvs-line.state-measure-tc-qnty
      tt-rvs-line.measure-qnty
      tt-rvs-line.state-measure-qnty
      tt-rvs-line.meas-calc-qnty
      
      in frame Dialog-Frame.
  if rdc-value <>  "pomi-rn" then do :
    hide
/*      tt-rvs-line.meas-calc-qnty    */
/*      tt-rvs-line.meas-calc-dens    */
/*      tt-rvs-line.meas-cli-calc-qnty*/
      tt-rvs-line.izmer-density
/*      mass-float-cov*/
      delta-mass-qnty
      abs-delta-mass-qnty
      b-calc
      in frame Dialog-Frame.
/*                                                               */
/*      find first rvs-line-attr no-lock                         */
/*          where rvs-line-attr.obj-code  = tt-rvs-line.obj-code */
/*          and rvs-line-attr.obj-type  = tt-rvs-line.obj-type   */
/*          and rvs-line-attr.gds-code  = tt-rvs-line.gds-code   */
/*          and rvs-line-attr.pl-code   = tt-rvs-line.pl-code    */
/*          and rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code   */
/*          and rvs-line-attr.attr-code = "delta-mass-qnty"      */
/*          no-error.                                            */
/*      if available rvs-line-attr then                          */
/*      do:                                                      */
/*          delta-mass-qnty = decimal(rvs-line-attr.attr-value) .*/
/*      end.                                                     */
/*                                                               */
/*      display                                                  */
/*       delta-mass-qnty                                         */
/*    with frame {&frame-name}.                                  */
      
  end.
  else  do :
    view
      tt-rvs-line.izmer-density
    in frame Dialog-Frame.
    enable   
      tt-rvs-line.izmer-density
    with frame Dialog-Frame.
    disable
      tt-rvs-line.state-density
      tt-rvs-line.state-measure-qnty
      tt-rvs-line.state-add-qnty
      tt-rvs-line.state-brutto-qnty
      tt-rvs-line.state-brutto-cli-qnty
    with frame Dialog-Frame.
    end.

    for each rvs-line-attr no-lock
       where rvs-line-attr.obj-code  = tt-rvs-line.obj-code
         and rvs-line-attr.obj-type  = tt-rvs-line.obj-type
         and rvs-line-attr.gds-code  = tt-rvs-line.gds-code
         and rvs-line-attr.pl-code   = tt-rvs-line.pl-code
         and rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
         :
          case rvs-line-attr.attr-code :
            when "meas-calc-qnty" then do :
              tt-rvs-line.meas-calc-qnty = decimal(rvs-line-attr.attr-value) .
            end.
            when "meas-calc-dens" then do :
              tt-rvs-line.meas-calc-dens = decimal(rvs-line-attr.attr-value) .
            end.
            when "meas-cli-calc-qnty" then do :
              tt-rvs-line.meas-cli-calc-qnty = decimal(rvs-line-attr.attr-value) .
            end.
            when "izmer-density" then do :
              tt-rvs-line.izmer-density = decimal(rvs-line-attr.attr-value) .
            end.
            when "temp-izm-vol" then do :
              tt-rvs-line.temp-izm-vol = decimal(rvs-line-attr.attr-value) .
            end.
/*            when "mass-float-cov" then do :                       */
/*              mass-float-cov = decimal(rvs-line-attr.attr-value) .*/
/*            end.                                                  */
            when "delta-mass-qnty" then do :
              delta-mass-qnty = decimal(rvs-line-attr.attr-value) .
            end.
            when "CriticalDif" then do :
              CriticalDif = decimal(rvs-line-attr.attr-value) .
            end.
          end case.
    end.
    release rvs-line-attr no-error .
    if rdc-value =  "pomi-rn" then do :
    display
      tt-rvs-line.izmer-density
      delta-mass-qnty
    with frame {&frame-name}.
    end.
    display
      CriticalDif

    with frame {&frame-name}.
    run placelib_get-attr  ( input {&place-type}
                            ,input tt-rvs-line.obj-code
                            ,input tt-rvs-line.obj-type
                            ,input tt-rvs-line.pl-code
                            ,output v-value
                            ,output v-ok      ) no-error.
/*    if v-ok then do :              */
/*      if integer(v-value) <> 1 then*/
/*      hide                         */
/*        mass-float-cov             */
/*      in frame {&frame-name}.      */
/*    end.                           */
  
  run placelib_get-attr  ( input {&place-asi-sertif}
                            ,input tt-rvs-line.obj-code
                            ,input tt-rvs-line.obj-type
                            ,input tt-rvs-line.pl-code
                            ,output v-value
                            ,output v-ok      ) no-error.
  if not v-ok
  then pl-asi-sertif = no.
  else
  if v-value > ""
  then pl-asi-sertif = logical(v-value) .
  else pl-asi-sertif = no.
  
  
  run placelib_get-attr  ( input {&place-diameter}
                          ,input tt-rvs-line.obj-code
                          ,input tt-rvs-line.obj-type
                          ,input tt-rvs-line.pl-code
                          ,output v-value
                          ,output v-ok      ) no-error.
  if v-ok
  then place-diameter = decimal(v-value) .
  else place-diameter = ? . 
  
  run placelib_get-attr  ( input {&place-SI}
                          ,input tt-rvs-line.obj-code
                          ,input tt-rvs-line.obj-type
                          ,input tt-rvs-line.pl-code
                          ,output v-value
                          ,output v-ok      ) no-error.
  if v-ok
  then place-si = integer(v-value) .
  else place-si = ? .
  
  run placelib_get-attr  ( input {&place-SI-temp}
                          ,input tt-rvs-line.obj-code
                          ,input tt-rvs-line.obj-type
                          ,input tt-rvs-line.pl-code
                          ,output v-value
                          ,output v-ok      ) no-error.
  if v-ok
  then pl-temp-sr-izm = integer(v-value) .
  else pl-temp-sr-izm = ? .
  
  run placelib_get-attr  ( input {&place-SI-dens}
                          ,input tt-rvs-line.obj-code
                          ,input tt-rvs-line.obj-type
                          ,input tt-rvs-line.pl-code
                          ,output v-value
                          ,output v-ok      ) no-error.
  if v-ok
  then pl-dens-sr-izm = integer(v-value) .
  else pl-dens-sr-izm = ? .
  
  run placelib_get-attr  ( input {&place-SI-level}
                          ,input tt-rvs-line.obj-code
                          ,input tt-rvs-line.obj-type
                          ,input tt-rvs-line.pl-code
                          ,output v-value
                          ,output v-ok      ) no-error.
  if v-ok
  then pl-level-sr-izm = integer(v-value) .
  else pl-level-sr-izm = ? .
  
  run placelib_get-attr  ( input {&place-error-mass}
                            ,input tt-rvs-line.obj-code
                            ,input tt-rvs-line.obj-type
                            ,input tt-rvs-line.pl-code
                            ,output v-value
                            ,output v-ok      ) no-error.
  if not v-ok then pl-error-mass = ?.
  else pl-error-mass = decimal(v-value) .
  
  assign tt-rvs-line.calc-add-mass = tt-rvs-line.add-qnty * input frame {&frame-name} tt-rvs-line.density .
  assign tt-rvs-line.calc-vol = tt-rvs-line.measure-qnty .
  assign tt-rvs-line.sum-vol = tt-rvs-line.calc-vol + tt-rvs-line.add-qnty .
  assign tt-rvs-line.sum-mass = tt-rvs-line.calc-add-mass + tt-rvs-line.measure-cli-qnty .
  assign varsum-vol = input frame {&frame-name} varmeasure-water-qnty + tt-rvs-line.calc-vol .
  
  assign
    tt-rvs-line.fact-calc-add-mass = tt-rvs-line.state-add-qnty * input frame {&frame-name} tt-rvs-line.state-density 
    tt-rvs-line.fact-calc-vol = tt-rvs-line.state-measure-qnty 
    tt-rvs-line.fact-sum-vol = tt-rvs-line.fact-calc-vol + tt-rvs-line.state-add-qnty 
    tt-rvs-line.fact-sum-mass = tt-rvs-line.fact-calc-add-mass + tt-rvs-line.state-measure-cli-qnty 
    varstate-sum-vol = input frame {&frame-name} varstate-water-qnty + tt-rvs-line.fact-calc-vol 
  .
  
  if tt-rvs-line.state-measure-qnty = ? then tt-rvs-line.state-measure-qnty = tt-rvs-line.fact-calc-vol .
  if tt-rvs-line.state-measure-qnty = ? then tt-rvs-line.state-measure-qnty = tt-rvs-line.fact-calc-vol .
  
  abs-delta-mass-add-qnty = tt-rvs-line.fact-calc-add-mass * pl-error-mass / 100 .
  abs-delta-mass-qnty = tt-rvs-line.state-measure-cli-qnty * delta-mass-qnty / 100 .
  
  display
    tt-rvs-line.calc-add-mass
    tt-rvs-line.calc-vol
    tt-rvs-line.sum-vol
    tt-rvs-line.sum-mass
    varsum-vol
    
    tt-rvs-line.fact-calc-add-mass
    tt-rvs-line.fact-calc-vol
    tt-rvs-line.fact-sum-vol
    tt-rvs-line.fact-sum-mass
    varstate-sum-vol
    
    abs-delta-mass-add-qnty
    
    tt-rvs-line.temp-izm-vol
  with frame {&frame-name}.
  
  if rdc-value = 'pomi-rn'
  then do :
    display
      abs-delta-mass-qnty
    with frame {&frame-name}.
  end.
  else
  if tt-rvs-line.density = ? and parmode = {&update} and tarir-value <> "yes"
  then do :
    enable
      tt-rvs-line.fact-calc-vol
      varstate-water-qnty
    with frame Dialog-Frame.
  end.
                           
  if parmode <> {&update} then do:
     disable tt-rvs-line.izmer-density with frame {&frame-name}.
     disable tt-rvs-line.temp-izm-vol with frame {&frame-name}.
/*     disable mass-float-cov with frame {&frame-name}.*/
     disable b-calc with frame {&frame-name}.
  end.
  else do :
    disable
      tt-rvs-line.izmer-density
      tt-rvs-line.state-temperature
      tt-rvs-line.state-density
    with frame {&frame-name}.
    if pl-rvd-dens and rdc-value = 'pomi-rn'
    and tt-rvs-line.state-level-total > 0
    then do :
      enable b-density with frame {&frame-name}.
    end.
    else do :
      disable b-density with frame {&frame-name}.
    end.
    if pl-rvd-dens and rdc-value <> 'pomi-rn'
    and tt-rvs-line.state-level-total > 0
    then do :
      enable tt-rvs-line.state-density with frame {&frame-name}.
    end.
    else do :
      disable tt-rvs-line.state-density with frame {&frame-name}.
    end.
    if pl-rvd-lvl
    then do :
      enable tt-rvs-line.state-level-total tt-rvs-line.state-level-water with frame {&frame-name}.
    end.
    else do :
      disable tt-rvs-line.state-level-total tt-rvs-line.state-level-water with frame {&frame-name}.
    end.
    if (pl-rvd-temp or tt-rvs-line.density = ?)
    and tt-rvs-line.state-level-total > 0
    then do :
      enable b-temperature with frame {&frame-name}.
    end.
    else do :
      disable b-temperature with frame {&frame-name}.
    end.
  end.
  
  find first rvs-line-attr no-lock
        where rvs-line-attr.obj-code  = tt-rvs-line.obj-code
          and rvs-line-attr.obj-type  = tt-rvs-line.obj-type
          and rvs-line-attr.gds-code  = tt-rvs-line.gds-code
          and rvs-line-attr.pl-code   = tt-rvs-line.pl-code
          and rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
          and rvs-line-attr.attr-code = "POkMI-result" no-error.
  if available rvs-line-attr then do :
    v-POkMI-result-attr = rvs-line-attr.attr-value .
    enable
      b-POkMI-result
    with frame Dialog-Frame.
  end.
  else do :
    disable
      b-POkMI-result
    with frame Dialog-Frame.
  end.
  
  if rdc-value <> 'pomi-rn'
  then do :
    hide
      b-temperature
      b-density
      tt-rvs-line.temp-izm-vol
      b-POkMI-result
    in frame Dialog-Frame.
    if parmode = {&update}
    then do :
      enable 
        tt-rvs-line.state-density
        tt-rvs-line.state-temperature
        tt-rvs-line.state-measure-cli-qnty
      with frame {&frame-name}.
    end .
  end .
  
  
  define variable sr-type-temp as integer no-undo .
  define variable sr-type-dens as integer no-undo .
  define variable v-izm-temps-attr as character no-undo .
  define variable v-izm-denses-attr as character no-undo .
  define variable it as integer no-undo .
  define variable id as integer no-undo .
  define variable ikey as integer no-undo .
  
  find first rvs-line-attr no-lock
           where rvs-line-attr.obj-code  = tt-rvs-line.obj-code
             and rvs-line-attr.obj-type  = tt-rvs-line.obj-type
             and rvs-line-attr.gds-code  = tt-rvs-line.gds-code
             and rvs-line-attr.pl-code   = tt-rvs-line.pl-code
             and rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
             and rvs-line-attr.attr-code = "izm-temps" no-error.
  if available rvs-line-attr then do :
    sr-type-temp = integer(entry(1, rvs-line-attr.attr-value, ";")) no-error .
    v-izm-temps-attr = entry(2, rvs-line-attr.attr-value, ";") no-error .
  end .  
  
  find first rvs-line-attr no-lock
           where rvs-line-attr.obj-code  = tt-rvs-line.obj-code
             and rvs-line-attr.obj-type  = tt-rvs-line.obj-type
             and rvs-line-attr.gds-code  = tt-rvs-line.gds-code
             and rvs-line-attr.pl-code   = tt-rvs-line.pl-code
             and rvs-line-attr.rvs-code  = tt-rvs-line.rvs-code
             and rvs-line-attr.attr-code = "izm-denses" no-error.
  if available rvs-line-attr then do :
    sr-type-dens = integer(entry(1, rvs-line-attr.attr-value, ";")) no-error .
    v-izm-denses-attr = entry(2, rvs-line-attr.attr-value, ";") no-error .
  end .         
  
  case sr-type-temp :
    when 2
    then do :
      ikey = num-entries(v-izm-temps-attr) .
      do it = 1 to num-entries(v-izm-temps-attr) :
        find first tt-temps no-lock where tt-temps.ii = ikey no-error .
        if not available tt-temps
        then do :
          create tt-temps .
          assign
            tt-temps.ii = ikey
            tt-temps.key_ = "t" + string(ikey)
            tt-temps.temperature = decimal(entry(it, v-izm-temps-attr))
          .
        end .
        ikey = ikey - 1 .
      end .
    end .
    when 3
    then do :
      do it = 1 to num-entries(v-izm-temps-attr) :
        find first tt-temps no-lock where tt-temps.ii = it no-error .
        if not available tt-temps
        then do :
          create tt-temps .
          assign
            tt-temps.ii = it
            tt-temps.temperature = decimal(entry(it, v-izm-temps-attr))
          .
          case it :
            when 1 then tt-temps.key_ = "tн" .
            when 2 then tt-temps.key_ = "tср" .
            when 3 then tt-temps.key_ = "tв" .
          end case .
        end .
      end .
    end .
  end case . 
  
  case sr-type-dens :
    when 2
    then do :
      ikey = num-entries(v-izm-denses-attr) .
      do id = 1 to num-entries(v-izm-denses-attr) :
        find first tt-dens no-lock where tt-dens.ii = ikey no-error .
        if not available tt-dens
        then do :
          create tt-dens .
          assign
            tt-dens.ii = ikey
            tt-dens.key_ = "P" + string(ikey)
            tt-dens.density = decimal(entry(id, v-izm-denses-attr))
          .
        end .
        ikey = ikey - 1 .
      end .
    end .
    when 3
    then do :
      do id = 1 to num-entries(v-izm-denses-attr) :
        find first tt-dens-temp no-lock where tt-dens-temp.ii = id no-error .
        if not available tt-dens-temp
        then do :
          create tt-dens-temp .
          assign
            tt-dens-temp.ii = id
            tt-dens-temp.density = decimal(entry(id, v-izm-denses-attr))
          .
          tt-dens-temp.temperature = decimal(entry(id, v-izm-temps-attr)) no-error .
          case id :
            when 1 then tt-dens-temp.key_ = "Pн" .
            when 2 then tt-dens-temp.key_ = "Pср" .
            when 3 then tt-dens-temp.key_ = "Pв" .
          end case .
        end .
      end .
    end .
  end case .
        
  assign frame {&frame-name} :title = frame {&frame-name} :title + " - " + parmode
                                    + " - " +  partitle.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.
return v-return-val .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chg-density Dialog-Frame 
PROCEDURE chg-density :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
if input frame {&frame-name} tt-rvs-line.state-density = ?
  or ( buf_goods.unit-base <> buf_goods.unit-cli
       and ( input frame {&frame-name} tt-rvs-line.state-density <= 0
             or input frame {&frame-name} tt-rvs-line.state-density >= 1
           )
     )
  or ( buf_goods.unit-base = buf_goods.unit-cli
       and input frame {&frame-name} tt-rvs-line.state-density <> 1
     )
then do:
   message "Неверно определена плотность топлива." skip buf_goods.unit-base skip buf_goods.unit-cli skip tt-rvs-line.state-density view-as alert-box error.
   return error.
end.

run gds-attr-value in this-procedure
  ( input  buf_goods.gds-code
  ,input  {&attr-gds-ptrl-densities}
  ,output v-gds-ptrl-densities
  ,output v-attr-type
  ) .
  if v-gds-ptrl-densities <> "" and v-gds-ptrl-densities <> ? then do:
    assign
      v-min-dens = decimal(replace(entry(1, v-gds-ptrl-densities, "-":U ), "кг\л", "":U))
      v-max-dens = decimal(replace(entry(2, v-gds-ptrl-densities, "-":U ), "кг\л":U, "":U))
    no-error .
    if (input frame {&frame-name} tt-rvs-line.state-density) < v-min-dens
    or (input frame {&frame-name} tt-rvs-line.state-density) > v-max-dens
    then do:
      message
        substitute("Введенное значение плотности находится вне заданного диапазона: &1.",
        v-gds-ptrl-densities )
        view-as alert-box error .
      return error.
    end.
  end.

assign frame {&frame-name} tt-rvs-line.state-density.

assign
  tt-rvs-line.state-measure-cli-qnty = tt-rvs-line.state-measure-qnty * tt-rvs-line.state-density
  tt-rvs-line.state-brutto-cli-qnty = tt-rvs-line.state-measure-cli-qnty + varstate-water-qnty
  tt-rvs-line.fact-calc-add-mass = tt-rvs-line.state-add-qnty  * tt-rvs-line.state-density
.
abs-delta-mass-add-qnty = tt-rvs-line.fact-calc-add-mass * pl-error-mass / 100 no-error .
display tt-rvs-line.state-measure-cli-qnty tt-rvs-line.fact-calc-add-mass with frame {&frame-name}.
/*display tt-rvs-line.state-brutto-cli-qnty with frame {&frame-name}.*/
/*if tt-rvs-line.state-measure-cli-qnty > tt-rvs-line.state-brutto-cli-qnty then do:    */
/*  message "Измеренный вес больше веса брутто. Подставить измеренный вес в вес брутто?"*/
/*  view-as alert-box question buttons yes-no update varlog.                            */
/*  if varlog = yes then do:                                                            */
/*    assign                                                                            */
/*      tt-rvs-line.state-brutto-cli-qnty = tt-rvs-line.state-measure-cli-qnty.         */
/*    display tt-rvs-line.state-brutto-cli-qnty with frame {&frame-name}.               */
/*  end.                                                                                */
/*end.                                                                                  */

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

  {&OPEN-QUERY-Dialog-Frame}
  GET FIRST Dialog-Frame.
  DISPLAY varmeasure-water-qnty varstate-water-qnty varmeasure-water-cli-qnty 
          varstate-water-cli-qnty delta-mass-qnty varstate-sum-vol varsum-vol /*mass-float-cov */
      WITH FRAME Dialog-Frame.
  IF AVAILABLE tt-rvs-line THEN
    DISPLAY tt-rvs-line.system-qnty tt-rvs-line.system-cli-qnty
          tt-rvs-line.orig-system-qnty tt-rvs-line.orig-system-cli-qnty
          tt-rvs-line.measure-qnty tt-rvs-line.state-measure-qnty
          tt-rvs-line.meas-calc-qnty tt-rvs-line.measure-tc-qnty tt-rvs-line.state-measure-tc-qnty
          tt-rvs-line.density tt-rvs-line.state-density
          tt-rvs-line.meas-calc-dens tt-rvs-line.izmer-density
          tt-rvs-line.add-qnty tt-rvs-line.state-add-qnty
          tt-rvs-line.brutto-qnty tt-rvs-line.state-brutto-qnty
          tt-rvs-line.brutto-tc-qnty tt-rvs-line.state-brutto-tc-qnty
          tt-rvs-line.measure-cli-qnty tt-rvs-line.state-measure-cli-qnty
          tt-rvs-line.meas-cli-calc-qnty tt-rvs-line.temp-izm-vol
          tt-rvs-line.brutto-cli-qnty tt-rvs-line.state-brutto-cli-qnty
          tt-rvs-line.level-petrol tt-rvs-line.state-level-petrol
          tt-rvs-line.level-total tt-rvs-line.state-level-total
          tt-rvs-line.level-water tt-rvs-line.state-level-water
          tt-rvs-line.temperature tt-rvs-line.state-temperature
          tt-rvs-line.meas-mh-qnty tt-rvs-line.state-mh-qnty
          tt-rvs-line.meas-am-qnty tt-rvs-line.state-am-qnty
          tt-rvs-line.meas-cf-qnty tt-rvs-line.state-cf-qnty
      WITH FRAME Dialog-Frame.
  ENABLE b-save b-cancel b-help RECT-2 RECT-3 tt-rvs-line.state-measure-qnty
         tt-rvs-line.state-density b-calc tt-rvs-line.state-add-qnty
         tt-rvs-line.state-brutto-qnty tt-rvs-line.state-brutto-cli-qnty
         tt-rvs-line.state-level-petrol tt-rvs-line.state-level-total
         tt-rvs-line.state-temperature
/*         mass-float-cov*/
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE level-measure-water Dialog-Frame 
PROCEDURE level-measure-water :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
display input frame {&frame-name} tt-rvs-line.level-total -
        input frame {&frame-name} tt-rvs-line.level-petrol @
        tt-rvs-line.level-water with frame {&frame-name}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE level-water Dialog-Frame 
PROCEDURE level-water :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  define input parameter p-mode as logical no-undo.

  define variable is_OK as logical no-undo initial yes.

/*  if input frame {&frame-name} tt-rvs-line.state-level-petrol >                        */
/*     input frame {&frame-name} tt-rvs-line.state-level-total  then do:                 */
/*    assign is_OK = no.                                                                 */
/*    if p-mode = yes then do:                                                           */
/*      message "Уровень топлива больше значения общего уровня." view-as alert-box error.*/
/*      return error.                                                                    */
/*    end.                                                                               */
/*  end.                                                                                 */
  tt-rvs-line.state-level-petrol = input frame {&frame-name} tt-rvs-line.state-level-total - input frame {&frame-name} tt-rvs-line.state-level-water .
/*  display input frame {&frame-name} tt-rvs-line.state-level-total  -*/
/*          input frame {&frame-name} tt-rvs-line.state-level-petrol @*/
/*                                    tt-rvs-line.state-level-water   */
/*  with frame {&frame-name}.                                         */
  if is_OK = yes then do:
    assign frame {&frame-name} tt-rvs-line.state-level-water
                               tt-rvs-line.state-level-petrol
                               tt-rvs-line.state-level-total.
  end.
END PROCEDURE. /* level-water */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-tarir Dialog-Frame 
PROCEDURE local-tarir :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER paraction AS CHARACTER NO-UNDO.
DEFINE VARIABLE varlevel-sm-q AS DECIMAL NO-UNDO.
define variable vartarirvalue as character no-undo.
define variable vartarirtype  as character no-undo.
define variable varlevel-sm   as integer   no-undo.
define buffer buf_place for ub.place.
define variable  v-file-name as character no-undo.
define variable v-delta-mas-qnty as decimal no-undo.
define variable v-full-name as character no-undo.
    define variable tt-level-water     as integer no-undo.
    define variable tt-level-water-dec as decimal no-undo.
    define variable v-water-qnty       as decimal no-undo. 
    define buffer bf-water-nxt_pl-level for pl-level.
    define variable varlevel-sm-water as decimal no-undo.
    
run gbl/conf-rd.p ("tarir", "", "", 0, "", "", "", no, output vartarirvalue, output vartarirtype) no-error.
/*Если работаем по тарировочным таблицам*/
if vartarirvalue = "yes" then do:
  CASE paraction:
    WHEN "state-level-total" THEN DO:
      ASSIGN
        varlevel-sm-q = input frame {&frame-name} tt-rvs-line.state-level-total.
    END.
    WHEN "state-level-petrol" THEN DO:
      ASSIGN
        varlevel-sm-q = input frame {&frame-name} tt-rvs-line.state-level-petrol.
    END.
  END CASE.
  assign
    varlevel-sm = trunc (varlevel-sm-q, 0).
  find first buf_place no-lock 
    where buf_place.pl-code = tt-rvs-line.pl-code
    .
  find first bf_pl-level
    where bf_pl-level.obj-type = tt-rvs-line.obj-type
      and bf_pl-level.obj-code = tt-rvs-line.obj-code
      and bf_pl-level.pl-code  = buf_place.pl-code
      and bf_pl-level.pl-level = varlevel-sm
    no-error.
  if not available bf_pl-level then do:
    message "Вычисляем объем резервуаров через градуировочные таблицы. Для резервуара " buf_place.loc1 " не задан объем для уровня " varlevel-sm view-as alert-box error.
    return no-apply.
  end.
  else do:
    if varlevel-sm = varlevel-sm-q then do:
      if error-status:error then return no-apply.
      display
/*        bf_pl-level.pl-qnty @ tt-rvs-line.state-brutto-qnty */
/*        bf_pl-level.pl-qnty @ tt-rvs-line.state-measure-qnty*/
        bf_pl-level.pl-qnty @ tt-rvs-line.fact-calc-vol
        bf_pl-level.pl-qnty + tt-rvs-line.state-add-qnty @ tt-rvs-line.fact-sum-vol
        with frame {&frame-name}.
    end.
    else do:
      assign
        varlevel-sm = varlevel-sm + 1.
      find first buf-nxt_pl-level
        where buf-nxt_pl-level.obj-type = tt-rvs-line.obj-type
          and buf-nxt_pl-level.obj-code = tt-rvs-line.obj-code
          and buf-nxt_pl-level.pl-code  = buf_place.pl-code
          and buf-nxt_pl-level.pl-level = varlevel-sm
        no-error.
      if not available buf-nxt_pl-level then do:
        message "Вычисляем объем резервуаров через градуировочные таблицы. Для резервуара " buf_place.loc1 " не задан объем для уровня " varlevel-sm " измерение " varlevel-sm-q view-as alert-box error.
        return no-apply.
      end.
      else do:
        display
/*          bf_pl-level.pl-qnty + (buf-nxt_pl-level.pl-qnty - bf_pl-level.pl-qnty) * (varlevel-sm-q - trunc(varlevel-sm-q, 0)) @ tt-rvs-line.state-brutto-qnty */
/*          bf_pl-level.pl-qnty + (buf-nxt_pl-level.pl-qnty - bf_pl-level.pl-qnty) * (varlevel-sm-q - trunc(varlevel-sm-q, 0)) @ tt-rvs-line.state-measure-qnty*/
          bf_pl-level.pl-qnty + (buf-nxt_pl-level.pl-qnty - bf_pl-level.pl-qnty) * (varlevel-sm-q - trunc(varlevel-sm-q, 0)) @ tt-rvs-line.fact-calc-vol
          bf_pl-level.pl-qnty + (buf-nxt_pl-level.pl-qnty - bf_pl-level.pl-qnty) * (varlevel-sm-q - trunc(varlevel-sm-q, 0)) + tt-rvs-line.state-add-qnty @ tt-rvs-line.fact-sum-vol
          with frame {&frame-name}.
      end.
    end.
      if  tt-rvs-line.state-level-water <> 0 then 
      do: 
          find first bf_pl-level where bf_pl-level.obj-type = tt-rvs-line.obj-type      and
              bf_pl-level.obj-code = tt-rvs-line.obj-code      and
              bf_pl-level.pl-code  = buf_place.pl-code          and
              bf_pl-level.pl-level = tt-rvs-line.state-level-water           no-error.
          if not available bf_pl-level then
          do:

                  assign
                      varlevel-sm-water = tt-rvs-line.state-level-water  + 1.
                  for each  bf-water-nxt_pl-level where bf-water-nxt_pl-level.obj-type = tt-rvs-line.obj-type  and
                      bf-water-nxt_pl-level.obj-code = tt-rvs-line.obj-code  and
                      bf-water-nxt_pl-level.pl-code  = buf_place.pl-code  and
                      bf-water-nxt_pl-level.pl-level  <  varlevel-sm-water   and        
                      bf-water-nxt_pl-level.pl-level > tt-rvs-line.state-level-water  - 1 no-lock  :  
                      v-water-qnty = abs (  abs (v-water-qnty )  -  bf-water-nxt_pl-level.pl-qnty / 10 )  .
                                  
                      if  bf-water-nxt_pl-level.pl-level > tt-rvs-line.state-level-water  - 1 and bf-water-nxt_pl-level.pl-level < tt-rvs-line.state-level-water  then 
                      do: 
                          tt-level-water =  bf-water-nxt_pl-level.pl-qnty.
                          tt-level-water-dec =  tt-rvs-line.state-level-water - bf-water-nxt_pl-level.pl-level .
                      end.
                  end. 
                  varstate-water-qnty =  tt-level-water +  tt-level-water-dec *  v-water-qnty * 10  . 
                  display  varstate-water-qnty with frame {&frame-name}.
/*                  display tt-rvs-line.state-brutto-qnty +  varstate-water-qnty  @ tt-rvs-line.state-brutto-qnty*/
/*                      with frame {&frame-name}.                                                                */
                  display tt-rvs-line.fact-calc-vol + tt-rvs-line.state-add-qnty + varstate-water-qnty  @ varstate-sum-vol
                      with frame {&frame-name}.
          end.
          else
          do:
              assign
                  varstate-water-qnty = bf_pl-level.pl-qnty  .
              display  varstate-water-qnty with frame {&frame-name}.
/*              display tt-rvs-line.state-brutto-qnty +  varstate-water-qnty  @ tt-rvs-line.state-brutto-qnty*/
/*              with frame {&frame-name}.                                                                    */
              display tt-rvs-line.fact-calc-vol + tt-rvs-line.state-add-qnty + varstate-water-qnty  @ varstate-sum-vol
                      with frame {&frame-name}.
/*              DISPLAY tt-rvs-line.state-measure-qnty with frame {&frame-name} .*/
          end.
      end.  
          else do:
              assign
                  varstate-water-qnty = 0  .
              display  varstate-water-qnty with frame {&frame-name}.
                
              display tt-rvs-line.fact-calc-vol + tt-rvs-line.state-add-qnty @ varstate-sum-vol
              with frame {&frame-name}.
/*              DISPLAY tt-rvs-line.state-measure-qnty with frame {&frame-name} .*/

          end.    

      assign
        tt-rvs-line.fact-calc-vol
        tt-rvs-line.fact-calc-vol = tt-rvs-line.fact-calc-vol - varstate-water-qnty 
        tt-rvs-line.state-measure-qnty = tt-rvs-line.fact-calc-vol 
        tt-rvs-line.state-brutto-qnty = tt-rvs-line.state-measure-qnty + varstate-water-qnty
      .
        display tt-rvs-line.fact-calc-vol with frame {&frame-name}.
/*        display tt-rvs-line.state-brutto-qnty with frame {&frame-name}.*/
        if tt-rvs-line.state-density <> 0 and
            tt-rvs-line.state-density <> ? then 
        do:
            run chg-density.
            run weath-water.
        end.
        
      if rdc-value = "pomi-rn"  then do:
        /*Тип резервуара*/
        run placelib_get-attr in this-procedure  (
            input {&place-type}
            ,input tt-rvs-line.obj-code
            ,input tt-rvs-line.obj-type
            ,input tt-rvs-line.pl-code
            ,output v-value
            ,output v-ok      ) no-error.
        if v-ok then 
        do :

    /*CASE paraction:
      WHEN "state-level-total" THEN DO:
        DISPLAY input frame {&frame-name} tt-rvs-line.state-level-total @ tt-rvs-line.state-level-petrol WITH FRAME {&FRAME-NAME}.
      END.
      WHEN "state-level-petrol" THEN DO:
        DISPLAY input frame {&frame-name} tt-rvs-line.state-level-petrol @ tt-rvs-line.state-level-total WITH FRAME {&FRAME-NAME}.
      END.
    END CASE.*/
            { gbl/getsect.i run  tt-rvs-line.obj-type  tt-rvs-line.obj-code  {&attr-petrol} }
    
            if integer(v-value) = 1 then 
            do:
                for each thbjattr_thbj-attr where thbjattr_thbj-attr.prop-code = {&attr-petrol_Delta-mass-vert}:    
                    assign 
                        v-full-name = thbjattr_thbj-attr.property-value-character .
                end.
            end.    
            else 
            do:
                for each thbjattr_thbj-attr where thbjattr_thbj-attr.prop-code = {&attr-petrol_Delta-mass-horiz}:    
                    assign 
                        v-full-name = thbjattr_thbj-attr.property-value-character .
                end.
            end.     
            do ii = 1 to NUM-ENTRIES(v-full-name,{&new-line}): 
                v-file-name = string(entry(ii,v-full-name,{&new-line})).
                if    tt-rvs-line.state-level-petrol = decimal ( entry(1, v-file-name, ";")  )  then 
                do: 
                    v-delta-mas-qnty =  decimal( entry(2, v-file-name, ";") ) no-error.
                end.
            end.
        end.
        if v-delta-mas-qnty > 0.65 then v-delta-mas-qnty = 0.65 .
        delta-mass-qnty = v-delta-mas-qnty.
        display  delta-mass-qnty with frame {&frame-name}.
        end.
        
    abs-delta-mass-add-qnty = tt-rvs-line.fact-calc-add-mass * pl-error-mass / 100 no-error .
    
/*    if tt-rvs-line.state-measure-cli-qnty = ?*/
/*    then do :                                */
       tt-rvs-line.state-measure-cli-qnty = input frame {&frame-name} tt-rvs-line.fact-calc-vol * tt-rvs-line.state-density .
       tt-rvs-line.fact-sum-mass = tt-rvs-line.state-measure-cli-qnty + tt-rvs-line.fact-calc-add-mass .
/*    end.*/
    tt-rvs-line.fact-sum-vol = tt-rvs-line.fact-calc-vol + tt-rvs-line.state-add-qnty .
    varstate-sum-vol = input frame {&frame-name} tt-rvs-line.fact-calc-vol + varstate-water-qnty .
    
    display 
      abs-delta-mass-add-qnty
      tt-rvs-line.fact-sum-vol
      tt-rvs-line.state-measure-cli-qnty
      tt-rvs-line.fact-sum-mass
      varstate-sum-vol
    with frame {&frame-name}.

    run volume-water.

  end.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE volume-measure-water Dialog-Frame 
PROCEDURE volume-measure-water :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
display input frame {&frame-name} tt-rvs-line.brutto-qnty -
        input frame {&frame-name} tt-rvs-line.measure-qnty @
        varmeasure-water-qnty with frame {&frame-name}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE volume-water Dialog-Frame 
PROCEDURE volume-water :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
if tt-rvs-line.state-brutto-qnty -
   tt-rvs-line.state-measure-qnty <> ?
then
display tt-rvs-line.state-brutto-qnty - tt-rvs-line.state-measure-qnty @
        varstate-water-qnty with frame {&frame-name}.
else        
if input frame {&frame-name} tt-rvs-line.state-brutto-qnty -
   input frame {&frame-name} tt-rvs-line.state-measure-qnty <> ?
then
display input frame {&frame-name} tt-rvs-line.state-brutto-qnty -
        input frame {&frame-name} tt-rvs-line.state-measure-qnty @
        varstate-water-qnty with frame {&frame-name}.
        
/*        assign frame {&frame-name} tt-rvs-line.state-brutto-qnty  */
/*                                   tt-rvs-line.state-measure-qnty.*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE weath-measure-water Dialog-Frame 
PROCEDURE weath-measure-water :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
display input frame {&frame-name} tt-rvs-line.brutto-cli-qnty -
        input frame {&frame-name} tt-rvs-line.measure-cli-qnty @
        varmeasure-water-cli-qnty with frame {&frame-name}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE weath-water Dialog-Frame 
PROCEDURE weath-water :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
/*if input frame {&frame-name} tt-rvs-line.state-measure-cli-qnty >      */
/*   input frame {&frame-name} tt-rvs-line.state-brutto-cli-qnty then do:*/
/*   message "Вес топлива больше общего веса."                           */
/*   view-as alert-box error.                                            */
/*   return error.                                                       */
/*end.                                                                   */
/*display input frame {&frame-name} tt-rvs-line.state-brutto-cli-qnty -  */
/*        input frame {&frame-name} tt-rvs-line.state-measure-cli-qnty @ */
/*        varstate-water-cli-qnty with frame {&frame-name}.              */
/*assign frame {&frame-name} tt-rvs-line.state-brutto-cli-qnty           */
/*                           tt-rvs-line.state-measure-cli-qnty.         */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

