 
/*------------------------------------------------------------------------
  File    : th
  Purpose   : 
  Syntax   : 
  Description : 
  Author(s)  : asmorozov
  Created   : Wed Feb 19 17:57:46 MSK 2020
  Notes    : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.gbl.propmap.
using ibs.th.gbl.map.mapstring.
using ibs.th.gbl.sys.objth.
using ibs.th.gbl.sys.objsrv.


class ibs.th.str.utd.sts.th inherits objth:
  
  define public property  NewStatus  as class propmap no-undo get.  protected set.
  define public property  ReceivedFromSupplier  as class propmap no-undo get.  protected set.
  define public property  VerificationPassed  as class propmap no-undo get.  protected set.
  define public property  RequiresAdjustment  as class propmap no-undo get.  protected set.
  define public property  AwaitingDelivery  as class propmap no-undo get.  protected set.
  define public property  SignatureRequired as class propmap no-undo get.  protected set.
  define public property  AwaitingConfirmation  as class propmap no-undo get.  protected set.
  define public property  CorrectionRequested as class propmap no-undo get.  protected set.
  define public property  Confirmed as class propmap no-undo get.  protected set.
  define public property  CancellationRequest as class propmap no-undo get.  protected set.
  define public property  Canceled as class propmap no-undo get.  protected set.

  define public property  LackOfMarkingCodesInCirculation as class propmap no-undo get.  protected set.
  define public property  DeliveryCodeMismatch as class propmap no-undo get.  protected set.
  define public property  InconsistencyWithSupplyContract as class propmap no-undo get.  protected set.
  define public property  LoadError as class propmap no-undo get.  protected set.
  define public property  edocError as class propmap no-undo get.  protected set.
  define public property  RejectionUtd as class propmap no-undo get.  protected set.
  define public property  ConfirmedUcd as class propmap no-undo get.  protected set.
  define public property  Rejection as class propmap no-undo get. 
    protected set.    

  define public property THMap as class mapstring no-undo get. 
    protected set.

  define public property CurrTHMapProp as class propmap no-undo 
  get:
    def var currP as class propmap no-undo. 
    currP = cast (THMap:SubjectObjCurr, propmap) no-error.
    if currP = ? or error-status:error
    then do:
      "Залогируем".
      return ?.
    end.
    else return currP.
  end. 
 
  constructor public th ():
    THMap = new mapstring(true).
    NewStatus            = crProp(0, "NewStatus", "Новый").
    ReceivedFromSupplier = crProp(1, "ReceivedFromSupplier", "Получен от поставщика").
    VerificationPassed   = crProp(2, "VerificationPassed", "Пройдена проверка МОТП").
    RequiresAdjustment   = crProp(3, "RequiresAdjustment", "Требует корректировки").  /* Это групповой статус для ошибок. в УПД ставить детализированный. см. ниже */
    AwaitingDelivery     = crProp(4, "AwaitingDelivery", "Ожидает поставку").
    SignatureRequired    = crProp(5, "SignatureRequired", "Требует подписания").
    AwaitingConfirmation = crProp(6, "AwaitingConfirmation", "Ожидает подтверждения МОТП").
    CorrectionRequested  = crProp(7, "CorrectionRequested", "Запрошена корректировка").
    Confirmed            = crProp(8, "Confirmed", "Подтвержден").
    CancellationRequest  = crProp(9, "CancellationRequest", "Запрос аннуляции").
    Canceled             = crProp(10, "Canceled", "Аннулирован").
    Rejection            = crProp(11, "Rejection", "Отказ").
    LackOfMarkingCodesInCirculation = crProp(31, "LackOfMarkingCodesInCirculation", "Отсутствие КМ в обороте").
    DeliveryCodeMismatch = crProp(32, "DeliveryCodeMismatch", "Частичная приемка").
    InconsistencyWithSupplyContract = crProp(33, "InconsistencyWithTheSupplyContract", "Несоответсвие договору поставки ").
    LoadError            = crProp(34, "LoadError", "Ошибка загрузки ").
    edocError            = crProp(35, "edocError", "Ошибка").
    RejectionUtd         = crProp(36, "RejectionUtd", "Отказать").
    ConfirmedUcd         = crProp(37, "ConfirmedUcd", "Подтвердить").
    
    
  end.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public char GetLabel(inKey as int):
    def var prop as class propmap no-undo.    
    if valid-object (THMap:GetItemKeyInt(inKey))
      then return cast (THMap:SubjectObjCurr, ibs.th.gbl.propmap):Label_. 
      else return string(inKey). /* для неизвестного типа статуса в лейбл возвращается значения ключа (грубо говоря того, что лежит в базе*/
  end method. 

  method private char GetLabel(inKeyStr as char):
    def var prop as class propmap no-undo.    
    if valid-object (THMap:GetItemKeyStr(inKeyStr))
      then return cast (THMap:SubjectObjCurr, ibs.th.gbl.propmap):Label_. 
      else return inKeyStr. /* для неизвестного типа статуса в лейбл возвращается значения ключа (грубо говоря того, что лежит в базе*/
  end method. 

  method public char GetNameProp(inKey as int):
    return GetNameProp(string (inKey)).
  end method. 
 
  method private char GetNameProp(inKeyStr as char):
    def var prop as class propmap no-undo.
    if valid-object (THMap:GetItemKeyStr(inKeyStr))
      then return cast (THMap:SubjectObjCurr, ibs.th.gbl.propmap):NameProp. 
      else return ?.
  end method. 

  method public int GetKeyIntDB(inKeyStr as char):
    def var prop as class propmap no-undo.
    if valid-object (THMap:GetItemKeyStr(inKeyStr))
      then return cast (THMap:SubjectObjCurr, ibs.th.gbl.propmap):KeyIntDB. 
      else return ?.
  end method. 
  
  method class propmap GetProp(inKey as int):
    return GetProp(string (inKey)).
  end method. 

  method private class propmap GetProp(inKeyStr as char):
    def var prop as class propmap no-undo.
    if valid-object (THMap:GetItemKeyStr(inKeyStr))
      then return cast(THMap:SubjectObjCurr, propmap). 
      else return ?.
  end method.
  
  method public char GetKeyStrDB(inKeyint as int):
    def var prop as class propmap no-undo.
    if valid-object (THMap:GetItemKeyint(inKeyint))
      then return cast (THMap:SubjectObjCurr, ibs.th.gbl.propmap):KeycharDB. 
      else return ?.
  end method. 
   
  method private class propmap crProp(inKeyInt as int, inNameProp as char, inLabel as char):
    def var prop as class propmap no-undo.
    prop = new propmap (string(inKeyInt), inLabel).
    prop:KeyIntDB = inKeyInt.
    prop:KeyCharDB = inNameProp.
    THMap:AddItem(prop, inKeyInt,inNameProp).
    return prop.
    
  end method.
  
  method public logical CheckStsErr(inKey as int):
    
    if RequiresAdjustment:KeyIntDB = inKey 
      or LackOfMarkingCodesInCirculation:KeyIntDB = inKey 
      or DeliveryCodeMismatch:KeyIntDB = inKey 
      or InconsistencyWithSupplyContract:KeyIntDB = inKey
      or LoadError:KeyIntDB = inKey
      then return true.
      else return false.

  end method.

end class.
