 
 /*------------------------------------------------------------------------
    File        : impgoods
    Purpose     : 
    Syntax      : 
    Description : Класс импорта данных по товарам из 1С
    Author(s)   : SSlivenko
    Created     : Fri Oct 20 17:21:36 AST 2017
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.*.

class ibs.th.bge.1crn.import.imppromotion implements ibs.th.bge.1crn.import.iimpsubject:
     
  
  
  define property Msg as character no-undo
    get. 
    set.
  
  method public logical Excute( subjectObj as class ibs.th.bge.1crn.subjects.isubject ):
      
      
      define variable objPromotion          as class promotion  no-undo .
      define variable v-profile             as integer          no-undo .
            
      objPromotion = cast (subjectObj, promotion).
      
      if objPromotion:dscnt-type = 2 and
         objPromotion:dscnt-value-type = 1 and
         (trim(objPromotion:pmnt-types) = "" or objPromotion:pmnt-types = ?)
      then do :
          v-profile = 5 .
      end.
      else
      if objPromotion:dscnt-type = 2 and
         objPromotion:dscnt-value-type = 1 and
         objPromotion:pmnt-types <> ? and trim(objPromotion:pmnt-types) <> ""
      then do :
          v-profile = 73 .
      end.
      else
      if objPromotion:dscnt-type = 2 and
         objPromotion:dscnt-value-type = 2 and
         objPromotion:pmnt-types <> ? and trim(objPromotion:pmnt-types) <> ""
      then do :
          v-profile = 74 .
      end.
      else
      if objPromotion:dscnt-type = 1 and
         objPromotion:dscnt-value-type = 1 and
         (trim(objPromotion:pmnt-types) = "" or objPromotion:pmnt-types = ?)
      then do :
          v-profile = 28 .
      end.
      else
      if objPromotion:dscnt-type = 3 and
         objPromotion:dscnt-value-type = 1 and
         (trim(objPromotion:pmnt-types) = "" or objPromotion:pmnt-types = ?)
      then do :
          v-profile = 20 .
      end.
      else
      if objPromotion:dscnt-type = 3 and
         objPromotion:dscnt-value-type = 1 and
         objPromotion:pmnt-types <> ? and trim(objPromotion:pmnt-types) <> ""
      then do :
          v-profile = 42 .
      end.
      else
      if objPromotion:dscnt-type = 3 and
         objPromotion:dscnt-value-type = 2 and
         objPromotion:pmnt-types <> ? and trim(objPromotion:pmnt-types) <> ""
      then do :
          v-profile = 43 .
      end.
      else do :
          Msg = "Не верная комбинация параметров типов скидки, типов значния скидки и кодов типов платежей. Промоакция с номером " + objPromotion:code_ .
          return false .
      end.
      
      run ref/imp-promotion-1C-RN.p (input objPromotion,
                                     input v-profile) no-error.
      if error-status:error
      then do :
          Msg = "Ошибка при загрузке промоакции с номером " + objPromotion:code_ + " .   " + return-value .
          return false.
      end.                                
      
      return true .
  end method.    
    
end class.