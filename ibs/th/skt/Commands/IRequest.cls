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

using ibs.th.skt.ControlledClients.*.

class ibs.th.skt.Commands.IRequest abstract:  

define public property Content as longchar no-undo 
    get.
    set.

  define public property ContentBuff as memptr no-undo 
    get.
    set.

  define public property QueryPar as character no-undo 
    get.
    set.

  define public property ContentObj as class content no-undo 
    get.
    set.

  define public property HndlSocket as handle no-undo 
    get.
    set.
  
end class.