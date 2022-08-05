 
 /*------------------------------------------------------------------------
    File        : markingtype
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : asmorozov
    Created     : Mon Mar 30 14:11:07 MSK 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.gbl.sys.objth.

class ibs.th.gbl.env.conf.markingtype inherits objth. 

  
  define public property ConfVal as character initial "" no-undo 
    get.
    private set.

  constructor public markingtype ( conf_val as char ):
    super().
    ConfVal = conf_val.
  end constructor.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public logical GetValForType(arg as char):

    if     arg     ne ? and arg     ne ""
       and ConfVal ne ? and ConfVal ne ""
       and lookup (arg, ConfVal) > 0
      then return true.
      else return false.

  end method.  
  
  
  
end class.