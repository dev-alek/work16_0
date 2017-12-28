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


class ibs.th.gbl.ggoattr: 

  define property ReturnMsg as character no-undo
    get.
    private set.

  define variable hndl-proc-ggoattr as handle.
 
  constructor public ggoattr ():
    
    run gbl\ggoattr.p persistent (output hndl-proc-ggoattr) no-error.
    
  end constructor.

  method public void ggoattr-code (  
    input  p-code           as character, /* код атрибута */
    output p-type           as character, /* тип атрибута */
    output p-format         as character, /* формат атрибута */
    output p-label          as character, /* лабел атрибута */
    output p-user-can-edit  as logical  , /* пользователь может изменять в броусе */
    output p-output-display as logical  , /* виден в броусе */
    output p-other          as character  /* еще чего - нибудь */
  
    ):
    
    run ggoattr-code in hndl-proc-ggoattr (   
      input  p-code,
      output p-type,
      output p-format,
      output p-label,
      output p-user-can-edit,
      output p-output-display,
      output p-other 
      ) no-error.
    
    if error-status:error
      then 
    do:
      
    end.
    
  end.
  

  method public void ggoattr-write (  
    input  p-node-code as integer,
    input  p-host-code as integer,
    input  p-obj-type  as character,
    input  p-obj-code  as integer, 
    input p-code  as character,
    input p-value as character
    ):
    
    run ggoattr-write in hndl-proc-ggoattr (   
      input  p-node-code,
      input  p-host-code,
      input  p-obj-type,
      input  p-obj-code, 
      input p-code,
      input p-value
      ) no-error.
    
    if error-status:error
      then 
    do:
      
    end.
    
  end.
  
  
  method public void ggoattr-delete (  
    input  p-node-code as integer,
    input  p-host-code as integer,
    input  p-obj-type  as character,
    input  p-obj-code  as integer, 
    input p-code  as character,
    input p-deleted as logical
    ):
    
    run ggoattr-delete in hndl-proc-ggoattr (   
      input  p-node-code,
      input  p-host-code,
      input  p-obj-type,
      input  p-obj-code, 
      input p-code,
      input p-deleted
      ) no-error.
    
    if error-status:error
      then 
    do:
      
    end.
    
  end.  
          
  destructor public ggoattr ():
    
    delete object hndl-proc-ggoattr no-error.
    
    if error-status:error
      then 
    do:
      
    end.
    
  end destructor.
  

end class.