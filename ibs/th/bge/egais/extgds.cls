/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Класс работы с внешним классификатором товаров ЕГАИС.

Автор: Морозов Александр Сергеевич
Дата создания: 15/03/16
Author: Alexandr Morozov
Creation date: 15/03/16

*/

using Progress.Lang.*.
using ibs.th.bge.egais.*.

class ibs.th.bge.egais.ExtGds: 
  
  {cmp/str-glbl.i class}
  { ref/extclass.i }  
  { gbl/thbj-def.i }
  
  
  define private temp-table ttObjEgaisAlcProp no-undo
    field iExtGdsObj as integer
    field ExtGdsValueObj as class Progress.Lang.Object
    index pi is primary unique iExtGdsObj .
  
  define private buffer buf_ext-classif      for ub.ext-classif.
  define private buffer x_ext-classif        for ub.ext-classif.
  define private buffer buf_ext-classif-attr for ub.ext-classif-attr.
  define private buffer buf_gds for ub.goods.

  define property ExtSystem as integer no-undo
    get.
    private set.
  
  define property DbNum as integer init 0 no-undo
    get.
    set.
  
  define property IsSilent as logical no-undo
    get.
    private set.

  define property GdsCodeItemQuery as integer no-undo init 0
    get.
    private set.

  define property AlcCodeItemQuery as character no-undo
    get.
    private set.

  define property NumBundles as integer no-undo
    get.
    private set.

  define property ReturnMsg as character no-undo
    get.
    private set.

  constructor public ExtGds (inIsSilent as logical):
    
    ExtSystem = getExtSystem().
    IsSilent = inIsSilent.
    
    if ExtSystem = 0 or ExtSystem = ?
      then 
    do:
      if not IsSilent 
        then message "Отсутсвует ВС настроенная для обмена с ЕГАИС" view-as alert-box.
      return error "Отсутсвует ВС настроенная для обмена с ЕГАИС".
    end.
    
  end constructor. 
  
  destructor public ExtGds ():
    
    ClearProp().
    
  end destructor. 

  method public logical OpenQueryExtGds (inGdsCode as int, inAlcCode as char):
    
    def var ii as int no-undo.
    
    ClearProp().
    
    assign
      ReturnMsg = ""
      AlcCodeItemQuery = inAlcCode
      GdsCodeItemQuery = inGdsCode
      ii = 0.
    
    for each buf_ext-classif no-lock where buf_ext-classif.classif-subject = {&table_goods} 
      and buf_ext-classif.classif-name = {&extclass_goods_esys} 
      and buf_ext-classif.db-num = 0
      and (GdsCodeItemQuery = 0 or buf_ext-classif.key#_one = GdsCodeItemQuery)   
      and buf_ext-classif.key#_two = ExtSystem 
      and buf_ext-classif.key#_three = 0
      and (AlcCodeItemQuery = "" or buf_ext-classif.charkey_one = AlcCodeItemQuery)
      and buf_ext-classif.charkey_two = ""
      and buf_ext-classif.charkey_three = ""
      and buf_ext-classif.nonunique = 0
      :
      
      find first buf_ext-classif-attr no-lock where buf_ext-classif-attr.classif-subject = buf_ext-classif.classif-subject
        and buf_ext-classif-attr.classif-name = buf_ext-classif.classif-name
        and buf_ext-classif-attr.db-num = buf_ext-classif.db-num
        and buf_ext-classif-attr.Key#_One = buf_ext-classif.key#_one
        and buf_ext-classif-attr.Key#_two = buf_ext-classif.key#_two
        and buf_ext-classif-attr.Key#_three = buf_ext-classif.key#_three
        and buf_ext-classif-attr.CharKey_One = buf_ext-classif.charkey_one
        and buf_ext-classif-attr.CharKey_two = buf_ext-classif.charkey_two
        and buf_ext-classif-attr.CharKey_three = buf_ext-classif.charkey_three
        and buf_ext-classif-attr.nonunique = buf_ext-classif.nonunique
        and buf_ext-classif-attr.attr-code = 'egais-info'
        no-error .
      
      if not available (buf_ext-classif-attr)
        then 
      do:
        ClearProp().
        ReturnMsg = "Отсутсвует атрибут egais-info - " + inAlcCode + ". Выполните синхронизацию.".
        if not IsSilent 
          then message ReturnMsg view-as alert-box.
      end.
      ii = ii + 1.
      setProp (ii) no-error.
      if error-status:error
        then 
      do:
        ReturnMsg = return-value.
        if not IsSilent 
          then message ReturnMsg view-as alert-box.
      end.
    end.
    NumBundles = ii.
    return true.
  end.
  
  method public class ExtGdsValue GetExtGdsValue () :

    return GetExtGdsValue (1).
     
  end.
  
  method public class ExtGdsValue GetExtGdsValue (inJJ as int) :
    
    find first ttObjEgaisAlcProp where ttObjEgaisAlcProp.iExtGdsObj = inJJ no-error.
    if not available (ttObjEgaisAlcProp)
      then return ?.
    return cast (ttObjEgaisAlcProp.ExtGdsValueObj, ibs.th.bge.egais.ExtGdsValue).
     
  end.

  method public logical CreateExtGds (inGdsCode as int, inAlcCode as char):
    
    define variable extGdsValueObj as class ExtGdsValue no-undo.
    define variable glog as logical no-undo.
    
    extGdsValueObj = new ExtGdsValue().
    extGdsValueObj:AlcCode = inAlcCode.
    extGdsValueObj:GdsCode = inGdsCode.
    
    glog = CreateExtGds(extGdsValueObj) .
    if not glog 
      then if valid-object (extGdsValueObj) 
                  then delete object extGdsValueObj. 
    
    return glog.
    
  end.

  method public logical CreateExtGds (inExtGdsValueObj as class ExtGdsValue):
    
    ClearProp().
    
    assign
      ReturnMsg = ""
      AlcCodeItemQuery = inExtGdsValueObj:AlcCode
      GdsCodeItemQuery = inExtGdsValueObj:GdsCode
    .
    
    find first buf_gds no-lock where buf_gds.gds-code = inExtGdsValueObj:GdsCode no-error.
    if not available (buf_gds)
    then do:
      ReturnMsg = "Не найден товар TH - " + string (inExtGdsValueObj:GdsCode).
      if not IsSilent 
        then message ReturnMsg view-as alert-box.
      AlcCodeItemQuery = "".
      GdsCodeItemQuery = 0.
      undo, return false.
    end.
    
    if inExtGdsValueObj:AlcCode = ? or inExtGdsValueObj:AlcCode = ""
    then do:
      ReturnMsg = "Неверное значение AlcCode".
      if not IsSilent 
        then message ReturnMsg view-as alert-box.
      AlcCodeItemQuery = "".
      GdsCodeItemQuery = 0.
      undo, return false.      
    end.
    
    do trans:
    
      find first buf_ext-classif no-lock  where buf_ext-classif.classif-subject = {&table_goods} 
        and buf_ext-classif.classif-name = {&extclass_goods_esys} 
        and buf_ext-classif.db-num = 0
        and buf_ext-classif.Key#_One = inExtGdsValueObj:GdsCode
        and buf_ext-classif.key#_two = ExtSystem 
        and buf_ext-classif.key#_three = 0
        and buf_ext-classif.charkey_one = inExtGdsValueObj:AlcCode
        and buf_ext-classif.charkey_two = ""
        and buf_ext-classif.charkey_three = ""
        and buf_ext-classif.nonunique = 0
        no-error.
  
      if available (buf_ext-classif)
        then 
      do:
        ReturnMsg = "Уже есть связка товара ЕГАИС - " + inExtGdsValueObj:AlcCode + " c товаром TH - " + string (inExtGdsValueObj:GdsCode).
        if not IsSilent 
          then message ReturnMsg view-as alert-box.
        AlcCodeItemQuery = "".
        GdsCodeItemQuery = 0.
        undo, return false.
      end.

      create buf_ext-classif.
      assign 
        buf_ext-classif.classif-subject = {&table_goods} 
        buf_ext-classif.classif-name = {&extclass_goods_esys} 
        buf_ext-classif.db-num = 0
        buf_ext-classif.Key#_One = inExtGdsValueObj:GdsCode  
        buf_ext-classif.key#_two = ExtSystem 
        buf_ext-classif.key#_three = 0
        buf_ext-classif.charkey_one = inExtGdsValueObj:AlcCode
        buf_ext-classif.charkey_two = ""
        buf_ext-classif.charkey_three = ""
        buf_ext-classif.nonunique = 0
        buf_ext-classif.uniq-key-rec = {&table_goods} + {&delim-key} + string (inExtGdsValueObj:GdsCode)
      no-error.
      
      if error-status:error
        then 
      do:
        delete buf_ext-classif.
        ReturnMsg = "Непредвиденная ошибка при создании связки  - " + inExtGdsValueObj:AlcCode + " TH - " + string (inExtGdsValueObj:GdsCode).
        if not IsSilent 
          then message ReturnMsg view-as alert-box.
        AlcCodeItemQuery = "".
        GdsCodeItemQuery = 0.
        undo, return false.
      end.
      
      create buf_ext-classif-attr. 
      assign
        buf_ext-classif-attr.classif-subject = buf_ext-classif.classif-subject
        buf_ext-classif-attr.classif-name    = buf_ext-classif.classif-name
        buf_ext-classif-attr.db-num          = buf_ext-classif.db-num
        buf_ext-classif-attr.Key#_One        = buf_ext-classif.key#_one
        buf_ext-classif-attr.Key#_two        = buf_ext-classif.key#_two
        buf_ext-classif-attr.Key#_three      = buf_ext-classif.key#_three
        buf_ext-classif-attr.CharKey_One     = buf_ext-classif.charkey_one
        buf_ext-classif-attr.CharKey_two     = buf_ext-classif.charkey_two
        buf_ext-classif-attr.CharKey_three   = buf_ext-classif.charkey_three
        buf_ext-classif-attr.nonunique       = buf_ext-classif.nonunique
        buf_ext-classif-attr.attr-code       = 'egais-info'
      no-error.

      if error-status:error
        then 
      do:
        delete buf_ext-classif-attr.
        ReturnMsg = "Запись уже есть buf_ext-classif-attr. Создание будет продолжено. Непредвиденная ситуация при создании атрибута egais-info  - " + inExtGdsValueObj:AlcCode + " TH - " + string (inExtGdsValueObj:GdsCode).
        if not IsSilent 
          then message ReturnMsg view-as alert-box.
        find first buf_ext-classif-attr where
          buf_ext-classif-attr.classif-subject = buf_ext-classif.classif-subject
          and buf_ext-classif-attr.classif-name    = buf_ext-classif.classif-name
          and buf_ext-classif-attr.db-num          = buf_ext-classif.db-num
          and buf_ext-classif-attr.Key#_One        = buf_ext-classif.key#_one
          and buf_ext-classif-attr.Key#_two        = buf_ext-classif.key#_two
          and buf_ext-classif-attr.Key#_three      = buf_ext-classif.key#_three
          and buf_ext-classif-attr.CharKey_One     = buf_ext-classif.charkey_one
          and buf_ext-classif-attr.CharKey_two     = buf_ext-classif.charkey_two
          and buf_ext-classif-attr.CharKey_three   = buf_ext-classif.charkey_three
          and buf_ext-classif-attr.nonunique       = buf_ext-classif.nonunique
          and buf_ext-classif-attr.attr-code       = 'egais-info'
        no-error.
      end.
  
      if not SaveEGAISInfoDB (inExtGdsValueObj)
        then do:
          AlcCodeItemQuery = "".
          GdsCodeItemQuery = 0.
          undo, return false.
        end.
    end.
    
    create ttObjEgaisAlcProp.
    NumBundles = 1.
    ttObjEgaisAlcProp.iExtGdsObj = 1.
    cast (ttObjEgaisAlcProp.ExtGdsValueObj, ibs.th.bge.egais.ExtGdsValue) = inExtGdsValueObj.
    return true.
  
  end.

  method public logical DeleteExtGds (inGdsCode as int):
    
    if DeleteExtGds ( inGdsCode, ? )
      then return true.
      else return false.
  
  end.  
  
  method public logical DeleteExtGds (inAlcCode as char):
    
    if DeleteExtGds (  ?, inAlcCode )
      then return true.
      else return false.
  
  end.  
  
  method public logical DeleteExtGds (inGdsCode as int, inAlcCode as char):
    
    ReturnMsg = "".
    
    do trans:
      
      for each buf_ext-classif-attr exclusive-lock where 
            buf_ext-classif-attr.classif-subject = {&table_goods}
        and buf_ext-classif-attr.classif-name = {&extclass_goods_esys} 
        and buf_ext-classif-attr.db-num = 0
        and (inGdsCode = ? or buf_ext-classif-attr.Key#_One = inGdsCode)
        and buf_ext-classif-attr.key#_two = ExtSystem 
/*        and buf_ext-classif-attr.key#_three = 0*/
        and (inAlcCode = ? or buf_ext-classif-attr.charkey_one = inAlcCode)
/*        and buf_ext-classif-attr.charkey_two = ""*/
/*        and buf_ext-classif-attr.charkey_three = ""*/
/*        and buf_ext-classif-attr.nonunique = 0*/
        :
        
        delete buf_ext-classif-attr.
      
      end.
      
      for each buf_ext-classif exclusive-lock where 
            buf_ext-classif.classif-subject = {&table_goods} 
        and buf_ext-classif.classif-name = {&extclass_goods_esys} 
        and buf_ext-classif.db-num = 0  
        and buf_ext-classif.key#_two = ExtSystem
        and (inGdsCode = ? or buf_ext-classif.Key#_One = inGdsCode) 
/*        and buf_ext-classif.key#_three = 0*/
        and (inAlcCode = ? or buf_ext-classif.charkey_one = inAlcCode)
/*        and buf_ext-classif.charkey_two = ""*/
/*        and buf_ext-classif.charkey_three = ""*/
/*        and buf_ext-classif.nonunique = 0*/
        :
        
        delete buf_ext-classif.        
        
      end.
    
    end.

    return true.
  
  end.
  
  method public logical SaveEGAISInfo (inExtGdsValueObj as ExtGdsValue):
    
    def var glog as log no-undo.
    
    do trans:

      find first buf_ext-classif-attr exclusive-lock where 
            buf_ext-classif-attr.classif-subject = buf_ext-classif.classif-subject
        and buf_ext-classif-attr.classif-name = {&extclass_goods_esys} 
        and buf_ext-classif-attr.db-num = 0
        and buf_ext-classif-attr.Key#_One = inExtGdsValueObj:GdsCode
        and buf_ext-classif-attr.key#_two = ExtSystem 
        and buf_ext-classif-attr.key#_three = 0
        and buf_ext-classif.charkey_one = inExtGdsValueObj:AlcCode
        and buf_ext-classif-attr.charkey_two = ""
        and buf_ext-classif-attr.charkey_three = ""
      no-error.

      glog = SaveEGAISInfoDB (inExtGdsValueObj).
      
    end.

    return glog.
    
  end.

  method private logical SaveEGAISInfoDB (inExtGdsValueObj as ExtGdsValue):
    
    def var v-prod  as char no-undo.
    def var v-impor as char no-undo.
    def var v-msg   as char no-undo.
    
    ReturnMsg = "".
    
    v-prod = chr(5) + chr(5) + chr(5) + chr(5) + chr(5).
    v-impor = chr(5) + chr(5) + chr(5) + chr(5) + chr(5).
    
    if error-status:error
      then 
    do:
      ReturnMsg = "Ошибка при сохранении атрибута egais-info  - " + inExtGdsValueObj:AlcCode + " TH - " + string (inExtGdsValueObj:GdsCode) + " Не найдена запись buf_ext-classif-attr".
      if not IsSilent 
        then message ReturnMsg view-as alert-box.
      undo, return false.
    end.
    
    entry (1, v-prod, chr(5)) = inExtGdsValueObj:CliRegIdProd.
    entry (2, v-prod, chr(5)) = inExtGdsValueObj:INNProd.
    entry (3, v-prod, chr(5)) = inExtGdsValueObj:KPPProd.
    entry (4, v-prod, chr(5)) = inExtGdsValueObj:FullNameProd.
    entry (5, v-prod, chr(5)) = inExtGdsValueObj:CountryProd.
    entry (6, v-prod, chr(5)) = inExtGdsValueObj:DescrProd.
    
    entry (1, v-impor, chr(5)) = inExtGdsValueObj:CliRegIdImpor.
    entry (2, v-impor, chr(5)) = inExtGdsValueObj:INNImpor.
    entry (3, v-impor, chr(5)) = inExtGdsValueObj:KPPImpor.
    entry (4, v-impor, chr(5)) = inExtGdsValueObj:FullNameImpor.
    entry (5, v-impor, chr(5)) = inExtGdsValueObj:CountryImpor.
    entry (6, v-impor, chr(5)) = inExtGdsValueObj:DescrImpor.
  
    buf_ext-classif-attr.attr-value = v-prod + chr(4) + v-impor + chr(4) + inExtGdsValueObj:FullNameGds.
    release buf_ext-classif-attr.
    
  end.

  method public void Release_ ():
    
    ClearProp().
    
  end.

  method private integer getExtSystem ():
  
    define variable v-value-character as character no-undo .
    define variable v-value-decimal   as decimal   no-undo .
    define variable v-value-integer   as integer   no-undo .
    define variable v-value-logical   as logical   no-undo .
    define variable v-value-type      as character no-undo .
    define variable v-value-date      as date      no-undo .
    define variable v-ext-sys         as integer   no-undo .
  
    empty temp-table thbjattr_thbj-attr.
    run adm/shattri.p (
      input "get":U
      ,input '':U
      ,input 0
      ,input {&attr-egais-host}
      ,input {&attr-egais-host_egais-exsys}
      ,output v-value-character
      ,output v-value-date
      ,output v-value-decimal
      ,output v-value-integer
      ,output v-value-logical
      ,output v-value-type
      ,input-output table thbjattr_thbj-attr
      ) no-error .
    return v-value-integer . 
  
  end.

  method private void setProp (inJJ as int):
    
    def var v-prod  as char no-undo.
    def var v-impor as char no-undo.
    def var v-msg   as char no-undo.
    def var hndlclsExtGdsValueObj as class ExtGdsValue no-undo.
    v-prod = ''.
    v-impor = ''.
    ReturnMsg = "".
    
    find current buf_ext-classif-attr no-lock.
    
    hndlclsExtGdsValueObj = new ExtGdsValue().
    
    create ttObjEgaisAlcProp.
    assign
      ttObjEgaisAlcProp.iExtGdsObj = inJJ
      ttObjEgaisAlcProp.ExtGdsValueObj = cast (hndlclsExtGdsValueObj,Progress.Lang.Object).
    
    hndlclsExtGdsValueObj:AlcCode = buf_ext-classif-attr.CharKey_One.
    hndlclsExtGdsValueObj:GdsCode = buf_ext-classif-attr.Key#_One.
    
    if num-entries (buf_ext-classif-attr.attr-value, chr(4)) <> 3
      then 
    do:
      v-msg = "Некорректный атрибут egais-info - " + buf_ext-classif-attr.attr-value + " Товар" + string (buf_ext-classif-attr.key#_one) + ". Выполните синхронизацию товаров.".
      return error v-msg.      
    end.
        
    v-prod = entry (1, buf_ext-classif-attr.attr-value, chr(4)) no-error.
    if num-entries (v-prod, chr (5)) <> 6 
      then 
    do:
      v-msg = "Некорректный атрибут egais-info v-prod - " + buf_ext-classif-attr.attr-value + " Товар" + string (buf_ext-classif-attr.key#_one) + ". Выполните синхронизацию товаров.".
      return error v-msg.
    end.
    
    v-impor = entry (2, buf_ext-classif-attr.attr-value, chr(4)) no-error.
    if  num-entries (v-impor, chr (5)) <> 6 
      then 
    do:
      v-msg = "Некорректный атрибут egais-info v-impor - " + buf_ext-classif-attr.attr-value + " Товар" + string (buf_ext-classif-attr.key#_one) + ". Выполните синхронизацию товаров.".
      return error v-msg.
    end.
    
    hndlclsExtGdsValueObj:CliRegIdProd = entry (1, v-prod, chr(5)).
    hndlclsExtGdsValueObj:INNProd = entry (2, v-prod, chr(5)).
    hndlclsExtGdsValueObj:KPPProd = entry (3, v-prod, chr(5)).
    hndlclsExtGdsValueObj:FullNameProd = entry (4, v-prod, chr(5)).
    hndlclsExtGdsValueObj:CountryProd = entry (5, v-prod, chr(5)).
    hndlclsExtGdsValueObj:DescrProd = entry (6, v-prod, chr(5)).
    
    hndlclsExtGdsValueObj:CliRegIdImpor = entry (1, v-impor, chr(5)).
    hndlclsExtGdsValueObj:INNImpor = entry (2, v-impor, chr(5)).
    hndlclsExtGdsValueObj:KPPImpor = entry (3, v-impor, chr(5)).
    hndlclsExtGdsValueObj:FullNameImpor = entry (4, v-impor, chr(5)).
    hndlclsExtGdsValueObj:CountryImpor = entry (5, v-impor, chr(5)).
    hndlclsExtGdsValueObj:DescrImpor = entry (6, v-impor, chr(5)).

    hndlclsExtGdsValueObj:FullNameGds = entry (3, buf_ext-classif-attr.attr-value, chr(4)).
    
    
  end.

  method private void ClearProp ():

    AlcCodeItemQuery = "".
    GdsCodeItemQuery = 0.
    NumBundles = 0.
    for each ttObjEgaisAlcProp:
      if valid-object (ttObjEgaisAlcProp.ExtGdsValueObj)
        then delete object ttObjEgaisAlcProp.ExtGdsValueObj.
    end.
    empty temp-table ttObjEgaisAlcProp.
    
  end.


end class.