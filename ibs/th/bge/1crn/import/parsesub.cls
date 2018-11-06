/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

парсер входящей xml из 1С ERPRN

Автор: Александр Морозов
Дата создания: 26/09/17
Author: Morozov Alexandr
Creation date: 26/09/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.*.
using ibs.th.bge.1crn.import.*.

block-level on error undo, throw.

class ibs.th.bge.1crn.import.parsesub:
  
  { cmp/str-glbl.i class }
  
  define public event ReceivedSubject signature void (input Subject as class ibs.th.bge.1crn.subjects.isubject, input EventHndlrImpSub as class ibs.th.bge.1crn.import.iimpsubject).

  define variable countrySubjectObj                        as class country                     no-undo.
  define variable impcountryEventHndlrObj                  as class impcountry                  no-undo.
  
  define variable cliGrpSubjectObj                         as class cli-grps                    no-undo.
  define variable impCliGrpEventHndlrObj                   as class impcli-grps                 no-undo.
  
  define variable businessUnitsSubjectObj                  as class business-units              no-undo.
  define variable impbusinessUnitsEventHndlrObj            as class impbusiness-units           no-undo.

/*----------*/
  
  define variable clientsSubjectObj                        as class clients                     no-undo.
  define variable clients_carriersSubjectObj               as class clients_carriers            no-undo.
  define variable clients_suppliersSubjectObj              as class clients_suppliers           no-undo.
  define variable impClientsEventHndlrObj                  as class impclients                  no-undo.

  define variable clients_carriersListSubjectObj           as class subjects                    no-undo.
  define variable clients_suppliersListSubjectObj          as class subjects                    no-undo.

/*---------*/
  define variable contractsSubjectObj                      as class contracts                   no-undo.
  define variable impContractsEventHndlrObj                as class impcontracts                no-undo.

  define variable currencySubjectObj                       as class currency                    no-undo.
  define variable impCurrencyEventHndlrObj                 as class impcurrency                 no-undo.

  define variable firmsSubjectObj                          as class firms                       no-undo.
  define variable impFirmsEventHndlrObj                    as class impfirms                    no-undo.
  
  define variable goodGrpsSubjectObj                       as class good-grps                   no-undo.
  define variable impGoodGrpsEventHndlrObj                 as class impgood-grps                no-undo.
  
  define variable paymentTypeGroupSubjectObj               as class payment-type-group          no-undo.
  define variable impPaymentTypeGroupEventHndlrObj         as class imppayment-type-group       no-undo.
  
  define variable paymentTypeSubjectObj                    as class payment-type                no-undo.
  define variable impPaymentTypeEventHndlrObj              as class imppayment-type             no-undo.
  
  define variable shopsSubjectObj                          as class shops                       no-undo.
  define variable impShopsEventHndlrObj                    as class impshops                    no-undo.

  define variable unitsSubjectObj                          as class units                       no-undo.
  define variable impUnitsEventHndlrObj                    as class impunits                    no-undo.  

  define variable goodSubjectObj                           as class goods                       no-undo.
  define variable barcodesSubjectsObj                      as class subjects                    no-undo.
  define variable good_barcodeSubjectObj                   as class goods_barcode               no-undo.
  define variable unitaddsSubjectsObj                      as class subjects                    no-undo.
  define variable good_unitaddSubjectObj                   as class unit-add-code               no-undo.
  define variable impGoodEventHndlrObj                     as class impgoods                    no-undo.
  
  
  define variable cashiersSubjectObj                       as class cashiers                    no-undo.
  define variable impcashiersEventHndlrObj                 as class impcashiers                 no-undo.    

  define variable bank-accountsSubjectObj                  as class bank-accounts               no-undo.
  define variable bank-accounts_bankSubjectObj             as class bank-accounts_bank          no-undo.
  define variable impbank-accountsEventHndlrObj            as class impbank-accounts            no-undo.

  define variable contr-price-docsSubjectObj               as class contr-price-docs            no-undo.
  define variable price-listSubjectsObj                    as class subjects                    no-undo.
  define variable contr-price-listSubjectObj               as class contr-price-docs_price-list no-undo.
  define variable impcontr-price-docsEventHndlrObj         as class impcontr-price-docs         no-undo.

  define variable price-doc-impSubjectObj                  as class price-doc-imp               no-undo.
  define variable price-doc_gds-saleSubjectObj             as class price-doc_gds-sale          no-undo.
  define variable impprice-docEventHndlrObj                as class impprice-doc                no-undo.

  define variable price-doc-listSubjectsObj                as class subjects                    no-undo.

  define variable int-pointSubjectObj                      as class int-point                   no-undo.
  define variable impint-pointEventHndlrObj                as class impint-point                no-undo.

  define variable assortment-matrixSubjectObj              as class assortment-matrix           no-undo.
  define variable impassortment-matrixEventHndlrObj        as class impassortment-matrix        no-undo.

  define variable measuringSubjectObj                      as class measuring                   no-undo.
  define variable impmeasuringEventHndlrObj                as class impmeasuring                no-undo.

  define variable recipeSubjectObj                         as class recipe                      no-undo.
  define variable recipe-gdSubjectObj                      as class recipe-gd                   no-undo.
  define variable imprecipeEventHndlrObj                   as class imprecipe                   no-undo.
  define variable recipe-gd-listSubjectsObj                as class subjects                    no-undo.

  define variable transportSubjectObj                      as class transport                   no-undo.
  define variable transport_sectionSubjectObj              as class transport_section           no-undo.
  define variable transport_section_ct-lvlSubjectObj       as class transport_section_ct-lvl    no-undo.
  define variable imptransportEventHndlrObj                as class imptransport                no-undo.
  define variable transport_section-listSubjectsObj        as class subjects                    no-undo.
  define variable transport_section_ct-lvl-listSubjectsObj as class subjects                    no-undo.

  define variable tank-impSubjectObj                       as class tank-imp                    no-undo.
  define variable tank-imp_cal-tblSubjectObj               as class tank-imp_cal-tbl            no-undo.
  define variable imptank-impEventHndlrObj                 as class imptank-imp                 no-undo.
  define variable tank-imp_cal-tbllistSubjectsObj          as class subjects                    no-undo.
  
  define variable trn-gd-doc-inSubjectObj                  as class trn-gd-doc-in               no-undo.
  define variable trn-gdSubjectObj                         as class trn-gd                      no-undo.
  define variable trn-prtSubjectObj                        as class trn-prt                      no-undo.
  define variable imptrn-gd-docEventHndlrObj               as class imptrn-gd-doc               no-undo.
  define variable trn-gd-doc-inlistSubjectsObj             as class subjects                    no-undo.
  define variable trn-prt-doc-inlistSubjectsObj             as class subjects                    no-undo.

  define variable normlossSubjectObj                        as class normloss                  no-undo.
  define variable impnormlossEventHndlrObj                as class impnormloss                no-undo.

  define variable trn-fuel-doc-inSubjectObj      as class trn-fuel-doc-in no-undo.
  define variable trn-gd-fuelSubjectObj          as class trn-gd-fuel     no-undo.
  define variable imptrn-fuel-docEventHndlrObj   as class imptrn-fuel-doc no-undo.
  define variable trn-fuel-doc-inlistSubjectsObj as class subjects        no-undo.

  
  /*---------------- Объекты для скидок ----------*/  
  define variable promotionSubjectObj                   as class promotion               no-undo. // <promotion>
  define variable promotionSheduleObj                   as class promotion_schedule      no-undo. // promotion:schedule
  define variable promotion_shedule-lineListSubjectsObj as class subjects                no-undo. // promotion:schedule:schedule-lines
  define variable promotion_shedule-lineSubjectObj      as class promotion_schedule-line no-undo. // promotion:schedule:schedule-lines:schedule-line
  define variable promotion_thresholdListSubjectsObj    as class subjects                no-undo. // promotion:thresholds
  define variable promotion_thresholdSubjectObj         as class promotion_threshold     no-undo. // promotion:thresholds:threshold
  define variable promotion_t_giftListSubjectsObj       as class subjects                no-undo. // promotion:thresholds:threshold:gifts
  define variable promotion_t_giftSubjectObj            as class promotion_gift-gd       no-undo. // promotion:thresholds:threshold:gifts:gd
  define variable promotion_gdsListSubjectsObj          as class subjects                no-undo. // promotion:gds
  define variable promotion_gdsSubjectObj               as class promotion_gds-gd        no-undo. // promotion:gds:gd
  define variable promotion_gdListSubjectsObj           as class subjects                no-undo. // promotion:gds-addcond
  define variable promotion_gdSubjectObj                as class promotion_gd            no-undo. // promotion:gds-addcond:gd
  define variable promotionPromosetObj                  as class promotion_promoset      no-undo. // promotion:promoset
  define variable promotion_psListSubjectsObj           as class subjects                no-undo. // promotion:promoset:ps-sections
  define variable promotion_psSubjectObj                as class promotion_ps-section    no-undo. // promotion:promoset:ps-sections:ps-section
  define variable promotion_p_gdListSubjectsObj         as class subjects                no-undo. // promotion:promoset:ps-sections:ps-section:gds
  define variable promotion_p_gdSubjectObj              as class promotion_gd            no-undo. // promotion:promoset:ps-sections:ps-section:gds:gd
  define variable promotion_giftListSubjectsObj         as class subjects                no-undo. // promotion:gifts
  define variable promotion_giftSubjectObj              as class promotion_gift-gd       no-undo. // promotion:gifts:gd
  
  define variable imppromotionEventHndlrObj                as class imppromotion                no-undo.
/*---------------- Объекты для скидок ---------- конец*/  
  
  
  define variable good             as logical   no-undo.
  define variable nameChildrenCurr as character no-undo.
  define variable iNum             as integer   no-undo. /* примерный счетчик элемента */

  define private variable parparentproc   as handle no-undo .
  define private variable p-parent-handle as handle no-undo .
  define private variable p-log-handle    as handle no-undo .


  define property MsgPrivate as character no-undo
    get:
      return trim (MsgPrivate, {&new-line}).
    end.
    private set (inArg as char):
      MsgPrivate = MsgPrivate + {&new-line} + inArg.
    end.

  define property Msg as character no-undo
    get:
      return (substitute ("Секция &1 элемент № &2: &3", nameChildrenCurr, string (iNum), MsgPrivate) ).
    end.

  define property ErrSts as logical no-undo
    get. 
    set.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
		
  constructor public parsesub (  ):

    /* производство групп объектов для обрабатываемых сущностей */

    countrySubjectObj = new country ().
    impcountryEventHndlrObj = new impcountry ().
    
    cliGrpSubjectObj = new cli-grps ().
    impCliGrpEventHndlrObj = new impcli-grps ().
    
    businessUnitsSubjectObj = new business-units ().
    impbusinessUnitsEventHndlrObj = new impbusiness-units ().

    clientsSubjectObj = new clients ().
    clients_carriersSubjectObj = new clients_carriers ().
    clients_suppliersSubjectObj = new clients_suppliers ().
    clients_carriersListSubjectObj = new subjects ('nb-carriers').
    clients_suppliersListSubjectObj = new subjects ('nb-suppliers').
    impClientsEventHndlrObj = new impclients ().

    contractsSubjectObj = new contracts ().
    impContractsEventHndlrObj = new impcontracts ().

    normlossSubjectObj = new normloss ().
    impnormlossEventHndlrObj = new impnormloss ().
    
    currencySubjectObj = new currency ().
    impCurrencyEventHndlrObj = new impcurrency ().
    
    firmsSubjectObj = new firms ().
    impFirmsEventHndlrObj = new impfirms ().
    
    goodGrpsSubjectObj = new good-grps ().
    impGoodGrpsEventHndlrObj = new impgood-grps ().

    paymentTypeSubjectObj = new payment-type ().
    impPaymentTypeEventHndlrObj = new imppayment-type ().
    
    paymentTypeGroupSubjectObj = new payment-type-group ().
    impPaymentTypeGroupEventHndlrObj = new imppayment-type-group ().

    unitsSubjectObj = new units ().
    impUnitsEventHndlrObj = new impunits ().
    
    cashiersSubjectObj = new cashiers ().
    impcashiersEventHndlrObj = new impcashiers (). 
		
    bank-accountsSubjectObj = new bank-accounts ().
    impbank-accountsEventHndlrObj = new impbank-accounts ().
    

    price-doc-listSubjectsObj = new subjects("gds-sale").

    price-doc-impSubjectObj = new price-doc-imp ().
    impprice-docEventHndlrObj = new impprice-doc ().

    int-pointSubjectObj = new int-point ().
    impint-pointEventHndlrObj = new impint-point ().

    assortment-matrixSubjectObj = new assortment-matrix ().
    impassortment-matrixEventHndlrObj = new impassortment-matrix ().
    
    measuringSubjectObj = new measuring ().
    impmeasuringEventHndlrObj = new impmeasuring ().
    
    recipeSubjectObj = new recipe ().
    imprecipeEventHndlrObj = new imprecipe ().
    recipe-gd-listSubjectsObj = new subjects ("recipe-gds").

    transportSubjectObj = new transport ().
    imptransportEventHndlrObj = new imptransport ().
    transport_section-listSubjectsObj = new subjects ("sections").
    transport_section_ct-lvl-listSubjectsObj = new subjects ("calibration-table").

    tank-impSubjectObj = new tank-imp ().
    imptank-impEventHndlrObj = new imptank-imp ().
    tank-imp_cal-tbllistSubjectsObj = new subjects ("cal-tbl").
		
/*		trn-gd-doc-inSubjectObj = new trn-gd-doc-in ().       */
/*    imptrn-gd-docEventHndlrObj = new imptrn-gd-doc ().  */
/*    trn-gd-doc-inlistSubjectsObj = new subjects ("gds").*/
    
    /* создание экземпляров объектов:
       - товаров
       - АЗК
       - промо-акций
       - срецификаций к договорам поставки
       перенесено внутрь парсинга */
    
    trn-gd-doc-inSubjectObj = new trn-gd-doc-in ().
    trn-gdSubjectObj = new trn-gd ().
    imptrn-gd-docEventHndlrObj = new imptrn-gd-doc ().
    trn-gd-doc-inlistSubjectsObj = new subjects ("gds").
    trn-prt-doc-inlistSubjectsObj = new subjects ("prts").
		
    trn-fuel-doc-inSubjectObj = new trn-fuel-doc-in ().
    trn-gd-fuelSubjectObj = new trn-gd-fuel ().
    imptrn-fuel-docEventHndlrObj = new imptrn-fuel-doc ().
    trn-fuel-doc-inlistSubjectsObj = new subjects ("gds").
		
  end constructor.
  
  method public void setParent (
  input parparentproc   as handle
, input p-parent-handle as handle
, input p-log-handle    as handle
  ) :
    assign
      this-object:parparentproc   = parparentproc
      this-object:p-parent-handle = p-parent-handle
      this-object:p-log-handle    = p-log-handle
    .
  end method .

  method public logical Parse1CRNSub (input inFileName as character):

    define variable result as logical no-undo.

    define variable hDoc as handle no-undo.
    define variable hRoot as handle no-undo.

    create x-document hDoc.
    create x-noderef hRoot.

    hDoc:load("file",inFileName,false).

    hDoc:get-document-element(hRoot).
    
    iNum = 3.
    
    GetChildren(hRoot, 1).
        
    delete object hDoc.
    delete object hRoot.
    

    return result.

  end method.
  
  
  method private void GetChildren (
    input hParent as handle,
    input level as integer):

    define variable i            as integer   no-undo.
    define variable hNoderef     as handle    no-undo.
    define variable hText        as handle    no-undo.
    define variable client       as character no-undo.
    
    define variable v-iSubject   as class ibs.th.bge.1crn.subjects.isubject no-undo .
    define variable v-iImpSub    as class ibs.th.bge.1crn.import.iimpsubject no-undo .    

    create x-noderef hNoderef.
    create x-noderef hText .
    repeat i = 1 to hParent:num-children:
      good = hparent:get-child(hnoderef,i).
      if not good then 
          leave.
      if hnoderef:subtype <> "element" then
          next.
      hnoderef:get-child(htext, 1) no-error .
      iNum = iNum + 1.
      if hnoderef:child-num = 2
      then do:
        nameChildrenCurr = hnoderef:name.
      end.
      case hNoderef:name:
        // экземпляр xxxSubjectObj создаётся перед первым импортом
        // экземпляр xxxSubjectObj очищается перед началом каждого нового объекта внутри GetChildrenSub()
        when "good" then do:
          if not valid-object(goodSubjectObj)       then goodSubjectObj         = new goods (). // <good>
          if not valid-object(impGoodEventHndlrObj) then do :
            impGoodEventHndlrObj = new impgoods () .
          end .
          v-iSubject = goodSubjectObj .
          v-iImpSub  = impGoodEventHndlrObj .
          // внести new внутрь остальных case, и потом вынести GetChildrenSub и ReceivedSubjectPublish вниз под case
          GetChildrenSub (hNoderef, (level + 1), v-iSubject).
          ReceivedSubjectPublish(v-iSubject, v-iImpSub).
        end.
        when "azk" then do:
          if not valid-object(shopsSubjectObj)       then shopsSubjectObj       = new shops (). // <azk>
          if not valid-object(impShopsEventHndlrObj) then do :
            impShopsEventHndlrObj = new impshops ().
            // impShopsEventHndlrObj:setParent (parparentproc, p-parent-handle, p-log-handle) . - пока не требуется
          end .
          v-iSubject = shopsSubjectObj .
          v-iImpSub  = impShopsEventHndlrObj .
          // внести new внутрь остальных case, и потом вынести GetChildrenSub и ReceivedSubjectPublish вниз под case
          GetChildrenSub (hNoderef, (level + 1), v-iSubject).
          ReceivedSubjectPublish(v-iSubject, v-iImpSub).
        end.
        when "promotion" then do:
          if not valid-object(promotionSubjectObj)       then promotionSubjectObj       = new promotion(). // <promotion>
          if not valid-object(imppromotionEventHndlrObj) then do :
            imppromotionEventHndlrObj = new imppromotion ().
            imppromotionEventHndlrObj:setParent (parparentproc, p-parent-handle, p-log-handle) .
          end .
          v-iSubject = promotionSubjectObj .
          v-iImpSub  = imppromotionEventHndlrObj .
          // внести new внутрь остальных case, и потом вынести GetChildrenSub и ReceivedSubjectPublish вниз под case
          GetChildrenSub (hNoderef, (level + 1), v-iSubject).
          ReceivedSubjectPublish(v-iSubject, v-iImpSub).
        end.
        when "contr-price-doc" then do:
          if not valid-object(contr-price-docsSubjectObj) then contr-price-docsSubjectObj = new contr-price-docs (). // <contr-price-doc>
          if not valid-object(impcontr-price-docsEventHndlrObj) then do :
            impcontr-price-docsEventHndlrObj = new impcontr-price-docs ().
          end .
          v-iSubject = contr-price-docsSubjectObj .
          v-iImpSub  = impcontr-price-docsEventHndlrObj .
          // внести new внутрь остальных case, и потом вынести GetChildrenSub и ReceivedSubjectPublish вниз под case
          GetChildrenSub (hNoderef, (level + 1), v-iSubject).
          ReceivedSubjectPublish(v-iSubject, v-iImpSub).
        end.

        when "business-unit" then do:
          GetChildrenSub (hNoderef, (level + 1), businessUnitsSubjectObj).
          ReceivedSubjectPublish(businessUnitsSubjectObj, impbusinessUnitsEventHndlrObj).
        end.
        when "contractor-group" then do:
          GetChildrenSub (hNoderef, (level + 1), cliGrpSubjectObj).
          ReceivedSubjectPublish(cliGrpSubjectObj, impCliGrpEventHndlrObj).
        end.
        when "contractor" then do:
          GetChildrenSub (hNoderef, (level + 1), clientsSubjectObj).
          ReceivedSubjectPublish(clientsSubjectObj, impClientsEventHndlrObj).
        end.
        when "contract" then do:
          GetChildrenSub (hNoderef, (level + 1), contractsSubjectObj).
          ReceivedSubjectPublish(contractsSubjectObj, impContractsEventHndlrObj).
        end.
        when "norm-loss" then do:
          GetChildrenSub (hNoderef, (level + 1), normlossSubjectObj).
          ReceivedSubjectPublish(normlossSubjectObj, impnormlossEventHndlrObj).
        end.
        when "country" then do:
          GetChildrenSub (hNoderef, (level + 1), countrySubjectObj).
          ReceivedSubjectPublish(countrySubjectObj, impcountryEventHndlrObj).
        end.
        when "currency" then do:
          GetChildrenSub (hNoderef, (level + 1), currencySubjectObj).
          ReceivedSubjectPublish(currencySubjectObj, impCurrencyEventHndlrObj).
        end.
        when "org-unit" then do:
          GetChildrenSub (hNoderef, (level + 1), firmsSubjectObj).
          ReceivedSubjectPublish(firmsSubjectObj, impFirmsEventHndlrObj).
        end.
        when "good-grp" then do:
          GetChildrenSub (hNoderef, (level + 1), goodGrpsSubjectObj).
          ReceivedSubjectPublish(goodGrpsSubjectObj, impGoodGrpsEventHndlrObj).
        end.
        when "payment-type-group" then do:
          GetChildrenSub (hNoderef, (level + 1), paymentTypeGroupSubjectObj).
          ReceivedSubjectPublish(paymentTypeGroupSubjectObj, impPaymentTypeGroupEventHndlrObj).
        end.
        when "payment-type" then do:
          GetChildrenSub (hNoderef, (level + 1), paymentTypeSubjectObj).
          ReceivedSubjectPublish(paymentTypeSubjectObj, impPaymentTypeEventHndlrObj).
        end.
        when "unit" then do:
          GetChildrenSub (hNoderef, (level + 1), unitsSubjectObj).
          ReceivedSubjectPublish(unitsSubjectObj, impUnitsEventHndlrObj).
        end.
        when "cashier" then do:
          GetChildrenSub (hNoderef, (level + 1), cashiersSubjectObj).
          ReceivedSubjectPublish(cashiersSubjectObj, impcashiersEventHndlrObj).
        end.
        when "bank-account" then do:
          GetChildrenSub (hNoderef, (level + 1), bank-accountsSubjectObj).
          ReceivedSubjectPublish(bank-accountsSubjectObj, impbank-accountsEventHndlrObj).
        end.
        when "price-doc" then do:
          GetChildrenSub (hNoderef, (level + 1), price-doc-impSubjectObj).
          ReceivedSubjectPublish(price-doc-impSubjectObj, impprice-docEventHndlrObj).
        end.
        when "int-point" then do:
          GetChildrenSub (hNoderef, (level + 1), int-pointSubjectObj).
          ReceivedSubjectPublish(int-pointSubjectObj, impint-pointEventHndlrObj).
        end.
        when "assortment-matrix" then do:
          GetChildrenSub (hNoderef, (level + 1), assortment-matrixSubjectObj).
          ReceivedSubjectPublish(assortment-matrixSubjectObj, impassortment-matrixEventHndlrObj).
        end.
        when "measuring" then do:
          GetChildrenSub (hNoderef, (level + 1), measuringSubjectObj).
          ReceivedSubjectPublish(measuringSubjectObj, impmeasuringEventHndlrObj).
        end.
        when "recipe" then do:
          GetChildrenSub (hNoderef, (level + 1), recipeSubjectObj).
          ReceivedSubjectPublish(recipeSubjectObj, imprecipeEventHndlrObj).
        end.
        when "transport" then do:
          GetChildrenSub (hNoderef, (level + 1), transportSubjectObj).
          ReceivedSubjectPublish(transportSubjectObj, imptransportEventHndlrObj).
        end.
        when "tank" then do:
          GetChildrenSub (hNoderef, (level + 1), tank-impSubjectObj).
          ReceivedSubjectPublish(tank-impSubjectObj, imptank-impEventHndlrObj).
        end.
        when "trn-gd-doc" then do:
          GetChildrenSub (hNoderef, (level + 1), trn-gd-doc-inSubjectObj).
          ReceivedSubjectPublish(trn-gd-doc-inSubjectObj, imptrn-gd-docEventHndlrObj).
        end.
        when "trn-fuel-doc" then do:
          GetChildrenSub (hNoderef, (level + 1), trn-fuel-doc-inSubjectObj).
          ReceivedSubjectPublish(trn-fuel-doc-inSubjectObj, imptrn-fuel-docEventHndlrObj).
        end.
      end case.
      // --> вставить GetChildrenSub и ReceivedSubjectPublish сюда
      
      // после отработки GetChildrenSub() вызывает GetChildren() и ещё раз просматривает все дочерние элементы сущности верхнего уровня 
      GetChildren(hNoderef, (level + 1)).
    end.
    
    catch exAppErrors as class Progress.Lang.AppError :
      MsgPrivate = exAppErrors:ReturnValue .
      MsgPrivate = exAppErrors:GetMessage(1) .
      ErrSts = true.
      undo, throw exAppErrors .
    end catch .
    catch exProErrors as class Progress.Lang.ProError :
      MsgPrivate = exProErrors:GetMessage(1) . 
      ErrSts = true.
      undo, throw exProErrors .
    end catch .
    catch exAnyErrors as class Progress.Lang.Error:
      MsgPrivate = "Unexpected error occurred..." .
      ErrSts   = true.
      undo, throw exAnyErrors .
    end catch .
    finally :
      // если мы зашли внутрь пустого элемента <tag/> - его num-children = 0 и объекты hNoderef и hText не созданы 
      if valid-object(hNoderef) then delete object hNoderef.
      if valid-object(hText)    then delete object hText.
    end finally .
    
  end method.
  
  method private void ReceivedSubjectPublish (
      input Subject as class ibs.th.bge.1crn.subjects.isubject, input EventHndlrImpSub as class ibs.th.bge.1crn.import.iimpsubject):
        
    ReceivedSubject:Publish(Subject, EventHndlrImpSub).
    
    catch exAppErrors as class Progress.Lang.AppError :
      MsgPrivate = EventHndlrImpSub:Msg .
      MsgPrivate = exAppErrors:GetMessage(1) .
      ErrSts = true.
      return error.
    end catch .
    catch exProErrors as class Progress.Lang.ProError :
      MsgPrivate = exProErrors:GetMessage(1) . 
      ErrSts = true.
      return error.
    end catch .
    catch exAnyErrors as class Progress.Lang.Error:
      MsgPrivate = "Unexpected error occurred..." .
      ErrSts = true.
      return error.
    end catch .
    
  end method.
  
  method private void GetChildrenSub (
    input hParent as handle,
    input level as integer, input subjectObj as class isubject):
    define variable i            as integer   no-undo.
    define variable hNoderef     as handle    no-undo.
    define variable hText        as handle    no-undo.
    define variable v-need-parse as logical   no-undo .
    create x-noderef hNoderef.
    create x-noderef hText .
    
    if valid-object (subjectObj) then do: 
      subjectObj:SetProp( hParent:name, "").
      
      /* обработка атрибутов самого объекта (выполняется после инициализации объекта) */
      case hparent:name :
        when "schedule" then do: // promotion:schedule; subjectObj = promotionSheduleObj
          // вместо тега <sch-code> могу прислать аттрибут "sch-code"
          subjectObj:SetProp( "sch-code" , hparent:get-attribute ("sch-code") ).
        end .
        otherwise .
      end case .
    end. // end_of_valid_object_subjectObj

      
    repeat i = 1 to hParent:num-children:
      good = hparent:get-child(hnoderef,i) no-error.
      if not good then 
          leave.
      if hnoderef:subtype <> "element" then
          next.
      /* htext = содержимое тега: <tag>htext</tag>
         для обязательных тегов значение должно быть определено */
      good = hnoderef:get-child(htext, 1) no-error .
      if not good
        then next.
      iNum = iNum + 1.

      /* обработка элементов, вложенных в секции (классы, вложенные в коллекции или в родительские классы) */
      case hnoderef:name:
        /* ----- имена секций любого уровня вложенности ----- */
        when "recipe-gds" or
        when "sections" or when "calibration-table" or
        when "cal-tbl" or
        when "nb-carriers" or when "nb-suppliers" or when "prts"
        then do:
          GetChildrenSub (hNoderef, (level + 1), ?).
          /* только проваливается дальше в секцию;
             внутри секции:
                или присутствует when с обработкой элемента секции,
                или присуисивует секция, в которую надо провалиться,
                или GetChildrenSub пройдёт насквозь без выполнения действий.
             Правило: на каждое имя секции в текущем when должен быть when c именем элемента секции.
          */
        end.
        when "barcodes" then do :
          v-need-parse = true .
          if v-need-parse and valid-object (goodSubjectObj) then do : // goods:good:barcodes
            if goodSubjectObj:IsInitSubForWrite then do:
              /* !! тег в файле называется barcodes, но InitTag коллекции в классе goods называется barcode !!
                    и InitTag класса goods_barcode тоже называется "barcode" */
              barcodesSubjectsObj = new subjects ("barcode") .
                 GetChildrenSub (hNoderef, (level + 1), ?).
              goodSubjectObj:SetProp (barcodesSubjectsObj).
              v-need-parse = false . 
            end .
          end .
          if v-need-parse then GetChildrenSub (hNoderef, (level + 1), ?).
        end.
        when "barcode" then do: // goods:good:barcodes:barcode
            if not valid-object(barcodesSubjectsObj) then
              undo, throw new Progress.Lang.AppError("отсутствует секция barcodes для перечня barcode") .
            barcodesSubjectsObj:Add(  new goods_barcode()  ).
            good_barcodeSubjectObj = cast (barcodesSubjectsObj:SubjectObjCurr, goods_barcode).
            GetChildrenSub (hNoderef, (level + 1), good_barcodeSubjectObj).
        end.
        when "gds" then do :
          // _SubjectObj[]: валидный только для коллекций, чьи теги присутствуют в импортируемом сейчас пакете;
          v-need-parse = true . 
          // по убыванию уровня вложенности:
          if v-need-parse and valid-object (promotion_psSubjectObj) then do: // promotion:promoset:ps-sections:ps-section:gds
            if promotion_psSubjectObj:IsInitSubForWrite then do:
              promotion_p_gdListSubjectsObj = new subjects ("gds") .
               GetChildrenSub (hNoderef, (level + 1), ?).
              promotion_psSubjectObj:SetProp (promotion_p_gdListSubjectsObj).
              v-need-parse = false .
            end .
          end .
          if v-need-parse and valid-object (promotionSubjectObj) then do: // promotion:gds
            if promotionSubjectObj:IsInitSubForWrite then do: 
              promotion_gdsListSubjectsObj = new subjects ("gds") .
               GetChildrenSub (hNoderef, (level + 1), ?).
              promotionSubjectObj:SetProp (promotion_gdsListSubjectsObj).
              v-need-parse = false .
            end .
          end .
          if v-need-parse then GetChildrenSub (hNoderef, (level + 1), ?).
        end.
        when "gifts" then do :
          v-need-parse = true . 
          if v-need-parse and valid-object (promotion_thresholdSubjectObj) then do : // promotion:thresholds:threshold:gifts
            if promotion_thresholdSubjectObj:IsInitSubForWrite then do:
              promotion_t_giftListSubjectsObj = new subjects ("gifts") .
                   GetChildrenSub (hNoderef, (level + 1), ?).
              promotion_thresholdSubjectObj:SetProp (promotion_t_giftListSubjectsObj).
              v-need-parse = false . 
            end .
          end .
          if v-need-parse and valid-object (promotionSubjectObj) then do : // promotion:gifts
            if promotionSubjectObj:IsInitSubForWrite then do:
              promotion_giftListSubjectsObj = new subjects ("gifts") .        
                 GetChildrenSub (hNoderef, (level + 1), ?).
              promotionSubjectObj:SetProp (promotion_giftListSubjectsObj).
              v-need-parse = false . 
            end .
          end .
          if v-need-parse then GetChildrenSub (hNoderef, (level + 1), ?).
        end.
        when "price-list" then do :
          v-need-parse = true .
          if v-need-parse and valid-object (contr-price-docsSubjectObj) then do : // contr-price-docs:price-list
            if contr-price-docsSubjectObj:IsInitSubForWrite then do:
              price-listSubjectsObj = new subjects ("price-list") .
                 GetChildrenSub (hNoderef, (level + 1), ?).
              contr-price-docsSubjectObj:SetProp (price-listSubjectsObj).
              v-need-parse = false . 
            end .
          end .
          if v-need-parse then GetChildrenSub (hNoderef, (level + 1), ?).
        end.
        when "gds-sale" then do: /*второй уровень с данными. обработка зависимой сущности gds-sale */
          v-need-parse = true . 
          if v-need-parse and valid-object (contr-price-docsSubjectObj) then do: // contr-price-doc:price-list:gds-sale
            if contr-price-docsSubjectObj:IsInitSubForWrite then do: /*идет запись спецификации*/
              price-listSubjectsObj:Add(  new contr-price-docs_price-list()  ).
              contr-price-listSubjectObj = cast (price-listSubjectsObj:SubjectObjCurr, contr-price-docs_price-list).
              GetChildrenSub (hNoderef, (level + 1), contr-price-listSubjectObj).
              v-need-parse = false .
            end .
          end .
          if v-need-parse then        
          case true : 
            when price-doc-impSubjectObj:IsInitSubForWrite then do: /*идет запись переоценки*/
              if not valid-object(price-doc-listSubjectsObj) then price-doc-listSubjectsObj = new subjects("gds-sale") .
              price-doc-listSubjectsObj:Add(new price-doc_gds-sale()). /* а вот здесь уже создаем объект сущнности*/
              price-doc_gds-saleSubjectObj = cast (price-doc-listSubjectsObj:SubjectObjCurr, price-doc_gds-sale).
              GetChildrenSub (hNoderef, (level + 1), price-doc_gds-saleSubjectObj).
              price-doc-impSubjectObj:SetProp (price-doc-listSubjectsObj).
              v-need-parse = false .
            end.
            otherwise do:
              
            end.
          end case.
          if v-need-parse then GetChildrenSub (hNoderef, (level + 1), ?).
        end.
        
        when "recipe-gd" then do: /* второй уровень с данными. обработка зависимой сущности recipe-gd  */
          case true : 
            when recipeSubjectObj:IsInitSubForWrite then do: /*идет запись рецепта*/  
              if not valid-object(recipe-gd-listSubjectsObj) then recipe-gd-listSubjectsObj = new subjects ("recipe-gds") .    
              recipe-gd-listSubjectsObj:Add(new recipe-gd()). /* а вот здесь уже создаем объект сущнности*/
              recipe-gdSubjectObj = cast (recipe-gd-listSubjectsObj:SubjectObjCurr, recipe-gd).
              GetChildrenSub (hNoderef, (level + 1), recipe-gdSubjectObj).
              recipeSubjectObj:SetProp (recipe-gd-listSubjectsObj).
            end.
            otherwise do:
              
            end.
          end case.
        end.
        when "section" then do: /* второй уровень с данными. обработка зависимой сущности transportSubjectObj  */
          case true : 
            when transportSubjectObj:IsInitSubForWrite then do: /*идет запись transportSubjectObj*/   
              if not valid-object(transport_section-listSubjectsObj) then transport_section-listSubjectsObj = new subjects ("sections") .     
              transport_section-listSubjectsObj:Add(new transport_section()). /* а вот здесь уже создаем объект сущнности*/
              transport_sectionSubjectObj = cast (transport_section-listSubjectsObj:SubjectObjCurr, transport_section).
              GetChildrenSub (hNoderef, (level + 1), transport_sectionSubjectObj).
              transportSubjectObj:SetProp (transport_section-listSubjectsObj).
            end.
            otherwise do:
              
            end.
          end case.
        end.
        when "ct-lvl" then do: /* второй уровень с данными. обработка зависимой сущности transportSubjectObj  */
          case true : 
            when transportSubjectObj:IsInitSubForWrite then do: /*идет запись transportSubjectObj*/  
              if not valid-object(transport_section_ct-lvl-listSubjectsObj) then transport_section_ct-lvl-listSubjectsObj = new subjects ("calibration-table") .        
              transport_section_ct-lvl-listSubjectsObj:Add(new transport_section_ct-lvl()). /* а вот здесь уже создаем объект сущнности*/
              transport_section_ct-lvlSubjectObj = cast (transport_section_ct-lvl-listSubjectsObj:SubjectObjCurr, transport_section_ct-lvl).
              GetChildrenSub (hNoderef, (level + 1), transport_section_ct-lvlSubjectObj).
              transportSubjectObj:SetProp (transport_section_ct-lvl-listSubjectsObj).
            end.
            otherwise do:
              
            end.
          end case.
        end.
        when "bank" then do: /*идет запись bank-accounts_bankSubjectObj*/  
          if not valid-object(bank-accounts_bankSubjectObj) then bank-accounts_bankSubjectObj = new bank-accounts_bank ().  .        
          /* а вот здесь уже создаем объект сущнности*/
          GetChildrenSub (hNoderef, (level + 1), bank-accounts_bankSubjectObj).
          bank-accountsSubjectObj:SetProp (bank-accounts_bankSubjectObj).
        end.
        when "schedule" then do: // promotion:schedule
          // экземпляр promotionSheduleObj создаётся перед импортом первой промо-акции
          if not valid-object(promotionSheduleObj) then
            promotionSheduleObj = new promotion_schedule().
          // экземпляр promotionSheduleObj очищается внутри GetChildrenSub()
          GetChildrenSub (hNoderef, (level + 1), promotionSheduleObj).
          // экземпляр promotionSheduleObj постоянно перепокладывается в промо-акцию
          promotionSubjectObj:SetProp (promotionSheduleObj). // здесь promotionSubjectObj = subjectObj
        end .
        when "schedule-lines" then do : // promotion:schedule:schedule-lines
          if not valid-object(promotionSheduleObj) then
            undo, throw new Progress.Lang.AppError("отсутствует секция schedule для секции schedule-lines") .
          if promotionSheduleObj:IsInitSubForWrite then do:
            promotion_shedule-lineListSubjectsObj = new subjects ("schedule-lines").
            GetChildrenSub (hNoderef, (level + 1), ?).
            promotionSheduleObj:SetProp (promotion_shedule-lineListSubjectsObj).
          end .
        end.
        when "schedule-line" then do: // promotion:schedule:schedule-lines:schedule-line
            if not valid-object(promotion_shedule-lineListSubjectsObj) then
              undo, throw new Progress.Lang.AppError("отсутствует секция schedule-lines для перечня schedule-line") .
            promotion_shedule-lineListSubjectsObj:Add(  new promotion_schedule-line()  ).
            promotion_shedule-lineSubjectObj = cast (promotion_shedule-lineListSubjectsObj:SubjectObjCurr, promotion_schedule-line).
            GetChildrenSub (hNoderef, (level + 1), promotion_shedule-lineSubjectObj).
        end.
        when "thresholds" then do : // promotion:thresholds
          if promotionSubjectObj:IsInitSubForWrite then do:
            promotion_thresholdListSubjectsObj = new subjects ("thresholds") .
            GetChildrenSub (hNoderef, (level + 1), ?).
            promotionSubjectObj:SetProp (promotion_thresholdListSubjectsObj).
          end .
        end.
        when "threshold" then do: // promotion:thresholds:threshold
          if promotionSubjectObj:IsInitSubForWrite then do:
            promotion_thresholdListSubjectsObj:Add(  new promotion_threshold()  ).
            promotion_thresholdSubjectObj = cast (promotion_thresholdListSubjectsObj:SubjectObjCurr, promotion_threshold).
            GetChildrenSub (hNoderef, (level + 1), promotion_thresholdSubjectObj).
          end .
        end.
        when "gds-addcond" then do : // promotion:gds-addcond
          if promotionSubjectObj:IsInitSubForWrite then do:
            promotion_gdListSubjectsObj = new subjects ("gds-addcond") .
               GetChildrenSub (hNoderef, (level + 1), ?).
            promotionSubjectObj:SetProp (promotion_gdListSubjectsObj).
          end .
        end.
        when "promoset" then do: // promotion:promoset
          if not valid-object(promotionPromosetObj) then
            promotionPromosetObj = new promotion_promoset().
          GetChildrenSub (hNoderef, (level + 1), promotionPromosetObj).
          promotionSubjectObj:SetProp (promotionPromosetObj).
        end .
        when "ps-sections" then do : // promotion:promoset:ps-sections
          if promotionPromosetObj:IsInitSubForWrite then do:
            promotion_psListSubjectsObj = new subjects ("ps-sections").
            GetChildrenSub (hNoderef, (level + 1), ?).
            promotionPromosetObj:SetProp (promotion_psListSubjectsObj).
          end .
        end.
        when "ps-section" then do: // promotion:promoset:ps-sections:ps-section
          if promotionPromosetObj:IsInitSubForWrite then do :
            promotion_psListSubjectsObj:Add(  new promotion_ps-section()  ).
            promotion_psSubjectObj = cast (promotion_psListSubjectsObj:SubjectObjCurr, promotion_ps-section).
            GetChildrenSub (hNoderef, (level + 1), promotion_psSubjectObj).
          end .
        end.
        when "cal-tbl" then do: /* второй уровень с данными. обработка зависимой сущности transportSubjectObj  */
          case true : 
            when tank-impSubjectObj:IsInitSubForWrite then do: /*идет запись transportSubjectObj*/  
              if not valid-object(tank-imp_cal-tbllistSubjectsObj) then tank-imp_cal-tbllistSubjectsObj = new subjects ("cal-tbl") .        
              tank-imp_cal-tbllistSubjectsObj:Add(new tank-imp_cal-tbl()). /* а вот здесь уже создаем объект сущнности*/
              tank-imp_cal-tblSubjectObj = cast (tank-imp_cal-tbllistSubjectsObj:SubjectObjCurr, tank-imp_cal-tbl).
              GetChildrenSub (hNoderef, (level + 1), transport_section_ct-lvlSubjectObj).
              tank-impSubjectObj:SetProp (tank-imp_cal-tbllistSubjectsObj).
            end.
            otherwise do:
              
            end.
          end case.
        end.
        when "cal-tbl-line" then do: /* второй уровень с данными. обработка зависимой сущности transportSubjectObj  */
          case true : 
            when tank-impSubjectObj:IsInitSubForWrite then do: /*идет запись transportSubjectObj*/  
              if not valid-object(tank-imp_cal-tbllistSubjectsObj) then tank-imp_cal-tbllistSubjectsObj = new subjects ("cal-tbl") .        
              tank-imp_cal-tbllistSubjectsObj:Add(new tank-imp_cal-tbl()). /* а вот здесь уже создаем объект сущнности*/
              tank-imp_cal-tblSubjectObj = cast (tank-imp_cal-tbllistSubjectsObj:SubjectObjCurr, tank-imp_cal-tbl).
              GetChildrenSub (hNoderef, (level + 1), tank-imp_cal-tblSubjectObj).
              tank-impSubjectObj:SetProp (tank-imp_cal-tbllistSubjectsObj).
            end.
            otherwise do:
              
            end.
          end case.
        end.
        when "gd" then do: /* второй уровень с данными. обработка зависимой сущности transportSubjectObj  */
          case true : 
            when trn-gd-doc-inSubjectObj:IsInitSubForWrite then do: /*идет запись transportSubjectObj*/  
              if not valid-object(trn-gd-doc-inlistSubjectsObj) then trn-gd-doc-inlistSubjectsObj = new subjects ("gds") .        
              trn-gd-doc-inlistSubjectsObj:Add(new trn-gd()). /* а вот здесь уже создаем объект сущнности*/
              trn-gdSubjectObj = cast (trn-gd-doc-inlistSubjectsObj:SubjectObjCurr, trn-gd).
              GetChildrenSub (hNoderef, (level + 1), trn-gdSubjectObj).
              trn-gd-doc-inSubjectObj:SetProp (trn-gd-doc-inlistSubjectsObj).
            end.
            when trn-fuel-doc-inSubjectObj:IsInitSubForWrite then do: /*идет запись transportSubjectObj*/  
              if not valid-object(trn-fuel-doc-inlistSubjectsObj) then trn-fuel-doc-inlistSubjectsObj = new subjects ("gds") .        
              trn-fuel-doc-inlistSubjectsObj:Add(new trn-gd-fuel()). /* а вот здесь уже создаем объект сущнности*/
              trn-gd-fuelSubjectObj = cast (trn-fuel-doc-inlistSubjectsObj:SubjectObjCurr, trn-gd-fuel).
              GetChildrenSub (hNoderef, (level + 1), trn-gd-fuelSubjectObj).
              trn-fuel-doc-inSubjectObj:SetProp (trn-fuel-doc-inlistSubjectsObj).
            end.
            when promotionSubjectObj:IsInitSubForWrite then do: // все :gd, прямо или косвенно вложенные в promotion
              v-need-parse = true . 
              if v-need-parse and valid-object (promotion_psSubjectObj) then do : // promotion:promoset:ps-sections:ps-section:gds:gd
                if promotion_psSubjectObj:IsInitSubForWrite then do:
                  promotion_p_gdListSubjectsObj:Add(  new promotion_gd()  ).
                  promotion_p_gdSubjectObj = cast (promotion_p_gdListSubjectsObj:SubjectObjCurr, promotion_gd).
                  GetChildrenSub (hNoderef, (level + 1), promotion_p_gdSubjectObj).
                  v-need-parse = false .
                end.
              end .
              if v-need-parse and valid-object (promotion_thresholdSubjectObj) then do : // promotion:thresholds:threshold:gifts:gd
                if promotion_thresholdSubjectObj:IsInitSubForWrite then do:
                  promotion_t_giftListSubjectsObj:Add(  new promotion_gift-gd()  ).
                  promotion_t_giftSubjectObj = cast (promotion_t_giftListSubjectsObj:SubjectObjCurr, promotion_gift-gd).
                  GetChildrenSub (hNoderef, (level + 1), promotion_t_giftSubjectObj).
                  v-need-parse = false .
                end.
              end .
              if v-need-parse then do :
                v-need-parse = false .
                case hParent:name :
                // один блок обработки на три коллекции:
                // родительский объект разложит их по местам внутри promotion:SetProp                
                when "gds" then do: // promotion:gds:gd
                  promotion_gdsListSubjectsObj:Add(  new promotion_gds-gd()  ).
                  promotion_gdsSubjectObj = cast (promotion_gdsListSubjectsObj:SubjectObjCurr, promotion_gds-gd).
                  GetChildrenSub (hNoderef, (level + 1), promotion_gdsSubjectObj).
                end .                
                when "gds-addcond" then do: // promotion:gds-addcond:gd
                  promotion_gdListSubjectsObj:Add(  new promotion_gd()  ).
                  promotion_gdSubjectObj = cast (promotion_gdListSubjectsObj:SubjectObjCurr, promotion_gd).
                  GetChildrenSub (hNoderef, (level + 1), promotion_gdSubjectObj).
                end .
                when "gifts" then do: // promotion:gifts:gd
                  promotion_giftListSubjectsObj:Add(  new promotion_gift-gd()  ).
                  promotion_giftSubjectObj = cast (promotion_giftListSubjectsObj:SubjectObjCurr, promotion_gift-gd).
                  GetChildrenSub (hNoderef, (level + 1), promotion_giftSubjectObj).
                end .
                otherwise v-need-parse = true .
                end case .
              end .  
            end . // end_of_promotionSubjectObj
            otherwise do:
              
            end.
          end case.
        end.
        when "prt" then do: /* второй уровень с данными. обработка зависимой сущности transportSubjectObj  */
          case true : 
            when trn-gd-doc-inSubjectObj:IsInitSubForWrite then do: /*идет запись transportSubjectObj*/
              if not valid-object(trn-prt-doc-inlistSubjectsObj) then trn-prt-doc-inlistSubjectsObj = new subjects ("prts") .        
              trn-prt-doc-inlistSubjectsObj:Add(new trn-prt()). /* а вот здесь уже создаем объект сущнности*/
              trn-prtSubjectObj = cast (trn-prt-doc-inlistSubjectsObj:SubjectObjCurr, trn-prt).
              GetChildrenSub (hNoderef, (level + 1), trn-prtSubjectObj).
              trn-gd-doc-inSubjectObj:SetProp (trn-prt-doc-inlistSubjectsObj).
            end.
          end.
        end.
        when "nb-carrier" then do: /* второй уровень с данными. обработка зависимой сущности clientsSubjectObj  */
          case true : 
            when clientsSubjectObj:IsInitSubForWrite then do: /*идет запись clientsSubjectObj*/  
              if not valid-object(clients_carriersListSubjectObj) then clients_carriersListSubjectObj = new subjects ("nb-carriers") .        
              clients_carriersListSubjectObj:Add(new clients_carriers()). /* а вот здесь уже создаем объект сущнности*/
              clients_carriersSubjectObj = cast (clients_carriersListSubjectObj:SubjectObjCurr, clients_carriers).
              GetChildrenSub (hNoderef, (level + 1), clients_carriersSubjectObj).
              clientsSubjectObj:SetProp (clients_carriersListSubjectObj).
            end.
            otherwise do:
              
            end.
          end case.
        end.
        when "nb-supplier" then do: /* второй уровень с данными. обработка зависимой сущности clientsSubjectObj  */
          case true : 
            when clientsSubjectObj:IsInitSubForWrite then do: /*идет запись clientsSubjectObj*/  
              if not valid-object(clients_suppliersListSubjectObj) then clients_suppliersListSubjectObj = new subjects ("nb-suppliers") .        
              clients_suppliersListSubjectObj:Add(new clients_suppliers()). /* а вот здесь уже создаем объект сущнности*/
              clients_suppliersSubjectObj = cast (clients_suppliersListSubjectObj:SubjectObjCurr, clients_suppliers).
              GetChildrenSub (hNoderef, (level + 1), clients_suppliersSubjectObj).
              clientsSubjectObj:SetProp (clients_suppliersListSubjectObj).
            end.
            otherwise do:
              
            end.
          end case.
        end.
        when "unit-add-codes" then do :
          v-need-parse = true .
          if v-need-parse and valid-object (goodSubjectObj) then do : // goods:good:unit-add-codes
            if goodSubjectObj:IsInitSubForWrite then do:
              unitaddsSubjectsObj = new subjects ("unit-add-codes") .
                 GetChildrenSub (hNoderef, (level + 1), ?).
              goodSubjectObj:SetProp (unitaddsSubjectsObj).
              v-need-parse = false . 
            end .
          end .
          if v-need-parse then GetChildrenSub (hNoderef, (level + 1), ?).
        end.
        when "unit-add-code" then do: // goods:good:unit-add-codes:unit-add-code
            if not valid-object(unitaddsSubjectsObj) then
              undo, throw new Progress.Lang.AppError("отсутствует секция unit-add-codes для перечня unit-add-code") .
            unitaddsSubjectsObj:Add(  new unit-add-code()  ).
            good_unitaddSubjectObj = cast (unitaddsSubjectsObj:SubjectObjCurr, unit-add-code).
            GetChildrenSub (hNoderef, (level + 1), good_unitaddSubjectObj).
        end.
        
        /* ----- конечный уровень
                 (не коллекции, не классы, только сами поля классов скалярного типа) ----- */
        otherwise do:
          if valid-object(subjectObj) then subjectObj:SetProp( hNoderef:name, hText:node-value).
        end.
      end case.
    end.
    if valid-object (subjectObj)
      then subjectObj:SetProp( hParent:name, "").
    delete object hNoderef.
    /* между закрывающим и следующим закрывающим тегами может не быть ни одного ELEMENT,
       и тогда hText не будет определён */
    if valid-object(hText) then delete object hText.
  end method.
  
	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	destructor public parsesub ( ):
/*    delete object businessUnitsSubjectObj no-error.         */
/*    delete object impbusinessUnitsEventHndlrObj no-error.   */
/*    delete object cliGrpSubjectObj no-error.                */
/*    delete object impClientsEventHndlrObj no-error.         */
/*    delete object contractsSubjectObj no-error.             */
/*    delete object impContractsEventHndlrObj no-error.       */
/*    delete object countrySubjectObj no-error.               */
/*    delete object impcountryEventHndlrObj no-error.         */
/*    delete object currencySubjectObj no-error.              */
/*    delete object impCurrencyEventHndlrObj no-error.        */
/*    delete object firmsSubjectObj no-error.                 */
/*    delete object impFirmsEventHndlrObj no-error.           */
/*    delete object goodGrpsSubjectObj no-error.              */
/*    delete object impGoodGrpsEventHndlrObj no-error.        */
/*    delete object paymentTypeGroupSubjectObj no-error.      */
/*    delete object impPaymentTypeGroupEventHndlrObj no-error.*/
/*    delete object paymentTypeSubjectObj no-error.           */
/*    delete object impPaymentTypeEventHndlrObj no-error.     */
/*    delete object shopsSubjectObj no-error.                 */
/*    delete object impShopsEventHndlrObj no-error.           */
/*    delete object unitsSubjectObj no-error.                 */
/*    delete object impUnitsEventHndlrObj no-error.           */
/*    delete object goodSubjectObj no-error.                  */
/*    delete object impGoodEventHndlrObj no-error.            */
/*    delete object cashiersSubjectObj no-error.              */
/*    delete object impcashiersEventHndlrObj no-error.        */
/*    delete object bank-accountsSubjectObj no-error.         */
/*    delete object impbank-accountsEventHndlrObj no-error.   */
/*    delete object contr-price-docsSubjectObj no-error.      */
/*    delete object impcontr-price-docsEventHndlrObj no-error.*/
        
	end destructor.

  
end class.