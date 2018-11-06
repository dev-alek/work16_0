&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
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

Настроечные параметры для накладных

Автор: Чернова Светлана Александровна
Дата создания: 07/04/07
Author: Svetlana Chernova
Creation date: 07/04/07

This .W file was created with the Progress AppBuilder.

*/

define input parameter parparentproc as widget-handle no-undo.
define input parameter p-mode        as character no-undo.
define input parameter p-obj-type    like ub.clients.obj-type no-undo.
define input parameter p-obj-code    like ub.shop.obj-code no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-Workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Настроечные параметры для накладных" .
{ cmp/vssrevis.i }
{ cmp/trg-def.i  }
{ cmp/library.i  }
{ cmp/showinf.i  }
{ gbl/thbjattr.i }
{ gbl/getcntxt.i def }
{ gbl/getcntxt.i get }
{ gbl/onewin.i   }
{ gbl/twowin.i   }
{ str/trdcalib.i }

define buffer obj_thbj-attr for ub.thbj-attr.
define buffer glb_thbj-attr for ub.thbj-attr.
define temp-table temp-thbj-attr no-undo like ub.thbj-attr.
define variable v-tth     as handle no-undo .
define variable v-tthg    as handle no-undo .
define variable v-to-create as logical no-undo.
define variable v-to-create-trn as logical no-undo.
define variable v-to-create-trn-g as logical no-undo.
define variable str-attr as character no-undo .
define temp-table thbjattr_thbj-attr-g no-undo like thbjattr_thbj-attr .

define VARIABLE v-string   as character  no-undo .

define temp-table temp_twowin_itemsSelected_col no-undo
    field its-key   as integer
    field itm-key   as integer
    field itmExtKey as character

    index pi is primary unique
      its-key
    index im
      itm-key
.
define variable v-list-edt-full as character    no-undo.
define variable v-list-edt      as character    no-undo.

define variable v-list-attr-PN-full as character    no-undo.
define variable v-list-attr-PN      as character    no-undo.


assign
v-tth  = buffer thbjattr_thbj-attr:table-handle .
v-tthg = buffer thbjattr_thbj-attr-g:table-handle .
 if g#db-num <> 0 and p-obj-type = "" and  p-obj-code = 0
    then p-mode = {&lookup} .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS B-exit B-quit B-Help button-1 RECT-3 ~
button-2 F-button-1 F-button-2 
&Scoped-Define DISPLAYED-OBJECTS F-button-1 F-button-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON B-exit AUTO-GO 
     LABEL "&Ввод" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON B-Help 
     LABEL "&Help" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON B-quit AUTO-END-KEY 
     LABEL "&Отмена" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON button-1 
     IMAGE-UP FILE "adeicon\ts-up":U
     IMAGE-DOWN FILE "adeicon\ts-down":U
     IMAGE-INSENSITIVE FILE "adeicon\ts-up":U NO-FOCUS
     LABEL "Страница&1" 
     SIZE 14 BY 1.13 TOOLTIP "Закладка №1".

DEFINE BUTTON button-2 
     IMAGE-UP FILE "adeicon\ts-up":U
     IMAGE-DOWN FILE "adeicon\ts-down":U
     IMAGE-INSENSITIVE FILE "adeicon\ts-up":U NO-FOCUS
     LABEL "Страница&2" 
     SIZE 14 BY 1.13 TOOLTIP "Закладка №2".

DEFINE VARIABLE F-button-1 AS CHARACTER FORMAT "X(256)":U INITIAL "№ &1." 
      VIEW-AS TEXT 
     SIZE 5 BY .67 TOOLTIP "Закладка №1" NO-UNDO.

DEFINE VARIABLE F-button-2 AS CHARACTER FORMAT "X(256)":U INITIAL "№ &2." 
      VIEW-AS TEXT 
     SIZE 4.75 BY .67 TOOLTIP "Закладка №2" NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL   ROUNDED 
     SIZE 100 BY 20.5
     FGCOLOR 15 .

DEFINE BUTTON B-1 
     IMAGE-UP FILE "cmp/btn-ref.bmp":U
     LABEL "" 
     SIZE 3 BY 1.

DEFINE BUTTON B-10 
     IMAGE-UP FILE "cmp/btn-ref.bmp":U
     LABEL "" 
     SIZE 3 BY 1.

DEFINE BUTTON B-2 
     IMAGE-UP FILE "cmp/btn-ref.bmp":U
     LABEL "" 
     SIZE 3 BY 1.

DEFINE BUTTON B-3 
     IMAGE-UP FILE "cmp/btn-ref.bmp":U
     LABEL "" 
     SIZE 3 BY 1.

DEFINE BUTTON B-4 
     IMAGE-UP FILE "cmp/btn-ref.bmp":U
     LABEL "" 
     SIZE 3 BY 1.

DEFINE BUTTON B-5 
     IMAGE-UP FILE "cmp/btn-ref.bmp":U
     LABEL "" 
     SIZE 3 BY 1.

DEFINE BUTTON B-6 
     IMAGE-UP FILE "cmp/btn-ref.bmp":U
     LABEL "" 
     SIZE 3 BY 1.

DEFINE BUTTON B-7 
     IMAGE-UP FILE "cmp/btn-ref.bmp":U
     LABEL "" 
     SIZE 3 BY 1.

DEFINE BUTTON B-8 
     IMAGE-UP FILE "cmp/btn-ref.bmp":U
     LABEL "" 
     SIZE 3 BY 1.

DEFINE BUTTON B-9 
     IMAGE-UP FILE "cmp/btn-ref.bmp":U
     LABEL "" 
     SIZE 3 BY 1.

DEFINE VARIABLE date-close-period AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 11.63 BY 1 NO-UNDO.

DEFINE VARIABLE factorrt AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5.5 BY 1 NO-UNDO.

DEFINE VARIABLE prc-exp AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE rnd-znk AS INTEGER FORMAT ">>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 3.5 BY 1 NO-UNDO.

DEFINE VARIABLE slt-ext AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN NATIVE 
     SIZE 6.5 BY 1 NO-UNDO.

DEFINE VARIABLE v-avail-on-date AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 56.63 BY 1 NO-UNDO.

DEFINE VARIABLE v-chk-prs AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE v-convimp AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE v-curcli AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 57.88 BY 1 NO-UNDO.

DEFINE VARIABLE v-date-close-period AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 23.88 BY 1 NO-UNDO.

DEFINE VARIABLE v-factorrt AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 28.38 BY 1 NO-UNDO.

DEFINE VARIABLE v-inp_sum AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 66.13 BY 1 NO-UNDO.

DEFINE VARIABLE v-intprmvq AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 56.63 BY 1 NO-UNDO.

DEFINE VARIABLE v-is-bcdoc AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE v-is-ov AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 44.38 BY 1 NO-UNDO.

DEFINE VARIABLE v-minusprt AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 56.63 BY 1 NO-UNDO.

DEFINE VARIABLE v-multdtyp AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 57.88 BY .88 NO-UNDO.

DEFINE VARIABLE v-noapndsc AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 43.38 BY 1 NO-UNDO.

DEFINE VARIABLE v-nocurbas AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 56 BY 1 NO-UNDO.

DEFINE VARIABLE v-part-prc AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 58.38 BY 1 NO-UNDO.

DEFINE VARIABLE v-prc-exp AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 65.13 BY 1 NO-UNDO.

DEFINE VARIABLE v-proxycrd AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 58.38 BY 1 NO-UNDO.

DEFINE VARIABLE v-rnd-znk AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 46 BY 1 NO-UNDO.

DEFINE VARIABLE v-slt-ext AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 36.5 BY 1 NO-UNDO.

DEFINE VARIABLE v-stfactdt AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 56.63 BY 1 NO-UNDO.

DEFINE VARIABLE v-type-slt AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE v-type-vat AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE v-vat-ext AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 29.38 BY 1 NO-UNDO.

DEFINE VARIABLE v-vat-sum AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 29.38 BY .92 NO-UNDO.

DEFINE VARIABLE vat-ext AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN NATIVE 
     SIZE 13.5 BY 1 NO-UNDO.

DEFINE IMAGE I-avail-on-date
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-chk-prs
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-convimp
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-curcli
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-date-close-period
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.04.

DEFINE IMAGE I-factorrt
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.04.

DEFINE IMAGE I-inp_sum
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-intprmvq
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-is-bcdoc
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-is-ov
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-minusprt
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-multdtyp
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-noapndsc
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-nocurbas
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-part-prc
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-prc-exp
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-proxycrd
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-rnd-znk
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-slt-ext
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-stfactdt
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-type-slt
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.04.

DEFINE IMAGE I-type-vat
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-vat-ext
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-vat-sum
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE VARIABLE nocurbas AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Нет", "no",
"Да", "yes",
"Запрещено сегодня", "no_today"
     SIZE 29.5 BY 1
     FONT 4 NO-UNDO.

DEFINE VARIABLE type-slt AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "в.т.ч", 1,
"нет", 2,
"без", 3
     SIZE 15.63 BY 1
     FONT 4 NO-UNDO.

DEFINE VARIABLE type-vat AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "в.т.ч", 1,
"нет", 2,
"без", 3
     SIZE 15.63 BY 1
     FONT 4 NO-UNDO.

DEFINE VARIABLE avail-on-date AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.38 BY 1 NO-UNDO.

DEFINE VARIABLE chk-prs AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.38 BY 1 NO-UNDO.

DEFINE VARIABLE convimp AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.38 BY 1 NO-UNDO.

DEFINE VARIABLE curcli AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.38 BY 1 NO-UNDO.

DEFINE VARIABLE inp_sum AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.38 BY 1 NO-UNDO.

DEFINE VARIABLE intprmvq AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.38 BY 1 NO-UNDO.

DEFINE VARIABLE is-bcdoc AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.38 BY 1 NO-UNDO.

DEFINE VARIABLE is-ov AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.38 BY 1 NO-UNDO.

DEFINE VARIABLE minusprt AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.38 BY 1 NO-UNDO.

DEFINE VARIABLE multdtyp AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.38 BY 1 NO-UNDO.

DEFINE VARIABLE noapndsc AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.38 BY 1 NO-UNDO.

DEFINE VARIABLE part-prc AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.38 BY 1 NO-UNDO.

DEFINE VARIABLE proxycrd AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.38 BY 1 NO-UNDO.

DEFINE VARIABLE stfactdt AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.38 BY 1 NO-UNDO.

DEFINE VARIABLE vat-sum AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.38 BY .92 NO-UNDO.

DEFINE BUTTON B-11 
     IMAGE-UP FILE "cmp/btn-ref.bmp":U
     LABEL "" 
     SIZE 3 BY 1.

DEFINE BUTTON B-12 
     IMAGE-UP FILE "cmp/btn-ref.bmp":U
     LABEL "" 
     SIZE 3 BY 1.

DEFINE BUTTON B-13 
     IMAGE-UP FILE "cmp/btn-ref.bmp":U
     LABEL "" 
     SIZE 3 BY 1.

DEFINE BUTTON B-14 
     IMAGE-UP FILE "cmp/btn-ref.bmp":U
     LABEL "" 
     SIZE 3 BY 1.

DEFINE BUTTON B-15 
     IMAGE-UP FILE "cmp/btn-ref.bmp":U
     LABEL "" 
     SIZE 3 BY 1.

DEFINE BUTTON B-16 
     IMAGE-UP FILE "cmp/btn-ref.bmp":U
     LABEL "" 
     SIZE 3 BY 1.

DEFINE BUTTON B-17 
     IMAGE-UP FILE "cmp/btn-ref.bmp":U
     LABEL "" 
     SIZE 3 BY 1.

DEFINE BUTTON B-18 
     IMAGE-UP FILE "cmp/btn-ref.bmp":U
     LABEL "" 
     SIZE 3 BY 1.

DEFINE BUTTON B-19 
     IMAGE-UP FILE "cmp/btn-ref.bmp":U
     LABEL "" 
     SIZE 3 BY 1.

DEFINE BUTTON B-20 
     IMAGE-UP FILE "cmp/btn-ref.bmp":U
     LABEL "" 
     SIZE 3 BY 1.

DEFINE BUTTON B-22 
     IMAGE-UP FILE "cmp/btn-ref.bmp":U
     LABEL "" 
     SIZE 3 BY 1.

DEFINE BUTTON B-ex 
     IMAGE-UP FILE "cmp/update.bmp":U
     LABEL "" 
     SIZE 3 BY 1.

DEFINE BUTTON B-set_attr-PN 
     IMAGE-UP FILE "cmp/update.bmp":U
     LABEL "" 
     SIZE 2.63 BY 1.08.

DEFINE VARIABLE attr-PN AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 35.5 BY 6 NO-UNDO.

DEFINE VARIABLE reasonme AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 41.25 BY 1
     FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE v-attr-PN AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 25.5 BY 1 NO-UNDO.

DEFINE VARIABLE v-back-date AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 66.13 BY 1 NO-UNDO.

DEFINE VARIABLE v-exc-max-qnty AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 66.13 BY 1 NO-UNDO.

DEFINE VARIABLE v-gtd-to-imp-prod AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 71 BY 1 NO-UNDO.

DEFINE VARIABLE v-inv-ship AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 66.13 BY 1 NO-UNDO.

DEFINE VARIABLE v-neg-ask AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 66.13 BY 1 NO-UNDO.

DEFINE VARIABLE v-not-ord AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 66.13 BY 1 NO-UNDO.

DEFINE VARIABLE v-reasonm AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 66.13 BY 1 NO-UNDO.

DEFINE VARIABLE v-reasonme AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 21.75 BY 1 NO-UNDO.

DEFINE VARIABLE v-round-vat-sum AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 66.13 BY 1 NO-UNDO.

DEFINE VARIABLE v-vat-goods AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 66.13 BY 1 NO-UNDO.

DEFINE IMAGE I-attr-PN
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-back-date
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-exc-max-qnty
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-gtd-to-imp-prod
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-inv-ship
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-neg-ask
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-not-ord
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-reasonm
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-reasonme
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-round-vat-sum
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE IMAGE I-vat-goods
     FILENAME "cmp/info.bmp":U
     SIZE 3 BY 1.

DEFINE VARIABLE back-date AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2 BY 1 NO-UNDO.

DEFINE VARIABLE exc-max-qnty AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.5 BY 1 NO-UNDO.

DEFINE VARIABLE gtd-to-imp-prod AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.5 BY 1 NO-UNDO.

DEFINE VARIABLE inv-ship AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.5 BY 1 NO-UNDO.

DEFINE VARIABLE neg-ask AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.5 BY 1 NO-UNDO.

DEFINE VARIABLE not-ord AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.5 BY 1 NO-UNDO.

DEFINE VARIABLE reasonm AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.5 BY 1 NO-UNDO.

DEFINE VARIABLE round-vat-sum AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.5 BY 1 NO-UNDO.

DEFINE VARIABLE vat-goods AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.5 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     B-exit AT ROW 1 COL 1
     B-quit AT ROW 1 COL 11
     B-Help AT ROW 1 COL 90.5
     button-1 AT ROW 1.08 COL 21.13 WIDGET-ID 244
     button-2 AT ROW 1.08 COL 34.63 WIDGET-ID 246
     F-button-1 AT ROW 1.33 COL 20.38 COLON-ALIGNED NO-LABEL WIDGET-ID 350
     F-button-2 AT ROW 1.33 COL 33.63 COLON-ALIGNED NO-LABEL WIDGET-ID 348
     RECT-3 AT ROW 2 COL 1 WIDGET-ID 248
     SPACE(0.49) SKIP(0.91)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Настройки для накладных"
         DEFAULT-BUTTON B-exit CANCEL-BUTTON B-quit WIDGET-ID 100.

DEFINE FRAME page-1
     B-1 AT ROW 1.08 COL 3.13 WIDGET-ID 80
     date-close-period AT ROW 1.08 COL 4.63 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     B-2 AT ROW 2.13 COL 3.13 WIDGET-ID 82
     stfactdt AT ROW 2.13 COL 6.63 WIDGET-ID 46
     B-3 AT ROW 3.17 COL 3.13 WIDGET-ID 84
     intprmvq AT ROW 3.17 COL 6.63 WIDGET-ID 52
     B-4 AT ROW 4.21 COL 3.13 WIDGET-ID 86
     minusprt AT ROW 4.21 COL 6.63 WIDGET-ID 58
     part-prc AT ROW 5.17 COL 3.13 WIDGET-ID 182
     curcli AT ROW 6 COL 3.13 WIDGET-ID 148
     B-7 AT ROW 6.88 COL 3.13 WIDGET-ID 92
     avail-on-date AT ROW 6.88 COL 6.63 WIDGET-ID 96
     nocurbas AT ROW 7.83 COL 60 NO-LABEL WIDGET-ID 124
     rnd-znk AT ROW 9.79 COL 46.5 COLON-ALIGNED NO-LABEL WIDGET-ID 214
     chk-prs AT ROW 9.83 COL 3.13 WIDGET-ID 130
     convimp AT ROW 10.79 COL 3.13 WIDGET-ID 134
     noapndsc AT ROW 10.79 COL 48.5 WIDGET-ID 176
     is-bcdoc AT ROW 11.67 COL 3.13 WIDGET-ID 156
     is-ov AT ROW 11.67 COL 48.5 WIDGET-ID 164
     B-9 AT ROW 12.58 COL 3.13 WIDGET-ID 108
     proxycrd AT ROW 12.58 COL 6.63 WIDGET-ID 112
     vat-sum AT ROW 13.54 COL 3.13 WIDGET-ID 232
     B-5 AT ROW 14.33 COL 3.13 WIDGET-ID 88
     type-vat AT ROW 14.33 COL 37.88 NO-LABEL WIDGET-ID 68
     vat-ext AT ROW 14.33 COL 60.5 COLON-ALIGNED NO-LABEL WIDGET-ID 226
     B-6 AT ROW 15.38 COL 3.13 WIDGET-ID 90
     type-slt AT ROW 15.38 COL 37.88 NO-LABEL WIDGET-ID 74
     slt-ext AT ROW 15.38 COL 60.5 COLON-ALIGNED NO-LABEL WIDGET-ID 220
     multdtyp AT ROW 16.33 COL 3.13 WIDGET-ID 170
     prc-exp AT ROW 17.21 COL 1.13 COLON-ALIGNED NO-LABEL WIDGET-ID 210
     B-8 AT ROW 18.29 COL 3.13 WIDGET-ID 100
     factorrt AT ROW 18.29 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 102
     B-10 AT ROW 19.38 COL 3.13 WIDGET-ID 238
     inp_sum AT ROW 19.38 COL 6.63 WIDGET-ID 236
     v-date-close-period AT ROW 1.08 COL 19.13 NO-LABEL WIDGET-ID 6
     v-stfactdt AT ROW 2.13 COL 9.38 NO-LABEL WIDGET-ID 18
     v-intprmvq AT ROW 3.17 COL 9.38 NO-LABEL WIDGET-ID 54
     v-minusprt AT ROW 4.21 COL 9.38 NO-LABEL WIDGET-ID 60
     v-part-prc AT ROW 5.17 COL 6.63 NO-LABEL WIDGET-ID 184
     v-curcli AT ROW 6 COL 6.63 NO-LABEL WIDGET-ID 150
     v-avail-on-date AT ROW 6.88 COL 9.38 NO-LABEL WIDGET-ID 98
     v-nocurbas AT ROW 7.83 COL 3.13 NO-LABEL WIDGET-ID 122
     v-rnd-znk AT ROW 9.79 COL 52.5 NO-LABEL WIDGET-ID 216
     v-chk-prs AT ROW 9.83 COL 5.75 NO-LABEL WIDGET-ID 132
     v-convimp AT ROW 10.79 COL 5.75 NO-LABEL WIDGET-ID 138
     v-noapndsc AT ROW 10.79 COL 52.25 NO-LABEL WIDGET-ID 178
     v-is-bcdoc AT ROW 11.67 COL 5.75 NO-LABEL WIDGET-ID 160
     v-is-ov AT ROW 11.67 COL 52.13 NO-LABEL WIDGET-ID 166
     v-proxycrd AT ROW 12.58 COL 8.63 NO-LABEL WIDGET-ID 114
     v-vat-sum AT ROW 13.54 COL 6.63 NO-LABEL WIDGET-ID 234
     v-type-vat AT ROW 14.33 COL 6.5 NO-LABEL WIDGET-ID 66
     v-vat-ext AT ROW 14.33 COL 70.63 NO-LABEL WIDGET-ID 228
     v-type-slt AT ROW 15.38 COL 6.5 NO-LABEL WIDGET-ID 78
     v-slt-ext AT ROW 15.38 COL 63.5 NO-LABEL WIDGET-ID 222
     v-multdtyp AT ROW 16.33 COL 6.63 NO-LABEL WIDGET-ID 172
     v-prc-exp AT ROW 17.21 COL 10.88 NO-LABEL WIDGET-ID 208
     v-factorrt AT ROW 18.29 COL 13.13 NO-LABEL WIDGET-ID 106
     v-inp_sum AT ROW 19.38 COL 9.38 NO-LABEL WIDGET-ID 242
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.5 ROW 2.25
         SIZE 99 BY 20 WIDGET-ID 200.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME page-1
     I-date-close-period AT ROW 1.08 COL 1.25 WIDGET-ID 10
     I-stfactdt AT ROW 2.13 COL 1 WIDGET-ID 34
     I-intprmvq AT ROW 3.17 COL 1 WIDGET-ID 50
     I-minusprt AT ROW 4.21 COL 1 WIDGET-ID 56
     I-part-prc AT ROW 5.17 COL 1 WIDGET-ID 180
     I-curcli AT ROW 6 COL 1 WIDGET-ID 146
     I-avail-on-date AT ROW 6.88 COL 1 WIDGET-ID 94
     I-nocurbas AT ROW 7.83 COL 1 WIDGET-ID 118
     I-chk-prs AT ROW 9.83 COL 1 WIDGET-ID 128
     I-rnd-znk AT ROW 9.79 COL 46 WIDGET-ID 212
     I-convimp AT ROW 10.79 COL 1 WIDGET-ID 136
     I-noapndsc AT ROW 10.79 COL 46 WIDGET-ID 174
     I-is-bcdoc AT ROW 11.67 COL 1 WIDGET-ID 158
     I-is-ov AT ROW 11.67 COL 46 WIDGET-ID 162
     I-proxycrd AT ROW 12.58 COL 1 WIDGET-ID 110
     I-vat-sum AT ROW 13.46 COL 1 WIDGET-ID 230
     I-type-vat AT ROW 14.33 COL 1 WIDGET-ID 64
     I-vat-ext AT ROW 14.33 COL 60 WIDGET-ID 224
     I-type-slt AT ROW 15.33 COL 1 WIDGET-ID 72
     I-slt-ext AT ROW 15.38 COL 60 WIDGET-ID 218
     I-multdtyp AT ROW 16.38 COL 1 WIDGET-ID 168
     I-prc-exp AT ROW 17.21 COL 1 WIDGET-ID 204
     I-factorrt AT ROW 18.25 COL 1 WIDGET-ID 104
     I-inp_sum AT ROW 19.38 COL 1 WIDGET-ID 240
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.5 ROW 2.25
         SIZE 99 BY 20 WIDGET-ID 200.

DEFINE FRAME page-2
     B-11 AT ROW 1.13 COL 2.88 WIDGET-ID 238
     reasonm AT ROW 1.13 COL 6 WIDGET-ID 236
     B-14 AT ROW 2.17 COL 5.75 WIDGET-ID 260
     B-ex AT ROW 2.17 COL 31.13 WIDGET-ID 268
     back-date AT ROW 3.25 COL 5.5 WIDGET-ID 248
     B-12 AT ROW 3.29 COL 2.88 WIDGET-ID 244
     B-13 AT ROW 4.42 COL 2.88 WIDGET-ID 252
     not-ord AT ROW 4.42 COL 6 WIDGET-ID 254
     B-15 AT ROW 5.46 COL 2.88 WIDGET-ID 270
     neg-ask AT ROW 5.46 COL 6 WIDGET-ID 274
     B-16 AT ROW 6.58 COL 2.88 WIDGET-ID 278
     vat-goods AT ROW 6.58 COL 6 WIDGET-ID 282
     B-17 AT ROW 7.75 COL 2.88 WIDGET-ID 286
     inv-ship AT ROW 7.75 COL 6 WIDGET-ID 290
     B-18 AT ROW 9 COL 2.88 WIDGET-ID 294
     round-vat-sum AT ROW 9 COL 6 WIDGET-ID 298
     B-19 AT ROW 10.25 COL 2.88 WIDGET-ID 302
     gtd-to-imp-prod AT ROW 10.25 COL 6 WIDGET-ID 306
     B-20 AT ROW 11.5 COL 2.88 WIDGET-ID 310
     exc-max-qnty AT ROW 11.5 COL 6 WIDGET-ID 314
     v-reasonm AT ROW 1.13 COL 8.75 NO-LABEL WIDGET-ID 242
     v-reasonme AT ROW 2.17 COL 6.75 COLON-ALIGNED NO-LABEL WIDGET-ID 264
     reasonme AT ROW 2.25 COL 32.75 COLON-ALIGNED NO-LABEL WIDGET-ID 266
     v-back-date AT ROW 3.38 COL 6.5 COLON-ALIGNED NO-LABEL WIDGET-ID 250
     v-not-ord AT ROW 4.42 COL 6.75 COLON-ALIGNED NO-LABEL WIDGET-ID 258
     v-neg-ask AT ROW 5.46 COL 6.75 COLON-ALIGNED NO-LABEL WIDGET-ID 276
     v-vat-goods AT ROW 6.58 COL 6.75 COLON-ALIGNED NO-LABEL WIDGET-ID 284
     v-inv-ship AT ROW 7.75 COL 6.5 COLON-ALIGNED NO-LABEL WIDGET-ID 292
     v-round-vat-sum AT ROW 9 COL 6.5 COLON-ALIGNED NO-LABEL WIDGET-ID 300
     v-gtd-to-imp-prod AT ROW 10.25 COL 6.5 COLON-ALIGNED NO-LABEL WIDGET-ID 308
     v-exc-max-qnty AT ROW 11.5 COL 6.5 COLON-ALIGNED NO-LABEL WIDGET-ID 316
     I-reasonm AT ROW 1.13 COL 1 WIDGET-ID 240
     I-back-date AT ROW 3.29 COL 1.5 WIDGET-ID 246
     I-not-ord AT ROW 4.42 COL 1 WIDGET-ID 256
     I-reasonme AT ROW 2.17 COL 3.88 WIDGET-ID 262
     I-neg-ask AT ROW 5.46 COL 1 WIDGET-ID 272
     I-vat-goods AT ROW 6.58 COL 1 WIDGET-ID 280
     I-inv-ship AT ROW 7.75 COL 1 WIDGET-ID 288
     I-round-vat-sum AT ROW 9 COL 1 WIDGET-ID 296
     I-gtd-to-imp-prod AT ROW 10.25 COL 1 WIDGET-ID 304
     I-exc-max-qnty AT ROW 11.5 COL 1 WIDGET-ID 312
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.63 ROW 2.33
         SIZE 99 BY 19.75 WIDGET-ID 300.

DEFINE FRAME page-2
     B-11 AT ROW 1.13 COL 2.88 WIDGET-ID 238
     reasonm AT ROW 1.13 COL 6 WIDGET-ID 236
     B-14 AT ROW 2.17 COL 5.75 WIDGET-ID 260
     B-ex AT ROW 2.17 COL 31.13 WIDGET-ID 268
     back-date AT ROW 3.25 COL 6 WIDGET-ID 248
     B-12 AT ROW 3.29 COL 2.88 WIDGET-ID 244
     B-13 AT ROW 4.42 COL 2.88 WIDGET-ID 252
     not-ord AT ROW 4.42 COL 6 WIDGET-ID 254
     B-15 AT ROW 5.46 COL 2.88 WIDGET-ID 270
     neg-ask AT ROW 5.46 COL 6 WIDGET-ID 274
     B-16 AT ROW 6.58 COL 2.88 WIDGET-ID 278
     vat-goods AT ROW 6.58 COL 6 WIDGET-ID 282
     B-17 AT ROW 7.75 COL 2.88 WIDGET-ID 286
     inv-ship AT ROW 7.75 COL 6 WIDGET-ID 290
     B-18 AT ROW 9 COL 2.88 WIDGET-ID 294
     round-vat-sum AT ROW 9 COL 6 WIDGET-ID 298
     B-19 AT ROW 10.25 COL 2.88 WIDGET-ID 302
     gtd-to-imp-prod AT ROW 10.25 COL 6 WIDGET-ID 306
     B-20 AT ROW 11.5 COL 2.88 WIDGET-ID 310
     exc-max-qnty AT ROW 11.5 COL 6 WIDGET-ID 314
     B-22 AT ROW 12.75 COL 2.88 WIDGET-ID 484
     B-set_attr-PN AT ROW 12.75 COL 32 WIDGET-ID 480
     attr-PN AT ROW 14 COL 6 NO-LABEL WIDGET-ID 492
     v-reasonm AT ROW 1.13 COL 8.75 NO-LABEL WIDGET-ID 242
     v-reasonme AT ROW 2.17 COL 6.75 COLON-ALIGNED NO-LABEL WIDGET-ID 264
     reasonme AT ROW 2.25 COL 32.75 COLON-ALIGNED NO-LABEL WIDGET-ID 266
     v-back-date AT ROW 3.38 COL 6.5 COLON-ALIGNED NO-LABEL WIDGET-ID 250
     v-not-ord AT ROW 4.42 COL 6.75 COLON-ALIGNED NO-LABEL WIDGET-ID 258
     v-neg-ask AT ROW 5.46 COL 6.75 COLON-ALIGNED NO-LABEL WIDGET-ID 276
     v-vat-goods AT ROW 6.58 COL 6.75 COLON-ALIGNED NO-LABEL WIDGET-ID 284
     v-inv-ship AT ROW 7.75 COL 6.5 COLON-ALIGNED NO-LABEL WIDGET-ID 292
     v-round-vat-sum AT ROW 9 COL 6.5 COLON-ALIGNED NO-LABEL WIDGET-ID 300
     v-gtd-to-imp-prod AT ROW 10.25 COL 6.5 COLON-ALIGNED NO-LABEL WIDGET-ID 308
     v-exc-max-qnty AT ROW 11.5 COL 6.5 COLON-ALIGNED NO-LABEL WIDGET-ID 316
     v-attr-PN AT ROW 12.75 COL 4.5 COLON-ALIGNED NO-LABEL WIDGET-ID 494
     I-reasonm AT ROW 1.13 COL 1 WIDGET-ID 240
     I-back-date AT ROW 3.29 COL 1.5 WIDGET-ID 246
     I-not-ord AT ROW 4.42 COL 1 WIDGET-ID 256
     I-reasonme AT ROW 2.17 COL 3.88 WIDGET-ID 262
     I-neg-ask AT ROW 5.46 COL 1 WIDGET-ID 272
     I-vat-goods AT ROW 6.58 COL 1 WIDGET-ID 280
     I-inv-ship AT ROW 7.75 COL 1 WIDGET-ID 288
     I-round-vat-sum AT ROW 9 COL 1 WIDGET-ID 296
     I-gtd-to-imp-prod AT ROW 10.25 COL 1 WIDGET-ID 304
     I-exc-max-qnty AT ROW 11.5 COL 1 WIDGET-ID 312
     I-attr-PN AT ROW 12.75 COL 1 WIDGET-ID 486
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.63 ROW 2.33
         SIZE 99 BY 19.75 WIDGET-ID 300.

DEFINE FRAME page-1
     B-1 AT ROW 1.08 COL 3.13 WIDGET-ID 80
     date-close-period AT ROW 1.08 COL 4.63 COLON-ALIGNED NO-LABEL WIDGET-ID 48
     B-2 AT ROW 2.13 COL 3.13 WIDGET-ID 82
     stfactdt AT ROW 2.13 COL 6.63 WIDGET-ID 46
     B-3 AT ROW 3.17 COL 3.13 WIDGET-ID 84
     intprmvq AT ROW 3.17 COL 6.63 WIDGET-ID 52
     B-4 AT ROW 4.21 COL 3.13 WIDGET-ID 86
     minusprt AT ROW 4.21 COL 6.63 WIDGET-ID 58
     part-prc AT ROW 5.17 COL 3.13 WIDGET-ID 182
     curcli AT ROW 6 COL 3.13 WIDGET-ID 148
     B-7 AT ROW 6.88 COL 3.13 WIDGET-ID 92
     avail-on-date AT ROW 6.88 COL 6.63 WIDGET-ID 96
     nocurbas AT ROW 7.83 COL 60 NO-LABEL WIDGET-ID 124
     rnd-znk AT ROW 9.79 COL 46.5 COLON-ALIGNED NO-LABEL WIDGET-ID 214
     chk-prs AT ROW 9.83 COL 3.13 WIDGET-ID 130
     convimp AT ROW 10.79 COL 3.13 WIDGET-ID 134
     noapndsc AT ROW 10.79 COL 48.5 WIDGET-ID 176
     is-bcdoc AT ROW 11.67 COL 3.13 WIDGET-ID 156
     is-ov AT ROW 11.67 COL 48.5 WIDGET-ID 164
     B-9 AT ROW 12.58 COL 3.13 WIDGET-ID 108
     proxycrd AT ROW 12.58 COL 6.63 WIDGET-ID 112
     vat-sum AT ROW 13.54 COL 3.13 WIDGET-ID 232
     B-5 AT ROW 14.33 COL 3.13 WIDGET-ID 88
     type-vat AT ROW 14.33 COL 37.88 NO-LABEL WIDGET-ID 68
     vat-ext AT ROW 14.33 COL 60.5 COLON-ALIGNED NO-LABEL WIDGET-ID 226
     B-6 AT ROW 15.38 COL 3.13 WIDGET-ID 90
     type-slt AT ROW 15.38 COL 37.88 NO-LABEL WIDGET-ID 74
     slt-ext AT ROW 15.38 COL 60.5 COLON-ALIGNED NO-LABEL WIDGET-ID 220
     multdtyp AT ROW 16.33 COL 3.13 WIDGET-ID 170
     prc-exp AT ROW 17.21 COL 1.13 COLON-ALIGNED NO-LABEL WIDGET-ID 210
     B-8 AT ROW 18.29 COL 3.13 WIDGET-ID 100
     factorrt AT ROW 18.29 COL 5 COLON-ALIGNED NO-LABEL WIDGET-ID 102
     B-10 AT ROW 19.38 COL 3.13 WIDGET-ID 238
     inp_sum AT ROW 19.38 COL 6.63 WIDGET-ID 236
     v-date-close-period AT ROW 1.08 COL 19.13 NO-LABEL WIDGET-ID 6
     v-stfactdt AT ROW 2.13 COL 9.38 NO-LABEL WIDGET-ID 18
     v-intprmvq AT ROW 3.17 COL 9.38 NO-LABEL WIDGET-ID 54
     v-minusprt AT ROW 4.21 COL 9.38 NO-LABEL WIDGET-ID 60
     v-part-prc AT ROW 5.17 COL 6.63 NO-LABEL WIDGET-ID 184
     v-curcli AT ROW 6 COL 6.63 NO-LABEL WIDGET-ID 150
     v-avail-on-date AT ROW 6.88 COL 9.38 NO-LABEL WIDGET-ID 98
     v-nocurbas AT ROW 7.83 COL 3.13 NO-LABEL WIDGET-ID 122
     v-rnd-znk AT ROW 9.79 COL 52.5 NO-LABEL WIDGET-ID 216
     v-chk-prs AT ROW 9.83 COL 5.75 NO-LABEL WIDGET-ID 132
     v-convimp AT ROW 10.79 COL 5.75 NO-LABEL WIDGET-ID 138
     v-noapndsc AT ROW 10.79 COL 52.25 NO-LABEL WIDGET-ID 178
     v-is-bcdoc AT ROW 11.67 COL 5.75 NO-LABEL WIDGET-ID 160
     v-is-ov AT ROW 11.67 COL 52.13 NO-LABEL WIDGET-ID 166
     v-proxycrd AT ROW 12.58 COL 8.63 NO-LABEL WIDGET-ID 114
     v-vat-sum AT ROW 13.54 COL 6.63 NO-LABEL WIDGET-ID 234
     v-type-vat AT ROW 14.33 COL 6.5 NO-LABEL WIDGET-ID 66
     v-vat-ext AT ROW 14.33 COL 76.50 NO-LABEL WIDGET-ID 228
     v-type-slt AT ROW 15.38 COL 6.5 NO-LABEL WIDGET-ID 78
     v-slt-ext AT ROW 15.38 COL 76.5 NO-LABEL WIDGET-ID 222
     v-multdtyp AT ROW 16.33 COL 6.63 NO-LABEL WIDGET-ID 172
     v-prc-exp AT ROW 17.21 COL 10.88 NO-LABEL WIDGET-ID 208
     v-factorrt AT ROW 18.29 COL 13.13 NO-LABEL WIDGET-ID 106
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.5 ROW 2.25
         SIZE 99 BY 20 WIDGET-ID 200.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME page-1
     v-inp_sum AT ROW 19.38 COL 9.38 NO-LABEL WIDGET-ID 242
     I-date-close-period AT ROW 1.08 COL 1.25 WIDGET-ID 10
     I-stfactdt AT ROW 2.13 COL 1 WIDGET-ID 34
     I-intprmvq AT ROW 3.17 COL 1 WIDGET-ID 50
     I-minusprt AT ROW 4.21 COL 1 WIDGET-ID 56
     I-part-prc AT ROW 5.17 COL 1 WIDGET-ID 180
     I-curcli AT ROW 6 COL 1 WIDGET-ID 146
     I-avail-on-date AT ROW 6.88 COL 1 WIDGET-ID 94
     I-nocurbas AT ROW 7.83 COL 1 WIDGET-ID 118
     I-chk-prs AT ROW 9.83 COL 1 WIDGET-ID 128
     I-rnd-znk AT ROW 9.79 COL 46 WIDGET-ID 212
     I-convimp AT ROW 10.79 COL 1 WIDGET-ID 136
     I-noapndsc AT ROW 10.79 COL 46 WIDGET-ID 174
     I-is-bcdoc AT ROW 11.67 COL 1 WIDGET-ID 158
     I-is-ov AT ROW 11.67 COL 46 WIDGET-ID 162
     I-proxycrd AT ROW 12.58 COL 1 WIDGET-ID 110
     I-vat-sum AT ROW 13.46 COL 1 WIDGET-ID 230
     I-type-vat AT ROW 14.33 COL 1 WIDGET-ID 64
     I-vat-ext AT ROW 14.33 COL 60 WIDGET-ID 224
     I-type-slt AT ROW 15.33 COL 1 WIDGET-ID 72
     I-slt-ext AT ROW 15.38 COL 60 WIDGET-ID 218
     I-multdtyp AT ROW 16.38 COL 1 WIDGET-ID 168
     I-prc-exp AT ROW 17.21 COL 1 WIDGET-ID 204
     I-factorrt AT ROW 18.25 COL 1 WIDGET-ID 104
     I-inp_sum AT ROW 19.38 COL 1 WIDGET-ID 240
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.5 ROW 2.25
         SIZE 99 BY 20 WIDGET-ID 200.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* REPARENT FRAME */
ASSIGN FRAME page-1:FRAME = FRAME Dialog-Frame:HANDLE
       FRAME page-2:FRAME = FRAME Dialog-Frame:HANDLE.

/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FRAME page-1
                                                                        */
/* SETTINGS FOR FILL-IN v-avail-on-date IN FRAME page-1
   ALIGN-L                                                              */
ASSIGN 
       v-avail-on-date:READ-ONLY IN FRAME page-1        = TRUE.

/* SETTINGS FOR FILL-IN v-chk-prs IN FRAME page-1
   ALIGN-L                                                              */
ASSIGN 
       v-chk-prs:READ-ONLY IN FRAME page-1        = TRUE.

/* SETTINGS FOR FILL-IN v-convimp IN FRAME page-1
   ALIGN-L                                                              */
ASSIGN 
       v-convimp:READ-ONLY IN FRAME page-1        = TRUE.

/* SETTINGS FOR FILL-IN v-curcli IN FRAME page-1
   ALIGN-L                                                              */
ASSIGN 
       v-curcli:READ-ONLY IN FRAME page-1        = TRUE.

/* SETTINGS FOR FILL-IN v-date-close-period IN FRAME page-1
   ALIGN-L                                                              */
ASSIGN 
       v-date-close-period:READ-ONLY IN FRAME page-1        = TRUE.

/* SETTINGS FOR FILL-IN v-factorrt IN FRAME page-1
   ALIGN-L                                                              */
ASSIGN 
       v-factorrt:READ-ONLY IN FRAME page-1        = TRUE.

/* SETTINGS FOR FILL-IN v-inp_sum IN FRAME page-1
   ALIGN-L                                                              */
ASSIGN 
       v-inp_sum:READ-ONLY IN FRAME page-1        = TRUE.

/* SETTINGS FOR FILL-IN v-intprmvq IN FRAME page-1
   ALIGN-L                                                              */
ASSIGN 
       v-intprmvq:READ-ONLY IN FRAME page-1        = TRUE.

/* SETTINGS FOR FILL-IN v-is-bcdoc IN FRAME page-1
   ALIGN-L                                                              */
ASSIGN 
       v-is-bcdoc:READ-ONLY IN FRAME page-1        = TRUE.

/* SETTINGS FOR FILL-IN v-is-ov IN FRAME page-1
   ALIGN-L                                                              */
ASSIGN 
       v-is-ov:READ-ONLY IN FRAME page-1        = TRUE.

/* SETTINGS FOR FILL-IN v-minusprt IN FRAME page-1
   ALIGN-L                                                              */
ASSIGN 
       v-minusprt:READ-ONLY IN FRAME page-1        = TRUE.

/* SETTINGS FOR FILL-IN v-multdtyp IN FRAME page-1
   ALIGN-L                                                              */
ASSIGN 
       v-multdtyp:READ-ONLY IN FRAME page-1        = TRUE.

/* SETTINGS FOR FILL-IN v-noapndsc IN FRAME page-1
   ALIGN-L                                                              */
ASSIGN 
       v-noapndsc:READ-ONLY IN FRAME page-1        = TRUE.

/* SETTINGS FOR FILL-IN v-nocurbas IN FRAME page-1
   ALIGN-L                                                              */
ASSIGN 
       v-nocurbas:READ-ONLY IN FRAME page-1        = TRUE.

/* SETTINGS FOR FILL-IN v-part-prc IN FRAME page-1
   ALIGN-L                                                              */
ASSIGN 
       v-part-prc:READ-ONLY IN FRAME page-1        = TRUE.

/* SETTINGS FOR FILL-IN v-prc-exp IN FRAME page-1
   ALIGN-L                                                              */
ASSIGN 
       v-prc-exp:READ-ONLY IN FRAME page-1        = TRUE.

/* SETTINGS FOR FILL-IN v-proxycrd IN FRAME page-1
   ALIGN-L                                                              */
ASSIGN 
       v-proxycrd:READ-ONLY IN FRAME page-1        = TRUE.

/* SETTINGS FOR FILL-IN v-rnd-znk IN FRAME page-1
   ALIGN-L                                                              */
ASSIGN 
       v-rnd-znk:READ-ONLY IN FRAME page-1        = TRUE.

/* SETTINGS FOR FILL-IN v-slt-ext IN FRAME page-1
   ALIGN-L                                                              */
ASSIGN 
       v-slt-ext:READ-ONLY IN FRAME page-1        = TRUE.

/* SETTINGS FOR FILL-IN v-stfactdt IN FRAME page-1
   ALIGN-L                                                              */
ASSIGN 
       v-stfactdt:READ-ONLY IN FRAME page-1        = TRUE.

/* SETTINGS FOR FILL-IN v-type-slt IN FRAME page-1
   ALIGN-L                                                              */
ASSIGN 
       v-type-slt:READ-ONLY IN FRAME page-1        = TRUE.

/* SETTINGS FOR FILL-IN v-type-vat IN FRAME page-1
   ALIGN-L                                                              */
ASSIGN 
       v-type-vat:READ-ONLY IN FRAME page-1        = TRUE.

/* SETTINGS FOR FILL-IN v-vat-ext IN FRAME page-1
   ALIGN-L                                                              */
ASSIGN 
       v-vat-ext:READ-ONLY IN FRAME page-1        = TRUE.

/* SETTINGS FOR FILL-IN v-vat-sum IN FRAME page-1
   ALIGN-L                                                              */
ASSIGN 
       v-vat-sum:READ-ONLY IN FRAME page-1        = TRUE.

/* SETTINGS FOR FRAME page-2
                                                                        */
ASSIGN 
       attr-PN:READ-ONLY IN FRAME page-2        = TRUE.

ASSIGN 
       v-attr-PN:READ-ONLY IN FRAME page-2        = TRUE.

ASSIGN 
       v-back-date:READ-ONLY IN FRAME page-2        = TRUE.

ASSIGN 
       v-exc-max-qnty:READ-ONLY IN FRAME page-2        = TRUE.

ASSIGN 
       v-gtd-to-imp-prod:READ-ONLY IN FRAME page-2        = TRUE.

ASSIGN 
       v-inv-ship:READ-ONLY IN FRAME page-2        = TRUE.

ASSIGN 
       v-neg-ask:READ-ONLY IN FRAME page-2        = TRUE.

ASSIGN 
       v-not-ord:READ-ONLY IN FRAME page-2        = TRUE.

/* SETTINGS FOR FILL-IN v-reasonm IN FRAME page-2
   ALIGN-L                                                              */
ASSIGN 
       v-reasonm:READ-ONLY IN FRAME page-2        = TRUE.

ASSIGN 
       v-reasonme:READ-ONLY IN FRAME page-2        = TRUE.

ASSIGN 
       v-round-vat-sum:READ-ONLY IN FRAME page-2        = TRUE.

ASSIGN 
       v-vat-goods:READ-ONLY IN FRAME page-2        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON GO OF FRAME Dialog-Frame /* Настройки для накладных */
DO:
  run save-proc in this-procedure no-error.
  if error-status :error then return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Настройки для накладных */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-1
&Scoped-define SELF-NAME B-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-1 Dialog-Frame
ON CHOOSE OF B-1 IN FRAME page-1
DO:
  run gbl/v-taobj.w
      ({&attr-nakl_par},
       "date-close-period"
       ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-10 Dialog-Frame
ON CHOOSE OF B-10 IN FRAME page-1
DO:
  run gbl/v-taobj.w
      ({&attr-nakl_par},
       "inp_sum"
       ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-2
&Scoped-define SELF-NAME B-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-11 Dialog-Frame
ON CHOOSE OF B-11 IN FRAME page-2
DO:
  run gbl/v-taobj.w
      ({&attr-nakl_par},
       "reasonm"
       ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-12 Dialog-Frame
ON CHOOSE OF B-12 IN FRAME page-2
DO:
  run gbl/v-taobj.w
      ({&attr-nakl_par},
       "back-date"
       ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-13 Dialog-Frame
ON CHOOSE OF B-13 IN FRAME page-2
DO:
  run gbl/v-taobj.w
      ({&attr-nakl_par},
       "not-ord"
       ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-14 Dialog-Frame
ON CHOOSE OF B-14 IN FRAME page-2
DO:
  run gbl/v-taobj.w
      ({&attr-nakl_par},
       "reasonme"
       ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-15
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-15 Dialog-Frame
ON CHOOSE OF B-15 IN FRAME page-2
DO:
  run gbl/v-taobj.w
      ({&attr-nakl_par},
       "neg-ask"
       ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-16
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-16 Dialog-Frame
ON CHOOSE OF B-16 IN FRAME page-2
DO:
  run gbl/v-taobj.w
      ({&attr-nakl_par},
       "vat-goods"
       ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-17
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-17 Dialog-Frame
ON CHOOSE OF B-17 IN FRAME page-2
DO:
  run gbl/v-taobj.w
      ({&attr-nakl_par},
       "inv-ship"
       ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-18
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-18 Dialog-Frame
ON CHOOSE OF B-18 IN FRAME page-2
DO:
  run gbl/v-taobj.w
      ({&attr-nakl_par},
       "round-vat-sum"
       ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-19
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-19 Dialog-Frame
ON CHOOSE OF B-19 IN FRAME page-2
DO:
  run gbl/v-taobj.w
      ({&attr-nakl_par},
       "gtd-to-imp-prod"
       ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-1
&Scoped-define SELF-NAME B-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-2 Dialog-Frame
ON CHOOSE OF B-2 IN FRAME page-1
DO:
  run gbl/v-taobj.w
      ({&attr-nakl_par},
       "stfactdt"
       ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-2
&Scoped-define SELF-NAME B-20
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-20 Dialog-Frame
ON CHOOSE OF B-20 IN FRAME page-2
DO:
  run gbl/v-taobj.w
      ({&attr-nakl_par},
       "exc-max-qnty"
       ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-22
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-22 Dialog-Frame
ON CHOOSE OF B-22 IN FRAME page-2
DO:
  run gbl/v-taobj.w
      ({&attr-nakl_par},
       "attr-PN"
       ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-1
&Scoped-define SELF-NAME B-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-3 Dialog-Frame
ON CHOOSE OF B-3 IN FRAME page-1
DO:
  run gbl/v-taobj.w
      ({&attr-nakl_par},
       "intprmvq"
       ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-4 Dialog-Frame
ON CHOOSE OF B-4 IN FRAME page-1
DO:
  run gbl/v-taobj.w
      ({&attr-nakl_par},
       "minusprt"
       ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-5 Dialog-Frame
ON CHOOSE OF B-5 IN FRAME page-1
DO:
  run gbl/v-taobj.w
      ({&attr-nakl_par},
       "type-vat"
       ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-6 Dialog-Frame
ON CHOOSE OF B-6 IN FRAME page-1
DO:
  run gbl/v-taobj.w
      ({&attr-nakl_par},
       "type-slt"
       ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-7 Dialog-Frame
ON CHOOSE OF B-7 IN FRAME page-1
DO:
  run gbl/v-taobj.w
      ({&attr-nakl_par},
       "avail-on-date"
       ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-8 Dialog-Frame
ON CHOOSE OF B-8 IN FRAME page-1
DO:
  run gbl/v-taobj.w
      ({&attr-nakl_par},
       "factorrt"
       ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-9 Dialog-Frame
ON CHOOSE OF B-9 IN FRAME page-1
DO:
  run gbl/v-taobj.w
      ({&attr-nakl_par},
       "proxycrd"
       ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-2
&Scoped-define SELF-NAME B-ex
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-ex Dialog-Frame
ON CHOOSE OF B-ex IN FRAME page-2
DO:
  /**/
    run select-col-type in this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-set_attr-PN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-set_attr-PN Dialog-Frame
ON CHOOSE OF B-set_attr-PN IN FRAME page-2
DO:
  run select-attr-PN in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define SELF-NAME button-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL button-1 Dialog-Frame
ON CHOOSE OF button-1 IN FRAME Dialog-Frame /* Страница1 */
DO:
  HIDE FRAME page-2.
  VIEW FRAME page-1.
  button-1:LOAD-IMAGE-UP("adeicon\ts-up":U)        in frame {&frame-name} .
  button-2:LOAD-IMAGE-Up("adeicon\ts-down":U)      in frame {&frame-name} .
  F-button-1:fgcolor = 1   .
  f-button-2:fgcolor = ? .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME button-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL button-2 Dialog-Frame
ON CHOOSE OF button-2 IN FRAME Dialog-Frame /* Страница2 */
DO:
    HIDE FRAME page-1.
    VIEW FRAME page-2.

    button-2:LOAD-IMAGE-UP("adeicon\ts-up":U)        in frame {&frame-name} .
    button-1:LOAD-IMAGE-Up("adeicon\ts-down":U)      in frame {&frame-name} .
    F-button-2:fgcolor = 1   .
    f-button-1:fgcolor = ? .


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-2
&Scoped-define SELF-NAME I-attr-PN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-attr-PN Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-attr-PN IN FRAME page-2
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-1
&Scoped-define SELF-NAME I-avail-on-date
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-avail-on-date Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-avail-on-date IN FRAME page-1
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-2
&Scoped-define SELF-NAME I-back-date
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-back-date Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-back-date IN FRAME page-2
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-1
&Scoped-define SELF-NAME I-chk-prs
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-chk-prs Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-chk-prs IN FRAME page-1
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME I-convimp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-convimp Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-convimp IN FRAME page-1
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME I-curcli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-curcli Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-curcli IN FRAME page-1
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME I-date-close-period
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-date-close-period Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-date-close-period IN FRAME page-1
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-2
&Scoped-define SELF-NAME I-exc-max-qnty
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-exc-max-qnty Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-exc-max-qnty IN FRAME page-2
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-1
&Scoped-define SELF-NAME I-factorrt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-factorrt Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-factorrt IN FRAME page-1
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-2
&Scoped-define SELF-NAME I-gtd-to-imp-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-gtd-to-imp-prod Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-gtd-to-imp-prod IN FRAME page-2
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-1
&Scoped-define SELF-NAME I-inp_sum
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-inp_sum Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-inp_sum IN FRAME page-1
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME I-intprmvq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-intprmvq Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-intprmvq IN FRAME page-1
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-2
&Scoped-define SELF-NAME I-inv-ship
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-inv-ship Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-inv-ship IN FRAME page-2
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-1
&Scoped-define SELF-NAME I-is-bcdoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-is-bcdoc Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-is-bcdoc IN FRAME page-1
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME I-is-ov
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-is-ov Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-is-ov IN FRAME page-1
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME I-minusprt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-minusprt Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-minusprt IN FRAME page-1
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME I-multdtyp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-multdtyp Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-multdtyp IN FRAME page-1
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-2
&Scoped-define SELF-NAME I-neg-ask
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-neg-ask Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-neg-ask IN FRAME page-2
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-1
&Scoped-define SELF-NAME I-noapndsc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-noapndsc Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-noapndsc IN FRAME page-1
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME I-nocurbas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-nocurbas Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-nocurbas IN FRAME page-1
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-2
&Scoped-define SELF-NAME I-not-ord
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-not-ord Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-not-ord IN FRAME page-2
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-1
&Scoped-define SELF-NAME I-part-prc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-part-prc Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-part-prc IN FRAME page-1
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME I-prc-exp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-prc-exp Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-prc-exp IN FRAME page-1
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME I-proxycrd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-proxycrd Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-proxycrd IN FRAME page-1
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-2
&Scoped-define SELF-NAME I-reasonm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-reasonm Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-reasonm IN FRAME page-2
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME I-reasonme
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-reasonme Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-reasonme IN FRAME page-2
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-1
&Scoped-define SELF-NAME I-rnd-znk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-rnd-znk Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-rnd-znk IN FRAME page-1
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-2
&Scoped-define SELF-NAME I-round-vat-sum
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-round-vat-sum Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-round-vat-sum IN FRAME page-2
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-1
&Scoped-define SELF-NAME I-slt-ext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-slt-ext Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-slt-ext IN FRAME page-1
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME I-stfactdt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-stfactdt Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-stfactdt IN FRAME page-1
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME I-type-slt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-type-slt Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-type-slt IN FRAME page-1
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME I-type-vat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-type-vat Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-type-vat IN FRAME page-1
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME I-vat-ext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-vat-ext Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-vat-ext IN FRAME page-1
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-2
&Scoped-define SELF-NAME I-vat-goods
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-vat-goods Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-vat-goods IN FRAME page-2
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME page-1
&Scoped-define SELF-NAME I-vat-sum
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL I-vat-sum Dialog-Frame
ON MOUSE-SELECT-CLICK OF I-vat-sum IN FRAME page-1
DO:
  MESSAGE {&SELF-NAME}:private-data  VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME Dialog-Frame
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

{ gbl/app_help.i }
{ gbl/ed_date.i date-close-period " in frame page-1 "}
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

if p-obj-type <> "" then
   frame {&frame-name}:title = frame {&frame-name}:title + (if p-obj-type = {&cmp} then " фирма" else " маг") + string(p-obj-code) .

define variable loc#log as logical   no-undo .
/* Проверка прав */
  { gbl/chk-actg.i
    g#db-num
    g#userid
    {&action-head-code-main}
    'actn_nakl-par_lookup':U
    {&cntxt-object}
    v-cntxt-host-code-obj
    v-cntxt-obj-type
    v-cntxt-obj-code
    0
    0
    0
    true
    loc#log
  }
   if loc#log <> yes then do: return error. end.
    run init-tt.
    RUN proc-init-EX.
    RUN proc-init-attr-PN.
    run enable_UI.
    run init-proc.
    apply "choose" to button-1 .

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
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
  HIDE FRAME page-1.
  HIDE FRAME page-2.
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
  DISPLAY F-button-1 F-button-2 
      WITH FRAME Dialog-Frame.
  ENABLE B-exit B-quit B-Help button-1 RECT-3 button-2 F-button-1 F-button-2 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
  DISPLAY date-close-period stfactdt intprmvq minusprt part-prc curcli 
          avail-on-date nocurbas rnd-znk chk-prs convimp noapndsc is-bcdoc is-ov 
          proxycrd vat-sum type-vat vat-ext type-slt slt-ext multdtyp prc-exp 
          factorrt inp_sum v-date-close-period v-stfactdt v-intprmvq v-minusprt 
          v-part-prc v-curcli v-avail-on-date v-nocurbas v-rnd-znk v-chk-prs 
          v-convimp v-noapndsc v-is-bcdoc v-is-ov v-proxycrd v-vat-sum 
          v-type-vat v-vat-ext v-type-slt v-slt-ext v-multdtyp v-prc-exp 
          v-factorrt v-inp_sum 
      WITH FRAME page-1.
  ENABLE B-1 date-close-period I-date-close-period I-stfactdt I-intprmvq 
         I-minusprt I-part-prc I-curcli I-avail-on-date I-nocurbas I-chk-prs 
         I-rnd-znk I-convimp I-noapndsc I-is-bcdoc I-is-ov I-proxycrd I-vat-sum 
         I-type-vat I-vat-ext I-type-slt I-slt-ext I-multdtyp I-prc-exp 
         I-factorrt I-inp_sum B-2 stfactdt B-3 intprmvq B-4 minusprt part-prc 
         curcli B-7 avail-on-date nocurbas rnd-znk chk-prs convimp noapndsc 
         is-bcdoc is-ov B-9 proxycrd vat-sum B-5 type-vat vat-ext B-6 type-slt 
         slt-ext multdtyp prc-exp B-8 factorrt B-10 inp_sum v-date-close-period 
         v-stfactdt v-intprmvq v-minusprt v-part-prc v-curcli v-avail-on-date 
         v-nocurbas v-rnd-znk v-chk-prs v-convimp v-noapndsc v-is-bcdoc v-is-ov 
         v-proxycrd v-vat-sum v-type-vat v-vat-ext v-type-slt v-slt-ext 
         v-multdtyp v-prc-exp v-factorrt v-inp_sum 
      WITH FRAME page-1.
  {&OPEN-BROWSERS-IN-QUERY-page-1}
  DISPLAY reasonm back-date not-ord neg-ask vat-goods inv-ship round-vat-sum 
          gtd-to-imp-prod exc-max-qnty attr-PN v-reasonm v-reasonme reasonme 
          v-back-date v-not-ord v-neg-ask v-vat-goods v-inv-ship v-round-vat-sum 
          v-gtd-to-imp-prod v-exc-max-qnty v-attr-PN 
      WITH FRAME page-2.
  ENABLE I-reasonm I-back-date I-not-ord I-reasonme I-neg-ask I-vat-goods 
         I-inv-ship I-round-vat-sum I-gtd-to-imp-prod I-exc-max-qnty I-attr-PN 
         B-11 reasonm B-14 B-ex back-date B-12 B-13 not-ord B-15 neg-ask B-16 
         vat-goods B-17 inv-ship B-18 round-vat-sum B-19 gtd-to-imp-prod B-20 
         exc-max-qnty B-22 B-set_attr-PN attr-PN v-reasonm v-reasonme reasonme 
         v-back-date v-not-ord v-neg-ask v-vat-goods v-inv-ship v-round-vat-sum 
         v-gtd-to-imp-prod v-exc-max-qnty v-attr-PN 
      WITH FRAME page-2.
  {&OPEN-BROWSERS-IN-QUERY-page-2}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fill-widgets Dialog-Frame 
PROCEDURE fill-widgets :
define variable v-value-character as character no-undo .
define variable v-value-date as date no-undo .
define variable v-value-decimal as decimal no-undo .
define variable v-value-integer as INTEGER no-undo .
define variable v-value-logical AS LOGICAL no-undo .
define variable v-param-type as character no-undo .
define variable v-param-value as character no-undo .

for each thbjattr_thbj-attr:
  delete thbjattr_thbj-attr.
end.
for each thbjattr_thbj-attr-g:
  delete thbjattr_thbj-attr-g.
end.


for each temp-thbj-attr:
  delete temp-thbj-attr.
end.

run adm/shattri.p (
    input "init":U
  , input p-obj-type
  , input p-obj-code
  , input {&attr-nakl_par}
  , input "":U
  , output v-value-character
  , output v-value-date
  , output v-value-decimal
  , output v-value-integer
  , output v-value-logical
  , output v-param-type
  , input-output TABLE-HANDLE v-tth
  ) no-error .
if error-status:error then do:
  message
  "Не удалось получить начальные значения настроек" skip
  error-status:get-message(1) return-value
  view-as alert-box error .
  undo, return error .
end.

run adm/shattri.p (
    input "init":U
  , input ""
  , input 0
  , input {&attr-nakl-glob}
  , input "":U
  , output v-value-character
  , output v-value-date
  , output v-value-decimal
  , output v-value-integer
  , output v-value-logical
  , output v-param-type
  , input-output TABLE-HANDLE v-tthg
  ) no-error .
if error-status:error then do:
  message
  "Не удалось получить начальные значения настроек" skip
  error-status:get-message(1) return-value
  view-as alert-box error .
  undo, return error .
end.


&scop telo1  IF thbjattr_thbj-attr.prop-code = ~{&attr-nakl_par_~{&pole~}~} THEN DO: ~
    ~{&pole~} = thbjattr_thbj-attr.property-value-~{&type~}. ~
    ~{&pole~}:private-data in frame page-~{&n-page~} = "recid2=" + string(recid(thbjattr_thbj-attr)). ~
    display ~{&pole~} with frame page-~{&n-page~} . ~
END.

&scop telo1g  IF thbjattr_thbj-attr-g.prop-code = ~{&attr-nakl-glob_~{&pole~}~} THEN DO: ~
    ~{&pole~} = thbjattr_thbj-attr-g.property-value-~{&type~}. ~
    ~{&pole~}:private-data in frame page-~{&n-page~} = "recid3=" + string(recid(thbjattr_thbj-attr-g)). ~
    display ~{&pole~} with frame page-~{&n-page~} . ~
END.


FOR EACH thbjattr_thbj-attr-g
:
&scop n-page 1
&scop pole nocurbas
&scop type character
{&telo1g}

&scop n-page 1
&scop pole chk-prs
&scop type logical
{&telo1g}

&scop n-page 1
&scop pole convimp
&scop type logical
{&telo1g}

&scop n-page 1
&scop pole curcli
&scop type logical
{&telo1g}

&scop n-page 1
&scop pole is-bcdoc
&scop type logical
{&telo1g}

&scop n-page 1
&scop pole is-ov
&scop type logical
{&telo1g}

&scop n-page 1
&scop pole multdtyp
&scop type logical
{&telo1g}

&scop n-page 1
&scop pole noapndsc
&scop type logical
{&telo1g}

&scop n-page 1
&scop pole part-prc
&scop type logical
{&telo1g}

&scop n-page 1
&scop pole prc-exp
&scop type decimal
{&telo1g}

&scop n-page 1
&scop pole rnd-znk
&scop type integer
{&telo1g}

&scop n-page 1
&scop pole slt-ext
&scop type character
{&telo1g}

&scop n-page 1
&scop pole vat-ext
&scop type character
{&telo1g}

&scop n-page 1
&scop pole vat-sum
&scop type logical
{&telo1g}


create temp-thbj-attr.
buffer-copy thbjattr_thbj-attr-g to temp-thbj-attr.


end.


FOR EACH thbjattr_thbj-attr
:
&scop n-page 1
&scop pole date-close-period
&scop type date
{&telo1}

&scop n-page 1
&scop pole stfactdt
&scop type logical
{&telo1}

&scop n-page 1
&scop pole intprmvq
&scop type logical
{&telo1}

&scop n-page 1
&scop pole minusprt
&scop type logical
{&telo1}

&scop n-page 1
&scop pole type-vat
&scop type integer
{&telo1}

&scop n-page 1
&scop pole type-slt
&scop type integer
{&telo1}

&scop n-page 1
&scop pole avail-on-date
&scop type logical
{&telo1}

&scop n-page 1
&scop pole inp_sum
&scop type logical
{&telo1}

&scop n-page 1
&scop pole factorrt
&scop type decimal
{&telo1}

&scop n-page 1
&scop pole proxycrd
&scop type logical
{&telo1}

&scop n-page 2
&scop pole reasonm
&scop type logical
{&telo1}

&scop n-page 2
&scop pole reasonme
&scop type character
{&telo1}

&scop n-page 2
&scop pole back-date
&scop type logical
{&telo1}

&scop n-page 2
&scop pole not-ord
&scop type logical
{&telo1}

&scop n-page 2
&scop pole neg-ask
&scop type logical
{&telo1}

&scop n-page 2
&scop pole vat-goods
&scop type logical
{&telo1}

&scop n-page 2
&scop pole inv-ship
&scop type logical
{&telo1}

&scop n-page 2
&scop pole round-vat-sum
&scop type logical
{&telo1}

&scop n-page 2
&scop pole gtd-to-imp-prod
&scop type logical
{&telo1}

&scop n-page 2
&scop pole exc-max-qnty
&scop type logical
{&telo1}

&scop n-page 2
&scop pole attr-PN
&scop type character
{&telo1}

  create temp-thbj-attr.
  buffer-copy thbjattr_thbj-attr to temp-thbj-attr.

END.


define variable v-tooltip as character no-undo .
define variable v-label   as character no-undo .
define variable v-tooltip-code as character no-undo .

&scop telo2 run thbjattr_tooltip in this-procedure ( ~
   input   {&attr-nakl_par} ~
  ,input  "~{&pole~}" ~
  ,output v-tooltip ~
  ,output v-label ~
  ,output v-tooltip-code ~
  ) no-error . ~
v-~{&pole~}:screen-value = REPLACE ( entry(2,v-label,":") , "`" , "," ) .  ~
I-~{&pole~}:private-data = REPLACE ( v-tooltip-code , "`" , "," ) .

&scop telo2g run thbjattr_tooltip in this-procedure ( ~
   input   {&attr-nakl-glob} ~
  ,input  "~{&pole~}" ~
  ,output v-tooltip ~
  ,output v-label ~
  ,output v-tooltip-code ~
  ) no-error . ~
v-~{&pole~}:screen-value = REPLACE ( entry(2,v-label,":") , "`" , "," ) .  ~
I-~{&pole~}:private-data = REPLACE ( v-tooltip-code , "`" , "," ) .

&scop pole date-close-period
{&telo2}

&scop pole stfactdt
{&telo2}

&scop pole type-vat
{&telo2}

&scop pole type-slt
{&telo2}

&scop pole intprmvq
{&telo2}

&scop pole minusprt
{&telo2}

&scop pole avail-on-date
{&telo2}


&scop pole inp_sum
{&telo2}

&scop pole factorrt
{&telo2}

&scop pole proxycrd
{&telo2}

&scop pole nocurbas
{&telo2g}

&scop pole chk-prs
{&telo2g}

&scop pole convimp
{&telo2g}

&scop pole curcli
{&telo2g}

&scop pole is-bcdoc
{&telo2g}

&scop pole is-ov
{&telo2g}

&scop pole multdtyp
{&telo2g}

&scop pole noapndsc
{&telo2g}

&scop pole part-prc
{&telo2g}

&scop pole prc-exp
{&telo2g}

&scop pole rnd-znk
{&telo2g}

&scop pole slt-ext
{&telo2g}

&scop pole vat-ext
{&telo2g}

&scop pole vat-sum
{&telo2g}

&scop pole reasonm
{&telo2}

&scop pole reasonme
{&telo2}


&scop pole back-date
{&telo2}

&scop pole not-ord
{&telo2}

&scop pole neg-ask
{&telo2}

&scop pole vat-goods
{&telo2}

&scop pole inv-ship
{&telo2}

&scop pole round-vat-sum
{&telo2}

&scop pole gtd-to-imp-prod
{&telo2}

&scop pole exc-max-qnty
{&telo2}

&scop pole attr-PN
{&telo2}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-proc Dialog-Frame 
PROCEDURE init-proc :
define variable v-i as integer   no-undo .
define variable v-value-character as character no-undo .
define variable v-value-date as date no-undo .
define variable v-value-decimal as decimal no-undo .
define variable v-value-integer as INTEGER no-undo .
define variable v-value-logical AS LOGICAL no-undo .
define variable v-type as character no-undo .
define variable v-value as character no-undo .
define variable v-found as decimal   no-undo .
  if p-mode = {&update} then do:
    find first obj_thbj-attr exclusive-lock where
              obj_thbj-attr.obj-type = p-obj-type
        and   obj_thbj-attr.obj-code = p-obj-code
        and   obj_thbj-attr.upper-prop-code = {&attr-nakl_par}
        and   obj_thbj-attr.prop-code = '':u no-wait no-error.
     if locked obj_thbj-attr then do:
        message
        vss-workfile vss-revision vss-description skip
        {&attr-nakl_par} skip
        "Запись ПАРАМЕТРОВ  занята"
        view-as alert-box error .
        undo, return error.
      end.
    find first glb_thbj-attr exclusive-lock where
              glb_thbj-attr.obj-type = ""
        and   glb_thbj-attr.obj-code = 0
        and   glb_thbj-attr.upper-prop-code = {&attr-nakl-glob}
        and   glb_thbj-attr.prop-code = '':u no-wait no-error.
     if locked glb_thbj-attr then do:
        message
        vss-workfile vss-revision vss-description skip
        {&attr-nakl-glob} skip
        "Запись Глобальных ПАРАМЕТРОВ  занята"
        view-as alert-box error .
        undo, return error.
      end.

  end.
  else do:
    find first obj_thbj-attr no-lock where
          obj_thbj-attr.obj-type = p-obj-type
    and   obj_thbj-attr.obj-code = p-obj-code
    and   obj_thbj-attr.upper-prop-code = {&attr-nakl_par}
    and   obj_thbj-attr.prop-code = '':u no-error.
    find first glb_thbj-attr no-lock where
          glb_thbj-attr.obj-type = ""
    and   glb_thbj-attr.obj-code = 0
    and   glb_thbj-attr.upper-prop-code = {&attr-nakl-glob}
    and   glb_thbj-attr.prop-code = '':u no-error.

  end.
  if not available obj_thbj-attr then do:
    assign
      v-to-create-trn  = true
      .
    message
    substitute ("Внимание!!!&1Секции по объекту НЕТ в БД!&1Будут показаны ЗНАЧЕНИЯ ПО УМОЛЧАНИЮ",
                {&new-line})
                 view-as alert-box warning.

  end.

  if not available glb_thbj-attr then do:
    assign
      v-to-create-trn-g  = true
      .
    message
    substitute ("Внимание!!!&1Секции Гл.Параметров НЕТ в БД!&1Будут показаны ЗНАЧЕНИЯ ПО УМОЛЧАНИЮ",
                {&new-line})
                 view-as alert-box warning.

  end.

  run fill-widgets in this-procedure no-error.
  if error-status:error then undo, return error.
  if p-mode <> {&update} then do:
     disable
     date-close-period
     stfactdt
     type-vat
     type-slt
     intprmvq
     minusprt
     avail-on-date
     inp_sum
     factorrt
     proxycrd
     nocurbas
     chk-prs
     convimp
     curcli
     is-bcdoc
     is-ov
     multdtyp
     noapndsc
     part-prc
     prc-exp
     rnd-znk
     slt-ext
     vat-ext
     vat-sum
     with frame page-1 .
     disable
     reasonm
     reasonme
     back-date
     not-ord
     neg-ask
     vat-goods
     inv-ship
     round-vat-sum
     gtd-to-imp-prod
     exc-max-qnty
     attr-PN
     with frame page-2 .

     B-exit:label in frame {&frame-name}  = "Вы&ход"  .
     hide B-quit in frame {&frame-name} .
  END.
  if not ( p-obj-type = "" and p-obj-code = 0 ) then do:
     disable
       nocurbas
       chk-prs
       convimp
       curcli
       is-bcdoc
       is-ov
       multdtyp
       noapndsc
       part-prc
       prc-exp
       rnd-znk
       slt-ext
       vat-ext
       vat-sum
     with frame page-1.
  end.
  hide attr-PN in frame page-2 .
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-tt Dialog-Frame 
PROCEDURE init-tt :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-init-attr-PN Dialog-Frame 
PROCEDURE proc-init-attr-PN :
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/



   assign
      v-list-attr-PN      = {&trdcattr-nids} + "," + {&trdcattr-dids} + "," + {&trdcattr-nsf} + "," + {&trdcattr-dsf} + "," + {&trdcattr-expense_own} + "," + {&trdcattr-ndog} + ","
      + {&trdcattr-ddog} + "," + {&trdcattr-ndov} + "," + {&trdcattr-ddov} + "," + {&trdcattr-print-num} + "," + {&trdcattr-idCountryContr} + "," + {&trdcattr-car-time} +
      "," + {&trdcattr-t_pass-fname} + "," + {&trdcattr-t_pass-position} + "," + {&trdcattr-t_accept-fname} + "," + {&trdcattr-t_accept-position} + "," +
      {&trdcattr-ndovwho} + "," + {&trdcattr-nosn} + "," + {&trdcattr-shipper}.
      v-list-attr-PN-full = {&label-trdcattr-nids} + "," + {&label-trdcattr-dids} + "," + {&label-trdcattr-nsf} + "," + {&label-trdcattr-dsf} + "," + {&label-trdcattr-expense_own} + "," + {&label-trdcattr-ndog} + ","
      + {&label-trdcattr-ddog} + "," + {&label-trdcattr-ndov} + "," + {&label-trdcattr-ddov} + "," + {&label-trdcattr-print-num} + "," + {&label-trdcattr-idCountryContr} + "," + {&label-trdcattr-car-time} +
      "," + {&label-trdcattr-t_pass-fname} + "," + {&label-trdcattr-t_pass-position} + "," + {&label-trdcattr-t_accept-fname} + "," + {&label-trdcattr-t_accept-position} + "," +
      {&label-trdcattr-ndovwho} + "," + {&label-trdcattr-nosn} + "," + {&label-trdcattr-shipper}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-init-EX Dialog-Frame 
PROCEDURE proc-init-EX :
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/

   assign
      v-list-edt      = {&TDEDT_List-ov}
      v-list-edt-full = {&TDEDT_List-ov-full}
   .


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE save-proc Dialog-Frame 
PROCEDURE save-proc :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
define variable v-value-character as character no-undo .
define variable v-value-date as date no-undo .
define variable v-value-decimal as decimal no-undo .
define variable v-value-integer as INTEGER no-undo .
define variable v-value-logical AS LOGICAL no-undo .
define variable v-sale-add as character no-undo .
define variable v-trf-type like ub.clients.obj-type no-undo .
define variable v-trf-code like ub.clients.obj-code no-undo .
define variable v-param-type as character no-undo .
define variable wh as widget-handle no-undo .
define variable fh as widget-handle no-undo .
define variable fh2 as widget-handle no-undo .
define variable v-same as logical no-undo .
define variable v-sameg as logical no-undo .
IF p-mode = {&LOOKUP} THEN RETURN .
define variable loc#log as logical   no-undo .
/* Проверка прав */
  { gbl/chk-actg.i
    g#db-num
    g#userid
    {&action-head-code-main}
    'actn_nakl-par_update':U
    {&cntxt-object}
    v-cntxt-host-code-obj
    v-cntxt-obj-type
    v-cntxt-obj-code
    0
    0
    0
    true
    loc#log
  }
  if loc#log <> yes then do: return error. end.

ASSIGN
    date-close-period FRAME page-1
    stfactdt
    type-vat
    type-slt
    intprmvq
    minusprt
    avail-on-date
    inp_sum
    factorrt
    proxycrd
    nocurbas
    chk-prs
    convimp
    curcli
    is-bcdoc
    is-ov
    multdtyp
    noapndsc
    part-prc
    prc-exp
    rnd-znk
    slt-ext
    vat-ext
    vat-sum
 .

 assign frame page-2
    reasonm
    reasonme
    back-date
    not-ord
    neg-ask
    vat-goods
    attr-PN
    .


assign
  fh = frame page-1:first-child
  fh2 = frame page-2:first-child

  .

define variable v-ind as integer   no-undo .
define variable v-num-entries as integer   no-undo .
define variable v-str as character no-undo .

v-str = string(fh:first-child) + "," + string(fh2:first-child) .
v-num-entries = num-entries (v-str) .

do v-ind = 1 to v-num-entries :
  wh  = widget-handle (entry(v-ind , v-str )) no-error .
  do while valid-handle(wh):
    if wh:private-data begins "recid2=" then do:

      find first thbjattr_thbj-attr where
                recid(thbjattr_thbj-attr) = integer(entry(2, wh:private-data, '='))
                no-error .
      if available thbjattr_thbj-attr then do:
      assign
          buffer thbjattr_thbj-attr:buffer-field("property-value-" + wh:data-type):buffer-value = wh:input-value
          .
      end.
    end.
    if wh:private-data begins "recid3=" then do:

      find first thbjattr_thbj-attr-g where
                recid(thbjattr_thbj-attr-g) = integer(entry(2, wh:private-data, '='))
                no-error .
      if available thbjattr_thbj-attr-g then do:
      assign
      buffer thbjattr_thbj-attr-g:buffer-field("property-value-" + wh:data-type):buffer-value = wh:input-value.
      end.
    end.


    wh = wh:next-sibling.
  end.
end.
v-same = yes.
for each thbjattr_thbj-attr where
         thbjattr_thbj-attr.obj-type = p-obj-type and
         thbjattr_thbj-attr.obj-code = p-obj-code ,
    first temp-thbj-attr where
          temp-thbj-attr.obj-type = p-obj-type
      and temp-thbj-attr.obj-code = p-obj-code
      and temp-thbj-attr.upper-prop-code = thbjattr_thbj-attr.upper-prop-code
      and temp-thbj-attr.prop-code = thbjattr_thbj-attr.prop-code :
   buffer-compare
   thbjattr_thbj-attr
   to temp-thbj-attr
   save result in v-same.
   if not v-same then leave.
end.

v-same = no.
v-sameg = yes.
for each thbjattr_thbj-attr-g ,
    first temp-thbj-attr where
          temp-thbj-attr.obj-type = ""
      and temp-thbj-attr.obj-code = 0
      and temp-thbj-attr.upper-prop-code = thbjattr_thbj-attr-g.upper-prop-code
      and temp-thbj-attr.prop-code = thbjattr_thbj-attr-g.prop-code :
   buffer-compare
   thbjattr_thbj-attr-g
   to temp-thbj-attr
   save result in v-sameg.
   if not v-sameg then leave.
end.

v-sameg = no.

do transaction
on error undo, return error return-value
:

  run thbjattr_set-section in this-procedure (
        input p-obj-type
      , input p-obj-code
      , input {&attr-nakl_par}
      , input table thbjattr_thbj-attr
  ) no-error.
  if error-status:error then do:
    message error-status:get-message(1)  skip
    return-value
    view-as alert-box.
    undo, return error.
  end.
  if p-obj-type = "" and p-obj-code = 0  then do:
      run thbjattr_set-section in this-procedure (
            input p-obj-type
          , input p-obj-code
          , input {&attr-nakl-glob}
          , input table thbjattr_thbj-attr-g
      ) no-error.
      if error-status:error then do:
        message error-status:get-message(1)  skip
        return-value
        view-as alert-box.
        undo, return error.
      end.
  end.

end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE select-attr-PN Dialog-Frame 
PROCEDURE select-attr-PN :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

define variable v-counter       as integer      no-undo.
define variable v-label         as character    no-undo.
define variable v-value         as character    no-undo.
define variable v-list          as character    no-undo.
define variable v-changed       as logical    no-undo.
define variable v-accepted      as logical    no-undo.
define variable V-EX as logical   no-undo .
define variable v-mode          as integer      no-undo .

do
with frame {&frame-name}
on error undo, return error
:
if p-mode = {&lookup} then v-mode = 0 .
else v-mode = 1 .

    run twowin_clear in this-procedure.

    do v-counter = 1 to num-entries( v-list-attr-PN-full )
    on error undo, return error
    :
        assign
            v-label = entry( v-counter, v-list-attr-PN-full )
            v-value = entry( v-counter, v-list-attr-PN )
            v-ex = false
        .
           if  lookup (v-value , attr-PN ) > 0 then  v-ex = true .
           else v-ex = false .
        run twowin_add-item in this-procedure (
              input v-value
            , input v-label
            , input substitute( "Атрибуты: &1", v-VALUE)
            , input  V-EX
        ).
    end.        /* do */
    run gbl/twowin.w (
          input ?
        , input v-mode
        , input "Выбор атрибутов ПН":U
        , input "":U
        , input "&Тест"
        , input table temp_twowin_items
        , output table temp_twowin_itemsSelected_col
        , output v-changed
        , output v-accepted
    ).
    if v-changed then do:
        attr-PN = "" .
        for each temp_twowin_itemsSelected_col :
        attr-PN = attr-PN +  temp_twowin_itemsSelected_col.itmExtKey + "," .
        end.
        attr-PN = trim(attr-PN, ",") .
        display attr-PN with frame page-2 .
        hide attr-PN in frame page-2 .
    end.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE select-col-type Dialog-Frame 
PROCEDURE select-col-type :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

define variable v-counter       as integer      no-undo.
define variable v-label         as character    no-undo.
define variable v-value         as character    no-undo.
define variable v-list          as character    no-undo.
define variable v-changed       as logical    no-undo.
define variable v-accepted      as logical    no-undo.
define variable V-EX as logical   no-undo .

do
with frame {&frame-name}
on error undo, return error
:
    run twowin_clear in this-procedure.

    do v-counter = 1 to num-entries( v-list-edt-full )
    on error undo, return error
    :
        assign
            v-label = entry( v-counter, v-list-edt-full )
            v-value = entry( v-counter, v-list-edt )
            v-ex = false
        .
           if  lookup (v-value , reasonme ) > 0 then  v-ex = true .
           else v-ex = false .
        run twowin_add-item in this-procedure (
              input v-value
            , input v-label
            , input substitute( "Документ: &1", v-VALUE)
            , input  V-EX
        ).
    end.        /* do */
    run gbl/twowin.w (
          input ?
        , input 1
        , input "Выбор ДОКУМЕНТОВ - ИСКЛЮЧЕНИЙ":U
        , input "":U
        , input "&Тест"
        , input table temp_twowin_items
        , output table temp_twowin_itemsSelected_col
        , output v-changed
        , output v-accepted
    ).
    if v-changed then do:
        reasonme = "" .
        for each temp_twowin_itemsSelected_col :
        reasonme = reasonme +  temp_twowin_itemsSelected_col.itmExtKey + "," .
        end.
        reasonme = trim(reasonme, ",") .
        display reasonme with frame page-2 .
    end.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

