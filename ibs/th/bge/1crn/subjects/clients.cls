/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных clients (контрагенты) из 1С

Автор: Молотков Сергей
Дата создания: 02/10/17
Author: Molotkov Sergey
Creation date: 02/10/17

*/

using Progress.Lang.*.


class ibs.th.bge.1crn.subjects.clients implements ibs.th.bge.1crn.subjects.isubject:

  define property code_ as character no-undo
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
  define property full-name as character no-undo
    get. 
    private set.
  define property grp-code as character no-undo
    get.
    private set.
  define property city as character no-undo
    get.
    private set.
  define property ind as character no-undo
    get.
    private set.
  define property inn as character no-undo
    get.
    private set.
  define property kpp as character no-undo
    get.
    private set.
  define property agnt as character no-undo
    get.
    private set.
  define property post-adr as character no-undo
    get.
    private set.
  define property e-mail as character no-undo
    get.
    private set.
  define property leg-adr as character no-undo
    get.
    private set.
  define property okpo as character no-undo
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
      when "full-name" then do:
        assign full-name = inValue .
      end.
      when "grp-code" then do:
        assign grp-code = inValue .
      end.
      when "city" then do:
        assign city = inValue .
      end.
      when "ind" then do:
        assign ind = inValue .
      end.
      when "kpp" then do:
        assign kpp = inValue .
      end.
      when "agnt" then do:
        assign agnt = inValue .
      end.
      when "post-adr" then do:
        assign post-adr = inValue .
      end.
      when "e-mail" then do:
        assign e-mail = inValue .
      end.
      when "leg-adr" then do:
        assign leg-adr = inValue .
      end.
      when "okpo" then do:
        assign okpo = inValue .
      end.
    end case.
  end.

end class.