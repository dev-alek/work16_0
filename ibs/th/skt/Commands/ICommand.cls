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

using ibs.th.skt.Commands.*.
using ibs.th.gbl.sys.objth.

class ibs.th.skt.Commands.ICommand inherits objth abstract :
  
  method public  void Execute_(req as class IRequest, resp as class IResponse): 
    return error "Данный метод абстрактный".
  end.
  
  method public void ContinueExecution(req as class IRequest,resp as class IResponse ):
/*     resp:condition = resp:STSlist:WriteResponse:NameProp.
     define variable sss as longchar no-undo.
     define variable vvv as integer no-undo.
     
     sss = "Жизнь удалась111".
     resp:setContent(sss). */
  end.

end class.