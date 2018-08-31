/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

статусы промо-акций

Автор: Молотков Сергей
Дата создания: 11/07/18
Author: Molotkov Sergey
Creation date: 11/07/18

*/

enum ibs.th.ref.promo.enum-promo-goods-type:
  define enum
    Appl      = 1     /* товары применения*/
    criterion = 2     /* независимые условия */
    PromoSet = 3      /* промо-набор */
    PromoSetGoods = 4 /* товары прома-набора */
  .
end enum .
