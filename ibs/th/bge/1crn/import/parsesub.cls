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
  
  
  define public event ReceivedSubject signature void (input Subject as class ibs.th.bge.1crn.subjects.isubject, input EventHndlrImpSub as class ibs.th.bge.1crn.import.iimpsubject).

  define variable countrySubjectObj                        as class country                     no-undo.
  define variable impcountryEventHndlrObj                  as class impcountry                  no-undo.
  
  define variable cliGrpSubjectObj                         as class cli-grps                    no-undo.
  define variable impCliGrpEventHndlrObj                   as class impcli-grps                 no-undo.
  
  define variable businessUnitsSubjectObj                  as class business-units              no-undo.
  define variable impbusinessUnitsEventHndlrObj            as class impbusiness-units           no-undo.
  
  define variable clientsSubjectObj                        as class clients                     no-undo.
  define variable impClientsEventHndlrObj                  as class impclients                  no-undo.

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
  define variable impGoodEventHndlrObj                     as class impgoods                    no-undo.
  
  define variable cashiersSubjectObj                       as class cashiers                    no-undo.
  define variable impcashiersEventHndlrObj                 as class impcashiers                 no-undo.    

  define variable bank-accountsSubjectObj                  as class bank-accounts               no-undo.
  define variable impbank-accountsEventHndlrObj            as class impbank-accounts            no-undo.

  define variable contr-price-docsSubjectObj               as class contr-price-docs            no-undo.
  define variable contr-price-listSubjectObj               as class contr-price-docs_price-list no-undo.
  define variable impcontr-price-docsEventHndlrObj         as class impcontr-price-docs         no-undo.

  define variable price-doc-impSubjectObj                  as class price-doc-imp               no-undo.
  define variable price-doc_gds-saleSubjectObj             as class price-doc_gds-sale          no-undo.
  define variable impprice-docEventHndlrObj                as class impprice-doc                no-undo.

  define variable price-listSubjectsObj                    as class subjects                    no-undo.

  define variable int-pointSubjectObj                      as class int-point                   no-undo.
  define variable impint-pointEventHndlrObj                as class impint-point                no-undo.

  define variable assortment-matrixSubjectObj              as class assortment-matrix           no-undo.
  define variable impassortment-matrixEventHndlrObj        as class impassortment-matrix        no-undo.

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
  
  
  define variable good as logical no-undo.

  define property Msg as character no-undo
    get. 
    set.

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
    impClientsEventHndlrObj = new impclients ().

    contractsSubjectObj = new contracts ().
    impContractsEventHndlrObj = new impcontracts ().

    currencySubjectObj = new currency ().
    impCurrencyEventHndlrObj = new impcurrency ().
    
    firmsSubjectObj = new firms ().
    impFirmsEventHndlrObj = new impfirms ().
    
    goodGrpsSubjectObj = new good-grps ().
    impGoodGrpsEventHndlrObj = new impgood-grps ().

    paymentTypeSubjectObj = new payment-type ().
    impPaymentTypeEventHndlrObj = new imppayment-type ().
    
    shopsSubjectObj = new shops ().
    impShopsEventHndlrObj = new impshops ().
    
    paymentTypeGroupSubjectObj = new payment-type-group ().
    impPaymentTypeGroupEventHndlrObj = new imppayment-type-group ().

    unitsSubjectObj = new units ().
    impUnitsEventHndlrObj = new impunits ().
    
    goodSubjectObj = new goods ().
    impGoodEventHndlrObj = new impgoods () .
    
    cashiersSubjectObj = new cashiers ().
    impcashiersEventHndlrObj = new impcashiers (). 
		
		bank-accountsSubjectObj = new bank-accounts ().
    impbank-accountsEventHndlrObj = new impbank-accounts ().
    

    price-listSubjectsObj = new subjects("gds-sale").

    contr-price-docsSubjectObj = new contr-price-docs ().
    impcontr-price-docsEventHndlrObj = new impcontr-price-docs ().

    price-doc-impSubjectObj = new price-doc-imp ().
    impprice-docEventHndlrObj = new impprice-doc ().

    int-pointSubjectObj = new int-point ().
    impint-pointEventHndlrObj = new impint-point ().

    assortment-matrixSubjectObj = new assortment-matrix ().
    impassortment-matrixEventHndlrObj = new impassortment-matrix ().

    recipeSubjectObj = new recipe ().
    imprecipeEventHndlrObj = new imprecipe ().
    recipe-gd-listSubjectsObj = new subjects ("recipe-gds").

    transportSubjectObj = new transport ().
    imptransportEventHndlrObj = new imptransport ().
    transport_section-listSubjectsObj = new subjects ("sections").
    transport_section_ct-lvl-listSubjectsObj = new subjects ("calibration-table").

		
  end constructor.
  
  

  method public logical Parse1CRNSub (input inFileName as character):
		
    define variable result as logical no-undo.

    define variable hDoc as handle no-undo.
    define variable hRoot as handle no-undo.

    create x-document hDoc.
    create x-noderef hRoot.

    hDoc:load("file",inFileName,false).
           
    hDoc:get-document-element(hRoot).
            
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

    create x-noderef hNoderef.
    create x-noderef hText .

    repeat i = 1 to hParent:num-children:
      good = hparent:get-child(hnoderef,i).
      if not good then 
          leave.
      if hnoderef:subtype <> "element" then
          next.
      hnoderef:get-child(htext, 1) no-error .
      case hNoderef:name:
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
        when "azk" then do:
          GetChildrenSub (hNoderef, (level + 1), shopsSubjectObj).
          ReceivedSubjectPublish(shopsSubjectObj, impShopsEventHndlrObj).
        end.
        when "unit" then do:
          GetChildrenSub (hNoderef, (level + 1), unitsSubjectObj).
          ReceivedSubjectPublish(unitsSubjectObj, impUnitsEventHndlrObj).
        end.
        when "good" then do:
          GetChildrenSub (hNoderef, (level + 1), goodSubjectObj).
          ReceivedSubjectPublish(goodSubjectObj, impGoodEventHndlrObj).
        end.
        when "cashier" then do:
          GetChildrenSub (hNoderef, (level + 1), cashiersSubjectObj).
          ReceivedSubjectPublish(cashiersSubjectObj, impcashiersEventHndlrObj).
        end.
        when "bank-account" then do:
          GetChildrenSub (hNoderef, (level + 1), bank-accountsSubjectObj).
          ReceivedSubjectPublish(bank-accountsSubjectObj, impbank-accountsEventHndlrObj).
        end.
        when "contr-price-doc" then do:
          GetChildrenSub (hNoderef, (level + 1), contr-price-docsSubjectObj).
          ReceivedSubjectPublish(contr-price-docsSubjectObj, impcontr-price-docsEventHndlrObj).
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
        when "recipe" then do:
          GetChildrenSub (hNoderef, (level + 1), recipeSubjectObj).
          ReceivedSubjectPublish(recipeSubjectObj, imprecipeEventHndlrObj).
        end.
        when "transport" then do:
          GetChildrenSub (hNoderef, (level + 1), transportSubjectObj).
          ReceivedSubjectPublish(transportSubjectObj, imptransportEventHndlrObj).
        end.
        
      end case.
      GetChildren(hNoderef, (level + 1)).
    end.
    
    catch exAppErrors as class Progress.Lang.AppError :
      Msg = Msg + "; " + exAppErrors:ReturnValue .
      if Msg = "" then Msg = exAppErrors:GetMessage(1) .
      ErrSts = true.
      undo, throw exAppErrors .
    end catch .
    catch exProErrors as class Progress.Lang.ProError :
      Msg = exProErrors:GetMessage(1) . 
      ErrSts = true.
      undo, throw exProErrors .
    end catch .
    catch exAnyErrors as class Progress.Lang.Error:
      Msg = "Unexpected error occurred..." .
      ErrSts   = true.
      undo, throw exAnyErrors .
    end catch .
    finally :
      delete object hNoderef.
      delete object hText.
    end finally .
    
  end method.
  
  method private void ReceivedSubjectPublish (
      input Subject as class ibs.th.bge.1crn.subjects.isubject, input EventHndlrImpSub as class ibs.th.bge.1crn.import.iimpsubject):
        
    ReceivedSubject:Publish(Subject, EventHndlrImpSub).
    
    catch exAppErrors as class Progress.Lang.AppError :
      Msg = EventHndlrImpSub:Msg .
      if Msg = "" then Msg = exAppErrors:GetMessage(1) .
      ErrSts = true.
      return error.
    end catch .
    catch exProErrors as class Progress.Lang.ProError :
      Msg = exProErrors:GetMessage(1) . 
      ErrSts = true.
      return error.
    end catch .
    catch exAnyErrors as class Progress.Lang.Error:
      Msg = "Unexpected error occurred..." .
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
    create x-noderef hNoderef.
    create x-noderef hText .
    if valid-object (subjectObj)
      then subjectObj:SetProp( hParent:name, "").
    repeat i = 1 to hParent:num-children:
      good = hparent:get-child(hnoderef,i) no-error.
      if not good then 
          leave.
      if hnoderef:subtype <> "element" then
          next.
      good = hnoderef:get-child(htext, 1) no-error .
      if not good
        then next.
      /*обработка зависимых объектов.*/
      case hnoderef:name:
        when "price-list" or when "recipe-gds" or
        when "sections" or when "calibration-table"
        then do: /*первый уровень. зависимых объектов gds-sale или Рецепты recipe-gds  */
          GetChildrenSub (hNoderef, (level + 1), ?). /*проваливаемся дальше в секцию*/
        end.
        when "gds-sale" then do: /*второй уровень с данными. обработка зависимой сущности gds-sale */
          case true : 
            when price-doc-impSubjectObj:IsInitSubForWrite then do: /*идет запись переоценки*/
              price-listSubjectsObj:Add(new price-doc_gds-sale()). /* а вот здесь уже создаем объект сущнности*/
              price-doc_gds-saleSubjectObj = cast (price-listSubjectsObj:SubjectObjCurr, price-doc_gds-sale).
              GetChildrenSub (hNoderef, (level + 1), price-doc_gds-saleSubjectObj).
              price-doc-impSubjectObj:SetProp (price-listSubjectsObj).
            end.
            when contr-price-docsSubjectObj:IsInitSubForWrite then do: /*идет запись спецификации*/
              price-listSubjectsObj:Add(new contr-price-docs_price-list()). /* а вот здесь уже создаем объект сущнности*/
              contr-price-listSubjectObj = cast (price-listSubjectsObj:SubjectObjCurr, contr-price-docs_price-list).
              GetChildrenSub (hNoderef, (level + 1), contr-price-listSubjectObj).
              contr-price-docsSubjectObj:SetProp (price-listSubjectsObj).
            end.
            otherwise do:
              
            end.
          end case.
        end.
        when "recipe-gd" then do: /* второй уровень с данными. обработка зависимой сущности recipe-gd  */
          case true : 
            when recipe-gdSubjectObj:IsInitSubForWrite then do: /*идет запись рецепта*/        
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
              transport_section_ct-lvl-listSubjectsObj:Add(new transport_section_ct-lvl()). /* а вот здесь уже создаем объект сущнности*/
              transport_section_ct-lvlSubjectObj = cast (transport_section_ct-lvl-listSubjectsObj:SubjectObjCurr, transport_section_ct-lvl).
              GetChildrenSub (hNoderef, (level + 1), transport_section_ct-lvlSubjectObj).
              transportSubjectObj:SetProp (transport_section_ct-lvl-listSubjectsObj).
            end.
            otherwise do:
              
            end.
          end case.
        end.
        otherwise do: /*конечный уровень*/
          subjectObj:SetProp( hNoderef:name, hText:node-value).
        end.
      end.
    end.
    if valid-object (subjectObj)
      then subjectObj:SetProp( hParent:name, "").
    delete object hNoderef.
    delete object hText.
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