
/*------------------------------------------------------------------------
    File        : ttCashBook.i
    Purpose     : 

    Syntax      :

    Description : Определение временных таблиц для Типов кассовых книг

    Author(s)   : SSlivenko
    Created     : Fri Feb 15 14:44:11 AST 2019
    Notes       :
  ----------------------------------------------------------------------*/
&global-define cashbookSysField "stat,mark,basic-kb"
define temp-table tt-cashbook like ub.cashbook
  field stat               as character
  field mark               as character
  field basic-kb           as logical
  field CountCollect-type  as character
  field SourceCode         as character
  field BankRecip-host     as integer
  field BankRecip-code     as integer
  field BankRecip-acct     as character 
  field BankDepos-host     as integer
  field BankDepos-code     as integer
  field CountCollect-code  as integer
.

define dataset ds-cashbook for tt-cashbook .

method private character getRuleOsnName (input p-rule-reason as character) :
    /* Правило заполнения графы "Основание"
• 0 - "Выручка от реализации"
• 1 - "Номера Z-отчетов"
• 2 - "Не заполнять"
20/V-2019 не используется
    */
    define variable v-name as character no-undo .
    case p-rule-reason :
      when "0" then v-name = "Выручка от реализации" .
      when "1" then v-name = "Номера Z-отчетов" .
      when "2" then v-name = "Не заполнять" .
        otherwise v-name = p-rule-reason .
    end case .
    return v-name .
  end method . /* end_of getRuleOsnName */

  method private character getRuleOsnID (input p-rule-reason as character) :
    /* Правило заполнения графы "Основание"
20/V-2019 не используется
    */
    define variable v-id as character no-undo .
    case p-rule-reason :
      when "Выручка от реализации" then v-id = "0" .
      when "Номера Z-отчетов" then v-id = "1" .
      when "Не заполнять" then v-id = "2" .
        otherwise v-id = p-rule-reason .
    end case .
    return v-id .
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
  
    method private character getRulePrilID (input p-rule-att as character) :
    /* Правило заполнения графы "Приложение"
• 0 - "Номера Z-отчетов"
• 1 - "Не заполнять"
    */
    define variable v-id as character no-undo .
    case p-rule-att :
      when "Не заполнять" then v-id = "1" .
        otherwise v-id = "0" .
    end case .
    return v-id .
  end method . /* end_of getRulePrilName */