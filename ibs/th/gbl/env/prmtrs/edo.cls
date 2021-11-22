 
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

  define public property Shoes as logical initial false no-undo 
    get.
    private set. 

  define public property Perfume as logical initial false no-undo 
    get.
    private set. 

  define public property Industry as logical initial false no-undo 
    get.
    private set. 

  define public property Tires as logical initial false no-undo 
    get.
    private set. 
    
  define public property Apteka as logical initial false no-undo 
    get.
    private set. 
    
  define public property Photo as logical initial false no-undo 
    get.
    private set. 

  define public property Tabak as logical initial false no-undo 
    get.
    private set.      

  define public property Milk as logical initial false no-undo 
    get.
    private set.   
    
  define public property Water as logical initial false no-undo 
    get.
    private set.   
        
  define public property NotType as logical initial false no-undo 
    get.
    private set.

  define public property MarkingType as character initial "" no-undo 
    get.
    private set.

  define public property MarkingTypeEDO as character initial "" no-undo 
    get.
    private set.

  define public property IsMarking as logical initial false no-undo 
    get.
    private set.

  define public property IsEdo as logical initial false no-undo 
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

    if MarkingType = ""
    then IsMarking = false.
    else do:
      IsMarking = true.
      case true:
        when lookup (MarkingType, "not-type") > 0 then do:
          NotType = true.
        end.
        when  lookup (MarkingType, "tabak") > 0 then do:
          Tabak = true.
        end.
        when  lookup (MarkingType, "shoes") > 0 then do:
          Shoes = true.
        end.
        when  lookup (MarkingType, "perfume") > 0 then do:
          Perfume = true.
        end.
        when  lookup (MarkingType, "industry") > 0 then do:
          Industry = true.
        end.
        when  lookup (MarkingType, "tires") > 0 then do:
          Tires = true.
        end.
        when  lookup (MarkingType, "apteka") > 0 then do:
          Apteka = true.
        end.
        when  lookup (MarkingType, "photo") > 0 then do:
          Photo = true.
        end.
        when  lookup (MarkingType, "milk") > 0 then do:
          Milk = true.
        end.
        when  lookup (MarkingType, "water") > 0 then do:
          Water = true.
        end.        
        otherwise do:
          IsMarking = false.
        end.
      end.
    end.
    
  end constructor.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public logical GetIsMarkingForType(pType as char):

    if not MarkingType = "" and lookup (pType, MarkingType) > 0
      then return true.
      else return false.

  end method.  
  
  method public logical GetIsMarkingForTypeEDO(pType as char):

    if not MarkingTypeEDO = "" and lookup (pType, MarkingTypeEDO) > 0
      then return true.
      else return false.

  end method.  
    
  
end class.