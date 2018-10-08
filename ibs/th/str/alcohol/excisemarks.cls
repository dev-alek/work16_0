/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Класс работы с акцизными марками.

Автор: Морозов Александр Сергеевич
Дата создания: 01/30/15
Author: Alexandr Morozov
Creation date: 01/30/15

/*    and lookup (buf_gen-attr.p-key, {&delim-key}, {&free-code}) > 0*/
 entry(8, cr_gen-attr.p-key, {&delim-key}) <> {&free-code}

*/

using Progress.Lang.*.
using ibs.th.str.alcohol.*.
using ibs.th.gbl.*.

class ibs.th.str.alcohol.excisemarks : 

{ cmp/str-glbl.i class}
{ str/inv-marks-tt.i  }
{ str/marks.i         }

  define buffer buf_gen-attr for ub.gen-attr.
    
  define variable key-rec-parts as character no-undo.
  define variable key-rec       as character no-undo.
  
  define property StatusErr as logical no-undo init false
    get.
    protected set.
  
  define property ObjType as character no-undo
    get.
    protected set.

  define property ObjCode as integer no-undo
    get.
    protected set.
  
  define property ReturnMsg as character no-undo
    get.
    private set.

  define property keyRecObj as class  ibs.th.gbl.keyrec no-undo
    get.
    private set.


  constructor public excisemarks (inObjType as char, inObjCode as int):
    
    find first ub.clients where ub.clients.obj-type = inObjType and ub.clients.obj-code = inObjCode no-error.
    
    if not available (ub.clients)
    then do:
      message substitute ("Критическая ошибка. Не найден клиент &1&2. Невозможно созадние экземпляра excisemarks.", inObjType, inObjCode) view-as alert-box.
      undo, return error.
    end.
    
    assign
      ObjType = inObjType
      ObjCode = inObjCode.
    keyRecObj = new keyrec().
    
  end constructor.

  method public void GetTableMarksForPartsAppend (buffer buf_parts for ub.parts, input-output table tt-marks):
    
    if not available (buf_parts)
    then do:
      StatusErr = true.
      ReturnMsg = substitute ("Не возможно создать список марок, так как буфер записи buf_parts не доступен."). 
      return.
    end.
    
    keyRecObj:GenKeyRec ("parts", buffer buf_parts:handle, output key-rec-parts).
    
    for each buf_gen-attr where buf_gen-attr.table-name = {&excise-mark}
      and buf_gen-attr.p-key = key-rec-parts:
        
      create tt-marks.
      assign 
        tt-marks.exciseMark = buf_gen-attr.attr-code 
        tt-marks.isCurr = true
        tt-marks.partId = buf_parts.in-code
      .
      
    end.
  end.

  method public void GetTableMarksForParts (buffer buf_parts for ub.parts, input-output table tt-marks):
    
    empty temp-table tt-marks.
    
    GetTableMarksForPartsAppend (buffer buf_parts, input-output table tt-marks).
    
  end.

  method public void GetTableMarksForPartsAppend (inKeyRec as char, input-output table tt-marks):
    for each buf_gen-attr where buf_gen-attr.table-name = {&excise-mark}
      and buf_gen-attr.p-key = inKeyRec:
        
      create tt-marks.
      assign 
        tt-marks.exciseMark = buf_gen-attr.attr-code 
        tt-marks.isCurr = true
      .
      
    end.
  end.
  
  method public void GetTableMarksForParts (inKeyRec as char, input-output table tt-marks):
    
    empty temp-table tt-marks.
    
    GetTableMarksForPartsAppend (inKeyRec, input-output table tt-marks).
    
  end.

  method public void GetRowOutFreePartsForMarks (inMark as character, output outRowParts as rowid):
    
    define variable vRowId as rowid no-undo.
    define variable vTblName as character no-undo.
    
    vRowId = ?.
    
    find first buf_gen-attr exclusive-lock where buf_gen-attr.table-name = {&excise-mark}
      and buf_gen-attr.attr-code = inMark
      and num-entries (buf_gen-attr.p-key, {&delim-key}) >= 8
      and
        (entry(8, buf_gen-attr.p-key, {&delim-key}) = {&free-code} or entry(8, buf_gen-attr.p-key, {&delim-key}) = {&output-code})
      and entry(2, buf_gen-attr.p-key, {&delim-key}) = ObjType  
      and entry(3 , buf_gen-attr.p-key, {&delim-key}) = string (ObjCode)
    no-error.
    
    if available (buf_gen-attr) and buf_gen-attr.whole-send-news = 1
    then do:
      release buf_gen-attr.
      StatusErr = true.
      ReturnMsg = substitute ("Марка зарезервирована &2. &1Партия - &3", {&new-line}, inMark, key-rec-parts). 
      return.
    end.
    
    if available (buf_gen-attr)
    then do:
      keyRecObj:GenRowKeyr(buf_gen-attr.p-key, ?, "ub", ?, no-lock, output vRowId, output vTblName).
    end.
    
    
    release buf_gen-attr.
    outRowParts = vRowId.
    
  end.

  method public void RemoveFreeZone (buffer buf_parts for ub.parts, input inMark as char):
    
    keyRecObj:GenKeyRec ("parts", buffer buf_parts:handle, output key-rec-parts).
    find first buf_gen-attr exclusive-lock where buf_gen-attr.table-name = {&excise-mark}
      and buf_gen-attr.p-key = key-rec-parts no-error.
    
    find first buf_gen-attr exclusive-lock where buf_gen-attr.table-name = {&excise-mark}
      and buf_gen-attr.p-key = key-rec-parts no-error.
    if not available (buf_gen-attr)
    then do:
      StatusErr = true.
      ReturnMsg = substitute ("Ошибка при переносе марки из свободной зоны. Не найденен атрибут для марки в расходной зоне &1", inMark). 
      return.
    end.
    
    entry(8, buf_gen-attr.p-key, {&delim-key}) = buf_parts.out-code.
    release buf_gen-attr.
    
    
  end.
  
  method public void CrMarkForParts (buffer buf_parts for ub.parts, input inMark as char):
    
    keyRecObj:GenKeyRec ("parts", buffer buf_parts:handle, output key-rec-parts).
    find first buf_gen-attr exclusive-lock where buf_gen-attr.table-name = {&excise-mark}
      and buf_gen-attr.p-key = key-rec-parts no-error.

    find first buf_gen-attr where 
      buf_gen-attr.table-name = {&excise-mark}
      and buf_gen-attr.p-key = key-rec-parts 
      and buf_gen-attr.attr-code = inMark no-lock no-error.
    
    if available buf_gen-attr
    then do :
        StatusErr = false .
        ReturnMsg = substitute ("Уже есть запись с &2 маркой. &1Партия - &3", {&new-line}, inMark, key-rec-parts) .
        return .
    end.
    
    create buf_gen-attr.   
    assign
        buf_gen-attr.table-name = {&excise-mark}
        buf_gen-attr.p-key      = key-rec-parts
        buf_gen-attr.attr-code  = inMark
        buf_gen-attr.whole-send-news = 0
    .
    
  end.
  
  method public void CrMarkForInvDoc (buffer buf_trn-doc for ub.trn-doc, input inMark as char):
    
    keyRecObj:GenKeyRec ("trn-doc", buffer buf_trn-doc:handle, output key-rec).
    if error-status:error
    then do:
      StatusErr = false .
      ReturnMsg = substitute ("Ошибка формирования уникального ключа.") .
      return .
    end.
    
    find first buf_gen-attr exclusive-lock where 
      buf_gen-attr.table-name = {&excise-mark}
      and buf_gen-attr.p-key = key-rec 
      and buf_gen-attr.attr-code = inMark no-error.
    
    if available buf_gen-attr
    then do :
        StatusErr = false .
        ReturnMsg = substitute ("Уже есть запись с &2 маркой. &1Запись - &3", {&new-line}, inMark, key-rec) .
        return .
    end.
    
    create buf_gen-attr.   
    assign
        buf_gen-attr.table-name = {&excise-mark}
        buf_gen-attr.p-key      = key-rec
        buf_gen-attr.attr-code  = inMark
        buf_gen-attr.whole-send-news = 0
    .
    
  end.
  
  method public void GetMarkForInvDoc (inKeyRec as char, input inAlcCode as char, input-output table tt-marks):
    
    def var v-key-rec-doc as char no-undo.
    def var v-doc-code as char no-undo.
    
    empty temp-table tt-marks.
    
    assign
      v-doc-code = entry(8, inKeyRec, {&delim-key}) when num-entries (inKeyRec, {&delim-key}) >= 8.
    
    find first ub.trn-doc no-lock where ub.trn-doc.doc-code = v-doc-code no-error.
    
    if available (ub.trn-doc)
       then keyRecObj:GenKeyRec("trn-doc", buffer ub.trn-doc:handle, v-key-rec-doc).
    
    for each buf_gen-attr exclusive-lock where 
      buf_gen-attr.table-name = {&excise-mark}
      and buf_gen-attr.p-key = v-key-rec-doc:
      
      if GetAlcCode (entry (2, buf_gen-attr.attr-code)) = inAlcCode
      then do:
        create tt-marks.
        assign
          tt-marks.alc-code = inAlcCode
          tt-marks.exciseMark = entry (2, buf_gen-attr.attr-code)
          tt-marks.gds-code = integer (entry (1, buf_gen-attr.attr-code))
        .
      end.
    
    end.
    
  end.
  
  method public void RestoreMarkToFreeZone (buffer buf_parts for ub.parts, input inMark as char):
    
    
    keyRecObj:GenKeyRec ("parts", buffer buf_parts:handle, output key-rec-parts).
    find first buf_gen-attr exclusive-lock where 
      buf_gen-attr.table-name = {&excise-mark}
      and buf_gen-attr.p-key = key-rec-parts 
      and buf_gen-attr.attr-code = inMark no-error.
    
    find first buf_gen-attr exclusive-lock where buf_gen-attr.table-name = {&excise-mark}
      and buf_gen-attr.p-key = key-rec-parts no-error.
    if not available (buf_gen-attr)
    then do:
      StatusErr = true.
      ReturnMsg = substitute ("Ошибка при восстановление марки в свободную зону. Не найденен атрибут для марки приходной партии &1", inMark). 
      return.
    end.
    
    entry(8, buf_gen-attr.p-key, {&delim-key}) = {&free-code}.
    release buf_gen-attr.
    
    
    
  end.
  
  
  method public void RemoveMarkFromFreeZoneToInvMinus (inKeyRec as char, input inMark as char, inDocCodeInv as char):
    
    define buffer buf_invMinus for ub.parts.
    
    find first buf_gen-attr exclusive-lock where 
      buf_gen-attr.table-name = {&excise-mark}
      and buf_gen-attr.p-key = inKeyRec
      and buf_gen-attr.attr-code = inMark no-error.
    
    
    
    find first buf_gen-attr exclusive-lock where buf_gen-attr.table-name = {&excise-mark}
      and buf_gen-attr.p-key = key-rec-parts no-error.
    if not available (buf_gen-attr)
    then do:
      StatusErr = true.
      ReturnMsg = substitute ("Ошибка при удалении марки со свободной зоны. Не найденен атрибут для марки партии свободной зоны &1", inMark). 
      return.
    end.
    
    if num-entries ( inKeyRec, {&delim-key}) < 8
    then do:
      StatusErr = true.
      ReturnMsg = substitute ("Неверный ключ партии &1", inKeyRec). 
      return.
    end.
    
    find first buf_invMinus where
            buf_invMinus.obj-type = ObjType
        and buf_invMinus.obj-code = ObjCode
        and buf_invMinus.artic = entry(8, inKeyRec, {&delim-key}) 
        and buf_invMinus.prod-type = entry(8, inKeyRec, {&delim-key}) 
        and buf_invMinus.prod-code = integer (entry(8, inKeyRec, {&delim-key})) 
        and buf_invMinus.out-code = inDocCodeInv
        and buf_invMinus.in-code = entry(8, inKeyRec, {&delim-key})  no-error.
    
    if not available (buf_invMinus)
    then do:
      StatusErr = true.
      ReturnMsg = substitute ("Не найдена партия инветаризации &1", inMark). 
      return.
    end.
    
    entry(8, buf_gen-attr.p-key, {&delim-key}) = buf_invMinus.out-code.
    release buf_gen-attr.
    
  end.
  
  method public void RemoveMarkFromFreeZoneToInvMinus (buffer buf_parts for ub.parts, input inMark as char, inDocCodeInv as char):
    
    keyRecObj:GenKeyRec ("parts", buffer buf_parts:handle, output key-rec-parts).
    RemoveMarkFromFreeZoneToInvMinus (key-rec-parts, inMark, inDocCodeInv).

  end.
  
  method public character GetAlcCode (
    input  inMarkAlc as character):
    define variable v-kol      as integer   no-undo .
    define variable v-alc-code as character no-undo .
    define variable v-result   as character no-undo .
    define variable ii         as integer   no-undo .  
    define variable v_list     as character no-undo initial '':U.
    assign 
      v_list = '0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,':U .

    v-alc-code = substring (inMarkAlc, 8, 12) .
    /*проверка на русские буквы*/
    do ii = 1 to length (v-alc-code):
      if lookup( substring( v-alc-code, ii, 1 ), v_list )  < 1 then
      do:
        StatusErr = yes .
        leave .
      
      end.
    end.
    v-alc-code = string (Base2Int64 (v-alc-code, 36) ) no-error.
    if (Base2Int64 (v-alc-code, 36) ) < 0 then 
    do:
      StatusErr = yes.
      return "".
    end.
    else 
    do:
      if length(v-alc-code) < 20 then 
      do:
        v-alc-code = fill('0', 19 - length(v-alc-code)) + v-alc-code.
      end.
      return v-alc-code. 
    end.
  
  end.
  
  method private int64 Base2Int64
    (p-num as character, 
    p-base as integer
    ): 
  
    define variable v_list as character no-undo initial '':U.
    define variable jj     as integer   no-undo.
    define variable j_sign as int64     no-undo.
    define variable v-int  as int64     no-undo.
  
    do on error undo, return error :
      if p-base > 60 then 
      do:
        assign 
          v-int = ?.
        undo, return error.
      end.
      assign 
        v_list = '0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,':U +
                      'Б,Г,Д,Ё,Ж,З,И,Й,Л,П,У,Ф,Ц,Ч,Ш,Щ,Ъ,Ы,Ь,Э,Ю,Я,@,$':U
        v_list = substring( v_list, 1, p-base * 2 - 1 )
        p-num  = trim( p-num ).
      if substring( p-num, 1, 1 ) = "-" then 
      do:
        assign 
          j_sign = -1
          p-num  = substring( p-num, 2 ).
      end.                              
      else 
      do: 
        assign 
          j_sign = 1. 
      end.
      do jj = 1 to length( p-num ) :
        assign 
          v-int = v-int * p-base + LOOKUP( substring( p-num, jj, 1 ), v_list ) - 1.
      end.
      assign 
        v-int = j_sign * v-int.
      return v-int.
    end. /* ON ERROR */
  end method. /* conv-base-to-int64 */
  
  destructor public excisemarks ():
    
    delete object keyRecObj.
    
  end destructor.
  

end class.