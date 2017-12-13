&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*------------------------------------------------------------------------

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Градуировочная таблица для резервуара

Автор: Уханов Дмитрий Юрьевич
Дата создания: 01/28/09
Author: Dmitry Ukhanov
Creation date: 01/28/09

Автор1: Белоусов Илья Александрович
Дата создания1: 12/24/07

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Градуировочная таблица для резервуара".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ cmp/showinf.i  }
{ gbl/waitfram.i }
/* Parameters Definitions ---                                           */
define input parameter parparentproc   as widget-handle  no-undo .
define input parameter p-obj-type      as character      no-undo .
define input parameter p-obj-code      as integer        no-undo .
define input parameter p-pl-code       as integer        no-undo .

define buffer buf_pl-level for ub.pl-level .
define buffer buf_place    for ub.place .
/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME BROWSE-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES buf_pl-level

/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 buf_pl-level.pl-level pl-qnty 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define QUERY-STRING-BROWSE-2 FOR EACH buf_pl-level ~
      WHERE buf_pl-level.obj-type = p-obj-type ~
 AND buf_pl-level.obj-code = p-obj-code ~
 AND buf_pl-level.pl-code = p-pl-code NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH buf_pl-level ~
      WHERE buf_pl-level.obj-type = p-obj-type ~
 AND buf_pl-level.obj-code = p-obj-code ~
 AND buf_pl-level.pl-code = p-pl-code NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 buf_pl-level
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 buf_pl-level


/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Dialog-Frame ~
    ~{&OPEN-QUERY-BROWSE-2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-exit b-add b-chg b-del b-load b-delete ~
b-help BROWSE-2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-add 
  LABEL "&Добавить" 
  SIZE 10 BY 1.

DEFINE BUTTON b-chg 
  LABEL "&Изменить" 
  SIZE 10 BY 1.

DEFINE BUTTON b-del 
  LABEL "&Удалить" 
  SIZE 10 BY 1.

DEFINE BUTTON b-delete 
  LABEL "Очистить" 
  SIZE 9 BY 1.

DEFINE BUTTON b-exit AUTO-GO 
  LABEL "&Выход" 
  SIZE 10 BY 1
  BGCOLOR 8 .

DEFINE BUTTON b-help 
  LABEL "Помо&щь" 
  SIZE 10 BY 1
  BGCOLOR 8 .

DEFINE BUTTON b-load 
  LABEL "&Загрузить" 
  SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-2 FOR 
  buf_pl-level SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 Dialog-Frame _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
  buf_pl-level.pl-level COLUMN-LABEL "Уровень, см"
  pl-qnty WIDTH 41.5
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 66 BY 17.5 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
  b-exit AT ROW 1 COL 1
  b-add AT ROW 1 COL 11 WIDGET-ID 2
  b-chg AT ROW 1 COL 21 WIDGET-ID 4
  b-del AT ROW 1 COL 31 WIDGET-ID 6
  b-load AT ROW 1 COL 41 WIDGET-ID 8
  b-delete AT ROW 1 COL 51 WIDGET-ID 10
  b-help AT ROW 1 COL 57
  BROWSE-2 AT ROW 2.25 COL 1 WIDGET-ID 200
  WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
  SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
  TITLE "Градуировочная таблица"
  DEFAULT-BUTTON b-exit WIDGET-ID 100.


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
/* BROWSE-TAB BROWSE-2 b-help Dialog-Frame */
ASSIGN 
  FRAME Dialog-Frame:SCROLLABLE = FALSE
  FRAME Dialog-Frame:HIDDEN     = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "buf_pl-level"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "buf_pl-level.obj-type = p-obj-type
 AND buf_pl-level.obj-code = p-obj-code
 AND buf_pl-level.pl-code = p-pl-code"
     _FldNameList[1]   > "_<CALC>"
"buf_pl-level.pl-level" ? ? ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"pl-qnty" ? ? "decimal" ? ? ? ? ? ? no ? no no "54.63" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Градуировочная таблица */
  DO:
    APPLY "END-ERROR":U TO SELF.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-add Dialog-Frame
ON CHOOSE OF b-add IN FRAME Dialog-Frame /* Добавить */
  DO:
    define variable v-level as integer no-undo.
    define variable v-ok    as logical no-undo.
    assign
      v-level = ?
      .
    run ref/pl-lvl.w
      ( input parparentproc
      , input p-obj-type
      , input p-obj-code
      , input p-pl-code
      , input-output v-level
      , output v-ok
      ) no-error.
    if error-status:error then 
    do:
      message
        error-status:get-message(1) skip
        return-value
        view-as alert-box error .

      return no-apply .
    end.
    IF v-ok then 
    do:
      run enable_UI in this-procedure.
    end.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-chg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-chg Dialog-Frame
ON CHOOSE OF b-chg IN FRAME Dialog-Frame /* Изменить */
  DO:
    define variable v-level as integer no-undo.
    define variable v-ok    as logical no-undo.

    if available buf_pl-level then 
    do:
      assign
        v-level = buf_pl-level.pl-level
        .
      run ref/pl-lvl.w
        ( input parparentproc
        , input buf_pl-level.obj-type
        , input buf_pl-level.obj-code
        , input buf_pl-level.pl-code
        , input-output v-level
        , output v-ok
        ) no-error.
      if error-status:error then 
      do:
        message
          error-status:get-message(1) skip
          return-value
          view-as alert-box error .

        return no-apply .
      end.
    end.
    if v-ok then 
    do:
      run enable_ui in this-procedure.
    end.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-del Dialog-Frame
ON CHOOSE OF b-del IN FRAME Dialog-Frame /* Удалить */
  DO:
    if available buf_pl-level then 
    do:
      run del-pl-level in this-procedure no-error.
      IF ERROR-STATUS:ERROR then 
      do:
        message
          error-status:get-message(1) skip
          return-value
          view-as alert-box error .

        return no-apply .
      end.
      else 
      do:
        run enable_UI in this-procedure.
      end.
    end.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-delete Dialog-Frame
ON CHOOSE OF b-delete IN FRAME Dialog-Frame /* Очистить */
  DO:
   
    define variable v-delete as logical no-undo.
    if available buf_pl-level then 
    do:
      message
        SUBSTITUTE ( "Очистить таблицу? " ) 
                  
        view-as alert-box information
        BUTTONS YES-NO
        update v-delete
        .
      IF v-delete
        THEN 
      DO:
        run waitfram-show in this-procedure ( input "Ждите...").
   
        FOR EACH buf_pl-level 
          WHERE buf_pl-level.obj-type = p-obj-type 
          AND buf_pl-level.obj-code = p-obj-code 
          AND buf_pl-level.pl-code = p-pl-code .
 
          delete buf_pl-level.
        end.
        run waitfram-hide in this-procedure.
        if error-status:error then 
        do:
          message 
            error-status:get-message(1) skip
            return-value
            view-as alert-box error.
          return no-apply.
        end.
        else 
        do:
          run enable_UI in this-procedure.
        end.
      END.
    end.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-exit Dialog-Frame
ON CHOOSE OF b-exit IN FRAME Dialog-Frame /* Выход */
  DO:
    define variable v-gap as character no-undo.
    define variable v-ok  as logical   no-undo.

    run check-pl-level in this-procedure ( OUTPUT v-gap ).
    IF v-gap <> ""
      THEN 
    DO:
      message
        "В тарировочной таблице имеются пропуски. Пропущены следующие уровни:"
        skip v-gap
        SKIP 
        "Выйти и оставить пропуски?"
        view-as alert-box information
        BUTTONS YES-NO
        update v-ok
        .
      IF NOT v-ok THEN 
      DO:
        RETURN NO-APPLY.
      END.
    END.

    if AVAILABLE (buf_pl-level) then 
    do:
      /*запуск машины правил для выгрузки резервуара*/
    { gbl/rum-runa.i
        ?
        this-procedure:handle
        ?
        {&thref-proc_ref-event}
        " buffer buf_pl-level:handle "
        " buffer buf_pl-level:handle "
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


&Scoped-define SELF-NAME b-load
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-load Dialog-Frame
ON CHOOSE OF b-load IN FRAME Dialog-Frame /* Загрузить */
  DO:
    define variable v-file-name as character no-undo.
    define variable v-dir-name  as character no-undo.
    define variable v-ok        as logical   no-undo.

    run gbl/d-file.p  ( input-output v-file-name
      , input-output v-dir-name
      , input  "":U
      , input  "":U
      , input  "":U
      , input  "":U
      , input  TRUE
      , input  FALSE
      , input  TRUE
      , input  "Файл для загрузки тарировочной таблицы"
      , output v-ok
      ) .
    IF v-ok
      AND v-file-name <> "":U
      AND v-file-name <> ?
      THEN 
    DO:
      run utl/tarir2.p  ( INPUT v-file-name
        , INPUT p-obj-type
        , INPUT p-obj-code
        , INPUT p-pl-code
        ) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN 
      DO:
        message
          error-status:get-message(1) skip
          return-value
          view-as alert-box error .

        return no-apply .
      end.
      run enable_UI in this-procedure.
    END.
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
{ gbl/hot-key.i b-add }
{ gbl/hot-key.i b-chg }

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
  ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  find first buf_place
    where buf_place.obj-type = p-obj-type
    and buf_place.obj-code = p-obj-code
    and buf_place.pl-code  = p-pl-code
    no-lock
    no-error
    .
  IF NOT AVAILABLE buf_place THEN 
  DO:
    return error SUBSTITUTE ( "Не найдено складское место &1 &2 &3"
      , p-pl-code
      , p-obj-code
      , p-obj-type
      ) .
  end.

  ASSIGN
    FRAME Dialog-Frame:TITLE = SUBSTITUTE  ( "Градуировочная таблица для резервуара &1 (&2) &3 &4"
                                             , p-pl-code
                                             , buf_place.loc1
                                             , p-obj-code
                                             , p-obj-type
                                             )
    .

  RUN enable_UI.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.

END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE check-pl-level Dialog-Frame 
PROCEDURE check-pl-level :
  /*------------------------------------------------------------------------------
    Purpose:
    Parameters:  <none>
    Notes:
  ------------------------------------------------------------------------------*/
  define output parameter p-error as character        no-undo.

  define buffer bf_pl-level for ub.pl-level .

  define variable v-pl-level-begin as integer no-undo.
  define variable v-pl-level-end   as integer no-undo.
  define variable v-count          as integer no-undo.

  FIND FIRST bf_pl-level
    where bf_pl-level.obj-type = p-obj-type
    and bf_pl-level.obj-code = p-obj-code
    and bf_pl-level.pl-code  = p-pl-code
    no-lock
    no-error.
  IF NOT AVAILABLE bf_pl-level THEN 
  DO:
    RETURN.
  END.
  assign
    v-pl-level-begin = bf_pl-level.pl-level
    .
  FIND LAST  bf_pl-level
    where bf_pl-level.obj-type = p-obj-type
    and bf_pl-level.obj-code = p-obj-code
    and bf_pl-level.pl-code  = p-pl-code
    no-lock
    .
  assign
    v-pl-level-end = bf_pl-level.pl-level
    .
  do v-count = v-pl-level-begin to v-pl-level-end :
    IF NOT CAN-FIND(FIRST bf_pl-level
      where bf_pl-level.obj-type = p-obj-type
      and bf_pl-level.obj-code = p-obj-code
      and bf_pl-level.pl-code  = p-pl-code
      and bf_pl-level.pl-level = v-count
      no-lock)
      THEN 
    DO:
      ASSIGN
        p-error = IF p-error = "" THEN STRING(v-count)
                                     ELSE SUBSTITUTE  ( "&1,&2"
                                                      , p-error
                                                      , v-count
                                                      )
        .
    END.

  END.





END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE del-pl-level Dialog-Frame 
PROCEDURE del-pl-level :
  /*------------------------------------------------------------------------------
    Purpose:
    Parameters:  <none>
    Notes:
  ------------------------------------------------------------------------------*/
  define buffer bf_pl-level for ub.pl-level .

  define variable v-ok  as logical no-undo.
  define variable v-del as logical no-undo.

  message
    SUBSTITUTE ( "Удалить ровень &1 "
    , buf_pl-level.pl-level
    )
    view-as alert-box information
    BUTTONS YES-NO
    update v-del
    .
  IF v-del
    THEN 
  DO
    on error undo, return error
    :
    IF CAN-FIND(FIRST bf_pl-level
      where bf_pl-level.obj-type = p-obj-type
      and bf_pl-level.obj-code = p-obj-code
      and bf_pl-level.pl-code  = p-pl-code
      and bf_pl-level.pl-level < buf_pl-level.pl-level
      no-lock)
      AND CAN-FIND(FIRST bf_pl-level
      where bf_pl-level.obj-type = p-obj-type
      and bf_pl-level.obj-code = p-obj-code
      and bf_pl-level.pl-code  = p-pl-code
      and bf_pl-level.pl-level > buf_pl-level.pl-level
      no-lock)
      THEN 
    DO:
      message
        SUBSTITUTE ( "Уровень &1 находится в середине градуировочной таблицы"
        , buf_pl-level.pl-level
        )
        skip 
        "При его удалении возникнут пропуски в таблице."
        skip 
        "Все равно удалить Удалить?"
        view-as alert-box information
        BUTTONS YES-NO
        update v-ok
        .
      IF v-ok THEN 
      DO:
        FIND FIRST bf_pl-level
          where RowID(bf_pl-level) = RowID(buf_pl-level)
          exclusive-lock
          .
        DELETE bf_pl-level .
      END.
    END.
    ELSE 
    DO:
      FIND FIRST bf_pl-level
        where RowID(bf_pl-level) = RowID(buf_pl-level)
        exclusive-lock
        .
      DELETE bf_pl-level .
    END.
  END. /* v-del do on error */
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
  ENABLE b-exit b-add b-chg b-del b-load b-delete b-help BROWSE-2 
    WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

