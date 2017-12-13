
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных units в 1С

Автор: Александр Морозов
Дата создания: 26/09/17
Author: Morozov Alexandr
Creation date: 26/09/17

*/

using Progress.Lang.*.


class ibs.th.bge.1crn.subjects.units implements ibs.th.bge.1crn.subjects.isubject:

  define property okei-code   as character    no-undo get. private set.
  define property del-l       as integer      no-undo get. private set.
  define property del-f       as integer      no-undo get. private set.
  define property name_       as character    no-undo get. private set.
  define property full-name   as character    no-undo get. private set.

  method public void SetProp (inTag as char, inValue as char):
    case inTag:
      when "okei-code" then do:
        assign okei-code = inValue .
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
      when "full-name" then do:
        assign full-name = inValue .
      end.
    end case.
  end.

end class.