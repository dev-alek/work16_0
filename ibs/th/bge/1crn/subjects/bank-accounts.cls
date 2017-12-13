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

CLASS ibs.th.bge.1crn.subjects.bank-accounts inherits ibs.th.bge.1crn.subjects.asubject: 
  
  define property r-schet     as character    no-undo get. private set.
  define property del-l       as integer      no-undo get. private set.
  define property del-f       as integer      no-undo get. private set.
  define property cont-code   as character    no-undo get. private set.
  define property bank-name   as character    no-undo get. private set.
  define property bik         as character    no-undo get. private set.
  define property bank-city   as character    no-undo get. private set.
  define property cor-acc     as character    no-undo get. private set.

  define override property InitTag as character no-undo init "bank-account"
    get. 


  method OVERRIDE PROTECTED void SetPropProtected (inTag as char, inValue as char):
    case inTag:
      when "r-schet" then do:
        assign r-schet = inValue .
      end.
      when "del-l" then do:
        assign del-l = integer (inValue).
      end.
      when "del-f" then do:
        assign del-f = integer (inValue).
      end.
      when "cont-code" then do:
        assign cont-code = inValue .
      end.
      when "bank-name" then do:
        assign bank-name = inValue .
      end.
      when "bik" then do:
        assign bik = inValue .
      end.
      when "bank-city" then do:
        assign bank-city = inValue .
      end.      
      when "cor-acc" then do:
        assign cor-acc = inValue .
      end.      
    end case.
  end.

  method override protected void CheckData ():

    def var v-str as char no-undo.
    
    assign
      v-str = "r-schet" when r-schet = ?
      v-str = v-str + ",cont-code" when cont-code = ?
      v-str = v-str + ",bank-name" when bank-name = ?
      v-str = v-str + ",bik" when bik = ?
      v-str = v-str + ",bank-city" when bank-city = ?
      v-str = v-str + ",cor-acc" when cor-acc = ?
    .
    v-str = trim (v-str, ",").
    if v-str > ''
    then 
      undo, throw new Progress.Lang.AppError( substitute ("Теги &1 не могут иметь неопределное значение", v-str)).

  end.
  
  method override protected void ClearSub():
    assign 
      r-schet = ?
      del-l     = ?
      del-f     = ?
      cont-code = ?
      bank-name = ?
      cor-acc   = ?
      bank-city = ?
      bik       = ?
    .
  end.
  
END CLASS.