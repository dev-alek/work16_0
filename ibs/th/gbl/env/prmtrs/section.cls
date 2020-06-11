 
 /*------------------------------------------------------------------------
    File        : section
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : asmorozov
    Created     : Tue Apr 07 21:34:55 MSK 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.gbl.env.prmtrs.edo.
using ibs.th.gbl.sys.objth.


class ibs.th.gbl.env.prmtrs.section inherits objth:
  
  define public variable edo as class edo no-undo.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public class edo GetSectionEDO(pObjType as char, pObjCode as int):
    def var vMarkingType as character no-undo.
    def var vIsEDO as logical no-undo.
    def var vIsManual as logical no-undo.
    if valid-object (edo) and edo:ObjType = pObjType and edo:ObjCode = pObjCode
    then do:
      return edo.
    end.
    delete object edo no-error.
    edo = new edo(pObjType, pObjCode).    
    return edo.
  end method.
  
  method public void ResetEdo ():
    delete object edo no-error.
  end.

end class.