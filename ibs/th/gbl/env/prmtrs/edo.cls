 
 /*------------------------------------------------------------------------
    File        : markingtype
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : asmorozov
    Created     : Mon Mar 30 14:11:07 MSK 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.gbl.sys.objth.
using ibs.th.gbl.env.conf.markingtype.


class ibs.th.gbl.env.prmtrs.edo inherits objth. 

{ cmp/str-glbl.i class}
{ gbl/thbj-def.i }

  define public property MarkingType as character initial "" no-undo 
    get.
    private set. 

  define public property MarkingTypeobj as class markingtype no-undo 
    get.
    private set. 

  define public property MarkingTypeEDO as character initial "" no-undo 
    get.
    private set. 

  define public property MarkingTypeEDOobj as class markingtype no-undo 
    get.
    private set. 
    
    
  define public property IsMarking as logical initial false no-undo 
    get:
       return MarkingTypeobj:IsMarking.
    end.

  define public property IsEdo as logical initial false no-undo 
    get.
    private set.   
        
  define public property IsEdoNotMark as logical initial false no-undo 
    get.
    private set.
    
  define public property IsManual as logical initial false no-undo 
    get.
    private set.

  define public property IsBanRecipes as logical initial false no-undo 
    get.
    private set.
        
  define public property IsBanAltr as logical initial false no-undo 
    get.
    private set.

  define public property IsBarCode as logical initial false no-undo 
    get.
    private set.
            
  define public property ObjType as character no-undo 
    get.
    private set.

  define public property ObjCode as integer no-undo 
    get.
    private set.
      
  constructor public edo ( pObjType as char, pObjCode as int ):


    define variable v-value-character     as character     no-undo .
    define variable v-value-decimal       as decimal       no-undo .
    define variable v-value-integer       as integer       no-undo .
    define variable v-value-logical       as logical       no-undo .
    define variable v-value-type          as character     no-undo .
    define variable v-value-date          as date          no-undo .
    
    assign
      ObjType = pObjType
      ObjCode = pObjCode
    .
    run adm/shattri.p (
      input "get":U
      ,input pObjType
      ,input pObjCode
      ,input {&attr-marking}
      ,input "marking-type"
      ,output v-value-character
      ,output v-value-date
      ,output v-value-decimal
      ,output v-value-integer
      ,output v-value-logical
      ,output v-value-type
      ,input-output TABLE thbjattr_thbj-attr
      ) no-error .
    MarkingType = v-value-character.
    {utl\objreg.i MarkingTypeobj markingtype MarkingType}
    run adm/shattri.p (
      input "get":U
      ,input pObjType
      ,input pObjCode
      ,input {&attr-marking}
      ,input "marking-type-edo"
      ,output v-value-character
      ,output v-value-date
      ,output v-value-decimal
      ,output v-value-integer
      ,output v-value-logical
      ,output v-value-type
      ,input-output TABLE thbjattr_thbj-attr
      ) no-error .
    MarkingTypeEDO = v-value-character.
    {utl\objreg.i MarkingTypeEDOobj markingtype MarkingTypeEDO}
        
    run adm/shattri.p (
      input "get":U
      ,input pObjType
      ,input pObjCode
      ,input {&attr-marking}
      ,input "marking-EDO"
      ,output v-value-character
      ,output v-value-date
      ,output v-value-decimal
      ,output v-value-integer
      ,output v-value-logical
      ,output v-value-type
      ,input-output TABLE thbjattr_thbj-attr
      ) no-error .
    if v-value-logical = true
      then IsEDO = true.
      else IsEDO = false.

    run adm/shattri.p (
      input "get":U
      ,input pObjType
      ,input pObjCode
      ,input {&attr-marking}
      ,input "marking-EDO-NotMark"
      ,output v-value-character
      ,output v-value-date
      ,output v-value-decimal
      ,output v-value-integer
      ,output v-value-logical
      ,output v-value-type
      ,input-output TABLE thbjattr_thbj-attr
      ) no-error .
    if v-value-logical = true
      then IsEdonotMark = true.
      else IsEdonotMark = false.
      
    run adm/shattri.p (
      input "get":U
      ,input pObjType
      ,input pObjCode
      ,input {&attr-marking}
      ,input "marking-manual"
      ,output v-value-character
      ,output v-value-date
      ,output v-value-decimal
      ,output v-value-integer
      ,output v-value-logical
      ,output v-value-type
      ,input-output TABLE thbjattr_thbj-attr
      ) no-error .
    if v-value-logical = true
      then IsManual = true.
      else IsManual = false.

    run adm/shattri.p (
      input "get":U
      ,input pObjType
      ,input pObjCode
      ,input {&attr-marking}
      ,input "ban-recipes"
      ,output v-value-character
      ,output v-value-date
      ,output v-value-decimal
      ,output v-value-integer
      ,output v-value-logical
      ,output v-value-type
      ,input-output TABLE thbjattr_thbj-attr
      ) no-error .
    if v-value-logical = true
      then IsBanRecipes = true.
      else IsBanRecipes = false.

    run adm/shattri.p (
      input "get":U
      ,input pObjType
      ,input pObjCode
      ,input {&attr-marking}
      ,input "ban-altr"
      ,output v-value-character
      ,output v-value-date
      ,output v-value-decimal
      ,output v-value-integer
      ,output v-value-logical
      ,output v-value-type
      ,input-output TABLE thbjattr_thbj-attr
      ) no-error .
    if v-value-logical = true
      then IsBanAltr = true.
      else IsBanAltr = false.      

    run adm/shattri.p (
      input "get":U
      ,input pObjType
      ,input pObjCode
      ,input {&attr-marking}
      ,input "bar-code"
      ,output v-value-character
      ,output v-value-date
      ,output v-value-decimal
      ,output v-value-integer
      ,output v-value-logical
      ,output v-value-type
      ,input-output TABLE thbjattr_thbj-attr
      ) no-error .
    if v-value-logical = true
      then IsBarCode = true.
      else IsBarCode = false.   

    
  end constructor.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public logical GetIsMarkingForType(pType as char):

    return MarkingTypeobj:GetValForType(pType).

  end method.  
  
  method public logical GetIsMarkingForTypeEDO(pType as char):

    return MarkingTypeEDOobj:GetValForType(pType).

  end method.  
    
  
end class.