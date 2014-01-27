&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win

/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

4GL socket server (HTTPD)

Автор: Гридчина Полина Дмитриевна
Дата создания: 10/01/07
Author: Polina Gridchina
Creation date: 10/01/07

Input:

Output:

*/

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p-param AS CHARACTER NO-UNDO.
/* Local Variable Definitions ---                                       */

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "4GL socket server (HTTPD)".
{ cmp/trg-def.i new }
{ cmp/showinf.i  }
{ gbl/cur-time.i }
{ str/defc-gds.i }
{ cmp/vssrevis.i }
{ cmp/library.i  }

/*def var parParentProc as Widget-handle no-undo .*/
{ str/travel-sheets-inc2.i }

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
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */


/* { adm/auto-def.i } */
define variable hServerSocket    as handle       no-undo.
define variable v-connect-param  as CHAR         no-undo.
define variable v-srv-connected  as LOG          no-undo.
v-connect-param = p-param.
/* v-connect-param = SUBSTITUTE('-H &1 -S &2',ENTRY(1,p-param,':':U),ENTRY(2,p-param,':':U)). */

DEFINE VARIABLE hDoc  AS HANDLE.
DEFINE VARIABLE hRoot AS HANDLE.
DEFINE VARIABLE hRow  AS HANDLE.
DEFINE VARIABLE hTxt  AS HANDLE.

DEFINE VARIABLE hDoc-out  AS HANDLE.
DEFINE VARIABLE hRoot-out AS HANDLE.
DEFINE VARIABLE hRow-out  AS HANDLE.

/* временные таблицы */
DEFINE TEMP-TABLE  in-AFTermId NO-UNDO
    FIELD AFTOrg as char
    FIELD AFTShop   AS CHAR
    FIELD AFTCashNum  AS CHAR
    FIELD AFTCashier  AS CHAR
INDEX AFTOrg AFTShop AFTCashNum AFTCashier
.
DEFINE TEMP-TABLE  in-AFAuto NO-UNDO
    FIELD AFAType as char
    FIELD AFAIDPassiveLabel   AS CHAR
    FIELD AFAIDList  AS CHAR
INDEX AFAType AFAIDPassiveLabel AFAIDList
.
DEFINE temp-table in-AFRequest  no-undo
    field AFRDate as char
    field AFRTrk  as char
    field AFRNozzle as char
    field AFRGrade as char
    field AFRPrice as char
Index AFRDate AFRTrk AFRNozzle AFRGrade AFRPrice
.
DEFINE temp-table in-AFFact  no-undo
    field AFFDate as char
    field AFFResult as char
    field AFFMessage as char
    field AFFCheqId as char
    field AFFTrk  as char
    field AFFNozzle as char
    field AFFGrade as char
    field AFFLiter as char
    field AFFMoney as char
    field AFFPrice as char
Index AFFDate AFFResult AFFMessage AFFCheqId AFFTrk AFFNozzle AFFGrade AFFLiter AFFMoney AFFPrice
.
DEFINE TEMP-TABLE  in-ItemHowMany NO-UNDO
    FIELD ItemCode   AS CHAR
    FIELD IHMObject  AS CHAR
    FIELD IHMObjCode AS INTEGER
    FIELD IHMFact    AS DECIMAL
    FIELD IHMFree    AS DECIMAL
INDEX idx-code ItemCode
.
DEFINE TEMP-TABLE  Out-ItemHowMany NO-UNDO
    FIELD ItemCode   AS CHAR
    FIELD IHMObject  AS CHAR
    FIELD IHMObjCode AS INTEGER
    FIELD IHMFact    AS DECIMAL
    FIELD IHMFree    AS DECIMAL
INDEX idx-code ItemCode
.

define variable v-AFType as integer no-undo.
define variable v-autorize-dose as decimal no-undo.
define variable v-dose as decimal no-undo.
define variable v-answer-error as character no-undo.
define variable v-line-rid as recid no-undo.
define variable v-date as character no-undo.
define variable v-in-code as character no-undo.
define variable v-out-code as integer no-undo.


define buffer buf_ext-classif for ub.ext-classif.
define buffer buf_dis-card for ub.dis-card.
define buffer buf_cd-doc for ub.cd-doc.
define buffer buf_cd-doc-line for ub.cd-doc-line.

&scop CRLF chr(13) + chr(10)
&scop HdEnd chr(13) + chr(10) + chr(13) + chr(10)
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-help b-exit Btn-st auto-log
&Scoped-Define DISPLAYED-OBJECTS auto-log

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD pet-code C-Win
FUNCTION pet-code RETURNS CHARACTER
  ( INPUT p-gds-code AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD SocketRead C-Win
FUNCTION SocketRead RETURNS CHARACTER
 (h AS HANDLE, l AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-exit DEFAULT
     LABEL "Вы&ход "
     SIZE 10 BY 1 TOOLTIP "Выход из автоматической системы"
     BGCOLOR 8 .

DEFINE BUTTON b-help DEFAULT
     LABEL "Помо&щь"
     SIZE 10 BY 1 TOOLTIP "Помощь"
     BGCOLOR 8 .

DEFINE BUTTON Btn-st
     LABEL "Старт"
     SIZE 10 BY 1.

DEFINE VARIABLE auto-log AS CHARACTER
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 96 BY 20 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     b-help AT ROW 1.17 COL 89 WIDGET-ID 4
     b-exit AT ROW 1.25 COL 2.5 WIDGET-ID 2
     Btn-st AT ROW 1.25 COL 12.5 WIDGET-ID 6
     auto-log AT ROW 3 COL 2.5 NO-LABEL WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1
         SIZE 99 BY 22.58 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Сокет-сервер"
         HEIGHT             = 22.58
         WIDTH              = 99
         MAX-HEIGHT         = 30.04
         MAX-WIDTH          = 128
         VIRTUAL-HEIGHT     = 30.04
         VIRTUAL-WIDTH      = 128
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
ASSIGN
       auto-log:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Сокет-сервер */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Сокет-сервер */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-exit C-Win
ON CHOOSE OF b-exit IN FRAME DEFAULT-FRAME /* Выход  */
DO:

RUN proc-stop-srv.

PAUSE 2.
APPLY 'close':U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-st
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-st C-Win
ON CHOOSE OF Btn-st IN FRAME DEFAULT-FRAME /* Старт */
DO:
IF v-srv-connected = NO THEN
  RUN proc-start-srv IN THIS-PROCEDURE NO-ERROR.
ELSE  RUN proc-stop-srv IN THIS-PROCEDURE NO-ERROR.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win


/* ***************************  Main Block  *************************** */
{ gbl/app_help.i }
/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME}
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  apply 'choose':U to Btn-st.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE connproc C-Win
PROCEDURE connproc :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  define input parameter hSocket as handle no-undo.

  define variable mbuffer        as memptr no-undo.
  define variable mbuffer-out    as memptr no-undo.
  define variable us-tmo         as INTEGER  INIT 10 no-undo. /*тайм-аут в сек.*/
  define variable us-tmp-etime   as INTEGER   no-undo.
  define variable v-bytes        as integer   no-undo.
  define variable v-header       as character no-undo.
  define variable v-hd-line      as character no-undo.
  define variable v-content      as character no-undo.
  define variable v-cont-length  as INTEGER   no-undo.
  define variable v-cont-type    as character no-undo.
  define variable v-str          as character no-undo.
  define variable i AS INT NO-UNDO.
  define variable s AS CHAR no-undo.
  define variable req-type   AS CHAR  NO-UNDO.
  define variable req-id     AS CHAR NO-UNDO.
  define variable req-from   AS CHAR NO-UNDO.
  define variable req-to     AS CHAR NO-UNDO.
  define variable req-tstamp AS INT NO-UNDO.
  define variable resp-head  AS CHAR NO-UNDO. /*ответ сокет-сервера*/
  define variable req-encod  AS CHAR INIT 'KOI8-R' NO-UNDO.

  SET-SIZE(mbuffer-out) = 0.
  ASSIGN S = '':U
  v-content = '':U
  v-header = '':U.
  v-cont-length = 0 .
  v-str = '':U.
  resp-head = substitute("HTTP/1.0 400 Bad Request&1Server: 4GL&2",{&CRLF},{&HdEnd}).  /* Возвращаемая по умолчанию ошибка */
  ContBlock: DO:

  /* читаем сокет и разбираем полученую информацию. */
    v-bytes = hSocket:get-bytes-available().
    v-str = socketRead(hSocket:handle,v-bytes).
    RUN write-to-log('SOCKET-READ:' + v-str ).
    /*ждем окончание передачи шапки. Признак конца шапки - двойной перевод строки*/
    etime(yes).
    DO WHILE index(v-str, {&HdEnd}) = 0 AND ETIME < us-tmo * 10 :
        v-bytes = hSocket:get-bytes-available().
        v-str = v-str + socketRead(hSocket:handle,v-bytes).
        RUN write-to-log('SOCKET-READ:' + v-str ).
        PAUSE 1.
    END.
    if v-str = '' or index(v-str, {&HdEnd}) = 0 then do:
      leave ContBlock.
    end.
    v-header  = SUBSTRING(v-str,1,INDEX(v-str,{&HdEnd})) no-error.         /*   CRLF */
    v-content = SUBSTRING(v-str,INDEX(v-str,{&HdEnd}) + 4,LENGTH(v-str)) no-error.
    RUN write-to-log('REQUEST-HEADER:' + v-header ).
    /*разбор шапки*/
    DO i = 1 TO NUM-ENTRIES(v-str,{&CRLF}):
        v-hd-line = trim(ENTRY(i,v-str,{&CRLF})).
        IF  v-hd-line  BEGINS "Content-Length"  THEN  do:
            v-cont-length = INT(trim(entry(2,v-hd-line,':'))).
        END.
        IF  v-hd-line  BEGINS "content-type:"  THEN  do:
            v-cont-type = trim(entry(1,SUBSTRING(v-hd-line,14,LENGTH(v-hd-line)),';')).
        END.
    END.
    /* Запросы не в xml формате не обрабатываем */

    if v-cont-type <> 'text/xml':U then do:
     /* resp-head = "HTTP/1.1 501 Not Implemented ~nServer: 4GL ~nConnection: close ~n~n".*/
      resp-head = substitute("HTTP/1.0 501 Not Implemented&1Server: 4GL&2",{&CRLF},{&HdEnd}).
      LEAVE ContBlock.
    end.
      IF v-cont-length = 0 THEN DO:  /* Если запрос c нулевой длиной тела, то создаем ответ об успешном выполнении запроса */
        resp-head = substitute("HTTP/1.0 411 No Content&1Server: 4GL&2",{&CRLF},{&HdEnd}).
        LEAVE ContBlock.
      END.
      /*ожидаем полной передачи тела запроса*/
      IF  LENGTH(v-content) < v-cont-length  THEN DO:
          ETIME (YES).
          DO WHILE LENGTH(v-content) < v-cont-length AND ETIME < us-tmo * 1000 :
              v-bytes = hSocket:get-bytes-available().
              v-content = v-content +  socketRead(hSocket:handle,v-bytes).
              RUN write-to-log('content:' + v-content ).
              PAUSE 1.
          END.
      END.
      RUN write-to-log('REQUEST-CONTENT:' + v-content ).
      /* тело запроса передано не полностью */
      IF v-cont-length > 0 AND LENGTH(v-content) < v-cont-length  THEN DO:
        resp-head =  substitute("HTTP/1.0 408 Request Timeout&1Server: 4GL&2",{&CRLF},{&HdEnd}).
         LEAVE ContBlock.
      END.
      ELSE IF v-cont-length > 0 THEN DO: /*Если тело не пустое*/
          SET-SIZE(mbuffer) = 0.
          SET-SIZE(mbuffer) = LENGTH(v-content,'RAW') + 2.
          PUT-STRING(mbuffer,1) = v-content.

        /*load XML и разбор запроса*/

          CREATE X-DOCUMENT hdoc.
          CREATE X-NODEREF  hroot.
          CREATE X-NODEREF  hrow.
          CREATE X-NODEREF  hTxt.

          hdoc:LOAD("memptr",mbuffer,NO).
          hdoc:GET-DOCUMENT-ELEMENT(hRoot).

          req-type   = hroot:GET-ATTRIBUTE("type").
          req-id     = hroot:GET-ATTRIBUTE("id").
          req-from   = hroot:GET-ATTRIBUTE("from").
          req-to     = hroot:GET-ATTRIBUTE("to").
          req-tstamp = int(hroot:GET-ATTRIBUTE("tstamp")).
          req-encod  = hdoc:ENCODING.


        /* Общий тэг xml-ответа */
          CREATE X-DOCUMENT hdoc-out.
          CREATE X-NODEREF hroot-out.

          hdoc-out:ENCODING = req-encod.
          hdoc-out:CREATE-NODE(hroot-out,'AuthFuel','element').
          hdoc-out:APPEND-CHILD(hroot-out).
          IF req-id <> "" AND req-id <> ? THEN  hroot-out:SET-ATTRIBUTE('id',req-id).
          IF req-to > '':U THEN                 hroot-out:SET-ATTRIBUTE('from',req-to).
          IF req-from > '':U THEN               hroot-out:SET-ATTRIBUTE('to',req-from).
          IF req-tstamp <> 0 AND req-tstamp <> ? THEN hroot-out:SET-ATTRIBUTE('tstamp',string(req-tstamp)).

          if hroot:name <> "AuthFuel" then do :
            hroot-out:SET-ATTRIBUTE('type','replay').
          end.

          DO i = 1 TO hRoot:NUM-CHILDREN:
             hRoot:GET-CHILD(hRow,i).
             /* MESSAGE i hRow:NAME. */
             if hRow:NAME = "AFType" then do :
              hRow:GET-CHILD(hTxt,1).
              v-AFType = int(hTxt:Node-Value).
             end.
             RUN xml-router(hRow:HANDLE
                           ,'':U
                           ,'':U
                           ,hRoot-out:HANDLE ) NO-ERROR.
          END. /* i */

         /*message in-AFAuto.AFAType skip in-AFAuto.AFAIDPassiveLabel skip skip in-AFRequest.AFRGrade view-as alert-box.*/

          if hroot:name = "AuthFuel" then do :
            run main-proc.

            run form-answer(hRoot-out:HANDLE).
          end.

          SET-SIZE(mbuffer-out) = 0.
          /*SET-SIZE(mbuffer-out) = 2000.  */
          hdoc-out:SAVE('memptr',mbuffer-out).

          s = GET-STRING(mbuffer-out,1).
          /*RUN write-to-log(s).*/
          /*message "!" view-as alert-box.*/
          v-cont-length = LENGTH(s,"RAW":U).

          DELETE OBJECT hdoc.
          DELETE OBJECT hroot.
          DELETE OBJECT hrow.
          DELETE OBJECT hdoc-out.
          DELETE OBJECT hroot-out.

          resp-head = substitute("HTTP/1.0 200 OK&1Server: 4GL&1Content-Type: text/xml&1Content-Length: &3&2&4",{&CRLF},{&HdEnd},string(v-cont-length),GET-STRING(mbuffer-out,1)).
      END.
  end. /* ContBlock */
  /* шапка http-ответа + тело ответа помещенное в память*/

  RUN write-to-log('RESPONSE: ' + resp-head).

  SET-SIZE(mbuffer-out) = 0.
  SET-SIZE(mbuffer-out) = LENGTH(resp-head,'RAW':U) + 1.
  PUT-STRING(mbuffer-out,1) = resp-head.
  hsocket:WRITE(mbuffer-out,1,LENGTH(resp-head,'RAW':U)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  DISPLAY auto-log
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE b-help b-exit Btn-st auto-log
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE out-tag-put C-Win
PROCEDURE out-tag-put :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-hRow   AS HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-hField AS HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-hText  AS HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-name   AS CHAR   NO-UNDO.
DEFINE INPUT PARAMETER p-value  AS CHAR   NO-UNDO.

hDoc-Out:CREATE-NODE(p-hField,p-name,'Element').
p-hRow:APPEND-CHILD(p-hField).
IF p-value > '' THEN DO:
    hDoc-Out:CREATE-NODE(p-hText,'','TEXT':U).
    p-hField:APPEND-CHILD(p-hText).
    p-hText:NODE-VALUE = p-value.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE main-proc C-Win
PROCEDURE main-proc :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE BUFFER buf_bar-code FOR  ub.bar-code .
  DEFINE BUFFER buf_prod-bc  FOR  ub.prod-bc.
    /*  */
 v-answer-error = ''.

case int(in-AFAuto.AFAType) :
  when 2 then do :
    if v-AFType = 1 then
    if in-AFRequest.AFRGrade = "" then do :
      v-answer-error = 'Не задан вид топлива.'.
      run write-to-log (v-answer-error).
      return.
    end.
    find first buf_ext-classif no-lock where buf_ext-classif.classif-name = "easyfuel2-rfn" and
                                            buf_ext-classif.CharKey_One  = in-AFAuto.AFAIDPassiveLabel no-error.
    if not available buf_ext-classif then do :
      v-answer-error = 'Не найден RFN.'.
      run write-to-log (v-answer-error).
      return.
    end.
    else do :
      find first buf_dis-card no-lock where buf_dis-card.d-card = buf_ext-classif.classif-subject no-error.
      if not available buf_dis-card then do :
        v-answer-error = ("Не найдена ДК с RFN = " + in-AFAuto.AFAIDPassiveLabel).
        run write-to-log (v-answer-error).
        return.
      end.
      else do :
        v-in-code = (if available in-AFRequest then trim(in-AFRequest.AFRGrade) else trim(in-AFFact.AFFGrade)).
        find first buf_prod-bc no-lock where buf_prod-bc.b-str = v-in-code no-error.
        if available buf_prod-bc then do :
          find first buf_bar-code no-lock where buf_bar-code.b-code = buf_prod-bc.b-code no-error.
        end.
        if available buf_bar-code then v-out-code = buf_bar-code.gds-code.
        /*message v-out-code.*/
        /*run write-to-log ("Найдена ДК " + buf_dis-card.d-card).*/
        find first buf_cd-doc no-lock where buf_cd-doc.CharKey_Two = buf_dis-card.d-card         and
                                            buf_cd-doc.Key#_Two   = v-out-code                  and
                                            buf_cd-doc.Key#_One   = 0                           and
                                            buf_cd-doc.DateKey_One = TODAY                       no-error.
        if not available buf_cd-doc then do :
          v-answer-error = 'Не найден путевой лист.'.
          run write-to-log (v-answer-error).
          return.
        end.
        else do :
          run cus/ef2-dose.p(input recid(buf_cd-doc), output v-autorize-dose) .
          v-dose = (if decimal(buf_ext-classif.CharKey_Two) < v-autorize-dose then decimal(buf_ext-classif.CharKey_Two) else v-autorize-dose) .
          if v-dose <= 0 and v-AFType = 1 then do :
            v-answer-error = substitute('Лимит по ПЛ &1 исчерпан.', buf_cd-doc.CharKey_One).
            run write-to-log (v-answer-error).
            return.
          end.
        end. /*  if available buf_cd-doc  */
      end.
    end.
  end.
  when 3 then do :
        find first buf_cd-doc no-lock where buf_cd-doc.CharKey_One = in-AFAuto.AFAIdList no-error.
        if not available buf_cd-doc then do :
          v-answer-error = 'Не найден путевой лист.'.
          run write-to-log (v-answer-error).
          return.
        end.
        else do :
          run cus/ef2-dose.p(input recid(buf_cd-doc), output v-autorize-dose) .
          v-dose = v-autorize-dose .
          if buf_cd-doc.Key#_One > 0 or v-dose = ? or v-dose <= 0 and v-AFType = 1 then do :
            v-answer-error = substitute('Лимит по ПЛ &1 исчерпан.', buf_cd-doc.CharKey_One).
            run write-to-log (v-answer-error).
            return.
          end.
          if buf_cd-doc.DateKey_One <> TODAY then do :
            v-answer-error = substitute('Дата ПЛ &1 не равна текущей.', buf_cd-doc.CharKey_One).
            run write-to-log (v-answer-error).
            return.
          end.
          if v-AFType = 1 then do :
            v-in-code = (if available in-AFRequest then trim(in-AFRequest.AFRGrade) else trim(in-AFFact.AFFGrade)).
            find first buf_prod-bc no-lock where buf_prod-bc.b-str = v-in-code no-error.
            if available buf_prod-bc then do :
              find first buf_bar-code no-lock where buf_bar-code.b-code = buf_prod-bc.b-code no-error.
            end.
            if available buf_bar-code then v-out-code = buf_bar-code.gds-code.
            if v-out-code <> ? and v-out-code <> 0 and v-out-code <> buf_cd-doc.Key#_Two then do :
              v-answer-error = substitute('Код топлива в ПЛ &1 не соответствует коду топлива в запросе.', buf_cd-doc.CharKey_One).
              run write-to-log (v-answer-error).
              return.
            end.
          end.
          /*if v-AFType = 2 then
          if in-AFFact.AFFGrade <> "" and int(in-AFFact.AFFGrade) <> buf_cd-doc.Key#_Two then do :
            v-answer-error = substitute('Код топлива в ПЛ &1 не соответствует коду топлива в запросе.', buf_cd-doc.CharKey_One).
            run write-to-log (v-answer-error).
            return.
          end.*/
        end. /*  if available buf_cd-doc  */
  end.
  otherwise do :

  end.
end case.

run create-travel-sheet-line (
    input recid(buf_cd-doc),
    input (if v-AFType = 2 then decimal(in-AFFact.AFFLiter) else v-dose),
    input (if v-AFType = 2 then in-AFFact.AFFCheqId else ''),
    input (if available buf_ext-classif then buf_ext-classif.CharKey_One else ''),
    input (if v-AFType = 2 then true else false),
    output v-line-rid) no-error.
if error-status:error then do :
   v-answer-error = return-value.
   run write-to-log (v-answer-error).
   undo, return.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE form-answer C-Win
PROCEDURE form-answer :
DEFINE INPUT PARAMETER p-hParentOut AS HANDLE NO-UNDO.

DEFINE VARIABLE hField-out AS HANDLE NO-UNDO.
DEFINE VARIABLE hText-out  AS HANDLE NO-UNDO.

CREATE X-NODEREF  hField-out.
CREATE X-NODEREF  hText-out.
CREATE X-NODEREF  hRow-out.

if v-AFType = 1 then do :

   RUN out-tag-put in THIS-PROCEDURE (hRoot-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'AFType' , '1' ).

   hDoc-Out:CREATE-NODE(hRow-out,'AFTermId','ELEMENT').
   p-hParentOut:APPEND-CHILD(hRow-out).
   RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'AFTOrg' , in-AFTermId.AFTOrg ).
   RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'AFTShop' , in-AFTermId.AFTShop ).
   RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'AFTCashNum' , in-AFTermId.AFTCashNum ).
   RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'AFTCashier' , in-AFTermId.AFTCashier ).

   hDoc-Out:CREATE-NODE(hRow-out,'AFAuto','ELEMENT').
   p-hParentOut:APPEND-CHILD(hRow-out).
   RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'AFAType' , in-AFAuto.AFAType ).
   if int(in-AFAuto.AFAType) = 2 then
     RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'AFAIdPassiveLabel' , in-AFAuto.AFAIdPassiveLabel ).
   RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'AFAIdList' , (if available buf_cd-doc then buf_cd-doc.CharKey_One else in-AFAuto.AFAIdList) ).

   hDoc-Out:CREATE-NODE(hRow-out,'AFRequest','ELEMENT').
   p-hParentOut:APPEND-CHILD(hRow-out).
   RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'AFRDate' , in-AFRequest.AFRDate ).
   RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'AFRTrk' , in-AFRequest.AFRTrk ).
   RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'AFRNozzle' , in-AFRequest.AFRNozzle ).
   RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'AFRGrade' , in-AFRequest.AFRGrade ).
   RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'AFRPrice' , in-AFRequest.AFRPrice ).

   hDoc-Out:CREATE-NODE(hRow-out,'AFGrant','ELEMENT').
   p-hParentOut:APPEND-CHILD(hRow-out).
   v-date = substring(string(TODAY, "99999999"),5,4) + "-" + substring(string(TODAY, "99999999"),3,2) + "-" + substring(string(TODAY, "99999999"),1,2) + ' ' + string(Time, 'hh:mm:ss').
   RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'AFGDate' , v-date ).
   RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'AFGResult' , (if v-answer-error = '' then '0' else '1') ).
   RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'AFGMessage' , v-answer-error ).
   RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'AFGAuthCode' , '' ).
   RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'AFGTrk' , in-AFRequest.AFRTrk ).
   RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'AFGNozzle' , in-AFRequest.AFRNozzle ).
   RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'AFGGrade' , in-AFRequest.AFRGrade ).
   RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'AFGLiter' , v-dose ).
   RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'AFGPrice' , in-AFRequest.AFRPrice ).

end.
if v-AFType = 2 then do :

   RUN out-tag-put in THIS-PROCEDURE (hRoot-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'AFType' , '2' ).

end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ParsTermId C-Win
PROCEDURE ParsTermId :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:       Остаток товара
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-hNode AS HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-hParentOut AS HANDLE NO-UNDO.

DEFINE VARIABLE hField AS HANDLE NO-UNDO.
DEFINE VARIABLE hBuf   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBFld AS HANDLE NO-UNDO.
DEFINE VARIABLE hText  AS HANDLE NO-UNDO.
DEFINE VARIABLE hBuf-out   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBFld-out AS HANDLE NO-UNDO.
DEFINE VARIABLE hField-out AS HANDLE NO-UNDO.
DEFINE VARIABLE hText-out  AS HANDLE NO-UNDO.
/*DEFINE VARIABLE hRow-out  AS HANDLE NO-UNDO.   */

DEF VAR v-ctrl AS CHAR NO-UNDO.
DEF VAR v-code AS CHAR NO-UNDO.
DEF VAR i AS INT NO-UNDO.
DEF VAR j AS INT NO-UNDO.
hBuf     = BUFFER in-AFTermId:HANDLE.
/*hBuf-out = BUFFER out-AFAuto:HANDLE.*/


CREATE in-AFTermId.

CREATE X-NODEREF  hField.
CREATE X-NODEREF  hText.

DO i = 1 TO p-hNode:NUM-CHILDREN:
    p-hNode:GET-CHILD(hField,i).
    IF hField:NAME = '#text' THEN NEXT.
    hDBFld = hBuf:BUFFER-FIELD(hField:NAME) NO-ERROR.
    IF VALID-HANDLE(hDBFld) THEN DO:
        hField:GET-CHILD(hText,1).
        hDbFld:BUFFER-VALUE = hText:NODE-VALUE.
    END.

END.


DELETE OBJECT hField.
DELETE OBJECT hText.
/*DELETE OBJECT hRow-out.   */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ParsAuto C-Win
PROCEDURE ParsAuto :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:       Остаток товара
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-hNode AS HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-hParentOut AS HANDLE NO-UNDO.

DEFINE VARIABLE hField AS HANDLE NO-UNDO.
DEFINE VARIABLE hBuf   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBFld AS HANDLE NO-UNDO.
DEFINE VARIABLE hText  AS HANDLE NO-UNDO.
DEFINE VARIABLE hBuf-out   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBFld-out AS HANDLE NO-UNDO.
DEFINE VARIABLE hField-out AS HANDLE NO-UNDO.
DEFINE VARIABLE hText-out  AS HANDLE NO-UNDO.
/*DEFINE VARIABLE hRow-out  AS HANDLE NO-UNDO.   */

DEF VAR v-ctrl AS CHAR NO-UNDO.
DEF VAR v-code AS CHAR NO-UNDO.
DEF VAR i AS INT NO-UNDO.
DEF VAR j AS INT NO-UNDO.
hBuf     = BUFFER in-AFAuto:HANDLE.


CREATE in-AFAuto.
/*ASSIGN in-AFAuto.ItemCode = v-code.*/

CREATE X-NODEREF  hField.
CREATE X-NODEREF  hText.
CREATE X-NODEREF  hField-out.
CREATE X-NODEREF  hText-out.
CREATE X-NODEREF  hRow-out.


DO i = 1 TO p-hNode:NUM-CHILDREN:
    p-hNode:GET-CHILD(hField,i).
    IF hField:NAME = '#text' THEN NEXT.
    hDBFld = hBuf:BUFFER-FIELD(hField:NAME) NO-ERROR.
    IF VALID-HANDLE(hDBFld) THEN DO:
        hField:GET-CHILD(hText,1) no-error.
        /*message "!".*/
        hDbFld:BUFFER-VALUE = hText:NODE-VALUE no-error.
       /* message "!!".*/
    END.

END.

DELETE OBJECT hField.
DELETE OBJECT hText.
DELETE OBJECT hField-out.
DELETE OBJECT hText-out.
/*DELETE OBJECT hTxt.*/
/*DELETE OBJECT hRow-out.   */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ParsRequest C-Win
PROCEDURE ParsRequest :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:       Остаток товара
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-hNode AS HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-hParentOut AS HANDLE NO-UNDO.

DEFINE VARIABLE hField AS HANDLE NO-UNDO.
DEFINE VARIABLE hBuf   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBFld AS HANDLE NO-UNDO.
DEFINE VARIABLE hText  AS HANDLE NO-UNDO.
DEFINE VARIABLE hBuf-out   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBFld-out AS HANDLE NO-UNDO.
DEFINE VARIABLE hField-out AS HANDLE NO-UNDO.
DEFINE VARIABLE hText-out  AS HANDLE NO-UNDO.
/*DEFINE VARIABLE hRow-out  AS HANDLE NO-UNDO.   */

DEF VAR v-ctrl AS CHAR NO-UNDO.
DEF VAR v-code AS CHAR NO-UNDO.
DEF VAR i AS INT NO-UNDO.
DEF VAR j AS INT NO-UNDO.
hBuf     = BUFFER in-AFRequest:HANDLE.
/*hBuf-out = BUFFER out-AFAuto:HANDLE.*/


CREATE in-AFRequest.
/*ASSIGN in-AFAuto.ItemCode = v-code.*/

CREATE X-NODEREF  hField.
CREATE X-NODEREF  hText.

DO i = 1 TO p-hNode:NUM-CHILDREN:
    p-hNode:GET-CHILD(hField,i).
    IF hField:NAME = '#text' THEN NEXT.
    hDBFld = hBuf:BUFFER-FIELD(hField:NAME) NO-ERROR.
    IF VALID-HANDLE(hDBFld) THEN DO:
        hField:GET-CHILD(hText,1).
        hDbFld:BUFFER-VALUE = hText:NODE-VALUE.
    END.

END.


DELETE OBJECT hField.
DELETE OBJECT hText.
/*DELETE OBJECT hRow-out.   */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ParsFact C-Win
PROCEDURE ParsFact :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:       Остаток товара
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-hNode AS HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-hParentOut AS HANDLE NO-UNDO.

DEFINE VARIABLE hField AS HANDLE NO-UNDO.
DEFINE VARIABLE hBuf   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBFld AS HANDLE NO-UNDO.
DEFINE VARIABLE hText  AS HANDLE NO-UNDO.
DEFINE VARIABLE hBuf-out   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBFld-out AS HANDLE NO-UNDO.
DEFINE VARIABLE hField-out AS HANDLE NO-UNDO.
DEFINE VARIABLE hText-out  AS HANDLE NO-UNDO.
/*DEFINE VARIABLE hRow-out  AS HANDLE NO-UNDO.   */

DEF VAR v-ctrl AS CHAR NO-UNDO.
DEF VAR v-code AS CHAR NO-UNDO.
DEF VAR i AS INT NO-UNDO.
DEF VAR j AS INT NO-UNDO.
hBuf     = BUFFER in-AFFact:HANDLE.
/*hBuf-out = BUFFER out-AFAuto:HANDLE.*/


CREATE in-AFFact.
/*ASSIGN in-AFAuto.ItemCode = v-code.*/

CREATE X-NODEREF  hField.
CREATE X-NODEREF  hText.

DO i = 1 TO p-hNode:NUM-CHILDREN:
    p-hNode:GET-CHILD(hField,i).
    IF hField:NAME = '#text' THEN NEXT.
    hDBFld = hBuf:BUFFER-FIELD(hField:NAME) NO-ERROR.
    IF VALID-HANDLE(hDBFld) THEN DO:
        hField:GET-CHILD(hText,1).
        hDbFld:BUFFER-VALUE = hText:NODE-VALUE.
    END.

END.


DELETE OBJECT hField.
DELETE OBJECT hText.
/*DELETE OBJECT hRow-out.   */

END PROCEDURE.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ParsHowMany C-Win
PROCEDURE ParsHowMany :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:       Остаток товара
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-hNode AS HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-ctrl  AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER p-code  AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER p-hParentOut AS HANDLE NO-UNDO.

DEFINE VARIABLE hField AS HANDLE NO-UNDO.
DEFINE VARIABLE hBuf   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBFld AS HANDLE NO-UNDO.
DEFINE VARIABLE hText  AS HANDLE NO-UNDO.
DEFINE VARIABLE hBuf-out   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBFld-out AS HANDLE NO-UNDO.
DEFINE VARIABLE hField-out AS HANDLE NO-UNDO.
DEFINE VARIABLE hText-out  AS HANDLE NO-UNDO.
/*DEFINE VARIABLE hRow-out  AS HANDLE NO-UNDO.   */

DEF VAR v-ctrl AS CHAR NO-UNDO.
DEF VAR v-code AS CHAR NO-UNDO.
DEF VAR i AS INT NO-UNDO.
DEF VAR j AS INT NO-UNDO.
hBuf     = BUFFER in-ItemHowMany:HANDLE.
hBuf-out = BUFFER out-ItemHowMany:HANDLE.

v-ctrl = p-hNode:GET-ATTRIBUTE("ctrl":U).
IF v-ctrl > ''  THEN. /* если действие не указано в конкретном тэге, используем ctrl родителя */
ELSE v-ctrl = p-ctrl.
v-code = p-hNode:GET-ATTRIBUTE("code":U).
IF v-code > '' THEN.
ELSE v-code = p-code.

CREATE in-ItemHowMany.
ASSIGN in-ItemHowMany.ItemCode = v-code.

CREATE X-NODEREF  hField.
CREATE X-NODEREF  hText.
CREATE X-NODEREF  hField-out.
CREATE X-NODEREF  hText-out.
CREATE X-NODEREF  hRow-out.


DO i = 1 TO p-hNode:NUM-CHILDREN:
    p-hNode:GET-CHILD(hField,i).
    IF hField:NAME = '#text' THEN NEXT.
    hDBFld = hBuf:BUFFER-FIELD(hField:NAME) NO-ERROR.
    IF VALID-HANDLE(hDBFld) THEN DO:
        hField:GET-CHILD(hText,1).
        hDbFld:BUFFER-VALUE = hText:NODE-VALUE.
    END.
END.


IF v-ctrl = 'read' THEN DO:
    EMPTY TEMP-TABLE out-ItemHowMany.
    empty temp-table cash-gds.
/*     FOR EACH in-ItemHowMany NO-LOCK WHERE in-ItemHowMany.ItemCode = v-code: */
        IF in-ItemHowMany.ItemCode = '*' THEN DO: /*По всем товарам*/
            CREATE out-ItemHowMany.
            ASSIGN out-ItemHowMany.ItemCode   = '105107'
                   out-ItemHowMany.IHMObject  = 'маг'
                   out-ItemHowMany.IHMObjCode = 20
                   out-ItemHowMany.IHMFact    = 10
                   out-ItemHowMany.IHMFree    = 10.
                        CREATE out-ItemHowMany.
            ASSIGN out-ItemHowMany.ItemCode   = '27'
                   out-ItemHowMany.IHMObject  = 'маг'
                   out-ItemHowMany.IHMObjCode = 20
                   out-ItemHowMany.IHMFact    = 20
                   out-ItemHowMany.IHMFree    = 20.
        END.
        ELSE DO:
          run str/sendirst.p (input substitute('&1&3&2',in-ItemHowMany.ItemCode,in-ItemHowMany.IHMObjCode,{&delim-par}),
                              output table cash-gds) no-error.
          if error-status:error then do:
            hDoc-Out:CREATE-NODE(hRow-out,'ItemHowMany','ELEMENT').
            p-hParentOut:APPEND-CHILD(hRow-out).
            hRow-out:SET-ATTRIBUTE("code",string(in-ItemHowMany.ItemCode)).
            hRow-out:SET-ATTRIBUTE("ctrl", "READ":U).
            RUN write-error (return-value
                ,1
                ,2
                ,hRow-out:HANDLE).
            run write-to-log(return-value).
          end.
        END.
/*     END. */
    for each cash-gds no-lock
        where cash-gds.fact-qnty <> 0 and cash-gds.free-qnty <> 0 :
        hDoc-Out:CREATE-NODE(hRow-out,'ItemHowMany','ELEMENT').
        p-hParentOut:APPEND-CHILD(hRow-out).
        hRow-out:SET-ATTRIBUTE("code",string(cash-gds.b-code)).
        hRow-out:SET-ATTRIBUTE("ctrl", "ADD":U).
        RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'IHMObject' , cash-gds.obj-type ).
        RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'IHMObjCode' , string(cash-gds.obj-code) ).
        RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'IHMFact' , string(cash-gds.fact-qnty) ).
        RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'IHMFree' , string(cash-gds.free-qnty) ).
    end.

/*    FOR EACH out-ItemHowMany:
        hDoc-Out:CREATE-NODE(hRow-out,'ItemHowMany','ELEMENT').
        p-hParentOut:APPEND-CHILD(hRow-out).
        hRow-out:SET-ATTRIBUTE("code",out-ItemHowMany.ItemCode).
        hRow-out:SET-ATTRIBUTE("ctrl", "ADD":U).
        REPEAT j = 1 TO hBuf-out:NUM-FIELDS:
            hDBFld-out = hBuf-out:BUFFER-FIELD(j).
            IF hDBFld-out:NAME = 'ItemCode':U THEN NEXT.
            hDoc-Out:CREATE-NODE(hField-out,hDBFld-out:NAME,'ELEMENT').
            hRow-out:APPEND-CHILD(hField-out).
            hDoc-Out:CREATE-NODE(hText-out,"",'TEXT').
            hField-out:APPEND-CHILD(hText-out).
            hText-out:NODE-VALUE = STRING(hDBFld-out:BUFFER-VALUE).
        END.
    END. */

END.

DELETE OBJECT hField.
DELETE OBJECT hText.
DELETE OBJECT hField-out.
DELETE OBJECT hText-out.
/*DELETE OBJECT hRow-out.   */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ParsPayMeans C-Win
PROCEDURE ParsPayMeans :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-hNode AS HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-hParentOut AS HANDLE NO-UNDO.

DEFINE VARIABLE hRow-out     AS HANDLE NO-UNDO.
DEFINE VARIABLE hField-out AS HANDLE NO-UNDO.
DEFINE VARIABLE hText-out AS HANDLE NO-UNDO.
/*DEFINE VARIABLE hBuf   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBFld AS HANDLE NO-UNDO. */

DEFINE VARIABLE hRowField-out     AS HANDLE NO-UNDO.
DEFINE VARIABLE v-ser-code   as integer NO-UNDO.
DEFINE VARIABLE v-db-num     as integer NO-UNDO.
DEFINE VARIABLE v-stts       as integer NO-UNDO.
DEFINE VARIABLE v-wth-code   as integer NO-UNDO.
DEFINE VARIABLE v-gds-code   as integer NO-UNDO.
DEFINE VARIABLE v-par-code   as integer NO-UNDO.
DEFINE VARIABLE v-FromDate   as date NO-UNDO.
DEFINE VARIABLE v-ToDate     as date NO-UNDO.
DEFINE VARIABLE v-zone       as CHAR NO-UNDO.
DEFINE VARIABLE v-rangeNum   as integer  no-undo.
DEFINE VARIABLE v-prod-bc    AS CHAR  NO-UNDO.
DEFINE BUFFER   buf_wth-par  FOR ub.wth-par.
DEFINE BUFFER   buf_wth-ser  FOR ub.wth-ser.
DEFINE BUFFER   buf_wealth   FOR ub.wealth.
DEFINE BUFFER   buf_cash-pay FOR ub.cash-pay.


DEF VAR v-ctrl AS CHAR NO-UNDO.
DEF VAR v-code AS CHAR NO-UNDO.
DEF VAR i AS INT NO-UNDO.
DEF VAR j AS INT NO-UNDO.

v-ctrl = p-hNode:GET-ATTRIBUTE("ctrl":U).
v-code = p-hNode:GET-ATTRIBUTE("code":U).

CREATE X-NODEREF  hField-out.
CREATE X-NODEREF  hRow-out.
CREATE X-NODEREF  hRowField-out.
CREATE X-NODEREF  hText-out.

IF v-ctrl = 'read' THEN ReadBlock: DO:
    hDoc-Out:CREATE-NODE(hRow-out,'PayMeans','ELEMENT').
    p-hParentOut:APPEND-CHILD(hRow-out).
    hRow-out:SET-ATTRIBUTE("code",v-code).
    hRow-out:SET-ATTRIBUTE("ctrl", "READ":U).

    run str/wthidnt.p ( input v-code /*"КОД ТАЛОНА"*/
              ,output v-ser-code
              ,output v-db-num
              ,output v-stts
              ,output v-wth-code
              ,output v-gds-code
              ,output v-par-code
              ,output v-zone
              ,output v-FromDate
              ,output v-ToDate
              ,output v-rangeNum
              ) no-error.
    if error-status:error then do:
       RUN write-error (RETURN-VALUE
                        ,1
                        ,2
                        ,hRow-out:HANDLE).
       return .
    end.
    RUN write-to-log (SUBSTITUTE('Идентифицирована маска: серия &1-&2, МЦ &3, зона &4, номер &5!',v-ser-code,v-db-num,v-wth-code,v-zone, v-rangeNum)).

    /*Находим буфферы для заполнения всей информ. по талону. При этом пользователю эти ошибки возвращаются как ошибки
    идентификации.  Более подробно ошибки вывводятся в лог.*/
    FIND FIRST buf_wth-ser NO-LOCK WHERE
               buf_wth-ser.ser-code = v-ser-code
           AND buf_wth-ser.db-num = v-db-num NO-ERROR.
    IF NOT AVAILABLE buf_wth-ser THEN DO:
        RUN write-error('Ошибка идентификации талона.'
                        ,2
                        ,2
                       ,hRow-out:HANDLE).
        RUN write-to-log (SUBSTITUTE('ERROR: Не найдена маска с кодом &1-&2!',v-ser-code,v-db-num)).
        LEAVE ReadBlock.
    END.
    FIND FIRST buf_wealth NO-LOCK WHERE
               buf_wealth.wth-code = v-wth-code NO-ERROR.
    IF NOT AVAILABLE buf_wealth THEN DO:
        RUN write-error ('Ошибка идентификации талона.'
                        ,2
                        ,2
                       ,hRow-out:HANDLE).
        RUN write-to-log (SUBSTITUTE('ERROR: Не найдена МЦ с кодом &1!',v-wth-code)).
        LEAVE ReadBlock.
    END.
    find first buf_wth-par no-lock where
               buf_wth-par.par-code = v-par-code no-error.
    if not available buf_wth-par then do:
        RUN write-error ('Ошибка идентификации талона.'
                        ,2
                        ,2
                       ,hRow-out:HANDLE).
        RUN write-to-log (SUBSTITUTE('ERROR: Не найден номинал с кодом &1!',v-par-code)).
        LEAVE ReadBlock.
    end.

    find first buf_cash-pay no-lock where
               buf_cash-pay.wth-code = v-wth-code no-error.
    if not available buf_cash-pay then do:
        RUN write-error ('Ошибка идентификации талона.'
                        ,2
                        ,2
                       ,hRow-out:HANDLE).
        RUN write-to-log (SUBSTITUTE('ERROR: Не найден тип платежа с кодом МЦ &1!',v-wth-code)).
        LEAVE ReadBlock.
    end.
    v-prod-bc = pet-code(v-gds-code).
    if v-prod-bc > '' then.
    else do:
        RUN write-error ('Ошибка идентификации талона.'
                        ,2
                        ,2
                       ,hRow-out:HANDLE).
        RUN write-to-log (SUBSTITUTE('ERROR: Не определен короткий код для кода товара  &1!',v-gds-code)).
        LEAVE ReadBlock.
    end.
    IF v-zone <> {&cli-zone} THEN DO:
        IF v-zone = {&put-zone} THEN RUN write-error(substitute('Талон с номером &1 уже погашен.',v-code)
                       ,4
                       ,2
                       ,hRow-out:HANDLE).
        ELSE RUN write-error (substitute('Нет информации о наличии у клиента талона с номером &1.',v-code)
                        ,5
                        ,2
                       ,hRow-out:HANDLE).
        LEAVE ReadBlock.
    END.
/*    IF v-ToDate <> ? AND TODAY < v-ToDate THEN DO:
        RUN write-error (substitute('Истек срок действия талона (&1).',v-Todate)
                        ,3
                        ,1
               ,hRow-out:HANDLE).
        LEAVE ReadBlock.
    END.
    IF v-FromDate <> ? AND TODAY > v-FromDate THEN DO:
        RUN write-error (substitute('Cрок действия талона (&1) еще не наступил.',v-FromDate)
                        ,3
                        ,1
               ,hRow-out:HANDLE).
        LEAVE ReadBlock.
    END.    */
    hRow-out:SET-ATTRIBUTE("ctrl", "ADD":U).
    RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'PMName' , buf_wealth.wth-name ).
    RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'PMProperty' , string(buf_wth-ser.authr) ).
    RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hRowField-out:HANDLE, hText-out:HANDLE, 'PMMark' , '':U ).
    RUN out-tag-put in THIS-PROCEDURE (hRowField-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'PMMCode' , v-prod-bc ).
    RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'PMCoupType' , '0' ).
    RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'PMValue' , STRING(buf_wth-par.par-val) ).
    RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'PMPayCode' , string(buf_cash-pay.cdpay-code) ).
    RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'PMDateSrartYY' , substring(string(year(v-fromDate)),3,2)).
    RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'PMDateStartMM' , string(month(v-fromDate)) ).
    RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'PMDateStartDD' , string(day(v-fromDate)) ).
    RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'PMDateEndYY' , substring(string(year(v-ToDate)),3,2) ).
    RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'PMDateEndMM' , string(month(v-ToDate)) ).
    RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'PMDateEndDD' , string(day(v-ToDate)) ).
    RUN out-tag-put in THIS-PROCEDURE (hRow-out:HANDLE, hField-out:HANDLE, hText-out:HANDLE, 'PMLock' , string(if buf_wth-ser.stts = 0 then 0 else 1) ).
/*     hDoc-Out:CREATE-NODE(hField-out,'PMMark','Element'). */
/*     hRow-out:APPEND-CHILD(hField-out).                   */
END.

DELETE OBJECT  hField-out.
DELETE OBJECT  hRow-out.
DELETE OBJECT  hRowField-out.
DELETE OBJECT  hText-out.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-start-srv C-Win
PROCEDURE proc-start-srv :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  /*Инициализация сокет-сервера*/
DEF VAR vl-cnt AS LOG NO-UNDO.
IF v-connect-param > '' THEN.
ELSE DO:
  RUN write-to-log('Не указаны параметры подключения!').
  return.
END.
/* v-connect-param = 'sdj78'. */
CREATE SERVER-SOCKET hServerSocket.
hServerSocket:SET-CONNECT-PROCEDURE ("connProc":U).
vl-cnt = hServerSocket:ENABLE-CONNECTIONS(v-connect-param) NO-ERROR.
if vl-cnt = NO THEN do:
  RUN write-to-log(substitute('Ошибка запуска сервера &1!',error-status:get-message(1) )).
  return.
end.
v-srv-connected = YES.
/* IF VALID-HANDLE(hServerSocket) AND hServerSocket:CONNECTED() THEN */
RUN write-to-log(substitute('Запущен сокет-сервер с параметрами: &1 ',v-connect-param)).
btn-st:LABEL IN FRAME {&FRAME-NAME} = 'Стоп'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-stop-srv C-Win
PROCEDURE proc-stop-srv :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEF VAR vl-dis AS LOG NO-UNDO.
vl-dis = hServerSocket:disable-CONNECTIONS() NO-ERROR.
IF NOT vl-dis THEN DO:
  RUN write-to-log(substitute('Ошибка остановки сервера &1!',error-status:get-message(1) )).
  return.
END.
DELETE OBJECT hServerSocket.
IF NOT valid-handle(hServerSocket) THEN
RUN write-to-log(substitute('Остановлен сокет-сервер (&1)',v-connect-param)).
ELSE RETURN.
v-srv-connected = NO.
btn-st:LABEL IN FRAME {&FRAME-NAME} = 'Старт'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE write-error C-Win
PROCEDURE write-error :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-str  AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER p-code AS INT NO-UNDO.
DEFINE INPUT PARAMETER p-severity   AS INT NO-UNDO.
DEFINE INPUT PARAMETER p-hParentOut AS HANDLE NO-UNDO.

DEFINE VARIABLE hRow-out  AS HANDLE NO-UNDO.
DEFINE VARIABLE hText-out  AS HANDLE NO-UNDO.
CREATE X-NODEREF hRow-out.
CREATE X-NODEREF hText-out.

hDoc-Out:CREATE-NODE(hRow-out,'Error','ELEMENT':U).
p-hParentOut:APPEND-CHILD(hRow-out).
hDoc-Out:CREATE-NODE(hText-out,'','TEXT':U).
hRow-out:APPEND-CHILD(hText-out).
hText-out:NODE-VALUE = string(p-code).

hDoc-Out:CREATE-NODE(hRow-out,'ErrorMessage','ELEMENT':U).
p-hParentOut:APPEND-CHILD(hRow-out).
hDoc-Out:CREATE-NODE(hText-out,'','TEXT':U).
hRow-out:APPEND-CHILD(hText-out).
hText-out:NODE-VALUE = p-str.

hDoc-Out:CREATE-NODE(hRow-out,'ErrorSeverity','ELEMENT':U).
p-hParentOut:APPEND-CHILD(hRow-out).
hDoc-Out:CREATE-NODE(hText-out,'','TEXT':U).
hRow-out:APPEND-CHILD(hText-out).
hText-out:NODE-VALUE = string(p-severity).

RUN write-to-log ("ERROR: " + p-str).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE write-to-log C-Win
PROCEDURE write-to-log :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER str AS CHAR NO-UNDO.
str = cur-time-string-sec() + {&tabulation} + str + {&new-line}.

auto-log:move-to-eof( ) IN FRAME {&FRAME-NAME} NO-ERROR.
auto-log:insert-string( str ) NO-ERROR.
OUTPUT TO 'test.txt' APPEND.
PUT UNFORMATTED str .
OUTPUT CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE xml-router C-Win
PROCEDURE xml-router :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-hNode AS HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-ctrl AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER p-code AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER p-hParentOut AS HANDLE NO-UNDO.

CASE p-hNode:NAME:
 WHEN 'Item' THEN DO:

 END.
 WHEN 'PayMeans' THEN DO:
    RUN ParsPayMeans(p-hNode,
                     p-hParentOut) NO-ERROR.
 END.
 WHEN 'ItemHowMany' THEN DO:
    RUN ParsHowMany IN THIS-PROCEDURE(p-hNode
                                       ,p-ctrl
                                       ,p-code
                                       ,p-hParentOut
                                       ) NO-ERROR.
 END.
 WHEN 'AFTermId' THEN DO:
   RUN ParsTermId IN THIS-PROCEDURE(p-hNode
                                       ,p-hParentOut
                                       ) NO-ERROR.

 END.
 WHEN 'AFAuto' THEN DO:
   RUN ParsAuto IN THIS-PROCEDURE(p-hNode
                                       ,p-hParentOut
                                       ) NO-ERROR.

 END.
 WHEN 'AFRequest' THEN DO:
    RUN ParsRequest IN THIS-PROCEDURE(p-hNode
                                       ,p-hParentOut
                                       ) NO-ERROR.
 END.
 WHEN 'AFFact' THEN DO:
    RUN ParsFact IN THIS-PROCEDURE(p-hNode
                                       ,p-hParentOut
                                       ) NO-ERROR.
 END.
 WHEN 'AFGrant' THEN DO:

 END.
END CASE.
IF ERROR-STATUS:ERROR THEN DO:
    RUN write-to-log (RETURN-VALUE).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION pet-code C-Win
FUNCTION pet-code RETURNS CHARACTER
  ( INPUT p-gds-code AS INTEGER ) :
  DEFINE VARIABLE main-b-code LIKE ub.bar-code.b-code NO-UNDO.
  DEFINE VARIABLE l-is-petrol-code AS LOGICAL NO-UNDO.
  DEFINE BUFFER buf_prod-bc FOR ub.prod-bc.
  if p-gds-code = 0 then return "":U.

  { gbl/gdsbcode.i p-gds-code ? main-b-code NO-ERROR }
  IF ERROR-STATUS:ERROR THEN RETURN "":U.

  FOR EACH buf_prod-bc NO-LOCK WHERE
          buf_prod-bc.b-code = main-b-code:
    { gbl/prodbcat.i buf_prod-bc 'petrolium=request' l-is-petrol-code NO-ERROR }
    IF l-is-petrol-code THEN RETURN buf_prod-bc.b-str.
  END.

  RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION SocketRead C-Win
FUNCTION SocketRead RETURNS CHARACTER
 (h AS HANDLE, l AS INTEGER):
  DEFINE VARIABLE b AS MEMPTR NO-UNDO.
  DEFINE VARIABLE s AS CHARACTER NO-UNDO.
  define variable v-read as logical no-undo.
  if not valid-handle(h) then do:
    run write-to-log("bad handle").
  end.
  SET-SIZE(b) = l + 1.
  v-read = h:READ(b, 1, l, 1) no-error.
  if not v-read  or error-status:error then return ''.
  /*message v-read.  */
  s = GET-STRING(b,1).
  SET-SIZE(b) = 0.
  RETURN s.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME