 
 /*------------------------------------------------------------------------
    File        : library
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : asmorozov
    Created     : Mon Mar 30 22:53:57 MSK 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.gbl.sys.objth.
using ibs.th.str.marking.handlers.tree.
using ibs.th.gbl.keyrec.


class ibs.th.gbl.lib inherits objth: 
  
  define variable marTree as class tree no-undo.
  
  define public property MarkingTree as class tree no-undo 
  get:
    if not valid-object (MarkingTree)
    then do:
       {utl\objreg.i marTree tree }
    end.
    return marTree .
  end.
/*  private set.*/

  define public property KeyRec as class keyrec no-undo 
  get.
  private set.
   
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  constructor public lib (  ):
    super ().
    {utl\objreg.i marTree tree}
    {utl\objreg.i KeyRec keyrec }
    
  end constructor.


end class.