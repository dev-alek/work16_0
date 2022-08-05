 
 /*------------------------------------------------------------------------
    File        : tree
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : eshklyar
    Created     : Tue Mar 24 17:14:12 MSK 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.gbl.sys.objth.

class ibs.th.str.marking.handlers.tree inherits objth: 


  method public logical LevelDownUTD(mark as char, doc-id as integer, db-num as integer):
     define variable vflag as logical no-undo.
     
     define variable mExem as class ibs.th.str.marking.handlers.treeexem no-undo.
     {utl\objreg.i mExem ibs.th.str.marking.handlers.treeexem }
     vflag = mExem:LevelDownUTD(mark , doc-id , db-num ).
     delete object mExem no-error.
     return vflag.
  end method. 

  method public logical LevelDownDoc(mark as char, obj-code as integer, obj-type as character, in-code as character, out-code as character):
     define variable vflag as logical no-undo.
     
     define variable mExem as class ibs.th.str.marking.handlers.treeexem no-undo.
     {utl\objreg.i mExem ibs.th.str.marking.handlers.treeexem }
     vflag = mExem:LevelDownDoc(mark, obj-code , obj-type , in-code , out-code).
     delete object mExem no-error.
     return vflag.  
      
  end method. 
  
  method public logical LevelUpUTD(mark as char, doc-id as integer, db-num as integer):
     define variable vflag as logical no-undo.
     
     define variable mExem as class ibs.th.str.marking.handlers.treeexem no-undo.
     {utl\objreg.i mExem ibs.th.str.marking.handlers.treeexem }
     vflag = mExem:LevelUpUTD(mark, doc-id, db-num ).
     delete object mExem no-error.
     return vflag. 
      
  end method. 

  method public logical StatusDownUTD(mark as char, doc-id as integer, db-num as integer, sts as integer):
     define variable vqnty-check as integer  no-undo.
     define variable vOk         as logical no-undo.
     define variable mExem as class ibs.th.str.marking.handlers.treeexem no-undo.
     {utl\objreg.i mExem ibs.th.str.marking.handlers.treeexem }
     vOk = mExem:StatusDownUTD(mark , doc-id , db-num , sts ).
     delete object mExem no-error.
     return vOk.   
  end method. 

  method public integer StatusDownDoc(mark as char, obj-code as integer, obj-type as character, in-code as character, out-code as character, sts as integer):
     define variable vqnty-check as integer  no-undo.
     
     define variable mExem as class ibs.th.str.marking.handlers.treeexem no-undo.
     {utl\objreg.i mExem ibs.th.str.marking.handlers.treeexem }
     vqnty-check = mExem:StatusDownDoc(mark , obj-code, obj-type, in-code, out-code, sts ).
     delete object mExem no-error.
     return vqnty-check.   
  end method. 
  
  method public integer DeleteDownDoc(mark as char, obj-code as integer, obj-type as character, in-code as character, out-code as character):
     define variable vqnty-check as integer  no-undo.
     
     define variable mExem as class ibs.th.str.marking.handlers.treeexem no-undo.
     {utl\objreg.i mExem ibs.th.str.marking.handlers.treeexem }
     vqnty-check = mExem:DeleteDownDoc(mark, obj-code , obj-type , in-code , out-code ).
     delete object mExem no-error.
     return vqnty-check.     
  end method. 
  
  method public logical UnGroupUTD(mark as char, doc-id as integer, db-num as integer):
     define variable vflag as logical no-undo.
     
     define variable mExem as class ibs.th.str.marking.handlers.treeexem no-undo.
     {utl\objreg.i mExem ibs.th.str.marking.handlers.treeexem }
     vflag = mExem:UnGroupUTD(mark , doc-id , db-num ).
     delete object mExem no-error.
     return vflag. 
  end method.   

  method public logical UnGroupDoc(mark as char, in-code as character, out-code as character, obj-code as integer, obj-type as character):
     define variable vflag as logical no-undo.
     
     define variable mExem as class ibs.th.str.marking.handlers.treeexem no-undo.
     {utl\objreg.i mExem ibs.th.str.marking.handlers.treeexem } 
     vflag = mExem:UnGroupDoc(mark , in-code , out-code , obj-code , obj-type ).
     delete object mExem no-error.
     return vflag. 
  end method.   

  method public logical UnGroupMark(mark as char):
     define variable vflag as logical no-undo.
     
     define variable mExem as class ibs.th.str.marking.handlers.treeexem no-undo.
     {utl\objreg.i mExem ibs.th.str.marking.handlers.treeexem }
     vflag = mExem:UnGroupMark(mark).
     delete object mExem no-error.
     return vflag.
  end method.   

  method public logical LevelDown(mark as char):
     define variable vflag as logical no-undo.
     
     define variable mExem as class ibs.th.str.marking.handlers.treeexem no-undo.
     {utl\objreg.i mExem ibs.th.str.marking.handlers.treeexem }
     vflag = mExem:LevelDown(mark).
     delete object mExem no-error.
     return vflag.
  end method. 
  
  method public void LockInvChildeMark (mark as char, doc-code as char):
     define variable mExem as class ibs.th.str.marking.handlers.treeexem no-undo.
     {utl\objreg.i mExem ibs.th.str.marking.handlers.treeexem }
     mExem:LockInvChildeMark (mark , doc-code ).
     delete object mExem no-error.
  end method.
 
  
  method public void LockChkChildeMark (Imark as char):
    
     define variable mExem as class ibs.th.str.marking.handlers.treeexem no-undo.
     {utl\objreg.i mExem ibs.th.str.marking.handlers.treeexem }
     mExem:LockChkChildeMark (Imark).
     delete object mExem no-error.
  end method.
  
  method public integer  GetQntySts(mark as char,  sts as integer):
     define variable vqnty-check as integer  no-undo.
     define variable mExem as class ibs.th.str.marking.handlers.treeexem no-undo.
     {utl\objreg.i mExem ibs.th.str.marking.handlers.treeexem }
     vqnty-check = mExem:GetQntySts(mark ,  sts ).
     delete object mExem no-error.
     return vqnty-check.   
  end method.
 
 method public integer  GetQntyStsUnit(db-num as integer, doc-id as integer, line-num as integer, sts as integer):
     define variable vqnty-check as integer  no-undo.
     define variable mExem as class ibs.th.str.marking.handlers.treeexem no-undo.
     {utl\objreg.i mExem ibs.th.str.marking.handlers.treeexem }
     vqnty-check = mExem:GetQntyStsUnit( db-num ,doc-id , line-num, sts ).
     delete object mExem no-error.
     return vqnty-check.   
  end method.
 
end class.
