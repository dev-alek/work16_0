 
 /*------------------------------------------------------------------------
    File        : GisMtOffline
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : BelovaMM
    Created     : 05.09.2024
    Notes       : 
  ----------------------------------------------------------------------*/
using Progress.Lang.*.
using ibs.th.skt.Commands.*.
using ibs.th.skt.Adapters.LogWrite.
using ibs.th.gbl.propmap.
using ibs.th.gbl.sys.objsrv.
using ibs.th.gbl.sys.objth.
using Progress.Lang.*.

class ibs.th.skt.ControlledClients.GisMtOffline inherits objth : 
     
  define override public property vss-revision    as character no-undo init "$Revision:$":U get .
  define override public property vss-author      as character no-undo init "$Author:$":U get.
  define override public property vss-date        as character no-undo init "$Date:$":U get.
  define override public property vss-workfile    as character no-undo init "$Workfile:$":U get.
  define override public property vss-archive     as character no-undo init "$Archive:$":U get.
  define override public property vss-description as character no-undo init "Работа с офлайн модулем ГИС МТ" get.
  
  define temp-table ttstatus-body  no-undo /*serialize-name  "bodys" */
  xml-node-name "body"
   field f_version    as char XML-NODE-NAME "version"
   field f_status     as char XML-NODE-NAME "status"
   field requiresDownload as log 
   field operationMode as char
   field name as char 
   field lastSync as int64
   field inst as char 
   field reqid        as recid serialize-hidden
   index reqidpar reqid 
   .
   
  define temp-table ttstatus no-undo    
   xml-node-name "replicationstatus"
   field reqid        as recid serialize-hidden
   field cis     as char 
   field blocked_series     as char
   field blocked_gtin as char 
   field blocked_cis as char 
   index reqidpar reqid 
   .   
  
    define temp-table ttcis no-undo    
   xml-node-name "cis"
   field s-reqid        as recid serialize-hidden           
   field timeLag as char 
   field serverDocCount as char
   field localDocCount as char
   index reqidpar s-reqid 
   .
   
   define temp-table ttblocked_series no-undo    
   xml-node-name "blocked_series"
   field s-reqid        as recid serialize-hidden           
   field timeLag as char 
   field serverDocCount as char
   field localDocCount as char
   index reqidpar s-reqid 
   .   
   define temp-table ttblocked_gtin no-undo    
   xml-node-name "blocked_gtin"
   field s-reqid        as recid serialize-hidden           
   field timeLag as char 
   field serverDocCount as char
   field localDocCount as char
   index reqidpar s-reqid 
   .   
   define temp-table ttblocked_cis no-undo    
   xml-node-name "blocked_cis"
   field s-reqid        as recid serialize-hidden           
   field timeLag as char 
   field serverDocCount as char
   field localDocCount as char
   index reqidpar s-reqid 
   . 

  define dataset gismt-mark-body  xml-node-name "bodys" for ttstatus-body, ttstatus, ttcis, ttblocked_series, ttblocked_gtin, ttblocked_cis 
  data-relation gismt-mark-cis for ttstatus-body, ttstatus relation-fields (reqid,reqid) nested
 .

  define stream out_data.
    
       /*------------------------------------------------------------------------------
        Purpose:
        Notes:
       ------------------------------------------------------------------------------*/
       /*define public property hpApi as handle no-undo 
       get.
       private set.*/
       
  { cmp/str-glbl.i class }
  { utl/search.i  class }
  { ibs/th/skt/controlledclients/gismtprop.i def}   
   
   method public character GetParam ():     
     define variable vRetProp as character no-undo.    
     
     define buffer buf_sys-ctrl for ub.sys-ctrl .
     
     find first buf_sys-ctrl no-lock no-error.
     if available buf_sys-ctrl and buf_sys-ctrl.db-num <> 0 
     then do:
         vRetProp = get-gismt-prop ({&db},
                                    buf_sys-ctrl.db-num) no-error.
     end.                                 
          
     return "".
   end method.   
   
   /* Запрос статуса ЛМ ЧЗ из сокета */  
   method public void ChkStsOffline ():       
       RunChkStsAndInit(yes, yes).
       EmptyTempTable().
   end method.
   
   /* Запрос статуса ЛМ ЧЗ из отчета */  
   method public character GetChkStsOffline (
       output oVersion as character,
       output oTimeLag as character):
           
       define variable vStatus as character no-undo.
       define variable vTimeLag as int64 no-undo.
              
       vTimeLag = 0.
       
       RunChkStsAndInit(no, no).
       
       find first ttstatus-body no-error.
       if avail ttstatus-body  
       then do:
           assign
             vStatus = ttstatus-body.f_status
             oVersion = ttstatus-body.f_version
             .
           vTimeLag  = Round(GetMaxTime() / 3600000, 0) no-error.
       end.              
       else
          assign 
             vStatus = "Нет связи с ЛМ ЧЗ"
             oVersion = "Не определена"
             .   
       if vTimeLag <> 0 and vTimeLag <> ? 
       then oTimeLag = string(vTimeLag).
       else oTimeLag = "не определено".
       
       EmptyTempTable().
       
       return vStatus.
   end method.
       
   /* Запрос статуса ЛМ ЧЗ */  
   method public void RunChkStsAndInit (
     iStartInit as log, 
     iWriteLog as log
     ):
                    
     define variable vTimeStart   as datetime-tz no-undo.       
     define variable vlongJson    as longchar no-undo.
     define variable hDS          as handle no-undo.
     define variable vRetOk       as logical no-undo.    
     define variable cmd          as character   no-undo.
     define variable vFileResult  as character   no-undo.
     define variable vFileResJson as character   no-undo.
     define variable vFileResXml  as character   no-undo.
     define variable vFileErr     as character   no-undo.
     define variable vParam       as character no-undo.  
     define variable vReqSts      as logical no-undo.
                           
     vParam = GetParam().          
     
     assign
        vlongJson = ""
        vTimeStart = now
        vReqSts = no
        .
     EmptyTempTable().
     
     run gbl/_tmpfile.p ( "StsOffGisMTRes", ".txt", output vFileResult ) .
     run gbl/_tmpfile.p ( "StsOffGisMTErr", ".txt", output vFileErr ) .
     run gbl/_tmpfile.p ( "StsOffGisMTResJson", ".json", output vFileResJson ) .
     run gbl/_tmpfile.p ( "StsOffGisMTResXml", ".xml", output vFileResXml ) .     

     do transaction 
     on error undo, return error:                                                              
         cmd = substitute ('&1 --connect-timeout &6 --max-time &6 -X GET -H "Accept: application/json" -H &2 &3 >&4 --stderr &5',
                          search ("exe/curl.exe"), /*1*/                                                                  
                          quoter("Authorization: Basic " + gismt-OflineAutoriz), /*2*/
                          quoter(gismt-OflineAdress + "/status"), /*3*/
                          vFileResult,             /*4*/                      
                          vFileErr,          /*5*/                      
                          trim(replace(string(gismt-WaitTime, "zzzz9.99999"),".",","),"")).         /*6*/
                          
         os-command silent value(cmd).                 
                           
         if searchFile(vfileresult) <> ? then do:
            file-info:file-name = searchFile(vfileresult).
            
            if file-info:file-size <> 0 then do:
               copy-lob from file vFileResult to vlongJson no-error.          
               vlongJson = '~{"bodys":[' + vlongJson + "]}" .
               cmd = substitute ('&1 -file=&2 >&3',
                                      search("exe/json2xml.exe"),
                                      vFileResult,
                                      vFileResXml).                          
               os-command silent value (cmd).  
               copy-lob from file vFileResXml to vlongJson no-error.    
               vRetOk = dataset gismt-mark-body:read-xml("FILE":U, vFileResXml, "EMPTY":U, ?, ?) no-error.

               find first ttstatus-body no-error.
               if avail ttstatus-body  and 
                  ttstatus-body.f_status = "not_configured" and
                  iStartInit 
               then do:
                  /* Запуск инициализации */                  
                  RunInitOffline() no-error.
                  vReqSts = yes.
               end.    
            end.    
         end. 
     end.     
     if iWriteLog then WriteLogOffLine(vlongJson, vReqSts) no-error.
     if not session:debug-alert
     then do:         
         os-delete silent value(vFileResult)     no-error.
         os-delete silent value(vFileErr)        no-error.
         os-delete silent value(vFileResJson)     no-error.
         os-delete silent value(vFileResXml)     no-error.             
     end.
         
   end method.
    
    /* Запуск инициализации модуля ЛМ ЧЗ */     
   method public void RunInitOffline():          
        define variable vlongJson as longchar no-undo.
        define variable hDS as handle no-undo.
        define variable vRetOk as logical no-undo.    
        define variable vCdnAdr as character no-undo.
        define variable cmd as character   no-undo.
        define variable vFileResult    as character   no-undo.
        define variable vFileErr as character   no-undo.   
        define variable vFileResJson    as character   no-undo.
        define variable vTimeCur as datetime-tz no-undo.
        def var vReqTime as int64 no-undo.
        define variable vFlagOk as log no-undo.
        define variable vTokenFile as char no-undo.
            
        assign
           vlongJson = ""
           vFlagOk = no
           .
                    
        run gbl/_tmpfile.p ( "InitOfflineGisMTRes", ".txt", output vFileResult ) .
        run gbl/_tmpfile.p ( "InitOfflineGisMTErr", ".txt", output vFileErr ) .
        run gbl/_tmpfile.p ( "InitOfflineToken", ".txt", output vTokenFile ) .
        
        OUTPUT STREAM out_data TO value(vTokenFile).        
        PUT STREAM out_data UNFORMATTED  
          '~{"token":"' gismt-RegKey '"~}' .
        OUTPUT STREAM out_data CLOSE.
    
        cmd = substitute ('&1 --connect-timeout &6 --max-time &6 -X POST -H "Accept: application/json" -H &2 --data @&7 &3 >&4 --stderr &5',
                          search ("exe/curl.exe"), /*1*/                                                                  
                          quoter("Authorization: Basic " + gismt-OflineAutoriz), /*2*/
                          quoter(gismt-OflineAdress + "/init"), /*3*/
                          vFileResult,             /*4*/                      
                          vFileErr,          /*5*/                      
                          trim(replace(string(gismt-WaitTime, "zzzz9.99999"),".",","),""),         /*6*/
                          searchfile(vTokenFile)
                          ). /*7*/                        
                                                                              
         os-command silent value(cmd).                                    
                        
         if searchFile(vfileresult) <> ? then do:
            file-info:file-name = searchFile(vfileresult).
            if file-info:file-size = 0 then vFlagOk = yes.
         end.
                  
         if not session:debug-alert
         then do:         
             os-delete silent value(vFileResult)     no-error.
             os-delete silent value(vFileErr)        no-error.
             os-delete silent value(vFileResJson)     no-error.             
         end.
   end method.   
   
   /* Запись лога */   
   method  private void WriteLogOffLine
       (iResultJson as longchar,
        iFlagOk as logical):
                       
        define variable vFileName as character no-undo.
        define variable vCh as character no-undo.
        define variable vFullCh as character no-undo.
        define variable vWork as character no-undo.
        define variable vNum as integer no-undo.
        define variable vStrLong as longchar no-undo.        
        define variable vStatus as character no-undo.        
        define variable vTimeLag as int64 no-undo.
        
        vFileName = "GisMtOffLine-" + replace(string(today),"/","-") +  ".log".
        
        /* ищем каталог запуска */
        assign
           vWork = ""
           vCh = "param.txt"
           .
        vFullCh = searchfile(vCh).
        if vFullCh <> ? and vFullCh <> ""
        then vNum = index(vFullCh,"\pid_").
        if vNum <> 0 then vWork = substring(vFullCh, 1, vNum).
        vFileName =  vWork + vFileName.
        
        find first ttstatus-body 
           no-lock no-error.
        if avail ttstatus-body then 
        do:   
           vTimeLag = GetMaxTime().                                    
           vStatus =  substitute("Статус модуля ЛМ ЧЗ:&1&2&1Время синхронизации:&1&3",
                                 chr(9),
                                 ttstatus-body.f_status,
                                 (if vTimeLag > 0 then string(now - vTimeLag) else " не определено")).           
        end.
        else vStatus =  "Ошибка получения статуса ЛМ ЧЗ".                     
        
        if iResultJson = "" then vStatus = "Не получен ответ от ЛМ ЧЗ.".   
           
        vCh = "". /* что бы в новый лог писал с первой строки, а в имеющийся - со следующей */
        if searchfile(vFileName) <> ?
        then do:
           file-info:file-name = searchfile(vFileName).
           if file-info:file-size <> 0 then vCh = " ".
        end.
        
        /* формируем лог файл */                
        OUTPUT STREAM out_data TO value(vFileName) APPEND.
        PUT STREAM out_data UNFORMATTED 
          vCh skip now chr(9) vStatus skip .
        OUTPUT STREAM out_data CLOSE.        
        
        copy-lob from iResultJson to file vFileName append no-error.
        
        if iFlagOk then do:
            OUTPUT STREAM out_data TO value(vFileName) APPEND.
            PUT STREAM out_data UNFORMATTED 
              skip "Запущена инициализация модуля ЛМ ЧЗ".
            OUTPUT STREAM out_data CLOSE.            
        end.    
                                                     
   end method.    
   
   method  private int64 GetMaxTime():
       define variable vTimeLag as int64 no-undo.
       define variable vTimeTT as int64 no-undo.
       
       vTimeLag = 0.
       find first ttblocked_series no-error.
       if avail ttblocked_series
            and ttblocked_series.timeLag <> "unknown" 
       then do: 
          vTimeTT = Int64(ttblocked_series.timeLag) no-error.
          if not error-status:error and
             vTimeTT > vTimeLag
          then vTimeLag = vTimeTT.            
       end. 
       find first ttblocked_gtin no-error.
       if avail ttblocked_gtin 
            and ttblocked_gtin.timeLag <> "unknown"
       then do: 
          vTimeTT = Int64(ttblocked_gtin.timeLag) no-error.
          if not error-status:error and
             vTimeTT > vTimeLag     
          then vTimeLag = vTimeTT.       
       end.       
       find first ttblocked_cis no-error.
       if avail ttblocked_cis 
            and ttblocked_cis.timeLag <> "unknown"
       then do: 
          vTimeTT = Int64(ttblocked_cis.timeLag) no-error.
          if not error-status:error and
             vTimeTT > vTimeLag     
          then vTimeLag = vTimeTT.       
       end.
       return vTimeLag.     
   end method.   
   
   method  private void EmptyTempTable ():       
      empty temp-table ttstatus-body.
      empty temp-table ttstatus.
      empty temp-table ttblocked_series.
      empty temp-table ttblocked_gtin.
      empty temp-table ttblocked_cis.      
   end method.
     
   constructor public GisMtOffline (  ):
      super ().      
   end constructor.

   destructor public GisMtOffline ( ):

   end destructor.

end class.