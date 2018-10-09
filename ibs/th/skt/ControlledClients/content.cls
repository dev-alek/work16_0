 
 /*------------------------------------------------------------------------
    File        : content
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : asmorozov
    Created     : Mon Jul 23 22:50:13 MSK 2018
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.


class ibs.th.skt.ControlledClients.content: 


  define property content-type as character no-undo
    get.
    set.
  
  define property user-agent as character no-undo
    get.
    set.

  define property ContentLong as longchar no-undo
    get:
      
    end.
    
  
  define property ContentBuff as memptr no-undo
    get.
    set.


end class.