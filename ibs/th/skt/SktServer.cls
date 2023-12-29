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

 
/*------------------------------------------------------------------------
   File        : skt-sevice
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : Admin
   Created     : Fri Jan 30 19:32:02 MSK 2015
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.skt.Commands.*.
using ibs.th.skt.ControlledClients.*.
using ibs.th.skt.*.
using ibs.th.skt.Adapters.*.

class ibs.th.skt.SktServer: 


  /*------------------------------------------------------------------------------
   Purpose: методы для работы сокет-сервера
   Notes:
  ------------------------------------------------------------------------------*/

  define private variable clientControl as class     ClientControl no-undo.
  define private variable clientList    as character no-undo init "TSD,TableMenu,Ticked,kiosk,websrv,atdclient,ThGetInfo,AuthMarking,DeferredCommand". /*список клиентов через запятую, с которыми работает сокет-сервер*/

  define private variable req           as class     IRequest      no-undo.
  define private variable resp          as class     IResponse     no-undo.
  define private variable client_       as character no-undo.
  define private variable hLog          as handle no-undo.
  define public property LogMsg as character no-undo
    get.
    set.
  define private variable logWrite as class   LogWrite no-undo.

  define public property QueryParam as character no-undo
    get.
    set.

  define public property Path as character no-undo
    get.
    set.

  define public property ClientPar as character no-undo
    get.
    set.
  
  /*------------------------------------------------------------------------------
   Purpose: При созаднии объекта SKTServer создадим комманды (т.е. объекты с набором комманд для конкретных клиентов) для всех клиентов сокет-сервера
   Notes:
  ------------------------------------------------------------------------------*/
  constructor SktServer (  ):
     this-object(?).
  end.
  constructor SktServer (iLog as handle  ):
	 hLog = iLog.	
    define variable conf-par   as character no-undo .  /* для чтения параметра конфигурации */
    define variable par-type   as character no-undo .  /* тип параметра конфигурации */
    define variable tsdCommand    as class TSDCommand.
    define variable tickedCommand as class TickedCommand.
    define variable tmCommand     as class TableMenuCommand.
    define variable kioskCommand  as class KioskCommand.
    define variable webCommand    as class webCommand.
    define variable atdclientcmd  as class atdclientcmd.
    define variable AuthMarking   as class markingcmd.
    define variable DeferredCommand   as class DeferredCommand.
		
    clientControl = new ClientControl(hLog). /*количество возможных комманд соответсвует кол-ву клиентов*/
    logWrite = new LogWrite().
    /*создадим объекты конкретных комманд для клиентов сокет-сервера. вешаем комманду на порядковый номер клиента в списке*/
    run gbl/conf-rd.p ("is-tsd", "", "", 0, "", "", "", no, output conf-par, output par-type) no-error.
    if logical (conf-par) then do:
      tsdCommand = new TSDCommand().
      clientControl:SetCommandForClient(lookup("TSD",clientList), tsdCommand).
    end.
    run gbl/conf-rd.p ("ser-wth", "", "", 0, "", "", "", no, output conf-par, output par-type) no-error.
    if logical (conf-par) then do:
      tickedCommand = new TickedCommand().
      clientControl:SetCommandForClient(lookup("Ticked",clientList), tickedCommand).
    end.
    tmCommand = new TableMenuCommand().
    clientControl:SetCommandForClient(lookup("TableMenu",clientList), tmCommand).
    run gbl/conf-rd.p ("is-byscr", "", "", 0, "", "", "", no, output conf-par, output par-type) no-error.
    if logical (conf-par) then do:
      kioskCommand = new KioskCommand().
      clientControl:SetCommandForClient(lookup("kiosk",clientList), kioskCommand).
    end.
    run gbl/conf-rd.p ("is-wbsrv", "", "", 0, "", "", "", no, output conf-par, output par-type) no-error.
    if logical (conf-par) then do:
      webCommand = new webCommand().
      clientControl:SetCommandForClient(lookup("websrv",clientList), webCommand).
    end.
    atdclientcmd = new atdclientcmd ().
    clientControl:SetCommandForClient(lookup("atdclient",clientList), atdclientcmd).
    
    AuthMarking = new markingcmd ().
    clientControl:SetCommandForClient(lookup("AuthMarking",clientList), AuthMarking).
    
    DeferredCommand = new DeferredCommand ().
    clientControl:SetCommandForClient(lookup("DeferredCommand",clientList), DeferredCommand).
    
  end constructor.

  
  /*------------------------------------------------------------------------------
   Purpose: Публичный метод, который все что нужно дальше делает с контентом. Его и вызываем для обработки контента.
   Notes:
  ------------------------------------------------------------------------------*/
  method public void RequestProcessing (content as longchar, hndlSocket as handle):
    define variable vDelete as logical no-undo.
    req = new SimpleRequest().
    resp = new SimpleResponse().
    req:Content = content.
    req:HndlSocket = hndlSocket.
    if QueryParam <> ""
      then req:QueryPar = QueryParam.
    identifyClients().
    if client_ <> ? then 
    do:
      vDelete = clientControl:SendRequest(lookup (client_,clientList), req, resp) no-error.
      if error-status:error then 
      do:
        logWrite:LogStr = return-value.
        vDelete = yes.
      end.
    end.
    if vDelete
    then do:
       delete object req  no-error.
       delete object resp no-error.
       hndlSocket:disconnect ().
    end.
  end.
  
  /*------------------------------------------------------------------------------
   Purpose: Публичный метод, который все что нужно дальше делает с контентом. Его и вызываем для обработки контента.
   Notes:
  ------------------------------------------------------------------------------*/
  method public void RequestProcessing (content as memptr, hndlSocket as handle, lpar as character):
    define variable vDelete as logical no-undo.
    req = new SimpleRequest().
    resp = new SimpleResponse().
    req:ContentBuff = content.
    req:HndlSocket = hndlSocket.
    identifyClients().
    client_ = "tsd".
    if client_ <> ? then 
    do:
      vDelete = clientControl:SendRequest(lookup (client_,clientList), req, resp, lpar) no-error.
      if error-status:error then 
      do:
        logWrite:LogStr = return-value.
        vDelete = yes.
      end.
/*      return ? /*cast(resp, ibs.th.skt.Commands.SimpleResponse):Content*/.*/
    end.
    if vDelete
    then do:
       delete object req no-error.
       delete object resp no-error.
       hndlSocket:disconnect ().
    end.
  end.

  method private void identifyClients ():
    define variable hRoot   as handle.
    define variable hDoc    as handle.
    def    var      mbuffer as memptr.

    if ClientPar <> ""
    then do:
      client_ = ClientPar.
      return.
    end.
    else
       client_ = "".
    
    
    if not    req:Content matches '*<data req="gds"*' 
           or req:Content matches '*<data req="grp"*'
      then do:
    
      create x-document hDoc.
      create x-noderef  hRoot.    
      
      set-size(mbuffer) = 0.
      set-size(mbuffer) = length(cast(req, ibs.th.skt.Commands.SimpleRequest):Content,'raw') + 2.
      put-string(mbuffer,1) = cast(req, ibs.th.skt.Commands.SimpleRequest):Content.
      hDoc:load("memptr",mbuffer,no) no-error.
      if error-status:error
        then return error.
      hdoc:get-document-element(hRoot) no-error.
      assign
        client_ = hRoot:name no-error.
/*        logWrite:WriteFileToLog( req:Content).*/
    end.
    
    /*далее случаи не по стандарту*/    
    if lookup (client_,clientList) = 0 then 
    do:
      if    req:Content matches '*<data req="gds"*' 
         or req:Content matches '*<data req="grp"*' 
        then 
      do:
        client_ = "TableMenu".
        logWrite:WriteFileToLog( req:Content + chr(13) + chr(10)).
      end.
      else 
      do: 
        client_ = "ticked".
      end.
    end.

  end.

  method public logical checkEnd ():
     return clientControl:checkEnd().
  end.
	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	destructor public SktServer ( ):
    delete object logWrite.
    delete object clientControl no-error.
    
	end destructor.


end class.