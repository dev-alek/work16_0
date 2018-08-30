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
      vID                    = if promoactionsubObj:id > 0 then promoactionsubObj:id else next-value (s-promoaction-id, ub)
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
    define variable vSchedDays        as class promoSchedwsubs.
    define variable vSchedDay         as class promoSchedwsub.
    define variable vSchedule         as class promoSchedsub.
    define variable v-sched-id        as integer no-undo .
    
    assign
      vSchedDays = ipromoactionsubObj:ScheduleWeek
      vSchedule  = ipromoactionsubObj:Schedule
    .
   if valid-object (vSchedDays) and valid-object (vSchedule) then do:
     vStorageschedwObj = new promoSchedwstorage ().       
//   vStorageschedwObj:updateDBAll(vSchedDays, buf_promoaction.Db-num, buf_promoaction.promosched-id) .
     vStorageschedwObj:updateDBAll(vSchedDays, buf_promoaction.Db-num, ipromoactionsubObj:promosched-id) .
     
     vStorageschedObj  = new promoSchedstorage ().
     case vSchedule:Mode :
       when {&h-create} then do:
         vSchedule:db-num = buf_promoaction.Db-num .
         
         vSchedDay  = vSchedDays:promoSchedwObjCurr .
         v-sched-id = if valid-object(vSchedDay) then vSchedDay:schedId else next-value (s-promosched-id, ub) .
         assign
           vSchedule:ID = v-sched-id 
           ipromoactionsubObj:promosched-id = v-sched-id
         .
         
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
    return promoactionsubsObj.
  end method.
    method public class promoactionsubs getpromoactionsubs (input iDate as date,input istatus as integer  ):
    define buffer buf_promoaction for ub.promoaction.
    define variable hQuery   as handle  no-undo .
    define variable vStrWhere as character no-undo.
    define variable promoactionsubsObj as class promoactionsubs.
    promoactionsubsObj = new promoactionsubs ().
    if idate <> ? 
    then
       vStrWhere = (if vStrWhere eq "" then "" else vStrWhere + " and ") + "buf_PromoAction.end-date >= " + string(idate).
    
    if istatus <> ? 
    then
       vStrWhere = (if vStrWhere eq "" then "" else vStrWhere + " and ") + "buf_PromoAction.Status_ = "  + string(istatus).
    
    
    vStrWhere = (if vStrWhere eq "" then "" else " where " + vStrWhere).
    create query hQuery.  
    hQuery:set-buffers(buffer buf_promoaction:HANDLE).
     
    hQuery:query-prepare("FOR EACH buf_promoaction " + vStrWhere).
    hQuery:query-open ().
    hQuery:get-first ().
    do while hQuery:query-off-end = false :
        promoactionsubsObj:AddItem(getDataStorage (buffer buf_promoaction)).
        hQuery:get-next().
    end.
    hQuery:query-close() .
    delete object hQuery.
     
    return promoactionsubsObj.
  end method.
  
   method public class promoactionsub CopyObject (input inpromoactionObj as class promoactionsub):
    define variable promoactionsubObj  as class promoactionsub.
    promoactionsubObj = new promoactionsub ().
    //promoactionsubObj = cast(inpromoactionObj:Clone(),promoactionsub). 
    assign
         // id ставляем чтобы начита потомков с родителя     
        promoactionsubObj:ID          = inpromoactionObj:ID
        promoactionsubObj:Mode        = {&h-create}
        promoactionsubObj:status_          = 0
        promoactionsubObj:NameAction  = inpromoactionObj:NameAction
                                                     
        promoactionsubObj:beg-date         = inpromoactionObj:beg-date
        promoactionsubObj:end-date        = inpromoactionObj:end-date
        promoactionsubObj:nameAction       = inpromoactionObj:nameAction
        promoactionsubObj:TypeDiscontEnum      = inpromoactionObj:TypeDiscontEnum
        promoactionsubObj:methodCalc       = inpromoactionObj:methodCalc
        promoactionsubObj:typecond         = inpromoactionObj:typecond
        promoactionsubObj:promosched-id    = inpromoactionObj:promosched-id
        promoactionsubObj:db-num           = inpromoactionObj:db-num // - заполнился при create
        promoactionsubObj:changeDate      = inpromoactionObj:changeDate    
        promoactionsubObj:comment          = inpromoactionObj:comment
        promoactionsubObj:description      = inpromoactionObj:description    
        promoactionsubObj:ext-code          = inpromoactionObj:ext-code 
        promoactionsubObj:paymenttype      = inpromoactionObj:paymenttype 
        promoactionsubObj:priority         = inpromoactionObj:priority 
        
        
        
    .
    promoactionsubObj:refreshChildObj().
    promoactionsubObj:id = 0.
    return promoactionsubObj.
    end.
    
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
