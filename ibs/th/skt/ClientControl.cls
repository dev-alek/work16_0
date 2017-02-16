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
using ibs.th.skt.Adapters.*.

class ibs.th.skt.ClientControl: 

  define private temp-table ttCommands no-undo
    field numCmd as integer 
    field objCommand as class Progress.Lang.Object 
    .

  define private variable ii       as integer no-undo.
  define private variable logWrite as class   LogWrite no-undo.
	
  method public void SendRequest ( numcmd as int, req as class IRequest, resp as class IResponse ):
    
    logWrite = new LogWrite().
    
    find first ttCommands where ttCommands.numCmd = numcmd no-lock no-error.
    if not available (ttCommands) then 
    do:
      logWrite:LogStr = "Для данного клиента не создана комманда.".
      return error .
    end.
    cast(ttCommands.objCommand, ibs.th.skt.Commands.ICommand):Execute_(req, output resp).    
  end method.


  method public void SetCommandForClient ( numcmd as int, cmd as class ICommand ):
    ii = ii + 1.
    create ttCommands.
    assign
      ttCommands.numCmd = numcmd
      ttCommands.objCommand = cmd
      .
  end method.


end class.