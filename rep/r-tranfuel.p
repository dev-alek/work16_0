/*

$Revision: $
$Author: $
$Date: $
$Workfile: $
$Archive: $

Отчет по длительности транзакций

Автор: Рукавишников Вадим
Дата создания: 24/05/21
Author: Rukavishnikov Vadim
Creation date: 24/05/21

*/
define input parameter iCntxtHostCodeObj as integer   no-undo.
define input parameter iChkTypeCodeList  as character no-undo.
define input parameter iGdsCodeList      as character no-undo.
define input parameter iCashPayList      as character no-undo.
define input parameter iTRKList          as character no-undo.
define input parameter iTranTimeMax      as integer   no-undo.
define input parameter iGrpChk           as logical   no-undo.
define input parameter iGrpTran          as logical   no-undo.

define variable vss-revision    as character     no-undo init "$ $":U .
define variable vss-author      as character     no-undo init "$ $":U .
define variable vss-date        as character     no-undo init "$ $":U .
define variable vss-workfile    as character     no-undo init "$ $":U .
define variable vss-archive     as character     no-undo init "$ $":U .
define variable vss-description as character     no-undo init "Отчет по длительности транзакций".
define variable parparentproc   as widget-handle no-undo.
define variable mParamStr       as character     no-undo extent 10.
define variable mProdBcStrList  as character     no-undo.

{cmp/str-glbl.i}
{cmp/vssrevis.i}
{cmp/str-glbl.i}
{cmp/r-page1.i}
{ref/fd-attr.i}
{cmp/trg-def.i}
{gbl/gbclcode.i}
{gbl/prn-lib.i "new shared"}
{ref/chk-type-desc.i}

define temp-table tt-rep no-undo
   field obj-type          as character
   field obj-code          as integer
   field obj-name          as character
   field chk-date          as date
   field chk-time          as integer
   field shift-date        as date
   field shift-name        as character
   field chk-num           as integer
   field doc-num2          as character
   field z-number          as integer
   field tran-num          as integer
   field chk-type-desc     as character
   field pay-desk          as character
   field cash-num          as integer
   field cashier           as character
   field trk-num           as integer
   field nozzle-num        as integer
   field fuel-code         as integer
   field gds-name          as character
   field volume            as decimal
   field price             as decimal
   field money             as decimal
   field cash-pay-code     as integer
   field cash-pay-name     as character
   field pay-card          as character
   field datetime-beg      as datetime
   field date-beg          as date
   field time-beg          as integer
   field datetime-end      as datetime
   field date-end          as date
   field time-end          as integer
   field time-length       as integer
   field all-time-length   as integer
   field all-time-length-2 as integer /* время от начала первой до окончания последней транзакции */
   field multi-pay         as logical
   field resume-tran       as logical
   field uuid              as character
   field uuid-cheq         as character
   field grp-num           as integer
index pi obj-code shift-date shift-name chk-date chk-time pay-desk fuel-code trk-num nozzle-num
index si1 obj-code grp-num datetime-beg
.

define temp-table tt-all-total-rep no-undo
   field obj-type           as character
   field obj-code           as integer
   field qty-chk            as integer  /* номер чека */
   field qty-tran           as integer  /* номер топливной транзакции */
   field qty-chk-fuel       as integer  /* номер чека + тип чека, ПРОДАЖА */
   field full-time-tran     as integer  /* номер чека + томер транзакции */
   field avg-time-tran      as integer  /* full-time-tran / qty-tran */
   field avg-time-tran-fuel as integer  /* full-time-tran / qty-chk-fuel */
.
define temp-table tt-total-rep no-undo like tt-all-total-rep
   field obj-name           as character
.

define temp-table tt-grp no-undo
   field obj-type           as character
   field obj-code           as integer
   field obj-name           as character
   field grp-num            as integer
   field uuid-cheq-list     as character
   field uuid-list          as character
   field all-time-length    as integer
   field all-time-length-2  as integer
   field cash-pay-code      as integer
   field cash-pay-name      as character
   field resume-tran        as logical
.

define temp-table tt-pay no-undo
   field seq             as integer
   field volume          as decimal
   field money           as decimal
   field cash-pay-code   as integer
   field cash-pay-name   as character
   field pay-card        as character
   field multi-pay       as logical
  index pi seq
  .

define stream sOutStr-html.

function fDate2Str returns character
   (input idate as date,
    input iformat as char):
   define variable vdatestr as character no-undo.
   if idate = ? then
      vdatestr = "".
   else
      vdatestr = trim(string(idate, iformat)).

   return vdatestr.
end function.

function fDec2Str returns character
   (input idec as decimal,
    input iformat as char):
   define variable vdecstr as character no-undo.
   if idec = ? then
      vdecstr = "".
   else
      vdecstr = trim(string(idec, iformat)).

   return vdecstr.
end function.

function fInt2Str returns character
   (input iInt as integer,
    input iformat as char):
   define variable vIntStr as character no-undo.
   if iInt = ? then
      vIntStr = "".
   else
      vIntStr = trim(string(iInt, iformat)).

   return vIntStr.
end function.

function fStrNvl returns character
   (input iStr     as character,
    input iDefault as character):
   return if iStr > "" then iStr else iDefault.
end function.

/* MAIN */

run initTT.
run PrintTT.

procedure InitTT:
   define buffer chk-doc      for chk-doc.
   define buffer chk-doc-attr for chk-doc-attr.
   define buffer chk-gds      for chk-gds.
   define buffer goods        for goods.
   define buffer cash-pay     for cash-pay.
   define buffer prod-bc      for prod-bc.
   define buffer b-tt-rep     for tt-rep.
   
   define variable vI                   as integer   no-undo.
   define variable vJ                   as integer   no-undo.
   define variable vStr                 as character no-undo.
   define variable vChkCode             as character no-undo.
   define variable vCheck               as logical   no-undo.
   define variable vCheckResumeTran     as logical   no-undo.
   define variable v-all-time-length    as integer   no-undo.
   define variable v-count-grp-num      as integer   no-undo.
   define variable v-prev-datetime-end  as datetime  no-undo.
   define variable v-first-datetime-beg as datetime  no-undo.
   define variable vResumeTran          as logical   no-undo.
   define variable vUuidCheq            as character no-undo.
   define variable vFirstRecId          as recid     no-undo.
   define variable vConfirmResumeTran   as logical   no-undo.
   define variable vRecId               as recid     no-undo.
   define variable vRowId               as rowid     no-undo.
   define variable vRowIdList           as character no-undo.
   define variable vUuidList            as character no-undo.
   
   if x-tog-shift then do:
      vI = vI + 1.
      if X-shift-start = X-shift-end then
         mParamStr[vI] = "Смена: " + string(X-shift-start).
      else
         mParamStr[vI] = "Смены: c " + string(X-shift-start) + " по " + string(X-shift-end).
   end.
   
   vI = vI + 1.
   if X-date-start = X-date-end then
      mParamStr[vI] = "За дату : " + string(X-date-start, "99.99.9999").
   else
      mParamStr[vI] = "За период c " + string(X-date-start, "99.99.9999") + " по " + string(X-date-end, "99.99.9999").
   
   vI = vI + 1.
   mParamStr[vI] = "Выбор объекта: ".
   for each obj-list:
      mParamStr[vI] = mParamStr[vI] + obj-list.obj-name + "," .
   end.
   mParamStr[vI] = trim(mParamStr[vI], ",").
   
   vI = vI + 1.
   if iGdsCodeList = "*" then do:
      mParamStr[vI] = "Вся номенклатура".
      mProdBcStrList = "*".
   end.
   else do:
      mParamStr[vI] = "Номенклатура: ".
      vStr = "".

      for each goods where
               can-do(iGdsCodeList, string(goods.gds-code))
      no-lock:
         vStr = vStr + "," + string(goods.gds-code) + "(" + goods.gds-name + ")".
         for each prod-bc where
                  prod-bc.b-code = goods.gds-code
         no-lock:
            mProdBcStrList = mProdBcStrList + "," + prod-bc.b-str.
         end.
      end.
      vStr = trim(vStr, ",").
      mProdBcStrList = trim(mProdBcStrList, ",").
      mParamStr[vI] = mParamStr[vI] + vStr.
   end.

   vI = vI + 1.
   if iTRKList = "*" then
      mParamStr[vI] = "Все ТРК".
   else
      mParamStr[vI] = "ТРК: " + iTRKList.
   mParamStr[vI] = mParamStr[vI] + ", все пистолеты".
   
   vI = vI + 1.
   if iCashPayList = "*" then
      mParamStr[vI] = "Все типы оплаты".
   else do:
      mParamStr[vI] = "Типы оплаты: ".
      vStr = "".

      for each cash-pay where
               can-do(iCashPayList, string(cash-pay.cdpay-code))
      no-lock:
         vStr = vStr + "," + cash-pay.obj-name.
      end.
      vStr = trim(vStr, ",").
      mParamStr[vI] = mParamStr[vI] + vStr.
   end.

   vI = vI + 1.
   if iChkTypeCodeList = "*" then
      mParamStr[vI] = "Все типы чеков".
   else do:
      mParamStr[vI] = "Типы чеков: ".
      vStr = "".
      do vJ = 1 to num-entries({&CHK_CODE_LIST}):
         vChkCode = entry(vJ, {&CHK_CODE_LIST}).
         if can-do(iChkTypeCodeList, vChkCode) then
            vStr = vStr + "," + entry(vJ, {&CHK_NAME_LIST}).
      end.
      vStr = trim(vStr, ",").
      mParamStr[vI] = mParamStr[vI] + vStr.
   end.
   
   if iTranTimeMax > 0 then do:
      vI = vI + 1.
      mParamStr[vI] = "Только с жизненным циклом заказа НП более " + string(iTranTimeMax) + " минут".
   end.
   
   vI = vI + 1.
   if not iGrpChk and not iGrpTran then
      mParamStr[vI] = "Без группировки".
   else do:
      mParamStr[vI] = "С группировкой по ".
      if iGrpChk then
         mParamStr[vI] = mParamStr[vI] + "чекам".
      if iGrpTran then
         mParamStr[vI] = mParamStr[vI] + 
                        (if iGrpChk then " и " else "") +
                         "транзакциям".
   end.

   if x-tog-shift then do:
      for each obj-list,
          each chk-doc where
               chk-doc.obj-type    = obj-list.obj-type
           and chk-doc.obj-code    = obj-list.obj-code
           and chk-doc.shift-date >= X-date-start
           and chk-doc.shift-date <= X-date-end
           and can-do(iChkTypeCodeList, string(chk-doc.chk-type))
      no-lock,
         first chk-doc-attr where
               chk-doc-attr.doc-code  = chk-doc.doc-code
           and chk-doc-attr.attr-code = "CheckId"
      no-lock,
         each tran-fuel where
              tran-fuel.uuid-cheq = chk-doc-attr.attr-value
          and can-do(mProdBcStrList, string(tran-fuel.fuel-code))
          and can-do(iTRKList, string(tran-fuel.trk-num + 1))
      no-lock,
         first prod-bc where
               prod-bc.b-str = string(tran-fuel.fuel-code)
      no-lock,
         first chk-gds  where
               chk-gds.doc-code = chk-doc.doc-code
           and chk-gds.b-code   = prod-bc.b-code
      no-lock,
        first goods where
              goods.gds-code = chk-gds.b-code
      no-lock:
          if (chk-doc.shift-date = X-date-start and chk-doc.shift-num < x-Shift-Start) or
            (chk-doc.shift-date = X-date-End   and chk-doc.shift-num > X-Shift-End) 
         then
            next.
         run CreateOneRec(buffer obj-list,
                          buffer chk-doc,
                          buffer tran-fuel,
                          buffer chk-gds,
                          buffer goods
                          ).
      end.
   end.
   else do:
      for each tran-fuel where
               tran-fuel.date-beg >= datetime(string(X-date-start) + " 00:00:00") - Timezone * 60000
           and tran-fuel.date-beg <= datetime(string(X-date-end + 2) + " 23:59:59") - Timezone * 60000 /* Отберем транзакции за 2 дня вперед. Отфильтруем после корректировки даты начала транзакции */
           and can-do(mProdBcStrList, string(tran-fuel.fuel-code))
           and can-do(iTRKList, string(tran-fuel.trk-num + 1))
      no-lock,
         first chk-doc-attr where
               chk-doc-attr.attr-code  = "CheckId"
           and chk-doc-attr.attr-value = tran-fuel.uuid-cheq
      no-lock,
         first chk-doc where
               chk-doc.doc-code = chk-doc-attr.doc-code
           and can-do(iChkTypeCodeList, string(chk-doc.chk-type))
      no-lock,
         first obj-list where
               obj-list.obj-type = chk-doc.obj-type
           and obj-list.obj-code = chk-doc.obj-code
      no-lock,
         first prod-bc where
               prod-bc.b-str = string(tran-fuel.fuel-code)
      no-lock,
         first chk-gds  where
               chk-gds.doc-code = chk-doc.doc-code
           and chk-gds.b-code   = prod-bc.b-code
      no-lock,
        first goods where
              goods.gds-code = chk-gds.b-code
      no-lock:
         run CreateOneRec(buffer obj-list,
                          buffer chk-doc,
                          buffer tran-fuel,
                          buffer chk-gds,
                          buffer goods
                          ).
      end.
   end.
   
   release tt-rep.

   /* Постобработка данных по фильтру */   
   for each tt-rep where
            not can-do(iTRKList, string(tt-rep.trk-num)):
      delete tt-rep.
   end.
   
   /* Попробуем найти отсутствующую информацию в связанном чеке */
   for each tt-rep where
            tt-rep.cash-pay-name = "":
      find first tran-fuel where
                 tran-fuel.tran-num = tt-rep.tran-num
             and tran-fuel.num-cheq = integer(tt-rep.doc-num2)
      no-lock no-error.
      if avail tran-fuel then do:
         for first chk-doc-attr where
                   chk-doc-attr.attr-code  = "CheckId"
               and chk-doc-attr.attr-value = tran-fuel.uuid-cheq
         no-lock,
             first chk-doc where
                   chk-doc.doc-code = chk-doc-attr.doc-code
         no-lock,
             first obj-list where
                   obj-list.obj-type = chk-doc.obj-type
               and obj-list.obj-code = chk-doc.obj-code
         no-lock,
             first prod-bc where
                   prod-bc.b-str = string(tran-fuel.fuel-code)
         no-lock,
             first chk-gds  where
                   chk-gds.doc-code = chk-doc.doc-code
               and chk-gds.b-code   = prod-bc.b-code
         no-lock,
            first goods where
                  goods.gds-code = chk-gds.b-code
         no-lock:
   
            find first chk-pay where
                       chk-pay.doc-code = chk-gds.doc-code
            no-lock no-error.
            if avail chk-pay then do:
               find first cash-pay where
                          cash-pay.cdpay-code = chk-pay.pay-code
               no-lock no-error.
               if avail cash-pay then
                  assign
                     tt-rep.cash-pay-code = chk-pay.pay-code
                     tt-rep.cash-pay-name = cash-pay.obj-name.
                     
            end.
         end.
      end.
   end.
   
   /* Группировка транзакций */
   v-count-grp-num = 0.
   for each tt-rep:
      find first tt-grp where
                 tt-grp.obj-type = tt-rep.obj-type 
             and tt-grp.obj-code = tt-rep.obj-code
             and tt-grp.obj-name = tt-rep.obj-name
             and (can-do(tt-grp.uuid-cheq-list, tt-rep.uuid-cheq)
                   or
                  can-do(tt-grp.uuid-list, tt-rep.uuid))
      no-error.
      if not avail tt-grp then do:
         v-count-grp-num = v-count-grp-num + 1.
         create tt-grp.
         assign
            tt-grp.obj-type = tt-rep.obj-type
            tt-grp.obj-code = tt-rep.obj-code
            tt-grp.obj-name = tt-rep.obj-name
            tt-grp.grp-num  = v-count-grp-num
            .
      end.
      if not can-do(tt-grp.uuid-cheq-list, tt-rep.uuid-cheq) then
         tt-grp.uuid-cheq-list = tt-grp.uuid-cheq-list + (if tt-grp.uuid-cheq-list > "" then "," else "") + string(tt-rep.uuid-cheq).
      if not can-do(tt-grp.uuid-list, tt-rep.uuid) then
         tt-grp.uuid-list = tt-grp.uuid-list + (if tt-grp.uuid-list > "" then "," else "") + tt-rep.uuid.

      tt-rep.grp-num = tt-grp.grp-num.
      if tt-grp.cash-pay-name = "" then
         assign
            tt-grp.cash-pay-code = tt-rep.cash-pay-code
            tt-grp.cash-pay-name = tt-rep.cash-pay-name
            .
   end.
   
   /* Продолжение налива */
   for each tt-rep
   break
      by tt-rep.obj-code
      by tt-rep.grp-num
      by tt-rep.datetime-beg
      by tt-rep.datetime-end:

      if first-of(tt-rep.grp-num) then do:
         assign
            vUuidCheq          = ""
            vResumeTran        = no
            vConfirmResumeTran = no
            vFirstRecId        = ?
            .
         if tt-rep.chk-type-desc = "Продажа" then
            assign
               vUuidCheq   = tt-rep.uuid-cheq
               vResumeTran = yes
               vFirstRecId = recid(tt-rep)
               .
      end.
      else do:
         if tt-rep.chk-type-desc = "Продажа" and 
            tt-rep.uuid-cheq     = vUuidCheq and
            tt-rep.multi-pay     = no        and /* Транзакции со смешанной оплатой не помечаем как продолжение налива */
            vResumeTran          = yes
         then
            assign
               tt-rep.resume-tran = yes
               vConfirmResumeTran = yes
               .
         else 
            if tt-rep.chk-type-desc = "Продажа" and 
               tt-rep.uuid-cheq     = vUuidCheq and
               tt-rep.multi-pay     = no            /* Транзакции со смешанной оплатой не помечаем как продолжение налива */
            then
               vResumeTran = yes.
         else
            vResumeTran = no.
      end.

      /* Отмечаем первую запись как продолжение налива - отключено 02.09.2021
      if last-of(tt-rep.grp-num) and not first-of(tt-rep.grp-num) and vConfirmResumeTran then do:
         for first b-tt-rep where recid(b-tt-rep) = vFirstRecId:
             b-tt-rep.resume-tran = yes.
         end.
      end. 
      */
      
      if last-of(tt-rep.grp-num) and not first-of(tt-rep.grp-num) and vConfirmResumeTran then do:
         for first tt-grp where tt-grp.grp-num = tt-rep.grp-num:
            tt-grp.resume-tran = yes.
         end.
      end. 
   end.
   
   /* Корректировка времени окончания и продолжительности транзакций при продолжении налива */
   for each tt-grp where
            tt-grp.resume-tran = yes:
      for each tt-rep where
               tt-rep.grp-num = tt-grp.grp-num
      break
         by tt-rep.obj-code
         by tt-rep.grp-num
         by tt-rep.datetime-beg
         by tt-rep.datetime-end:
         
         if not first-of(tt-rep.grp-num) and tt-rep.chk-type-desc = "Продажа" then do:
            find first b-tt-rep where
                       recid(b-tt-rep)        = vRecId
                   and b-tt-rep.chk-type-desc = "Продажа"
            no-error.
            if avail b-tt-rep then do:
               assign
                  b-tt-rep.datetime-end    = tt-rep.datetime-beg
                  b-tt-rep.date-end        = tt-rep.date-beg
                  b-tt-rep.time-end        = tt-rep.time-beg
                  b-tt-rep.time-length     = (b-tt-rep.datetime-end - b-tt-rep.datetime-beg) / 1000
                  .
            end.
         end.
         
         vRecId = recid(tt-rep).
      end.
   end.
   
   /* Корректировка времени окончания и продолжительности транзакций при переводе транзакции */
   for each tt-grp:
      for each tt-rep where
               tt-rep.grp-num = tt-grp.grp-num
      break
         by tt-rep.obj-code
         by tt-rep.grp-num
         by tt-rep.datetime-beg
         by tt-rep.datetime-end:
         
         if not first-of(tt-rep.grp-num) and tt-rep.chk-type-desc = "ПеревТрнзкц" then do:
            find first b-tt-rep where
                       recid(b-tt-rep)        = vRecId
                   and b-tt-rep.chk-type-desc = "Продажа"
            no-error.
            if avail b-tt-rep then do:
               assign
                  b-tt-rep.datetime-end    = tt-rep.datetime-end
                  b-tt-rep.date-end        = tt-rep.date-end
                  b-tt-rep.time-end        = tt-rep.time-end
                  b-tt-rep.time-length     = (b-tt-rep.datetime-end - b-tt-rep.datetime-beg) / 1000
                  .
            end.
         end.
         vRecId = recid(tt-rep).
      end.
   end.
   
   
   /* Корректировка времени окончания и продолжительности транзакций, где следующей строкой идет Сброс или Возврат */
   for each tt-rep
   break
      by tt-rep.obj-code
      by tt-rep.grp-num
      by tt-rep.datetime-beg
      by tt-rep.datetime-end:

      if first-of(tt-rep.grp-num) then do:
         vRowId = ?.
      end.

      if can-do("Возврат,СбросТрнзкц", tt-rep.chk-type-desc) and vRowId <> ? then do:
         for first b-tt-rep where rowid(b-tt-rep) = vRowId:
            assign
               b-tt-rep.datetime-end    = tt-rep.datetime-end
               b-tt-rep.date-end        = tt-rep.date-end
               b-tt-rep.time-end        = tt-rep.time-end
               b-tt-rep.time-length     = (b-tt-rep.datetime-end - b-tt-rep.datetime-beg) / 1000
               .
         end.
      end. 

      vRowId = rowid(tt-rep).
   end.
   
   /* Корректировка времени окончания и продолжительности транзакций, где идет последовательность "аннуляц-ия(ии), продажа" */
   for each tt-rep
   break
      by tt-rep.obj-code
      by tt-rep.grp-num
      by tt-rep.datetime-beg
      by tt-rep.datetime-end:

      if first-of(tt-rep.grp-num) then do:
         vRowIdList = "".
      end.

      if tt-rep.chk-type-desc = "Аннуляция" then
         vRowIdList = vRowIdList + (if vRowIdList > "" then "," else "") + string(rowid(tt-rep)).
      else if tt-rep.chk-type-desc = "Продажа" then do:
         do vI = 1 to num-entries(vRowIdList):
            vRowId = to-rowid(entry(vI, vRowIdList)).
            for first b-tt-rep where rowid(b-tt-rep) = vRowId:
               assign
                  b-tt-rep.datetime-end    = tt-rep.datetime-end
                  b-tt-rep.date-end        = tt-rep.date-end
                  b-tt-rep.time-end        = tt-rep.time-end
                  b-tt-rep.time-length     = (b-tt-rep.datetime-end - b-tt-rep.datetime-beg) / 1000
                  .
            end.
         end.
         vRowIdList = "".
      end. 
   end.
   
   /* В аннуляциях уберем тип оплаты */
   /*
   for each tt-rep where tt-rep.chk-type-desc = "Аннуляция":
      assign
         tt-rep.cash-pay-code = 0
         tt-rep.cash-pay-name = ""
         .
   end.
   */

   /* Постобработка данных по фильтру тип оплаты */   
   for each tt-rep where
            not can-do(iCashPayList, string(tt-rep.cash-pay-code)):
      delete tt-rep.
   end.

   if x-tog-shift = no then do:
      /* Постобработка: удалим тразакции не входящие в период расчета */
      for each tt-rep where
               tt-rep.datetime-beg > datetime(string(X-date-end) + " 23:59:59"):
         delete tt-rep.
      end.
   end.
   
   /* Общее время отпуска НП */
   for each tt-rep
   break
      by tt-rep.obj-code
      by tt-rep.grp-num
      by tt-rep.datetime-beg
      by tt-rep.datetime-end:

      if first-of(tt-rep.grp-num) then do:
         assign
            v-all-time-length    = 0
            v-prev-datetime-end  = datetime("01/01/1990 00:00:00")
            v-first-datetime-beg = tt-rep.datetime-beg
            .
      end.

      if tt-rep.datetime-end > v-prev-datetime-end then
         v-all-time-length = v-all-time-length + (tt-rep.datetime-end - max(tt-rep.datetime-beg, v-prev-datetime-end)) / 1000.
      
      v-prev-datetime-end = max(tt-rep.datetime-end, v-prev-datetime-end).
      
      if last-of(tt-rep.grp-num) then do:
         find first tt-grp where
                    tt-grp.grp-num = tt-rep.grp-num
         no-error.
         if avail tt-grp then
            assign
               tt-grp.all-time-length   = v-all-time-length
               tt-grp.all-time-length-2 = (tt-rep.datetime-end - v-first-datetime-beg) / 1000
               .
      end.
   end.
   
   for each tt-rep:
      find first tt-grp where
                 tt-grp.grp-num = tt-rep.grp-num
      no-error.
      if avail tt-grp then do:
         assign
            tt-rep.all-time-length   = tt-grp.all-time-length
            tt-rep.all-time-length-2 = tt-grp.all-time-length-2
            .
         /*
         if tt-rep.cash-pay-name = "" then
            assign
               tt-rep.cash-pay-code = tt-grp.cash-pay-code
               tt-rep.cash-pay-name = tt-grp.cash-pay-name.
         */
      end.
   end.
   
   /* Оставляем записи только со временем отпуска НП >= параметру из фильтра отчета */ 
   for each tt-rep where
            tt-rep.all-time-length-2 < iTranTimeMax * 60:
      delete tt-rep.
   end.
   
   /* Итоги по АЗК */
   vUuidList = "".
   for each tt-rep
   break
      by tt-rep.obj-type
      by tt-rep.obj-code
      by tt-rep.obj-name
      by tt-rep.uuid-cheq:
      if first-of(tt-rep.obj-name) then do:
         create tt-total-rep.
         assign
            tt-total-rep.obj-type = tt-rep.obj-type
            tt-total-rep.obj-code = tt-rep.obj-code
            tt-total-rep.obj-name = tt-rep.obj-name
            .
      end.
      if first-of(tt-rep.uuid-cheq) then do:
         vCheck = no.
         tt-total-rep.qty-chk = tt-total-rep.qty-chk + 1.
      end.

      if can-do(vUuidList, tt-rep.uuid) = no
      then do:
         vCheck = yes.
         vUuidList = vUuidList + (if vUuidList > "" then "," else "") + tt-rep.uuid.
      end.

      if last-of(tt-rep.uuid-cheq) then do:
         if vCheck then
            tt-total-rep.qty-chk-fuel = tt-total-rep.qty-chk-fuel + 1.
      end.
   end.
   release tt-total-rep.
   
   for each tt-rep,
      first tt-total-rep where
            tt-total-rep.obj-type = tt-rep.obj-type
        and tt-total-rep.obj-code = tt-rep.obj-code
        and tt-total-rep.obj-name = tt-rep.obj-name
   break
      by tt-rep.obj-type
      by tt-rep.obj-code
      by tt-rep.obj-name
      by tt-rep.tran-num:
      if first-of(tt-rep.tran-num) then do:
         tt-total-rep.qty-tran       = tt-total-rep.qty-tran + 1.
         tt-total-rep.full-time-tran = tt-total-rep.full-time-tran + tt-rep.time-length.
      end.
   end.
   
   for each tt-total-rep:
      tt-total-rep.avg-time-tran      = tt-total-rep.full-time-tran / tt-total-rep.qty-tran.
      tt-total-rep.avg-time-tran-fuel = tt-total-rep.full-time-tran / tt-total-rep.qty-chk-fuel.
   end.
   
   /* Общие итоги по фирме */
   vUuidList = "".
   for each tt-rep
   break
      by tt-rep.obj-type
      by tt-rep.obj-code
      by tt-rep.uuid-cheq:
      if first-of(tt-rep.obj-code) then do:
         create tt-all-total-rep.
         assign
            tt-all-total-rep.obj-type = tt-rep.obj-type
            tt-all-total-rep.obj-code = tt-rep.obj-code
            .
      end.
      if first-of(tt-rep.uuid-cheq) then do:
         vCheck = no.
         tt-all-total-rep.qty-chk = tt-all-total-rep.qty-chk + 1.
      end.

      if can-do(vUuidList, tt-rep.uuid) = no
      then do:
         vCheck = yes.
         vUuidList = vUuidList + (if vUuidList > "" then "," else "") + tt-rep.uuid.
      end.

      if last-of(tt-rep.uuid-cheq) then do:
         if vCheck then
            tt-all-total-rep.qty-chk-fuel = tt-all-total-rep.qty-chk-fuel + 1.
      end.
   end.
   release tt-all-total-rep.
   
   for each tt-rep,
      first tt-all-total-rep where
            tt-all-total-rep.obj-type = tt-rep.obj-type
        and tt-all-total-rep.obj-code = tt-rep.obj-code
   break
      by tt-rep.obj-type
      by tt-rep.obj-code
      by tt-rep.tran-num:
      if first-of(tt-rep.tran-num) then do:
         tt-all-total-rep.qty-tran       = tt-all-total-rep.qty-tran + 1.
         tt-all-total-rep.full-time-tran = tt-all-total-rep.full-time-tran + tt-rep.time-length.
      end.
   end.
  
   for each tt-all-total-rep:
      tt-all-total-rep.avg-time-tran      = tt-all-total-rep.full-time-tran / tt-all-total-rep.qty-tran.
      tt-all-total-rep.avg-time-tran-fuel = tt-all-total-rep.full-time-tran / tt-all-total-rep.qty-chk-fuel.
   end.

end procedure.

procedure CreateOneRec:
   define parameter buffer obj-list  for obj-list.
   define parameter buffer chk-doc   for chk-doc.
   define parameter buffer tran-fuel for tran-fuel.
   define parameter buffer chk-gds   for chk-gds.
   define parameter buffer goods     for goods.
                                          
   define buffer cash-pay    for cash-pay.
   define buffer b-chk-gds   for chk-gds.
   define buffer b-tran-fuel for tran-fuel.

   define variable v-chk-type-desc as character no-undo.
   define variable v-cash-pay-code as integer   no-undo.
   define variable v-cash-pay-name as character no-undo.
   define variable v-pay-card      as character no-undo.
   define variable v-psn-code      as integer   no-undo.
   define variable v-db-num        as integer   no-undo.
   define variable vDateBeg        as datetime  no-undo.
   define variable vDateEnd        as datetime  no-undo.
   define variable vSeq            as integer   no-undo.
   define variable vMoney          as decimal   no-undo.
   define variable vVolume         as decimal   no-undo.
   define variable vTotSum         as decimal   no-undo.

   do:
      /* Для чеков с типами возврат, сброс транзакции, перевод транзакции в отчет берем объем из чеков  */
      vVolume = if can-do("6,14,16", string(chk-doc.chk-type)) then chk-gds.doc-qnty else tran-fuel.volume. 
      
      empty temp-table tt-pay.
      v-chk-type-desc = entry(lookup(string(chk-doc.chk-type), {&CHK_CODE_LIST}), {&CHK_NAME_LIST}).

      for each chk-pay where
               chk-pay.doc-code = chk-gds.doc-code
      no-lock
      break
         by chk-pay.doc-code
         by chk-pay.tot-sum:
         /* Если одна оплата, то выходим */
         if first-of(chk-pay.doc-code) and last-of(chk-pay.doc-code) then
            leave.

         vSeq = vSeq + 1.
         v-pay-card = if chk-pay.pay-card = "0" then "" else chk-pay.pay-card.

         find first cash-pay where
                    cash-pay.cdpay-code = chk-pay.pay-code
         no-lock no-error.
         if avail cash-pay then
            assign
               v-cash-pay-code = chk-pay.pay-code
               v-cash-pay-name = cash-pay.obj-name
               .
         else
            assign
               v-cash-pay-code = 0
               v-cash-pay-name = ""
               .
         
         /* Если в чеке есть нетопливные товары, то вычтем из самой большого платежа сумму этих товаров */
         vTotSum = chk-pay.tot-sum - (if last-of(chk-pay.doc-code) then 
                                         (chk-doc.tot-doc - chk-gds.sum-base)
                                      else 0). 
         create tt-pay.
         assign
            tt-pay.seq           = vSeq
            tt-pay.volume        = round(vVolume * vTotSum / chk-gds.sum-base, 2)
            tt-pay.money         = vTotSum
            tt-pay.cash-pay-code = v-cash-pay-code
            tt-pay.cash-pay-name = v-cash-pay-name
            tt-pay.pay-card      = v-pay-card
            tt-pay.multi-pay     = yes
            .
            if tt-pay.volume = ? then
               tt-pay.volume = 0.0.
      end.
      
      find first tt-pay no-error.
      if not avail tt-pay then do:
         find first chk-pay where
                    chk-pay.doc-code = chk-gds.doc-code
         no-lock no-error.
         if avail chk-pay then
            assign
               v-pay-card      = if chk-pay.pay-card = "0" then "" else chk-pay.pay-card
               vMoney          = chk-gds.sum-base
               v-cash-pay-code = chk-pay.pay-code
               .
         else
            assign
               v-pay-card       = ""
               vMoney           = tran-fuel.money
               v-cash-pay-code  = (if chk-doc.chk-type = 8 then 0 else tran-fuel.pay-code) /* Для чеков аннуляций тип оплаты берем только с чека */
               .


         find first cash-pay where
                    cash-pay.cdpay-code = v-cash-pay-code
         no-lock no-error.
         v-cash-pay-name = if avail cash-pay then cash-pay.obj-name else "".
         create tt-pay.
         assign
            tt-pay.seq           = 1
            tt-pay.volume        = vVolume
            tt-pay.money         = if chk-doc.chk-type = 1 then vVolume * tran-fuel.price else vMoney
            tt-pay.cash-pay-code = v-cash-pay-code
            tt-pay.cash-pay-name = v-cash-pay-name
            tt-pay.pay-card      = v-pay-card
            .
      end.

      /* Попробуем найти первую из связанных в цепочке транзакций и возьмем из неё время начала */
      find first b-tran-fuel where
                 b-tran-fuel.uuid      = tran-fuel.uuid
             and b-tran-fuel.uuid-cheq = ""
      no-lock no-error.
      if avail b-tran-fuel then
         vDateBeg = b-tran-fuel.date-beg.
      else
         vDateBeg = tran-fuel.date-beg.
      
      /* Корректировка по часовому поясу */
      assign
         vDateBeg = vDateBeg           + Timezone * 60000
         vDateEnd = tran-fuel.date-end + Timezone * 60000.
         .
      for each tt-pay:
         create tt-rep.
         assign
            tt-rep.obj-type        = obj-list.obj-type
            tt-rep.obj-code        = obj-list.obj-code
            tt-rep.obj-name        = obj-list.obj-name
            tt-rep.chk-date        = chk-doc.chk-date
            tt-rep.chk-time        = chk-doc.chk-time
            tt-rep.shift-date      = chk-doc.shift-date
            tt-rep.shift-name      = chk-doc.shift-name + "(" + string(chk-doc.shift-num) + ")"
            tt-rep.chk-num         = chk-doc.chk-num
            tt-rep.doc-num2        = (if num-entries(chk-doc.doc-num2, ":") > 1 then entry(1, chk-doc.doc-num2, ":") else "")
            tt-rep.z-number        = chk-doc.z-number
            tt-rep.tran-num        = tran-fuel.tran-num
            tt-rep.chk-type-desc   = v-chk-type-desc
            tt-rep.cash-num        = tran-fuel.cash-num
            tt-rep.trk-num         = tran-fuel.trk-num + 1
            tt-rep.nozzle-num      = tran-fuel.nozzle-num + 1
            tt-rep.fuel-code       = chk-gds.b-code
            tt-rep.gds-name        = goods.gds-name
            tt-rep.volume          = tt-pay.volume
            tt-rep.price           = tran-fuel.price
            tt-rep.money           = tt-pay.money
            tt-rep.cash-pay-code   = tt-pay.cash-pay-code
            tt-rep.cash-pay-name   = tt-pay.cash-pay-name
            tt-rep.pay-card        = tt-pay.pay-card
            tt-rep.datetime-beg    = vDateBeg
            tt-rep.date-beg        = date(vDateBeg)
            tt-rep.time-beg        = mtime(vDateBeg) / 1000
            tt-rep.datetime-end    = vDateEnd
            tt-rep.date-end        = date(vDateEnd)
            tt-rep.time-end        = mtime(vDateEnd) / 1000
            tt-rep.time-length     = (vDateEnd - vDateBeg) / 1000
            tt-rep.all-time-length = tt-rep.time-length
            tt-rep.multi-pay       = tt-pay.multi-pay
            tt-rep.resume-tran     = no
            tt-rep.uuid            = tran-fuel.uuid
            tt-rep.uuid-cheq       = tran-fuel.uuid-cheq
            .
         /* Если перевод транзакции, то берем количество, номер колонки и пистолета из строки чека */
         if chk-doc.chk-type = 16 and chk-gds.src-qnty <= 0 then do:
            find first b-chk-gds where
                       b-chk-gds.doc-code = chk-gds.doc-code
                   and b-chk-gds.b-code   = chk-gds.b-code
                   and b-chk-gds.line-num > chk-gds.line-num
            no-lock no-error.
            if avail b-chk-gds then
               assign
                  tt-rep.volume     = b-chk-gds.doc-qnty
                  /* tt-rep.trk-num    = b-chk-gds.pump */
                  tt-rep.nozzle-num = b-chk-gds.nozzle-code
                  .
         end.
   
         { gbl/objdbnum.i obj-list.obj-type obj-list.obj-code v-db-num }
   
         v-psn-code = gbclcode-is-this-db-role ({&role-cashier},
                                                v-db-num,
                                                chk-doc.cashier,
                                                chk-doc.chk-date
                                                ).
   
         find first clients where
                    clients.obj-type = {&prs}
                and clients.obj-code = v-psn-code
         no-lock no-error.
         if available clients then
            tt-rep.cashier = clients.obj-name.
      end.
   end.
end procedure.


procedure PrintTT:
   define variable vReportId     as character no-undo.
   define variable vFileNameRep  as character no-undo.
   define variable vLevel        as character no-undo.
   define variable vPrevUuidCheq as character no-undo.
   define variable vPrevUuid     as character no-undo.
   define variable vStr          as character no-undo.
   define variable vI            as integer   no-undo.

   do on error undo, return error return-value:
      run get-report-num(output vReportId).
      vFileNameRep = session:temp-directory + string(vReportId) + ".html".

      output stream sOutStr-html to value(vFileNameRep) convert target 'UTF-8'.
      put stream sOutStr-html unformatted
         "<!DOCTYPE HTML>" skip
            ' <html>' skip
            '  <head>' skip
            '   <meta charset="utf-8">' skip
            '    <style type="text/css">' skip
            '      table ' + chr(123) + ' border-collapse: collapse; ' + chr(125) skip
            '      .class1 ' + chr(123) + ' border-collapse: collapse; ' + chr(125) skip
            '      tbody td, th ' + chr(123) + ' border-collapse: collapse; border: 1px solid black; height: 14px;' + chr(125) skip
            '   </style>' skip
            '  </head>' skip
         .

      put stream sOutStr-html unformatted
           '<body>' skip
           '<TABLE name="1" outline_below="true" fit_to_page="true" orientation="landscape" CELLSPACING="0" BORDER="0">' skip
           '<thead>' skip
           '<TR class="set_columns">' skip
               '<TD style="width:  68px;"></TD>' skip            /*  1    */
               '<TD style="width: 111px;"></TD>' skip            /*  2    */
               '<TD style="width:  84px;"></TD>' skip            /*  3    */
               '<TD style="width:  78px;"></TD>' skip            /*  4    */
               '<TD style="width:  88px;"></TD>' skip            /*  5    */
               '<TD style="width:  80px;"></TD>' skip            /*  6    */
               '<TD style="width:  95px;"></TD>' skip            /*  7    */
               '<TD style="width:  84px;"></TD>' skip            /*  8    */
               '<TD style="width: 148px;"></TD>' skip            /*  9    */
               '<TD style="width:  64px;"></TD>' skip            /*  10   */
               '<TD style="width: 150px;"></TD>' skip            /*  11   */
               '<TD style="width:  65px;"></TD>' skip            /*  12   */
               '<TD style="width: 108px;"></TD>' skip            /*  13   */
               '<TD style="width:  72px;"></TD>' skip            /*  14   */
               '<TD style="width: 113px;"></TD>' skip            /*  15   */
               '<TD style="width:  79px;"></TD>' skip            /*  16   */
               '<TD style="width:  82px;"></TD>' skip            /*  17   */
               '<TD style="width:  97px;"></TD>' skip            /*  18   */
               '<TD style="width: 150px;"></TD>' skip            /*  19   */
               '<TD style="width: 157px;"></TD>' skip            /*  20   */
               '<TD style="width:  88px;"></TD>' skip            /*  21   */
               '<TD style="width:  81px;"></TD>' skip            /*  22   */
               '<TD style="width:  85px;"></TD>' skip            /*  23   */
               '<TD style="width: 100px;"></TD>' skip            /*  24   */
               '<TD style="width:  91px;"></TD>' skip            /*  25   */
               '<TD style="width:  91px;"></TD>' skip            /*  26   */
               '<TD style="width: 103px;"></TD>' skip            /*  27   */
           '</TR>' skip
           '<TR>' skip
               '<TD colspan="12" STYLE="font-size: 14px;">' + 'Отчет по продолжительности топливных транзакций' + '</TD>'skip
           '</TR>' skip
           .

      do vI = 1 to extent(mParamStr):
         if mParamStr[vI] = "" then leave.
         put stream sOutStr-html unformatted
              '<TR>' skip
                  '<TD colspan="12" STYLE="font-size: 14px;">' + mParamStr[vI] + '</TD>' skip
              '</TR>' skip
            .
      end.

      put stream sOutStr-html unformatted
           '<TR>' skip
               '<TD colspan="12" STYLE="font-size: 14px;">Дата печати: ' + string(today, "99.99.9999") + ' ' + string(time, "HH:MM") + '</TD>' skip
           '</TR>' skip
           '</thead>' skip
         .

      put stream sOutStr-html unformatted
         '<tbody>'
         '<TR >'skip
            '<TH style="text-align: center; font-weight:bold; ">Название АЗС/АЗК</TH>'                 skip
            '<TH style="text-align: center; font-weight:bold; ">Дата чека</TH>'                        skip
            '<TH style="text-align: center; font-weight:bold; ">Время чека</TH>'                       skip
            '<TH style="text-align: center; font-weight:bold; ">Дата смены</TH>'                       skip
            '<TH style="text-align: center; font-weight:bold; ">Номер смены</TH>'                      skip
            '<TH style="text-align: center; font-weight:bold; ">Номер чека</TH>'                       skip
            '<TH style="text-align: center; font-weight:bold; ">Номер Z-отчета</TH>'                   skip
            '<TH style="text-align: center; font-weight:bold; ">Номер топливной транзакции</TH>'       skip
            '<TH style="text-align: center; font-weight:bold; ">Тип чека</TH>'                         skip
            '<TH style="text-align: center; font-weight:bold; ">Номер кассы</TH>'                      skip
            '<TH style="text-align: center; font-weight:bold; ">ФИО кассира</TH>'                      skip
            '<TH style="text-align: center; font-weight:bold; ">Номер ТРК</TH>'                        skip
            '<TH style="text-align: center; font-weight:bold; ">Номер пистолета</TH>'                  skip
            '<TH style="text-align: center; font-weight:bold; ">Код топлива</TH>'                      skip
            '<TH style="text-align: center; font-weight:bold; ">Наименование топлива</TH>'             skip
            '<TH style="text-align: center; font-weight:bold; ">Объем топлива, л</TH>'                 skip
            '<TH style="text-align: center; font-weight:bold; ">Цена топлива, р</TH>'                  skip
            '<TH style="text-align: center; font-weight:bold; ">Сумма, р</TH>'                         skip
            '<TH style="text-align: center; font-weight:bold; ">Тип оплаты</TH>'                       skip
            '<TH style="text-align: center; font-weight:bold; ">Номер карты</TH>'                      skip
            '<TH style="text-align: center; font-weight:bold; ">Дата начала транзакции</TH>'           skip
            '<TH style="text-align: center; font-weight:bold; ">Время начала транзакции</TH>'          skip
            '<TH style="text-align: center; font-weight:bold; ">Дата окончания транзакции</TH>'        skip
            '<TH style="text-align: center; font-weight:bold; ">Время окончания транзакции</TH>'       skip
            '<TH style="text-align: center; font-weight:bold; ">Продолжительность транзакции (*)</TH>' skip
            '<TH style="text-align: center; font-weight:bold; ">Жизненный цикл заказа НП</TH>'         skip
            '<TH style="text-align: center; font-weight:bold; ">Продолжение налива</TH>'               skip
         '</TR>'skip
         .

      for each tt-rep
      break
         by tt-rep.obj-code
         by tt-rep.grp-num
         by tt-rep.datetime-beg
         by tt-rep.datetime-end
         by tt-rep.chk-date
         by tt-rep.chk-time:
            
         vLevel = "".
         if not first-of(tt-rep.grp-num) then do:
            if iGrpChk or iGrpTran then do:
               if iGrpChk and iGrpTran then
                  vLevel = 'level="2"'.
               else if iGrpChk and tt-rep.uuid-cheq = vPrevUuidCheq then
                  vLevel = 'level="2"'.
               else if iGrpTran and tt-rep.uuid = vPrevUuid then
                  vLevel = 'level="2"'.
            end.
         end.
         assign
            vPrevUuidCheq = tt-rep.uuid-cheq
            vPrevUuid     = tt-rep.uuid
            .
         put stream sOutStr-html unformatted
            '<TR ' vLevel '>' skip
                '<TD style="text-align: center">'                  fStrNvl(tt-rep.obj-name, "")                                '</TD>' skip
                '<TD style="text-align: center">'                  fdate2str(tt-rep.chk-date, "99.99.9999")                    '</TD>' skip
                '<TD style="text-align: center">'                  fStrNvl(string(tt-rep.chk-time, "HH:MM:SS"), "")            '</TD>' skip
                '<TD style="text-align: center">'                  fdate2str(tt-rep.shift-date, "99.99.9999")                  '</TD>' skip
                '<TD style="text-align: center">'                  fStrNvl(tt-rep.shift-name, "")                              '</TD>' skip
                '<TD style="text-align: center">'                  fInt2Str(tt-rep.chk-num, ">>>>>>>>>9")                      '</TD>' skip
                '<TD style="text-align: center">'                  fInt2Str(tt-rep.z-number, ">>>>>>>>>9")                     '</TD>' skip
                '<TD style="text-align: center">'                  fInt2Str(tt-rep.tran-num, ">>>>>>>>>9")                     '</TD>' skip
                '<TD text_wrap="true" style="text-align: center">' fStrNvl(tt-rep.chk-type-desc, "")                           '</TD>' skip
                '<TD style="text-align: center">'                  fInt2Str(tt-rep.cash-num, ">>>>9")                          '</TD>' skip
                '<TD text_wrap="true" style="text-align: left">' fStrNvl(tt-rep.cashier, "")                                 '</TD>' skip
                '<TD style="text-align: center">'                  fInt2Str(tt-rep.trk-num, ">>9")                             '</TD>' skip
                '<TD style="text-align: center">'                  fInt2Str(tt-rep.nozzle-num, ">>9")                          '</TD>' skip
                '<TD style="text-align: center">'                  fInt2Str(tt-rep.fuel-code, ">>>>>>>>>9")                    '</TD>' skip
                '<TD text_wrap="true" style="text-align: center">' fStrNvl(tt-rep.gds-name, "")                                '</TD>' skip
                '<TD num="#,##0.00" val="' + fDec2Str(tt-rep.volume, "->>>>>>>>>>>9.99") + '" style="text-align: right">' + fDec2Str(tt-rep.volume, "->>>>>>>>>>>9.99") + '</TD>' skip
                '<TD num="#,##0.00" val="' + fDec2Str(tt-rep.price, "->>>>>>>>>>>9.99") + '" style="text-align: right">'  + fDec2Str(tt-rep.price, "->>>>>>>>>>>9.99") + '</TD>' skip
                '<TD num="#,##0.00" val="' + fDec2Str(tt-rep.money, "->>>>>>>>>>>9.99") + '" style="text-align: right">'  + fDec2Str(tt-rep.money, "->>>>>>>>>>>9.99") + '</TD>' skip
                '<TD text_wrap="true" style="text-align: center">' fStrNvl(tt-rep.cash-pay-name, "")                           '</TD>' skip
                '<TD style="text-align: center">'                  fStrNvl(tt-rep.pay-card, "")                                '</TD>' skip
                '<TD style="text-align: center">'                  fdate2str(tt-rep.date-beg, "99.99.9999")                    '</TD>' skip
                '<TD style="text-align: center">'                  fStrNvl(string(tt-rep.time-beg, "HH:MM:SS"), "")            '</TD>' skip
                '<TD style="text-align: center">'                  fdate2str(tt-rep.date-end, "99.99.9999")                    '</TD>' skip
                '<TD style="text-align: center">'                  fStrNvl(string(tt-rep.time-end, "HH:MM:SS"), "")            '</TD>' skip
                '<TD style="text-align: center">'                  fStrNvl(string(tt-rep.time-length, "HH:MM:SS"), "")         '</TD>' skip
                '<TD style="text-align: center">'                  fStrNvl(string(tt-rep.all-time-length-2, "HH:MM:SS"), "")   '</TD>' skip
                '<TD style="text-align: center">'                  string(tt-rep.resume-tran, "+/-")                           '</TD>' skip
            '</TR>' skip.
         if last-of(tt-rep.obj-code) then do:
            for first tt-total-rep where
                      tt-total-rep.obj-type = tt-rep.obj-type
                  and tt-total-rep.obj-code = tt-rep.obj-code
                  and tt-total-rep.obj-name = tt-rep.obj-name:
               put stream sOutStr-html unformatted
                  '<TR >' skip
                      '<TD style="text-align: left; font-weight:bold">'                   "Итого по:"                                                       '</TD>' skip
                      '<TD style="text-align: left; font-weight:bold">'                   fStrNvl(tt-total-rep.obj-name, "")                                '</TD>' skip
                      '<TD text_wrap="true" style="text-align: left; font-weight:bold">'  "Количество чеков"                                                '</TD>' skip
                      '<TD style="text-align: left; font-weight:bold">'                    fInt2Str(tt-total-rep.qty-chk, ">>>9")                           '</TD>' skip
                      '<TD text_wrap="true" style="text-align: left; font-weight:bold">'  "Количество транзакций"                                           '</TD>' skip
                      '<TD style="text-align: left; font-weight:bold">'                    fInt2Str(tt-total-rep.qty-tran, ">>>9")                          '</TD>' skip
                      '<TD text_wrap="true" style="text-align: left; font-weight:bold">'  "Количество  чеков с транзакциями"                                 '</TD>' skip
                      '<TD style="text-align: left; font-weight:bold">'                    fInt2Str(tt-total-rep.qty-chk-fuel, ">>>9")                      '</TD>' skip
                      '<TD text_wrap="true" style="text-align: left; font-weight:bold">'  "Общая продолжительность"                                         '</TD>' skip
                      '<TD style="text-align: left; font-weight:bold">'                    fStrNvl(string(tt-total-rep.full-time-tran, "HH:MM:SS"), "")     '</TD>' skip
                      '<TD text_wrap="true" style="text-align: left; font-weight:bold">'  "Средняя продолжительность"                                       '</TD>' skip
                      '<TD style="text-align: left; font-weight:bold">'                    fStrNvl(string(tt-total-rep.avg-time-tran, "HH:MM:SS"), "")      '</TD>' skip
                      '<TD text_wrap="true" style="text-align: left; font-weight:bold">'  "Средняя длительность жизненного цикла заказа НП"                 '</TD>' skip
                      '<TD style="text-align: left; font-weight:bold">'                    fStrNvl(string(tt-total-rep.avg-time-tran-fuel, "HH:MM:SS"), "") '</TD>' skip
                      .
            end.
            do vI = 1 to 13:
               put stream sOutStr-html unformatted
                  '<TD style="text-align: right"> </TD>' skip
                  .
            end.
            put stream sOutStr-html unformatted
                  '</TR>' skip.
         end.
      end.
      
      for first tt-all-total-rep:
         put stream sOutStr-html unformatted
            '<TR >' skip
                '<TD style="text-align: left; font-weight:bold">'                   "Итого по:"                                                          '</TD>' skip
                '<TD text_wrap="true" style="text-align: left; font-weight:bold">'  "Всем выбранным объектам"                                            '</TD>' skip
                '<TD text_wrap="true" style="text-align: left; font-weight:bold">'  "Количество чеков"                                                   '</TD>' skip
                '<TD style="text-align: left; font-weight:bold">'                    fInt2Str(tt-all-total-rep.qty-chk, ">>>9")                          '</TD>' skip
                '<TD text_wrap="true" style="text-align: left; font-weight:bold">'  "Количество транзакций"                                              '</TD>' skip
                '<TD style="text-align: left; font-weight:bold">'                    fInt2Str(tt-all-total-rep.qty-tran, ">>>9")                         '</TD>' skip
                '<TD text_wrap="true" style="text-align: left; font-weight:bold">'  "Количество  чеков с отпуском НП"                                    '</TD>' skip
                '<TD style="text-align: left; font-weight:bold">'                    fInt2Str(tt-all-total-rep.qty-chk-fuel, ">>>9")                     '</TD>' skip
                '<TD text_wrap="true" style="text-align: left; font-weight:bold">'  "Общая продолжительность"                                            '</TD>' skip
                '<TD style="text-align: left; font-weight:bold">'                    fStrNvl(string(tt-all-total-rep.full-time-tran, "HH:MM:SS"), "")    '</TD>' skip
                '<TD text_wrap="true" style="text-align: left; font-weight:bold">'  "Средняя продолжительность"                                          '</TD>' skip
                '<TD style="text-align: left; font-weight:bold">'                    fStrNvl(string(tt-all-total-rep.avg-time-tran, "HH:MM:SS"), "")     '</TD>' skip
                '<TD text_wrap="true" style="text-align: left; font-weight:bold">'  "Средняя длительность жизненного цикла заказа НП"                    '</TD>' skip
                '<TD style="text-align: left; font-weight:bold">'                    fStrNvl(string(tt-all-total-rep.avg-time-tran-fuel, "HH:MM:SS"), "") '</TD>' skip
                .
         do vI = 1 to 13:
            put stream sOutStr-html unformatted
               '<TD style="text-align: right"> </TD>' skip
               .
         end.
         put stream sOutStr-html unformatted
               '</TR>' skip.
      end.
      
      vStr = "(*) В отчете для всех строк с транзакцией, связанной с несколькими чеками или строками чеков (при смешанной оплате), " +
             "отображается одинаковая продолжительность. Данное время не определяет длительность выполнения конкретной кассовой операции " + 
             "(например, возврат, сброс, аннуляция, смешанная оплата), относящейся к транзакции".
      put stream sOutStr-html unformatted
         '<TR>'  skip
            '<TD colspan="27" STYLE="font-size: 11px;">' + vStr + '</TD>' skip
         '</TR>' skip.
         
      put stream sOutStr-html unformatted
         '</tbody>' skip
         '</table>' skip
         '</body>' skip
         '</html>' skip
         .
         
      output stream sOutStr-html close.

      run prn-lib-reportviewer-report-name in this-procedure (
          input parparentproc
          ,input vFileNameRep
          ) no-error.
      if error-status:error then
      do:
          message "error-status:error = " error-status:error skip return-value view-as alert-box.
          return .
      end.
            
   end.

end procedure.

PROCEDURE get-report-num :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
define output parameter p-report-num as integer no-undo .

  do
  on error undo, return error return-value
  :
    run gbl/getrpnum.p (output p-report-num).
  end.

END PROCEDURE.