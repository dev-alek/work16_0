&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
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
using Progress.Lang.*.
using Progress.Json.ObjectModel.*.

/* Parameters Definitions ---                                           */
define input parameter parparentproc as widget-handle no-undo .
/* Local Variable Definitions ---                                       */

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Толкач выгрузки на прайс-чекер".
{ cmp/vssrevis.i }
{ gbl/getcntxt.i def }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ gbl/cd-attr.i  }
{ gbl/db-attr.i }
{ gbl/windows.i  }
{ gbl/runrepid.i }
{ cmp/mrk-strf.i }
{ rep/html-conv.i }
{ cmp/r-pril.i new }
{ cmp/r-page1.i new }
/*{ cmp/r-page1.i " " cmp }*/
{ gbl/prn-lib.i }
{ gbl/waitfram.i }
{ str/placelib.i }

function f-int-to-chr returns character (input v-int as integer) :
  if v-int = 0 or v-int = ? then return "" .
  return string(v-int) .
end function .

function f-dec-to-chr returns character (input v-dec as decimal) :
  if v-dec = ? then return "" .
  return string(v-dec, "->>>>>>>9.99<<<") .
end function .

define temp-table tt-place no-undo
  field loc1          as character  label "№ резервуара"
  field pl-code       as integer    label "Код резервуара" format ">>>>>>>>>9"
  field gds-code      as integer    label "Код продукта" format ">>>>>>>>>9"
  field gds-name      as character  label "НАИМЕНОВАНИЕ ПРОДУКТА" format "X(20)"
  field level-total   as decimal    label "Общий уровень (см)"
  field level-water   as decimal    label "Уровень воды (см)"
  field total-vol     as decimal    label "Общий объем (л)"
  field avrg-temp     as decimal    label "Средняя Т"
  field t1            as decimal    label "T1"
  field t2            as decimal    label "T2"
  field t3            as decimal    label "T3"
  field density       as decimal decimals 10  label "Плотность (кг/л)" format ">>>>>>>>>9.9<<<<<<<<<"
  field mass          as decimal    label "Масса (кг)"
  field vapor-density as decimal decimals 10  label "Плотность СУГ ПФ (кг/л)" format ">>>>>>>>>9.9<<<<<<<<<"
  field vapor-pressure as decimal   label "Давление СУГ (мПа)" format ">>>9.99999"
  field is-error      as logical 
  field error-message as character
  index pi as primary unique
    loc1
.

define temp-table tt-pids no-undo
  field pid as integer
  index pi as primary unique
    pid
.

define variable log-exit          as logical    no-undo .
define variable curl-path         as character  no-undo .
define variable v-post-file-name  as character  no-undo .
define variable v-cmd-file-name   as character  no-undo .
define variable v-command         as character  no-undo .
define variable v-out-str         as character  no-undo .
define variable v-pid-list        as character  no-undo .
define variable v-time-str        as character  no-undo .
define variable v-del-file        as character  no-undo .
define variable v-log-file-name   as character  no-undo .

define variable v-parsesub        as character  no-undo .
define variable hDoc              as handle     no-undo .
define variable hRoot             as handle     no-undo .
define variable good              as logical    no-undo .

define variable v-temp-dir        as character  no-undo .

define variable rv                as integer    no-undo .

define variable cash-recids       as character  no-undo .
define variable ii                as integer    no-undo .

define variable rid-list          as character  no-undo .

define variable v-asi-ip  as character no-undo .
define variable v-asi-port as character no-undo .
define variable v-asi-type as character no-undo .
define variable v-attr-type as character no-undo .

define variable v-mode    as integer no-undo .

define variable v-status  as character view-as text label "Статус" initial "" format "X(80)".

define variable v-asi-error-code as integer no-undo initial 0 .
define variable v-asi-error-message as character no-undo .

define buffer buf_clients for ub.clients .
define buffer buf_place for ub.place .
define buffer buf_pl-gds for ub.pl-gds .
define buffer buf_tt-place for tt-place .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-exit b-req b-print

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */

DEFINE BUTTON b-exit AUTO-END-KEY 
     LABEL "Выход" 
     SIZE 10 BY 1
     BGCOLOR 8 .
     
DEFINE BUTTON b-req
     LABEL "Запрос" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-print 
     LABEL "Печать" 
     SIZE 18 BY 1
     BGCOLOR 8 .



define query br-place for tt-place scrolling .

define browse br-place
  query br-place no-lock display
    tt-place.loc1
    f-int-to-chr(tt-place.pl-code)  label "Код резервуара"
    tt-place.gds-name
    f-int-to-chr(tt-place.gds-code)  label "Код продукта"
    tt-place.level-total
    tt-place.level-water
    tt-place.total-vol
    tt-place.avrg-temp
    tt-place.density
    tt-place.mass
    tt-place.vapor-density
    tt-place.vapor-pressure
WITH NO-ROW-MARKERS SEPARATORS SIZE 143 BY 15
         TITLE "Показания АСИ" FIT-LAST-COLUMN.
    
define stream OutStr-html.
define stream MyWatch-strm. /* задать в области определения переменных */

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     b-exit AT ROW 1.24 COL 2
     b-req at row 1.24 col 12.1
     b-print AT ROW 1.24 COL 93 WIDGET-ID 10
     br-place at row 3 col 2
     v-status at row 18 col 2
     SPACE(1) 
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Показания АСИ"
         CANCEL-BUTTON b-exit WIDGET-ID 100.


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
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* <insert dialog title> */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-req
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-req Dialog-Frame
ON CHOOSE OF b-req IN FRAME Dialog-Frame 
DO:
  case v-mode :
    when 1
    then do :
      run get-from-struna no-error .
      if error-status:error
      then do :
        v-status = return-value .
      end .
      else do :
        v-status = "Данные получены " + string(NOW) .
      end.
    end .
    when 2
    then do :
      run asi-send-cmd no-error .
      if error-status:error
      then do :
        v-status = return-value .
      end .
      else do :
        v-status = "Запрос отправлен " + string(NOW) .
        display v-status with frame {&frame-name} .
      end.
    end .
    when 3
    then do :
      run get-from-ifsf no-error .
      if error-status:error
      then do :
        v-status = return-value .
      end .
      else do :
        v-status = "Данные получены " + string(NOW) .
      end.
    end .
  end case .
  
  if v-mode = 2
  then do :
    run sleep (500) .
    run asi-read-sts no-error .
    if error-status:error
    then do :
      v-status = return-value .
    end .
    else do :
      v-status = "Данные получены " + string(NOW) .
    end.
  end.
  open query br-place for each tt-place indexed-reposition .
  display v-status with frame {&frame-name} .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-print
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-print Dialog-Frame
ON CHOOSE OF b-print IN FRAME Dialog-Frame 
DO:
  case v-mode :
    when 1
    then do :
      run get-from-struna no-error .
      if error-status:error
      then do :
        message return-value view-as alert-box .
        return no-apply .
      end .
    end .
    when 2
    then do :
      run asi-send-cmd no-error .
      if error-status:error
      then do :
        message return-value view-as alert-box .
        return no-apply .
      end .
      run sleep (500) .
      run asi-read-sts no-error .
      if error-status:error
      then do :
        message return-value view-as alert-box .
        return no-apply .
      end .
    end .
    when 3
    then do :
      run get-from-ifsf no-error .
      if error-status:error
      then do :
        message return-value view-as alert-box .
        return no-apply .
      end .
    end .
  end case .
  
  run My-Rep.
  
  run waitfram-hide in this-procedure no-error .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-exit Dialog-Frame
ON CHOOSE OF b-exit IN FRAME Dialog-Frame /* Выход */
DO:
  
  for each tt-place no-lock :
    v-del-file = v-temp-dir + "\asiresp_" + string(tt-place.loc1) + ".xml" .
    v-del-file = search(v-del-file) .
    if v-del-file = ? or trim(v-del-file) = ""
    then next .
                   
    os-delete value(v-del-file) . 
    
    v-del-file = v-temp-dir + "\asireq_" + string(tt-place.loc1) + ".bat" . 
    v-del-file = search(v-del-file) .
    if v-del-file = ? or trim(v-del-file) = ""
    then next .
                   
    os-delete value(v-del-file) .             
  end.
  run sleep (1000) .
  os-delete value (search(v-temp-dir)) recursive .
  
  assign
    log-exit = true
  .
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

on row-display OF br-place IN FRAME Dialog-Frame
do:
  if  tt-place.level-total    = ? then tt-place.level-total:fgcolor in browse br-place = 15 . 
  if  tt-place.level-water    = ? then tt-place.level-water:fgcolor in browse br-place = 15 .  
  if  tt-place.total-vol      = ? then tt-place.total-vol:fgcolor in browse br-place = 15 . 
  if  tt-place.avrg-temp      = ? then tt-place.avrg-temp:fgcolor in browse br-place = 15 .  
  if  tt-place.density        = ? then tt-place.density:fgcolor in browse br-place = 15 . 
  if  tt-place.mass           = ? then tt-place.mass:fgcolor in browse br-place = 15 .
  if  tt-place.vapor-density  = ? then tt-place.vapor-density:fgcolor in browse br-place = 15 .
  if  tt-place.vapor-pressure = ? then tt-place.vapor-pressure:fgcolor in browse br-place = 15 .
end.

&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  { gbl/getcntxt.i get }
  
  v-log-file-name = substitute('&1rvs.log', ibs.th.gbl.gbl-inipar:logDir) .
  v-temp-dir = "ASI_temp-cmd" .
  os-delete value (v-temp-dir) recursive no-error .
  os-create-dir value(v-temp-dir) .
  
  run db-attr-value(v-cntxt-db-num,"AsiIp",output v-asi-ip,output v-attr-type).
  run db-attr-value(v-cntxt-db-num,"AsiPort",output v-asi-port,output v-attr-type).
  run db-attr-value(v-cntxt-db-num,"AsiType",output v-asi-type,output v-attr-type).
  
  if trim(v-asi-ip) <> ''
  and trim(v-asi-port) <> ''
  and trim(v-asi-type) <> ''
  then do :
    case v-asi-type :
      when "1"
      then do :
        v-mode = 2 .
      end .
      when "2"
      then do :
        v-mode = 3 .
      end .
    end case .
  end . 
  else do :
    v-mode = 1 .
  end . 
  
  empty temp-table tt-pids .
  
  assign
    curl-path = search("exe/curl.exe")
  .
  
  run init-tt .
  
  case v-mode :
    when 1
    then do :
      run get-from-struna no-error .
      if error-status:error
      then do :
        v-status = return-value .
      end .
      else do :
        v-status = "Данные получены " + string(NOW) .
      end.
    end .
    when 2
    then do :
      run asi-send-cmd no-error .
      if error-status:error
      then do :
        v-status = return-value .
      end .
      else do :
        v-status = "Запрос отправлен " + string(NOW) .
      end.
      run sleep (500) .
    end .
    when 3
    then do :
      run get-from-ifsf no-error .
      if error-status:error
      then do :
        v-status = return-value .
      end .
      else do :
        v-status = "Данные получены " + string(NOW) .
      end.
    end .
  end case .
  
  RUN enable_UI.
  if v-mode = 2
  then do :
    run asi-read-sts no-error .
    if error-status:error
    then do :
      v-status = return-value .
    end .
    else do :
      v-status = "Данные получены " + string(NOW) .
    end.
  end.
  open query br-place for each tt-place indexed-reposition .
  display v-status with frame {&frame-name} .
  
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
   
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

procedure asi-send-cmd :
  define variable bat-file              as character    no-undo .
  define variable cmd                   as character    no-undo .
  define variable v-pid                 as integer      no-undo .
  define variable v-addr                as character    no-undo .
  define variable v-file                as character    no-undo .
  v-file = v-temp-dir + "\asiresp_agnt.xml" .
  
  v-addr = v-asi-ip + ":" + v-asi-port + "/getmeas/?loclist=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22" .
  cmd = substitute ('&1 --connect-timeout 5 "&3" >&2', search ("exe/curl.exe"), v-file, v-addr).          
  bat-file = v-temp-dir + "\asireq_agnt.bat" .  
  output to value(bat-file) .
  put unformatted cmd skip .
  output close .     
  
  os-delete value(v-file) no-error .
  v-file = search(v-file) .
  if v-file = ? or trim(v-file) = ""
  then do :
  end . 
  else do :
    return error ("Не могу удалить файл " + v-file + " для получения новых данных!") .
  end .
      
  run gbl/run-gpid.p (  input bat-file
                       ,input '':U
                       ,output v-pid).
                       
  output to value (  v-log-file-name  ) append .
  put unformatted string(today) ' ' string(time, "HH:MM:SS") "  Запрос  " cmd skip .
  output close .     
                  
  run sleep (500) .
  rv = IsProcessRunning(v-pid). 
  if rv >= 0 then do :
  end.
  else do :
    os-delete value(bat-file) .
  end.                     
  find first tt-pids no-lock where tt-pids.pid = v-pid no-error .
  if not available tt-pids
  then do :
    create tt-pids.
    tt-pids.pid = v-pid .
  end.                      
  
  v-file = search(v-file) .
  if v-file = ? or trim(v-file) = ""
  then do :
  end .
  else do :
    file-info:file-name = v-file .
    if file-info:file-size = 0
    then do :
    end.
    else do :
      run parse-xml (input v-file,
                     input-output table tt-place) .
      
    end.
  end.
  
end procedure .

procedure asi-read-sts :
  define variable v-file    as character no-undo .
  define variable jj as integer no-undo .
  define variable err-msg as character no-undo .
  v-file = v-temp-dir + "\asiresp_agnt.xml" .
  v-file = search(v-file) .
  if v-file = ? or trim(v-file) = ""
  then return error "Не могу получить данные от агента АСИ".
  
  jj_ :
  do jj = 1 to 20 :
    file-info:file-name = v-file .
    if file-info:file-size = 0
    then do :
      run sleep(500) .
    end.
    else leave .
  end.
  
  file-info:file-name = v-file .
  if file-info:file-size = 0
  then do :
    os-delete value(v-file) .
    return error "Пустой ответ от агента АСИ".
  end.
  
  run parse-xml (input v-file,
                 input-output table tt-place) .
                 
  find first buf_tt-place no-error .
  if available buf_tt-place
  then
  br-place:refresh () in frame Dialog-Frame no-error . 
  
  find first buf_tt-place where buf_tt-place.is-error no-error .
  if available buf_tt-place
  then do :
    err-msg = "Ошибка при получении данных с резервуаров " .
    for each buf_tt-place where buf_tt-place.is-error :
      err-msg = err-msg + buf_tt-place.loc1 + ", " .
    end .
    err-msg = trim(err-msg) .
    err-msg = trim(err-msg, ",") .
    return error err-msg .
  end .
end procedure .

procedure parse-xml :
  define input parameter p-file as character .
  define input-output parameter table for tt-place .
  
  CREATE X-DOCUMENT hDoc.
  CREATE X-NODEREF hRoot.
     
  hDoc:LOAD("file",p-file,FALSE).
     
  hDoc:GET-DOCUMENT-ELEMENT(hRoot).
      
  RUN GetChildren(hRoot, 1).
  
  DELETE OBJECT hDoc.
  DELETE OBJECT hRoot.
  
  output to value (  v-log-file-name  ) append .
  put unformatted string(today) ' ' string(time, "HH:MM:SS") "  Данные  " skip .
  for each tt-place no-lock :
    put unformatted ("TANK = " + tt-place.loc1 ) skip .
    if tt-place.level-total <> ? then
      put unformatted ("LEVEL_TOTAL = " + string(tt-place.level-total, ">>>>>9.9<<<")) skip .
    if tt-place.level-water <> ? then
      put unformatted ("LEVEL_WATER = " + string(tt-place.level-water, ">>>>>9.9<<<")) skip .
    if (tt-place.level-total - tt-place.level-water) <> ? then
      put unformatted ("LEVEL_OIL = " + string((tt-place.level-total - tt-place.level-water), ">>>>>9.9<<<")) skip .
    if tt-place.avrg-temp <> ? then
      put unformatted ("TEMPERATURE = " + string(tt-place.avrg-temp, "->>>>>9.9<<<")) skip .
    if tt-place.density <> ? then
      put unformatted ("DENSITY = " + string(tt-place.density, ">>>>>>>>>9.9<<<<<<<<<")) skip .
    if tt-place.total-vol <> ? then
      put unformatted ("VOLUME_TOTAL = " + string(tt-place.total-vol, ">>>>>9.9<<<")) skip .
    if tt-place.mass <> ? then
      put unformatted ("MASS_TOTAL = " + string(tt-place.mass, ">>>>>9.9<<<")) skip .
    if tt-place.t1 <> ? then
      put unformatted ("T1 = " + string(tt-place.t1, "->>>>>9.9<<<")) skip .
    if tt-place.t2 <> ? then
      put unformatted ("T2 = " + string(tt-place.t1, "->>>>>9.9<<<")) skip .
    if tt-place.t3 <> ? then
      put unformatted ("T3 = " + string(tt-place.t3, "->>>>>9.9<<<")) skip .
    if tt-place.vapor-density <> 0 and tt-place.vapor-density <> ? then
      put unformatted ("VAPOR_DENSITY = " + string(tt-place.vapor-density, ">>>>>>>>>9.9<<<<<<<<<")) skip .
    if tt-place.vapor-pressure <> 0 and tt-place.vapor-pressure <> ? then
      put unformatted ("VAPOR_PRESSURE = " + string(tt-place.vapor-pressure, ">>>>>9.9<<<")) skip .
  end.
  output close .
  
end procedure .

PROCEDURE GetChildren:
DEFINE INPUT PARAMETER hParent AS HANDLE NO-UNDO.
DEFINE INPUT PARAMETER level AS INTEGER NO-UNDO.

DEFINE VARIABLE i AS INTEGER NO-UNDO.
DEFINE VARIABLE hNoderef AS HANDLE NO-UNDO.
DEFINE VARIABLE hText AS HANDLE NO-UNDO.
define variable client as character no-undo.

CREATE X-NODEREF hNoderef.
CREATE X-NODEREF hText .


REPEAT i = 1 TO hParent:NUM-CHILDREN:
    good = hParent:GET-CHILD(hNoderef,i).
    IF NOT good THEN 
        LEAVE.
    IF hNoderef:SUBTYPE <> "element" THEN
        NEXT.
    
    hNoderef:GET-CHILD(hText, 1) no-error .    
    
    IF hNoderef:NAME = "ErrNum"
    then do :
      v-asi-error-code = integer(hText:node-value) no-error .
    end .
    
    IF hNoderef:NAME = "ErrMsg"
    then do :
      v-asi-error-message = hText:node-value no-error .
      if v-asi-error-code > 0
      then do :
        assign
          tt-place.t1             = ?
          tt-place.t2             = ?
          tt-place.t3             = ?
          tt-place.level-total    = ?   
          tt-place.level-water    = ?   
          tt-place.total-vol      = ? 
          tt-place.avrg-temp      = ?  
          tt-place.density        = ? 
          tt-place.mass           = ?
          tt-place.vapor-density  = ?
          tt-place.vapor-pressure = ?
          tt-place.is-error       = true
          tt-place.error-message  = v-asi-error-message
        .
      end .
    end .
        
    IF hNoderef:NAME = "Tank"
    then do :
      find first tt-place where tt-place.loc1 = hText:node-value no-error .
      if not available tt-place
      then do :
        create tt-place .
        assign tt-place.loc1 = hText:node-value no-error .
        assign
          tt-place.t1             = ?
          tt-place.t2             = ?
          tt-place.t3             = ?
          tt-place.level-total    = ?   
          tt-place.level-water    = ?   
          tt-place.total-vol      = ? 
          tt-place.avrg-temp      = ?  
          tt-place.density        = ? 
          tt-place.mass           = ?
          tt-place.vapor-density  = ?
          tt-place.vapor-pressure = ?
        .
      end.
    end.
    
    if v-asi-error-code = 0
    then do :
      IF hNoderef:NAME = "LevelTotal" then assign tt-place.level-total = decimal(hText:node-value) / 10 no-error .
      IF hNoderef:NAME = "LevelWater" then assign tt-place.level-water = decimal(hText:node-value) / 10 no-error .
      IF hNoderef:NAME = "Temperature" then assign tt-place.avrg-temp = decimal(hText:node-value) no-error .
      IF hNoderef:NAME = "Density" then assign tt-place.density = decimal(hText:node-value) no-error .
      IF hNoderef:NAME = "VolumeTotal" then assign tt-place.total-vol = decimal(hText:node-value) no-error .
      IF hNoderef:NAME = "MassTotal" then assign tt-place.mass = decimal(hText:node-value) no-error .
      IF hNoderef:NAME = "VaporDensity" then assign tt-place.vapor-density = decimal(hText:node-value) no-error .
      IF hNoderef:NAME = "VaporPressure" then assign tt-place.vapor-pressure = decimal(hText:node-value) / 1000 no-error .
      IF hNoderef:NAME = "Temperature1" then assign tt-place.t1 = decimal(hText:node-value) no-error .
      IF hNoderef:NAME = "Temperature2" then assign tt-place.t2 = decimal(hText:node-value) no-error .
      IF hNoderef:NAME = "Temperature3" then assign tt-place.t3 = decimal(hText:node-value) no-error .
    end .
           
    RUN GetChildren(hNoderef, (level + 1)).
END.

DELETE OBJECT hNoderef.
DELETE OBJECT hText.
END PROCEDURE.

procedure init-tt :
  define variable pl-twice-code as character no-undo initial "" .
  define variable v-value       as character no-undo .
  define variable v-ok          as logical   no-undo .
  define buffer buf_tt-place for tt-place .
  
  for each buf_place no-lock where buf_place.obj-type = v-cntxt-obj-type
                               and buf_place.obj-code = v-cntxt-obj-code
                               and buf_place.is-meas 
                               and buf_place.status_ = ""  :
    find first tt-place where tt-place.loc1 = buf_place.loc1 no-error.
    if not available tt-place
    then do :
      create tt-place .
      assign
        tt-place.loc1     = buf_place.loc1
        tt-place.pl-code  = buf_place.pl-code
      .
      assign
        tt-place.t1             = ?
        tt-place.t2             = ?
        tt-place.t3             = ?
        tt-place.level-total    = ?   
        tt-place.level-water    = ?   
        tt-place.total-vol      = ? 
        tt-place.avrg-temp      = ?  
        tt-place.density        = ? 
        tt-place.mass           = ?
        tt-place.vapor-density  = ?
        tt-place.vapor-pressure = ?
      .
      find first buf_pl-gds no-lock where buf_pl-gds.pl-code = buf_place.pl-code no-error .
      if available (buf_pl-gds) then 
      do:
        tt-place.gds-code = buf_pl-gds.gds-code .
        find first goods no-lock where goods.gds-code = tt-place.gds-code .
        if available (goods)
        then tt-place.gds-name = goods.gds-name .
      end.
    end.  
    run placelib_get-attr  ( input {&place-twice-code}
                      ,input v-cntxt-obj-code
                      ,input v-cntxt-obj-type
                      ,input buf_place.pl-code
                      ,output v-value
                      ,output v-ok      ) no-error.   
    if v-ok then pl-twice-code = v-value . 
    if trim(pl-twice-code) > ""
    then do :
      if num-entries(pl-twice-code) > 1
      then do :
        do ii = 1 to num-entries(pl-twice-code) :
          find first buf_tt-place where buf_tt-place.loc1 = trim( entry( ii, pl-twice-code ) ) no-error.
          if not available buf_tt-place
          then do :
            create buf_tt-place .
          end.
          assign
            buf_tt-place.loc1 = trim( entry( ii, pl-twice-code ) )
          .
          assign  
            buf_tt-place.gds-code = tt-place.gds-code
            buf_tt-place.gds-name = tt-place.gds-name
          .
          assign
            buf_tt-place.t1             = ?
            buf_tt-place.t2             = ?
            buf_tt-place.t3             = ?
            buf_tt-place.level-total    = ?   
            buf_tt-place.level-water    = ?   
            buf_tt-place.total-vol      = ? 
            buf_tt-place.avrg-temp      = ?  
            buf_tt-place.density        = ? 
            buf_tt-place.mass           = ?
            buf_tt-place.vapor-density  = ?
            buf_tt-place.vapor-pressure = ?
          .
        end.
      end.
      else do :
        find first buf_tt-place where buf_tt-place.loc1 = pl-twice-code no-error .
        if not available buf_tt-place
        then do :
          create buf_tt-place .
        end.
        assign
          buf_tt-place.loc1 = pl-twice-code
        .
        assign  
          buf_tt-place.gds-code = tt-place.gds-code
          buf_tt-place.gds-name = tt-place.gds-name
        .
        assign
          buf_tt-place.t1             = ?
          buf_tt-place.t2             = ?
          buf_tt-place.t3             = ?
          buf_tt-place.level-total    = ?   
          buf_tt-place.level-water    = ?   
          buf_tt-place.total-vol      = ? 
          buf_tt-place.avrg-temp      = ?  
          buf_tt-place.density        = ? 
          buf_tt-place.mass           = ?
          buf_tt-place.vapor-density  = ?
          buf_tt-place.vapor-pressure = ?
        .
      end.
    end.
    pl-twice-code = "" .                          
  end.
  
end procedure.

procedure get-from-struna :
  define variable v-comstring as character no-undo .
  define variable v_File-Name as character no-undo .
  define variable v_command as character no-undo .
  
  define variable str       as character no-undo .
  define variable str1      as character no-undo .
  define variable str2      as character no-undo .
  
  define variable StrFrFile-list as character no-undo initial '':U.
  
  StrFrFile-list = 'tank,level_total,level_water,level_oil,t1,t2,t3,temperature,density,'
                 + 'volume_total,volume_total_tc,mass_total,volume_oil,volume_water,vapor_density,vapor_pressure' .
  
  get-key-value section 'revision'
                key     'comstr'
                value   v-comstring.
  
  assign
    v_File-Name = 'revis.txt':U
  .
  os-delete value( v_File-Name ) .
  if v-comstring = '':U
    or v-comstring = ?
  then do:
    return error 'Не задан парам. comstr в секции revision ini файла.' .
  end.
  
  assign
    v_command = substitute( "&1 &2 &3 &4", v-comstring, string(0), v_File-Name, v-cntxt-obj-code)
  .
  os-command silent value( v_command ) .
  
  output to value (  v-log-file-name  ) append .
  put unformatted string(today) ' ' string(time, "HH:MM:SS") "  Запрос  " v_command skip .
  
  if search( v_File-Name ) = ? then do:
    put unformatted string(today) ' ' string(time, "HH:MM:SS") "  Файл с прибора не получен.  " v_command skip .
    output close .
    return error 'Файл с прибора не получен.' .
  end.
  else do: 
    v_File-Name  = search( v_File-Name ) . 
  end.
  
  put unformatted string(today) ' ' string(time, "HH:MM:SS") "  Данные  " skip .
  output close .
  os-append value(v_File-Name) value(v-log-file-name).
  output to value (  v-log-file-name  ) append .
  put unformatted skip .
  output close .
  
  input from value(v_File-Name) .
  repeat :
    import unformatted str .  
    if index( str, "#" ) > 0
    then do:
      assign
        str = substring( str, 1, index( str, "#" ) - 1 )
      .
    end.
    if str = '':U then next .
    str1 = trim(entry(1, str, "=")) .
    str2 = trim(entry(2, str, "=")) .
    if can-do(StrFrFile-list, str1)
    then do :
      case str1 :
        when "tank"
        then do :
          find first tt-place where tt-place.loc1 = str2 no-error .
          if not available tt-place
          then do :
            create tt-place .
            assign tt-place.loc1 = str2 no-error .
            assign
              tt-place.t1             = ?
              tt-place.t2             = ?
              tt-place.t3             = ?
              tt-place.level-total    = ?   
              tt-place.level-water    = ?   
              tt-place.total-vol      = ? 
              tt-place.avrg-temp      = ?  
              tt-place.density        = ? 
              tt-place.mass           = ?
              tt-place.vapor-density  = ?
              tt-place.vapor-pressure = ?
            .
          end.
        end .
        when "level_total" then assign tt-place.level-total = decimal(str2) no-error .
        when "level_water" then assign tt-place.level-water = decimal(str2) no-error .
/*        when "level_oil" then assign tt-place.*/
        when "temperature" then assign tt-place.avrg-temp = decimal(str2) no-error .
        when "t1" then assign tt-place.t1 = decimal(str2) no-error .
        when "t2" then assign tt-place.t2 = decimal(str2) no-error .
        when "t3" then assign tt-place.t3 = decimal(str2) no-error .
        when "density" then assign tt-place.density = decimal(str2) no-error .
        when "volume_total" then assign tt-place.total-vol = decimal(str2) no-error .
        when "mass_total" then assign tt-place.mass = decimal(str2) no-error .
/*        when "volume_oil" then assign tt-place.*/
/*        when "volume_water" then assign tt-place.*/
        when "vapor_density" then assign tt-place.vapor-density = decimal(str2) no-error .
        when "vapor_pressure" then assign tt-place.vapor-pressure = decimal(str2) / 1000 no-error .
      end case .
    end .
  end.
  input close .
  
end procedure .

procedure get-from-ifsf :
/*  define variable v-asi-ip  as character no-undo .  */
/*  define variable v-asi-port as character no-undo . */
/*  define variable v-attr-type as character no-undo .*/
  define variable v_command     as   character     no-undo.
  define variable v-log     as logical no-undo .
  define variable v-bytes   as integer no-undo .
  define variable v-out-data as character no-undo .
  define variable v-line-str as character no-undo .
  define variable ii        as integer no-undo .
  define variable str       as character no-undo .
  define variable str1      as character no-undo .
  define variable str2      as character no-undo .
  
  define variable hSocket   as handle no-undo .
  define variable mDataIn   as memptr no-undo .
  define variable mDataout  as memptr no-undo .
  define variable cmd       as character no-undo .
  define variable connStr   as character no-undo .
  
  define variable StrFrFile-list as character no-undo initial '':U.
  
  StrFrFile-list = 'tank,level_total,level_water,level_oil,t1,t2,t3,temperature,density,'
                 + 'volume_total,volume_total_tc,mass_total,volume_oil,volume_water,vapor_density,vapor_pressure' .
  
  
  cmd = 'KOI8-R 1 0 1' + {&new-line} .
  set-size(mDataIn) = 0 .
  set-size(mDataIn) = length(cmd , "RAW":U) + 1 .
  put-string(mDataIn,1) = cmd .
  
/*  find first sys-ctrl no-lock.                                                  */
/*  run db-attr-value(sys-ctrl.db,"AsiIp",output v-asi-ip,output v-attr-type).    */
/*  run db-attr-value(sys-ctrl.db,"AsiPort",output v-asi-port,output v-attr-type).*/
  
  create socket hSocket .
  hSocket:disconnect() no-error.
  connStr = '-H ' + v-asi-ip + ' -S ' + v-asi-port .
  hSocket:connect(connStr) no-error.
  
  output to value (  v-log-file-name  ) append .
  put unformatted string(today) ' ' string(time, "HH:MM:SS") "  Запрос  connStr='-H " v-asi-ip " -S " v-asi-port "'  cmd='KOI8-R 1 0 1'" skip .
  output close .
  
  if hSocket:connected() = false
  then do :
    return error "Не могу подключиться к IFSF серверу." .
  end.
  
  hSocket:set-socket-option('TCP-NODELAY', 'true').
  hSocket:set-socket-option('SO-KEEPALIVE', 'true').
  hSocket:set-socket-option('SO-REUSEADDR', 'true').
  
  v-log = hSocket:write(mDataIn, 1, get-size(mDataIn)) no-error.
  if v-log = false or error-status:get-message(1) <> ''
  then do:
    hSocket:disconnect() no-error.
    output to value (  v-log-file-name  ) append .
    put unformatted string(today) ' ' string(time, "HH:MM:SS") "  Не могу отправить команду на IFSF сервер.  " skip .
    output close .
    return error "Не могу отправить команду на IFSF сервер." .
  end.
  
  run sleep (1000) .
  
  set-size(mDataOut) = 0 .
  v-bytes = hSocket:get-bytes-available() .
  set-size(mDataOut) = v-bytes + 1 .
  
  v-log = hSocket:read(mDataOut, 1, v-bytes, 2) no-error.
  if v-log = false or error-status:get-message(1) <> ''
  then do:
    hSocket:disconnect() no-error.
    output to value (  v-log-file-name  ) append .
    put unformatted string(today) ' ' string(time, "HH:MM:SS") "  Не могу прочитать ответ от IFSF сервера.  " skip .
    output close .
    return error "Не могу прочитать ответ от IFSF сервера." .
  end.
  
  v-out-data = get-string(mDataOut,1) .
  if v-out-data = ""
  then do :
    hSocket:disconnect() no-error.
    output to value (  v-log-file-name  ) append .
    put unformatted string(today) ' ' string(time, "HH:MM:SS") "  Не могу получить данные от IFSF сервера.  " skip .
    output close .
    return error "Не могу получить данные от IFSF сервера." .
  end.
  if index(v-out-data, "Bad Request") > 0
  then do :
    hSocket:disconnect() no-error.
    output to value (  v-log-file-name  ) append .
    put unformatted string(today) ' ' string(time, "HH:MM:SS") "  " v-out-data skip .
    output close .
    return error v-out-data .
  end.
  
  hSocket:disconnect() no-error.
  delete object hSocket.
  set-size(mDataIn) = 0.
  set-size(mDataOut)   = 0.
  
  output to value (  v-log-file-name  ) append .
  put unformatted string(today) ' ' string(time, "HH:MM:SS") "  Данные  " skip .
  put unformatted v-out-data skip .
  output close .
  
  do ii = 1 to num-entries(v-out-data, {&new-line}) :
    str = entry(ii, v-out-data, {&new-line}) .
    if index( str, "#" ) > 0
    then do:
      assign
        str = substring( str, 1, index( str, "#" ) - 1 )
      .
    end.
    if str = '':U then next .
    str1 = trim(entry(1, str, "=")) .
    str2 = trim(entry(2, str, "=")) .
    if can-do(StrFrFile-list, str1)
    then do :
      case str1 :
        when "tank"
        then do :
          find first tt-place where tt-place.loc1 = str2 no-error .
          if not available tt-place
          then do :
            create tt-place .
            assign tt-place.loc1 = str2 no-error .
            assign
              tt-place.t1             = ?
              tt-place.t2             = ?
              tt-place.t3             = ?
              tt-place.level-total    = ?   
              tt-place.level-water    = ?   
              tt-place.total-vol      = ? 
              tt-place.avrg-temp      = ?  
              tt-place.density        = ? 
              tt-place.mass           = ?
              tt-place.vapor-density  = ?
              tt-place.vapor-pressure = ?
            .
          end.
        end .
        when "level_total" then assign tt-place.level-total = decimal(str2) no-error .
        when "level_water" then assign tt-place.level-water = decimal(str2) no-error .
/*        when "level_oil" then assign tt-place.*/
        when "temperature" then assign tt-place.avrg-temp = decimal(str2) no-error .
        when "t1" then assign tt-place.t1 = decimal(str2) no-error .
        when "t2" then assign tt-place.t2 = decimal(str2) no-error .
        when "t3" then assign tt-place.t3 = decimal(str2) no-error .
        when "density" then assign tt-place.density = decimal(str2) no-error .
        when "volume_total" then assign tt-place.total-vol = decimal(str2) no-error .
        when "mass_total" then assign tt-place.mass = decimal(str2) no-error .
/*        when "volume_oil" then assign tt-place.*/
/*        when "volume_water" then assign tt-place.*/
        when "vapor_density" then assign tt-place.vapor-density = decimal(str2) no-error .
        when "vapor_pressure" then assign tt-place.vapor-pressure = decimal(str2) / 1000 no-error .
      end case .
    end .
  end .
  

end procedure .

procedure My-Rep:

define variable v-full-path-RepView as character no-undo.   /* Полный путь к файлу Просмотровщика (отчётов) */
define variable v-file-name-rep-htm as character no-undo.   /* Полный путь к файлу отчёта */
define variable g#report-num as integer no-undo.            /* Номер отчёта (получим стандартной процедурой ТН) */
define variable v-report-name as character no-undo.
define variable Lines_Counter as integer no-undo .

  run get-full-path-RepViewer(output v-full-path-RepView).    /* Перед работой с "Просмотровщиком отчёта" (main.exe) - убедимся, что он существует и получим полный путь к нему. */

  run get-report-num in parParentProc(output g#report-num).   /* Получим СТАНДАРТНЫМ МЕТОДОМ ТН номер файла отчёта. */

  run define-full-path-Report(input g#report-num, output v-file-name-rep-htm).   /* Сформируем стандартизованное в ТН имя файла отчёта. */

  run create-file(v-file-name-rep-htm).   /* Создадим на диске пустой файл со сформированным по стандарту именем файла. */


  run waitfram-show in this-procedure ("Подождите ...").
  

  Lines_Counter = 0 .

    
&scoped-define css_page1tit      text-align:center; font-weight:bold;
&scoped-define css_align_righit  text-align:right; padding-right:4px;
&scoped-define css_align_center  text-align:center;
&scoped-define css_table_border  border-style:solid; border-width:thin;
&scoped-define css_cell_border   border: 1px solid black; 
&scoped-define css_border_bottom border-bottom: 1px solid black;  

  output stream OutStr-html to value(v-file-name-rep-htm) convert target 'UTF-8' .
  
  
  /* Системная шапка HTML */
  put stream OutStr-html unformatted
  "<!DOCTYPE HTML>" skip
  ' <html>' skip
  '  <head>' skip
  '   <meta charset="utf-8">' skip
  '    <style type="text/css">' skip
  '      table ' + chr(123) + ' border-collapse: collapse; ' + chr(125) skip
  '      .class1 ' + chr(123) + ' border-collapse: collapse; ' + chr(125) skip
  '      tbody td, th ' + chr(123) + ' border-collapse: collapse; border: 1px solid black; height: 14px;' + chr(125) skip
  '   </style>' skip
  '  </head>' skip
  .
    
  put stream OutStr-html unformatted
    '<body>' skip
    '<TABLE name="1"  fit_to_page="true" orientation="portrait" CELLSPACING="0" BORDER="0">'skip
    '<thead>' skip
  .
  put stream OutStr-html unformatted
    '<tr>' skip
    '<td style="width: 60px;"></td>' skip
    '<td style="width: 60px;"></td>' skip
    '<td style="width: 120px;"></td>' skip
    '<td style="width: 60px;"></td>' skip
    '<td style="width: 60px;"></td>' skip
    '<td style="width: 60px;"></td>' skip
    '<td style="width: 60px;"></td>' skip
    '<td style="width: 60px;"></td>' skip
    '<td style="width: 60px;"></td>' skip
    '<td style="width: 60px;"></td>' skip
    '<td style="width: 60px;"></td>' skip
    '<td style="width: 60px;"></td>' skip
    '<td style="width: 60px;"></td>' skip
    '<td style="width: 60px;"></td>' skip
    '<td style="width: 60px;"></td>' skip
    '</tr>' skip
  .
                        
 
  put stream OutStr-html unformatted
    '<tr>' skip
    '<td colspan="15" style="text-align: center; font-weight:bold;">Оперативный отчет по показаниям АСИ</td>' skip
    '</tr>' skip   
    '<tr>' skip
    '<td colspan="7" style="text-align: left; font-weight:bold;">Дата: ' + string(date(now)) + '</td>' skip
    '</tr>' skip  
    '<tr>' skip
    '<td colspan="7" style="text-align: left; font-weight:bold;">Время: ' + string(time, 'HH:MM:SS') + '</td>' skip
    '</tr>' skip 
    '<tr>' skip
    '<td colspan="7" style="text-align: left; font-weight:bold;"><br></td>' skip
    '</tr>' skip
    '</thead>' skip
  .  
    
  put stream OutStr-html unformatted
      '     <tbody>' skip
      '       <tr>' skip
      '         <th style="text-align: center; font-weight:bold; background-color: silver; height: 50px">№ резервуара</th>' skip
      '         <th style="text-align: center; font-weight:bold; background-color: silver;">Код резервуара</th>' skip
      '         <th style="text-align: center; font-weight:bold; background-color: silver;">НАИМЕНОВАНИЕ ПРОДУКТА</th>' skip
      '         <th style="text-align: center; font-weight:bold; background-color: silver;">Код продукта</th>' skip
      '         <th style="text-align: center; font-weight:bold; background-color: silver;">Общий уровень (см)</th>' skip
      '         <th style="text-align: center; font-weight:bold; background-color: silver;">Уровень воды (см)</th>' skip
      '         <th style="text-align: center; font-weight:bold; background-color: silver;">Общий объем (л)</th>' skip
      '         <th style="text-align: center; font-weight:bold; background-color: silver;">Средняя Т (°С)</th>' skip
      '         <th style="text-align: center; font-weight:bold; background-color: silver;">Т1 (°С)</th>' skip
      '         <th style="text-align: center; font-weight:bold; background-color: silver;">Т2 (°С)</th>' skip
      '         <th style="text-align: center; font-weight:bold; background-color: silver;">Т3 (°С)</th>' skip
      '         <th style="text-align: center; font-weight:bold; background-color: silver;">Плотность (кг/л)</th>' skip
      '         <th style="text-align: center; font-weight:bold; background-color: silver;">Масса (кг)</th>' skip
      '         <th style="text-align: center; font-weight:bold; background-color: silver;">Плотность СУГ ПФ (кг/л)</th>' skip
      '         <th style="text-align: center; font-weight:bold; background-color: silver;">Давление СУГ (мПа)</th>' skip
      '       </tr>' skip
      '       <tr>' skip
      '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">1.1</th>' skip
      '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">1.2</th>' skip
      '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">1.3</th>' skip
      '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">1.4</th>' skip
      '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">1.5</th>' skip
      '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">1.6</th>' skip
      '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">1.7</th>' skip
      '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">1.8</th>' skip
      '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">1.9</th>' skip
      '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">1.10</th>' skip
      '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">1.11</th>' skip
      '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">1.12</th>' skip
      '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">1.13</th>' skip
      '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">1.14</th>' skip
      '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">1.15</th>' skip
      '       </tr>' skip
  . /* Точка для закрытия Put */
  
  for each tt-place no-lock :
    put stream OutStr-html unformatted
      '       <tr>' skip
      '         <th style="text-align: center;">' + tt-place.loc1 + '</th>' skip
      '         <th style="text-align: center;">' + (if tt-place.pl-code > 0 then string(tt-place.pl-code, ">>>>>>>>>>9") else " ") + '</th>' skip
      '         <th style="text-align: center;">' + tt-place.gds-name + '</th>' skip
      '         <th style="text-align: center;">' + (if tt-place.gds-code > 0 then string(tt-place.gds-code) else " ") + '</th>' skip
      '         <th style="text-align: center;">' + (if tt-place.level-total <> ? then string(tt-place.level-total, ">>>>>9.9<<") else " ") + '</th>' skip
      '         <th style="text-align: center;">' + (if tt-place.level-water <> ? then string(tt-place.level-water, ">>>>>9.9<<") else " ") + '</th>' skip
      '         <th style="text-align: center;">' + (if tt-place.total-vol <> ? then string(tt-place.total-vol,   ">>>>>9.9<<") else " ") + '</th>' skip
      '         <th style="text-align: center;">' + (if tt-place.avrg-temp <> ? then string(tt-place.avrg-temp,  "->>>>>9.9<<") else " ") + '</th>' skip
      '         <th style="text-align: center;">' + (if tt-place.t1 <> ? then string(tt-place.t1,  "->>>>>9.9<") else " ") + '</th>' skip
      '         <th style="text-align: center;">' + (if tt-place.t2 <> ? then string(tt-place.t2,  "->>>>>9.9<") else " ") + '</th>' skip
      '         <th style="text-align: center;">' + (if tt-place.t3 <> ? then string(tt-place.t3,  "->>>>>9.9<") else " ") + '</th>' skip
      '         <th style="text-align: center;">' + (if tt-place.density <> ? then string(tt-place.density,   ">>>>>>>>>9.9<<<<<<<<<") else " ") + '</th>' skip
      '         <th style="text-align: center;">' + (if tt-place.mass <> ? then string(tt-place.mass,        ">>>>>9.9<<") else " ") + '</th>' skip
      '         <th style="text-align: center;">' + (if tt-place.vapor-density <> ? then string(tt-place.vapor-density, ">>>>>>>>>9.9<<<<<<<<<") else " ") + '</th>' skip
      '         <th style="text-align: center;">' + (if tt-place.vapor-pressure <> ? then string(tt-place.vapor-pressure, ">>>>>9.99999") else " ") + '</th>' skip
      '       </tr>' skip
    . /* Точка для закрытия Put */
  end.
  
  put stream OutStr-html unformatted
                '     </tbody>' skip
                '   </table>' skip
                '  </body>' skip
                ' </html>' skip
 . /* Точка для закрытия Put */
  output stream OutStr-html close.

  output stream OutStr-html close.
  
  
  run prn-lib-reportviewer-report-name in this-procedure (
  input THIS-PROCEDURE
  ,input v-file-name-rep-htm
  ).


/* **************************************** */

end procedure. /* My-Rep */

procedure get-full-path-RepViewer:
/* Получение полного пути к exe-файлу просмотровщика отчётов */
    define output parameter p-fill-path-RepView as character no-undo.

    if search("exe\ReportViewer\reportviewer.exe") <> ? then
    do:
        p-fill-path-RepView = search("exe\ReportViewer\reportviewer.exe").
    end.
    else
    do:
        message "Не найдена программа просмотра отчёта!" view-as alert-box error.
    end.
end procedure.

procedure define-full-path-Report:
/* Получение полного пути к отчёту html */
    define input parameter p-rep-num as integer no-undo.
    define output parameter p-file-name-rep-htm as character no-undo.

    p-file-name-rep-htm = session:temp-directory + {&DF_Name} + string(p-rep-num) + ".html".

end procedure.

procedure search-full-path-Report:
/* Поиск файла */
    define input parameter p-file-name as character no-undo.

    if search(p-file-name) = ? then
        do:
            message "Не найден файл отчёта: " p-file-name view-as alert-box error.
        end.
    else
        do:
            p-file-name = search(p-file-name).
        end.

end procedure.

procedure Report-Viewer:
/* Запуск программы "Просмотровщик Отчётов" - ReportViewer. */
    define input parameter p-full-path-RepView as character no-undo.
    define input parameter p-file-name-rep-htm as character no-undo.

os-command no-wait value(p-full-path-RepView + " " + search(p-file-name-rep-htm)).

end procedure.

procedure create-file:
/* Создание пустого файла (во входном параметре: полный путь и имя файла) */
    define input parameter p-file-name as character no-undo.
    output to value(string(p-file-name)).
    output close.

end procedure.

                                                                                                                                                                                                       

function fnc-DD-MM-YYYY returns character 
(input p-dat-date as date):
/* Преобразование даты в формат: "01.01.2014" */

    define variable result as character no-undo.
    define variable p-str-date as character no-undo.

    p-str-date = replace(string(p-dat-date,'99.99.9999'), "/", ".").

        return p-str-date.

end function.

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
  ENABLE b-exit b-req b-print br-place v-status
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

PROCEDURE Sleep EXTERNAL "kernel32.DLL":
  DEFINE INPUT PARAMETER intMilliseconds AS LONG.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

