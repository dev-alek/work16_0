/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Класс ипорта данных kass-book (типы кассовых книг) из 1С

Автор: Молотков Сергей
Дата создания: 13/02/19
Author: Molotkov Sergey
Creation date: 13/02/19

*/
&scoped-define impclass kass-book
using ibs.th.bge.1crn.subjects.subjects.
using ibs.th.bge.1crn.subjects.{&impclass}.

block-level on error undo, throw.

class ibs.th.bge.1crn.import.imp{&impclass} implements ibs.th.bge.1crn.import.iimpsubject: 

  { ibs/th/ref/ttCashBook.i }
  { ibs/th/ref/ttCashBookRule.i }
  
  { cmp/str-glbl.i class } /* &add-def, &update, &deletion, &shop, &attr-cash-book-id, &attr-oper-serv-id */
  /* { gbl/attr-lib.i class } gds-attr-write() заинлайнена */
  
  define private temp-table tt-gds no-undo
    field gds-code as integer
  .
  define private temp-table tt-operserv no-undo like ub.OperServ .
  
  define property Msg as character no-undo
    get. 
    set.

  method public logical Excute( subjectObj as class ibs.th.bge.1crn.subjects.isubject ):
    define variable objImp    as class {&impclass} no-undo.
    define variable v-retfl   as logical no-undo .
    define variable v-mode    as character no-undo. /* create/update */
    define variable v-storage as class ibs.th.ref.cashbookstorage no-undo .

    define variable v-code      as character no-undo .
    define variable v-basic-kb  as integer no-undo .
    define variable v-objlist   as class ibs.th.bge.1crn.subjects.subjects no-undo . // imp:kb-gds[]
    define variable v-gds-gd    as class ibs.th.bge.1crn.subjects.kass-book-gd no-undo .
    define variable v-i-counter as integer no-undo .
    define variable v-i-num     as integer no-undo .
    define variable v-stub      as integer no-undo .
    define variable v-gds-code  as integer no-undo .
    define variable v-str-kb-id as character no-undo .
    define variable v-str-ossid as character no-undo .
    define variable v-pay-agent as class ibs.th.bge.1crn.subjects.payment-agent no-undo . // imp:payment-agent
    define variable v-cashbookid as int64 no-undo .
    define variable v-operservid as int64 no-undo .
    define variable v-typecalcrepl as integer no-undo .
    define buffer buf_clients    for ub.clients .
    define buffer buf_goods      for ub.goods .
    define buffer buf_goods-attr for ub.goods-attr .
    define buffer buf_OperServ   for ub.OperServ .
    

    objImp = cast (subjectObj, {&impclass}).

    if objImp:del-f > 0 then
      undo, throw new Progress.Lang.AppError("физичесткое удаление Типа кассовых книг не предусмотрено") .    
    
    /* если код не задан:
         - если пришла с признаком "основная" - то обновляем CashBook.id = 0 и не грузим секцию с товарами;
         - если пришла без признака "основная" - то режим создания с автоматическим присвоением кода;
       если код задан:
         - признак "основная" игнорируется;
         - если код присутствует в БД - режим обновления;
         - если код отсутствует в БД - режим создания;
       логическое удаление - только, если код задан, присутствует в БД, и CashBook.id <> 0.
       
       чтобы при изменении записи не затирать поля, которые не приходят из 1С, значениями по умолчанию -
       читаем их значения из исходной записи;
       чтобы при изменении записи не затирать поля из необязательных тегов, которые пришли из 1С, пустыми значениями -
       читаем их значения из исходной записи.
    */
    assign
      v-code     = objImp:code_
      v-basic-kb = objImp:basic-kb
      Msg        = "":U
    .
    empty temp-table tt-cashbook .
    
    if v-code > "" then do :
      v-basic-kb = ? .
      v-storage = new ibs.th.ref.cashbookstorage () .
      v-storage:getcashbook(v-code, output dataset ds-cashbook by-reference) .
      find first tt-cashbook no-error .
      if available tt-cashbook then do :
        v-str-kb-id = string(tt-cashbook.id) .
        /* ТР вер.1.9 4.3.4.1: Удалить – логическое удаление записи справочника; */
        if objImp:del-l > 0 then do :
          if tt-cashbook.id = 0 then undo, throw new Progress.Lang.AppError(        
            substitute("Ошибка логического удаления. Попытка удаления кассовой книги по признаку «Основная деятельность».")
          ) .
          v-mode = {&deletion} .
        end .
        else v-mode = {&update} .
      end .
      else do :
        if objImp:del-l > 0 then do :
          undo, throw new Progress.Lang.AppError(        
            substitute("Ошибка логического удаления. Тип кассовой книги с кодом [&1] отсутствует в БД.", v-code)
           ) .
        end .
        v-mode = {&add-def} .
        create tt-cashbook .
        assign
          tt-cashbook.ext-code = v-code
        .
      end .
    end .
    else do :
      if objImp:del-l > 0 then
        undo, throw new Progress.Lang.AppError("Не задан код Типа кассовой книги для логического удаления.").
      v-storage = new ibs.th.ref.cashbookstorage () .
      if v-basic-kb = 0 then do :
        v-storage:getcashbook(0, output dataset ds-cashbook by-reference) .
        find first tt-cashbook no-error .
        if available tt-cashbook then assign
          v-str-kb-id = "0"
          v-mode = {&update}
        .
        else undo, throw new Progress.Lang.AppError(        
            substitute("Ошибка импорта кассовой книги по признаку «Основная деятельность»: тип кассовой книги с кодом [0] отсутствует в БД.")
           ) .
      end .
      else do :
        v-mode = {&add-def} .
        create tt-cashbook .
        assign
          tt-cashbook.ext-code = v-code
        .
      end .
    end.
    

    if v-mode = {&deletion} then do :
      if tt-cashbook.Status_ = 0 /* 0:"Текущий" */ then do : 
        for each buf_goods-attr exclusive-lock
           where buf_goods-attr.attr-code  = {&attr-cash-book-id}
             and buf_goods-attr.attr-value = v-str-kb-id :
          delete buf_goods-attr.
        end .
        find first buf_OperServ exclusive-lock
             where buf_OperServ.ext-code = tt-cashbook.ext-code no-error .
        if available buf_OperServ then do:
          buf_OperServ.Status_ = 1 .
          /* или менять buf_OperServ.Status_ на статус, полученный tt-cashbook внутри v-storage:deleteDB() */
          for each buf_goods-attr exclusive-lock
             where buf_goods-attr.attr-code  = {&attr-oper-serv-id}
               and buf_goods-attr.attr-value = string(buf_OperServ.id) :
            delete buf_goods-attr.
          end .
        end .
        v-storage:deleteDB(input dataset ds-cashbook by-reference) .
      end .
      return true .
    end .

   
    assign
      tt-cashbook.CashBookName = objImp:name_       when objImp:name_ <> ?
      tt-cashbook.RuleOsn      = getRuleOsnName(objImp:rule-reason) when objImp:rule-reason <> ?
      tt-cashbook.RulePril     = getRulePrilName(objImp:rule-att)   when objImp:rule-att <> ?
      tt-cashbook.FlagSepCash  = (objImp:ind-kass-pko = 1) when objImp:ind-kass-pko <> ?
      tt-cashbook.FlagSepFull  = (objImp:apart-np-tnp = 1) when objImp:apart-np-tnp <> ?
      tt-cashbook.Credit       = objImp:kredit      when objImp:kredit <> ?
      tt-cashbook.Debit        = objImp:debit       when objImp:debit <> ?
   /* tt-cashbook.Status_      = 0:"Текущий", 1:"Удаленный"
      - при создании заполняется значением по умолчанию, при обновлении остаётся в прежнем значении */
    .
    if v-mode = {&add-def} then do :
      v-storage:insertDB(buffer tt-cashbook, output v-cashbookid) .
      if v-storage:Msg <> "" then undo, throw new Progress.Lang.AppError(        
        substitute("Ошибка импорта кассовой книги [&1]: &2", objImp:name_, v-storage:Msg)
      ) .
      
      tt-cashbook.id = v-cashbookid .
      v-str-kb-id = string(tt-cashbook.id) .
      for each buf_clients no-lock
         where buf_clients.db-num   = ibs.th.gbl.gbl-var:g#db-num
           and buf_clients.obj-type = {&shop}
           and buf_clients.stts     = {&bef-current-status-int} :
        empty temp-table tt-cashbookrule .
        create tt-cashbookrule .
        assign
          tt-cashbookrule.cashbookId      = tt-cashbook.id
          tt-cashbookrule.obj-type        = buf_clients.obj-type
          tt-cashbookrule.obj-code        = buf_clients.obj-code
          tt-cashbookrule.obj             = substitute("&1&2", tt-cashbookrule.obj-type, tt-cashbookrule.obj-code)
          tt-cashbookrule.host-code       = if buf_clients.obj-type = {&cmp} then string(buf_clients.obj-code) else string(buf_clients.host-code)
          /* 05/III-2019 Маски формировать из Получаемого префикса + "[NNNN]" */
          tt-cashbookrule.RkoMask         = substitute("&1[NNNN]", objImp:pko-prefix) when objImp:pko-prefix <> ?
          tt-cashbookrule.PkoMask         = substitute("&1[NNNN]", objImp:rko-prefix) when objImp:rko-prefix <> ?
          tt-cashbookrule.ManagerPosition = getMgrPositionName(objImp:post-chief) when objImp:post-chief <> ?
          tt-cashbookrule.ManagerFIO      = getMgrFioName(objImp:fio-chief)       when objImp:fio-chief <> ?
          tt-cashbookrule.BuhFIO          = getBuhFioName(objImp:fio-booker)      when objImp:fio-booker <> ?
          tt-cashbookrule.Struct          = getStructName(objImp:struct-unit) when objImp:struct-unit <> ?
          tt-cashbookrule.DptName         = objImp:struct-unit-name           when objImp:struct-unit-name <> ?
          tt-cashbookrule.DptType         = objImp:struct-unit-type           when objImp:struct-unit-type <> ?
          tt-cashbookrule.DptCode         = objImp:struct-unit-code           when objImp:struct-unit-code <> ?
          tt-cashbookrule.uchet           = getUchetName(objImp:acc-shift)        when objImp:acc-shift <> ?
        .
        v-storage:insertDBobj(input dataset ds-cashbookrule by-reference) .
        if v-storage:Msg <> "" then undo, throw new Progress.Lang.AppError(        
          substitute("Ошибка импорта кассовой книги [&1]: &2", objImp:name_, v-storage:Msg)
        ) .
      end .
    end .
    else do :
      v-storage:updateDB(buffer tt-cashbook) .
      if v-storage:Msg <> "" then undo, throw new Progress.Lang.AppError(        
        substitute("Ошибка импорта кассовой книги [&1]: &2", objImp:name_, v-storage:Msg)
      ) .
      for each buf_clients no-lock
         where buf_clients.db-num   = ibs.th.gbl.gbl-var:g#db-num
           and buf_clients.obj-type = {&shop}
           and buf_clients.stts     = {&bef-current-status-int} :
       empty temp-table tt-cashbookrule .
       v-storage:getCashBookRule (tt-cashbook.id, buf_clients.obj-type, buf_clients.obj-code, output dataset ds-cashbookrule by-reference) .
       find first tt-cashbookrule no-error .
       if available tt-cashbookrule then do :
         assign
          tt-cashbookrule.RkoMask         = substitute("&1[NNNN]", objImp:pko-prefix) when objImp:pko-prefix <> ?
          tt-cashbookrule.PkoMask         = substitute("&1[NNNN]", objImp:rko-prefix) when objImp:rko-prefix <> ?
          tt-cashbookrule.ManagerPosition = getMgrPositionName(objImp:post-chief) when objImp:post-chief <> ?
          tt-cashbookrule.ManagerFIO      = getMgrFioName(objImp:fio-chief)       when objImp:fio-chief <> ?
          tt-cashbookrule.BuhFIO          = getBuhFioName(objImp:fio-booker)      when objImp:fio-booker <> ?
          tt-cashbookrule.Struct          = getStructName(objImp:struct-unit) when objImp:struct-unit <> ?
          tt-cashbookrule.DptName         = objImp:struct-unit-name           when objImp:struct-unit-name <> ?
          tt-cashbookrule.DptType         = objImp:struct-unit-type           when objImp:struct-unit-type <> ?
          tt-cashbookrule.DptCode         = objImp:struct-unit-code           when objImp:struct-unit-code <> ?
          tt-cashbookrule.uchet           = getUchetName(objImp:acc-shift)        when objImp:acc-shift <> ?
         .
         v-storage:updateDBobj(input dataset ds-cashbookrule by-reference) .
         if v-storage:Msg <> "" then undo, throw new Progress.Lang.AppError(        
           substitute("Ошибка импорта кассовой книги [&1]: &2", objImp:name_, v-storage:Msg)
         ) .
       end .
       else do :
         create tt-cashbookrule .
         assign
          tt-cashbookrule.cashbookId      = tt-cashbook.id
          tt-cashbookrule.obj-type        = buf_clients.obj-type
          tt-cashbookrule.obj-code        = buf_clients.obj-code
          tt-cashbookrule.obj             = substitute("&1&2", tt-cashbookrule.obj-type, tt-cashbookrule.obj-code)
          tt-cashbookrule.host-code       = if buf_clients.obj-type = {&cmp} then string(buf_clients.obj-code) else string(buf_clients.host-code)
          /* 05/III-2019 Маски формировать из Получаемого префикса + "[NNNN]" */
          tt-cashbookrule.RkoMask         = substitute("&1[NNNN]", objImp:pko-prefix) when objImp:pko-prefix <> ?
          tt-cashbookrule.PkoMask         = substitute("&1[NNNN]", objImp:rko-prefix) when objImp:rko-prefix <> ?
          tt-cashbookrule.ManagerPosition = getMgrPositionName(objImp:post-chief) when objImp:post-chief <> ?
          tt-cashbookrule.ManagerFIO      = getMgrFioName(objImp:fio-chief)       when objImp:fio-chief <> ?
          tt-cashbookrule.BuhFIO          = getBuhFioName(objImp:fio-booker)      when objImp:fio-booker <> ?
          tt-cashbookrule.Struct          = getStructName(objImp:struct-unit) when objImp:struct-unit <> ?
          tt-cashbookrule.DptName         = objImp:struct-unit-name           when objImp:struct-unit-name <> ?
          tt-cashbookrule.DptType         = objImp:struct-unit-type           when objImp:struct-unit-type <> ?
          tt-cashbookrule.DptCode         = objImp:struct-unit-code           when objImp:struct-unit-code <> ?
          tt-cashbookrule.uchet           = getUchetName(objImp:acc-shift)        when objImp:acc-shift <> ?
         .
         v-storage:insertDBobj(input dataset ds-cashbookrule by-reference) .
         if v-storage:Msg <> "" then undo, throw new Progress.Lang.AppError(        
           substitute("Ошибка импорта кассовой книги [&1]: &2", objImp:name_, v-storage:Msg)
         ) .
       end .
      end . /* end_of for_each_clients */
    end .


    /* платёжный агент:
      - ext-code платёжного агента совпадает с ext-code кассовой книги, к которой он относится в 1с;
      - новый платёжный агент добавляется, старый - обновляется;
      - при удалении Status_ у платёжного агента изменяется как Status_ у кассовой книги.
      Ид. платёжного агента далее используется вместе с ид.кассовой книги для привязки товара к кассовой книге.
    */
    empty temp-table tt-operserv .
    v-pay-agent = objImp:payment-agent .
    if valid-object(v-pay-agent) then do :
      if v-pay-agent:type-calc-repl <> ? then do :
        v-typecalcrepl = integer(v-pay-agent:type-calc-repl) no-error .
        /* 07/III-2019 Допустимые значения: 0 - пусто, 1 - "Автопомощь" */
        if (v-typecalcrepl = 0) or (v-typecalcrepl = 1) then .
        else undo, throw new Progress.Lang.AppError( substitute(
            "Тип расчета с опер.пополн. [&1] для платёжного агента из типа кассовой книги [&2] может принимать только значения значения: 0 - пусто, или 1 - Автопомощь."
            , v-pay-agent:type-calc-repl, objImp:name_
        ) ) .
      end .
      else v-typecalcrepl = 0 .
          
      find first buf_OperServ exclusive-lock
           where buf_OperServ.ext-code = tt-cashbook.ext-code no-error .
      if available buf_OperServ then do :
        create tt-operserv .
        buffer-copy buf_OperServ to tt-operserv .
      end .
      else do :
        create tt-operserv .
        assign
          tt-operserv.id       = next-value (s-operserv-id)
          tt-operserv.ext-code = tt-cashbook.ext-code
        .
      end .
      assign
        v-operservid = tt-operserv.id
/* char   */ tt-operserv.OSname    = v-pay-agent:name_   when v-pay-agent:name_ <> ?
/* char      tt-operserv.OsNameAbbr = отсутствует в формате импорта */ 
/* deci-2 */ tt-operserv.SummMin   = v-pay-agent:min-sum     when v-pay-agent:min-sum <> ?
/* deci-2 */ tt-operserv.SummMax   = v-pay-agent:max-sum     when v-pay-agent:max-sum <> ?
/* deci-2 */ tt-operserv.SummAtent = v-pay-agent:warning-sum when v-pay-agent:warning-sum <> ?
/* inte   */ tt-operserv.CommType  = v-pay-agent:comm-entry-type when v-pay-agent:comm-entry-type <> ? 
/* deci-2 */ tt-operserv.CommSumm  = v-pay-agent:sum-comm        when v-pay-agent:sum-comm <> ?
/* deci-2 */ tt-operserv.CommPerc  = v-pay-agent:pct-comm        when v-pay-agent:pct-comm <> ? 
/* logi   */ tt-operserv.PreAAvt   = (v-pay-agent:auth-req > 0)    when v-pay-agent:auth-req <> ?
/* logi   */ tt-operserv.PreSlip   = (v-pay-agent:prt-slp-req > 0) when v-pay-agent:prt-slp-req <> ?
/* char   */ tt-operserv.SlipName  = v-pay-agent:name-slp          when v-pay-agent:name-slp <> ?
/* inte   */ tt-operserv.CalcType  = v-typecalcrepl                when v-pay-agent:type-calc-repl <> ?
/* char   */ tt-operserv.OperAddr  = v-pay-agent:adr-trans-op    when v-pay-agent:adr-trans-op <> ?
/* char   */ tt-operserv.OperInn   = v-pay-agent:inn-trans-op    when v-pay-agent:inn-trans-op <> ?
/* char   */ tt-operserv.OperName  = v-pay-agent:name-trans-op   when v-pay-agent:name-trans-op <> ?
/* inte   */ tt-operserv.AgentFlag = integer(v-pay-agent:sign-pa) when v-pay-agent:sign-pa <> ?
/* char   */ tt-operserv.AgentTel  = v-pay-agent:tel-pa           when v-pay-agent:tel-pa <> ?
/* char   */ tt-operserv.OperTel   = v-pay-agent:tel-acceptor     when v-pay-agent:tel-acceptor <> ?
/* inte   */ tt-operserv.AgentFlagRasch = integer(v-pay-agent:sign-pa-subj) when v-pay-agent:sign-pa-subj <> ?
/* char   */ tt-operserv.InnSupp   = v-pay-agent:inn-prov          when v-pay-agent:inn-prov <> ?
/* char   */ tt-operserv.OperTelTran    = v-pay-agent:tel-trans-op when v-pay-agent:tel-trans-op <> ?
/* char   */ tt-operserv.AgentOpere     = v-pay-agent:oper-pa      when v-pay-agent:oper-pa <> ?
/* char   */ tt-operserv.SuppTel   = v-pay-agent:tel-prov          when v-pay-agent:tel-prov <> ?
/* char   */ tt-operserv.SuppName  = v-pay-agent:name-prov         when v-pay-agent:name-prov <> ?
/* inte   */ tt-operserv.QuantMax  = v-pay-agent:max-num     when v-pay-agent:max-num <> ?
/* inte   */ tt-operserv.QuantMin  = v-pay-agent:min-num     when v-pay-agent:min-num <> ?
      .
      if available buf_OperServ then do :
        buffer-copy tt-operserv to buf_OperServ .
      end .
      else do :
        create buf_OperServ .
        buffer-copy tt-operserv to buf_OperServ .
      end .
      
    end . // end_of_payment-agent
    else v-operservid = ? .

    /* на выходе товары:
       - привязаны к пришедшей кассовой книге,
       - других товаров к ней не привязано,
       - от других книг товары отвязаны
    */
    &scop proc-name gds-attr-write
    empty temp-table tt-gds .
    if (v-mode = {&update}) and (v-basic-kb = 0) then do :
      /* при обновлении основной кассовой книги секция с товарами игнорируется */
    end .
    else do :
      
      v-objlist = objImp:kb-gds .
      if valid-object(v-objlist) then do :
        v-i-counter = v-objlist:iCounter .
        do v-i-num = 1 to v-i-counter :
          v-stub = v-objlist:Get(v-i-num) . // возвращает кол-во элементов и переключает currItem
          v-gds-gd = cast(v-objlist:SubjectObjCurr, ibs.th.bge.1crn.subjects.kass-book-gd) .
          v-gds-code = integer(v-gds-gd:gd-code) .
          if not can-find (first buf_goods where buf_goods.gds-code = v-gds-code) then
            undo, throw new Progress.Lang.AppError( substitute(
              "Код товара [&1] из кассовой книги [&2 &3] отсутствует в справочнике товаров."
              , v-gds-code, v-code, objImp:name_
          ) ) .
          create tt-gds.
          tt-gds.gds-code = v-gds-code .
        end . // end_of_objImp:gds[]

        v-str-ossid = string(v-operservid) no-error .
        
        /* Отвязать от других кассовых книг. Скопировано из attr-lib:gds-attr-DELETE() */
        if v-mode = {&update} then do :
          for each buf_goods-attr exclusive-lock
             where buf_goods-attr.attr-code  = {&attr-cash-book-id}
               and buf_goods-attr.attr-value = v-str-kb-id :
            if not can-find (first tt-gds where tt-gds.gds-code = buf_goods-attr.gds-code) then
              delete buf_goods-attr.
          end .
          for each buf_goods-attr exclusive-lock
             where buf_goods-attr.attr-code  = {&attr-oper-serv-id}
               and buf_goods-attr.attr-value = v-str-ossid :
            if not can-find (first tt-gds where tt-gds.gds-code = buf_goods-attr.gds-code) then
              delete buf_goods-attr.
          end .
        end .
        /* Перепривязать к пришедшей кассовой книге. Скопировано из attr-lib:gds-attr-write() */
        for each tt-gds :
          find first buf_goods-attr exclusive-lock
               where buf_goods-attr.gds-code  = tt-gds.gds-code
                 and buf_goods-attr.attr-code = {&attr-cash-book-id} no-error .
          if available buf_goods-attr then assign
            buf_goods-attr.attr-value = v-str-kb-id when (buf_goods-attr.attr-value <> v-str-kb-id)
          .
          else do:
            create buf_goods-attr .
            assign
              buf_goods-attr.gds-code   = tt-gds.gds-code
              buf_goods-attr.attr-code  = {&attr-cash-book-id}
              buf_goods-attr.attr-value = v-str-kb-id
            .
          end.
          find first buf_goods-attr exclusive-lock
               where buf_goods-attr.gds-code  = tt-gds.gds-code
                 and buf_goods-attr.attr-code = {&attr-oper-serv-id} no-error .
          if available buf_goods-attr then assign
            buf_goods-attr.attr-value = v-str-ossid when (buf_goods-attr.attr-value <> v-str-ossid)
          .
          else do:
            create buf_goods-attr .
            assign
              buf_goods-attr.gds-code   = tt-gds.gds-code
              buf_goods-attr.attr-code  = {&attr-oper-serv-id}
              buf_goods-attr.attr-value = v-str-ossid
            .
          end.
        end .
        /* образец вызова из attr-lib.p
        {&run_proc_attr-lib}
        (input  v-gds-code
        ,input  {&attr-cash-book-id}
        ,input  v-str-kb-id
        ) no-error .
        */
      end. // end_of_gds

    end .

/*

Остались несопоставленными

define property payment-agent     as ibs.th.bge.1crn.subjects.payment-agent no-undo
payment-agent   0-1 Секция с параметрами платежного агента

  define property code_           as character    no-undo get. private set.

OperServ

OsType;integer;9;Тип;Тип;0;Тип;180;;0;;false;false;;;;;;;;;;;;

    if tt-query.OsType = "OCC" then 
    do:
      button_addOSS_Click({&lookup} , tt-query.id) .
    end.
    else 
    do:
      button_addBPA_Click({&lookup} , tt-query.id ) .
    end.    

      if ub.OperServ.OsType = 1 then type_ = "OCC" .
      else type_ = "ПА/БПА" .   


                  if ub.OperServ.OsType = 0 then 
                  do:
                    tt-query.OsType = "ПА/БПА" .
                  end.
                  else 
                  do:
                    tt-query.OsType = "OCC" .
                  end.              


                  if ub.OperServ.OsType = 0 then 
                  do:
                    tt-query.OsType = "ПА/БПА" .
                  end.
                  else 
                  do:
                    tt-query.OsType = "OCC" .
                  end.              

                  if ub.OperServ.OsType = 0 then 
                  do:
                    tt-query.OsType = "ПА/БПА" .
                  end.
                  else 
                  do:
                    tt-query.OsType = "OCC" .
                  end.              

*/
    

    v-retfl = true.
    
    catch exAppErrors as class Progress.Lang.AppError :
      Msg = exAppErrors:ReturnValue .
      if Msg > "" then . else do :
        Msg = exAppErrors:GetMessage(1) .
        if Msg > "" then . else Msg = "AppError в типах кассовых книг" .
      end .
      v-retfl = false .
      undo, throw exAppErrors .
    end catch .
    catch exProErrors as class Progress.Lang.ProError :
      Msg = exProErrors:GetMessage(1) . 
      if Msg > "" then . else Msg = "ProError в типах кассовых книг" .
      v-retfl = false.
      undo, throw exProErrors .
    end catch .
    catch exAnyErrors as class Progress.Lang.Error:
      Msg = "Unexpected error в типах кассовых книг" .
      v-retfl = false .
      undo, throw exAnyErrors .
    end catch .
    finally :
      dataset ds-cashbook:empty-dataset() .
      if valid-object(v-storage) then delete object v-storage .
      return v-retfl .
    end finally .
  end method. /* end_of Excute */


  method private character getMgrPositionName (input p-post-chief as integer) :
    /* Должность рук-ля
• 0 – должность рук-ля фирмы
• 1 – «директор»
• 2 – «управляющий»
    */
    define variable v-name as character no-undo .
    case p-post-chief :
      when 1 then v-name = "директор" .
      when 2 then v-name = "управляющий" .
      otherwise do :
        // как найти должность руководителя фирмы?
      end .
    end case .
    return v-name .
  end method . /* end_of getMgrPositionName */

  method private character getMgrFioName (input p-fio-chief as integer) :
    /* ФИО рук-ля
• 0 - "ФИО руководителя фирмы"
• 1 - "ФИО руководителя магазина"
    */
    define variable v-name as character no-undo .
    case p-fio-chief :
      when 1 then v-name = "ФИО руководителя магазина" .
        otherwise v-name = "ФИО руководителя фирмы" .
    end case .
    return v-name .
  end method . /* end_of getMgrFioName */

  method private character getBuhFioName (input p-fio-booker as integer) :
    /* ФИО бухг-ра
• 0 - "ФИО гл. бухгалтера фирмы"
• 1 - "ФИО бухгалтера магазина"
    */
    define variable v-name as character no-undo .
    case p-fio-booker :
      when 1 then v-name = "ФИО бухгалтера магазина" .
        otherwise v-name = "ФИО гл. бухгалтера фирмы" .
    end case .
    return v-name .
  end method . /* end_of getBuhFioName */

  method private character getStructName (input p-struct-unit as integer) :
    /* Поле «Структурн.подразд»
• 0 – заполняет оператор
• 1 – из настроек объекта
• 2 – свободный текст
       В экранной форме реализован выбор:
arrayvar5[1] = "Заполняет оператор".
arrayvar5[2] = "Взять из объекта".
arrayvar5[3] = "Значение по умолчанию".
    */
    define variable v-name as character no-undo .
    case p-struct-unit :
      when 1 then v-name = "Взять из объекта" .
      when 2 then v-name = "Значение по умолчанию" .
        otherwise v-name = "Заполняет оператор" .
    end case .
    return v-name .
  end method . /* end_of getStructName */
  
  method private character getRuleOsnName (input p-rule-reason as integer) :
    /* Правило заполнения графы "Основание"
• 0 - "Выручка от реализации"
• 1 - "Номера Z-отчетов"
• 2 - "Не заполнять"
    */
    define variable v-name as character no-undo .
    case p-rule-reason :
      when 1 then v-name = "Номера Z-отчетов" .
      when 2 then v-name = "Не заполнять" .
        otherwise v-name = "Выручка от реализации" .
    end case .
    return v-name .
  end method . /* end_of getRuleOsnName */
    
  method private character getRulePrilName (input p-rule-att as integer) :
    /* Правило заполнения графы "Приложение"
• 0 - "Номера Z-отчетов"
• 1 - "Не заполнять"
    */
    define variable v-name as character no-undo .
    case p-rule-att :
      when 1 then v-name = "Не заполнять" .
        otherwise v-name = "Номера Z-отчетов" .
    end case .
    return v-name .
  end method . /* end_of getRulePrilName */

  method private character getUchetName (input p-acc-shift as integer) :
    /* Учет ведется по:
• 0 –календарным датам
• 1 –по сменам
       В экранной форме реализован выбор:
arrayvar6[1] = "по сменным датам".
arrayvar6[2] = "по календарным датам".
    */
    define variable v-name as character no-undo .
    case p-acc-shift :
      when 1 then v-name = "по сменным датам" .
        otherwise v-name = "по календарным датам" .
    end case .
    return v-name .
  end method . /* end_of getUchetName */
    
end class.
