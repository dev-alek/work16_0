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

interface ibs.th.skt.Commands.ICommand :
  
  method public void Execute_(req as class IRequest, output resp as class IResponse).


end interface.