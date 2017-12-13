/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных shops (АЗК/АЗС) из 1С

Автор: Молотков Сергей
Дата создания: 04/12/17
Author: Molotkov Sergey
Creation date: 04/12/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.enum-ms-type.
using ibs.th.bge.1crn.enum-ms-tk-type.
block-level on error undo, throw.

class ibs.th.bge.1crn.subjects.measuring inherits ibs.th.bge.1crn.subjects.asubject:

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
  define property ms-type as enum-ms-type no-undo 
    get. 
    private set.
  define property me-np as decimal no-undo
    get. 
    private set.
  define property me-wtr as decimal no-undo
    get. 
    private set.
  define property me-dnsty as decimal no-undo
    get. 
    private set.
  define property me-tmp-amnt as decimal no-undo
    get. 
    private set.
  define property me-tmp-dnsty as decimal no-undo
    get. 
    private set.
  define property limit as decimal no-undo
    get. 
    private set.
  define property tk as enum-ms-tk-type no-undo 
    get. 
    private set.
  
  define override property InitTag as character no-undo init "measuring"
    get. 
    
  method override protected void SetPropProtected (inTag as char, inValue as char):
    case inTag:
      when "code"       then code_      = if inValue >= "" then inValue else "" .
      when "del-l"      then del-l      = if inValue >= "" then integer (inValue) else 0 .
      when "del-f"      then del-f      = if inValue >= "" then integer (inValue) else 0 .
      when "name"       then name_      = if inValue >= "" then inValue else "" .
      
      /* допустимые значения ms-type перечислены в enum;
         если дано пустое значение - поле заполнится типом "ареометр калиброванный при 15 градусах",
         если дано значение вне enum - поле останется пустым
       */
      when "ms-type" then do :
        if inValue >= "" then ms-type = enum-ms-type:GetEnum( integer (inValue) ) no-error .
                         else ms-type = enum-ms-type:enare15 .
      end .

      when "me-np"        then me-np        = if inValue >= "" then decimal (inValue) else 0 .
      when "me-wtr"       then me-wtr       = if inValue >= "" then decimal (inValue) else 0 .
      when "me-dnsty"     then me-dnsty     = if inValue >= "" then decimal (inValue) else 0 .
      when "me-tmp-amnt"  then me-tmp-amnt  = if inValue >= "" then decimal (inValue) else 0 .
      when "me-tmp-dnsty" then me-tmp-dnsty = if inValue >= "" then decimal (inValue) else 0 .
      when "limit"        then limit        = if inValue >= "" then decimal (inValue) else 0 .

      when "tk" then do :
        if inValue >= "" then tk = enum-ms-tk-type:GetEnum( integer (inValue) ) no-error .
                         else tk = enum-ms-tk-type:ensteel .
      end .

    end case.
  end method.

  method override protected void CheckData ():
    def var v-str as char no-undo.
    assign
      v-str = ",code" when code_ = ?
      v-str = v-str + ",name" when name_ = ?
      v-str = v-str + ",ms-type" when ms-type = ?
      v-str = v-str + ",me-np" when me-np = ?
      v-str = v-str + ",me-wtr" when me-wtr = ?
      v-str = v-str + ",me-dnsty" when me-dnsty = ?
      v-str = v-str + ",me-tmp-amnt" when me-tmp-amnt = ?
      v-str = v-str + ",me-tmp-dnsty" when me-tmp-dnsty = ?
      v-str = v-str + ",limit" when limit = ?
      v-str = v-str + ",tk" when tk = ?
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
      ms-type      = ?
      me-np        = ?
      me-wtr       = ?
      me-dnsty     = ?
      me-tmp-amnt  = ?
      me-tmp-dnsty = ?
      limit        = ?
      tk           = ?
    .
  end method.

end class.