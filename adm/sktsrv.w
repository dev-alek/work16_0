&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DECLARATIONS Procedure
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

using ibs.th.skt.*.
using ibs.th.skt.Adapters.*.

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p-param AS CHARACTER NO-UNDO.
define input parameter p-hide as logical no-undo.
/* Local Variable Definitions ---                                       */

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "4GL socket server (HTTPD)".


define new shared variable g#LogStr       as character no-undo .
define shared     variable g#auto-user-id as character no-undo .

{ cmp/trg-def.i new }
{ cmp/showinf.i  }
{ gbl/cur-time.i }
{ str/defc-gds.i }
{ cmp/vssrevis.i }
{ cmp/library.i  }

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

DEFINE VARIABLE hDoc-out  AS HANDLE.
DEFINE VARIABLE hRoot-out AS HANDLE.
DEFINE VARIABLE hRow-out  AS HANDLE.

/* временные таблицы */
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
THEN C-Win:HIDDEN = yes.

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
  if not p-hide then do:
      C-Win:HIDDEN = no.
  RUN enable_UI.
  end.
  apply 'choose':U to Btn-st.
    { gbl/curdbnum.i
      g#db-num
    }
  g#language = 'RUS'.
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
  define variable v-content     as longchar  no-undo.
  define variable v-cont-length  as INTEGER   no-undo.
  define variable v-cont-type   as longchar  no-undo.
  define variable v-str          as character no-undo.
  define variable i AS INT NO-UNDO.
  define variable s AS CHAR no-undo.
  define variable resp-head     AS longchar  NO-UNDO. /*ответ сокет-сервера*/
  define variable lsocket       as logical   no-undo.
  
  hSocket:SET-SOCKET-OPTION('TCP-NODELAY', 'true').
  hSocket:SET-SOCKET-OPTION('SO-KEEPALIVE', 'true').
  hSocket:SET-SOCKET-OPTION('SO-REUSEADDR', 'true').

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
    v-header  = SUBSTRING(v-str,1,INDEX(v-str,{&HdEnd})) no-error.
    v-content = SUBSTRING(v-str,INDEX(v-str,{&HdEnd}) + 4,LENGTH(v-str)) no-error.
    RUN write-to-log('REQUEST-HEADER:' + v-header ).
    /*разбор шапки*/
    DO i = 1 TO NUM-ENTRIES(v-str,{&CRLF}):
        v-hd-line = trim(ENTRY(i,v-str,{&CRLF})).
        IF  v-hd-line  BEGINS "Content-Length"  THEN  do:
            v-cont-length = INT(trim(entry(1,SUBSTRING(v-hd-line,16,LENGTH(v-hd-line)),';'))).
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

          define variable sktserv  as class SktServer no-undo.
          define variable logWrite as class LogWrite  no-undo.

          sktserv = new SktServer().
          logWrite = new LogWrite().
          sktserv:RequestProcessing(v-content, hsocket) no-error.
          resp-head = if logWrite:LogStr <> "" then logWrite:LogStr else "OK".
          logWrite:LogStr = "".
          /*if error-status:error then do:
            resp-head =  substitute("HTTP/1.0 400 Bad Request&1Server: 4GL&2",{&CRLF},{&HdEnd}).
            RUN write-to-log(return-value).            
          end.
          else do:
/*            resp-head = "OK".*/
          end.*/
          delete object sktserv.
      END.
  end. /* ContBlock */
  /* шапка http-ответа + тело ответа помещенное в память*/
/*  SET-SIZE(mbuffer-out) = 0.                            */
/*  SET-SIZE(mbuffer-out) = LENGTH(resp-head,'RAW':U) + 1.*/
/*  PUT-STRING(mbuffer-out,1) = resp-head.*/
  lsocket = hsocket:WRITE(mbuffer-out,1,LENGTH(resp-head,'RAW':U)) no-error.

  IF lsocket = FALSE OR ERROR-STATUS:GET-MESSAGE(1) <> '' THEN
        DO:
  RUN write-to-log('RESPONSE: ' + resp-head).
            RETURN.
        END.

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
OUTPUT TO 'sktsrv.log' APPEND.
PUT UNFORMATTED str .
OUTPUT CLOSE.
END PROCEDURE.

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