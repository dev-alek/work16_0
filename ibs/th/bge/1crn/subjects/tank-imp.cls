
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных tank в 1С

Автор: Елена Шкляр
Дата создания: 26/09/17
Author: Shklyar Elena
Creation date: 26/09/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.subjects from propath.
using ibs.th.bge.1crn.subjects.tank-imp_cal-tbl from propath.
using ibs.th.bge.1crn.subjects.tank-imp from propath.
USING ibs.th.bge.1crn.subjects.tank FROM PROPATH.

class ibs.th.bge.1crn.subjects.tank-imp inherits ibs.th.bge.1crn.subjects.asubject:

  define property tank-code       as character    no-undo get. 
    private set.
  define property gs-code     as character    no-undo get. 
    private set.
  define property cal-tbl    as subjects     no-undo get. 
    private set.
  
  define override property InitTag as character no-undo init "tank"
    get. 
    
  constructor public tank-imp ():
    InitListTag = "cal-tbl".
  end constructor.
  
     
  method override protected void SetPropProtected (inTag as char, inValue as char):
    case inTag:
      when "tank-code" then 
        do:
          assign 
            tank-code = inValue .
        end.
      when "gs-code" then 
        do:
          assign 
            gs-code = inValue.
        end.
    end case.
  end.

  method override protected void SetPropProtected(SubsObj as subjects):

    case SubsObj:InitTag:   
      when "cal-tbl" then
        do:
          cal-tbl = SubsObj.            
        end.
    end case.
  end.
  
  method override protected void CheckData ():

    def var v-str as char no-undo.
    
    assign
      v-str = "tank-code" 
      when tank-code = ?
      v-str = v-str + ",gs-code" 
      when gs-code = ?
      .
      
    v-str = trim (v-str, ",").
    if v-str > ''
      then 
      undo, throw new Progress.Lang.AppError( substitute ("Теги &1 не могут иметь неопределное значение", v-str)).

  end.
  
  method override protected void ClearSub():
    assign 
      tank-code = ?
      gs-code   = ?
      .

    delete object cal-tbl no-error .
 
  end.

end class.