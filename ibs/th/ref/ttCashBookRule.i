
/*------------------------------------------------------------------------
    File        : ttCashBook.i
    Purpose     : 

    Syntax      :

    Description : Определение временных таблиц для Типов кассовых книг

    Author(s)   : SSlivenko
    Created     : Fri Feb 15 14:44:11 AST 2019
    Notes       :
  ----------------------------------------------------------------------*/

define temp-table tt-cashbookrule like ub.cashbookrule
  field RkoMask         as character
  field PkoMask         as character
  field currPko         as character
  field currRko         as character
  field ManagerPosition as character
  field ManagerFIO      as character
  field BuhFIO          as character
  field struct          as character
  field uchet           as character
  field DptName         as character
  field DptType         as character
  field DptCode         as integer
  field obj             as character
  field stat            as character
.

define dataset ds-cashbookrule for tt-cashbookrule .