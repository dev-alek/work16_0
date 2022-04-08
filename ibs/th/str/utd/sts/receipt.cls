 
/*------------------------------------------------------------------------
  File    : edi
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


class ibs.th.str.utd.sts.receipt inherits objth:
  
  define public property GeneralReceiptStsNotAcceptable as class propmap no-undo get. 
    protected set.
  define public property HaveToCreateReceipt as class propmap no-undo get. 
    protected set.
  define public property WaitingForReceipt  as class propmap no-undo get. 
    protected set.
  define public property Finished  as class propmap no-undo get. 
    protected set.
    
  define public property ReceiptMap as class mapstring no-undo get. 
    protected set.
    
  define public property CurrReceiptMapProp as class propmap no-undo 
  get:
    def var currP as class propmap no-undo. 
    currP = cast (ReceiptMap:SubjectObjCurr, propmap) no-error.
    if currP = ? or error-status:error
    then do:
      "Залогируем".
      return ?.
    end.
    else return currP.
  end. 
 
  constructor public receipt ():
    {utl\objreg.i ReceiptMap mapstring true}  
    GeneralReceiptStsNotAcceptable  = crProp("GeneralReceiptStsNotAcceptable", "ИОП на документ не запрошен").
    HaveToCreateReceipt  = crProp("HaveToCreateReceipt", "нужно подписать ИОП на документ").
    WaitingForReceipt  = crProp("WaitingForReceipt", "ожидание подписания ИОПа на документ").
    Finished  = crProp("Finished", "ИОП подписано. Действий не требуется").
    
  end.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public char GetLabel(inKeyStr as char):
    def var prop as class propmap no-undo.    
    if valid-object (ReceiptMap:GetItemKeyStr(inKeyStr))
      then return cast (ReceiptMap:SubjectObjCurr, ibs.th.gbl.propmap):Label_. 
      else return inKeyStr. /* для неизвестного типа статуса в лейбл возвращается значения ключа (грубо говоря того, что лежит в базе*/
  end method. 
 
  method public char GetNameProp(inKeyStr as char):
    def var prop as class propmap no-undo.
    if valid-object (ReceiptMap:GetItemKeyStr(inKeyStr))
      then return cast (ReceiptMap:SubjectObjCurr, ibs.th.gbl.propmap):NameProp. 
      else return ?.
  end method. 

  method public class propmap GetProp(inKeyStr as char):
    def var prop as class propmap no-undo.
    if valid-object (ReceiptMap:GetItemKeyStr(inKeyStr))
      then return cast(ReceiptMap:SubjectObjCurr, ibs.th.gbl.propmap). 
      else return ?.
  end method.
  
  method private class propmap crProp(inNameProp as char, inLabel as char):
    def var prop as class propmap no-undo.
    {utl\objreg.i prop propmap inNameProp inLabel}
    prop:KeyCharDB = inNameProp.
    ReceiptMap:AddItem(prop, inNameProp).
    return prop.
  end method. 

end class.
