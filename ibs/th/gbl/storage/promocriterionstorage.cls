/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$
 
Storage Criterion Action

Автор: Рубан Дмитрий Андреевич
Дата создания: 11/07/18
Author: Ruban Dmitriy
Creation date: 11/07/18

*/


using Progress.Lang.*.
using ibs.th.gbl.storage.*.
using ibs.th.gbl.*.
using ibs.th.ref.promo.*.
block-level on error undo, throw.

class ibs.th.gbl.storage.promoCriterionstorage: 
  define variable vss-revision    as character no-undo initial "$Revision$":U .
  define variable vss-author      as character no-undo initial "$Author$":U .
  define variable vss-date        as character no-undo initial "$Date$":U .
  define variable vss-workfile    as character no-undo initial "$Workfile$":U .
  define variable vss-archive     as character no-undo initial "$Archive$":U . 
  define variable vss-description as character no-undo initial "Storage Criterion Action". 

  { cmp/str-glbl.i class }
  
  define property Msg as character
    get.
    private set.
  
  
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes: 
  ------------------------------------------------------------------------------*/

  method private void exception( arg as handle, inPromoCriterionObj as class promoCriterionsub, t-h as handle ):
    
    inpromoCriterionObj:setMsg(arg:get-message (1)).
    inpromoCriterionObj:setStatusErr(arg:error).
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
  method public void updateDBAll( input promoCriterionsubsObj as promoCriterionsubs ):
      updateDBAll (promoCriterionsubsObj,?,?).
  end.     
  method public void updateDBAll( input promoCriterionsubsObj as promoCriterionsubs ,input pIdParent as int64,input pdb-num as integer  ):
      define variable vi as int no-undo.
      define variable v-sub as promoCriterionsub no-undo .
      do vi =  1 to promoCriterionsubsObj:GetItem(vi):
         v-sub =promoCriterionsubsObj:promoCriterionObjCurr.
         if pIdParent ne ?
         then 
            v-sub:idAction = pIdParent.
         
         if pdb-num ne ?
         then 
            v-sub:db-num = pdb-num.
         
         if      v-sub:Mode eq {&h-create}
         then
            insertDB(v-sub).
         else if v-sub:Mode eq {&h-update}
         then     
            updateDB(v-sub).
         else if v-sub:Mode eq {&h-delete}
         then     
            deleteDB(v-sub). 
            
      end.    
  end.
  
  method public void insertDB( input promoCriterionsubObj as promoCriterionsub  ):
     define buffer buf_promoCriterion for ub.promoCriterion.
      if promoCriterionsubObj:db-num eq ? then
       undo, throw new Progress.Lang.AppError(
         substitute("отсутствует db-num в классе с кодом товара &1", string(promoCriterionsubObj:mincrit))
       ) .
    define variable vId as integer no-undo.
    create buf_promoCriterion.
    assign
      VId                       = next-value (s-promoCriterion-id, ub)
      buf_promoCriterion.id     = vId
      buf_promoCriterion.db-num = promoCriterionsubObj:db-num 
    no-error.
    if error-status:error 
    then do:
      exception(error-status, promoCriterionsubObj, buffer buf_promoCriterion:handle).
      return.
    end.
    
    setDataStorage(input promoCriterionsubObj, buffer buf_promoCriterion).
    
    define variable vStorageGiftOBj  as class promoGiftStorage.
    if valid-object(promoCriterionsubObj:Gifts)
    then do:
          vStorageGiftOBj = new promoGiftStorage().
          vStorageGiftOBj:updateDBAll(promoCriterionsubObj:Gifts,promoCriterionsubObj:idAction,vID,promoCriterionsubObj:db-num).
    end.
    return.
    finally:
          if valid-object(vStorageGiftOBj) then delete object vStorageGiftOBj.
    end finally.
   

  end method.
  
  method public void updateDB( input promoCriterionsubObj as promoCriterionsub  ):
    define buffer buf_promoCriterion for ub.promoCriterion.
    find first buf_promoCriterion where
          buf_promoCriterion.id     = promoCriterionsubObj:ID 
    no-error.

    if not available (buf_promoCriterion)
    then do:
      exception(error-status, promoCriterionsubObj, buffer buf_promoCriterion:handle).
      return.
    end.
    setDataStorage(input promoCriterionsubObj, buffer buf_promoCriterion).
    define variable vStorageGiftOBj  as class promoGiftStorage.
    if valid-object(promoCriterionsubObj:Gifts)
    then do:
          vStorageGiftOBj = new promoGiftStorage().
          vStorageGiftOBj:updateDBAll(promoCriterionsubObj:Gifts,promoCriterionsubObj:idAction,promoCriterionsubObj:ID,promoCriterionsubObj:db-num).
    end.
    return.
    finally:
          if valid-object(vStorageGiftOBj) then delete object vStorageGiftOBj.
    end finally.
  end method.
  
  method public void deleteDB( input promoCriterionsubObj as promoCriterionsub  ):
    define buffer buf_promoCriterion for ub.promoCriterion.  
    find first buf_promoCriterion where
      buf_promoCriterion.id     = promoCriterionsubObj:ID
      no-error.

    if not available (buf_promoCriterion)
    then do:
      exception(error-status, promoCriterionsubObj, buffer buf_promoCriterion:handle).
      return.
    end.
    
    delete buf_promoCriterion.
    return.

  end method.
  
  method public class promoCriterionsubs getpromoCriterionsubs (input pId as int64,input idb-num as int ):
    define buffer buf_promoCriterion for ub.promoCriterion.
    define variable promoCriterionsubsObj as class promoCriterionsubs.
    promoCriterionsubsObj = new promoCriterionsubs ().
    
    for each buf_promoCriterion  where buf_promoCriterion.idAction = pId
                                   and buf_promoCriterion.db-num = idb-num
    no-lock: 
        promoCriterionsubsObj:AddItem(getDataStorage (buffer buf_promoCriterion)).
    end.      
    return promoCriterionsubsObj.
  end method.
  
    
  method private void setDataStorage (input inpromoCriterionObj as class promoCriterionsub, buffer inbf_promoCriterion for ub.promoCriterion ):
    
    assign
        inbf_promoCriterion.mincrit         = inpromoCriterionObj:mincrit
        inbf_promoCriterion.discont         = inpromoCriterionObj:discont
        inbf_promoCriterion.idAction        = inpromoCriterionObj:idAction
        //inbf_promoCriterion.db-num          = inpromoCriterionObj:db-num 
        
    .
    validate inbf_promoCriterion.
    end.
  
  method private class promoCriterionsub getDataStorage ( buffer inbf_promoCriterion for ub.promoCriterion ):
    
    define variable promoCriterionsubObj  as class promoCriterionsub.
    promoCriterionsubObj = new promoCriterionsub ().
    return getDataStorage(promoCriterionsubObj,buffer inbf_promoCriterion).
  end.
  
  method private class promoCriterionsub getDataStorage (inpromoCriterionSubObj as class promoCriterionsub,buffer inbf_promoCriterion for ub.promoCriterion ): 
    assign 
      inpromoCriterionSubObj:ID            = inbf_promoCriterion.id
      inpromoCriterionSubObj:mincrit       = inbf_promoCriterion.mincrit
      inpromoCriterionSubObj:discont       = inbf_promoCriterion.discont             
      inpromoCriterionSubObj:idAction      = inbf_promoCriterion.idAction     
      inpromoCriterionSubObj:db-num        = inbf_promoCriterion.db-num        
    .  
       
    return inpromoCriterionSubObj.
    
  end.
  
  method public void refreshObj (inpromoCriterionSubObj as class promoCriterionsub):
    define buffer buf_promoCriterion for ub.promoCriterion.
    if not valid-object (inpromoCriterionSubObj)
    then do:
      Msg = "Объект типа promoCriterionsub не существует".
      return.
    end.
    
    find first buf_promoCriterion no-lock where buf_promoCriterion.ID = inpromoCriterionSubObj:ID no-error.
    if not available (buf_promoCriterion)
    then do:
      Msg = "Не найден Критерий - " + string (inpromoCriterionSubObj:ID) .
      return.
    end.
    getDataStorage (inpromoCriterionSubObj,buffer buf_promoCriterion).
  end.

end class.
