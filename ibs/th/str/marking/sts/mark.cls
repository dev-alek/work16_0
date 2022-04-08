 
 /*------------------------------------------------------------------------
    File        : mark
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : asmorozov
    Created     : Mon Feb 24 19:25:41 MSK 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.gbl.propmap.
using ibs.th.gbl.map.mapstring.
using ibs.th.gbl.sys.objth.


class ibs.th.str.marking.sts.mark inherits objth:
  
  define public property  PendingVerification as class propmap no-undo get.  protected set.
  define public property  CheckContr  as class propmap no-undo get.  protected set.
  define public property  DeliveryControl  as class propmap no-undo get.  protected set.
  define public property  DemandInfo as class propmap no-undo get.  protected set.
  define public property  MarkError as class propmap no-undo get.  protected set.
  define public property  NotAvailable as class propmap no-undo get.  protected set.
  define public property  Checked_  as class propmap no-undo get.  protected set.
  define public property  Received as class propmap no-undo get.  protected set.
  define public property  OutZone as class propmap no-undo get.  protected set.
  define public property  FreeZone as class propmap no-undo get.  protected set.
  define public property  Reserved as class propmap no-undo get.  protected set.
  define public property  SaleLock  as class propmap no-undo get.  protected set.
  define public property  ReturnLock  as class propmap no-undo get.  protected set.
  define public property  SaleWaitLock  as class propmap no-undo get.  protected set.
  define public property  ReturnWaitLock  as class propmap no-undo get.  protected set.
  define public property  Ungrouped as class propmap no-undo get.  protected set.
  define public property  GrayZone as class propmap no-undo get.  protected set.
  
  define public property  UnknowSts as class propmap no-undo get.  protected set.
  
  /*
  define public property  ErrorSubordinateCodes as class propmap no-undo get.  protected set.
  define public property  ErrorOver as class propmap no-undo get.  protected set.
  define public property  Moved as class propmap no-undo get.  protected set.
  define public property  Implemented as class propmap no-undo get.  protected set.
  define public property  WrittenOff  as class propmap no-undo get.  protected set.
  define public property  Sale  as class propmap no-undo get.  protected set.
  define public property  Return_  as class propmap no-undo get.  protected set.
  define public property  Returned  as class propmap no-undo get.  protected set.
*/
  define public property MarkMap as class mapstring no-undo get. 
    protected set.

  define public property CurrMarkMapProp as class propmap no-undo 
  get:
    def var currP as class propmap no-undo. 
    currP = cast (MarkMap:SubjectObjCurr, propmap) no-error.
    if currP = ? or error-status:error
    then do:
     "Залогируем".
      return ?.
    end.
    else return currP.
  end. 
 
  constructor public mark ():
    
    {utl\objreg.i MarkMap mapstring true}
    
    PendingVerification  = crProp(1,"PendingVerification","Ожидает проверку").
    CheckContr   = crProp(2,"CheckContr","Ожидает проверку по договору").
    DeliveryControl = crProp(3,"DeliveryControl","Ожидает приемку").
    DemandInfo = crProp(4,"DemandInfo","Запрос инфо").
    MarkError = crProp(5,"MarkError","Ошибка").
    NotAvailable   = crProp(6,"NotAvailable","Отсутствует в поставке").
    Checked_   = crProp(7,"Checked_","Проверен").
    Received   = crProp(8,"Received","Получен").
    OutZone  = crProp(9,"OutZone","Выбыл").
    FreeZone  = crProp(10,"FreeZone","Свободная зона").
    SaleLock   = crProp(11,"SaleLock","Продан на кассе").
    ReturnLock   = crProp(12,"ReturnLock","Возвращен на кассе").
    SaleWaitLock   = crProp(14,"SaleWaitLock","Идет продажа").
    ReturnWaitLock   = crProp(15,"ReturnWaitLock","Блокировка идет возврат").
    Reserved   = crProp(13,"Reserved","Зарезервирован").
    Ungrouped  = crProp(20,"Ungrouped","Разгруппирован").
    
    GrayZone  = crProp(21,"GrayZone","Серая зона").
    
    
    UnknowSts  = crProp(0,"UnknowSts","Неизвестный статус маркированного товара.").
    
   /* 
    ErrorSubordinateCodes  = crProp(6,"ErrorSubordinateCodes","Ошибка подчиненных кодов").
    ErrorOver  = crProp(7,"ErrorOver","Ошибка излишек").
    Moved  = crProp(8,"Moved","Перемещен").
    
    WrittenOff   = crProp(10,"WrittenOff ","Списан").
    Sale   = crProp(11,"Sale","Продажа").
    Return_   = crProp(12,"Return","Возврат").
    SaleLock   = crProp(13,"SaleLock","Блокировка продажа").
    ReturnLock   = crProp(14,"ReturnLock","Блокировка возврат").
    Returned   = crProp(15,"Returned","Возвращен").
   */
  end.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public char GetLabel(inKey as int):
    def var prop as class propmap no-undo.    
    if valid-object (MarkMap:GetItemKeyInt(inKey))
      then return cast (MarkMap:SubjectObjCurr, ibs.th.gbl.propmap):Label_. 
      else return string(inKey). /* для неизвестного типа статуса в лейбл возвращается значения ключа (грубо говоря того, что лежит в базе*/
  end method. 

  method private char GetLabel(inKeyStr as char):
    def var prop as class propmap no-undo.    
    if valid-object (MarkMap:GetItemKeyStr(inKeyStr))
      then return cast (MarkMap:SubjectObjCurr, ibs.th.gbl.propmap):Label_. 
      else return inKeyStr. /* для неизвестного типа статуса в лейбл возвращается значения ключа (грубо говоря того, что лежит в базе*/
  end method. 

  method public char GetNameProp(inKey as int):
    return GetNameProp(string (inKey)).
  end method. 
 
  method private char GetNameProp(inKeyStr as char):
    def var prop as class propmap no-undo.
    if valid-object (MarkMap:GetItemKeyStr(inKeyStr))
      then return cast (MarkMap:SubjectObjCurr, ibs.th.gbl.propmap):NameProp. 
      else return ?.
  end method. 

  method public char GetKeystrDB(inKeyint as integer ):
    def var prop as class propmap no-undo.
    if valid-object (MarkMap:GetItemKeyInt(inKeyint))
      then return cast (MarkMap:SubjectObjCurr, ibs.th.gbl.propmap):KeycharDB. 
      else return ?.
  end method. 
  
  method public int GetKeyIntDB(inKeyStr as char):
    def var prop as class propmap no-undo.
    if valid-object (MarkMap:GetItemKeyStr(inKeyStr))
      then return cast (MarkMap:SubjectObjCurr, ibs.th.gbl.propmap):KeyIntDB. 
      else return ?.
  end method. 
  
  method class propmap GetProp(inKey as int):
    def var prop as class propmap no-undo.
    if valid-object (MarkMap:GetItemKeyInt(inKey))
      then return cast(MarkMap:SubjectObjCurr, propmap). 
      else return UnknowSts.
  end method. 

  method private class propmap GetProp(inKeyStr as char):
    def var prop as class propmap no-undo.
    if valid-object (MarkMap:GetItemKeyStr(inKeyStr))
      then return cast(MarkMap:SubjectObjCurr, propmap). 
      else return UnknowSts.
  end method.
  
  method private class propmap crProp(inKeyInt as int, inNameProp as char, inLabel as char):
    def var prop as class propmap no-undo.
    {utl\objreg.i prop propmap string(inKeyInt) inLabel}
    prop:KeyIntDB = inKeyInt.
    prop:KeyCharDB = inNameProp.
    MarkMap:AddItem(prop, inKeyInt,inNameProp).
    return prop.
    
  end method. 

  

end class.