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

class ibs.th.bge.1crn.import.imppayment-type-group implements ibs.th.bge.1crn.import.iimpsubject: 
  
  { cmp/str-glbl.i class }
  
  
  define property Msg as character no-undo
    get. 
    set.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/

  method public logical Excute( subjectObj as class ibs.th.bge.1crn.subjects.isubject ):
		
    def var v-rec  as recid     no-undo .
    def var v-mode as character no-undo .
    
    define variable objPaymentTypeGroup as class payment-type-group no-undo.
    
    objPaymentTypeGroup = cast (subjectObj, payment-type-group).

		if objPaymentTypeGroup:del-f = 1 then do:
		  /*проверять не используется ли данные где-то в другом месте - не сделано*/
		  Msg = "Физическое удаление в базе не реализовано".
/*		  find first ub.pay-type where ub.pay-type.obj-code = integer(objPaymentTypeGroup:code_) no-error .*/
/*      if AVAILABLE ub.pay-type then do:                                                              */
/*        delete ub.pay-type .                                                                         */
/*      end.  		                                                                                       */
		end.  
		else do:
      find first ub.pay-type where ub.pay-type.obj-code = integer(objPaymentTypeGroup:code_) no-error .
      if AVAILABLE ub.pay-type then do:
        assign
          v-mode = {&update}
          v-rec = recid (ub.pay-type) 
          .
      end.
      else do:
        assign
          v-mode = {&add-def}
          v-rec = ?
        .
      end.      
   run ref/paytype1.p
     ( input-output v-rec
     , input v-mode
     , input yes /* p-silent */
     , input objPaymentTypeGroup:code_
     , input objPaymentTypeGroup:name_
     ) no-error.
        if error-status:error then do:
          Msg = return-value.
          return false.
        end.
		return true.
    end.
	end method.

end class.