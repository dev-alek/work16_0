 
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
using ibs.th.str.marking.handlers.tree.
using ibs.th.gbl.keyrec.


class ibs.th.gbl.lib: 
  
  
  
  define public property MarkingTree as class tree no-undo 
  get.
  private set. 

  define public property KeyRec as class keyrec no-undo 
  get.
  private set.
   
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  constructor public lib (  ):
    super ().
    MarkingTree = new tree ().
    KeyRec = new keyrec ().
    
  end constructor.


end class.