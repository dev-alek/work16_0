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

class ibs.th.skt.ControlledClients.TSD inherits objth: 

  &scop delimiteFld chr(30)
  &scop delimiterLine chr(31)
  
  { str/marks.i         }
  { cmp/str-glbl.i class}
  { gbl/attr-lib.i class}
  { str/lib-trn.i class }
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

  define public property CurrDecSeparator as character no-undo init "."
      get.
      set.

  define public property CurrDecSeparatorTH as character no-undo init ","
      get:
        return session:numeric-separator.
      end.
      set.

  define public property IsMarkOn as logical no-undo init false
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
  define private buffer buf_gen-attr  for ub.gen-attr.
  
  define private variable tthDocument as handle no-undo.
  define private stream tsdstream.
  define private variable logWrite     as class     LogWrite     no-undo.
  define private variable keyrec       as class     keyrec       no-undo.
/*  define private variable flagsdoc     as class     flagsdoc     no-undo.*/
/*  define private variable flagsdocline as class     flagsdocline no-undo.*/
  define private variable v-keyrec     as character no-undo.

/*  define private variable isDocMarkOn  as logical   no-undo.       */
/*  define private variable DocFlags     as integer   no-undo init 0.*/
/*  define private variable DocLineFlags as integer   no-undo init 0.*/

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
		
  constructor public TSD (  ):

    keyrec = new keyrec ().
    logWrite = new LogWrite().
    os-delete value (search ("MT_documents.txt")) no-error.
    os-delete value (search ("MT_lines.txt")) no-error.
    os-delete value (search ("MT_MarkLines.txt")) no-error.
    if not valid-handle (ibs.th.gbl.gbl-hndllib:g#trdcalib)
    then do:
      run str/trdcalib.p persistent no-error.
    end.
    { str/trdcalib.i class}
		
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


  method public void getUTDDoc ():
    
    define buffer buf_utd         for ub.utd.
    define buffer buf_utd-err     for ub.utd-err.
    define buffer buf_utd-m-l     for ub.utd-marking-lines.
    define buffer buf_m-l         for ub.marking-lines.
    define buffer buf_m-chi       for ub.marking.
    define buffer buf_utd-l       for ub.utd-lines.
    define buffer buf_m           for ub.marking.
    
    
    define variable dFactSum   as decimal   no-undo.
    define variable factQnty   as character no-undo.
    define variable docQnty    as character no-undo.
    define variable priceSale  as character no-undo.
    define variable FactSum    as character no-undo.
    define variable docType    as character no-undo.
    define variable dPriceSale as decimal   no-undo.
    define variable decDocQnty as decimal no-undo.
    define variable decFactQnty as decimal no-undo.
    define variable jj as integer no-undo.
    define variable jjm as integer no-undo.
    define variable iim as integer no-undo.
    define variable myflagsDoc     as class flagsdoc     no-undo.
    define variable myflagsDocLine as class flagsdocline no-undo.
    define variable pos as integer no-undo.
    myflagsDoc = new flagsdoc ().
    myflagsDocLine = new flagsdocline ().
    
    def    var      internal-b-code like ub.bar-code.b-code no-undo .
    def    var      full-b-code     as character init "" no-undo .
    def    var      bc-frmt         as character no-undo .
    def    var      bc-pfx          as character no-undo .
    def    var      v-par-type      as character no-undo .
    def    var      v-doc-num       as character no-undo .
    run gbl/conf-rd.p ("bc-pfx", "", "", 0, "", "", "", yes, output bc-pfx, output v-par-type) no-error.
    run gbl/conf-rd.p ("bc-frmt", "", "", 0, "", "", "", yes, output bc-frmt, output v-par-type) no-error.
    myflagsDoc = new flagsdoc ().
    myflagsDocLine = new flagsdocline ().
    myflagsDocLine:unSetAllFlags().
    myflagsDocLine:isNotEditManualQnty = true.
    myflagsDoc:unSetAllFlags().
    myflagsDoc:isDocMarkOn = true.
    l_utd:
    for each buf_utd where buf_utd.obj-type = ObjType and buf_utd.obj-code = ObjCode and buf_utd.sts = ObjSrv:Env:Utd:Sts:TH:AwaitingDelivery:KeyIntDB
      and buf_utd.EDocType = ObjSrv:Env:Utd:EDocType:UTD:KeyIntDB:
      
      v-doc-num = buf_utd.DocumentNumber + "(" + string(buf_utd.db-num) + "_" + string(buf_utd.doc-id) + ")".

      if buf_utd.cli-code = ? or buf_utd.obj-code = ? or buf_utd.cli-type = ? or buf_utd.obj-type = ?
      then do:
        LogWrite:LogStr = LogWrite:LogStr + {&new-line} + substitute ( "Не указан контрагент/объект TH в документе УТД &1.", v-doc-num).
        next l_utd.
      end.
      
      if not can-find (first buf_utd-m-l where buf_utd-m-l.db-num = buf_utd.db-num and buf_utd-m-l.doc-id = buf_utd.doc-id)
        then next l_utd.
      pos = 0.
      for each buf_utd-l where buf_utd-l.db-num = buf_utd.db-num and buf_utd-l.doc-id = buf_utd.doc-id no-lock:

        find first buf_goods no-lock where buf_goods.gds-code = buf_utd-l.gds-code no-error.
        if not available (buf_goods)
        then do: 
          LogWrite:LogStr = LogWrite:LogStr + {&new-line} + substitute ( "Не указан товар TH в документе УТД &1.", v-doc-num).
          next l_utd.
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
          put stream tsdstream unformatted string (jjm) + {&delimiteFld} + v-doc-num + {&delimiteFld} + string (pos) + {&delimiteFld} + string (buf_goods.gds-code) + {&delimiteFld} 
          + string (buf_goods.gds-name) + {&delimiteFld} + buf_goods.unit-base + {&delimiteFld} + full-b-code + {&delimiteFld} + 
          priceSale + {&delimiteFld} + docQnty + {&delimiteFld} + 
          "0" + {&delimiteFld} + string (buf_goods.gds-code) + {&delimiteFld} + 
          v-doc-num + "_" + string (buf_goods.gds-code) + {&delimiteFld} + string(myflagsDocLine:FlagsToInt) + {&delimiterLine}.
        tsdstreamclose().
        for each buf_utd-m-l where buf_utd-m-l.db-num = buf_utd.db-num and buf_utd-m-l.doc-id = buf_utd.doc-id and buf_utd-m-l.LineNum = buf_utd-l.LineNum no-lock
          :
          find first buf_m no-lock where buf_m.mark = buf_utd-m-l.mark.
          if not buf_m.unit-ext = "UNIT"
          then do:
            find first buf_m-chi no-lock where buf_m-chi.mark-parent = buf_m.mark
              and buf_m-chi.unit-ext = "UNIT" no-error.
            if not available (buf_m-chi)
              then next.
          end.
          def var v-sts as character no-undo.
          def var vRecKey-line as character no-undo.
          ObjSrv:Lib:KeyRec:GenKeyRec ( input "utd-lines", 
            input  buffer buf_utd-l:handle, 
            output vRecKey-line).
    
          find first buf_utd-err no-lock where buf_utd-err.doc-id = buf_utd-l.doc-id and buf_utd-err.db-num = buf_utd-l.db-num and buf_utd-err.reckey = vRecKey-line no-error .
          if available (buf_utd-err) then 
          do:
            v-sts = "NotCorrect".
          end.
          else do:
            if not buf_m.sts = ObjSrv:Env:Marking:Sts:Mark:DeliveryControl:KeyIntDB 
              then v-sts = "NotCorrect".
              else v-sts = "UTD". 
          end.
          
          tsdstreamopenapp("MT_MarkLines.txt").
          jj = jj + 1.
          put stream tsdstream unformatted string (jj) + {&delimiteFld} + v-doc-num + {&delimiteFld} + buf_utd-m-l.mark + {&delimiteFld} 
          + v-doc-num + "_" + string (buf_goods.gds-code) + {&delimiteFld} + v-sts + {&delimiteFld} + buf_m.mark-parent + {&delimiteFld} + string(buf_m.box-qnty) + {&delimiterLine}.
          tsdstreamclose().
        end.
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
        string (FactSum) + {&delimiteFld} + string (iso-date (datetime-tz (if buf_utd.Timestamp = ? then now else buf_utd.Timestamp))) + {&delimiteFld} 
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
          put stream tsdstream unformatted string (jjm) + {&delimiteFld} + v-doc-num + {&delimiteFld} + string (pos) + {&delimiteFld} + string (buf_goods.gds-code) + {&delimiteFld} 
          + string (buf_goods.gds-name) + {&delimiteFld} + buf_goods.unit-base + {&delimiteFld} + full-b-code + {&delimiteFld} + 
          priceSale + {&delimiteFld} + docQnty + {&delimiteFld} + 
          docQnty + {&delimiteFld} + string (buf_goods.gds-code) + {&delimiteFld} + 
          v-doc-num + "_" + string (buf_goods.gds-code) + {&delimiteFld} + string(myflagsDocLine:FlagsToInt) + {&delimiterLine}.
        tsdstreamclose().
        for each buf_utd-m-l where buf_utd-m-l.db-num = buf_utd.db-num and buf_utd-m-l.doc-id = buf_utd.doc-id and buf_utd-m-l.LineNum = buf_utd-l.LineNum no-lock
          :
          find first buf_m no-lock where buf_m.mark = buf_utd-m-l.mark.
          if not buf_m.unit-ext = "UNIT"
          then do:
            find first buf_m-chi no-lock where buf_m-chi.mark-parent = buf_m.mark
              and buf_m-chi.unit-ext = "UNIT" no-error.
            if not available (buf_m-chi)
              then next.
          end.
          tsdstreamopenapp("MT_MarkLines.txt").
          jj = jj + 1.
          put stream tsdstream unformatted string (jj) + {&delimiteFld} + v-doc-num + {&delimiteFld} + buf_utd-m-l.mark + {&delimiteFld} 
          + v-doc-num + "_" + string (buf_goods.gds-code) + {&delimiteFld} + "CrTSD" + {&delimiteFld} + buf_m.mark-parent + {&delimiteFld} + string(buf_m.box-qnty) + {&delimiterLine}.
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
        string (FactSum) + {&delimiteFld} + string (iso-date (datetime-tz (if buf_utd.Timestamp = ? then now else buf_utd.Timestamp))) + {&delimiteFld} 
        + string(myflagsDoc:FlagsToInt) + {&delimiterLine}).
      
      tsdstreamopenapp("MT_documents.txt"). 
        put stream tsdstream unformatted str. 
      tsdstreamclose().
              
    end.

    def var v-attr-value   as character no-undo.
    def var v-attr-type    as character no-undo. 
    def var v-is-introduce as logical   no-undo.
    invd_:
    for each buf_trn-doc where buf_trn-doc.ext-doc-type = {&TDEDT_Inv} and buf_trn-doc.status_ = {&wayb} and not buf_trn-doc.flag:

      { str/tdat-val.i
        buf_trn-doc.doc-code
        {&trdcattr-inv-introduce}
        v-attr-value
        v-attr-type
        no-error
      }
      if not error-status:error and v-attr-value = "yes" then do:
        v-is-introduce = true.
      end.
      
      v-doc-num = buf_trn-doc.doc-code.
      pos = 0.
      for each buf_doc-line where buf_doc-line.doc-code = buf_trn-doc.doc-code no-lock:
        find first buf_goods no-lock where buf_goods.artic = buf_doc-line.artic and buf_goods.prod-code = buf_doc-line.prod-code and buf_goods.prod-type = buf_doc-line.prod-type.
        find first buf_bar-code no-lock where buf_bar-code.gds-code = buf_goods.gds-code.
        
/*        if not ObjSrv:Env:Conf:IsMarking:GetValForType(gds-attr-mark-type(buf_goods.gds-code))*/
/*          then next invd_.                                                                    */
        
        if not gds-attr-mark-type(buf_goods.gds-code) = "tabak"
        then next invd_.
        internal-b-code = buf_bar-code.b-code.
        { str/bc-gnrti.i "bc" "internal-b-code" "full-b-code"}
        pos = pos + 1.
        def var v-qnty as integer no-undo.        
        v-qnty = 0.
        if v-is-introduce
        then do:
          for each ub.utd no-lock where ub.utd.doc-code = buf_doc-line.doc-code:
            for each ub.utd-marking-lines no-lock where ub.utd-marking-lines.doc-id = ub.utd.doc-id and ub.utd-marking-lines.db-num = ub.utd.db-num and ub.utd-marking-lines.gds-code = buf_goods.gds-code:
              for each ub.marking no-lock where ub.marking.mark = ub.utd-marking-lines.mark.
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
        put stream tsdstream unformatted string (jjm) + {&delimiteFld} + v-doc-num + {&delimiteFld} + string (pos) + {&delimiteFld} + string (buf_goods.gds-code) + {&delimiteFld} 
        + string (buf_goods.gds-name) + {&delimiteFld} + buf_goods.unit-base + {&delimiteFld} + full-b-code + {&delimiteFld} + 
        priceSale + {&delimiteFld} + docQnty + {&delimiteFld} + 
        factQnty + {&delimiteFld} + string (buf_goods.gds-code) + {&delimiteFld} + 
        v-doc-num + "_" + string (buf_goods.gds-code) + {&delimiteFld} + string (myflagsDocLine:FlagsToInt) + {&delimiterLine}.
      tsdstreamclose().
        if not v-is-introduce
        then do:
          for each buf_m-l no-lock where buf_m-l.obj-type = buf_doc-line.obj-type
              and buf_m-l.obj-code = buf_doc-line.obj-code
              and buf_m-l.out-code = {&free-code}
              and buf_m-l.gds-code = buf_goods.gds-code
            :
            find first buf_m no-lock where buf_m.mark = buf_m-l.mark.
            if not buf_m.unit-ext = "UNIT"
            then do:
              find first buf_m-chi no-lock where buf_m-chi.mark-parent = buf_m.mark
                and buf_m-chi.unit-ext = "UNIT" no-error.
              if not available (buf_m-chi)
                then next.
            end. 
            tsdstreamopenapp("MT_MarkLines.txt").
            jj = jj + 1.
            put stream tsdstream unformatted string (jj) + {&delimiteFld} + v-doc-num + {&delimiteFld} + buf_m-l.mark + {&delimiteFld} 
            + v-doc-num + "_" + string (buf_goods.gds-code)  + {&delimiteFld} + "Check" + {&delimiteFld} + buf_m.mark-parent + {&delimiteFld} + string(buf_m.box-qnty) + {&delimiterLine}.
            tsdstreamclose().
          end.
        end.
        else do:
          find first buf_utd no-lock where buf_utd.doc-code = buf_trn-doc.doc-code.
          l_utdf:
          for each buf_utd-l where buf_utd-l.db-num = buf_utd.db-num and buf_utd-l.doc-id = buf_utd.doc-id no-lock:
    
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
            for each buf_utd-m-l where buf_utd-m-l.db-num = buf_utd.db-num and buf_utd-m-l.doc-id = buf_utd.doc-id and buf_utd-m-l.LineNum = buf_utd-l.LineNum no-lock
              :
              find first buf_m no-lock where buf_m.mark = buf_utd-m-l.mark.
              if not buf_m.unit-ext = "UNIT"
              then do:
                find first buf_m-chi no-lock where buf_m-chi.mark-parent = buf_m.mark
                  and buf_m-chi.unit-ext = "UNIT" no-error.
                if not available (buf_m-chi)
                  then next.
              end.
              tsdstreamopenapp("MT_MarkLines.txt").
              jj = jj + 1.
              put stream tsdstream unformatted string (jj) + {&delimiteFld} + v-doc-num + {&delimiteFld} + buf_utd-m-l.mark + {&delimiteFld} 
              + v-doc-num + "_" + string (buf_goods.gds-code) + {&delimiteFld} + "CrTSD" + {&delimiteFld} + buf_m.mark-parent + {&delimiteFld} + string(buf_m.box-qnty) + {&delimiterLine}.
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
/*      assign        */
/*        dFactSum = 0*/
/*        cHeader = ""*/
/*        cLine= ""   */
/*      .             */
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
          put stream tsdstream unformatted string (jjm) + {&delimiteFld} + buf_trn-doc.doc-code + {&delimiteFld} + (if docType = 'inv' then string (pos) else string (buf_doc-line.line-num)) + {&delimiteFld} + string (buf_goods.gds-code) + {&delimiteFld} 
          + string (buf_goods.gds-name) + {&delimiteFld} + buf_goods.unit-base + {&delimiteFld} + full-b-code + {&delimiteFld} + 
          priceSale + {&delimiteFld} + docQnty + {&delimiteFld} + 
          "0" + {&delimiteFld} + "" + {&delimiteFld} + 
          "" + {&delimiteFld} + string (myflagsDocLine:FlagsToInt) + {&delimiterLine}.
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
              put stream tsdstream unformatted string (jj) + {&delimiteFld} + buf_trn-doc.doc-code + {&delimiteFld} + buf_gen-attr.attr-code + {&delimiteFld} 
              + v-keyrec + {&delimiteFld} + "TH" + {&delimiterLine}.
            end.
            tsdstreamclose().
            
            tsdstreamopenapp("MT_lines.txt"). 
              jjm = jjm + 1.
              if decimal (iim) = buf_parts.qnty
                then myflagsDocLine:isEditManualFullQnty = true.
                else myflagsDocLine:isNotEditManualQnty = true.
              put stream tsdstream unformatted string (jjm) + {&delimiteFld} + buf_trn-doc.doc-code + {&delimiteFld} + string (pos) + {&delimiteFld} + string (buf_goods.gds-code) + {&delimiteFld} 
              + string (buf_goods.gds-name) + {&delimiteFld} + buf_goods.unit-base + {&delimiteFld} + full-b-code + {&delimiteFld} + 
              priceSale + {&delimiteFld} + docQnty + {&delimiteFld} + 
              "0" + {&delimiteFld} + v-alc-code + {&delimiteFld} + 
              v-keyrec + {&delimiteFld} + string(myflagsDocLine:FlagsToInt) + {&delimiterLine}.
            tsdstreamclose().
            
/*            dFactSum = buf_doc-line.fact-qnty + dFactSum.*/
          end.
        end.      
      end.
      
      FactSum = if dFactSum > -1 and dFactSum < 1 then replace (string (dFactSum), ".", "0,") else replace (string (dFactSum), ".", ",").
      
      find first buf_user where buf_user.user-id = buf_trn-doc.user-name no-error.
      
      tsdstreamopenapp("MT_documents.txt"). 
        put stream tsdstream unformatted buf_trn-doc.doc-code + {&delimiteFld} + 
        docType + {&delimiteFld} + "false" + {&delimiteFld} + buf_trn-doc.status_ + string (buf_trn-doc.flag, "+/-") + {&delimiteFld} + 
        string (buf_trn-doc.cli-code) + {&delimiteFld} + buf_trn-doc.cli-type + {&delimiteFld} + 
        string (buf_trn-doc.obj-code) + {&delimiteFld} + buf_trn-doc.obj-type + {&delimiteFld} + 
        (if available (buf_user)
        then buf_trn-doc.user-name + {&delimiteFld} + buf_user.user-login + {&delimiteFld} else {&delimiteFld} + {&delimiteFld}
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
    define variable is-petrol   as logical no-undo.
    define variable is-pieces   as logical no-undo.  

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
        then next cicle.
      
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


  method public void WriteBarcodes ():

    define variable cliBaseRate     as character no-undo.
    define variable priceSale       as character no-undo.
    define variable internal-b-code like ub.bar-code.b-code no-undo .
    define variable full-b-code     as character init "" no-undo .
    define variable bc-frmt         as character no-undo .
    define variable bc-pfx          as character no-undo .
    define variable v-par-type      as character no-undo .
    define variable is-petrol      as logical no-undo.
    define variable is-pieces      as logical no-undo.    
    
    run gbl/conf-rd.p ("bc-pfx", "", "", 0, "", "", "", yes, output bc-pfx, output v-par-type) no-error.
    run gbl/conf-rd.p ("bc-frmt", "", "", 0, "", "", "", yes, output bc-frmt, output v-par-type) no-error.   

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


        assign
          priceSale   = if available buf_price-all then string (buf_price-all.price-sale) else "0"
          cliBaseRate = string (buf_bar-code.cli-base-rate)
          .
        assign 
          priceSale = if available buf_price-all and buf_price-all.price-sale > -1 and buf_price-all.price-sale < 1 then replace (priceSale, ".", "0" + CurrDecSeparatorTH) else replace (priceSale, ".", CurrDecSeparatorTH)
          cliBaseRate = if buf_bar-code.cli-base-rate > -1 and buf_bar-code.cli-base-rate < 1 then replace (cliBaseRate, ".", "0" + CurrDecSeparatorTH) else replace (cliBaseRate, ".", CurrDecSeparatorTH)
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
          else LogWrite:LogStr = LogWrite:LogStr + {&new-line} + return-value.
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
          else LogWrite:LogStr = LogWrite:LogStr + {&new-line} + return-value.
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
    define variable adapterOra-i506 as class   AdapterOra-i506.
    define variable varzero-string  as logical no-undo.
    define variable myflagsDoc     as class flagsdoc     no-undo.
    define variable myflagsDocLine as class flagsdocline no-undo.
    
    find first TempTrnDoc.
    
    myflagsDoc = new flagsdoc ().
    myflagsDocLine = new flagsdocline ().
    myflagsDoc:setFlagsToInt(TempTrnDoc.Flags_).
    
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
        run str/scantsd.p ( 2, input no , input recid(buf_trn-doc) ,input "doctsd.txt", if myflagsDoc:isDocMarkOn then "rsvmarks" else "" ) no-error.
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
        run str/scantsd.p ( 1, input no , input recid(buf_trn-doc) ,input "newdoctsd.txt", if myflagsDoc:isDocMarkOn then "rsvmarks" else ""  ) no-error.
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

  method public logical ImpUTDDOC (table TempTrnDoc, table TempDocLine, table TempMarkLine):
    
    def var v-utd-db-num as integer no-undo.
    def var v-utd-doc-id as integer no-undo.
    def var v-ext-doc-code as character no-undo.
         
    for each TempTrnDoc :
      
      v-ext-doc-code = replace (entry (2, TempTrnDoc.ext-doc-code, "("),")","").
      assign
        v-utd-db-num = integer (entry (1, v-ext-doc-code, "_"))
        v-utd-doc-id = integer (entry (2, v-ext-doc-code, "_"))
      no-error.
      
      if error-status:error
        then next.
      
      for each TempMarkLine where TempMarkLine.Sts = "Check" or TempMarkLine.Sts = "CheckScan" :
        find first ub.utd-marking-lines where ub.utd-marking-lines.mark = TempMarkLine.MarkCode no-error.
        if available (ub.utd-marking-lines)
        then do:
          ub.utd-marking-lines.sts = ObjSrv:Env:Marking:Sts:Mark:Checked_:KeyIntDB.
          find first ub.marking where ub.marking.mark = TempMarkLine.MarkCode no-error.
          ub.marking.sts = ObjSrv:Env:Marking:Sts:Mark:Checked_:KeyIntDB.
          if TempMarkLine.Sts = "CheckScan"
            then ungrg(ub.marking.mark-parent).
        end.
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
    for each buf_m where buf_m.mark = mark-parent :
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
        find first ub.utd where ub.utd.doc-code = TempTrnDoc.ext-doc-code no-error.
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
        
        chAddIntoduce:AddMarkUTD(TempMarkLine.MarkCode, v-utd-doc-id, v-utd-db-num) no-error.
        if error-status:error
        then do:
          dispmessage (return-value, false).
          return false.
        end.
      end.
    end.
    
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
        
        find first buf_marking where (buf_marking.mark = TempMarkLine.MarkCode) no-error.
      
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
          and bf_doc-line.prod-code = ub.goods.prod-code no-error.
        
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
    
    find first ub.goods-attr where ub.goods-attr.gds-code = p-gds-code and ub.goods-attr.attr-code = {&attr-mark-type} no-error. 
    
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

end class.
