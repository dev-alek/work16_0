 
 /*------------------------------------------------------------------------
    File        : flagsdoc
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : asmorozov
    Created     : Thu Mar 07 20:33:18 MSK 2019
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.gbl.*.
block-level on error undo, throw.


class ibs.th.skt.ControlledClients.flagsbarcode inherits flags: 
  
  
  define property isMark as logical no-undo /*Товар с обязательной маркировкой*/
    get:
      return getflag (1).
    end.
    set (arg as log):
       setFlag (1,arg).
    end.

end class.