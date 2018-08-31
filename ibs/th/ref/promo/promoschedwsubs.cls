/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

коллекция дней расписания промоакций

Автор: Молотков Сергей
Дата создания: 10/07/18
Author: Molotkov Sergey
Creation date: 10/07/18

*/

using Progress.Lang.*.
using ibs.th.gbl.collection.*.
using ibs.th.ref.promo.*.


class ibs.th.ref.promo.promoSchedwSubs inherits asubjects: 
define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo initial "Коллекция объектов расписания дней акции.". 
   
  define property promoSchedwObjCurr as class promoSchedwSub
    get:
      return cast (SubjectObjCurr, promoSchedwSub). 
    end.

end class.
