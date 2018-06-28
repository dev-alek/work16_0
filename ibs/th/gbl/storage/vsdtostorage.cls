/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

ВСД
Модуль взаимодействия сущностей TH с базой данных

Автор: Морозов Александр Сергеевич
Дата создания: 04/23/18
Author: Morozov Alexandr
Creation date: 04/23/18


*/


using Progress.Lang.*.
using ibs.th.str.mercury.*.
using ibs.th.gbl.storage.*.
using ibs.th.gbl.*.
using ibs.th.str.clients.*.


class ibs.th.gbl.storage.vsdtostorage: 
  
  { cmp/str-glbl.i class }
  
  define property Msg as character
    get.
    private set.
  
  define buffer buf_vsd for ub.vsd.
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method private void exception( arg as handle, invsdObj as class vsdsub, t-h as handle ):
    
    invsdObj:setMsg(arg:get-message (1)).
    invsdObj:setStatusErr(arg:error).
    t-h:buffer-delete () no-error.
    return.

  end method.

  method private void exception( arg as char ):
    
    Msg = arg.
    return.

  end method.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public void insertDB( input vsdsubObj as vsdsub  ):
    
    create buf_vsd.
    find first ub.sys-ctrl no-lock.
    assign
      buf_vsd.id     = next-value (s-vsd-id, ub)
      buf_vsd.db-num = ub.sys-ctrl.db-num
    no-error.
    if error-status:error
    then do:
      exception(error-status, vsdsubObj, buffer buf_vsd:handle).
      return.
    end.
    
    setDataStorage(input vsdsubObj, buffer buf_vsd).
    
    return.

  end method.
  
  method public void updateDB( input vsdsubObj as vsdsub  ):
    
    find first buf_vsd where
      buf_vsd.id     = vsdsubObj:ID and
      buf_vsd.db-num = vsdsubObj:DBNum no-error.

    if not available (buf_vsd)
    then do:
      exception(error-status, vsdsubObj, buffer buf_vsd:handle).
      return.
    end.
    setDataStorage(input vsdsubObj, buffer buf_vsd).
    release buf_vsd.
    return.

  end method.
  
  method public void deleteDB( input vsdsubObj as vsdsub  ):
    
    define buffer buf_vsd-attr for ub.vsd-attr .
    
    find first buf_vsd where
      buf_vsd.id     = vsdsubObj:ID and
      buf_vsd.db-num = vsdsubObj:DBNum no-error.

    if not available (buf_vsd)
    then do:
      exception(error-status, vsdsubObj, buffer buf_vsd:handle).
      return.
    end.
    
    for each buf_vsd-attr exclusive-lock where buf_vsd-attr.ID     = buf_vsd.ID
                                           and buf_vsd-attr.db-num = buf_vsd.db-num :
      delete buf_vsd-attr .
    end.
    
    delete buf_vsd.
    return.

  end method.
  
  method public class vsdsubs getVSDsubs ( buffer buf_parts for ub.parts ):
    define variable keyrecObj as class keyrec no-undo.
    define variable keyrec as character no-undo.
    keyrecObj = new keyrec ().
    keyrecObj:GenKeyRec({&table_parts}, buffer buf_parts:handle, output keyrec).
    delete object keyrecObj.
    return getVSDsubs (input "part-key", input keyrec).
  end.
  
  method public class vsdsubs getVSDsubs (input inFieldName as character, input inValue as character ):
    
    define variable vsdsubsObj as class vsdsubs.
    vsdsubsObj = new vsdsubs ().
    
    case inFieldName:
    when "part-key" then do:
      for each buf_vsd no-lock where buf_vsd.part-key = inValue by buf_vsd.vsd-type:
        vsdsubsObj:AddItem(getDataStorage (buffer buf_vsd)).
      end.      
    end.
    when "UUID" then do:
      for each buf_vsd no-lock where buf_vsd.UUID = inValue by buf_vsd.vsd-type:
        vsdsubsObj:AddItem(getDataStorage (buffer buf_vsd)).
      end.      
    end.
    otherwise do:
      exception( substitute ("Нет обработки для поля - &1", inFieldName) ).
    end.
    end case.
    return vsdsubsObj.
  end method.
  
  method public class vsdsubs getVSDsubs (input  inObjType    as character,
                                          input  inObjCode    as int64 ,
                                          input  inStatusList as character ):
  
      define variable vsdsubsObj as class vsdsubs.
      vsdsubsObj = new vsdsubs ().
      for each buf_vsd where buf_vsd.obj-type eq inObjType
                         and buf_vsd.obj-code eq inObjCode
                         and can-do(inStatusList,string (buf_vsd.status_))
      no-lock:
          vsdsubsObj:AddItem(getDataStorage (BUFFER buf_vsd)).
      end. 
      return vsdsubsObj.
  end method.
  
  method public class vsdsubs getVSDsubs ( buffer buf_vsd for ub.vsd ):
    define variable vsdsubsObj as class vsdsubs.
    vsdsubsObj = new vsdsubs ().
    vsdsubsObj:AddItem(getDataStorage (buffer buf_vsd)).
    return vsdsubsObj.
   
  end.  


  method public class vsdsubs getVSDsubs ( objTHObj as class clisub, vsdStatusType as integer ):
    
    define variable vsdsubsObj as class vsdsubs.
    vsdsubsObj = new vsdsubs ().
    for each buf_vsd no-lock where buf_vsd.obj-code = objTHObj:ObjCode and buf_vsd.obj-type = objTHObj:ObjType
      and buf_vsd.status_ =  vsdStatusType:
      vsdsubsObj:AddItem(getDataStorage (buffer buf_vsd)).
    end.
    
    return vsdsubsObj.
  end method.
  
  method public class vsdsubs getVSDsubs ( objTHObj as class clisub ):
    
    define variable vsdsubsObj as class vsdsubs.
    vsdsubsObj = new vsdsubs ().
    for each buf_vsd no-lock where buf_vsd.obj-code = objTHObj:ObjCode and buf_vsd.obj-type = objTHObj:ObjType :
      vsdsubsObj:AddItem(getDataStorage (buffer buf_vsd)).
    end.
    
    return vsdsubsObj.
  end method.
  
  method private void setDataStorage (input invsdObj as class vsdsub, buffer inbf_vsd for ub.vsd ):
    
    define buffer buf_vsd-attr for ub.vsd-attr .
        
    inbf_vsd.UUID            = invsdObj:UUID.
    inbf_vsd.economic-sub    = invsdObj:EconomicSub.
    inbf_vsd.date-cr         = invsdObj:DateCr.
    inbf_vsd.date-out        = invsdObj:DateOut.
    inbf_vsd.type-prod       = invsdObj:TypeProd.
    inbf_vsd.expiry-date-2   = invsdObj:ExpiryDate2.
    inbf_vsd.qnty            = invsdObj:Qnty.
    inbf_vsd.expiry-out-date = invsdObj:ExpiryOutDate.
    inbf_vsd.num-part        = invsdObj:NumPart.
    inbf_vsd.note            = invsdObj:Note.
    inbf_vsd.msg-err         = invsdObj:MsgErr.
    inbf_vsd.vsd-num         = invsdObj:VsdNum.
    inbf_vsd.expiry-date     = invsdObj:ExpiryDate.
    inbf_vsd.vsd-type        = invsdObj:VSDType.
    inbf_vsd.part-key        = invsdObj:PartKey.
    inbf_vsd.status_         = invsdObj:Status_.
    inbf_vsd.gds-code        = invsdObj:GdsCode.
    inbf_vsd.fact-datetime   = invsdObj:FactDatetime.
    inbf_vsd.obj-type        = invsdObj:ObjType.
    inbf_vsd.obj-code        = invsdObj:ObjCode.
    inbf_vsd.cli-type        = invsdObj:CliType.
    inbf_vsd.cli-code        = invsdObj:CliCode.
    inbf_vsd.gds-guid        = invsdObj:GdsGuid.
    inbf_vsd.gds-name-merc   = invsdObj:GdsName.
    
    
    find first buf_vsd-attr exclusive-lock where buf_vsd-attr.ID        = inbf_vsd.ID
                                             and buf_vsd-attr.db-num    = inbf_vsd.db-num
                                             and buf_vsd-attr.attr-code = "TransportType"
                                             no-error .
    if not available buf_vsd-attr  
    then do :
      create buf_vsd-attr.
      assign
        buf_vsd-attr.ID        = inbf_vsd.ID
        buf_vsd-attr.db-num    = inbf_vsd.db-num
        buf_vsd-attr.attr-code = "TransportType"
      .
    end.
    assign buf_vsd-attr.attr-value = invsdObj:TransportType . 
    
    
    find first buf_vsd-attr exclusive-lock where buf_vsd-attr.ID        = inbf_vsd.ID
                                             and buf_vsd-attr.db-num    = inbf_vsd.db-num
                                             and buf_vsd-attr.attr-code = "Transport"
                                             no-error .
    if not available buf_vsd-attr  
    then do :
      create buf_vsd-attr.
      assign
        buf_vsd-attr.ID        = inbf_vsd.ID
        buf_vsd-attr.db-num    = inbf_vsd.db-num
        buf_vsd-attr.attr-code = "Transport"
      .
    end.
    assign buf_vsd-attr.attr-value = invsdObj:Transport .
    
    
    find first buf_vsd-attr exclusive-lock where buf_vsd-attr.ID        = inbf_vsd.ID
                                             and buf_vsd-attr.db-num    = inbf_vsd.db-num
                                             and buf_vsd-attr.attr-code = "CarNum"
                                             no-error .
    if not available buf_vsd-attr  
    then do :
      create buf_vsd-attr.
      assign
        buf_vsd-attr.ID        = inbf_vsd.ID
        buf_vsd-attr.db-num    = inbf_vsd.db-num
        buf_vsd-attr.attr-code = "CarNum"
      .
    end.
    assign buf_vsd-attr.attr-value = invsdObj:CarNum .
    
    
    find first buf_vsd-attr exclusive-lock where buf_vsd-attr.ID        = inbf_vsd.ID
                                             and buf_vsd-attr.db-num    = inbf_vsd.db-num
                                             and buf_vsd-attr.attr-code = "ContainerNum"
                                             no-error .
    if not available buf_vsd-attr  
    then do :
      create buf_vsd-attr.
      assign
        buf_vsd-attr.ID        = inbf_vsd.ID
        buf_vsd-attr.db-num    = inbf_vsd.db-num
        buf_vsd-attr.attr-code = "ContainerNum"
      .
    end.
    assign buf_vsd-attr.attr-value = invsdObj:ContainerNum .
    
    
    find first buf_vsd-attr exclusive-lock where buf_vsd-attr.ID        = inbf_vsd.ID
                                             and buf_vsd-attr.db-num    = inbf_vsd.db-num
                                             and buf_vsd-attr.attr-code = "TrailerNum"
                                             no-error .
    if not available buf_vsd-attr  
    then do :
      create buf_vsd-attr.
      assign
        buf_vsd-attr.ID        = inbf_vsd.ID
        buf_vsd-attr.db-num    = inbf_vsd.db-num
        buf_vsd-attr.attr-code = "TrailerNum"
      .
    end.
    assign buf_vsd-attr.attr-value = invsdObj:TrailerNum .
    
    
    find first buf_vsd-attr exclusive-lock where buf_vsd-attr.ID        = inbf_vsd.ID
                                             and buf_vsd-attr.db-num    = inbf_vsd.db-num
                                             and buf_vsd-attr.attr-code = "OrigCountryGuid"
                                             no-error .
    if not available buf_vsd-attr  
    then do :
      create buf_vsd-attr.
      assign
        buf_vsd-attr.ID        = inbf_vsd.ID
        buf_vsd-attr.db-num    = inbf_vsd.db-num
        buf_vsd-attr.attr-code = "OrigCountryGuid"
      .
    end.
    assign buf_vsd-attr.attr-value = invsdObj:OrigCountryGuid .
    
    
    find first buf_vsd-attr exclusive-lock where buf_vsd-attr.ID        = inbf_vsd.ID
                                             and buf_vsd-attr.db-num    = inbf_vsd.db-num
                                             and buf_vsd-attr.attr-code = "ProducerGuid"
                                             no-error .
    if not available buf_vsd-attr  
    then do :
      create buf_vsd-attr.
      assign
        buf_vsd-attr.ID        = inbf_vsd.ID
        buf_vsd-attr.db-num    = inbf_vsd.db-num
        buf_vsd-attr.attr-code = "ProducerGuid"
      .
    end.
    assign buf_vsd-attr.attr-value = invsdObj:ProducerGuid .
    
    
    find first buf_vsd-attr exclusive-lock where buf_vsd-attr.ID        = inbf_vsd.ID
                                             and buf_vsd-attr.db-num    = inbf_vsd.db-num
                                             and buf_vsd-attr.attr-code = "ProducerRole"
                                             no-error .
    if not available buf_vsd-attr  
    then do :
      create buf_vsd-attr.
      assign
        buf_vsd-attr.ID        = inbf_vsd.ID
        buf_vsd-attr.db-num    = inbf_vsd.db-num
        buf_vsd-attr.attr-code = "ProducerRole"
      .
    end.
    assign buf_vsd-attr.attr-value = invsdObj:ProducerRole .
    
    
    find first buf_vsd-attr exclusive-lock where buf_vsd-attr.ID        = inbf_vsd.ID
                                             and buf_vsd-attr.db-num    = inbf_vsd.db-num
                                             and buf_vsd-attr.attr-code = "ProductGuid"
                                             no-error .
    if not available buf_vsd-attr  
    then do :
      create buf_vsd-attr.
      assign
        buf_vsd-attr.ID        = inbf_vsd.ID
        buf_vsd-attr.db-num    = inbf_vsd.db-num
        buf_vsd-attr.attr-code = "ProductGuid"
      .
    end.
    assign buf_vsd-attr.attr-value = invsdObj:ProductGuid .
    
    
    find first buf_vsd-attr exclusive-lock where buf_vsd-attr.ID        = inbf_vsd.ID
                                             and buf_vsd-attr.db-num    = inbf_vsd.db-num
                                             and buf_vsd-attr.attr-code = "SubProductGuid"
                                             no-error .
    if not available buf_vsd-attr  
    then do :
      create buf_vsd-attr.
      assign
        buf_vsd-attr.ID        = inbf_vsd.ID
        buf_vsd-attr.db-num    = inbf_vsd.db-num
        buf_vsd-attr.attr-code = "SubProductGuid"
      .
    end.
    assign buf_vsd-attr.attr-value = invsdObj:SubProductGuid .
    
    
    find first buf_vsd-attr exclusive-lock where buf_vsd-attr.ID        = inbf_vsd.ID
                                             and buf_vsd-attr.db-num    = inbf_vsd.db-num
                                             and buf_vsd-attr.attr-code = "UnitGuid"
                                             no-error .
    if not available buf_vsd-attr  
    then do :
      create buf_vsd-attr.
      assign
        buf_vsd-attr.ID        = inbf_vsd.ID
        buf_vsd-attr.db-num    = inbf_vsd.db-num
        buf_vsd-attr.attr-code = "UnitGuid"
      .
    end.
    assign buf_vsd-attr.attr-value = invsdObj:UnitGuid .  
    
    
    find first buf_vsd-attr exclusive-lock where buf_vsd-attr.ID        = inbf_vsd.ID
                                             and buf_vsd-attr.db-num    = inbf_vsd.db-num
                                             and buf_vsd-attr.attr-code = "Perishable"
                                             no-error .
    if not available buf_vsd-attr  
    then do :
      create buf_vsd-attr.
      assign
        buf_vsd-attr.ID        = inbf_vsd.ID
        buf_vsd-attr.db-num    = inbf_vsd.db-num
        buf_vsd-attr.attr-code = "Perishable"
      .
    end.
    assign buf_vsd-attr.attr-value = invsdObj:Perishable .  
    
    
    find first buf_vsd-attr exclusive-lock where buf_vsd-attr.ID        = inbf_vsd.ID
                                             and buf_vsd-attr.db-num    = inbf_vsd.db-num
                                             and buf_vsd-attr.attr-code = "CLiBeGuid"
                                             no-error .
    if not available buf_vsd-attr  
    then do :
      create buf_vsd-attr.
      assign
        buf_vsd-attr.ID        = inbf_vsd.ID
        buf_vsd-attr.db-num    = inbf_vsd.db-num
        buf_vsd-attr.attr-code = "CLiBeGuid"
      .
    end.
    assign buf_vsd-attr.attr-value = invsdObj:CLiBeGuid .  
    
    
    find first buf_vsd-attr exclusive-lock where buf_vsd-attr.ID        = inbf_vsd.ID
                                             and buf_vsd-attr.db-num    = inbf_vsd.db-num
                                             and buf_vsd-attr.attr-code = "CLiEntGuid"
                                             no-error .
    if not available buf_vsd-attr  
    then do :
      create buf_vsd-attr.
      assign
        buf_vsd-attr.ID        = inbf_vsd.ID
        buf_vsd-attr.db-num    = inbf_vsd.db-num
        buf_vsd-attr.attr-code = "CLiEntGuid"
      .
    end.
    assign buf_vsd-attr.attr-value = invsdObj:CLiEntGuid . 
    
    
    find first buf_vsd-attr exclusive-lock where buf_vsd-attr.ID        = inbf_vsd.ID
                                             and buf_vsd-attr.db-num    = inbf_vsd.db-num
                                             and buf_vsd-attr.attr-code = "TTNissueSeries"
                                             no-error .
    if not available buf_vsd-attr  
    then do :
      create buf_vsd-attr.
      assign
        buf_vsd-attr.ID        = inbf_vsd.ID
        buf_vsd-attr.db-num    = inbf_vsd.db-num
        buf_vsd-attr.attr-code = "TTNissueSeries"
      .
    end.
    assign buf_vsd-attr.attr-value = invsdObj:TTNissueSeries . 
    
    
    find first buf_vsd-attr exclusive-lock where buf_vsd-attr.ID        = inbf_vsd.ID
                                             and buf_vsd-attr.db-num    = inbf_vsd.db-num
                                             and buf_vsd-attr.attr-code = "TTNissueNumber"
                                             no-error .
    if not available buf_vsd-attr  
    then do :
      create buf_vsd-attr.
      assign
        buf_vsd-attr.ID        = inbf_vsd.ID
        buf_vsd-attr.db-num    = inbf_vsd.db-num
        buf_vsd-attr.attr-code = "TTNissueNumber"
      .
    end.
    assign buf_vsd-attr.attr-value = invsdObj:TTNissueNumber .  
    
    
    find first buf_vsd-attr exclusive-lock where buf_vsd-attr.ID        = inbf_vsd.ID
                                             and buf_vsd-attr.db-num    = inbf_vsd.db-num
                                             and buf_vsd-attr.attr-code = "TTNissueDate"
                                             no-error .
    if not available buf_vsd-attr  
    then do :
      create buf_vsd-attr.
      assign
        buf_vsd-attr.ID        = inbf_vsd.ID
        buf_vsd-attr.db-num    = inbf_vsd.db-num
        buf_vsd-attr.attr-code = "TTNissueDate"
      .
    end.
    assign buf_vsd-attr.attr-value = invsdObj:TTNissueDate .  
    
    
    find first buf_vsd-attr exclusive-lock where buf_vsd-attr.ID        = inbf_vsd.ID
                                             and buf_vsd-attr.db-num    = inbf_vsd.db-num
                                             and buf_vsd-attr.attr-code = "TTNtype"
                                             no-error .
    if not available buf_vsd-attr  
    then do :
      create buf_vsd-attr.
      assign
        buf_vsd-attr.ID        = inbf_vsd.ID
        buf_vsd-attr.db-num    = inbf_vsd.db-num
        buf_vsd-attr.attr-code = "TTNtype"
      .
    end.
    assign buf_vsd-attr.attr-value = invsdObj:TTNtype .  
    
    
    find first buf_vsd-attr exclusive-lock where buf_vsd-attr.ID        = inbf_vsd.ID
                                             and buf_vsd-attr.db-num    = inbf_vsd.db-num
                                             and buf_vsd-attr.attr-code = "TTNrelationshipType"
                                             no-error .
    if not available buf_vsd-attr  
    then do :
      create buf_vsd-attr.
      assign
        buf_vsd-attr.ID        = inbf_vsd.ID
        buf_vsd-attr.db-num    = inbf_vsd.db-num
        buf_vsd-attr.attr-code = "TTNrelationshipType"
      .
    end.
    assign buf_vsd-attr.attr-value = invsdObj:TTNrelationshipType .                                 
    
    
    find first buf_vsd-attr exclusive-lock where buf_vsd-attr.ID        = inbf_vsd.ID
                                             and buf_vsd-attr.db-num    = inbf_vsd.db-num
                                             and buf_vsd-attr.attr-code = "PurposeGuid"
                                             no-error .
    if not available buf_vsd-attr  
    then do :
      create buf_vsd-attr.
      assign
        buf_vsd-attr.ID        = inbf_vsd.ID
        buf_vsd-attr.db-num    = inbf_vsd.db-num
        buf_vsd-attr.attr-code = "PurposeGuid"
      .
    end.
    assign buf_vsd-attr.attr-value = invsdObj:PurposeGuid .  
    
    
    find first buf_vsd-attr exclusive-lock where buf_vsd-attr.ID        = inbf_vsd.ID
                                             and buf_vsd-attr.db-num    = inbf_vsd.db-num
                                             and buf_vsd-attr.attr-code = "CargoInspected"
                                             no-error .
    if not available buf_vsd-attr  
    then do :
      create buf_vsd-attr.
      assign
        buf_vsd-attr.ID        = inbf_vsd.ID
        buf_vsd-attr.db-num    = inbf_vsd.db-num
        buf_vsd-attr.attr-code = "CargoInspected"
      .
    end.
    assign buf_vsd-attr.attr-value = invsdObj:CargoInspected .  
    
    
    find first buf_vsd-attr exclusive-lock where buf_vsd-attr.ID        = inbf_vsd.ID
                                             and buf_vsd-attr.db-num    = inbf_vsd.db-num
                                             and buf_vsd-attr.attr-code = "CargoExpertized"
                                             no-error .
    if not available buf_vsd-attr  
    then do :
      create buf_vsd-attr.
      assign
        buf_vsd-attr.ID        = inbf_vsd.ID
        buf_vsd-attr.db-num    = inbf_vsd.db-num
        buf_vsd-attr.attr-code = "CargoExpertized"
      .
    end.
    assign buf_vsd-attr.attr-value = invsdObj:CargoExpertized .  
    
    
    find first buf_vsd-attr exclusive-lock where buf_vsd-attr.ID        = inbf_vsd.ID
                                             and buf_vsd-attr.db-num    = inbf_vsd.db-num
                                             and buf_vsd-attr.attr-code = "LocationProsperity"
                                             no-error .
    if not available buf_vsd-attr  
    then do :
      create buf_vsd-attr.
      assign
        buf_vsd-attr.ID        = inbf_vsd.ID
        buf_vsd-attr.db-num    = inbf_vsd.db-num
        buf_vsd-attr.attr-code = "LocationProsperity"
      .
    end.
    assign buf_vsd-attr.attr-value = invsdObj:LocationProsperity .   
    
    
    release inbf_vsd.
    release buf_vsd-attr.
    
  end.
  
  method private class vsdsub getDataStorage ( buffer inbf_vsd for ub.vsd ):
    
    define variable vsdsubObj  as class vsdsub.
    define buffer buf_vsd-attr for ub.vsd-attr .
      
    vsdsubObj = new vsdsub ().
    
    assign
      vsdsubObj:ID            = inbf_vsd.id
      vsdsubObj:DBNum         = inbf_vsd.db-num
      vsdsubObj:UUID          = inbf_vsd.UUID             
      vsdsubObj:EconomicSub   = inbf_vsd.economic-sub     
      vsdsubObj:DateCr        = inbf_vsd.date-cr          
      vsdsubObj:DateOut       = inbf_vsd.date-out         
      vsdsubObj:TypeProd      = inbf_vsd.type-prod        
      vsdsubObj:ExpiryDate2   = inbf_vsd.expiry-date-2    
      vsdsubObj:Qnty          = inbf_vsd.qnty             
      vsdsubObj:ExpiryOutDate = inbf_vsd.expiry-out-date  
      vsdsubObj:NumPart       = inbf_vsd.num-part         
      vsdsubObj:Note          = inbf_vsd.note             
      vsdsubObj:MsgErr        = inbf_vsd.msg-err          
      vsdsubObj:VsdNum        = inbf_vsd.vsd-num          
      vsdsubObj:ExpiryDate    = inbf_vsd.expiry-date      
      vsdsubObj:PartKey       = inbf_vsd.part-key         
      vsdsubObj:Status_       = inbf_vsd.status_
      vsdsubObj:GdsCode       = inbf_vsd.gds-code     
      vsdsubObj:FactDatetime  = inbf_vsd.fact-datetime
      vsdsubObj:ObjType       = inbf_vsd.obj-type     
      vsdsubObj:ObjCode       = inbf_vsd.obj-code
      vsdsubObj:VSDType       = inbf_vsd.vsd-type
      vsdsubObj:CliType       = inbf_vsd.cli-type     
      vsdsubObj:CliCode       = inbf_vsd.cli-code 
      vsdsubObj:GdsGuid       = inbf_vsd.gds-guid   
      vsdsubObj:GdsName       = inbf_vsd.gds-name-merc
      vsdsubObj:VsdRecid      = recid (inbf_vsd).   
    .
    
    for each buf_vsd-attr no-lock where buf_vsd-attr.ID     = inbf_vsd.ID
                                    and buf_vsd-attr.db-num = inbf_vsd.db-num :
      case buf_vsd-attr.attr-code :
        when "TransportType"    then vsdsubObj:TransportType    = buf_vsd-attr.attr-value .
        when "Transport"        then vsdsubObj:Transport        = buf_vsd-attr.attr-value .
        when "CarNum"           then vsdsubObj:CarNum           = buf_vsd-attr.attr-value .
        when "ContainerNum"     then vsdsubObj:ContainerNum     = buf_vsd-attr.attr-value .
        when "TrailerNum"       then vsdsubObj:TrailerNum       = buf_vsd-attr.attr-value .
        when "OrigCountryGuid"  then vsdsubObj:OrigCountryGuid  = buf_vsd-attr.attr-value .
        when "ProducerGuid"     then vsdsubObj:ProducerGuid     = buf_vsd-attr.attr-value .
        when "ProducerRole"     then vsdsubObj:ProducerRole     = buf_vsd-attr.attr-value .
        when "ProductGuid"      then vsdsubObj:ProductGuid      = buf_vsd-attr.attr-value .
        when "SubProductGuid"   then vsdsubObj:SubProductGuid   = buf_vsd-attr.attr-value .
        when "UnitGuid"         then vsdsubObj:UnitGuid         = buf_vsd-attr.attr-value .
        when "Perishable"       then vsdsubObj:Perishable       = buf_vsd-attr.attr-value .
        when "CliBeGuid"        then vsdsubObj:CliBeGuid        = buf_vsd-attr.attr-value .
        when "CliEntGuid"       then vsdsubObj:CliEntGuid       = buf_vsd-attr.attr-value .
        when "TTNissueSeries"   then vsdsubObj:TTNissueSeries   = buf_vsd-attr.attr-value .
        when "TTNissueNumber"   then vsdsubObj:TTNissueNumber   = buf_vsd-attr.attr-value .
        when "TTNissueDate"     then vsdsubObj:TTNissueDate     = buf_vsd-attr.attr-value .
        when "TTNtype"          then vsdsubObj:TTNtype          = buf_vsd-attr.attr-value .
        when "TTNrelationshipType" then vsdsubObj:TTNrelationshipType = buf_vsd-attr.attr-value .
        when "PurposeGuid"      then vsdsubObj:PurposeGuid      = buf_vsd-attr.attr-value .
        when "CargoInspected"   then vsdsubObj:CargoInspected   = buf_vsd-attr.attr-value .
        when "CargoExpertized"  then vsdsubObj:CargoExpertized  = buf_vsd-attr.attr-value .
        when "LocationProsperity"  then vsdsubObj:LocationProsperity  = buf_vsd-attr.attr-value .
      end case.
    end.
           
    return vsdsubObj.
    
  end.
  
  method public void refreshObj (inVsdSubObj as class vsdsub):
    
    if not valid-object (inVsdSubObj)
    then do:
      Msg = "Объект типа vsdsub не существует".
      return.
    end.
    
    find first buf_vsd no-lock where buf_vsd.ID = inVsdSubObj:ID and buf_vsd.db-num = inVsdSubObj:DBNum no-error.
    if not available (buf_vsd)
    then do:
      Msg = "Не найден ВДС - " + string (inVsdSubObj:ID) + string ( inVsdSubObj:DBNum ).
      return.
    end.
    getDataStorage (buffer buf_vsd).
    release buf_vsd.
    
  end.

  method public logical exsistuuid (inVsdSubObj as class vsdsub):
    
    define variable trnDoc as character no-undo. 
    
    find first buf_vsd no-lock where recid (buf_vsd) <> inVsdSubObj:VsdRecid and buf_vsd.UUID = inVsdSubObj:UUID no-error.
    if available (buf_vsd)
    then do:
      trnDoc = entry (7,buf_vsd.part-key, {&delim-key}) no-error.
      Msg = substitute ("ВСД UUID &1 уже заведен в системе. Документ - &2. Товар - &3.", buf_vsd.UUID, trnDoc, buf_vsd.gds-code ).
      inVsdSubObj:setStatusErr(true).
      inVsdSubObj:MsgErr = Msg.
      release buf_vsd.
      return true.
      
    end.
    return false.
    
  end.
  
  method public logical exsistvsd (buffer inbf_dl for ub.doc-line):
    
    define variable keyrecObj as class keyrec no-undo.
    define variable keyrec as character no-undo.
    define buffer buf_parts for ub.parts.
    
    keyrecObj = new keyrec ().

    find first buf_parts no-lock where buf_parts.out-code = inbf_dl.doc-code
      and buf_parts.artic = inbf_dl.artic
      and buf_parts.prod-type = inbf_dl.prod-type
      and buf_parts.prod-code = inbf_dl.prod-code no-error.
    if not available (buf_parts)
      then return false.
    for each buf_parts no-lock where buf_parts.out-code = inbf_dl.doc-code 
      and buf_parts.artic = inbf_dl.artic
      and buf_parts.prod-type = inbf_dl.prod-type
      and buf_parts.prod-code = inbf_dl.prod-code:
      
      keyrecObj:GenKeyRec({&table_parts}, buffer buf_parts:handle, output keyrec).
      
      find first buf_vsd no-lock where buf_vsd.part-key = keyrec and buf_vsd.UUID <> "" and buf_vsd.UUID <> ? no-error.
      if not available (buf_vsd) 
        then return false.
    end.
    delete object keyrecObj.    
    return true.
    
  end.

  method public logical exsistvsd (buffer inbf_gd-dtl for ub.gds-dtl):
    
    define variable keyrecObj as class keyrec no-undo.
    define variable keyrec as character no-undo.
    define buffer buf_parts for ub.parts.
    
    keyrecObj = new keyrec ().

    find first buf_parts no-lock where buf_parts.out-code = inbf_gd-dtl.doc-code
      and buf_parts.artic = inbf_gd-dtl.artic
      and buf_parts.prod-type = inbf_gd-dtl.prod-type
      and buf_parts.prod-code = inbf_gd-dtl.prod-code no-error.
    if not available (buf_parts)
      then return false.
    for each buf_parts no-lock where buf_parts.out-code = inbf_gd-dtl.doc-code 
      and buf_parts.artic = inbf_gd-dtl.artic
      and buf_parts.prod-type = inbf_gd-dtl.prod-type
      and buf_parts.prod-code = inbf_gd-dtl.prod-code:
      
      keyrecObj:GenKeyRec({&table_parts}, buffer buf_parts:handle, output keyrec).
      
      find first buf_vsd no-lock where buf_vsd.part-key = keyrec and buf_vsd.UUID <> "" and buf_vsd.UUID <> ? no-error.
      if not available (buf_vsd) 
        then return false.
    end.
    delete object keyrecObj.    
    return true.
    
  end.

end class.
