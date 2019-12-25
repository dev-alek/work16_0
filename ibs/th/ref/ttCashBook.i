
/*------------------------------------------------------------------------
    File        : ttCashBook.i
    Purpose     : 

    Syntax      :

    Description : Определение временных таблиц для Типов кассовых книг

    Author(s)   : SSlivenko
    Created     : Fri Feb 15 14:44:11 AST 2019
    Notes       :
  ----------------------------------------------------------------------*/

define temp-table tt-cashbook like ub.cashbook
  field stat      as character
  field mark      as character
.

define dataset ds-cashbook for tt-cashbook .