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
Modified: Belova Marina 25/10/2023

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
  &scop CRLF chr(13) + chr(10)
  &scop HdEnd chr(13) + chr(10)  + chr(13) + chr(10)
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
  
  define private variable mMarkOrig     as character no-undo.
  define private variable mCheckSts     as integer   no-undo.
  define private variable mReqId        as character no-undo. 
  define private variable mReqTimestamp as character no-undo.
    
  def stream out_s.
  def stream out_data.
  
  define temp-table ttmark-body no-undo    
     xml-node-name "body"
     field code            as char
     field error-1         as char XML-NODE-NAME "error"
     field requestid       as char
     field status-1        as char XML-NODE-NAME "status"
     field reqid           as char
     field reqtimestamp    as char
     field timestamp       as char
     .
  define temp-table ttmark-check no-undo    
     xml-node-name "codes"
     field cis             as char
     field printView       as char
     field gtin            as char
     field verified        as char
     field found           as char
     field realizable      as char
     field utilised        as char 
     field isBlocked       as char 
     field productionDate  as char
     field isOwner         as char 
     field errorCode       as char 
     field isTracking      as char 
     field sold            as char
     field packageType     as char
     field producerInn     as char
     field grayZone        as char
     field mrp             as char
     field expireDate      as char
     .
   
  define dataset gismt-mark-body  xml-node-name "bodys" for ttmark-body.
  define dataset gismt-mark-codes xml-node-name "body"  for ttmark-check.

  define public property SomeStr as longchar no-undo /* сюда писать если что-то отправить*/
    get.
    set.

  {utl/gtin.i class}
  { utl/search.i  class }
  { ibs/th/skt/controlledclients/gismtprop.i def}

  constructor public marking (  ):
    super ().
    logWrite = new LogWrite().
    
    /* определяем настройки подключения к ГИС МТ */
    define buffer buf_sys-ctrl for ub.sys-ctrl .
    define variable vRetProp as character no-undo.
    
    find first buf_sys-ctrl no-lock no-error.
    if available buf_sys-ctrl and buf_sys-ctrl.db-num <> 0 
    then do:
       dbgPrint("marking.log", substitute("База &1 номер: &2", "{&db}", buf_sys-ctrl.db-num)).
       vRetProp = get-gismt-prop ({&db},
                                  buf_sys-ctrl.db-num) no-error.
    end.
    else do:
       dbgPrint("marking.log", "Не определена БД").
    end.
    cashSts =  new cash().
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
    define variable vAccMarkCheck as character no-undo. 

    assign
      mCheckSts = 1
      mReqId        = ""
      mReqTimeStamp = ""
      answerFlag = false
      cash       = ""      
      shift_id   = ""
      chk_id     = ""
      cntx_id    = ""
      mark       = ""
      action     = ""
      shift_tbeg = ?
      shift_num  = 0 
    .
    
    

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
            mMarkOrig = val.
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
    EDOParSec = ObjSrv:Env:ParametrsOfSection:GetSectionEDO({&shop}, obj-code).

    case true:
      when can-do(listActionsByMark,action) or (can-do(listActionsUnlock,action) and mark <> "") then 
      do:            /* действие по марке */
        if mark = "" then do:
          vLC = chr(123) + substitute('"server_error":"Неверные параметры запроса. Не заполнен mark."') + chr(125).
          sendContent(vLC).
          return.
        end.
  
        mark-short = GetCodeIdent(mark).
        if mark-short = "" or mark-short = ? then do:
          vLC = chr(123) + substitute('"server_error":"Неверные параметры запроса. Некорректный код марки."') + chr(125).
          sendContent(vLC).
          return.
        end.
        
        if action = cashSts:SaleLock:NameProp then 
        do:
           vAccMarkCheck = ChekAccessMark({&shop},obj-code,mark,mark-short).
           dbgPrint("marking.log", substitute("Проверка ГИС МТ: &1 Статус: &2 mReqId &3 mReqTimeStamp &4", 
                                              vAccMarkCheck, 
                                              mCheckSts,
                                              mReqId,
                                              mReqTimeStamp)).
           if mCheckSts = 0 or 
              mCheckSts = 3 /* faund = false */
           then do:
              vAccMarkCheck = vAccMarkCheck + "Снимите с продажи и передайте товар управляющему/старшему смены".
              /* если марки нет в ГИС МТ, то не сохраняем ее, а сразу выходим */
              if mCheckSts = 3 then do:
                 vLC = getJson(0, vAccMarkCheck, mark).
                 sendContent(vLC).
                 return.
              end.   
           end.
           /* Если прошло более 72ч с момента аварии ГИС МТ */
           if mCheckSts = 4 then do:
              vLC = getJson(0, vAccMarkCheck, mark).
              sendContent(vLC).
              return.
           end.     
        end.
  
        find first buf_marking exclusive-lock where buf_marking.mark begins mark-short no-wait no-error.
        if not available (buf_marking) then 
        do:      /* марка не найдена в БД TH */
          if locked buf_marking then do:
             vLC = getJson(0, "С маркой " + mark-short + " уже работают. ", mark).
             sendContent(vLC).
             return.
          end.   
          case action:
            when cashSts:SaleLock:NameProp then
            do:
              createMark(mark-short, buffer buf_marking).
              /* если марка не прошла проверку в ГИС МТ, то ее создаем, но продавать нельзя */
              if mCheckSts = 0 then do:
                 vLC = getJson(0, vAccMarkCheck, mark).
                 sendContent(vLC).
                 return.
              end. 
              if available buf_marking then 
                answerFlag = true.
              vLC = setMarkStatus (
                thMarkSts:SaleWaitLock:KeyIntDB, 
                "cash:" +  cash + ":" + "context:" + cntx_id,
                if mCheckSts = 2 then vAccMarkCheck else cashSts:SaleLock:Label_,
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
          if action = cashSts:SaleLock:NameProp and 
             mCheckSts = 0 
          then do:
                 vLC = getJson(0, vAccMarkCheck, mark).
                 sendContent(vLC).
                 return.
          end. 
              
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
                if mCheckSts = 2 then vAccMarkCheck else cashSts:SaleLock:Label_,
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
    inLC = inLC + {&CRLF}.
    v-cont-length = length(inLC,"RAW":U).
    SomeStr = substitute("HTTP/1.1 200 OK&1Server: 4GL&1Content-Type: text/html; charset=UTF-8&1Content-Length: &3&2&4",{&CRLF},{&HdEnd},string(v-cont-length),inLC).
    return.
  end method.

  method private character getJson(stsInt as int, msg as char, mark as char):
    def var json-str as char no-undo.
    mark = replace (mark, '\', '\\').
    mark = replace (mark, '"', '\"').
    
    /* Онлайн-проверка КМ не была выполнена в части срока годности */
    if stsInt = 1 and mCheckSts = 2 
    then stsInt = 2.
      
    json-str = chr(123) + substitute ('"status":&1,"comment":"&2","reqid":"&3","reqtimestamp":"&4"', stsInt, msg, mReqId, mReqTimestamp) + chr(125).
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

  method private character FixErrGisMT ():
     
    define variable vErrSts as character no-undo.
    define variable vTimeBegErr as datetime-tz no-undo.
    define variable vTimeAvail  as integer     no-undo.
    
    define buffer buf_code for ub.code.
    
    assign
       mCheckSts = 2  
       vErrSts = ""
       .
    
    do transaction on error undo, leave:        
       /* Проверяем, зафиксирован ли сбой онлайн-проверки */
       find first buf_code where buf_code.parent eq "GisMt"
                             and buf_code.code   eq "GisMtErr"
          exclusive-lock no-wait no-error.
       if not available buf_code 
       then do:
          if locked buf_code then             
                vErrSts = vErrSts + "Время сбоя не зафиксировано. ".
          else do:
             /* создаем верхний уровень, если его нет */
             find first code where buf_code.parent eq ""
                               and buf_code.code   eq "GisMt"
             no-lock no-error.
             if not available buf_code then do:
                create buf_code.
                assign
                   buf_code.parent = ""
                   buf_code.code = "GisMt"
                   buf_code.codename = "Cбой онлайн-проверки КМ"
                   .
             end.
             /* создаем запись с фиксацией времени ошибки */
             create buf_code.
             assign
                buf_code.parent = "GisMt"
                buf_code.code = "GisMtErr"
                buf_code.codename = "Время сбоя онлайн-проверки КМ"
                buf_code.codevalue = string(now)
                .
          end.         
       end.
       else do:
          /* если ошибка уже была, смотрим сколько прошло времени */
          if buf_code.codevalue > "" then do:
             vTimeBegErr = datetime-tz(buf_code.codevalue) no-error.
             if gismt-MaxTime <> ? and
                gismt-TimeFalStart <> ? and 
                vTimeBegErr <> ?
             then do:
                /* время максимального ожидания вышло */
                if vTimeBegErr + gismt-MaxTime * 3600000 < now
                then do:
                   assign
                      mCheckSts = 4 
                      vErrSts = "С момента начала сбоя онлайн-проверки прошло более " 
                                + string(gismt-MaxTime) 
                                + " часов, реализация маркированных товаров невозможна. "
                      .
                end.
                /* время максимального ожидания не вышло, но время когда надо начать предупреждать */
                else if vTimeBegErr + gismt-TimeFalStart * 3600000 <= now
                then do:
                   assign
                      vTimeAvail = Round((vTimeBegErr + gismt-MaxTime * 3600000 - now) / 3600000,0)
                      vErrSts = "Сообщите управляющему/старшему смены, что до блокировки продаж маркированных товаров осталось: " 
                                + string(vTimeAvail) + " ч. "
                      .
                end.   
             end.    
             else if vTimeBegErr = ? then buf_code.codevalue = string(now).   
          end.
          /* новая фиксация ошибки */
          else buf_code.codevalue = string(now).
       end.
    end.
    return vErrSts.
    
  end method.   
  /* Получение настроек из типа маркировки */
  method private logical GetMarkProp (
     p-obj-type  as character, 
     p-obj-code  as integer,
     p-param-code as character,
     p-type-mark as character
     ):
      define variable v-tth             as handle    no-undo .
      define variable v-value-character as character no-undo.
      define variable v-value-date      as date      no-undo.
      define variable v-value-decimal   as decimal   no-undo.
      define variable v-value-integer   as integer   no-undo.
      define variable v-param-type      as character no-undo.
      define variable v-param-logical   as logical   no-undo.
      
      run adm/shattri.p (
         input "get":U
        ,input  p-obj-type
        ,input  p-obj-code
        ,input  {&attr-marking}
        ,input  p-param-code
        ,output v-value-character
        ,output v-value-date
        ,output v-value-decimal
        ,output v-value-integer
        ,output v-param-logical
        ,output v-param-type
        ,input-output table-handle v-tth
        ) no-error .
        
      dbgPrint("marking.log", substitute("Тип маркировки: p-param-code &1 v-value-character &2 тип маркировки &3", 
                                         p-param-code, 
                                         v-value-character,
                                         p-type-mark)).
      
      if lookup (p-type-mark,v-value-character) > 0
      then return yes.
        
      return no.
  end method.
  
  /* Проверка марки в ГИС МТ */
  method private integer GetGisMTCheck (
     p-obj-type  as character, 
     p-obj-code  as integer,
     mark as character  
  ):
    define variable vInn           as character   no-undo.
    define variable vErrSts        as character   no-undo.
    define variable cmd            as character   no-undo.
    define variable cmdlog         as character   no-undo.
    define variable CmdParamProxy  as character   no-undo.
    define variable vFileToken     as character   no-undo. 
    define variable vFileResult    as character   no-undo.
    define variable vFileResultErr as character   no-undo.   
    define variable vFileresultXml as character   no-undo.
    define variable vFileLog       as character   no-undo.
    define variable vlongJson      as longchar    no-undo case-sensitive.
    define variable vlongJsonError as longchar    no-undo case-sensitive.
    define variable vMark          as character   no-undo case-sensitive.
    define variable vDataMark      as character   no-undo.
    define variable vTimeReq       as datetime-tz no-undo.
    
    define variable v-value-character as character no-undo .
    define variable v-value-date      as date      no-undo .
    define variable v-value-decimal   as decimal   no-undo .
    define variable v-value-integer   as integer   no-undo .
    define variable v-value-logical   as logical   no-undo .
    define variable v-param-type      as character no-undo .
    define variable v-param-value     as character no-undo .
   
    define variable vRetOk   as logical   no-undo.
    define variable vCh      as character no-undo.
        
    define buffer buf_firm for ub.firm .
    define buffer buf_shop for ub.shop.
    
    /* заменяем 1D в 16-тиричной на \u001d */
    assign
       vTimeReq = now
       vMark = mark
       vMark = replace(vMark, '\', '\\') .
       vMark = replace(vMark, '/', '\/') .
       vMark = replace(vMark, '"', '\"') .
       vMark = replace(vMark,chr(29),"\u001d")
       .
      
    dbgPrint("marking.log", substitute("Отправка запроса p-obj-type &1 p-obj-code &2 mark &3", 
                                       p-obj-type, 
                                       p-obj-code,
                                       vMark)).
    
    /* определяем по фирме ИНН */
    vInn = "".
    find first buf_shop no-lock where buf_shop.obj-code = p-obj-code no-error. 
    if available buf_shop then do:
       find first buf_firm no-lock where buf_firm.firm-code = buf_shop.host-code no-error. 
       if available buf_firm then vInn = buf_firm.inn.
       dbgPrint("marking.log", substitute(" Код фирмы &1", buf_shop.host-code)).
    end.   
    else dbgPrint("marking.log", substitute("Не найден магазин с кодом &1", p-obj-code)).
    dbgPrint("marking.log", substitute(" ИНН &1 ", vInn)).
                                  
    dbgPrint("marking.log", "gismt-info").
    
    /* если установлен параметр, обозначающий наличие аварии в ГИС МТ, выходим */
    if gismt-CrashSituat then do:
       dbgPrint("marking.log", "Установлена аварийная ситуация.").
       return 1.
    end. 
      
    if gismt-AdressPort <> "" then CmdParamProxy = substitute ('-x &1 -U &2:&3', gismt-AdressPort, gismt-ProxyLogin, gismt-ProxyPswd).
    else CmdParamProxy = "".  
    
    vFileLog = "GisMtReq-" + replace(string(today),"/","-") +  ".log".
    vCh = "". /* что бы в новый лог писал с первой строки, а в имеющийся - со следующей */
    if searchfile(vFileLog) <> ?
    then do:
       file-info:file-name = searchfile(vFileLog).
       if file-info:file-size <> 0 then vCh = " ".
    end.
    
    /* формируем лог файл */
    OUTPUT STREAM out_data TO value(vFileLog) APPEND.
    PUT STREAM out_data UNFORMATTED 
      vCh skip now " " mMarkOrig " ".
    OUTPUT STREAM out_data CLOSE.
    
    /* формируем файл запроса к ГИС МТ с маркой и ИНН */
    run gbl/_tmpfile.p ( "GisMT_data", ".txt", output vDataMark ) .
    dbgPrint("marking.log", substitute("vDataMark &1 ", vDataMark)).
    OUTPUT STREAM out_data TO value(vDataMark).
    PUT STREAM out_data UNFORMATTED  
      '~{"codes":["' vMark '"],"inn":"' vInn  '"~}' .
    OUTPUT STREAM out_data CLOSE.
    
    run gbl/_tmpfile.p ( "ChkGisMTRes", ".txt", output vFileResult ) .
    run gbl/_tmpfile.p ( "ChkGisMTResErr", ".txt", output vFileResultErr ) .
    dbgPrint("marking.log", substitute("vFileResult &1 ", vFileResult)).
    dbgPrint("marking.log", substitute("vFileResultErr &1 ", vFileResultErr)).
    
    cmd = substitute ('&1 &8 --max-time &9 -X POST -H "Content-Type: application/json" -H &5 &6 --data @&4 &3 >&2 --stderr &7',
                      search ("exe/curl.exe"), /*1*/
                      vFileResult,             /*2*/
                      quoter(gismt-GisAdress), /*3*/
                      searchfile(vDataMark),   /*4*/
                      quoter("X-api-Key: " + gismt-RegKey), /*5*/
                      CmdParamProxy,           /*6*/
                      vFileResultErr,          /*7*/
                      gismt-DopParam,          /*8*/
                      replace(string(gismt-WaitTime, "zzzz9.99999"),".",",")).         /*9*/  
                      
    dbgPrint("marking.log", "cmd: " + cmd).
                                         
    os-command silent value(cmd) .
     
    if searchFile(vfileresult) = ?
    then do :
       dbgPrint("marking.log", "Запрос не выполнен! Не могу найти файл ").
       /* формируем лог файл */
       OUTPUT STREAM out_data TO value(vFileLog) APPEND.
       PUT STREAM out_data UNFORMATTED  
         "Отсутствует ответ ГИС МТ ".
       OUTPUT STREAM out_data CLOSE.
       return 2.
    end .
    file-info:file-name = searchFile(vfileresult) .
    if file-info:file-size = 0
    then do :
       dbgPrint("marking.log", "Запрос не выполнен! Файл-ответ пустой (размер 0 байт). ").   
       /* формируем лог файл */
       OUTPUT STREAM out_data TO value(vFileLog) APPEND.
       PUT STREAM out_data UNFORMATTED  
         " Отсутствует ответ ГИС МТ ".
       OUTPUT STREAM out_data CLOSE.
       return 2.
    end .
    
    copy-lob from file vFileResult to vlongJson .
    copy-lob from file vFileresultErr to vlongJsonError .
    
    /* формируем лог файл */
    os-append value(vfileresult) value(vFileLog) .
           
    /* анализируем, есть ли ошибки в ответе */
    if index(vlongJsonError,"curl:") > 0 then do:
       dbgPrint("marking.log", "Ошибка ответа от сервиса ").
       /* формируем лог файл */
       OUTPUT STREAM out_data TO value(vFileLog) APPEND.
       PUT STREAM out_data UNFORMATTED  
         " Отсутствует ответ ГИС МТ ".
       OUTPUT STREAM out_data CLOSE.
       return 2.
    end.   
   
    /* заменяем спец.символы, которые не дадут сконвертировать в xml */
    assign
       vlongJson = replace(vlongJson, "&lt;", "###lo-then###") 
       vlongJson = replace(vlongJson, "&Lt;", "###LO-then###") 
       vlongJson = replace(vlongJson, "&lT;", "###lo-THEN###") 
       vlongJson = replace(vlongJson, "&LT;", "###LO-THEN###") 
       vlongJson = replace(vlongJson, "&gt;", "###gr-then###") 
       vlongJson = replace(vlongJson, "&Gt;", "###GR-then###") 
       vlongJson = replace(vlongJson, "&gT;", "###gr-THEN###") 
       vlongJson = replace(vlongJson, "&GT;", "###GR-THEN###") 
       vlongJson = replace(vlongJson, "&", "&amp;") 
       vlongJson = replace(vlongJson, "<", "&lt;") 
       vlongJson = replace(vlongJson, ">", "&gt;") 
       vlongJson = replace(vlongJson, ':null', ':""') 
       vlongJson = replace(vlongJson, (':' + CHR(91) + CHR(123) + CHR(125) + CHR(93)), ':""') 
       vlongJson = replace(vlongJson, ':~{~}', ':""')
       vlongJson = replace(vlongJson, '"1":', '"n1":')
       vlongJson = replace(vlongJson, '"2":', '"n2":')
       vlongJson = replace(vlongJson, '"3":', '"n3":')
       vlongJson = replace(vlongJson, '"4":', '"n4":')
       vlongJson = replace(vlongJson, '"5":', '"n5":')
       vlongJson = replace(vlongJson, '"6":', '"n6":')
       vlongJson = replace(vlongJson, '"7":', '"n7":')
       vlongJson = replace(vlongJson, '"8":', '"n8":')
       vlongJson = replace(vlongJson, '"9":', '"n9":')
       vlongJson = replace(vlongJson, '"10":', '"n10":')
       vlongJson = replace(vlongJson, '"11":', '"n11":')
       vlongJson = replace(vlongJson, '"12":', '"n12":')
       vlongJson = replace(vlongJson, '"13":', '"n13":')
       vlongJson = replace(vlongJson, '"14":', '"n14":')
       vlongJson = replace(vlongJson, '"15":', '"n15":')
       vlongJson = replace(vlongJson, '"16":', '"n16":')
       vlongJson = replace(vlongJson, '"17":', '"n17":')
       vlongJson = replace(vlongJson, '"18":', '"n18":')
       vlongJson = replace(vlongJson, '"19":', '"n19":')
       vlongJson = replace(vlongJson, '"20":', '"n20":')
       vlongJson = replace(vlongJson, '"21":', '"n21":')
       .
    
    copy-lob from vlongJson to file vfileresult .
    
    if vlongJson = "" then do:
       dbgPrint("marking.log", "Не получен ответ от сервиса ").
       /* формируем лог файл */
       OUTPUT STREAM out_data TO value(vFileLog) APPEND.
       PUT STREAM out_data UNFORMATTED  
         " Отсутствует ответ ГИС МТ ".
       OUTPUT STREAM out_data CLOSE.
       return 2.
    end.   
    
    run gbl/_tmpfile.p ( "ChkGisMTResXml", ".xml", output vFileResultXml ) . 
    dbgPrint("marking.log", substitute("vFileResultXml &1 ", vFileResultXml)).
            
    cmd = substitute ('&1 -file=&2 >&3',
                      search("exe/json2xml.exe"),
                      vFileResult,
                      vfileresultxml).
                          
    os-command silent value (cmd).  
    
    file-info:file-name = search(vfileresultxml) .
    if file-info:file-size = 0
    then do :
       dbgPrint("marking.log", "Запрос не выполнен! Ошибка при чтении XML <body>. " + error-status:get-message(1)).
       /* формируем лог файл */
       OUTPUT STREAM out_data TO value(vFileLog) APPEND.
       PUT STREAM out_data UNFORMATTED  
         " Отсутствует ответ ГИС МТ ".
       OUTPUT STREAM out_data CLOSE.
       return 2.
    end .
    
    copy-lob from file vfileresultxml to vlongJson.
    vlongJson = "<bodys>" +  vlongJson + "</bodys>".
    if index(vlongJson,"</expiredate>") > 0 then .    
    copy-lob from vlongJson to file vfileresultxml.
    vRetOk = dataset gismt-mark-body:read-xml("FILE":U, vfileresultxml, "EMPTY":U, ?, ?) no-error.
    if not vRetOk or error-status:error then do:
       dbgPrint("marking.log", "Запрос не выполнен! Ошибка при чтении XML <body>. " + error-status:get-message(1)).
       /* формируем лог файл */
       OUTPUT STREAM out_data TO value(vFileLog) APPEND.
       PUT STREAM out_data UNFORMATTED  
         " Отсутствует ответ ГИС МТ ".
       OUTPUT STREAM out_data CLOSE.
       return 2.
    end.   
    vRetOk = dataset gismt-mark-codes:read-xml("FILE":U, vfileresultxml, "EMPTY":U, ?, ?) no-error. 
    if not vRetOk or error-status:error then do:
       dbgPrint("marking.log", "Запрос не выполнен! Ошибка при чтении XML <codes>.").
       /* формируем лог файл */
       OUTPUT STREAM out_data TO value(vFileLog) APPEND.
       PUT STREAM out_data UNFORMATTED  
         " Отсутствует ответ ГИС МТ ".
       OUTPUT STREAM out_data CLOSE.
       return 2.
    end.
    
    if not session:debug-alert
    then do:
       os-delete value(vDataMark) no-error.
       os-delete value(vFileResult) no-error.
       os-delete value(vFileResultErr) no-error.
       os-delete value(vFileResultXml) no-error.
    end.   
       
    return 0.
    
  end method.
  
  
  /* Проверка марки в ГИС МТ */
  method private character ChekAccessMark (
    p-obj-type  as character, 
    p-obj-code  as integer,
    mark as character,
    mark-short as character 
  ):
    define variable vErrSts as character no-undo.
    define variable vMark as character no-undo.
    
    define variable vGetGisMt as int no-undo.
        
    define variable vMarkNotNeedCheck as logical   no-undo.
    /* настройки по типам маркировки */
    define variable vCheckBlock    as logical   no-undo.
    define variable vCheckDate     as logical   no-undo.
    define variable vCheckMRC      as logical   no-undo.
    define variable vCheckOwner    as logical   no-undo.
    define variable vCheckStatusKM as logical   no-undo.
    define variable vCheck         as logical   no-undo.
    
    define variable vMRC as decimal no-undo.
    define variable vMrp as decimal no-undo.
    define variable vMRC_r as decimal no-undo.
    define variable vMrp_r as decimal no-undo.
    define variable vExpireDMY  as character  no-undo.
    define variable vExpireTime as character  no-undo.
    define variable vExpireDate as datetime-tz no-undo.
    define variable vExpireTimeMes as character no-undo.
        
    define buffer buf_marking-attr for ub.marking-attr.
    define buffer buf_code for ub.code.
    
    if mark = "" or mark = "?" 
       then return "".
       
    assign
       vErrSts = ""
       mCheckSts = 1
       .
    
    /* определяем тип марки и МРЦ */
    ChekTypeMarkByDm(mark).
    
    /* если не определен тип марки, это не марка, не проверяем */    
    if mTypeMark = "" then do:
        mCheckSts = 0.
        return "Не опредлен тип маркировки товара. ".
    end.    
    
    dbgPrint("marking.log", substitute("Проверка марки p-obj-type &1 p-obj-code &2 mark &3 mTypeMark &4 mark-short &5", 
                                        p-obj-type,
                                        p-obj-code,
                                        mark,
                                        mTypeMark,
                                        trim(mark-short,chr(29))
                                        )).  
                                        
    /* Вычисляем, какие проверки нужны для этого типа марки */    
    vCheckBlock = GetMarkProp (p-obj-type, 
                               p-obj-code,
                               {&attr-marking_checkBlock},
                               mTypeMark).
    vCheckDate   = GetMarkProp (p-obj-type, 
                               p-obj-code,
                               {&attr-marking_checkDate},
                               mTypeMark).
    vCheckMRC    = GetMarkProp (p-obj-type, 
                               p-obj-code,
                               {&attr-marking_checkMRC},
                               mTypeMark).
    vCheckOwner  = GetMarkProp (p-obj-type, 
                               p-obj-code,
                               {&attr-marking_checkOwner},
                               mTypeMark).
    vCheckStatusKM = GetMarkProp (p-obj-type, 
                               p-obj-code,
                               {&attr-marking_checkStatusKM},
                               mTypeMark).
       
    if  vCheckBlock or vCheckDate or vCheckMRC or vCheckOwner or vCheckStatusKM
       then vCheck = yes.
    else vCheck = no.     
    
    dbgPrint("marking.log", substitute("vCheckBlock &1 vCheckDate &2 vCheckMRC &3 vCheckOwner &4 vCheckStatusKM &5",
                                       vCheckBlock,
                                       vCheckDate,
                                       vCheckMRC,
                                       vCheckOwner,
                                       vCheckStatusKM)).
                                       
    /* у типа маркировки не отмечен ни один параметр для проверки */
    if not vCheck then return "".
    
    /* Определяем, стоит ли игнорировать проверку онлайн по марке */
    find first buf_marking-attr no-lock where 
                buf_marking-attr.attr-code = "notOnlineCheck"
            and buf_marking-attr.mark begins trim(mark-short,chr(29))
        no-error.
    if available buf_marking-attr 
    then vMarkNotNeedCheck = logical(buf_marking-attr.attr-value) no-error.
    else vMarkNotNeedCheck = no.
    
    dbgPrint("marking.log", substitute("Игнорировать он-лайн проверку: &1",vMarkNotNeedCheck)). 
    
    if vMarkNotNeedCheck then return "".
    
    /* вызываем проверку по марке */
    vGetGisMt = GetGisMTCheck(p-obj-type,p-obj-code,mark).
    
    /* установлен признак аварии в настройках */
    if vGetGisMt = 1 then do:
       mCheckSts = 2.
       return "".
    end.   
    /* произошла аварийная ситуация - фиксируем */
    if vGetGisMt = 2 then 
    do:
       vErrSts = FixErrGisMT().
       return vErrSts.
    end.
    /* Сбоя нет, проверяем, был ли ранее сбой и сбрасываем время сбоя */
    else do:
       do transaction on error undo, leave: 
          find first buf_code where buf_code.parent eq "GisMt"
                                and buf_code.code   eq "GisMtErr"
             exclusive-lock no-error.
          if available buf_code 
          then buf_code.codevalue = "".
        end.     
    end.

    dbgPrint("marking.log", "ttmark-body").
     
    for first ttmark-body no-lock:
        assign
           mReqId        = ttmark-body.reqid
           mReqTimeStamp = ttmark-body.reqtimestamp
           .
        if ttmark-body.code = "0" or
           ttmark-body.code = "10" 
           then . 
        else do:
           assign 
              mCheckSts = 0
              vErrSts = "Онлайн-проверка завершилась с ошибкой. "
              .
            return vErrSts.  
         end.        
    end.
    
    vMRC = getMRCByDM(mark) * 100 no-error.
    if vMRC = ? then vMRC = 0.
    dbgPrint("marking.log", substitute("МРЦ по марке: &1",vMRC)).
    
    dbgPrint("marking.log", "ttmark-check").
     
    for first ttmark-check no-lock:

      if ttmark-check.errorCode = "" or 
         ttmark-check.errorCode = "0" or
         ttmark-check.errorCode = "10" 
         then . 
      else do:
          assign 
            vErrSts = "Онлайн-проверка завершилась с ошибкой. "
            mCheckSts = 0.
          return vErrSts.
      end.      
         
      if ttmark-check.found = "" then ttmark-check.found = "false".
      if ttmark-check.verified = "" then ttmark-check.verified = "false".
      if ttmark-check.realizable = "" then ttmark-check.realizable = "false".
      if ttmark-check.sold = "" then ttmark-check.sold = "true".
      if ttmark-check.utilised = "" then ttmark-check.utilised = "false".
      if ttmark-check.isBlocked = "" then ttmark-check.isBlocked = "true".
      if ttmark-check.isOwner = "" then ttmark-check.isOwner = "false".
      if ttmark-check.isTracking = "" then ttmark-check.isTracking = "true".
      if ttmark-check.grayZone = "" then ttmark-check.grayZone = "false".
      
      vMrp = int(ttmark-check.mrp) no-error.
                 
      if vCheck then do:
         if ttmark-check.found = "false" 
         then do: 
            assign 
                vErrSts = "Данная марка не зарегистрирована в Честном Знаке. "
                mCheckSts = 3.
            return vErrSts.
         end.
         
         if  vCheckDate = yes then do:
            vExpireDate = ?.
            if ttmark-check.expireDate <> ""
               and num-entries(ttmark-check.expireDate,"T") = 2 
            then do:
                vExpireDMY = entry(1,ttmark-check.expireDate,"T").
                if num-entries(vExpireDMY,"-") = 3 then 
                do:
                   if num-entries(ttmark-check.expireDate,"T") >= 2 then
                      vExpireTime = entry(1,entry(2,ttmark-check.expireDate,"T"),"Z").
                   else vExpireTime =  "00:00:00.000".  
                   vExpireDMY = entry(3,vExpireDMY,"-") + "/" + entry(2,vExpireDMY,"-") + "/" + entry(1,vExpireDMY,"-").
                   vExpireDate = datetime-tz(vExpireDMY + " " + vExpireTime) no-error.
                   if vExpireDate <> ? and 
                      vExpireDate < now + gismt-BanDate * 60 * 1000
                   then do:
                      vExpireTime = entry(1,vExpireTime,".").
                      if num-entries(vExpireTime,":") > 2 then
                         vExpireTimeMes = entry(1,vExpireTime,":") + ":" + entry(2,vExpireTime,":"). 
                      else vExpireTimeMes = "".   
                      assign
                         vErrSts = "Срок годности товара истек " + vExpireDMY + " " + vExpireTimeMes + ". "
                         mCheckSts = 0.
                   end.      
                end.   
            end.
            if ttmark-check.expireDate = ""
               or vExpireDate = ?
            then assign 
                   vErrSts = ""
                   mCheckSts = 2.
         end.
         if  vCheckBlock and ttmark-check.isBlocked = "true"
         then assign
                 vErrSts = vErrSts + "Реализация товара запрещена контролирующими органами. "
                 mCheckSts = 0.
         
         if  vCheckStatusKM and 
                 (ttmark-check.utilised = "false" or 
                 (ttmark-check.realizable = "false" and ttmark-check.grayZone = "false") or 
                 ttmark-check.sold = "true" or 
                 ttmark-check.verified = "false")
         then assign 
                 vErrSts = vErrSts + "Марка товара в статусе, запрещающем розничную реализацию. "
                 mCheckSts = 0.
                 
         if vCheckMRC and 
            vMrp <> 0 and 
            vMRC <> vMrp          
         then 
              assign 
                 vMRC_r = if vMRC <> ? then Round((vMrc / 100), 2) else 0
                 vMrp_r = Round((vMrp / 100), 2)
                 vErrSts = vErrSts + "МРЦ на упаковке " 
                           + (if vMRC = ? then "не определена" else trim(string(vMrc_r,">>>>>>>>>>9.99"), " ") + "р.") 
                           + " не совпадает с МРЦ в Честном Знаке - " 
                           + trim(string(vMrp_r,">>>>>>>>>>9.99"), " ") + "р. "
                 mCheckSts = 0
                 .
         if  vCheckOwner and 
             ttmark-check.isOwner = "false" and 
             ttmark-check.isTracking = "true" and 
             ttmark-check.grayZone = "false"
         then assign
                 vErrSts = vErrSts + "Общество не является владельцем товара. "
                 mCheckSts = 0.
      end.     
    end.
    
    dbgPrint("marking.log", substitute("vErrSts &1 mCheckSts &2", vErrSts, mCheckSts)).
    
    return vErrSts.

  end method.
  
  method private void dbgPrint(
     iLogName as character, 
     iTxt as character
    ):
    if session:debug-alert
    then do:     
       output stream out_s to value(iLogName) append.
       case iTxt:
          when "gismt-info" then do:
             put stream out_s unformatted
                   " AdressPort " gismt-AdressPort skip
                   " DopParam " gismt-DopParam skip
                   " GisAdress " gismt-GisAdress skip 
                   " ProxyLogin " gismt-ProxyLogin skip  
                   " ProxyPswd " gismt-ProxyPswd skip
                   " MaxTime " gismt-MaxTime skip
                   " RegKey " gismt-RegKey skip
                   " TimeFalStart " gismt-TimeFalStart skip
                   " WaitTime " gismt-WaitTime skip
                   " CrashSituat " gismt-CrashSituat skip
                   " BanDate " gismt-BanDate
                   skip.   
          end.   
          when "ttmark-body" then do:
             for each ttmark-body:
                put stream out_s unformatted  
                    now " ttmark-body: " skip
                    "ttmark-body.code " ttmark-body.code skip
                    "ttmark-body.error " ttmark-body.error-1 skip
                    "ttmark-body.requestid " ttmark-body.requestid skip
                    "ttmark-body.status " ttmark-body.status-1 skip
                    "ttmark-body.timestamp " ttmark-body.timestamp skip 
                    "ttmark-body.reqid " ttmark-body.reqid skip
                    "ttmark-body.reqtimestamp " ttmark-body.reqtimestamp
                    skip .
             end.       
          end.
          when "ttmark-check" then do: 
             for each ttmark-check:
                put stream out_s unformatted  
                     now " ttmark-check: " skip
                     "ttmark-check.cis: " ttmark-check.cis skip        
                     "tttmark-check.printView: " ttmark-check.printView skip      
                     "ttmark-check.gtin: " ttmark-check.gtin           skip
                     "ttmark-check.verified: " ttmark-check.verified   skip    
                     "ttmark-check.found: " ttmark-check.found         skip 
                     "ttmark-check.realizable: " ttmark-check.realizable  skip   
                     "ttmark-check.utilised: " ttmark-check.utilised   skip     
                     "ttmark-check.isBlocked: " ttmark-check.isBlocked skip      
                     "ttmark-check.productionDate: " ttmark-check.productionDate skip 
                     "ttmark-check.isOwner: " ttmark-check.isOwner     skip    
                     "ttmark-check.errorCode: " ttmark-check.errorCode skip      
                     "ttmark-check.isTracking: " ttmark-check.isTracking   skip   
                     "ttmark-check.sold: " ttmark-check.sold           skip
                     "ttmark-check.packageType: " ttmark-check.packageType skip   
                     "ttmark-check.producerInn: " ttmark-check.producerInn skip   
                     "ttmark-check.grayZone: " ttmark-check.grayZone       skip
                     "ttmark-check.mrp: " ttmark-check.mrp skip
                     "ttmark-check.expireDate: " ttmark-check.expireDate          
                     skip.
             end.        
          end.     
          otherwise      
             put stream out_s unformatted now " " iTxt skip.
       end case.     
       output stream out_s close.
    end.
    return.
  end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	destructor public marking ( ):
      delete object cashSts.
      delete object logWrite.
	end destructor.
  
  
end class.  

