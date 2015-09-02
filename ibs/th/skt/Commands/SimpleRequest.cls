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

class ibs.th.skt.Commands.SimpleRequest implements IRequest: 

  define public property Content as longchar no-undo 
    get.
    set.

  define public property HndlSocket as handle no-undo 
    get.
    set.

end class.