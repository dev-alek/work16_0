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

class ibs.th.skt.Commands.TSDCommand implements ICommand: 

  { cmp/str-glbl.i class}  
  {ibs/th/skt/ControlledClients/TSDTT.i}
  
  define public property ErrStatus as logical no-undo 
    get.
    private set.

  define public property LogMsg as character no-undo 
    get.
    private set.

  define private variable tsd         as class     TSD .
  define private variable logWrite    as class     LogWrite no-undo.
  define private variable hRoot       as handle    no-undo.
  define private variable hDoc        as handle    no-undo.
  define private variable hRow        as handle    no-undo.
  define private variable tthDocument as handle    no-undo.
  define private variable i           as integer   no-undo.
  define private variable userId_     as character no-undo.
  define private variable sn          as character no-undo.
  define private variable hndlSocket  as handle    no-undo.

  method public void Execute_( input req as IRequest, output resp as class IResponse ):
  
  do transaction:

    &scop CRLF chr(13) + chr(10)
    &scop HdEnd chr(13) + chr(10) + chr(13) + chr(10)

    define variable contLength as integer   no-undo.
    define variable strLog     as character no-undo.
    define variable str        as character no-undo.
    define buffer buf_bar-code  for ub.bar-code.
    define buffer buf_prod-bc   for ub.prod-bc.
    define buffer buf_place     for ub.place.
    define buffer bfTempDocLine for TempDocLine.
    
    resp = new SimpleResponse().
    tsd = new tsd().
    logWrite = new LogWrite().

    create x-document hDoc.
    create x-noderef  hRoot.
    create x-noderef  hRow.
    
    hDoc:load("longchar",cast(req, ibs.th.skt.Commands.SimpleRequest):Content,no).
    tsd:CP = hDoc:encoding.
    if hDoc:encoding <> "windows-" + session:charset then
    do:
      str = cast(req, ibs.th.skt.Commands.SimpleRequest):Content.
      str = codepage-convert (str, session:charset, hDoc:encoding) no-error.
      if error-status:error
        then return error "Ошибка при преобразовании кодировки".
      cast(req, ibs.th.skt.Commands.SimpleRequest):Content = str.
      delete object hDoc.
      create x-document hDoc.
      hDoc:load("longchar",cast(req, ibs.th.skt.Commands.SimpleRequest):Content,no).
    end.
    hDoc:encoding = if session:charset begins "12" then "windows-" + session:charset else session:charset.
    hDoc:get-document-element(hRoot) .
    assign
      tsd:ObjCode = integer (substring (hRoot:get-attribute("to"), 4))
      tsd:ObjType = substring (hRoot:get-attribute("to"), 1, 3)
      tsd:ReqType = hRoot:get-attribute("item")
      .
    hndlsocket = cast(req, ibs.th.skt.Commands.SimpleRequest):HndlSocket.
    case tsd:ReqType :
      when "SETTINGS" then 
        do:
          parseXML().
          tsd:Check_().
        end.
      when "TH_ALL" then 
        do:
          tsd:WriteUsers().
          tsd:WriteObjects().
          tsd:WriteClients().
          tsd:WriteGoods().
          tsd:WriteBarcodes().
          str = 'dictionaries'.
        end.
      when "TH_WB" then 
        do:
          tsd:GetWB().
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
          tsd:WriteBarcodes().
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
                LogWrite:LogStr = 'Отправлен ответ на запрос типа "WAYBILL".' + {&new-line} + "Не известный штрих-код:" + TempDocLine.b-code.
                tsd:SomeStr = tsd:getStatusXml(false, "Не известный штрих-код:" + TempDocLine.b-code).
                writeSock("").
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
          
          if tsd:ImpWB(table TempTrnDoc, table TempDocLine, userId_)
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
          LogWrite:LogStr = 'Отправлен ответ на запрос типа "SETTINGS".' + {&new-line} + LogWrite:LogStr.
        end.
      when "TH_ALL" then 
        do:
          LogWrite:LogStr = 'Отправлен ответ на запрос типа "TH_ALL".' + {&new-line} + LogWrite:LogStr.
        end.
      when "TH_WB" then 
        do:
          LogWrite:LogStr = 'Отправлен ответ на запрос типа "TH_WB".' + {&new-line} + LogWrite:LogStr.
        end.
      when "WAYBILL" then 
        do:
          LogWrite:LogStr = 'Отправлен ответ на запрос типа "WAYBILL".' + {&new-line} + LogWrite:LogStr.
        end.
      when "INVENTORY" then 
        do:
          LogWrite:LogStr = 'Отправлен ответ на запрос типа "INVENTORY".' + {&new-line} + LogWrite:LogStr.
        end.
        
    end case.

    if ErrStatus then 
    do:
      writeSock("").
      if ErrStatus = true then undo.
    end.
    else do:
      writeSock(str).
      if ErrStatus = true then undo.
    end.
    
  end /*trans*/.
    
  end method.


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
            find first ub.user-login where ub.user-login.db-num = iDbNum and ub.user-login.user-id = userId_ no-lock no-error.
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
              .
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
            
            create TempDocLine.
            assign
              TempDocLine.line-num     = integer (hRow:get-attribute("Pos"))
              TempDocLine.gds-code     = integer (hRow:get-attribute("GoodsID"))
              TempDocLine.b-code       = string (hRow:get-attribute("BC"))
              TempDocLine.fact-qnty    = decimal(cFactQnty)
              TempDocLine.doc-qnty     = decimal(cDocQnty)
              TempDocLine.price-rubl   = decimal(cPriceRubl)
              TempDocLine.RowSum       = decimal(cRowSum)
              TempDocLine.aclMarksList = string (hRow:get-attribute("AlcMarks"))
              TempDocLine.PartIDTH = string (hRow:get-attribute("PartIDTH"))
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

  method private logical writeSock ( arg as character ):
    
    define variable mbuffer       as memptr   no-undo.
    define variable mbuffer1      as memptr   no-undo.
    define variable tempLongCh    as longchar no-undo.
    define variable tempStr       as char     no-undo.
    define variable glog          as logical  no-undo.
    define variable is-ProcArch64 as logical  no-undo init no.
    
    set-size(mbuffer1) = 0.
    if arg = "dictionaries" then 
    do:
    os-command silent value( 'set pro >>procarch') .
    if search ("procarch") = ? 
    then do:
      LogWrite:LogStr = "Не найден файл с данными PROCESSOR_ARCHITECTURE, проверьте настройки propath - должен быть указан путь рабочий директории".
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

    os-copy value(search("exe/DBInit.exe")) value ("DBInit.exe").    
    
    if is-ProcArch64 
    then do:
      os-copy value(search("exe/x64/System.Data.SQLite.dll")) value ("System.Data.SQLite.dll").
    end.
    else do:
      os-copy value(search("exe/x86/System.Data.SQLite.dll")) value ("System.Data.SQLite.dll").
    end.    
    
    
    os-command silent value( 'DBInit.exe 9 31') .
    if search ("dictionaries.s3db") = ? 
    then do:
        LogWrite:LogStr = "Не найден файл базы данных, для отсылки на TSD, проверьте настройки propath - должен быть указан путь рабочий директории".
      return false.
    end.
    assign
      file-info:file-name = "dictionaries.s3db"
      .
      set-size (mbuffer1) = file-info:file-size.
      input from value (file-info:file-name) binary no-convert.
      import mbuffer1.
      input close.
    end.
    else 
    do:
      set-size(mbuffer1) = length (tsd:SomeStr, "RAW":U) + 1.
      put-string(mbuffer1,1) = tsd:SomeStr.        
    end.
      
    tempLongCh = substitute("HTTP/1.0 200 OK&1Server: 4GL&1Content-Type: text/csv&1Content-Length: &3&2",{&CRLF},{&HdEnd},get-size(mbuffer1)).
    set-size(mbuffer) = 0.
    set-size(mbuffer) = length (tempLongCh, "RAW":U) + 1.
    put-string(mbuffer,1) = tempLongCh.
    assign
      glog = hndlsocket:write(mbuffer,1,length(tempLongCh,'RAW':U)) no-error.
    if not glog 
      then do:
        LogWrite:LogStr = LogWrite:LogStr + " " + "Ошибка при отправке сообщения удаленному клиенту.". 
        ErrStatus = true.
      end.
    assign
      glog = hndlsocket:write(mbuffer1,1,get-size(mbuffer1)) no-error.
    if not glog
      then do:
        LogWrite:LogStr = LogWrite:LogStr + " " + "Ошибка при отправке сообщения удаленному клиенту.".
        ErrStatus = true.
      end.
    return true.
      
  end method.
  
  
end class.