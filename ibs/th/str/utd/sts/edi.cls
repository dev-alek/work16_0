 
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


class ibs.th.str.utd.sts.edi inherits objth:

    define public property HaveToCreateReceipt as class propmap no-undo get. 
    protected set.
  
  
    define public property RevocationIsRequestedByMe as class propmap no-undo get. 
    protected set.
    define public property RequestsMyRevocation  as class propmap no-undo get. 
    protected set.
    define public property RevocationAccepted  as class propmap no-undo get. 
    protected set.
    define public property UnknownRevocationStatus  as class propmap no-undo get. 
    protected set.
    
    define public property RecipientResponseStatusUnknown  as class propmap no-undo get. 
    protected set.
    define public property RecipientResponseStatusNotAccep  as class propmap no-undo get. 
    protected set.
    define public property WaitingForRecipientSignature  as class propmap no-undo get. 
    protected set.
    define public property WithRecipientSignature  as class propmap no-undo get. 
    protected set.
    define public property RecipientSignatureRequestReject  as class propmap no-undo get. 
    protected set.
    define public property InvalidRecipientSignature as class propmap no-undo get. 
    protected set.
   
    define public property AutoRejected as class propmap no-undo get. 
    protected set.
    define public property SignatureAdjustment as class propmap no-undo get. 
    protected set.
    
    define public property Verification as class propmap no-undo get. 
    protected set.
    define public property Changed as class propmap no-undo get. 
    protected set.
    
    define public property sendRejected as class propmap no-undo get. 
    protected set.
    
    define public property sendRecipient  as class propmap no-undo get. 
    protected set.
    
    define public property sendRevocation as class propmap no-undo get. 
    protected set.
    
    define public property sendAdjustment as class propmap no-undo get. 
    protected set.
    
    define public property StatFinesh as integer init 300 
    get. 
    set.
     
    define public property StatChangLoanOnlyBeg as integer init 200 
    get. 
    set.
    
    define public property StatChangLoanOnlyEnd as integer init 299 
    get. 
    set.
    define public property AvailAdjustment as class propmap no-undo get. 
    protected set.
    define public property SignatureNotAccepted as class propmap no-undo get. 
    protected set.
    
    define public property SendAutoRejected as class propmap no-undo get. 
    protected set.
    
    define public property SignatureAutoRejected as class propmap no-undo get. 
    protected set.
    
    
                        
  define public property EDIMap as class mapstring no-undo get. 
    protected set.
    
  define public property CurrEDIMapProp as class propmap no-undo 
  get:
    def var currP as class propmap no-undo. 
    currP = cast (EDIMap:SubjectObjCurr, propmap) no-error.
    if currP = ? or error-status:error
    then do:
      "Залогируем".
      return ?.
    end.
    else return currP.
  end. 
 
  constructor public edi ():
    EDIMap = new mapstring(true).
    HaveToCreateReceipt = crProp(11,"HaveToCreateReceipt","Подписать ИОП").

    RequestsMyRevocation      = crProp(32,"RequestsMyRevocation","Подписать аннуляцию").
    RevocationIsRequestedByMe = crProp(131,"RevocationIsRequestedByMe","Запрошена аннуляция").
    UnknownRevocationStatus   = crProp(134,"UnknownRevocationStatus","Неизвестный анул.").
    RevocationAccepted	      = crProp(333,"RevocationAccepted","Аннулирован").
    
    WaitingForRecipientSignature         = crProp(53,"WaitingForRecipientSignature","Подписать").
    RecipientResponseStatusUnknown       = crProp(151,"RecipientResponseStatusUnknown","Неизвестный").
    InvalidRecipientSignature            = crProp(156,"InvalidRecipientSignature","Ош. подписи").
    RecipientResponseStatusNotAccep      = crProp(352,"RecipientResponseStatusNotAcceptable","Не требуется").
    WithRecipientSignature               = crProp(354,"WithRecipientSignature","Подписан").
    RecipientSignatureRequestReject      = crProp(355,"RecipientSignatureRequestRejected","Отказ").
    
    
    
    AutoRejected                         = crProp(71,"AutoRejected","Подписать отказ").
    SignatureAdjustment                  = crProp(72,"SignatureAdjustment","Подписать корректировку").
    SignatureNotAccepted                 = crProp(73,"SignatureNotAccepted","Подписать с отказом").
    
    Verification                         = crProp(173,"Verification","Проверка").    
    sendRejected                         = crProp(274,"sendRejected","Отправлен отказ").
    sendRecipient                        = crProp(275,"sendRecipient","Отправлена подпись").
    sendRevocation                       = crProp(276,"sendRevocation","Отправлена ответ на аннуляцию").
    sendAdjustment                       = crProp(277,"sendAdjustment","Отправлена корректировка").
    sendAutoRejected                     = crProp(278,"sendAutoRejected","Отправлен отказ авт.").
    
    SignatureAutoRejected                = crProp(379,"SignatureAutoRejected","Отказ авт.").
    Changed                              = crProp(374,"Changed","Изменен").
    AvailAdjustment                      = crProp(378,"AvailAdjustment","По документу нельзя запросить корректировку").

  end.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public char GetLabel(inKey as int):
     def var prop as class propmap no-undo.    
    if valid-object (EDIMap:GetItemKeyint(inKey))
      then return cast (EDIMap:SubjectObjCurr, ibs.th.gbl.propmap):Label_. 
      else return string(inKey). /* для неизвестного типа статуса в лейбл возвращается значения ключа (грубо говоря того, что лежит в базе*/
  end method. 

  method private char GetLabel(inKeyStr as char):
    def var prop as class propmap no-undo.    
    if valid-object (EDIMap:GetItemKeyStr(inKeyStr))
      then return cast (EDIMap:SubjectObjCurr, ibs.th.gbl.propmap):Label_. 
      else return inKeyStr. /* для неизвестного типа статуса в лейбл возвращается значения ключа (грубо говоря того, что лежит в базе*/
  end method. 

  method public char GetNameProp(inKey as int):
    return GetNameProp(string (inKey)).
  end method. 
 
  method private char GetNameProp(inKeyStr as char):
    def var prop as class propmap no-undo.
    if valid-object (EDIMap:GetItemKeyStr(inKeyStr))
      then return cast (EDIMap:SubjectObjCurr, ibs.th.gbl.propmap):NameProp. 
      else return ?.
  end method. 

  method public int GetKeyIntDB(inKeyStr as char):
    def var prop as class propmap no-undo.
    if valid-object (EDIMap:GetItemKeyStr(inKeyStr))
      then return cast (EDIMap:SubjectObjCurr, ibs.th.gbl.propmap):KeyIntDB. 
      else return ?.
  end method. 

  method public char GetKeyStrDB(inKeyInt as int):
    def var prop as class propmap no-undo.
    if valid-object (EDIMap:GetItemKeyInt(inKeyInt))
      then return cast (EDIMap:SubjectObjCurr, ibs.th.gbl.propmap):KeycharDB. 
      else return ?.
  end method. 
  
  method class propmap GetProp(inKey as int):
    def var prop as class propmap no-undo.
    if valid-object (EDIMap:GetItemKeyInt(inKey))
      then return cast(EDIMap:SubjectObjCurr, propmap). 
      else return ?.
  end method. 

  method private class propmap GetProp(inKeyStr as char):
    def var prop as class propmap no-undo.
    if valid-object (EDIMap:GetItemKeyStr(inKeyStr))
      then return cast(EDIMap:SubjectObjCurr, propmap). 
      else return ?.
  end method.
  
   method private class propmap crProp(inKeyInt as int, inNameProp as char, inLabel as char):
    def var prop as class propmap no-undo.
    prop = new propmap (string(inKeyInt), inLabel).
    prop:KeyIntDB = inKeyInt.
    prop:KeyCharDB = inNameProp.
    EDIMap:AddItem(prop, inKeyInt,inNameProp).
    return prop.
    
  end method. 

end class.
