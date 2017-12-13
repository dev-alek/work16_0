/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Класс ипорта данных business-units из 1С

Автор: Александр Морозов
Дата создания: 26/09/17
Author: Morozov Alexandr
Creation date: 26/09/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.*.

class ibs.th.bge.1crn.import.impbusiness-units: 
  
  { cmp/str-glbl.i class }
  
  
  define property Msg as character no-undo
    get. 
    set.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public logical Excute( objBusiness as class business-units ):
	
		
    define buffer buf_regions for regions.


    on write  of ub.regions override 
      do: 
      end.
    on delete of ub.regions override 
      do: 
      end.

    do
      on error undo, return error
      :

      if objBusiness:del-f = 1 then 
      do:
        for each buf_regions exclusive-lock where 
          buf_regions.reg-code = integer (objBusiness:code_):
          delete buf_regions.
        end.
      end.
      else 
      do:
        find first buf_regions exclusive-lock where 
          buf_regions.reg-code = integer (objBusiness:code_) no-error .
        if AVAILABLE buf_regions then 
        do:
          assign
            buf_regions.reg-name = objBusiness:name_
            buf_regions.status_  = objBusiness:del-l
            .
        end.
        else 
        do:  
          create buf_regions.
          assign
            buf_regions.reg-code = integer (objBusiness:code_)
            buf_regions.reg-name = objBusiness:name_
            buf_regions.status_  = objBusiness:del-l
            .
        end.
      end.  
    end.
  end method.

end class.