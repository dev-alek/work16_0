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
using ibs.th.skt.ControlledClients.*.

/* Parameters Definitions ---                                           */
define input parameter p-param as character no-undo.
define input parameter p-hide as logical no-undo.
define input parameter p-user-login    as character no-undo .
define input parameter p-user-password as character no-undo .
/* Local Variable Definitions ---                                       */

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "4GL socket server (HTTPD)".


define new shared variable g#LogStr       as character no-undo .
define shared     variable g#auto-user-id as character no-undo .
define shared     variable g#auto-user-login as character no-undo .
define shared     variable g#auto-user-password as character no-undo .

define variable v-header      as character no-undo.
define variable v-hd-line     as character no-undo.
define variable v-cont-length as integer   no-undo.
define variable v-cont-type   as character no-undo.
define variable v-user-agent  as character no-undo.
define variable v-querypar    as character no-undo.
define variable v-path        as character no-undo.
define variable mWork         as logical no-undo.

{ cmp/trg-def.i new }
{ cmp/showinf.i  }
{ gbl/cur-time.i }
{ str/defc-gds.i }
{ cmp/vssrevis.i }
{ cmp/library.i  }
{ utl/search.i   }

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
define variable us-tmo           as INTEGER   INIT 60 no-undo. /*тайм-аут в сек.*/

if num-entries (p-param, ";") = 2
then do:
  v-connect-param = entry (1, p-param, ";").
  us-tmo = integer (entry (2, p-param, ";")) no-error.
  if us-tmo = ?
  then us-tmo = 60.
end.
else do:
  v-connect-param = p-param.
end.
/* v-connect-param = SUBSTITUTE('-H &1 -S &2',ENTRY(1,p-param,':':U),ENTRY(2,p-param,':':U)). */

DEFINE VARIABLE hDoc  AS HANDLE.
DEFINE VARIABLE hRoot AS HANDLE.
DEFINE VARIABLE hRow  AS HANDLE.

DEFINE VARIABLE hDoc-out  AS HANDLE.
DEFINE VARIABLE hRoot-out AS HANDLE.
DEFINE VARIABLE hRow-out  AS HANDLE.

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

DEFINE VARIABLE auto-log AS longchar
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
  mWork = no.
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
mWork = no.
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
  define variable sktserv  as class SktServer no-undo.
  define variable logWrite as class LogWrite  no-undo.

  apply 'choose':U to Btn-st.
    { gbl/curdbnum.i
      g#db-num
    }
  g#language = 'RUS'.
  run gbl/set-gbl.p
    (input true
    ,input p-user-login
    ,input p-user-password
    ) no-error.
  run gbl/get-gbl.p no-error.
  if error-status:error
  then do:
    message "Ошибка получения глобальный переменных." view-as alert-box.
    return error.
  end.

  logWrite = new LogWrite().          
  sktserv  = new SktServer(this-procedure).
  
  mWork = yes.
  subscribe "write-to-log" anywhere.
  define variable CheckUpd      as class ibs.th.adm.upd.CheckUpd no-undo.
  CheckUpd = new ibs.th.adm.upd.CheckUpd ().
  IF NOT THIS-PROCEDURE:PERSISTENT THEN 
  do while mWork:
     /*  */
     
     if valid-object(sktserv)
     then
        if sktserv:checkEnd()
        then
           wait-for close of this-procedure pause 0.001.
        else do:
           if  CheckUpd:isStopWork or CheckUpd:isNeedUpd 
           then do:
              RUN proc-stop-srv.
              mWork = no.
           end.
           else
              wait-for connect of hServerSocket or choose of Btn-st or close of this-procedure pause 60.
        end.
     else
       wait-for choose of Btn-st or close of this-procedure.
     
  end.
  unsubscribe "write-to-log".  
END.
delete object logWrite.
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

  define variable mbuffer       as memptr   no-undo.
  define variable contObj       as class    content no-undo.
  define variable mbuffer-out   as memptr   no-undo.
  define variable mbuffer-in    as memptr   no-undo.
  define variable mbuffer-hdr   as memptr   no-undo.
  define variable us-tmp-etime  as INTEGER  no-undo.
  define variable v-bytes       as integer  no-undo.
  define variable v-str         as char     no-undo init "".
  define variable i             AS INT      NO-UNDO.
  define variable s             AS CHAR     no-undo.
  define variable resp-head     AS longchar NO-UNDO. /*ответ сокет-сервера*/
  define variable lsocket       as logical  no-undo.
  define variable v-read        as logical  no-undo.
  define variable v-content     as longchar no-undo.
  define variable v-step        as integer  no-undo.
  define variable v-pos-buf     as integer  no-undo.
  define variable v-cont-read   as integer  no-undo.
  define variable v-hdr-lenth   as integer  no-undo.
  define variable v-is-hdr-rcvs as logical  no-undo.
  
  
  fix-codepage(v-content) = "1251" .
  fix-codepage(resp-head) = "1251" .
  hSocket:SET-SOCKET-OPTION('TCP-NODELAY', 'true').
  hSocket:SET-SOCKET-OPTION('SO-KEEPALIVE', 'true').
  hSocket:SET-SOCKET-OPTION('SO-REUSEADDR', 'true').
  
  SET-SIZE(mbuffer-out) = 0.
  ASSIGN S = '':U
  v-content = '':U
  v-header = '':U.
  v-cont-length = 0 .
  v-hd-line = "" .
  v-cont-type = "".
  v-user-agent = "".
  
  v-str = '':U.
  resp-head = substitute("HTTP/1.0 400 Bad Request&1Server: 4GL&2",{&CRLF},{&HdEnd}).  /* Возвращаемая по умолчанию ошибка */
  contObj = new content ().
  def var n as int no-undo.
  ContBlock: DO:

  /* читаем сокет и разбираем полученую информацию. */
/*    v-bytes = hSocket:get-bytes-available().*/
/*    if v-bytes = 0 then leave ContBlock.*/


/*    v-str = GET-STRING(mbuffer-in,1).*/
    /*ждем окончание передачи шапки. Признак конца шапки - двойной перевод строки*/
    def var offscont as int no-undo.
    etime(yes).
    v-bytes = 0 .
    offscont = 0.
    n = 0.
    v-str = "".
    v-cont-length = 0.
    v-querypar = "".
    v-path = "".
    set-size (mbuffer-in) = 0.
    set-size (mbuffer-out) = 0.
    set-size (mbuffer) = 0.
    mbuffer-out = ?.
    mbuffer = ?.
    mbuffer-in = ?.
    set-size (mbuffer-hdr) = 33000. 
    
    dwhdr_:
    DO WHILE ETIME < 5000 : /*5 сек на прием шапки*/
      /* читаем сокет и разбираем полученую информацию. */
      if n = v-bytes
      then do:
        n = 0.
        v-bytes = hsocket:get-bytes-available().
      end.
      do while n < v-bytes :
        n = n + 1.
        v-pos-buf = v-pos-buf + 1.
        v-read = hSocket:read(mbuffer-hdr, v-pos-buf, 1, 2) no-error .
        if not v-read 
          then leave.
        if v-pos-buf > 4
          then v-str = get-string (mbuffer-hdr, v-pos-buf - 3, 4).
        if v-pos-buf > 32000
          then leave.
        if v-str = {&HdEnd}
        then do:
          v-header = get-string (mbuffer-hdr, 1).
          v-str = "".
          v-pos-buf = 0.
          run parseheader(input v-header).
          set-size (mbuffer-in) = 0.
          set-size (mbuffer-hdr) = 0.
          set-size (mbuffer-in) = v-cont-length.
          leave dwhdr_.
        end.
      end.
    END.
    
    dw_:
    DO WHILE (v-cont-length > 0 and v-cont-length > v-pos-buf) and ETIME < us-tmo * 1000 :
      /* читаем сокет и разбираем полученую информацию. */
      if n = v-bytes
      then do:
        n = 0.
        v-bytes = hsocket:get-bytes-available().
      end.
      do while n < v-bytes :
        n = n + 1.
        v-pos-buf = v-pos-buf + 1.
        v-read = hSocket:read(mbuffer-in, v-pos-buf, 1, 2) no-error .
        if not v-read 
          then leave.
      end.
    END.
    if not (mbuffer-in = ? or get-size (mbuffer-in) = ? or get-size(mbuffer-in) = 0) and not v-cont-type = 'raw'
      then v-content = get-string (mbuffer-in, 1).
    
    RUN write-to-log-file('SOCKET-READ:' + v-content ).
/*    RUN write-to-log('SOCKET-READ:' + v-str ).*/
    if ((v-content = '' or v-content = ?) and (v-cont-type <> "raw" and v-querypar = "")) or v-header = "" then do:
      resp-head =  substitute("HTTP/1.0 408 Request Timeout or bad request &1Server: 4GL&2",{&CRLF},{&HdEnd}).
      SET-SIZE(mbuffer-out) = 0.
      SET-SIZE(mbuffer-out) = LENGTH(resp-head,'RAW') + 2.
      PUT-STRING(mbuffer-out,1) = resp-head.
      lsocket = hsocket:WRITE(mbuffer-out,1,LENGTH(resp-head,'RAW':U)) no-error.
      hsocket:disconnect ().
      LEAVE ContBlock.
    end.
    
    /* Запросы не в xml формате не обрабатываем */

    if v-cont-type <> 'text/xml':U and v-cont-type <> 'raw' and v-querypar = "" then do:
     /* resp-head = "HTTP/1.1 501 Not Implemented ~nServer: 4GL ~nConnection: close ~n~n".*/
      resp-head = substitute("HTTP/1.0 501 Not Implemented&1Server: 4GL&2",{&CRLF},{&HdEnd}).
      SET-SIZE(mbuffer-out) = 0.
      SET-SIZE(mbuffer-out) = LENGTH(resp-head,'RAW') + 2.
      PUT-STRING(mbuffer-out,1) = resp-head.
      lsocket = hsocket:WRITE(mbuffer-out,1,LENGTH(resp-head,'RAW':U)) no-error.
      hsocket:disconnect ().
      LEAVE ContBlock.
    end.
      IF v-cont-length = 0 and not num-entries (v-querypar, "?") > 1 THEN DO:  /* Если запрос c нулевой длиной тела, то создаем ответ об успешном выполнении запроса */
        resp-head = substitute("HTTP/1.0 411 No Content&1Server: 4GL&2",{&CRLF},{&HdEnd}).
        SET-SIZE(mbuffer-out) = 0.
        SET-SIZE(mbuffer-out) = LENGTH(resp-head,'RAW') + 2.
        PUT-STRING(mbuffer-out,1) = resp-head.
        lsocket = hsocket:WRITE(mbuffer-out,1,LENGTH(resp-head,'RAW':U)) no-error.
        hsocket:disconnect ().
        LEAVE ContBlock.
      END.
      /*ожидаем полной передачи тела запроса*/
/*                                                                                */
/*      IF  LENGTH(v-content) < v-cont-length  THEN DO:                           */
/*          ETIME (YES).                                                          */
/*          DO WHILE LENGTH(v-content) < v-cont-length AND ETIME < us-tmo * 1000 :*/
/*              v-bytes = hSocket:get-bytes-available().                          */
/*              run socketRead(hSocket:handle, v-bytes, input-output mbuffer-in). */
/*              PAUSE 1.                                                          */
/*          END.                                                                  */
/*      END.                                                                      */
      
      RUN write-to-log-file('REQUEST-CONTENT:' + v-content ).
      /* тело запроса передано не полностью */
      IF (v-cont-length > 0 AND v-pos-buf < v-cont-length)  THEN DO:
        resp-head =  substitute("HTTP/1.0 408 Request Timeout&1Server: 4GL&2",{&CRLF},{&HdEnd}).
        SET-SIZE(mbuffer-out) = 0.
        SET-SIZE(mbuffer-out) = LENGTH(resp-head,'RAW') + 2.
        PUT-STRING(mbuffer-out,1) = resp-head.
        lsocket = hsocket:WRITE(mbuffer-out,1,LENGTH(resp-head,'RAW':U)) no-error.
        hsocket:disconnect ().
        LEAVE ContBlock.
      END.
      ELSE DO: /*Если тело не пустое*/
          SET-SIZE(mbuffer) = 0.
          SET-SIZE(mbuffer) = LENGTH(v-content,'RAW') + 2.
          PUT-STRING(mbuffer,1) = v-content.

          case v-path:
          when "AuthMarking" then do:
            sktserv:ClientPar = v-path. 
            sktserv:QueryParam = entry (2, v-querypar, "?").            
          end.
          otherwise do:
            if v-querypar <> ""
            then do:
              if num-entries (v-querypar, "?") > 1
              then do:
                sktserv:ClientPar  = entry (1, v-querypar, "?"). 
                sktserv:QueryParam = entry (2, v-querypar, "?").
              end.
              else do:
                 sktserv:ClientPar = v-querypar.
                 sktserv:QueryParam = "".
               end.
            end.
            else do:
               sktserv:ClientPar = "".
               sktserv:QueryParam = "".
            end.
          end.
          end.
          case true:
          when sktserv:ClientPar <> '' then do:
            sktserv:RequestProcessing(v-content, hsocket) no-error.
            resp-head = if logWrite:LogStr <> "" then logWrite:LogStr else "OK".
          end.
          when v-cont-type = 'raw' then do:
            sktserv:RequestProcessing(mbuffer-in, hsocket, v-user-agent) no-error.
            resp-head = if logWrite:LogStr <> "" then logWrite:LogStr else "OK".
          end.
          when v-cont-type = 'text/xml' then do:
            sktserv:RequestProcessing(v-content, hsocket) no-error.
            resp-head = if logWrite:LogStr <> "" then logWrite:LogStr else "OK".
          end.
          end case.
          
          logWrite:LogStr = "".
          
          /*if error-status:error then do:
            resp-head =  substitute("HTTP/1.0 400 Bad Request&1Server: 4GL&2",{&CRLF},{&HdEnd}).
            RUN write-to-log(return-value).            
          end.
          else do:
/*            resp-head = "OK".*/
          end.*/
          
      END.
  end. /* ContBlock */
  RUN write-to-log('RESPONSE: ' + resp-head).
  
    
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
  RUN write-to-log('Параметры задаются -param "Sock:-S <Port>" или -param "M:<h+>Sock:<Port>" ').
  v-connect-param = "-S 8080".
  RUN write-to-log('Задаем порт по умочанию 8080').
  
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
sktserv  = new SktServer(this-procedure).
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
DELETE OBJECT sktserv.
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
DEFINE INPUT PARAMETER itext AS character NO-UNDO.

define variable str as char no-undo.

auto-log:move-to-eof( ) IN FRAME {&FRAME-NAME} NO-ERROR.
if objExists(itext,"F") eq ?
then do:
   str = cur-time-string-sec() + {&tabulation} + itext + {&new-line}.

   auto-log:insert-string( str ) NO-ERROR.
   RUN write-to-log-file(str).
end.
else do:
   def var varfile-str as longchar no-undo.
   
   str = cur-time-string-sec() + {&tabulation} + "Файл: " +  itext + {&new-line}.
   auto-log:insert-string(str) NO-ERROR.
   auto-log:insert-file(search(itext)) no-error.
   RUN write-to-log-file(str).
   copy-lob
      file itext
      to object varfile-str
   no-error.
   RUN write-to-log-file(varfile-str + {&new-line}).
end.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE write-to-log-file C-Win
PROCEDURE write-to-log-file :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER str-long AS longchar NO-UNDO.

str-long = cur-time-string-sec() + {&tabulation} + str-long + {&new-line} .

copy-lob
from object str-long
to file 'sktsrv.log' append
no-error
.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _Procedure parseheader C-Win
procedure parseheader:
  
  define input parameter p-header as character no-undo.
  define variable n as integer no-undo.
  define variable idxQuerypar as integer no-undo.

  def var i as int no-undo.
  RUN write-to-log('REQUEST-HEADER:' + p-header ).
  /*разбор шапки*/
  n = 2.
  if num-entries (p-header, "/") > 1
  then do:
    v-querypar = right-trim (right-trim  (entry(n, p-header, "/"), "HTTP"), " ").
  end.
  if v-querypar = "AuthMarking"
  then do:
    /* нельзя использовать entry, т.к. в коде марки может быть слеш "/" */
    assign
      v-path = v-querypar
      idxQuerypar = index(p-header,"/")
      idxQuerypar = index(p-header,"/",idxQuerypar + 1)
      v-querypar = right-trim (substring(p-header, idxQuerypar + 1, r-index(p-header,"HTTP") - idxQuerypar - 1), " ")
      n = 3
    .
  end.
  
  p-header = replace (p-header,";",{&CRLF}).
  DO i = 1 TO NUM-ENTRIES(p-header,{&CRLF}):
      v-hd-line = trim(ENTRY(i,p-header,{&CRLF})).
      IF  v-hd-line  BEGINS "Content-Length"  THEN  do:
          v-cont-length = INT(trim(SUBSTRING(v-hd-line,16,LENGTH(v-hd-line)))).
      END.
      IF  v-hd-line  BEGINS "content-type:"  THEN  do:
          v-cont-type = trim(SUBSTRING(v-hd-line,14,LENGTH(v-hd-line))).
      END.
      IF  v-hd-line  BEGINS "user-agent:"  THEN  do:
          v-user-agent = trim(SUBSTRING(v-hd-line,13,LENGTH(v-hd-line))).
      END.
  END.
    
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME