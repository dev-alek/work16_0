 
 /*------------------------------------------------------------------------
    File        : sts
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : asmorozov
    Created     : Thu Mar 05 22:12:46 MSK 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.str.marking.sts.mark.


class ibs.th.str.marking.sts: 

  define public property Mark as class mark no-undo 
    get.
    protected set.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  constructor public sts (  ):
    super ().
    Mark = new mark().
    
  end constructor.

end class.