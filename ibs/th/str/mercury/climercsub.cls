/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Сущность TH клиент меркурия


Автор: Морозов Александр Сергеевич
Дата создания: 04/23/18
Author: Morozov Alexandr
Creation date: 04/23/18


*/

using Progress.Lang.*.
using ibs.th.str.clients.*.
using ibs.th.str.gds.*.
using ibs.th.gbl.storage.*.


class ibs.th.str.mercury.climercsub implements ithsub: 

  define property GUID_ as integer no-undo
    get.
    set.

end class.