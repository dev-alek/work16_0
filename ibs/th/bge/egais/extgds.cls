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


class ibs.th.bge.egais.ExtGds: 
  
  {cmp/str-glbl.i class}
  { ref/extclass.i }  
  { gbl/thbj-def.i }
  
  define private buffer buf_ext-classif      for ub.ext-classif.
  define private buffer x_ext-classif        for ub.ext-classif.
  define private buffer buf_ext-classif-attr for ub.ext-classif-attr.

  define property ExtSystem as integer no-undo
    get.
    private set.
  
  define property DbNum as integer init 0 no-undo
    get.
    set.
  
  define property CliRegIdProd as character no-undo
    get.
    set.
  
  define property INNProd as character no-undo
    get.
    set.
  
  define property KPPProd as character no-undo
    get.
    set.
  
  define property FullNameProd as character no-undo
    get.
    set.
  
  define property CountryProd as character no-undo
    get.
    set.
  
  define property DescrProd as character no-undo
    get.
    set.

  define property CliRegIdImpor as character no-undo
    get.
    set.
  
  define property INNImpor as character no-undo
    get.
    set.
  
  define property KPPImpor as character no-undo
    get.
    set.
  
  define property FullNameImpor as character no-undo
    get.
    set.
  
  define property CountryImpor as character no-undo
    get.
    set.
  
  define property DescrImpor as character no-undo
    get.
    set.

  define property FullNameGds as character no-undo
    get.
    set.

  define property IsSilent as logical no-undo
    get.
    private set.

  define property GdsCode as integer no-undo init 0
    get.
    private set.

  define property AlcCode as character no-undo
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

  method public logical FindExtGds (inAlcCode as char):
    
    ReturnMsg = "".
    AlcCode = inAlcCode.
    
    find first buf_ext-classif no-lock  where buf_ext-classif.classif-subject = {&table_goods} 
      and buf_ext-classif.classif-name = {&extclass_goods_esys} 
      and buf_ext-classif.db-num = 0  
      and buf_ext-classif.key#_two = ExtSystem 
      and buf_ext-classif.key#_three = 0
      and buf_ext-classif.charkey_one = inAlcCode
      and buf_ext-classif.charkey_two = ""
      and buf_ext-classif.charkey_three = ""
      and buf_ext-classif.nonunique = 0
      no-error.
                                               

    if not available (buf_ext-classif)
      then 
    do:
      ClearProp().
      ReturnMsg = "Отсутсвует связка товара ЕГАИС - " + inAlcCode.
      if not IsSilent 
        then message ReturnMsg view-as alert-box.
      AlcCode = "".
      return false.
    end.
    
    GdsCode = buf_ext-classif.key#_one.
    
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
/*      AlcCode = "".*/
/*      return false.*/
    end.
    
    setProp () no-error.
    if error-status:error
      then 
    do:
      ReturnMsg = return-value.
      if not IsSilent 
        then message ReturnMsg view-as alert-box.
    end.
    return true.
  
  end.

  method public logical CreateExtGds (inAlcCode as char, InGdsCode as integer):
    
    ReturnMsg = "".
    AlcCode = inAlcCode.
    GdsCode = InGdsCode. 
    
    do trans:
    
      find first buf_ext-classif no-lock  where buf_ext-classif.classif-subject = {&table_goods} 
        and buf_ext-classif.classif-name = {&extclass_goods_esys} 
        and buf_ext-classif.db-num = 0  
        and buf_ext-classif.key#_two = ExtSystem 
        and buf_ext-classif.key#_three = 0
        and buf_ext-classif.charkey_one = inAlcCode
        and buf_ext-classif.charkey_two = ""
        and buf_ext-classif.charkey_three = ""
        and buf_ext-classif.nonunique = 0
        no-error.
  
      if available (buf_ext-classif)
        then 
      do:
        ReturnMsg = "Уже есть связка товара ЕГАИС - " + inAlcCode + " c товаром TH - " + string (buf_ext-classif.Key#_One).
        if not IsSilent 
          then message ReturnMsg view-as alert-box.
        AlcCode = "".
        GdsCode = 0.
        undo, return false.
      end.

      create buf_ext-classif.
      assign 
        buf_ext-classif.classif-subject = {&table_goods} 
        buf_ext-classif.classif-name = {&extclass_goods_esys} 
        buf_ext-classif.db-num = 0
        buf_ext-classif.Key#_One = InGdsCode  
        buf_ext-classif.key#_two = ExtSystem 
        buf_ext-classif.key#_three = 0
        buf_ext-classif.charkey_one = inAlcCode
        buf_ext-classif.charkey_two = ""
        buf_ext-classif.charkey_three = ""
        buf_ext-classif.nonunique = 0
        buf_ext-classif.uniq-key-rec = {&table_goods} + {&delim-key} + string (InGdsCode)
      no-error.
      
      if error-status:error
        then 
      do:
        delete buf_ext-classif.
        ReturnMsg = "Непредвиденная ошибка при создании связки  - " + inAlcCode + " TH - " + string (InGdsCode).
        if not IsSilent 
          then message ReturnMsg view-as alert-box.
        AlcCode = "".
        GdsCode = 0.
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
      .

      if error-status:error
        then 
      do:
        delete buf_ext-classif-attr.
        ReturnMsg = "Запись уже есть buf_ext-classif-attr. Создание будет продолжено. Непредвиденная ситуация при создании атрибута egais-info  - " + inAlcCode + " TH - " + string (InGdsCode).
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
        /*AlcCode = "".
        GdsCode = 0.
        undo, return false.*/
      end.
  
      if not SaveEGAISInfo ()
        then do:
          AlcCode = "".
          GdsCode = 0.
          undo, return false.
        end.
    end.
      
    return true.
  
  end.
  
  method public logical DeleteExtGds (inAlcCode as char):
    
    ReturnMsg = "".
    
    do trans:
      
      for each buf_ext-classif-attr exclusive-lock where 
            buf_ext-classif-attr.classif-subject = buf_ext-classif.classif-subject
        and buf_ext-classif-attr.classif-name = {&extclass_goods_esys} 
        and buf_ext-classif-attr.db-num = 0  
        and buf_ext-classif-attr.key#_two = ExtSystem 
/*        and buf_ext-classif-attr.key#_three = 0*/
        and buf_ext-classif-attr.charkey_one = inAlcCode
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
/*        and buf_ext-classif.key#_three = 0*/
        and buf_ext-classif.charkey_one = inAlcCode
/*        and buf_ext-classif.charkey_two = ""*/
/*        and buf_ext-classif.charkey_three = ""*/
/*        and buf_ext-classif.nonunique = 0*/
        :
        
        delete buf_ext-classif.        
        
      end.
      
/*      if not available (buf_ext-classif)                              */
/*        then                                                          */
/*      do:                                                             */
/*        ReturnMsg = "Непредвидинная ошибка не найден  - " + inAlcCode.*/
/*        if not IsSilent                                               */
/*          then message ReturnMsg view-as alert-box.                   */
/*        AlcCode = "".                                                 */
/*        GdsCode = 0.                                                  */
/*        undo, return false.                                           */
/*      end.                                                            */


      
      AlcCode = "".
      GdsCode = 0.
    
    end.

    return true.
  
  end.
  
  method public logical SaveEGAISInfo ():
    
    def var v-prod  as char no-undo.
    def var v-impor as char no-undo.
    def var v-msg   as char no-undo.
    
    do trans:
    
      ReturnMsg = "".
      
      v-prod = chr(5) + chr(5) + chr(5) + chr(5) + chr(5).
      v-impor = chr(5) + chr(5) + chr(5) + chr(5) + chr(5).
  
      find current buf_ext-classif-attr exclusive-lock.
      
      if error-status:error
        then 
      do:
        ReturnMsg = "Ошибка при сохранении атрибута egais-info  - " + AlcCode + " TH - " + string (GdsCode) + " Не могу заблокировать запись buf_ext-classif-attr".
        if not IsSilent 
          then message ReturnMsg view-as alert-box.
        undo, return false.
      end.
      
      entry (1, v-prod, chr(5)) = CliRegIdProd.
      entry (2, v-prod, chr(5)) = INNProd.
      entry (3, v-prod, chr(5)) = KPPProd.
      entry (4, v-prod, chr(5)) = FullNameProd.
      entry (5, v-prod, chr(5)) = CountryProd.
      entry (6, v-prod, chr(5)) = DescrProd.
      
      entry (1, v-impor, chr(5)) = CliRegIdImpor.
      entry (2, v-impor, chr(5)) = INNImpor.
      entry (3, v-impor, chr(5)) = KPPImpor.
      entry (4, v-impor, chr(5)) = FullNameImpor.
      entry (5, v-impor, chr(5)) = CountryImpor.
      entry (6, v-impor, chr(5)) = DescrImpor.
  
      buf_ext-classif-attr.attr-value = v-prod + chr(4) + v-impor + chr(4) + FullNameGds.
      
    end.

    find current buf_ext-classif-attr no-lock.
    return true.
    
  end.

  method public character GetListAlcCode (inGdsCode as integer):

    def var v-ListAlcCode as char no-undo.

    ReturnMsg = "".
    inGdsCode = inGdsCode.
 

    for each x_ext-classif no-lock where x_ext-classif.classif-subject = {&table_goods} 
      and x_ext-classif.classif-name = {&extclass_goods_esys} 
      and x_ext-classif.db-num = 0
      and x_ext-classif.key#_one = inGdsCode  
      and x_ext-classif.key#_two = ExtSystem 
      and x_ext-classif.key#_three = 0
      and x_ext-classif.uniq-key-rec = {&table_goods} + {&delim-key} + string (inGdsCode)
      and x_ext-classif.charkey_two = ""
      and x_ext-classif.charkey_three = ""
      and x_ext-classif.nonunique = 0
      :
    
      v-ListAlcCode = v-ListAlcCode + "," + x_ext-classif.charkey_one.
    
    end.
    
    v-ListAlcCode = left-trim (v-ListAlcCode, ",").
    return v-ListAlcCode.
    
    
  end.

  method public void Release_ ():
    
    AlcCode = "".
    GdsCode = 0.
    release buf_ext-classif.
    release buf_ext-classif-attr.
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

  method private void setProp ():
    
    def var v-prod  as char no-undo.
    def var v-impor as char no-undo.
    def var v-msg   as char no-undo.
    v-prod = ''.
    v-impor = ''.
    ReturnMsg = "".
    
    ClearProp().
    
    find current buf_ext-classif.
    find current buf_ext-classif-attr.
    
    if num-entries (buf_ext-classif-attr.attr-value, chr(4)) <> 3
      then 
    do:
      v-msg = "Некорректный атрибут egais-info - " + buf_ext-classif-attr.attr-value + " Товар" + string (buf_ext-classif.key#_one) + ". Выполните синхронизацию товаров.".
      return error v-msg.      
    end.
        
    v-prod = entry (1, buf_ext-classif-attr.attr-value, chr(4)) no-error.
    if num-entries (v-prod, chr (5)) <> 6 
      then 
    do:
      v-msg = "Некорректный атрибут egais-info v-prod - " + buf_ext-classif-attr.attr-value + " Товар" + string (buf_ext-classif.key#_one) + ". Выполните синхронизацию товаров.".
      return error v-msg.
    end.
    
    v-impor = entry (2, buf_ext-classif-attr.attr-value, chr(4)) no-error.
    if  num-entries (v-impor, chr (5)) <> 6 
      then 
    do:
      v-msg = "Некорректный атрибут egais-info v-impor - " + buf_ext-classif-attr.attr-value + " Товар" + string (buf_ext-classif.key#_one) + ". Выполните синхронизацию товаров.".
      return error v-msg.
    end.
    
    CliRegIdProd = entry (1, v-prod, chr(5)).
    INNProd = entry (2, v-prod, chr(5)).
    KPPProd = entry (3, v-prod, chr(5)).
    FullNameProd = entry (4, v-prod, chr(5)).
    CountryProd = entry (5, v-prod, chr(5)).
    DescrProd = entry (6, v-prod, chr(5)).
    
    CliRegIdImpor = entry (1, v-impor, chr(5)).
    INNImpor = entry (2, v-impor, chr(5)).
    KPPImpor = entry (3, v-impor, chr(5)).
    FullNameImpor = entry (4, v-impor, chr(5)).
    CountryImpor = entry (5, v-impor, chr(5)).
    DescrImpor = entry (6, v-impor, chr(5)).

    FullNameGds = entry (3, buf_ext-classif-attr.attr-value, chr(4)).
    
  end.

  method private void ClearProp ():

    CliRegIdProd = "".
    INNProd = "".
    KPPProd = "".
    FullNameProd = "".
    CountryProd = "".
    DescrProd = "".
    
    CliRegIdImpor = "".
    INNImpor = "".
    KPPImpor = "".
    FullNameImpor = "".
    CountryImpor = "".
    DescrImpor = "".
    
    FullNameGds = "".
    
  end.


end class.