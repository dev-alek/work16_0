 
 /*------------------------------------------------------------------------
    File        : cashbookstorage
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : SSlivenko
    Created     : Thu Feb 14 10:39:01 AST 2019
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

block-level on error undo, throw.

class ibs.th.ref.cashbookstorage final: 
  {cmp/str-glbl.i class}
  
  { ibs/th/ref/ttCashBook.i }
  { ibs/th/ref/ttCashBookRule.i }
  
  define property Msg as character
    get.
    private set.
  
  define variable mQuery as handle no-undo.
  define variable mQueryRule as handle no-undo.
  define variable objKeyRec as ibs.th.gbl.keyrec no-undo.
  define variable objCount  as ibs.th.ref.counter.counterstorage no-undo.
  constructor public cashbookstorage (  ):
    super ().
    objKeyRec = new ibs.th.gbl.keyrec().
    objCount  = new ibs.th.ref.counter.counterstorage().
      
  end constructor.

  destructor public cashbookstorage ( ):
     delete object objKeyRec.
     delete object objCount.
  end destructor.
  
  method private void checkCashBook (buffer tt-cashbook for tt-cashbook) :
    Msg = "" .
    if trim(tt-cashbook.CashBookName) = ""
    then do :
      Msg = "Наименование типа кассовой книги не может быть пустым!" .
      return .
    end.
    if trim(tt-cashbook.CorrPko) = ""
    then do :
      Msg = "Поле Кор. счет ПКО не может быть пустым!" .
      return .
    end.
    if trim(tt-cashbook.CorrRko) = ""
    then do :
      Msg = "Поле Кор. счет РКО не может быть пустым!" .
      return .
    end.
     if trim(tt-cashbook.OSnAcct) = ""
    then do :
      Msg = "Поле Основной счет не может быть пустым!" .
      return .
    end.
    if trim(tt-cashbook.RuleOsnPko) = ""
    then do :
      Msg = 'Правило заполнения графы "Основание" ПКО не может быть пустым!' .
      return .
    end.
    if trim(tt-cashbook.RuleOsnRko) = ""
    then do :
      Msg = 'Правило заполнения графы "Основание" РКО не может быть пустым!' .
      return .
    end.
    if trim(tt-cashbook.RulePril) = ""
    then do :
      Msg = "Правило заполнения графы Приложение не может быть пустым!" .
      return .
    end.
    if trim(tt-cashbook.cli-type) = ""
    or tt-cashbook.cli-code = ? or tt-cashbook.cli-code <= 0
    then do :
      Msg = "Выберите контрагента для автоматического формирования платежей. Поле Контрагент (авто)." .
      return .
    end.
   /* if trim(tt-cashbook.takenfrom) = ""
    then do :
      Msg = "Поле Принято от (авто) не может быть пустым!" .
      return .
    end.
    */
    find first ub.cashbook no-lock where ub.CashBook.CashBookName = tt-cashbook.CashBookName and ub.CashBook.id <> tt-cashbook.id no-error.
    if available ub.cashbook
    then do :
      Msg = "Уже есть тип кассовой книги с наименованием  " + tt-cashbook.CashBookName .
      return .
    end.
    
    return .
  end method .
  
  method private void checkCashBookRule (buffer tt-cashbookrule for tt-cashbookrule) :
    Msg = "" .
    if trim(tt-cashbookrule.obj) = ""
    then do :
      Msg = "Выберите объект!" .
      return .
    end.
    if tt-cashbookrule.obj-type <> {&shop}
    then do :
      if trim(tt-cashbookrule.ManagerPosition) = ""
      then do :
        Msg = "Выберите должность руководителя!" .
        return .
      end.
      if trim(tt-cashbookrule.ManagerFIO) = ""
      then do :
        Msg = "Выберите ФИО руководителя!" .
        return .
      end.
      if trim(tt-cashbookrule.BuhFIO) = ""
      then do :
        Msg = "Выберите ФИО бухгалтера!" .
        return .
      end.
      if trim(tt-cashbookrule.struct) = ""
      then do :
        Msg = "Поле <Структурное подразделение> не выбрано!" .
        return .
      end.
      if trim(tt-cashbookrule.uchet) = ""
      then do :
        Msg = "Поле <учёт ведётся> не выбрано!" .
        return .
      end.
      if trim(tt-cashbookrule.PkoMask) = ""
      then do :
        Msg = "Маска ПКО не может быть пустой!" .
        return .
      end.
      if trim(tt-cashbookrule.RkoMask) = ""
      then do :
        Msg = "Маска РКО не может быть пустой!" .
        return .
      end.
    end.
    
    if tt-cashbookrule.obj-type <> {&cmp}
    then do :
      if tt-cashbookrule.currPko > ""
      then do :
        int64(tt-cashbookrule.currPko) no-error.
        if error-status:error
        then do :
          Msg = "Текущий номер ПКО должен быть целым числом (без маски)" .
          return .
        end.
      end.
      if tt-cashbookrule.currRko > ""
      then do :  
        int64(tt-cashbookrule.currRko) no-error.
        if error-status:error
        then do :
          Msg = "Текущий номер РКО должен быть целым числом (без маски)" .
          return .
        end.
      end.
    end.
    
    return.
  end method .
  
  method public void insertDB (buffer tt-cashbook for tt-cashbook, output p-id as int64) :
    
      checkCashBook(buffer tt-cashbook) .
      if Msg <> ""
      then return .
      
      create ub.cashbook .
      buffer-copy tt-cashbook except tt-cashbook.RulePril to ub.CashBook
      assign
        ub.CashBook.id = if tt-cashbook.basic-kb then 0 else next-value(s-cashbook-id)
        ub.CashBook.Status_ = 0
        ub.CashBook.RulePril = getRulePrilID(tt-cashbook.RulePril)
        ub.CashBook.RuleOsn = getRuleOsnID(tt-cashbook.RuleOsn) 
      .
      p-id = ub.CashBook.id .
  
  end method .
  
  method public void insertDBobj (input dataset for ds-cashbookrule) :
    for each tt-cashbookrule :
      checkCashBookRule(buffer tt-cashbookrule) .
      if Msg <> ""
      then return .
      
      create ub.cashbookrule .
      assign
        ub.cashbookrule.CashBookID  = tt-cashbookrule.CashBookID
        ub.cashbookrule.Obj-code    = tt-cashbookrule.Obj-code
        ub.cashbookrule.Obj-type    = tt-cashbookrule.obj-type
        ub.cashbookrule.host-code   = tt-cashbookrule.host-code 
        ub.cashbookrule.Status_     = 0
        ub.cashbookrule.Code        = 1 /* Маска ПКО */
        ub.cashbookrule.RuleValue   = tt-cashbookrule.PkoMask
      .
      
      create ub.cashbookrule .
      assign
        ub.cashbookrule.CashBookID  = tt-cashbookrule.CashBookID
        ub.cashbookrule.Obj-code    = tt-cashbookrule.Obj-code
        ub.cashbookrule.Obj-type    = tt-cashbookrule.obj-type
        ub.cashbookrule.host-code   = tt-cashbookrule.host-code 
        ub.cashbookrule.Status_     = 0
        ub.cashbookrule.Code        = 2 /* Маска РКО */
        ub.cashbookrule.RuleValue   = tt-cashbookrule.RkoMask
      .
      
      if tt-cashbookrule.obj-type <> {&cmp}
      then do :
        create ub.cashbookrule .
        assign
          ub.cashbookrule.CashBookID  = tt-cashbookrule.CashBookID
          ub.cashbookrule.Obj-code    = tt-cashbookrule.Obj-code
          ub.cashbookrule.Obj-type    = tt-cashbookrule.obj-type
          ub.cashbookrule.host-code   = tt-cashbookrule.host-code 
          ub.cashbookrule.Status_     = 0
          ub.cashbookrule.Code        = 3 /* Текущий ПКО */
          ub.cashbookrule.RuleValue   = tt-cashbookrule.currPko
        .
        
         define variable v-cashbookrule-key-rec as character no-undo.
         objKeyRec:GenKeyRec ( input {&table_cashbookrule}
                                            ,input buffer ub.cashbookrule:handle
                                            ,output v-cashbookrule-key-rec).
         find first clients where clients.obj-type eq tt-cashbookrule.obj-type
                             and clients.obj-code eq tt-cashbookrule.obj-code
                             no-lock no-error.
         if     available clients
            and clients.db-num ne ?
         then                    
            objcount:SetCountValue(clients.db-num,"cashbookrule",v-cashbookrule-key-rec,"currPKO",int64(ub.cashbookrule.RuleValue)).
                             
        
        create ub.cashbookrule .
        assign
          ub.cashbookrule.CashBookID  = tt-cashbookrule.CashBookID
          ub.cashbookrule.Obj-code    = tt-cashbookrule.Obj-code
          ub.cashbookrule.Obj-type    = tt-cashbookrule.obj-type
          ub.cashbookrule.host-code   = tt-cashbookrule.host-code 
          ub.cashbookrule.Status_     = 0
          ub.cashbookrule.Code        = 4 /* Текущий РКО */
          ub.cashbookrule.RuleValue   = tt-cashbookrule.currRko
        .
        objKeyRec:GenKeyRec ( input {&table_cashbookrule}
                                            ,input buffer ub.cashbookrule:handle
                                            ,output v-cashbookrule-key-rec).
        find first clients where clients.obj-type eq tt-cashbookrule.obj-type
                             and clients.obj-code eq tt-cashbookrule.obj-code
                             no-lock no-error.
         if     available clients
            and clients.db-num ne ?
         then                    
            objcount:SetCountValue(clients.db-num,"cashbookrule",v-cashbookrule-key-rec,"currRKO",int64(ub.cashbookrule.RuleValue)).
         
        
      end.  
      
      create ub.cashbookrule .
      assign
        ub.cashbookrule.CashBookID  = tt-cashbookrule.CashBookID
        ub.cashbookrule.Obj-code    = tt-cashbookrule.Obj-code
        ub.cashbookrule.Obj-type    = tt-cashbookrule.obj-type
        ub.cashbookrule.host-code   = tt-cashbookrule.host-code 
        ub.cashbookrule.Status_     = 0
        ub.cashbookrule.Code        = 5 /* Должность руководителя */
        ub.cashbookrule.RuleValue   = tt-cashbookrule.ManagerPosition .
      .
      
      create ub.cashbookrule .
      assign
        ub.cashbookrule.CashBookID  = tt-cashbookrule.CashBookID
        ub.cashbookrule.Obj-code    = tt-cashbookrule.Obj-code
        ub.cashbookrule.Obj-type    = tt-cashbookrule.obj-type
        ub.cashbookrule.host-code   = tt-cashbookrule.host-code 
        ub.cashbookrule.Status_     = 0
        ub.cashbookrule.Code        = 6 /* ФИО руководителя */
        ub.cashbookrule.RuleValue   = tt-cashbookrule.ManagerFIO 
      .
      
      create ub.cashbookrule .
      assign
        ub.cashbookrule.CashBookID  = tt-cashbookrule.CashBookID
        ub.cashbookrule.Obj-code    = tt-cashbookrule.Obj-code
        ub.cashbookrule.Obj-type    = tt-cashbookrule.obj-type
        ub.cashbookrule.host-code   = tt-cashbookrule.host-code 
        ub.cashbookrule.Status_     = 0
        ub.cashbookrule.Code        = 7 /* ФИО бухгалтера */
        ub.cashbookrule.RuleValue   = tt-cashbookrule.BuhFIO
      .
      
      create ub.cashbookrule .
      assign
        ub.cashbookrule.CashBookID  = tt-cashbookrule.CashBookID
        ub.cashbookrule.Obj-code    = tt-cashbookrule.Obj-code
        ub.cashbookrule.Obj-type    = tt-cashbookrule.obj-type
        ub.cashbookrule.host-code   = tt-cashbookrule.host-code 
        ub.cashbookrule.Status_     = 0
        ub.cashbookrule.Code        = 8 /* Структурное подразделение */
        ub.cashbookrule.RuleValue   = tt-cashbookrule.Struct
      .
      
      create ub.cashbookrule .
      assign
        ub.cashbookrule.CashBookID  = tt-cashbookrule.CashBookID
        ub.cashbookrule.Obj-code    = tt-cashbookrule.Obj-code
        ub.cashbookrule.Obj-type    = tt-cashbookrule.obj-type
        ub.cashbookrule.host-code   = tt-cashbookrule.host-code 
        ub.cashbookrule.Status_     = 0
        ub.cashbookrule.Code        = 9 /* Учёт ведется */
        ub.cashbookrule.RuleValue   = tt-cashbookrule.uchet
      .
      
      create ub.cashbookrule .
      assign
        ub.cashbookrule.CashBookID  = tt-cashbookrule.CashBookID
        ub.cashbookrule.Obj-code    = tt-cashbookrule.Obj-code
        ub.cashbookrule.Obj-type    = tt-cashbookrule.obj-type
        ub.cashbookrule.host-code   = tt-cashbookrule.host-code 
        ub.cashbookrule.Status_     = 0
        ub.cashbookrule.Code        = 10 /* Наименование структурного подразделения по умлочанию */
        ub.cashbookrule.RuleValue   = tt-cashbookrule.DptName
      .
      
      create ub.cashbookrule .
      assign
        ub.cashbookrule.CashBookID  = tt-cashbookrule.CashBookID
        ub.cashbookrule.Obj-code    = tt-cashbookrule.Obj-code
        ub.cashbookrule.Obj-type    = tt-cashbookrule.obj-type
        ub.cashbookrule.host-code   = tt-cashbookrule.host-code 
        ub.cashbookrule.Status_     = 0
        ub.cashbookrule.Code        = 11 /* Тип структурного подразделения по умлочанию */
        ub.cashbookrule.RuleValue   = tt-cashbookrule.DptType
      .
      
      create ub.cashbookrule .
      assign
        ub.cashbookrule.CashBookID  = tt-cashbookrule.CashBookID
        ub.cashbookrule.Obj-code    = tt-cashbookrule.Obj-code
        ub.cashbookrule.Obj-type    = tt-cashbookrule.obj-type
        ub.cashbookrule.host-code   = tt-cashbookrule.host-code 
        ub.cashbookrule.Status_     = 0
        ub.cashbookrule.Code        = 12 /* Код структурного подразделения по умлочанию */
        ub.cashbookrule.RuleValue   = string(tt-cashbookrule.DptCode)
      .
      
    end.  
  end method .
  
  method public void updateDB (buffer tt-cashbook for tt-cashbook) :
      checkCashBook(buffer tt-cashbook) .
      if Msg <> ""
      then return .
      
      find first ub.cashbook exclusive-lock where ub.cashbook.id = tt-cashbook.id .
      buffer-copy tt-cashbook except tt-cashbook.RulePril tt-cashbook.RuleOsn to ub.CashBook .
      assign
      ub.CashBook.RuleOsn = getRuleOsnID(tt-cashbook.RuleOsn)
      ub.CashBook.RulePril = getRulePrilID(tt-cashbook.RulePril) 
      .
      
  end method .
  method private void CrRuleDBobj (buffer tt-cashbookrule for tt-cashbookrule  , icode as integer ) :
     find first ub.CashBookRule exclusive-lock where ub.CashBookRule.CashBookID  = tt-cashbookrule.CashBookID 
                                                 and ub.CashBookRule.host-code   = tt-cashbookrule.host-code
                                                 and ub.CashBookRule.Obj-type    = tt-cashbookrule.obj-type
                                                 and ub.CashBookRule.Obj-code    = tt-cashbookrule.obj-code
                                                 and ub.CashBookRule.Status_     = tt-cashbookrule.Status_
                                                 and ub.CashBookRule.Code        = icode 
        no-error .
     if not available ub.CashBookRule 
     then do:
        create ub.CashBookRule.
        assign
           ub.CashBookRule.CashBookID  = tt-cashbookrule.CashBookID 
           ub.CashBookRule.host-code   = tt-cashbookrule.host-code
           ub.CashBookRule.Obj-type    = tt-cashbookrule.obj-type
           ub.CashBookRule.Obj-code    = tt-cashbookrule.obj-code
           ub.CashBookRule.Status_     = tt-cashbookrule.Status_
           ub.CashBookRule.Code        = icode
        .
     end.
     ub.CashBookRule.RuleValue = if      icode eq 1 
                                  then tt-cashbookrule.PkoMask 
                                  else if icode eq 2 
                                  then tt-cashbookrule.RkoMask 
                                  else if icode eq 3 
                                  then tt-cashbookrule.currPko 
                                  else if icode eq 4 
                                  then tt-cashbookrule.currRko
                                  else if icode eq 5 
                                  then getMgrPositionID(tt-cashbookrule.ManagerPosition)
                                  else if icode eq 6 
                                  then getMgrFioID(tt-cashbookrule.ManagerFIO)
                                  else if icode eq 7 
                                  then getBuhFioID(tt-cashbookrule.BuhFIO)
                                  else if icode eq 8 
                                  then getStructID(tt-cashbookrule.Struct)
                                  else if icode eq 9 
                                  then getUchetID(tt-cashbookrule.uchet)
                                  else if icode eq 10 
                                  then tt-cashbookrule.DptName
                                  else if icode eq 11 
                                  then tt-cashbookrule.DptType
                                  else if icode eq 12 
                                  then string (tt-cashbookrule.DptCode)
                                  else ""
                                  
                                  .
         define variable v-cashbookrule-key-rec as character no-undo.
         if icode eq 3 or icode eq 4
         then do:
            objKeyRec:GenKeyRec ( input {&table_cashbookrule}
                                               ,input buffer ub.cashbookrule:handle
                                               ,output v-cashbookrule-key-rec).
            find first clients where clients.obj-type eq tt-cashbookrule.obj-type
                             and clients.obj-code eq tt-cashbookrule.obj-code
                             no-lock no-error.
            if     available clients
               and clients.db-num ne ?
            then
            objcount:SetCountValue(clients.db-num,
                                   "cashbookrule",
                                   v-cashbookrule-key-rec,
                                   if icode eq 3 then "currPKO" else if icode eq 4 then "currRko" else "",
                                   int64(ub.cashbookrule.RuleValue)).
           
        end.                             
  end method. 
  method public void updateDBobj (input dataset for ds-cashbookrule) :
    for each tt-cashbookrule :
      checkCashBookRule(buffer tt-cashbookrule) .
      if Msg <> ""
      then return .
      CrRuleDBobj(buffer tt-cashbookrule, 1).
      CrRuleDBobj(buffer tt-cashbookrule, 2).
      CrRuleDBobj(buffer tt-cashbookrule, 3).
      CrRuleDBobj(buffer tt-cashbookrule, 4).
      CrRuleDBobj(buffer tt-cashbookrule, 5).
      CrRuleDBobj(buffer tt-cashbookrule, 6).
      CrRuleDBobj(buffer tt-cashbookrule, 7).
      CrRuleDBobj(buffer tt-cashbookrule, 8).
      CrRuleDBobj(buffer tt-cashbookrule, 9).
      CrRuleDBobj(buffer tt-cashbookrule,10).
      CrRuleDBobj(buffer tt-cashbookrule,11).
      CrRuleDBobj(buffer tt-cashbookrule,12).
            
    end.                                        
  end method .
  
  method public void deleteDB (input dataset for ds-cashbook) :
    for each tt-cashbook :
      find first ub.cashbook exclusive-lock where ub.cashbook.id = tt-cashbook.id .
      if ub.CashBook.Status_ = 0
      then do :
        ub.CashBook.Status_ = 1.
        for each ub.CashBookRule exclusive-lock where ub.CashBookRule.CashBookID = ub.cashbook.id :
          delete ub.CashBookRule.
        end.
        for each ub.goods-attr exclusive-lock where ub.goods-attr.attr-code = {&attr-cash-book-id}
                                              and ub.goods-attr.attr-value = string(ub.cashbook.id):
        delete ub.goods-attr .
      end.
      end.  
      else
      if ub.CashBook.Status_ = 1
      then do :
        ub.CashBook.Status_ = 0.
/*        for each ub.CashBookRule exclusive-lock where ub.CashBookRule.CashBookID = ub.cashbook.id :*/
/*          ub.CashBookRule.Status_ = ub.CashBook.Status_ .                                          */
/*        end.                                                                                       */
      end. 
    end. 
  end method .
  
  method public void deleteDB (input id as int64) :
    
    find first ub.cashbook exclusive-lock where ub.cashbook.id = id .
    if ub.CashBook.Status_ = 0
    then do :
      ub.CashBook.Status_ = 1.
      for each ub.CashBookRule exclusive-lock where ub.CashBookRule.CashBookID = ub.cashbook.id :
        delete ub.CashBookRule.
      end.
      for each ub.goods-attr exclusive-lock where ub.goods-attr.attr-code = {&attr-cash-book-id}
                                              and ub.goods-attr.attr-value = string(ub.cashbook.id):
        delete ub.goods-attr .
      end.
    end.  
    else if ub.CashBook.Status_ = 1
    then do :
      ub.CashBook.Status_ = 0.
/*      for each ub.CashBookRule exclusive-lock where ub.CashBookRule.CashBookID = ub.cashbook.id :*/
/*        ub.CashBookRule.Status_ = ub.CashBook.Status_ .                                          */
/*      end.                                                                                       */
    end. 
    
  end method .
  
  method public void deleteDBobj (input cashbookId as int64, input p-obj-type as character, input p-obj-code as integer) :
    
    for each ub.cashbookrule exclusive-lock where ub.CashBookRule.CashBookID = cashbookId
                                              and ub.CashBookRule.obj-type   = p-obj-type
                                              and ub.CashBookRule.obj-code   = p-obj-code :
      delete ub.CashBookRule .                                          
    end.
    
  end method .
  
  method public void getcashbook (input pExtCode as character, output dataset ds-cashbook ) :
    define buffer buf_cashbook for ub.cashbook .
    for each buf_cashbook no-lock where buf_cashbook.ext-code = pExtCode :
      create tt-cashbook .
      buffer-copy buf_cashbook to tt-cashbook
      assign
        tt-cashbook.stat = if tt-cashbook.status_ = 0 then "Текущий" else if tt-cashbook.status_ = 1 then "Удаленный" else "?"
        tt-cashbook.basic-kb = tt-cashbook.id eq 0
      .
    end.
  end method.

  method public void getcashbook (input pCashBookId as int64, output dataset ds-cashbook ) :
    define buffer buf_cashbook for ub.cashbook .
    find first buf_cashbook no-lock where buf_cashbook.id = pCashBookId no-error .
    if available buf_cashbook then do :
      create tt-cashbook .
      buffer-copy buf_cashbook to tt-cashbook
      assign
        tt-cashbook.stat = if tt-cashbook.status_ = 0 then "Текущий" else if tt-cashbook.status_ = 1 then "Удаленный" else "?"
        tt-cashbook.basic-kb = tt-cashbook.id eq 0
      .
    end.
  end method.
  
  method public handle getquery
  ( input v-stat as character,
    input v-firm as character,
    output oQuery as handle,
    output oQueryRule as handle)
  :
    define buffer buf_cashbook for ub.cashbook .
    define buffer buf_cashbookrule for ub.cashbookrule .
    if valid-object(mQuery) then delete object mQuery.
    if valid-object(mQueryRule) then delete object mQueryRule.
    empty temp-table tt-cashbook .
    empty temp-table tt-cashbookrule .
    
    case v-firm :
      when {&all}
      then do :
        case v-stat :
          when {&all}
          then do :
            for each buf_cashbook no-lock :
              create tt-cashbook .
              buffer-copy buf_cashbook except buf_cashbook.RulePril buf_cashbook.RuleOsn to tt-cashbook
              assign
                tt-cashbook.stat = if tt-cashbook.status_ = 0 then "Текущий" else if tt-cashbook.status_ = 1 then "Удаленный" else "?"
              .
              tt-cashbook.RulePril = getRulePrilName(integer(buf_cashbook.RulePril)) .
              tt-cashbook.RuleOsn = getRuleOsnName(buf_cashbook.RulePril) .
              for each buf_cashbookrule no-lock where buf_cashbookrule.cashbookId = buf_cashbook.id 
                                                  break by buf_cashbookrule.obj-type desc
                                                        by buf_cashbookrule.obj-code:
                if first-of(buf_cashbookrule.obj-type)
                or first-of(buf_cashbookrule.obj-code)
                then do :
                  create tt-cashbookrule.
                  buffer-copy buf_cashbookrule to tt-cashbookrule .
                  tt-cashbookrule.obj = tt-cashbookrule.obj-type + string(tt-cashbookrule.obj-code) .
                end. 
                fill_cashbookrule (buffer buf_cashbookrule) .                                    
              end.
            end.
          end.
          when {&current-status}
          then do :
            for each buf_cashbook no-lock where buf_cashbook.status_ = 0:
              create tt-cashbook .
              buffer-copy buf_cashbook except buf_cashbook.RulePril buf_cashbook.RuleOsn to tt-cashbook
              assign
                tt-cashbook.stat = if tt-cashbook.status_ = 0 then "Текущий" else if tt-cashbook.status_ = 1 then "Удаленный" else "?"
              .
              tt-cashbook.RulePril = getRulePrilName(integer(buf_cashbook.RulePril)) .
              tt-cashbook.RuleOsn = getRuleOsnName(buf_cashbook.RuleOsn) .
              for each buf_cashbookrule no-lock where buf_cashbookrule.cashbookId = buf_cashbook.id 
                                                  and buf_cashbookrule.status_ = 0
                                                  break by buf_cashbookrule.obj-type desc
                                                        by buf_cashbookrule.obj-code:
                if first-of(buf_cashbookrule.obj-type)
                or first-of(buf_cashbookrule.obj-code)
                then do :
                  create tt-cashbookrule.
                  buffer-copy buf_cashbookrule to tt-cashbookrule .
                  tt-cashbookrule.obj = tt-cashbookrule.obj-type + string(tt-cashbookrule.obj-code) .
                end. 
                fill_cashbookrule (buffer buf_cashbookrule) .                                     
              end.
            end.
          end.
          when {&deleted-status}
          then do :
            for each buf_cashbook no-lock where buf_cashbook.status_ = 1:
              create tt-cashbook .
              buffer-copy buf_cashbook except buf_cashbook.RulePril buf_cashbook.RuleOsn to tt-cashbook
              assign
                tt-cashbook.stat = if tt-cashbook.status_ = 0 then "Текущий" else if tt-cashbook.status_ = 1 then "Удаленный" else "?"
              .
              tt-cashbook.RulePril = getRulePrilName(integer(buf_cashbook.RulePril)) .
              tt-cashbook.RuleOsn = getRuleOsnName(buf_cashbook.RuleOsn) .
              
              for each buf_cashbookrule no-lock where buf_cashbookrule.cashbookId = buf_cashbook.id 
                                                  and buf_cashbookrule.status_ = 1
                                                  break by buf_cashbookrule.obj-type desc
                                                        by buf_cashbookrule.obj-code:
                if first-of(buf_cashbookrule.obj-type)
                or first-of(buf_cashbookrule.obj-code)
                then do :
                  create tt-cashbookrule.
                  buffer-copy buf_cashbookrule to tt-cashbookrule .
                  tt-cashbookrule.obj = tt-cashbookrule.obj-type + string(tt-cashbookrule.obj-code) .
                end. 
                fill_cashbookrule (buffer buf_cashbookrule) .                                     
              end.
            end.
          end.
        end case .
      end.
      otherwise
      do :
        case v-stat :
          when {&all}
          then do :
            for each buf_cashbook no-lock :
              create tt-cashbook .
              buffer-copy buf_cashbook to tt-cashbook
              assign
                tt-cashbook.stat = if tt-cashbook.status_ = 0 then "Текущий" else if tt-cashbook.status_ = 1 then "Удаленный" else "?"
              .
              tt-cashbook.RulePril = getRulePrilName(integer(buf_cashbook.RulePril)) .
              tt-cashbook.RuleOsn = getRuleOsnName(buf_cashbook.RuleOsn) .
              
              for each buf_cashbookrule no-lock where buf_cashbookrule.cashbookId = buf_cashbook.id 
                                                  and buf_cashbookrule.host-code = v-firm 
                                                  break by buf_cashbookrule.obj-type desc
                                                        by buf_cashbookrule.obj-code:
                if first-of(buf_cashbookrule.obj-type)
                or first-of(buf_cashbookrule.obj-code)
                then do :
                  create tt-cashbookrule.
                  buffer-copy buf_cashbookrule to tt-cashbookrule .
                  tt-cashbookrule.obj = tt-cashbookrule.obj-type + string(tt-cashbookrule.obj-code) .
                  tt-cashbook.RulePril = getRulePrilName(integer(buf_cashbook.RulePril)) .
                  tt-cashbook.RuleOsn = getRuleOsnName(buf_cashbook.RuleOsn) .
                end. 
                fill_cashbookrule (buffer buf_cashbookrule) .                                    
              end.
            end.
          end.
          when {&current-status}
          then do :
            for each buf_cashbook no-lock where buf_cashbook.status_ = 0:
              create tt-cashbook .
              buffer-copy buf_cashbook to tt-cashbook
              assign
                tt-cashbook.stat = if tt-cashbook.status_ = 0 then "Текущий" else if tt-cashbook.status_ = 1 then "Удаленный" else "?"
              .
              tt-cashbook.RulePril = getRulePrilName(integer(buf_cashbook.RulePril)) .
              tt-cashbook.RuleOsn = getRuleOsnName(buf_cashbook.RuleOsn) .
              
              for each buf_cashbookrule no-lock where buf_cashbookrule.cashbookId = buf_cashbook.id 
                                                  and buf_cashbookrule.host-code = v-firm
                                                  and buf_cashbookrule.status_ = 0
                                                  break by buf_cashbookrule.obj-type desc
                                                        by buf_cashbookrule.obj-code:
                if first-of(buf_cashbookrule.obj-type)
                or first-of(buf_cashbookrule.obj-code)
                then do :
                  create tt-cashbookrule.
                  buffer-copy buf_cashbookrule to tt-cashbookrule .
                  tt-cashbookrule.obj = tt-cashbookrule.obj-type + string(tt-cashbookrule.obj-code) .
                end. 
                fill_cashbookrule (buffer buf_cashbookrule) .                                     
              end.
            end.
          end.
          when {&deleted-status}
          then do :
            for each buf_cashbook no-lock where buf_cashbook.status_ = 1:
              create tt-cashbook .
              buffer-copy buf_cashbook to tt-cashbook
              assign
                tt-cashbook.stat = if tt-cashbook.status_ = 0 then "Текущий" else if tt-cashbook.status_ = 1 then "Удаленный" else "?"
              .
              tt-cashbook.RulePril = getRulePrilName(integer(buf_cashbook.RulePril)) .
              tt-cashbook.RuleOsn = getRuleOsnName(buf_cashbook.RuleOsn) .
              
              for each buf_cashbookrule no-lock where buf_cashbookrule.cashbookId = buf_cashbook.id 
                                                  and buf_cashbookrule.host-code = v-firm 
                                                  and buf_cashbookrule.status_ = 1
                                                  break by buf_cashbookrule.obj-type desc
                                                        by buf_cashbookrule.obj-code:
                if first-of(buf_cashbookrule.obj-type)
                or first-of(buf_cashbookrule.obj-code)
                then do :
                  create tt-cashbookrule.
                  buffer-copy buf_cashbookrule to tt-cashbookrule .
                  tt-cashbookrule.obj = tt-cashbookrule.obj-type + string(tt-cashbookrule.obj-code) .
                end. 
                fill_cashbookrule (buffer buf_cashbookrule) .                                   
              end.
            end.
          end.
        end case .
      end.
    end case.
    
    if not valid-object(mQuery)
    then do:
       create query mQuery.
       mQuery:set-buffers(buffer tt-cashbook:HANDLE).
       mQuery:query-prepare("FOR EACH tt-cashbook").
    end.
    mQuery:query-open ().
    oQuery = mQuery.
    if not valid-object(mQueryRule)
    then do:
       create query mQueryRule.
       mQueryRule:set-buffers(buffer tt-cashbookrule:HANDLE).
       mQueryRule:query-prepare("FOR EACH tt-cashbookrule").
    end.
    mQueryRule:query-open ().
    oQueryRule = mQueryRule.
    return oQuery.
  end method.
  
  method public void getCashBookRule (input pCashBookId as int64, input pObjType as character, input pObjCode as integer, output dataset ds-cashbookrule) :
    define buffer buf_cashbookrule for ub.cashbookrule .
    for each buf_cashbookrule no-lock where buf_cashbookrule.cashbookId = pCashBookId 
                                        and buf_cashbookrule.obj-code = pObjCode
                                        and buf_cashbookrule.obj-type = pObjType
                                        break by buf_cashbookrule.obj-type
                                              by buf_cashbookrule.obj-code:
      if first-of(buf_cashbookrule.obj-type)
      or first-of(buf_cashbookrule.obj-code)
      then do :
        create tt-cashbookrule.
        buffer-copy buf_cashbookrule to tt-cashbookrule .
        tt-cashbookrule.obj = tt-cashbookrule.obj-type + string(tt-cashbookrule.obj-code) .
      end. 
      fill_cashbookrule (buffer buf_cashbookrule) .                                   
    end.
    
  end method.
  
  method public character getSinglRule (input pCashBookId as int64, input pObjType as character, input pObjCode as integer, input pRuleCode as integer) :
    find first ub.CashBookRule no-lock where ub.CashBookRule.CashBookID = pCashBookId
                                         and ub.CashBookRule.Obj-type   = pObjType
                                         and ub.CashBookRule.Obj-code   = pObjCode
                                         and ub.CashBookRule.Code       = pRuleCode
                                         no-error.
    if not available ub.CashBookRule
    then do :
      find first ub.clients no-lock where ub.clients.obj-type = pObjType
                                      and ub.clients.obj-code = pObjCode
                                      no-error.
      if not available ub.clients   
      then do :
        return ? .
      end.  
      find first ub.CashBookRule no-lock where ub.CashBookRule.CashBookID = pCashBookId
                                           and ub.CashBookRule.Obj-type   = {&cmp}
                                           and ub.CashBookRule.Obj-code   = ub.clients.host-code
                                           and ub.CashBookRule.Code       = pRuleCode
                                           no-error.  
      if not available ub.CashBookRule
      then do :
        return ? .
      end.                                                             
    end.
    
    return ub.CashBookRule.RuleValue .
                                        
  end.
   
  method private void fill_cashbookrule (buffer buf_cashbookrule for ub.cashbookrule) :
    define variable v-cashbookrule-key-rec as character no-undo.
    case buf_cashbookrule.code :
      when 1 /*маска ПКО*/
      then do :
        tt-cashbookrule.PkoMask = buf_cashbookrule.RuleValue .
      end.
      when 2 /*маска РКО*/
      then do :
        tt-cashbookrule.RkoMask = buf_cashbookrule.RuleValue .
      end.
      when 3 /*маска ПКО*/
      then do :
        objKeyRec:GenKeyRec ( input {&table_cashbookrule}
                                            ,input buffer buf_cashbookrule:handle
                                            ,output v-cashbookrule-key-rec).
        find first clients where clients.obj-type eq tt-cashbookrule.obj-type
                             and clients.obj-code eq tt-cashbookrule.obj-code
                             no-lock no-error.
            if     available clients
               and clients.db-num ne ?
            then
        tt-cashbookrule.currPko = string(
                                         objcount:getCountValue(clients.db-num,
                                                                "cashbookrule",
                                                                v-cashbookrule-key-rec,
                                                                "currPKO")
                                         ). 
      end.
      when 4 /*маска РКО*/
      then do :
         objKeyRec:GenKeyRec ( input {&table_cashbookrule}
                                            ,input buffer buf_cashbookrule:handle
                                            ,output v-cashbookrule-key-rec).
         find first clients where clients.obj-type eq tt-cashbookrule.obj-type
                             and clients.obj-code eq tt-cashbookrule.obj-code
                             no-lock no-error.
            if     available clients
               and clients.db-num ne ? 
            then
         tt-cashbookrule.currRko = string(objcount:getCountValue(clients.db-num,
                                                                 "cashbookrule",
                                                                 v-cashbookrule-key-rec,
                                                                 "currRko")) .
        
      end.
      when 5 /*Должность руководителя*/
      then do :
        tt-cashbookrule.ManagerPosition = getMgrPositionName(integer(buf_cashbookrule.RuleValue)) .
      end.
      when 6 /*Фио руководителя*/
      then do :
        tt-cashbookrule.ManagerFIO = getMgrFioName(integer(buf_cashbookrule.RuleValue)) .
      end.
      when 7 /*Фио бухгалтера*/
      then do :
        tt-cashbookrule.BuhFIO = getBuhFioName(integer (buf_cashbookrule.RuleValue)) .
      end.
      when 8 /*Структурное подразделение*/
      then do :
        tt-cashbookrule.Struct = getStructName(integer(buf_cashbookrule.RuleValue)) .
      end.
      when 9 /*Учёт ведётся*/
      then do :
        tt-cashbookrule.uchet = getUchetName(integer(buf_cashbookrule.RuleValue)) .
      end.
      when 10 /*Наименование структурного подразделения по умолчанию*/
      then do :
        tt-cashbookrule.DptName = buf_cashbookrule.RuleValue .
      end.
      when 11 /*Тип структурного подразделения по умолчанию*/
      then do :
        tt-cashbookrule.DptType = buf_cashbookrule.RuleValue .
      end.
      when 12 /*Код структурного подразделения по умолчанию*/
      then do :
        tt-cashbookrule.DptCode = integer(buf_cashbookrule.RuleValue) no-error .
      end.
    end case.
  end method.

end class.