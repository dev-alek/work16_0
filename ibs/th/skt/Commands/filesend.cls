using Progress.Lang.*.
using ibs.th.skt.Commands.*.
using ibs.th.skt.ControlledClients.*.
using ibs.th.skt.Adapters.*.
block-level on error undo, throw.
class ibs.th.skt.Commands.Filesend inherits ICommand:
   define override public property vss-revision    as character no-undo init "$Revision:$":U get .
   define override public property vss-author      as character no-undo init "$Author:$":U get.
   define override public property vss-date        as character no-undo init "$Date:$":U get.
   define override public property vss-workfile    as character no-undo init "$Workfile:$":U get.
   define override public property vss-archive     as character no-undo init "$Archive:$":U get.
   define override public property vss-description as character no-undo init "Обработка запросов в сокет сервер для отправки файлов" get.

   method override public void Execute_( input req as ibs.th.skt.Commands.IRequest, input resp as class IResponse ):
      resp:setFile(req:queryAdr,req:queryPar).
      resp:condition = resp:STSlist:WriteResponse:NameProp.
   end method.
  
end class.
