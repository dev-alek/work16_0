/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Обработчик контента атд клиента.


Автор: Морозов Александр Сергеевич
Дата создания: 08/05/18
Author: Alexandr Morozov
Creation date: 08/05/18

*/


using Progress.Lang.*.
using ibs.th.skt.Commands.*.
using ibs.th.skt.ControlledClients.*.
using ibs.th.skt.*.
using ibs.th.skt.Adapters.*.


class ibs.th.skt.ControlledClients.atdclient : 
  
  {cmp/str-glbl.i class}
  {str/lib-trn.i class}
  
  define private variable logWrite as class LogWrite no-undo.

  define public property SomeStr as longchar no-undo /* сюда писать если что-то отправить*/
    get.
    set.

  constructor public atdclient (  ):
   
    logWrite = new LogWrite().
       
  end.
  
  method public void hndler (req as class ibs.th.skt.Commands.SimpleRequest):
    define variable vExp as class ibs.th.bge.atd.dict-atd-exp no-undo.
 
    define buffer bclients    for ub.clients.

    find first bclients where bclients.obj-type = 'маг'
                          and bclients.db-num   = ibs.th.gbl.gbl-var:g#db-num
                          and bclients.stts     = 0 
    no-lock no-error.
    if available bclients then do:
       vExp = new ibs.th.bge.atd.dict-atd-exp(bclients.db-num,
                                              bclients.obj-type,
                                              bclients.obj-code).
   
       LogWrite:LogStr = substitute("Обработка &1:&2:&3:&4:&5",
                                    "atdclient",
                                    req:QueryPar,
                                    bclients.db-num,
                                    bclients.obj-type,
                                    bclients.obj-code).
       
       req:Content.
       case req:QueryPar:
         when "GetObj"       
           then SomeStr = vExp:GetNObjectTable().
         when "GetCashDesk"  
           then SomeStr = vExp:GetNCassaTable().
         when "GetFuel"      
           then SomeStr = vExp:GetReCodesTable().
         when "GetTank"      
           then SomeStr = vExp:GetNTankTable().
         otherwise SomeStr = "".
       end case.
          
       delete object vExp.
    end. 
  end method.
  
  
end class.
  
