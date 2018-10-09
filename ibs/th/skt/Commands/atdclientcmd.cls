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

class ibs.th.skt.Commands.atdclientcmd implements ICommand: 

  &scop CRLF chr(13) + chr(10)
  &scop HdEnd chr(13) + chr(10) + chr(13) + chr(10)

  define public property ErrStatus as logical no-undo 
    get.
    set. 

  define public property LogMsg as character no-undo 
    get.
    private set. 

  define private variable atdcli     as class  atdclient no-undo.
  define private variable logWrite    as class     LogWrite no-undo.
  define private variable hndlSocket as handle no-undo.

  method public void Execute_( input req as ibs.th.skt.Commands.IRequest, output resp as class IResponse ):
    
    resp = new SimpleResponse().
    
    logWrite = new LogWrite().
    atdcli = new atdclient().
    hndlsocket = cast(req, ibs.th.skt.Commands.SimpleRequest):HndlSocket.
    atdcli:hndler(cast(req, ibs.th.skt.Commands.SimpleRequest)).
    writeSock(atdcli:SomeStr).

  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method private logical writeSock ( arg as longchar ):
    
    define variable mbuffer  as memptr   no-undo.
    define variable mbuffer1 as memptr   no-undo.
    define variable tempStr  as longchar no-undo.
    define variable glog     as logical  no-undo.
    
    
    
    set-size(mbuffer1) = length (atdcli:SomeStr, "RAW":U) + 1.
    put-string(mbuffer1,1) = atdcli:SomeStr.        
    
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