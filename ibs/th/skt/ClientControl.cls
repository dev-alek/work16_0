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
block-level on error undo, throw.

class ibs.th.skt.ClientControl: 

  define private temp-table ttCommands no-undo
    field numCmd as integer 
    field objCommand as class Progress.Lang.Object 
    .
  define private temp-table ttDeferredCommands no-undo
    field objCommand as class Progress.Lang.Object
    field objreq     as class Progress.Lang.Object
    field objResp    as class Progress.Lang.Object 
    .
  define private variable ii       as integer no-undo.
  define private variable logWrite as class   LogWrite no-undo.
  define private variable hLog     as handle  no-undo.	
   /*------------------------------------------------------------------------------
    Purpose:
    Notes:
   ------------------------------------------------------------------------------*/
   define variable HTTPOK as longchar no-undo.
       
   constructor public ClientControl (ilog as handle  ):
      super ().
      hLog = iLog.
      logWrite = new LogWrite().
      HTTPOK = substitute("HTTP/1.1 200 OK&1Server: 4GL&1Content-Type: &3&1Content-Length: &4&2",
                         chr(13) + chr(10),
                         chr(13) + chr(10) + chr(13) + chr(10) , "&1","&2").
   end constructor.


  method public logical SendRequest ( numcmd as int, req as class IRequest, resp as class IResponse ):
    find first ttCommands where ttCommands.numCmd = numcmd no-lock no-error.
    if not available (ttCommands) then 
    do:
      logWrite:LogStr = "Для данного клиента не создана комманда.".
      return true.
    end.
    do transaction:
       cast(ttCommands.objCommand, ibs.th.skt.Commands.ICommand):Execute_(req, resp)no-error.
       if error-status:error
       then do:
          return error return-value + " " + error-status:get-message (1).
       end.
       if resp:condition eq resp:STSlist:WriteResponse:NameProp
       then do:
          if not writeSock(req:HndlSocket,resp)
          then
             undo, return error. 
       end.
       else if    resp:condition eq resp:STSlist:WaitResult:NameProp
               or resp:condition eq resp:STSlist:WriteStatusAndWait:NameProp
       then do:
          create ttDeferredCommands.
          assign
            ttDeferredCommands.objCommand = ttCommands.objCommand
            ttDeferredCommands.objreq     = req
            ttDeferredCommands.objResp    = resp
          .
          logWrite:LogStr = substitute ("Wait result Class: &1 Param: &2",resp, resp:ParamWait) .
          resp:condition = resp:STSlist:WaitResult:NameProp.
          return false.
       end.
    end.
    return true.
       
  end method.
  
  method public logical SendRequest ( numcmd as int, req as IRequest, resp as class IResponse, lpar as character ):
    find first ttCommands where ttCommands.numCmd = numcmd no-lock no-error.
    if not available (ttCommands) then 
    do:
      logWrite:LogStr = "Для данного клиента не создана комманда.".
      return true .
    end.
    do transaction:
       cast(ttCommands.objCommand, ibs.th.skt.Commands.TSDCommand):Execute_(req, resp, lpar) no-error.
       if error-status:error
       then
          return error return-value + " " + error-status:get-message (1).
       if resp:condition eq resp:STSlist:WriteResponse:NameProp
       then do:
          if not writeSock(req:HndlSocket,resp)
          then
             undo, return error. 
       end.
       else if    resp:condition eq resp:STSlist:WaitResult:NameProp
               or resp:condition eq resp:STSlist:WriteStatusAndWait:NameProp
       then do:
          create ttDeferredCommands.
          assign
            ttDeferredCommands.objCommand = ttCommands.objCommand
            ttDeferredCommands.objreq     = req
            ttDeferredCommands.objResp    = resp
          .
          logWrite:LogStr = substitute ("Wait result Class: &1 Param: &2",resp, resp:ParamWait) .
          resp:condition = resp:STSlist:WaitResult:NameProp.
          return false.
       end.
    end.
    return true.    
  end method.


  method public void SetCommandForClient ( numcmd as int, cmd as class ICommand ):
    ii = ii + 1.
    create ttCommands.
    assign
      ttCommands.numCmd = numcmd
      ttCommands.objCommand = cmd
      .
  end method.

  method public logical checkEnd ():
     define variable req  as ibs.th.skt.Commands.IRequest  no-undo.
     define variable resp as ibs.th.skt.Commands.IResponse no-undo.
     define variable vAvailProc as logical no-undo.
     for each ttDeferredCommands:
        req  = cast(ttDeferredCommands.objreq, ibs.th.skt.Commands.IRequest).
        resp = cast(ttDeferredCommands.objResp,ibs.th.skt.Commands.IResponse).
        block-check:
        do transaction:
           cast(ttDeferredCommands.objCommand, ibs.th.skt.Commands.ICommand):ContinueExecution (req,resp). 
           if resp:condition eq resp:STSlist:WriteResponse:NameProp
           then do:
              if not writeSock(req:HndlSocket,resp)
              then
                 undo block-check, leave block-check.
           end.
           if resp:condition eq resp:STSlist:WriteStatusAndWait:NameProp
           then do:
              if valid-handle (hlog)
              then
                 publish "write-to-log" from hLog (substitute ("Wait result Class: &1 Param: &2",resp, resp:ParamWait)) .
              resp:condition = resp:STSlist:WaitResult:NameProp.
           end.
           
           if resp:condition ne resp:STSlist:WaitResult:NameProp
              or  not req:HndlSocket:CONNECTED()
           then do:
              define variable resp-head as character no-undo.
              resp-head = if logWrite:LogStr <> "" then logWrite:LogStr else "OK".
              if valid-handle (hlog)
              then
                 publish "write-to-log" from hLog (substitute ("RESPONCE: Class: &1 end result: &2",resp ,resp-head)).
              logWrite:LogStr = "".
              req:HndlSocket:disconnect().
              delete object req.
              delete object resp.
              delete ttDeferredCommands.
              
           end.
           else
              vAvailProc = yes.
        end.
     end.
     return vAvailProc.
  end.
  
  method private logical writeSock (hndlsocket as handle, resp as ibs.th.skt.Commands.IResponse ):
    define variable glog     as logical  no-undo.
    
    define variable v-cont-length as integer no-undo.
    define variable VOK as longchar no-undo.
    define variable VrespOK as memptr no-undo.
    define variable vBytes as int64 no-undo.
    VOK = substitute (HTTPOK,resp:Content-Type,string(resp:ContentLength)).
    copy-lob
      from object VOK
      to object VrespOK
      convert target codepage "UTF-8".
    if not hndlSocket:connected()
    then do:
       LogWrite:WriteFileToLog("Клиент отключился.").
       return false.
    end.
    vBytes = hndlsocket:bytes-written. 
    glog = hndlsocket:write(VrespOK,1,get-size(VrespOK)).
    if    not glog
       or hndlsocket:bytes-written ne vBytes + get-size(VrespOK)
    then do:
       set-size(VrespOK) = 0.
       LogWrite:LogStr = LogWrite:LogStr + " " + "Ошибка при отправке сообщения удаленному клиенту.".
       return false.
    end.
    set-size(VrespOK) = 0.
    
    if not hndlSocket:connected()
    then do:
       LogWrite:WriteFileToLog("Клиент отключился.").
       return false.
    end.
    vBytes = hndlsocket:bytes-written. 
    glog = hndlsocket:write(resp:Content,1,get-size(resp:Content)).
    if    not glog
       or hndlsocket:bytes-written ne vBytes + get-size(resp:Content)
    then do:
       LogWrite:LogStr = LogWrite:LogStr + " " + "Ошибка при отправке сообщения удаленному клиенту.".
       return false.
    end.
    return true.
      
  end method.
	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	destructor public ClientControl ( ):
	 for each ttDeferredCommands:
	    cast(ttDeferredCommands.objreq,IRequest):HndlSocket:disconnect().
	    delete object ttDeferredCommands.objreq no-error.
       delete object ttDeferredCommands.objResp no-error.
       delete ttDeferredCommands.
	 end. 
    for each ttCommands:
      delete object ttCommands.objCommand no-error.
      delete ttCommands.
    end.
    delete object logWrite.
	end destructor.


end class.