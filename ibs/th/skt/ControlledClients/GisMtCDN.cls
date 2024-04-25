 
 /*------------------------------------------------------------------------
    File        : GisMtCDN
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : BelovaMM
    Created     : 29.03.2024
    Notes       : 
  ----------------------------------------------------------------------*/
using Progress.Lang.*.
using ibs.th.skt.Commands.*.
using ibs.th.skt.Adapters.LogWrite.
using ibs.th.gbl.propmap.
using ibs.th.gbl.sys.objsrv.
using ibs.th.gbl.sys.objth.
using Progress.Lang.*.

class ibs.th.skt.ControlledClients.GisMtCDN inherits objth : 
     
  define override public property vss-revision    as character no-undo init "$Revision:$":U get .
  define override public property vss-author      as character no-undo init "$Author:$":U get.
  define override public property vss-date        as character no-undo init "$Date:$":U get.
  define override public property vss-workfile    as character no-undo init "$Workfile:$":U get.
  define override public property vss-archive     as character no-undo init "$Archive:$":U get.
  define override public property vss-description as character no-undo init "Работа с CDN площадками ГИС МТ" get.
  
  define temp-table tthosts-body  no-undo serialize-name  "bodys" 
   field code            as int
   field description     as char
   field avgTimeMs       as int 
   .
  define temp-table tthosts no-undo    
   SERIALIZE-NAME "hosts"        
   field reqid        as recid serialize-hidden
   field host_adr     as char SERIALIZE-NAME "host"
   index reqidpar reqid host_adr
   .   
     
  define temp-table tthosts-adr  no-undo serialize-name  "bodys" 
   field code            as int
   field description     as char
   field avgTimeMs       as int 
   .
   
  define dataset gismt-host-body SERIALIZE-HIDDEN  for tthosts-body, tthosts
     PARENT-ID-RELATION FOR tthosts-body, tthosts PARENT-ID-FIELD reqid .
    
  define dataset gismt-host-adr SERIALIZE-HIDDEN  for tthosts-adr .
    
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
   
  method public character GetParamProxy ():
     define variable vParamProxy as character no-undo.
     define variable vRetProp as character no-undo.    
     
     define buffer buf_sys-ctrl for ub.sys-ctrl .
     
     find first buf_sys-ctrl no-lock no-error.
     if available buf_sys-ctrl and buf_sys-ctrl.db-num <> 0 
     then do:
         vRetProp = get-gismt-prop ({&db},
                                    buf_sys-ctrl.db-num) no-error.
     end.                                 
     if gismt-AdressPort <> "" and gismt-ProxyLogin <> "" and gismt-ProxyPswd <> "" 
        then vParamProxy = substitute ('-x &1 -U &2:&3',gismt-AdressPort,gismt-ProxyLogin,gismt-ProxyPswd).
     else if gismt-AdressPort <> "" then vParamProxy = substitute ('-x &1',gismt-AdressPort).
     else vParamProxy = "".
     return vParamProxy.
  end method.   
     
   method public void GetListCdn ():
     def variable vTimeStart as datetime-tz no-undo.       
     define variable vlongJson as longchar no-undo.
     define variable hDS as handle no-undo.
     define variable vRetOk as logical no-undo.    
     define variable vCdnAdr as character no-undo.
     define variable cmd as character   no-undo.
     define variable vFileResult    as character   no-undo.
     define variable vFileResJson    as character   no-undo.
     define variable vFileErr as character   no-undo.
     define variable vParamProxy as character no-undo.          
     
     
     /* Проверяем, что сейчас обновления нет */
     vRetOk = CheckCdnUpd ().
     if not vRetOk then return.              
          
     /*run PutMesAsunc (substitute ("Начало обновления площадок &1" , vTimeStart)).*/
     
     vParamProxy = GetParamProxy().
     vlongJson = "".
     vTimeStart = now.
     for each tthosts-body:
         delete tthosts-body.
     end.
     
     for each tthosts:
         delete tthosts.
     end. 
      /*
     /* проверяем сколько времени прошло с предыдущего обновления */
     vRetOk = CheckCdnUpdTime(vTimeStart).
     if not vRetOk then return.     
     */
     do transaction 
     on error undo, return error:
         /* установка параметра начала опроса площадок */          
         vRetOk = SetCdnUpd(vTimeStart).
    
         run gbl/_tmpfile.p ( "CdnListGisMTRes", ".txt", output vFileResult ) .
         run gbl/_tmpfile.p ( "CdnListGisMTErr", ".txt", output vFileErr ) .
         run gbl/_tmpfile.p ( "CdnListGisMTRes", ".json", output vFileResJson ) .
                          
         cmd = substitute ('&1 --connect-timeout &8 --max-time &8 &7 -X GET &3 -H "Content-Type: application/json" -H &4 &5 >&2 --stderr &6',
                          search ("exe/curl.exe"), /*1*/
                          vFileResult,             /*2*/
                          quoter(gismt-cdnAdress),       /*3*/                      
                          quoter("X-api-Key: " + gismt-RegKey), /*4*/
                          vParamProxy,           /*5*/
                          vFileErr,              /*6*/
                          gismt-DopParam,        /*7*/
                          trim(replace(string(gismt-WaitTime, "zzzz9.99999"),".",","),"")). /*8*/
                          
         /*run PutMesAsunc (substitute ("Запрос списка площадок &1" , cmd)).*/
                              
         os-command silent value(cmd).                 
                           
         if searchFile(vfileresult) <> ? then do:
            file-info:file-name = searchFile(vfileresult).
            if file-info:file-size <> 0 then do:
                /*run PutMesAsunc (substitute ("Разбираем файл &1" , vfileresult)).*/
                copy-lob from file vFileResult to vlongJson no-error.          
                
                vlongJson = '~{"bodys":[' + vlongJson + "]}" .
                hDS = dataset gismt-host-body:handle.
                          
                vRetOk  = hDS:read-json("longchar":U, vlongJson) no-error.  
                /*run PutMesAsunc (substitute ("Список площадок vRetOk &1 num-err &2 err-mes &3" , vRetOk, error-status:NUM-MESSAGES, error-status:get-message(1))).*/
                
                dataset gismt-host-body:write-json("FILE":U, vFileResJson) no-error.            
                
                find first tthosts-body no-error.
                if avail tthosts-body  and tthosts-body.code = 0 then 
                do:
                    /*run PutMesAsunc (substitute ("code &1" , tthosts-body.code)).
                    run PutMesAsunc (substitute ("description &1" , tthosts-body.description)).
                    run PutMesAsunc (substitute ("avgTimeMs &1" , tthosts-body.avgTimeMs)).*/
                    for each tthosts:
                       /*run PutMesAsunc (substitute ("host_adr &1" , tthosts.host_adr)).*/
                       /* Запуск опроса площадок и обновления */
                       ReqHost(tthosts.host_adr, vParamProxy, vTimeStart).                              
                    end.
                end.    
            end.    
         end.
         /* удаляем плохие площадки, или скидываем блокировку */     
         DelOldCdn(vTimeStart).
     end.     
     /*run PutMesAsunc (substitute ("Окончания обновления площадок &1 заняло времени (мс) &2" , now, now - vTimeStart)).*/
   end method.
    
    /* проверка площадок и сохранение в БД */     
   method public void ReqHost
       (iHostAdr as char, 
        iParamProxy as char,
        iTimeStart as datetime-tz):  
        
        def var vHostAdress as char no-undo.
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
            
        vHostAdress = iHostAdr + "/api/v4/true-api/cdn/health/check".
        vlongJson = "".
        vFlagOk = no.
        for each tthosts-adr:
            delete tthosts-adr.
        end.
            
        run gbl/_tmpfile.p ( "CdnGisMTRes", ".txt", output vFileResult ) .
        run gbl/_tmpfile.p ( "CdnGisMTErr", ".txt", output vFileErr ) .
        run gbl/_tmpfile.p ( "CdnListGisMTRes", ".json", output vFileResJson ) .
        
        cmd = substitute ('&1  --connect-timeout &8 --max-time &8 &7 -X GET &3 -H "Content-Type: application/json" -H &4 &5 >&2 --stderr &6',
                          search ("exe/curl.exe"), /*1*/
                          vFileResult,             /*2*/
                          quoter(vHostAdress),       /*3*/                      
                          quoter("X-api-Key: " + gismt-RegKey), /*4*/
                          iParamProxy,           /*5*/
                          vFileErr,              /*6*/
                          gismt-DopParam,        /*7*/
                          trim(replace(string(gismt-WaitTime, "zzzz9.99999"),".",","),"")). /*8*/
                          
         /*run PutMesAsunc (substitute ("Запрос состояния площадки &1" , cmd)).*/
         
         vTimeCur = now.                          
         os-command silent value(cmd).                 
         vReqTime = now -  vTimeCur.  
                        
         if searchFile(vfileresult) <> ? then do:
            file-info:file-name = searchFile(vfileresult).
            if file-info:file-size <> 0 then do:
                /*run PutMesAsunc (substitute ("Разбираем файл &1" , vfileresult)).*/
                copy-lob from file vFileResult to vlongJson no-error.          
                
                vlongJson = '~{"bodys":[' + vlongJson + "]}" .
                hDS = dataset gismt-host-adr:handle.
                          
                vRetOk  = hDS:read-json("longchar":U, vlongJson) no-error.
                /*run PutMesAsunc (substitute ("Площадка &1 vRetOk &2 num-err &3 err-mess &4" , 
                iHostAdr, vRetOk, error-status:NUM-MESSAGES, error-status:get-message(1))).    */          
                
                dataset gismt-host-adr:write-json("FILE":U, vFileResJson) no-error.            
    
                find first tthosts-adr no-error.
                if avail tthosts-adr  and 
                   tthosts-adr.code = 0 then 
                do:
                    UpdCdNAdr(iHostAdr, iTimeStart, vReqTime, tthosts-adr.avgTimeMs).
                    vFlagOk = yes.
                    /*run PutMesAsunc (substitute ("code &1" , tthosts-adr.code)).
                    run PutMesAsunc (substitute ("description &1" , tthosts-adr.description)).
                    run PutMesAsunc (substitute ("avgTimeMs &1" , tthosts-adr.avgTimeMs)).*/                
                end.    
            end.    
         end.
         /* если не удалось получить ответ */
         if not vFlagOk 
         then do:
            vReqTime = 5 * 3600 * 1000. /* устанавливаем адресу время ответа 5 минут */
            UpdCdNAdr(iHostAdr, iTimeStart, vReqTime, -1).
         end.   
   end method.   
   
   /* проверка, что обновление cdn-площадок не запущено */
   method public logical CheckCdnUpd ():
       def buffer buf_code for ub.code.
       def var vCheck as logical no-undo.
       
       find first buf_code where 
                  buf_code.parent = "CDN_GisMt" 
              and buf_code.code = "CDN_Upd"              
           no-lock no-error.
       if not avail buf_code then vCheck = yes.
       
       return vCheck.   
   end method.
   
   /* проверка, сколько времени прошло с последнего обновления */
   method public logical CheckCdnUpdTime (iTimeStart as datetime-tz):
      def buffer buf_code for ub.code.
      def var vCheck as logical no-undo.
      def var vTimeUpd as datetime-tz no-undo.
      
      vCheck = no.
        
      find first buf_code where 
                 buf_code.parent = "CDN_GisMt"
         no-lock no-error.
      if avail buf_code then vTimeUpd = datetime-tz(buf_code.misc1) no-error.
      if (not avail buf_code) or 
         vTimeUpd = ? or 
         (vTimeUpd <> ? and     
          datetime-tz(vTimeUpd) < iTimeStart and
          (iTimeStart - datetime-tz(vTimeUpd)) >= gismt-cdnTimeUpd * 3600 * 1000)
      then vCheck = yes.
      
      return vCheck.    
   end.
      
   /* Установка флага, что запущено обновление cdn-площадок */
   method public logical SetCdnUpd (iTimeStart as datetime-tz):
       def buffer buf_code for ub.code.
       def var vCheck as logical no-undo.
       
       find first buf_code where 
                  buf_code.parent = "CDN_GisMt" 
              and buf_code.code = "CDN_Upd"              
           no-lock no-error.
       if not avail buf_code then do:
           create buf_code.
           assign
              buf_code.parent = "CDN_GisMt" 
              buf_code.code = "CDN_Upd"
              buf_code.codename = "Запущен процесс обновления площадок ГИС МТ"
              buf_code.codeval = string(iTimeStart)   
              .
           vCheck = yes.
       end.   
       
       return vCheck.   
   end method.
   
   method public void DelCdnUpd (iTimeStart as datetime-tz):
       def buffer buf_code for ub.code.       
       
       find first buf_code where 
                  buf_code.parent = "CDN_GisMt" 
              and buf_code.code = "CDN_Upd" 
              and buf_code.codeval = string(iTimeStart)             
           exclusive-lock no-wait no-error.
       if avail buf_code then do:
           delete buf_code.
       end.           
          
   end method.
    
     
   method public void UpdCdNAdr
       (iCdnAdr as char,
        iTimeStart as datetime-tz,
        iReqTime as int64,
        iavgTimeMs as int):
                
        def buffer buf_code for ub.code.
                    
        WriteLogCdn(iCdnAdr,
                    iTimeStart,
                    iReqTime).     
          
        find first buf_code where 
                   buf_code.parent = "CDN_GisMt" 
               and buf_code.code = iCdnAdr
           exclusive-lock no-wait no-error.
        if not avail buf_code then do:
          if locked buf_code then do:
                /*run PutMesAsunc (substitute ("Площадка &1 заблокирована для изменения. Не удалось обновить данные." , iCdnAdr)).*/
          end.    
          else do:
             create buf_code.
             assign
                buf_code.parent = "CDN_GisMt" 
                buf_code.code = iCdnAdr
                buf_code.codename = "Адрес площадки ГИС МТ"
                .
          end.   
        end.            
        if avail buf_code then  do:
           assign
             buf_code.codeval = string(iReqTime)                            
             buf_code.misc1 = String(iTimeStart)
             buf_code.misc2 = ""
             .  
        end.   
        
   end method.   
    
   method public void DelOldCdn
        (iTimeStart as datetime-tz):
            
        def buffer buf_code for ub.code. 
        
        /* если обновляли площадки, то старые удаляем */
        if can-find(first buf_code no-lock where 
                     buf_code.parent = "CDN_GisMt"              
                 and buf_code.misc1 = String(iTimeStart)
                 ) then
        do:              
            for each buf_code where 
                         buf_code.parent = "CDN_GisMt"              
                     exclusive-lock :
               if  buf_code.misc1 <> String(iTimeStart) then
               do:
                   delete buf_code. 
               end.           
            end.
        end.  
        /* иначе сбрасываем блокировки */ 
        else do:
            for each buf_code where 
                         buf_code.parent = "CDN_GisMt"              
                     exclusive-lock :
               buf_code.misc2 = "".           
            end.
            /* удаляем признак, что работает обновление площадок */
            DelCdnUpd(iTimeStart).
        end.              
   end method.
   
   method  private void WriteLogCdn
       (iCdnAdr as char,
        iTimeStart as datetime-tz,
        iReqTime as int64):
            
        define variable vFileName as character no-undo.
        define variable vCh as character no-undo.
        define variable vFullCh as character no-undo.
        define variable vWork as character no-undo.
        define variable vNum as int no-undo.
        define variable vStrLong as longchar no-undo.
        
        vFileName = "GisMtCDN-" + replace(string(today),"/","-") +  ".log".
        
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
        
        vStrLong = substitute("&1~t&2~t&3~n",iTimeStart,iCdnAdr,iReqTime).
        
        copy-lob from object vStrLong to file vFileName append no-error.

   end method.    
      
     
   constructor public GisMtCDN (  ):
      super ().
      /*run gbl\getwindows.p(output hpApi).*/
   end constructor.

   destructor public GisMtCDN ( ):

   end destructor.

end class.