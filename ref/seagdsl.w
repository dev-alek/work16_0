&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases
          ub               PROGRESS
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

Товары по сезонам

Автор: Чернова Светлана Александровна
Дата создания: 03/19/02
Author: Svetlana Chernova
Creation date: 03/19/02

*/
define input parameter parParentProc  as widget-handle no-undo.
define input parameter p-sea-code   like ub.season.sea-code no-undo.
define input parameter p-db-num like ub.season.db-num no-undo.
define input parameter p-name   like ub.season.sea-name no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Товары с темпами    ".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/showinf.i  }
{ cmp/library.i  }
{ cmp/gds-list.i gds-list def "new shared" }
{ gbl/getcntxt.i def }
{ gbl/getcntxt.i get }

define buffer buf_season    for ub.season.
define variable rid-list    as  character no-undo . /* список recid'ов выбранных аписей */
define variable log-res as log no-undo.
define variable rr as recid no-undo.
define variable v-log as logical   no-undo .

define variable line-mode as character no-undo .
define variable doc-rec as recid no-undo .
define variable gds-rec as recid no-undo .
define variable lns-cnt as integer   no-undo .
define variable g#log as logical   no-undo .


define temp-table tt-gds-list no-undo like ub.goods
field nn as integer
index by-nn nn
index by_gds-code gds-code
.
define variable varschartic       like ub.price-list.artic initial " " no-undo.
define variable ref-list  as character                     no-undo.

define variable sch-field as character no-undo.
define buffer buf_gds-season for ub.gds-season.  /* для поиска по номеру, дате, факт */
define buffer buf_goods      for ub.goods.  /* для поиска по номеру, дате, факт */

&Scoped-define OPEN-QUERY-BROWSE-2-alt OPEN QUERY BROWSE-2 FOR EACH ub.gds-season ~
      WHERE ub.gds-season.sea-code = p-sea-code and ~
            ub.gds-season.db-num   = p-db-num NO-LOCK, ~
      EACH ub.goods where ~
      ub.goods.gds-code = ub.gds-season.gds-code and ~
      INDEX(ub.goods.gds-name,s-name-cnt) > 0 ~
      NO-LOCK ~{&SORTBY-PHRASE}.

define variable sort-column-name as character no-undo .
define variable list-option as character no-undo.
define stream sout.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ub.gds-season ub.goods

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 ub.goods.artic ub.goods.gds-name ~
ub.goods.unit-base ub.gds-season.min-stock ub.goods.gds-code
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 ub.gds-season.min-stock
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-2 ub.gds-season
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BROWSE-2 ub.gds-season
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH ub.gds-season ~
      WHERE ub.gds-season.sea-code = p-sea-code and ~
gds-season.db-num = p-db-num NO-LOCK, ~
      EACH ub.goods WHERE ub.goods.gds-code = ub.gds-season.gds-code NO-LOCK ~
    ~{&SORTBY-PHRASE}
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH ub.gds-season ~
      WHERE ub.gds-season.sea-code = p-sea-code and ~
gds-season.db-num = p-db-num NO-LOCK, ~
      EACH ub.goods WHERE ub.goods.gds-code = ub.gds-season.gds-code NO-LOCK ~
    ~{&SORTBY-PHRASE}.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 ub.gds-season ub.goods
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 ub.gds-season
&Scoped-define SECOND-TABLE-IN-QUERY-BROWSE-2 ub.goods


/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Dialog-Frame ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-exit b-add b-del b-list b-help R-sort ~
s-artic BROWSE-2 FILL-IN-2 mark-num
&Scoped-Define DISPLAYED-OBJECTS R-sort s-name s-name-cnt s-artic FILL-IN-2 ~
mark-num

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-b-list
       MENU-ITEM m_item1        LABEL "Сохранить"
       MENU-ITEM m_item2        LABEL "Загрузить"     .


/* Definitions of the field level widgets                               */
DEFINE BUTTON b-add
     LABEL "&Добавить":L
     SIZE 10 BY 1.

DEFINE BUTTON b-del
     LABEL "&Удалить":L
     SIZE 10 BY 1.

DEFINE BUTTON b-exit AUTO-GO
     LABEL "&Выход ":L
     SIZE 10 BY 1.

DEFINE BUTTON b-help
     LABEL "Помо&щь":L
     SIZE 10 BY 1.

DEFINE BUTTON b-list
     LABEL "Список":L
     SIZE 10 BY 1.

DEFINE BUTTON B-mark
     LABEL "&*"
     SIZE 3 BY 1.

DEFINE BUTTON b-print
     LABEL "Пе&чать":L
     SIZE 10 BY 1.

DEFINE BUTTON b-sel AUTO-GO
     LABEL "Вы&бор ":L
     SIZE 10 BY 1.

DEFINE BUTTON b-upd
     LABEL "&Изменить":L
     SIZE 10 BY 1.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Поиск по"
      VIEW-AS TEXT
     SIZE 8.88 BY .67
     FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE mark-num AS CHARACTER FORMAT "X(256)":U
      VIEW-AS TEXT
     SIZE 9 BY .67
     FGCOLOR 4  NO-UNDO.

DEFINE VARIABLE s-artic AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     SIZE 30 BY 1
     FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE s-name AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     SIZE 30 BY 1
     FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE s-name-cnt AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     SIZE 30 BY 1
     FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE R-sort AS INTEGER
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS
          "Артик", 1,
"Нач.назв", 2,
"Нач.слова", 3
     SIZE 34.63 BY .96 TOOLTIP "Поиск по" NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR
      ub.gds-season,
      ub.goods SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 Dialog-Frame _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      ub.goods.artic FORMAT "X(16)":U
      ub.goods.gds-name FORMAT "X(48)":U
      ub.goods.unit-base FORMAT "X(3)":U
      ub.gds-season.min-stock FORMAT ">>,>>9.999":U LABEL-FGCOLOR 1
      ub.goods.gds-code FORMAT "999999999":U
  ENABLE
      ub.gds-season.min-stock
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 87 BY 18.33
         BGCOLOR 15 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     b-exit AT ROW 1 COL 1
     b-sel AT ROW 1 COL 11
     B-mark AT ROW 1 COL 21
     b-add AT ROW 1 COL 24
     b-upd AT ROW 1 COL 34
     b-del AT ROW 1 COL 44
     b-print AT ROW 1 COL 54
     b-list AT ROW 1 COL 64.13
     b-help AT ROW 1 COL 78
     R-sort AT ROW 2.04 COL 10.75 NO-LABEL
     s-name AT ROW 2.04 COL 44.13 COLON-ALIGNED NO-LABEL
     s-name-cnt AT ROW 2.04 COL 44.13 COLON-ALIGNED NO-LABEL
     s-artic AT ROW 2.04 COL 44.13 COLON-ALIGNED NO-LABEL
     BROWSE-2 AT ROW 3.71 COL 1
     FILL-IN-2 AT ROW 2.21 COL 1 NO-LABEL
     mark-num AT ROW 2.96 COL 1 NO-LABEL
     SPACE(78.00) SKIP(18.41)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE
         TITLE "Товары по сезону".


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
                                                                        */
/* BROWSE-TAB BROWSE-2 s-artic Dialog-Frame */
ASSIGN
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

ASSIGN
       b-list:POPUP-MENU IN FRAME Dialog-Frame       = MENU POPUP-MENU-b-list:HANDLE.

/* SETTINGS FOR BUTTON B-mark IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b-print IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b-sel IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b-upd IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN mark-num IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN s-name IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN s-name-cnt IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "ub.gds-season,ub.goods WHERE ub.gds-season ..."
     _Options          = "NO-LOCK SORTBY-PHRASE"
     _TblOptList       = ","
     _Where[1]         = "ub.gds-season.sea-code = p-sea-code and
gds-season.db-num = p-db-num"
     _JoinCode[2]      = "ub.goods.gds-code = ub.gds-season.gds-code"
     _FldNameList[1]   = ub.goods.artic
     _FldNameList[2]   = ub.goods.gds-name
     _FldNameList[3]   = ub.goods.unit-base
     _FldNameList[4]   > ub.gds-season.min-stock
"ub.gds-season.min-stock" ? ? "decimal" ? ? ? ? 1 ? yes ? no no ? yes no no "U" "" ""
     _FldNameList[5]   = ub.goods.gds-code
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Товары по сезону */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-add Dialog-Frame
ON CHOOSE OF b-add IN FRAME Dialog-Frame /* Добавить */
DO:
  { gbl/chk-actg.i
    v-cntxt-db-num
    v-cntxt-userid
    {&action-head-code-main}
    'actn_season_add-def':U
    {&cntxt-global}
    0
    '':U
    0
    0
    0
    0
    true
    v-log
  }
 if not v-log then return no-apply .

assign
  line-mode = {&add-def}
.
run str/chsgdsls.w
(   input parParentProc ,
    input "season" ,
    input "Сезон " + p-name  ,
    input ? ,
    input ? ,
    input v-cntxt-host-code-obj,
    input-output varschartic,
    output ref-list,
    output table tt-gds-list,
    false )
    /* no-error */.

    if ref-list <> "" then do:
       run cycle-add in this-procedure no-error.
      if error-status:error then do:
         message
            vss-workfile vss-revision vss-description skip
            "Ошибка при вызове процедуры создания товара" skip
            error-status :get-message(1) skip
            return-value skip
            view-as alert-box error .
         return no-apply.
      end.
       {&OPEN-QUERY-{&BROWSE-NAME}}
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-del Dialog-Frame
ON CHOOSE OF b-del IN FRAME Dialog-Frame /* Удалить */
DO:
define variable g-log as logical   no-undo .
  { gbl/chk-actg.i
    v-cntxt-db-num
    v-cntxt-userid
    {&action-head-code-main}
    'actn_season_deletion':U
    {&cntxt-global}
    0
    '':U
    0
    0
    0
    0
    true
    v-log
  }
if not v-log then return no-apply .
if not available ub.gds-season then  return no-apply.

      message "Удалить запись ? "
      view-as alert-box question
      buttons yes-no
      update g-log.
      if g-log = false then return no-apply.

  define variable v-recid as integer no-undo .
  define variable ii as integer no-undo .

  find current ub.gds-season exclusive-lock no-error .
  delete ub.gds-season.
  {&BROWSE-NAME}:delete-current-row().

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-list
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-list Dialog-Frame
ON CHOOSE OF b-list IN FRAME Dialog-Frame /* Список */
DO:
    if list-option = "" then do:
    run gbl/pop-up.p (self:handle, no) no-error.
    if error-status:error then return no-apply.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-sel Dialog-Frame
ON CHOOSE OF b-sel IN FRAME Dialog-Frame /* Выбор  */
DO:
    if ( available ub.season ) AND ( rid-list = "" ) then
        rid-list = string( recid( ub.season ) ) .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-upd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-upd Dialog-Frame
ON CHOOSE OF b-upd IN FRAME Dialog-Frame /* Изменить */
DO:
  { gbl/chk-actg.i
    v-cntxt-db-num
    v-cntxt-userid
    {&action-head-code-main}
    'actn_season_update':U
    {&cntxt-global}
    0
    '':U
    0
    0
    0
    0
    true
    v-log
  }
 if not v-log then return no-apply .
 if not available ub.season THEN return no-apply.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_item1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_item1 Dialog-Frame
ON CHOOSE OF MENU-ITEM m_item1 /* Сохранить */
DO:
   list-option = "save":U.
  run proc-b-list in this-procedure (input list-option) no-error.
  if error-status:error then return no-apply.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_item2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_item2 Dialog-Frame
ON CHOOSE OF MENU-ITEM m_item2 /* Загрузить */
DO:
     list-option = "load":U.
  run proc-b-list in this-procedure (input list-option) no-error.
  if error-status:error then return no-apply.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME R-sort
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL R-sort Dialog-Frame
ON VALUE-CHANGED OF R-sort IN FRAME Dialog-Frame
DO:
  Assign frame {&frame-name} r-sort.
  case r-sort :
  when 1 then do:
        if sch-field = "s-name-cnt" then do:
                       assign frame {&frame-name}:title = "Товары >> Сезон - " + p-name.
                      {&OPEN-QUERY-BROWSE-2}
                      end.
        enable s-artic with frame {&frame-name}.
            Hide s-name  s-name-cnt in frame {&frame-name}.
        display s-artic with frame {&frame-name}.
   end.
  when 2 then do:
    if sch-field = "s-name-cnt" then do:
                 assign frame {&frame-name}:title = "Товары >> Сезон - " + p-name.
                {&OPEN-QUERY-BROWSE-2}
                end.
        enable s-name with frame {&frame-name}.
        hide s-artic  s-name-cnt in frame {&frame-name}.
        display s-name with frame {&frame-name}.
   end.
  when 3 then do:
        enable s-name-cnt with frame {&frame-name}.
        hide s-artic  s-name in frame {&frame-name}.
        display s-name-cnt with frame {&frame-name}.
   end.

  end case.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME s-artic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL s-artic Dialog-Frame
ON MOUSE-SELECT-DBLCLICK OF s-artic IN FRAME Dialog-Frame
OR  RETURN OF s-artic IN FRAME {&frame-name}
DO:
  if s-artic <> input frame {&frame-name} s-artic or sch-field <> "s-artic" then do:

 sch-field = "s-artic".
 assign s-artic = input frame {&frame-name} s-artic.

 doc-rec = ?.
 for each buf_gds-season no-lock where
          buf_gds-season.sea-code = p-sea-code and
          buf_gds-season.db-num   = p-db-num ,
            first buf_goods no-lock where
                  buf_goods.gds-code = buf_gds-season.gds-code and
                  buf_goods.artic begins s-artic :
         doc-rec = recid ( buf_gds-season ) .
         leave.
 end.
  if doc-rec = ? then message "Товар не найден !"  .
  else
      reposition {&browse-name} to recid doc-rec no-error.

return no-apply.
end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME s-name
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL s-name Dialog-Frame
ON MOUSE-SELECT-DBLCLICK OF s-name IN FRAME Dialog-Frame
OR  RETURN OF s-name IN FRAME {&frame-name}
DO:
  if s-name <> input frame {&frame-name} s-name or sch-field <> "s-name" then do:

 sch-field = "s-name".
 assign s-name = input frame {&frame-name} s-name.

 doc-rec = ?.
 for each buf_gds-season no-lock where
          buf_gds-season.sea-code = p-sea-code and
          buf_gds-season.db-num   = p-db-num ,
            first buf_goods no-lock where
                  buf_goods.gds-code = buf_gds-season.gds-code and
                  buf_goods.gds-name begins s-name
                  :
         doc-rec = recid(buf_gds-season) .
         leave.
 end.
  if doc-rec = ? then message "Товар не найден !"  .
  else
      reposition {&browse-name} to recid doc-rec no-error.

return no-apply.
end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME s-name-cnt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL s-name-cnt Dialog-Frame
ON MOUSE-SELECT-DBLCLICK OF s-name-cnt IN FRAME Dialog-Frame
OR  RETURN OF s-name-cnt IN FRAME {&frame-name}
DO:
  if s-name-cnt <> input frame {&frame-name} s-name-cnt or sch-field <> "s-name-cnt" then do:

 sch-field = "s-name-cnt".
 assign s-name-cnt = input frame {&frame-name} s-name-cnt.

 doc-rec = ?.
 for each buf_gds-season no-lock where
          buf_gds-season.sea-code = p-sea-code and
          buf_gds-season.db-num   = p-db-num ,
            first buf_goods no-lock where
                  buf_goods.gds-code = buf_gds-season.gds-code  and
            INDEX (buf_goods.gds-name,s-name-cnt) > 0
            :
         doc-rec = recid(buf_gds-season) .
         leave.
 end.
  if doc-rec = ? then message "Товар не найден !"  .
  else do:
     assign frame {&frame-name}:title = "Товары >> Сезон - " + p-name + " , содержащие в названии " + s-name-cnt .
      {&OPEN-QUERY-BROWSE-2-alt}
     /* reposition {&browse-name} to recid doc-rec no-error. */
     end.
return no-apply.
end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

{ gbl/app_help.i }

assign frame {&frame-name}:title = "Товары >>-  " + p-name.

{ gbl/srt-clmn.i
  &browse-name    = "{&browse-name}"
  &frame-name     = "{&frame-name}"
  &table-name     = "{&first-table-in-query-{&browse-name}}"
  &sort-clmn_1    = "ub.goods.artic"
  &sort-clmn_2    = "ub.goods.gds-name"
  &sort-clmn_3    = "ub.goods.unit-base"
  &sort-clmn_4    = "ub.gds-season.min-stock"
  &open-query     = "run OpenBr."
  &open-query-otherwise = "run OpenBr."
  &sort-column-name     = "sort-column-name"
  &re-move-clmn         = "no"
  &mv-brw-default       = "no" }

 ASSIGN b-list:POPUP-MENU IN FRAME {&frame-name}   = MENU POPUP-MENU-b-list:HANDLE.
 ASSIGN b-list:MENU-MOUSE   = 1.

{ gbl/f2.i {&browse-name} " " " " parParentProc }
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:



  run enable_UI in this-procedure .

  find first  buf_season no-lock where
              buf_season.sea-code = p-sea-code and
              buf_season.db-num   = p-db-num
              no-error .
  if not available buf_season  then return error .
  IF BUF_SEASON.SEA-MONTH-1 = 0 THEN hide ub.gds-season.min-stock in browse  {&browse-name}  .
  enable  s-artic with frame {&frame-name}.
  Hide      s-name  s-name-cnt in frame {&frame-name}.
  display s-artic with frame {&frame-name}.

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
run disable_UI in this-procedure .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cycle-add Dialog-Frame
PROCEDURE cycle-add :
define variable dct-type as character no-undo .
define variable  stp-cycl as logical no-undo .
define variable v-num as integer   no-undo .
define variable v-flag as logical   no-undo init false .
define buffer bb_gds-season for ub.gds-season.
define buffer old_season    for ub.season.
stp-cycl = false .

if buf_season.sea-month-1 = 0 then dct-type = "coll". else dct-type = "season" .

if dct-type = "coll" then do:
            run gbl/d-askw.w
              (input "Вопрос" /* Заголовок окна */
              ,input "Если товар уже прикреплен к коллекции, пропускаем его?"
              ,input "|^" /* Символы разделители для кодирования двух следующих параметров */
              ,input "Не добавлять|Добавлять|Остановка" /* список названий кнопок  */
              ,input "Не добавляем товар в новую коллекцию, товар остается в старой коллекции|" /* список описаний кнопок */
                  + "Добавляем товар в новую коллекцию и удаляем в старой коллекции|"
                  + "Остановить добавление товаров, если встречаются товары прикрепленные к другим коллекциям."
              ,input 1 /* значение возвращаемое при нажатии enter */
              ,input 2 /* значение возвращаемое при нажатии escape */
              ,output v-num /* выбор пользователя */
              ).
case v-num :
when 1 then do:
    for each tt-gds-list no-lock  by tt-gds-list.nn :
        lns-cnt  =  lns-cnt + 1 .
        if lns-cnt > 1 then assign line-mode = "ЦИКЛ":U.
          v-flag = false .
          for each   bb_gds-season no-lock where
                     bb_gds-season.gds-code = tt-gds-list.gds-code  ,
               each old_season no-lock where
                    old_season.sea-code = bb_gds-season.sea-code and
                    old_season.db-num   = bb_gds-season.db-num   and
                    old_season.sea-month-1 = 0
                    :
                    v-flag = true .
                    leave.
           end.

           if  v-flag = false   then do:
             find first gds-season no-lock
                  where ub.gds-season.gds-code = tt-gds-list.gds-code
                    and ub.gds-season.sea-code = p-sea-code
                    and ub.gds-season.db-num   = p-db-num
                    and ub.gds-season.min-stock = 0 no-error.
             if not available gds-season then do :
               create gds-season.
               assign
                   ub.gds-season.gds-code = tt-gds-list.gds-code
                   ub.gds-season.sea-code = p-sea-code
                   ub.gds-season.db-num   = p-db-num
                   ub.gds-season.min-stock = 0
               .
             end.
          end.
        if  stp-cycl = true then leave.
    end.

end.
when 2 then do:
    for each tt-gds-list no-lock  by tt-gds-list.nn :
        lns-cnt  =  lns-cnt + 1 .
        if lns-cnt > 1 then assign line-mode = "ЦИКЛ":U.
          v-flag = false .
          for each  bb_gds-season exclusive-lock  where
                    bb_gds-season.gds-code = tt-gds-list.gds-code ,
               each old_season no-lock where
                    old_season.sea-code = bb_gds-season.sea-code and
                    old_season.db-num   = bb_gds-season.db-num   and
                    old_season.sea-month-1 = 0
                    :
                    delete bb_gds-season .
           end.

            find first gds-season no-lock
                 where ub.gds-season.gds-code = tt-gds-list.gds-code
                   and ub.gds-season.sea-code = p-sea-code
                   and ub.gds-season.db-num   = p-db-num
                   and ub.gds-season.min-stock = 0 no-error.
            if not available gds-season then do :
              create gds-season.
              assign
                  ub.gds-season.gds-code = tt-gds-list.gds-code
                  ub.gds-season.sea-code = p-sea-code
                  ub.gds-season.db-num   = p-db-num
                  ub.gds-season.min-stock = 0
              .
            end.
        if  stp-cycl = true then leave.
    end.

end.
when 3 then do:
    for each tt-gds-list no-lock  by tt-gds-list.nn :
        lns-cnt  =  lns-cnt + 1 .
        if lns-cnt > 1 then assign line-mode = "ЦИКЛ":U.
          v-flag = false .
          for each   bb_gds-season no-lock where
                     bb_gds-season.gds-code = tt-gds-list.gds-code  ,
               each old_season no-lock where
                    old_season.sea-code = bb_gds-season.sea-code and
                    old_season.db-num   = bb_gds-season.db-num   and
                    old_season.sea-month-1 = 0 :
                    v-flag = true .
                    leave.
           end.
           if  v-flag = true  then do:
               leave .
           end.
        if  stp-cycl = true then leave.
    end.
        if v-flag <> true then do :
          for each tt-gds-list no-lock  by tt-gds-list.nn :
            find first gds-season no-lock
                 where ub.gds-season.gds-code = tt-gds-list.gds-code
                   and ub.gds-season.sea-code = p-sea-code
                   and ub.gds-season.db-num   = p-db-num
                   and ub.gds-season.min-stock = 0 no-error.
            if not available gds-season then do :
              create gds-season.
              assign
                  ub.gds-season.gds-code = tt-gds-list.gds-code
                  ub.gds-season.sea-code = p-sea-code
                  ub.gds-season.db-num   = p-db-num
                  ub.gds-season.min-stock = 0
              .
            end.
          end.
        end.
end.

end case.




end.
else do:
    for each tt-gds-list no-lock  by tt-gds-list.nn :
        lns-cnt  =  lns-cnt + 1 .
        if lns-cnt > 1 then assign line-mode = "ЦИКЛ":U.
        if not can-find (first ub.gds-season where
            ub.gds-season.gds-code = tt-gds-list.gds-code and
            ub.gds-season.sea-code = p-sea-code and
            ub.gds-season.db-num   = p-db-num no-lock
            ) then do:
            create ub.gds-season.
            assign
                ub.gds-season.gds-code  = tt-gds-list.gds-code
                ub.gds-season.sea-code  = p-sea-code
                ub.gds-season.db-num    = p-db-num
                ub.gds-season.min-stock = 0
            .
        end.
        if  stp-cycl = true then leave.
    end.
end.
  ASSIGN lns-cnt = lns-cnt + 1 .

end procedure.

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
  DISPLAY R-sort s-name s-name-cnt s-artic FILL-IN-2 mark-num
      WITH FRAME Dialog-Frame.
  ENABLE b-exit b-add b-del b-list b-help R-sort s-artic BROWSE-2 FILL-IN-2
         mark-num
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenBr Dialog-Frame
PROCEDURE OpenBr :
define variable t-ret as logical no-undo .
t-ret =  session:SET-WAIT-STATE("GENERAL") .
&scop my-open-query     if r-sort = 3 and sch-field = "s-name-cnt" then do: ~
    assign frame ~{&frame-name}:title = "Товары >> Сезон - " + p-name + " , содержащие в названии " + s-name-cnt . ~
   ~{&OPEN-QUERY-BROWSE-2-alt}  ~
   end. ~
   else DO: ~
    assign frame ~{&frame-name}:title = "Товары >> Сезон - " + p-name. ~
   ~{&OPEN-QUERY-BROWSE-2} ~
   end.

case sort-column-name :
  when "" then do:
    &scop SORTBY-PHRASE
    {&my-open-query}
  end.

  when "ub.goods.artic" then do:
    &scop SORTBY-PHRASE by ub.goods.artic
    {&my-open-query}
  end.

  when "ub.goods.gds-name" then do:
    &scop SORTBY-PHRASE by ub.goods.gds-name
    {&my-open-query}
  end.

  when "ub.goods.unit-base" then do:
    &scop SORTBY-PHRASE by ub.goods.unit-base
    {&my-open-query}
  end.

  when "ub.gds-season.min-stock" then do:
    &scop SORTBY-PHRASE by ub.gds-season.min-stock
    {&my-open-query}
  end.

  otherwise do:
    &scop SORTBY-PHRASE
    {&my-open-query}
  end.
end case.

t-ret =  session:SET-WAIT-STATE("") .
apply "HOME" to {&browse-name} in frame {&frame-name}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-b-list Dialog-Frame
PROCEDURE proc-b-list :
define input parameter loc-list-option as character no-undo.

define buffer   loc-gds-season for ub.gds-season.

define variable v-sea-code    like ub.gds-season.sea-code no-undo.
define variable jj as integer no-undo.
define variable varrid-gds-season as recid no-undo.
define variable f-name as character init "default.cli" no-undo.
define variable imp-type         like ub.goods.prod-type no-undo.
define variable imp-code         like ub.goods.prod-code no-undo.
define variable loc-gds-code     like ub.gds-season.gds-code no-undo.
define variable loc-min-stock    like ub.gds-season.min-stock no-undo.
define variable loc-sea-code     like ub.gds-season.sea-code no-undo.
define variable loc-db-num       like ub.gds-season.db-num no-undo.

v-sea-code =  p-sea-code .
case loc-list-option:
  when "save":U then do:
    g#log = yes.
    message "Сохранить все товары в файле списка"
    view-as alert-box question buttons OK-Cancel update g#log.
    if not g#log then do:
      list-option = "":U.
      return.
    end.
    assign
    f-name = "default.sea"
    g#log = yes
    .
    system-dialog get-file f-name
    filters "Списки товаров  *.sea" "*.sea"
    ask-overwrite
    save-as
    use-filename
    update g#log
    default-extension "sea".
    if not g#log then do:
      list-option = "":U.
      return.
    end.
    g#log =  session:SET-WAIT-STATE("GENERAL") .

    output stream sout to value (f-name).
      for each loc-gds-season No-LOCK WHERE
                 loc-gds-season.sea-code = v-sea-code and
                 loc-gds-season.db-num   = p-db-num
                 :
      export stream sout
      loc-gds-season.gds-code
      loc-gds-season.min-stock
      loc-gds-season.sea-code
      loc-gds-season.db-num
      .
      END.
      output stream sout close.
      g#log =  session:SET-WAIT-STATE("") .
    end.


    when "load":U then do:

      system-dialog get-file f-name
      filters "Списки клиентов *.sea" "*.sea"
      title "Выберите файл списка"
      INITIAL-DIR "."
      return-to-start-dir
      must-exist
      /* use-filename */
      update g#log
      default-extension "sea".
      if not g#log then do:
       list-option = "":U.
       return.
      end.
      g#log =  session:SET-WAIT-STATE("GENERAL") .
      input stream sout from value (f-name).
      _repeat:
      repeat:
        import stream sout
                      loc-gds-code
                      loc-min-stock
                      loc-sea-code
                      loc-db-num
                      no-error.

       find first loc-gds-season exclusive-LOCK WHERE
            loc-gds-season.gds-code = loc-gds-code  and
            loc-gds-season.sea-code = v-sea-code and
            loc-gds-season.db-num   = p-db-num
            no-error.
        if not available loc-gds-season then create loc-gds-season.

        assign
          loc-gds-season.gds-code   = loc-gds-code
          loc-gds-season.min-stock  = loc-min-stock
          loc-gds-season.sea-code   = v-sea-code
          loc-gds-season.db-num     = p-db-num

        .

    end.
    input stream sout close.
    g#log =  session:SET-WAIT-STATE("") .
    {&OPEN-QUERY-BROWSE-2}
   end.
END CASE.
loc-list-option = "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME