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

class ibs.th.bge.1crn.subjects.exp-edi-doc inherits ibs.th.gbl.sys.objth implements iexpsubject:

  { cmp/str-glbl.i class }
  { utl/gtin.i class}
  { str/utd-attr.i class}
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
  &scop tag-interface 'edi-docs':U
  define property InitSecTag as character no-undo init {&tag-interface}
    get.

  define property BufHandle as handle no-undo
    get.
    set.

    
  &scop tag-edi-doc   'edi-doc':U
  
  &scop tag-message   'edo-doc':U
  &scop tag-section1  'gds':U
  &scop tag-item1     'gd':U
  &scop tag-section2  'marks':U
  &scop tag-item2     'mark':U
  
  constructor public exp-edi-doc ():
  end constructor.
  
  /*------------------------------------------------------------------------------
   Purpose: выгружает несколько чеков со всеми потрохами в контекст контейнера SAX-writer
   Notes:   обязательный метод
   Param:   insw = create sax-writer
  ------------------------------------------------------------------------------*/
method public void CrContentToSW (insw as handle):

   Msg = "" .
   if not valid-handle(BufHandle) then undo, throw new Progress.Lang.AppError("Отсутствует запись Электронного документа") .
    
   define variable vdb-num as integer no-undo.
   define variable vdoc-id as integer no-undo.
    
    vdb-num = int(BufHandle:buffer-field( "db-num":U  ):buffer-value ).
    vdoc-id = int(BufHandle:buffer-field( "doc-id":U  ):buffer-value).
   find first utd where utd.db-num eq vdb-num
                    and utd.doc-id eq vdoc-id
   no-lock no-error.
 
   if available utd
   then do:
/*      insw:start-element ({&tag-edi-docs}) .*/
      insw:start-element ({&tag-edi-doc}) .
      insw:write-data-element (  "edoc-id":U,      if utd.DocumentExt eq "" or utd.DocumentExt eq ? then string(utd.doc-id ) else utd.DocumentExt   ).
      insw:write-data-element (  "edoc-num":U,       utd.DocumentNumber   ).
      insw:write-data-element (  "edoc-date":U,       iso-date(utd.DocumentDate)    ).
      define variable VText as character no-undo.
      VText = ObjSrv:Env:Utd:edoctype:GetKeyStrDB(utd.EDocType).
      if VText eq ?
      then
         VText = "".
      
      insw:write-data-element (  "edoc-type":U,       VText).
      insw:write-data-element (  "edoc-stts":U,       ObjSrv:Env:Utd:Sts:th:GetKeystrDB(utd.sts)   ).
      insw:write-data-element (  "contr-code":U,       utd.CounteragentId   ).
      insw:write-data-element (  "dog-code":U,       string(utd.contract-code)   ).
      insw:write-data-element (  "orig-edoc-id":U,       utd.parentDocumentExt   ).
      insw:write-data-element (  "comment":U,       if utd.comment = ? then "" else utd.comment   ).
      insw:write-data-element (  "sum":U,       string(utd.total)   ).
      insw:write-data-element (  "sum-nonds":U,       string(utd.total - utd.vat )    ).
      if utd.EDocType        = objSrv:Env:Utd:EDocType:returns:KeyIntDB
      then
         insw:write-data-element (  "trn-doc-code":U,      utd.doc-code ).
      find first utd-lines  where utd-lines.db-num = utd.db-num
                              and utd-lines.doc-id = utd.doc-id 
      no-lock no-error.
      if available utd-lines
      then do:
         define variable VFlagStsMark as logical no-undo.
         VFlagStsMark = yes /*utd.EDocType eq ObjSrv:Env:Utd:edoctype:Introduce:KeyIntDB*/ . /* всегда выгружаем статус марок */ 
         insw:start-element ({&tag-section1}) .
         for each utd-lines  where utd-lines.db-num = utd.db-num
                              and utd-lines.doc-id = utd.doc-id 
         no-lock:
            insw:start-element ({&tag-item1}) .
            insw:write-data-element (  "line-num",       string(utd-lines.LineNum)          ) .
           /* find last tax-rate-value where    /*Значение ставки налога    НДС    */
                          tax-rate-value.tax-code = 1 and
                        tax-rate-value.rate-value = utd-lines.TaxRate no-lock no-error.
            if available tax-rate-value then*/
               insw:write-data-element (  "nds-code",         string( utd-lines.TaxRate )           ) . 
            insw:write-data-element (  "gd-code",      string(utd-lines.gds-code)        ) . 
            insw:write-data-element (  "price-nonds",      string(utd-lines.Price)        ) . 
            insw:write-data-element (  "qnty-ttn",   string(utd-lines.Quantity)  ) . 
            insw:write-data-element (  "sum",  string(utd-lines.Total)                 ) .
            insw:write-data-element (  "sum-nds",  string(utd-lines.vat)                 ) .
            insw:write-data-element (  "Qnty-accepted",  
                                     getattrutdlinesex(utd-lines.db-num, utd-lines.doc-id, utd-lines.lineNum,"QuantityBarCode","0")                 
                                     ) .  
            find first utd-marking-lines  where utd-marking-lines.db-num  = utd-lines.db-num
                                            and utd-marking-lines.doc-id  = utd-lines.doc-id
                                            and utd-marking-lines.LineNum = utd-lines.LineNum
                                            and utd-marking-lines.doc-level = 1 
            no-lock no-error.
            if available utd-marking-lines 
            then do:
               insw:start-element ({&tag-section2}) .
               for each utd-marking-lines  where utd-marking-lines.db-num  = utd-lines.db-num
                                             and utd-marking-lines.doc-id  = utd-lines.doc-id
                                             and utd-marking-lines.LineNum = utd-lines.LineNum
                                             and utd-marking-lines.doc-level = 1 
               no-lock:
                  insw:start-element ({&tag-item2}) .
                  insw:write-data-element (  "mark-code",        repSpecSimbforXlm( addBracketForCode(utd-marking-lines.mark) )         ) . 
                  if VFlagStsMark
                  then do:
                     find first marking where marking.mark eq utd-marking-lines.mark
                     no-lock no-error.
                     if available marking
                     then 
                        insw:write-data-element (  "stts",      ObjSrv:Env:marking:Sts:mark:GetKeystrDB(    marking.sts      )        ) . 
                     else
                        insw:write-data-element (  "stts",      ObjSrv:Env:marking:Sts:mark:GetKeystrDB(utd-marking-lines.sts)        ) .  
                  end.
                  else
                     insw:write-data-element (  "stts",         ObjSrv:Env:marking:Sts:mark:GetKeystrDB(utd-marking-lines.sts)        ) . 
          
                  insw:end-element ({&tag-item2}) .
               end.
               insw:end-element ({&tag-section2}) .
            end.
            insw:end-element ({&tag-item1}) .
         end.
         
         insw:end-element ({&tag-section1}) .
      end.
      insw:end-element ({&tag-edi-doc}) .
/*      insw:end-element ({&tag-edi-docs}) .*/
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
