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
  define private variable hRoot       as handle    no-undo.
  define private variable hDoc        as handle    no-undo.
  define private variable hRow        as handle    no-undo.
  define private variable tthDocument as handle    no-undo.
  define private variable i           as integer   no-undo.
  define private variable userId_     as character no-undo.
  define private variable sn          as character no-undo.
  define private variable hndlSocket  as handle    no-undo.
  define private variable duration    as integer   no-undo.
  define private variable millisec    as integer   no-undo.
  
/*  define private variable isDocMarkOn as logical   no-undo.*/
  
    /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  constructor public TSDCommand (  ):
    define variable tempStr       as char     no-undo.
    
    super ().
    os-command silent value( 'set pro >>procarch') .
    if search ("procarch") = ? 
    then do:
      logWrite:LogStr = "Не найден файл с данными PROCESSOR_ARCHITECTURE, проверьте настройки propath - должен быть указан путь рабочий директории".
      ErrStatus = true.
      return.
    end.    

    input from value (search('procarch')) no-convert.
    if not index ("PROCESSOR_ARCHITECTURE=AMD64", tempStr) = 0
      then assign is-ProcArch64 = true.
    import tempStr.
    if not index ("PROCESSOR_ARCHITEW6432=AMD64", tempStr) = 0
      then assign is-ProcArch64 = true.
    input close.
    tsd = new tsd().
    
  end constructor.

  method private void startStep(msg as char):
    output to logduraton.txt append.
    duration = etime.
    put unformatted string (string (now) + "   " + msg + {&new-line}).
    output close.
  end.
  
  method private void endStep(msg as char):
    output to logduraton.txt append.
    duration = etime - duration.
    put unformatted string ('Время выполнения шага - ' + string (int64 (duration / 1000), "HH:MM:SS") + "." + string ((duration / 1000 - int64 (duration / 1000)) * 1000) + {&new-line}).
    put unformatted string (string (now) + "   " + msg  + {&new-line}).
    output close.    
  end.
  define variable mServiceBusy as logical no-undo.
  method public void Execute_( input req as IRequest, resp as class IResponse, list-par as char ):
    define variable mbuffer       as memptr   no-undo.
    define variable mbuffer1      as memptr   no-undo.
    define variable tempLongCh    as longchar no-undo.
    define variable glog          as logical  no-undo.
    
    if mServiceBusy
    then do:
       logWrite:LogStr = "При обмене возникли ошибки. Уже выполняется одна задание получения данных".
       tempLongCh = substitute("HTTP/1.0 200 OK&1Server: 4GL&1Content-Type: text/csv&1Content-Length: &3&1ETag: &4&2",
                              {&CRLF},
                              {&HdEnd},
                              length(logWrite:LogStr,'RAW':U), 
                              logWrite:LogStr). 
    
       set-size(mbuffer) = 0.
       set-size(mbuffer) = length (tempLongCh, "RAW":U) + 1.
       put-string(mbuffer,1) = tempLongCh.
       glog = req:HndlSocket:write(mbuffer,1,length(tempLongCh,'RAW':U)) no-error.
       if not glog 
       then do:
          logWrite:LogStr = logWrite:LogStr + " " + "Ошибка при отправке сообщения удаленному клиенту.". 
       end.
       ErrStatus = true.
       return.
    end.
    mServiceBusy = yes.
    os-delete value (search ("MT_documentsSend.txt")) no-error.
    os-delete value (search ("MT_lineSend.txt")) no-error.
    os-delete value (search ("MT_MarkLinesSend.txt")) no-error.  
    
    startStep('Начало выгрузка из базы ТСД').
          
    define variable vobjtype as character no-undo.
    logWrite:LogStr = "".
    
    copy-lob
    from  object req:ContentBuff
    to file "documents.s3db"
    no-convert
    no-error .
    
    vobjtype = entry (1, list-par, "?").
    if vobjtype eq "" or vobjtype eq ?
    then do:
      mServiceBusy = no.
      logWrite:LogStr = "Не задан тип объекта".
      ErrStatus = true.
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
      mServiceBusy = no.
      logWrite:LogStr = "Не задан код объекта".
      ErrStatus = true.
      return.
    end.
    assign    
    
    tsd:ObjType = vobjtype
    tsd:ReqType = entry (3, list-par, "?")
    tsd:CurrDecSeparator = entry (4, list-par, "?")
    tsd:IsMarkOn = if entry (5, list-par, "?") = "true" then true else false
    no-error.
    
    if req:HeadHTTP:getValue("TSD-protocol") > ""
    then
       os-copy value(search("exe/DBInit_1_6_a.exe")) value ("DBInit.exe").
    else
       os-copy value(search("exe/DBInit_1_5.exe"))   value ("DBInit.exe").       
         
    
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
    
  end method.
  
  method override public void ContinueExecution( input req as IRequest, input resp as IResponse ):
    define variable tempLongCh    as longchar no-undo.
    define variable mbuffer       as memptr   no-undo.
    define variable mbuffer1      as memptr   no-undo.
    define variable glog          as logical  no-undo.
    
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
    if vStatus eq "step1"
    then do transaction:
       logWrite:WriteFileToLog("DBInitExpDoc.txt").
       run gbl/pause.p( 1000).
       endStep('Завершена выгрузка из базы ТСД').
       startStep('Начало загрузки документов.').
       parseCSV().
       endStep('Завершена загрузки документов.').
       startStep('Начало выгрузки накладных.').
       tsd:clear().
       tsd:getWB().
       endStep('Завершена выгрузка накладных').
       startStep('Начало выгрузки ЭДО.').
       tsd:getUTDDoc(req:HeadHTTP:getValue("TSD-protocol")).
       endStep('Завершена выгрузка ЭДО').
       startStep('Начало загрузки документов в ТСД.').
       os-delete "documents_new.s3db".
       vpid = runProc('DBInit.exe Doc 30 31 >DBInitDoc.txt'  + {&new-line} + 'rename documents.s3db documents_new.s3db').
       
       resp:condition = resp:STSlist:WriteStatusAndWait:NameProp.
       resp:ParamWait = substitute ("pid,&1,status,Step2", vpid).
    end.
    else if vStatus eq "step2"
    then do:
      logWrite:WriteFileToLog("DBInitDoc.txt").
      endStep('Завершена загрузка документов в ТСД.').
      resp:condition = resp:STSlist:ReciveCommand:NameProp.
      define variable vsize as int64 no-undo.
      define variable vi as integer no-undo.
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
      if vsize eq ?
      then do:
         set-size (mbuffer1) = 0.
         logWrite:WriteFileToLog("DBInitDoc.txt").
         logWrite:LogStr = "Не удалость произвести выгрузку".
      end.
      else do:
         set-size (mbuffer1) = 0.
         set-size (mbuffer1) = vsize.
         input from value (file-info:file-name) binary no-convert.
         import mbuffer1.
         input close.
      end.
      
      if logWrite:LogStr = ""
      then tempLongCh = substitute("HTTP/1.0 200 OK&1Server: 4GL&1Content-Type: text/csv&1Content-Length: &3&2",{&CRLF},{&HdEnd},get-size(mbuffer1)).
      else tempLongCh = substitute("HTTP/1.0 200 OK&1Server: 4GL&1Content-Type: text/csv&1Content-Length: &3&1ETag: &4&1&5&2",{&CRLF},{&HdEnd},get-size(mbuffer1), "При обмене возникли ошибки.",logWrite:LogStr). 
      block-write:
      do trans:
      set-size(mbuffer) = 0.
      set-size(mbuffer) = length (tempLongCh, "RAW":U) + 1.
      put-string(mbuffer,1) = tempLongCh.
      mServiceBusy = no.
      assign
         glog = req:HndlSocket:write(mbuffer,1,length(tempLongCh,'RAW':U)) no-error.
      if not glog 
      then do:
        logWrite:LogStr = logWrite:LogStr + " " + "Ошибка при отправке сообщения удаленному клиенту.". 
        ErrStatus = true.
        leave block-write.
      end.
      assign
         glog = req:HndlSocket:write(mbuffer1,1,get-size(mbuffer1)) no-error.
      if not glog
      then do:
        logWrite:LogStr = logWrite:LogStr + " " + "Ошибка при отправке сообщения удаленному клиенту.".
        ErrStatus = true.
        leave block-write.
      end.
      end.
    end.
  end.
  

  method public override void Execute_( input req as IRequest, resp as class IResponse ):
  
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
    
    
    logWrite = new logWrite().

    create x-document hDoc.
    create x-noderef  hRoot.
    create x-noderef  hRow.
    
    hDoc:load("longchar",req:Content,no).
    tsd:CP = hDoc:encoding.
    if hDoc:encoding <> "windows-" + session:charset then
    do:
      str = req:Content.
      str = codepage-convert (str, session:charset, hDoc:encoding) no-error.
      if error-status:error
        then return error "Ошибка при преобразовании кодировки".
      req:Content = str.
      delete object hDoc.
      create x-document hDoc.
      hDoc:load("longchar",req:Content,no).
    end.
    hDoc:encoding = if session:charset begins "12" then "windows-" + session:charset else session:charset.
    hDoc:get-document-element(hRoot) .
    assign
      tsd:ObjCode = integer (substring (hRoot:get-attribute("to"), 4))
      tsd:ObjType = substring (hRoot:get-attribute("to"), 1, 3)
      tsd:ReqType = hRoot:get-attribute("item")
      tsd:CurrDecSeparator = hRoot:get-attribute("currDecSeparator")
      tsd:IsMarkOn = if hRoot:get-attribute("MarksReg") = "true" then true else false
      .
    hndlsocket = req:HndlSocket.
    case tsd:ReqType :
      when "SETTINGS" then 
        do:
          parseXML().
          tsd:Check_().
        end.
      when "TH_ALL" then 
        do:
          startStep('Начало кеширования справочника пользователей.').
          tsd:WriteUsers().
          endStep('Завершено кеширование справочника пользователей.').
          startStep('Начало кеширования справочника объектов.').
          tsd:WriteObjects().
          endStep('Завершено кеширование справочника объектов.').
          startStep('Начало кеширования справочника контрагентов.').          
          tsd:WriteClients().
          endStep('Завершено кеширование справочника контрагентов.').
          startStep('Начало кеширования справочника товаров.').
          tsd:WriteGoods().
          endStep('Завершено кеширование справочника товаров.').
          startStep('Начало кеширования справочника штрих-кодов.').
          tsd:WriteBarcodes(req:HeadHTTP:getValue("TSD-protocol")).
          endStep('Завершено кеширование справочника штрих-кодов.').
          str = 'dictionaries'.
        end.
      when "TH_WB" then 
        do:
          startStep('Начало кеширования документов.').
          tsd:GetWB().
          endStep('Завершено кеширование справочника штрих-кодов.').
        end.
      when "TH_users" then 
        do:
          tsd:WriteUsers().
        end.
      when "TH_objects" then 
        do:
          tsd:WriteObjects().
        end.
      when "TH_clients" then 
        do:
          tsd:WriteClients().
        end.
      when "TH_goods" then 
        do:
          tsd:WriteGoods().
        end.
      when "TH_barcodes" then 
        do:
          tsd:WriteBarcodes(req:HeadHTTP:getValue("TSD-protocol")).
        end.
      when "WAYBILL" then 
        do:
          parseXML().

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
                tsd:SomeStr = tsd:getStatusXml(false, "Не известный штрих-код:" + TempDocLine.b-code).
                writeSock("",req:HeadHTTP:getValue("TSD-protocol")).
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

          parseXML().

          if tsd:ImpInventory (table TempTrnDoc, table TempDocLine, userId_)
            then ErrStatus = false.
            else ErrStatus = true.

        end.
      otherwise 
      do:
        tsd:WriteUnknown().
      end.
    end.
/*    tsd:CodePageConvert().*/

    case tsd:ReqType :
      when "SETTINGS" then 
        do:
          logWrite:LogStr = 'Отправлен ответ на запрос типа "SETTINGS".' + {&new-line} + logWrite:LogStr.
        end.
      when "TH_ALL" then 
        do:
          logWrite:LogStr = 'Отправлен ответ на запрос типа "TH_ALL".' + {&new-line} + logWrite:LogStr.
        end.
      when "TH_WB" then 
        do:
          logWrite:LogStr = 'Отправлен ответ на запрос типа "TH_WB".' + {&new-line} + logWrite:LogStr.
        end.
      when "WAYBILL" then 
        do:
          logWrite:LogStr = 'Отправлен ответ на запрос типа "WAYBILL".' + {&new-line} + logWrite:LogStr.
        end.
      when "INVENTORY" then 
        do:
          logWrite:LogStr = 'Отправлен ответ на запрос типа "INVENTORY".' + {&new-line} + logWrite:LogStr.
        end.
        
    end case.

    if ErrStatus then 
    do:
      writeSock("",req:HeadHTTP:getValue("TSD-protocol")).
      if ErrStatus = true then undo.
    end.
    else do:
      writeSock(str,req:HeadHTTP:getValue("TSD-protocol")).
      if ErrStatus = true then undo.
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
          cFactQntyDec = DECIMAL(cFactQnty) no-error.
          if ERROR-STATUS:ERROR then
          assign
          cFactQnty = "0" .
          cPriceRublDec = DECIMAL (cPriceRubl)no-error.
          if ERROR-STATUS:error then 
          ASSIGN 
          cPriceRubl = "0"
          .
          RowSum    =  DECIMAL (cFactQnty) * DECIMAL (cPriceRubl) .

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
      
      for each TempMarkLineMT where TempMarkLineMT.DocName = TempTrnDoc.ext-doc-code:
      
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
                logWrite:LogStr = 'Отправлен ответ на запрос типа "WAYBILL".' + {&new-line} + "Не известный штрих-код:" + TempDocLine.b-code.
                tsd:SomeStr = tsd:getStatusXml(false, "Не известный штрих-код:" + TempDocLine.b-code).
                writeSock("","").
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

    end.

    
    return true.
    
  end.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method private logical parseXML(  ):
    
    define variable lResult    as logical   no-undo.
    define variable cFactQnty  as character no-undo.
    define variable cDocQnty   as character no-undo.
    define variable cPriceRubl as character no-undo.
    define variable cRowSum    as character no-undo.
    define variable iDbNum     as integer   no-undo.
    define variable docType    as character no-undo.

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
        when "SN" then
          do:
            if hRow:get-attribute("type") = "HARDWARE" 
            then do:
              tsd:SN = hRow:get-attribute("value").
            end.
          end.
      end case.
    end.
    
    
    return true.

  end method.  
  
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method private logical writeSock ( arg as character, iprotocol as char ):
    
    define variable mbuffer       as memptr   no-undo.
    define variable mbuffer1      as memptr   no-undo.
    define variable tempLongCh    as longchar no-undo.
    define variable tempStr       as char     no-undo.
    define variable glog          as logical  no-undo.
    define variable is-ProcArch64 as logical  no-undo init no.
    
    define variable mTypeResp as character no-undo init "text/csv".
    
    if arg = "dictionaries" then 
    do:
      os-command silent value( 'set pro >>procarch') .
      if search ("procarch") = ? 
      then do:
         logWrite:LogStr = "Не найден файл с данными PROCESSOR_ARCHITECTURE, проверьте настройки propath - должен быть указан путь рабочий директории".
         return false.
      end.    

      input from value (search('procarch')) no-convert.
      import tempStr.
      if not index ("PROCESSOR_ARCHITECTURE=AMD64", tempStr) = 0
      then assign is-ProcArch64 = true.
      import tempStr.
      if not index ("PROCESSOR_ARCHITEW6432=AMD64", tempStr) = 0
      then assign is-ProcArch64 = true.
      input close.
      startStep("Начало конвертации справочника.").
      if iprotocol > ""
      then
         os-copy value(search("exe/DBInit_1_6_a.exe")) value ("DBInit.exe").
      else
         os-copy value(search("exe/DBInit_1_5.exe"))   value ("DBInit.exe").       
      if is-ProcArch64 
      then do:
         os-copy value(search("exe/x64/System.Data.SQLite.dll")) value ("System.Data.SQLite.dll").
      end.
      else do:
         os-copy value(search("exe/x86/System.Data.SQLite.dll")) value ("System.Data.SQLite.dll").
      end.    
    
      os-command silent value( 'DBInit.exe Dict 30 31 >>DBInitDict.txt') .
      if search ("dictionaries.s3db") = ? 
      then do:
        logWrite:LogStr = "Не найден файл базы данных, для отсылки на TSD, проверьте настройки propath - должен быть указан путь рабочий директории".
         return false.
      end.
      assign
         file-info:file-name = "dictionaries.s3db"
      .
      set-size (mbuffer1) = file-info:file-size.
      input from value (file-info:file-name) binary no-convert.
      import mbuffer1.
      input close.
      endStep("Завершена конвертация справочника.").
      mTypeResp = "raw".
    end.
    else 
    do:
/*      
    os-command silent value( 'set pro >>procarch') .
    if search ("procarch") = ? 
    then do:
      logWrite:LogStr = "Не найден файл с данными PROCESSOR_ARCHITECTURE, проверьте настройки propath - должен быть указан путь рабочий директории".
      return false.
    end.    

    input from value (search('procarch')) no-convert.
    import tempStr.
    if not index ("PROCESSOR_ARCHITECTURE=AMD64", tempStr) = 0
      then assign is-ProcArch64 = true.
    import tempStr.
    if not index ("PROCESSOR_ARCHITEW6432=AMD64", tempStr) = 0
      then assign is-ProcArch64 = true.
    input close.

    if req:HeadHTTP:getValue("TSD-protocol") > ""
      then
         os-copy value(search("exe/DBInit_1_6_a.exe")) value ("DBInit.exe").
      else
         os-copy value(search("exe/DBInit_1_5.exe"))   value ("DBInit.exe").       
        
    
    if is-ProcArch64 
    then do:
      os-copy value(search("exe/x64/System.Data.SQLite.dll")) value ("System.Data.SQLite.dll").
    end.
    else do:
      os-copy value(search("exe/x86/System.Data.SQLite.dll")) value ("System.Data.SQLite.dll").
    end.    
    
    
    os-command silent value( 'DBInit.exe 30 31') .
    if search ("documents.s3db") = ? 
    then do:
        logWrite:LogStr = "Не найден файл базы данных, для отсылки на TSD, проверьте настройки propath - должен быть указан путь рабочий директории".
      return false.
    end.
    assign
      file-info:file-name = "documents.s3db"
      .
      set-size (mbuffer1) = file-info:file-size.
      input from value (file-info:file-name) binary no-convert.
      import mbuffer1.
      input close.*/
      
      
      set-size(mbuffer1) = length (tsd:SomeStr, "RAW":U) + 1.
      put-string(mbuffer1,1) = tsd:SomeStr.        
    end.
      
    tempLongCh = substitute("HTTP/1.0 200 OK&1Server: 4GL&1Content-Type: &4&1Content-Length: &3&2",{&CRLF},{&HdEnd},get-size(mbuffer1),mTypeResp).
    set-size(mbuffer) = length (tempLongCh, "RAW":U) + 1.
    put-string(mbuffer,1) = tempLongCh.
    startStep("Начало отправки справочника на ТСД.").
    assign
      glog = hndlsocket:write(mbuffer,1,length(tempLongCh,'RAW':U)) no-error.
    set-size(mbuffer) = 0.
    if not glog 
      then do:
        logWrite:LogStr = logWrite:LogStr + " " + "Ошибка при отправке сообщения удаленному клиенту.". 
        ErrStatus = true.
      end.
    assign
      glog = hndlsocket:write(mbuffer1,1,get-size(mbuffer1)) no-error.
    set-size(mbuffer1) = 0.
    if not glog
      then do:
        logWrite:LogStr = logWrite:LogStr + " " + "Ошибка при отправке сообщения удаленному клиенту.".
        ErrStatus = true.
      end.
    endStep("Завершена отправка справочника на ТСД.").
    return true.
      
  end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	destructor public TSDCommand ( ):
      delete object tsd no-error.
   end destructor.
  
   
  { utl/search.i class}

end class.

   
