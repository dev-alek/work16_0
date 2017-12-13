/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Класс ипорта данных currency из 1С

Автор: Елена Шкляр
Дата создания: 26/09/17
Author: Shklyar Elena
Creation date: 26/09/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.*.

class ibs.th.bge.1crn.import.impcurrency: 
  
  { cmp/str-glbl.i class }
  
  
  define property Msg as character no-undo
    get. 
    set.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/

	method public logical Excute( objCurrency as class currency ):
		
		def var v-rec as recid no-undo .
		def var v-curr-code as integer no-undo .
		if objCurrency:del-f = 1 then do:
		  /*проверять не используется ли данные где-то в другом месте - не сделано*/
		  
		  find first ub.currency where ub.currency.okv-code = integer(objCurrency:code_) no-error .
      if AVAILABLE ub.currency then do:
        delete ub.currency .
      end.  		                          
		end.  
		else do:
      find first ub.currency where ub.currency.okv-code = integer(objCurrency:code_) no-error .
      if AVAILABLE ub.currency then do:
        v-rec = recid(ub.currency) .
        run ref/currenc1.p (
         input-output v-rec
        ,input {&update}
        ,input false /* p-silent */
        ,input ub.currency.curr-code
        ,input objCurrency:sym-name
        ,input ub.currency.part-abbr
        ,input objCurrency:name_
        ,input ub.currency.curr-name-one
        ,input ub.currency.curr-name-three
        ,input ub.currency.curr-name-five
        ,input ub.currency.curr-eng-name
        ,input ub.currency.curr-eng-name-one
        ,input ub.currency.curr-eng-name-three
        ,input ub.currency.curr-eng-name-five
        ,input ub.currency.part-name
        ,input ub.currency.part-name-one
        ,input ub.currency.part-name-three
        ,input ub.currency.part-name-five
        ,input objCurrency:code_
        ,input ""
        ) no-error .
        if error-status:error then do:
          Msg = return-value.
          return false.
        end.
      end.                                
      else do:		
       find last ub.currency no-error .
       if AVAILABLE ub.currency then do: 
       v-curr-code = ub.currency.curr-code + 1 .
       v-rec = recid(ub.currency) .
       end.
       else do: 
       v-curr-code = 0 .
       v-rec = ? . 
       end.
         
       run ref/currenc1.p (
         input-output v-rec
        ,input {&add-def}
        ,input false /* p-silent */
        ,input v-curr-code
        ,input objCurrency:sym-name
        ,input ""
        ,input objCurrency:name_
        ,input ""
        ,input ""
        ,input ""
        ,input ""
        ,input ""
        ,input ""
        ,input ""
        ,input ""
        ,input ""
        ,input ""
        ,input ""
        ,input objCurrency:code_
        ,input ""
        ) no-error .
        if error-status:error then do:
          Msg = return-value.
          return false.
        end.
      end.
		return true.
    end.
	end method.

end class.