/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Экспорт сообщения с чеком в 1С ERPRN check

Автор: Молотков Сергей Михайлович
Дата создания: 03/11/17
Author: Molotkov Sergey
Creation date: 03/11/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.enum-chk-type.
using ibs.th.bge.1crn.subjects.*.
block-level on error undo, throw.

class ibs.th.bge.1crn.subjects.exp-mark inherits ibs.th.gbl.sys.objth implements iexpsubject:

  { cmp/str-glbl.i class }
  { utl/gtin.i class}
 /* { str/lib-trn.i  class }
  { cmp/library.i  class }
  { ref/extclass.i }*/

  define property Msg as character no-undo
    get:
      return trim (Msg, {&new-line}).
    end.
    private set (inArg as char):
      Msg = Msg + {&new-line} + inArg.
    end.

  /* 16/VIII-2018 надо вокруг чеков сделать еще одну секцию с номером смены.
     Связано это с тем, что если в пакет попадает несколько раз одна и таже смена,
     1С уже не понимает какой набор чеков был последний, т.к. они все валятся в один раздел.
  */
  &scop tag-interface 'marks':U
  define property InitSecTag as character no-undo init {&tag-interface}
    get.

  define property BufHandle as handle no-undo
    get.
    set.

  &scop tag-marks   'marks':U     
  &scop tag-mark   'mark':U
  
  
  
  constructor public exp-mark ():
  end constructor.
  
  /*------------------------------------------------------------------------------
   Purpose: выгружает несколько чеков со всеми потрохами в контекст контейнера SAX-writer
   Notes:   обязательный метод
   Param:   insw = create sax-writer
  ------------------------------------------------------------------------------*/
method public void CrContentToSW (insw as handle):

   Msg = "" .
   if not valid-handle(BufHandle) then undo, throw new Progress.Lang.AppError("Отсутствует запись Электронного документа") .
    
   
    
    
   find first marking where marking.mark eq string(BufHandle:buffer-field( "mark":U  ):buffer-value)
   no-lock no-error.
   if available marking
   then do:
/*      insw:start-element ({&tag-marks}) .*/
      insw:start-element ({&tag-mark}) .
      insw:write-data-element (  "mark-code":U,       addBracketForCode(marking.mark)   ).
      insw:write-data-element (  "unit-ext":U,        marking.unit-ext   ).
      insw:write-data-element (  "qnty-box":U,      string( marking.box-qnty )   ).
      insw:write-data-element (  "stts":U,       ObjSrv:Env:marking:sts:mark:GetKeyStrDB(marking.sts)).
      insw:write-data-element (  "mark_parent":U,      addBracketForCode( marking.mark-parent )  ).
      insw:write-data-element (  "GTIN":U,       marking.gds-ext-id   ).
      insw:write-data-element (  "gds-code":U,       string(marking.gds-code)   ).
      find first marking-attr where marking-attr.mark eq marking.mark
                                and marking-attr.attr-code eq "mrc"  
      no-lock no-error.
      if available marking-attr
      then
         insw:write-data-element (  "mrc":U,       marking-attr.attr-value   ).
      insw:end-element ({&tag-mark}) .
/*      insw:end-element ({&tag-marks}) .*/
   end.
   catch exAppErrors as class Progress.Lang.AppError :
      Msg = exAppErrors:ReturnValue .
      if Msg = "" then Msg = exAppErrors:GetMessage(1) .
      undo, throw exAppErrors .
    end catch .
    catch exProErrors as class Progress.Lang.ProError :
      Msg = exProErrors:GetMessage(1) . 
      undo, throw exProErrors .
    end catch .
    catch exAnyErrors as class Progress.Lang.Error:
      Msg = "Unexpected error occurred..." .
      undo, throw exAnyErrors .
    end catch .
    
  end method . /* end_of CrContentToSW */




  /* Формат даты ДД.ММ.ГГГГ
    <doc-date>01.01.2017</doc-date>
    <created-date>23.10.2017 12:08:15</created-date>
    28/XI-2017 - dataFormat() не используется: все даты в формате ISO
  */
  method private character timeFormat (p-time as integer) :
    define variable v-tm-format as character initial "hh:mm:ss" no-undo .
    return if (p-time >= 0) then string(p-time, v-tm-format) else "" .
  end method .
  method private character dateFormat (p-date as date) :
    define variable v-dt-format as character initial "99.99.9999" no-undo .
    return if (p-date = ?) then "" else string(p-date, v-dt-format) .
  end method .

  
  method private character base64-enc ( input v-string as character ) :
    
    define variable v-base64-encode as character no-undo .
    
    
    do
    on error undo, return error return-value
    :
      define variable v-raw     as raw       no-undo .
      define variable v-raw-str as character no-undo .
    
      if v-string = ?
      then do:
        undo, return error "base64-encode: строка имеет неопределенное значение" .
        end.
    
        assign
          length(v-raw) = length(v-string) + 1
        .
        assign
          put-string(v-raw, 1) = v-string
        .
        assign
          v-raw-str = string(v-raw)
        .
        assign
          length(v-raw) = 0
        .
        assign
          v-base64-encode = substring(v-raw-str, 7)
        .
    end.
    
    return v-base64-encode .
  end.

  
end class.
