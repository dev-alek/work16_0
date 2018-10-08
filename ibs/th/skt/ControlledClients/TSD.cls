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

using Progress.Lang.*.
using ibs.th.skt.Commands.*.
using ibs.th.skt.ControlledClients.*.
using ibs.th.skt.Adapters.*.
using ibs.th.skt.*.


class ibs.th.skt.ControlledClients.TSD : 

  &scop delimiteFld chr(9)
  &scop delimiterLine chr(31)
  
  { cmp/str-glbl.i class}
  {ibs/th/skt/ControlledClients/TSDTT.i}
  
  define stream str1 .
  define stream str2 .
  define stream logTSD .

  define public property SomeStr as longchar no-undo
    get.
    set.

  define public property ObjCode as integer no-undo
    private get.
    set.
    
  define public property ObjType as character no-undo
    private get.
    set.

  define public property SN as character no-undo
    private get.
    set.

  define public property ReqType as character no-undo
    get.
    set.

  define public property CP as character no-undo
    get.
    set.

  define private buffer buf_user      for ub.user-login.
  define private buffer buf_goods     for ub.goods.
  define private buffer buf_clients   for ub.clients.
  define private buffer buf_shop      for ub.shop.
  define private buffer buf_store     for ub.store.
  define private buffer buf_bar-code  for ub.bar-code.
  define private buffer buf_gds-obj   for ub.gds-obj.
  define private buffer buf_price-all for ub.price-all.
  define private buffer buf_prod-bc   for ub.prod-bc.
  define private buffer buf_trn-doc   for ub.trn-doc.
  define private buffer buf_doc-line  for ub.doc-line.
  define private buffer buf_parts     for ub.parts.
  
  define private variable tthDocument as handle no-undo.
  define private stream tsdstream.
  define private variable logWrite as class LogWrite no-undo.
  define private variable isAlcWB as logical no-undo init false.  /* !!!!!!!!!!!!!!!!!!!!!!!!!!!Сделать нормально!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! */


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
		
  constructor public TSD (  ):
    
    logWrite = new LogWrite().
		
  end constructor.



  define temp-table TempBCode no-undo
    field gds-code as integer
    field b-str as character
    field priceSale as character
    field unit-cli  as character
    field cliBaseRate as character
    index pi is unique primary b-str.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  method private void tsdstreamopen (streamFile as char):
    
    output stream tsdstream to value (streamFile).

  end method.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  method private void tsdstreamclose ():
    
    output stream tsdstream close.

  end method.  
  
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public character getStatusXml (statusOk as logical, statusMsg as char):
    
    define variable statusOkTag as character no-undo.
    define variable statusMsgTag as character no-undo. 
  
    assign
      statusOkTag = substitute ('<STATUS>&1</STATUS>', if statusOk then "OK" else "ERROR")
      statusMsgTag = if statusOk then '' else substitute ('<STATUS_MESSAGE>&1</STATUS_MESSAGE>', statusMsg)
    .
    return substitute ('<?xml version="1.0" encoding="&1"?><TSD>&2&3</TSD>', CP, statusOkTag, statusMsgTag).

  end method.

  method public void getWB ():
    
    define variable cHeader    as character no-undo.
    define variable cLine      as longchar no-undo.
    define variable dFactSum   as decimal   no-undo.
    define variable factQnty   as character no-undo.
    define variable docQnty    as character no-undo.
    define variable priceSale  as character no-undo.
    define variable FactSum    as character no-undo.
    define variable docType    as character no-undo.
    define variable dPriceSale as decimal   no-undo.
    define variable hour     as integer no-undo.
    define variable minute   as integer no-undo.
    define variable sec      as integer no-undo.
    define variable timeleft as integer no-undo. 
    define variable decDocQnty as decimal no-undo.
    define variable decFactQnty as decimal no-undo. 

    def    var      internal-b-code like ub.bar-code.b-code no-undo .
    def    var      full-b-code     as character init "" no-undo .
    def    var      bc-frmt         as character no-undo .
    def    var      bc-pfx          as character no-undo .
    def    var      v-par-type      as character no-undo .
    
    
    run gbl/conf-rd.p ("bc-pfx", "", "", 0, "", "", "", yes, output bc-pfx, output v-par-type) no-error.
    run gbl/conf-rd.p ("bc-frmt", "", "", 0, "", "", "", yes, output bc-frmt, output v-par-type) no-error.  

        
    for each buf_trn-doc where 
            buf_trn-doc.obj-type = ObjType 
        and buf_trn-doc.obj-code = ObjCode 
        and ( ((buf_trn-doc.ext-doc-type = {&TDEDT_Ras_Vnesh} 
              or buf_trn-doc.ext-doc-type = {&TDEDT_Ras_Perem}
              or buf_trn-doc.ext-doc-type = {&TDEDT_Inv})
              and buf_trn-doc.flag_ = true
              and buf_trn-doc.status_ = {&permitted})
            or 
              ((buf_trn-doc.ext-doc-type = {&TDEDT_Pri_Vnesh} 
              or buf_trn-doc.ext-doc-type = {&TDEDT_Pri_Perem})
              and buf_trn-doc.flag_ = true
              and buf_trn-doc.status_ = {&wayb})
            ) 
      no-lock:
      assign
        dFactSum = 0
        cHeader = ""
        cLine= ""
      .
      
      case buf_trn-doc.ext-doc-type:
        when {&TDEDT_Ras_Vnesh} then do:
          docType = "ExtSalesWB".
        end.
        when {&TDEDT_Ras_Perem} then do:
          docType = "IntSalesWB".
        end.
        when {&TDEDT_Pri_Vnesh} then do:
          docType = "ExtPurchWB".
        end.
        when {&TDEDT_Pri_Perem} then do:
          docType = "IntPurchWB".
        end.
        when {&TDEDT_Inv} then do:
          docType = "Inv".
        end.
      end case.
      
      if not isAlcWB or docType = 'inv'
      then do:
        for each buf_doc-line where buf_doc-line.doc-code = buf_trn-doc.doc-code no-lock:
          find first buf_goods no-lock where buf_goods.artic = buf_doc-line.artic and buf_goods.prod-code = buf_doc-line.prod-code and buf_goods.prod-type = buf_doc-line.prod-type.
          find first buf_bar-code no-lock where buf_bar-code.gds-code = buf_goods.gds-code.
          internal-b-code = buf_bar-code.b-code.
          { str/bc-gnrti.i "bc" "internal-b-code" "full-b-code"}
          
          decDocQnty = buf_doc-line.doc-qnty - buf_doc-line.fact-qnty.
          decFactQnty = buf_doc-line.doc-qnty.
          
          assign
            priceSale   = if buf_doc-line.price-rubl <> 0 and buf_doc-line.price-rubl <> ? then string (buf_doc-line.price-rubl) else "0"
            factQnty    = string (decFactQnty)
            docQnty    = string (decDocQnty)
            .
          assign
            priceSale = if buf_doc-line.price-rubl > -1 and buf_doc-line.price-rubl < 1 then replace (priceSale, ".", "0,") else replace (priceSale, ".", ",")
            factQnty  = if buf_doc-line.fact-qnty > -1 and buf_doc-line.fact-qnty < 1 then replace (factQnty, ".", "0,") else replace (factQnty, ".", ",")
            docQnty  = if buf_doc-line.doc-qnty > -1 and buf_doc-line.doc-qnty < 1 then replace (docQnty, ".", "0,") else replace (docQnty, ".", ",")
            .
          cLine = cLine + substitute ('<line DocName="&1" GoodsID="&2" UnitBC="&3" BC="&4" Price="&5" DocQnty="&6" FactQnty="&7" />', buf_doc-line.doc-code, buf_goods.gds-code, buf_goods.unit-base, full-b-code, priceSale, docQnty, factQnty).
          dFactSum = buf_doc-line.fact-qnty + dFactSum.
        end.
      end.
      else do:
        for each buf_doc-line where buf_doc-line.doc-code = buf_trn-doc.doc-code no-lock:
          find first buf_goods no-lock where buf_goods.artic = buf_doc-line.artic and buf_goods.prod-code = buf_doc-line.prod-code and buf_goods.prod-type = buf_doc-line.prod-type.
          find first buf_bar-code no-lock where buf_bar-code.gds-code = buf_goods.gds-code.
          
          
          if true /*not docType = 'inv'*/ then do:
          
            for each buf_parts no-lock where
              buf_parts.obj-type = buf_trn-doc.obj-type and 
              buf_parts.obj-code = buf_trn-doc.obj-code and 
              buf_parts.artic = buf_doc-line.artic and
              buf_parts.prod-type = buf_doc-line.prod-type and
              buf_parts.prod-code = buf_doc-line.prod-code and
              buf_parts.out-code = buf_trn-doc.doc-code:
            
              internal-b-code = buf_bar-code.b-code.
              { str/bc-gnrti.i "bc" "internal-b-code" "full-b-code"}

              
              assign
                priceSale   = if buf_parts.price-rubl <> 0 and buf_parts.price-rubl <> ? then string (buf_parts.price-rubl) else "0"
                factQnty    = string (decFactQnty)
                docQnty    = string (decDocQnty)
                .
              assign
                priceSale = if buf_parts.price-rubl > -1 and buf_parts.price-rubl < 1 then replace (priceSale, ".", "0,") else replace (priceSale, ".", ",")
                factQnty  = if buf_parts.fact-qnty > -1 and buf_parts.fact-qnty < 1 then replace (factQnty, ".", "0,") else replace (factQnty, ".", ",")
                docQnty  = if buf_parts.qnty > -1 and buf_parts.qnty < 1 then replace (docQnty, ".", "0,") else replace (docQnty, ".", ",")
                .
              cLine = cLine + substitute ('<line DocName="&1" GoodsID="&2" UnitBC="&3" BC="&4" Price="&5" DocQnty="&6" FactQnty="&7" AlcCode="&8" PartIDTH ="&9" />', buf_doc-line.doc-code, buf_goods.gds-code, buf_goods.unit-base, full-b-code, priceSale, docQnty, factQnty, if num-entries  (buf_parts.alc-ref-ab-path, ",") < 3 then "" else entry (3, buf_parts.alc-ref-ab-path, ","), buf_parts.part-code).
              dFactSum = buf_doc-line.fact-qnty + dFactSum.
            end.
            
          end.
          else do:
            
             /*for each buf_parts no-lock where
              buf_parts.obj-type = buf_trn-doc.obj-type and 
              buf_parts.obj-code = buf_trn-doc.obj-code and 
              buf_parts.artic = buf_doc-line.artic and
              buf_parts.prod-type = buf_doc-line.prod-type and
              buf_parts.prod-code = buf_doc-line.prod-code and
                (buf_parts.out-code = {&free-code} or
                buf_parts.out-code = ub.trn-doc.doc-code):
            
              internal-b-code = buf_bar-code.b-code.
              { str/bc-gnrti.i "bc" "internal-b-code" "full-b-code"}
              
              decDocQnty = if docType = 'inv' then buf_parts.qnty - buf_parts.fact-qnty else buf_parts.qnty.
              decFactQnty = if docType = 'inv' then buf_parts.qnty else buf_parts.fact-qnty.
              
              assign
                priceSale   = if buf_parts.price-rubl <> 0 and buf_parts.price-rubl <> ? then string (buf_parts.price-rubl) else "0"
                factQnty    = string (decFactQnty)
                docQnty    = string (decDocQnty)
                .
              assign
                priceSale = if buf_parts.price-rubl > -1 and buf_parts.price-rubl < 1 then replace (priceSale, ".", "0,") else replace (priceSale, ".", ",")
                factQnty  = if buf_parts.fact-qnty > -1 and buf_parts.fact-qnty < 1 then replace (factQnty, ".", "0,") else replace (factQnty, ".", ",")
                docQnty  = if buf_parts.qnty > -1 and buf_parts.qnty < 1 then replace (docQnty, ".", "0,") else replace (docQnty, ".", ",")
              .
              cLine = cLine + substitute ('<line DocName="&1" GoodsID="&2" UnitBC="&3" BC="&4" Price="&5" DocQnty="&6" FactQnty="&7" AlcCode="&8" PartIDTH ="&9" />', buf_doc-line.doc-code, buf_goods.gds-code, buf_goods.unit-base, full-b-code, priceSale, docQnty, factQnty, if num-entries  (buf_parts.alc-ref-ab-path, ",") < 3 then "" else entry (3, buf_parts.alc-ref-ab-path, ","), buf_parts.in-code + chr(4) + buf_parts.part-code).
              dFactSum = buf_doc-line.fact-qnty + dFactSum.
            end.*/
            
          end.
          
          
        end.      
      end.
      
      FactSum = if dFactSum > -1 and dFactSum < 1 then replace (string (dFactSum), ".", "0,") else replace (string (dFactSum), ".", ",").
      cHeader = substitute ('<header DocType="&1" DocName="&2" ClientID="&3" ClientType="&4" ObjectID="&5" ObjectType="&6" FactSum="&7" StartDate="&8" userID = "&9" />'
          , docType
          , buf_trn-doc.doc-code
          , buf_trn-doc.cli-code
          , buf_trn-doc.cli-type
          , buf_trn-doc.obj-code 
          , buf_trn-doc.obj-type
          , dFactSum
          , string(datetime(buf_trn-doc.doc-date, buf_trn-doc.real-time-create), "99.99.9999 HH:MM:SS")
          , buf_trn-doc.user-name
          ).
      SomeStr = SomeStr + cHeader + cLine.
    end.
    SomeStr = substitute ('<?xml version="1.0" encoding="&1"?><TSD>', CP) + SomeStr + ('</TSD>').
    output stream logTSD to value ("logSKTTSD.txt").
    export stream logTSD SomeStr.
    output stream logTSD close.

  end method.

  method public void Check_ ():
    
    define variable confPar   as character no-undo.
    define variable parType   as character no-undo.
    define variable statusOK  as logical   no-undo init false.
    run gbl/conf-rd.p ("tsd-list", "", "", 0, "", "", "", no, output confPar, output parType) no-error.
    if lookup (SN, confPar, ";") > 0 
      then statusOK = true.
    find first buf_clients no-lock 
      where buf_clients.obj-type = ObjType and buf_clients.obj-code = ObjCode no-error.
    if available (buf_clients) 
      then statusOK = true. 
	  else statusOK = false. 
    SomeStr = 
      if true 
        then getStatusXml(statusOK, "") 
        else if lookup (SN, confPar) = 0 then getStatusXml(statusOK, "LIC") else getStatusXml(statusOK, "OBJ").
    
  end method.


  method public void WriteUsers ():
    define variable dbNum as integer no-undo.
    tsdstreamopen("TH_users.txt").
    dbNum = GetDbNum().
    for each buf_user where buf_user.status_ = 0 and buf_user.db-num = dbNum no-lock:
      put stream tsdstream unformatted buf_user.user-id + {&delimiteFld} + buf_user.user-login + {&delimiterLine}.
    end.
    tsdstreamclose().
    
  end.


  method public void WriteObjects ():

    tsdstreamopen("TH_objects.txt").    
    for each buf_clients where buf_clients.stts = 0 and (buf_clients.obj-type = "маг" or buf_clients.obj-type = "скл") no-lock:
     put stream tsdstream unformatted 
      string (buf_clients.obj-code) + {&delimiteFld} + 
      buf_clients.obj-type + {&delimiteFld} + 
      buf_clients.obj-name + 
      {&delimiterLine}.
    end.
    tsdstreamclose().
    
  end.


  method public void WriteClients ():
    
    tsdstreamopen("TH_clients.txt"). 
    for each buf_clients where buf_clients.stts = 0 and (buf_clients.obj-type = "орг" 
      or buf_clients.obj-type = "чел" or buf_clients.obj-type = {&shop} or buf_clients.obj-type = {&stock})
      and not (buf_clients.obj-type = ObjType and buf_clients.obj-code = ObjCode) no-lock:
      put stream tsdstream unformatted string (buf_clients.obj-code) + {&delimiteFld} + buf_clients.obj-type + {&delimiteFld} + buf_clients.obj-name + {&delimiterLine}.
    end.
    tsdstreamclose().
    
  end.
  

  method public void WriteGoods ():

    define variable factQnty    as character no-undo.
    define variable freeQnty    as character no-undo.
    define variable priceSale   as character no-undo.
    define variable vatPc       as character no-undo.
    define variable countryName as character no-undo.
    define variable dPriceSale  as decimal   no-undo.
    define variable dVatPc      as decimal   no-undo.

    tsdstreamopen("TH_goods.txt").
    for each buf_goods where buf_goods.stts = 0 and gds-type = 'т' no-lock use-index ists:
      
      find first buf_gds-obj where buf_gds-obj.gds-code = buf_goods.gds-code no-lock no-error.
      find first buf_bar-code where buf_bar-code.gds-code = buf_goods.gds-code and buf_bar-code.stts = 0 no-lock use-index prt-parts no-error.
      
      /*run ibs\th\skt\Adapters\AdapteeProcBcprcex.p
        (
        input ObjType,
        input ObjCode,
        input buf_bar-code.b-code,
        output dPriceSale,
        output dVatPc
        ) 
        no-error.*/

      find first ub.country where ub.country.alpha1 = buf_goods.alpha1 no-lock no-error. 

      assign
        priceSale   = if dPriceSale <> 0 and dPriceSale <> ? then string (dPriceSale) else "0"
        vatPc       = if dVatPc <> 0 and vatPc <> ? then string (dVatPc) else "0"
        factQnty    = if available buf_gds-obj then string (buf_gds-obj.fact-qnty) else "0"
        freeQnty    = if available buf_gds-obj then string (buf_gds-obj.free-qnty) else "0"
        countryName = if available ub.country then ub.country.long-name else ""
        .
      assign
        priceSale = if dPriceSale > -1 and dPriceSale < 1 then replace (priceSale, ".", "0,") else replace (priceSale, ".", ",")
        factQnty  = if available buf_gds-obj and buf_gds-obj.fact-qnty > -1 and buf_gds-obj.fact-qnty < 1 then replace (factQnty, ".", "0,") else replace (factQnty, ".", ",")
        freeQnty  = if available buf_gds-obj and buf_gds-obj.free-qnty > -1 and buf_gds-obj.free-qnty < 1 then replace (freeQnty, ".", "0,") else replace (freeQnty, ".", ",")
        .
      
      put stream tsdstream unformatted 
        string (buf_goods.gds-code) + {&delimiteFld} + 
        buf_goods.gds-name + {&delimiteFld} + 
        buf_goods.unit-base + {&delimiteFld} +
        priceSale + {&delimiteFld} +
        vatPc + {&delimiteFld} +
        countryName  + {&delimiteFld} +
        "Состав" + {&delimiteFld} +
        factQnty + {&delimiteFld} + 
        freeQnty + {&delimiterLine}.

    end.
    tsdstreamclose().
        
  end.


  method public void WriteBarcodes ():

    define variable cliBaseRate     as character no-undo.
    define variable priceSale       as character no-undo.
    def    var      internal-b-code like ub.bar-code.b-code no-undo .
    def    var      full-b-code     as character init "" no-undo .
    def    var      bc-frmt         as character no-undo .
    def    var      bc-pfx          as character no-undo .
    def    var      v-par-type      as character no-undo .
    
    
    run gbl/conf-rd.p ("bc-pfx", "", "", 0, "", "", "", yes, output bc-pfx, output v-par-type) no-error.
    run gbl/conf-rd.p ("bc-frmt", "", "", 0, "", "", "", yes, output bc-frmt, output v-par-type) no-error.   

    tsdstreamopen("TH_barcodes.txt").
    for each buf_goods where buf_goods.stts = 0 and gds-type = 'т' no-lock use-index ists:
      
      for each buf_bar-code where buf_bar-code.gds-code = buf_goods.gds-code and buf_bar-code.stts_ = 0 no-lock use-index prt-parts:

        find last buf_price-all where
          buf_price-all.b-code          = buf_bar-code.b-code and
          buf_price-all.gds-code        = buf_goods.gds-code  and
          buf_price-all.obj-code        = ObjCode and
          buf_price-all.obj-type        = ObjType and
          buf_price-all.plt-priority    = 0                   and
          buf_price-all.last-pr         = true
          no-lock no-error.

        internal-b-code = buf_bar-code.b-code.

        
        { str/bc-gnrti.i "bc" "internal-b-code" "full-b-code"}


        assign
          priceSale   = if available buf_price-all then string (buf_price-all.price-sale) else "0"
          cliBaseRate = string (buf_bar-code.cli-base-rate)
          .
        assign 
          priceSale = if available buf_price-all and buf_price-all.price-sale > -1 and buf_price-all.price-sale < 1 then replace (priceSale, ".", "0,") else replace (priceSale, ".", ",")
          cliBaseRate = if buf_bar-code.cli-base-rate > -1 and buf_bar-code.cli-base-rate < 1 then replace (cliBaseRate, ".", "0,") else replace (cliBaseRate, ".", ",")
          .
      
        create TempBCode.
              
        assign
          TempBCode.gds-code = buf_goods.gds-code
          TempBCode.b-str = full-b-code
          TempBCode.priceSale = priceSale
          TempBCode.unit-cli = buf_bar-code.unit-cli
          TempBCode.cliBaseRate = cliBaseRate 
        no-error.
        
        if error-status:error 
        then do:
          delete TempBCode.
          LogWrite:LogStr = LogWrite:LogStr + {&new-line} + substitute ( "Ошибка передачи бар-кода &1 в ТСД.", full-b-code).
        end.
        
        for each buf_prod-bc no-lock where buf_prod-bc.b-code = buf_bar-code.b-code and buf_prod-bc.bc-on = yes:
          
          
        create TempBCode.
              
          assign
            TempBCode.gds-code = buf_goods.gds-code
            TempBCode.b-str = buf_prod-bc.b-str
            TempBCode.priceSale = priceSale
            TempBCode.unit-cli = buf_bar-code.unit-cli
            TempBCode.cliBaseRate = cliBaseRate 
          no-error.
          
          if error-status:error
          then do:
            delete TempBCode.
            LogWrite:LogStr = LogWrite:LogStr + {&new-line} + substitute ( "Ошибка передачи бар-кода &1 в ТСД.", buf_prod-bc.b-str).
          end.
          
        end.
      end.

    end.
    
    for each TempBCode:
        
        put stream tsdstream unformatted
          string (TempBCode.gds-code) + {&delimiteFld} +
          TempBCode.b-str + {&delimiteFld} +
          TempBCode.priceSale + {&delimiteFld} +
          TempBCode.unit-cli + {&delimiteFld} +
          TempBCode.cliBaseRate + {&delimiterLine}.
          
    end.
    
    tsdstreamclose().
    
  end.

  
  method public logical ImpWB (table TempTrnDoc, table TempDocLine, userId_ as char):

    define buffer buf_trn-doc       for ub.trn-doc.
    define buffer buf_doc-line      for ub.doc-line.
    define buffer buf_doc-line-attr for ub.doc-line-attr.
    define variable adapterOra-i516 as class   AdapterOra-i516.
    define variable glog           as logical   no-undo.
    define variable mes            as character no-undo.
    define variable hLibMarks      as handle    no-undo.
    define variable ii             as integer   no-undo.
    define variable varzero-string as logical   no-undo.
    
    find first TempTrnDoc.
    find first buf_trn-doc exclusive-lock where buf_trn-doc.doc-code = TempTrnDoc.ext-doc-code
            and
            ( 
              ((buf_trn-doc.ext-doc-type = {&TDEDT_Ras_Vnesh} 
              or buf_trn-doc.ext-doc-type = {&TDEDT_Ras_Perem}
              or buf_trn-doc.ext-doc-type = {&TDEDT_Inv})
              and buf_trn-doc.flag_ = true
              and buf_trn-doc.status_ = {&permitted})
            or 
              ((buf_trn-doc.ext-doc-type = {&TDEDT_Pri_Vnesh} 
              or buf_trn-doc.ext-doc-type = {&TDEDT_Pri_Perem})
              and buf_trn-doc.flag_ = true
              and buf_trn-doc.status_ = {&wayb})
            )  no-error.
    if available buf_trn-doc then 
    do:   
      
      for each TempDocLine no-lock break by TempDocLine.gds-code:
        find first ub.goods where ub.goods.gds-code  = TempDocLine.gds-code
          no-lock no-error .
        find first buf_doc-line exclusive-lock where buf_doc-line.doc-code = buf_trn-doc.doc-code
          and buf_doc-line.artic = ub.goods.artic
          and buf_doc-line.prod-type = ub.goods.prod-type
          and buf_doc-line.prod-code = ub.goods.prod-code
          no-error  .
        if available buf_doc-line then do:
          
        end.
        else do:
          LogWrite:LogStr = substitute ( "В накладной &1 отсутсвует товар с кодом &2.", TempTrnDoc.ext-doc-code, TempDocLine.gds-code ).
          buf_trn-doc.ps = if buf_trn-doc.ps begins "@" then substitute ( "пропущен товар с кодом (штрих-код &3) &1&2.", TempDocLine.gds-code, {&new-line}, TempDocLine.b-code ) else substitute ( "&1&3 пропущен товар с кодом &2.",buf_trn-doc.ps, TempDocLine.gds-code, {&new-line} ).
          delete TempDocLine.
          next.
        end.
      end.
      
      os-delete value (search ("doctsd.txt")) no-error.
      os-delete value (search ("newdoctsd.txt")) no-error.
      output stream str1 to value ("doctsd.txt").
      output stream str2 to value ("newdoctsd.txt").
      for each TempDocLine where TempDocLine.is-tsd-qnty = true:
        put stream str1 unformatted TempDocLine.b-code "," TempDocLine.fact-qnty skip.
      end.
      for each TempDocLine where TempDocLine.is-tsd-qnty = false:
        put stream str2 unformatted TempDocLine.b-code "," TempDocLine.fact-qnty skip.
      end.
      output stream str1 close.
      output stream str2 close.
      if can-find (first TempDocLine)
      then do: 
        run gbl/filnline.p (input ("doctsd.txt"), output varzero-string).
        if varzero-string 
        then do:
          run str/scantsd.p ( 2, input no , input recid(buf_trn-doc) ,input "doctsd.txt" ) no-error.
          if error-status:error then do:
            LogWrite:LogStr = LogWrite:LogStr + {&new-line} + return-value. 
            SomeStr = getStatusXml(false, LogWrite:LogStr).
            os-delete value (search ("doctsd.txt")) no-error.
            os-delete value (search ("newdoctsd.txt")) no-error.
            return false.
          end.
          else LogWrite:LogStr = LogWrite:LogStr + {&new-line} + return-value.
        end.
  
        run gbl/filnline.p (input ("newdoctsd.txt"), output varzero-string).
        if varzero-string 
        then do:
          run str/scantsd.p ( 1, input no , input recid(buf_trn-doc) ,input "newdoctsd.txt" ) no-error.
          if error-status:error then do:
            LogWrite:LogStr = LogWrite:LogStr + {&new-line} + return-value. 
            SomeStr = getStatusXml(false, LogWrite:LogStr).
            os-delete value (search ("doctsd.txt")) no-error.
            os-delete value (search ("newdoctsd.txt")) no-error.
            return false.
          end.
          else LogWrite:LogStr = LogWrite:LogStr + {&new-line} + return-value.
        end.
  
      end.
      os-delete value (search ("doctsd.txt")) no-error.
      os-delete value (search ("newdoctsd.txt")) no-error.
      
      
      run bge/egais-marks-find.p persistent (output hLibMarks) no-error .
      for each TempDocLine no-lock break by TempDocLine.gds-code:
        find first ub.goods where ub.goods.gds-code  = TempDocLine.gds-code
          no-lock no-error .
        find first buf_doc-line exclusive-lock where buf_doc-line.doc-code = buf_trn-doc.doc-code
          and buf_doc-line.artic = ub.goods.artic
          and buf_doc-line.prod-type = ub.goods.prod-type
          and buf_doc-line.prod-code = ub.goods.prod-code
          no-error  .
        if available buf_doc-line then do:
          
          for each buf_parts where
            buf_parts.obj-type = buf_trn-doc.obj-type and 
            buf_parts.obj-code = buf_trn-doc.obj-code and 
            buf_parts.artic = buf_doc-line.artic and
            buf_parts.prod-type = buf_doc-line.prod-type and
            buf_parts.prod-code = buf_doc-line.prod-code and
            buf_parts.out-code = buf_trn-doc.doc-code and
            buf_parts.part-code = TempDocLine.PartIDTH:
            
            buf_parts.fact-qnty = TempDocLine.fact-qnty.
            if TempDocLine.aclMarksList <> ""
            then do:
              do ii = 1 to num-entries (TempDocLine.aclMarksList, ";"):
                run create-mark in hLibMarks (input entry (ii, TempDocLine.aclMarksList, ";"), buffer buf_parts, output glog, output mes ).
              end.
            end.
          end.
          
        end.
      end.
      delete object hLibMarks no-error.
      run gbl/calc-trn.p (?, recid(buf_trn-doc)) no-error .
      
      SomeStr = getStatusXml(true, "").
      return true.
      
      
    end.
    else 
    do:
      adapterOra-i516 = new AdapterOra-i516().
      
      adapterOra-i516:SetTempTable(table TempTrnDoc, table TempDocLine, userId_).
      
      adapterOra-i516:WriteDB(output glog).
  
      LogWrite:LogStr = LogWrite:LogStr + {&new-line} + adapterOra-i516:StrLog.
      delete object AdapterOra-i516.
  
      if glog
        then do:
          SomeStr = getStatusXml(true, "").
          return true.
        end.
        else do:
          SomeStr = getStatusXml(false, LogWrite:LogStr).
          return false.
        end.
    end.
    
  end.
  
  
  method public logical ImpInventory (table TempTrnDoc, table TempDocLine, userId_ as char):

    define buffer buf_trn-doc       for ub.trn-doc.
    define buffer buf_doc-line      for ub.doc-line.
    define buffer buf_doc-line-attr for ub.doc-line-attr.
    define buffer bfTempDocLine for TempDocLine.    
    define variable adapterOra-i506 as class   AdapterOra-i506.
    define variable varzero-string  as logical no-undo.
    
    
    find first TempTrnDoc.
    find first buf_trn-doc exclusive-lock where buf_trn-doc.doc-code = TempTrnDoc.ext-doc-code
      and buf_trn-doc.status_ = {&permitted}
      and buf_trn-doc.flag_ = true no-error.
    if available buf_trn-doc then 
    do:   
      
      for each TempDocLine no-lock break by TempDocLine.gds-code:
        find first ub.goods where ub.goods.gds-code  = TempDocLine.gds-code
          no-lock no-error .
        find first buf_doc-line exclusive-lock where buf_doc-line.doc-code = buf_trn-doc.doc-code
          and buf_doc-line.artic = ub.goods.artic
          and buf_doc-line.prod-type = ub.goods.prod-type
          and buf_doc-line.prod-code = ub.goods.prod-code
          no-error  .
        if available buf_doc-line then do:
          find first buf_doc-line-attr where buf_doc-line-attr.doc-code = buf_doc-line.doc-code and buf_doc-line-attr.gds-code = ub.goods.gds-code and buf_doc-line-attr.attr-code = "tsd-qnty" no-error.
          if not available buf_doc-line-attr and first-of (TempDocLine.gds-code)
            then do:
              create buf_doc-line-attr.
              assign
                buf_doc-line-attr.attr-code = "tsd-qnty"
                buf_doc-line-attr.gds-code = ub.goods.gds-code
                buf_doc-line-attr.doc-code = buf_doc-line.doc-code
              .
            end.
            else do:
              TempDocLine.is-tsd-qnty = true.
            end.
        end.
        else do:
          LogWrite:LogStr = substitute ( "В инвентаризации &1 отсутсвует товар с кодом &2.", TempTrnDoc.ext-doc-code, TempDocLine.gds-code ).
          buf_trn-doc.ps = if buf_trn-doc.ps begins "@" then substitute ( "пропущен товар с кодом (штрих-код &3) &1&2.", TempDocLine.gds-code, {&new-line}, TempDocLine.b-code ) else substitute ( "&1&3 пропущен товар с кодом &2.",buf_trn-doc.ps, TempDocLine.gds-code, {&new-line} ).
          delete TempDocLine.
          next.
        end.
      end.
    end.
    else 
    do:
      LogWrite:LogStr = "Нет инвентаризации в статусе разр+ с кодом: " + TempTrnDoc.ext-doc-code.
      SomeStr = getStatusXml(false, "Нет инвентаризации в статусе разр+ с кодом: " + TempTrnDoc.ext-doc-code).
  
      return false.
    end.
    
    os-delete value (search ("doctsd.txt")) no-error.
    os-delete value (search ("newdoctsd.txt")) no-error.
    output stream str1 to value ("doctsd.txt").
    output stream str2 to value ("newdoctsd.txt").
    for each TempDocLine where TempDocLine.is-tsd-qnty = true:
      put stream str1 unformatted TempDocLine.b-code "," TempDocLine.fact-qnty skip.
    end.
    for each TempDocLine where TempDocLine.is-tsd-qnty = false:
      put stream str2 unformatted TempDocLine.b-code "," TempDocLine.fact-qnty skip.
    end.
    output stream str1 close.
    output stream str2 close.
    if can-find (first TempDocLine)
    then do: 
      run gbl/filnline.p (input ("doctsd.txt"), output varzero-string).
      if varzero-string 
      then do:
        run str/scantsd.p ( 2, input no , input recid(buf_trn-doc) ,input "doctsd.txt" ) no-error.
        if error-status:error then do:
          LogWrite:LogStr = LogWrite:LogStr + {&new-line} + return-value. 
          SomeStr = getStatusXml(false, LogWrite:LogStr).
          os-delete value (search ("doctsd.txt")) no-error.
          os-delete value (search ("newdoctsd.txt")) no-error.
          return false.
        end.
        else LogWrite:LogStr = LogWrite:LogStr + {&new-line} + return-value.
      end.

      run gbl/filnline.p (input ("newdoctsd.txt"), output varzero-string).
      if varzero-string 
      then do:
        run str/scantsd.p ( 1, input no , input recid(buf_trn-doc) ,input "newdoctsd.txt" ) no-error.
        if error-status:error then do:
          LogWrite:LogStr = LogWrite:LogStr + {&new-line} + return-value. 
          SomeStr = getStatusXml(false, LogWrite:LogStr).
          os-delete value (search ("doctsd.txt")) no-error.
          os-delete value (search ("newdoctsd.txt")) no-error.
          return false.
        end.
        else LogWrite:LogStr = LogWrite:LogStr + {&new-line} + return-value.
      end.

    end.
    os-delete value (search ("doctsd.txt")) no-error.
    os-delete value (search ("newdoctsd.txt")) no-error.
    SomeStr = getStatusXml(true, "").
    return true.
    
    /*
    
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
          LogWrite:LogStr = "Не известный штрих-код:" + TempDocLine.b-code + {&new-line}.
          SomeStr = getStatusXml(false, "Не известный штрих-код: " + TempDocLine.b-code).

          return false.
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
  
    
    adapterOra-i506 = new AdapterOra-i506().
    
    adapterOra-i506:SetTempTable(table TempTrnDoc, table TempDocLine, userId_ ).
    
    glog = adapterOra-i506:WriteDB().
    
    LogWrite:LogStr = LogWrite:LogStr + {&new-line} + adapterOra-i506:StrLog.
    delete object AdapterOra-i506.
    
    if glog
      then 
    do:
      SomeStr = getStatusXml(true, "").
      return true.
    end.
    else 
    do:
      SomeStr = getStatusXml(false, LogWrite:LogStr).
      return false.
    end.*/
    
  end.


  method public void CodePageConvert ():
    
    define variable str as char no-undo.
    
    
    if session:charset <> replace (CP, "windows-", "") 
      then do:
        str = codepage-convert (SomeStr, replace (CP, "windows-", ""), session:charset) no-error.
        if str = ? 
          then.
          else SomeStr = str. 
      end.
        
  end.  
  

  method public void WriteUnknown ():
    
    SomeStr = getStatusXml(false, "Неизвестный запрос.").
   
  end.

  method public integer GetDbNum ():
    define buffer buf_sys-ctrl for ub.sys-ctrl .
  
    do
    on error undo, return error return-value
    :
      for first buf_sys-ctrl field (db-num) no-lock :
       return buf_sys-ctrl.db-num.
      end.
  
    end.
  end method.

end class.
