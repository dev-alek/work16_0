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

using ibs.th.gbl.*.
using ibs.th.skt.Adapters.*.
using ibs.th.str.alcohol.*.
using ibs.th.skt.ControlledClients.*.
using ibs.th.gbl.sys.objth.
using ibs.th.str.utd.handlers.introduce.
using ibs.th.gbl.env.prmtrs.edo.
using ibs.th.gbl.sys.objsrv.
using ibs.th.str.marking.sts.*.
block-level on error undo, throw.

class ibs.th.skt.ControlledClients.TSD inherits objth: 
     define override public property vss-revision    as character no-undo init "$Revision:$":U get .
     define override public property vss-author      as character no-undo init "$Author:$":U get.
     define override public property vss-date        as character no-undo init "$Date:$":U get.
     define override public property vss-workfile    as character no-undo init "$Workfile:$":U get.
     define override public property vss-archive     as character no-undo init "$Archive:$":U get.
     define override public property vss-description as character no-undo init "клас для подготовки даныных для ТСД и загрузки из него" get.
    
   
  &scop delimiteFld chr(30)
  &scop delimiterLine chr(31)
  
  { str/marks.i         }
  { cmp/str-glbl.i class}
  { gbl/attr-lib.i class}
  {str/lib-trn.i class}
  { str/utd-attr.i class }
  { str/utd-err.i class }
  {ibs/th/skt/ControlledClients/TSDTT.i}
  { str/utd-err.i class }
  {ibs/th/gbl/doc-codeClass.i}
  {ibs/th/gbl/basecodeClass.i}
  
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

  define public property CurrDecSeparator as character no-undo init ","
      get.
      set.

  define public property CurrDecSeparatorTH as character no-undo
      get:
        return session:numeric-decimal-point.
      end.

  define public property IsMarkOn as logical no-undo init false
      get.
      set.
      
  define public property CP as character no-undo
    get.
    set.

  define private variable tthDocument as handle no-undo.
  define private stream tsdstream.
  define private variable logWrite     as class     LogWrite     no-undo.
  define private variable keyrec       as class     keyrec       no-undo.
  define private variable v-keyrec     as character no-undo.

  define         variable v-today  as date      no-undo .
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
		
  constructor public TSD (  ):

    keyrec = new keyrec ().
    logWrite = new LogWrite().
    if not valid-handle (ibs.th.gbl.gbl-hndllib:g#trdcalib)
    then do:
      run str/trdcalib.p persistent no-error.
    end.
    { str/trdcalib.i class}
    os-delete value (search ("MT_documents.txt")) no-error.
    os-delete value (search ("MT_lines.txt")) no-error.
    os-delete value (search ("MT_MarkLines.txt")) no-error.
		
  end constructor.
  method public void clear():
     os-delete value (search ("MT_documents.txt")) no-error.
    os-delete value (search ("MT_lines.txt")) no-error.
    os-delete value (search ("MT_MarkLines.txt")) no-error.
  end.


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

  method private void tsdstreamopenapp (streamFile as char):
    
    output stream tsdstream to value (streamFile) append.

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
    
/*    define variable cHeader    as character no-undo.*/
/*    define variable cLine      as longchar no-undo. */
/*    define variable cMarkLine  as longchar no-undo. */
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
    define variable jj as integer no-undo.
    define variable jjm as integer no-undo.
    define variable iim as integer no-undo.
    define buffer buf_trn-doc    for ub.trn-doc.
    define buffer buf_doc-line   for ub.doc-line.
    define buffer buf_goods      for ub.goods.
    define buffer buf_bar-code   for ub.bar-code.
    define buffer buf_parts      for ub.parts.
    define buffer buf_gen-attr   for ub.gen-attr.
    define buffer buf_user-login for ub.user-login.
    
    def    var      internal-b-code like ub.bar-code.b-code no-undo .
    def    var      full-b-code     as character init "" no-undo .
    def    var      bc-frmt         as character no-undo .
    def    var      bc-pfx          as character no-undo .
    def    var      v-par-type      as character no-undo .

    define variable myflagsDoc     as class flagsdoc     no-undo.
    define variable myflagsDocLine as class flagsdocline no-undo.
    
    myflagsDoc = new flagsdoc ().
    myflagsDocLine = new flagsdocline ().
    
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

    find first ub.inv-doc-attr no-lock where ub.inv-doc-attr.doc-code = buf_trn-doc.doc-code and (ub.inv-doc-attr.attr-code = "ItogInv" or ub.inv-doc-attr.attr-code = "ItogInvManual" )no-error .
    if available (ub.inv-doc-attr) then next .  
    
    find first ub.inv-doc-attr no-lock where ub.inv-doc-attr.doc-code = buf_trn-doc.doc-code and ub.inv-doc-attr.attr-code = "invMultDevice" and ub.inv-doc-attr.attr-value = string(true) no-error .
    if not available (ub.inv-doc-attr) and buf_trn-doc.ext-doc-type = {&TDEDT_Inv} then next .  

      myflagsDoc:unSetAllFlags().
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
      if IsMarkOn and not docType = 'Inv'
      then do:
        for each buf_doc-line where buf_doc-line.doc-code = buf_trn-doc.doc-code no-lock:
          find first buf_goods no-lock where buf_goods.artic = buf_doc-line.artic and buf_goods.prod-code = buf_doc-line.prod-code 
            and buf_goods.prod-type = buf_doc-line.prod-type.                          
          find first ub.goods-attr where ub.goods-attr.gds-code = buf_goods.gds-code
            and ub.goods-attr.attr-code = {&attr-mark} and ub.goods-attr.attr-value = "yes" no-lock no-error.
          if available (ub.goods-attr)
          then do:
            myflagsDoc:isDocMarkOn = true.
            leave.
          end. 
        end.
      end.
      def var pos as int no-undo.
      if not myflagsDoc:isDocMarkOn
      then do:
        pos = 0.
        for each buf_doc-line where buf_doc-line.doc-code = buf_trn-doc.doc-code no-lock:
          find first buf_goods no-lock where buf_goods.artic = buf_doc-line.artic and buf_goods.prod-code = buf_doc-line.prod-code and buf_goods.prod-type = buf_doc-line.prod-type.
          find first buf_bar-code no-lock where buf_bar-code.gds-code = buf_goods.gds-code
            and buf_bar-code.unit-cli = buf_goods.unit-base.
          
          myflagsDocLine:unSetAllFlags().
          internal-b-code = buf_bar-code.b-code.
          { str/bc-gnrti.i "bc" "internal-b-code" "full-b-code"}
          pos = pos + 1.
          decDocQnty = if docType = 'inv' then buf_doc-line.doc-qnty - buf_doc-line.fact-qnty else buf_doc-line.doc-qnty.
          decFactQnty = if docType = 'inv' then buf_doc-line.doc-qnty else buf_doc-line.fact-qnty.
          
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
/*          cLine = cLine + substitute ('<line DocName="&1" GoodsID="&2" UnitBC="&3" BC="&4" Price="&5" DocQnty="&6" FactQnty="&7" AlcCode="&8" PartIDTH ="&9" />', buf_doc-line.doc-code, buf_goods.gds-code, buf_goods.unit-base, full-b-code, priceSale, docQnty, factQnty).*/
        tsdstreamopenapp("MT_lines.txt"). 
          jjm = jjm + 1.
          put stream tsdstream unformatted 
          substitute ("&2&1&3&1&4&1&5&1&6&1&7&1&8&1&9&1",
                      {&delimiteFld},
                      string (jjm),
                      buf_trn-doc.doc-code,
                      if docType = 'inv' then string (pos) else string (buf_doc-line.line-num),
                      buf_goods.gds-code,
                      buf_goods.gds-name,
                      buf_goods.unit-base,
                      full-b-code,
                      priceSale
                      
                      
                     )
                     +
           substitute ("&3&1&4&1&5&1&6&1&7&2",
                      {&delimiteFld},
                      {&delimiterLine},
                      docQnty,
                      "0",
                      "",
                      "",
                      string (myflagsDocLine:FlagsToInt)
)          
          .
          
        tsdstreamclose().
          
/*          dFactSum = buf_doc-line.fact-qnty + dFactSum.*/
        end.
      end.
      else do:
        def var v-alc-code as char no-undo.
        pos = 0.
        for each buf_doc-line where buf_doc-line.doc-code = buf_trn-doc.doc-code no-lock:
          find first buf_goods no-lock where buf_goods.artic = buf_doc-line.artic and buf_goods.prod-code = buf_doc-line.prod-code and buf_goods.prod-type = buf_doc-line.prod-type.
          find first buf_bar-code no-lock where buf_bar-code.gds-code = buf_goods.gds-code.
          
          for each buf_parts no-lock where
            buf_parts.obj-type = buf_trn-doc.obj-type and 
            buf_parts.obj-code = buf_trn-doc.obj-code and 
            buf_parts.artic = buf_doc-line.artic and
            buf_parts.prod-type = buf_doc-line.prod-type and
            buf_parts.prod-code = buf_doc-line.prod-code and
            buf_parts.out-code = buf_trn-doc.doc-code:
          
            internal-b-code = buf_bar-code.b-code.
            { str/bc-gnrti.i "bc" "internal-b-code" "full-b-code"}
            
            myflagsDocLine:unSetAllFlags().
            
            decDocQnty = buf_parts.qnty.
            decFactQnty = buf_parts.fact-qnty.
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
            keyrec:GenKeyRec({&table_parts}, buffer buf_parts:handle, output v-keyrec).
            v-alc-code = if num-entries  (buf_parts.alc-ref-ab-path, ",") < 3 then "" else entry (3, buf_parts.alc-ref-ab-path, ",").
/*            cLine = cLine + substitute ('<line DocName="&1" GoodsID="&2" UnitBC="&3" BC="&4" Price="&5" DocQnty="&6" FactQnty="&7" AlcCode="&8" PartIDTH ="&9" />',*/
/*            buf_doc-line.doc-code, buf_goods.gds-code, buf_goods.unit-base, full-b-code, priceSale, docQnty, factQnty, v-alc-code, v-keyrec).*/
            

            pos = pos + 1.
            iim = 0.
            tsdstreamopenapp("MT_MarkLines.txt").
            for each buf_gen-attr no-lock where buf_gen-attr.p-key = v-keyrec and buf_gen-attr.table-name = {&excise-mark}:
              iim = iim + 1.
              jj = jj + 1.
/*              cMarkLine = cMarkLine + substitute ('<MarkLines DocName="&1"  MarkCode="&2" Sts="&3" PartIDTH="&4" />', buf_doc-line.doc-code, buf_gen-attr.attr-code, "TH", v-keyrec).*/
              put stream tsdstream unformatted 
              substitute ("&3&1&4&1&5&1&6&1&7&2",
                      {&delimiteFld},
                      {&delimiterLine},
                      string (jj),
                      buf_trn-doc.doc-code,
                      buf_gen-attr.attr-code,
                      v-keyrec,
                      "TH"
                      
                     )             
          .
              
              string (jj) + {&delimiteFld} + 
              buf_trn-doc.doc-code + {&delimiteFld} + buf_gen-attr.attr-code + {&delimiteFld} 
              + v-keyrec + {&delimiteFld} + "TH" + {&delimiterLine}.
            end.
            tsdstreamclose().
            
            tsdstreamopenapp("MT_lines.txt"). 
              jjm = jjm + 1.
              if decimal (iim) = buf_parts.qnty
                then myflagsDocLine:isEditManualFullQnty = true.
                else myflagsDocLine:isNotEditManualQnty = true.
              put stream tsdstream unformatted 
              substitute ("&2&1&3&1&4&1&5&1&6&1&7&1&8&1&9&1",
                      {&delimiteFld},
                      string (jjm),
                      buf_trn-doc.doc-code,
                      string (pos),
                      string (buf_goods.gds-code),
                      buf_goods.gds-name,
                      buf_goods.unit-base,
                      full-b-code,
                      priceSale
                      
                      
                     )
                     +
             substitute ("&3&1&4&1&5&1&6&1&7&2",
                      {&delimiteFld},
                      {&delimiterLine},
                      docQnty,
                      "0",
                      "", /* v-alc-code */
                      v-keyrec,
                      string (myflagsDocLine:FlagsToInt)
                     )
              
          .
            tsdstreamclose().
            
/*            dFactSum = buf_doc-line.fact-qnty + dFactSum.*/
          end.
        end.      
      end.
      
      FactSum = if dFactSum > -1 and dFactSum < 1 then replace (string (dFactSum), ".", "0,") else replace (string (dFactSum), ".", ",").
      if buf_trn-doc.ext-doc-type = {&TDEDT_Inv} then myflagsDoc:setFlagsToInt(1). /* Было решено сделать флаг 1 всегда для инвентаризаций на АКС от 22.04.2025 */
      
      find first buf_user-login where buf_user-login.user-id = buf_trn-doc.user-name  no-lock no-error.
      
      tsdstreamopenapp("MT_documents.txt"). 
        put stream tsdstream unformatted buf_trn-doc.doc-code + {&delimiteFld} + 
        docType + {&delimiteFld} + "false" + {&delimiteFld} + buf_trn-doc.status_ + string (buf_trn-doc.flag, "+/-") + {&delimiteFld} + 
        string (buf_trn-doc.cli-code) + {&delimiteFld} + buf_trn-doc.cli-type + {&delimiteFld} + 
        string (buf_trn-doc.obj-code) + {&delimiteFld} + buf_trn-doc.obj-type + {&delimiteFld} + 
        (if available (buf_user-login)
        then buf_trn-doc.user-name + {&delimiteFld} + buf_user-login.user-login + {&delimiteFld} else {&delimiteFld} + {&delimiteFld}
        ) +
        string (FactSum) + {&delimiteFld} + string (iso-date (datetime-tz (buf_trn-doc.doc-date, buf_trn-doc.real-time-create * 1000))) + {&delimiteFld} 
        + string(myflagsDoc:FlagsToInt) + {&delimiterLine}.
      
      tsdstreamclose().

      
/*      SomeStr = SomeStr + cHeader + cLine + cMarkLine.*/

    end.
/*    SomeStr = substitute ('<?xml version="1.0" encoding="&1"?><TSD>', CP) + SomeStr + ('</TSD>').*/
/*    output stream logTSD to value ("logSKTTSD.txt").*/
/*    export stream logTSD SomeStr.                   */
/*    output stream logTSD close.                     */

  end method.

  method public void Check_ ():
    
    define variable confPar   as character no-undo.
    define variable parType   as character no-undo.
    define variable statusOK  as logical   no-undo init false.
    define buffer buf_clients   for ub.clients.
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
    define buffer buf_user-login for ub.user-login.
    tsdstreamopen("TH_users.txt").
    dbNum = GetDbNum().
    for each buf_user-login where buf_user-login.status_ = 0 and buf_user-login.db-num = dbNum no-lock:
      put stream tsdstream unformatted buf_user-login.user-id + {&delimiteFld} + buf_user-login.user-login + {&delimiterLine}.
    end.
    tsdstreamclose().
    
  end.


  method public void WriteObjects ():
    define buffer buf_clients   for ub.clients.
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
    define buffer buf_clients   for ub.clients.
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
    define variable is-petrol   as logical no-undo.
    define variable is-pieces   as logical no-undo.  
    define buffer buf_goods     for ub.goods.
    define buffer buf_gds-obj   for ub.gds-obj.

    tsdstreamopen("TH_goods.txt").
    cicle:
    for each buf_goods where buf_goods.stts = 0 and gds-type = 'т' no-lock use-index ists:
      
      { str/is-petrl.i
          buf_goods.artic
          buf_goods.prod-type
          buf_goods.prod-code
          is-petrol
          is-pieces
          no-error
      }
      if is-petrol = yes and is-pieces = no then do:
        next cicle.
      end.
      
      find first buf_gds-obj where buf_gds-obj.gds-code = buf_goods.gds-code no-lock no-error.
      if not available (buf_gds-obj)
      then do:
        find first ub.utd-lines where ub.utd-lines.gds-code = buf_goods.gds-code no-lock no-error.
        if not available (ub.utd-lines)
          then next cicle.
      end.
      
/*      find first buf_bar-code where buf_bar-code.gds-code = buf_goods.gds-code and buf_bar-code.stts = 0 no-lock use-index prt-parts no-error.*/
      
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
        priceSale = if dPriceSale > -1 and dPriceSale < 1 then replace (priceSale, ".", "0" + CurrDecSeparatorTH) else replace (priceSale, ".",  CurrDecSeparatorTH)
        factQnty  = if available buf_gds-obj and buf_gds-obj.fact-qnty > -1 and buf_gds-obj.fact-qnty < 1 then replace (factQnty, ".", "0" + CurrDecSeparatorTH) else replace (factQnty, ".", CurrDecSeparatorTH)
        freeQnty  = if available buf_gds-obj and buf_gds-obj.free-qnty > -1 and buf_gds-obj.free-qnty < 1 then replace (freeQnty, ".", "0" + CurrDecSeparatorTH) else replace (freeQnty, ".", CurrDecSeparatorTH)
        .
        
      put stream tsdstream unformatted 
        string (buf_goods.gds-code) + {&delimiteFld} + 
        trim (buf_goods.gds-name, chr (9)) + {&delimiteFld} + 
        buf_goods.unit-base + {&delimiteFld} +
        priceSale + {&delimiteFld} +
        vatPc + {&delimiteFld} +
        countryName  + {&delimiteFld} +
        "Состав" + {&delimiteFld} +
        factQnty + {&delimiteFld} + 
        freeQnty + {&delimiterLine}.

    end.
    
/*    put stream tsdstream unformatted                          */
/*      string (9999) + {&delimiteFld} +                        */
/*      trim ("Первоначальный ввод", chr (9)) + {&delimiteFld} +*/
/*      "макра" + {&delimiteFld} +                              */
/*      "0" + {&delimiteFld} +                                  */
/*      "0" + {&delimiteFld} +                                  */
/*      ""  + {&delimiteFld} +                                  */
/*      "Состав" + {&delimiteFld} +                             */
/*      "0" + {&delimiteFld} +                                  */
/*      "0" + {&delimiterLine}.                                 */
/*                                                              */
    
    tsdstreamclose().
        
  end.


  method public void WriteBarcodes (input iprotocol as char):

    define variable cliBaseRate     as character no-undo.
    define variable priceSale       as character no-undo.
    define variable internal-b-code like ub.bar-code.b-code no-undo .
    define variable full-b-code     as character init "" no-undo .
    define variable bc-frmt         as character no-undo .
    define variable bc-pfx          as character no-undo .
    define variable v-par-type      as character no-undo .
    define variable is-petrol      as logical no-undo.
    define variable is-pieces      as logical no-undo.    
    define buffer buf_goods     for ub.goods.
    define buffer buf_bar-code  for ub.bar-code.
    define buffer buf_price-all for ub.price-all.
    define buffer buf_prod-bc   for ub.prod-bc.
    define variable vMarkingType   as logical no-undo.
    run gbl/conf-rd.p ("bc-pfx", "", "", 0, "", "", "", yes, output bc-pfx, output v-par-type) no-error.
    run gbl/conf-rd.p ("bc-frmt", "", "", 0, "", "", "", yes, output bc-frmt, output v-par-type) no-error.   
    define variable EDOParSec as class ibs.th.gbl.env.prmtrs.edo .
    EDOParSec = ObjSrv:Env:ParametrsOfSection:GetSectionEDO(ObjType, ObjCode).
    empty temp-table TempBCode.
    tsdstreamopen("TH_barcodes.txt").
    cicle:
    for each buf_goods where buf_goods.stts = 0 and gds-type = 'т' no-lock use-index ists:
      
      { str/is-petrl.i
          buf_goods.artic
          buf_goods.prod-type
          buf_goods.prod-code
          is-petrol
          is-pieces
          no-error
      }
      if is-petrol = yes and is-pieces = no then do:
        next cicle.
      end.
      if iprotocol > "" then do:
      define variable v-value as character no-undo.
      define variable v-type  as character no-undo.
      &scop proc-name gds-attr-value
       {&run_proc_attr-lib}
         (input  buf_goods.gds-code
         ,input  {&attr-mark-type}
         ,output v-value
         ,output v-type
         ) no-error .
       if error-status :error
       then do:
         undo, return error return-value .
       end.
       vMarkingType = (EDOParSec:GetIsEDOForType(v-value) or EDOParSec:GetIsArticForType(v-value)) and not EDOParSec:GetIsTransitionalForType(v-value).
      end.
      for each buf_bar-code where buf_bar-code.in-code = "" and buf_bar-code.gds-code = buf_goods.gds-code and buf_bar-code.stts_ = 0 no-lock use-index prt-parts:

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

        find first ub.gds-obj no-lock where 
                      ub.gds-obj.artic = buf_goods.artic
                  and ub.gds-obj.prod-type = buf_goods.prod-type
                  and ub.gds-obj.prod-code = buf_goods.prod-code no-error.
        
        if available buf_price-all and not buf_price-all.price-sale = ?
          then priceSale = string (buf_price-all.price-sale).
          else if available (ub.gds-obj) and not ub.gds-obj.price-sale = ?
            then priceSale = string (ub.gds-obj.price-sale).
            else priceSale = "0".
        if iprotocol > "" then do:
        if priceSale = "0"
        then
           priceSale =  trim(string(1 / 100000,">>>>>>>>>>>9.99<<<<<<")).  
        end.
        assign
/*          priceSale   = if available buf_price-all then string (buf_price-all.price-sale) else ().*/
          cliBaseRate = string (buf_bar-code.cli-base-rate)
          .
        assign 
          priceSale = if available buf_price-all and buf_price-all.price-sale > -1 and buf_price-all.price-sale < 1 then replace (priceSale, ".", "0" + CurrDecSeparatorTH) else replace (priceSale, ".", CurrDecSeparatorTH)
          cliBaseRate = if buf_bar-code.cli-base-rate > -1 and buf_bar-code.cli-base-rate < 1 then replace (cliBaseRate, ".", "0" + CurrDecSeparatorTH) else replace (cliBaseRate, ".", CurrDecSeparatorTH)
          .
/*        create TempBCode.                                                                                                             */
/*                                                                                                                                      */
/*        assign                                                                                                                        */
/*          TempBCode.gds-code = buf_goods.gds-code                                                                                     */
/*          TempBCode.b-str = full-b-code                                                                                               */
/*          TempBCode.priceSale = (if available buf_prod-bc-attr and  logical(buf_prod-bc-attr.attr-value) then "-" else "") + priceSale*/
/*          TempBCode.unit-cli = buf_bar-code.unit-cli                                                                                  */
/*          TempBCode.cliBaseRate = cliBaseRate                                                                                         */
/*        no-error.                                                                                                                     */
/*                                                                                                                                      */
/*        if error-status:error                                                                                                         */
/*        then do:                                                                                                                      */
/*          delete TempBCode.                                                                                                           */
/*          LogWrite:LogStr = LogWrite:LogStr + {&new-line} + substitute ( "Ошибка передачи бар-кода &1 в ТСД.", full-b-code).          */
/*        end.                                                                                                                          */
        
        for each buf_prod-bc no-lock where buf_prod-bc.b-code = buf_bar-code.b-code and buf_prod-bc.bc-on = yes:
        
        if iprotocol > "" then do:
        define buffer buf_prod-bc-attr for ub.prod-bc-attr.
        find first buf_prod-bc-attr where buf_prod-bc-attr.b-code eq buf_prod-bc.b-code
                              and buf_prod-bc-attr.b-str eq buf_prod-bc.b-str 
                              and buf_prod-bc-attr.attr-code eq {&mark}
        no-lock no-error.
        end. 
          
        create TempBCode.
              
          assign
            TempBCode.gds-code = buf_goods.gds-code
            TempBCode.b-str = buf_prod-bc.b-str            
            TempBCode.unit-cli = buf_bar-code.unit-cli
            TempBCode.cliBaseRate = cliBaseRate 
          no-error.

          if error-status:error
          then do:
            delete TempBCode.
            LogWrite:LogStr = LogWrite:LogStr + {&new-line} + substitute ( "Ошибка передачи бар-кода &1 в ТСД.", buf_prod-bc.b-str).
          end.
          if iprotocol > "" then
          TempBCode.priceSale = (if vMarkingType or (available buf_prod-bc-attr and  logical(buf_prod-bc-attr.attr-value)) then "-" else "") + priceSale .
          else TempBCode.priceSale = priceSale .
          
        end.
      end.

    end.
    
/*    create TempBCode.            */
/*    assign                       */
/*      TempBCode.gds-code = 9999  */
/*      TempBCode.b-str = "9999"   */
/*      TempBCode.priceSale = "0"  */
/*      TempBCode.unit-cli = "шт"  */
/*      TempBCode.cliBaseRate = "0"*/
/*    .                            */
    
    
    for each TempBCode:
        
        put stream tsdstream unformatted
          string (TempBCode.gds-code) + {&delimiteFld} +
          TempBCode.b-str + {&delimiteFld} +
          TempBCode.priceSale + {&delimiteFld} +
          TempBCode.unit-cli + {&delimiteFld} +
          TempBCode.cliBaseRate + {&delimiterLine}.
          
    end.
    
    tsdstreamclose().
    empty temp-table TempBCode.
  end.

  
  method public logical ImpWB (table TempTrnDoc, table TempDocLine, table TempMarkLine, userId_ as char):

    define buffer buf_trn-doc       for ub.trn-doc.
    define buffer buf_doc-line      for ub.doc-line.
    define buffer buf_doc-line-attr for ub.doc-line-attr.
    define variable adapterOra-i516 as class   AdapterOra-i516.
    define variable glog           as logical   no-undo.
    define variable mes            as character no-undo.
    define variable hLibMarks      as handle    no-undo.
    define variable ii             as integer   no-undo.
    define variable varzero-string as logical   no-undo.

    define variable myflagsDoc     as class flagsdoc     no-undo.

    find first TempTrnDoc.
    if TempTrnDoc.ext-doc-code = {&TDEDT_Inv} then TempTrnDoc.Flags_ = 1 .
    myflagsDoc = new flagsdoc ().
    myflagsDoc:setFlagsToInt(TempTrnDoc.Flags_).
    
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
      
      output to "marks.txt".
      for each ub.gen-attr where num-entries (ub.gen-attr.p-key, {&delim-key}) > 6 and entry (8, ub.gen-attr.p-key, {&delim-key}) = buf_trn-doc.doc-code:
        export ub.gen-attr.
      end.
      put skip "полученные с TSD" skip.
      for each TempMarkLine:
        export TempMarkLine.
      end.
      output close.
      
      if myflagsDoc:isDocMarkOn
      then do:
        for each TempDocLine no-lock where not TempDocLine.fact-qnty = 0 break by TempDocLine.gds-code:
          for each TempMarkLine where lookup (TempMarkLine.PartIDTH, TempDocLine.PartIDTH, {&delim-par}) > 0 and TempMarkLine.Sts = "TH" no-lock:
            for each ub.gen-attr where ub.gen-attr.p-key = TempMarkLine.PartIDTH and ub.gen-attr.attr-code = TempMarkLine.MarkCode and ub.gen-attr.table-name = {&excise-mark}:
              delete ub.gen-attr.
            end.
          end.
        end.
        for each TempMarkLine where TempMarkLine.Sts = "crTSD" no-lock:
          create ub.gen-attr.
          ub.gen-attr.p-key = TempMarkLine.PartIDTH.
          ub.gen-attr.attr-code = TempMarkLine.MarkCode.
          ub.gen-attr.table-name = {&excise-mark}.
          ub.gen-attr.whole-send-news = 0.
        end.
      end.
      
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
          run str/scantsd.p ( 2, input no , input recid(buf_trn-doc) ,input "doctsd.txt", if myflagsDoc:isDocMarkOn then "rsvmarks" else "" ) no-error.
          if error-status:error then do:
            LogWrite:LogStr = LogWrite:LogStr + {&new-line} + return-value. 
            SomeStr = getStatusXml(false, LogWrite:LogStr).
            os-delete value (search ("doctsd.txt")) no-error.
            os-delete value (search ("newdoctsd.txt")) no-error.
            return false.
          end.
/*          else LogWrite:LogStr = LogWrite:LogStr.*/
        end.
  
        run gbl/filnline.p (input ("newdoctsd.txt"), output varzero-string).
        if varzero-string 
        then do:
          run str/scantsd.p ( 1, input no , input recid(buf_trn-doc) ,input "newdoctsd.txt", if myflagsDoc:isDocMarkOn then "rsvmarks" else "" ) no-error.
          if error-status:error then do:
            LogWrite:LogStr = LogWrite:LogStr + {&new-line} + return-value. 
            SomeStr = getStatusXml(false, LogWrite:LogStr).
            os-delete value (search ("doctsd.txt")) no-error.
            os-delete value (search ("newdoctsd.txt")) no-error.
            return false.
          end.
/*          else LogWrite:LogStr = LogWrite:LogStr.*/
        end.
  
      end.
      os-delete value (search ("doctsd.txt")) no-error.
      os-delete value (search ("newdoctsd.txt")) no-error.
      
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
    define buffer bfTempDocLineTSD  for TempDocLineTSD .
    define buffer bf_inv-doc-attr   for ub.inv-doc-attr .
        
    define variable adapterOra-i506 as class   AdapterOra-i506.
    define variable varzero-string  as logical no-undo.
    define variable myflagsDoc     as class flagsdoc     no-undo.
    define variable myflagsDocLine as class flagsdocline no-undo.
    define variable invMulti as logical no-undo .
    define variable ii              as integer   no-undo init 0 .
    define variable vardoc-code     like ub.trn-doc.doc-code no-undo.
    define variable v-marking-type  as character no-undo .
    define variable v-type          as character no-undo .
    define variable isManual        as logical   no-undo .
    def    var      Marking         as class     mark            no-undo .
    
    find first TempTrnDoc.
    myflagsDoc = new flagsdoc ().
    myflagsDocLine = new flagsdocline ().
    myflagsDoc:setFlagsToInt(TempTrnDoc.Flags_).

    find first buf_trn-doc no-lock where buf_trn-doc.doc-code = TempTrnDoc.ext-doc-code
      and buf_trn-doc.status_ = {&permitted} no-error.
    if available buf_trn-doc then 
    do:
      invMulti = false .
      ii = 0 .
      find first ub.inv-doc-attr no-lock where ub.inv-doc-attr.doc-code = TempTrnDoc.ext-doc-code and
        ub.inv-doc-attr.attr-code = 'invMultDevice' and ub.inv-doc-attr.attr-value = string(true) no-error .
      if available (ub.inv-doc-attr) then invMulti = true .
      if invMulti = false then next .  
      if invMulti then 
      do:
        find last ub.trn-doc no-lock where ub.trn-doc.status_ = {&inquiry} and TempTrnDoc.ext-doc-code = entry(1,ub.trn-doc.doc-code,"/") no-error .
        if available (ub.trn-doc) then 
        do:
          ii = integer(entry(2,ub.trn-doc.doc-code,"/")) .
          TempTrnDoc.ext-doc-code = entry(1,ub.trn-doc.doc-code,"/") + "/" + string(ii + 1) .
        end. 
        else TempTrnDoc.ext-doc-code = TempTrnDoc.ext-doc-code + "/" + string(ii + 1) .
        TempTrnDoc.Status_= {&inquiry} .
      end.
      if invMulti then 
      do:
        create ub.trn-doc .
        ub.trn-doc.doc-code = TempTrnDoc.ext-doc-code .
        ub.trn-doc.status_ = {&inquiry} .
        ub.trn-doc.flag_ = no .
        buffer-copy buf_trn-doc except doc-code status_ flag_ to ub.trn-doc .
        find first ub.inv-doc-attr exclusive-lock where ub.inv-doc-attr.doc-code = ub.trn-doc.doc-code
        and ub.inv-doc-attr.attr-code = 'invMultDevice' no-error .
        if not available (ub.inv-doc-attr) then do:
        create ub.inv-doc-attr .
        assign
        ub.inv-doc-attr.doc-code = ub.trn-doc.doc-code
        ub.inv-doc-attr.attr-code = 'invMultDevice' .
        end.
        ub.inv-doc-attr.attr-value = string(true) .
      end. 
      for each TempDocLine no-lock break by TempDocLine.gds-code:
        find first ub.goods where ub.goods.gds-code  = TempDocLine.gds-code
          no-lock no-error .
        find first buf_doc-line exclusive-lock where buf_doc-line.doc-code = buf_trn-doc.doc-code
          and buf_doc-line.artic = ub.goods.artic
          and buf_doc-line.prod-type = ub.goods.prod-type
          and buf_doc-line.prod-code = ub.goods.prod-code
          no-error  .
        if available buf_doc-line then do:
          if invMulti then do:
          create ub.doc-line .
          ub.doc-line.doc-code = TempTrnDoc.ext-doc-code .
          buffer-copy buf_doc-line except doc-code to ub.doc-line .
          assign
          ub.doc-line.doc-qnty = TempDocLine.fact-qnty .
          ub.doc-line.fact-qnty = TempDocLine.fact-qnty - TempDocLine.doc-qnty .
          end.
/*          else do:                                                               */
/*          assign                                                                 */
/*          buf_doc-line.doc-qnty = TempDocLine.fact-qnty .                        */
/*          buf_doc-line.fact-qnty = TempDocLine.fact-qnty - TempDocLine.doc-qnty .*/
/*          end.                                                                   */
          find first buf_doc-line-attr where buf_doc-line-attr.doc-code = buf_doc-line.doc-code and buf_doc-line-attr.gds-code = ub.goods.gds-code and buf_doc-line-attr.attr-code = "tsd-qnty" no-lock no-error.
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
            release ub.doc-line .
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
      if not (TempTrnDoc.ext-doc-code begins "TSD-") then do:
      LogWrite:LogStr = "Нет инвентаризации в статусе разр+ с кодом: " + TempTrnDoc.ext-doc-code.
      SomeStr = getStatusXml(false, "Нет инвентаризации в статусе разр+ с кодом: " + TempTrnDoc.ext-doc-code).
  
      return false.
      end.
        /* Проверка на создание итогового документа */
    find first bf_inv-doc-attr no-lock where bf_inv-doc-attr.attr-code = "ItogInv" and bf_inv-doc-attr.attr-value = TempTrnDoc.ext-doc-code no-error .
    if available (bf_inv-doc-attr) then leave .       
   
    empty temp-table TempDocLineTSD .
    find first ub.clients no-lock where ub.clients.obj-code = TempTrnDoc.obj-code and
      ub.clients.obj-type = TempTrnDoc.obj-type no-error .
    if available (ub.clients) then 
    do:    
      /*Загрузка инвенаризации с ТСД*/
      /*Проверка товаров*/    
      isManual = true .
      for each TempDocLine:
        find first ub.goods no-lock where string(ub.goods.gds-code) = TempDocLine.b-code no-error .
        if available (ub.goods) then 
        do:
          createTempGoods(false) .
        end.
        else 
        do:
          find first ub.prod-bc no-lock where (string(ub.prod-bc.b-code) = TempDocLine.b-code or ub.prod-bc.b-str = TempDocLine.b-code) no-error .
          if available (ub.prod-bc) then 
          do:
            find first ub.bar-code no-lock where ub.bar-code.b-code = ub.prod-bc.b-code .
            find first ub.goods no-lock where ub.goods.gds-code = ub.bar-code.gds-code .
            createTempGoods(false) .
          end.
          else 
          do:
            find first ub.marking no-lock where ub.marking.mark = TempDocLine.b-code no-error .
            if available (ub.marking) then 
            do:
              find first ub.goods no-lock where ub.goods.gds-code = ub.marking.gds-code .
              createTempGoods(true) .
            end.
            else 
            do:
              createTempGoodsError() .
            end.
          end.
        end.
      end.
       /*проверяем на помарочный учет*/
      for each TempDocLineTSD where not TempDocLineTSD.Flags_error:
        &scop proc-name gds-attr-value
        {&run_proc_attr-lib}
          (input  TempDocLineTSD.gds-code
          ,input  {&attr-mark-type}
          ,output v-marking-type
          ,output v-type
          ) no-error .
        if error-status :error
          then 
        do:
          undo, return error return-value .
        end.
        if ObjSrv:Env:ParametrsOfSection:GetSectionEDO(ub.clients.obj-type, ub.clients.obj-code):GetIsMarkingForType(v-marking-type) 
          then 
        do:
          TempDocLineTSD.mark-type = v-marking-type .
          find first ub.marking no-lock where ub.marking.mark = TempDocLineTSD.mark and ub.marking.sts = Marking:FreeZone:KeyIntDB no-error .
          if not available (ub.marking) then 
          do:
            TempDocLineTSD.Flags_error = true.
          end.
        end.
      end.
      if can-find(TempDocLineTSD where TempDocLineTSD.mark-type <> "") then 
      do:
        if can-find(TempDocLineTSD where TempDocLineTSD.mark-type = "") then 
        do:
          for each TempDocLineTSD where not TempDocLineTSD.Flags_error and TempDocLineTSD.mark-type <> "":
            TempDocLineTSD.Flags_error = true .
          end.
        end.  
      end.  
      find first TempDocLineTSD no-error .
      if available (TempDocLineTSD) then 
      do:
        /*номер документа*/
        vardoc-code = docCode("main", ub.clients.obj-type, ub.clients.obj-code, ?) no-error .
        if error-status:error then 
        do:
          LogWrite:LogStr = "Ошибка при генерации номера документа." .
          SomeStr = getStatusXml(false, "Ошибка при генерации номера документа.").
          return false.
        end.
      end.
      find first TempDocLineTSD where not TempDocLineTSD.Flags_error no-error .
      if available (TempDocLineTSD) then 
      do:
        /*создаем накладную*/
        createTrn(vardoc-code,userId_).

        createAttrInv(vardoc-code,"isManual",string(true)).
        /*Создаем линии для накладной*/
        for each bfTempDocLineTSD where not bfTempDocLineTSD.Flags_:
          createDocLine(vardoc-code, bfTempDocLineTSD.gds-code, bfTempDocLineTSD.fact-qnty).
        end.
      end.      
      find first TempDocLineTSD where TempDocLineTSD.Flags_error no-error .
      if available (TempDocLineTSD) then 
      do:
        /*создаем ошибочную накладную*/
        createTrn(vardoc-code + "-M",userId_).
        createAttrInv(vardoc-code + "-M","isManualError",string(true)).
        for each bfTempDocLineTSD where bfTempDocLineTSD.Flags_:
          find first ub.goods where ub.goods.gds-code = bfTempDocLineTSD.gds-code no-error .
          if available (ub.goods) then do:
            createDocLine(vardoc-code + "-M", bfTempDocLineTSD.gds-code, bfTempDocLineTSD.fact-qnty).
          end.
          else do:
            createDocLineError(vardoc-code + "-M", bfTempDocLineTSD.artic, bfTempDocLineTSD.prod-code, bfTempDocLineTSD.prod-type, bfTempDocLineTSD.fact-qnty).
          end.
        end.
      end.
    end.      
    end.
    find last ub.trn-doc no-lock .
    release ub.trn-doc .
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
      if varzero-string and not invMulti
      then do:
        run str/scantsd.p ( 2, input no , input recid(buf_trn-doc) ,input "doctsd.txt", if myflagsDoc:isDocMarkOn then "rsvmarks" else "" ) no-error.
        if error-status:error then do:
          LogWrite:LogStr = LogWrite:LogStr + {&new-line} + return-value. 
          SomeStr = getStatusXml(false, LogWrite:LogStr).
          os-delete value (search ("doctsd.txt")) no-error.
          os-delete value (search ("newdoctsd.txt")) no-error.
          return false.
        end.
/*        else LogWrite:LogStr = LogWrite:LogStr + {&new-line} + return-value.*/
      end.

      run gbl/filnline.p (input ("newdoctsd.txt"), output varzero-string).
      if varzero-string 
      then do:
      if not isManual then 
      do: 
        if not invMulti then do:
        run str/scantsd.p ( 1, input no , input if invMulti then recid(ub.trn-doc) else recid(buf_trn-doc) ,input "newdoctsd.txt", if myflagsDoc:isDocMarkOn then "rsvmarks" else ""  ) no-error.
        if error-status:error then do:
          LogWrite:LogStr = LogWrite:LogStr + {&new-line} + return-value. 
          SomeStr = getStatusXml(false, LogWrite:LogStr).
          os-delete value (search ("doctsd.txt")) no-error.
          os-delete value (search ("newdoctsd.txt")) no-error.
          return false.
        end.
        end.
      end.
      end.

    end.
    os-delete value (search ("doctsd.txt")) no-error.
    os-delete value (search ("newdoctsd.txt")) no-error.
    SomeStr = getStatusXml(true, "").

    return true.
  end method.

method public void createTempGoods(mark_ as logical):
  define buffer del_TempDocLineTSD for TempDocLineTSD .
  if not mark_ then do:
  find first TempDocLineTSD where TempDocLineTSD.artic = ub.goods.artic and
    TempDocLineTSD.prod-code = ub.goods.prod-code and
    TempDocLineTSD.prod-type = ub.goods.prod-type no-error . 
  if not available (TempDocLineTSD) then 
  do:
    create TempDocLineTSD .
    assign
      TempDocLineTSD.gds-code  = ub.goods.gds-code
      TempDocLineTSD.artic     = ub.goods.artic
      TempDocLineTSD.prod-code = ub.goods.prod-code
      TempDocLineTSD.prod-type = ub.goods.prod-type
      .
  end.

  if TempDocLine.NotDict then 
  TempDocLineTSD.fact-qnty = TempDocLineTSD.fact-qnty + TempDocLine.fact-qnty * ub.bar-code.cli-base-rate .
  else TempDocLineTSD.fact-qnty = TempDocLineTSD.fact-qnty + TempDocLine.fact-qnty .
  end.
  /*марки*/
  else 
  do:
    find first ub.marking no-lock where ub.marking.mark = TempDocLine.b-code no-error .
    if available (ub.marking) then do:
          find first TempDocLineTSD where TempDocLineTSD.artic = ub.goods.artic and
    TempDocLineTSD.prod-code = ub.goods.prod-code and
    TempDocLineTSD.prod-type = ub.goods.prod-type no-error . 
      if not available (TempDocLineTSD) then 
  do:
    create TempDocLineTSD .
    assign
      TempDocLineTSD.gds-code  = ub.goods.gds-code
      TempDocLineTSD.artic     = ub.goods.artic
      TempDocLineTSD.prod-code = ub.goods.prod-code
      TempDocLineTSD.prod-type = ub.goods.prod-type
      TempDocLineTSD.mark = ub.marking.mark
      TempDocLineTSD.mark-parent = ub.marking.mark-parent
      .
      if ub.marking.mark-parent = "" then do:
        for each del_TempDocLineTSD where del_TempDocLineTSD.mark-parent = ub.marking.mark:
          delete del_TempDocLineTSD .
        end.
      end.
            TempDocLineTSD.fact-qnty   = TempDocLineTSD.fact-qnty + TempDocLine.fact-qnty * ub.marking.box-qnty.
      end.
      else do:
        if not TempDocLineTSD.mark = ub.marking.mark-parent then do:
    create TempDocLineTSD .
    assign
      TempDocLineTSD.gds-code  = ub.goods.gds-code
      TempDocLineTSD.artic     = ub.goods.artic
      TempDocLineTSD.prod-code = ub.goods.prod-code
      TempDocLineTSD.prod-type = ub.goods.prod-type
      TempDocLineTSD.mark = ub.marking.mark
      TempDocLineTSD.mark-parent = ub.marking.mark-parent
      .
      if ub.marking.mark-parent = "" then do:
        for each del_TempDocLineTSD where del_TempDocLineTSD.mark-parent = ub.marking.mark:
          delete del_TempDocLineTSD .
        end.
      end.
            TempDocLineTSD.fact-qnty   = TempDocLineTSD.fact-qnty + TempDocLine.fact-qnty * ub.marking.box-qnty.
                
        end.  
      end.
  end.
end.
end.
  
method public void createTempGoodsError():
  find first TempDocLineTSD where TempDocLineTSD.artic = TempDocLine.b-code and
    TempDocLineTSD.prod-code = 999999 and
    TempDocLineTSD.prod-type = "орг" no-error . 
  if not available (TempDocLineTSD) then 
  do:
    create TempDocLineTSD .
    assign
      TempDocLineTSD.artic       = TempDocLine.b-code
      TempDocLineTSD.prod-code   = 999999
      TempDocLineTSD.prod-type   = "орг"
      TempDocLineTSD.Flags_error = true
      .
  end.      
    .
  TempDocLineTSD.fact-qnty = TempDocLineTSD.fact-qnty + TempDocLine.fact-qnty .
end.
  
method public void createTrn(docCode as character, parUserId as character):
  define buffer bf_trn-doc    for ub.trn-doc .
  define buffer bf_curr-accnt for ub.curr-accnt .
  define buffer bf_sysconf    for ub.sysconf .
    
  find first ub.shop no-lock where ub.shop.obj-code = ub.clients.obj-code no-error .
  find first bf_sysconf no-lock where bf_sysconf.host-code = ub.clients.host-code .
  v-today = today .
  { str/crtrndoc.i
  ?
  ?
  1
  1
  ub.clients.host-code
  {&cmp}
  ub.clients.obj-name
  ub.clients.db-num
  parUserId
  "' '"
  docCode
  v-today
  {&inventory}
  no
  ub.clients.host-code
  no
  ub.clients.obj-code
  ub.clients.obj-type
  no
  ub.shop.inv-pay
  "'@  '"
  no
  ?
  {&wayb}
  ?
  {&TDEDT_Inv}
  ?
  no-error
  }
  
  if error-status:error then 
  do:
    return error return-value.
  end.
  find bf_trn-doc where bf_trn-doc.doc-code = docCode.
  assign
    bf_trn-doc.tot-calc = ?.

  assign
    bf_trn-doc.status_ = {&inquiry}
    bf_trn-doc.flag_   = no
    bf_trn-doc.PS      = TempTrnDoc.ext-doc-code + ", " + string(TempTrnDoc.doc-date)
    .

  find last bf_curr-accnt where bf_curr-accnt.curr-code = bf_sysconf.base-code
    and bf_curr-accnt.exch-date <= v-today use-index pi no-lock no-error.
  if not available bf_curr-accnt then 
  do:
    message "На дату" v-today "неизвестен курс базовой валюты." SKIP
      "Сумма по документу в валюте будет рассчитана при закрытии на факт".
  end.
  else 
  do:
    assign
      bf_trn-doc.base-rate  = bf_curr-accnt.exch-rate
      bf_trn-doc.base-scale = bf_curr-accnt.exch-scale.
  END.
  ASSIGN
    bf_trn-doc.exch-code  = 0
    bf_trn-doc.exch-rate  = 1
    bf_trn-doc.exch-scale = 1.

  { str/crinvdoc.i bf_trn-doc.doc-code no-error}
  if error-status:error then return error return-value.

end.
  
method public void createAttrInv(docCode as character, attrCode as character, attrValue as character):
  create ub.inv-doc-attr .
  assign
    ub.inv-doc-attr.doc-code   = docCode
    ub.inv-doc-attr.attr-code  = attrCode
    ub.inv-doc-attr.attr-value = attrValue
    .
end.
  
method public void createDocLine(pardoc-code as character, 
  pargds-code as integer, factQnty as decimal):

  define variable varis-petrolium as logical no-undo.
  define variable varis-pieces    as logical no-undo.
  define buffer cr_doc-line   for ub.doc-line.
  define buffer last_doc-line for ub.doc-line.
  define buffer new_trn-doc   for ub.trn-doc .
  define buffer new_goods     for ub.goods .
  define variable varline-num  as integer no-undo.
  define variable rec-inv-line as recid   no-undo.
  define variable v-vat-pc     as decimal no-undo .
  define variable v-slt-pc     as decimal no-undo .
  define buffer bf_sysconf for ub.sysconf .
    
  find first new_trn-doc no-lock where new_trn-doc.doc-code = pardoc-code no-error .
  find first new_goods no-lock where new_goods.gds-code = pargds-code no-error .
  find first bf_sysconf where bf_sysconf.host-code = new_trn-doc.host-code no-lock no-error .
  find last last_doc-line where last_doc-line.doc-code = pardoc-code use-index line-num no-lock no-error.
  if not available last_doc-line then 
  do:
    assign 
      varline-num = 1.
  end.
  else 
  do:
    assign 
      varline-num = last_doc-line.line-num + 1.
  end.
  find first cr_doc-line where cr_doc-line.doc-code  = pardoc-code  and
    cr_doc-line.artic     = new_goods.artic     and
    cr_doc-line.prod-type = new_goods.prod-type and
    cr_doc-line.prod-code = new_goods.prod-code no-error.
  if not available cr_doc-line then 
  do:
    v-vat-pc = pftxvalg(new_goods.gds-code, 1, ?, new_trn-doc.host-code, new_trn-doc.obj-type, new_trn-doc.obj-code) .
    v-slt-pc = st-sltpc(recid(new_goods), recid(new_trn-doc), if available(bf_sysconf) then bf_sysconf.cash-pay else 0) .
    create cr_doc-line.
    assign
      cr_doc-line.doc-code     = pardoc-code
      cr_doc-line.artic        = new_goods.artic
      cr_doc-line.prod-type    = new_goods.prod-type
      cr_doc-line.prod-code    = new_goods.prod-code
      cr_doc-line.obj-type     = new_trn-doc.obj-type
      cr_doc-line.obj-code     = new_trn-doc.obj-code
      cr_doc-line.status_      = new_trn-doc.status_
      cr_doc-line.ext-doc-type = new_trn-doc.ext-doc-type
      cr_doc-line.prt-root     = new_goods.prt-root
      cr_doc-line.vat-pc       = v-vat-pc
      cr_doc-line.slt-pc       = v-slt-pc
      cr_doc-line.cons-vat-pc  = bf_sysconf.cons-vat-pc
      cr_doc-line.line-num     = varline-num
      .

    if ( cr_doc-line.cli-base-rate = 0 or cr_doc-line.cli-base-rate = ? )
      then
      cr_doc-line.cli-base-rate = 1 .

  end.
  find first ub.prt-obj no-lock where ub.prt-obj.artic = cr_doc-line.artic and
    ub.prt-obj.prod-code = cr_doc-line.prod-code and
    ub.prt-obj.prod-type = cr_doc-line.prod-type and
    ub.prt-obj.obj-code = cr_doc-line.obj-code and
    ub.prt-obj.obj-type = cr_doc-line.obj-type no-error .
  if available (ub.prt-obj) then cr_doc-line.fact-qnty = factQnty - ub.prt-obj.fact-qnty .
  cr_doc-line.doc-qnty = factQnty .
end.
  
method public void createDocLineError(pardoc-code as character, 
  parartic as character, parprod-code as integer, parprod-type as character, factQnty as decimal):

  define variable varis-petrolium as logical no-undo.
  define variable varis-pieces    as logical no-undo.
  define buffer cr_doc-line   for ub.doc-line.
  define buffer last_doc-line for ub.doc-line.
  define buffer new_trn-doc   for ub.trn-doc .
  define buffer new_goods     for ub.goods .
  define variable varline-num  as integer no-undo.
  define variable rec-inv-line as recid   no-undo.
  define variable v-vat-pc     as decimal no-undo .
  define variable v-slt-pc     as decimal no-undo .
  define buffer bf_sysconf for ub.sysconf .
    
  find first new_trn-doc no-lock where new_trn-doc.doc-code = pardoc-code no-error .
  find first bf_sysconf where bf_sysconf.host-code = new_trn-doc.host-code no-lock.
  find last last_doc-line where last_doc-line.doc-code = pardoc-code use-index line-num no-lock no-error.
  if not available last_doc-line then 
  do:
    assign 
      varline-num = 1.
  end.
  else 
  do:
    assign 
      varline-num = last_doc-line.line-num + 1.
  end.
    
    create cr_doc-line.
    assign
      cr_doc-line.doc-code     = pardoc-code
      cr_doc-line.artic        = parartic
      cr_doc-line.prod-type    = parprod-type
      cr_doc-line.prod-code    = parprod-code
      cr_doc-line.obj-type     = new_trn-doc.obj-type
      cr_doc-line.obj-code     = new_trn-doc.obj-code
      cr_doc-line.status_      = new_trn-doc.status_
      cr_doc-line.ext-doc-type = new_trn-doc.ext-doc-type
      cr_doc-line.line-num     = varline-num
      .
  
  cr_doc-line.doc-qnty = factQnty .
  cr_doc-line.fact-qnty = factQnty .
end.
  method public logical ImpUTDDOC (table TempTrnDoc, table TempDocLine, table TempMarkLine):
    
    def var v-utd-db-num as integer no-undo.
    def var v-utd-doc-id as integer no-undo.
    def var v-ext-doc-code as character no-undo.
         
    define buffer buf_utd-marking-lines for ub.utd-marking-lines.
    
    for each TempTrnDoc :
      
      v-ext-doc-code = replace (entry (2, TempTrnDoc.ext-doc-code, "("),")","").
      assign
        v-utd-db-num = integer (entry (1, v-ext-doc-code, "_"))
        v-utd-doc-id = integer (entry (2, v-ext-doc-code, "_"))
      no-error.
      if error-status:error
        then next.
      tml_:
      for each TempMarkLine where TempMarkLine.Sts = "Check" or TempMarkLine.Sts = "CheckScan" or TempMarkLine.Sts = "CrTsd" :
        find first ub.utd-marking-lines where ub.utd-marking-lines.db-num = v-utd-db-num and ub.utd-marking-lines.doc-id = v-utd-doc-id 
          and ub.utd-marking-lines.mark = TempMarkLine.MarkCode 
          exclusive-lock no-error.
        if available (ub.utd-marking-lines)
        then do:
          ub.utd-marking-lines.sts = ObjSrv:Env:Marking:Sts:Mark:Checked_:KeyIntDB.
          find first ub.marking where ub.marking.mark = TempMarkLine.MarkCode no-lock no-error.
/*          ub.marking.sts = ObjSrv:Env:Marking:Sts:Mark:Checked_:KeyIntDB.*/
          if available  ub.marking and TempMarkLine.Sts = "CheckScan"
            then ungrg(ub.marking.mark-parent).
        end.
        else do:
          def var v-GTIN as char no-undo.
          def var v-mark-ident as char no-undo.
          v-GTIN = getGtinByDM(TempMarkLine.MarkCode) .
          v-mark-ident = GetCodeIdent(TempMarkLine.MarkCode).
          if v-GTIN <> "" then 
          do:
            find first buf_utd-marking-lines where
                  buf_utd-marking-lines.db-num = v-utd-db-num and buf_utd-marking-lines.doc-id = v-utd-doc-id 
              and buf_utd-marking-lines.mark begins TempMarkLine.MarkParent exclusive-lock no-error.
            if not available (buf_utd-marking-lines)
            then do:
              LogWrite:LogStr =  LogWrite:LogStr + {&new-line} + substitute ("Нарушена целостности либо изменен документ &1 на стороне TH", v-utd-doc-id).
              undo, return false.
            end.
            buf_utd-marking-lines.sts = ObjSrv:Env:Marking:Sts:Mark:Checked_:KeyIntDB.
            ungrg(buf_utd-marking-lines.mark).
            create ub.utd-marking-lines .
            assign
              ub.utd-marking-lines.db-num    = buf_utd-marking-lines.db-num
              ub.utd-marking-lines.doc-id    = buf_utd-marking-lines.doc-id
              ub.utd-marking-lines.gds-code  = buf_utd-marking-lines.gds-code
              ub.utd-marking-lines.LineNum   = buf_utd-marking-lines.LineNum
              ub.utd-marking-lines.doc-level = buf_utd-marking-lines.doc-level + 1
              ub.utd-marking-lines.mark      = v-mark-ident
             .
            if ismark(v-mark-ident)
            then do:
               find first ub.marking where ub.marking.mark = v-mark-ident exclusive-lock no-error.
               if not available (ub.marking) 
                 then create ub.marking .
               assign
                 ub.marking.gds-code    = ub.utd-marking-lines.gds-code
                 ub.marking.mark        = v-mark-ident
                 ub.marking.mark-parent = buf_utd-marking-lines.mark
                 ub.marking.sts         = ObjSrv:Env:Marking:Sts:Mark:PendingVerification:KeyIntDB
                 ub.marking.gds-ext-id  = v-GTIN
                 ub.marking.obj-code    = TempTrnDoc.obj-code
                 ub.marking.obj-type    = TempTrnDoc.obj-type
                 .
               ub.marking.unit-ext = getLevelMotpByDM(v-mark-ident) .
               ub.marking.box-qnty = getQntyUTDByDM(v-mark-ident) .
               ub.marking.unit = getLevelUTDByDM(v-mark-ident) .
            end.
            ub.utd-marking-lines.sts = ObjSrv:Env:Marking:Sts:Mark:Checked_:KeyIntDB.
            if available ub.marking
            THEN
               ub.utd-marking-lines.mark = ub.marking.mark.
         end.
        end.
      end.
      for each TempDocLine:
         find first ub.utd-lines no-lock where ub.utd-lines.doc-id = v-utd-doc-id 
                                           and ub.utd-lines.db-num = v-utd-db-num 
                                           and ub.utd-lines.LineNum eq TempDocLine.line-num no-error.
         if available ( ub.utd-lines)
         then
            SetAttrUtdlines(ub.utd-lines.db-num,ub.utd-lines.doc-id,ub.utd-lines.linenum,"QuantityBarCode",string(TempDocLine.fact-qnty)).
        
      end.
/*      for each TempMarkLine where TempMarkLine.Sts = "Ungrouped" :                                       */
/*        find first ub.utd-marking-lines where ub.utd-marking-lines.mark = TempMarkLine.MarkCode no-error.*/
/*        if available (ub.utd-marking-lines)                                                              */
/*        then do:                                                                                         */
/*          ub.utd-marking-lines.sts = ObjSrv:Env:Marking:Sts:Mark:Ungrouped:KeyIntDB.                     */
/*          find first ub.marking where ub.marking.mark = TempMarkLine.MarkCode no-error.                  */
/*          ub.marking.sts = ObjSrv:Env:Marking:Sts:Mark:Ungrouped:KeyIntDB.                               */
/*        end.                                                                                             */
/*      end.                                                                                               */
    end.
    
  end.

  method private void ungrg (mark-parent as char):
    define buffer buf_m for ub.marking.
    for each buf_m where buf_m.mark = mark-parent exclusive-lock :
      buf_m.sts = ObjSrv:Env:Marking:Sts:Mark:Ungrouped:KeyIntDB.
      ungrg(buf_m.mark-parent).
    end. 
  end.  

  method public logical ImpUTDIntroduce (table TempTrnDoc, table TempDocLine, table TempMarkLine):
    
    def var chAddIntoduce as class introduce no-undo.
    def var v-utd-db-num as integer no-undo.
    def var v-utd-doc-id as integer no-undo.
    def var v-ext-doc-code as character no-undo.
     
    chAddIntoduce = new introduce ().
     
    for each TempTrnDoc :
      
      if TempTrnDoc.ext-doc-type = "InvIntroduce"
      then do:
        find first ub.utd where ub.utd.doc-code = TempTrnDoc.ext-doc-code no-lock no-error.
        if not available (ub.utd)
          then next.
        v-utd-db-num = ub.utd.db-num.
        v-utd-doc-id = ub.utd.doc-id.
      end.
      else do:
        v-ext-doc-code = replace (entry (2, TempTrnDoc.ext-doc-code, "("),")","").
        assign
          v-utd-db-num = integer (entry (1, v-ext-doc-code, "_"))
          v-utd-doc-id = integer (entry (2, v-ext-doc-code, "_"))
        no-error.
      end.
      
      if error-status:error
        then next.
        
      for each TempMarkLine where TempMarkLine.Sts = "CrTsd" :

        find first ub.utd-marking-lines no-lock where ub.utd-marking-lines.mark = TempMarkLine.MarkCode and ub.utd-marking-lines.doc-id = v-utd-doc-id and ub.utd-marking-lines.db-num = v-utd-db-num no-error.
        if available ( ub.utd-marking-lines)
          then next.
        
        find first ub.marking where ub.marking.mark = ub.utd-marking-lines.mark exclusive-lock no-error.
        if available (ub.marking)
        then do:
          ub.marking.sts = ObjSrv:Env:Marking:Sts:Mark:PendingVerification:KeyIntDB.
        end.
        
        chAddIntoduce:AddMarkUTD(TempMarkLine.MarkCode, v-utd-doc-id, v-utd-db-num, "CrTsd") no-error.

        if error-status:error
        then do:
          dispmessage (return-value, false).
          delete object chAddIntoduce no-error.
          return false.
        end.
      end.
    end.
    delete object chAddIntoduce no-error.
    
  end.

  method public logical ImpInvMarksDOC (table TempTrnDoc, table TempDocLine, table TempMarkLine):
    
    def buffer buf_marking for ub.marking.
    def buffer buf_marking-lines for ub.marking-lines.
    def buffer bf_doc-line for ub.doc-line.
    
    def var v-inv-doc as character no-undo.
     
    for each TempTrnDoc :
      
      assign
        v-inv-doc = TempTrnDoc.ext-doc-code
      no-error.
      
      if error-status:error
        then next.
      
      for each TempMarkLine where TempMarkLine.Sts = "CheckScan" :
        
        find first ub.marking-attr no-lock where (ub.marking-attr.attr-code = "inv-doc" or ub.marking-attr.attr-code = "inv-doc-scan") and (ub.marking-attr.mark = TempMarkLine.MarkCode) 
          no-error.
        
        if available (ub.marking-attr) and not ub.marking-attr.attr-value = v-inv-doc 
        then do:
          dispmessage ("Марка находится в инвентаризации - " + ub.marking-attr.attr-value, false).
          return false.
        end.
        else do:
          if available (ub.marking-attr) 
            then next.
       end.
        
        find first buf_marking where (buf_marking.mark = TempMarkLine.MarkCode) no-lock no-error.
      
        if not available (buf_marking)
        then do:
          dispmessage ("Марка не найдена в системе.", false).
          return false.    
        end.
        
        find first buf_marking-lines where (buf_marking-lines.mark = TempMarkLine.MarkCode)
          and buf_marking-lines.out-code = {&free-code} no-error.
      
        find first ub.goods no-lock where ub.goods.gds-code = buf_marking-lines.gds-code no-error.
        find first bf_doc-line where bf_doc-line.doc-code = v-inv-doc
          and bf_doc-line.artic = ub.goods.artic
          and bf_doc-line.prod-type = ub.goods.prod-type
          and bf_doc-line.prod-code = ub.goods.prod-code no-lock no-error.
        
        if not available (bf_doc-line)
        then do:
          dispmessage (substitute ("В накладной к линии с товаром &1 &2 к марке &3.", string (ub.goods.gds-code), ub.goods.gds-name, buf_marking-lines.mark), false).
          return false.
        end.
        
/*        if buf_marking.sts = ObjSrv:Env:Marking:Sts:Mark:Ungrouped:KeyIntDB*/
/*        then do:                                                           */
/*          run dispmessage ("Упаковка разгруппирована.", false).            */
/*          return.                                                          */
/*        end.                                                               */
        
        if available (buf_marking) and available (buf_marking-lines)
        then do:

          create ub.marking-attr.
          ub.marking-attr.mark = TempMarkLine.MarkCode.
          ub.marking-attr.attr-code = "inv-doc-scan".
          ub.marking-attr.attr-value = v-inv-doc.
          ObjSrv:Lib:MarkingTree:UnGroupMark(buf_marking.mark).    
          
          if ObjSrv:Lib:MarkingTree:LevelDown(buf_marking.mark  ) 
          then do:
            ObjSrv:Lib:MarkingTree:LockInvChildeMark(buf_marking.mark, v-inv-doc).
          end.
         
    
        end.
      end.
    end.
    return true.
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

  method public character gds-attr-mark-type (

  p-gds-code as integer
     /* код атрибута */
     /* значение атрибута */
  ):

  do
  on error undo, return error
  :
    
    find first ub.goods-attr where ub.goods-attr.gds-code = p-gds-code and ub.goods-attr.attr-code = {&attr-mark-type} no-lock no-error. 
    
    if available ub.goods-attr
      then return ub.goods-attr.attr-value.
    return "".
    
  end.
  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  destructor public TSD ( ):
    
    delete object keyrec no-error.
    
  end destructor.

  method public void dispmessage (p-str as char, p-sts as logical): 
    LogWrite:LogStr = p-str.
    SomeStr = getStatusXml(p-sts, p-str).
  end.

  method public void getUTDDoc (iProtocol as char):
    
    define buffer buf_utd         for ub.utd.
    define buffer buf_utd-err     for ub.utd-err.
    define buffer buf_utd-m-l     for ub.utd-marking-lines.
    define buffer buf_utd-m-l-par for ub.utd-marking-lines.
    define buffer buf_m-l         for ub.marking-lines.
    define buffer buf_m-chi       for ub.marking.
    define buffer buf_m-par       for ub.marking.
    define buffer buf_utd-l       for ub.utd-lines.
    define buffer buf_m           for ub.marking.
    define buffer buf_goods     for ub.goods.
    define buffer buf_bar-code  for ub.bar-code.
    define buffer buf_trn-doc   for ub.trn-doc.
    define buffer buf_doc-line  for ub.doc-line.
    
    define variable dFactSum   as decimal   no-undo.
    define variable factQnty   as character no-undo.
    define variable docQnty    as character no-undo.
    define variable priceSale  as character no-undo.
    define variable FactSum    as character no-undo.
    define variable docType    as character no-undo.
    define variable dPriceSale as decimal   no-undo.
    define variable decDocQnty as decimal no-undo.
    define variable jj as integer no-undo.
    define variable jjm as integer no-undo.
    define variable iim as integer no-undo.
    define variable myflagsDoc     as class flagsdoc     no-undo.
    define variable myflagsDocLine as class flagsdocline no-undo.
    define variable pos as integer no-undo.
    def    var      internal-b-code like ub.bar-code.b-code no-undo .
    def    var      full-b-code     as character init "" no-undo .
    def    var      bc-frmt         as character no-undo .
    def    var      bc-pfx          as character no-undo .
    def    var      v-par-type      as character no-undo .
    def    var      v-doc-num       as character no-undo .
    def var v-sts as character no-undo.
    def var vRecKey-line as character no-undo.
          
    run gbl/conf-rd.p ("bc-pfx", "", "", 0, "", "", "", yes, output bc-pfx, output v-par-type) no-error.
    run gbl/conf-rd.p ("bc-frmt", "", "", 0, "", "", "", yes, output bc-frmt, output v-par-type) no-error.
    myflagsDoc = new flagsdoc ().
    myflagsDocLine = new flagsdocline ().
    l_utd:
    for each buf_utd where buf_utd.obj-type = ObjType and buf_utd.obj-code = ObjCode and buf_utd.sts = ObjSrv:Env:Utd:Sts:TH:AwaitingDelivery:KeyIntDB
      and buf_utd.EDocType = ObjSrv:Env:Utd:EDocType:UTD:KeyIntDB:
      v-doc-num = buf_utd.DocumentNumber + "(" + string(buf_utd.db-num) + "_" + string(buf_utd.doc-id) + ")".
      myflagsDoc:unSetAllFlags().
      myflagsDoc:isDocMarkOn = false.
      block-u-l:
      for each buf_utd-l where buf_utd-l.db-num = buf_utd.db-num and buf_utd-l.doc-id = buf_utd.doc-id no-lock:
         block-mark:
         for each buf_utd-m-l where buf_utd-m-l.db-num = buf_utd-l.db-num 
                             and buf_utd-m-l.doc-id    = buf_utd-l.doc-id
                             and buf_utd-m-l.LineNum   = buf_utd-l.LineNum 
         no-lock:
            if    ismark(buf_utd-m-l.mark)
               or isOAD (buf_utd-m-l.mark)
            then do:
               ObjSrv:Lib:KeyRec:GenKeyRec ( input "utd-lines", 
                  input  buffer buf_utd-l:handle, 
                  output vRecKey-line). 
               find first buf_utd-err no-lock where buf_utd-err.doc-id = buf_utd-l.doc-id and buf_utd-err.db-num = buf_utd-l.db-num and buf_utd-err.reckey = vRecKey-line no-error .
               if not available buf_utd-err
               then do:
                  myflagsDoc:isDocMarkOn = true.
                  leave block-u-l.
               end.
               else
                  leave block-mark.
            end.
         end.
      end.         
      if buf_utd.cli-code = ? or buf_utd.obj-code = ? or buf_utd.cli-type = ? or buf_utd.obj-type = ?
      then do:
        LogWrite:LogStr = LogWrite:LogStr + {&new-line} + substitute ( "Не указан контрагент/объект TH в документе УТД &1.", v-doc-num).
        next l_utd.
      end.
      
      pos = 0.
      for each buf_utd-l where buf_utd-l.db-num = buf_utd.db-num and buf_utd-l.doc-id = buf_utd.doc-id no-lock:
        
        myflagsDocLine:unSetAllFlags().
        myflagsDocLine:isMarkOn            = logical(GetAttrUtdlinesEx (buf_utd-l.db-num,buf_utd-l.doc-id,buf_utd-l.lineNum,"MarkUtdLine","no")).
        myflagsDocLine:isVarietalVolumeOn  = logical(GetAttrUtdlinesEx (buf_utd-l.db-num,buf_utd-l.doc-id,buf_utd-l.lineNum,"ArticUtdLine","no")).
        myflagsDocLine:isNotEditManualQnty = not (myflagsDocLine:isMarkOn).
        
        find first buf_goods no-lock where buf_goods.gds-code = buf_utd-l.gds-code no-error.
        if not available (buf_goods)
        then do: 
          LogWrite:LogStr = LogWrite:LogStr + {&new-line} + substitute ( "Не указан товар TH в документе УТД &1.", v-doc-num).
          next l_utd.
        end.

        find first buf_bar-code no-lock where buf_bar-code.gds-code = buf_goods.gds-code.
        
       internal-b-code = buf_bar-code.b-code.                
        { str/bc-gnrti.i "bc" "internal-b-code" "full-b-code"}

        pos = pos + 1.
        dPriceSale = buf_utd-l.Total / buf_utd-l.Quantity. 
        decDocQnty = buf_utd-l.Quantity.
        

        assign
          priceSale = string (dPriceSale)
          docQnty   = string (decDocQnty)
        .

        assign
          priceSale = if dPriceSale > -1 and dPriceSale < 1 then replace (priceSale, ".", "0,") else replace (priceSale, ".", ",")
          docQnty  = if decDocQnty > -1 and decDocQnty < 1 then replace (docQnty, ".", "0,") else replace (docQnty, ".", ",")
        .
        define variable vErrorLine as logical no-undo.
        ObjSrv:Lib:KeyRec:GenKeyRec ( input "utd-lines", 
            input  buffer buf_utd-l:handle, 
            output vRecKey-line). 
        find first buf_utd-err no-lock where buf_utd-err.doc-id = buf_utd-l.doc-id and buf_utd-err.db-num = buf_utd-l.db-num and buf_utd-err.reckey = vRecKey-line no-error .
        vErrorLine = available buf_utd-err.  
        for each buf_utd-m-l where buf_utd-m-l.db-num = buf_utd.db-num and buf_utd-m-l.doc-id = buf_utd.doc-id and buf_utd-m-l.LineNum = buf_utd-l.LineNum no-lock
          :
          define variable vMark as logical no-undo.
          vMark = isMark(buf_utd-m-l.mark).
          if vMark 
          then do:
             find first buf_m no-lock where buf_m.mark = buf_utd-m-l.mark no-error.
          end.
          if vErrorLine and false then 
          do:
            v-sts = "NotCorrect".
          end.
          else do:
             if not vMark
             then
                v-sts = "UTD".
             else if not buf_utd-m-l.sts = ObjSrv:Env:Marking:Sts:Mark:PendingVerification:KeyIntDB
                 and not buf_utd-m-l.sts = ObjSrv:Env:Marking:Sts:Mark:DeliveryControl:KeyIntDB          
             then do:
                  if available buf_m and buf_m.sts = ObjSrv:Env:Marking:Sts:Mark:Checked_:KeyIntDB 
                      or buf_utd-m-l.sts = ObjSrv:Env:Marking:Sts:Mark:Checked_:KeyIntDB 
                  then v-sts = "Check".
                  else v-sts = "NotCorrect".
              end.
              else if available buf_m and buf_m.sts = ObjSrv:Env:Marking:Sts:Mark:MarkError:KeyIntDB
              then
                 v-sts = "NotCorrect".
              else do:
                if available buf_m and buf_m.sts = ObjSrv:Env:Marking:Sts:Mark:GrayZone:KeyIntDB
                  then v-sts = "GrayZone".
                  else do:
                    if can-find (first buf_m-par no-lock where buf_m-par.mark = buf_m.mark-parent and buf_m-par.sts = ObjSrv:Env:Marking:Sts:Mark:GrayZone:KeyIntDB) 
                      then v-sts = "GrayZone".
                      else v-sts = "UTD".
                  end.
              end. 
          end.

      
          tsdstreamopenapp("MT_MarkLines.txt").
          jj = jj + 1.
          define variable vqnty as decimal no-undo.
          if vmark
             and available buf_m 
          then do:
             vqnty = buf_m.box-qnty.
             if vqnty = ? then vqnty = decimal(GetAttrUtdlinesEx (buf_utd-m-l.db-num,buf_utd-m-l.doc-id,buf_utd-m-l.lineNum,"box-qnty","0")) no-error.
          end.   
          else vqnty = decimal(GetAttrUtdlinesEx (buf_utd-m-l.db-num,buf_utd-m-l.doc-id,buf_utd-m-l.lineNum,"box-qnty","0")) no-error.
          if vqnty = ? then vqnty = 0.
          put stream tsdstream unformatted 
          substitute ("&3&1&4&1&5&1&6&1&7&1&8&1&9&2",
                      {&delimiteFld},
                      {&delimiterLine},
                      string (jj),
                      v-doc-num,
                      buf_utd-m-l.mark,
                      v-doc-num + "_" + string (buf_goods.gds-code) + "_" + string(pos),
                      v-sts,
                      (if available buf_m then  buf_m.mark-parent else ""),
                      string(vqnty)
                     )
          .
          tsdstreamclose().
        end.


        factQnty  = replace (GetAttrUtdlinesEx(buf_utd-l.db-num,buf_utd-l.doc-id,buf_utd-l.linenum,"QuantityBarCode","0"), ".", "0" + CurrDecSeparatorTH).
        tsdstreamopenapp("MT_lines.txt"). 
          jjm = jjm + 1.
          put stream tsdstream unformatted 
          substitute ("&2&1&3&1&4&1&5&1&6&1&7&1&8&1&9&1",
                      {&delimiteFld},
                      string (jjm),
                      v-doc-num ,
                      string (pos),
                      string (buf_goods.gds-code),
                      buf_goods.gds-name,
                      buf_goods.unit-base,
                      full-b-code,
                      priceSale

                     )
                     +
           substitute ("&3&1&4&1&5&1&6&1&7&2",
                      {&delimiteFld},
                      {&delimiterLine},
                      docQnty,
                      factQnty,
                      getErrForLineType(buffer buf_utd-l:handle, "*"),
                      v-doc-num + "_" + string (buf_goods.gds-code) + "_" + string(pos),
                      string (myflagsDocLine:FlagsToInt)
                      )
          
          .
         tsdstreamclose().
        
      end.
      
      FactSum = if dFactSum > -1 and dFactSum < 1 then replace (string (dFactSum), ".", "0,") else replace (string (dFactSum), ".", ",").

      docType = "UTD".
      def var str as character no-undo.
      str = string (v-doc-num + {&delimiteFld} + 
        docType + {&delimiteFld} + "false" + {&delimiteFld} + "накл" + string ("+") + {&delimiteFld} + 
        string (buf_utd.cli-code) + {&delimiteFld} + buf_utd.cli-type + {&delimiteFld} + 
        string (buf_utd.obj-code) + {&delimiteFld} + buf_utd.obj-type + {&delimiteFld} + 
        {&delimiteFld} + {&delimiteFld}
        +
        string (FactSum) + {&delimiteFld} + string (iso-date (datetime-tz (if buf_utd.DocumentDate = ? then now else buf_utd.DocumentDate))) + {&delimiteFld} 
        + string(myflagsDoc:FlagsToInt) + {&delimiterLine}).
      
      tsdstreamopenapp("MT_documents.txt"). 
        put stream tsdstream unformatted str. 
      tsdstreamclose().
    end.
    l_utd_Introduce:
    for each buf_utd where buf_utd.obj-type = ObjType and buf_utd.obj-code = ObjCode and buf_utd.sts = ObjSrv:Env:Utd:Sts:TH:NewStatus:KeyIntDB
      and buf_utd.EDocType = ObjSrv:Env:Utd:EDocType:Introduce:KeyIntDB
        and buf_utd.doc-code = "" 
        and not can-find (first buf_trn-doc no-lock where buf_trn-doc.doc-code = buf_utd.doc-code):
      
      v-doc-num = buf_utd.DocumentNumber + "(" + string(buf_utd.db-num) + "_" + string(buf_utd.doc-id) + ")".
      pos = 0.
      l_utd1:
      for each buf_utd-l where buf_utd-l.db-num = buf_utd.db-num and buf_utd-l.doc-id = buf_utd.doc-id no-lock:

        myflagsDocLine:unSetAllFlags().
        myflagsDocLine:isMarkOn            = logical(GetAttrUtdlinesEx (buf_utd-l.db-num,buf_utd-l.doc-id,buf_utd-l.lineNum,"MarkUtdLine","yes")).
        myflagsDocLine:isVarietalVolumeOn  = logical(GetAttrUtdlinesEx (buf_utd-l.db-num,buf_utd-l.doc-id,buf_utd-l.lineNum,"ArticUtdLine","no")).
        myflagsDocLine:isNotEditManualQnty = not (myflagsDocLine:isMarkOn).
              
        find first buf_goods no-lock where buf_goods.gds-code = buf_utd-l.gds-code no-error.
        if not available (buf_goods)
        then do: 
          LogWrite:LogStr = LogWrite:LogStr + {&new-line} + substitute ( "Не указан товар TH в документе УТД &1.", v-doc-num).
          next l_utd1.
        end.
       
        find first buf_bar-code no-lock where buf_bar-code.gds-code = buf_goods.gds-code.
        
        internal-b-code = buf_bar-code.b-code.
        { str/bc-gnrti.i "bc" "internal-b-code" "full-b-code"}
        
        dPriceSale = buf_utd-l.Total / buf_utd-l.Quantity. 
        decDocQnty = buf_utd-l.Quantity.
        
        assign
          priceSale   = string (dPriceSale)
          docQnty    = string (decDocQnty)
          .

        assign
          priceSale = if dPriceSale > -1 and dPriceSale < 1 then replace (priceSale, ".", "0,") else replace (priceSale, ".", ",")
          docQnty  = if decDocQnty > -1 and decDocQnty < 1 then replace (docQnty, ".", "0,") else replace (docQnty, ".", ",")
          .
        pos = pos + 1.
        tsdstreamopenapp("MT_lines.txt"). 
          jjm = jjm + 1.
          put stream tsdstream unformatted 
          substitute ("&2&1&3&1&4&1&5&1&6&1&7&1&8&1&9&1",
                      {&delimiteFld},
                      string (jjm),
                      v-doc-num ,
                      string (pos),
                      string (buf_goods.gds-code),
                      buf_goods.gds-name,
                      buf_goods.unit-base,
                      full-b-code,
                      priceSale
                      
                     )
                     +
          substitute ("&3&1&4&1&5&1&6&1&7&2",
                      {&delimiteFld},
                      {&delimiterLine},
                      docQnty,
                      docQnty,
                      "", /* string (buf_goods.gds-code) */
                      v-doc-num + "_" + string (buf_goods.gds-code),
                      string (myflagsDocLine:FlagsToInt)
                      )
                     .
        tsdstreamclose().
        for each buf_utd-m-l where buf_utd-m-l.db-num = buf_utd.db-num and buf_utd-m-l.doc-id = buf_utd.doc-id and buf_utd-m-l.LineNum = buf_utd-l.LineNum no-lock
          :
          vmark =isMark(buf_utd-m-l.mark).
          if vmark
          then do:
          find first buf_m no-lock where buf_m.mark = buf_utd-m-l.mark no-error.
             if not available (buf_m)
             then do:
               LogWrite:LogStr = LogWrite:LogStr + {&new-line} + (substitute ("Некорректная марка &1.", buf_utd-m-l.mark)).
               next.
             end.
          end.
/*          if not buf_m.unit-ext = "UNIT"                                         */
/*          then do:                                                               */
/*            find first buf_m-chi no-lock where buf_m-chi.mark-parent = buf_m.mark*/
/*              and buf_m-chi.unit-ext = "UNIT" no-error.                          */
/*            if not available (buf_m-chi)                                         */
/*              then next.                                                         */
/*          end.                                                                   */
          find first ub.utd-marking-lines-attr where
                ub.utd-marking-lines-attr.db-num    = buf_utd-m-l.db-num
            and ub.utd-marking-lines-attr.doc-id    = buf_utd-m-l.doc-id
            and ub.utd-marking-lines-attr.LineNum   = buf_utd-m-l.LineNum
            and ub.utd-marking-lines-attr.mark      = buf_utd-m-l.mark
            and ub.utd-marking-lines-attr.attr-code = "CrTsd" no-lock no-error
          .
          def var v-mark as char no-undo.
          if available (ub.utd-marking-lines-attr)
            then v-mark = ub.utd-marking-lines-attr.attr-value.
            else v-mark = buf_utd-m-l.mark. 

          tsdstreamopenapp("MT_MarkLines.txt").
          jj = jj + 1.
          if vmark and 
             available buf_m 
          then do:
             vqnty = buf_m.box-qnty.
             if vqnty = ? then vqnty = decimal(GetAttrUtdlinesEx (buf_utd-m-l.db-num,buf_utd-m-l.doc-id,buf_utd-m-l.lineNum,"box-qnty","0")) no-error.
          end.   
          else vqnty = decimal(GetAttrUtdlinesEx (buf_utd-m-l.db-num,buf_utd-m-l.doc-id,buf_utd-m-l.lineNum,"box-qnty","0")) no-error.
          if vqnty = ? then vqnty = 0.
          put stream tsdstream unformatted 
          substitute ("&3&1&4&1&5&1&6&1&7&1&8&1&9&2",
                      {&delimiteFld},
                      {&delimiterLine},
                      string (jj),
                      v-doc-num,
                      v-mark,
                      v-doc-num + "_" + string (buf_goods.gds-code),
                      "CrTSD",
                      (if available buf_m then  buf_m.mark-parent else ""),
                      string(vqnty)
                     )             
          .
          tsdstreamclose().
        end.
      end.      
      
      FactSum = if dFactSum > -1 and dFactSum < 1 then replace (string (dFactSum), ".", "0,") else replace (string (dFactSum), ".", ",").

      if buf_utd.cli-code = ? or buf_utd.obj-code = ? or buf_utd.cli-type = ? or buf_utd.obj-type = ?
      then do:
        LogWrite:LogStr = LogWrite:LogStr + {&new-line} + substitute ( "Не указан контрагент/объект TH в документе УТД &1.", v-doc-num).
        next l_utd_Introduce.
      end.
      FactSum = "0".
/*      tsdstreamopenapp("MT_lines.txt").                                                                                                                           */
/*        jjm = jjm + 1.                                                                                                                                            */
/*        put stream tsdstream unformatted string (jjm) + {&delimiteFld} + v-doc-num + {&delimiteFld} + string (1) + {&delimiteFld} + string (9999) + {&delimiteFld}*/
/*        + string (9999) + {&delimiteFld} + "марка" + {&delimiteFld} + "9999" + {&delimiteFld} +                                                                   */
/*        "0" + {&delimiteFld} + "0" + {&delimiteFld} +                                                                                                             */
/*        "0" + {&delimiteFld} + string (9999) + {&delimiteFld} +                                                                                                   */
/*        v-doc-num + "_9999" + {&delimiteFld} + string(myflagsDocLine:FlagsToInt) + {&delimiterLine}.                                                              */
/*      tsdstreamclose().                                                                                                                                           */
      
      docType = "Introduce".
      str = string (v-doc-num + {&delimiteFld} + 
        docType + {&delimiteFld} + "false" + {&delimiteFld} + "накл" + string ("+") + {&delimiteFld} + 
        string (buf_utd.obj-code) + {&delimiteFld} + buf_utd.obj-type + {&delimiteFld} + 
        string (buf_utd.obj-code) + {&delimiteFld} + buf_utd.obj-type + {&delimiteFld} + 
        {&delimiteFld} + {&delimiteFld}
        +
        string (FactSum) + {&delimiteFld} + string (iso-date (if buf_utd.DocumentDate = ? then now else buf_utd.DocumentDate)) + {&delimiteFld} 
        + string(myflagsDoc:FlagsToInt) + {&delimiterLine}).
      
      tsdstreamopenapp("MT_documents.txt"). 
        put stream tsdstream unformatted str. 
      tsdstreamclose().
              
    end.

    def var v-attr-value   as character no-undo.
    def var v-attr-type    as character no-undo. 
    def var v-is-introduce as logical   no-undo.
    define variable decFactQnty as decimal no-undo.
    define buffer buf_utd-marking-lines for ub.utd-marking-lines.
    invd_:
    for each buf_trn-doc where buf_trn-doc.ext-doc-type = {&TDEDT_Inv} and buf_trn-doc.status_ = {&wayb} and not buf_trn-doc.flag:
      v-is-introduce = false.
      { str/tdat-val.i
        buf_trn-doc.doc-code
        {&trdcattr-inv-introduce}
        v-attr-value
        v-attr-type
        no-error
      }
      if not error-status:error and v-attr-value = "yes" then do:
        v-is-introduce = true.
        find first buf_utd no-lock where buf_utd.doc-code = buf_trn-doc.doc-code no-error.
        if not available (buf_utd)
        then do:
          LogWrite:LogStr = LogWrite:LogStr + {&new-line} + substitute ( "Ошибочный документ &1 TH первоначального ввода, нет привязанного документа УТД.", v-doc-num).
          next invd_.
        end.
      end.
      
      v-doc-num = buf_trn-doc.doc-code.
      pos = 0.
      for each buf_doc-line where buf_doc-line.doc-code = buf_trn-doc.doc-code no-lock:
        find first buf_goods no-lock where buf_goods.artic = buf_doc-line.artic and buf_goods.prod-code = buf_doc-line.prod-code and buf_goods.prod-type = buf_doc-line.prod-type.
        find first buf_bar-code no-lock where buf_bar-code.gds-code = buf_goods.gds-code.
        
        if not ObjSrv:Env:ParametrsOfSection:GetSectionEDO(buf_trn-doc.obj-type, buf_trn-doc.obj-code):GetIsMarkingForType(gds-attr-mark-type(buf_goods.gds-code))
          then next invd_.
/*        if not gds-attr-mark-type(buf_goods.gds-code) = "tabak"*/
/*        then next invd_.                                       */
        internal-b-code = buf_bar-code.b-code.
        { str/bc-gnrti.i "bc" "internal-b-code" "full-b-code"}
        pos = pos + 1.
        def var v-qnty as integer no-undo.        
        v-qnty = 0.
        if v-is-introduce
        then do:
          for each ub.marking-attr no-lock where (marking-attr.attr-code = "inv-doc" or marking-attr.attr-code = "inv-doc-scan")  and ub.marking-attr.attr-value = buf_doc-line.doc-code:
            if not can-find (first ub.marking no-lock where ub.marking.mark = ub.marking-attr.mark and ub.marking.unit-ext = "UNIT" and ub.marking.gds-code = buf_goods.gds-code) 
              then next.
            v-qnty = v-qnty + 1.
          end.
          for each ub.utd no-lock where ub.utd.doc-code = buf_doc-line.doc-code:
            for each ub.utd-marking-lines no-lock where ub.utd-marking-lines.doc-id = ub.utd.doc-id and ub.utd-marking-lines.db-num = ub.utd.db-num and ub.utd-marking-lines.gds-code = buf_goods.gds-code
              and (ub.utd-marking-lines.sts = ObjSrv:Env:Marking:Sts:Mark:PendingVerification:KeyIntDB or ub.utd-marking-lines.sts = ObjSrv:Env:Marking:Sts:Mark:Checked_:KeyIntDB):
              for each ub.marking no-lock where ub.marking.mark = ub.utd-marking-lines.mark.
                if can-find (buf_utd-marking-lines where 
                      buf_utd-marking-lines.doc-id = ub.utd.doc-id and buf_utd-marking-lines.db-num = ub.utd.db-num and buf_utd-marking-lines.mark = ub.marking.mark-parent
                    )
                  then next.
                v-qnty = v-qnty + ub.marking.box-qnty.
              end.
            end.
            decDocQnty = buf_doc-line.doc-qnty - buf_doc-line.fact-qnty.
            decFactQnty = v-qnty.
          end.
        end.
        else do:
          for each ub.marking-attr no-lock where (marking-attr.attr-code = "inv-doc" or marking-attr.attr-code = "inv-doc-scan")  and ub.marking-attr.attr-value = buf_doc-line.doc-code:
            if not can-find (first ub.marking no-lock where ub.marking.mark = ub.marking-attr.mark and ub.marking.unit-ext = "UNIT" and ub.marking.gds-code = buf_goods.gds-code) 
              then next.
            v-qnty = v-qnty + 1.
          end.
          decDocQnty = buf_doc-line.doc-qnty - buf_doc-line.fact-qnty.
          decFactQnty = v-qnty.
        end.
        
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
/*          cLine = cLine + substitute ('<line DocName="&1" GoodsID="&2" UnitBC="&3" BC="&4" Price="&5" DocQnty="&6" FactQnty="&7" AlcCode="&8" PartIDTH ="&9" />', buf_doc-line.doc-code, buf_goods.gds-code, buf_goods.unit-base, full-b-code, priceSale, docQnty, factQnty).*/
      tsdstreamopenapp("MT_lines.txt"). 
        jjm = jjm + 1.
        put stream tsdstream unformatted
          substitute ("&2&1&3&1&4&1&5&1&6&1&7&1&8&1&9&1",
                      {&delimiteFld},
                      string (jjm),
                      v-doc-num ,
                      string (pos),
                      string (buf_goods.gds-code),
                      buf_goods.gds-name,
                      buf_goods.unit-base,
                      full-b-code,
                      priceSale
                      
                     )
                    +
         substitute ("&3&1&4&1&5&1&6&1&7&2",
                      {&delimiteFld},
                      {&delimiterLine},
                      docQnty,
                      factQnty,
                      "", /* string (buf_goods.gds-code) */
                      v-doc-num + "_" + string (buf_goods.gds-code),
                      string (myflagsDocLine:FlagsToInt)
                      )
                     .
        
      tsdstreamclose().
        if not v-is-introduce
        then do:
          for each buf_m-l no-lock where buf_m-l.obj-type = buf_doc-line.obj-type
              and buf_m-l.obj-code = buf_doc-line.obj-code
              and buf_m-l.out-code = {&free-code}
              and buf_m-l.gds-code = buf_goods.gds-code
            :
               vmark = isMark(buf_m-l.mark).
            if vmark
            then do:
               find first buf_m no-lock where buf_m.mark = buf_m-l.mark no-error.
               if available (buf_m)
               then do:
                  if buf_m.sts = ObjSrv:Env:Marking:Sts:Mark:Ungrouped:KeyIntDB
                    then next.  
                  if not buf_m.unit-ext = "UNIT"
                  then do:
                    find first buf_m-chi no-lock where buf_m-chi.mark-parent = buf_m.mark
                      and buf_m-chi.unit-ext = "UNIT" no-error.
                    if not available (buf_m-chi)
                      then next.
                  end.
               
                  if can-find (first ub.marking-attr where (ub.marking-attr.attr-code = "inv-doc" or ub.marking-attr.attr-code = "inv-doc-scan") and ub.marking-attr.mark = buf_m.mark)
                 then v-sts = "Check".
                 else v-sts = "UTD".
               end.
               else next.
            end.
            else v-sts = "Check".
            tsdstreamopenapp("MT_MarkLines.txt").
            jj = jj + 1.
            if vmark 
              and available buf_m
            then vqnty = buf_m.box-qnty.
/*            else vqnty = decimal(GetAttrUtdlinesEx (buf_m-l.db-num,buf_m-l.doc-id,buf_m-l.lineNum,"box-qnty","0")).*/
            if vqnty = ? then run vqnty = 0.
            put stream tsdstream unformatted 
            substitute ("&3&1&4&1&5&1&6&1&7&1&8&1&9&2",
                      {&delimiteFld},
                      {&delimiterLine},
                      string (jj),
                      v-doc-num,
                      buf_m-l.mark,
                      v-doc-num + "_" + string (buf_goods.gds-code),
                      "Check",
                      (if available buf_m then buf_m.mark-parent else ""),
                      string(vqnty)
                     )
          
            .
            tsdstreamclose().
          end.
        end.
        else do:
          find first buf_utd no-lock where buf_utd.doc-code = buf_trn-doc.doc-code.
          l_utdf:
          for each buf_utd-l where buf_utd-l.db-num = buf_utd.db-num and buf_utd-l.doc-id = buf_utd.doc-id 
            and buf_utd-l.gds-code = buf_goods.gds-code no-lock:
    
            find first buf_goods no-lock where buf_goods.gds-code = buf_utd-l.gds-code no-error.
            if not available (buf_goods)
            then do: 
              LogWrite:LogStr = LogWrite:LogStr + {&new-line} + substitute ( "Не указан товар TH в документе УТД &1.", v-doc-num).
              next l_utdf.
            end.
           
            find first buf_bar-code no-lock where buf_bar-code.gds-code = buf_goods.gds-code.
            
            internal-b-code = buf_bar-code.b-code.
            { str/bc-gnrti.i "bc" "internal-b-code" "full-b-code"}
            
            dPriceSale = buf_utd-l.Total / buf_utd-l.Quantity. 
            decDocQnty = buf_utd-l.Quantity.
            
            assign
              priceSale   = string (dPriceSale)
              docQnty    = string (decDocQnty)
              .
    
            assign
              priceSale = if dPriceSale > -1 and dPriceSale < 1 then replace (priceSale, ".", "0,") else replace (priceSale, ".", ",")
              docQnty  = if decDocQnty > -1 and decDocQnty < 1 then replace (docQnty, ".", "0,") else replace (docQnty, ".", ",")
              .
            for each buf_utd-m-l where buf_utd-m-l.db-num = buf_utd.db-num and buf_utd-m-l.doc-id = buf_utd.doc-id and buf_utd-m-l.LineNum = buf_utd-l.LineNum 
              no-lock
              :
              vmark = ismark(buf_utd-m-l.mark).
              if vmark
              then do:
                 find first buf_m no-lock where buf_m.mark = buf_utd-m-l.mark no-error.
                 if not available (buf_m)
                 then do:
                   LogWrite:LogStr = LogWrite:LogStr + {&new-line} + (substitute ("Некорректная марка &1.", buf_utd-m-l.mark)).
                   next.
                 end.
              end.
/*              if not buf_m.unit-ext = "UNIT"                                         */
/*              then do:                                                               */
/*                find first buf_m-chi no-lock where buf_m-chi.mark-parent = buf_m.mark*/
/*                  and buf_m-chi.unit-ext = "UNIT" no-error.                          */
/*                if not available (buf_m-chi)                                         */
/*                  then next.                                                         */
/*              end.                                                                   */
              tsdstreamopenapp("MT_MarkLines.txt").
              jj = jj + 1.
              if vmark
                 and available buf_m 
              then do:
                 vqnty = buf_m.box-qnty.
                 if vqnty = ? then vqnty = decimal(GetAttrUtdlinesEx (buf_utd-m-l.db-num,buf_utd-m-l.doc-id,buf_utd-m-l.lineNum,"box-qnty","0")) no-error.
              end.   
              else vqnty = decimal(GetAttrUtdlinesEx (buf_utd-m-l.db-num,buf_utd-m-l.doc-id,buf_utd-m-l.lineNum,"box-qnty","0")) no-error.
              if vqnty = ? then vqnty = 0.
              put stream tsdstream unformatted 
              substitute ("&3&1&4&1&5&1&6&1&7&1&8&1&9&2",
                      {&delimiteFld},
                      {&delimiterLine},
                      string (jj),
                      v-doc-num,
                      buf_utd-m-l.mark,
                      v-doc-num + "_" + string (buf_goods.gds-code),
                      "CrTSD",
                      (if available buf_m then buf_m.mark-parent else ""),
                      string(vqnty)
                     )
          
            
              .
              tsdstreamclose().
            end.
          end.
        end.
      end.
      FactSum = if dFactSum > -1 and dFactSum < 1 then replace (string (dFactSum), ".", "0,") else replace (string (dFactSum), ".", ",").
      if v-is-introduce
        then doctype = "InvIntroduce". 
        else docType = "InvMarks".
      str = string (v-doc-num + {&delimiteFld} + 
        docType + {&delimiteFld} + "false" + {&delimiteFld} + buf_trn-doc.status_ + string (buf_trn-doc.flag, "+/-") + {&delimiteFld} + 
        string (buf_trn-doc.cli-code) + {&delimiteFld} + buf_trn-doc.cli-type + {&delimiteFld} + 
        string (buf_trn-doc.obj-code) + {&delimiteFld} + buf_trn-doc.obj-type + {&delimiteFld} + 
        {&delimiteFld} + {&delimiteFld}
        +
        string (FactSum) + {&delimiteFld} + string (iso-date (datetime-tz (now))) + {&delimiteFld} 
        + string(myflagsDoc:FlagsToInt) + {&delimiterLine}).
      
      tsdstreamopenapp("MT_documents.txt"). 
        put stream tsdstream unformatted str. 
      tsdstreamclose().

    end.
  end.

  { utl/gtin.i class }

end class.

