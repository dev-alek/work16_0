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

class ibs.th.skt.Commands.markingcmd inherits ICommand: 
  define override public property vss-revision    as character no-undo init "$Revision:$":U get .
  define override public property vss-author      as character no-undo init "$Author:$":U get.
  define override public property vss-date        as character no-undo init "$Date:$":U get.
  define override public property vss-workfile    as character no-undo init "$Workfile:$":U get.
  define override public property vss-archive     as character no-undo init "$Archive:$":U get.
  define override public property vss-description as character no-undo init "обработчик команд по маркам через сокет" get.
 
  &scop CRLF chr(13) + chr(10)
  &scop HdEnd chr(13) + chr(10) + chr(13) + chr(10)


  define public property LogMsg as character no-undo 
    get.
    private set. 

   /*------------------------------------------------------------------------------
    Purpose:
    Notes:
   ------------------------------------------------------------------------------*/
   define private variable marking     as class  marking no-undo.
      
   constructor public markingcmd (  ):
      super ().
      marking = new marking().
   end constructor.

  
  define private variable hndlSocket as handle no-undo.

  method public override void Execute_( input req as ibs.th.skt.Commands.IRequest, resp as class IResponse ):
    
    do transaction:
       hndlsocket = req:HndlSocket.
       marking:hndler(req).
       if not writeSock(marking:SomeStr)
       then
          undo, return.
       /* обновляем, если надо, CDN площадки */             
       else if marking:CheckCdnNeedUpd() then 
       do:           
          run utl/pub-runcdn.p .
       end.    
       
    end.

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
    set-size(mbuffer1) = length (marking:SomeStr, "RAW":U).    
    copy-lob
      from object marking:SomeStr
      to object mbuffer1
      convert target codepage "UTF-8".
    if not hndlSocket:connected()
    then do:
       LogWrite:LogStr = " " + "Клиент отключился.".
       return false.
    end.
    glog = hndlsocket:write(mbuffer1,1,get-size(mbuffer1)).
    if not glog
       or hndlsocket:bytes-written ne get-size(mbuffer1)
    then do:
        set-size(mbuffer1) = 0.
        LogWrite:WriteFileToLog("Ошибка при отправке сообщения удаленному клиенту.").
        return false.
    end.
    set-size(mbuffer1) = 0.
    LogWrite:LogStr = LogWrite:LogStr + " " + string (marking:SomeStr).
    return true.
      
  end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	destructor public markingcmd ( ):
      delete object marking.
	end destructor.

end class.
