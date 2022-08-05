 
 /*------------------------------------------------------------------------
    File        : marking
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : asmorozov
    Created     : Tue Feb 25 13:03:00 MSK 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.gbl.sys.objth.
using ibs.th.str.marking.sts.
using ibs.th.str.marking.types.

class ibs.th.gbl.env.marking inherits objth: 
  
  define public property Sts as class sts no-undo 
    get.
    set.
  define public property Types as class Types no-undo 
    get.
    set.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  constructor public marking (  ):
    super ().
    {utl\objreg.i Sts sts }
    {utl\objreg.i Types Types  }
  end constructor.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
/*  destructor public marking ( ):*/
/*    if valid-object (EDI)    */
/*      then delete object EDI.*/
/*    if valid-object (TH)     */
/*      then delete object TH. */
/*  end destructor.*/

end class.