 
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


class ibs.th.str.utd.sts.direction inherits objth:
  

  define public property Inbound as class propmap no-undo get. 
    protected set.
  define public property Outbound as class propmap no-undo get. 
    protected set.
  define public property Internal as class propmap no-undo get. 
    protected set.
    
  define public property DirectionMap as class mapstring no-undo get. 
    protected set.
    
  define public property CurrDirectionMapProp as class propmap no-undo 
  get:
    def var currP as class propmap no-undo. 
    currP = cast (DirectionMap:SubjectObjCurr, propmap) no-error.
    if currP = ? or error-status:error
    then do:
      "Залогируем".
      return ?.
    end.
    else return currP.
  end. 
 
  constructor public direction ():
    {utl\objreg.i DirectionMap mapstring true}
  
    Inbound  = crProp("Inbound", "входящий документ").
    Outbound = crProp("Outbound", "исходящий документ").
    Internal = crProp("Internal", "внутренний документ").
    
  end.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public char GetLabel(inKeyStr as char):
    def var prop as class propmap no-undo.    
    if valid-object (DirectionMap:GetItemKeyStr(inKeyStr))
      then return cast (DirectionMap:SubjectObjCurr, ibs.th.gbl.propmap):Label_. 
      else return inKeyStr. /* для неизвестного типа статуса в лейбл возвращается значения ключа (грубо говоря того, что лежит в базе*/
  end method. 
 
  method public char GetNameProp(inKeyStr as char):
    def var prop as class propmap no-undo.
    if valid-object (DirectionMap:GetItemKeyStr(inKeyStr))
      then return cast (DirectionMap:SubjectObjCurr, ibs.th.gbl.propmap):NameProp. 
      else return ?.
  end method. 

  method public class propmap GetProp(inKeyStr as char):
    def var prop as class propmap no-undo.
    if valid-object (DirectionMap:GetItemKeyStr(inKeyStr))
      then return cast(DirectionMap:SubjectObjCurr, ibs.th.gbl.propmap). 
      else return ?.
  end method.
  
  method private class propmap crProp(inNameProp as char, inLabel as char):
    def var prop as class propmap no-undo.
    {utl\objreg.i prop propmap inNameProp inLabel}
    prop:KeyCharDB = inNameProp.
    DirectionMap:AddItem(prop, inNameProp).
    return prop.
  end method. 

end class.
