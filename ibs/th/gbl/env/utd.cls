 
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
using ibs.th.gbl.sys.objth.
using ibs.th.str.utd.sts.
using ibs.th.str.utd.edoctype.

class ibs.th.gbl.env.utd inherits objth:
  
  define public property Sts as class sts no-undo 
    get.
    set.

  define public property EDocType as class edoctype no-undo 
    get.
    set.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  constructor public utd (  ):
    super ().
    {utl\objreg.i Sts sts }
    {utl\objreg.i EDocType edoctype }
    
  end constructor.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
/*  destructor public utd ( ):*/
/*    if valid-object (EDI)    */
/*      then delete object EDI.*/
/*    if valid-object (TH)     */
/*      then delete object TH. */
/*  end destructor.*/

end class.