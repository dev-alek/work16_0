/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

коды типов промо-акций согласно протоколу взаимодействия с 1С

Автор: Молотков Сергей
Дата создания: 10/07/18
Author: Molotkov Sergey
Creation date: 10/07/18

*/

enum ibs.th.ref.promo.enum-type-discount:
  define enum
    ensolo  = 1 /* врЕменная скидка - предоставляется на отдельный товар */
    encombo = 2 /* промо-набор      - предоставляется на сочетание товаров */
  .
end enum .
