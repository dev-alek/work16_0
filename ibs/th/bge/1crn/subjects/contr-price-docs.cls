
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных contr-price-docs в 1С

Автор: Александр Морозов
Дата создания: 26/09/17
Author: Morozov Alexandr
Creation date: 26/09/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.subjects from propath.
using ibs.th.bge.1crn.subjects.contr-price-docs_price-list from propath.
using ibs.th.bge.1crn.subjects.contr-price-docs from propath.

class ibs.th.bge.1crn.subjects.contr-price-docs inherits ibs.th.bge.1crn.subjects.asubject:

  define property doc-id      as character    no-undo get. private set.
  define property doc-num     as character    no-undo get. private set.
  define property doc-date    as character    no-undo get. private set.
  define property contr-code  as character    no-undo get. private set.
  define property cont-code   as character    no-undo get. private set.
  define property price-list  as subjects     no-undo get. private set.
  
  define override property InitTag as character no-undo init "contr-price-doc"
    get. 
    
  constructor public contr-price-docs ():
    InitListTag = "gds-sale".
  end constructor.
      
  method override protected void SetPropProtected (inTag as char, inValue as char):
    case inTag:
      when "doc-id" then do:
        assign doc-id = inValue .
      end.
      when "doc-num" then do:
        assign doc-num = inValue .
      end.
      when "doc-date" then do:
        assign doc-date = inValue .
      end.
      when "contr-code" then do:
        assign contr-code = inValue.
      end.
      when "cont-code" then do:
        assign cont-code = inValue.
      end.
    end case.
  end.

  method override protected void SetPropProtected(SubsObj as subjects):

    case SubsObj:InitTag:   
      when "gds-sale" then
        do:
          price-list = SubsObj.            
        end.
    end case.

  end.
  
  method override protected void CheckData ():

    def var v-str as char no-undo.
    
    assign
      v-str = "doc-id" when doc-id = ?
      v-str = "doc-num" when doc-num = ?
      v-str = "doc-date" when doc-date = ?
      v-str = v-str + ",contr-code" when contr-code = ?
      v-str = v-str + ",cont-code" when cont-code = ?
    .
    v-str = trim (v-str, ",").
    if v-str > ''
    then 
      undo, throw new Progress.Lang.AppError( substitute ("Теги &1 не могут иметь неопределное значение", v-str)).

  end.
  
  method override protected void ClearSub():
    assign 
      doc-id       = ?
      doc-num      = ?
      doc-date     = ?
      contr-code   = ?
      cont-code    = ?
    .
  end.

end class.