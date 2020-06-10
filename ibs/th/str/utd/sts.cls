 
/*------------------------------------------------------------------------
   File        : sts
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : asmorozov
   Created     : Wed Feb 19 17:58:15 MSK 2020
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.str.utd.sts.*.
using ibs.th.str.marking.sts.*.
using ibs.th.gbl.sys.objth.

class ibs.th.str.utd.sts inherits objth:
  
  
  define public property EDI as class edi no-undo 
    get.
    protected set. 

  define public property TH as class th no-undo 
    get.
    protected set.

  define public property Receipt as class receipt no-undo 
    get.
    protected set.
    
  define public property Direction as class direction no-undo 
    get.
    protected set.
    
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  constructor public sts (  ):
    super ().
    EDI = new edi().
    TH = new th().
    Receipt = new receipt().
    Direction = new direction().
  end constructor.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  destructor public sts ( ):
/*    if valid-object (EDI)    */
/*      then delete object EDI.*/
/*    if valid-object (TH)     */
/*      then delete object TH. */
  end destructor.

end class.