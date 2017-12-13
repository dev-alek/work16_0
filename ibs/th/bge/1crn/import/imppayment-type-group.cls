/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Класс ипорта данных payment-type-group из 1С

Автор: Елена Шкляр
Дата создания: 26/09/17
Author: Shklyar Elena
Creation date: 26/09/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.*.

class ibs.th.bge.1crn.import.imppayment-type-group: 
  
  { cmp/str-glbl.i class }
  
  
  define property Msg as character no-undo
    get. 
    set.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/

	method public logical Excute( objPaymentTypeGroup as class payment-type-group ):
		
		def var v-rec as recid no-undo .

		if objPaymentTypeGroup:del-f = 1 then do:
		  /*проверять не используется ли данные где-то в другом месте - не сделано*/
		  
		  find first ub.pay-type where ub.pay-type.obj-code = integer(objPaymentTypeGroup:code_)
		                           and ub.pay-type.obj-name = objPaymentTypeGroup:name_ no-error .
      if AVAILABLE ub.pay-type then do:
        delete ub.pay-type .
      end.  		                          
		end.  
		else do:
      find first ub.pay-type where ub.pay-type.obj-code = integer(objPaymentTypeGroup:code_) no-error .
      if AVAILABLE ub.pay-type then do:
   run ref/paytype1.p
     ( input-output v-rec
     , input {&update}
     , input no /* p-silent */
     , input objPaymentTypeGroup:code_
     , input objPaymentTypeGroup:name_
     ) no-error.
     
        if error-status:error then do:
          Msg = return-value.
          return false.
        end.
      end.                                
      else do:		
   run ref/paytype1.p
     ( input-output v-rec
     , input {&add-def}
     , input no /* p-silent */
     , input objPaymentTypeGroup:code_
     , input objPaymentTypeGroup:name_
     ) no-error.
        if error-status:error then do:
          Msg = return-value.
          return false.
        end.
      end.
		return true.
    end.
	end method.

end class.