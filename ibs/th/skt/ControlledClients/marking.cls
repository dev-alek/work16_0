/*
$Revision:$
$Author:$
$Date:$
$Workfile:$
$Archive:$

Автор: Рубан Дмитрий Андреевич 
Дата создания: 16 мая 2022 г.
Author:  Ruban Dmitriy Andreevich
Creation date: 16 мая 2022 г.
Modified: Rostovtsev Aleksandr 03/07/2023

*/

using Progress.Lang.*.
using ibs.th.skt.ControlledClients.marking.sts.cash.
using ibs.th.skt.Adapters.LogWrite.
using ibs.th.gbl.propmap.
using ibs.th.gbl.sys.objsrv.
using ibs.th.gbl.sys.objth.



class ibs.th.skt.ControlledClients.marking inherits objth: 
  define override public property vss-revision    as character no-undo init "$Revision:$":U get .
  define override public property vss-author      as character no-undo init "$Author:$":U get.
  define override public property vss-date        as character no-undo init "$Date:$":U get.
  define override public property vss-workfile    as character no-undo init "$Workfile:$":U get.
  define override public property vss-archive     as character no-undo init "$Archive:$":U get.
  define override public property vss-description as character no-undo init "Обработчик запросов по маркам с кассы" get.

  {cmp\str-glbl.i class}
  define private variable logWrite   as class LogWrite no-undo.
  define private variable cashSts    as class cash     no-undo.
  define private variable answerFlag as logical        no-undo init false.
  define private variable thMarkSts  as class ibs.th.str.marking.sts.mark no-undo.
  define private variable EDOParSec as class ibs.th.gbl.env.prmtrs.edo .

  define private variable cash      as character no-undo.
  define private variable shift_id  as character no-undo.
  define private variable chk_id    as character no-undo.
  define private variable cntx_id   as character no-undo.
  define private variable mark      as character no-undo.
  define private variable action    as character no-undo.
  define private variable shift_tbeg as date no-undo.
  define private variable shift_num  as integer no-undo.

  define public property SomeStr as longchar no-undo /* сюда писать если что-то отправить*/
    get.
    set.

  {utl/gtin.i class}

  constructor public marking (  ):
    super ().
    logWrite = new LogWrite().
  end.

  method public void hndler (req as class ibs.th.skt.Commands.iRequest):
    define variable vLC       as longchar  no-undo.
    define variable ii        as integer   no-undo.
    define variable n         as integer   no-undo.
    define variable mark-short as character no-undo.
    define variable par       as character no-undo.
    define variable val       as character no-undo.
    define variable km        as character no-undo.

    define buffer buf_marking for ub.marking.
    define buffer buf_marking-l for ub.marking-lines.

    define variable newSts    as integer   no-undo.
    define variable obj-code  as integer no-undo. 
    define variable gdsCode   as integer no-undo. 
    define variable canSaleReturnedGoods as logical no-undo init false.
    
    define variable listActions           as character no-undo.
    define variable listActionsByMark     as character no-undo.
    define variable listActionsUnlock     as character no-undo.
    define variable listStatusesForSale   as character no-undo.
    define variable listStatusesForSaleWithReturn as character no-undo.
    define variable listStatusesForReturn as character no-undo.

    cashSts =  new cash().

    thMarkSts = ObjSrv:Env:Marking:Sts:Mark.

    fix-codepage(vLC) = "UTF-8".

    LogWrite:LogStr = substitute("Авторизация маркированной продукции &1",
      req:QueryPar).

    assign
      listActionsByMark = substitute("&1,&2", 
        cashSts:SaleLock:NameProp, 
        cashSts:ReturnLock:NameProp 
      )
      listActionsUnlock = cashSts:Unlock:NameProp
      listActions = substitute("&1,&2,&3,&4", 
        listActionsByMark, 
        listActionsUnlock,
        cashSts:UnlockAll:NameProp,
        cashSts:Commit:NameProp
      )
    .

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
            if lookup (val,listActions) = 0
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
      end case.
    end.
    if cash = "" or action = ""
      then 
    do:
      vLC = chr(123) + substitute('"server_error":"Неверные параметры запроса."') + chr(125).
      sendContent(vLC).
      return.
    end.

    /* получаем по номеру кассы номер магазина */
    /* TODO: обработать привязку к разным магазинам касс с одинаковым номером */
    obj-code = getObject(integer(cash)).
    if obj-code = ? then
    do:
      vLC = chr(123) + substitute('"server_error":"Не удалось определить магазин по кассе &1."', cash) + chr(125).
      sendContent(vLC).
      return.
    end.
    EDOParSec = ObjSrv:Env:ParametrsOfSection:GetSectionEDO("маг", obj-code).

    case true:
      when can-do(listActionsByMark,action) or (can-do(listActionsUnlock,action) and mark <> "") then 
      do:            /* действие по марке */
        if mark = "" then do:
          vLC = chr(123) + substitute('"server_error":"Неверные параметры запроса. Не заполнен mark."') + chr(125).
          sendContent(vLC).
          return.
        end.
  
        mark-short = GetCodeIdent(mark).
  
        find first buf_marking exclusive-lock where (buf_marking.mark begins mark or buf_marking.mark begins mark-short) no-error.
        if not available (buf_marking) then 
        do:      /* марка не найдена в БД TH */
          case action:
            when cashSts:SaleLock:NameProp then
            do:
              createMark(mark-short, buffer buf_marking).
              if available buf_marking then 
                answerFlag = true.
              vLC = setMarkStatus (
                thMarkSts:SaleWaitLock:KeyIntDB, 
                "cash:" +  cash + ":" + "context:" + cntx_id,
                cashSts:SaleLock:Label_,
                cashSts:NotAccessible:Label_,
                buffer buf_marking).
            end.
            when cashSts:ReturnLock:NameProp then 
            do:
              createMark(mark-short, buffer buf_marking).
              if available buf_marking then 
                answerFlag = true.
              vLC = setMarkStatus (
                thMarkSts:ReturnWaitLock:KeyIntDB, 
                "cash:" +  cash + ":" + "context:" + cntx_id,
                cashSts:ReturnLock:Label_,
                cashSts:NotAccessibleRet:Label_,
                buffer buf_marking).
            end.
            otherwise 
            do:
              vLC = getJson(0, "Операция невозможна. Марка не найдена.", mark).
            end.
          end case.
        end.
        else 
        do:      /* марка найдена */
          if (action = cashSts:SaleLock:NameProp or action = cashSts:ReturnLock:NameProp) 
             and (buf_marking.sts = thMarkSts:SaleWaitLock:KeyIntDB or buf_marking.sts = thMarkSts:ReturnWaitLock:KeyIntDB)
             and buf_marking.loc-key begins "cash"
          then do:
            /* марка уже заблокирована для продажи или возврата */
            vLC = getJson(0, substitute (
              "Операция невозможна. Статус марки - &1 на кассе &2", 
              thMarkSts:GetLabel(buf_marking.sts), 
              trim(entry(2, buf_marking.loc-key, ":"))), 
              mark
            ).
            sendContent(vLC).
            return.
          end.

          /* получаем тип марки и определяем значение параметра «Разрешена продажа возвращенных товаров» по типу */
          ChekTypeMarkByDm(mark).
          if mTypeMark <> "" then
            canSaleReturnedGoods = EDOParSec:GetIsSaleReturnForType(mTypeMark).
  
          assign
            listStatusesForSale = substitute("&1,&2",thMarkSts:Checked_:KeyIntDB,thMarkSts:FreeZone:KeyIntDB)
            listStatusesForSaleWithReturn = substitute("&1,&2",listStatusesForSale,thMarkSts:ReturnLock:KeyIntDB)
            listStatusesForReturn = substitute("&1,&2",listStatusesForSale,thMarkSts:SaleLock:KeyIntDB)
          .
  
          case action:
            when cashSts:SaleLock:NameProp then 
            do:
              if can-do(
                if canSaleReturnedGoods then listStatusesForSaleWithReturn else listStatusesForSale, 
                string(buf_marking.sts) 
              ) then 
              do:
                answerFlag = true.
              end.
              vLC = setMarkStatus (
                thMarkSts:SaleWaitLock:KeyIntDB, 
                "cash:" +  cash + ":" + "context:" + cntx_id,
                cashSts:SaleLock:Label_,
                substitute ("Операция невозможна. Статус марки - &1.", thMarkSts:GetProp(buf_marking.sts):Label_),
                buffer buf_marking).
            end.
            when cashSts:ReturnLock:NameProp then 
            do: 
              if can-do(listStatusesForReturn, string(buf_marking.sts)) then 
              do:
                answerFlag = true.
              end.
              vLC = setMarkStatus (
                thMarkSts:ReturnWaitLock:KeyIntDB, 
                "cash:" +  cash + ":" + "context:" + cntx_id,
                cashSts:ReturnLock:Label_,
                substitute ("Операция невозможна. Статус марки - &1.", thMarkSts:GetProp(buf_marking.sts):Label_),
                buffer buf_marking).
            end.
            when cashSts:Unlock:NameProp then 
            do:
              if buf_marking.loc-key = "" or buf_marking.loc-key begins "cash:" + cash
              then do:
                answerFlag = true.
                vLC = setMarkStatus (
                  if buf_marking.sts = thMarkSts:SaleWaitLock:KeyIntDB then thMarkSts:FreeZone:KeyIntDB else thMarkSts:SaleLock:KeyIntDB,
                  "",
                  cashSts:Unlock:Label_,
                  substitute ("Операция невозможна. Статус марки - &1.", thMarkSts:GetProp(buf_marking.sts):Label_),
                  buffer buf_marking).
              end.
              else do:
                vLC = getJson(0, substitute ("Операция невозможна. Статус марки - &1.", thMarkSts:GetProp(buf_marking.sts):Label_), mark).
              end.
            end.
          end case.
        end.             /* марка найдена */
      end.
      when can-do(listActionsUnlock,action) and mark = "" then
      do:
        answerFlag = true.
        if cntx_id = "" then
          vLC = unlockMarks("cash:" +  cash).
        else
          vLC = unlockMarks("cash:" +  cash + ":" + "context:" + cntx_id).
      end.
      when action = cashSts:Commit:NameProp then 
      do:
        answerFlag = true.
        vLC = commitCheck().
      end.
      when action = cashSts:UnlockAll:NameProp then 
      do:
        answerFlag = true.
        vLC = unlockMarks("cash:" +  cash).
      end.
    end case.
    sendContent(vLC).
    return.
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
      decode-str = decode-str + (if entry-str <> "" then string (hex-decode (substring (entry-str, 1, 2))) + substring (entry-str, 3, length (entry-str)) else "%").
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

  method private character setMarkStatus (
    state as integer, 
    loc-key as character, 
    msgOk   as character, 
    msgError as character, 
    buffer buf_marking for ub.marking
  ):
    if answerFlag then 
    do:
      assign  
        buf_marking.loc-key = loc-key
        buf_marking.sts = state
        buf_marking.last-change = now
      .
      ObjSrv:Lib:MarkingTree:UnGroupMark(buf_marking.mark).
      ObjSrv:Lib:MarkingTree:LockChkChildeMark(buf_marking.mark).
      return getJson(1, msgOk , buf_marking.mark).
    end.
    return getJson(0, msgError, buf_marking.mark).
  end method.

  method private void createMark (
    mark as character, 
    buffer buf_marking for ub.marking
  ):
    create buf_marking.
    assign 
      buf_marking.mark    = mark
      buf_marking.sts     = thMarkSts:FreeZone:KeyIntDB
    .
  end method.

  method private void setShift (
    mark as character, 
    shiftBeg as date,
    shiftNum as integer
  ):
    define buffer buf_marking-attr for ub.marking-attr.

    if shiftBeg ne ?
    then do:
      find first buf_marking-attr where buf_marking-attr.mark = mark and buf_marking-attr.attr-code = "shift-date" no-error.
      if not available buf_marking-attr
      then do:
        create buf_marking-attr.
        buf_marking-attr.mark = mark.
        buf_marking-attr.attr-code = "shift-date".
      end.
      buf_marking-attr.attr-value = string (shiftBeg).
    end.
    if shiftNum ne ?
    then do:
      find first buf_marking-attr where buf_marking-attr.mark = mark and buf_marking-attr.attr-code = "shift-num" no-error.
      if not available buf_marking-attr
      then do:
        create buf_marking-attr.
        buf_marking-attr.mark = mark.
        buf_marking-attr.attr-code = "shift-num".
      end.
      buf_marking-attr.attr-value = string (shiftNum).
    end.
  end method.

  method private integer getObject (
    cash as integer
  ):
    define buffer buf_cash-desk for ub.cash-desk.

    find buf_cash-desk where buf_cash-desk.cash-num = cash no-lock no-error.
    return if available buf_cash-desk then buf_cash-desk.obj-code else ?.
  end method.

  method private character unlockMarks (
    loc-key as character
  ):
    define variable newSts    as integer   no-undo.
    define buffer buf_marking for ub.marking.
    define buffer buf_marking-l for ub.marking-lines.

    for each buf_marking where 
             buf_marking.loc-key begins loc-key
         and lookup("chk_num",buf_marking.loc-key,":") = 0:
      setMarkStatus (
        if buf_marking.sts = thMarkSts:SaleWaitLock:KeyIntDB then thMarkSts:FreeZone:KeyIntDB else thMarkSts:SaleLock:KeyIntDB,
        "",
        "",
        "",
        buffer buf_marking)
      .
      setShift(buf_marking.mark, shift_tbeg, shift_num).
    end.
    return getJson(1, cashSts:UnlockAll:Label_, mark).
  end method.

  method private character commitCheck ():
    define buffer buf_marking for ub.marking.

    for each buf_marking where buf_marking.loc-key = "cash:" +  cash + ":" + "context:" + cntx_id:
      setMarkStatus (
        if buf_marking.sts = thMarkSts:SaleWaitLock:KeyIntDB then thMarkSts:SaleLock:KeyIntDB else thMarkSts:ReturnLock:KeyIntDB, 
        "cash:" +  cash + ":" + "context:" + cntx_id + ":" + "chk_num:" + chk_id,
        "",
        "",
        buffer buf_marking)
      .
      setShift(buf_marking.mark, shift_tbeg, shift_num).
      accum buf_marking.mark (count).
    end.
    return if (accum count buf_marking.mark) = 0
      then getJson(0, "По данной кассе не было маркированого товара", mark)
      else getJson(1, cashSts:Commit:Label_ + " Зарезервировано кол-во " + string (accum count buf_marking.mark), mark).
  end method.

end class.
