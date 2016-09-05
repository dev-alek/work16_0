 
 /*------------------------------------------------------------------------
    File        : ParseXMLDictGds
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : ASMorozov
    Created     : 16/05/2016
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.bge.egais.*.

class ibs.th.bge.egais.ParserXMLDocWB:

  {cmp/str-glbl.i class}    
  {ibs/th/bge/egais/wb-egais.i}
  { ref/extclass.i }

  define private buffer buf_clob-bind for ub.clob-bind.
  define private buffer buf_clob-data for ub.clob-data.
  define private buffer buf_clients   for ub.clients.


  define private variable inFileName as character no-undo.
  define private variable nn         as integer   no-undo.

  define property glog as logical no-undo
    get.
    set.

  define property FromFSRAR as character no-undo
    get.
    set.
  
  define property IsToClearTable as logical no-undo init true
    get.
    set.

  define property ExtSys as integer no-undo
    get.
    private set.
  
  constructor public ParserXMLDocWB (inExtSys as int):
    
    ExtSys = inExtSys. 
  
  end.
  
  method public void ParseRec (hDoc as handle, input-output table tt-wb-header, input-output table tt-wb-act-header, input-output table tt-ticket, input-output table tt-wb-info-client):
    
    define variable hRoot as handle no-undo.
    
    glog = false.
    empty temp-table tt-wb-header.
    empty temp-table tt-wb-gds-EG.
    empty temp-table tt-wb-act-header.
    empty temp-table tt-wb-act-gds-EG.
    empty temp-table tt-ticket.
    empty temp-table tt-wb-info-client.
    if valid-handle (hDoc)
    then do:
      create x-noderef hRoot.
      nn = 0.
      hDoc:get-document-element(hRoot).
      GetChildren(hRoot, 1).
      delete object hRoot.
      delete object hDoc.
    end.
  
    find first tt-wb-header no-error.
    find first tt-wb-act-header no-error.
    find first tt-ticket no-error.
  
    if not available (tt-wb-header) and not available (tt-wb-act-header) and not available (tt-ticket) then 
    do:
      glog = false.
    end.
  
    glog = true.
    
  end.
  
  method public void ParseRec (hDoc as handle, input-output outDate as date, url_ as char):
    
    define variable hRoot as handle no-undo.

    
/*    find first tt-alldoc where tt-alldoc.url_ = url_.*/
    
    glog = false.
    empty temp-table tt-wb-header.
    empty temp-table tt-wb-gds-EG.
    empty temp-table tt-wb-act-header.
    empty temp-table tt-wb-act-gds-EG.
    empty temp-table tt-ticket.
    
    if valid-handle (hDoc)
    then do:
      create x-noderef hRoot.
      nn = 0.
      hDoc:get-document-element(hRoot).
      GetChildren(hRoot, 1).
      delete object hRoot.
      delete object hDoc.
    end.
  
    find first tt-wb-header no-error.
    find first tt-wb-act-header no-error.
    find first tt-ticket no-error.
  
    case true:
      when available tt-wb-header then do:
        outDate = tt-wb-header.wb-date.
      end.
      when available tt-wb-act-header then do:
        outDate = tt-wb-act-header.act-date.
      end.
      when available tt-ticket then do:
        assign
          outDate = date (   substring (entry (3, tt-ticket.ticket-date, "-"), 1, 2) + "." + entry (2, tt-ticket.ticket-date, "-") + "." + entry (1, tt-ticket.ticket-date, "-"))
        no-error.
      end.
    end case.
  
  
    glog = true.
    
  end.
  
  method public void ParseRec (hDocWB as handle, hDocRef as handle, input-output table tt-wb-header, input-output table tt-wb-gds-EG, input-output table tt-wb-info-client):

    define variable hRoot as handle no-undo.

    glog = false.
    if IsToClearTable
    then do:
      empty temp-table tt-wb-header.
      empty temp-table tt-wb-gds-EG.
      empty temp-table tt-wb-info-client.
    end.

    if valid-handle (hDocWB)
    then do:
      create x-noderef hRoot.
      nn = 0.
      hDocWB:get-document-element(hRoot).
      GetChildren(hRoot, 1).
      delete object hRoot.
      delete object hDocWB.
    end.

    if valid-handle (hDocRef)
    then do:
      create x-noderef hRoot.
      nn = 0.
      hDocRef:get-document-element(hRoot).
      GetChildren(hRoot, 1).
      delete object hRoot.
      delete object hDocRef.
    end.
    glog = true.

  end.
  
  method public void ParseRec (hDocAct as handle, input-output table tt-wb-act-header, input-output table tt-wb-act-gds-EG):

    define variable hRoot as handle no-undo.

    glog = false.
    if IsToClearTable
    then do:
      empty temp-table tt-wb-act-header.
      empty temp-table tt-wb-act-gds-EG.
    end.

    if valid-handle (hDocAct)
    then do:
      create x-noderef hRoot.
      nn = 0.
      hDocAct:get-document-element(hRoot).
      GetChildren(hRoot, 1).
      delete object hRoot.
      delete object hDocAct.
    end.
    glog = true.
            
  end.
  
  method public void ParseRec (hDocTicket as handle, input-output table tt-ticket):

    define variable hRoot as handle no-undo.

    glog = false.
    if IsToClearTable
    then do:
      empty temp-table tt-ticket.
    end.

    if valid-handle (hDocTicket)
    then do:
      create x-noderef hRoot.
      nn = 0.
      hDocTicket:get-document-element(hRoot).
      GetChildren(hRoot, 1).
      delete object hRoot.
      delete object hDocTicket.
    end.
    glog = true.
            
  end.

  method private void GetChildren(hParent as handle, level as integer):
        
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
        when "wb:Content" or when "wbr:Content" then
          do:
            assign 
              tt-wb-header.uniq-key-rec = tt-wb-header.num + {&delim-cmd} + string (tt-wb-header.wb-date) + {&delim-cmd} + tt-wb-header.regID-Ship + {&delim-cmd} + tt-wb-header.Identity.
          end.
        when "wb:Position" then 
          do:
            create tt-wb-gds-EG .
            tt-wb-gds-EG.prod-list = chr(5) + chr(5) + chr(5) + chr(5) + chr(5) + chr(5) + chr(5).
            tt-wb-gds-EG.importer-list = chr(5) + chr(5) + chr(5) + chr(5) + chr(5) + chr(5) + chr(5).
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
        when "ns:ConfirmTicket" then 
          do:
            create tt-ticket .
            tt-ticket.doc = 'ConfirmTicket'.
          end.
      end case.
      if lookup (hParent:name, "ns:Ticket") > 0 then do:
        if hNoderef:name = "tc:DocId" then assign tt-ticket.docID = hText:node-value.
        if hNoderef:name = "tc:TransportId" then assign tt-ticket.TransId = hText:node-value.
        if hNoderef:name = "tc:TicketDate" then assign tt-ticket.ticket-date = hText:node-value.
        if hNoderef:name = "tc:RegID" 
        then do:
          assign tt-ticket.regid = hText:node-value.
        end.
        if hNoderef:name = "tc:Identity" then assign tt-ticket.Identity = hText:node-value.
        if hNoderef:name = "tc:DocType" then assign tt-ticket.doc = hText:node-value.
        
      end.

      if lookup (hParent:name, "ns:ConfirmTicket") > 0 then do:
        if hNoderef:name = "wt:Identity" then assign tt-ticket.Identity = hText:node-value.
      end.
      if lookup (hParent:name, "wt:Header") > 0 then do:
        if hNoderef:name = "wt:IsConfirm" then assign tt-ticket.status_ = hText:node-value.
        if hNoderef:name = "wt:TicketDate" then assign tt-ticket.ticket-date = hText:node-value.
        if hNoderef:name = "wt:WBRegId" then assign tt-ticket.regid = hText:node-value.
        if hNoderef:name = "wt:Note" then assign tt-ticket.comment = hText:node-value.
      end.

      if lookup (hParent:name, "tc:Result") > 0 then do:
        if hNoderef:name = "tc:Conclusion" then assign tt-ticket.status_ = hText:node-value.
        if hNoderef:name = "tc:Comments" then assign tt-ticket.comment = hText:node-value.
      end.
      if lookup (hParent:name, "tc:OperationResult") > 0 then do:
        if hNoderef:name = "tc:OperationResult" then assign tt-ticket.status_ = hText:node-value.
        if hNoderef:name = "tc:OperationComment" then assign tt-ticket.comment = hText:node-value.
      end.
      if lookup (hParent:name, "ns:Owner") > 0
      then do:
        
        if hNoderef:name = "ns:FSRAR_ID" then assign FromFSRAR = hText:node-value.

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
              end.
            when 'WBReturnFromMe' then 
              do:
                assign 
                  tt-wb-header.wb-type      = {&TDEDT_Vozvrat_Vnesh}
                  tt-wb-header.wb-type-full = "возврат".
              end.
            otherwise 
            do:
              assign 
                tt-wb-header.wb-type = ?.
            end.
          end case.
        end.
        if hNoderef:name = "wb:UnitType"     then assign tt-wb-header.UnitType = hText:node-value .
        
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
        end.
        if hNoderef:name = "oref:ShortName"   then assign tt-wb-header.NameShip = hText:node-value when hParent:name = 'wb:Shipper'.
        if hNoderef:name = "oref:INN"         then assign tt-wb-header.INNShip = hText:node-value when hParent:name = 'wb:Shipper'.
        if hNoderef:name = "oref:KPP"         then assign tt-wb-header.KPPShip = hText:node-value when hParent:name = 'wb:Shipper'.
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
      
      
      if lookup (hParent:name, "wa:Position") > 0
      then
      do:
        if hNoderef:name = "wa:InformBRegId"   then assign tt-wb-act-gds-EG.refB = hText:node-value .
        if hNoderef:name = "wa:RealQuantity"   then assign tt-wb-act-gds-EG.RealQuantity = decimal(hText:node-value) .        
      end.
      
      if lookup (hParent:name, "wb:Position,wb:Product") > 0
        then 
      do:
        if tt-wb-gds-EG.gds-name = "" then
          if hNoderef:name = "pref:ShortName"    then assign tt-wb-gds-EG.gds-name = hText:node-value.

        if hNoderef:name = "pref:FullName"     then assign tt-wb-gds-EG.gds-name = hText:node-value.
        if hNoderef:name = "pref:AlcCode"      
          then assign tt-wb-gds-EG.alc-code = hText:node-value.
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
        
        if hNoderef:name = "pref:UnitType"       then assign tt-wb-gds-EG.UnitType = hText:node-value .
        
      end.
      
      if available (tt-wb-gds-EG) and lookup (hParent:name, "pref:Importer") > 0 then do:
        if hNoderef:name = "oref:ClientRegId" then assign tt-wb-gds-EG.regID-Importer = hText:node-value .
        
        tt-wb-gds-EG.importer-th = "".
        find first ub.ext-classif no-lock 
          where ub.ext-classif.classif-subject = {&table_clients}
            and ub.ext-classif.classif-name = {&extclass_clients_esys}
            and ub.ext-classif.db-num = 0
            and ub.ext-classif.key#_one = ExtSys
            and ub.ext-classif.CharKey_Three = tt-wb-gds-EG.regID-Importer
            no-error.
        if available (ub.ext-classif) then do:
          tt-wb-gds-EG.importer-th = entry (2, ub.ext-classif.uniq-key-rec, {&delim-key}) + entry (3, ub.ext-classif.uniq-key-rec, {&delim-key}).
        end.
        
        if hNoderef:name = "oref:ClientRegId" then do:
          assign entry (1, tt-wb-gds-EG.importer-list, chr(5)) = hText:node-value .
          assign entry (5, tt-wb-gds-EG.importer-list, chr(5)) = "oref:address".
          assign entry (6, tt-wb-gds-EG.importer-list, chr(5)) = "oref:address".
        end.
        if hNoderef:name = "oref:INN"         then assign entry (2, tt-wb-gds-EG.importer-list, chr(5)) = hText:node-value .
        if hNoderef:name = "oref:KPP"         then assign entry (3, tt-wb-gds-EG.importer-list, chr(5)) = hText:node-value .
        if hNoderef:name = "oref:FullName"    then assign entry (4, tt-wb-gds-EG.importer-list, chr(5)) = hText:node-value .
        
      end.
      
      if available (tt-wb-gds-EG) and hParent:name = "oref:address" and (entry (5, tt-wb-gds-EG.importer-list, chr(5)) = "oref:address" or entry (6, tt-wb-gds-EG.importer-list, chr(5)) = "oref:address")
      then do:
        
        if hNoderef:name = "oref:Country"     then assign entry (5, tt-wb-gds-EG.importer-list, chr(5)) = hText:node-value .
        if hNoderef:name = "oref:description" then assign entry (6, tt-wb-gds-EG.importer-list, chr(5)) = hText:node-value .
      end.

      if available (tt-wb-gds-EG) and
        (lookup (hParent:name, "pref:Producer") > 0 
          or lookup (hParent:name, "oref:UL") > 0 
          or lookup (hParent:name, "pref:FL") > 0 
          or lookup (hParent:name, "pref:FO") > 0 
          or lookup (hParent:name, "pref:TS") > 0
        ) 
        then do:
        case hParent:name:
          when "oref:UL" then entry (7, tt-wb-gds-EG.prod-list, chr(5)) = 'UL'.
          when "oref:FL" then entry (7, tt-wb-gds-EG.prod-list, chr(5)) = 'FL'.
          when "oref:FO" then entry (7, tt-wb-gds-EG.prod-list, chr(5)) = 'FO'.
          when "oref:TS" then entry (7, tt-wb-gds-EG.prod-list, chr(5)) = 'TS'.
        end case. 
        if hNoderef:name = "oref:ClientRegId" then assign tt-wb-gds-EG.regID-Producer = hText:node-value .
        tt-wb-gds-EG.producer-th = "".
        find first ub.ext-classif no-lock 
          where ub.ext-classif.classif-subject = {&table_clients}
            and ub.ext-classif.classif-name = {&extclass_clients_esys}
            and ub.ext-classif.db-num = 0
            and ub.ext-classif.key#_one = ExtSys
            and ub.ext-classif.CharKey_Three = tt-wb-gds-EG.regID-Producer
            no-error.
        if available (ub.ext-classif) then do:
          tt-wb-gds-EG.producer-th = entry (2, ub.ext-classif.uniq-key-rec, {&delim-key}) + entry (3, ub.ext-classif.uniq-key-rec, {&delim-key}).
        end.
        
        if hNoderef:name = "oref:ClientRegId" 
        then do: 
          assign entry (1, tt-wb-gds-EG.prod-list, chr(5)) = hText:node-value .
          assign entry (5, tt-wb-gds-EG.prod-list, chr(5)) = "oref:address".
          assign entry (6, tt-wb-gds-EG.prod-list, chr(5)) = "oref:address".
        end.
        if hNoderef:name = "oref:INN"         then assign entry (2, tt-wb-gds-EG.prod-list, chr(5)) = hText:node-value .
        if hNoderef:name = "oref:KPP"         then assign entry (3, tt-wb-gds-EG.prod-list, chr(5)) = hText:node-value .
        if hNoderef:name = "oref:FullName"    then assign entry (4, tt-wb-gds-EG.prod-list, chr(5)) = hText:node-value .
        if hNoderef:name = "oref:RegionCode"    then assign entry (8, tt-wb-gds-EG.prod-list, chr(5)) = hText:node-value .
      end.
      
      if available (tt-wb-gds-EG) and hParent:name = "oref:address" and (entry (5, tt-wb-gds-EG.prod-list, chr(5)) = "oref:address" or entry (6, tt-wb-gds-EG.prod-list, chr(5)) = "oref:address")
      then do:
        if hNoderef:name = "oref:Country"     then assign entry (5, tt-wb-gds-EG.prod-list, chr(5)) = hText:node-value .
        if hNoderef:name = "oref:description" then assign entry (6, tt-wb-gds-EG.prod-list, chr(5)) = hText:node-value .
      end.
      
      
      if lookup (hParent:name, "wb:InformA") > 0
        then 
      do:
        if hNoderef:name = "pref:RegId" then assign tt-wb-gds-EG.refA = hText:node-value.
      end.
      if lookup (hParent:name, "wb:InformF1") > 0
        then 
      do:
        if hNoderef:name = "pref:RegId" then assign tt-wb-gds-EG.refA = hText:node-value.
      end.
      
      
      if lookup (hParent:name, "pref:InformBItem") > 0
        then 
      do:
        if hNoderef:name = "pref:BRegId" then assign tt-wb-gds-EG.beforRefB = hText:node-value.
      end.
      if lookup (hParent:name, "pref:InformF2Item") > 0
        then 
      do:
        if hNoderef:name = "pref:F2RegId" then assign tt-wb-gds-EG.beforRefB = hText:node-value.
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
        if available (tt-wb-gds-EG) and (hNoderef:name = "wbr:InformBRegId" or hNoderef:name = "wbr:InformF2RegId") then assign tt-wb-gds-EG.refB = hText:node-value.
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
              and ub.ext-classif.key#_one = ExtSys
              and ub.ext-classif.CharKey_Three =  tt-wb-gds-EG.regID-i-p
              no-error.
          if available (ub.ext-classif) then do:
            find first buf_clients where buf_clients.obj-type = entry (2, ub.ext-classif.uniq-key-rec, {&delim-key}) and buf_clients.obj-code = integer (entry (3, ub.ext-classif.uniq-key-rec, {&delim-key})) no-error.
            if available (buf_clients) 
              then tt-wb-gds-EG.i-p-name = buf_clients.obj-name.
          end.
      end.
      GetChildren(hNoderef, (level + 1)).
    end.


    delete object hNoderef.
    delete object hText.
  end.


end class.