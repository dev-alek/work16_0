 
/*------------------------------------------------------------------------
   File        : cash
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : asmorozov
   Created     : Thu Mar 05 20:00:55 MSK 2020
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.gbl.sys.objth.
using ibs.th.gbl.propmap.
using ibs.th.gbl.map.mapstring.


class ibs.th.skt.ControlledClients.marking.sts.cash inherits objth: 

  define public property  NotAccessible as class propmap no-undo get.  
    protected set.
  define public property  NotAccessibleRet as class propmap no-undo get.  
    protected set.
  define public property  NotReadyForSale as class propmap no-undo get.  
    protected set.
  define public property  OutZone as class propmap no-undo get.  
    protected set.
  define public property  Received as class propmap no-undo get.  
    protected set.
  define public property  Return_ as class propmap no-undo get.  
    protected set.


  define public property  SaleLock as class propmap no-undo get.  
    protected set.

  define public property  ReturnLock as class propmap no-undo get.  
    protected set.
  
  define public property  Unlock as class propmap no-undo get.  
    protected set.

  define public property  UnlockAll as class propmap no-undo get.  
    protected set.
  
  define public property  Commit as class propmap no-undo get.  
    protected set.

  define public property  LockOtherCash as class propmap no-undo get.  
    protected set.

  define public property  NotSaleSts as class propmap no-undo get.  
    protected set.
  
  define public property CashMap as class mapstring no-undo get. 
    protected set.



  define public property CurrCashMapProp as class propmap no-undo 
    get:
      def var currP as class propmap no-undo. 
      currP = cast (CashMap:SubjectObjCurr, propmap) no-error.
      if currP = ? or error-status:error
        then 
      do:
        "Залогируем".
        return ?.
      end.
      else return currP.
    end. 
 
  constructor public cash ():
    
    CashMap = new mapstring(true).
    NotAccessible  = crProp(1,"NotAccessible","Маркированный товар еще не поступил в продажу на АЗК. Его реализация невозможна").
    NotAccessibleRet = crProp(9,"NotAccessible","Маркированный товар еще не поступил в продажу на АЗК. Его оборот невозможен").
/*    NotReadyForSale = crProp(2,"CheckContr","Ожидает проверку по договору").*/
/*    Received   = crProp(7,"Received","Получен").                            */
/*    Return_ = crProp(8,"Return","Возврат").                                 */
/*    OutZone  = crProp(9,"OutZone","Выбыл").                                 */
    
    SaleLock  = crProp(2,"sale_lock","Маркированный товар заблокирован для продажи.").
    ReturnLock  = crProp(3,"return_lock","Маркированный товар заблокирован для возврата.").
    Unlock  = crProp(4,"unlock","Блокировка по кассе сброшена.").
    UnlockAll  = crProp(5,"unlock","Блокировки по кассе сброшены.").
    Commit  = crProp(6,"commit","Чек завершен.").
    
    LockOtherCash  = crProp(7,"LockOtherCash","Маркированный товар заблокирован другой кассой.").
    
    NotSaleSts  = crProp(8,"NotSaleSts","Товар не был продан.").

  end.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public char GetLabel(inKey as int):
    return GetLabel(string (inKey)).
  end method. 

  method private char GetLabel(inKeyStr as char):
    def var prop as class propmap no-undo.    
    if valid-object (CashMap:GetItemKeyStr(inKeyStr))
      then return cast (CashMap:SubjectObjCurr, ibs.th.gbl.propmap):Label_. 
    else return inKeyStr. /* для неизвестного типа статуса в лейбл возвращается значения ключа (грубо говоря того, что лежит в базе*/
  end method. 

  method public char GetNameProp(inKey as int):
    return GetNameProp(string (inKey)).
  end method. 
 
  method private char GetNameProp(inKeyStr as char):
    def var prop as class propmap no-undo.
    if valid-object (CashMap:GetItemKeyStr(inKeyStr))
      then return cast (CashMap:SubjectObjCurr, ibs.th.gbl.propmap):NameProp. 
    else return ?.
  end method. 

  method public int GetKeyIntDB(inKeyStr as char):
    def var prop as class propmap no-undo.
    if valid-object (CashMap:GetItemKeyStr(inKeyStr))
      then return cast (CashMap:SubjectObjCurr, ibs.th.gbl.propmap):KeyIntDB. 
    else return ?.
  end method. 
  
  method class propmap GetProp(inKey as int):
    return GetProp(string (inKey)).
  end method. 

  method private class propmap GetProp(inKeyStr as char):
    def var prop as class propmap no-undo.
    if valid-object (CashMap:GetItemKeyStr(inKeyStr))
      then return cast(CashMap:SubjectObjCurr, propmap). 
    else return ?.
  end method.
  
  method private class propmap crProp(inKeyInt as int, inNameProp as char, inLabel as char):
    def var prop as class propmap no-undo.
    prop = new propmap (string(inKeyInt), inLabel).
    prop:KeyIntDB = inKeyInt.
    prop:NameProp = inNameProp.
    CashMap:AddItem(prop, string(inKeyInt)).
    return prop.
    
  end method. 

end class.
