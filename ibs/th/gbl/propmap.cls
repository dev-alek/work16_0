 
/*------------------------------------------------------------------------
   File        : prop
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : asmorozov
   Created     : Tue Feb 18 18:54:25 MSK 2020
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.gbl.propmap.
using ibs.th.gbl.sys.objth.
using ibs.th.gbl.map.mapstring.


class ibs.th.gbl.propmap inherits objth: 
  
  define public property Label_ as character no-undo 
    get.
    set. 

  define public property NameProp as character no-undo 
    get.
    set. 

  
  define public property KeyIntDB as integer no-undo 
    get.
    set.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  
  constructor public propmap (inNameProp as char, inLabel as char):
    super ().
    assign
      Label_   = inLabel
      NameProp = inNameProp
      .
  end constructor.
 
  constructor public propmap (iKeyIntDB as integer, inNameProp as char, inLabel as char):
    super ().
    assign
      Label_   = inLabel
      NameProp = inNameProp
      KeyIntDB = iKeyIntDB
      .
  end constructor.
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  destructor public propmap ( ):
	  
  end destructor.

  


end class.