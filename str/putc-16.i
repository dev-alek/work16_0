/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отсылка промоакций на кассу - вывод

Автор: Шкляр Елена
Дата создания: 02/19/06
Author: Shklyar Elena
Creation date: 02/19/06

*/


&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".
assign
  v-version-dec = decimal(p-pos-version)
    no-error .

run bgelib-tag-open in this-procedure ( input 2, input "PromoAction"
  , input substitute("ctrl='&1' tms='&2' code='&3'", (if action = "U"
  then "ADD":U
  else "DEL":U),
  OS2-time, v-promo-action:ID)).
run bgelib-tag-put in this-procedure ( input 3, input "PAName":U
  , input string(v-promo-action:NameAction), input 1 ).
run bgelib-tag-put in this-procedure ( input 3, input "PAType":U
  , input string(v-promo-action:TypeDiscont), input 1 ).
run bgelib-tag-put in this-procedure ( input 3, input "PABeg":U
  , input Xml-CD-DateTimetoString(v-promo-action:beg-date,0), input 1 ).
run bgelib-tag-put in this-procedure ( input 3, input "PAEnd":U
  , input Xml-CD-DateTimetoString(if v-promo-action:changeDate <> ? then v-promo-action:changeDate else v-promo-action:end-date,86399), input 1 ).
run bgelib-tag-put in this-procedure ( input 3, input "PAPriority":U
  , input string(v-promo-action:priority), input 1 ).
  vTypePay = "".
  do vIp = 1 to num-entries(v-promo-action:paymenttype,{&delim-par}):
     vTypePay = vTypePay + "," + LEFT-TRIM(entry(1,
                                                 entry(vIp,
                                                       v-promo-action:paymenttype,
                                                       {&delim-par}
                                                 ),
                                                 {&delim-key}
                                           ),
                                           "0").
  end.
  vTypePay = substring(vTypePay,2).
run bgelib-tag-put in this-procedure ( input 3, input "PAPayment":U
  , input vTypePay, input 0 ).  
run bgelib-tag-put in this-procedure ( input 3, input "PACalcMethod":U
  , input string(v-promo-action:methodCalc), input 1 ).
run bgelib-tag-put in this-procedure ( input 3, input "PACondType":U
  , input string(v-promo-action:typecond), input 1 ).            


/*Расписание работы акции*/
v-subShedWs = v-promo-action:ScheduleWeek .
v-lengthSh = v-subShedWs:iCounter .
do v-i = 1 to v-lengthSh:
  v-size = v-subShedWs:GetItem(v-i) .
  v-subShedW = v-subShedWs:promoSchedwObjCurr .
  do v-ii = 1 to num-entries(v-subShedW:wdaylist):
     if v-subShedW:wdaylist = "0"
     then do v-j = 1 to 7:
        run bgelib-tag-open in this-procedure ( input 3, input "PASched","").
        run bgelib-tag-put in this-procedure ( input 4, input "PASId":U
        , input string(v-promo-action:id), input 1 ).
     
        run bgelib-tag-put in this-procedure ( input 4, input "PASDay":U
          , input string(v-j), input 1 ).
        run bgelib-tag-put in this-procedure ( input 4, input "PASBeg":U
          , input Xml-CD-DateTimetoString(12/31/1989,v-subShedW:timebeg), input 1 ).
        run bgelib-tag-put in this-procedure ( input 4, input "PASEnd":U
          , input Xml-CD-DateTimetoString({&end-of-age},v-subShedW:timeend), input 1 ).
        run bgelib-tag-close in this-procedure ( input 3, input "PASched").
    end.
    else do: 
       run bgelib-tag-open in this-procedure ( input 3, input "PASched","").
       run bgelib-tag-put in this-procedure ( input 4, input "PASId":U
       , input string(v-promo-action:id), input 1 ).
     
       run bgelib-tag-put in this-procedure ( input 4, input "PASDay":U
         , input string(entry(v-ii,v-subShedW:wdaylist)), input 1 ).
       run bgelib-tag-put in this-procedure ( input 4, input "PASBeg":U
         , input Xml-CD-DateTimetoString(12/31/1989,v-subShedW:timebeg), input 1 ).
       run bgelib-tag-put in this-procedure ( input 4, input "PASEnd":U
         , input Xml-CD-DateTimetoString({&end-of-age},v-subShedW:timeend), input 1 ).
       run bgelib-tag-close in this-procedure ( input 3, input "PASched").
    end.
  end.
  
end.  
      

/*Список товаров*/
v-subGoods = v-promo-action:GoodsAppl .
if valid-object (v-subGoods) then 
do: 
  v-lengthGd = v-subGoods:iCounter .
  if v-lengthGd eq 0
  then do:
     run bgelib-tag-open in this-procedure ( input 3, input "PAGoods","").
     run bgelib-tag-close in this-procedure ( input 3, input "PAGoods").
  end.
  else do v-i = 1 to v-lengthGD:
    v-size = v-subGoods:GetItem(v-i) .
    v-subGood = v-subGoods:promoGoodsObjCurr .
      
    run bgelib-tag-open in this-procedure ( input 3, input "PAGoods","").
    run bgelib-tag-put in this-procedure ( input 4, input "PAGId":U
      , input string(v-promo-action:id), input 1 ).
    run bgelib-tag-put in this-procedure ( input 4, input "PAGCode":U
      , input string(v-subGood:GdsCode), input 1 ).
    run bgelib-tag-put in this-procedure ( input 4, input "PAGPrice":U
      , input string(v-subGood:price), input 0 ).
    run bgelib-tag-close in this-procedure ( input 3, input "PAGoods").
  end. /*do v-i = 1 to v-lengthGD:*/
end. /*if valid-object (promoGoodsSubs) then do:*/

/*Список товаров для проверки условий*/

v-subGdCrs = v-promo-action:GoodsCrits .
if valid-object (v-subGdCrs) then 
do: 
  if v-subGdCrs:iCounter ne 0
  then  do v-i = 1 to v-subGdCrs:iCounter:
    v-subGdCrs:GetItem(v-i) .
    v-subGdCr = v-subGdCrs:promoGoodsObjCurr .    
    
    run bgelib-tag-open in this-procedure ( input 3, input "PAFreeGoods","").
    run bgelib-tag-put in this-procedure ( input 4, input "PAFGId":U
      , input string(v-promo-action:id), input 1 ).
    run bgelib-tag-put in this-procedure ( input 4, input "PAFGCode":U
      , input string(v-subGdCr:GdsCode), input 1 ).
    run bgelib-tag-close in this-procedure ( input 3, input "PAFreeGoods").

  end.
end. /*if VALID-OBJECT (v-subFree) then do:*/

v-subcardbins= v-promo-action:CardsBin .
if valid-object (v-subcardbins) then 
do: 
  if v-subcardbins:iCounter ne 0
  then  do v-i = 1 to v-subcardbins:iCounter:
    v-subcardbins:GetItem(v-i) .
    v-subCardBin = v-subcardbins:promoGoodsObjCurr .    
    
    run bgelib-tag-open in this-procedure ( input 3, input "PAFreeGoods","").
    run bgelib-tag-put in this-procedure ( input 4, input "PAFGId":U
      , input string(v-promo-action:id), input 1 ).
    run bgelib-tag-put in this-procedure ( input 4, input "PAFGCode":U
      , input string(v-subCardBin:nameset), input 1 ).
    run bgelib-tag-close in this-procedure ( input 3, input "PAFreeGoods").

  end.
end. /*if VALID-OBJECT (v-subFree) then do:*/
    
if  valid-object (v-subGdCrs)    and v-subGdCrs   :iCounter eq 0
and valid-object (v-subcardbins) and v-subcardbins:iCounter eq 0
then do:
   run bgelib-tag-open in this-procedure ( input 3, input "PAFreeGoods","").
   run bgelib-tag-close in this-procedure ( input 3, input "PAFreeGoods").
end.

/*Подарки*/
   
v-subGifts = v-promo-action:Gifts .
if VALID-OBJECT (v-subGifts) then 
do:
  
  
  do v-i = 1 to v-subGifts:iCounter:
    vgift = yes.
    v-subGifts:GetItem(v-i).
    v-subGift = v-subGifts:promoGiftObjCurr .
      
    run bgelib-tag-open in this-procedure ( input 3, input "PAGiftGoods","").
    run bgelib-tag-put in this-procedure ( input 4, input "PAGGId":U
      , input string(v-promo-action:id), input 1 ).
    run bgelib-tag-put in this-procedure ( input 4, input "PAGGCode":U
      , input string(v-subGift:GdsCode), input 1 ).
    run bgelib-tag-put in this-procedure ( input 4, input "PAGGAmount":U
      , input string(v-subGift:qnty), input 1 ).
    run bgelib-tag-close in this-procedure ( input 3, input "PAGiftGoods").
    
  end. /*do v-i = 1 to v-subGifts:iCounter:*/
end. /*if VALID-OBJECT (v-subGifts) then do:*/
 
v-subGDCrites = v-promo-action:Criterion .

if valid-object (v-subGDCrites) then
do:
  if v-subGDCrites:iCounter eq 0
  then do:
    run bgelib-tag-open in this-procedure ( input 3, input "PACond","").
    run bgelib-tag-close in this-procedure ( input 3, input "PACond").
  end.
  else
  
  do v-ii = 1 to v-subGDCrites:iCounter:
    v-subGDCrites:GetItem(v-ii) .
    v-subGDCrite = v-subGDCrites:promoCriterionObjCurr .
    v-subGDCrite:refreshChildObj() .
    v-subCrGifts = v-subGDCrite:Gifts .

      if VALID-OBJECT (v-subCrGifts) then
      do:
        do v-i = 1 to v-subCrGifts:iCounter:
          vgift = yes.
          v-subCrGifts:GetItem(v-i) .
          v-subCrGift = v-subCrGifts:promoGiftObjCurr .
          if v-subCrGift:mess <> "" or v-subCrGift:mess <> ? then v-mess = v-subCrGift:mess .
          if v-subCrGift:GdsCode <> 0 then do:
          run bgelib-tag-open in this-procedure ( input 3, input "PAGiftGoods","").
          run bgelib-tag-put in this-procedure ( input 4, input "PAGGId":U
            , input string(v-promo-action:id), input 1 ).
          run bgelib-tag-put in this-procedure ( input 4, input "PAGGNum":U
            , input string(v-subGDCrite:id), input 1 ).
          run bgelib-tag-put in this-procedure ( input 4, input "PAGGCode":U
            , input string(v-subCrGift:GdsCode), input 1 ).
          run bgelib-tag-put in this-procedure ( input 4, input "PAGGAmount":U
            , input string(v-subCrGift:qnty), input 1 ).
          run bgelib-tag-close in this-procedure ( input 3, input "PAGiftGoods").
          end.
        end. /*do v-i = 1 to v-subGifts:iCounter:*/
      end. /*if VALID-OBJECT (v-subGifts) then do:*/

    /*Список условий*/
    vPricePromoSets = v-subGDCrite:discont .
    run bgelib-tag-open in this-procedure ( input 3, input "PACond","").
    run bgelib-tag-put in this-procedure ( input 4, input "PACId":U
      , input string(v-promo-action:id), input 1 ).
    run bgelib-tag-put in this-procedure ( input 4, input "PACNum":U
      , input string(v-subGDCrite:id), input 1 ).
    run bgelib-tag-put in this-procedure ( input 4, input "PACAmount":U
      , input string(v-subGDCrite:mincrit), input 1 ).
    run bgelib-tag-put in this-procedure ( input 4, input "PACDiscount":U
      , input string(v-subGDCrite:discont), input 1 ).
    run bgelib-tag-put in this-procedure ( input 4, input "PACMessage":U
      , input string(v-mess), input 0 ).  
    run bgelib-tag-close in this-procedure ( input 3, input "PACond").
  end.
end.


/*Список секций промо-набора*/

v-subPromoSets = v-promo-action:PromoSet .
if valid-object (v-subPromoSets) then 
do:
  run bgelib-tag-put in this-procedure ( input 3, input "PASetPrice":U
    , input string(vPricePromoSets), input 1 ).
  if v-subPromoSets:iCounter eq 0
  then do:
    run bgelib-tag-open in this-procedure ( input 3, input "PASetSection","").
    run bgelib-tag-close in this-procedure ( input 3, input "PASetSection").
  end.
  else
  do v-i = 1 to v-subPromoSets:iCounter:
    v-subPromoSets:GetItem(v-i).
    v-subPromoSet = v-subPromoSets:promoGoodsObjCurr .
    run bgelib-tag-open in this-procedure ( input 3, input "PASetSection","").
    run bgelib-tag-put in this-procedure ( input 4, input "PASSId":U
      , input string(v-subPromoSet:idaction), input 1 ).
    run bgelib-tag-put in this-procedure ( input 4, input "PASSAmount":U
      , input string(v-subPromoSet:qnty), input 1 ).
    run bgelib-tag-put in this-procedure ( input 4, input "PASSDiscount":U
      , input string(v-subPromoSet:price), input 1 ).
    run bgelib-tag-put in this-procedure ( input 4, input "PASSNum":U
      , input string(v-subPromoSet:id), input 1 ).
    run bgelib-tag-close in this-procedure ( input 3, input "PASetSection").
  end.
  do v-i = 1 to v-subPromoSets:iCounter:
    v-subPromoSets:GetItem(v-i).
    v-subPromoSet = v-subPromoSets:promoGoodsObjCurr .
    v-subPromoSet:refreshChildObj().
    v-subPromoSetGoods = v-subPromoSet:promoSetGoods.
    do v-j = 1 to v-subPromoSetGoods:iCounter:
        vsetgoods = yes.
        v-subPromoSetGoods:GetItem(v-j).    
        v-subPromoSetGood = v-subPromoSetGoods:promoGoodsObjCurr. 
        run bgelib-tag-open in this-procedure ( input 3, input "PASetGoods","").
        run bgelib-tag-put in this-procedure ( input 4, input "PASGId":U
          , input string(v-subPromoSetGood:idaction), input 1 ).
        run bgelib-tag-put in this-procedure ( input 4, input "PASGCode":U
          , input string(v-subPromoSetGood:GdsCode), input 1 ).
        run bgelib-tag-put in this-procedure ( input 4, input "PASGNum":U
          , input string(v-subPromoSetGood:idSet), input 1 ).
        run bgelib-tag-close in this-procedure ( input 3, input "PASetGoods").
    end.    

  end.
end.
   
/*                                                                             */
/*                                                                             */
/*                                                                             */
/*                                                                             */
/*                                                                             */
/*                                                                             */
/*      v-subGDCrites = v-promo-action:Criterion .                             */
/*      v-subGDCrite = v-subGDCrites:promoCriterionObjCurr .                   */
/*      if VALID-OBJECT (v-subGDCrite) then                                    */
/*      do:                                                                    */
/*/*      v-subGDCrite:refreshChildObj() .*/                                   */
/*        run bgelib-tag-put in this-procedure ( input 5, input "GAmount":U    */
/*          , input string(v-subGDCrite:mincrit), input 1 ).                   */
/*        run bgelib-tag-put in this-procedure ( input 5, input "GDiscount":U  */
/*          , input string(v-subGDCrite:discont), input 1 ).                   */
/*      end. /*if VALID-OBJECT (PromoCriterionSub) then do:*/                  */
/*                                                                             */
/*                                                                             */
/*                                                                             */
/*                                                                             */
/*                                                                             */
/*                                                                             */
/*                                                                             */
/*                                                                             */
/*                                                                             */
/*if  v-promo-action:TypeDiscont = 1 then                                      */
/*do:                                                                          */
/*  run bgelib-tag-open in this-procedure ( input 3, input "ActionCtl"         */
/*    , input substitute("code='&1'", (v-promo-action:id))).                   */
/*  run bgelib-tag-put in this-procedure ( input 4, input "ACId":U             */
/*    , input string(v-promo-action:id), input 1 ).                            */
/*                                                                             */
/*                                                                             */
/*                                                                             */
/*                                                                             */
/*                                                                             */
/*                                                                             */
/*                                                                             */
/*  v-subGDCrites = v-promo-action:Criterion .                                 */
/*  v-subGDCrite = v-subGDCrites:promoCriterionObjCurr .                       */
/*  if valid-object (v-subGDCrite) then                                        */
/*  do:                                                                        */
/*                                                                             */
/*    if v-subGDCrite:idAction = v-promo-action:ID then                        */
/*    do:                                                                      */
/*                                                                             */
/*      run bgelib-tag-open in this-procedure ( input 4, input "ACCond"        */
/*        , input substitute("code='&1'", (v-promo-action:id))).               */
/*      run bgelib-tag-put in this-procedure ( input 5, input "ACCId":U        */
/*        , input string(v-promo-action:id), input 1 ).                        */
/*      run bgelib-tag-put in this-procedure ( input 5, input "ACCNum":U       */
/*        , input string(v-sizeGif), input 1 ).                                */
/*      run bgelib-tag-put in this-procedure ( input 5, input "ACCAmount":U    */
/*        , input string(v-subGDCrite:mincrit), input 1 ).                     */
/*      run bgelib-tag-put in this-procedure ( input 5, input "ACCDiscount":U  */
/*        , input string(v-subGDCrite:discont), input 1 ).                     */
/*      run bgelib-tag-put in this-procedure ( input 5, input "ACCMessage":U   */
/*        , input string(v-subGDCrite:Msg), input 1 ).                         */
/*                                                                             */
/*  v-subGDCrite:refreshChildObj() .                                           */
/*  v-subGifts = v-subGDCrite:Gifts .                                          */
/*                                                                             */
/*  if VALID-OBJECT (v-subGifts) then                                          */
/*  do:                                                                        */
/*                                                                             */
/*    do v-i = 1 to v-subGifts:iCounter:                                       */
/*      v-sizeGif = v-subGifts:GetItem(v-i) .                                  */
/*      v-subGift = v-subGifts:promoGiftObjCurr .                              */
/*      run bgelib-tag-open in this-procedure ( input 5, input "ACGiftGoods"   */
/*        , input substitute("code='&1'", (v-promo-action:id))).               */
/*      run bgelib-tag-put in this-procedure ( input 6, input "GGId":U         */
/*        , input string(v-promo-action:id), input 1 ).                        */
/*      run bgelib-tag-put in this-procedure ( input 6, input "GGNum":U        */
/*        , input string(v-i), input 1 ).                                      */
/*      run bgelib-tag-put in this-procedure ( input 6, input "GGCode":U       */
/*        , input string(v-subGift:GdsCode), input 1 ).                        */
/*      run bgelib-tag-put in this-procedure ( input 6, input "GGAmount":U     */
/*        , input string(v-subGift:qnty), input 1 ).                           */
/*      run bgelib-tag-close in this-procedure ( input 5, input "ACGiftGoods").*/
/*                                                                             */
/*    end. /*do v-i = 1 to v-subGifts:iCounter:*/                              */
/*  end. /*if VALID-OBJECT (v-subGifts) then do:*/                             */
/*      run bgelib-tag-close in this-procedure ( input 4, input "ACCond").     */
/*                                                                             */
/*    end.                                                                     */
/*  end.                                                                       */
/*                                                                             */
/*  run bgelib-tag-close in this-procedure ( input 3, input "ActionCtl").      */
/*end.                                                                         */
/*/*Промо-набор*/                                                              */
/*else                                                                         */
/*do:                                                                          */
/*  run bgelib-tag-open in this-procedure ( input 3, input "PromoActionCtl"    */
/*    , input substitute("code='&1'", (v-promo-action:TypeDiscont))).          */
/*  run bgelib-tag-put in this-procedure ( input 4, input "PACid":U            */
/*    , input string(v-promo-action:ID), input 1 ).                            */
/*  run bgelib-tag-put in this-procedure ( input 4, input "PACCalcMethod":U    */
/*    , input string(v-promo-action:methodCalc), input 1 ).                    */
/*                                                                             */
/*  v-subPromoSets = v-promo-action:PromoSet .                                 */
/*  v-subPromoSet = v-subPromoSets:promoGoodsObjCurr .                         */
/*                                                                             */
/*  run bgelib-tag-open in this-procedure ( input 4, input "PromoSet"          */
/*    , input substitute("code='&1'", (v-promo-action:id))).                   */
/*  run bgelib-tag-put in this-procedure ( input 5, input "PSId":U             */
/*    , input string(v-promo-action:id), input 1 ).                            */
/*  do v-i = 1 to v-subPromoSets:iCounter:                                     */
/*    v-subPromoSec = v-subPromoSets:promoGoodsObjCurr .                       */
/*    run bgelib-tag-open in this-procedure ( input 5, input "PSSection"       */
/*      , input substitute("code='&1'", (v-subPromoSec:idSet))).               */
/*    run bgelib-tag-put in this-procedure ( input 6, input "PSSId":U          */
/*      , input string(v-promo-action:id), input 1 ).                          */
/*    run bgelib-tag-put in this-procedure ( input 6, input "PSSName":U        */
/*      , input string(v-subPromoSec:NameSet), input 1 ).                      */
/*    run bgelib-tag-put in this-procedure ( input 6, input "PSSAmount":U      */
/*      , input string(v-subPromoSec:qnty), input 1 ).                         */
/*    run bgelib-tag-put in this-procedure ( input 6, input "PSSDiscount":U    */
/*      , input string(v-subPromoSec:price), input 1 ).                        */
/*    run bgelib-tag-put in this-procedure ( input 6, input "PSSGoods":U       */
/*      , input string(v-subPromoSec:GdsCode), input 1 ).                      */
/*    run bgelib-tag-close in this-procedure ( input 5, input "PSSection").    */
/*  end.                                                                       */
/*  run bgelib-tag-put in this-procedure ( input 5, input "PSPrice":U          */
/*    , input string(v-subPromoSet:price), input 1 ).                          */
/*                                                                             */
/*  run bgelib-tag-close in this-procedure ( input 4, input "PromoSet").       */
/*                                                                             */
/*  run bgelib-tag-close in this-procedure ( input 3, input "PromoActionCtl"). */
/*end.                                                                         */
/*                                                                             */
if not vGift
  then do:
    run bgelib-tag-open in this-procedure ( input 3, input "PAGiftGoods","").
    run bgelib-tag-close in this-procedure ( input 3, input "PAGiftGoods").
  end.
if not vSetgoods
  then do:
    run bgelib-tag-open in this-procedure ( input 3, input "PASetGoods","").
    run bgelib-tag-close in this-procedure ( input 3, input "PASetGoods").
  end.                                          
run bgelib-tag-close in this-procedure ( input 2, input "PromoAction").
