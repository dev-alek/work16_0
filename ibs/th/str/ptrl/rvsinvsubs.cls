 
 /*------------------------------------------------------------------------
    File        : rvsinvsubs
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : asmorozov
    Created     : Tue Oct 16 23:46:14 MSK 2018
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.gbl.collection.asubjects.
using ibs.th.str.ptrl.*.
using ibs.th.gbl.storage.*.


class ibs.th.str.ptrl.rvsinvsubs inherits asubjects: 

  define property RvsInvSubCurr as class rvsinvsub
    get:
      return cast (SubjectObjCurr, rvsinvsub).
    end.
  
  define property RvsCode as character no-undo
    get.
    set.
    
  define property ObjType as character no-undo
    get.
    set.
    
  define property ObjCode as integer no-undo
    get.
    set.
  
  define property MeteringErrSum as decimal no-undo
    get.
    set.

  define property NormalWastageSum as decimal no-undo
    get.
    set.

  define property TPNormalAutoSum as decimal no-undo
    get.
    set.
    
  define property TPNormalPlSum as decimal no-undo
    get.
    set.

  define property TPNormalSum as decimal no-undo
    get:
      return TPNormalAutoSum + TPNormalPlSum. 
    end.

  define property DiffSum as decimal no-undo
    get.
    set.

  define property RvsInvStrObj as class rvsinvstr no-undo
    get:
      if not valid-object ( RvsInvStrObj )
        then return new rvsinvstr ().
        else return RvsInvStrObj.
    end.
    set.
  
  method public void CalcSum ():
    
    RvsInvStrObj:CalcSum(this-object).

  end method.


end class.