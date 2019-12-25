 
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
  
  constructor public cashbookstorage (  ):
    super ().
      
  end constructor.

  destructor public cashbookstorage ( ):

  end destructor.
  
  method private void checkCashBook (buffer tt-cashbook for tt-cashbook) :
    Msg = "" .
    if trim(tt-cashbook.CashBookName) = ""
    then do :
      Msg = "Наименование типа кассовой книги не может быть пустым!" .
      return .
    end.
    if trim(tt-cashbook.Credit) = ""
    then do :
      Msg = "Поле Кредит не может быть пустым!" .
      return .
    end.
    if trim(tt-cashbook.Debit) = ""
    then do :
      Msg = "Поле Дебет не может быть пустым!" .
      return .
    end.
    if trim(tt-cashbook.RuleOsn) = ""
    then do :
      Msg = "Правило заполнения графы Основание не может быть пустым!" .
      return .
    end.
    if trim(tt-cashbook.RulePril) = ""
    then do :
      Msg = "Правило заполнения графы Приложение не может быть пустым!" .
      return .
    end.
    
    find first ub.cashbook no-lock where ub.CashBook.ext-code = tt-cashbook.ext-code and ub.CashBook.id <> tt-cashbook.id no-error.
    if available ub.cashbook
    then do :
      Msg = "Уже есть тип кассовой книги с кодом " + tt-cashbook.ext-code .
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
    
    for each ub.cashbookrule no-lock where ub.CashBookRule.CashBookID = tt-cashbookrule.CashBookID
                                       and ub.CashBookRule.Obj-type   = tt-cashbookrule.obj-type
                                       and ub.CashBookRule.Obj-code   = tt-cashbookrule.obj-code
                                       and ub.CashBookRule.Code       = 1
                                       and ub.CashBookRule.id        <> tt-cashbookrule.id :
      Msg = "Уже есть настройки для этого типа кассовой книги по объекту " + tt-cashbookrule.obj .  
      return .                               
    end.                                  
    
    return.
  end method .
  
  method public void insertDB (buffer tt-cashbook for tt-cashbook, output p-id as int64) :
    
      checkCashBook(buffer tt-cashbook) .
      if Msg <> ""
      then return .
      
      create ub.cashbook .
      buffer-copy tt-cashbook to ub.CashBook
      assign
        ub.CashBook.id = next-value(s-cashbook-id)
        ub.CashBook.Status_ = 0
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
        ub.cashbookrule.id          = next-value(s-cashbookrule-id)
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
        ub.cashbookrule.id          = next-value(s-cashbookrule-id)
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
          ub.cashbookrule.id          = next-value(s-cashbookrule-id)
          ub.cashbookrule.CashBookID  = tt-cashbookrule.CashBookID
          ub.cashbookrule.Obj-code    = tt-cashbookrule.Obj-code
          ub.cashbookrule.Obj-type    = tt-cashbookrule.obj-type
          ub.cashbookrule.host-code   = tt-cashbookrule.host-code 
          ub.cashbookrule.Status_     = 0
          ub.cashbookrule.Code        = 3 /* Текущий ПКО */
          ub.cashbookrule.RuleValue   = tt-cashbookrule.currPko
        .
        
        create ub.cashbookrule .
        assign
          ub.cashbookrule.id          = next-value(s-cashbookrule-id)
          ub.cashbookrule.CashBookID  = tt-cashbookrule.CashBookID
          ub.cashbookrule.Obj-code    = tt-cashbookrule.Obj-code
          ub.cashbookrule.Obj-type    = tt-cashbookrule.obj-type
          ub.cashbookrule.host-code   = tt-cashbookrule.host-code 
          ub.cashbookrule.Status_     = 0
          ub.cashbookrule.Code        = 4 /* Текущий РКО */
          ub.cashbookrule.RuleValue   = tt-cashbookrule.currRko
        .
      end.  
      
      create ub.cashbookrule .
      assign
        ub.cashbookrule.id          = next-value(s-cashbookrule-id)
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
        ub.cashbookrule.id          = next-value(s-cashbookrule-id)
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
        ub.cashbookrule.id          = next-value(s-cashbookrule-id)
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
        ub.cashbookrule.id          = next-value(s-cashbookrule-id)
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
        ub.cashbookrule.id          = next-value(s-cashbookrule-id)
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
        ub.cashbookrule.id          = next-value(s-cashbookrule-id)
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
        ub.cashbookrule.id          = next-value(s-cashbookrule-id)
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
        ub.cashbookrule.id          = next-value(s-cashbookrule-id)
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
      buffer-copy tt-cashbook to ub.CashBook .
      
  end method .
  
  method public void updateDBobj (input dataset for ds-cashbookrule) :
    for each tt-cashbookrule :
      checkCashBookRule(buffer tt-cashbookrule) .
      if Msg <> ""
      then return .
      
      find first ub.cashbook no-lock where ub.cashbook.id = tt-cashbookrule.CashBookID .
      find first ub.CashBookRule exclusive-lock where ub.CashBookRule.CashBookID  = tt-cashbookrule.CashBookID 
                                                and ub.CashBookRule.host-code   = tt-cashbookrule.host-code
                                                and ub.CashBookRule.Obj-type    = tt-cashbookrule.obj-type
                                                and ub.CashBookRule.Obj-code    = tt-cashbookrule.obj-code
                                                and ub.CashBookRule.Status_     = tt-cashbookrule.Status_
                                                and ub.CashBookRule.Code        = 1 
                                                .
      ub.CashBookRule.RuleValue = tt-cashbookrule.PkoMask .
      
      find first ub.CashBookRule exclusive-lock where ub.CashBookRule.CashBookID  = tt-cashbookrule.CashBookID 
                                                and ub.CashBookRule.host-code   = tt-cashbookrule.host-code
                                                and ub.CashBookRule.Obj-type    = tt-cashbookrule.obj-type
                                                and ub.CashBookRule.Obj-code    = tt-cashbookrule.obj-code
                                                and ub.CashBookRule.Status_     = tt-cashbookrule.Status_
                                                and ub.CashBookRule.Code        = 2 
                                                .
      ub.CashBookRule.RuleValue = tt-cashbookrule.RkoMask .
      
      if tt-cashbookrule.Obj-type <> {&cmp}
      then do :
        find first ub.CashBookRule exclusive-lock where ub.CashBookRule.CashBookID  = tt-cashbookrule.CashBookID 
                                                  and ub.CashBookRule.host-code   = tt-cashbookrule.host-code
                                                  and ub.CashBookRule.Obj-type    = tt-cashbookrule.obj-type
                                                  and ub.CashBookRule.Obj-code    = tt-cashbookrule.obj-code
                                                  and ub.CashBookRule.Status_     = tt-cashbookrule.Status_
                                                  and ub.CashBookRule.Code        = 3 
                                                  .
        ub.CashBookRule.RuleValue = tt-cashbookrule.currPko .
        
        find first ub.CashBookRule exclusive-lock where ub.CashBookRule.CashBookID  = tt-cashbookrule.CashBookID 
                                                  and ub.CashBookRule.host-code   = tt-cashbookrule.host-code
                                                  and ub.CashBookRule.Obj-type    = tt-cashbookrule.obj-type
                                                  and ub.CashBookRule.Obj-code    = tt-cashbookrule.obj-code
                                                  and ub.CashBookRule.Status_     = tt-cashbookrule.Status_
                                                  and ub.CashBookRule.Code        = 4 
                                                  .
        ub.CashBookRule.RuleValue = tt-cashbookrule.currRko .
      end.
      
      find first ub.CashBookRule exclusive-lock where ub.CashBookRule.CashBookID  = tt-cashbookrule.CashBookID 
                                                and ub.CashBookRule.host-code   = tt-cashbookrule.host-code
                                                and ub.CashBookRule.Obj-type    = tt-cashbookrule.obj-type
                                                and ub.CashBookRule.Obj-code    = tt-cashbookrule.obj-code
                                                and ub.CashBookRule.Status_     = tt-cashbookrule.Status_
                                                and ub.CashBookRule.Code        = 5 
                                                .
      ub.cashbookrule.RuleValue = tt-cashbookrule.ManagerPosition .
      
      find first ub.CashBookRule exclusive-lock where ub.CashBookRule.CashBookID  = tt-cashbookrule.CashBookID 
                                                and ub.CashBookRule.host-code   = tt-cashbookrule.host-code
                                                and ub.CashBookRule.Obj-type    = tt-cashbookrule.obj-type
                                                and ub.CashBookRule.Obj-code    = tt-cashbookrule.obj-code
                                                and ub.CashBookRule.Status_     = tt-cashbookrule.Status_
                                                and ub.CashBookRule.Code        = 6 
                                                .
      ub.cashbookrule.RuleValue = tt-cashbookrule.ManagerFIO .
      
      find first ub.CashBookRule exclusive-lock where ub.CashBookRule.CashBookID  = tt-cashbookrule.CashBookID 
                                                and ub.CashBookRule.host-code   = tt-cashbookrule.host-code
                                                and ub.CashBookRule.Obj-type    = tt-cashbookrule.obj-type
                                                and ub.CashBookRule.Obj-code    = tt-cashbookrule.obj-code
                                                and ub.CashBookRule.Status_     = tt-cashbookrule.Status_
                                                and ub.CashBookRule.Code        = 7 
                                                .
      ub.cashbookrule.RuleValue = tt-cashbookrule.BuhFIO .
      
      find first ub.CashBookRule exclusive-lock where ub.CashBookRule.CashBookID  = tt-cashbookrule.CashBookID 
                                                and ub.CashBookRule.host-code   = tt-cashbookrule.host-code
                                                and ub.CashBookRule.Obj-type    = tt-cashbookrule.obj-type
                                                and ub.CashBookRule.Obj-code    = tt-cashbookrule.obj-code
                                                and ub.CashBookRule.Status_     = tt-cashbookrule.Status_
                                                and ub.CashBookRule.Code        = 8 
                                                .
      ub.cashbookrule.RuleValue = tt-cashbookrule.Struct .
      
      find first ub.CashBookRule exclusive-lock where ub.CashBookRule.CashBookID  = tt-cashbookrule.CashBookID 
                                                and ub.CashBookRule.host-code   = tt-cashbookrule.host-code
                                                and ub.CashBookRule.Obj-type    = tt-cashbookrule.obj-type
                                                and ub.CashBookRule.Obj-code    = tt-cashbookrule.obj-code
                                                and ub.CashBookRule.Status_     = tt-cashbookrule.Status_
                                                and ub.CashBookRule.Code        = 9 
                                                .
      ub.cashbookrule.RuleValue = tt-cashbookrule.uchet .
      
      find first ub.CashBookRule exclusive-lock where ub.CashBookRule.CashBookID  = tt-cashbookrule.CashBookID 
                                                and ub.CashBookRule.host-code   = tt-cashbookrule.host-code
                                                and ub.CashBookRule.Obj-type    = tt-cashbookrule.obj-type
                                                and ub.CashBookRule.Obj-code    = tt-cashbookrule.obj-code
                                                and ub.CashBookRule.Status_     = tt-cashbookrule.Status_
                                                and ub.CashBookRule.Code        = 10 
                                                .
      ub.CashBookRule.RuleValue = tt-cashbookrule.DptName .
      
      find first ub.CashBookRule exclusive-lock where ub.CashBookRule.CashBookID  = tt-cashbookrule.CashBookID 
                                                and ub.CashBookRule.host-code   = tt-cashbookrule.host-code
                                                and ub.CashBookRule.Obj-type    = tt-cashbookrule.obj-type
                                                and ub.CashBookRule.Obj-code    = tt-cashbookrule.obj-code
                                                and ub.CashBookRule.Status_     = tt-cashbookrule.Status_
                                                and ub.CashBookRule.Code        = 11 
                                                .
      ub.CashBookRule.RuleValue = tt-cashbookrule.DptType .
      
      find first ub.CashBookRule exclusive-lock where ub.CashBookRule.CashBookID  = tt-cashbookrule.CashBookID 
                                                and ub.CashBookRule.host-code   = tt-cashbookrule.host-code
                                                and ub.CashBookRule.Obj-type    = tt-cashbookrule.obj-type
                                                and ub.CashBookRule.Obj-code    = tt-cashbookrule.obj-code
                                                and ub.CashBookRule.Status_     = tt-cashbookrule.Status_
                                                and ub.CashBookRule.Code        = 12 
                                                .
      ub.CashBookRule.RuleValue = string(tt-cashbookrule.DptCode) .
      
    end.                                        
  end method .
  
  method public void deleteDB (input dataset for ds-cashbook) :
    for each tt-cashbook :
      find first ub.cashbook exclusive-lock where ub.cashbook.id = tt-cashbook.id .
      if ub.CashBook.Status_ = 0
      then do :
        ub.CashBook.Status_ = 1.
        for each ub.CashBookRule exclusive-lock where ub.CashBookRule.CashBookID = ub.cashbook.id :
          ub.CashBookRule.Status_ = ub.CashBook.Status_ .
        end.
      end.  
      else if ub.CashBook.Status_ = 1
      then do :
        ub.CashBook.Status_ = 0.
        for each ub.CashBookRule exclusive-lock where ub.CashBookRule.CashBookID = ub.cashbook.id :
          ub.CashBookRule.Status_ = ub.CashBook.Status_ .
        end.
      end. 
    end. 
  end method .
  
  method public void deleteDB (input id as int64) :
    
    find first ub.cashbook exclusive-lock where ub.cashbook.id = id .
    if ub.CashBook.Status_ = 0
    then do :
      ub.CashBook.Status_ = 1.
      for each ub.CashBookRule exclusive-lock where ub.CashBookRule.CashBookID = ub.cashbook.id :
        ub.CashBookRule.Status_ = ub.CashBook.Status_ .
      end.
    end.  
    else if ub.CashBook.Status_ = 1
    then do :
      ub.CashBook.Status_ = 0.
      for each ub.CashBookRule exclusive-lock where ub.CashBookRule.CashBookID = ub.cashbook.id :
        ub.CashBookRule.Status_ = ub.CashBook.Status_ .
      end.
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
    define buffer buf_cashbookrule for ub.cashbookrule .
    for each buf_cashbook no-lock where buf_cashbook.ext-code = pExtCode :
      create tt-cashbook .
      buffer-copy buf_cashbook to tt-cashbook
      assign
        tt-cashbook.stat = if tt-cashbook.status_ = 0 then "Текущий" else if tt-cashbook.status_ = 1 then "Удаленный" else "?"
      .
    end.
  end.
  
  method public handle getquery
  ( input v-stat as character,
    input v-firm as character,
    output mQuery as handle,
    output mQueryRule as handle)
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
              buffer-copy buf_cashbook to tt-cashbook
              assign
                tt-cashbook.stat = if tt-cashbook.status_ = 0 then "Текущий" else if tt-cashbook.status_ = 1 then "Удаленный" else "?"
              .
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
              buffer-copy buf_cashbook to tt-cashbook
              assign
                tt-cashbook.stat = if tt-cashbook.status_ = 0 then "Текущий" else if tt-cashbook.status_ = 1 then "Удаленный" else "?"
              .
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
              buffer-copy buf_cashbook to tt-cashbook
              assign
                tt-cashbook.stat = if tt-cashbook.status_ = 0 then "Текущий" else if tt-cashbook.status_ = 1 then "Удаленный" else "?"
              .
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
    
    create query mQuery.
    mQuery:set-buffers(buffer tt-cashbook:HANDLE).
    mQuery:query-prepare("FOR EACH tt-cashbook").
    mQuery:query-open ().
    
    create query mQueryRule.
    mQueryRule:set-buffers(buffer tt-cashbookrule:HANDLE).
    mQueryRule:query-prepare("FOR EACH tt-cashbookrule").
    mQueryRule:query-open ().
    
    return mQuery.
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
        tt-cashbookrule.currPko = buf_cashbookrule.RuleValue .
      end.
      when 4 /*маска РКО*/
      then do :
        tt-cashbookrule.currRko = buf_cashbookrule.RuleValue .
      end.
      when 5 /*Должность руководителя*/
      then do :
        tt-cashbookrule.ManagerPosition = buf_cashbookrule.RuleValue .
      end.
      when 6 /*Фио руководителя*/
      then do :
        tt-cashbookrule.ManagerFIO = buf_cashbookrule.RuleValue .
      end.
      when 7 /*Фио бухгалтера*/
      then do :
        tt-cashbookrule.BuhFIO = buf_cashbookrule.RuleValue .
      end.
      when 8 /*Структурное подразделение*/
      then do :
        tt-cashbookrule.Struct = buf_cashbookrule.RuleValue .
      end.
      when 9 /*Учёт ведётся*/
      then do :
        tt-cashbookrule.uchet = buf_cashbookrule.RuleValue .
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