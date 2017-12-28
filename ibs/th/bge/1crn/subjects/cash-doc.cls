/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Экспорт сообщения с накладаной в 1С ERPRN cash-doc

Автор: Елена Шкляр
Дата создания: 26/09/17
Author: Shklyar Elena
Creation date: 26/09/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.*.

class ibs.th.bge.1crn.subjects.cash-doc implements iexpsubject:

  
  { cmp/str-glbl.i class }
  
  define buffer buf_fin-doc       for ub.fin-doc .
  define buffer buf_fin-doc-tax   for ub.fin-doc-tax .
  define buffer buf_c-fin-doc     for ub.c-fin-doc .
  define buffer buf_c-fin-doc-tax for ub.c-fin-doc-tax .
  
  define temp-table tt-fin-doc like ub.c-fin-doc .
  define temp-table tt-fin-doc-tax like ub.c-fin-doc-tax .

  define property Msg as character no-undo
    get.
    private set.

  define property InitSecTag as character no-undo init "cash"
    get.
    private set.
      
  define property fin-doc as character no-undo
    get.
    set.

  define property del_f  as integer no-undo
    get.
    set.

  define variable sw     as handle    no-undo.
  define variable v-type as character no-undo .

  method public void CrContentToSW (insw as handle):
    
    sw = insw .    

    find first buf_fin-doc no-lock where buf_fin-doc.fin-doc-code = INTEGER (fin-doc) no-error .
    if AVAILABLE buf_fin-doc then 
    do:
      create tt-fin-doc .
      BUFFER-COPY buf_fin-doc to tt-fin-doc .
      for each buf_fin-doc-tax no-lock where buf_fin-doc-tax.fin-doc-code = buf_fin-doc.fin-doc-code:
        create tt-fin-doc-tax .
        BUFFER-COPY buf_fin-doc-tax to tt-fin-doc-tax .
      end.  
    end.
    else 
    do:
      find FIRST buf_c-fin-doc no-lock where buf_c-fin-doc.fin-doc-code = INTEGER (fin-doc) no-error .
      if AVAILABLE buf_c-fin-doc then 
      do:
        create tt-fin-doc .
        BUFFER-COPY buf_c-fin-doc to tt-fin-doc .
        for each buf_c-fin-doc-tax no-lock where buf_c-fin-doc-tax.fin-doc-code = buf_c-fin-doc.fin-doc-code:
          create tt-fin-doc-tax .
          BUFFER-COPY buf_c-fin-doc-tax to tt-fin-doc-tax .
        end.  
      end.
      else 
      do:
        Msg = "Нет финансового документа с номером" + fin-doc .
        return error.
      end.
    
    end.    
    
    case tt-fin-doc.fin-doc-type:
      when {&income-cash} then 
        v-type = "1".
      when {&expense-cash} then 
        v-type = "2".
      when ? then 
        v-type = "".   
    end.  
    
    /*      sw:start-element ("cash-doc") .*/
    sw:start-element ("cash-doc") .
    sw:write-data-element ("doc-code", string-mth(tt-fin-doc.fin-doc-code)).
    sw:write-data-element ("num", if tt-fin-doc.prn-doc-code = ? then "" else string(tt-fin-doc.prn-doc-code)).
    sw:write-data-element ("del-f", string(del_f)).
    sw:write-data-element ("date", if tt-fin-doc.doc-date = ? then "" else ISO-DATE (tt-fin-doc.doc-date)).
    sw:write-data-element ("shift-date", if tt-fin-doc.shift-date = ? then "" else ISO-DATE (tt-fin-doc.shift-date)).
    sw:write-data-element ("shift-num", string-mth(tt-fin-doc.shift-num)).
    sw:write-data-element ("type", v-type).
    sw:write-data-element ("sum", string-mth(tt-fin-doc.sum-doc)).
    if v-type = "1" then 
    do:
      sw:write-data-element ("contr-name", if tt-fin-doc.payer-name = ? then "" else string(tt-fin-doc.payer-name)).
      sw:write-data-element ("contr-code", string-mth(tt-fin-doc.payer-code)).
    end.
    else 
    do:
      sw:write-data-element ("contr-name", if tt-fin-doc.receiver-name = ? then "" else string(tt-fin-doc.receiver-name)).
      sw:write-data-element ("contr-code", string-mth(tt-fin-doc.receiver-code)).
    end.    
    sw:write-data-element ("doc-osn", if tt-fin-doc.naznach-plat = ? then "" else string(tt-fin-doc.naznach-plat)).
    sw:write-data-element ("idty-doc", if tt-fin-doc.payer-dop1 = ? then "" else string(tt-fin-doc.receiver-passport)).
      
    sw:start-element ("ndss") .
    for each tt-fin-doc-tax no-lock where tt-fin-doc-tax.fin-doc-code = tt-fin-doc.fin-doc-code:
      sw:start-element ("nds") .
      sw:write-data-element ("sum", string-mth(tt-fin-doc-tax.sum-line-doc)).
      sw:write-data-element ("nds-code", string-mth(tt-fin-doc-tax.vat-pc)).
      sw:write-data-element ("sum-nds", string-mth(tt-fin-doc-tax.sum-vat-line-doc)).
      sw:end-element ("nds") .
    end.
    sw:end-element ("ndss")  .  
    sw:END-ELEMENT ("cash-doc") .  
    
  end.
  
  method private character string-mth (inValue as decimal):
    
    def var v-str as character no-undo.
    
    if inValue = ?
      then v-str = "0".
    
    if string (inValue) begins "."
      then v-str = "0" + string (inValue).
    else v-str = string (inValue).
    return v-str.
    
  end.
end class.