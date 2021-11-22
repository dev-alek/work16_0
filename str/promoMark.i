/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Автор: Шкляр Елена
Дата создания: 03/24/06
Author: Shklyar Elena
Creation date: 03/24/06

*/

define buffer buf_PromoAction for ub.PromoAction .
define buffer buf_PromoGoods  for ub.PromoGoods .
define buffer buf_PromoGift   for ub.PromoGift .
define buffer buf_goods-attr  for ub.goods-attr .

for each buf_PromoGift no-lock:
   if can-find (first buf_goods-attr no-lock where buf_goods-attr.gds-code = buf_PromoGift.gds-code and 
      buf_goods-attr.attr-code = {&attr-mark-type} and buf_goods-attr.attr-value <> "not-type" and 
      buf_goods-attr.attr-value <> "") then 
   do:
      find first buf_PromoAction exclusive-lock where buf_PromoAction.id = buf_PromoGift.idaction and 
         buf_PromoAction.db-num = buf_PromoGift.db-num and buf_PromoAction.end-date >= today no-error .
      if available (buf_PromoAction) then 
      do:
         buf_PromoAction.end-date = today - 1 .
      end.   
   end.   
end.   
for each buf_PromoGoods no-lock:
   if can-find (first buf_goods-attr no-lock where buf_goods-attr.gds-code = buf_PromoGoods.gds-code and 
      buf_goods-attr.attr-code = {&attr-mark-type} and buf_goods-attr.attr-value <> "not-type" and 
      buf_goods-attr.attr-value <> "") then 
   do:
      find first buf_PromoAction exclusive-lock where buf_PromoAction.id = buf_PromoGoods.idaction and 
         buf_PromoAction.db-num = buf_PromoGoods.db-num and buf_PromoAction.end-date >= today no-error .
      if available (buf_PromoAction) then 
      do:
         buf_PromoAction.end-date = today - 1 .
      end.   
   end.   
end.    


/* $Workfile$ e n d */