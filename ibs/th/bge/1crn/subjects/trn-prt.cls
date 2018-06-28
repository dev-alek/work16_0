/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных prts накладной из 1С ERPRN

Автор: Александр Морозов
Дата создания: 26/09/17
Author: Morozov Alexandr
Creation date: 26/09/17

*/

using Progress.Lang.*.


class ibs.th.bge.1crn.subjects.trn-prt inherits ibs.th.bge.1crn.subjects.asubject: 

  define property gd-line-num as character no-undo
    get. 
    private set.
  define property prt-id as character no-undo 
    get. 
    private set.
  define property vad-guid as character no-undo 
    get. 
    private set.
  define property qnty as decimal no-undo 
    get. 
    private set.
    
  define override property InitTag as character no-undo init "prt"
    get. 
    
  method override protected void SetPropProtected (inTag as char, inValue as char):
    case inTag:
      when "gd-line-num" then do:
        assign gd-line-num = inValue.
      end.
      when "prt-id" then do:
        assign prt-id = inValue.
      end.
      when "vad-guid" then do:
        assign vad-guid = inValue.
      end.
      when "qnty" then do:
        assign qnty = decimal (inValue) .
      end.
    end case.
  end.

  method override protected void CheckData ():

    def var v-str as char no-undo.
    
    assign
      v-str = "gd-line-num" when gd-line-num = ?
      v-str = v-str + ",prt-id" when prt-id = ?
      v-str = v-str + ",qnty" when qnty = ?
    .
    v-str = trim (v-str, ",").
    if v-str > ''
    then 
      undo, throw new Progress.Lang.AppError( substitute ("Теги &1 не могут иметь неопределное значение", v-str)).

  end.
  
  method override protected void ClearSub():
    assign 
      gd-line-num  = ?
      prt-id   = ?
      qnty = ?
      vad-guid  = ?
    .
  end.

  
end class.