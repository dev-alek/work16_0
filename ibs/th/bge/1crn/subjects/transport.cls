
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных transport в 1С

Автор: Елена Шкляр
Дата создания: 26/09/17
Author: Shklyar Elena
Creation date: 26/09/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.subjects from propath.
using ibs.th.bge.1crn.subjects.transport_section from propath.
using ibs.th.bge.1crn.subjects.transport_section_ct-lvl from propath.
using ibs.th.bge.1crn.subjects.transport from propath.

class ibs.th.bge.1crn.subjects.transport inherits ibs.th.bge.1crn.subjects.asubject:

  define property code_       as character    no-undo get. 
    private set.
  define property del-l       as integer      no-undo get. 
    private set.
  define property del-f       as integer      no-undo get. 
    private set.
  define property mark        as character    no-undo get. 
    private set.
  define property reg-num     as character    no-undo get. 
    private set.
  define property tr-owner    as character    no-undo get. 
    private set.
  define property is-ac       as integer      no-undo get. 
    private set.
  define property name_       as character    no-undo get. 
    private set.
  define property sections    as subjects     no-undo get. 
    private set.
  define property calibration-table    as subjects     no-undo get. 
    private set.
  define override property InitTag as character no-undo init "transport"
    get. 
    
  constructor public transport ():
    InitListTag = "sections,calibration-table".
  end constructor.
  
     
  method override protected void SetPropProtected (inTag as char, inValue as char):
    case inTag:
      when "code" then 
        do:
          assign 
            code_ = inValue .
        end.
      when "del-l" then 
        do:
          assign 
            del-l = integer(inValue) .
        end.
      when "del-f" then 
        do:
          assign 
            del-f = integer(inValue) .
        end.
      when "mark" then 
        do:
          assign 
            mark = inValue.
        end.
      when "reg-num" then 
        do:
          assign 
            reg-num = inValue.
        end.
      when "tr-owner" then 
        do:
          assign 
            tr-owner = inValue.
        end.
      when "is-ac" then 
        do:
          assign 
            is-ac = integer(inValue) .
        end.
      when "name" then 
        do:
          assign 
            name_ = inValue.
        end.
    end case.
  end.

  method override protected void SetPropProtected(SubsObj as subjects):

    case SubsObj:InitTag:   
      when "sections" then
        do:
          sections = SubsObj.            
        end.
      when "calibration-table" then
        do:
          calibration-table = SubsObj.            
        end.
    end case.
  end.
  
  method override protected void CheckData ():

    def var v-str as char no-undo.
    
    assign
      v-str = "code" 
      when code_ = ?
      v-str = v-str + ",mark" 
      when mark = ?
      v-str = v-str + ",reg-num" 
      when reg-num = ?
      v-str = v-str + ",tr-owner" 
      when tr-owner = ?
      v-str = v-str + ",is-ac" 
      when is-ac = ?
      v-str = v-str + ",name" 
      when name_ = ?
      .
    v-str = trim (v-str, ",").
    if v-str > ''
      then 
      undo, throw new Progress.Lang.AppError( substitute ("Теги &1 не могут иметь неопределное значение", v-str)).

  end.
  
  method override protected void ClearSub():
    assign 
      code_    = ?
      del-l    = ?
      del-f    = ?
      mark     = ?
      reg-num  = ?
      tr-owner = ?
      is-ac    = ?
      name_    = ?
      .
      delete object sections no-error .
      delete object calibration-table no-error . 
  end.

end class.