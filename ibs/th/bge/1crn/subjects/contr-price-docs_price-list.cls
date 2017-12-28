
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных contr-price-docs_price-list в 1С

Автор: Александр Морозов
Дата создания: 26/09/17
Author: Morozov Alexandr
Creation date: 26/09/17

*/

using Progress.Lang.*.


class ibs.th.bge.1crn.subjects.contr-price-docs_price-list inherits ibs.th.bge.1crn.subjects.asubject:

  define property gds-code    as character    no-undo get. private set.
  define property price-sale  as decimal      no-undo get. private set.
  define property nds-code    as decimal      no-undo get. private set.
  define property min-otkl    as decimal      no-undo get. private set.
  define property max-otkl    as decimal      no-undo get. private set.

  define override property InitTag as character no-undo init "gds-sale"
    get. 
    
     
  method override protected void SetPropProtected (inTag as char, inValue as char):
    case inTag:
      when "gds-code" then do:
        assign gds-code = inValue .
      end.
      when "price-sale" then do:
        assign price-sale = decimal(inValue) .
      end.
      when "nds-code" then do:
        assign nds-code = decimal (inValue) .
      end.
      when "min-otkl" then do:
        assign min-otkl = decimal (inValue) .
      end.
      when "max-otkl" then do:
        assign max-otkl = decimal (inValue) .
      end.
    end case.
  end.


  method override protected void CheckData ():

    def var v-str as char no-undo.
    
    assign
      v-str = v-str + ",gds-code" when gds-code = ?
      v-str = v-str + ",price-sale" when price-sale = ?
      v-str = v-str + ",nds-code" when nds-code = ?
      v-str = v-str + ",min-otkl" when min-otkl = ?
      v-str = v-str + ",max-otkl" when max-otkl = ?
    .
    v-str = trim (v-str, ",").
    if v-str > ''
    then 
      undo, throw new Progress.Lang.AppError( substitute ("Теги &1 не могут иметь неопределное значение", v-str)).

  end.
  
  method override protected void ClearSub():
    assign 
      gds-code     = ?
      price-sale   = ?
      nds-code     = ?
      min-otkl     = ?
      max-otkl     = ?
    .
  end.

end class.