 
 /*------------------------------------------------------------------------
    File        : CashParamControl
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Daru
    Created     : Sun Mar 12 22:28:18 MSK 2023
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.*.
using ibs.th.gbl.*.
block-level on error undo, throw.

class ibs.th.bge.1crn.subjects.CashParamControl inherits ibs.th.gbl.sys.objth implements iexpsubject: 
   {cmp/str-glbl.i class}
   &scop tag-interface 'Control-etalon-params':U
   define property InitSecTag as character no-undo init {&tag-interface}
   get.
    

   define property Msg as character no-undo
   get:
      return trim (Msg, {&new-line}).
   end.
   private set (inArg as char):
      Msg = Msg + {&new-line} + inArg.
   end.
    

   method public void CrContentToSW( input insw as handle ):
      define buffer code for ub.code.
      for each code where code.code begins "cash-param"
                      and num-entries (code.parent,{&delim-par}) eq 4
      no-lock:
         insw:start-element ("Control-etalon-param").
         insw:write-data-element (  "sign":U,          string(int(entry(2,Code.parent)) + 1)).
         insw:write-data-element (  "source":U,                   entry(3,Code.parent)      ).
         insw:write-data-element (  "section":U,                  entry(4,Code.parent)      ).
         insw:write-data-element (  "name":U,                     Code.code                 ).
         insw:write-data-element (  "value-etalon":U,             Code.CodeValue            ).
         insw:write-data-element (  "required":U,                 string(Code.status_)      ).
         insw:write-data-element (  "description":U,              Code.CodeName             ).
         insw:end-element("Control-etalon-param").
      end.
      return.

   end method.

end class.