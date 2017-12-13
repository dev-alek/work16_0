/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных cli-grps (группы контрагентов) из 1С

Автор: Молотков Сергей
Дата создания: 02/10/17
Author: Molotkov Sergey
Creation date: 02/10/17

*/

using Progress.Lang.*.


class ibs.th.bge.1crn.subjects.cli-grps implements ibs.th.bge.1crn.subjects.isubject: 

  define property code_ as character no-undo
    get. 
    private set.
  define property upper-code as character no-undo
    get.
    private set.
  define property del-l as integer no-undo 
    get. 
    private set.
  define property del-f as integer no-undo 
    get. 
    private set.
  define property name_ as character no-undo 
    get. 
    private set.

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
      when "name" then do:
        assign name_ = inValue .
      end.
    end case.
  end.

end class.