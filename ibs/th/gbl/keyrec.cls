/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$



Автор: Морозов Александр Сергеевич
Дата создания: 01/30/15
Author: Alexandr Morozov
Creation date: 01/30/15

*/

using Progress.Lang.*.


class ibs.th.gbl.keyrec: 

  define property ReturnMsg as character no-undo
    get.
    private set.
  define property Err as logical  no-undo
    get.
    private set.
  define variable hndl-proc-key-rec as handle.
 
  constructor public keyrec ():
    
    run gbl\key-rec.p persistent (output hndl-proc-key-rec) no-error.
    
  end constructor.

  method public void GenKeyRec (  
    input  p-tbl-name    as character,
    input  p-bh_tbl-name as handle,    
    output p-key-rec     as character ):
    
    run gen-key-rec in hndl-proc-key-rec ( input p-tbl-name
                                          ,input p-bh_tbl-name
                                          ,output p-key-rec) no-error.
    
    if error-status:error
    then do:
      ReturnMsg = return-value.
      Err = true.
    end.
    
  end.
  
  method public void GenRowKeyr (
    input p-key-rec    as character,
    input p-key-handle as handle   , /* буфер записи которую будем искать. если ищем по key-rec то ? */
    input p-db-name    as character,
    input p-tt-handle  as handle   , /* буфер таблицы - если надо найти во временной таблице. если ищем в БД то ? */
    input p-stts-lock  as integer  , /* этот параметр игнорируется для временных таблиц */
    output p-tbl-row   as rowid    ,
    output p-tbl-name  as character
  ):
    
    run gen-row-keyr in hndl-proc-key-rec (  input p-key-rec
                                            ,input p-key-handle
                                            ,input p-db-name
                                            ,input p-tt-handle
                                            ,input p-stts-lock
                                            ,output p-tbl-row
                                            ,output p-tbl-name) no-error.
    
    if error-status:error
    then do:
      ReturnMsg = return-value.
      Err = true.
    end.
                                        
  end.
  
  method public void GenKkeyFv (
    input p-key-rec     as character,
    output p-field-list as character,
    output p-value-list as character
  ):
    
    run gen-key-fv in hndl-proc-key-rec ( input p-key-rec
                                         ,output p-field-list
                                         ,output p-field-list) no-error.

    if error-status:error
    then do:
      ReturnMsg = return-value.
      Err = true.
    end.
    
  end.
  
  destructor public keyrec ():
    
    delete object hndl-proc-key-rec no-error.
    
    if error-status:error
    then do:
      ReturnMsg = return-value.
      Err = true.
    end.
    
  end destructor.
  

end class.