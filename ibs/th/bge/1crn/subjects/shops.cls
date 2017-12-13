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
block-level on error undo, throw.

class ibs.th.bge.1crn.subjects.shops inherits ibs.th.bge.1crn.subjects.asubject:

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
  define property frm-code as character no-undo
    get.
    private set.
  /* от 21-окт-2017:
     Справочник групп клиентов из 1С к нам приходить не будет.
     Поле grp-code в импорте не приходит. Значение grp-code подставляется по согласованию с техносервом.
  */
  define property grp-code as character no-undo
    get.
    private set.
  define property address as character no-undo
    get.
    private set.
  define property tel as character no-undo
    get.
    private set.
  define property director as character no-undo
    get.
    private set.
  define property accr as character no-undo
    get.
    private set.
    
   /* 22-ноя-2017 добавлено: Число (1,0) 1-1 Наличие кафе
      Полного аналога в TradeHouse пока нет. Поле читаем, проверяем наличее т.к. оно обязательное,
      но не обрабатываем. */
  define property cafe_exist as integer no-undo
    get.
    private set.
  
  define override property InitTag as character no-undo init "azk"
    get. 
    
  method override protected void SetPropProtected (inTag as char, inValue as char):
    case inTag:
      when "code"       then code_      = if inValue >= "" then inValue else "" .
      when "del-l"      then del-l      = if inValue >= "" then integer (inValue) else 0 .
      when "del-f"      then del-f      = if inValue >= "" then integer (inValue) else 0 .
      when "name"       then name_      = if inValue >= "" then inValue else "" .
      when "frm-code"   then frm-code   = if inValue >= "" then inValue else "" .
      when "grp-code"   then grp-code   = if inValue >= "" then inValue else "" .
      when "address"    then address    = if inValue >= "" then inValue else "" .
      when "tel"        then tel        = if inValue >= "" then inValue else "" .
      when "director"   then director   = if inValue >= "" then inValue else "" .
      when "accr"       then accr       = if inValue >= "" then inValue else "" .
      when "cafe_exist" then cafe_exist = if inValue >= "" then integer (inValue) else 0 .
    end case.
  end method.

  method override protected void CheckData ():

    def var v-str as char no-undo.
    assign
      v-str = ",code" when code_ = ?
      v-str = v-str + ",name" when name_ = ?
      v-str = v-str + ",frm-code" when frm-code = ?
      
      /* 23/XI-2017 снята обязательность с полей, несмотря на наличее её в документации:
         "Коллеги, по АЗК Директора и Бухгалтера давайте сделаем необязательными."
         "Наличие кафе пока никак не обрабатываем вообще."
         Второе утверждение тоже подразумевает снятие обязательности с поля. 
      v-str = v-str + ",director" when director = ?
      v-str = v-str + ",accr" when accr = ?
      v-str = v-str + ",cafe_exist" when cafe_exist = ?
      */
    .
    v-str = substring(v-str, 2).
    if v-str > "" then undo, throw new Progress.Lang.AppError(
      substitute("Теги [&1] отсутствуют в сообщении [&2]", v-str, InitTag)
    ) .

  end method.
  
  method override protected void ClearSub():
    assign 
      code_      = ?
      del-l      = ?
      del-f      = ?
      name_      = ?
      frm-code   = ?
      grp-code   = ?
      address    = ?
      tel        = ?
      director   = ?
      accr       = ?
      cafe_exist = ?
    .
  end method.

end class.