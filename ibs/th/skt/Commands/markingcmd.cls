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
   define temp-table tt-code no-undo like ub.code.
      
   constructor public markingcmd (  ):
      super ().
      marking = new marking().
   end constructor.

  
  define private variable hndlSocket as handle no-undo.

  method public override void Execute_( input req as ibs.th.skt.Commands.IRequest, resp as class IResponse ):
    def buffer buf_code for ub.code.
    
    empty temp-table tt-code.
    
    do transaction:
       hndlsocket = req:HndlSocket.
       marking:hndler(req).
       if not writeSock(marking:SomeStr)
       then do:  
         find first buf_code where 
                     buf_code.parent eq "GisMt"
                 and buf_code.code   eq "GisMtErr"
         no-lock no-error.
         if avail buf_code then do:
             create tt-code.
             buffer-copy buf_code to tt-code.
         end.
         for each buf_code no-lock where 
                  buf_code.parent = "CDN_GisMt":
             create tt-code.
             buffer-copy buf_code to tt-code.         
         end.                                    
         undo.
       end.                     
    end.
    do transaction:
        for each tt-code:
           find first buf_code where 
                      buf_code.parent = tt-code.parent 
                  and buf_code.code   = tt-code.code
              exclusive-lock no-wait no-error.
           if avail buf_code then do:
               buffer-copy tt-code to buf_code no-error.
           end.    
        end.    
    end.
    /* обновляем, если надо, CDN площадки */             
    if marking:CheckCdnNeedUpd() then 
    do:           
      run utl/pub-runcdn.p .
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
