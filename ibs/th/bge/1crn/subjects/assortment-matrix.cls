/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных assortment-matrix в 1С

Автор: Молотков Сергей Михайлович
Дата создания: 21/11/17
Author: Molotkov Sergey
Creation date: 21/11/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.enum-assortment-stg.
using ibs.th.bge.1crn.subjects.subjects from propath.


class ibs.th.bge.1crn.subjects.assortment-matrix inherits ibs.th.bge.1crn.subjects.asubject:

  define property gds-code as character no-undo
    get.
    private set.
  define property stg as enum-assortment-stg no-undo 
    get. 
    private set.

  define override property InitTag as character no-undo init "assortment-matrix"
    get. 


  method override protected void SetPropProtected (inTag as char, inValue as char):
    case inTag:
      when "gds-code" then gds-code = if inValue >= "" then inValue else "" .
      
      /* допустимые значения stg перечислены в enum;
         если дано значение вне enum - поле останется пустым,
         если дано пустое значение - поле заполнится типом "archive"
         (в БД TradeHouse запишется как "Пусто")
       */
      when "stg" then do :
        if inValue >= "" then stg = enum-assortment-stg:GetEnum( integer (inValue) ) no-error .
                         else stg = enum-assortment-stg:enarchive .
      end .
      
    end case.
  end method.


  method override protected void CheckData ():
    def var v-str as char no-undo.
    
    assign
      v-str = ",gds-code" when gds-code = ?
      v-str = v-str + ",stg" when stg = ?
    .
    v-str = substring(v-str, 2).
    if v-str > "" then undo, throw new Progress.Lang.AppError(
      substitute("Теги [&1] отсутствуют в сообщении [&2]", v-str, InitTag)
    ) .

  end method.
  
  method override protected void ClearSub():
    assign 
      gds-code = ?
      stg      = ?
    .
  end method.


end class.