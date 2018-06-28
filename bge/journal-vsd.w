&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          ub               PROGRESS
*/
USING ibs.th.str.gds.*.
USING ibs.th.str.mercury.*.
USING ibs.th.gbl.storage.*.
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttvsd NO-UNDO LIKE vsd
       FIELD dateTTH      AS DATE  /*  "Номер ТТН"              "X(20)" */
       FIELD NomTTH       AS CHAR  /*  "Номер ТТН"              "X(20)" */
       FIELD NomTTHpost   AS CHAR  /*  "Номер ТТН поставщика"   "X(20)" */
       FIELD NomAZS       AS CHAR  /*  "№ АЗС"                  ?  */
       FIELD Post         AS CHAR  /*  "Поставщик"              "X(20)" */
       FIELD artic        AS CHAR  /*  "Артикул товара"         "X(20)" */
       FIELD gdsname      AS CHAR  /*  "Наименование товара"    "X(30)" */
       FIELD prod-code    AS CHAR  /*  "Производитель"          "X(20)" */
       FIELD COLobj       AS DEC   /*  "Кол-во факт"            "X(15)" */
       FIELD unit-cli     AS CHAR  /*  "Ед.изм."                "X(6)" */
       FIELD unit-base     AS CHAR  /*  "Ед.изм."                "X(6)" */
       /*FIELD UUID         AS CHAR    "Номер ВСД"              "X(40)" */
       FIELD statusvsd    AS CHAR  /*  "Статус ВСД"             "X(20)" */
       FIELD ojd          AS DEC   /*  "Ожидает гашения"        "X(20)" */
       FIELD gdsmercguid  AS CHAR  /*  Guid merc                "X(40)" */
       FIELD vsdtypelbl   AS CHAR  /*  Guid merc                "X(40)" */.



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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Журнал ВСД

Автор: Рубан Дмитрий Андреевич
Дата создания: 30.05.2018
Author: Dmitriy Ruban
Creation date: 30/05/18

*/
DEFINE VARIABLE vss-revision          AS CHARACTER NO-UNDO INIT "$Revision$":U .
DEFINE VARIABLE vss-author            AS CHARACTER NO-UNDO INIT "$Author$":U .
DEFINE VARIABLE vss-date              AS CHARACTER NO-UNDO INIT "$Date$":U .
DEFINE VARIABLE vss-workfile          AS CHARACTER NO-UNDO INIT "$Workfile$":U .
DEFINE VARIABLE vss-archive           AS CHARACTER NO-UNDO INIT "$Archive$":U .
DEFINE VARIABLE vss-description       AS CHARACTER NO-UNDO INIT "Журнал ВСД". 
DEFINE VARIABLE v-object-available    AS LOGICAL   NO-UNDO .

DEFINE VARIABLE v-bge-dper-host-code  AS INTEGER   NO-UNDO.
DEFINE VARIABLE v-bge-dper-store-type AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-bge-dper-store-code AS INTEGER   NO-UNDO.

DEFINE VARIABLE v-host-name           AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER parparentproc        AS HANDLE               NO-UNDO.
/* Local Variable Definitions ---                                       */
{ cmp/vssrevis.i }     
{ cmp/showinf.i  }
{ cmp/library.i  }
{ cmp/str-glbl.i }
{ gbl/getcntxt.i def }
{ gbl/prn-lib.i   }
{ gbl/userobjs.i }
{ bge/ds-vsd-set.i }
DEFINE STREAM OutStr-html.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME BROWSE-VSD

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttvsd

/* Definitions for BROWSE BROWSE-VSD                                    */
&Scoped-define FIELDS-IN-QUERY-BROWSE-VSD ttvsd.dateTTH ttvsd.NomTTH ~
ttvsd.NomAZS ttvsd.artic ttvsd.UUID ttvsd.vsdtypelbl ttvsd.statusvsd ~
ttvsd.NomTTHpost ttvsd.Post ttvsd.gdsname ttvsd.prod-code ttvsd.COLobj ~
ttvsd.unit-cli ttvsd.unit-base ttvsd.ojd 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-VSD 
&Scoped-define QUERY-STRING-BROWSE-VSD FOR EACH ttvsd NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-VSD OPEN QUERY BROWSE-VSD FOR EACH ttvsd NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-VSD ttvsd
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-VSD ttvsd


/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Dialog-Frame ~
    ~{&OPEN-QUERY-BROWSE-VSD}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 Btn_Cancel btn_edit ~
Btn_lookup btn_prn RECT-4 vTime v-date-start v-date-end btRef btFilt ~
vReqVerif vFalVerif vToExtin vFalExting vRep BROWSE-VSD Btn_gds btn_merc ~
btn_trndoc 
&Scoped-Define DISPLAYED-FIELDS ttvsd.gds-code ttvsd.gdsname ~
ttvsd.gdsmercguid ttvsd.gds-name-merc ttvsd.gds-guid ttvsd.NomTTH ~
ttvsd.msg-err 
&Scoped-define DISPLAYED-TABLES ttvsd
&Scoped-define FIRST-DISPLAYED-TABLE ttvsd
&Scoped-Define DISPLAYED-OBJECTS vTime v-date-start v-date-end vReqVerif ~
vFalVerif vToExtin vFalExting vRep 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btFilt 
     LABEL "Расшир. фильтр" 
     SIZE 15 BY 1.13.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Выход" 
     SIZE 15 BY 1.13
     BGCOLOR 8 .

DEFINE BUTTON btn_edit 
     LABEL "Изменить" 
     SIZE 15 BY 1.13
     BGCOLOR 8 .

DEFINE BUTTON Btn_gds 
     IMAGE-UP FILE "cmp/btn-fnd.bmp":U
     IMAGE-DOWN FILE "cmp/btn-fnd.bmp":U
     IMAGE-INSENSITIVE FILE "cmp/btn-fnd.bmp":U NO-CONVERT-3D-COLORS
     LABEL "" 
     SIZE 3 BY 1 TOOLTIP "Карточка товара".

DEFINE BUTTON Btn_lookup 
     LABEL "Просмотр" 
     SIZE 15 BY 1.13.

DEFINE BUTTON btn_merc 
     IMAGE-UP FILE "cmp/btn-fnd.bmp":U
     IMAGE-DOWN FILE "cmp/btn-fnd.bmp":U
     IMAGE-INSENSITIVE FILE "cmp/btn-fnd.bmp":U NO-CONVERT-3D-COLORS
     LABEL "" 
     SIZE 3 BY 1 TOOLTIP "Синхронизация товара".

DEFINE BUTTON btn_prn 
     LABEL "Печать" 
     SIZE 15 BY 1.13.

DEFINE BUTTON btn_trndoc 
     IMAGE-UP FILE "cmp/btn-fnd.bmp":U
     IMAGE-DOWN FILE "cmp/btn-fnd.bmp":U
     IMAGE-INSENSITIVE FILE "cmp/btn-fnd.bmp":U NO-CONVERT-3D-COLORS
     LABEL "" 
     SIZE 3 BY 1 TOOLTIP "Просмотр накладной".

DEFINE BUTTON btRef 
     LABEL "Обновить" 
     SIZE 15 BY 1.13.

DEFINE VARIABLE v-date-end AS DATE FORMAT "99/99/9999":U 
     LABEL "По" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE v-date-start AS DATE FORMAT "99/99/9999":U 
     LABEL "C" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE vTime AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Время гашения" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 102 BY 1.67.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 102 BY 1.42.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 99.5 BY 2.75.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 102 BY 1.25.

DEFINE VARIABLE vFalExting AS LOGICAL INITIAL yes 
     LABEL "Ошибка гашения" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.5 BY 1 NO-UNDO.

DEFINE VARIABLE vFalVerif AS LOGICAL INITIAL yes 
     LABEL "Ошибка проверки ВСД" 
     VIEW-AS TOGGLE-BOX
     SIZE 21.5 BY 1 NO-UNDO.

DEFINE VARIABLE vRep AS LOGICAL INITIAL yes 
     LABEL "Погашен" 
     VIEW-AS TOGGLE-BOX
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE vReqVerif AS LOGICAL INITIAL yes 
     LABEL "Требует проверки" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.5 BY 1 NO-UNDO.

DEFINE VARIABLE vToExtin AS LOGICAL INITIAL yes 
     LABEL "К гашению" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.5 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-VSD FOR 
      ttvsd SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-VSD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-VSD Dialog-Frame _STRUCTURED
  QUERY BROWSE-VSD NO-LOCK DISPLAY
      ttvsd.dateTTH COLUMN-LABEL "Дата ТТН" FORMAT "99/99/9999":U
      ttvsd.NomTTH COLUMN-LABEL "Номер ТТН" FORMAT "x(30)":U WIDTH 15
      ttvsd.NomAZS COLUMN-LABEL "Объект" WIDTH 8.63
      ttvsd.artic COLUMN-LABEL "Артикул товара" FORMAT "x(30)":U
            WIDTH 10.38
      ttvsd.UUID COLUMN-LABEL "Номер ВСД" FORMAT "x(36)":U WIDTH 40
      ttvsd.vsdtypelbl COLUMN-LABEL "Тип" FORMAT "x(100)":U WIDTH 12
      ttvsd.statusvsd COLUMN-LABEL "Статус ВСД" FORMAT "x(30)":U
      ttvsd.NomTTHpost COLUMN-LABEL "Номер ТТН поставщика" FORMAT "x(100)":U
            WIDTH 22
      ttvsd.Post COLUMN-LABEL "Поставщик" FORMAT "x(100)":U WIDTH 30
      ttvsd.gdsname COLUMN-LABEL "Наименование товара" FORMAT "x(100)":U
            WIDTH 35
      ttvsd.prod-code COLUMN-LABEL "Производитель" FORMAT "x(100)":U
            WIDTH 32
      ttvsd.COLobj COLUMN-LABEL "Кол-во факт" FORMAT ">>>>>>9":U
      ttvsd.unit-base COLUMN-LABEL "Ед.изм.уч." WIDTH 10
      ttvsd.unit-cli COLUMN-LABEL "Ед.изм.пост." WIDTH 12
      ttvsd.ojd COLUMN-LABEL "Ожидает гашения(Ч.)" FORMAT ">>>>>":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 121 BY 15.25 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     Btn_Cancel AT ROW 1 COL 5.5
     btn_edit AT ROW 1 COL 20.5
     Btn_lookup AT ROW 1 COL 35.5 WIDGET-ID 54
     btn_prn AT ROW 1 COL 50 WIDGET-ID 80
     vTime AT ROW 2.5 COL 17 COLON-ALIGNED WIDGET-ID 22
     v-date-start AT ROW 2.5 COL 34 COLON-ALIGNED WIDGET-ID 36
     v-date-end AT ROW 2.5 COL 53 COLON-ALIGNED WIDGET-ID 38
     btRef AT ROW 2.5 COL 72 WIDGET-ID 28
     btFilt AT ROW 2.5 COL 87 WIDGET-ID 52
     vReqVerif AT ROW 3.75 COL 4.5 WIDGET-ID 2
     vFalVerif AT ROW 3.75 COL 24.5 WIDGET-ID 4
     vToExtin AT ROW 3.75 COL 48 WIDGET-ID 6
     vFalExting AT ROW 3.75 COL 62 WIDGET-ID 8
     vRep AT ROW 3.75 COL 79.5 WIDGET-ID 10
     BROWSE-VSD AT ROW 5.5 COL 1 WIDGET-ID 200
     ttvsd.gds-code AT ROW 21.58 COL 22.5 COLON-ALIGNED WIDGET-ID 56
          LABEL "Товар TH" FORMAT "->>>>>>9"
          VIEW-AS FILL-IN 
          SIZE 14 BY 1
     ttvsd.gdsname AT ROW 21.58 COL 37.5 COLON-ALIGNED HELP
          "" NO-LABEL WIDGET-ID 60 FORMAT "x(20)"
          VIEW-AS FILL-IN 
          SIZE 29 BY 1 TOOLTIP "123456677878"
     ttvsd.gdsmercguid AT ROW 21.58 COL 67 COLON-ALIGNED HELP
          "" NO-LABEL WIDGET-ID 72 FORMAT "x(40)"
          VIEW-AS FILL-IN 
          SIZE 37 BY 1
     Btn_gds AT ROW 21.58 COL 107.5 WIDGET-ID 68
     ttvsd.gds-name-merc AT ROW 23.08 COL 22.5 COLON-ALIGNED WIDGET-ID 44
          LABEL "Товар в ВСД"
          VIEW-AS FILL-IN 
          SIZE 29 BY 1
     ttvsd.gds-guid AT ROW 23.08 COL 52 COLON-ALIGNED NO-LABEL WIDGET-ID 42 FORMAT "x(40)"
          VIEW-AS FILL-IN 
          SIZE 37 BY 1
     btn_merc AT ROW 23.08 COL 93.5 WIDGET-ID 70
     ttvsd.NomTTH AT ROW 24.33 COL 22.5 COLON-ALIGNED HELP
          "" WIDGET-ID 66
          LABEL "Накладная" FORMAT "x(20)"
          VIEW-AS FILL-IN 
          SIZE 14 BY 1
     btn_trndoc AT ROW 24.33 COL 40 WIDGET-ID 74
     ttvsd.msg-err AT ROW 26.5 COL 5.5 NO-LABEL WIDGET-ID 64
          VIEW-AS EDITOR
          SIZE 112 BY 3
     "Описание ошибки:" VIEW-AS TEXT
          SIZE 17 BY .67 AT ROW 25.75 COL 54 WIDGET-ID 84
     RECT-1 AT ROW 21.25 COL 10 WIDGET-ID 76
     RECT-2 AT ROW 22.92 COL 10 WIDGET-ID 78
     RECT-3 AT ROW 2.25 COL 3.5 WIDGET-ID 82
     RECT-4 AT ROW 24.25 COL 10 WIDGET-ID 86
     SPACE(10.00) SKIP(4.28)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Журнал ВСД"
         CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttvsd T "?" NO-UNDO ub vsd
      ADDITIONAL-FIELDS:
          FIELD dateTTH      AS DATE  /*  "Номер ТТН"              "X(20)" */
          FIELD NomTTH       AS CHAR  /*  "Номер ТТН"              "X(20)" */
          FIELD NomTTHpost   AS CHAR  /*  "Номер ТТН поставщика"   "X(20)" */
          FIELD NomAZS       AS CHAR  /*  "№ АЗС"                  ?  */
          FIELD Post         AS CHAR  /*  "Поставщик"              "X(20)" */
          FIELD artic        AS CHAR  /*  "Артикул товара"         "X(20)" */
          FIELD gdsname      AS CHAR  /*  "Наименование товара"    "X(30)" */
          FIELD prod-code    AS CHAR  /*  "Производитель"          "X(20)" */
          FIELD COLobj       AS DEC   /*  "Кол-во факт"            "X(15)" */
          FIELD unit-cli     AS CHAR  /*  "Ед.изм."                "X(6)" */
          FIELD unit-base     AS CHAR  /*  "Ед.изм."                "X(6)" */
          /*FIELD UUID         AS CHAR    "Номер ВСД"              "X(40)" */
          FIELD statusvsd    AS CHAR  /*  "Статус ВСД"             "X(20)" */
          FIELD ojd          AS DEC   /*  "Ожидает гашения"        "X(20)" */
          FIELD gdsmercguid  AS CHAR  /*  Guid merc                "X(40)" */
          FIELD vsdtypelbl   AS CHAR  /*  Guid merc                "X(40)" */
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-VSD vRep Dialog-Frame */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

ASSIGN 
       BROWSE-VSD:ALLOW-COLUMN-SEARCHING IN FRAME Dialog-Frame = TRUE
       BROWSE-VSD:COLUMN-RESIZABLE IN FRAME Dialog-Frame       = TRUE
       BROWSE-VSD:COLUMN-MOVABLE IN FRAME Dialog-Frame         = TRUE.

/* SETTINGS FOR FILL-IN ttvsd.gds-code IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL EXP-FORMAT                                       */
/* SETTINGS FOR FILL-IN ttvsd.gds-guid IN FRAME Dialog-Frame
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN ttvsd.gds-name-merc IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN ttvsd.gdsmercguid IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL EXP-FORMAT EXP-HELP                              */
/* SETTINGS FOR FILL-IN ttvsd.gdsname IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL EXP-FORMAT EXP-HELP                              */
/* SETTINGS FOR EDITOR ttvsd.msg-err IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
ASSIGN 
       ttvsd.msg-err:AUTO-RESIZE IN FRAME Dialog-Frame      = TRUE
       ttvsd.msg-err:RESIZABLE IN FRAME Dialog-Frame        = TRUE.

/* SETTINGS FOR FILL-IN ttvsd.NomTTH IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL EXP-FORMAT EXP-HELP                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-VSD
/* Query rebuild information for BROWSE BROWSE-VSD
     _TblList          = "Temp-Tables.ttvsd"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.ttvsd.dateTTH
"ttvsd.dateTTH" "Дата ТТН" "99/99/9999" ? ? ? ? ? ? ? no "Дата ТТН" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.ttvsd.NomTTH
"ttvsd.NomTTH" "Номер ТТН" "x(30)" "character" ? ? ? ? ? ? no "Номер ТТН" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.ttvsd.NomAZS
"ttvsd.NomAZS" "Объект" ? "character" ? ? ? ? ? ? no "Объект" no no "8.63" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.ttvsd.artic
"ttvsd.artic" "Артикул товара" "x(30)" "character" ? ? ? ? ? ? no "Артикул товара" no no "10.38" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.ttvsd.UUID
"ttvsd.UUID" "Номер ВСД" ? "character" ? ? ? ? ? ? no "Номер ВСД" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.ttvsd.vsdtypelbl
"ttvsd.vsdtypelbl" "Тип" "x(100)" "character" ? ? ? ? ? ? no "Тип" no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.ttvsd.statusvsd
"ttvsd.statusvsd" "Статус ВСД" "x(30)" "character" ? ? ? ? ? ? no "Статус ВСД" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.ttvsd.NomTTHpost
"ttvsd.NomTTHpost" "Номер ТТН поставщика" "x(100)" "character" ? ? ? ? ? ? no "Номер ТТН поставщика" no no "22" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.ttvsd.Post
"ttvsd.Post" "Поставщик" "x(100)" "character" ? ? ? ? ? ? no "Поставщик" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.ttvsd.gdsname
"ttvsd.gdsname" "Наименование товара" "x(100)" "character" ? ? ? ? ? ? no "Наименование товара" no no "35" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.ttvsd.prod-code
"ttvsd.prod-code" "Производитель" "x(100)" "character" ? ? ? ? ? ? no "Производитель" no no "32" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.ttvsd.COLobj
"ttvsd.COLobj" "Кол-во факт" ">>>>>>9" ? ? ? ? ? ? ? no "Кол-во факт" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.ttvsd.unit-base
"ttvsd.unit-cli" "Ед.изм.уч." ? "character" ? ? ? ? ? ? no "Ед.изм.уч." no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
_FldNameList[14]   > Temp-Tables.ttvsd.unit-cli
"ttvsd.unit-cli" "Ед.изм.пост." ? "character" ? ? ? ? ? ? no "Ед.изм.пост." no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > Temp-Tables.ttvsd.ojd
"ttvsd.ojd" "Ожидает гашения(Ч.)" ">>>>>" ? ? ? ? ? ? ? no "Ожидает гашения(Ч.)" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-VSD */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Журнал ВСД */
DO:
        APPLY "END-ERROR":U TO SELF.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-VSD
&Scoped-define SELF-NAME BROWSE-VSD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-VSD Dialog-Frame
ON VALUE-CHANGED OF BROWSE-VSD IN FRAME Dialog-Frame
DO:
  IF AVAILABLE ttvsd THEN 
    DISPLAY {&DISPLAYED-FIELDS}
      WITH FRAME Dialog-Frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFilt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFilt Dialog-Frame
ON CHOOSE OF btFilt IN FRAME Dialog-Frame /* Расшир. фильтр */
DO:
        RUN bge/vsd-filt.w(parparentproc,INPUT-OUTPUT DATASET ds-vsd-set ).
        FIND FIRST tt-vsd-filt NO-ERROR .
        IF AVAIL tt-vsd-filt  
            THEN ASSIGN 
                v-date-end   = tt-vsd-filt.date-end
                v-date-start = tt-vsd-filt.date-start
                vtime        = tt-vsd-filt.fTime
                vFalExting   = tt-vsd-filt.FalExting
                vFalVerif    = tt-vsd-filt.FalVerif
                vRep         = tt-vsd-filt.Rep
                vReqVerif    = tt-vsd-filt.ReqVerif
                vToExtin     = tt-vsd-filt.ToExtin
                .
        RUN refresh-query IN THIS-PROCEDURE.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_edit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_edit Dialog-Frame
ON CHOOSE OF btn_edit IN FRAME Dialog-Frame /* Изменить */
DO:
   DEFINE VARIABLE vsdsubsObj    AS CLASS vsdsubs      NO-UNDO.
   DEFINE VARIABLE vsdsubObj     AS CLASS vsdsub       NO-UNDO.
   DEFINE VARIABLE vsdStorageObj AS CLASS vsdtostorage NO-UNDO.
   DEFINE BUFFER vsd FOR vsd.
   DEFINE VARIABLE vSave AS LOGICAL NO-UNDO.
   DEFINE VARIABLE vI AS INTEGER NO-UNDO.
   FIND FIRST vsd WHERE vsd.id EQ ttvsd.id
                    AND vsd.db-num EQ ttvsd.db-num
      NO-LOCK NO-ERROR.
   IF AVAIL vsd 
   THEN DO:                 
      vsdStorageObj = NEW vsdtostorage ().
      vsdsubsObj = vsdStorageObj:getVSDsubs(BUFFER vsd).
      RUN str/vsd.w (INPUT parparentproc, INPUT {&update}, INPUT vsdsubsObj,INPUT yes, OUTPUT vSave).
      IF vSave 
      THEN DO:
         DO vi = 1 TO vsdsubsObj:GetItem(vi):
            vsdsubObj = vsdsubsObj:VsdObjCurr.
            IF vsdsubObj:Changed
            THEN DO: 
               CASE TRUE:
                  WHEN vsdsubObj:ID > 0 
                  THEN DO:
                     vsdStorageObj:updateDB(vsdsubObj).
                  END.
                  OTHERWISE DO:
                     vsdStorageObj:insertDB(vsdsubObj).
                  END.
               END CASE.
            END.
         END.
          RUN refresh-query IN THIS-PROCEDURE .
      END.
      
                          
             
   END.
    /* FINALLY: */
          
        DELETE OBJECT vsdsubsObj NO-ERROR.
   /* END FINALLY. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_gds
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_gds Dialog-Frame
ON CHOOSE OF Btn_gds IN FRAME Dialog-Frame
DO:
    DEFINE VARIABLE gds-rec  AS INT64 NO-UNDO.
    DEFINE BUFFER goods FOR goods.
    FIND FIRST goods WHERE goods.gds-code EQ ttvsd.gds-code NO-LOCK NO-ERROR.
    IF AVAIL goods
    THEN DO:
        gds-rec = recid(goods).
        run ref/gds-form.w (
            INPUT parparentproc
            , INPUT {&lookup}
            , INPUT ttvsd.obj-type
            , INPUT ttvsd.obj-code
            , input THIS-PROCEDURE 
            , input-output gds-rec
            ) .
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_lookup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_lookup Dialog-Frame
ON CHOOSE OF Btn_lookup IN FRAME Dialog-Frame /* Просмотр */
DO:
    DEFINE VARIABLE vsdsubsObj AS CLASS vsdsubs NO-UNDO.
    DEFINE VARIABLE vsdStorageObj AS CLASS vsdtostorage NO-UNDO.
    DEFINE VARIABLE vSave AS LOGICAL NO-UNDO.
    DEFINE BUFFER vsd FOR vsd.
    FIND FIRST vsd WHERE vsd.id EQ ttvsd.id
        AND vsd.db-num EQ ttvsd.db-num
        NO-LOCK NO-ERROR.
    IF AVAIL vsd 
        THEN 
    DO: 
        vsdStorageObj = NEW vsdtostorage ().                
        vsdsubsObj = vsdStorageObj:getVSDsubs(BUFFER vsd).
        RUN str/vsd.w (INPUT parparentproc, INPUT {&lookup}, INPUT vsdsubsObj,INPUT no, OUTPUT vSave).
    END. 
    /* FINALLY: */
          
        DELETE OBJECT vsdsubsObj NO-ERROR.
    /* END FINALLY. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_merc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_merc Dialog-Frame
ON CHOOSE OF btn_merc IN FRAME Dialog-Frame
DO:
    run ref/merq-gds.w (
        parparentproc
        ,INPUT-OUTPUT ttvsd.gds-code
        ,INPUT {&lookup}
        ) no-error .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_prn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_prn Dialog-Frame
ON CHOOSE OF btn_prn IN FRAME Dialog-Frame /* Печать */
DO:
    RUN print IN THIS-PROCEDURE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_trndoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_trndoc Dialog-Frame
ON CHOOSE OF btn_trndoc IN FRAME Dialog-Frame
DO:
    DEFINE BUFFER doc-line FOR doc-line.
    DEFINE BUFFER trn-doc  FOR trn-doc.
    DEFINE BUFFER goods FOR goods.
    DEFINE VARIABLE vlog AS LOGICAL NO-UNDO.
    FIND FIRST trn-doc WHERE trn-doc.doc-code EQ ENTRY (7,ttvsd.part-key,{&delim-key}) NO-LOCK NO-ERROR.
    
    IF AVAIL trn-doc
    THEN DO :
        CASE trn-doc.doc-type:
            WHEN {&income}
            THEN DO:
                { gbl/chk-actg.i
                    v-cntxt-db-num
                    v-cntxt-userid
                    {&action-head-code-main}
                    'actn_income_lookup':U
                    {&cntxt-object}
                    trn-doc.host-code
                    trn-doc.obj-type
                    trn-doc.obj-code
                    0
                    0
                    0
                    true
                    vlog
                  }
            END.
            WHEN {&expense}
            THEN DO:
                    { gbl/chk-actg.i
                        v-cntxt-db-num
                        v-cntxt-userid
                        {&action-head-code-main}
                        'actn_expense_lookup':U
                        {&cntxt-object}
                        trn-doc.host-code
                        trn-doc.obj-type
                        trn-doc.obj-code
                        0
                        0
                        0
                        true
                        vlog
                      }
            END.
            WHEN {&write-off}
            THEN DO:
                { gbl/chk-actg.i
                    v-cntxt-db-num
                    v-cntxt-userid
                    {&action-head-code-main}
                    'actn_write-off_lookup':U
                    {&cntxt-object}
                    trn-doc.host-code
                    trn-doc.obj-type
                    trn-doc.obj-code
                    0
                    0
                    0
                    true
                    vlog
                  }
            END .
            WHEN {&inventory}
            THEN DO:
                { gbl/chk-actg.i
                    v-cntxt-db-num
                    v-cntxt-userid
                    {&action-head-code-main}
                    'actn_inventory_lookup':U
                    {&cntxt-object}
                    trn-doc.host-code
                    trn-doc.obj-type
                    trn-doc.obj-code
                    0
                    0
                    0
                    true
                    vlog
                  }
            END.
            WHEN {&return}
            THEN DO:
                { gbl/chk-actg.i
                    v-cntxt-db-num
                    v-cntxt-userid
                    {&action-head-code-main}
                    'actn_return_lookup':U
                    {&cntxt-object}
                    trn-doc.host-code
                    trn-doc.obj-type
                    trn-doc.obj-code
                    0
                    0
                    0
                    true
                    vlog
                  }
             END.
             OTHERWISE 
             DO:
                MESSAGE
                    vss-workfile vss-revision vss-description skip
                    "Неизвестный тип документа" skip
                    "Тип документа" trn-doc.doc-type skip
                    "Код документа" trn-doc.doc-code skip
                    VIEW-AS ALERT-BOX ERROR .
                
            END.
        END CASE .
        
        IF NOT vlog THEN RETURN NO-APPLY.
        FIND FIRST goods WHERE goods.gds-code EQ ttvsd.gds-code NO-LOCK NO-ERROR.
                       
        IF AVAIL goods
        THEN DO:
            FIND doc-line WHERE doc-line.doc-code  = trn-doc.doc-code  
                            AND doc-line.artic     = goods.artic     
                            AND doc-line.prod-type = goods.prod-type 
                            AND doc-line.prod-code = goods.prod-code 
            NO-LOCK  NO-ERROR .
            IF AVAIL doc-line 
            THEN
                RUN str/trn-lkp.p (parparentproc, recid(trn-doc), recid(doc-line)).
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btRef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRef Dialog-Frame
ON CHOOSE OF btRef IN FRAME Dialog-Frame /* Обновить */
DO:
        FIND FIRST tt-vsd-filt.
        ASSIGN
            v-date-end 
            v-date-start
            vtime
            vFalExting
            vFalVerif
            vRep
            vReqVerif
            vToExtin.
        ASSIGN 
            tt-vsd-filt.date-end   = v-date-end    
            tt-vsd-filt.date-start = v-date-start 
            tt-vsd-filt.fTime      = vtime         
            tt-vsd-filt.FalExting  = vFalExting   
            tt-vsd-filt.FalVerif   = vFalVerif
            tt-vsd-filt.Rep        = vRep         
            tt-vsd-filt.ReqVerif   = vReqVerif     
            tt-vsd-filt.ToExtin    = vToExtin      
            .
        RUN refresh-query IN THIS-PROCEDURE.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT EQ ?
    THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    { gbl/getcntxt.i get }
    ASSIGN 
        v-date-end   = TODAY
        v-date-start = TODAY
        vFalExting   = YES
        vFalVerif    = YES 
        vRep         = YES 
        vReqVerif    = YES 
        vToExtin     = YES
        vTime        = 0        
         
        . 
    
    CREATE tt-vsd-filt.
    ASSIGN 
        tt-vsd-filt.date-end   = TODAY
        tt-vsd-filt.date-start = TODAY
        tt-vsd-filt.FalExting  = YES
        tt-vsd-filt.FalVerif   = YES 
        tt-vsd-filt.Rep        = YES 
        tt-vsd-filt.ReqVerif   = YES 
        tt-vsd-filt.ToExtin    = YES
        tt-vsd-filt.fTime      = 0
                
        . 
    FOR EACH db NO-LOCK
        ON ERROR UNDO, RETURN NO-APPLY
        :
        FOR EACH clients NO-LOCK
            WHERE clients.db-num = db.db-num
            ON ERROR UNDO, RETURN NO-APPLY
            :
            { gbl/usobjava.i
            v-cntxt-db-num
            {&action-head-code-main}
            v-cntxt-userid
            clients.obj-type
            clients.obj-code
            v-object-available
            no-error
          }
            IF ERROR-STATUS :ERROR
                THEN 
            DO:
                MESSAGE
                    vss-workfile vss-revision vss-description SKIP
                    "Ошибка при вызове процедуры gbl/usobjava.i" SKIP
                    ERROR-STATUS :GET-MESSAGE(1) SKIP
                    RETURN-VALUE SKIP
                    VIEW-AS ALERT-BOX ERROR .
                UNDO, RETURN NO-APPLY .
            END.

            IF v-object-available = TRUE
                THEN 
            DO:
                CREATE t-obj-list .
                ASSIGN
                    t-obj-list.obj-type = clients.obj-type
                    t-obj-list.obj-code = clients.obj-code
                    .
            END.
        END.
    END.
    { gbl/diasize.i &browse-name=BROWSE-VSD }
    run diasize_init in this-procedure .
    RUN enable_UI.
    RUN refresh-query IN THIS-PROCEDURE .
    
    WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreateTT Dialog-Frame 
PROCEDURE CreateTT :
/*------------------------------------------------------------------------------
          Purpose:
          Parameters:  <none>
          Notes:
        ------------------------------------------------------------------------------*/
    
    DEFINE BUFFER tt-gds-list FOR tt-gds-list.
    DEFINE BUFFER t-obj-list  FOR t-obj-list.
    DEFINE BUFFER goods       FOR goods.
    DEFINE BUFFER trn-doc     FOR trn-doc.
    DEFINE BUFFER clients     FOR clients.
    DEFINE BUFFER bclients    FOR clients.
    DEFINE BUFFER ttvsd       FOR ttvsd.
    
     
    
    DEFINE VARIABLE vStatus     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE vGdsChek    AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE v-attr-type AS CHARACTER NO-UNDO.
    DEFINE VARIABLE vStatusTXT  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE vOjd        AS INTEGER   NO-UNDO.
    DEFINE VARIABLE vI          AS INTEGER   NO-UNDO.

    DEFINE VARIABLE vsdsTHObj   AS CLASS     vsdsubs.
    DEFINE VARIABLE vsdStorage  AS CLASS     vsdtostorage.
    
    vstatustxt ="Требует проверки,Ошибка проверки ВСД,К гашению,Ошибка гашения,Погашен".
    FIND FIRST tt-vsd-filt.
    IF tt-vsd-filt.ReqVerif THEN 
        vStatus = vStatus + ",0".
    IF tt-vsd-filt.FalVerif THEN 
        vStatus = vStatus + ",1".
    IF tt-vsd-filt.ToExtin THEN 
        vStatus = vStatus + ",2".
    IF tt-vsd-filt.FalExting THEN 
        vStatus = vStatus + ",3".
    IF tt-vsd-filt.Rep THEN 
        vStatus = vStatus + ",4".
    vStatus = SUBSTRING(vStatus,2).
    .
    FIND FIRST tt-gds-list NO-LOCK NO-ERROR.
    vGdsChek = AVAIL tt-gds-list. 
    IF    tt-vsd-filt.doc-code EQ "?" 
       OR tt-vsd-filt.doc-code EQ ""
    THEN tt-vsd-filt.doc-code = ?.
    vsdsTHObj = NEW vsdsubs ().
    vsdStorage = NEW vsdtostorage ().
    
    FOR EACH t-obj-list:
   
   
        /*EACH vsd WHERE vsd.obj-type EQ t-obj-list.obj-type
                   AND vsd.obj-code EQ t-obj-list.obj-code
                   AND CAN-DO(vstatus,STRING (vsd.status_))
        NO-LOCK:*/
        vsdsTHObj = vsdStorage:getVSDsubs(t-obj-list.obj-type,t-obj-list.obj-code,vstatus).
        Block-vsd:
        DO vi = 1 TO vsdsTHObj:GetItem (vi): 
            FIND FIRST ttvsd WHERE ttVSD.ID         = vsdsTHObj:VsdObjCurr:ID
                AND ttvsd.db-num     = vsdsTHObj:VsdObjCurr:DBNum
                NO-ERROR.
            IF AVAIL ttvsd 
                THEN 
                NEXT Block-vsd.
            FIND FIRST trn-doc WHERE trn-doc.doc-code EQ ENTRY (7,vsdsTHObj:VsdObjCurr:PartKey,{&delim-key}) NO-LOCK NO-ERROR.
            IF NOT AVAIL trn-doc 
                THEN 
                NEXT Block-vsd.
            IF    trn-doc.doc-date < tt-vsd-filt.date-start 
                OR trn-doc.doc-date > tt-vsd-filt.date-end 
                OR (tt-vsd-filt.doc-code NE ?
                    AND NOT CAN-DO(tt-vsd-filt.doc-code,trn-doc.doc-code))
                THEN 
                NEXT Block-vsd.
                
            FIND FIRST goods WHERE goods.gds-code EQ vsdsTHObj:VsdObjCurr:GdsCode NO-LOCK NO-ERROR.
            IF NOT AVAIL goods THEN NEXT Block-vsd.
            CASE  vGdsChek: 
                WHEN YES THEN 
                    DO:
                        FIND FIRST tt-gds-list
                            WHERE tt-gds-list.artic     = goods.artic
                            AND tt-gds-list.prod-type = goods.prod-type
                            AND tt-gds-list.prod-code = goods.prod-code NO-ERROR .
                        IF NOT AVAILABLE tt-gds-list THEN NEXT Block-vsd.
                    END.
                OTHERWISE . /* все товары */
            END.   
            FIND FIRST  clients WHERE clients.obj-type EQ goods.prod-type
                AND clients.obj-code EQ goods.prod-code
                NO-LOCK NO-ERROR.
            FIND FIRST  bclients WHERE bclients.obj-type EQ  trn-doc.cli-type
                AND bclients.obj-code EQ trn-doc.cli-code
                NO-LOCK NO-ERROR.
                
                   
                            
            vOjd =  IF vsdsTHObj:VsdObjCurr:Status_ EQ 4 THEN 0 ELSE TRUNC ((NOW - vsdsTHObj:VsdObjCurr:FactDatetime)/ (1000 * 60 * 60),0).
            IF    vOjd >= tt-vsd-filt.fTime
               OR vsdsTHObj:VsdObjCurr:Status_ EQ 4
                THEN  
            DO:
                CREATE ttvsd.
                ttvsd.gds-name-merc = vsdsTHObj:VsdObjCurr:GdsMercName.
                ttvsd.gds-guid      = vsdsTHObj:VsdObjCurr:GdsGUID.
                ttvsd.gdsmercguid   = vsdsTHObj:VsdObjCurr:GdsMercGUID.
                ttvsd.msg-err       = vsdsTHObj:VsdObjCurr:MsgErr.
                ttvsd.gds-code      = vsdsTHObj:VsdObjCurr:GdsCode.
                ttVSD.UUID          = vsdsTHObj:VsdObjCurr:UUID.                    /*  "Номер ВСД"              "X(40)" */
                ttvsd.date-out      = vsdsTHObj:VsdObjCurr:DateOut.
                ttvsd.date-cr       = vsdsTHObj:VsdObjCurr:DateCr.
                ttvsd.expiry-date   = vsdsTHObj:VsdObjCurr:ExpiryDate.
                ttvsd.expiry-date-2 = vsdsTHObj:VsdObjCurr:ExpiryDate2.
                ttVSD.statusvsd     = vsdsTHObj:VsdObjCurr:StatusLbl.          /*  "Статус ВСД"             "X(20)" */
                ttVSD.ID            = vsdsTHObj:VsdObjCurr:ID.                
                ttvsd.db-num        = vsdsTHObj:VsdObjCurr:DBNum.
                ttvsd.part-key      = vsdsTHObj:VsdObjCurr:PartKey.
                ttvsd.obj-type      = vsdsTHObj:VsdObjCurr:ObjType.
                ttvsd.obj-code      = vsdsTHObj:VsdObjCurr:ObjCode.
                ttvsd.vsdtypelbl    = vsdsTHObj:VsdObjCurr:VSDTypeLbl.
                ttVSD.COLobj        = vsdsTHObj:VsdObjCurr:Qnty.            /*  "Кол-во факт"            "X(15)" */
                ASSIGN                          
                    ttVSD.dateTTH    = trn-doc.doc-date            /*  "Номер ТТН"              "X(20)" */
                    ttVSD.NomTTH     = trn-doc.doc-code            /*  "Номер ТТН"              "X(20)" */
                    ttVSD.NomTTHpost = trn-doc.rcv-code            /*  "Номер ТТН поставщика"   "X(20)" */
                    ttVSD.NomAZS     = STRING(t-obj-list.obj-code)   /*  "№ АЗС"                  ?  */
                    ttVSD.Post       = IF AVAIL bclients 
                                       THEN bclients.obj-name
                    ELSE ""                     /*  "Поставщик"              "X(20)" */
                    ttVSD.artic      = goods.artic                 /*  "Артикул товара"         "X(20)" */ 
                    ttVSD.gdsname    = goods.gds-name              /*  "Наименование товара"    "X(30)" */
                    ttVSD.prod-code  = IF AVAIL clients 
                                       THEN clients.obj-name
                    ELSE ""                     /*  "Производитель"          "X(20)" */
                    
                    ttVSD.unit-cli   = goods.unit-cli              /*  "Ед.изм."                "X(6)" */
                    ttVSD.unit-base   = goods.unit-base              /*  "Ед.изм."                "X(6)" */
                    ttVSD.ojd        = vojd                             /*  "Ожидает гашения"        "X(20)" */
                
                    .
                    
                RUN gbl/trdcat-v.p
                    ( INPUT trn-doc.doc-code
                    ,INPUT {&trdcattr-nids }
                    ,OUTPUT ttVSD.NomTTHpost
                    ,OUTPUT v-attr-type
                    ).
                    
            END.
            /* vsdsTHObj:GetItem(2). */ 
        END. 
    END.
   /* FINALLY :*/
         DELETE  OBJECT vsdStorage NO-ERROR .
         DELETE OBJECT vsdsTHObj NO-ERROR.
    /* END FINALLY. */
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
  DISPLAY vTime v-date-start v-date-end vReqVerif vFalVerif vToExtin vFalExting 
          vRep 
      WITH FRAME Dialog-Frame.
  IF AVAILABLE ttvsd THEN 
    DISPLAY ttvsd.gds-code ttvsd.gdsname ttvsd.gdsmercguid ttvsd.gds-name-merc 
          ttvsd.gds-guid ttvsd.NomTTH ttvsd.msg-err 
      WITH FRAME Dialog-Frame.
  ENABLE RECT-1 RECT-2 RECT-3 Btn_Cancel btn_edit Btn_lookup btn_prn RECT-4 
         vTime v-date-start v-date-end btRef btFilt vReqVerif vFalVerif 
         vToExtin vFalExting vRep BROWSE-VSD Btn_gds btn_merc btn_trndoc 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE print Dialog-Frame 
PROCEDURE print :
{rep/r-statusvsd.p &only_print = YES 
                   &date-start = tt-vsd-filt.date-start 
                   &date-end   = tt-vsd-filt.date-end }
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refresh-query Dialog-Frame 
PROCEDURE refresh-query :
/*------------------------------------------------------------------------------
          Purpose:
          Parameters:  <none>
          Notes:
        ------------------------------------------------------------------------------*/
    FOR EACH ttvsd:
        DELETE ttvsd.
    END.    
    RUN CreateTT.
    OPEN QUERY {&browse-name} FOR EACH ttvsd INDEXED-REPOSITION .
    APPLY "VALUE-CHANGED" to {&BROWSE-NAME} in frame {&frame-name}.
    VIEW FRAME Dialog-Frame. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

