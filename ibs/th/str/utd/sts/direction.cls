 
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
using ibs.th.gbl.TypeMap.
using ibs.th.gbl.propmap.
using ibs.th.gbl.map.mapstring.
using ibs.th.gbl.sys.objth.


class ibs.th.str.utd.sts.direction inherits TypeMap:
  

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
      "«алогируем".
      return ?.
    end.
    else return currP.
  end. 
 
  constructor public direction ():
    {utl\objreg.i DirectionMap mapstring true}
  
    Inbound  = crProp("Inbound", "вход€щий документ").
    Outbound = crProp("Outbound", "исход€щий документ").
    Internal = crProp("Internal", "внутренний документ").
    
  end.

  

end class.
