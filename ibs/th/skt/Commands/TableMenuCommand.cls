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
using ibs.th.skt.Commands.*.
using ibs.th.skt.ControlledClients.*.
using ibs.th.skt.Adapters.*.

class ibs.th.skt.Commands.TableMenuCommand implements ICommand: 

  &scop CRLF chr(13) + chr(10)
  &scop HdEnd chr(13) + chr(10) + chr(13) + chr(10)

  define public property ErrStatus as logical no-undo 
    get.
    set. 

  define public property LogMsg as character no-undo 
    get.
    set. 
  
  define         variable tm         as class  TableMenu no-undo.
  define private variable hndlSocket as handle no-undo.
  define private variable logWrite   as class  LogWrite  no-undo.

  method public void Execute_( input req as ibs.th.skt.Commands.IRequest, output resp as class IResponse ):
		
    logWrite = new LogWrite().
    tm = new TableMenu().
    hndlsocket = cast(req, ibs.th.skt.Commands.SimpleRequest):HndlSocket.
    case true:
      when cast(req, ibs.th.skt.Commands.SimpleRequest):Content matches '*<data req="grp"*' then 
        do:
          tm:WriteCSVGrp().
        end.
      when cast(req, ibs.th.skt.Commands.SimpleRequest):Content matches '*<data req="gds"*' then 
        do:
          tm:WriteCSVGds(cast(req, ibs.th.skt.Commands.SimpleRequest):Content).
        end.
    end case.
		
    writeSock("").
    
    
  end method.
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method private logical writeSock ( arg as character ):
    
    define variable mbuffer  as memptr   no-undo.
    define variable mbuffer1 as memptr   no-undo.
    define variable tempStr  as longchar no-undo.
    define variable glog     as logical  no-undo.
    
    set-size(mbuffer1) = length (tm:SomeStr, "RAW":U) + 1.
    put-string(mbuffer1,1) = tm:SomeStr.        

      
    tempStr = substitute("HTTP/1.0 200 OK&1Server: 4GL&1Content-Type: text/csv&1Content-Length: &3&2",{&CRLF},{&HdEnd},get-size(mbuffer1)).
    set-size(mbuffer) = 0.
    set-size(mbuffer) = length (tempStr, "RAW":U) + 1.
    put-string(mbuffer,1) = tempstr.
    assign
      glog = hndlsocket:write(mbuffer,1,length(tempStr,'RAW':U)) no-error.
    if not glog 
      then do:
        LogWrite:LogStr = LogWrite:LogStr + " " + "Ошибка при отправке сообщения удаленному клиенту.". 
        ErrStatus = true.
      end.
    assign
      glog = hndlsocket:write(mbuffer1,1,get-size(mbuffer1)) no-error.
    if not glog
      then do:
        LogWrite:LogStr = LogWrite:LogStr + " " + "Ошибка при отправке сообщения удаленному клиенту.".
        ErrStatus = true.
      end.
    return true.
    
      
  end method.

 
end class.