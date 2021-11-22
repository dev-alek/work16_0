&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

Данные по автотранспорту

Автор: Уханов Дмитрий Юрьевич
Дата создания: 08/16/07
Author: Dmitry Ukhanov
Creation date: 08/16/07

Автор: Перваков Михаил Сергеевич
Дата создания: 04/11/06
Author: Mikhail Pervakov
Creation date: 04/11/06

*/

/* ***************************  Definitions  ************************** */
/* Parameters Definitions ---                                           */
define input parameter parparentproc as widget-handle no-undo.
define input parameter parmode as character no-undo.
define input-output parameter parrecid as recid no-undo.

/* Local Variable Definitions ---                                       */
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Данные по автотранспорту".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/showinf.i  }

define variable ref-list as character no-undo.
define variable v-af-obj-code like ub.clients.obj-code no-undo.
define variable v-af-obj-type like ub.clients.obj-type no-undo.
define variable v-i AS INTEGER NO-UNDO.
define variable varauto-tank-sec as CHARACTER no-undo.
define variable parrec-meas as recid     no-undo.
define variable v-auto-num as character no-undo.
define variable v-auto-num-meas as character no-undo.
define variable v-meas-label as character no-undo.
define variable select-list as character no-undo .


DEFINE BUFFER buf_auto-tank FOR ub.auto-tank.
DEFINE BUFFER error_auto-tank-attr FOR ub.auto-tank-attr.
DEFINE BUFFER temp_auto-tank-attr FOR ub.auto-tank-attr.
DEFINE BUFFER buf_auto-tank-meas FOR ub.auto-tank-meas.
define buffer buf_auto-section for ub.auto-section.

DEFINE TEMP-TABLE tt_auto-tank-sec NO-UNDO
       FIELD sec-num AS integer
       FIELD brutto-qnty AS DECIMAL
       field add-volume as decimal
       .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

FUNCTION get-mark RETURNS CHARACTER
(buffer local-meas for auto-tank-meas ):
if lookup (string (recid (local-meas)), select-list) > 0  then return "*".
                                                           else return "".
end function.

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME brw-auto-meas

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES auto-tank-meas tt_auto-tank-sec

/* Definitions for BROWSE brw-auto-meas                                 */
&Scoped-define FIELDS-IN-QUERY-brw-auto-meas auto-tank-meas.meas-label ~
auto-tank-meas.meas-qnty 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brw-auto-meas 
&Scoped-define QUERY-STRING-brw-auto-meas FOR EACH auto-tank-meas ~
      WHERE auto-tank-meas.auto-num = varauto-num:screen-value + "#" + string(tt_auto-tank-sec.sec-num) NO-LOCK
&Scoped-define OPEN-QUERY-brw-auto-meas OPEN QUERY brw-auto-meas FOR EACH auto-tank-meas ~
      WHERE auto-tank-meas.auto-num = varauto-num:screen-value + "#" + string(tt_auto-tank-sec.sec-num) NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brw-auto-meas auto-tank-meas
&Scoped-define FIRST-TABLE-IN-QUERY-brw-auto-meas auto-tank-meas


/* Definitions for BROWSE brw-auto-num-sec                              */
&Scoped-define FIELDS-IN-QUERY-brw-auto-num-sec tt_auto-tank-sec.sec-num tt_auto-tank-sec.brutto-qnty tt_auto-tank-sec.dop-volume /*ENABLE tt_auto-tank-sec.diametr tt_auto-tank-sec.brutto-qnty*/   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brw-auto-num-sec   
&Scoped-define SELF-NAME brw-auto-num-sec
&Scoped-define QUERY-STRING-brw-auto-num-sec FOR EACH tt_auto-tank-sec EXCLUSIVE-LOCK
&Scoped-define OPEN-QUERY-brw-auto-num-sec OPEN QUERY brw-auto-num-sec FOR EACH tt_auto-tank-sec EXCLUSIVE-LOCK.
&Scoped-define TABLES-IN-QUERY-brw-auto-num-sec tt_auto-tank-sec
&Scoped-define FIRST-TABLE-IN-QUERY-brw-auto-num-sec tt_auto-tank-sec


/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Dialog-Frame ~
    ~{&OPEN-QUERY-brw-auto-num-sec}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-cancel b-help RECT-1 RECT-2 c-AC-type ~
b-choose-auto-firm C-neck f-error f-temp varPS b-view-sec brw-auto-num-sec 
&Scoped-Define DISPLAYED-OBJECTS varname varauto-num varauto-firm c-AC-type ~
C-neck f-error f-temp varPS 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-add-sec 
     LABEL "Добавить" 
     SIZE 10 BY 1.

DEFINE BUTTON b-cancel AUTO-END-KEY 
     LABEL "&Отмена" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-chg-sec 
     LABEL "Изменить" 
     SIZE 10 BY 1.

DEFINE BUTTON b-choose-auto-firm
     IMAGE-UP FILE "btn-down-arrow":U
     IMAGE-DOWN FILE "btn-down-arrow":U
     IMAGE-INSENSITIVE FILE "btn-down-arrow":U
     LABEL "b-choose-auto-firm"
     SIZE 3 BY 1.

DEFINE BUTTON b-del-sec 
     LABEL "Удалить" 
     SIZE 10 BY 1.

DEFINE BUTTON b-help
     LABEL "&Помощь"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-imp-meas 
     LABEL "Импорт" 
     SIZE 10 BY 1.

DEFINE BUTTON b-save AUTO-GO
     LABEL "&Ввод"
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-mark 
     LABEL "&*" 
     SIZE 3 BY 1 .

DEFINE BUTTON b-view-meas 
     LABEL "П&росмотр" 
     SIZE 10 BY 1.

DEFINE BUTTON b-view-sec 
     LABEL "Просмотр" 
     SIZE 10 BY 1.
     
DEFINE BUTTON b-sel-all
     LABEL "&+":L
     SIZE 3 BY 1 TOOLTIP "Отметить все объекты".

DEFINE BUTTON b-unmark
     LABEL "&-":L
     SIZE 3 BY 1 TOOLTIP "Снять все отметки".

DEFINE VARIABLE varPS AS CHARACTER
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 58.5 BY 2.88 DROP-TARGET NO-UNDO.

DEFINE VARIABLE varps-meas AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 76 BY 2.5
     BGCOLOR 8  DROP-TARGET NO-UNDO.

DEFINE VARIABLE varauto-firm AS CHARACTER FORMAT "X(256)"
     LABEL "Автопредприятие"
     VIEW-AS FILL-IN
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE varauto-num AS CHARACTER FORMAT "X(20)"
     LABEL "Гос. номер" 
     VIEW-AS FILL-IN
     SIZE 21.5 BY 1 TOOLTIP "Государственный регистрационный номер автомобиля" NO-UNDO.

DEFINE VARIABLE varname AS CHARACTER FORMAT "X(40)" 
     LABEL "Марка" 
     VIEW-AS FILL-IN
     SIZE 20.5 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77.5 BY 10.38.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brw-auto-num-sec FOR 
      tt_auto-tank-sec SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brw-auto-num-sec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brw-auto-num-sec Dialog-Frame _FREEFORM
  QUERY brw-auto-num-sec DISPLAY
      tt_auto-tank-sec.sec-num FORMAT ">>>>9":U LABEL "№ секции"
      tt_auto-tank-sec.brutto-qnty FORMAT "->>,>>>,>>9.<<<":U LABEL "Вместимость(л)"
      tt_auto-tank-sec.add-volume  FORMAT "->>,>>>,>>9.<<<":U LABEL "Дополнит. объем трубопровода нижнего налива(мм)"
  /*ENABLE
      tt_auto-tank-sec.diametr
      tt_auto-tank-sec.brutto-qnty*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 76 BY 7.88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     b-save AT ROW 1 COL 1
     b-cancel AT ROW 1 COL 11
     b-help AT ROW 1 COL 21
     varname AT ROW 2.5 COL 17.5 COLON-ALIGNED
     varauto-num AT ROW 2.5 COL 54 COLON-ALIGNED
     varauto-firm AT ROW 3.75 COL 17.5 COLON-ALIGNED WIDGET-ID 2
     c-AC-type AT ROW 3.75 COL 54 COLON-ALIGNED WIDGET-ID 36
     b-choose-auto-firm AT ROW 3.79 COL 36.88 WIDGET-ID 4
     C-neck AT ROW 5 COL 17.5 COLON-ALIGNED WIDGET-ID 38
     f-error AT ROW 7.25 COL 59.75 COLON-ALIGNED WIDGET-ID 46
     f-temp AT ROW 8.54 COL 3.75 WIDGET-ID 48
     varPS AT ROW 10.25 COL 19.5 NO-LABEL
     b-add-sec AT ROW 14.38 COL 2 WIDGET-ID 22
     b-chg-sec AT ROW 14.38 COL 12 WIDGET-ID 18
     b-del-sec AT ROW 14.38 COL 22 WIDGET-ID 32
     b-view-sec AT ROW 14.38 COL 32 WIDGET-ID 20
     brw-auto-num-sec AT ROW 15.63 COL 1.75 WIDGET-ID 100
     "Информация по секциям автотранспорта" VIEW-AS TEXT
          SIZE 36 BY .67 AT ROW 13.29 COL 21.75 WIDGET-ID 26
          FGCOLOR 4 
     "Примечание:" VIEW-AS TEXT
          SIZE 11.88 BY .88 AT ROW 11.29 COL 3.25
     "Метрологические характеристики" VIEW-AS TEXT
          SIZE 30.75 BY .67 AT ROW 6.17 COL 23.13 WIDGET-ID 44
          FGCOLOR 4 
     RECT-1 AT ROW 13.63 COL 1 WIDGET-ID 28
     RECT-2 AT ROW 6.5 COL 2 WIDGET-ID 40
     SPACE(1.37) SKIP(14.49)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Данные по автотранспорту"
         DEFAULT-BUTTON b-save CANCEL-BUTTON b-cancel.


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
/* BROWSE-TAB brw-auto-num-sec b-view-sec Dialog-Frame */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON b-add-sec IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b-chg-sec IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b-del-sec IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON b-save IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN f-temp IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN varauto-firm IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
ASSIGN 
       varauto-firm:READ-ONLY IN FRAME Dialog-Frame        = TRUE.

/* SETTINGS FOR FILL-IN varauto-num IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN varname IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
ASSIGN 
       varPS:RETURN-INSERTED IN FRAME Dialog-Frame  = TRUE
       varPS:READ-ONLY IN FRAME Dialog-Frame        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brw-auto-num-sec
/* Query rebuild information for BROWSE brw-auto-num-sec
     _START_FREEFORM
OPEN QUERY brw-auto-num-sec FOR EACH tt_auto-tank-sec EXCLUSIVE-LOCK.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brw-auto-num-sec */
&ANALYZE-RESUME


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Данные по автотранспорту */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-cancel Dialog-Frame
ON CHOOSE OF b-cancel IN FRAME Dialog-Frame /* Данные по автотранспорту */
DO:
  if not available ub.auto-tank then do:
    for each buf_auto-section exclusive-lock where buf_auto-section.auto-num = varauto-num:
      delete buf_auto-section .
    end.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-add-sec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-add-sec Dialog-Frame
ON CHOOSE OF b-add-sec IN FRAME Dialog-Frame /* Добавить */
DO:
      if varauto-num:screen-value = ? or trim(varauto-num:screen-value) = "" then do :
          message "Введите номер автотранспорта!" view-as alert-box.
          return no-apply.
      end .
      ASSIGN
/*        varauto-tank-num = if available ub.auto-tank then ub.auto-tank.auto-num else varauto-num:screen-value*/
        varauto-tank-sec = ?
      .
      run str/auto-tncs.w
        ( input        {&add-def}
         ,input        varauto-tank-num
         ,input-output varauto-tank-sec
        ) no-error.

      RUN init-proc.
      {&OPEN-QUERY-brw-auto-num-sec}
      FIND FIRST tt_auto-tank-sec WHERE tt_auto-tank-sec.sec-num = varauto-tank-sec NO-LOCK NO-ERROR.
      IF AVAILABLE tt_auto-tank-sec THEN DO:
            REPOSITION brw-auto-num-sec TO RECID recid(tt_auto-tank-sec) NO-ERROR.            
      END.
      for each tt_auto-tank-sec no-lock :
        disable varauto-num with frame {&frame-name}.
      end.     
      apply "value-changed" to brw-auto-num-sec in frame dialog-frame.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-chg-sec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-chg-sec Dialog-Frame
ON CHOOSE OF b-chg-sec IN FRAME Dialog-Frame /* Изменить */
DO:

    if available tt_auto-tank-sec then do:
      ASSIGN
        varauto-tank-sec = string(tt_auto-tank-sec.sec-num)
      .
      run str/auto-tncs.w
        ( input        {&update}
         ,input        varauto-num
         ,input        c-AC-type
         ,input        C-neck
         ,input-output varauto-tank-sec
        ) no-error.
      RUN init-proc.
      {&OPEN-QUERY-brw-auto-num-sec}
      FIND FIRST tt_auto-tank-sec WHERE tt_auto-tank-sec.sec-num = integer(varauto-tank-sec) NO-LOCK NO-ERROR.
      IF AVAILABLE tt_auto-tank-sec THEN DO:
            REPOSITION brw-auto-num-sec TO RECID recid(tt_auto-tank-sec) NO-ERROR.
      END.
      apply "value-changed" to brw-auto-num-sec in frame dialog-frame.
    end.
    else do:
      message "Не выбрана секция." view-as alert-box error.
    end.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-choose-auto-firm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-choose-auto-firm Dialog-Frame
ON CHOOSE OF b-choose-auto-firm IN FRAME Dialog-Frame /* b-choose-auto-firm */
DO:
  run ref/cli-all.w
  ( parparentproc
    , input  "b-sel"
    , ?
    , ?
    , ?
    , ?
    , ?
    , ?
  ,output ref-list
  ).
  If ref-list <> "" then do :
    find first ub.clients no-lock
         where recid(ub.clients) = integer(ref-list) no-error.
    if available ub.clients then do :
      varauto-firm = ub.clients.obj-type + " " + string(ub.clients.obj-code) .
    end.
  end.
  else do :
    varauto-firm = "".
  end.
  display varauto-firm WITH FRAME Dialog-Frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&Scoped-define SELF-NAME b-del-sec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-del-sec Dialog-Frame
ON CHOOSE OF b-del-sec IN FRAME Dialog-Frame /* Удалить */
DO:
  define variable varlog as log NO-UNDO.


    if available tt_auto-tank-sec then do:
      ASSIGN
        v-auto-num = varauto-num
      .

      MESSAGE "Удалить секцию?" view-as alert-box question
        buttons yes-no
        update varlog.
        if varlog = false then return no-apply.

      FOR EACH auto-tank-meas WHERE auto-tank-meas.auto-num = v-auto-num EXCLUSIVE-LOCK:
          FOR EACH auto-tank-meas-attr WHERE auto-tank-meas-attr.auto-num = v-auto-num
                                         AND auto-tank-meas-attr.meas-label = auto-tank-meas.meas-label EXCLUSIVE-LOCK:
              DELETE auto-tank-meas-attr.
          END.
          DELETE auto-tank-meas.
      END.

      FIND FIRST buf_auto-section WHERE buf_auto-section.auto-num = v-auto-num 
                                    and buf_auto-section.section-num = tt_auto-tank-sec.sec-num EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE buf_auto-section THEN
          DELETE buf_auto-tank.

      DELETE tt_auto-tank-sec.
      {&OPEN-QUERY-brw-auto-num-sec}

    end.
    else do:
      message "Не выбрана секция." view-as alert-box error.
    end.
    for each tt_auto-tank-sec no-lock :
        disable varauto-num with frame {&frame-name}.
    end.
    find first tt_auto-tank-sec no-lock no-error.
    if not available tt_auto-tank-sec then enable varauto-num with frame {&frame-name}.
    apply "value-changed" to brw-auto-num-sec in frame dialog-frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-imp-meas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-imp-meas Dialog-Frame
ON CHOOSE OF b-imp-meas IN FRAME Dialog-Frame /* Импорт */
DO:
    DEFINE VARIABLE vartmp AS CHAR NO-UNDO.
    DEFINE VARIABLE lOk AS LOG NO-UNDO.
    DEFINE VARIABLE varFileName AS CHARACTER NO-UNDO.
    DEFINE VARIABLE varmeas AS CHAR NO-UNDO.
    DEFINE VARIABLE varqnty AS CHAR NO-UNDO.

    SYSTEM-DIALOG GET-FILE varTmp
        TITLE      "Выберите файл для импорта ..."
        FILTERS    "CSV Files (*.csv)"   "*.csv",
                   "Все файлы (*.*)" "*.*"
        MUST-EXIST
        USE-FILENAME
        INITIAL-DIR "C:\"
        RETURN-TO-START-DIR
        UPDATE lOk.
    IF lOk THEN
        ASSIGN varFileName = varTmp.
    ELSE DO:
        MESSAGE "файл не найден" VIEW-AS ALERT-BOX.
        RETURN.
    END.

    FILE-INFO:FILE-NAME = varFileName.
    IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
        MESSAGE "Указанный файл не найден" VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.

    SESSION:SET-WAIT-STATE("GENERAL":U) NO-ERROR.

    INPUT FROM VALUE(varFileName).

    REPEAT:
        IMPORT DELIMITER ";" varmeas varqnty.
        
        IF NOT CAN-FIND( buf_auto-tank-meas WHERE buf_auto-tank-meas.auto-num = ub.auto-tank.auto-num + CHR(35) + tt_auto-tank-sec.sec-num
                                          AND buf_auto-tank-meas.meas-label = varmeas NO-LOCK) THEN DO:
            CREATE buf_auto-tank-meas.
            ASSIGN
                buf_auto-tank-meas.auto-num = ub.auto-tank.auto-num + CHR(35) + tt_auto-tank-sec.sec-num
                buf_auto-tank-meas.meas-label = varmeas
                buf_auto-tank-meas.meas-qnty = DECIMAL(varqnty)
                .
        END.
    END.

    INPUT CLOSE.

    MESSAGE "Импорт завершён." VIEW-AS ALERT-BOX.

    apply "value-changed" to brw-auto-num-sec in frame dialog-frame.

    SESSION:SET-WAIT-STATE("":U) NO-ERROR.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-save
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-save Dialog-Frame
ON CHOOSE OF b-save IN FRAME Dialog-Frame /* Ввод */
DO:
define variable v-auto-secnum as character no-undo .
define variable v-brutto-qnty as decimal no-undo .
define buffer auto-tank-sec for ub.auto-tank .

  if varauto-num:screen-value = ? or trim(varauto-num:screen-value) = "" 
  or varname:screen-value = ? or trim(varname:screen-value) = ""
  then do :
      message "Заполните поля 'марка' и 'гос. номер'" view-as alert-box.
      return no-apply .
  end.    
  
  if parmode = {&add-def} then do:
    if can-find (first ub.auto-tank where ub.auto-tank.auto-num = input frame {&frame-name} varauto-num)
    then do:
      message "Уже существует автотранспорт с гос. номером: " input frame {&frame-name} varauto-num view-as alert-box.
      return no-apply.
    end.
  end .
      
  assign
    v-auto-secnum = (input frame {&frame-name} varauto-num) + "#"
    v-brutto-qnty = 0
  .
  for each auto-tank-sec no-lock where auto-tank-sec.auto-num begins v-auto-secnum :
    v-brutto-qnty = v-brutto-qnty + auto-tank-sec.brutto-qnty .    
  end.
  
  if parmode = {&add-def} then do:
    create ub.auto-tank.
    assign
      ub.auto-tank.auto-num    = input frame {&frame-name} varauto-num
      ub.auto-tank.name        = input frame {&frame-name} varname
      ub.auto-tank.ps          = input frame {&frame-name} varps
      ub.auto-tank.brutto-qnty = v-brutto-qnty
      ub.auto-tank.status_     = {&current-status}
    .
    parrecid = recid(ub.auto-tank) .
    if varauto-firm <> "" then do :
      create ub.auto-tank-attr.
      assign
        ub.auto-tank-attr.auto-num  = ub.auto-tank.auto-num
        ub.auto-tank-attr.attr-code = "auto-firm"
        ub.auto-tank-attr.attr-value = input frame {&frame-name} varauto-firm
      .
    end.
  end. /* end_of create */
  else if parmode = {&update} then do:
     assign
       ub.auto-tank.auto-num    = input frame {&frame-name} varauto-num
       ub.auto-tank.name        = input frame {&frame-name} varname
       ub.auto-tank.ps          = input frame {&frame-name} varps
       ub.auto-tank.brutto-qnty = v-brutto-qnty
    .
    if varauto-firm > "" then do :
      if available ub.auto-tank-attr then ub.auto-tank-attr.attr-value = input frame {&frame-name} varauto-firm .
      else do :
        create ub.auto-tank-attr.
        assign
          ub.auto-tank-attr.auto-num  = ub.auto-tank.auto-num
          ub.auto-tank-attr.attr-code = "auto-firm"
          ub.auto-tank-attr.attr-value = input frame {&frame-name} varauto-firm
        .
      end.
    end.
    else do :
      if available ub.auto-tank-attr then delete ub.auto-tank-attr.
    end.
  end. /* end_of update */

  /* 06/III-2018 если parmode = {&update} то менять auto-tank.auto-num нельзя:
     при отправке новостей принимающая сторона сопоставляет записи по первичному ключу,
     и при смене auto-num принимающая сторона вместо update создаст новую запись с изменённым auto-num
  if parmode = {&update} and ub.auto-tank.auto-num <> varauto-num:screen-value then
  for each buf_auto-tank exclusive-lock where buf_auto-tank.auto-num begins (ub.auto-tank.auto-num + "#") :
      for each buf_auto-tank-meas exclusive-lock where buf_auto-tank-meas.auto-num = buf_auto-tank.auto-num :
          buf_auto-tank-meas.auto-num = varauto-num:screen-value + "#" + entry(2,buf_auto-tank.auto-num,"#") no-error.
      end.    
      buf_auto-tank.auto-num = varauto-num:screen-value + "#" + entry(2,buf_auto-tank.auto-num,"#") no-error.
  end.
  */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-temp Dialog-Frame
ON VALUE-CHANGED OF f-temp IN FRAME Dialog-Frame
DO:
  if available tt_auto-tank-sec then do:
      FIND FIRST buf_auto-tank WHERE buf_auto-tank.auto-num = (if available ub.auto-tank then ub.auto-tank.auto-num else varauto-num:screen-value) + CHR(35) + tt_auto-tank-sec.sec-num NO-LOCK NO-ERROR.
      IF AVAILABLE buf_auto-tank THEN DO:
        if available ub.auto-tank-meas then do:
            assign
              v-auto-num-meas = buf_auto-tank.auto-num
              v-meas-label = ub.auto-tank-meas.meas-label
            .
            run str/auto-tnm.w (input {&lookup},
                            input v-auto-num-meas,
                            input-output v-meas-label) no-error.
            end.
        else do:
          message "Не выбрано измерение по секции." view-as alert-box error.
        end.
      end.
      ELSE DO:
          message "Данные по секции не заполнены." view-as alert-box error.
      END.  
  end.
  else do:
    message "Не выбрана секция." view-as alert-box.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-error Dialog-Frame
ON VALUE-CHANGED OF f-error IN FRAME Dialog-Frame
DO:
    assign f-error .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&Scoped-define SELF-NAME b-view-sec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-view-sec Dialog-Frame
ON CHOOSE OF b-view-sec IN FRAME Dialog-Frame /* Просмотр */
DO:
  
  if available tt_auto-tank-sec then do:
      ASSIGN
/*        varauto-tank-num = if available ub.auto-tank then ub.auto-tank.auto-num else varauto-num:screen-value*/
        varauto-tank-sec = string(tt_auto-tank-sec.sec-num)
      .
      run str/auto-tncs.w
        ( input        {&lookup}
         ,input        varauto-num
         ,input        c-AC-type
         ,input        C-neck
         ,input-output varauto-tank-sec
        ) no-error.
/*      run local-enable_ui.*/
    end.
    else do:
      message "Не выбрана секция." view-as alert-box error.
    end.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-mark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-mark Dialog-Frame
ON CHOOSE OF b-mark IN FRAME Dialog-Frame /* * */
DO:
/*  {&stdbtn}*/
  run proc-b-mark in this-procedure no-error.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-sel-all
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-sel-all Dialog-Frame
ON CHOOSE OF b-sel-all IN FRAME Dialog-Frame /* + */
DO:
  assign select-list = "".
  v-auto-num = if available ub.auto-tank then ub.auto-tank.auto-num else varauto-num:screen-value in frame {&frame-name} .
  if not available auto-tank-meas then return.
  for each auto-tank-meas no-lock where auto-tank-meas.auto-num = v-auto-num + "#" + tt_auto-tank-sec.sec-num :
    { gbl/markstrn.i auto-tank-meas select-list }
  end.
  brw-auto-meas:refresh() in frame {&frame-name} .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-unmark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-unmark Dialog-Frame
ON CHOOSE OF b-unmark IN FRAME Dialog-Frame /* - */
DO:
  if not available auto-tank-meas then return.
  select-list  = "".
  brw-auto-meas:refresh() in frame {&frame-name} .
END.

&Scoped-define BROWSE-NAME brw-auto-meas
&Scoped-define SELF-NAME brw-auto-meas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brw-auto-meas Dialog-Frame
ON VALUE-CHANGED OF brw-auto-meas IN FRAME Dialog-Frame
DO:
  if available ub.auto-tank-meas then do:
    assign
      varps-meas = ub.auto-tank-meas.ps
    .
  end.
  else do:
    assign
      varps-meas = "":U
    .
  end.
  display
    varps-meas
    with frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brw-auto-num-sec Dialog-Frame
ON choose of brw-auto-num-sec IN FRAME Dialog-Frame
    DO:
       find first tt_auto-tank-sec no-error . 
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

  if parmode = {&lookup} then do:
    find first ub.auto-tank where recid(ub.auto-tank) = parrecid no-lock.
    find first error_auto-tank-attr no-lock
         where error_auto-tank-attr.auto-num = ub.auto-tank.auto-num
           and error_auto-tank-attr.attr-code = "auto-error" no-error.
    find first temp_auto-tank-attr no-lock
         where temp_auto-tank-attr.auto-num = ub.auto-tank.auto-num
           and temp_auto-tank-attr.attr-code = "auto-temp" no-error.
           
  end.
  if parmode = {&update} then do:
    do transaction:
    find first ub.auto-tank where recid(ub.auto-tank) = parrecid exclusive-lock.
    find first error_auto-tank-attr exclusive-lock
         where error_auto-tank-attr.auto-num = ub.auto-tank.auto-num
           and error_auto-tank-attr.attr-code = "auto-error" no-error.
    find first temp_auto-tank-attr exclusive-lock
         where temp_auto-tank-attr.auto-num = ub.auto-tank.auto-num
           and temp_auto-tank-attr.attr-code = "auto-temp" no-error.
    end.
  end.
  if parmode = {&lookup} or
     parmode = {&update} then do:
    assign
      varauto-num    = ub.auto-tank.auto-num
      varname        = ub.auto-tank.NAME
      varps          = ub.auto-tank.ps
      varauto-firm   = string (ub.auto-tank.firm-type) + " " + string (ub.auto-tank.firm-code)
      c-AC-type      = ub.auto-tank.type-AC
      C-neck         = ub.auto-tank.type-neck.
    if available error_auto-tank-attr then f-error = decimal(error_auto-tank-attr.attr-value).
    if available temp_auto-tank-attr then f-temp = decimal(temp_auto-tank-attr.attr-value) .
  end.

  run init-proc in this-procedure .

  RUN local-enable_UI.
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
  DISPLAY varname varauto-num varauto-firm c-AC-type varPS 
      WITH FRAME Dialog-Frame.
  ENABLE b-cancel b-help RECT-1 RECT-2 c-AC-type b-choose-auto-firm brw-auto-num-sec
         varPS b-view-sec  
      WITH FRAME Dialog-Frame.
  if c-AC-type <> 1 then do: 
  hide C-neck f-error f-temp in frame Dialog-Frame .        
  end.  
  else do:
  display C-neck f-error f-temp with frame Dialog-Frame .    
  end.  
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-proc Dialog-Frame 
PROCEDURE init-proc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  FOR EACH tt_auto-tank-sec EXCLUSIVE-LOCK:
      DELETE tt_auto-tank-sec.
  END.
  v-auto-num = if available ub.auto-tank then ub.auto-tank.auto-num else varauto-num:screen-value in frame {&frame-name} .
  FOR EACH buf_auto-tank WHERE buf_auto-tank.auto-num begins (v-auto-num + CHR(35)) NO-LOCK:
    CREATE tt_auto-tank-sec.
    ASSIGN 
      tt_auto-tank-sec.sec-num = ENTRY(2, buf_auto-tank.auto-num,CHR(35))
      tt_auto-tank-sec.brutto-qnty = buf_auto-tank.brutto-qnty
      tt_auto-tank-sec.min-lvl = DECIMAL(ENTRY(1, buf_auto-tank.NAME,{&delim-par}))
      tt_auto-tank-sec.max-lvl = DECIMAL(ENTRY(2, buf_auto-tank.NAME,{&delim-par}))
      tt_auto-tank-sec.diametr = ENTRY(3, buf_auto-tank.NAME,{&delim-par})
      NO-ERROR. 
  END.

  FIND FIRST tt_auto-tank-sec WHERE tt_auto-tank-sec.sec-num = "1" NO-LOCK NO-ERROR.
  IF AVAILABLE tt_auto-tank-sec THEN DO:
      REPOSITION brw-auto-num-sec TO RECID recid(tt_auto-tank-sec) NO-ERROR.
  END.

  apply "value-changed" to brw-auto-num-sec in frame dialog-frame.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable_UI Dialog-Frame 
PROCEDURE local-enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */

  RUN enable_ui IN THIS-PROCEDURE.
  if parmode = {&add-def} or parmode = {&update} then do:
      enable varauto-num varname varauto-firm b-save b-add-sec b-chg-sec with frame {&frame-name}.
      assign varps:read-only = no.
      if c-AC-type = 1 then do:
        enable
        C-neck
        f-error
        f-temp
        with frame {&frame-name} .
      end.  
  end.
  {&OPEN-QUERY-brw-auto-meas}
/*  if parmode = {&add-def} then do:                                                                                                          */
/*     enable varauto-num varname varauto-firm b-save with frame {&frame-name}.                                                               */
/*     assign varps:read-only = no.                                                                                                           */
/*  end.                                                                                                                                      */
/*  ELSE IF parmode = {&update} then do:                                                                                                      */
/*     enable varauto-num varname varauto-firm b-save b-add-sec b-chg-sec b-add-meas b-chg-meas b-del-meas b-del-sec with frame {&frame-name}.*/
/*     assign varps:read-only = no.                                                                                                           */
/*  end.                                                                                                                                      */

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.