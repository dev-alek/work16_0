 
 /*------------------------------------------------------------------------
    File        : edoctype
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : asmorozov
    Created     : Thu Mar 05 21:50:33 MSK 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.str.utd.edoctype.
using ibs.th.gbl.propmap.
using ibs.th.gbl.map.mapstring.


class ibs.th.str.utd.edoctype: 

  define public property  UTD  as class propmap no-undo get.  protected set.
  define public property  Introduce   as class propmap no-undo get.  protected set.
  define public property  Receipt  as class propmap no-undo get.  protected set.
  define public property  UCD  as class propmap no-undo get.  protected set.
  define public property  returns  as class propmap no-undo get.  protected set.
  define public property  AKT  as class propmap no-undo get.  protected set.
  define public property  EDoc         as class propmap no-undo get.  protected set.

  define public property EDocTypeMap as class mapstring no-undo get. 
    protected set.

  define public property CurrEDocTypeMapProp as class propmap no-undo 
  get:
    def var currP as class propmap no-undo. 
    currP = cast (EDocTypeMap:SubjectObjCurr, propmap) no-error.
    if currP = ? or error-status:error
    then do:
      "Залогируем".
      return ?.
    end.
    else return currP.
  end. 
 
  constructor public edoctype ():
    EDocTypeMap = new mapstring(true).
    UTD       = crProp(1, "UTD", "УПД").
    Introduce = crProp(2, "Introduce", "Первоначальный ввод КМ").
    Receipt   = crProp(3, "receipt", "Списание (выбытие из оборота)").
    UCD       = crProp(4, "UСD", "УКД").
    Returns   = crProp(5, "return", "Возврат поставщику").
    AKT       = crProp(6, "akt", "Акт приема").
    EDoc      = crProp(7, "EDoc", "Эл.Док").
  end.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public char GetLabel(inKey as int):
    def var prop as class propmap no-undo.    
    if valid-object (EDocTypeMap:GetItemKeyInt(inKey))
      then return cast (EDocTypeMap:SubjectObjCurr, ibs.th.gbl.propmap):Label_. 
      else return string(inKey). /* для неизвестного типа статуса в лейбл возвращается значения ключа (грубо говоря того, что лежит в базе*/
  end method. 

  method private char GetLabel(inKeyStr as char):
    def var prop as class propmap no-undo.    
    if valid-object (EDocTypeMap:GetItemKeyStr(inKeyStr))
      then return cast (EDocTypeMap:SubjectObjCurr, ibs.th.gbl.propmap):Label_. 
      else return inKeyStr. /* для неизвестного типа статуса в лейбл возвращается значения ключа (грубо говоря того, что лежит в базе*/
  end method. 

  method public char GetNameProp(inKey as int):
    return GetNameProp(string (inKey)).
  end method. 
 
  method private char GetNameProp(inKeyStr as char):
    def var prop as class propmap no-undo.
    if valid-object (EDocTypeMap:GetItemKeyStr(inKeyStr))
      then return cast (EDocTypeMap:SubjectObjCurr, ibs.th.gbl.propmap):NameProp. 
      else return ?.
  end method. 

  method public int GetKeyIntDB(inKeyStr as char):
    def var prop as class propmap no-undo.
    if valid-object (EDocTypeMap:GetItemKeyStr(inKeyStr))
      then return cast (EDocTypeMap:SubjectObjCurr, ibs.th.gbl.propmap):KeyIntDB. 
      else return ?.
  end method. 
  
  method class propmap GetProp(inKey as int):
    return GetProp(string (inKey)).
  end method. 

  method public char GetKeyStrDB(inKeyint as int):
    def var prop as class propmap no-undo.
    if valid-object (EDocTypeMap:GetItemKeyInt(inKeyint))
      then return cast (EDocTypeMap:SubjectObjCurr, ibs.th.gbl.propmap):KeycharDB. 
      else return ?.
  end method. 
  

  method private class propmap GetProp(inKeyStr as char):
    def var prop as class propmap no-undo.
    if valid-object (EDocTypeMap:GetItemKeyStr(inKeyStr))
      then return cast(EDocTypeMap:SubjectObjCurr, propmap). 
      else return ?.
  end method.
  
  method private class propmap crProp(inKeyInt as int, inNameProp as char, inLabel as char):
    def var prop as class propmap no-undo.
    prop = new propmap (string(inKeyInt), inLabel).
    prop:KeyIntDB = inKeyInt.
    prop:KeyCharDB = inNameProp.
    EDocTypeMap:AddItem(prop,  inKeyInt,inNameProp).
    return prop.
    
  end method. 

end class.