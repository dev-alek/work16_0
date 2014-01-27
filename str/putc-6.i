/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

вывод в поток для разных типов касс - пересылка кассиров

Автор: Бахтадзе Наталья Викторовна
Дата создания: 11/28/05
Author: Bakhtadze Natalya
Creation date: 11/28/05

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

PROCEDURE putc-6.
def input param pos-type as char no-undo.
def var ii  as  int     no-undo.
&scop validate-cash-cash  if cash-cash.cash-code > ~{&max-cash-code~} then do:                      ~
    run write-log-and-file in p-log-handle (                                         ~
          input 1                                                                    ~
        , input log-file-name                                                        ~
        , input 1                                                                    ~
        , input substitute("!!!Ошибка: код кассира больше &1: кассир &2 код &3"      ~
                           , ~{&max-cash-code~}                                      ~
                           , cash-cash.cash-code                                     ~
                           , cash-cash.cash-name)                                    ~
                                            ).                                       ~
    assign                                                                           ~
    v-view-log = yes                                                                 ~
    .                                                                                ~
    NEXT.                                                                            ~
  end

CASE pos-type:
  when {&cd-type-ibm} then do:
    FOR EACH cash-cash NO-LOCK use-index icash:
&scop max-cash-code 999
      {&validate-cash-cash}.
      PUT stream IBMstream unformatted
      '6 "'
      if cash-cash.stts = 1 then string( "D", "x(1)" ) else string( action, "x(1)" )
      '" '
      cash-cash.cash-code format ">>9"
      ' "'
      cash-cash.cash-name format "X(19)"
      ' "'
      " "
      string( cash-cash.psswd, "9999" )
      " "
      OS2-time
      SKIP.
    END.
  end.
  when {&cd-type-ibm-xml} then do:
    FOR EACH cash-cash NO-LOCK use-index icash:
&scop max-cash-code 999
      {&validate-cash-cash}.
      run bgelib-tag-open in this-procedure ( input 2, input "Cashier", input substitute("ctrl='&1' tms='&2' code='&3'"
                                                                                          , (if action = "U":U
                                                                                             then "ADD":U
                                                                                             else "DEL":U)
                                                                                          , OS2-time
                                                                                          , cash-cash.cash-code)).
      run bgelib-tag-put in this-procedure ( input 3, input "CashierName"         , input cash-cash.cash-name, input 1 ).
      run bgelib-tag-put in this-procedure ( input 3, input "CashierParol"        , input cash-cash.psswd, input 1 ).
      run bgelib-tag-put in this-procedure ( input 3, input "CashierLock"         , input cash-cash.stts, input 1 ).
      run bgelib-tag-close in this-procedure ( input 2, input "Cashier").
    END.
  end.
END CASE .
END PROCEDURE .

/* $Workfile$ e n d */