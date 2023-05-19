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
using ibs.th.gbl.sys.objth.

class ibs.th.skt.Commands.markingcmd inherits objth implements ICommand: 
  define override public property vss-revision    as character no-undo init "$Revision:$":U get .
  define override public property vss-author      as character no-undo init "$Author:$":U get.
  define override public property vss-date        as character no-undo init "$Date:$":U get.
  define override public property vss-workfile    as character no-undo init "$Workfile:$":U get.
  define override public property vss-archive     as character no-undo init "$Archive:$":U get.
  define override public property vss-description as character no-undo init "обработчик команд по маркам через сокет" get.
 
  &scop CRLF chr(13) + chr(10)
  &scop HdEnd chr(13) + chr(10) + chr(13) + chr(10)

  define public property ErrStatus as logical no-undo 
    get.
    set. 

  define public property LogMsg as character no-undo 
    get.
    private set. 

  define private variable marking     as class  marking no-undo.
  define private variable logWrite    as class     LogWrite no-undo.
  define private variable hndlSocket as handle no-undo.

  method public void Execute_( input req as ibs.th.skt.Commands.IRequest, output resp as class IResponse ):
    
    resp = new SimpleResponse().
    
    logWrite = new LogWrite().
    marking = new marking().
    hndlsocket = cast(req, ibs.th.skt.Commands.SimpleRequest):HndlSocket.
    marking:hndler(cast(req, ibs.th.skt.Commands.SimpleRequest)).
    writeSock(marking:SomeStr).

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
    LogWrite:LogStr = LogWrite:LogStr + " " + string (marking:SomeStr).
    set-size(mbuffer1) = length (marking:SomeStr, "RAW":U).    
    copy-lob
      from object marking:SomeStr
      to object mbuffer1
      convert target codepage "UTF-8".
    assign
      glog = hndlsocket:write(mbuffer1,1,get-size(mbuffer1)) no-error.
    if not glog
      then do:
        LogWrite:LogStr = LogWrite:LogStr + " " + "Ошибка при отправке сообщения удаленному клиенту.".
        ErrStatus = true.
        undo.
      end.
    return true.
      
  end method.

end class.
