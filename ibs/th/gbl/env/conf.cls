 
/*------------------------------------------------------------------------
   File        : confrd
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : asmorozov
   Created     : Mon Mar 30 13:19:46 MSK 2020
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.gbl.env.conf.markingtype.
using ibs.th.gbl.sys.objth.

class ibs.th.gbl.env.conf inherits objth:
  
  define public property IsMarking as class markingtype no-undo 
    get.
    private set.

  /*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    
  constructor public conf (  ):
    
    define variable v-par-val  as character no-undo .
    define variable v-par-type as character no-undo .
    
    run gbl/conf-rd.p ("is-mark":U, "":U, "":U, 0, "":U, "":U, "":U, no, output v-par-val, output v-par-type) no-error.
    IsMarking = new markingtype(v-par-val).    
    
  end constructor.

end class.