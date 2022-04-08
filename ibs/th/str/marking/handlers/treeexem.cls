 
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

class ibs.th.str.marking.handlers.treeexem inherits objth: 


  method public logical LevelDownUTD(mark as char, doc-id as integer, db-num as integer):
    define buffer buf_utd-marking-lines for ub.utd-marking-lines . 
    define buffer buf_marking           for ub.marking .
    define variable vflag as logical no-undo.
    find first buf_marking no-lock where buf_marking.mark-parent = mark no-error . 
    if available (buf_marking) then do:
      if can-find(first buf_utd-marking-lines no-lock where buf_utd-marking-lines.db-num = db-num and buf_utd-marking-lines.doc-id = doc-id
        and buf_utd-marking-lines.mark = buf_marking.mark )
      then vflag = yes .
      else vflag = no .      
    end.  
    else vflag = no .
    release buf_marking.
    return vflag.
  end method. 

  method public logical LevelDownDoc(mark as char, obj-code as integer, obj-type as character, in-code as character, out-code as character):
    define buffer buf_marking-lines for ub.marking-lines .
    define buffer buf_marking           for ub.marking .

    find first buf_marking no-lock where buf_marking.mark-parent = mark no-error .
    if available (buf_marking) then do:
      if can-find(first buf_marking-lines no-lock where buf_marking-lines.obj-code = obj-code and buf_marking-lines.obj-type = obj-type
        and buf_marking-lines.mark = buf_marking.mark and buf_marking-lines.in-code = in-code and buf_marking-lines.out-code = out-code)
      then return yes .
      else return no .      
    end.  
    else return no .  
      
  end method. 
  
  method public logical LevelUpUTD(mark as char, doc-id as integer, db-num as integer):
    define buffer buf_utd-marking-lines for ub.utd-marking-lines .
    define buffer buf_marking           for ub.marking .

    find first buf_marking no-lock where buf_marking.mark = mark no-error .
    if available (buf_marking) then do:
      if can-find(first buf_utd-marking-lines no-lock where buf_utd-marking-lines.db-num = db-num and buf_utd-marking-lines.doc-id = doc-id
        and buf_utd-marking-lines.mark = buf_marking.mark-parent)
      then return yes .
      else return no .      
    end.  
    else return no .  
      
  end method. 

  method public integer StatusDownUTD(mark as char, doc-id as integer, db-num as integer, sts as integer):
    do trans:
    define buffer buf_utd-marking-lines for ub.utd-marking-lines .
    define buffer buf_marking           for ub.marking .
    define variable qnty-check  as integer no-undo .
    
    for each buf_marking no-lock where buf_marking.mark-parent = mark :
      for each buf_utd-marking-lines exclusive-lock where buf_utd-marking-lines.db-num = db-num and buf_utd-marking-lines.doc-id = doc-id
        and buf_utd-marking-lines.mark = buf_marking.mark:
          buf_utd-marking-lines.sts = sts .
          qnty-check = qnty-check + 1 .
          if LevelDownUTD(buf_utd-marking-lines.mark, buf_utd-marking-lines.doc-id, buf_utd-marking-lines.db-num) then do:
            qnty-check = qnty-check + StatusDownUTD(buf_utd-marking-lines.mark,buf_utd-marking-lines.doc-id,buf_utd-marking-lines.db-num,buf_utd-marking-lines.sts) .
          end.
      end.
      
    end.
    end.
    return qnty-check .    
  end method. 

  method public integer StatusDownDoc(mark as char, obj-code as integer, obj-type as character, in-code as character, out-code as character, sts as integer):
    do trans:
    define buffer buf_marking-lines for ub.marking-lines .
    define buffer buf_marking           for ub.marking .
    define variable qnty-check  as integer no-undo .
    
    for each buf_marking no-lock where buf_marking.mark-parent = mark :
      for each buf_marking-lines exclusive-lock where buf_marking-lines.obj-code = obj-code and buf_marking-lines.obj-type = obj-type
        and buf_marking-lines.mark = buf_marking.mark and buf_marking-lines.in-code = in-code and buf_marking-lines.out-code = out-code:
          buf_marking-lines.sts = sts .
          qnty-check = qnty-check + 1 .
          if LevelDownDoc(buf_marking-lines.mark, buf_marking-lines.obj-code, buf_marking-lines.obj-type, buf_marking-lines.in-code, buf_marking-lines.out-code) then do:
            qnty-check = qnty-check + StatusDownDoc(buf_marking-lines.mark,buf_marking-lines.obj-code,buf_marking-lines.obj-type, buf_marking-lines.in-code, buf_marking-lines.out-code, buf_marking-lines.sts) .
          end.
      end.
      
    end.  
    end.
    return qnty-check .    
  end method. 
  
  method public integer DeleteDownDoc(mark as char, obj-code as integer, obj-type as character, in-code as character, out-code as character):
    do trans:
    define buffer buf_marking-lines for ub.marking-lines .
    define buffer buf_marking           for ub.marking .
    define variable qnty-check  as integer no-undo .
    
    for each buf_marking exclusive-lock where buf_marking.mark-parent = mark :
      for each buf_marking-lines exclusive-lock where buf_marking-lines.obj-code = obj-code and buf_marking-lines.obj-type = obj-type
        and buf_marking-lines.mark = buf_marking.mark and buf_marking-lines.in-code = in-code and buf_marking-lines.out-code = out-code:
          buf_marking.sts = ObjSrv:Env:Marking:Sts:Mark:FreeZone:KeyIntDB. .

          if LevelDownDoc(buf_marking-lines.mark, buf_marking-lines.obj-code, buf_marking-lines.obj-type, buf_marking-lines.in-code, buf_marking-lines.out-code) then do:
            DeleteDownDoc(buf_marking-lines.mark,buf_marking-lines.obj-code,buf_marking-lines.obj-type, buf_marking-lines.in-code, buf_marking-lines.out-code) .
          end.
          delete buf_marking-lines .
      end.
    end.  
    end.
    return qnty-check .    
  end method. 
  
  method public logical UnGroupUTD(mark as char, doc-id as integer, db-num as integer):
    do trans:
    define buffer buf_utd-marking-lines for ub.utd-marking-lines .
    define buffer buf_marking           for ub.marking .
    define buffer bf_marking            for ub.marking .
    define buffer marking            for ub.marking .
    define variable v-is                as logical no-undo.
    
    for first marking where marking.mark = mark no-lock:
      for first buf_marking exclusive-lock where buf_marking.mark = marking.mark-parent:
/*        for each bf_marking no-lock where bf_marking.mark-parent = buf_marking.mark:*/
/*          for first buf_utd-marking-lines exclusive-lock where buf_utd-marking-lines.db-num = db-num and buf_utd-marking-lines.doc-id = doc-id*/
/*            and buf_utd-marking-lines.mark = bf_marking.mark:                                                                                 */
/*            buf_utd-marking-lines.doc-level = buf_utd-marking-lines.doc-level - 1 .                                                           */
/*          end.                                                                                                                                */
/*        end.*/
        buf_marking.sts = ObjSrv:Env:Marking:Sts:Mark:Ungrouped:KeyIntDB. .
        for first buf_utd-marking-lines exclusive-lock where buf_utd-marking-lines.db-num = db-num and buf_utd-marking-lines.doc-id = doc-id
            and buf_utd-marking-lines.mark = buf_marking.mark:
              buf_utd-marking-lines.sts = ObjSrv:Env:Marking:Sts:Mark:UnknowSts:KeyIntDB. .
/*              buf_utd-marking-lines.doc-level = 0 .*/
        end.       
        v-is = yes .
      end.
    end.
    
  end.
  release marking.
  release buf_utd-marking-lines.
  release bf_marking.
  release buf_marking.
  return v-is.
  end method.   

  method public logical UnGroupDoc(mark as char, in-code as character, out-code as character, obj-code as integer, obj-type as character):
    define buffer buf_marking-lines for ub.marking-lines .
    define buffer buf_marking           for ub.marking .
    define buffer bf_marking            for ub.marking .
    define buffer marking            for ub.marking .
    
    define variable v-log as logical no-undo.
    ff_:
    for first marking where marking.mark = mark  no-lock trans:
      for first buf_marking exclusive-lock where buf_marking.mark = marking.mark-parent:
        for each bf_marking no-lock where bf_marking.mark-parent = buf_marking.mark:
          for first buf_marking-lines exclusive-lock where buf_marking-lines.in-code = in-code and buf_marking-lines.out-code = out-code and 
          buf_marking-lines.obj-code = obj-code and buf_marking-lines.obj-type = obj-type and buf_marking-lines.mark = bf_marking.mark:
            buf_marking-lines.doc-level = buf_marking-lines.doc-level - 1 .          
          end.
        end.
        buf_marking.sts = ObjSrv:Env:Marking:Sts:Mark:Ungrouped:KeyIntDB. .
          for first buf_marking-lines exclusive-lock where buf_marking-lines.in-code = in-code and buf_marking-lines.out-code = out-code and 
          buf_marking-lines.obj-code = obj-code and buf_marking-lines.obj-type = obj-type and buf_marking-lines.mark = buf_marking.mark:
              buf_marking-lines.sts = ObjSrv:Env:Marking:Sts:Mark:Ungrouped:KeyIntDB. .
              buf_marking-lines.doc-level = 0 .
        end.
        v-log = true.
        leave ff_.
      end.
    end.
    release marking.
    release bf_marking.
    release buf_marking.
    release buf_marking-lines.
    return v-log .
  end method.   

  method public logical UnGroupMark(mark as char):
    define buffer buf_marking           for ub.marking .
    define buffer bf_marking            for ub.marking .
    find first bf_marking no-lock where bf_marking.mark = mark.
    for each buf_marking exclusive-lock where buf_marking.mark = bf_marking.mark-parent trans:
      buf_marking.sts =  ObjSrv:Env:Marking:Sts:Mark:Ungrouped:KeyIntDB.
      UnGroupMark (buf_marking.mark).
    end.
    release buf_marking.
    release bf_marking.
    return true.
  end method.   

  method public logical LevelDown(mark as char):
    do trans:
    define buffer buf_marking           for ub.marking .

    if can-find (first buf_marking no-lock where buf_marking.mark-parent = mark)
      then return true.
      else return false.  
    end.
  end method. 
  
  method public void LockInvChildeMark (mark as char, doc-code as char):
    
    define buffer buf_utd-marking-lines for ub.utd-marking-lines .
    define buffer buf_marking           for ub.marking .
    define buffer bf_marking            for ub.marking .
    
    for each buf_marking no-lock where buf_marking.mark-parent = mark trans:
      create ub.marking-attr.
      ub.marking-attr.mark = buf_marking.mark.
      ub.marking-attr.attr-code = "inv-doc".
      ub.marking-attr.attr-value = doc-code.
      LockInvChildeMark (buf_marking.mark, doc-code).
      release ub.marking-attr.
    end.

  end method.
  
  method public void LockChkChildeMark (Imark as char ):
    
    def buffer buf_marking for ub.marking.
    def buffer buf_mark for ub.marking. 
    find first buf_mark where buf_mark.mark eq Imark
    no-lock no-error.
    if available buf_mark
    then do:
      for each buf_marking exclusive-lock where buf_marking.mark-parent = buf_mark.mark trans:
         buf_marking.loc-key = buf_mark.loc-key.
         buf_marking.sts = buf_mark.sts.
         LockChkChildeMark (buf_marking.mark).   
      end.
    end.
    release buf_mark.
    
  end method.
 
end class.
