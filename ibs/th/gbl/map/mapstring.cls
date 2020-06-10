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
    
  define property IsDelChildObj as logical init true no-undo
    get.
    set.    
  
  define private temp-table ttListObj no-undo
    field iNum as integer
    field keyStr as character
    field keyInt as integer 
    field SubObj as class Progress.Lang.Object
    index pi is primary unique iNum 
    index keyStr is unique keyStr
    index keyInt is unique keyInt
    index obj is unique SubObj.
    
  
  /*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    
  constructor public mapstring ( isDelChild as log ):
    
    IsDelChildObj = isDelChild.
    
  end constructor.
  
  method public void AddItem (subObj as Progress.Lang.Object, keyStr as character):
 
    assign 
      iCounter = iCounter + 1.
    create ttListObj.
    assign
      ttListObj.iNum = iCounter
      ttListObj.SubObj = subObj
      ttListObj.keyStr = keyStr
      ttListObj.keyInt = iCounter
    no-error.
    if error-status:error
    then do:
      /*ругаться*/
    end.
    SubjectObjCurr = subObj.
    
  end.

  method public void AddItem (subObj as Progress.Lang.Object, keyInt as Int, keyStr as character):
 
    assign 
      iCounter = iCounter + 1.
    create ttListObj.
    assign
      ttListObj.iNum = iCounter
      ttListObj.SubObj = subObj
      ttListObj.keyStr = keyStr
      ttListObj.keyInt = keyInt
    no-error.
    if error-status:error
    then do:
      /*ругаться*/
    end.
    SubjectObjCurr = subObj.
    
  end. 

  method public void DeleteItem (iNum as int):
    
    find first ttListObj where ttListObj.iNum = iNum.
    delete ttListObj.
    for each ttListObj where ttListObj.iNum > iNum use-index pi :
      assign
        ttListObj.iNum = ttListObj.iNum - 1.
    end.
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

  method public integer GetItem (iNum as int):
    for first ttListObj where ttListObj.iNum = iNum:
      SubjectObjCurr = ttListObj.SubObj.
    end.
    return iCounter.
  end.

  method public class Progress.Lang.Object GetItemKeyStr (keyStr as character):
    SubjectObjCurr = ?.
    for first ttListObj where ttListObj.keyStr = keyStr:
      SubjectObjCurr = ttListObj.SubObj.
    end.
    return SubjectObjCurr.
  end.

  method public class Progress.Lang.Object GetItemKeyInt (keyInt as Integer):
    SubjectObjCurr = ?.
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