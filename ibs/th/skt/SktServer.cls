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

class ibs.th.skt.SktServer: 


  /*------------------------------------------------------------------------------
   Purpose: методы для работы сокет-сервера
   Notes:
  ------------------------------------------------------------------------------*/

  define private variable clientControl as class     ClientControl no-undo.
  define private variable clientList    as character no-undo init "TSD,TableMenu,Ticked,kiosk". /*список клиентов через запятую, с которыми работает сокет-сервер*/

  define private variable req           as class     IRequest      no-undo.
  define private variable resp          as class     IResponse     no-undo.
  define private variable client_       as character no-undo.

  define public property LogMsg as character no-undo
    get.
    set.
  
  /*------------------------------------------------------------------------------
   Purpose: При созаднии объекта SKTServer создадим комманды (т.е. объекты с набором комманд для конкретных клиентов) для всех клиентов сокет-сервера
   Notes:
  ------------------------------------------------------------------------------*/
  constructor SktServer (  ):
		
    define variable conf-par   as character no-undo .  /* для чтения параметра конфигурации */
    define variable par-type   as character no-undo .  /* тип параметра конфигурации */
    define variable tsdCommand    as class TSDCommand.
    define variable tickedCommand as class TickedCommand.
    define variable tmCommand     as class TableMenuCommand.
    define variable kioskCommand  as class KioskCommand.
		
    clientControl = new ClientControl(). /*количество возможных комманд соответсвует кол-ву клиентов*/
    
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

  end constructor.

  
  /*------------------------------------------------------------------------------
   Purpose: Публичный метод, который все что нужно дальше делает с контентом. Его и вызываем для обработки контента.
   Notes:
  ------------------------------------------------------------------------------*/
  method public memptr RequestProcessing (content as longchar, hndlSocket as handle):
    req = new SimpleRequest().
    resp = new SimpleResponse().
    cast(req, ibs.th.skt.Commands.SimpleRequest):Content = content.
    cast(req, ibs.th.skt.Commands.SimpleRequest):HndlSocket = hndlSocket.
    identifyClients().
    if client_ <> ? then 
    do:
      resp = clientControl:SendRequest(lookup (client_,clientList), req) no-error.
      if error-status:error then 
      do:
        return error return-value.
      end.
      return ? /*cast(resp, ibs.th.skt.Commands.SimpleResponse):Content*/.
    end.
    delete object req no-error.
    delete object resp no-error.
  end.

  method private void identifyClients ():
    define variable hRoot   as handle.
    define variable hDoc    as handle.
    def    var      mbuffer as memptr.

    if not (cast(req, ibs.th.skt.Commands.SimpleRequest):Content matches '*<data req="gds"*' or cast(req, ibs.th.skt.Commands.SimpleRequest):Content matches '*<data req="grp"*')
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
        
    end.
    
    /*далее случаи не по стандарту*/    
    if lookup (client_,clientList) = 0 then 
    do:
      if cast(req, ibs.th.skt.Commands.SimpleRequest):Content matches '*<data req="gds"*' or cast(req, ibs.th.skt.Commands.SimpleRequest):Content matches '*<data req="grp"*' 
        then 
      do:
        client_ = "TableMenu".
      end.
      else 
      do: 
        client_ = "ticked".
      end.
    end.

  end.


end class.