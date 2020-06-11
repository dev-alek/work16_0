 
/*------------------------------------------------------------------------
   File        : output
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : asmorozov
   Created     : Thu Feb 20 04:46:52 MSK 2020
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.


class ibs.th.gbl.logger.putout:
  
  define stream out.
  define private variable fileName_ as character no-undo.

  /*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    
  constructor public putout (inFileName as char ):
    super ().
    fileName_ = inFileName.
    
  end constructor.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public void PutMessage( inMsg as character ):
    
    output stream out to value(fileName_) append.    
    put stream out unformatted (string(now) + ": " + inMsg) skip.
    output stream out close.

  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  destructor public putout ( ):
    output stream out close.
  end destructor.
  
  

end class.