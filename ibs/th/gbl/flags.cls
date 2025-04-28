 
 /*------------------------------------------------------------------------
    File        : flags
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : asmorozov
    Created     : Wed Mar 13 22:08:53 MSK 2019
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
block-level on error undo, throw.


class ibs.th.gbl.flags: 
  
  define property FlagsToInt as integer
    get.
    protected set.
  
  method public void setFlagsToInt(arg as int):
    FlagsToInt = arg.
    return.
  end method.

  method public void unSetAllFlags():
    FlagsToInt = 0.
    return.
  end method.


end class.