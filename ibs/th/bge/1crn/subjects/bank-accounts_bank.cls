/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных bank-accounts в 1С

Автор: Елена Шкляр
Дата создания: 26/09/17
Author: Shklyar Elena
Creation date: 26/09/17

*/

USING Progress.Lang.*.
using ibs.th.bge.1crn.subjects.subjects from propath.
using ibs.th.bge.1crn.subjects.bank-accounts from propath.
using ibs.th.bge.1crn.subjects.bank-accounts_bank from propath.

CLASS ibs.th.bge.1crn.subjects.bank-accounts_bank inherits ibs.th.bge.1crn.subjects.asubject: 
  

  define property bank-name   as character    no-undo get. 
    private set.
  define property bik         as character    no-undo get. 
    private set.
  define property bank-city   as character    no-undo get. 
    private set.
  define property cor-acc     as character    no-undo get. 
    private set.
  define property qr-rule     as integer      no-undo get. 
    private set.
  define property bank-resive-debit as character    no-undo get. 
    private set.    
  define property bank-resive-kredit as character    no-undo get. 
    private set.    
  define override property InitTag as character no-undo init "bank"
    get. 

  method OVERRIDE PROTECTED void SetPropProtected (inTag as char, inValue as char):
    case inTag:
      when "bank-name" then 
        do:
          assign 
            bank-name = inValue .
        end.
      when "bik" then 
        do:
          assign 
            bik = inValue .
        end.
      when "bank-city" then 
        do:
          assign 
            bank-city = inValue .
        end.      
      when "cor-acc" then 
        do:
          assign 
            cor-acc = inValue .
        end.
      when "qr-rule" then 
        do:
          assign 
            qr-rule = integer(inValue) .
        end.              
      when "bank-resive-debit" then 
        do:
          assign 
            bank-resive-debit = inValue .
        end.      
      when "bank-resive-kredit" then 
        do:
          assign 
            bank-resive-kredit = inValue .
        end.      
    end case.
  end.

  method override protected void CheckData ():

    def var v-str as char no-undo.
    
    assign
      v-str = v-str + ",bank-name" 
      when bank-name = ?
      v-str = v-str + ",bik" 
      when bik = ?
      v-str = v-str + ",bank-city" 
      when bank-city = ?
      v-str = v-str + ",cor-acc" 
      when cor-acc = ?
      v-str = v-str + ",qr-rule" 
      when qr-rule = ?
      v-str = v-str + ",bank-resive-debit" 
      when bank-resive-debit = ?
      v-str = v-str + ",bank-resive-kredit" 
      when bank-resive-kredit = ?
      .
    v-str = trim (v-str, ",").
    if v-str > ''
      then 
      undo, throw new Progress.Lang.AppError( substitute ("Теги &1 не могут иметь неопределное значение", v-str)).

  end.
  
  method override protected void ClearSub():
    assign 
      bank-name = ?
      cor-acc   = ?
      bank-city = ?
      bik       = ?
      qr-rule   = ?
      bank-resive-debit = ?
      bank-resive-kredit = ?
      .
  end.
  
END CLASS.