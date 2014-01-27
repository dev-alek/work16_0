&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases
          ub               PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME d-type-tmp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS d-type-tmp
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Справочник сезонов

Автор: Чернова Светлана Александровна
Дата создания: 09/07/05
Author: Svetlana Chernova
Creation date: 09/07/05

Нужен для расчета темпа продаж в заказе

bttns =
  b-add
  b-sel
  b-mark

*/

define input  parameter parParentProc  as widget-handle no-undo.
define input  parameter bttns  as character   no-undo .
define output parameter rid-list    as  character no-undo . /* список recid'ов выбранных аписей */


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Справочник сезонов".
{ cmp/vssrevis.i }
{ cmp/showinf.i  }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ gbl/getcntxt.i def }
{ cmp/r-pril.i new }
{ gbl/cur-time.i   }
{ cmp/operlist.i   }
{ gbl/waitfram.i   }
{ gbl/getcntxt.i get }
define variable g#report-num as integer   no-undo .
run get-report-num  in parParentProc ( output g#report-num ).
define variable log-res as log no-undo.
define variable rr as recid no-undo.
define variable v-log as logical   no-undo .

def stream ListStream .

define variable sort-column-name as character no-undo .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME d-type-tmp
&Scoped-define BROWSE-NAME br-season

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ub.season

/* Definitions for BROWSE br-season                                     */
&Scoped-define FIELDS-IN-QUERY-br-season ~
(IF ( CAN-DO (rid-list, string( recid( ub.season ) ) ) ) THEN ("*") ELSE (" ")) ~
ub.season.sea-code ub.season.sea-name mon-name(ub.season.sea-month-1) ~
mon-name(ub.season.sea-month-2)
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-season
&Scoped-define QUERY-STRING-br-season FOR EACH ub.season ~
      WHERE ub.season.sea-month-1 <> 0 ~
 AND ub.season.sea-month-2 <> 0 NO-LOCK
&Scoped-define OPEN-QUERY-br-season OPEN QUERY br-season FOR EACH ub.season ~
      WHERE ub.season.sea-month-1 <> 0 ~
 AND ub.season.sea-month-2 <> 0 NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-season ub.season
&Scoped-define FIRST-TABLE-IN-QUERY-br-season ub.season


/* Definitions for DIALOG-BOX d-type-tmp                                */
&Scoped-define OPEN-BROWSERS-IN-QUERY-d-type-tmp ~
    ~{&OPEN-QUERY-br-season}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-exit b-sel b-goods b-hist b-help B-mark ~
b-add b-upd b-del mark-num b-print br-season
&Scoped-Define DISPLAYED-OBJECTS mark-num

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD mon-name d-type-tmp
FUNCTION mon-name RETURNS CHARACTER
( input n-mon as int)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-add
     LABEL "&Добавить":L
     SIZE 9 BY 1.

DEFINE BUTTON b-del
     LABEL "&Удалить"
     SIZE 10 BY 1.

DEFINE BUTTON b-exit AUTO-GO
     LABEL "&Выход ":L
     SIZE 12 BY 1.

DEFINE BUTTON b-goods
     LABEL "Товары":L
     SIZE 10 BY 1.

DEFINE BUTTON b-help
     LABEL "Помо&щь":L
     SIZE 10 BY 1.

DEFINE BUTTON b-hist
     LABEL "Ис&тория"
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

DEFINE VARIABLE mark-num AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     SIZE 9 BY 1
     FGCOLOR 4  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-season FOR
      ub.season SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-season
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-season d-type-tmp _STRUCTURED
  QUERY br-season NO-LOCK DISPLAY
      (IF ( CAN-DO (rid-list, string( recid( ub.season ) ) ) ) THEN ("*") ELSE (" ")) COLUMN-LABEL "*" FORMAT "X(1)":U
      ub.season.sea-code COLUMN-LABEL "Код" FORMAT ">>>>>>>>>9":U
      mon-name(ub.season.sea-month-1) COLUMN-LABEL "с" FORMAT "X(10)":U
      mon-name(ub.season.sea-month-2) COLUMN-LABEL "по" FORMAT "X(10)":U
      ub.season.sea-name FORMAT "X(100)":U
      ub.season.db-num COLUMN-LABEL "БД" FORMAT ">>>>9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 54.5 BY 18.46
         BGCOLOR 15 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME d-type-tmp
     b-exit AT ROW 1 COL 1
     b-sel AT ROW 1 COL 13
     b-goods AT ROW 1 COL 23
     b-hist AT ROW 1 COL 33
     b-help AT ROW 1 COL 43
     B-mark AT ROW 2 COL 1
     b-add AT ROW 2 COL 4
     b-upd AT ROW 2 COL 13
     b-del AT ROW 2 COL 23
     mark-num AT ROW 2 COL 34 NO-LABEL
     b-print AT ROW 2 COL 43
     br-season AT ROW 3.25 COL 1.5
     SPACE(0.37) SKIP(0.28)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE
         TITLE "Сезоны":L.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX d-type-tmp
                                                                        */
/* BROWSE-TAB br-season b-print d-type-tmp */
ASSIGN
       FRAME d-type-tmp:SCROLLABLE       = FALSE.

ASSIGN
       br-season:NUM-LOCKED-COLUMNS IN FRAME d-type-tmp     = 3.

/* SETTINGS FOR FILL-IN mark-num IN FRAME d-type-tmp
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-season
/* Query rebuild information for BROWSE br-season
     _TblList          = "ub.season"
     _Options          = "NO-LOCK"
     _Where[1]         = "season.sea-month-1 <> 0
 AND ub.season.sea-month-2 <> 0"
     _FldNameList[1]   > "_<CALC>"
"(IF ( CAN-DO (rid-list, string( recid( ub.season ) ) ) ) THEN (""*"") ELSE ("" ""))" "*" "X(1)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[2]   > ub.season.sea-code
"sea-code" "Код" ">>>>>>>>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[3]   > ub.season.sea-name
"sea-name" ? ? "character" ? ? ? ? ? ? no ":C20" no no ? yes no no "U" "" ""
     _FldNameList[4]   > "_<CALC>"
"mon-name(ub.season.sea-month-1)" "с" "X(10)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[5]   > "_<CALC>"
"mon-name(ub.season.sea-month-2)" "по" "X(10)" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE br-season */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX d-type-tmp
/* Query rebuild information for DIALOG-BOX d-type-tmp
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX d-type-tmp */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-add d-type-tmp
ON CHOOSE OF b-add IN FRAME d-type-tmp /* Добавить */
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

 run ref/seasoni.w ( parParentProc , {&add-def}, input-output rr ).
 if rr <> ? then
    do:
        {&open-query-br-season}
        reposition br-season to recid rr.
        log-res  = br-season:select-focused-row( ).
        apply "ENTRY":U to br-season.
        apply "home"    to br-season.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-del d-type-tmp
ON CHOOSE OF b-del IN FRAME d-type-tmp /* Удалить */
DO:

define variable g-log as logical   no-undo .
define variable v-recid as integer no-undo .
define variable ii as integer no-undo .
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

if not available ub.season or v-log = false then  return no-apply.

message "Удалить запись ? При этом удаляется привязка товаров к сезону."
          view-as alert-box question
          buttons yes-no
          update g-log.
          if g-log = false then return no-apply.

find current ub.season exclusive-lock no-error .
if available ub.season then delete ub.season.

{&OPEN-QUERY-br-season}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-goods
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-goods d-type-tmp
ON CHOOSE OF b-goods IN FRAME d-type-tmp /* Товары */
DO:
  if not available ub.season then return no-apply.
  run ref/seagdsl.w
    ( input Parparentproc,
      input ub.season.sea-code,
      input ub.season.db-num,
      input ub.season.sea-name
      ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-hist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-hist d-type-tmp
ON CHOOSE OF b-hist IN FRAME d-type-tmp /* История */
DO:
  find current ub.season no-lock no-error .
  if available ub.season THEN
      run ref/seasonh.w
      ( input parParentProc ,
        input ub.season.sea-code,
        input ub.season.db-num
        ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME B-mark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-mark d-type-tmp
ON CHOOSE OF B-mark IN FRAME d-type-tmp /* * */
DO:
  if not available ub.season then return.
  { gbl/markstrn.i ub.season rid-list }
    v-log = br-season :refresh( )  in frame {&frame-name}.
  if not can-do ("MOUSE-SELECT-DBLCLICK,Return", last-event:function) then do:
      v-log = br-season:select-next-row () in frame {&frame-name}.
      apply "iteration-changed" to br-season in frame {&frame-name}.
  end.

  if num-entries (rid-list) = 0 then
     hide mark-num in frame {&frame-name}.
  else
    disp num-entries (rid-list) @ mark-num
    with frame {&frame-name}.

  apply "entry" to br-season in frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-print d-type-tmp
ON CHOOSE OF b-print IN FRAME d-type-tmp /* Печать */
DO:
define variable sym1 as character init ":"   no-undo.
define variable sym2 as character init ":"   no-undo.
define variable sym3 as character init ":"   no-undo.
define variable sym4 as character init ":"   no-undo.
define variable sym5 as character init ":"   no-undo.

define variable Line                    as character         no-undo.

define variable ii      as integer   no-undo.
define variable StartRecid      as integer   no-undo.

DEFINE FRAME List
    sym1 column-label ":" format "x(1)"
    ub.season.sea-code column-label {&g___code} format ">>>>>>>>>>>>9"
    sym2 column-label ":" format "x(1)"
    ub.season.sea-name column-label "Наименование" format "x(89)"
    sym3 column-label ":" format "x(1)"
    ub.season.sea-month-1
    sym4 column-label ":" format "x(1)"
    ub.season.sea-month-2
    sym5 column-label ":" format "x(1)"
    HEADER
        cur-time-print () format "X(50)"
        string( "Страница " + string( PAGE-NUMBER( ListStream ) , ">>9") )
                AT 86 format "X(15)" SKIP
        Line format "x(110)" AT 1
    with width {&A4_CW} down use-text stream-io no-box .

/* if num-results( "br-season" ) = 0 then
    do:
        message "Список  П У С Т !" skip view-as alert-box information .
        return no-apply .
    end.
  */
run waitfram-show in this-procedure ("Ждите...").
Line = fill( "-" , 140 ) .
/*
Это из-за того, что в QUERY br-season используется index reposition и,
как следствие, не работает GET first br-season  ( ошибка 3157 )
*/
StartRecid = recid (ub.season).
{&OPEN-QUERY-br-season}
ii = 1 .
{ cmp/open-out.i stream ListStream }

FORM HEADER
    Line format "X(130)" SKIP
    "Продолжение - на следующей странице" AT 30 SKIP
    with FRAME CliBottomFrame width {&A4_CW} PAGE-BOTTOM NO-LABELS no-box.
VIEW stream ListStream FRAME CliBottomFrame .
PUT stream ListStream space(20)
    "С П И С О К  С Е З О Н О В "
    format "X(100)" SKIP(2) .
FORM with frame List .
  DO WHILE available ub.season :
      DISPLAY stream ListStream
            sym1 ub.season.sea-code
            sym2 ub.season.sea-name
            sym3 ub.season.sea-month-1
            sym4 ub.season.sea-month-2
            sym5    with frame List .
      DOWN stream ListStream 1 with frame List .
      ii =  ii + 1 .
      if ( ( ii modulo 10 ) = 0 ) AND ( ii >= 10 ) then
      run waitfram-show in this-procedure ( "Просмотрено строк : " + string( ii ) ) .
      GET next br-season .
  END.
PUT stream ListStream Line format "X(110)" SKIP.
HIDE stream ListStream FRAME CliBottomFrame .
output stream ListStream close .

define variable v-user-action as character no-undo .
define variable v-printed as logical   no-undo .
define variable DisabledOptions as integer   no-undo .
DisabledOptions = 0 .
run gbl/prnfilen.w
  (input  ""
  ,input  DisabledOptions
  ,input  string(session :temp-directory) + {&DF_Name} + string( g#report-num )
  ,input  7
  ,output v-user-action
  ,output v-printed
  ) .
  reposition br-season to recid StartRecid NO-ERROR .

run waitfram-hide in this-procedure .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-sel d-type-tmp
ON CHOOSE OF b-sel IN FRAME d-type-tmp /* Выбор  */
DO:
    if ( available ub.season ) AND ( rid-list = "" ) then
        rid-list = string( recid( ub.season ) ) .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-upd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-upd d-type-tmp
ON CHOOSE OF b-upd IN FRAME d-type-tmp /* Изменить */
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

    if not available ub.season or v-log = false then  return no-apply.


        rr = recid( ub.season ).
        run ref/seasoni.w
            (parParentProc , {&update}, input-output rr ).
        {&open-query-br-season}
        reposition br-season to recid rr .


 END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-season
&Scoped-define SELF-NAME br-season
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-season d-type-tmp
ON DEFAULT-ACTION OF br-season IN FRAME d-type-tmp
DO:
  case yes:
      when  b-upd:sensitive THEN apply "CHOOSE":U to b-upd.
  end case.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-season d-type-tmp
ON MOUSE-SELECT-DBLCLICK OF br-season IN FRAME d-type-tmp
DO:
    if lookup ( "b-sel", bttns ) > 0  then
        do:
            apply "choose" to b-sel in frame {&frame-name} .
            return no-apply .
        end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-season d-type-tmp
ON RETURN OF br-season IN FRAME d-type-tmp
DO:
    if Lookup( "b-sel",  bttns ) > 0 then
        do:
            apply "choose" to b-sel in frame {&frame-name} .
            return no-apply .
        end.
    else
        apply "DEFAULT-ACTION":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK d-type-tmp


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

{ gbl/app_help.i &browse-name="br-season" }

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    run enable_ui.
    APPLY "VALUE-CHANGED":U TO br-season in frame {&frame-name}.
    ub.season.sea-name:RESIZABLE in  browse {&browse-name}   = true .

    if num-entries (rid-list) = 0 then
        hide mark-num in frame {&frame-name}.
    else
        disp
        num-entries (rid-list) @ mark-num
        with frame {&frame-name}.
    WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
run disable_ui.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI d-type-tmp  _DEFAULT-DISABLE
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
  HIDE FRAME d-type-tmp.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI d-type-tmp
PROCEDURE enable_UI :
/* --------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other
               Settings" section of the widget Property Sheets.
   -------------------------------------------------------------------- */
    ENABLE
        br-season
        b-exit
        b-add WHEN  (lookup  ( "b-add" , bttns) > 0 )
        b-sel WHEN  (lookup  ( "b-sel" , bttns) > 0 )
        b-mark when (lookup  ( "b-mark", bttns) > 0 )
        b-upd WHEN  (lookup  ( "b-add" , bttns) > 0 )
        b-del WHEN  (lookup  ( "b-add" , bttns) > 0 )
        b-print
        b-hist
        b-help
        b-goods

        WITH FRAME  {&frame-name}.
    {&OPEN-BROWSERS-IN-QUERY-d-season}
    if available ub.season then
        log-res  = br-season:select-focused-row( ) in frame {&frame-name}.


     {&open-query-br-season}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION mon-name d-type-tmp
FUNCTION mon-name RETURNS CHARACTER
( input n-mon as int) :
define variable name-mon as character no-undo.
   run gbl/monthnam.p ( input n-mon, output name-mon ) .
 RETURN name-mon.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME