block-level on error undo, throw.
/*
File        : r-lmsts.p
$Revision:$
$Author:$
$Date:$
$Workfile:$
$Archive:$
Отчет о состоянии локального модуля Честный знак
Автор: Белова Марина Михайловна 
Дата создания: 24 сентября 2024 г.
Author:  Belova Marina 
Creation date: 24 september 2024 г.

*/
USING ibs.th.skt.ControlledClients.GisMtOffline.

DEFINE INPUT PARAMETER parparentproc    AS WIDGET-HANDLE NO-UNDO .
DEFINE INPUT PARAMETER p-parent-handle  AS WIDGET-HANDLE NO-UNDO .
DEFINE INPUT PARAMETER p-log-handle  AS HANDLE NO-UNDO .
DEFINE INPUT PARAMETER p-cre-db-num     AS INTEGER      NO-UNDO .
DEFINE INPUT PARAMETER p-task-type      AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER p-task-num       AS INTEGER      NO-UNDO.
DEFINE INPUT PARAMETER p-db-num         AS INTEGER      NO-UNDO .
 
DEFINE VARIABLE vss-revision    AS CHARACTER NO-UNDO INIT "$Revision:$":U .
DEFINE VARIABLE vss-author      AS CHARACTER NO-UNDO INIT "$Author:$":U .
DEFINE VARIABLE vss-date        AS CHARACTER NO-UNDO INIT "$Date:$":U .
DEFINE VARIABLE vss-workfile    AS CHARACTER NO-UNDO INIT "$Workfile:$":U .
DEFINE VARIABLE vss-archive     AS CHARACTER NO-UNDO INIT "$Archive:$":U .
DEFINE VARIABLE vss-description AS CHARACTER NO-UNDO INIT "Отчет о состоянии ЛМ ЧЗ - вызов по расписанию".
DEFINE VARIABLE mError AS LOGICAL NO-UNDO.
{ cmp/vssrevis.i }
{ utl/proc-async.i proc_def}
{ utl/search.i }
{ gbl/db-attr.i }   
{ cmp/trg-def.i }
{ adm/auto-def.i    }
{ ref/shd-attr.i    }
{ gbl/cur-time.i }

DEFINE VARIABLE v-dir-name  AS CHARACTER NO-UNDO .
DEFINE VARIABLE v-dir-type  AS CHARACTER NO-UNDO .
DEFINE VARIABLE v-can-read  AS LOGICAL   NO-UNDO .
DEFINE VARIABLE v-param-list    AS CHARACTER     NO-UNDO.
DEFINE VARIABLE v-param-type    AS CHARACTER     NO-UNDO.
DEFINE VARIABLE v-computer-tcp-name    AS CHARACTER NO-UNDO .
DEFINE VARIABLE v-computer-ip-addr     AS CHARACTER NO-UNDO .
DEFINE VARIABLE v-target    AS CHARACTER NO-UNDO .

DEFINE VARIABLE thGisMtOff AS CLASS GisMtOffline NO-UNDO .

DEFINE TEMP-TABLE ttreport-header NO-UNDO    
   XML-NODE-NAME "report-header"
   FIELD reqid        AS RECID SERIALIZE-HIDDEN
   FIELD f_datetime-tz     AS DATETIME-TZ XML-NODE-NAME "datetime-tz"
   FIELD report-name     AS CHAR
   FIELD report-label AS CHAR 
   FIELD report-db-num AS INT
   FIELD report-db-name AS CHAR
   FIELD report-db-hist AS CHAR
   INDEX reqidpar reqid 
   .   
  
 DEFINE TEMP-TABLE ttreplicationStatus NO-UNDO    
   XML-NODE-NAME "replicationStatus"
   FIELD reqid      AS RECID     SERIALIZE-HIDDEN           
   FIELD f_status   AS CHARACTER XML-NODE-NAME "status"
   FIELD f_version  AS CHARACTER XML-NODE-NAME "version"   
   FIELD lastUpdate AS CHARACTER 
   FIELD lastSync   AS CHARACTER 
   FIELD inst       AS CHARACTER 
   FIELD vers       AS CHARACTER XML-NODE-NAME "dbVersion"
   FIELD timeLag    AS CHARACTER
   FIELD onlineTime AS CHARACTER
   INDEX reqidpar reqid 
   .
   
 DEFINE DATASET gismt-report-body  XML-NODE-NAME "report-lmchzsts" FOR ttreport-header, ttreplicationStatus.      

DO
ON ERROR UNDO, RETURN ERROR RETURN-VALUE
:   
   &scop display-message    run write-log-and-file in p-log-handle (  ~
        input 1                                                      ~
      , input log-file-name                                          ~
      , input 1                                                      ~
      , input ~{&my-message~})


    ASSIGN
    log-file-name = "shd-free.log".

    RUN gbl/set-gbl.p
      (INPUT  TRUE
      ,INPUT  g#auto-user-id
      ,INPUT  g#auto-user-password
      ) NO-ERROR.
    IF ERROR-STATUS :ERROR
    THEN DO:
      DEF VAR v-err-str AS CHARACTER NO-UNDO.
      v-err-str = ERROR-STATUS:GET-MESSAGE(ERROR-STATUS:NUM-MESSAGES) + {&new-line} + RETURN-VALUE.
       
&scop my-message   substitute("!!!Ошибка при инициализации переменных g#... &1&2" ~
                                     , v-err-str ~
                                     , ~{&new-line~})

       {&display-message}.
                        
        RETURN.
    END.
    
    RUN schedule-attr-value IN this-procedure (
          INPUT p-cre-db-num
        , INPUT p-task-type
        , INPUT p-task-num
        , INPUT {&attr-schedule-param-list-h}
        , OUTPUT v-param-list
        , OUTPUT v-param-type
    ).
    IF v-param-list = "":U THEN DO:

&scop my-message   substitute("!!!Не заданы параметры отчета о состоянии ЛМ ЧЗ &1&2" ~
                                     , p-task-num        ~
                                     , ~{&new-line~})

       {&display-message}.
       RETURN.
    END.
    
    v-dir-name = v-param-list NO-ERROR.
    

    ASSIGN
    FILE-INFO:FILE-NAME = v-dir-name
    v-dir-type = FILE-INFO:FILE-TYPE
    .
    IF INDEX( v-dir-type, "D" ) = 0 THEN DO:
&scop my-message   substitute("!!!Выбранный для формирования отчета каталог &1 - недоступен&2" ~
                                     , v-dir-name ~
                                     , ~{&new-line~})

      {&display-message}.
      RETURN .
    END.
    /*
    run gbl/tcp-info.p
      (output v-computer-tcp-name
      ,output v-computer-ip-addr
      ) .
    */
    RUN CalcStatus (v-dir-name) NO-ERROR .
    IF ERROR-STATUS:ERROR THEN DO:
&scop my-message   substitute("!!!Ошибка при формировании отчета&3&1&3&2&3" ~
                                     , return-value ~
                                     , error-status:get-message(1) ~
                                     , ~{&new-line~})

      {&display-message}.
    END.
    ELSE DO:
&scop my-message   substitute("!!!Формирование отчета о состоянии ЛМ ЧЗ завершено.&1" ~
                                     , ~{&new-line~})

      {&display-message}.
    END.
END.

DELETE OBJECT thGisMtOff NO-ERROR.  
{ utl/proc-async.i proc_end}

PROCEDURE CalcStatus:
    DEFINE INPUT PARAM iDirName AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE vStatus   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE v-version AS CHARACTER NO-UNDO.
    DEFINE VARIABLE vTimeLag  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE vOnlineTimeD AS DECIMAL NO-UNDO.
    DEFINE VARIABLE vOnlineTime AS INT64    NO-UNDO.
    DEFINE VARIABLE vTimeBegErr AS DATETIME-TZ NO-UNDO.
    DEFINE VARIABLE vlastUpdate AS CHARACTER NO-UNDO.
    DEFINE VARIABLE vLastSync   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE vInst       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE vdbVersion  AS CHARACTER NO-UNDO.
    
    DEFINE BUFFER buf_code FOR ub.code.

    thGisMtOff =  NEW GisMtOffline() NO-ERROR.           
    vStatus = thGisMtOff:GetChkStsOffline(OUTPUT v-version, 
                                          OUTPUT vTimeLag, 
                                          OUTPUT vlastUpdate, 
                                          OUTPUT vLastSync, 
                                          OUTPUT vInst, 
                                          OUTPUT vdbVersion) NO-ERROR.
    
    /* Проверяем, зафиксирован ли сбой онлайн-проверки */    
    FIND FIRST buf_code WHERE buf_code.parent EQ "GisMt"
           AND buf_code.code   EQ "GisMtErr"
       NO-LOCK NO-WAIT NO-ERROR.
    /* если ошибка уже была, смотрим сколько прошло времени */   
    IF AVAILABLE buf_code            
       AND buf_code.codevalue > "" 
    THEN DO:
       vTimeBegErr = DATETIME-TZ(buf_code.codevalue) NO-ERROR.
       IF vTimeBegErr <> ? THEN DO:
          vOnlineTimeD = (NOW - vTimeBegErr) / 3600000.
          vOnlineTime = ROUND(vOnlineTimeD,0).
          if vOnlineTime < vOnlineTimeD then vOnlineTime = vOnlineTime + 1.
       END.   
       ELSE vOnlineTime = 0.    
    END.
    ELSE vOnlineTime = 0.
       
    RUN Put2Xml (iDirName, 
                 vStatus, 
                 v-version, 
                 vTimeLag, 
                 STRING(vOnlineTime),
                 vlastUpdate, 
                 vLastSync, 
                 vInst, 
                 vdbVersion) NO-ERROR.  
      
END PROCEDURE.

PROCEDURE Put2Xml:
    DEFINE INPUT PARAM iDirName AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER iStatus AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER iVersion AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER iTimeLag AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER iOnlineTime AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER vlastUpdate AS CHARACTER NO-UNDO. 
    DEFINE INPUT PARAMETER vLastSync AS CHARACTER NO-UNDO. 
    DEFINE INPUT PARAMETER vInst AS CHARACTER NO-UNDO. 
    DEFINE INPUT PARAMETER vdbVersion AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE vFileResult AS CHARACTER NO-UNDO.
    DEFINE VARIABLE vFileName AS CHARACTER NO-UNDO.
    DEFINE VARIABLE vRetOk AS LOGICAL NO-UNDO.       
    DEFINE VARIABLE vWorkDir AS CHARACTER NO-UNDO.
    DEFINE VARIABLE v-obj-name AS CHARACTER NO-UNDO.
    DEFINE VARIABLE v-db-num AS INTEGER NO-UNDO.
        
    DEFINE VARIABLE v-par-type  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE v-hist-code AS CHARACTER NO-UNDO.
    DEFINE VARIABLE v-hist-name AS CHARACTER NO-UNDO.
                    
    DEFINE BUFFER buf_sys-ctrl FOR ub.sys-ctrl .
    DEFINE BUFFER buf_clients FOR ub.clients .
     
     FIND FIRST buf_sys-ctrl NO-LOCK NO-ERROR.
     IF AVAILABLE buf_sys-ctrl AND buf_sys-ctrl.db-num <> 0 
     THEN DO:
         FIND FIRST buf_clients NO-LOCK WHERE 
                   buf_clients.db-num = buf_sys-ctrl.db-num NO-ERROR.
         IF AVAIL buf_clients 
         THEN ASSIGN
                v-obj-name = buf_clients.obj-name 
                v-db-num  = buf_sys-ctrl.db-num
                .
     END.    
    RUN db-attr-value(INPUT v-db-num,INPUT {&attr-hist-code},OUTPUT v-hist-code ,OUTPUT v-par-type) .  
    RUN db-attr-value(INPUT v-db-num,INPUT {&attr-hist-name},OUTPUT v-hist-name ,OUTPUT v-par-type) .              

    vWorkDir = iDirName.
    vFileName = "LmChz-" + string(TODAY,"99-99-9999") 
                  + "_" + string(v-db-num). 
           
    RUN GenFileName (vWorkDir, vFileName, OUTPUT vfileresult).        
    
    if vfileresult = "" then return error "Не удалось инициализировать имя файла.".
                      
    CREATE ttreport-header.
    ASSIGN
       ttreport-header.reqid = 1
       ttreport-header.f_datetime-tz  = NOW
       ttreport-header.report-name    = "lmchzsts"
       ttreport-header.report-label   = "Отчет о состоянии ЛМЧЗ"
       ttreport-header.report-db-num  = v-db-num
       ttreport-header.report-db-name = v-obj-name /*if v-hist-name = "" then v-obj-name else v-hist-name*/
       ttreport-header.report-db-hist = v-hist-code
       .
        
    CREATE ttreplicationStatus.
    ASSIGN 
       ttreplicationStatus.reqid      = 1
       ttreplicationStatus.f_status   = iStatus 
       ttreplicationStatus.f_version  = iVersion
       ttreplicationStatus.timeLag    = iTimeLag
       ttreplicationStatus.onlineTime = iOnlineTime
       ttreplicationStatus.lastUpdate = vlastUpdate    
       ttreplicationStatus.lastSync   = vLastSync
       ttreplicationStatus.inst       = vInst                
       ttreplicationStatus.vers       = vdbVersion      
       .
    vRetOk = DATASET gismt-report-body:WRITE-XML("FILE":U, vfileresult, TRUE, "windows-1251", ?, FALSE, TRUE ,FALSE,TRUE ) no-error.
    
END PROCEDURE.    

PROCEDURE GenFileName:
  DEFINE INPUT PARAM iWorkDir      AS CHAR NO-UNDO.
  DEFINE INPUT PARAM iFileNameBase AS CHAR NO-UNDO.  
  DEFINE OUTPUT PARAM oFileNameGen AS CHAR NO-UNDO.  
    
  DEFINE VARIABLE v-name        AS CHARACTER NO-UNDO .
  DEFINE VARIABLE v-check-name  AS CHARACTER NO-UNDO .
  DEFINE VARIABLE vNum AS INTEGER NO-UNDO.  
  DEFINE VARIABLE vExtension  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE vDirDelim   AS CHARACTER NO-UNDO INIT "\":u.
    
  ASSIGN
    vNum = 0         
    vExtension = '.':u + "xml"
    oFileNameGen = ""
    .
  
  v-check-name = "something". 

  DO WHILE v-check-name <> ? and vNum < 99:
    /* число из не более чем 2 цифр */
    ASSIGN
      vNum = vNum + 1
    .
            
    ASSIGN
      v-name = iWorkDir + vDirDelim + iFileNameBase + "-" + string(vNum,"99":U) + vExtension
    .
    
    ASSIGN
      v-check-name = SEARCH(v-name)
    .
  END.
  if v-check-name = ? 
  then oFileNameGen = v-name.
  
END PROCEDURE.    
