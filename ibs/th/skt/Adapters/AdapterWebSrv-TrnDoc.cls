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
using ibs.th.skt.Adapters.*. 


class ibs.th.skt.Adapters.AdapterWebSrv-TrnDoc implements IAdapter: 

  {ibs/th/skt/ControlledClients/websrvTT.i}

  define property StrLog as character no-undo
    get.
    set.


  define property UserId_ as character no-undo
    get.
    set.



  /*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
		
  method public void WriteDB (output glog as log):
    define variable ERR as logical no-undo init no .
    run ibs/th/skt/Adapters/AdapteeWebSrv-TrnDoc.p
      (
      input table TempTrnDoc,
      input table TempDocLine,
      input table TempDocAttr,
      input table TempGdsDtl,
      input table TempParts,
      output ERR
      ) no-error.
    if ERR then
    do:
      assign
        StrLog = return-value
        .
      glog = false.
    end.
    else
      glog = true.

  end method.
  
  method public void SetTempTable (input table TempTrnDoc,
                                   input table TempDocLine,
                                   input table TempGdsDtl,
                                   input table TempParts,
                                   input table TempDocAttr):
    
    
  end method.

end class.