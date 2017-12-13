
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных contracts в 1С

Автор: Александр Морозов
Дата создания: 26/09/17
Author: Morozov Alexandr
Creation date: 26/09/17

*/

using Progress.Lang.*.


class ibs.th.bge.1crn.subjects.contracts implements ibs.th.bge.1crn.subjects.isubject:

  define property code_       as character    no-undo get. private set.
  define property del-l       as integer      no-undo get. private set.
  define property del-f       as integer      no-undo get. private set.
  define property org-code    as character    no-undo get. private set.
  define property cont-code   as character    no-undo get. private set.
  define property date-srt    as date         no-undo get. private set.
  define property date-end    as date         no-undo get. private set.

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
      when "org-code" then do:
        assign org-code = inValue .
      end.
      when "cont-code" then do:
        assign cont-code = inValue .
      end.
      when "date-srt" then do:
        assign date-srt = date (inValue) .
      end.
      when "date-end" then do:
        assign date-end = date (inValue) .
      end.
    end case.
  end.

end class.