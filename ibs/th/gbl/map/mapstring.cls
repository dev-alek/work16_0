/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

карта по строковому ключу. содержит коллекцию объектов и предоставляет объекты по строковому ключу.

Автор: Александр Морозов
Дата создания: 26/09/17
Author: Morozov Alexandr
Creation date: 26/09/17

*/

using Progress.Lang.*.
using ibs.th.gbl.collection.*.
using ibs.th.gbl.sys.objth.


class ibs.th.gbl.map.mapstring inherits ibs.th.gbl.sys.objth:
  
  define property iCounter as integer no-undo
    get.
    private set.

  define property SubjectObjCurr as class Progress.Lang.Object no-undo
    get.
    set.
  
  define property UncnowObj as class Progress.Lang.Object no-undo
    get.
    private set.
  
  define property IsDelChildObj as logical init true no-undo
    get.
    set.    
  
  define property isSort as logical init false no-undo
    get.
    private set.    
  
  define private temp-table ttListObj no-undo
    field iNum as integer
    field keyStr as character
    field ByKeyStr as int
    field keyInt as integer
    field ByKeyInt as integer 
    field LabStr as character
    field ByLabStr as int
    field SubObj as class Progress.Lang.Object
    index pi is primary unique iNum 
    index keyStr is unique keyStr
    index keyInt is unique keyInt
    index ByKeyStr ByKeyStr
    index ByKeyInt ByKeyInt
    index obj is unique SubObj.
    
  
  /*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  
  constructor public mapstring ( isDelChild as log ):
    
    IsDelChildObj = isDelChild.
    
  end constructor.
  
    
  constructor public mapstring ( isDelChild as log, iobj as Progress.Lang.Object ):
    
    IsDelChildObj = isDelChild.
    UncnowObj = iobj.
    
  end constructor.
  
  method public void AddItem (subObj as Progress.Lang.Object, keyStr as character):
     AddItem (subObj, ?, keyStr).
  end.
  
  method public void AddItem (subObj as Progress.Lang.Object, keyInt as integer , keyStr as character):
     AddItem (subObj, keyInt, keyStr, ? ).
  end.
  
  method public void AddItem (subObj as Progress.Lang.Object, keyInt as integer, keyStr as character, LabStr as character):
 
    find first ttListObj where ttListObj.SubObj = subObj
    no-error.
    if not available ttListObj
    then do:
       iCounter = iCounter + 1.
       create ttListObj.
       assign
         ttListObj.iNum = iCounter
         ttListObj.SubObj = subObj
      .
   end.
   assign
      ttListObj.keyStr = keyStr
      ttListObj.keyInt = if keyInt eq ? then iCounter         else keyInt
      ttListObj.LabStr = if LabStr eq ? then ttListObj.keyStr else LabStr
   
   no-error.
   if error-status:error
   then do:
      /*ругаться*/
   end.
   isSort = no.
   SubjectObjCurr = subObj.
    
  end. 

  method public void DeleteItem (iNum as int):
    
    find first ttListObj where ttListObj.iNum = iNum.
    delete ttListObj.
    for each ttListObj where ttListObj.iNum > iNum use-index pi :
      assign
        ttListObj.iNum = ttListObj.iNum - 1.
    end.
    isSort = no.
    iCounter = iCounter - 1.
    
  end.
  
  method public void DeleteItem (keyStr as character):
    def var iNum as integer no-undo.
    find first ttListObj where ttListObj.keyStr = keyStr.
    iNum = ttListObj.iNum.
    delete ttListObj.
    for each ttListObj where ttListObj.iNum > iNum use-index pi :
      assign
        ttListObj.iNum = ttListObj.iNum - 1.
    end.
    iCounter = iCounter - 1.
  end.
  
  method public void SortTab ():
     define variable vi as integer no-undo.
     if not isSort
     then do: 
        vi = 0.
        for each ttListObj where ttListObj.KeyInt ne ? by ttListObj.keyStr:
           vi = vi + 1.
           ttListObj.ByKeyStr = vi. 
        end.
        
        vi = 0.
        for each ttListObj where ttListObj.KeyInt ne ? by ttListObj.keyInt:
           vi = vi + 1.
           ttListObj.ByKeyInt = vi. 
        end.
        
        vi = 0.
        for each ttListObj where ttListObj.KeyInt ne ?  by ttListObj.LabStr:
           vi = vi + 1.
           ttListObj.ByLabStr = vi. 
        end.
        
        isSort = yes.
     end.
  end.

  method public integer GetItem (iNum as int):
    SubjectObjCurr = UncnowObj.
    for first ttListObj where ttListObj.iNum = iNum:
      SubjectObjCurr = ttListObj.SubObj.
    end.
    return iCounter.
  end.
  
  method public integer GetItemByInt (iNum as int):
    SortTab().
    SubjectObjCurr = UncnowObj.
    for first ttListObj where ttListObj.ByKeyInt = iNum:
      SubjectObjCurr = ttListObj.SubObj.
    end.
    return iCounter.
  end.

  method public integer GetItemByStr (iNum as int):
    SortTab().
    SubjectObjCurr = UncnowObj.
    for first ttListObj where ttListObj.ByKeyStr = iNum:
      SubjectObjCurr = ttListObj.SubObj.
    end.
    return iCounter.
  end.
  
  method public integer GetItemByLab (iNum as int):
    SortTab().
    SubjectObjCurr = UncnowObj.
    for first ttListObj where ttListObj.ByLabStr = iNum:
      SubjectObjCurr = ttListObj.SubObj.
    end.
    return iCounter.
  end.
  
  method public class Progress.Lang.Object GetItemKeyStr (keyStr as character):
    SubjectObjCurr = UncnowObj.
    for first ttListObj where ttListObj.keyStr = keyStr:
      SubjectObjCurr = ttListObj.SubObj.
    end.
    return SubjectObjCurr.
  end.

  method public class Progress.Lang.Object GetItemKeyInt (keyInt as integer):
    SubjectObjCurr = UncnowObj.
    for first ttListObj where ttListObj.keyInt = keyint:
      SubjectObjCurr = ttListObj.SubObj.
    end.
    return SubjectObjCurr.
  end.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  destructor public mapstring ( ):
    
    if IsDelChildObj 
    then 
    for each ttListObj:
      SubjectObjCurr = ttListObj.SubObj.
      delete object SubjectObjCurr no-error.
    end.
    
  end destructor.
  
end class.