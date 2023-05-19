 
/*------------------------------------------------------------------------
   File        : cash-section
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : Shklyar
   Created     : Sat Jan 28 03:55:45 MSK 2023
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.gbl.propmap.
using ibs.th.gbl.TypeMap.

/*block-level on error undo, throw.*/

class ibs.th.str.cash.CashSection inherits TypeMap:
   
  define public property Param_          as class propmap no-undo get. 
    protected set.
  define public property KeyBoard            as class propmap no-undo get. 
    protected set.
   
  constructor public CashSection ():
    super(). 
    crProp(1,  "Param_",               "Параметры").
    crProp(2,  "KeyBoard",               "Клавиатура").
  end.
end class.