/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Расписания промо-акций

Автор: Молотков Сергей
Дата создания: 21/06/18
Author: Molotkov Sergey
Creation date: 21/06/18

*/
&if defined(ds-promo-i) = 0 &then
&global-define ds-promo-i

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

/* для списка акций */
define temp-table tt-promoaction no-undo
  like ub.PromoAction
  
  field status_lbl       as character
  field sub as class Progress.Lang.Object
  FIELD mode AS char
  field Chang as logical
  .

/* для редактирования акций */
define temp-table tt-promoaction-one no-undo
  like tt-promoaction
  
  before-table tt-promoaction-one-before
  
  //field TypeDiscontlbl   as character
  field TypeDiscontlog   as logical 
  field methodCalclbl    as character
  field typecondlbl      as character
  field scheduleName     as character
  field scheduleType     as integer
  field extCodeSched     as character
  .

define temp-table tt-PromoGoodsAppl no-undo
  like ub.PromoGoods
  
  FIELD gdsName AS char 
  field sub as class Progress.Lang.Object
  FIELD mode AS char
  .
define temp-table tt-PromoGoodsCrite no-undo
  like ub.PromoGoods
  
  FIELD gdsName AS char 
  field sub as class Progress.Lang.Object
  FIELD mode AS char
  .  
define temp-table tt-PromoSet no-undo
  like ub.PromoGoods
   
  field sub as class Progress.Lang.Object
  FIELD mode AS char
  .  
define temp-table tt-PromoSetGoods no-undo
  like ub.PromoGoods
  
  FIELD gdsName AS char 
  field sub as class Progress.Lang.Object
  FIELD mode AS char
  .  
define temp-table tt-PromoCriterion no-undo
  like ub.PromoCriterion
  field span as character  
  field sub as Progress.Lang.Object
  FIELD mode AS char
  .

define temp-table tt-PromoGift no-undo
  like ub.PromoGift
   
  FIELD gdsName AS char
  field sub as class Progress.Lang.Object
  FIELD mode AS char
  .
  
define temp-table tt-PromoObject no-undo
  like ub.PromoObject
   
  FIELD objName  AS char
  FIELD FirmCode AS integer 
  FIELD FirmName AS char
  FIELD objDbNum AS integer
  
  field sub as class Progress.Lang.Object
  FIELD mode AS char
  .

define temp-table tt-CashPay no-undo
  like ub.Cash-Pay
.

define temp-table tt-promo-schedule-week no-undo
  like ub.promo-schedule-week

  field dtime-beg as datetime
  field dtime-end as datetime
  field isday_mon as logical
  field isday_tue as logical
  field isday_wed as logical
  field isday_thu as logical
  field isday_fri as logical
  field isday_sat as logical
  field isday_sun as logical

  field sub  as class Progress.Lang.Object
  field mode as character
.

define dataset ds-promoaction-one
  for tt-promoaction-one
  , tt-CashPay
  , tt-PromoGoodsAppl
  , tt-PromoGoodsCrite
  , tt-PromoCriterion
  , tt-PromoGift
  , tt-PromoSet
  , tt-PromoSetGoods
  , tt-PromoObject
//  , tt-promo-schedule
  , tt-promo-schedule-week
//  data-relation relGoodsAppl  for tt-promoaction-one, tt-PromoGoodsAppl     relation-fields (id, idaction)
  //data-relation relGoodsCrite for tt-promoaction-one, tt-PromoGoodsCrite    relation-fields (id, idaction) nested
  //data-relation relCriterion  for tt-promoaction-one, tt-PromoCriterion     relation-fields (id, idaction) nested
  //data-relation relGift       for tt-promoaction-one, tt-PromoGift          relation-fields (id, idaction) nested
//  data-relation relPromo      for tt-promoaction-one, tt-promo-schedule     relation-fields (id, idaction)
//  data-relation relPromoWeek  for tt-promo-schedule, tt-promo-schedule-week relation-fields (id, promosched-id)
.

&endif
/* $Workfile$ e n d */