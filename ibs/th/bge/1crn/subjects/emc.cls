/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных countries из 1С ERPRN

Автор: Александр Морозов
Дата создания: 26/09/17
Author: Morozov Alexandr
Creation date: 26/09/17

*/

using Progress.Lang.*.


class ibs.th.bge.1crn.subjects.emc inherits ibs.th.bge.1crn.subjects.asubject: 
  { cmp/str-glbl.i class } 
  define var emctype-code as integer no-undo
  . 
  define property del-l as integer no-undo 
    get. 
    private set.
  define property del-f as integer no-undo 
    get. 
    private set.
  define property code_ as character no-undo 
    get. 
    private set.
  define property parent_ as character no-undo 
    get. 
    private set.
  
  define property misc1 as character no-undo 
    get. 
    private set.
  define property codeValue as character no-undo 
    get. 
    private set.
  define property codeName as character no-undo 
    get. 
    private set.
  define property status_ as integer no-undo init {&bef-current-status-int} 
    get. 
    private set.
    
  define override property InitTag as character no-undo init "EMC"
    get. 
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
      when "emc-start-date" then do:
          assign code_ = {&attr-str}
                 misc1 = string({&attr-date},"99/99/9999")
          .
      end.
      when "del-l" then do:
        assign del-l = {&attr-integer}.
         if del-l > 0
         then
            status_ = {&bef-deleted-status-int}.
      end.
      when "del-f" then do:
        assign del-f = {&attr-integer}.
      end.
      when "emc-name" then do:
        assign CodeName = {&attr-str} .
      end.
      when "emc-value" then do:
        assign CodeValue = {&attr-str} .
      end.
      when "emctype-code" then do:
        assign emctype-code = {&attr-integer}
               parent_      = "emc" + {&delim-par} + string(emctype-code,"001").
      end.
      
    end case.
  end.

  method override protected void CheckData ():

    def var v-str as char no-undo.
    
    assign
      v-str = "emc-start-date" when code_ = ?
      v-str = v-str + ",emc-value" when CodeValue = ?
      v-str = v-str + ",emctype-code" when emctype-code = ?
    .
    v-str = trim (v-str, ",").
    if v-str > ''
    then 
      undo, throw new Progress.Lang.AppError( substitute ("Теги &1 не могут иметь неопределное значение", v-str)).
    if emctype-code ne 1
    then 
      undo, throw new Progress.Lang.AppError( substitute("Загрузка emctype-code = &1 не предусмотрена",emctype-code)).
    if del-f > 0 then
      undo, throw new Progress.Lang.AppError("физичесткое удаление EMC не предусмотрено") .    
    
  end.

  method override protected void ClearSub():
    assign 
      code_         = ?
      del-l         = ?
      del-f         = ?
      CodeName      = ?
      CodeValue     = ?
      misc1         = ?
      emctype-code  = ? 
    .
  end.

  
end class.