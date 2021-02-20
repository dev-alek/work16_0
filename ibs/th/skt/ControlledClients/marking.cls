 
/*------------------------------------------------------------------------
   File        : marking
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : asmorozov
   Created     : Mon Mar 16 16:41:03 MSK 2020
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.skt.ControlledClients.marking.sts.cash.
using ibs.th.skt.Adapters.LogWrite.
using ibs.th.gbl.propmap.
using ibs.th.gbl.sys.objsrv.
using ibs.th.gbl.sys.objth.



class ibs.th.skt.ControlledClients.marking inherits objth: 

  {cmp\str-glbl.i class}
  
  define private variable logWrite as class LogWrite no-undo.

  define public property SomeStr as longchar no-undo /* сюда писать если что-то отправить*/
    get.
    set.

  constructor public marking (  ):
    super ().
    logWrite = new LogWrite().
     
  end.
  
  method public void hndler (req as class ibs.th.skt.Commands.SimpleRequest):
    define variable vLC       as longchar  no-undo.
    define variable ii        as integer   no-undo.
    define variable n         as integer   no-undo.
    define variable cash      as character no-undo.
    define variable shift_id  as character no-undo.
    define variable chk_id    as character no-undo.
    define variable cntx_id   as character no-undo.
    define variable mark      as character no-undo.
    define variable mark-short as character no-undo.
    define variable action    as character no-undo.
    define variable par       as character no-undo.
    define variable val       as character no-undo.
    define variable cashSts   as class     cash                        no-undo.
    define variable thMarkSts as class     ibs.th.str.marking.sts.mark no-undo.
    define variable shift_tbeg as date no-undo.
    define variable shift_num  as integer no-undo.
    
    define buffer buf_marking for ub.marking.
    define buffer buf_marking-attr for ub.marking-attr.
    define buffer buf_marking-l for ub.marking-lines.
    
    cashSts =  new cash().
  
    thMarkSts = ObjSrv:Env:Marking:Sts:Mark.
    
    fix-codepage(vLC) = "UTF-8".
  
    LogWrite:LogStr = substitute("Авторизация маркированной продукции &1",
      req:QueryPar).
  
    n = num-entries (req:QueryPar, "&").
/*    if n ne 4 and n ne 3                                                         */
/*      then                                                                       */
/*    do:                                                                          */
/*      vLC = chr(123) + '"server_error":"Неверные параметры запроса."' + chr(125).*/
/*      sendContent(vLC).                                                          */
/*      return.                                                                    */
/*    end.                                                                         */
    do ii = 1 to n:
      assign
        par = entry (1, entry (ii, req:QueryPar, "&"), "=")
        val = entry (2, entry (ii, req:QueryPar, "&"), "=")
    no-error.
      if error-status:error
        then 
      do:
        vLC = chr(123) + '"server_error":"Неверные параметры запроса."' + chr(125).
        sendContent(vLC).
        return.        
      end.
      case par:
        when "cash" then 
          do:
            cash = val.
          end.
        when "shift_id" then 
          do:
            shift_id = val.
          end.
        when "check" then 
          do:
            chk_id = val.
          end.
        when "mark" then 
          do:
            mark = percentDecoding (val).
          end.
        when "context" then 
          do:
            cntx_id = val.
          end.
        when "set" then 
          do:
            if lookup (val,"unlock,sale_lock,return_lock,commit") = 0
              then 
            do:
              vLC = chr(123) + substitute('"server_error":"Неверный тип &1 параметра set."', val) + chr(125).
              sendContent(vLC).
              return.
            end. 
            action = val.
          end.
        when "shift_tbeg" then 
          do:
            shift_tbeg = date (integer (substring (val, 03, 2)), integer (substring (val, 01, 2)), integer (substring (val, 05, 4))) no-error.
          end.
        when "shift_num" then 
          do:
            shift_num = int (val) no-error.
          end.
        otherwise 
        do:
/*          vLC = chr(123) + substitute('"server_error":"Неверный параметр &1 запроса."', par) + chr(125).*/
/*          sendContent(vLC).                                                                             */
/*          return.                                                                                       */
        end.
      end case.
    end.
    if cash = "" or action = "" or cntx_id = ""
      then 
    do:
      vLC = chr(123) + substitute('"server_error":"Неверные параметры запроса."') + chr(125).
      sendContent(vLC).
      return.
    end.
    
    if mark = "" then do:
      case action:
      when cashSts:Commit:NameProp then 
      do:
        def var jj as int no-undo.
        for each buf_marking where buf_marking.loc-key = "cash:" +  cash + ":" + "context:" + cntx_id:
          buf_marking.loc-key = "cash:" +  cash + ":" + "context:" + cntx_id + ":" + "chk_num:" + chk_id.
          case buf_marking.sts:
          when thMarkSts:SaleWaitLock:KeyIntDB then
          do:
            buf_marking.sts = thMarkSts:SaleLock:KeyIntDB.
          end.
          when thMarkSts:ReturnWaitLock:KeyIntDB then 
          do:
            buf_marking.sts = thMarkSts:ReturnLock:KeyIntDB.
          end.
          end case.
          jj = jj + 1.
          if shift_tbeg ne ?
          then do:
            find first buf_marking-attr where buf_marking-attr.mark = buf_marking.mark and buf_marking-attr.attr-code = "shift-date" no-error.
            if not available buf_marking-attr
            then do:
              create buf_marking-attr.
              buf_marking-attr.mark = buf_marking.mark.
              buf_marking-attr.attr-code = "shift-date".
            end.
            buf_marking-attr.attr-value = string (shift_tbeg).
          end.
          if shift_num ne ?
          then do:
            find first buf_marking-attr where buf_marking-attr.mark = buf_marking.mark and buf_marking-attr.attr-code = "shift-num" no-error.
            if not available buf_marking-attr
            then do:
              create buf_marking-attr.
              buf_marking-attr.mark = buf_marking.mark.
              buf_marking-attr.attr-code = "shift-num".
            end.
            buf_marking-attr.attr-value = string (shift_num).
          end.
        end.
        if jj = 0
        then vLC = getJson(0, "По данной кассе не было маркированого товара", mark).
        else vLC = getJson(1, cashSts:Commit:Label_ + " Зарезервировано кол-во " + string (jj), mark).
        sendContent(vLC).
        return.
      end.
      when cashSts:Unlock:NameProp then 
      do:
        for each buf_marking where buf_marking.loc-key begins "cash:" +  cash:
          buf_marking.loc-key = "".
          case buf_marking.sts:
          when thMarkSts:SaleWaitLock:KeyIntDB then
          do:
            if can-find (first buf_marking-l no-lock where buf_marking-l.out-code = {&free-code} and buf_marking-l.mark = buf_marking.mark )
              then buf_marking.sts = thMarkSts:FreeZone:KeyIntDB.
              else buf_marking.sts = thMarkSts:ReturnLock:KeyIntDB.
          end.
          when thMarkSts:ReturnWaitLock:KeyIntDB then 
          do:
            if can-find (first buf_marking-l no-lock where buf_marking-l.out-code = {&output-code} and buf_marking-l.mark = buf_marking.mark )
              then buf_marking.sts = thMarkSts:OutZone:KeyIntDB.
              else buf_marking.sts = thMarkSts:SaleLock:KeyIntDB.
          end.
          end case.
          if shift_tbeg ne ?
          then do:
            find first buf_marking-attr where buf_marking-attr.mark = buf_marking.mark and buf_marking-attr.attr-code = "shift-date" no-error.
            if not available buf_marking-attr
            then do:
              create buf_marking-attr.
              buf_marking-attr.mark = buf_marking.mark.
              buf_marking-attr.attr-code = "shift-date".
            end.
            buf_marking-attr.attr-value = string (shift_tbeg).
          end.
          if shift_num ne ?
          then do:
            find first buf_marking-attr where buf_marking-attr.mark = buf_marking.mark and buf_marking-attr.attr-code = "shift-num" no-error.
            if not available buf_marking-attr
            then do:
              create buf_marking-attr.
              buf_marking-attr.mark = buf_marking.mark.
              buf_marking-attr.attr-code = "shift-num".
            end.
            buf_marking-attr.attr-value = string (shift_num).
          end.
        end.
        vLC = getJson(1, cashSts:UnlockAll:Label_, mark).
        sendContent(vLC).
        return.
      end.
      otherwise do:
        vLC = chr(123) + substitute('"server_error":"Неверные параметры запроса. Не указана марка."') + chr(125).
        sendContent(vLC).
        return.
      end.
      end case.
    end.

    mark-short = GetCodeIdent(mark).
    
    find first buf_marking exclusive-lock where (buf_marking.mark begins mark or buf_marking.mark begins mark-short) no-error.
    if not available (buf_marking)
      then 
    do:
      case true:
      when action = cashSts:SaleLock:NameProp then
      do:
        vLC = getJson(0, cashSts:NotAccessible:Label_, mark).
      end.
      when action = cashSts:ReturnLock:NameProp then 
      do:
        vLC = getJson(0, cashSts:NotAccessibleRet:Label_, mark).
      end.
      end case.
      
      sendContent(vLC).
      return.
    end.
    
    
/*    def var is-curr-cntx as logical no-undo init false.                  */
/*    if buf_marking.loc-key = "cash:" +  cash + ":" + "context:" + cntx_id*/
/*      then is-curr-cntx = true.                                          */

    if (buf_marking.sts = thMarkSts:SaleWaitLock:KeyIntDB or buf_marking.sts = thMarkSts:ReturnWaitLock:KeyIntDB)
      and buf_marking.loc-key begins "cash" and not buf_marking.loc-key begins "cash:" + cash
    then do:
      vLC = getJson(0, substitute ("&1 на кассе - &2 ", thMarkSts:GetLabel(buf_marking.sts), cash), mark).
      sendContent(vLC).
      return.      
    end.

    case true:
    when action = cashSts:SaleLock:NameProp and
      (buf_marking.sts = thMarkSts:FreeZone:KeyIntDB
      or buf_marking.sts = thMarkSts:ReturnLock:KeyIntDB)
    then do:
      buf_marking.loc-key = "cash:" +  cash + ":" + "context:" + cntx_id.
      buf_marking.sts = thMarkSts:SaleWaitLock:KeyIntDB.
      vLC = getJson(1, cashSts:SaleLock:Label_, buf_marking.mark).
      ObjSrv:Lib:MarkingTree:UnGroupMark(buf_marking.mark).
      ObjSrv:Lib:MarkingTree:LockChkChildeMark(buffer buf_marking).
    end.
    when action = cashSts:ReturnLock:NameProp and
      (buf_marking.sts = thMarkSts:OutZone:KeyIntDB
      or buf_marking.sts = thMarkSts:SaleLock:KeyIntDB)
    then do:
      buf_marking.loc-key = "cash:" +  cash + ":" + "context:" + cntx_id.
      buf_marking.sts = thMarkSts:ReturnWaitLock:KeyIntDB.
      vLC = getJson(1, cashSts:ReturnLock:Label_, buf_marking.mark).
      ObjSrv:Lib:MarkingTree:UnGroupMark(buf_marking.mark).
      ObjSrv:Lib:MarkingTree:LockChkChildeMark(buffer buf_marking).
    end.

    when action = cashSts:Unlock:NameProp then 
    do:
      if buf_marking.loc-key begins "cash:" + cash
      then do:
        
      
        buf_marking.loc-key = "".
        case buf_marking.sts:
        when thMarkSts:SaleWaitLock:KeyIntDB then
        do:
          if can-find (first buf_marking-l no-lock where buf_marking-l.out-code = {&free-code} and buf_marking-l.mark = buf_marking.mark )
            then buf_marking.sts = thMarkSts:FreeZone:KeyIntDB.
            else buf_marking.sts = thMarkSts:ReturnLock:KeyIntDB.
        end.
        when thMarkSts:ReturnWaitLock:KeyIntDB then 
        do:
          if can-find (first buf_marking-l no-lock where buf_marking-l.out-code = {&output-code} and buf_marking-l.mark = buf_marking.mark )
            then buf_marking.sts = thMarkSts:OutZone:KeyIntDB.
            else buf_marking.sts = thMarkSts:SaleLock:KeyIntDB.
        end.
        end case.
        vLC = getJson(1, cashSts:Unlock:Label_, buf_marking.mark).
      end.
      else do:
        vLC = getJson(0, substitute ("Невозможно разблокировать маркированный товар. Статус маркировки - &1. ", thMarkSts:GetProp(buf_marking.sts):Label_), mark).
      end.
    end.
    otherwise do:
      vLC = getJson(0, substitute ("Операция невозможна. Статус маркировки - &1. &2 ", thMarkSts:GetProp(buf_marking.sts):Label_,
                                   (if buf_marking.sts ne thMarkSts:Checked_:KeyIntDB then "" else "Товар не поступил в продажу.")),
                                   mark).
    end.
    end case.
    
    
  
    sendContent(vLC).

  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public character percentDecoding(encode-str as char):
    def var ii         as int.
    def var decode-str as char.
    def var entry-str  as char.
    decode-str = entry (1, encode-str, "%").
    do ii = 2 to num-entries (encode-str,"%"):
      entry-str = entry (ii, encode-str, "%").
      decode-str = decode-str + string (hex-decode (substring (entry-str, 1, 2))) + substring (entry-str, 3, length (entry-str)).
    end.      
    return decode-str.
  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method private void sendContent(inLC as longchar):
    define variable v-cont-length as integer no-undo.
    v-cont-length = length(inLC,"RAW":U).
    SomeStr = substitute("HTTP/1.1 200 OK&1Server: 4GL&1Content-Type: text/html; charset=UTF-8&1Content-Length: &3&2&4",chr(13) + chr(10),chr(13) + chr(10) + chr(13) + chr(10),string(v-cont-length),inLC).
    return.
  end method.

  method private character getJson(stsInt as int, msg as char, mark as char):
    def var json-str as char no-undo.
    mark = replace (mark, '\', '\\').
    mark = replace (mark, '"', '\"').
    json-str = chr(123) + substitute ('"status":&1,"comment":"&2"', stsInt, msg) + chr(125).
    return json-str.
  end.

  {utl/gtin.i class}

end class.
