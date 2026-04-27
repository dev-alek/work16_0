/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$



Автор: Морозов Александр Сергеевич
Дата создания: 01/30/15
Author: Alexandr Morozov
Creation date: 01/30/15

*/

using ibs.th.skt.*.
using ibs.th.skt.Commands.*.
using ibs.th.skt.ControlledClients.*.
using ibs.th.skt.Adapters.*.
block-level on error undo, throw.

class ibs.th.skt.Commands.TSDCommand inherits ICommandProc: 
  define override public property vss-revision    as character no-undo init "$Revision:$":U get .
  define override public property vss-author      as character no-undo init "$Author:$":U get.
  define override public property vss-date        as character no-undo init "$Date:$":U get.
  define override public property vss-workfile    as character no-undo init "$Workfile:$":U get.
  define override public property vss-archive     as character no-undo init "$Archive:$":U get.
  define override public property vss-description as character no-undo init "Обработка запросов в сокет по ТСД" get.
  
   /*------------------------------------------------------------------------------
    Purpose:
    Notes:
   ------------------------------------------------------------------------------*/
   define variable is-ProcArch64 as logical  no-undo init no.  
   
  { cmp/str-glbl.i class}  
  { ibs/th/skt/ControlledClients/TSDTT.i}
  &scop CRLF chr(13) + chr(10)
  &scop HdEnd chr(13) + chr(10) + chr(13) + chr(10)
  
  define public property ErrStatus as logical no-undo 
    get.
    private set.
  
  define private variable tsd         as class     TSD no-undo.
  define private variable fileSend         as class     FileSend no-undo.
  define private variable i           as integer   no-undo.
  define private variable userId_     as character no-undo.
  define private variable sn          as character no-undo.
  define private variable hndlSocket  as handle    no-undo.
  define private variable millisec    as integer   no-undo.
  
/*  define private variable isDocMarkOn as logical   no-undo.*/
  
    /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  define variable HTTPError as longchar no-undo.
    
  constructor public TSDCommand (iFileSend as class fileSend):
    
    super ().
    fileSend = iFileSend. 
    define variable tempStr       as char     no-undo.
    HTTPError = substitute("HTTP/1.1 500 Internal Server Error&1Server: 4GL&1Content-Type: text/html&1ETag: &3&4&2",
                         chr(13) + chr(10),
                         chr(13) + chr(10) + chr(13) + chr(10) , 
                         "&1",
                         "&2").
    os-command silent value( 'set processor_Architecture >procarch') .
    if search ("procarch") = ? 
    then do:
      logWrite:WriteFileToLog ( "Не найден файл с данными PROCESSOR_ARCHITECTURE, проверьте настройки propath - должен быть указан путь рабочий директории").
      ErrStatus = true.
      return.
    end.    

    input from value (search('procarch')) no-convert.
    import tempStr.
    if not index ("PROCESSOR_ARCHITEW6432=AMD64", tempStr) = 0
      then assign is-ProcArch64 = true.
    input close.
    tsd = new tsd().
    
  end constructor.
  define variable mEmptyConstr as logical no-undo.
  constructor public TSDCommand ():
      this-object(new fileSend()).
      mEmptyConstr = yes.
  end.
  
  method private void startStep(msg as char):
    logWrite:WriteDebugLog(msg).
  end.
  
  method private void endStep(msg as char):
     logWrite:WriteDebugLog(msg).
  end.
  define private property mServiceBusy as logical no-undo
  get.
  set (arg as logical):
      mServiceBusy = arg.
      if arg
      then
         logWrite:WriteDebugLog("Загрузка с другого устройтва заблокирована").
      else
         logWrite:WriteDebugLog("Загрузка с другого устройтва разблокирована").
       
  end.
  method public void Execute_( input req as IRequest, resp as class IResponse, list-par as char ):
    ErrStatus = false.
    define variable mbuffer       as memptr   no-undo.
    define variable mbuffer1      as memptr   no-undo.
    define variable tempLongCh    as longchar no-undo.
    define variable glog          as logical  no-undo.
    define variable vMesForTsd as character no-undo. 
    if mServiceBusy
    then do:
       vMesForTsd = "При обмене возникли ошибки. Уже выполняется одна задание получения данных".
       logWrite:LogStr = vMesForTsd.
              
       ErrStatus = true.
       return.
    end.
     do on error undo, leave:
       define variable vOk as logical no-undo.
       mServiceBusy = yes.
       os-delete value (search ("MT_documentsSend.txt")) no-error.
       os-delete value (search ("MT_lineSend.txt")) no-error.
       os-delete value (search ("MT_MarkLinesSend.txt")) no-error.  
       
       startStep('Начало выгрузка из базы ТСД').
             
       define variable vobjtype as character no-undo.
       logWrite:LogStr = "".
       if    get-size(req:ContentBuff) eq 0
          or get-size(req:ContentBuff) eq ?
       then
          os-delete value (search ("documents_tsd.s3db")).
       else 
          copy-lob
             from  object req:ContentBuff
             to file "documents.s3db"
             no-convert
          no-error .
       if session:debug-alert
       then do:
          os-delete value (search ("documents_tsd.s3db")) no-error.
          if    get-size(req:ContentBuff) ne 0
            and get-size(req:ContentBuff) ne ?
          then
          copy-lob
             from  object req:ContentBuff
             to file "documents_tsd.s3db"
             no-convert
          no-error .
       end.
       vobjtype = entry (1, list-par, "?").
       if vobjtype eq "" or vobjtype eq ?
       then do:
         vMesForTsd = "Не задан тип объекта".
         logWrite:WriteFileToLog ( vMesForTsd).
         return.
       end.
       else if vobjtype eq "shop"
       then  
          vobjtype = {&Shop}.
       else if vobjtype eq "stock"
       then  
          vobjtype = {&stock}.
       else if vobjtype eq "cmp"
       then  
          vobjtype = {&cmp}.
       tsd:ObjCode = integer (entry (2, list-par, "?")) no-error.
       if error-status:error
       then do:
         vMesForTsd  = "Не задан код объекта".
         logWrite:WriteFileToLog ( vMesForTsd).
         return.
       end.
       assign    
       
       tsd:ObjType = vobjtype
       tsd:ReqType = entry (3, list-par, "?")
       tsd:CurrDecSeparator = entry (4, list-par, "?")
       tsd:IsMarkOn = if entry (5, list-par, "?") = "true" then true else false
       no-error.
       define variable vProt as character no-undo.
       vProt = req:HeadHTTP:getValue("TSD-protocol").
       if vProt > ""
       then do:
          define variable vfileDbInit as character no-undo.
          vfileDbInit = "exe/DBInit_" + replace (vProt,".","_") +  ".exe".
          if (search(vfileDbInit)) eq ?
          then do:
             vMesForTsd = "Не найден файл " + vfileDbInit + " для версии протокола " + vProt.
             
             return error . 
             
          end. 
          else
             os-copy value(search(vfileDbInit)) value ("DBInit.exe").
          logWrite:WriteDebugLog("Используем " + vfileDbInit).
       
       end.
       else do:
          os-copy value(search("exe/DBInit_0.exe"))   value ("DBInit.exe").       
          logWrite:WriteDebugLog("Используем exe/DBInit_0.exe" ).
       end.  
       
       if is-ProcArch64 
       then do:
         os-copy value(search("exe/x64/System.Data.SQLite.dll")) value ("System.Data.SQLite.dll").
       end.
       else do:
         os-copy value(search("exe/x86/System.Data.SQLite.dll")) value ("System.Data.SQLite.dll").
       end.    
       define variable vpid as integer no-undo.
       vpid = runProc('DBInit.exe ExpDoc 30 31 >DBInitExpDoc.txt').
       
       resp:condition = resp:STSlist:WriteStatusAndWait:NameProp.
       resp:ParamWait = substitute ("pid,&1,status,Step1", vpid).
       vOk = true.
       finally:
         if (vOk ne true)
         then do:
            
            if (vMesForTsd > "")
            then do:
               writeSockError (req:HndlSocket, vMesForTsd).
            end.
            ErrStatus = true.
            mServiceBusy = no.
         end.        
       end finally.
    end.
  end method.
  
  method override public void ContinueExecution( input req as IRequest, input resp as IResponse ):
    ErrStatus = false.
    define variable tempLongCh    as longchar no-undo.
    define variable mbuffer       as memptr   no-undo.
    define variable mbuffer1      as memptr   no-undo.
    define variable glog          as logical  no-undo.
    define variable vsize as int64 no-undo.
    define variable vi as integer no-undo.
      
    hndlsocket = req:HndlSocket.
    
    define variable vPos as integer no-undo.
    define variable vPid as integer no-undo.
    vpos = lookup("pid",resp:ParamWait).
    vpid = int64(entry(vpos + 1,resp:ParamWait)).
    if IsProcessRunning(vpid) > 0
    then
       return. /* ждем завершения процеса */
    define variable vStatus as character no-undo.
    vpos    = lookup("status",resp:ParamWait).
    vStatus = entry(vpos + 1,resp:ParamWait).
    if vStatus eq "dictionaries"
    then do:
       mServiceBusy = no.
       logWrite:WriteFileToLog("DBInitDict.txt","IBM866").
       block-size:
       do vi = 1 to 50:
         file-info:file-name = "dictionaries_new.s3db".
         vsize = file-info:file-size. 
         run gbl/pause.p( 1000). /* Пауза для того чтобы файл успел дозаписаться иначе размер определяется не правильно*/
         if     vsize ne ?
            and vsize eq file-info:file-size
         then
            leave block-size.
      end.
       if vsize eq ? or vsize eq 0 
       then do:
          logWrite:WriteFileToLog ( substitute ("Не найден файл &1 базы данных, для отсылки на TSD, проверьте настройки propath - должен быть указан путь рабочий директории",ifileName)).
          ErrStatus = true.
          return.
       end.
       assign
         file-info:file-name = "dictionaries_new.s3db"
       .
        
       filesend:sendfile(resp, file-info:file-name).
       
       
    end.
    else if vStatus eq "step1"
    then do transaction:
       if not hndlSocket:connected()
       then do:
          resp:condition = resp:STSlist:WriteResponse:NameProp.
          mServiceBusy = no.
          return.
       end.
       logWrite:WriteFileToLog("DBInitExpDoc.txt","IBM866").
       run gbl/pause.p( 1000).
       endStep('Завершена выгрузка из базы ТСД').
       startStep('Начало загрузки документов.').
       if not parseCSV()
       then do:
          resp:condition = resp:STSlist:ReciveCommand:NameProp.
          mServiceBusy = no.
          return.
       end.
       endStep('Завершена загрузки документов.').
       startStep('Начало выгрузки накладных.').
       tsd:clear().
       tsd:getWB().
       endStep('Завершена выгрузка накладных').
       startStep('Начало выгрузки ЭДО.').
       tsd:getUTDDoc(req:HeadHTTP:getValue("TSD-protocol")).
       endStep('Завершена выгрузка ЭДО').
       tsd:docPrint().
       tsd:docLinePrint().
       tsd:docLineMarkPrint().
       startStep('Начало загрузки документов в ТСД.').
       os-delete "documents_new.s3db".
       if not hndlSocket:connected()
       then do:
          resp:condition = resp:STSlist:WriteResponse:NameProp.
          mServiceBusy = no.
          return.
       end.
    
       vpid = runProc('DBInit.exe Doc 30 31 >DBInitDoc.txt'  + {&new-line} + 'rename documents.s3db documents_new.s3db').
       resp:condition = resp:STSlist:WriteStatusAndWait:NameProp.
       resp:ParamWait = substitute ("pid,&1,status,Step2", vpid).
       catch exAppErrors as class Progress.Lang.AppError :
            mServiceBusy = no.
            undo ,throw exAppErrors.
         end catch .
         catch exProErrors as class Progress.Lang.ProError :
            mServiceBusy = no.
            undo ,throw exProErrors.
         end catch .
         catch exAnyErrors as class Progress.Lang.Error:
            mServiceBusy = no.
            undo ,throw exAnyErrors.
         end catch .
    end.
    else if vStatus eq "step2"
    then do on error undo, leave:
      logWrite:WriteFileToLog("DBInitDoc.txt").
      endStep('Завершена загрузка документов в ТСД.').
      if not hndlSocket:connected()
       then do:
          resp:condition = resp:STSlist:WriteResponse:NameProp.
          return.
       end.
    
      resp:condition = resp:STSlist:ReciveCommand:NameProp.
      block-size:
      do vi = 1 to 50:
         file-info:file-name = "documents_new.s3db".
         vsize = file-info:file-size. 
         run gbl/pause.p( 1000). /* Пауза для того чтобы файл успел дозаписаться иначе размер определяется не правильно*/
         if     vsize ne ?
            and vsize eq file-info:file-size
         then
            leave block-size.
      end.
      if vsize eq ? or vsize eq 0
      then do:
         set-size (mbuffer1) = 0.
         logWrite:WriteFileToLog("DBInitDoc.txt","IBM866").
         logWrite:LogStr = "Не удалость произвести выгрузку".
      end.
      else do:
         filesend:sendfile(resp, file-info:file-name).
         return.
      end.
      writeSockError (req:HndlSocket, substitute("&1 &2", "При обмене возникли ошибки.",logWrite:LogStr)).
      finally:
         mServiceBusy = no.
      end.
    end.
  end.
  
  method private int64 dumpDistric(iprotocol as char):
     define variable tempStr       as char     no-undo.
     define variable vMesForTsd as character no-undo.
     if mServiceBusy
     then do:
       vMesForTsd = "При обмене возникли ошибки. Уже выполняется одна задание получения данных".
       logWrite:LogStr = vMesForTsd.
              
       ErrStatus = true.
       return error.
     end.
      os-delete "dictionaries.s3db".
      os-delete "dictionaries_new.s3db".
      startStep("Начало конвертации справочника.").
      if iprotocol > ""
      then do:
         define variable vfileDbInit as character no-undo.
         vfileDbInit = "exe/DBInit_" + replace (iprotocol,".","_") +  ".exe".
         if (search(vfileDbInit)) eq ?
         then do:
             vMesForTsd = "Не найден файл " + vfileDbInit + " для версии протокола " + iprotocol.
             writeSockError (hndlsocket, vMesForTsd).
             logWrite:LogStr = vMesForTsd.
             ErrStatus = true.
             return error . 
             
          end. 
          os-copy value(search(vfileDbInit)) value ("DBInit.exe").
          logWrite:WriteDebugLog("Используем " + vfileDbInit).
  
      end.
      else do:
         os-copy value(search("exe/DBInit_0.exe"))   value ("DBInit.exe").       
         logWrite:WriteDebugLog("Используем exe/DBInit_0.exe").
  
      end.
      if is-ProcArch64 
      then do:
         os-copy value(search("exe/x64/System.Data.SQLite.dll")) value ("System.Data.SQLite.dll").
      end.
      else do:
         os-copy value(search("exe/x86/System.Data.SQLite.dll")) value ("System.Data.SQLite.dll").
      end.    
    
      return runProc( 'DBInit.exe Dict 30 31 >DBInitDict.txt' + {&new-line} + 'rename dictionaries.s3db dictionaries_new.s3db') .
       
       
   end.
   
    define variable mType    as character no-undo.
    define variable mVersion as character no-undo.
    define variable mObjType as character no-undo .
    define variable mObjCode as character no-undo .
    define variable mSN      as character no-undo .
  method public override void Execute_( input req as IRequest, resp as class IResponse ):
  ErrStatus = false.
  do transaction:
    define variable contLength as integer   no-undo.
    define variable strLog     as character no-undo.
    define variable str        as character no-undo.
    define buffer buf_bar-code  for ub.bar-code.
    define buffer buf_prod-bc   for ub.prod-bc.
    define buffer buf_place     for ub.place.
    define buffer bfTempDocLine for TempDocLine.
    
    if req:HeadHTTP:queryAdr eq "tsd/doc"
    then do:
       Execute_ (req,resp,req:HeadHTTP:userAgent).
       return.
    end.
    define variable hRoot       as handle    no-undo.
    define variable hDoc        as handle    no-undo.
  
    create x-document hDoc.
    hDoc:encoding = "utf-8".
    hDoc:load("longchar",req:Content,no).
    tsd:CP = hDoc:encoding.
    if hDoc:encoding <> "windows-" + session:charset then
    do:
      req:convertContentInCharset(hDoc:encoding).
      delete object hDoc.
      create x-document hDoc.
      hDoc:load("longchar",req:Content,no).
    end.
    hDoc:encoding = if session:charset begins "12" then "windows-" + session:charset else session:charset.
    create x-noderef  hRoot.
    hDoc:get-document-element(hRoot) .
    assign
      tsd:ObjCode = integer (substring (hRoot:get-attribute("to"), 4))
      tsd:ObjType = substring (hRoot:get-attribute("to"), 1, 3)
      tsd:ReqType = hRoot:get-attribute("item")
      tsd:ResType = hRoot:get-attribute("responseType")
      tsd:CurrDecSeparator = hRoot:get-attribute("currDecSeparator")
      tsd:IsMarkOn = if hRoot:get-attribute("MarksReg") = "true" then true else false
      .
      if tsd:ResType eq "xml"
      then do:
         resp:Content-Type = "text/xml; charset=" + tsd:CP.
         
      end.
      else if tsd:ResType eq "json"
      then
       resp:Content-Type = "application/json; charset=" + tsd:CP.  
       
    hndlsocket = req:HndlSocket.
    case tsd:ReqType :
        when "SETTINGS" then 
        do:
          parseXML(hRoot).
          tsd:Check_().
          tsd:ResType = "xml".
          resp:Content-Type = "text/xml; charset=" + tsd:CP.
        end.
        when "getSETTINGS" then 
        do:
          parseXML(hRoot).
          tsd:getSETTINGS().
          tsd:ResType = "xml".
          resp:Content-Type = "text/xml; charset=" + tsd:CP.
        end.
        when "getListVersions" then 
        do:
          parseXML(hRoot).
          tsd:getListVersions().
          tsd:ResType = "xml".
          resp:Content-Type = "text/xml; charset=" + tsd:CP.
        end.
      when "getVersion" then 
        do:
          parseXML(hRoot).
          define variable vfile as character no-undo.
          vfile = tsd:getFileVersion(mType, mVersion).
          if vfile ne ?
          then do:
             logWrite:WriteFileToLog (substitute ("Подготавливаем файл &1 к отправке ",vfile)).
             filesend:sendfile(resp, vfile).
             return.
          end.
          else do:
             tsd:SomeStr = tsd:getStatusXml(false, substitute ("Нет файла для устройства '&1' и версии '&2'", mType, mVersion)).
             tsd:ResType = "xml".
             resp:Content-Type = "text/xml" + (if tsd:cp ne "windows-1251" then "; charset=" + tsd:CP else "").
      
          end.
        end.
      when "TH_ALL" then 
        do:
          tsd:usersClear().
          startStep('Начало кеширования справочника пользователей.').
          tsd:WriteUsers().
          endStep('Завершено кеширование справочника пользователей.').
          startStep('Начало кеширования справочника объектов.').
          tsd:objectsClear().
          tsd:WriteObjects().
          endStep('Завершено кеширование справочника объектов.').
          startStep('Начало кеширования справочника контрагентов.').          
          tsd:WriteClients().
          endStep('Завершено кеширование справочника контрагентов.').
          startStep('Начало кеширования справочника товаров и штрих-кодов.').
          tsd:getGoodsAndBarcodes(req:HeadHTTP:getValue("TSD-protocol"),vdir).
          endStep('Завершено кеширование справочника товаров и штрих-кодов.').
          str = 'dictionaries'.
          define variable vpid as integer no-undo.
          vpid = dumpDistric(req:HeadHTTP:getValue("TSD-protocol")).
          resp:condition = resp:STSlist:WriteStatusAndWait:NameProp.
          resp:ParamWait = substitute ("pid,&1,status,&2", vpid, str). 
        end.
      when "TH_WB" then 
        do:
          tsd:docClear().
          startStep('Начало кеширования документов.').
          tsd:GetWB().
          tsd:getUTDDoc(req:HeadHTTP:getValue("TSD-protocol")).
          endStep('Завершено кеширование документов.').
          tsd:docWrite().
        end.
      when "TH_users" then 
        do:
          tsd:usersClear(). 
          tsd:GetUsers ().
          tsd:UsersPrint(tsd:ResType).
        end.
      when "TH_objects" then 
        do:
          tsd:objectsClear().
          tsd:getObjects().
          tsd:ObjectsPrint(tsd:ResType).
        end.
      when "TH_clients" then 
        do:
          tsd:ClientsClear ().
          tsd:getClients().
          tsd:ClientsPrint(tsd:ResType).
        end.
      when "TH_goods" then  
        do:
          tsd:GoodsClear().
          tsd:getGoods().
          tsd:GoodsPrint(tsd:ResType).
        end.
      when "TH_barcodes" then 
        do:
          tsd:BarcodesClear().
          tsd:getBarcodes(req:HeadHTTP:getValue("TSD-protocol")).
          tsd:BarcodesPrint(tsd:ResType).
          
        end.
     when "TH_goodsAndBarcodes" then 
        do:
          tsd:GoodsAndBarcodesClear().
          tsd:getGoodsAndBarcodes(yes, yes, req:HeadHTTP:getValue("TSD-protocol")).
          tsd:GoodsAndBarcodesPrint(tsd:ResType,?).
          
        end.
      when "WAYBILL" then 
        do:
          parseXML(hRoot).

          for each TempDocLine no-lock where not TempDocLine.b-code matches ("*" + string (TempDocLine.gds-code) + "*"):
                      
            find first bfTempDocLine where bfTempDocLine.gds-code = TempDocLine.gds-code and bfTempDocLine.b-code matches ( "*" + string (bfTempDocLine.gds-code) + "*")  no-error.
            find buf_bar-code where 
              buf_bar-code.gds-code = TempDocLine.gds-code and TempDocLine.b-code matches ("*" + string(buf_bar-code.b-code)+ "*") no-error.
            
            
            if not available buf_bar-code then do:
              
              find first buf_prod-bc where buf_prod-bc.b-str = TempDocLine.b-code no-error.
              if available buf_prod-bc 
              then do:
                find first buf_bar-code where buf_bar-code.b-code = buf_prod-bc.b-code and buf_bar-code.gds-code = TempDocLine.gds-code no-error.
              end.
              
              if not available buf_bar-code then do:
                logWrite:LogStr = 'Отправлен ответ на запрос типа "WAYBILL".' + {&new-line} + "Не известный штрих-код:" + TempDocLine.b-code.
                logWrite:WriteFileToLog( "Не известный штрих-код:" + TempDocLine.b-code).
                writeSockError(HndlSocket, "Не известный штрих-код:" + TempDocLine.b-code).
              end.
              
            end.

            if not available bfTempDocLine
            then do:
              create bfTempDocLine.
              assign
                bfTempDocLine.gds-code = TempDocLine.gds-code
                bfTempDocLine.b-code = string (TempDocLine.gds-code)
              .
            end.
            
            assign
              bfTempDocLine.doc-qnty  = bfTempDocLine.doc-qnty + TempDocLine.doc-qnty * buf_bar-code.cli-base-rate
              bfTempDocLine.fact-qnty = bfTempDocLine.fact-qnty + TempDocLine.fact-qnty * buf_bar-code.cli-base-rate
              bfTempDocLine.RowSum    = bfTempDocLine.RowSum + TempDocLine.RowSum
              .
            delete TempDocLine.
          
          end.
          
          for each TempDocLine no-lock:
            assign
              TempDocLine.price-rubl = TempDocLine.RowSum / TempDocLine.fact-qnty.
              .
            
          end.
          
          if tsd:ImpWB(table TempTrnDoc, table TempDocLine, table TempMarkLine, userId_)
            then ErrStatus = false.
            else ErrStatus = true.
          
        end.
      when "INVENTORY" then 
        do:

          parseXML(hRoot).

          if tsd:ImpInventory (table TempTrnDoc, table TempDocLine, userId_)
            then ErrStatus = false.
            else ErrStatus = true.

        end.
      otherwise 
      do:
        tsd:WriteUnknown().
        tsd:ResType = "xml".
        resp:Content-Type = "text/xml; charset=" + tsd:CP.
        
      end.
    end.
/*    tsd:CodePageConvert().*/

    case tsd:ReqType :
      when "SETTINGS" then 
        do:
          logWrite:WriteFileToLog ( 'Отправлен ответ на запрос типа "SETTINGS".' + {&new-line} + logWrite:LogStr).
        end.
      when "TH_ALL" then 
        do:
          logWrite:LogStr = 'Отправлен ответ на запрос типа "TH_ALL".' + {&new-line} + logWrite:LogStr.
        end.
      when "TH_WB" then 
        do:
          logWrite:WriteFileToLog ('Отправлен ответ на запрос типа "TH_WB".' + {&new-line} + logWrite:LogStr).
        end.
      when "WAYBILL" then 
        do:
          logWrite:WriteFileToLog ( 'Отправлен ответ на запрос типа "WAYBILL".' + {&new-line} + logWrite:LogStr).
        end.
      when "INVENTORY" then 
        do:
          logWrite:WriteFileToLog ( 'Отправлен ответ на запрос типа "INVENTORY".' + {&new-line} + logWrite:LogStr).
        end.
        
    end case.
    mSN = req:HeadHTTP:getValue("TSD-serial").
    mVersion = req:HeadHTTP:getValue("TSD-version").
    if mSN <> "" and mSN ne ? then do:
    find first ub.Code exclusive-lock where ub.Code.code = mSN and ub.Code.parent = "TSDversion" no-error .
    if not available (ub.Code) then do:
        create ub.Code .
        assign
        ub.Code.code = mSN
        ub.Code.parent = "TSDversion"
        .
    end.
    if mVersion <> "" then ub.Code.misc1 = mVersion .
    if mObjCode <> "" then ub.Code.misc2 = mObjCode .
    if mObjType <> "" then ub.Code.misc3 = mObjType .
    ub.Code.misc4 = string(now,"99/99/9999 HH:MM:SS") .
    end.

    if ErrStatus then 
    do:
      writeSock(resp,"").
      if ErrStatus = true then undo.
    end.
    else do:
      if     resp:condition ne resp:STSlist:WriteStatusAndWait:NameProp
         and resp:condition ne resp:STSlist:WaitResult:NameProp
      then do:
      if tsd:ResType eq "xml" or tsd:ResType eq "json" 
      then do:
         resp:condition = resp:STSlist:WriteResponse:NameProp.
         resp:ConvertPage = tsd:CP.
         resp:setContent(tsd:SomeStr). 
      end.
      else do:
         writeSock(resp,tsd:SomeStr).
         if ErrStatus = true then undo.
      end.
      end.
    end.
    finally:
        delete object hDoc no-error.
        delete object hRoot no-error.
    end.
  end /*trans*/.
    
  end method.

  
  method private logical parseCSV(  ):
    
    define variable lResult    as logical   no-undo.
    define variable cFactQnty  as character no-undo.
    define variable cDocQnty   as character no-undo.
    define variable cPriceRubl as character no-undo.
    define variable RowSum     as decimal   no-undo.
    define variable iDbNum     as integer   no-undo.
    define variable docType    as character no-undo.
    define variable vFilename  as character no-undo.
    define buffer buf_bar-code  for ub.bar-code.
    define buffer buf_prod-bc   for ub.prod-bc.
    define buffer buf_place     for ub.place.
    define buffer bfTempDocLine for TempDocLine.
    define variable myflagsDoc     as class flagsdoc     no-undo.
    
    myflagsDoc = new flagsdoc ().

    iDbNum = tsd:GetDbNum().
    empty temp-table TempTrnDocMT.
    empty temp-table TempTrnLineMT.
    empty temp-table TempMarkLineMT.
    vFilename = "MT_documentsSend.txt".
    if SearchFile(vFilename) ne ? 
    then do:
       input from value(SearchFile(vFilename)) convert source "UTF-8". 
       repeat:  
         create TempTrnDocMT.
         import TempTrnDocMT no-error.
       end. 
       input close.
    end.

    vFilename = "MT_lineSend.txt".
    if SearchFile(vFilename) ne ?
    then do:
       input from value(SearchFile(vFilename)) convert source "UTF-8".
       repeat:  
         create TempTrnLineMT.
         import TempTrnLineMT no-error.
         if TempTrnLineMT.goodsid = 0 then TempTrnLineMT.NotDict = true .
         else TempTrnLineMT.NotDict = false .
       end. 
       input close.
    end.
 
    vFilename = "MT_MarkLinesSend.txt".
    if SearchFile(vFilename) ne ?
    then do:
       input from value(SearchFile(vFilename)) convert source "UTF-8".
       repeat:  
         create TempMarkLineMT.
         import TempMarkLineMT no-error.
       end. 
       input close.
    end.
    for each TempTrnDocMT where TempTrnDocMT.Complete_ = true:
      logWrite:WriteDebugLog("Загружаем документ " + TempTrnDocMT.DocName).
      empty temp-table TempTrnDoc.
      empty temp-table TempDocLine.
      empty temp-table TempMarkLine.

      case TempTrnDocMT.DocType:
        when "ExtSalesWB" then do:
          docType = {&TDEDT_Ras_Vnesh}.
        end.
        when "IntSalesWB" then do:
          docType = {&TDEDT_Ras_Perem}.
        end.
        when "ExtPurchWB" then do:
          docType = {&TDEDT_Pri_Vnesh}.
        end.
        when "IntPurchWB" then do:
          docType = {&TDEDT_Pri_Perem}.
        end.
        when "Inv" then do:
          docType = {&TDEDT_Inv}.
        end.
        when "Introduce" then do:
          docType = "UTD_Introduce".
        end.
        when "UTD" then do:
          docType = "UTD_DOC".
        end.
        when "InvMarks" then do:
          docType = "invmark".
        end.
        when "MarksInv" then do:
          docType = "MarksInv".
        end.
        when "InvIntroduce" then do:
          docType = "InvIntroduce".
        end.
      end case.
        
      userId_ = TempTrnDocMT.UserID_.

      find first ub.user-login where ub.user-login.db-num = iDbNum and ub.user-login.user-id = userId_ no-lock no-error.  
      create TempTrnDoc.
      assign
        TempTrnDoc.line-num     = 1
        TempTrnDoc.doc-date     = today
        TempTrnDoc.ext-doc-code = TempTrnDocMT.DocName
        TempTrnDoc.ext-doc-type = docType 
        TempTrnDoc.cli-type     = TempTrnDocMT.ClientType
        TempTrnDoc.cli-code     = integer(TempTrnDocMT.ClientID)
        TempTrnDoc.obj-type     = TempTrnDocMT.ObjectType
        TempTrnDoc.obj-code     = TempTrnDocMT.ObjectID
        TempTrnDoc.ps           = if available (ub.user-login) then "" else " Пользователь: " + TempTrnDocMT.UserName
        TempTrnDoc.Status_      = TempTrnDocMT.Status_
        TempTrnDoc.Flags_       = TempTrnDocMT.Flags_
        .

      myflagsDoc:setFlagsToInt(TempTrnDocMT.Flags_).
       
      define variable cFactQntyDec as decimal no-undo .
      define variable cPriceRublDec as decimal no-undo .  
      for each TempTrnLineMT where TempTrnLineMT.docname = TempTrnDocMT.DocName:

          cDocQnty   = replace (TempTrnLineMT.DocQnty, ",", ".") .
          cFactQnty  = replace (TempTrnLineMT.FactQnty, ",", ".") .
          cPriceRubl = replace (TempTrnLineMT.Price_, ",", ".") .
          cFactQntyDec = decimal(cFactQnty) no-error.
          if error-status:error then
          assign
          cFactQnty = "0" .
          cPriceRublDec = decimal (cPriceRubl)no-error.
          if error-status:error then 
          cPriceRubl = "0" .
          RowSum    =  decimal (cFactQnty) * decimal (cPriceRubl) .

        /* для помарочного учета объеденим все линии по товару и будем резервировать количество по маркам в rsrv-dtl.p*/
        if myflagsDoc:isDocMarkOn and (docType = {&TDEDT_Pri_Vnesh} or docType = {&TDEDT_Pri_Perem})
        then do:
          find first TempDocLine no-lock 
            where TempDocLine.gds-code = integer (TempTrnLineMT.goodsid) 
              and TempDocLine.b-code = (TempTrnLineMT.BC) no-error.
          if not available (TempDocLine)
          then do:
            create TempDocLine.
            assign
              TempDocLine.line-num     = integer (TempTrnLineMT.pos)
              TempDocLine.gds-code     = integer (TempTrnLineMT.goodsid)
              TempDocLine.b-code       = string (TempTrnLineMT.BC)
              TempDocLine.fact-qnty    = decimal(cFactQnty)
              TempDocLine.doc-qnty     = decimal(cDocQnty)
              TempDocLine.price-rubl   = ?
              TempDocLine.RowSum       = ?
              TempDocLine.PartIDTH     = TempTrnLineMT.PartIDTH
              TempDocLine.NotDict      = TempTrnLineMT.NotDict
              .
          end.
          else do:
            assign
              TempDocLine.fact-qnty    = TempDocLine.fact-qnty + decimal(cFactQnty)
              TempDocLine.PartIDTH     = TempDocLine.PartIDTH + {&delim-par} + TempTrnLineMT.PartIDTH 
            .
          end.
  
        end.
        else do:
          create TempDocLine.
          assign
            TempDocLine.line-num     = integer (TempTrnLineMT.pos)
            TempDocLine.gds-code     = integer (TempTrnLineMT.goodsid)
            TempDocLine.b-code       = string (TempTrnLineMT.BC)
            TempDocLine.fact-qnty    = decimal(cFactQnty)
            TempDocLine.doc-qnty     = decimal(cDocQnty)
            TempDocLine.price-rubl   = decimal(cPriceRubl)
            TempDocLine.RowSum       = RowSum
            TempDocLine.PartIDTH = string (TempTrnLineMT.PartIDTH)
            TempDocLine.NotDict      = TempTrnLineMT.NotDict
            .
        end.
      end.
      
      for each TempMarkLineMT 
/*      where TempMarkLineMT.DocName = TempTrnDoc.ext-doc-code*/
          :
      
        create TempMarkLine.
        assign
          TempMarkLine.DocName     =  TempMarkLineMT.DocName 
          TempMarkLine.PartIDTH    =  TempMarkLineMT.PartIDTH
          TempMarkLine.MarkCode    =  TempMarkLineMT.MarkCode
          TempMarkLine.Sts         =  TempMarkLineMT.Sts
          TempMarkLine.MarkParent  =  TempMarkLineMT.MarkParent     
          .
      end.

      case docType:

        when {&TDEDT_Inv} then 
          do:
            if tsd:ImpInventory (table TempTrnDoc, table TempDocLine, userId_)
            then ErrStatus = false.
            else ErrStatus = true.

          end.
        when "UTD_DOC" then 
          do:
            if tsd:ImpUTDDOC (table TempTrnDoc, table TempDocLine, table TempMarkLine)
            then ErrStatus = false.
            else ErrStatus = true.

          end.
        when "InvIntroduce" then 
          do:
            if tsd:ImpUTDIntroduce(table TempTrnDoc, table TempDocLine, table TempMarkLine)
            then ErrStatus = false.
            else ErrStatus = true.

          end.
        when "invmark" then 
          do:
            if tsd:ImpInvMarksDOC (table TempTrnDoc, table TempDocLine, table TempMarkLine)
            then ErrStatus = false.
            else ErrStatus = true.

          end.
        when "UTD_Introduce" then 
          do:
            if tsd:ImpUTDIntroduce(table TempTrnDoc, table TempDocLine, table TempMarkLine)
            then ErrStatus = false.
            else ErrStatus = true.

          end.
         when "MarksInv" then 
          do:
            if tsd:ImpMarksInv (table TempTrnDoc, table TempDocLine, table TempMarkLine)
            then ErrStatus = false.
            else ErrStatus = true.

          end.
        otherwise  
        do:
          for each TempDocLine no-lock where not TempDocLine.b-code matches ("*" + string (TempDocLine.gds-code) + "*"):
                      
            find first bfTempDocLine where bfTempDocLine.gds-code = TempDocLine.gds-code and bfTempDocLine.b-code matches ( "*" + string (bfTempDocLine.gds-code) + "*")  no-error.
            find buf_bar-code no-lock where 
              buf_bar-code.gds-code = TempDocLine.gds-code and TempDocLine.b-code matches ("*" + string(buf_bar-code.b-code)+ "*") no-error.
            
            
            if not available buf_bar-code then 
            do:
              
              find first buf_prod-bc no-lock where buf_prod-bc.b-str = TempDocLine.b-code no-error.
              if available buf_prod-bc 
                then 
              do:
                find first buf_bar-code no-lock where buf_bar-code.b-code = buf_prod-bc.b-code and buf_bar-code.gds-code = TempDocLine.gds-code no-error.
              end.
              
              if not available buf_bar-code then 
              do:
                LogWrite:LogStr =  LogWrite:LogStr + {&new-line} + 'Отправлен ответ на запрос типа "WAYBILL".' + {&new-line} + "Не известный штрих-код:" + TempDocLine.b-code.
                logWrite:WriteFileToLog( "Не известный штрих-код:" + TempDocLine.b-code).
                writeSockError(HndlSocket, "Не известный штрих-код:" + TempDocLine.b-code).
                ErrStatus = true.
                return false.
              end.
              
            end.

            if not available bfTempDocLine
              then 
            do:
              create bfTempDocLine.
              assign
                bfTempDocLine.gds-code = TempDocLine.gds-code
                bfTempDocLine.b-code   = string (TempDocLine.gds-code)
                .
            end.
            
            assign
              bfTempDocLine.doc-qnty  = bfTempDocLine.doc-qnty + TempDocLine.doc-qnty * buf_bar-code.cli-base-rate
              bfTempDocLine.fact-qnty = bfTempDocLine.fact-qnty + TempDocLine.fact-qnty * buf_bar-code.cli-base-rate
              bfTempDocLine.RowSum    = bfTempDocLine.RowSum + TempDocLine.RowSum
              .
            delete TempDocLine.
          
          end.
          
          for each TempDocLine no-lock:
            assign
              TempDocLine.price-rubl = TempDocLine.RowSum / TempDocLine.fact-qnty.
            .
            
          end.
          
          if tsd:ImpWB(table TempTrnDoc, table TempDocLine, table TempMarkLine, userId_)
          then ErrStatus = false.
          else ErrStatus = true.
          
        end.

      end.
      logWrite:WriteDebugLog("Загружен документ " + TempTrnDocMT.DocName).
    end.

    
    return true.
    
  end.


  /*------------------------------------------------------------------------------
   Notes:
  ------------------------------------------------------------------------------*/

  method private logical parseXML(hRoot as handle  ):
    
    define variable lResult    as logical   no-undo.
    define variable cFactQnty  as character no-undo.
    define variable cDocQnty   as character no-undo.
    define variable cPriceRubl as character no-undo.
    define variable cRowSum    as character no-undo.
    define variable iDbNum     as integer   no-undo.
    define variable docType    as character no-undo.
    define variable hRow        as handle    no-undo.
    mSN = ?.
    tsd:SN = ?.
    mVersion = ?.
    mobjtype = ?.
    mobjcode = ?.          
    create x-noderef  hRow.
    
    do i = 1 to hRoot:num-children:
      hRoot:get-child(hRow,i).
      case hRow:name:
        when "header" then
          do:
            iDbNum = tsd:GetDbNum().
            case hRow:get-attribute("DocType"):
              when "ExtSalesWB" then do:
                docType = {&TDEDT_Ras_Vnesh}.
              end.
              when "IntSalesWB" then do:
                docType = {&TDEDT_Ras_Perem}.
              end.
              when "ExtPurchWB" then do:
                docType = {&TDEDT_Pri_Vnesh}.
              end.
              when "IntPurchWB" then do:
                docType = {&TDEDT_Pri_Perem}.
              end.
              when "Inv" then do:
                docType = {&TDEDT_Inv}.
              end.
            end case.
            create TempTrnDoc.
            assign
              TempTrnDoc.line-num     = 1
              TempTrnDoc.doc-date     = today
              TempTrnDoc.ext-doc-code = hRow:get-attribute("DocName")
              TempTrnDoc.ext-doc-type = docType 
              TempTrnDoc.cli-type     = hRow:get-attribute("ClientType")
              TempTrnDoc.cli-code     = integer(hRow:get-attribute("ClientID"))
              TempTrnDoc.obj-type     = hRow:get-attribute("ObjectType")
              TempTrnDoc.obj-code     = integer (hRow:get-attribute("ObjectID"))
              TempTrnDoc.ps           = if available (ub.user-login) then "" else " Пользователь: " + hRow:get-attribute("UserName")
              TempTrnDoc.Status_      = hRow:get-attribute("Status")
              .
            find first ub.user-login where ub.user-login.db-num = iDbNum and ub.user-login.user-id = userId_ no-lock no-error.  
            userId_ = hRow:get-attribute("UserID").
          end.
        when "line" then
          do:
            assign
              cDocQnty   = replace (hRow:get-attribute("DocQnty"), ",", ".")
              cFactQnty  = replace (hRow:get-attribute("FactQnty"), ",", ".")
              cPriceRubl = replace (hRow:get-attribute("Price"), ",", ".")
              cRowSum    = replace (hRow:get-attribute("RowSum"), ",", ".")
              .

            /* для помарочного учета объеденим все линии по товару и будем резервировать количество по маркам в rsrv-dtl.p*/
            if (docType = {&TDEDT_Pri_Vnesh} or docType = {&TDEDT_Pri_Perem})
            and not TempTrnDoc.Status_ = "НОВ"
            then do:
              find first TempDocLine no-lock where TempDocLine.gds-code = integer (hRow:get-attribute("GoodsID")) and TempDocLine.b-code = (hRow:get-attribute("BC")) no-error.
              if not available (TempDocLine)
              then do:
                create TempDocLine.
                assign
                  TempDocLine.line-num     = integer (hRow:get-attribute("Pos"))
                  TempDocLine.gds-code     = integer (hRow:get-attribute("GoodsID"))
                  TempDocLine.b-code       = string (hRow:get-attribute("BC"))
                  TempDocLine.fact-qnty    = decimal(cFactQnty)
                  TempDocLine.doc-qnty     = decimal(cDocQnty)
                  TempDocLine.price-rubl   = ?
                  TempDocLine.RowSum       = ?
/* TempDocLine.PartIDTH = string (hRow:get-attribute("PartIDTH"))*/ 
                  .
              end.
              else do:
                assign
                  TempDocLine.fact-qnty    = TempDocLine.fact-qnty + decimal(cFactQnty)
                .
               end.

            end.
            else do:
              create TempDocLine.
              assign
                TempDocLine.line-num     = integer (hRow:get-attribute("Pos"))
                TempDocLine.gds-code     = integer (hRow:get-attribute("GoodsID"))
                TempDocLine.b-code       = string (hRow:get-attribute("BC"))
                TempDocLine.fact-qnty    = decimal(cFactQnty)
                TempDocLine.doc-qnty     = decimal(cDocQnty)
                TempDocLine.price-rubl   = decimal(cPriceRubl)
                TempDocLine.RowSum       = decimal(cRowSum)
                TempDocLine.PartIDTH = string (hRow:get-attribute("PartIDTH"))
                .
            end.
          end.
        when "MarkLines" then
          do:
            create TempMarkLine.
            assign
              TempMarkLine.DocName     = hRow:get-attribute("DocName")
              TempMarkLine.PartIDTH    = hRow:get-attribute("PartIDTH")
              TempMarkLine.MarkCode    = hRow:get-attribute("MarkCode")
              TempMarkLine.Sts         = hRow:get-attribute("Sts")
              .
          end.
         when "device" then
          do:
            mType    = hRow:get-attribute("type"). 
            mVersion = hRow:get-attribute("version").
          end.
        when "OBJ" then
          do:
            mObjType = hRow:get-attribute("obj_type"). 
            mObjCode = hRow:get-attribute("obj_code").
          end.
          
      end case.
      
    end.
    
    
    return true.
    finally:
           delete object  hRow no-error.
    end.
  end method.  
  
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
   
  method private logical writeSockError (HndlSocket as handle, textMes as longchar):
    define variable glog     as logical  no-undo.
    
    define variable v-cont-length as integer no-undo.
    define variable VOK as longchar no-undo.
    define variable VrespOK as memptr no-undo.
    VOK = substitute (HTTPError, textMes).
    copy-lob
      from object VOK
      to object VrespOK
      convert target codepage "UTF-8".
    .
    if not hndlSocket:connected()
    then do:
       LogWrite:WriteFileToLog("Клиент отключился.").
       return false.
    end.
    logWrite:WriteDebugLog("Отправляем ответ:").
    logWrite:WriteDebugLog(VOK).
    glog = hndlsocket:write(VrespOK,1,get-size(VrespOK)).
    if    not glog
       or hndlsocket:bytes-written ne get-size(VrespOK)
    then do:
       set-size(VrespOK) = 0.
       logWrite:WriteDebugLog("Произошла ошибка при отправке.").
       LogWrite:LogStr = LogWrite:LogStr + " " + "Ошибка при отправке сообщения удаленному клиенту.".
       return false.
    end.
    set-size(VrespOK) = 0.
    logWrite:WriteDebugLog("Ответ отправлен.").
       
    return true.
      
  end method.

  
  method private logical writeSock (resp as class IResponse, arg as longchar):
    resp:setContent(arg).
    resp:Content-Type= "text/csv".   
    resp:condition = resp:STSlist:WriteResponse:NameProp.  
  end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	destructor public TSDCommand ( ):
      delete object tsd no-error.
      if mEmptyConstr
      then
         delete object filesend no-error.
   end destructor.
  
   
  { utl/search.i class}

end class.

   
