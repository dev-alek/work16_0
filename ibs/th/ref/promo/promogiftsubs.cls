/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$
 
Коллекция объектов подарков акции

Автор: Рубан Дмитрий Андреевич
Дата создания: 11/07/18
Author: 
Creation date: 11/07/18

*/

using Progress.Lang.*.
using ibs.th.gbl.collection.*.
using ibs.th.ref.promo.*.


class ibs.th.ref.promo.promoGiftSubs inherits asubjects: 
define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo initial "Коллекция объектов подарков акции.". 
   
  define property promoGiftObjCurr as class promoGiftSub
    get:
      return cast (SubjectObjCurr, promoGiftSub). 
    end.

end class.
