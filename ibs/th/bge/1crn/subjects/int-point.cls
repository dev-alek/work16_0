/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных countries из 1С ERPRN

Автор: Александр Морозов
Дата создания: 26/09/17
Author: Morozov Alexandr
Creation date: 26/09/17

*/

using Progress.Lang.*.


class ibs.th.bge.1crn.subjects.int-point inherits ibs.th.bge.1crn.subjects.asubject: 

  define property code_ as character no-undo
    get. 
    private set.
  define property azk-code as character no-undo 
    get. 
    private set.
    
  define override property InitTag as character no-undo init "int-point"
    get. 
    
  method override protected void SetPropProtected (inTag as char, inValue as char):
    case inTag:
      when "code" then do:
        assign code_ = inValue.
      end.
      when "azk-code" then do:
        assign azk-code = inValue.
      end.
    end case.
  end.

  method override protected void CheckData ():

    def var v-str as char no-undo.
    
    assign
      v-str = "code" when code_ = ?
      v-str = v-str + ",azk-code" when azk-code = ?
    .
    v-str = trim (v-str, ",").
    if v-str > ''
    then 
      undo, throw new Progress.Lang.AppError( substitute ("Теги &1 не могут иметь неопределное значение", v-str)).

  end.
  
  method override protected void ClearSub():
    assign 
      code_     = ?
      azk-code  = ?
    .
  end.

  
end class.