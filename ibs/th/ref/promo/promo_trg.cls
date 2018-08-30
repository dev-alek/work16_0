/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Экранные триггеры промо-акций

Автор: Молотков Сергей
Дата создания: 21/06/18
Author: Molotkov Sergey
Creation date: 21/06/18

Состав:
1 вызовы из списка акций:
1.1 получить таблицу акций для отображения в data-grid -> m-storage:getItems()
1.2а вызвать форму ввода и создать одну акцию       -> m-storage:getItem(), insert, update
1.2б вызвать форму ввода и редактировать одну акцию -> m-storage:getItem(), insert, update
1.2в вызвать форму просмотра акции                  -> m-storage:getItem()
2 вызовы из формы добавления/редактирования
    
*/ 
using Progress.Lang.*.
using ibs.th.gbl.storage.*.
using ibs.th.ref.promo.*.
block-level on error undo, throw.
&glob promoTrackingChanges no and
class ibs.th.ref.promo.promo_trg :
  { cmp/str-glbl.i class } 
  { bge/ds-promo.i} 
  define temp-table tt-query
      field NameQuery as character 
      field hQuery    as handle
  index NameQuery NameQuery.    
  /* --- для cmp/vssrevis.i --- */
    define variable vss-revision       as character no-undo init "$Revision$":U .
    define variable vss-author         as character no-undo init "$Author$":U .
    define variable vss-date           as character no-undo init "$Date$":U .
    define variable vss-workfile       as character no-undo init "$Workfile$":U .
    define variable vss-archive        as character no-undo init "$Archive$":U .
    define variable vss-description    as character no-undo init "Экранные триггеры промо-акций". 
  /* --- end_of для cmp/vssrevis.i --- */

  define private variable m-storage as class promoactionstorage no-undo .
  define variable dialog1 as class ibs.th.ref.promo.dPromoActions no-undo .
  
  constructor public promo_trg (  ):
    m-storage = new promoactionstorage () .
  end constructor.

  destructor public promo_trg ( ):
    if valid-object (m-storage) then delete object m-storage no-error.
  end destructor.

/* --- 1 вызовы из списка --- */
     
/* 1.1 получить таблицу акций для отображения в data-grid */
    method public void getListTable (
       //input-output table tt-promoaction bind
    ) : 
        define variable v-subs    as class promoActionSubs no-undo .
        define variable v-sub     as class promoactionsub no-undo .
        define variable v-length  as integer no-undo .
        define variable v-i       as integer no-undo .
        define variable v-size    as integer no-undo .
  
        empty temp-table tt-promoaction.
        
        v-subs    = 
        m-storage:getpromoactionsubs() . // получаем коллекцию из data-storage
        
        // перекладываем коллекцию во временную таблицу
        v-length  = v-subs:iCounter .
        v-subs:IsDelChildObj = no.
        do v-i = 1 to v-length :
            v-size = v-subs:GetItem(v-i) . // переключает SubjectObjCurr на N[v-i] и возвращает количество элементов в коллекции 
            v-sub = v-subs:promoActionObjCurr .
            create tt-promoaction .
            assign
                tt-promoaction.id           = v-sub:ID
                tt-PromoAction.db-num      = v-sub:db-num
                tt-PromoAction.changeDate  = v-sub:changeDate    
                tt-PromoAction.comment     = v-sub:comment
                tt-PromoAction.description = v-sub:description    
                tt-PromoAction.ext-code    = v-sub:ext-code 
                tt-PromoAction.paymenttype = v-sub:paymenttype 
                tt-PromoAction.priority    = v-sub:priority 
                tt-PromoAction.status_     = v-sub:status_
                tt-PromoAction.status_lbl  = v-sub:status_lbl       
                tt-promoaction.beg-date    = v-sub:beg-date
                tt-promoaction.end-date    = v-sub:end-date
                tt-promoaction.methodCalc  = v-sub:methodCalc
                tt-promoaction.mode        = v-sub:Mode
                tt-promoaction.nameAction  = v-sub:nameAction
                tt-promoaction.typecond    = v-sub:typecond
                tt-promoaction.TypeDiscont = v-sub:TypeDiscont
        
                tt-promoaction.sub         = v-subs:SubjectObjCurr
            .
        end.
    // удаляем коллекцию без удаления её элементов:
    //   data-storage использовал конструктор с флагом false на входе для создания коллекции
        delete object v-subs .
    // Все элементы коллекции доступны по ссылке из экранной таблицы
           
    
    end method . // end_of getListTable
  
  method public class promoActionSubs ReturnSubsPromoAction():
      define variable vSubs  as class promoActionSubs  no-undo .
      define variable vSub   as class promoActionSub   no-undo .
      vSubs = new promoActionSubs().
      for each tt-promoaction where tt-promoaction.Chang:
          vsub = cast(tt-promoaction.sub, ibs.th.ref.promo.PromoActionSub) .
          m-storage:refreshObj(vsub).
          vSubs:AddItem(tt-promoaction.sub).
      end.
      return vSubs.
   end.  
   
   method public void changeRow(input iAll as logical):
       define variable vFlag as logical no-undo.
       vFlag = if     available tt-promoaction
                  and tt-promoaction.Chang
               then no
               else yes.
       if iAll 
       then
           for each   tt-promoaction:
               tt-promoaction.Chang = vFlag.
           end.
       else
            if avail tt-promoaction
            then
                tt-promoaction.Chang = vFlag.
               
   end.          
      
  
/* 1.2 запустить браузер с перечнем акций */
    method public handle getQuery (input iNameQuery as character ) :
        return getQuery(iNameQuery,no).
    end.
    
    method public handle getQuery (input iNameQuery as character,input iNewQuery as logical ) :
        define variable hQuery   as handle  no-undo .
        define variable vfirst   as logical no-undo .
        define variable vTblName as character no-undo .
        define variable vOpenStr as character no-undo .
        define variable vSchedId as integer no-undo .
/* 26/VII-2018 - не используется        
        if iNameQuery eq "promo-schedule" 
        then
            hQuery = dataset ds-promoaction-one:get-buffer-handle ( "tt-promo-schedule" ).
        /*else if iNameQuery eq "promoActionOne" //так как нам надо две разные ссылки на запрос мы не можем использовать буфер
        then
            hQuery = buffer tt-promoaction-one:handle.*/
        else do:
*/          
            find first tt-Query where tt-Query.NameQuery eq iNameQuery
            no-error.
            if     available tt-Query
               and iNewQuery
            then do:
               delete object tt-Query.hQuery.
               delete tt-Query.
            end.      
            if not available tt-Query
            then 
            do: 
                create query hQuery.    
                case iNameQuery:
                    when "promoActionAll"
                    then do:
                        hQuery:set-buffers(buffer tt-promoaction:HANDLE). 
                        hQuery:query-prepare("FOR EACH tt-promoaction").
                    end.
                    when "promoActionOne"
                    or
                    when "promoActionOne2" or when "promoActionOne3"
                    then do:
                        
                        hQuery:set-buffers(buffer tt-promoaction-one:HANDLE). 
                        hQuery:query-prepare("FOR EACH tt-promoaction-one").
                        vfirst = yes.
                    end.
                    when "PromoGoodsAppl" 
                    then do:
                        hQuery:set-buffers(buffer tt-PromoGoodsAppl:HANDLE). 
                        hQuery:query-prepare("FOR EACH tt-PromoGoodsAppl " + if not available tt-promoaction-one then "" else (
                                                 "where tt-PromoGoodsAppl.idaction eq " + string(tt-promoaction-one.id)  +
                                                 "  and tt-PromoGoodsAppl.mode ne {&h-delete}"
                                             )).
                    end.
                    when "PromoGoodsCrit" 
                    then do:
                        hQuery:set-buffers(buffer tt-PromoGoodsCrite:HANDLE). 
                        hQuery:query-prepare("FOR EACH tt-PromoGoodsCrite " + if not available tt-promoaction-one then "" else ( 
                                                 "where tt-PromoGoodsCrite.idaction eq " + string(tt-promoaction-one.id)  +
                                                 "  and tt-PromoGoodsCrite.mode     ne {&h-delete}")).
                    end.
                    when "PromoSet" 
                    then do:
                        hQuery:set-buffers(buffer tt-PromoSet:HANDLE). 
                        hQuery:query-prepare("FOR EACH tt-PromoSet " +  if not available tt-promoaction-one then "" else (
                                                 "where tt-PromoSet.idaction eq " + string(tt-promoaction-one.id) +
                                                 "  and tt-PromoSet.mode     ne {&h-delete}"
                                             )).
                    end.
                    when "PromoSetGoods" 
                    then do:
                        hQuery:set-buffers(buffer tt-PromoSetGoods:HANDLE). 
                        hQuery:query-prepare("FOR EACH tt-PromoSetGoods " + if not available tt-PromoSet then "" else ( 
                                                 "where tt-PromoSetGoods.idaction eq " + string(tt-PromoSet.idAction) +
                                                 "  and tt-PromoSetGoods.idset    eq " + string(tt-PromoSet.id) +
                                                 "  and tt-PromoSetGoods.mode     ne {&h-delete}"
                                            )).
                    end.
                    when "PromoCriterion" 
                    then do:
                        hQuery:set-buffers(buffer tt-PromoCriterion:HANDLE). 
                        hQuery:query-prepare("FOR EACH tt-PromoCriterion " + if not available tt-promoaction-one then "" else (
                                                 "where tt-PromoCriterion.idaction eq " + string(tt-promoaction-one.id) +
                                                 "  and tt-PromoCriterion.mode     ne {&h-delete}")).
                    end.
                    when "PromoObject" 
                    then do:
                        hQuery:set-buffers(buffer tt-PromoObject:HANDLE). 
                        hQuery:query-prepare("FOR EACH tt-PromoObject " + if not available tt-promoaction-one then "" else (
                                                 "where tt-PromoObject.idaction eq " + string(tt-promoaction-one.id) +
                                                 "  and tt-PromoObject.mode     ne {&h-delete}")).
                    end.
                    when "PromoPay" 
                    then do:
                        hQuery:set-buffers(buffer tt-CashPay:HANDLE). 
                        hQuery:query-prepare("FOR EACH tt-CashPay ").
                    end.
                    when "PromoCriterionOne" 
                    then do:
                        
                        for each tt-PromoCriterion where tt-PromoCriterion.mode eq "{&h-update}" :
                            if vFirst 
                            then
                                tt-PromoCriterion.mode = "{&h-delete}".
                            else
                                vFirst = yes.
                        end.
                        for each tt-PromoCriterion where tt-PromoCriterion.mode eq "{&h-create}" :
                            if vFirst 
                            then
                                delete tt-PromoCriterion.
                            else
                                vFirst = yes.
                        end.
                        if not vFirst
                        then do:
                            create tt-PromoCriterion.
                            assign
                                vFirst                     = yes
                                tt-PromoCriterion.mode     = "{&h-create}".
                                tt-PromoCriterion.idAction = tt-promoaction-one.id
                            no-error.
                                 
                        end.        
                        hQuery:set-buffers(buffer tt-PromoCriterion:HANDLE). 
                        hQuery:query-prepare("FOR EACH tt-PromoCriterion " + if not available tt-promoaction-one then "" else (
                                                 "where tt-PromoCriterion.idaction eq " + string(tt-promoaction-one.id) +
                                                 "  and tt-PromoCriterion.mode     ne {&h-delete}")).
                        
                    end.
                    when "PromoGiftForAction" 
                    then do: 
                        hQuery:set-buffers(buffer tt-PromoGift:HANDLE). 
                        hQuery:query-prepare("FOR EACH tt-PromoGift " + if not available tt-promoaction-one then "" else (
                                                 "where tt-PromoGift.idaction eq " + string(tt-promoaction-one.id) +
                                                 "  and tt-PromoGift.idCrit   eq 0 "  +
                                                 "  and tt-PromoGift.mode     ne {&h-delete}"
                                            )).
                    end.
                    when "PromoMes" 
                    then do: 
                        vFirst = yes.
                        if     available tt-promoaction-one 
                           and not can-find( first tt-PromoGift  where tt-PromoGift.idaction eq tt-promoaction-one.id 
                                                   and tt-PromoGift.idCrit   eq 0   
                                                   and tt-PromoGift.mode     ne {&h-delete})
                        then do:
                            create tt-PromoGift.
                            assign 
                            tt-PromoGift.idCrit = 0
                            tt-PromoGift.idaction = tt-promoaction-one.id.
                        end.    
                        hQuery:set-buffers(buffer tt-PromoGift:HANDLE). 
                        hQuery:query-prepare("FOR each tt-PromoGift " + if not available tt-promoaction-one then "" else (
                                                 "where tt-PromoGift.idaction eq " + string(tt-promoaction-one.id) +
                                                 "  and tt-PromoGift.idCrit   eq 0 "  +
                                                 "  and tt-PromoGift.mode     ne {&h-delete}"
                                            )).
                    end.
                    when "PromoGiftForCrit" 
                    then do: 
                        hQuery:set-buffers(buffer tt-PromoGift:HANDLE). 
                        hQuery:query-prepare("FOR EACH tt-PromoGift " + if not available tt-PromoCriterion then "" else (
                                                 "where tt-PromoGift.idaction eq " + string(tt-PromoCriterion.idAction) +
                                                 "  and tt-PromoGift.idCrit   eq " + string(tt-PromoCriterion.id) +
                                                 "  and tt-PromoGift.mode     ne {&h-delete}"
                                            )).
                    end.
                    when "promoSchedWeek" 
                    then do:
                        vTblName = "tt-promo-schedule-week" .
                        hQuery:set-buffers(buffer tt-promo-schedule-week:HANDLE).
                        // 26/VII-2018 - tt-promoaction-one должен быть всегда available
                        // 27/VII-2018 - если на available tt-promoaction-one - то хотябы available tt-promoaction
                        case true:
                          when available tt-promoaction-one then vSchedId = tt-promoaction-one.promosched-id .
                          when available tt-promoaction     then vSchedId = tt-promoaction.promosched-id .
                                                       otherwise vSchedId = 0 .
                        end case .
                        vOpenStr = substitute (
                          "FOR EACH &1 where &1.promosched-id = &2 and &1.mode ne '&3'"
                          , vTblName, vSchedId, {&h-delete}
                        ) .
                        hQuery:query-prepare(vOpenStr).
                        vfirst = yes.
                    end.
                    
                end case.
                hQuery:query-open.
                if vFirst 
                then
                    hQuery:get-first ().
                create tt-Query.
                assign
                    tt-Query.NameQuery = iNameQuery
                    tt-Query.hQuery    = hQuery
                .         
            end.
            else
               hQuery = tt-Query.hQuery.
               
            
/* 26/VII-2018 не используется       end.*/
     
        return hQuery.
    end.
    method public handle CleanQuery (input iNoCleanNameQuery as character ) :
        for each tt-Query where not can-do(iNoCleanNameQuery,tt-Query.nameQuery):
            tt-Query.hQuery:query-close ().
            delete object tt-Query.hQuery.
            delete tt-Query.
        end.  
    end.     
    method public void viewpage6 (input iFlag as logical) :
        dialog1:viewpage6(iFlag).
    end.        
  method public void BrwPromoAction () :
      
    define variable v-listact-brw as class ibs.th.ref.promo.wListActions no-undo .
  v-listact-brw = new ibs.th.ref.promo.wListActions (input this-object
  //, input table tt-promoaction by-reference 
  ). 
  /* v-listact-brw:SetPromoBind(input table tt-promoaction by-reference
   )
   .*/.
 //  v-listact-brw:SetPromoTrg(this-object ).
  /* Display and wait for this non-modal form to close. */
  wait-for System.Windows.Forms.Application:Run ( v-listact-brw ) .
  
  /*define variable v-err-msg as character no-undo .  
  catch exAppErrors as class Progress.Lang.AppError :
    v-err-msg = exAppErrors:ReturnValue .
    if v-err-msg > "" then . else do :
      v-err-msg = exAppErrors:GetMessage(1) . 
      if v-err-msg > "" then . else v-err-msg = "AppError в модуле {&FILE-NAME}" .
    end .
    message "AppError" skip(1) v-err-msg skip exAppErrors:CallStack view-as alert-box.
  end catch .
  catch exProErrors as class Progress.Lang.ProError :
    v-err-msg = exProErrors:GetMessage(1) . 
    if v-err-msg > "" then . else v-err-msg = "ProError в модуле {&FILE-NAME}" .
    message "ProError" skip(1) v-err-msg skip exProErrors:CallStack view-as alert-box.
  end catch .
  catch exAnyErrors as class Progress.Lang.Error:
    v-err-msg = "Unexpected error в модуле {&FILE-NAME} " + exAnyErrors:GetMessage(1).
    message "LangError" skip(1) v-err-msg skip exAnyErrors:CallStack view-as alert-box.
  end catch .*/
  finally: 
    if valid-object(v-listact-brw) then delete object v-listact-brw no-error .
  end finally.  
    
  end method .
   
/* 1.3а вызвать форму ввода и создать одну акцию */
/* 1.3б вызвать форму ввода и редактировать одну акцию */
/* 1.3в вызвать форму просмотра акции */
  method public void addOnePromo () :
    /* буффер tt-promoaction спозиционирован на текущей записи,
       буффер buf_tt-promoaction неспозиционирован */
    formOnePromo ({&add-def}) .
  end method .
  method public void viewOnePromo () :
    formOnePromo ({&lookup}) .
  end method .
  method public void editOnePromo () :
    formOnePromo ({&update}) .
  end method .
  method public void formOnePromo (input  p-mode as character) :  
  
  define variable v-sub   as class promoActionsub no-undo .
      dataset ds-promoaction-one:empty-dataset ( ) .   
      
      // вызвать в storage создание экземпляра класса sub и его заполнение или инициализацию
      if p-mode eq {&add-def} then
         v-sub = new promoActionsub().
      else do:
        if available tt-promoaction then do:
         v-sub = cast(tt-promoaction.sub, ibs.th.ref.promo.PromoActionSub) .
         m-storage:refreshObj(v-sub).
        end .
        else do:
          undo, throw new Progress.Lang.AppError("отсутствует промоакция для отображения в форме ввода") .
        end .
      end .
             
      v-sub:refreshChildObj().   
      // перелить этот класс в таблицы редактируемого dataset
      createDsForAction(p-mode, v-sub).
      find first tt-promoaction-one no-error.
      if not available tt-promoaction-one then
        undo, throw new Progress.Lang.AppError("отсутствует набор данных для формы ввода") .
      dialog1 = new ibs.th.ref.promo.dPromoActions(p-mode, this-object).
      dialog1:prepareobj(). //input-output dataset ds-promoaction-one by-reference) .
      
      // для просмотра убрать кнопку "Ок", написать гашение полей, сравнить активность полей для создания и для редактирования
      dialog1:ShowModalDialog().

      if dialog1:DialogResult = System.Windows.Forms.DialogResult:Ok then do:
        // изменённый dataset с описанием акции из v-dialog1 хранится тут;  
        // перенести значение из таблиц DataSet'а в классы описаня акции
        if p-mode ne {&lookup}
        then
           updateObjForAction(). // - обновляет класс в tt-PromoAction-one.sub
        
        // и передать класс(ы) в storage на insert-row, и затем на update-row
        v-sub = cast(tt-PromoAction-one.sub, promoActionSub) .
        
        if v-sub:Changed then do:
          if v-sub:ID > 0 then m-storage:updateDB(v-sub) .
                          else m-storage:insertDB(v-sub) .
        end .
        getListTable().
      end .
      if p-mode eq {&add-def}
      then
          delete object v-sub.
      
    return.   
  define variable v-err-msg as character no-undo .  
  catch exAppErrors as class Progress.Lang.AppError :
    v-err-msg = exAppErrors:ReturnValue .
    if v-err-msg > "" then . else do :
      v-err-msg = exAppErrors:GetMessage(1) .
      if v-err-msg > "" then . else v-err-msg = "AppError в модуле {&FILE-NAME}" .
    end .
    message "AppError" skip(1) v-err-msg skip exAppErrors:CallStack view-as alert-box.
  end catch .
  catch exProErrors as class Progress.Lang.ProError :
    v-err-msg = exProErrors:GetMessage(1) . 
    if v-err-msg > "" then . else v-err-msg = "ProError в модуле {&FILE-NAME}" .
    message "ProError" skip(1) v-err-msg skip exProErrors:CallStack view-as alert-box.
  end catch .
  catch exAnyErrors as class Progress.Lang.Error:
    v-err-msg = "Unexpected error в модуле {&FILE-NAME} " + exAnyErrors:GetMessage(1).
    message "LangError" skip(1) v-err-msg skip exAnyErrors:CallStack view-as alert-box.
  end catch .
  finally:
      // оставлять диалог пока не получается: при повторном запуске указатель валидный, но сам объект disposed
      CleanQuery("promoActionAll").
      if valid-object(dialog1) then delete object dialog1 .
      
    end finally .
  end method. // end_of getOnePromo
  
/* --- 2 вызовы из формы добавления/редактирования --- */

/* 2.1 перенести объект m-sub в temp-table */
  method public void CreateDsForAction
  ( input  p-mode as character
  , input  p-sub  as class promoactionsub
  ) :
    define variable v-sched-sub as class promoSchedSub no-undo .
    define variable vi          as integer  no-undo.
    define variable vSurr       as character no-undo.
    define buffer buf_cashpay for cash-pay.
    
    // для режима добавления включить tracking-changes на время инициализации полей
    // для режима редактирования - включить после инициализации   
    //if p-mode = {&add-def} then temp-table tt-promoaction-one:tracking-changes = true . 
    create tt-promoaction-one.
    assign 
       tt-PromoAction-one.id             = p-sub:ID
       tt-PromoAction-one.db-num         = p-sub:db-num
       tt-PromoAction-one.changeDate     = p-sub:changeDate    
       tt-PromoAction-one.comment        = p-sub:comment
       tt-PromoAction-one.description    = p-sub:description    
       tt-PromoAction-one.ext-code       = p-sub:ext-code 
       tt-PromoAction-one.paymenttype    = p-sub:paymenttype 
       tt-PromoAction-one.priority       = p-sub:priority 
       tt-PromoAction-one.beg-date       = p-sub:beg-date
       tt-PromoAction-one.end-date       = p-sub:end-date
       tt-PromoAction-one.methodCalclbl  = p-sub:methodCalclbl
       tt-PromoAction-one.mode           = p-sub:Mode
       tt-PromoAction-one.nameAction     = p-sub:NameAction
       tt-PromoAction-one.promosched-id  = p-sub:promosched-id
       tt-PromoAction-one.typecondlbl    = p-sub:typecondLbl
       tt-PromoAction-one.status_lbl     = p-sub:status_lbl
       tt-PromoAction-one.TypeDiscontlog = if p-sub:TypeDiscont eq 1 then true else false
       tt-PromoAction-one.sub            = cast(p-sub,Progress.Lang.Object)
    no-error.   
    v-sched-sub = p-sub:Schedule .
    if valid-object(v-sched-sub) then do:
      assign
       tt-PromoAction-one.scheduleName   = v-sched-sub:dispname
       tt-PromoAction-one.extCodeSched   = v-sched-sub:extCodeSched
      no-error.
    end .
    else do:
       v-sched-sub = new promoSchedSub ().
       assign
         v-sched-sub:schedType = 0
         v-sched-sub:Mode      = {&h-create}
       .
       p-sub:Schedule = v-sched-sub .
    end .
    assign
      tt-PromoAction-one.scheduleType   = v-sched-sub:schedType
    .
    if v-sched-sub:schedType = 0 then CreateTableForSchedw0 (p-mode, p-sub:ScheduleWeek).
                                 else CreateTableForSchedw1 (p-mode, p-sub:ScheduleWeek).
       
     //if p-mode = {&update} then temp-table tt-promoaction-one:tracking-changes = true .
     CreateTableForGoodsCrits(p-mode, p-sub:GoodsCrits).
     CreateTableForGoodsAppl (p-mode, p-sub:GoodsAppl ).
     CreateTableForPromoSet  (p-mode, p-sub:PromoSet ).
     CreateTableForCrite     (p-mode, p-sub:Criterion ).
     CreateTableForGift      (p-mode, p-sub:Gifts     ).
     CreateTableForObject    (p-mode, p-sub:Objects     ).
      do vi = 1 to num-entries(tt-PromoAction-one.paymenttype,{&delim-par}):
         vSurr = entry(vi,tt-PromoAction-one.paymenttype,{&delim-par}).
         find first Buf_cashpay where Buf_cashpay.cdpay-code = integer (entry(1,vSurr,{&delim-key}))
                                  and Buf_cashpay.curr-code  = integer (entry(2,vSurr,{&delim-key}))
         no-lock no-error.
         if available Buf_cashpay
         then do:
             find first tt-cashpay where tt-cashpay.cdpay-code = Buf_cashpay.cdpay-code 
                                     and tt-cashpay.curr-code  = Buf_cashpay.curr-code  
             no-lock no-error.
             if not available tt-cashpay
             then do:
                 create tt-cashpay.
                 buffer-copy Buf_cashpay to tt-cashpay.
             end.
         end.
     end.
  end method. // end_of_CreateDsForAction
  
  method public void CreateTableForGoodsCrits
  ( input  p-mode as character
  , input  p-subs  as class promogoodssubs
  ) :
    define variable vI as int no-undo.
    define variable p-sub as class promogoodssub no-undo.
    //if p-mode = {&add-def} then temp-table tt-PromoGoodsCrite:tracking-changes = true . 
    do vi = 1 to p-subs:GetItem(vI):
        p-sub = p-subs:promoGoodsObjCurr.  
        create tt-PromoGoodsCrite.
        assign
           tt-PromoGoodsCrite.id             = p-sub:ID
           tt-PromoGoodsCrite.idAction       = p-sub:idAction
           tt-PromoGoodsCrite.gds-code       = p-sub:GdsCode
           tt-PromoGoodsCrite.gdsname        = p-sub:Gdsname
           tt-PromoGoodsCrite.type           = p-sub:type
           tt-PromoGoodsCrite.sub            = p-subs:SubjectObjCurr
           tt-PromoGoodsCrite.mode           = p-sub:Mode
           tt-PromoGoodsCrite.db-num         = p-sub:db-num
           tt-PromoGoodsCrite.idSet          = p-sub:idSet
           tt-PromoGoodsCrite.price          = p-sub:price
           tt-PromoGoodsCrite.qnty           = p-sub:qnty
           tt-PromoGoodsCrite.NameSet        = p-sub:NameSet
         .
     end.    
     //if p-mode = {&update} then temp-table tt-PromoGoodsCrite:tracking-changes = true .
  end method. // end_of_CreateTableForGoodsCrite
  
  method public void CreateTableForGoodsAppl
  ( input  p-mode as character
  , input  p-subs  as class promogoodssubs
  ) :
    define variable vI as int no-undo.
    define variable p-sub as class promogoodssub no-undo.
    
    //if p-mode = {&add-def} then temp-table tt-PromoGoodsAppl:tracking-changes = true . 
    do vi = 1 to p-subs:GetItem(vI):  
        p-sub = p-subs:promoGoodsObjCurr.
        create tt-PromoGoodsAppl.
        assign
           tt-PromoGoodsAppl.id             = p-sub:ID
           tt-PromoGoodsAppl.idAction       = p-sub:idAction
           tt-PromoGoodsAppl.gds-code       = p-sub:GdsCode
           tt-PromoGoodsAppl.gdsname        = p-sub:GdsName
           tt-PromoGoodsAppl.type           = p-sub:type
           tt-PromoGoodsAppl.sub            = p-subs:SubjectObjCurr
           tt-PromoGoodsAppl.mode           = p-sub:Mode
           tt-PromoGoodsAppl.db-num         = p-sub:db-num
           tt-PromoGoodsAppl.idSet          = p-sub:idSet
           tt-PromoGoodsAppl.price          = p-sub:price
           tt-PromoGoodsAppl.qnty           = p-sub:qnty
           tt-PromoGoodsAppl.NameSet        = p-sub:NameSet
         . 
     end.
     //if p-mode = {&update} then temp-table tt-PromoGoodsAppl:tracking-changes = true .
  end method. // end_of_CreateTableForGoodsAppl
  
   method public void CreateTableForPromoSet
  ( input  p-mode as character
  , input  p-subs  as class promogoodssubs
  ) :
    define variable vI as int no-undo.
    define variable p-sub as class promogoodssub no-undo.
    
    if {&promoTrackingChanges} p-mode = {&add-def} then temp-table tt-PromoSet:tracking-changes = true . 
    do vi = 1 to p-subs:GetItem(vI):  
        p-sub = p-subs:promoGoodsObjCurr.
        
        create tt-PromoSet.
        assign
           tt-PromoSet.id             = p-sub:ID
           tt-PromoSet.idAction       = p-sub:idAction
           tt-PromoSet.gds-code       = p-sub:GdsCode
           tt-PromoSet.type           = p-sub:type
           tt-PromoSet.sub            = p-subs:SubjectObjCurr
           tt-PromoSet.mode           = p-sub:Mode
           tt-PromoSet.db-num         = p-sub:db-num
           tt-PromoSet.idSet          = p-sub:idSet
           tt-PromoSet.price          = p-sub:price
           tt-PromoSet.qnty           = p-sub:qnty
           tt-PromoSet.NameSet        = p-sub:NameSet
         .
         p-sub:refreshChildObj().
         CreateTableForPromoSetGoods(p-mode, p-sub:PromoSetGoods).  
     end.
     if {&promoTrackingChanges} p-mode = {&update} then temp-table tt-PromoSet:tracking-changes = true .
  end method. // end_of_CreateTableForPromoSet
  
  method public void CreateTableForPromoSetGoods
  ( input  p-mode as character
  , input  p-subs  as class promogoodssubs
  ) :
    define variable vI as int no-undo.
    define variable p-sub as class promogoodssub no-undo.
    
    //if p-mode = {&add-def} then temp-table tt-PromoGoodsAppl:tracking-changes = true . 
    do vi = 1 to p-subs:GetItem(vI):  
        p-sub = p-subs:promoGoodsObjCurr.
        
        create tt-PromoGoodsAppl.
        assign
           tt-PromoSetGoods.id             = p-sub:ID
           tt-PromoSetGoods.idAction       = p-sub:idAction
           tt-PromoSetGoods.gds-code       = p-sub:GdsCode
           tt-PromoSetGoods.gdsName        = p-sub:GdsName 
           tt-PromoSetGoods.type           = p-sub:type
           tt-PromoSetGoods.sub            = p-subs:SubjectObjCurr
           tt-PromoSetGoods.mode           = p-sub:Mode
           tt-PromoSetGoods.db-num         = p-sub:db-num
           tt-PromoSetGoods.idSet          = p-sub:idSet
           tt-PromoSetGoods.price          = p-sub:price
           tt-PromoSetGoods.qnty           = p-sub:qnty
           tt-PromoSetGoods.NameSet        = p-sub:NameSet
         . 
     end.
     //if p-mode = {&update} then temp-table tt-PromoGoodsAppl:tracking-changes = true .
  end method. // end_of_CreateTableForPromoSetGoods
  
  method public void CreateTableForCrite
  ( input  p-mode as character
  , input  p-subs  as class promoCriterionSubs
  ) :
    define variable vI as int no-undo.
    define variable p-sub as class promoCriterionSub no-undo.
    // if p-mode = {&add-def} then temp-table tt-PromoCriterion:tracking-changes = true . 
    do vi = 1 to p-subs:GetItem(vI):  
        p-sub = p-subs:promoCriterionObjCurr.
        create tt-PromoCriterion.
        assign
           tt-PromoCriterion.id             = p-sub:ID
           tt-PromoCriterion.idAction       = p-sub:idAction
           tt-PromoCriterion.discont        = p-sub:discont
           tt-PromoCriterion.mincrit        = p-sub:mincrit
           tt-PromoCriterion.sub            = p-subs:SubjectObjCurr
           tt-PromoCriterion.mode           = p-sub:Mode
           tt-PromoCriterion.db-num         = p-sub:db-num
         .
         p-sub:refreshChildObj().
         CreateTableForGift(p-mode, p-sub:Gifts).
     end.
     // if p-mode = {&update} then temp-table tt-PromoCriterion:tracking-changes = true .
  end method. // end_of_CreateTableForCrite
  method public void CreateTableForGift
  ( input  p-mode as character
  , input  p-subs  as class promoGiftSubs
  ) :
    define variable vI as int no-undo.
    define variable p-sub as class promoGiftSub no-undo.
    // if p-mode = {&add-def} then temp-table tt-PromoGift:tracking-changes = true . 
    do vi = 1 to p-subs:GetItem(vI): 
        p-sub = p-subs:promoGiftObjCurr.
        create tt-PromoGift.
        assign
           tt-PromoGift.id             = p-sub:ID
           tt-PromoGift.idaction       = p-sub:idAction
           tt-PromoGift.idCrit         = p-sub:idCrit
           tt-PromoGift.gds-code       = p-sub:GdsCode
           tt-PromoGift.gdsName        = p-sub:GdsName
           tt-PromoGift.mess           = p-sub:mess
           tt-PromoGift.qnty           = p-sub:qnty
           tt-PromoGift.sub            = p-subs:SubjectObjCurr
           tt-PromoGift.mode           = p-sub:Mode
           tt-PromoGift.db-num         = p-sub:db-num
         . 
     end.
     // if p-mode = {&update} then temp-table tt-PromoGift:tracking-changes = true .
  end method. // end_of_CreateTableForGift
  
  method public void CreateTableForObject
  ( input  p-mode as character
  , input  p-subs  as class promoObjectSubs
  ) :
    define variable vI as int no-undo.
    define variable p-sub as class promoObjectSub no-undo.
    // if p-mode = {&add-def} then temp-table tt-PromoGift:tracking-changes = true . 
    do vi = 1 to p-subs:GetItem(vI):
        p-sub = p-subs:promoObjectObjCurr.
        create tt-PromoObject.
        assign
           tt-PromoObject.id             = p-sub:ID
           tt-PromoObject.idaction       = p-sub:idAction
           tt-PromoObject.sub            = p-subs:SubjectObjCurr
           tt-PromoObject.mode           = p-sub:Mode
           tt-PromoObject.db-num         = p-sub:db-num
           tt-PromoObject.obj-code       = p-sub:obj-code
           tt-PromoObject.obj-type       = p-sub:obj-type
           tt-PromoObject.FirmCode       = p-sub:FirmCode
           tt-PromoObject.FirmName       = p-sub:FirmName
           tt-PromoObject.objName        = p-sub:objName
           tt-PromoObject.objDbNum       = p-sub:objDbNum
           
         . 
     end.
     // if p-mode = {&update} then temp-table tt-PromoGift:tracking-changes = true .
  end method. // end_of_CreateTableForGift

  method public void CreateTableForSchedw0
  ( input  p-mode as character
  , input  p-subs as class promoschedwsubs
  ) :
    define variable vI as int no-undo.
    define variable v-sub as promoschedwsub no-undo .
    // if p-mode = {&add-def} then temp-table tt-PromoGift:tracking-changes = true . 
    create tt-promo-schedule-week.
    
  if valid-object(p-subs) then do:
    do vi = 1 to p-subs:GetItem(vI):
        v-sub = p-subs:promoSchedwObjCurr .
        assign
          tt-promo-schedule-week.id     = v-sub:ID
          tt-promo-schedule-week.db-num = v-sub:db-num
          tt-promo-schedule-week.promosched-id = v-sub:schedId
          tt-promo-schedule-week.timebeg   = v-sub:timebeg
          tt-promo-schedule-week.timeend   = v-sub:timeend
          tt-promo-schedule-week.dtime-beg = datetime (today, tt-promo-schedule-week.timebeg * 1000)
          tt-promo-schedule-week.dtime-end = datetime (today, tt-promo-schedule-week.timeend * 1000)
          tt-promo-schedule-week.mode   = v-sub:Mode // ?? p-mode ??
          tt-promo-schedule-week.sub    = v-sub 
        .
        
        tt-promo-schedule-week.wdaylist = tt-promo-schedule-week.wdaylist + substitute(",&1", v-sub:wdaylist) .
    end.
    tt-promo-schedule-week.wdaylist = substring(tt-promo-schedule-week.wdaylist, 2) .
    assign
      tt-promo-schedule-week.isday_mon = can-do(tt-promo-schedule-week.wdaylist, "1")
      tt-promo-schedule-week.isday_tue = can-do(tt-promo-schedule-week.wdaylist, "2")
      tt-promo-schedule-week.isday_wed = can-do(tt-promo-schedule-week.wdaylist, "3")
      tt-promo-schedule-week.isday_thu = can-do(tt-promo-schedule-week.wdaylist, "4")
      tt-promo-schedule-week.isday_fri = can-do(tt-promo-schedule-week.wdaylist, "5")
      tt-promo-schedule-week.isday_sat = can-do(tt-promo-schedule-week.wdaylist, "6")
      tt-promo-schedule-week.isday_sun = can-do(tt-promo-schedule-week.wdaylist, "7")
    .
  end. // end_of valid-object(subs)
    // if p-mode = {&update} then temp-table tt-PromoGift:tracking-changes = true .
  end method. // end_of_CreateTableForSchedw0


  method public void CreateTableForSchedw1
  ( input  p-mode as character
  , input  p-subs as class promoschedwsubs
  ) :
    define variable vI as int no-undo.
    define variable v-sub as promoschedwsub no-undo .
    if valid-object(p-subs) then do:
    // if p-mode = {&add-def} then temp-table tt-PromoGift:tracking-changes = true . 
    do vi = 1 to p-subs:GetItem(vI):
        v-sub = p-subs:promoSchedwObjCurr .
        create tt-promo-schedule-week.
        assign
          tt-promo-schedule-week.id     = v-sub:ID
          tt-promo-schedule-week.db-num = v-sub:db-num
          tt-promo-schedule-week.promosched-id = v-sub:schedId
          tt-promo-schedule-week.timebeg   = v-sub:timebeg
          tt-promo-schedule-week.timeend   = v-sub:timeend
          tt-promo-schedule-week.dtime-beg = datetime (today, tt-promo-schedule-week.timebeg * 1000)
          tt-promo-schedule-week.dtime-end = datetime (today, tt-promo-schedule-week.timeend * 1000)
          tt-promo-schedule-week.wdaylist  = v-sub:wdaylist
          tt-promo-schedule-week.isday_mon = can-do(v-sub:wdaylist, "1")
          tt-promo-schedule-week.isday_tue = can-do(v-sub:wdaylist, "2")
          tt-promo-schedule-week.isday_wed = can-do(v-sub:wdaylist, "3")
          tt-promo-schedule-week.isday_thu = can-do(v-sub:wdaylist, "4")
          tt-promo-schedule-week.isday_fri = can-do(v-sub:wdaylist, "5")
          tt-promo-schedule-week.isday_sat = can-do(v-sub:wdaylist, "6")
          tt-promo-schedule-week.isday_sun = can-do(v-sub:wdaylist, "7")
          tt-promo-schedule-week.mode   = v-sub:Mode // ?? p-mode ??
          tt-promo-schedule-week.sub    = v-sub 
        .
    end.
    // if p-mode = {&update} then temp-table tt-PromoGift:tracking-changes = true .
    end. // end_of valid-object(subs)
  end method. // end_of_CreateTableForSchedw1

  
/* 2.2 перенести temp-table в объект m-sub */
  method public void UpdateObjForAction
  ( 
  ) :
    define variable p-sub as class promoActionSub.
    define variable v-sched-sub as class promoSchedSub no-undo .
    for first tt-PromoAction-one:
        
        assign
           p-sub                 = cast(tt-PromoAction-one.sub, promoActionSub)
           p-sub:ID              = tt-PromoAction-one.id             
           p-sub:db-num          = tt-PromoAction-one.db-num
           p-sub:changeDate      = tt-PromoAction-one.changeDate
           p-sub:comment         = tt-PromoAction-one.comment
           p-sub:description     = tt-PromoAction-one.description
           p-sub:ext-code        = tt-PromoAction-one.ext-code
           p-sub:priority        = tt-PromoAction-one.priority
           p-sub:status_lbl      = tt-PromoAction-one.status_lbl
           p-sub:beg-date        = tt-PromoAction-one.beg-date        
           p-sub:end-date        = tt-PromoAction-one.end-date        
           p-sub:methodCalc      = tt-PromoAction-one.methodCalc      
           p-sub:Mode            = tt-PromoAction-one.mode           
           p-sub:NameAction      = tt-PromoAction-one.nameAction      
           p-sub:promosched-id   = tt-PromoAction-one.promosched-id   
           p-sub:typecond        = tt-PromoAction-one.typecond        
           p-sub:TypeDiscont     = if tt-PromoAction-one.TypeDiscontlog then 1 else 2     
           v-sched-sub           = p-sub:Schedule
         .
         assign
           v-sched-sub:dispname     = tt-PromoAction-one.scheduleName 
           v-sched-sub:schedType    = tt-PromoAction-one.scheduleType
           v-sched-sub:extCodeSched = tt-PromoAction-one.extCodeSched
         .
         
         // ?? переделать все на input-output ??
         updateObjForGoodsCrits(p-sub:GoodsCrits).
         updateObjForGoodsAppl (p-sub:GoodsAppl ).
         updateObjForCrite     (p-sub:Criterion ).
         updateObjForGift      (p-sub:Gifts,0).
         updateObjForObject    (p-sub:Objects).
         updateObjForSET       (p-sub:PromoSet ).
         if v-sched-sub:schedType = 0 then UpdateObjForSchedw0 (p-sub:ScheduleWeek).
                                      else UpdateObjForSchedw1 (p-sub:ScheduleWeek).
         define variable vstr as character no-undo.
         for each tt-cashpay no-lock:
             vstr = vstr 
                  + "{&delim-par}" 
                  + string(tt-cashpay.cdpay-code) 
                  + "{&delim-key}" 
                  + string(tt-cashpay.curr-code).
         end.
         assign
            vstr                           = trim(vstr, "{&delim-par}" )
            tt-PromoAction-one.paymenttype = vstr
            p-sub:paymenttype              = tt-PromoAction-one.paymenttype
         .                                 
     end.
  end method. // end_of_updateObjForAction
  
  method public void updateObjForGoodsCrits
  ( input  p-subs  as class promogoodssubs
  ) :
      
    define variable v-sub as class PromoGoodsSub no-undo.
    for each tt-PromoGoodsCrite:
        if not valid-object(tt-PromoGoodsCrite.sub)
        then do:
           v-sub = new PromoGoodsSub(). 
           tt-PromoGoodsCrite.sub = cast(v-sub,Progress.Lang.Object).
           p-subs:AddItem(tt-PromoGoodsCrite.sub).
        end.
        else
           v-sub = cast(tt-PromoGoodsCrite.sub,promogoodssub).
               
        assign
           v-sub:ID       = tt-PromoGoodsCrite.id              
           v-sub:idAction = tt-PromoGoodsCrite.idAction        
           v-sub:GdsCode  = tt-PromoGoodsCrite.gds-code        
           v-sub:type     = {&criterion} 
           tt-PromoGoodsCrite.type = {&criterion}            
           v-sub:Mode     = tt-PromoGoodsCrite.mode            
        .
     end.    
  end method. // end_of_updateObjForGoodsCrite
  
  method public void updateObjForGoodsAppl
  ( input  p-subs  as class promogoodssubs
  ) :
    define variable v-sub as class PromoGoodsSub no-undo.
    for each tt-PromoGoodsAppl:
        if not valid-object(tt-PromoGoodsAppl.sub)
        then do:
           v-sub = new PromoGoodsSub(). 
           tt-PromoGoodsAppl.sub = cast(v-sub,Progress.Lang.Object).
           p-subs:AddItem(tt-PromoGoodsAppl.sub).
        end.
        else
           v-sub = cast(tt-PromoGoodsAppl.sub,promogoodssub).
               
        assign
           v-sub:ID       = tt-PromoGoodsAppl.id              
           v-sub:idAction = tt-PromoGoodsAppl.idAction        
           v-sub:GdsCode  = tt-PromoGoodsAppl.gds-code        
           v-sub:type     = {&appl}
           tt-PromoGoodsAppl.type = {&appl}            
           v-sub:Mode     = tt-PromoGoodsAppl.mode            
        .
     end.    
  end method. // end_of_updateObjForGoodsAppl
  
  method public void updateObjForCrite
  ( input  p-subs  as class promoCriterionSubs
  ) :
    define variable v-sub as class promoCriterionSub no-undo.
    for each tt-PromoCriterion:
        if not valid-object(tt-PromoCriterion.sub)
        then do:
           v-sub = new promoCriterionSub().
           tt-PromoCriterion.sub = cast(v-sub,Progress.Lang.Object).
           p-subs:AddItem(tt-PromoCriterion.sub).
           v-sub:refreshChildObj(). // создаем потомков
           
        end.
        else do:
           v-sub = cast(tt-PromoCriterion.sub,promoCriterionSub).
        end.     
        assign
           v-sub:ID       = tt-PromoCriterion.id              
           v-sub:idAction = tt-PromoCriterion.idAction        
           v-sub:discont  = tt-PromoCriterion.discont         
           v-sub:mincrit  = tt-PromoCriterion.mincrit         
           v-sub:Mode     = tt-PromoCriterion.mode            
           
           
         .
         updateObjForGift(v-sub:Gifts,v-sub:ID).
     end.
  end method. // end_of_updateObjForCrite
  
  method public void updateObjForGift
  ( input  p-subs    as class promoGiftSubs
  , input  p-IdCrit  as int64
  ) :
    define variable v-sub as class promoGiftSub no-undo.
    for each tt-PromoGift where tt-PromoGift.idCrit eq p-IdCrit:
        if not valid-object(tt-PromoGift.sub)
        then do:
           v-sub = new promoGiftSub(). 
           tt-PromoGift.sub = cast(v-sub,Progress.Lang.Object).
           p-subs:AddItem(tt-PromoGift.sub).
        end.
        else
           v-sub = cast(tt-PromoGift.sub,promoGiftSub).  
        assign
           v-sub:GdsCode  = tt-PromoGift.gds-code        
           v-sub:mess     = tt-PromoGift.mess        
           v-sub:qnty     = tt-PromoGift.qnty        
           v-sub:Mode     = tt-PromoGift.mode        
         . 
     end.
  end method. // end_of_updateObjForGift
  
   method public void updateObjForObject
  ( input  p-subs    as class promoObjectSubs
  
  ) :
    define variable v-sub as class promoObjectSub no-undo.
    for each tt-PromoObject :
        if not valid-object(tt-PromoObject.sub)
        then do:
           v-sub = new promoObjectSub(). 
           tt-PromoGift.sub = cast(v-sub,Progress.Lang.Object).
           p-subs:AddItem(tt-PromoObject.sub).
        end.
        else
           v-sub = cast(tt-PromoObject.sub,promoObjectSub).  
         assign
           v-sub:Mode     = tt-PromoObject.mode           
           v-sub:obj-code = tt-PromoObject.obj-code
           v-sub:obj-type = tt-PromoObject.obj-type       
        .
     end.
  end method. // end_of_updateObjForGift
  
    method public void updateObjForSet
    ( input  p-subs  as class promogoodssubs
     ) :
      
    define variable v-sub as class PromoGoodsSub no-undo.
    for each tt-Promoset:
        if not valid-object(tt-PromoSet.sub)
        then do:
           v-sub = new PromoGoodsSub(). 
           tt-PromoSet.sub = cast(v-sub,Progress.Lang.Object).
           p-subs:AddItem(tt-PromoSet.sub).
           v-sub:refreshChildObj().
        end.
        else
           v-sub = cast(tt-PromoSet.sub,promogoodssub).
               
        assign
           v-sub:ID       = tt-PromoSet.id              
           v-sub:idAction = tt-PromoSet.idAction        
           v-sub:GdsCode  = tt-PromoSet.gds-code        
           v-sub:type     = {&promoSet} 
           tt-PromoSet.type = {&promoSet}            
           v-sub:Mode     = tt-PromoSet.mode            
        .
        updateObjForSetGoods(v-sub:promoSetGoods,v-sub:ID).
     end.    
  end method. // end_of_updateObjForSet
  method public void updateObjForSetGoods
    ( input  p-subs  as class promogoodssubs,
      input  pIdset  as int64
     ) :
      
    define variable v-sub as class PromoGoodsSub no-undo.
    for each tt-PromoSetGoods where tt-PromoSetGoods.IdSet eq pIdset:
        if not valid-object(tt-PromoSetGoods.sub)
        then do:
           v-sub = new PromoGoodsSub(). 
           tt-PromoSetGoods.sub = cast(v-sub,Progress.Lang.Object).
           p-subs:AddItem(tt-PromoSetGoods.sub).
        end.
        else
           v-sub = cast(tt-PromoSetGoods.sub,promogoodssub).
               
        assign
           v-sub:ID       = tt-PromoSetGoods.id              
           v-sub:idAction = tt-PromoSetGoods.idAction        
           v-sub:GdsCode  = tt-PromoSetGoods.gds-code        
           v-sub:type     = {&promoSetGoods} 
           tt-PromoSetGoods.type = {&promoSetgoods}            
           v-sub:Mode     = tt-PromoSetGoods.mode            
        .
     end.    
  end method. // end_of_updateObjForSet

  method public void UpdateObjForSchedw0
  ( input  p-subs    as class promoSchedwSubs
  ) :
    define variable v-sub   as class promoSchedwSub no-undo.
    define variable vi      as integer no-undo .
    define variable v-days  as character no-undo .
    /* для простого расписания на одна запись в temp-table распределяется в коллекцию так:
       - первая строка в коллекции обновляется, согласно отображению на экране;
       - остальным строчкам коллекции проставляется delete
    */
    for first tt-promo-schedule-week:
      v-days = "".
      assign
        v-days = v-days + ",1" when tt-promo-schedule-week.isday_mon
        v-days = v-days + ",2" when tt-promo-schedule-week.isday_tue
        v-days = v-days + ",3" when tt-promo-schedule-week.isday_wed
        v-days = v-days + ",4" when tt-promo-schedule-week.isday_thu
        v-days = v-days + ",5" when tt-promo-schedule-week.isday_fri
        v-days = v-days + ",6" when tt-promo-schedule-week.isday_sat
        v-days = v-days + ",7" when tt-promo-schedule-week.isday_sun
      .
      v-days = substring(v-days, 2) .
      vi = p-subs:GetItem(1) .
      if vi > 0 then
        v-sub = p-subs:promoSchedwObjCurr .
      else do:
        v-sub = new promoSchedwSub().
        assign
          v-sub:Mode    = {&h-create}
        . 
      end.
      assign
        v-sub:timebeg  = integer( truncate(  mtime(tt-promo-schedule-week.dtime-beg) / 1000,  0  ) ) 
        v-sub:timeend  = integer( truncate(  mtime(tt-promo-schedule-week.dtime-end) / 1000,  0  ) )
        v-sub:wdaylist = v-days
      .
      do vi = 2 to p-subs:GetItem(vI):
        v-sub = p-subs:promoSchedwObjCurr .
        v-sub:Mode = {&h-delete} .
      end .
    end.
        
  end method. // end_of_UpdateObjForSchedw0

  method public void UpdateObjForSchedw1
  ( input  p-subs    as class promoSchedwSubs
  ) :
/*    
    define variable v-sub   as class promoSchedwSub no-undo.
    define variable vi      as integer no-undo .
    for first tt-promo-schedule-week:
      vi = p-subs:GetItem(1) .
      if vi > 0 then
        v-sub = p-subs:promoSchedwObjCurr .
      else do:
        v-sub = new promoSchedwSub().
        assign
          v-sub:ID      = tt-promo-schedule-week.id
          v-sub:db-num  = tt-promo-schedule-week.db-num
          v-sub:schedId = tt-promo-schedule-week.promosched-id
          v-sub:Mode    = {&h-create}
        . 
      end.
      assign
        v-sub:timebeg  = truncate(  mtime(tt-promo-schedule-week.timebeg) / 1000,  0  ) 
        v-sub:timeend  = truncate(  mtime(tt-promo-schedule-week.timeend) / 1000,  0  )
        v-sub:wdaylist = tt-promo-schedule-week.wdaylist 
      .
      do vi = 2 to p-subs:GetItem(vI):
        v-sub = p-subs:promoSchedwObjCurr .
        v-sub:Mode = {&h-delete} .
      end .
    end.
  */      
  end method. // end_of_UpdateObjForSchedw1


/* 2.3 проверить введённые значение (лежат в temp-table после bindingSource:Assign) */
  method public void checkPromoAction () :
    /*message tt-promoaction-one.status_lbl
    tt-promoaction-one.nameaction
    view-as alert-box.*/
  end method. // end_of_checkPromoAction 

  
end class .
