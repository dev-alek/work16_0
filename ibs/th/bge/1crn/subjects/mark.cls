/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

kass-book:payment-agent - Секция с параметрами платежного агента из 1С
c 21/V-2019 самостоятельная сущность Платежные агента/Банковские платежные агенты

Автор: Рубан Дмитрий
Дата создания: 13/02/19
Author: Ruban Dmitriy
Creation date: 13/02/19

*/
block-level on error undo, throw.
 

class ibs.th.bge.1crn.subjects.mark inherits ibs.th.bge.1crn.subjects.asubject:
  
  
  define property mark-code       as character    no-undo get. private set.
  define property unit-ext        as character    no-undo get. private set.
  define property qnty-box        as decimal      no-undo get. private set.
  define property stts            as character    no-undo get. private set.
  define property mark-parent     as character    no-undo get. private set.
  define property GTIN            as character    no-undo get. private set.
  define property gds-code        as integer      no-undo get. private set.
  define property mrc             as decimal      no-undo get. private set.
  define property stts-desc             as character    no-undo get. private set.

  define property del-l         as integer      no-undo get. private set.
  define property del-f         as integer      no-undo get. private set.

  define property obj-load        as character       no-undo get.  set.
  
  define override property InitTag as character no-undo init "mark"
    get.
  
  constructor public mark ():
  end constructor.

  method private date date-mth (inValue as character):
    
    inValue = entry (1, inValue, "T").
    return date (integer (entry (2, Invalue, "-")), integer (entry (3, Invalue, "-")), integer (entry (1, Invalue, "-")) ). 
    
  end.
  &scoped-define attr-str      if inValue >= "" then inValue else ""
  &scoped-define attr-integer  if inValue >= "" then integer (inValue) else 0
  &scoped-define attr-dec      if inValue >= "" then decimal (inValue) else 0.0
  &scoped-define attr-date     if inValue >= "" then date-mth (inValue) else ?
  method override protected void SetPropProtected (inTag as char, inValue as char):
    case inTag:
      when "del-l"        then del-l            = {&attr-integer} .
      when "del-f"        then del-f            = {&attr-integer} .
      when "mark-code"    then mark-code        = {&attr-str} .
      when "unit-ext"     then unit-ext         = {&attr-str} .
      when "qnty-box"     then qnty-box         = {&attr-dec} .
      when "stts"         then stts             = {&attr-str} .
      when "mark_parent"  then mark-parent      = {&attr-str} .
      when "mark-parent"  then mark-parent      = {&attr-str} .
      when "stts-desc"    then stts-desc        = {&attr-str} .
      when "GTIN"         then GTIN             = {&attr-str} .
      when "gds-code"     then gds-code         = {&attr-integer} .
      when "mrc"          then mrc              = {&attr-dec} .
    end case.
    catch exProErrors as class Progress.Lang.ProError :
      case exProErrors:GetMessageNum(1):
        when 18207 then undo, throw new Progress.Lang.AppError(
          substitute("Поле <&1> содержит ошибочное значение [&2]", inTag, inValue)
        ) .
        otherwise undo, throw new Progress.Lang.AppError(
          substitute("Ошибка значения для поля <&1>: &2", inTag, exProErrors:GetMessage(1))
        ) .
      end case .
    end catch .
  end method.

  method override protected void SetPropProtected (SubsObj as ibs.th.bge.1crn.subjects.subjects):
    /* вызывается для переприсваивания коллекции после каждого добавления элемента в коллекцию;
       указатель на объект коллекции приходит с одним и тем же значением */
   end method.

  method override protected void CheckData ():
    def var v-str as char no-undo.
    
    assign
      v-str = v-str + ",mark-code"          when mark-code         = ? 
      v-str = v-str + ",unit-ext"           when unit-ext          = ? and obj-load eq "mark"
      v-str = v-str + ",qnty-box"           when qnty-box          = ? and obj-load eq "mark"
/*      v-str = v-str + ",GTIN"               when GTIN              = ? and obj-load eq "mark" */
/*      v-str = v-str + ",gds-code"           when gds-code          = ? and obj-load eq "mark"*/
      v-str = v-str + ",stts"               when stts              = ? 
    .
   
    v-str = substring(v-str, 2).
    if v-str > "" then undo, throw new Progress.Lang.AppError(
      substitute("Теги [&1] отсутствуют в сообщении [&2]", v-str, InitTag)
    ) .
  end method.
  
  method override protected void ClearSub():
    assign
      mark-code          = ?
      del-l              = ?
      del-f              = ?
      unit-ext           = ?
      qnty-box           = ?
      stts               = ?
      mark-parent        = ?
      GTIN               = ?
      gds-code           = ?
      mrc                = ?
      stts-desc          = ?
    .
    
    
  end method.
      
end class.