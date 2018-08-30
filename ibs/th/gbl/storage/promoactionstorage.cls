/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$
 
Storage Action

Автор: Рубан Дмитрий Андреевич
Дата создания: 11/07/18
Author: Ruban Dmitriy
Creation date: 11/07/18

*/
	
using Progress.Lang.*.
using ibs.th.gbl.storage.*.
using ibs.th.gbl.*.
using ibs.th.ref.promo.*.


class ibs.th.gbl.storage.promoactionstorage: 
  define variable vss-revision    as character no-undo initial "$Revision$":U .
  define variable vss-author      as character no-undo initial "$Author$":U .
  define variable vss-date        as character no-undo initial "$Date$":U .
  define variable vss-workfile    as character no-undo initial "$Workfile$":U .
  define variable vss-archive     as character no-undo initial "$Archive$":U . 
  define variable vss-description as character no-undo initial "Storage Action". 

  { cmp/str-glbl.i class }
  
  define property Msg as character
    get.
    private set.
  
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method private void exception( arg as handle, inPromoActionObj as class promoactionsub, t-h as handle ):
    
    inpromoactionObj:setMsg(arg:get-message (1)).
    inpromoactionObj:setStatusErr(arg:error).
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

  method public void insertDB( input promoactionsubObj as promoactionsub  ):
    define buffer buf_promoaction for ub.promoaction.
    define variable vID     as integer no-undo.
    define variable vDb-num as integer no-undo.
    create buf_promoaction.
    assign
      vID                    = next-value (s-promoaction-id, ub)
      buf_promoaction.id     = vID
      vDb-num                = ibs.th.gbl.gbl-var:g#db-num
      buf_promoaction.db-num = vDb-num
    no-error.
    if error-status:error
    then do:
      exception(error-status, promoactionsubObj, buffer buf_promoaction:handle).
      return.
    end.
    assign
        promoactionsubObj:ID     = VID 
        promoactionsubObj:db-num = vDb-num 
    .
    
    updateDBChiled(input promoactionsubObj,buffer buf_promoaction).  
    
  end method.
  
  method public void updateDB( input promoactionsubObj as promoactionsub  ):
    define buffer buf_promoaction for ub.promoaction.
    
    find first buf_promoaction where
          buf_promoaction.id     = promoactionsubObj:ID 
    no-error.

    if not available (buf_promoaction)
    then do:
      exception(error-status, promoactionsubObj, buffer buf_promoaction:handle).
      return.
    end.
    updateDBChiled(input promoactionsubObj,buffer buf_promoaction). 
  end method.
  method public void updateDBChiled( input ipromoactionsubObj as promoactionsub ,buffer buf_promoaction for ub.promoaction):
    define variable vStoragegoodsOBj  as class promoGoodsStorage.
    define variable vStorageCritOBj   as class promoCriterionStorage.
    define variable vStorageGiftOBj   as class promoGiftStorage.
    define variable vStorageObjectOBj as class promoObjectStorage.
    define variable vStorageschedObj  as class promoSchedstorage.
    define variable vStorageschedwObj as class promoSchedwstorage.
    define variable vSchedDay         as class promoSchedwsub.
    define variable vSchedule         as class promoSchedsub.
    
   if    valid-object (ipromoactionsubObj:Schedule)
     and valid-object (ipromoactionsubObj:ScheduleWeek) then do:
     vStorageschedwObj = new promoSchedwstorage ().       
     vStorageschedwObj:updateDBAll(ipromoactionsubObj:ScheduleWeek, buf_promoaction.Db-num).
     vSchedDay = ipromoactionsubObj:ScheduleWeek:promoSchedwObjCurr .
     
     vStorageschedObj  = new promoSchedstorage ().
     vSchedule = ipromoactionsubObj:Schedule .
     case vSchedule:Mode :
       when {&h-create} then do:
         vSchedule:ID     = vSchedDay:schedId .
         vSchedule:db-num = buf_promoaction.Db-num .
         ipromoactionsubObj:promosched-id = vSchedule:ID .
         vStorageschedObj:insertDB(vSchedule).
       end .
       when {&h-update} then     
         vStorageschedObj:updateDB(vSchedule).
       when {&h-delete} then     
         vStorageschedObj:deleteDB(vSchedule).
       otherwise .
     end case .
   end .
   setDataStorage(input ipromoactionsubObj, buffer buf_promoaction).    
   if    valid-object (ipromoactionsubObj:GoodsCrits)
      or valid-object (ipromoactionsubObj:GoodsAppl)
      or valid-object (ipromoactionsubObj:PromoSet)
   then do :
      vStoragegoodsOBj = new promoGoodsStorage().
      if    valid-object (ipromoactionsubObj:GoodsCrits)
      then
          vStoragegoodsOBj:updateDBAll(ipromoactionsubObj:GoodsCrits,buf_promoaction.ID,buf_promoaction.Db-num).
      if valid-object (ipromoactionsubObj:GoodsAppl)
      then 
          vStoragegoodsOBj:updateDBAll(ipromoactionsubObj:GoodsAppl,buf_promoaction.ID,buf_promoaction.Db-num).
      if valid-object (ipromoactionsubObj:PromoSet)
      then 
          vStoragegoodsOBj:updateDBAll(ipromoactionsubObj:PromoSet,buf_promoaction.ID,buf_promoaction.Db-num).
   end.
   if valid-object(ipromoactionsubObj:Criterion)
    then do: 
          vStorageCritOBj = new promoCriterionStorage().
          vStorageCritOBj:updateDBAll(ipromoactionsubObj:Criterion,buf_promoaction.ID,buf_promoaction.Db-num).
           
    end.
    if valid-object(ipromoactionsubObj:Gifts)
    then do:
          vStorageGiftOBj = new promoGiftStorage().
          vStorageGiftOBj:updateDBAll(ipromoactionsubObj:Gifts,buf_promoaction.ID,0,buf_promoaction.Db-num). 
           
    end.
    if valid-object(ipromoactionsubObj:Objects)
    then do:
          vStorageObjectOBj = new promoObjectStorage().
          vStorageObjectOBj:updateDBAll(ipromoactionsubObj:Objects,buf_promoaction.ID,buf_promoaction.Db-num). 
           
    end.  
    return.
    finally:
          if valid-object(vStoragegoodsOBj ) then delete object vStoragegoodsOBj.
          if valid-object(vStorageCritOBj  ) then delete object vStorageCritOBj.
          if valid-object(vStorageGiftOBj  ) then delete object vStorageGiftOBj.
          if valid-object(vStorageObjectOBj) then delete object vStorageObjectOBj.
          if valid-object(vStorageschedObj ) then delete object vStorageschedObj.
          if valid-object(vStorageschedwObj) then delete object vStorageschedwObj.       
      end finally.
  end.    
  
  method public void deleteDB( input promoactionsubObj as promoactionsub  ):
    define buffer buf_promoaction for ub.promoaction.
    define variable vStoragegoodsOBj as class promoGoodsStorage.
     
    find first buf_promoaction where
      buf_promoaction.id     = promoactionsubObj:ID
      no-error.

    if not available (buf_promoaction)
    then do:
      exception(error-status, promoactionsubObj, buffer buf_promoaction:handle).
      return.
    end.
    delete buf_promoaction.
    return.

  end method.
  
  method public class promoactionsubs getpromoactionsubs ( ):
    define buffer buf_promoaction for ub.promoaction.
  
    define variable promoactionsubsObj as class promoactionsubs.
    promoactionsubsObj = new promoactionsubs ().
    
    for each buf_promoaction no-lock:
        promoactionsubsObj:AddItem(getDataStorage (buffer buf_promoaction)).
        // + set promosched-id
    end.  
    //------------------------------------------------    
/*    define variable vin as integer no-undo.
    create buf_promoaction.
do vin = 1000 to 1005 :
    
        assign
           buf_promoaction.id = vin
           buf_promoaction.nameAction = substitute ("nameAction &1", vin)
           buf_promoaction.beg-date = today + vin 
           buf_promoaction.end-date = today + vin + 2  
           
        .
        promoactionsubsObj:AddItem(getDataStorage (buffer buf_promoaction)).
        
end .  

delete buf_promoaction.
*/
//--------------------------------------------------------
    return promoactionsubsObj.
  end method.
  
    
  method private void setDataStorage (input inpromoactionObj as class promoactionsub, buffer inbf_promoaction for ub.promoaction ):
    
    assign
        inbf_promoaction.beg-date         = inpromoactionObj:beg-date
        inbf_promoaction.end-date         = inpromoactionObj:end-date
        inbf_promoaction.nameAction       = inpromoactionObj:nameAction
        inbf_promoaction.TypeDiscont      = inpromoactionObj:TypeDiscontEnum:GetValue()
        inbf_promoaction.methodCalc       = inpromoactionObj:methodCalc
        inbf_promoaction.typecond         = inpromoactionObj:typecond
        inbf_promoaction.promosched-id    = inpromoactionObj:promosched-id
//        inbf_promoaction.db-num           = inpromoactionObj:db-num - заполнился при create
        inbf_promoaction.changeDate       = inpromoactionObj:changeDate    
        inbf_promoaction.comment          = inpromoactionObj:comment
        inbf_promoaction.description      = inpromoactionObj:description    
        inbf_promoaction.ext-code         = inpromoactionObj:ext-code 
        inbf_promoaction.paymenttype      = inpromoactionObj:paymenttype 
        inbf_promoaction.priority         = inpromoactionObj:priority 
        inbf_promoaction.status_          = inpromoactionObj:status_Enum:GetValue()
    .
    validate inbf_promoaction.
    end.
  
  method private class promoactionsub getDataStorage ( buffer inbf_promoaction for ub.promoaction ):
    
    define variable promoactionsubObj  as class promoactionsub.
    promoactionsubObj = new promoactionsub ().
    return getDataStorage(promoactionsubObj,buffer inbf_promoaction).
  end.
  method private class promoactionsub getDataStorage (input inpromoactionSubObj as class promoactionsub, buffer inbf_promoaction for ub.promoaction ):  
    
    assign
      inpromoactionSubObj:ID            = inbf_promoaction.id
      inpromoactionSubObj:beg-date      = inbf_promoaction.beg-date
      inpromoactionSubObj:end-date      = inbf_promoaction.end-date             
      inpromoactionSubObj:nameAction    = inbf_promoaction.nameAction     
      inpromoactionSubObj:TypeDiscont   = inbf_promoaction.TypeDiscont          
      inpromoactionSubObj:methodCalc    = inbf_promoaction.methodCalc         
      inpromoactionSubObj:typecond      = inbf_promoaction.typecond
      inpromoactionSubObj:promosched-id = inbf_promoaction.promosched-id // заполняется автоматом в .Schedule:set()
      inpromoactionSubObj:db-num        = inbf_promoaction.db-num
      inpromoactionSubObj:changeDate    = inbf_promoaction.changeDate
      inpromoactionSubObj:comment       = inbf_promoaction.comment
      inpromoactionSubObj:description   = inbf_promoaction.description
      inpromoactionSubObj:ext-code      = inbf_promoaction.ext-code
      inpromoactionSubObj:paymenttype   = inbf_promoaction.paymenttype
      inpromoactionSubObj:priority      = inbf_promoaction.priority
      inpromoactionSubObj:status_       = inbf_promoaction.status_
    .  
    return inpromoactionSubObj.
    
  end.
  
  method public void refreshObj (inpromoactionSubObj as class promoactionsub):
    define buffer buf_promoaction for ub.promoaction.
    if not valid-object (inpromoactionSubObj)
    then do:
      Msg = "Объект типа promoactionsub не существует".
      return.
    end.
    
    find first buf_promoaction no-lock where buf_promoaction.ID = inpromoactionSubObj:ID no-error.
    if not available (buf_promoaction)
    then do:
      Msg = "Не найден Акция - " + string (inpromoactionSubObj:ID) .
      return.
    end.
    
    define variable v-sub as class promoactionsub no-undo .
    getDataStorage (inpromoactionSubObj,buffer buf_promoaction).
  end.

end class.
