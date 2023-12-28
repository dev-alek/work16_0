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

class ibs.th.skt.Commands.TableMenuCommand inherits ICommand: 
  define override public property vss-revision    as character no-undo init "$Revision:$":U get .
  define override public property vss-author      as character no-undo init "$Author:$":U get.
  define override public property vss-date        as character no-undo init "$Date:$":U get.
  define override public property vss-workfile    as character no-undo init "$Workfile:$":U get.
  define override public property vss-archive     as character no-undo init "$Archive:$":U get.
  define override public property vss-description as character no-undo init "Обработка запросов в сокет сервер для TableMenu" get.
  &scop CRLF chr(13) + chr(10)
  &scop HdEnd chr(13) + chr(10) + chr(13) + chr(10)

  define public property ErrStatus as logical no-undo 
    get.
    set. 

  define public property LogMsg as character no-undo 
    get.
    set. 

   /*------------------------------------------------------------------------------
    Purpose:
    Notes:
   ------------------------------------------------------------------------------*/
   define         variable tm         as class  TableMenu no-undo.  
   constructor public TableMenuCommand (  ):
      super ().
      tm = new TableMenu().
   end constructor.
  
  
  define private variable hndlSocket as handle no-undo.

  method override public void Execute_( input req as ibs.th.skt.Commands.IRequest, input resp as class IResponse ):
		
    
    hndlsocket = req:HndlSocket.
    case true:
      when req:Content matches '*<data req="grp"*' then 
        do:
          tm:WriteCSVGrp().
        end.
      when req:Content matches '*<data req="gds"*' then 
        do:
          tm:WriteCSVGds(req:Content).
        end.
    end case.
    resp:Content-Type = "application/json".
    resp:setContent(tm:SomeStr).
    resp:condition = resp:STSlist:WriteResponse:NameProp.   
    
  end method.
 

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	destructor public TableMenuCommand ( ):
      delete object tm.
	end destructor.

 
end class.