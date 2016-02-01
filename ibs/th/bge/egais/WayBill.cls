 
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
  { ref/extclass.i }

&scop xml-act-1 '<?xml version="1.0" encoding="UTF-8"?>~
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
<wa:WBRegId>&5</wa:WBRegId>~
<wa:Note>&6</wa:Note>~
</wa:Header>~
<wa:Content>'

&scop xml-act-2 '</wa:Content></ns:WayBillAct>~
</ns:Document>~
</ns:Documents>'

&scop xml-wb1 '<?xml version="1.0" encoding="UTF-8"?>~
<ns:Documents Version="1.0"~
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"~
xmlns:ns= "http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01"~
xmlns:c="http://fsrar.ru/WEGAIS/Common"~
xmlns:oref="http://fsrar.ru/WEGAIS/ClientRef"~
xmlns:pref="http://fsrar.ru/WEGAIS/ProductRef"~
xmlns:wb= http://fsrar.ru/WEGAIS/TTNSingle>~
<!--Кто подает документы-->~
<ns:Owner>~
<!--Идентификатор организации в ФС РАР-->~
<ns:FSRAR_ID>&1</ns:FSRAR_ID>~
</ns:Owner>~
<!--Накладная на отгрузку-->~
<ns:Document>~
<ns:WayBill>~
<wb:Identity>&2</wb:Identity>~
<wb:Header>~
<!--номерТТН-->~
<wb:NUMBER>&3</wb:NUMBER>~
<!--Дата составления ТТН-->~
<wb:Date>&4</wb:Date>~
<!--Дата отгрузки продукции-->~
<wb:ShippingDate>&5</wb:ShippingDate>~
<!--типТТН-->~
<wb:Type>WBInvoiceFromMe</wb:Type>~
<wb:UnitType>&6</wb:UnitType>~
<wb:Shipper>~
<oref:INN>&7</oref:INN>~
<oref:KPP>&8</oref:KPP>~
<oref:ClientRegId>&9</oref:ClientRegId>~
<oref:FullName></oref:FullName>~
<oref:ShortName></oref:ShortName>~
<oref:address>~
<oref:Country></oref:Country>~
<oref:Index></oref:Index>~
<oref:RegionCode></oref:RegionCode>~
<oref:area></oref:area>~
<oref:city></oref:city>~
<oref:place></oref:place>~
<oref:street></oref:street>~
<oref:house></oref:house>~
<oref:building></oref:building>~
<oref:liter></oref:liter>~
<oref:description></oref:description>~
</oref:address>~
</wb:Shipper>~'

&scop xml-wb2 '<!--получатель (обязательно)-->~
<wb:Consignee>~
<oref:INN>&1</oref:INN>~
<oref:KPP>&2</oref:KPP>~
<oref:ClientRegId>&3</oref:ClientRegId>~
<oref:FullName></oref:FullName>~
<oref:ShortName></oref:ShortName>~
<oref:address>~
<oref:Country></oref:Country>~
<oref:Index></oref:Index>~
<oref:RegionCode></oref:RegionCode>~
<oref:area></oref:area>~
<oref:city></oref:city>~
<oref:place></oref:place>~
<oref:street></oref:street>~
<oref:house></oref:house>~
<oref:building></oref:building>~
<oref:liter></oref:liter>~
<oref:description></oref:description>~
</oref:address>~
</wb:Consignee>~
<wb:Supplier>~
<oref:INN></oref:INN>~
<oref:KPP></oref:KPP>~
<oref:ClientRegId></oref:ClientRegId>~
<oref:FullName></oref:FullName>~
<oref:ShortName></oref:ShortName>~
<oref:address>~
<oref:Country></oref:Country>~
<oref:Index></oref:Index>~
<oref:RegionCode></oref:RegionCode>~
<oref:area></oref:area>~
<oref:city></oref:city>~
<oref:place></oref:place>~
<oref:street></oref:street>~
<oref:house></oref:house>~
<oref:building></oref:building>~
<oref:liter></oref:liter>~
<oref:description></oref:description>~
</oref:address>~
</wb:Supplier>~
<wb:Transport>~
<wb:TRAN_TYPE></wb:TRAN_TYPE>~
<wb:TRAN_COMPANY></wb:TRAN_COMPANY>~
<wb:TRAN_CAR></wb:TRAN_CAR>~
<wb:TRAN_TRAILER></wb:TRAN_TRAILER>~
<wb:TRAN_CUSTOMER></wb:TRAN_CUSTOMER>~
<wb:TRAN_DRIVER></wb:TRAN_DRIVER>~
<wb:TRAN_LOADPOINT></wb:TRAN_LOADPOINT>~
<wb:TRAN_UNLOADPOINT></wb:TRAN_UNLOADPOINT>~
<wb:TRAN_REDIRECT></wb:TRAN_REDIRECT>~
<wb:TRAN_FORWARDER></wb:TRAN_FORWARDER>~
</wb:Transport>~
<wb:Base></wb:Base>~
<wb:Note></wb:Note>~
</wb:Header>~
<!--СодержимоеТТН-->~
<wb:Content>~
&12~
</wb:Content>~
</ns:WayBill>~
</ns:Document>~
</ns:Documents>'

&scop xml-wb-cont '<wb:Position>~
<wb:Identity>1</wb:Identity>~
<wb:Product>~
<pref:Type>АП</pref:Type>~
<pref:FullName></pref:FullName>~
<pref:ShortName></pref:ShortName>~
<pref:AlcCode>&1</pref:AlcCode>~
<pref:Capacity>&2</pref:Capacity>~
<pref:AlcVolume>&3</pref:AlcVolume>~
<pref:ProductVCode>&4</pref:ProductVCode>~
<pref:Producer>~
<!--Отечественная-->~
<oref:INN>&5</oref:INN>~
<oref:KPP>&6</oref:KPP>~
<oref:ClientRegId>&7</oref:ClientRegId>~
<oref:FullName></oref:FullName>~
<oref:ShortName></oref:ShortName>~
<oref:address>~
<oref:Country></oref:Country>~
<oref:Index></oref:Index>~
<oref:RegionCode></oref:RegionCode>~
<oref:area></oref:area>~
<oref:city></oref:city>~
<oref:place></oref:place>~
<oref:street></oref:street>~
<oref:house></oref:house>~
<oref:building></oref:building>~
<oref:liter></oref:liter>~
<oref:description></oref:description>~
</oref:address>~
</pref:Producer>~
</wb:Product>~
<!--Количество - шт для фасованной, Дал для нефасованной-->~
<wb:Quantity>&8</wb:Quantity>~
<!--цена (обязательно?)-->~
<wb:Price>&9</wb:Price>~
<wb:Pack_ID>&10</wb:Pack_ID>~
<!--Номерпартии-->~
<wb:Party></wb:Party>~
<wb:InformA>~
<!--Обязательный регистрационный номер справки А-->~
<pref:RegId></pref:RegId>~
</wb:InformA>~
<wb:InformB>~
<!--Раздел Б - ид записи предыдущей отгрузки (по которому продукция поступила на склад)-->~
<pref:InformBItem>~
<pref:BRegId>&11</pref:BRegId>~
</pref:InformBItem>~
</wb:InformB>~
</wb:Position>'

  define stream outstr.
  
  define private buffer buf_clob-bind     for ub.clob-bind.
  define private buffer buf_clob-data     for ub.clob-data.
  define private buffer buf_gds           for ub.goods.
  define private buffer buf_trn-doc       for ub.trn-doc.
  define private buffer buf_doc-attr      for ub.doc-attr.
  define private buffer buf_parts         for ub.parts.
  define private buffer buf_doc-line      for ub.doc-line.
  define private buffer buf_doc-line-attr for ub.doc-line-attr.
  define private buffer buf_clients       for ub.clients.
  define private buffer buf_clients-attr  for ub.clients-attr.
  define private buffer buf_firm          for ub.firm.
  define private buffer buf_shop          for ub.shop.
  define private buffer buf_store         for ub.store.
  define private buffer buf_ext-classif   for ub.ext-classif.
  define private buffer X_ext-classif     for ub.ext-classif.
  define private variable parameters     as character no-undo.
  define private variable inFileName     as character no-undo.
  define private variable inData         as character no-undo.
  define private variable outData        as character no-undo.
  define private variable cmd            as character no-undo.
  define private variable urlResp        as character no-undo.
  define private variable v-uniq-key-rec as character no-undo.
  define private variable nn             as integer   no-undo.

  define         variable v-FS-RAR       as character no-undo .
  define         variable inDocFSRAR     as character no-undo .
  define         variable v-ext-sys      as integer   no-undo .
  define         variable ObjType        as character no-undo .
  define         variable ObjCode        as integer   no-undo .
  
  define property HndlHeader as handle no-undo
    get.
    private set. 
  
  define property HndlLine as handle no-undo
    get.
    private set.

  define temp-table tt-wb-hndls no-undo
    field num          as character label "№ накл." format "X(50)"
    field wb-date      as date      label "Дата"
    field obj          as character label "Объект"
    field shippregid   as character label "ID поставщика" format "x(21)"
    field cliname      as character label "Контрагент" format "x(30)"
    field wb-type      as character label "Тип" format "x(10)"
    field trn-doc-code as character label "№ накл. TH"
    field status_      as character label "Статус"
    field is-sent      as character label "Отправлена"
    field wbregid      as character label "ID EGAIS" format "X(50)"
    field Identity     as character format "X(50)"
    field uniq-key-rec as character format "X(50)"
    index pi
    Identity 
    .

  define temp-table tt-wb-act-hndls no-undo
    field num          as character label "№ акта"
    field act-date     as date      label "Дата"
    field status_      as character label "Статус"
    field wbregid      as character label "ID накл. EGAIS" format "X(21)"
    index pi
    wbregid
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

  define temp-table tt-ticket no-undo
    field regid        as character label "RegId документа" format "X(21)"
    field doc          as character label "Документ" format "X(10)"
    field ticket-date  as character label "Дата" format "X(10)"
    field status_      as character label "Статус"
    field comment      as character label "Коментарий" format "X(40)"
    field docId        as character label "DocId" format "X(40)"
    index pi 
    regid 
    .

  constructor public WayBill (inOjType as char, inObjCode as int, inFSRAR as char, inExtSys as integer):
    
    /*    assign                 */
    /*      parameters = inFSRAR.*/
    /*    .                      */
    super (inOjType, inObjCode).
    ObjCode = inObjCode.
    ObjType = inOjType.
    v-FS-RAR = inFSRAR.
    v-ext-sys = inExtSys.
    IsSent.
    
  end constructor.
  
  method public override handle GetHndlTable(inTableType as int, inWbIdentity as char) :

    assign
      StatusErr = false
      Msg       = ""
      .
    
    if inWbIdentity = "AllWB"
      then 
    do: 
      GetWBUTM().
      if StatusErr
        then return ?.
      return ?.
    end.
    
    case inTableType:
      when {&wb-header} or 
      when {&wb-line} then 
        do:
          if true /*not (available (buf_clob-bind) and inWbIdentity)*/
            then 
          do:
            if inTableType = {&wb-header}
              then empty temp-table tt-wb-header.
              else empty temp-table tt-wb-gds-EG.
            find first buf_clob-bind exclusive-lock where buf_clob-bind.uniq-key-rec = inWbIdentity and buf_clob-bind.field-name_ = {&lob-egais-wb} no-error.
            if not available (buf_clob-bind) then 
            do:
              find first buf_clob-bind exclusive-lock where num-entries (inWbIdentity, {&delim-cmd}) = 4 and entry (1, buf_clob-bind.uniq-key-rec, {&delim-cmd}) = entry (4, inWbIdentity, {&delim-cmd}) and entry (2, buf_clob-bind.uniq-key-rec, {&delim-cmd}) = entry (3, inWbIdentity, {&delim-cmd}) and buf_clob-bind.field-name_ = {&lob-egais-wb} no-error.
              if not available (buf_clob-bind) then 
              do:
                Msg = "Не найдена накладная с идентификатором " + inWbIdentity.
                StatusErr = true.
                return ?.
              end.
            end.
            v-uniq-key-rec = buf_clob-bind.uniq-key-rec.
            find first buf_clob-data exclusive-lock where buf_clob-data.db-num = buf_clob-bind.db-num and buf_clob-data.int64-id = buf_clob-bind.int64-id no-error.

            ParseResponse("", inTableType).
            find first tt-wb-header.
            find first buf_ext-classif no-lock where buf_ext-classif.classif-subject = {&table_clients}
              and buf_ext-classif.classif-name = {&extclass_clients_esys}
              and buf_ext-classif.db-num = 0
              and buf_ext-classif.key#_one = v-ext-sys
              and buf_ext-classif.CharKey_Three = tt-wb-header.regID-Ship no-error.
            if available (buf_ext-classif)
              then 
            do:
              find first ub.clients no-lock where 
                ub.clients.obj-type = entry(2, buf_ext-classif.uniq-key-rec, {&delim-key}) and 
                ub.clients.obj-code = integer(entry(3, buf_ext-classif.uniq-key-rec, {&delim-key})).
              
              if available (ub.clients) then 
              do:
                assign
                  tt-wb-header.cli-type = ub.clients.obj-type
                  tt-wb-header.cli-code = ub.clients.obj-code
                  tt-wb-header.client   = ub.clients.obj-type + string (ub.clients.obj-code)
                  .
              end.
            end.
           
            find first buf_ext-classif no-lock where buf_ext-classif.classif-subject = {&table_clients}
              and buf_ext-classif.classif-name = {&extclass_clients_esys}
              and buf_ext-classif.db-num = 0
              and buf_ext-classif.key#_one = v-ext-sys
              and buf_ext-classif.CharKey_Three = tt-wb-header.regID-Cons and buf_ext-classif.CharKey_Two = entry (9, buf_clob-bind.descr, {&delim-par}) no-error.
            
            if available (buf_ext-classif)
              then 
            do:
              find first ub.clients no-lock where 
                ub.clients.obj-type = entry(2, buf_ext-classif.uniq-key-rec, {&delim-key}) and 
                ub.clients.obj-code = integer(entry(3, buf_ext-classif.uniq-key-rec, {&delim-key})).
              
              if available (ub.clients) then 
              do:
                assign
                  tt-wb-header.obj-type   = ub.clients.obj-type
                  tt-wb-header.obj-code   = ub.clients.obj-code
                  tt-wb-header.clientCons = ub.clients.obj-type + string (ub.clients.obj-code)
                  .
              end.
            end.

            for each tt-wb-gds-EG:
              find first X_ext-classif no-lock where X_ext-classif.classif-subject = {&table_goods} 
                and X_ext-classif.classif-name = {&extclass_goods_esys} 
                and x_ext-classif.db-num = 0  
                and X_ext-classif.key#_two = v-ext-sys 
                and X_ext-classif.CharKey_One = tt-wb-gds-EG.alc-code no-error.

              if available (X_ext-classif)
                then tt-wb-gds-EG.gds-code = X_ext-classif.Key#_One.
              else tt-wb-gds-EG.gds-code = ?.
            end.
/*            v-uniq-key-rec = inWbIdentity.*/
            find first buf_clob-bind exclusive-lock where buf_clob-bind.uniq-key-rec = v-uniq-key-rec and buf_clob-bind.field-name_ = {&lob-egais-ref-b} no-error.
            if available (buf_clob-bind) then 
            do:
              find first buf_clob-data exclusive-lock where buf_clob-data.db-num = buf_clob-bind.db-num and buf_clob-data.int64-id = buf_clob-bind.int64-id no-error.
              ParseResponse("", {&wb-refB}).
            end.
            find first buf_clob-bind exclusive-lock where buf_clob-bind.uniq-key-rec = v-uniq-key-rec and buf_clob-bind.field-name_ = {&lob-egais-wb} no-error.
            
          end.
          HndlHeader = buffer tt-wb-header:handle.
          HndlLine = buffer tt-wb-gds-EG:handle.
          if inTableType = {&wb-header} then 
          do:
            return buffer tt-wb-header:handle.
          end.
          else 
          do:
            return buffer tt-wb-gds-EG:handle.
          end.
        end.
      when {&wb-act-header} or 
      when {&wb-act-line} then 
        do:
          if true /*not (available (buf_clob-bind) and inWbIdentity)*/
            then 
          do:
            if inTableType = {&wb-act-header}
              then empty temp-table tt-wb-act-header.
              else empty temp-table tt-wb-act-gds-EG.
            find first buf_clob-bind exclusive-lock where buf_clob-bind.uniq-key-rec = inWbIdentity and buf_clob-bind.field-name_ = {&lob-egais-wb-act} no-error.
            if not available (buf_clob-bind) then 
            do:
              Msg = "Не найден акт с идентификатором " + inWbIdentity.
              StatusErr = true.
              return ?.
            end.
            find first buf_clob-data exclusive-lock where buf_clob-data.db-num = buf_clob-bind.db-num and buf_clob-data.int64-id = buf_clob-bind.int64-id no-error.
            ParseResponse("", inTableType).
            find first tt-wb-act-header.
            
            find first buf_doc-attr no-lock where buf_doc-attr.attr-code = {&trdcattr-negais} and buf_doc-attr.attr-value begins tt-wb-act-header.wbregid no-error.
            if available (buf_doc-attr) then do:
              find first buf_trn-doc no-lock where buf_trn-doc.doc-code = buf_doc-attr.doc-code.
              
              for each tt-wb-act-gds-EG :
                
                find first buf_parts no-lock where
                 buf_parts.obj-type = buf_trn-doc.obj-type and 
                 buf_parts.obj-code = buf_trn-doc.obj-code and 
                 buf_parts.in-code = buf_trn-doc.doc-code and
                 buf_parts.out-code = buf_trn-doc.doc-code and
                 tt-wb-act-gds-EG.refB = entry (2, buf_parts.alc-ref-ab-path, ",") no-error.
                
                /*if not available (buf_parts)
                  then do:
                    message substitute ("Не найдена партия для товара из акта") view-as alert-box. 
                  end.*/

                if available (buf_parts) then do:
                  find first buf_gds no-lock where buf_gds.artic = buf_parts.artic and buf_gds.prod-code = buf_parts.prod-code and buf_gds.prod-type = buf_parts.prod-type.
                  assign
                    tt-wb-act-gds-EG.doc-qnty = buf_parts.qnty
                    tt-wb-act-gds-EG.fact-qnty = buf_parts.fact-qnty
                    tt-wb-act-gds-EG.gds-code = buf_gds.gds-code
                  .
                end.
                else do:
                  assign
                    tt-wb-act-gds-EG.doc-qnty = ?
                    tt-wb-act-gds-EG.fact-qnty = ?
                    tt-wb-act-gds-EG.gds-code = ?
                  .
                end.
              end.
              
            end.
            
          end.
          HndlHeader = buffer tt-wb-header:handle.
          HndlLine = buffer tt-wb-gds-EG:handle.
          if inTableType = {&wb-act-header} then 
          do:
            return buffer tt-wb-act-header:handle.
          end.
          else 
          do:
            return buffer tt-wb-act-gds-EG:handle.
          end.
        end.
      when {&wb-clob} then 
        do:
          empty temp-table tt-wb-hndls.
          for each buf_clob-bind where buf_clob-bind.field-name_ = {&lob-egais-wb}:
            /*v-info = string (tt-wb-header.wb-date) + {&-par} + tt-wb-header.num + {&-par} + tt-wb-info-client.regID + {&-par} + tt-wb-header.Identity + {&-par} + string (tt-wb-header.wbregid) + {&-par} + "нет" + {&-par} + "нет" + {&-par}.*/
            if entry (9, buf_clob-bind.descr, {&delim-par}) <> "" and entry (9, buf_clob-bind.descr, {&delim-par}) <> ObjType + string (ObjCode)
              then next.
            create tt-wb-hndls.
            assign
              tt-wb-hndls.wb-date      = date (entry (1, buf_clob-bind.descr, {&delim-par}))
              tt-wb-hndls.num          = entry (2, buf_clob-bind.descr, {&delim-par})
              tt-wb-hndls.shippregid   = entry (3, buf_clob-bind.descr, {&delim-par})
              tt-wb-hndls.Identity     = entry (4, buf_clob-bind.descr, {&delim-par})
              tt-wb-hndls.trn-doc-code = entry (6, buf_clob-bind.descr, {&delim-par})
              tt-wb-hndls.is-sent      = entry (7, buf_clob-bind.descr, {&delim-par})
              tt-wb-hndls.wb-type      = "приход вн."  
              when entry (8, buf_clob-bind.descr, {&delim-par}) = {&TDEDT_Pri_Vnesh}
              tt-wb-hndls.obj          = entry (9, buf_clob-bind.descr, {&delim-par}) 
              tt-wb-hndls.uniq-key-rec = buf_clob-bind.uniq-key-rec.
            .
            find first ub.ext-classif no-lock 
              where ub.ext-classif.classif-subject = {&table_clients}
                and ub.ext-classif.classif-name = {&extclass_clients_esys}
                and ub.ext-classif.db-num = 0
                and ub.ext-classif.key#_one = v-ext-sys
                and ub.ext-classif.CharKey_Three = tt-wb-hndls.shippregid
                no-error.
            if available (ub.ext-classif) then do:
              find first buf_clients where buf_clients.obj-type = entry (2, ub.ext-classif.uniq-key-rec, {&delim-key}) and buf_clients.obj-code = integer (entry (3, ub.ext-classif.uniq-key-rec, {&delim-key})) no-error.
              if available (buf_clients)
                then do: 
                  tt-wb-hndls.cliname = buf_clients.obj-name.
                end.
            end.
            assign 
              tt-wb-hndls.wbregid = entry (5, buf_clob-bind.descr, {&delim-par}) no-error.
            find first buf_trn-doc where buf_trn-doc.doc-code = tt-wb-hndls.trn-doc-code no-error.
            if available (buf_trn-doc)
              then tt-wb-hndls.status_ = buf_trn-doc.status_.
          end.
          return buffer tt-wb-hndls:handle.
        end.
      when {&wb-clob-act} then 
        do:
          empty temp-table tt-wb-act-hndls.
          for each buf_clob-bind where buf_clob-bind.field-name_ = {&lob-egais-wb-act}:
            /*v-info = string (tt-wb-header.wb-date) + {&-par} + tt-wb-header.num + {&-par} + tt-wb-info-client.regID + {&-par} + tt-wb-header.Identity + {&-par} + string (tt-wb-header.wbregid) + {&-par} + "нет" + {&-par} + "нет" + {&-par}.*/
            if num-entries (buf_clob-bind.descr, {&delim-par}) > 4 then do:
              if v-FS-RAR <> entry (5, buf_clob-bind.descr, {&delim-par}) then next.
            end.
            create tt-wb-act-hndls.
            assign
              tt-wb-act-hndls.wbregid  = entry (1, buf_clob-bind.descr, {&delim-par})
              tt-wb-act-hndls.act-date = date (entry (2, buf_clob-bind.descr, {&delim-par}))
              tt-wb-act-hndls.num      = entry (3, buf_clob-bind.descr, {&delim-par})
              tt-wb-act-hndls.status_  = entry (4, buf_clob-bind.descr, {&delim-par})
              .
          end.
          return buffer tt-wb-act-hndls:handle.
        end.
      when {&ticket} then 
        do:
          empty temp-table tt-ticket.
          for each buf_clob-bind where buf_clob-bind.field-name_ = {&lob-egais-ticket} and buf_clob-bind.uniq-key-rec begins inWbIdentity :
            find first buf_clob-data where buf_clob-data.db-num = buf_clob-bind.db-num and buf_clob-data.int64-id = buf_clob-bind.int64-id no-error.
            ParseResponse("", inTableType).
          end.
          return buffer tt-ticket:handle.
        end.
      when {&wb-fact} then 
        do:
          empty temp-table tt-wb-hndls.
          for each buf_doc-attr no-lock where buf_doc-attr.attr-code = {&trdcattr-negais}:
            for each buf_trn-doc no-lock where buf_trn-doc.doc-code = buf_doc-attr.doc-code and buf_trn-doc.status_ = {&fact}:
              if ObjCode <> buf_trn-doc.obj-code or ObjType <> buf_trn-doc.obj-type
                then next.
              /*              define variable v-obj-uniq-key-rec as character no-undo .
                            find first buf_clients no-lock where buf_clients.obj-type = buf_trn-doc.cli-type and buf_clients.obj-code = buf_trn-doc.cli-code .
                            run gen-key-rec in this-procedure   ( input {&table_clients}
                                                                 ,input buffer buf_clients:handle
                                                                 ,output v-obj-uniq-key-rec).
                            find first buf_ext-classif exclusive-lock  where buf_ext-classif.classif-subject = {&table_clients}
                                                                       and buf_ext-classif.classif-name = {&extclass_clients_esys}
                                                                       and buf_ext-classif.db-num = 0
                                                                       and buf_ext-classif.key#_one = v-ext-sys
                                                                       and buf_ext-classif.uniq-key-rec = v-obj-uniq-key-rec
                                                                       no-error.*/
              create tt-wb-hndls. 
              assign
                tt-wb-hndls.wb-date      = buf_trn-doc.doc-date
                tt-wb-hndls.num          = buf_trn-doc.doc-code
                tt-wb-hndls.trn-doc-code = buf_trn-doc.doc-code
                tt-wb-hndls.shippregid   = buf_trn-doc.cli-type + string (buf_trn-doc.cli-code)
                tt-wb-hndls.uniq-key-rec = buf_doc-attr.attr-value
                tt-wb-hndls.status_      = buf_trn-doc.status_
                tt-wb-hndls.wbregid      = entry (1, buf_doc-attr.attr-value, {&delim-cmd}) no-error.
                entry (1, tt-wb-hndls.uniq-key-rec, {&delim-cmd}) = "".
                tt-wb-hndls.uniq-key-rec = left-trim (tt-wb-hndls.uniq-key-rec, {&delim-cmd}).
                
            end.
          end.
          return buffer tt-wb-hndls:handle.
        end.
      when {&wb-ras} then 
        do:
          empty temp-table tt-wb-hndls.
          for each buf_ext-classif no-lock where buf_ext-classif.classif-subject = {&table_clients}
            and buf_ext-classif.classif-name = {&extclass_clients_esys}
            and buf_ext-classif.db-num = 0
            and buf_ext-classif.key#_one = v-ext-sys:
                                                 
            find first buf_clients no-lock where 
              buf_clients.obj-type = entry(2, buf_ext-classif.uniq-key-rec, {&delim-key}) and
              buf_clients.obj-code = integer(entry(3, buf_ext-classif.uniq-key-rec, {&delim-key})).
            
            for each buf_trn-doc no-lock where buf_trn-doc.obj-code = ObjCode and buf_trn-doc.obj-type = ObjType and 
              buf_trn-doc.cli-code = buf_clients.obj-code and 
              buf_trn-doc.cli-type = buf_clients.obj-type and 
              buf_trn-doc.status_ = {&fact}
              and (buf_trn-doc.ext-doc-type = {&TDEDT_Ras_Vnesh_VP} or buf_trn-doc.ext-doc-type = {&TDEDT_Ras_Perem}) :
              create tt-wb-hndls.
              assign
                tt-wb-hndls.wb-date      = buf_trn-doc.doc-date
                tt-wb-hndls.trn-doc-code = buf_trn-doc.doc-code
                tt-wb-hndls.shippregid   = buf_ext-classif.charkey_three
                tt-wb-hndls.wb-type      = {&TDEDT_Ras_Vnesh_VP-full} when buf_trn-doc.ext-doc-type = {&TDEDT_Ras_Vnesh_VP}
                tt-wb-hndls.wb-type      = {&TDEDT_Ras_Vnesh_VP-full} when buf_trn-doc.ext-doc-type = {&TDEDT_Ras_Perem}
                tt-wb-hndls.status_      = buf_trn-doc.status_.
            end.
          end.
          return buffer tt-wb-hndls:handle.
        end.
      when {&wb-ras-header} or 
      when {&wb-ras-line} then
        do:
          def var ii as int    no-undo.
          
          if inTableType = {&wb-ras-header}
            then empty temp-table tt-wb-header.
          else empty temp-table tt-wb-gds-EG.
          
          find first buf_trn-doc no-lock where buf_trn-doc.doc-code = inWbIdentity no-error.
          
          if not available (buf_trn-doc)
          then do:
            Msg = "Не найдена накладная" + inWbIdentity.
            StatusErr = true.
            return ?.
          end.
          
          create tt-wb-header.
          assign
            tt-wb-header.Identity = buf_trn-doc.doc-code
            tt-wb-header.wb-type = "WBReturnFromMe"
            tt-wb-header.wb-date = buf_trn-doc.fact-date
            tt-wb-header.obj-code = buf_trn-doc.obj-code
            tt-wb-header.obj-type = buf_trn-doc.obj-type
            tt-wb-header.cli-code = buf_trn-doc.cli-code
            tt-wb-header.cli-type = buf_trn-doc.cli-type
          .
          
          find first buf_ext-classif no-lock where buf_ext-classif.classif-subject = {&table_clients}
            and buf_ext-classif.classif-name = {&extclass_clients_esys}
            and buf_ext-classif.db-num = 0
            and buf_ext-classif.key#_one = v-ext-sys
            and buf_ext-classif.CharKey_Two = buf_trn-doc.obj-type + string (buf_trn-doc.obj-code) no-error.
          if not available (buf_ext-classif)
          then do:
            Msg = "Не найден объект ЕГАИС " + inWbIdentity.
            StatusErr = true.
            return ?.
          end.
          tt-wb-header.regID-Ship = buf_ext-classif.CharKey_Three.
          
          find first buf_ext-classif no-lock where buf_ext-classif.classif-subject = {&table_clients}
            and buf_ext-classif.classif-name = {&extclass_clients_esys}
            and buf_ext-classif.db-num = 0
            and buf_ext-classif.key#_one = v-ext-sys
            and buf_ext-classif.uniq-key-rec = {&table_clients} + {&delim-key} + buf_trn-doc.cli-type + {&delim-key} + string (buf_trn-doc.cli-code) no-error.
          if not available (buf_ext-classif)
          then do:
            Msg = "Не найден клиент ЕГАИС " + inWbIdentity.
            StatusErr = true.
            return ?.
          end.
          tt-wb-header.regID-Cons = buf_ext-classif.CharKey_Three.          
          
          for each buf_doc-line no-lock where buf_doc-line.doc-code = buf_trn-doc.doc-code: 
            for each buf_parts no-lock where
              buf_parts.obj-type = buf_trn-doc.obj-type and 
              buf_parts.obj-code = buf_trn-doc.obj-code and 
              buf_parts.artic = buf_doc-line.artic and
              buf_parts.prod-type = buf_doc-line.prod-type and
              buf_parts.prod-code = buf_doc-line.prod-code and
              buf_parts.out-code = buf_trn-doc.doc-code: 
              ii = ii + 1.
              find first buf_gds no-lock where buf_gds.artic = buf_parts.artic and buf_gds.prod-code = buf_parts.prod-code and buf_gds.prod-type = buf_parts.prod-type.
              find first buf_ext-classif no-lock where buf_ext-classif.classif-subject = {&table_goods} 
                                                 and buf_ext-classif.classif-name = {&extclass_goods_esys} 
                                                 and buf_ext-classif.db-num = 0  
                                                 and buf_ext-classif.key#_one = buf_gds.gds-code
                                                 and buf_ext-classif.key#_two = v-ext-sys 
                                                 no-error. 
              create tt-wb-gds-EG.
              assign
                tt-wb-gds-EG.Identity = string (ii)
                tt-wb-gds-EG.gds-name = buf_gds.gds-name
                tt-wb-gds-EG.alc-code = buf_ext-classif.charkey_one
                tt-wb-gds-EG.qnty = buf_parts.fact-qnty
                tt-wb-gds-EG.price = buf_parts.price-rubl
                tt-wb-gds-EG.refA = entry (1, buf_parts.alc-ref-ab-path, ",")
                tt-wb-gds-EG.refB = entry (2, buf_parts.alc-ref-ab-path, ",")
              .
              
            end. 
          end.
          
        end. 
    end case.
    
  end.
  
  method override public logical SendRequestUTM ():
    
    def var ii        as int    no-undo.
    def var xml-cont  as char   no-undo.
    def var respValue as handle no-undo.
    assign
      StatusErr = false
      Msg       = ""
      .
    
    if IsSent 
      then 
    do:
      Msg = "Запрос уже был отправлен".
      StatusErr = true.
      return no.
    end.
    do trans:
    
      os-delete "RespTTNAct.xml".
      assign
        inFileName = "RespTTNAct.xml"
        .
      
      find first tt-wb-hndls no-error.
      
      if available (tt-wb-hndls)
        then 
      do:
        if not (tt-wb-hndls.wb-type matches "*расход*" or tt-wb-hndls.wb-type matches "*возврат*") then 
        do:
          output stream outstr to value ("TTNAct.xml") convert target "UTF-8". 
          outData = GetXMLAct() no-error.
          if outData = ? or outData = ""
          then do:
            return false.
          end.
          
          put stream outstr unformatted outData.
          put stream outstr skip.
          output stream outstr close.
      
          cmd = substitute ("&1 --connect-timeout 1 -F xml_file=@&2 &3/opt/in/WayBillAct >&4", search ("exe/curl.exe"), search ("TTNAct.xml"), ConPar, inFileName).
          os-command value (cmd).
    
          file-info:file-name = search (inFileName).
          if search (inFileName) <> ? and file-info:file-size > 0 
            then 
          do:
            respValue = ParseRequest (inFileName).
            if respValue = ? 
              then 
            do:
              assign
                StatusErr = true
                Msg       = "Не удалось разобрать данные от UTM"
                .
              undo, return false. 
            end.
            if not StatusErr 
              then 
              ReplyId = respValue:node-value.
            else 
            do:
              assign
                StatusErr = true
                Msg       = respValue:node-value
                .
              undo, return false. 
            end.
          end.
          else 
          do:
            assign
              StatusErr = true
              Msg       = "Не удалось отправить акт на накладную в UTM"
              .
            undo, return false.
          end.
          entry (7, buf_clob-bind.descr, {&delim-par}) = "да".
          tt-wb-hndls.is-sent = "да". 
        end.

        else 
        do:
        /*          output stream outstr to value ("TTNSingle.xml") convert target "UTF-8".                                                                                                     */
        /*                                                                                                                                                                                  */
        /*          find first buf_trn-doc where buf_trn-doc.doc-code = tt-wb-hndls.trn-doc-code no-lock.                                                                                   */
        /*                                                                                                                                                                                  */
        /*          for each buf_doc-line no-lock where buf_doc-line.doc-code = tt-wb-hndls.trn-doc-code:                                                                                   */
        /*            find first buf_gds no-lock where buf_gds.artic = buf_doc-line.artic and buf_gds.prod-code = buf_doc-line.prod-code and buf_gds.prod-type = buf_doc-line.prod-type.    */
        /*          end.                                                                                                                                                                    */
        /*                                                                                                                                                                                  */
        /*          def var v-date as character no-undo.                                                                                                                                    */
        /*          v-date = substitute ("&1-&2-&3",string (year (now)), string (month (now)), string (day (now))).                                                                         */
        /*                                                                                                                                                                                  */
        /*          outData = substitute ({&xml-wb1}, '020000367672', tt-wb-hndls.trn-doc-code, tt-wb-hndls.trn-doc-code, v-date, v-date, "Packed", "442351234541", "432143124", "2341234").*/
        /*                                                                                                                                                                                  */
        /*          put stream outstr unformatted outData.                                                                                                                                  */
        /*          put stream outstr skip.                                                                                                                                                 */
        /*          output stream outstr close.                                                                                                                                             */
        /*                                                                                                                                                                                  */
          inFileName = "TTN.xml".
          
          WriteXMLWB (inFileName).
          
          if StatusErr
          then
          do:
            return false.
          end.
          
          cmd = substitute ("&1 --connect-timeout 1 -F xml_file=@&2 &3/opt/in/WayBill >&4", search ("exe/curl.exe"), search (inFileName), ConPar, "RespTTN.xml").
          os-command value (cmd).
          file-info:file-name = search ("RespTTN.xml").
          if search ("RespTTN.xml") <> ? and file-info:file-size > 0
            then
          do:
            respValue = ParseRequest ("RespTTN.xml").
            if respValue = ?
              then
            do:
              assign
                StatusErr = true
                Msg       = "Не удалось разобрать данные от UTM"
                .
              undo, return false.
            end.
            if not StatusErr
              then
              ReplyId = respValue:node-value.
            else
            do:
              assign
                StatusErr = true
                Msg       = respValue:node-value
                .
              undo, return false.
            end.
          end.
          else
          do:
            assign
              StatusErr = true
              Msg       = "Не удалось отправить накладную в UTM"
              .
            undo, return false.
          end.
          entry (7, buf_clob-bind.descr, {&delim-par}) = "да".
          tt-wb-hndls.is-sent = "да".
        
        end.
      end.
    end.      
  end.

  method override protected logical GetIsSent ():
    def var repId as char no-undo.
    def var glog  as log  no-undo.
    glog = CheckCurrentRequest (3, parameters, repId).
    if glog
      then ReplyId = repId.
    return glog.
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
  
  method private void GetWBUTM ():
    
    define variable hRoot         as handle    no-undo.
    define variable hDoc          as handle    no-undo.
    define variable hRow          as handle    no-undo.
    define variable hText         as handle    no-undo.
    define variable ii            as integer   no-undo.
    
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
      then 
    do:
      assign
        StatusErr = true
        Msg       = "Не удалось получить данные от UTM"
        .
      return.
    end.
    hDoc:load ("file", inFileName, false).
    hDoc:get-document-element(hRoot) .
    
    url_:
    do ii = 1 to hRoot:num-children:
      
      hRoot:get-child(hRow,ii).
      
      case hRow:name:
        when "url" then
          do:
            hRow:get-child (hText, 1) no-error.
        
            case true:
              when hText:node-value matches ("*opt/out/WayBill/*") then 
                do:

                  os-delete "WayBill.xml".
                  assign
                    inFileName = "WayBill.xml"
                    .  
                  CmdParseXml(hText:node-value).

                  find first tt-wb-header.
                  find first tt-wb-info-client where tt-wb-info-client.wb-type-client = "Consignee".
                  find first buf_ext-classif no-lock where 
                        buf_ext-classif.classif-subject = {&table_clients}
                    and buf_ext-classif.classif-name = {&extclass_clients_esys}
                    and buf_ext-classif.db-num = 0
                    and buf_ext-classif.key#_one = v-ext-sys
                    and buf_ext-classif.CharKey_Three = tt-wb-info-client.regID no-error.

                  if available (buf_ext-classif) then 
                  do:
                    tt-wb-header.obj-type = entry(2, buf_ext-classif.uniq-key-rec, {&delim-key}).
                    tt-wb-header.obj-code = integer(entry(3, buf_ext-classif.uniq-key-rec, {&delim-key})).
                  end.
                  find first tt-wb-info-client where tt-wb-info-client.wb-type-client = "Shipper".                
                  v-info = string (tt-wb-header.wb-date) + {&delim-par} + tt-wb-header.num + {&delim-par} + tt-wb-info-client.regID + {&delim-par} + tt-wb-header.Identity + {&delim-par} + tt-wb-header.wbregid + {&delim-par} + "нет" + {&delim-par} + "нет" + {&delim-par} + tt-wb-header.wb-type + {&delim-par} + tt-wb-header.obj-type + string (tt-wb-header.obj-code).

                  v-clob-db-num = ?.
                  v-int64-id = 0.
                  if can-find (first buf_clob-bind where (buf_clob-bind.uniq-key-rec = tt-wb-header.uniq-key-rec or buf_clob-bind.uniq-key-rec = tt-wb-header.Identity + {&delim-cmd} + tt-wb-header.regID-Ship) and buf_clob-bind.field-name_ =  {&lob-egais-wb})
                    then next url_.
                  run gbl/file2clb.p ( input {&add-def}
                    ,input ",no"
                    ,input ? /*p-bh*/
                    ,input tt-wb-header.uniq-key-rec /*p-uniq-key-rec*/
                    ,input {&lob-egais-wb} /*p-field-*/
                    ,input v-info /*p-descr*/
                    ,input-output v-part-num
                    ,input {&lob-egais-wb}
                    ,input-output v-clob-db-num
                    ,input-output v-int64-id
                    ,input search (inFileName)
                    ,input '' /*p-src-encoding*/
                    ) no-error .
                  if error-status:error then 
                  do:
                    Msg = error-status:get-message(1) + {&new-line} + return-value.
                    StatusErr = true.
                  end.


                end.
              when hText:node-value matches ("*opt/out/FORMBREGINFO/*") then 
                do:

                  os-delete "FORMBREGINFO.xml".
                  assign
                    inFileName = "FORMBREGINFO.xml"
                    .

                  CmdParseXml(hText:node-value).
                  find first tt-wb-header.
                  v-clob-db-num = ?.
                  v-int64-id = 0.
                  if can-find (first buf_clob-bind where (buf_clob-bind.uniq-key-rec = tt-wb-header.uniq-key-rec or buf_clob-bind.uniq-key-rec = tt-wb-header.Identity + {&delim-cmd} + tt-wb-header.regID-Ship) and buf_clob-bind.field-name_ =  {&lob-egais-ref-b})
                    then next url_.
                  run gbl/file2clb.p ( input {&add-def}
                    ,input ",no"
                    ,input ? /*p-bh*/
                    ,input tt-wb-header.uniq-key-rec /*p-uniq-key-rec*/
                    ,input {&lob-egais-ref-b} /*p-field-*/
                    ,input '' /*p-descr*/
                    ,input-output v-part-num
                    ,input {&lob-egais-ref-b}
                    ,input-output v-clob-db-num
                    ,input-output v-int64-id
                    ,input search (inFileName)
                    ,input '' /*p-src-encoding*/
                    ) no-error .
                  if error-status:error then 
                  do:
                    Msg = error-status:get-message(1) + {&new-line} + return-value.
                    StatusErr = true.
                  end.
  
                end.

              when hText:node-value matches ("*opt/out/WayBillAct/*") then 
                do:
  
                  os-delete "WayBillAct.xml".
                  assign
                    inFileName = "WayBillAct.xml"
                    .
                  CmdParseXml(hText:node-value).
                  find first tt-wb-act-header.
                  v-clob-db-num = ?.
                  v-int64-id = 0.
                  v-info = tt-wb-act-header.wbregid + {&delim-par} + string (tt-wb-act-header.act-date) + {&delim-par} + tt-wb-act-header.num + {&delim-par} + tt-wb-act-header.status_ + {&delim-par} + inDocFSRAR.
                  if can-find (first buf_clob-bind where buf_clob-bind.uniq-key-rec = tt-wb-act-header.wbregid and buf_clob-bind.field-name_ =  {&lob-egais-wb-act})
                    then next url_.
                  run gbl/file2clb.p ( input {&add-def}
                    ,input ",no"
                    ,input ? /*p-bh*/
                    ,input tt-wb-act-header.wbregid /*p-uniq-key-rec*/
                    ,input {&lob-egais-wb-act} /*p-field-*/
                    ,input v-info /*p-descr*/
                    ,input-output v-part-num
                    ,input {&lob-egais-wb-act}
                    ,input-output v-clob-db-num
                    ,input-output v-int64-id
                    ,input search (inFileName)
                    ,input '' /*p-src-encoding*/
                    ) no-error .
                  if error-status:error then 
                  do:
                    Msg = error-status:get-message(1) + {&new-line} + return-value.
                    StatusErr = true.
                  end.
  
                end.
              when hText:node-value matches ("*opt/out/Ticket/*") then 
                do:
  
                  os-delete "Ticket.xml".
                  assign
                    inFileName = "Ticket.xml"
                    .
                  CmdParseXml(hText:node-value).
                  if StatusErr then 
                    return.
                  find first tt-ticket.
                  if (tt-ticket.regid = "" or tt-ticket.regid = ?) or tt-ticket.doc <> 'WayBillAct' then do:
                    next url_.  
                  end.
                  v-clob-db-num = ?.
                  v-int64-id = 0.
                  
                  if can-find (first buf_clob-bind where buf_clob-bind.uniq-key-rec = tt-ticket.regid + {&delim-par} + tt-ticket.docId and buf_clob-bind.field-name_ =  {&lob-egais-ticket})
                    then next url_.
                  run gbl/file2clb.p ( input {&add-def}
                    ,input ",no"
                    ,input ? /*p-bh*/
                    ,input tt-ticket.regid + {&delim-par} + tt-ticket.docId /*p-uniq-key-rec*/
                    ,input {&lob-egais-ticket} /*p-field-*/
                    ,input '' /*p-descr*/
                    ,input-output v-part-num
                    ,input {&lob-egais-ticket}
                    ,input-output v-clob-db-num
                    ,input-output v-int64-id
                    ,input search (inFileName)
                    ,input '' /*p-src-encoding*/
                    ) no-error .
                  if error-status:error then 
                  do:
                    Msg = error-status:get-message(1) + {&new-line} + return-value.
                    StatusErr = true.
                  end.
  
                end.
            end case.
            
            empty temp-table tt-wb-info-client.
            empty temp-table tt-wb-hndls.
            empty temp-table tt-wb-act-hndls.
            empty temp-table tt-wb-header.
            empty temp-table tt-wb-gds-EG.
            empty temp-table tt-wb-act-header.
            empty temp-table tt-wb-act-gds-EG.
          end.

      end case.
    
    end.

  end.

  method override void ParseResponse(inContent as char, inTableType as int):

    define variable hDoc  as handle no-undo.
    define variable hRoot as handle no-undo.

    if not inTableType = {&wb-refB} or inTableType = {&wb-clob} then 
    do:
      empty temp-table tt-wb-info-client.
      empty temp-table tt-wb-header.
      empty temp-table tt-wb-gds-EG.
      empty temp-table tt-wb-act-header.
      empty temp-table tt-wb-act-gds-EG.
      empty temp-table tt-ticket.
    end.
                
    create x-document hDoc.
    create x-noderef hRoot.

    case inTableType:
      when {&wb-header} or 
      when {&wb-line} or
      when {&wb-act-line} or 
      when {&wb-act-header} or
      when {&ticket} or  
      when {&wb-refB} then 
        do:
        
          copy-lob
            from  object buf_clob-data.cdata
            to  file (if inTableType = {&wb-refB} then "-refb" else "") + 'temp.xml'
            no-convert
            no-error .

          hDoc:encoding = 'utf-8'.
          hDoc:load("file", search ((if inTableType = {&wb-refB} then "-refb" else "") + 'temp.xml'), false).
        
        end.
      when {&wb-clob} then 
        do:
          hDoc:load("file",inFileName,false).
          hDoc:encoding = 'utf-8'.
        end.
    end case.
           
    nn = 0.
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
      
      if hNoderef:subtype <> "element" or hNoderef:num-children = 0 then
        next.
            
      hNoderef:get-child(hText, 1) no-error .
      
      if error-status:error
        then next.
            
      /*if hNoderef:name = "ns:FSRAR_ID" then
        assign v-FS-RAR = hText:node-value .*/       
      case hNoderef:name:
        when "wb:Shipper" or 
        when "wbr:Shipper" then 
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
            nn = nn + 1.
          end.
        when "wa:Header" then 
          do:
            create tt-wb-act-header .
          end.
        when "wa:Position" then 
          do:
            create tt-wb-act-gds-EG .
          end.
        when "ns:Ticket" then 
          do:
            create tt-ticket .
          end.
      end case.
      if lookup (hParent:name, "ns:Ticket") > 0 then do:
        if hNoderef:name = "tc:DocId" then assign tt-ticket.docID = hText:node-value.
        if hNoderef:name = "tc:TicketDate" then assign tt-ticket.ticket-date = hText:node-value.
        if hNoderef:name = "tc:RegID" 
        then do:
          assign tt-ticket.regid = hText:node-value.
        end.
        if hNoderef:name = "tc:DocType" then assign tt-ticket.doc = hText:node-value.
        if hNoderef:name = "tc:DocType" then assign tt-ticket.doc = hText:node-value.
        
      end.
      if lookup (hParent:name, "tc:Result") > 0 then do:
        if hNoderef:name = "tc:Conclusion" then assign tt-ticket.status_ = hText:node-value.
        if hNoderef:name = "tc:Comments" then assign tt-ticket.comment = hText:node-value.
      end.
      if lookup (hParent:name, "ns:Owner") > 0
      then do:
        
        if hNoderef:name = "ns:FSRAR_ID" then assign inDocFSRAR = hText:node-value.
      end.

      if lookup (hParent:name, "wb:Header,ns:WayBill,wbr:Header,wa:Header") > 0
        then 
      do: 
        if hNoderef:name = "wb:Identity" or hNoderef:name = "wbr:Identity" or hNoderef:name = "wb:NUMBER" or hNoderef:name = "wbr:WBRegId" 
          then 
        do:
          if not available (tt-wb-header) then create tt-wb-header.
          assign 
            tt-wb-header.Identity = hText:node-value when hNoderef:name = "wb:Identity"
            tt-wb-header.ps       = "EGAIS wb:Identity " + hText:node-value when hNoderef:name = "wb:Identity"
            .
        end.
        if hNoderef:name = "wb:NUMBER" or hNoderef:name = "wbr:WBNUMBER" then assign tt-wb-header.num = hText:node-value.
        if hNoderef:name = "wb:Date" or hNoderef:name = "wbr:WBDate" then assign tt-wb-header.wb-date = date (entry (3, hText:node-value, "-") + "." + entry (2, hText:node-value, "-") + "." + entry (1, hText:node-value, "-")) .
        if hNoderef:name = "wb:ShippingDate" then assign tt-wb-header.shippingdate = date (entry (3, hText:node-value, "-") + "." + entry (2, hText:node-value, "-") + "." + entry (1, hText:node-value, "-")) .
        if hNoderef:name = "wb:Type" then 
        do:
          case hText:node-value :
            when 'WBInvoiceFromMe' then 
              do:
                assign 
                  tt-wb-header.wb-type      = {&TDEDT_Pri_Vnesh}
                  tt-wb-header.wb-type-full = "приход вн.".
                if available (tt-wb-hndls) 
                  then tt-wb-hndls.wb-type = "приход вн."
                    .
              end.
            otherwise 
            do:
              assign 
                tt-wb-header.wb-type = ?.
            end.
          end case.
        end.
        if hNoderef:name = "wb:UnitType"     then assign tt-wb-header.unit-type = hText:node-value .
        
        if hNoderef:name = "wa:ACTNUMBER" then assign tt-wb-act-header.num = hText:node-value.
        if hNoderef:name = "wa:ActDate" then assign tt-wb-act-header.act-date = date (entry (3, hText:node-value, "-") + "." + entry (2, hText:node-value, "-") + "." + entry (1, hText:node-value, "-")) .
        if hNoderef:name = "wa:WBRegId" then assign tt-wb-act-header.wbregid = hText:node-value.
        if hNoderef:name = "wa:IsAccept" then assign tt-wb-act-header.status_ = hText:node-value.
        if hNoderef:name = "wa:Note" then assign tt-wb-act-header.note = hText:node-value.
        
        
      end.
      if lookup (hParent:name, "wb:Shipper,wb:Consignee,wb:Supplier,wbr:Shipper") > 0
        then 
      do: 
        if hNoderef:name = "oref:ClientRegId" then 
        do:
          assign 
            tt-wb-info-client.regID = hText:node-value
            tt-wb-header.regID-Ship = hText:node-value
            when hParent:name = 'wb:Shipper'
            tt-wb-header.regID-Ship = hText:node-value 
            when hParent:name = 'wbr:Shipper'
            tt-wb-header.regID-Cons = hText:node-value 
            when hParent:name = 'wb:Consignee'
            .
          
          assign 
            tt-wb-header.uniq-key-rec = tt-wb-header.num + {&delim-cmd} + string (tt-wb-header.wb-date) + {&delim-cmd} + tt-wb-header.regID-Ship + {&delim-cmd} + tt-wb-header.Identity when hParent:name = 'wbr:Shipper' or hParent:name = 'wb:Shipper'.
        end.
        if hNoderef:name = "oref:ShortName"   then assign tt-wb-header.NameShip = hText:node-value when hParent:name = 'wb:Shipper'.
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
      if lookup (hParent:name, "wb:Position,wb:Product,wa:Position") > 0
        then 
      do:
        if tt-wb-gds-EG.gds-name = "" then
          if hNoderef:name = "pref:ShortName"    then assign tt-wb-gds-EG.gds-name = hText:node-value.

        if hNoderef:name = "pref:FullName"     then assign tt-wb-gds-EG.gds-name = hText:node-value.
        if hNoderef:name = "pref:AlcCode"      then assign tt-wb-gds-EG.alc-code = hText:node-value.
        if hNoderef:name = "pref:Capacity"     then assign tt-wb-gds-EG.ms-base = decimal(hText:node-value) .
        if hNoderef:name = "pref:AlcVolume"    then assign tt-wb-gds-EG.proof = decimal(hText:node-value) .
        
        if hNoderef:name = "pref:ProductVCode" then assign tt-wb-gds-EG.alc-type-code = hText:node-value .
        if hNoderef:name = "wb:Identity"       
        then do:
          assign 
            tt-wb-gds-EG.Identity = hText:node-value
            tt-wb-gds-EG.nn = nn
          .
        end.
        if hNoderef:name = "wb:Price"          then assign tt-wb-gds-EG.price = decimal(hText:node-value) .
        if hNoderef:name = "wb:Quantity"       then assign tt-wb-gds-EG.qnty = decimal(hText:node-value) .
        
        if hNoderef:name = "wa:InformBRegId"   then assign tt-wb-act-gds-EG.refB = hText:node-value .
        if hNoderef:name = "wa:RealQuantity"   then assign tt-wb-act-gds-EG.RealQuantity = decimal(hText:node-value) .
        
      end.
      if lookup (hParent:name, "pref:Importer") > 0 then do:
        if hNoderef:name = "oref:ClientRegId" then assign tt-wb-gds-EG.regID-Importer = hText:node-value .
        tt-wb-gds-EG.importer-th = "".
        find first ub.ext-classif no-lock 
          where ub.ext-classif.classif-subject = {&table_clients}
            and ub.ext-classif.classif-name = {&extclass_clients_esys}
            and ub.ext-classif.db-num = 0
            and ub.ext-classif.key#_one = v-ext-sys
            and ub.ext-classif.CharKey_Three = tt-wb-gds-EG.regID-Importer
            no-error.
        if available (ub.ext-classif) then do:
          tt-wb-gds-EG.importer-th = entry (2, ub.ext-classif.uniq-key-rec, {&delim-key}) + entry (3, ub.ext-classif.uniq-key-rec, {&delim-key}).
        end.
      end.
      if lookup (hParent:name, "pref:Producer") > 0 then do:
        if hNoderef:name = "oref:ClientRegId" then assign tt-wb-gds-EG.regID-Producer = hText:node-value .
        tt-wb-gds-EG.producer-th = "".
        find first ub.ext-classif no-lock 
          where ub.ext-classif.classif-subject = {&table_clients}
            and ub.ext-classif.classif-name = {&extclass_clients_esys}
            and ub.ext-classif.db-num = 0
            and ub.ext-classif.key#_one = v-ext-sys
            and ub.ext-classif.CharKey_Three = tt-wb-gds-EG.regID-Producer
            no-error.
        if available (ub.ext-classif) then do:
          tt-wb-gds-EG.producer-th = entry (2, ub.ext-classif.uniq-key-rec, {&delim-key}) + entry (3, ub.ext-classif.uniq-key-rec, {&delim-key}).
        end.
      end.
      if lookup (hParent:name, "wb:InformA") > 0
        then 
      do:
        if hNoderef:name = "pref:RegId" then assign tt-wb-gds-EG.refA = hText:node-value.
      end.
      if lookup (hParent:name, "wbr:Header") > 0
        then 
      do:
        find first tt-wb-header no-error.
        if not available (tt-wb-header) then create tt-wb-header.
        if hNoderef:name = "wbr:WBRegId" then assign tt-wb-header.wbregid = hText:node-value .
        if hNoderef:name = "wbr:Identity" then assign tt-wb-header.Identity = hText:node-value .
      end.
      if lookup (hParent:name, "wbr:Position") > 0
        then 
      do:
        if hNoderef:name = "wbr:Identity" then 
        do:
          find first tt-wb-gds-EG where tt-wb-gds-EG.Identity = hText:node-value no-error.
        end.
        if available (tt-wb-gds-EG) and hNoderef:name = "wbr:InformBRegId" then assign tt-wb-gds-EG.refB = hText:node-value.
      end.
      if available (tt-wb-gds-EG) then do:
        if tt-wb-gds-EG.regID-Importer = ""
          then
          assign 
            tt-wb-gds-EG.regID-i-p = tt-wb-gds-EG.regID-Producer
            tt-wb-gds-EG.i-p-th = tt-wb-gds-EG.producer-th
          .
          else
          assign 
            tt-wb-gds-EG.regID-i-p = tt-wb-gds-EG.regID-Importer
            tt-wb-gds-EG.i-p-th = tt-wb-gds-EG.importer-th
          .
          find first ub.ext-classif no-lock 
            where ub.ext-classif.classif-subject = {&table_clients}
              and ub.ext-classif.classif-name = {&extclass_clients_esys}
              and ub.ext-classif.db-num = 0
              and ub.ext-classif.key#_one = v-ext-sys
              and ub.ext-classif.CharKey_Three =  tt-wb-gds-EG.regID-i-p
              no-error.
          if available (ub.ext-classif) then do:
            find first buf_clients where buf_clients.obj-type = entry (2, ub.ext-classif.uniq-key-rec, {&delim-key}) and buf_clients.obj-code = integer (entry (3, ub.ext-classif.uniq-key-rec, {&delim-key})) no-error.
            if available (buf_clients) 
              then tt-wb-gds-EG.i-p-name = buf_clients.obj-name.
          end.
      end.
      GetChildren(hNoderef, (level + 1), inTableType).
    end.


    delete object hNoderef.
    delete object hText.
  end.

  method override public void SaveWB (inWbIdentity as char):
    
    def var trn-doc-code as char no-undo.
    
    find first buf_clob-bind exclusive-lock where buf_clob-bind.uniq-key-rec = inWbIdentity and buf_clob-bind.field-name_ = {&lob-egais-wb} no-error.
    if not available (buf_clob-bind) then 
    do:
      Msg = "Не найдена накладная с идентификатором " + inWbIdentity.
      StatusErr = true.
      return.
    end.
    
    if can-find (first tt-wb-gds-EG where tt-wb-gds-EG.RefA = "" or tt-wb-gds-EG.RefB = "")
      then 
    do:
      Msg = "Не для всех товаров есть сравка A или B ".
      StatusErr = true.
      return.      
    end.
    
    run ibs/th/bge/egais/AdapteeEGAISProcOra-i516.p
      (
      input table tt-wb-header,
      input table tt-wb-gds-EG,
      input User_Id,
      input "",
      input-output trn-doc-code
      ) no-error.
    if error-status:error then 
    do:
      Msg = return-value.
      StatusErr = true.
      return.
    end.
    entry (6, buf_clob-bind.descr, {&delim-par}) = trn-doc-code.
    GetHndlTable ({&wb-clob}, '').
    
  end.

  method override public void RejectWB (inWbIdentity as char):
    
    find first buf_clob-bind exclusive-lock where buf_clob-bind.uniq-key-rec = inWbIdentity and buf_clob-bind.field-name_ = {&lob-egais-wb} no-error.
    if not available (buf_clob-bind) then
    do:
      Msg = "Не найдена накладная с идентификатором " + inWbIdentity.
      StatusErr = true.
      return.
    end.
    entry (6, buf_clob-bind.descr, {&delim-par}) = 'отказ'.
    SendRequestUTM().
    GetHndlTable ({&wb-clob}, '').
    
  end.

  method override public void ConnWB (inWbIdentity as char, inTrnDoc as char):
    
    find first buf_clob-bind exclusive-lock where buf_clob-bind.uniq-key-rec = inWbIdentity and buf_clob-bind.field-name_ = {&lob-egais-wb} no-error.
    if not available (buf_clob-bind) then
    do:
      Msg = "Не найдена накладная с идентификатором " + inWbIdentity.
      StatusErr = true.
      return.
    end.
    if entry (6, buf_clob-bind.descr, {&delim-par}) = 'отказ' or entry (6, buf_clob-bind.descr, {&delim-par}) <> ''
    then do:
      Msg = "Накладная уже связана или по ней был отказ".
      StatusErr = true.
      return.
    end.
    
    for each buf_doc-line no-lock where buf_doc-line.doc-code = inTrnDoc:
      find first buf_gds no-lock  where
        buf_doc-line.artic     = buf_gds.artic and
        buf_doc-line.prod-type = buf_gds.prod-type and
        buf_doc-line.prod-code = buf_gds.prod-code
        no-error .
      
      find first tt-wb-gds-EG where tt-wb-gds-EG.gds-code = buf_gds.gds-code no-error.
      if not available (tt-wb-gds-EG)
      then do:
        Msg = "Несоответсвие товаров накладной TH товарам накладной ЕГАИС".
        StatusErr = true.
        return.
      end.
    end.
    run ibs/th/bge/egais/AdapteeEGAISProcOra-i516.p
      (
      input table tt-wb-header,
      input table tt-wb-gds-EG,
      input User_Id,
      input "set-refAB",
      input-output inTrnDoc
      ) no-error.
    if error-status:error then 
    do:
      Msg = return-value.
      StatusErr = true.
      return.
    end.
    entry (6, buf_clob-bind.descr, {&delim-par}) = inTrnDoc.
    GetHndlTable ({&wb-clob}, '').
     
    
  end.

  method private longchar GetXMLAct ():

    def var ii       as int      no-undo.
    def var xml-cont as longchar no-undo.
    def var is-diff  as logical no-undo.
    
    find first tt-wb-header.
    if not (available (buf_clob-bind) and entry (6, buf_clob-bind.descr, {&delim-par}) = 'отказ') then do:
      find first buf_doc-attr no-lock where buf_doc-attr.attr-code = {&trdcattr-negais} and buf_doc-attr.attr-value begins (tt-wb-header.wbregid).
      for each buf_doc-line no-lock where buf_doc-line.doc-code = buf_doc-attr.doc-code:
        
        find first buf_gds no-lock where buf_gds.artic = buf_doc-line.artic and buf_gds.prod-code = buf_doc-line.prod-code and buf_gds.prod-type = buf_doc-line.prod-type.
        for each tt-wb-gds-EG where tt-wb-gds-EG.gds-code = buf_gds.gds-code.
          find first buf_parts where
            buf_parts.obj-type = buf_doc-line.obj-type and 
            buf_parts.obj-code = buf_doc-line.obj-code and 
            buf_parts.artic = buf_doc-line.artic and
            buf_parts.prod-type = buf_doc-line.prod-type and
            buf_parts.prod-code = buf_doc-line.prod-code and
            buf_parts.in-code = buf_doc-line.doc-code and
            buf_parts.out-code = buf_doc-line.doc-code and
            buf_parts.alc-ref-ab-path = tt-wb-gds-EG.refA + "," + tt-wb-gds-EG.refB no-lock no-error.
            
          if not available (buf_parts)
          then do:
            find first buf_parts where
              buf_parts.obj-type = buf_doc-line.obj-type and 
              buf_parts.obj-code = buf_doc-line.obj-code and 
              buf_parts.artic = buf_doc-line.artic and
              buf_parts.prod-type = buf_doc-line.prod-type and
              buf_parts.prod-code = buf_doc-line.prod-code and
              buf_parts.in-code = buf_doc-line.doc-code and
              buf_parts.out-code = buf_doc-line.doc-code and
              buf_parts.qnty = tt-wb-gds-EG.qnty no-lock no-error.
            if not available (buf_parts) then do:
              Msg = "Не найдена партия для товара " + string (tt-wb-gds-EG.gds-code) + " справка А " + tt-wb-gds-EG.refA + " справка Б " + tt-wb-gds-EG.refB.
              StatusErr = true.
              return ?.            
            end.
          end.
          

          
          if tt-wb-gds-EG.qnty <> buf_parts.fact-qnty then 
          do:
            is-diff = true. 
          end.
&scop xml-act-cont '<wa:Position>~
<wa:Identity>&1</wa:Identity>~
<wa:InformBRegId>&2</wa:InformBRegId>~
<wa:RealQuantity>&3</wa:RealQuantity>~
</wa:Position>'
          xml-cont = xml-cont + substitute ({&xml-act-cont}, string (tt-wb-gds-EG.Identity), tt-wb-gds-EG.refB, string (buf_parts.fact-qnty)).
        end.
      end.
      return substitute ({&xml-act-1}, v-FS-RAR, 'Accepted', buf_doc-attr.doc-code, iso-date (date (now)), tt-wb-header.wbregid, "Принимаем продукцию") + (if is-diff then xml-cont else "") + {&xml-act-2}.
    end.
    else do:
      xml-cont = substitute ({&xml-act-1}, v-FS-RAR, 'Rejected', time, iso-date (date (now)), tt-wb-header.wbregid, "Отказ") + {&xml-act-2}.
      return xml-cont.
    end.
    
  end.


  method private void CmdParseXml (inType as char):
    
    cmd = substitute ("&1 --connect-timeout &2 -X GET &3 >&4", search ("exe/curl.exe"), TimeOut, inType, inFileName).
    os-command silent value (cmd).
    ParseResponse(inFileName, {&wb-clob}).
    find first tt-wb-header no-error.
    find first tt-wb-act-header no-error.
    find first tt-ticket no-error.
    if not available (tt-wb-header) and not available (tt-wb-act-header) and not available (tt-ticket) then 
    do:
      Msg = 'Ошибка обработки xml'.
      StatusErr = true.
      return.
    end.
    
  end.


  method private void WriteXMLWB (inFileName as char):

    def var sw as handle no-undo. 

    create sax-writer sw .
  
    sw:formatted = true.
    sw:set-output-destination ("file", inFileName).
    sw:encoding = "UTF-8".
    sw:start-document () .
    sw:start-element ("ns:Documents") .
    sw:insert-attribute ("Version", "1.0") .
    sw:insert-attribute ("xmlns:wb", "http://fsrar.ru/WEGAIS/TTNSingle") .
    sw:insert-attribute ("xmlns:ns", "http://fsrar.ru/WEGAIS/WB_DOC_SINGLE_01") .
    sw:insert-attribute ("xmlns:oref", "http://fsrar.ru/WEGAIS/ClientRef") .
    sw:insert-attribute ("xmlns:pref", "http://fsrar.ru/WEGAIS/ProductRef") .
  
  
    sw:start-element ("ns:Owner") . 
        sw:write-data-element ("ns:FSRAR_ID", v-fs-rar) .
    sw:end-element ("ns:Owner") . 
  
  
  
    sw:start-element ("ns:Document") .
  
      sw:start-element ("ns:WayBill") .
  
  
        sw:write-data-element ("wb:Identity", tt-wb-header.Identity) .
        sw:start-element ("wb:Header") .  
          sw:write-data-element ("wb:NUMBER", tt-wb-header.Identity).
          sw:write-data-element ("wb:Date", iso-date (tt-wb-header.wb-date)).
          sw:write-data-element ("wb:Type", tt-wb-header.wb-type).  
          sw:write-data-element ("wb:UnitType", 'Packed'). /*??????*/
          sw:write-data-element ("wb:ShippingDate", iso-date (tt-wb-header.wb-date)).
          sw:start-element ("wb:Shipper") .
            AddClientXML(sw, tt-wb-header.obj-type, tt-wb-header.obj-code, tt-wb-header.regID-Ship).
            if StatusErr
              then return. 
          sw:end-element ("wb:Shipper") .
          sw:start-element ("wb:Consignee") .
            AddClientXML(sw, tt-wb-header.cli-type, tt-wb-header.cli-code, tt-wb-header.regID-Cons).
            if StatusErr
              then return.
          sw:end-element ("wb:Consignee") .
          sw:start-element ("wb:Transport") .
          sw:end-element ("wb:Transport") .
        sw:end-element ("wb:Header") .
        sw:start-element ("wb:Content") .
          sw:start-element ("wb:Position") .
            sw:write-data-element ("wb:Identity", tt-wb-gds-EG.Identity).
            sw:start-element ("wb:Product") .
              sw:write-data-element ("pref:FullName", tt-wb-gds-EG.gds-name).
              sw:write-data-element ("pref:AlcCode", tt-wb-gds-EG.alc-code).
            sw:end-element ("wb:Product") .
            sw:write-data-element ("wb:Quantity", string (tt-wb-gds-EG.qnty)).
            sw:write-data-element ("wb:Price", string (tt-wb-gds-EG.price)).
            sw:start-element ("wb:InformA") .
              sw:write-data-element ("pref:RegId", tt-wb-gds-EG.refA).
            sw:end-element ("wb:InformA") .
            sw:start-element ("wb:InformB") .
              sw:start-element ("pref:InformBItem") .
                sw:write-data-element ("pref:BRegId", tt-wb-gds-EG.refB).
              sw:end-element ("pref:InformBItem") .
            sw:end-element ("wb:InformB") .                    
          sw:end-element ("wb:Position") .
        sw:end-element ("wb:Content") .
      sw:end-element ("ns:WayBill") .
    sw:end-element ("ns:Document") .
    sw:end-element ("ns:Documents") .


    delete object sw.

  end.
  
  method private void AddClientXML (inSW as handle, inObjType as char, inObjCode as int, inRegID as char):
    
    find first buf_clients no-lock where buf_clients.obj-type = inObjType and buf_clients.obj-code = inObjCode no-error.
    if available (buf_clients)
    then do:
      if buf_clients.obj-type = {&cmp}
      then do:
        find first buf_firm no-lock where buf_firm.firm-code = buf_clients.obj-code no-error.
      end.
      else do:
        find first buf_firm no-lock where buf_firm.firm-code = buf_clients.host-code no-error.
      end.
      find first buf_clients-attr no-lock where buf_clients-attr.obj-type = inObjType and buf_clients-attr.obj-code = inObjCode
        and buf_clients-attr.attr-code = {&attr-kpp} no-error.
    end.
    else do:
      Msg = "Не найден клиент " + inObjType + string (inObjCode).
      StatusErr = true.
      return.
    end.

    if available (buf_firm) and 
      (available (buf_clients-attr) or (buf_firm.kpp <> "" and not available (buf_clients-attr))) then do:
      inSW:write-data-element ("oref:INN", buf_firm.inn).
      inSW:write-data-element ("oref:KPP", if available buf_clients-attr then buf_clients-attr.attr-value else buf_firm.kpp).
    end.
    else do:
      Msg = "Не найден ИНН или КПП объекта " + inObjType + string (inObjCode).
      StatusErr = true.
      return.
    end.
    inSW:write-data-element ("oref:ClientRegId", inRegID).
    inSW:write-data-element ("oref:FullName", buf_clients.obj-name).
    inSW:write-data-element ("oref:ShortName", '').
    inSW:start-element ("oref:address").
      inSW:write-data-element ("oref:Country", '643').
      inSW:write-data-element ("oref:description", '').
    inSW:end-element ("oref:address").
    
  end.

end class.
