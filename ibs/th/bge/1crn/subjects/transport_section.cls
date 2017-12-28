
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных transport_section в 1С

Автор: Елена Шкляр
Дата создания: 26/09/17
Author: Shklyar Elena
Creation date: 26/09/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.subjects from propath.
using ibs.th.bge.1crn.subjects.transport_section from propath.
using ibs.th.bge.1crn.subjects.transport_section_ct-lvl from propath.

class ibs.th.bge.1crn.subjects.transport_section inherits ibs.th.bge.1crn.subjects.asubject:

  define property sec-num       as integer    no-undo get. 
    private set.
  define property capacity       as decimal      no-undo get. 
    private set.
  define property min-of-lvl       as decimal      no-undo get. 
    private set.
  define property max-of-lvl        as decimal    no-undo get. 
    private set.
  define property throat-diameter     as character    no-undo get. 
    private set.
  
  define override property InitTag as character no-undo init "section"
    get. 
    
  method override protected void SetPropProtected (inTag as char, inValue as char):
    case inTag:
      when "sec-num" then 
        do:
          assign 
            sec-num = integer(inValue) .
        end.
      when "capacity" then 
        do:
          assign 
            capacity = decimal(inValue) .
        end.
      when "min-of-lvl" then 
        do:
          assign 
            min-of-lvl = decimal(inValue) .
        end.
      when "max-of-lvl" then 
        do:
          assign 
            max-of-lvl = decimal(inValue).
        end.
      when "throat-diameter" then 
        do:
          assign 
            throat-diameter = inValue.
        end.
    end case.
  end.

 
  method override protected void CheckData ():

    def var v-str as char no-undo.
    
    assign
      v-str = v-str + ",sec-num" 
      when sec-num = ?
      v-str = v-str + ",capacity" 
      when capacity = ?
      v-str = v-str + ",min-of-lvl" 
      when min-of-lvl = ?
      v-str = v-str + ",max-of-lvl" 
      when max-of-lvl = ?
      v-str = v-str + ",throat-diameter" 
      when throat-diameter = ?
      .
    v-str = trim (v-str, ",").
    if v-str > ''
      then 
      undo, throw new Progress.Lang.AppError( substitute ("Теги &1 не могут иметь неопределное значение", v-str)).

  end.
  
  method override protected void ClearSub():
    assign 
      sec-num         = ?
      capacity        = ?
      min-of-lvl      = ?
      max-of-lvl      = ?
      throat-diameter = ?
      .
  end.

end class.