/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных payment-type в 1С

Автор: Елена Шкляр
Дата создания: 26/09/17
Author: Shklyar Elena
Creation date: 26/09/17

*/

USING Progress.Lang.*.
using System.Boolean from assembly.

CLASS ibs.th.bge.1crn.subjects.payment-type implements ibs.th.bge.1crn.subjects.isubject:
  
  define property code_         as character    no-undo get. private set.
  define property del-l         as integer      no-undo get. private set.
  define property del-f         as integer      no-undo get. private set.
  define property name_         as character    no-undo get. private set.
  define property curr-code     as character    no-undo get. private set.
  define property ptg-code      as character    no-undo get. private set.
  define property pmt-cash      as integer      no-undo get. private set.
  define property pmt-fuel      as integer      no-undo get. private set.
  define property pmt-service   as integer      no-undo get. private set.
  define property cnt-code      as character    no-undo get. private set.
  define property enbl-zd       as integer      no-undo get. private set.
  define property use-km3       as integer      no-undo get. private set.
  define property enbl-trf      as integer      no-undo get. private set.
  define property pmt-ved       as integer      no-undo get. private set.
  define property doc-type      as integer      no-undo get. private set.
  define property mst-online    as integer      no-undo get. private set.
  define property mst-slip      as integer      no-undo get. private set.
  define property kbo           as integer      no-undo get. private set.
  define property malina        as integer      no-undo get. private set.
  define property prfx          as character    no-undo get. private set.
  
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
      when "curr-code" then do:
        assign curr-code = inValue .
      end.
      when "ptg-code" then do:
        assign ptg-code = inValue .
      end.
      when "pmt-cash" then do:
        assign pmt-cash = integer(inValue) .
      end.
      when "pmt-fuel" then do:
        assign pmt-fuel = integer(inValue) .
      end.
      when "pmt-service" then do:
        assign pmt-service = integer(inValue) .
      end.
      when "cnt-code" then do:
        assign cnt-code = inValue .
      end.
      when "enbl-zd" then do:
        assign enbl-zd = integer(inValue) .
      end.
      when "use-km3" then do:
        assign use-km3 = integer(inValue) .
      end.
      when "enbl-trf" then do:
        assign enbl-trf = integer(inValue) .
      end.
      when "pmt-ved" then do:
        assign pmt-ved = integer(inValue) .
      end.
      when "doc-type" then do:
        assign doc-type = integer(inValue) .
      end.
      when "mst-online" then do:
        assign mst-online = integer(inValue) .
      end.
      when "mst-slip" then do:
        assign mst-slip = integer(inValue) .
      end.
      when "kbo" then do:
        assign kbo = integer(inValue) .
      end.
      when "malina" then do:
        assign malina = integer(inValue) .
      end.
      when "prfx" then do:
        assign prfx = inValue .
      end.
    end case.
  end.

END CLASS.