/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных shops (АЗК/АЗС) из 1С

Автор: Молотков Сергей
Дата создания: 02/10/17
Author: Molotkov Sergey
Creation date: 02/10/17

*/

using Progress.Lang.*.


class ibs.th.bge.1crn.subjects.shops implements ibs.th.bge.1crn.subjects.isubject:

  define property code_ as character no-undo
    get. 
    set.
  define property del-l as integer no-undo 
    get. 
    set.
  define property del-f as integer no-undo 
    get. 
    set.
  define property name_ as character no-undo 
    get. 
    set.
  define property frm-code as character no-undo
    get.
    set.
  define property grp-code as character no-undo
    get.
    set.
  define property address as character no-undo
    get.
    set.
  define property tel as character no-undo
    get.
    set.
  define property director as character no-undo
    get.
    set.
  define property accr as character no-undo
    get.
    set.
    
  method public void SetProp (inTag as char, inValue as char):
    case inTag:
      when "code" then do:
        assign code_ = inValue .
      end.
      when "del-l" then do:
        assign del-l = integer (inValue).
      end.
      when "del-f" then do:
        assign del-f = integer (inValue).
      end.
      when "upper-code" then do:
        assign upper-code = inValue .
      end.
      when "frm-code" then do:
        assign frm-code = inValue .
      end.
      when "grp-code" then do:
        assign grp-code = inValue .
      end.
      when "address" then do:
        assign address = inValue .
      end.
      when "tel" then do:
        assign tel = inValue .
      end.
      when "director" then do:
        assign director = inValue .
      end.
      when "accr" then do:
        assign accr = inValue .
      end.
    end case.
  end.

end class.