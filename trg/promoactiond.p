/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$
 


Автор: Рубан Дмитрий Андреевич
Дата создания: 11/07/18
Author: Ruban Dmitriy
Creation date: 11/07/18

*/
TRIGGER PROCEDURE FOR DELETE OF ub.PromoAction.

define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo init "Тригер удаления PromoAction". 
{ cmp/vssrevis.i }
{ cmp/trg-def.i  }

do
on error undo, return ERROR:

   FOR EACH  ub.PromoCriterion WHERE ub.PromoCriterion.idAction EQ  ub.PromoAction.id
   EXCLUSIVE-LOCK:
       DELETE ub.PromoCriterion.
   END.
   
   FOR EACH  ub.PromoGift WHERE ub.PromoGift.idAction EQ  ub.PromoAction.id
   EXCLUSIVE-LOCK:
       DELETE ub.PromoGift.
   END.     
   
   FOR EACH  ub.PromoGoods WHERE ub.PromoGoods.idAction EQ  ub.PromoAction.id
   EXCLUSIVE-LOCK:
       DELETE ub.PromoGoods.
   END.
   FOR EACH  ub.PromoObject WHERE ub.PromoObject.idAction EQ  ub.PromoAction.id
   EXCLUSIVE-LOCK:
       DELETE ub.PromoObject.
   END.
END.
