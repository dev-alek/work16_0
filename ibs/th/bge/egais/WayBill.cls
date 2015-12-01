 
/*------------------------------------------------------------------------
   File        : RequestDictOrg
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : asmorozov
   Created     : Wed Nov 11 14:29:45 MSK 2015
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.bge.egais.*.

class ibs.th.bge.egais.WayBill inherits EGAISUTM:

{cmp/str-glbl.i class}
{ibs/th/bge/egais/wb-egais.i}

&scop xml '<?xml version="1.0" encoding="UTF-8"?>~
<ns:Documents Version="1.0" ~
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ~
xmlns:ns= "http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01" ~
xmlns:oref="http://fsrar.ru/WEGAIS/ClientRef" ~
xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef" ~
xmlns:wa= "http://fsrar.ru/WEGAIS/ActTTNSingle">~
<ns:Owner>~
<ns:FSRAR_ID>&1</ns:FSRAR_ID>~
</ns:Owner>~
<ns:Document>~
<ns:WayBillAct>~
<wa:Header>~
<wa:IsAccept>&2</wa:IsAccept>~
<wa:ACTNUMBER>&3</wa:ACTNUMBER>~
<wa:ActDate>&4</wa:ActDate>~
<wa:WBRegId></wa:WBRegId>~
<wa:Note>Принимаем продукцию</wa:Note>~
</wa:Header>~
<wa:Content>~
</wa:Content>~
</ns:WayBillAct>~
</ns:Document>~
</ns:Documents>'

  define stream outstr.
  
  define private buffer buf_ext-sys for ub.ext-system.
  define private buffer buf_clob-bind for ub.clob-bind.
  define private buffer buf_clob-data for ub.clob-data.
  
  define private variable parameters as character no-undo.
  define private variable inFileName as character no-undo.
  define private variable inData     as character no-undo.
  define private variable outData    as character no-undo.
  define private variable cmd        as character no-undo.
  define private variable urlResp    as character no-undo.

  
  define variable v-FS-RAR as character no-undo .

  define temp-table tt-wb-clob-hndls no-undo
    field indenty      as character label "ID EGAIS"
    field num          as character label "№ EGAIS"
    field wb-date      as date label "Дата"
    field shippingdate as date label "Дата поставки"
    field shippregid   as character label "ID поставщика"
    field wb-type      as character label "Тип"
    field trn-doc-code as character label "№ накл."
    index pi
    indenty 
    .


  define temp-table tt-wb-info-client no-undo
    field obj-type        like ub.clients.obj-type
    field obj-code        like ub.clients.obj-code
    field obj-name-th     as character 
    field obj-name-egais  as character
    field wb-type-client  as character
    field regID           as character format "X(21)"
    field inn             as character
    field kpp             as character
    field country         as character
    field regionCode      as character
    field district        as character
    field city            as character
    field settlement      as character
    field street          as character
    field house-number    as character
    field house-case      as character
    field house-apartment as character
    field house-litera    as character
    field postIndex       as character
    field description_    as character format "X(100)"
    index pi 
    inn kpp
    . 

  constructor public WayBill (inFSRAR as char):
    
    assign
      parameters = inFSRAR. 
    .
    IsSent.
    
  end constructor.

  method override protected logical GetIsSent ():
    def var repId as char no-undo.
    def var glog  as log  no-undo.
    glog = CheckCurrentRequest (3, parameters, repId).
    if glog
      then ReplyId = repId.
    return glog.
  end.
  
  method override public logical SendRequestUTM ():

    
    assign
      StatusErr = false
      Msg = ""
    .
    
    if IsSent 
    then do:
      Msg = "Запрос уже был отправлен".
      StatusErr = true.
      return no.
    end.
    
    do trans:
    
      os-delete "TTNAct.xml".
      assign
        inFileName = "TTNAct.xml"
      .
      
      output stream outstr to value ("QueryAPSingle.xml") convert target "UTF-8". 
      
      outData = substitute ({&xml}, entry (1, parameters, {&delim-par}), entry (2, parameters, {&delim-par})).
      
      put stream outstr unformatted outData.
      put stream outstr skip.
      output stream outstr close.
  
      cmd = substitute ("&1 --connect-timeout 1 -F xml_file=@&2 &3/opt/in/WayBillAct >&4", search ("exe/curl.exe"), search ("QueryAPSingle.xml"), ConPar, inFileName).
      os-command value (cmd).
         
      file-info:file-name = search (inFileName).
      if search (inFileName) <> ? and file-info:file-size > 0 
      then do:
        def var respValue as handle no-undo.
        respValue = ParseRequest (inFileName).
        if respValue = ? 
        then do:
          assign
            StatusErr = true
            Msg = "Не удалось разобрать данные от UTM"
          .
          undo, return false. 
        end.
        if not StatusErr 
          then 
            ReplyId = respValue:node-value.
          else do:
            assign
              StatusErr = true
              Msg = respValue:node-value
            .
            undo, return false. 
          end.
      end.
      else do:
        assign
          StatusErr = true
          Msg = "Не удалось получить данные от UTM"
        .
        undo, return false.
      end.

      if not WriteDbStatus (3, parameters , ReplyId, false)
      then do: 
        assign
          StatusErr = true
          Msg = "Не удалось записать данные о запросе в БД. Запрос не выполен."
        .
        undo, return false.
      end.

    end.
    
    

  end.


  method protected handle ParseRequest (inFileName as char):
    
    define variable hRoot as handle  no-undo.
    define variable hDoc  as handle  no-undo.
    define variable hRow  as handle  no-undo.
    define variable hText as handle  no-undo.
    define variable ii    as integer no-undo.
    
    create x-document hDoc.
    create x-noderef  hRoot.
    create x-noderef  hRow.
    create x-noderef htext .
    
    hDoc:load ("file", inFileName, false).
    hDoc:encoding = "UTF-8".
    hDoc:get-document-element(hRoot) .
    
    do ii = 1 to hRoot:num-children:
      hRoot:get-child(hRow,ii).
      case hRow:name:
        when "url" then
          do:
            hRow:get-child (hText, 1) no-error.
            return hText.
          end.
        when "error" then
          do:
            hRow:get-child (hText, 1) no-error.
            StatusErr = true.
            return hText.
          end.
        otherwise 
          do:
            return ?.
          end.
      end case.
    end.


  end.

  method public override handle GetHndlTable(inTableType as int, inWbIndenty as char) :

    assign
      StatusErr = false
      Msg       = ""
      .
    
    if inWbIndenty = "AllWB"
    then do: 
      GetWBUTM().
      return ?.
    end.
    
    case inTableType:
      when {&wb-header} or 
      when {&wb-line} then 
        do:
          if true /*not (available (buf_clob-bind) and buf_clob-bind.uniq-key-rec = {&lob-egais-wb} + "," + inWbIndenty)*/
            then 
          do:
            find first buf_clob-bind exclusive-lock where buf_clob-bind.uniq-key-rec = {&lob-egais-wb} + "," + inWbIndenty no-error.
            if not available (buf_clob-bind) then 
            do:
              Msg = "Не найдена накладная с идентификатором " + inWbIndenty.
              StatusErr = true.
              return ?.
            end.
            find first buf_clob-data exclusive-lock where buf_clob-data.db-num = buf_clob-bind.db-num and buf_clob-data.int64-id = buf_clob-bind.int64-id no-error.
            ParseResponse("", inTableType).
            find first tt-wb-header.
            find first ub.ext-classif where ub.ext-classif.CharKey_Three = tt-wb-header.regID-Ship no-error.
            if available (ub.ext-classif)
              then 
            do:
              find first ub.clients no-lock where 
                ub.clients.obj-type = entry(2, ub.ext-classif.uniq-key-rec, {&delim-key}) and 
                ub.clients.obj-code = integer(entry(3, ub.ext-classif.uniq-key-rec, {&delim-key})).
              
              if available (ub.clients) then do:
                assign
                  tt-wb-header.cli-type = ub.clients.obj-type
                  tt-wb-header.cli-code = ub.clients.obj-code
                  tt-wb-header.client = ub.clients.obj-type + string (ub.clients.obj-code)
                .
              end.
            end.

            find first ub.ext-classif where ub.ext-classif.CharKey_Three = tt-wb-header.regID-Cons no-error.
            if available (ub.ext-classif)
              then 
            do:
              find first ub.clients no-lock where 
                ub.clients.obj-type = entry(2, ub.ext-classif.uniq-key-rec, {&delim-key}) and 
                ub.clients.obj-code = integer(entry(3, ub.ext-classif.uniq-key-rec, {&delim-key})).
              
              if available (ub.clients) then do:
                assign
                  tt-wb-header.obj-type = ub.clients.obj-type
                  tt-wb-header.obj-code = ub.clients.obj-code
                  tt-wb-header.clientCons = ub.clients.obj-type + string (ub.clients.obj-code)
                .
              end.
            end.

            for each tt-wb-gds-EG:
              find first ub.ext-classif where ub.ext-classif.charkey_one = tt-wb-gds-EG.alc-code no-error.
              if available (ub.ext-classif)
                then tt-wb-gds-EG.gds-code = ub.ext-classif.Key#_One.
              else tt-wb-gds-EG.gds-code = ?.
            end.
            
          end.
          if inTableType = {&wb-header} then 
          do:
            return buffer tt-wb-header:handle.
          end.
          else 
          do:
            return buffer tt-wb-gds-EG:handle.
          end.
        end.
      when {&wb-clob} then 
        do:
          empty temp-table tt-wb-clob-hndls.
          for each buf_clob-bind where buf_clob-bind.resource-type = {&lob-egais-wb}:
            /*          v-info = string (tt-wb-header.wb-date) + {&delim-par} + tt-wb-header.num + {&delim-par} + tt-wb-info-client.regID + {&delim-par} + tt-wb-header.indenty.*/
            create tt-wb-clob-hndls.
            assign
              tt-wb-clob-hndls.wb-date    = date (entry (1, buf_clob-bind.descr, {&delim-par}))
              tt-wb-clob-hndls.num        = entry (2, buf_clob-bind.descr, {&delim-par})
              tt-wb-clob-hndls.shippregid = entry (3, buf_clob-bind.descr, {&delim-par})
              tt-wb-clob-hndls.indenty    = entry (4, buf_clob-bind.descr, {&delim-par})
              .
            return buffer tt-wb-clob-hndls:handle.
          end.
        end.
    end case.

    


    
  end.
  
  method private void GetWBUTM ():
    
    define variable hRoot as handle  no-undo.
    define variable hDoc  as handle  no-undo.
    define variable hRow  as handle  no-undo.
    define variable hText as handle  no-undo.
    define variable ii    as integer no-undo.
    
    define variable v-part-num    as integer   no-undo .
    define variable v-clob-db-num as integer   no-undo .
    define variable v-int64-id    as int64     no-undo .
    define variable v-info        as character no-undo .

    
    
    create x-document hDoc.
    create x-noderef  hRoot.
    create x-noderef  hRow.
    create x-noderef  hText.
    
    
    assign
      inFileName = "ReceiptListOfQuery.xml"
    .
    if search ("ReceiptListOfQuery.xml") <> ? then os-delete value (inFileName).
    if search (inFileName) <> ? then os-delete value (inFileName).
    

    cmd = substitute ("&1 --connect-timeout &2 -X GET &3/opt/out?refresh=true >&4",search ("exe/curl.exe"), TimeOut, ConPar, inFileName).
    os-command value (cmd).
       
    file-info:file-name = search (inFileName).
    if search (inFileName) = ? or file-info:file-size = 0 
    then do:
      assign
        StatusErr = true
        Msg = "Не удалось получить данные от UTM"
      .
      return.
    end.
    hDoc:load ("file", inFileName, false).
    hDoc:get-document-element(hRoot) .
    
    do ii = 1 to hRoot:num-children:
      hRoot:get-child(hRow,ii).
      case hRow:name:
        when "url" then
          do:
              hRow:get-child (hText, 1) no-error.
              if hText:node-value matches "*opt/out/WayBill*"
              then do:
                os-delete "WayBill.xml".
                assign
                  inFileName = "WayBill.xml"
                .
                cmd = substitute ("&1 --connect-timeout &2 -X GET &3 >&4", search ("exe/curl.exe"), TimeOut, hText:node-value, inFileName).
                os-command value (cmd).
                ParseResponse(inFileName, {&wb-clob}).
                find first tt-wb-header no-error.
                if not available (tt-wb-header) then do:
                  Msg = 'Ошибка обработки xml'.
                  StatusErr = true.
                  return.
                end.
                find first tt-wb-info-client where tt-wb-info-client.wb-type-client = "Shipper".
                v-info = string (tt-wb-header.wb-date) + {&delim-par} + tt-wb-header.num + {&delim-par} + tt-wb-info-client.regID + {&delim-par} + tt-wb-header.indenty.
                v-clob-db-num = ?.
                v-int64-id = 0.
                run gbl/file2clb.p ( input {&add-def}
                                    ,input ",no"
                                    ,input ? /*p-bh*/
                                    ,input {&lob-egais-wb} + "," + tt-wb-header.indenty /*p-uniq-key-rec*/
                                    ,input '' /*p-field-*/
                                    ,input v-info /*p-descr*/
                                    ,input-output v-part-num
                                    ,input {&lob-egais-wb}
                                    ,input-output v-clob-db-num
                                    ,input-output v-int64-id
                                    ,input search (inFileName)
                                    ,input '' /*p-src-encoding*/
                                    ) no-error .
                if error-status:error then do:
                  os-delete value (search (inFileName)) no-error.
                  Msg = error-status:get-message(1) + {&new-line} + return-value.
                  StatusErr = true. 
                end.
                os-delete value (search (inFileName)) no-error.
              end.
          end.
      end case.
    end.

  end.

  method override void ParseResponse(inContent as char, inTableType as int):
    empty temp-table tt-wb-header .
    empty temp-table tt-wb-info-client .
    empty temp-table tt-wb-gds-EG .
    define variable hDoc  as handle  no-undo.
    define variable hRoot as handle  no-undo.
    define variable content as longchar no-undo.
    define variable v-longchar as longchar no-undo.
                
    create x-document hDoc.
    create x-noderef hRoot.

    copy-lob
    from  object buf_clob-data.cdata
    to  object v-longchar
    convert target codepage 'utf-8'
    no-error .

    content = codepage-convert (v-longchar, '1251', 'utf-8') .

    
    hDoc:encoding = 'utf-8'.
    
    case inTableType:
      when {&wb-header} or when {&wb-line} then do:
        hDoc:load("longchar", content, false).
      end.
      when {&wb-clob} then do:
        hDoc:load("file",inFileName,false).
      end.
    end case.
    

    hDoc:encoding = 'windows-1251'.
           
    hDoc:get-document-element(hRoot).
            
    GetChildren(hRoot, 1, {&wb-clob}).
        
    delete object hDoc.
    delete object hRoot.
            
  end.
    
  method private void GetChildren(hParent as handle, level as integer, inTableType as int):
        
    define variable i          as integer no-undo.
    define variable hNoderef   as handle  no-undo.
    define variable hText      as handle  no-undo.
    define variable nameParent as handle  no-undo.
    define variable good       as logical no-undo.
        
    create x-noderef hNoderef.
    create x-noderef hText .
        
        
    repeat i = 1 to hParent:num-children:
      good = hParent:get-child(hNoderef,i).
      if not good then 
        leave.
      if hNoderef:subtype <> "element" then
        next.
            
      hNoderef:get-child(hText, 1) no-error .    
            
      if hNoderef:name = "ns:FSRAR_ID" then
        assign v-FS-RAR = hText:node-value .       
      case hNoderef:name:
        when "wb:Shipper" then 
        do:
          create tt-wb-info-client .
          tt-wb-info-client.wb-type-client = "Shipper".
        end.
        when "wb:Consignee" then 
        do:
          create tt-wb-info-client .
          tt-wb-info-client.wb-type-client = "Consignee".
        end.
        when "wb:Supplier" then 
        do:
          create tt-wb-info-client .
          tt-wb-info-client.wb-type-client = "Supplier".
        end.
        when "wb:Position" then 
        do:
          create tt-wb-gds-EG .
        end.
      end case.
      if lookup (hParent:name, "wb:Header,ns:WayBill") > 0
      then do: 
        if hNoderef:name = "wb:Identity"     then do:
          create tt-wb-header.
          assign 
            tt-wb-header.indenty = hText:node-value 
            tt-wb-header.ps = "EGAIS wb:Identity " + hText:node-value 
          .
        end.
        if hNoderef:name = "wb:NUMBER" then assign tt-wb-header.num = hText:node-value.
        if hNoderef:name = "wb:Date"         then assign tt-wb-header.wb-date = date (entry (3, hText:node-value, "-") + "." + entry (2, hText:node-value, "-") + "." + entry (1, hText:node-value, "-")) .
        if hNoderef:name = "wb:ShippingDate" then assign tt-wb-header.shippingdate = date (entry (3, hText:node-value, "-") + "." + entry (2, hText:node-value, "-") + "." + entry (1, hText:node-value, "-")) .
        if hNoderef:name = "wb:Type"         then do: 
          case hText:node-value :
            when 'WBInvoiceFromMe' then do:
              assign tt-wb-header.wb-type = {&TDEDT_Pri_Vnesh}.
            end.
          end case.
        end.
        if hNoderef:name = "wb:UnitType"     then assign tt-wb-header.unit-type = hText:node-value .
      end.
      if lookup (hParent:name, "wb:Shipper,wb:Consignee,wb:Supplier") > 0
      then do: 
        if hNoderef:name = "oref:ClientRegId" then do:
          assign 
          tt-wb-info-client.regID = hText:node-value
          tt-wb-header.regID-Ship = hText:node-value when hParent:name = 'wb:Shipper'
          tt-wb-header.regID-Cons = hText:node-value when hParent:name = 'wb:Consignee'
          .
        end.
        if hNoderef:name = "oref:INN"         then assign tt-wb-info-client.inn = hText:node-value .
        if hNoderef:name = "oref:KPP"         then assign tt-wb-info-client.kpp = hText:node-value .
        if hNoderef:name = "oref:FullName"    then assign tt-wb-info-client.obj-name-egais = hText:node-value .
        if hNoderef:name = "oref:Country"     then assign tt-wb-info-client.country = hText:node-value .
        if hNoderef:name = "oref:Index"       then assign tt-wb-info-client.postIndex = hText:node-value .
        if hNoderef:name = "oref:RegionCode"  then assign tt-wb-info-client.regionCode = hText:node-value .
        if hNoderef:name = "oref:area"        then assign tt-wb-info-client.district = hText:node-value . 
        if hNoderef:name = "oref:city"        then assign tt-wb-info-client.city = hText:node-value .       
        if hNoderef:name = "oref:place"       then assign tt-wb-info-client.settlement = hText:node-value .
        if hNoderef:name = "oref:street"      then assign tt-wb-info-client.street = hText:node-value .
        if hNoderef:name = "oref:house"       then assign tt-wb-info-client.house-number = hText:node-value .  
        if hNoderef:name = "oref:building"    then assign tt-wb-info-client.house-case = hText:node-value .
        if hNoderef:name = "oref:liter"       then assign tt-wb-info-client.house-litera = hText:node-value .  
        if hNoderef:name = "oref:description" then assign tt-wb-info-client.description_ = hText:node-value .    
      end.
      if lookup (hParent:name, "wb:Position,wb:Product") > 0
      then do:
        if hNoderef:name = "pref:ShortName"    then assign tt-wb-gds-EG.gds-name        = codepage-convert (hText:node-value, '1251', 'utf-8') .
        if hNoderef:name = "pref:AlcCode"      then assign tt-wb-gds-EG.alc-code        = codepage-convert (hText:node-value, '1251', 'utf-8') .
        if hNoderef:name = "pref:Capacity"     then assign tt-wb-gds-EG.ms-base         = decimal(hText:node-value) .
        if hNoderef:name = "pref:AlcVolume"    then assign tt-wb-gds-EG.proof           = decimal(hText:node-value) .
        if hNoderef:name = "pref:ProductVCode" then assign tt-wb-gds-EG.alc-type-code   = codepage-convert (hText:node-value, '1251', 'utf-8') .
        if hNoderef:name = "wb:Identity"       then assign tt-wb-gds-EG.Identity        = integer(hText:node-value) .
        if hNoderef:name = "wb:Price"          then assign tt-wb-gds-EG.price           = decimal(hText:node-value) .
        if hNoderef:name = "wb:Quantity"       then assign tt-wb-gds-EG.doc-qnty        = decimal(hText:node-value) .
      end.

      GetChildren(hNoderef, (level + 1), inTableType).
    end.


    delete object hNoderef.
    delete object hText.
  end.

  method override public void SaveWB (inWbIndenty as char):
    
    find first buf_clob-bind exclusive-lock where buf_clob-bind.uniq-key-rec = {&lob-egais-wb} + "," + inWbIndenty no-error.
    if not available (buf_clob-bind) then 
    do:
      Msg = "Не найдена накладная с идентификатором " + inWbIndenty.
      StatusErr = true.
    end.
    
    run ibs/th/bge/egais/AdapteeEGAISProcOra-i516.p
      (
      input table tt-wb-header,
      input table tt-wb-gds-EG,
      input User_Id
      ) .
    
    if error-status:error then do:
      Msg = return-value.
      StatusErr = true.
    end.
    
  end.


end class.



