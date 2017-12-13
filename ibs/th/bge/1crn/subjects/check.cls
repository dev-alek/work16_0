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

class ibs.th.bge.1crn.subjects.check implements iexpsubject:

  { cmp/str-glbl.i class }
  { str/lib-trn.i  class }
  { ref/extclass.i }

  define property Msg as character no-undo
    get:
      return trim (Msg, {&new-line}).
    end.
    private set (inArg as char):
      Msg = Msg + {&new-line} + inArg.
    end.

  &scop tag-interface 'checks':U
  define property InitSecTag as character no-undo init {&tag-interface}
    get.

  define property BufHandle as handle no-undo
    get.
    set.

  define private variable libFindtank as class ibs.th.str.findtank no-undo . /* обёртка для findtank.i */

  define private variable m-chk-types as enum-chk-type extent 17 no-undo . /* маппинг типов чеков наших на 1с */
    
  &scop tag-message   'check':U
  &scop tag-section1  'chk-gds':U
  &scop tag-item1     'chk-gd':U
  &scop tag-section2  'chk-pays':U
  &scop tag-item2     'chk-pay':U
  &scop tag-section3  'chk-discnts':U
  &scop tag-item3     'chk-discnt':U
  &scop tag-section4  'chk-bonus-ps':U
  &scop tag-item4     'chk-bonus-p':U
  &scop tag-section5  'chk-bonus-ms':U
  &scop tag-item5     'chk-bonus-m':U
  &scop tag-section6  'chk-pays-r':U
  &scop tag-item6     'chk-pay-r':U

  constructor public check ():
  end constructor.
  
  /*------------------------------------------------------------------------------
   Purpose: выгружает несколько чеков со всеми потрохами в контекст контейнера SAX-writer
   Notes:   обязательный метод
   Param:   insw = create sax-writer
  ------------------------------------------------------------------------------*/
  method public void CrContentToSW (insw as handle):
    /* define buffer buf_inkas   for ub.inkas . */
    define buffer buf_chk-doc for ub.chk-doc .
    define variable v-fld-inkas-code as handle no-undo .
    define variable v-inkas-code     as character no-undo .

    Msg = "" .
    if not valid-handle(BufHandle) then undo, throw new Progress.Lang.AppError("Отсутствует запись ПРОДАЖИ inkas") .

    v-fld-inkas-code = BufHandle:buffer-field( "inkas-code":U ) .
    v-inkas-code = v-fld-inkas-code:buffer-value .
    
    libFindtank = new ibs.th.str.findtank ().


    for each buf_chk-doc no-lock
       where buf_chk-doc.out-code = v-inkas-code
         and buf_chk-doc.chk-type <> {&bef-rcpt-annu} : /* 29/XI-2017 аннуляцию не выгружаем */
      CrContentInterfaceToSW (insw, buffer buf_chk-doc) .
    end . /* end_of for_each buf_chk-doc */
    

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
    finally :
      if valid-object(libFindtank) then delete object libFindtank .
    end finally .
  end method . /* end_of CrContentToSW */


  /*------------------------------------------------------------------------------
   Purpose: выгружает содержимое чека и вложенные секции в контекст контейнера SAX-writer
   Param:   insw = create sax-writer
  ------------------------------------------------------------------------------*/
  method private void CrContentInterfaceToSW (insw as handle
                                          , buffer buf_chk-doc for ub.chk-doc) :
    define buffer buf_dis-card     for ub.dis-card .
    define buffer buf_chk-gds      for ub.chk-gds .
    define buffer buf_bar-code     for ub.bar-code .
    define buffer buf_goods        for ub.goods .
    define buffer buf_chk-gds-attr for ub.chk-gds-attr .
    define buffer buf_ext-classif  for ub.ext-classif .
    define buffer buf_chk-pay      for ub.chk-pay .
    define buffer buf_chk-pay-attr for ub.chk-pay-attr .
    define buffer buf_chk-discnt   for ub.chk-discnt .
    define buffer buf_chk-gds-pay  for ub.chk-gds-pay .
    define variable v-is-petrolium as logical no-undo . /* true = топливо */
    define variable v-is-pieces    as logical no-undo .
    define variable v-loc1         as character no-undo . /* номер резервуара */
    define variable v-spump        as character no-undo . /* номер ТРК */ 
    define variable v-snozzle-code as character no-undo . /* номер пистолета */
    define variable v-key-one      as integer no-undo . /* для поиска оператора сотовой связи */

    insw:start-element ({&tag-message}) .

    /* обязательность 1-1 */
    if buf_chk-doc.shift-date = ? then insw:write-empty-element ( "shift-date":U ) . /* Дата смены (Дата) */
    else insw:write-data-element (  "shift-date":U,  iso-date(buf_chk-doc.shift-date)  ). 

    insw:write-data-element (  "shift-num":U,       string(buf_chk-doc.shift-num)   ). /* Номер смены (Число) */
    insw:write-data-element (  "chk-num":U,         string(buf_chk-doc.chk-num)     ). /* Номер чека на кассе (Число) */
    insw:write-data-element (  "cb-num":U,          string(buf_chk-doc.pay-desk)    ). /* Номер кассы (Число) */
    insw:write-data-element (  "chk-id":U,                 buf_chk-doc.doc-code     ). /* Номер чека в GC (Строка) */
    
    /* обязательность 0-1 для del-l, ext-num, direct-chk-num */
    
    /* 04/XII-2017 при удалении продажи чеки у нас не удаляются: они просто остаются непривязанными к продаже.
                   При удалении продажи надо посылать чеки с del-l = 1 (в протоколе поля del-l раньше не было) */
    /* 07/XII-2017 теперь чеки выгружаем вместе с закрытием смены, и никакое удаление продаж на них не влияет */

    /* 17/XI-2017 Добавляем поле «ext-num» в шапку.
       В поле хранятся внешние номера, в нашем случае номер карты активации, с типом платежа «Активация». */
    if buf_chk-doc.doc-num > "" then
    insw:write-data-element (  "ext-num":U,         buf_chk-doc.doc-num   ). /* Внешний номер. В случае типа платежа «активация» номер карты активации (Строка) */
    
    /* 17/XI-2017 Добавляем поле «direct-chk-num» в шапке.
       В этом поле будет номер прямого чека. */
    if buf_chk-doc.doc-num2 > "" then
    insw:write-data-element (  "direct-chk-num":U,  buf_chk-doc.doc-num2  ). /* Номер прямого чека (Строка) */
    
    /* обязательность 1-1 */
    if buf_chk-doc.chk-date = ? then insw:write-empty-element( "chk-date":U ). /* Дата чека (Дата) */
    else insw:write-data-element (  "chk-date":U,  iso-date(buf_chk-doc.chk-date)  ).
    
    insw:write-data-element (  "chk-time",     timeFormat(buf_chk-doc.chk-time)    ). /* Время чека (Время) */
    insw:write-data-element (  "cashier",          string(buf_chk-doc.cashier)     ). /* Код кассира (Строка) */
    insw:write-data-element (  "z-num",            string(buf_chk-doc.z-number)    ). /* Номер z-отчета (Число) */
    insw:write-data-element (  "chk-type", left-trim(string(buf_chk-doc.chk-type, ">9"))    ). /* Тип чека (Число, enum) */
    insw:write-data-element (  "netto",   left-trim(string(buf_chk-doc.netto,   "->>>>>>>>9.9<"))  ). /* Сумма чека нетто в валюте продаж. Выручка со скидками. (Число) */
    insw:write-data-element (  "tot-doc", left-trim(string(buf_chk-doc.tot-doc, "->>>>>>>>9.9<"))  ). /* Сумма брутто по чеку в валюте продаж. Сумма по текущей розничной цене (Число) */

    /* обязательность 0-1 */
    
    /* 28/XI-2017 term-num будет строкой, поэтому пустой можно, и необязательный. */
    if "" > "" then insw:write-data-element ( "term-num", "" ).  /* Номер терминала POS (Строка) */

    if buf_chk-doc.d-card > "" then do:
      insw:write-data-element (  "dc-num",          buf_chk-doc.d-card      ). /* Номер ДК (Строка) */
      find first buf_dis-card no-lock
           where buf_dis-card.d-card = buf_chk-doc.d-card no-error .
      if available buf_dis-card then do:
        /* обязательность 0-1 */
        if buf_dis-card.card-num > 0 then
      insw:write-data-element (  "dc-name",  string(buf_dis-card.type)  ). /* Наименование ДК (Строка) */
      end.
    end.  


    /* section1 обязательность 1-1 */
    insw:start-element ({&tag-section1}) .
    if can-find (first buf_chk-gds where buf_chk-gds.doc-code = buf_chk-doc.doc-code) then do:
      for each buf_chk-gds no-lock
         where buf_chk-gds.doc-code = buf_chk-doc.doc-code :
        insw:start-element ({&tag-item1}) .
        
        insw:write-data-element (  "line-num",  string(buf_chk-gds.line-num)  ) . /* Номер строки чека (Число) */
        
        /* обязательность 1-1 на trk-num, tank-num, trk-pnum, gd-code;
           для нетоплива trk-num, tank-num, trk-pnum создавать пустыми;
           22/XI-2017 пустые числовые поля создавать с нулями */
        find first buf_bar-code no-lock where buf_bar-code.b-code = buf_chk-gds.b-code no-error.
        if available buf_bar-code then do:
          /* 1. товар в goods надо найти для того, чтобы получить artic, prod-type, prod-code */
          find first buf_goods no-lock where buf_goods.gds-code = buf_bar-code.gds-code no-error.
          if available buf_goods then do:
            /* 2. внутри is-petrl.i поля artic, prod-type, prod-code используются для поиска товара в goods */
            { str/is-petrl.i
              buf_goods.artic
              buf_goods.prod-type
              buf_goods.prod-code
              v-is-petrolium
              v-is-pieces
            }
            /* 3. внутри is-petrl.i не используется поле gds-code для поиска товара в goods */
          end .
          else v-is-petrolium = false .
        end .
        else v-is-petrolium = false .
        
        if v-is-petrolium then do :
          /* номер резервуара */
          if buf_chk-gds.pl-code > 0 then v-loc1 = string (buf_chk-gds.pl-code).
          else if available buf_bar-code then do:
            v-loc1 = getTankNum
              (input buf_chk-doc.obj-type
              ,input buf_chk-doc.obj-code
              ,input buf_chk-gds.pump
              ,input buf_chk-gds.nozzle-code
              ,input buf_chk-gds.src-pl-code
              ,input buf_chk-gds.pl-code  
              ,input buf_bar-code.gds-code
              ) .
          end.
          else v-loc1 = "" .

          /* номер ТРК, номер пистолета */
          assign
            v-spump        = string(buf_chk-gds.pump)
            v-snozzle-code = string(buf_chk-gds.nozzle-code)            
          .           
        end .
        else assign
          v-loc1  = ""
          v-spump = ""
          v-snozzle-code = ""
        .
    
        insw:write-data-element (  "trk-num",  if v-spump        > "" then v-spump        else "0"  ) . /* Номер ТРК (Число) */
        insw:write-data-element (  "tank-num", if v-loc1         > "" then v-loc1         else "0"  ) . /* Номер резервуара (Число) */
        insw:write-data-element (  "trk-pnum", if v-snozzle-code > "" then v-snozzle-code else "0"  ) . /* Номер пистолета ТРК (Число) */
          
        if available buf_bar-code then insw:write-data-element (  "gd-code",  string(buf_bar-code.gds-code)  ) .
                                  else insw:write-empty-element ( "gd-code" ) . /* Код товара (Строка) */
        
        insw:write-data-element (  "qnty",  left-trim(string(buf_chk-gds.doc-qnty, "->>>>>>>9.999"))  ) . /* Количество. Для НП количество литров. (Число 15,3) */

        /* обязательность 0-1; только для топливных чеков: к объёму в литрах прикладывается вес в киллограммах */
        if v-is-petrolium and (buf_chk-gds.density > 0) then do :
          insw:write-data-element (  "cap",
            left-trim( string(buf_chk-gds.doc-qnty * buf_chk-gds.density, "->>>>>>>>9.999") )
          ) . /* Объем, кг (Число 15,3) */ 
        end.

        insw:write-data-element (  "sum",  left-trim(string(buf_chk-gds.sum-base, "->>>>>>>>9.99"))  ) . /* Сумма (Число 15,2) */
        
        
        /* далее обязательность 0-1 */
        
        /* chk-gds.discnt - скидка относительно цены; чтобы получить скидку по строке - её надо умножать на количество */
        if (buf_chk-gds.discnt > 0) or (buf_chk-gds.discnt < 0) then
        insw:write-data-element (  "sum-discnt",
          left-trim( string(buf_chk-gds.doc-qnty * buf_chk-gds.discnt, "->>>>>>>>>9.9<<<<<<<<<") )
        ) . /* Скидка на строку товара - с учетом всех скидок на строку и на итог (Число) */
        
        if v-is-petrolium and (buf_chk-gds.density > 0) then
        insw:write-data-element (  "dnsty",  string(buf_chk-gds.density, "9.9999999999")  ) . /* Плотность (Число 12,10) */
        
        if buf_chk-gds.pass-gds > 0 then
        insw:write-data-element (  "dry-chk",  string(buf_chk-gds.pass-gds)  ) . /* Признак сухого чека (Число 1,0) */

        /* обязательность 0-1
           «Оператор» это оператор сотовой связи. Берется из атрибута строки чека с кодом oss-code.
           Название подтягивается из соответствующего справочника.
        */
        find first buf_chk-gds-attr no-lock
             where buf_chk-gds-attr.doc-code  = buf_chk-gds.doc-code
               and buf_chk-gds-attr.line-num  = buf_chk-gds.line-num
               and buf_chk-gds-attr.attr-code = 'oss-code' no-error .
        if available buf_chk-gds-attr then do:
          insw:write-data-element (  "operator-code",  buf_chk-gds-attr.attr-value  ) . /* Код оператора(эмитента) (Строка) */
          v-key-one = integer (buf_chk-gds-attr.attr-value) no-error .
          find first buf_ext-classif no-lock
               where buf_ext-classif.classif-subject = {&extclass_oss-ref}
                 and buf_ext-classif.Key#_One        = v-key-one no-error .
          if available buf_ext-classif then
            insw:write-data-element (  "operator-name",  entry(1, ext-classif.charkey_two, {&delim-par})  ) . /* Наименование оператора(эмитента) (Строка) */
        end .

        /* 17/XI-2017 Добавляем поле «price» (цена до применения скидок) в секции «chk-gd». */
        insw:write-data-element (  "price",  left-trim(string(buf_chk-gds.src-price, "->>>>>>>>9.99"))  ) . /* Цена до применения скидок (Число 15,2) */

        insw:end-element ({&tag-item1}) .
      end . /* end_of for each buf_chk-gds */
    end .
    else do:
      insw:write-empty-element ({&tag-item1}) .
    end .
    insw:end-element ({&tag-section1}) .


    /* section2 обязательность 0-1 */
    for each buf_chk-pay no-lock
       where buf_chk-pay.doc-code = buf_chk-doc.doc-code
    break by buf_chk-pay.doc-code :
      if first-of(buf_chk-pay.doc-code) then insw:start-element ({&tag-section2}) .
      insw:start-element ({&tag-item2}) .
      
      insw:write-data-element (  "pay-num",  string(buf_chk-pay.line-num)  ) . /* Номер строки платежа (Число) */
      insw:write-data-element (  "pay-code",  string(buf_chk-pay.pay-code)  ) . /* Код платежа (Строка) */
      
      /* обязательность 0-1 */
      if buf_chk-pay.pay-card > "" then 
      insw:write-data-element (  "pay-card",  string(buf_chk-pay.pay-card)  ) . /* Номер платежной карты (Строка) */
      
      find first buf_chk-pay-attr no-lock
           where buf_chk-pay-attr.doc-code  = buf_chk-pay.doc-code
             and buf_chk-pay-attr.attr-code = "cpdoc":U
             and buf_chk-pay-attr.line-num  = buf_chk-pay.line-num no-error.
      if available buf_chk-pay-attr then 
      insw:write-data-element (  "rrn",  buf_chk-pay-attr.attr-value  ) . /* RNN платежа (Строка) */
      
      insw:write-data-element (  "sum",  left-trim(string(buf_chk-pay.tot-rubl, "->>>>>>>>>9.9<<<<<<<<<"))  ) . /* Сумма платежа (либо бонус в рублевом эквиваленте) (Число) */

      insw:end-element ({&tag-item2}) .
      if last-of(buf_chk-pay.doc-code) then insw:end-element ({&tag-section2}) .
    end . /* end_of for each buf_chk-pay */


    /* section3 обязательность 0-1 */
    for each buf_chk-discnt no-lock
       where buf_chk-discnt.doc-code = buf_chk-doc.doc-code
        /* скидки обычные (record-type = 0) и скидки, которыми выравниваются погрешности (record-type = 2) */
         and ( buf_chk-discnt.record-type = 0 or
               buf_chk-discnt.record-type = 2 )
    break by buf_chk-discnt.doc-code :
      if first-of(buf_chk-discnt.doc-code) then insw:start-element ({&tag-section3}) .
      insw:start-element ({&tag-item3}) .
      
      insw:write-data-element (  "discnt-num",       string(buf_chk-discnt.discnt-id)          ) . /* Номер строки скидки (Число) */
      insw:write-data-element (  "line-num",         string(buf_chk-discnt.line-num)           ) . /* Номер строки чека на которую предоставлена скидка (Число) */
      insw:write-data-element (  "discnt-type",      string(buf_chk-discnt.discnt-type)        ) . /* Тип скидки (Строка) */
      insw:write-data-element (  "discntValueAbs",   left-trim(string(buf_chk-discnt.discnt-value-abs,  "->>>>>>>>>9.9<<<<<<<<<"))  ) . /* Абсолютное значение скидки - сумма (Число) */
      insw:write-data-element (  "discntValuePcnt",  left-trim(string(buf_chk-discnt.discnt-value-pcnt, "->9.9<"))                 ) . /* % скидки (Число) */
      
      /* обязательность 0-1 */
      if buf_chk-discnt.promo-id > "" then
      insw:write-data-element (  "promotion-code",  buf_chk-discnt.promo-id  ) . /* Код промо-акции (Строка) */

      insw:end-element ({&tag-item3}) .
      if last-of(buf_chk-discnt.doc-code) then insw:end-element ({&tag-section3}) .
    end . /* end_of for each buf_chk-discnt */


    /* section4 обязательность 0-1 */
    for each buf_chk-discnt no-lock
       where buf_chk-discnt.doc-code    = buf_chk-doc.doc-code
         and buf_chk-discnt.record-type = 4
         and buf_chk-discnt.discnt-value-abs <> 0
    break by buf_chk-discnt.doc-code :
      if first-of(buf_chk-discnt.doc-code) then insw:start-element ({&tag-section4}) .
      insw:start-element ({&tag-item4}) .

      insw:write-data-element (  "chk-line-num",  string(buf_chk-discnt.line-num)  ) . /* Номер строки чека (Число) */
      insw:write-data-element (  "sum-bonus",     left-trim(string(buf_chk-discnt.discnt-value-abs, "->>>>>>>>9.99"))   ) . /* Сумма начисленного бонуса (Число 15,2) */

      /* 17/XI-2017 Вид бонуса, поле «bonus-mode», в секции chk-bonus-p
         Сейчас везде используется начисление только на итог.
         Везде для выгрузки в процессинг используем - .
         Если в будущем понадобиться будем добавлять поле. */
      /* 22/XI-2017 поле bonus-mode исключено.
         Сейчас везде используется начисление только на итог.
         Везде для выгрузки в процессинг используем - 3.
         Если в будущем понадобиться будем добавлять поле. */
      /*   
      if buf_chk-discnt.line-type > 0 then 
        insw:write-data-element (  "bonus-mode",  string(buf_chk-discnt.line-type)  ) .
      */
        
      /* 21/XI-2017 добавлено dc-num, обязательность 0-1 */
      if buf_chk-discnt.d-card > "" then
      insw:write-data-element (  "dc-num",  buf_chk-discnt.d-card  ) . /* Номер ДК (Строка) */

      insw:end-element ({&tag-item4}) .
      if last-of(buf_chk-discnt.doc-code) then insw:end-element ({&tag-section4}) .
    end . /* end_of for each buf_chk-discnt */

    
    /* section5 исключена */


    /* 28/XI-2017 при выгрузке чеков надо еще запускать размаз чеков, иначе chk-pay-r нет. */
    run rep/rpychk0.p ( input "bgepych2"
                       ,input buf_chk-doc.obj-type
                       ,input buf_chk-doc.obj-code
                      ,input ? /*p-date-from*/
                      ,input ? /*p-date-to*/
                      ,input ? /*p-shift-date-from*/
                      ,input ? /*p-shift-date-to*/
                      ,input ? /*p-shift-num-start*/
                      ,input ? /*p-shift-num-end*/
                       ,input buf_chk-doc.out-code /* p-inkas-code */
                      ) .

    /* section6 обязательность 0-1 */
    for each buf_chk-gds-pay no-lock
       where buf_chk-gds-pay.doc-code = buf_chk-doc.doc-code
    break by buf_chk-gds-pay.doc-code :
      if first-of(buf_chk-gds-pay.doc-code) then insw:start-element ({&tag-section6}) .
      insw:start-element ({&tag-item6}) .
      
      insw:write-data-element (  "pay-code",  string(buf_chk-gds-pay.pay-code)    ) . /* Код типа платежа (Число) */
      insw:write-data-element (  "line-num",  string(buf_chk-gds-pay.line-num)    ) . /* Номер строки с товарах чека (Число) */
      insw:write-data-element (  "pay-num",   string(buf_chk-gds-pay.cpline-num)  ) . /* Номер строки в оплатах чека (Число) */
      insw:write-data-element (  "sum",       left-trim(string(buf_chk-gds-pay.tot-r-b,      "->>>>>>>>9.99"))  ) . /* Сумма отнесенная на товар (либо бонус в рублевом эквиваленте) (Число 15,2) */
      insw:write-data-element (  "qnty",      left-trim(string(buf_chk-gds-pay.eff-doc-qnty, "->>>>>>>9.999"))  ) . /* Эффективное количество (Число 15,3) */

      /* 17/XI-2017 Добавляем поле «price-base» (цена) в секции «chk-pay-r». */
      /* обязательность 0-1 */
      if buf_chk-gds-pay.price-base > 0 then
      insw:write-data-element ( "price-base", left-trim(string(buf_chk-gds-pay.price-base, "->>>>>>>>9.99"))  ) . /* Цена (Число 15,2) */

      /* 21/XI-2017 Добавлены поля pay-card (обязательность 0-1) и discntValueAbs (обязательность 1-1) */
      if buf_chk-gds-pay.pay-card > "" then
      insw:write-data-element (  "pay-card",               buf_chk-gds-pay.pay-card  ) . /* Номер платежной карты. Заполняется в случае оплаты банковской картой (Строка) */
      insw:write-data-element (  "discntValueAbs",  left-trim(string(buf_chk-gds-pay.discnt, "->>>>>>>>>9.9<<<<<<<<<"))  ) . /* Абсолютное значение скидки – сумма (Число) */
      
      insw:end-element ({&tag-item6}) .
      if last-of(buf_chk-gds-pay.doc-code) then insw:end-element ({&tag-section6}) .
    end . /* end_of for each buf_chk-gds-pay */

    insw:end-element ({&tag-message}) .
    
  end method .


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

  /* найти номер резервуара */
  method private character getTankNum (p-obj-type    as character,
                                       p-obj-code    as integer,
                                       p-pump        as integer,
                                       p-nozzle-code as integer,
                                       p-src-pl-code as integer,
                                       p-pl-code     as integer,
                                       p-gds-code    as integer) :
    define buffer buf_place for ub.place .
    define variable v-pl-code as integer no-undo .
    define variable v-loc1    as character no-undo .
                                       
         if p-src-pl-code > 0 then v-pl-code = p-src-pl-code.
    else if p-pl-code     > 0 then v-pl-code = p-pl-code.
    else do:
      /* если нет резервуара в чеке, найти в топологии текущую связку ТРК+Пистолет,
         определить по ней резервуар и выгрузить полученный код резервура */
      /* libFindtank всегда валидна: работа с классом ведётся только через метод CrContentToSW() */ 
      libFindtank:findtank_
      (input p-obj-type
      ,input p-obj-code
      ,input p-pump
      ,input p-nozzle-code
      ,input p-pl-code
      ,input p-gds-code
      ,output v-pl-code
      ) .
    end .
    
    if v-pl-code > 0 then do:
      find first buf_place no-lock where buf_place.pl-code = v-pl-code no-error .
      v-loc1 = if available buf_place then buf_place.loc1 else "0" .
    end.
    else v-loc1 = "0" .

    return v-loc1 .        
  end method .

  
end class.