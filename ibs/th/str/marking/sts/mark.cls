 
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
using ibs.th.gbl.TypeMap.


class ibs.th.str.marking.sts.mark inherits TypeMap:
  
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
 
  constructor public mark ():
    super().
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



end class.