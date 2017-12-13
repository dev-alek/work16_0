/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$



Автор: Шкляр Елена Львовна
Дата создания: 01/30/15
Author: Elena Shklyar
Creation date: 01/30/15

*/

using Progress.Lang.*.


class ibs.th.str.placelib: 

  define property ReturnMsg as character no-undo
    get.
    private set.

  define variable hndl-proc-placelib as handle.
 
  constructor public placelib ():
    
    run str\placelib.p persistent (output hndl-proc-placelib) no-error.
    
  end constructor.

  method public void placelib_get-attr (  
         input p-code as character,
         input p-obj-code as integer,
         input p-obj-type as character,
         input p-pl-code  as integer,
         output v-value   as character,
         output p-ok      as logical):
    
    run placelib_get-attr in hndl-proc-placelib (   
         input p-code,
         input p-obj-code,
         input p-obj-type,
         input p-pl-code,
         output v-value,
         output p-ok) no-error.
    
    if error-status:error
      then 
    do:
      
    end.
    
  end.

  destructor public placelib ():
    
    delete object hndl-proc-placelib no-error.
    
    if error-status:error
      then 
    do:
      
    end.
    
  end destructor.
  

end class.