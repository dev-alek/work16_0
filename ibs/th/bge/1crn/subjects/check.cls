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

class ibs.th.bge.1crn.subjects.check implements iexpsubject:

  { cmp/str-glbl.i class }
  { str/lib-trn.i  class }
  { cmp/library.i  class }
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
    define variable v-fld-inkas-code as handle no-undo .
    define variable v-fld-inkas-date as handle no-undo .
    define variable v-fld-inkas-time as handle no-undo .
    define variable v-fld-inkas-oper as handle no-undo .
    define variable v-fld-obj-type   as handle no-undo .
    define variable v-fld-obj-code   as handle no-undo .
    define variable v-inkas-code     as character no-undo .
    define variable v-inkas-date     as date no-undo .
    define variable v-inkas-time     as integer no-undo .
    define variable v-inkas-dtime    as datetime no-undo .
    define variable v-inkas-operator as character no-undo .
    define variable v-user-name      as character no-undo .
    define variable v-obj-type       as character no-undo .
    define variable v-obj-code       as integer no-undo .
    define variable v-en-chktype     as enum-chk-type no-undo .
    /* define buffer buf_inkas   for ub.inkas . */
    define buffer over_buf_chk-doc        for ub.chk-doc .

    Msg = "" .
    if not valid-handle(BufHandle) then undo, throw new Progress.Lang.AppError("Отсутствует запись ПРОДАЖИ inkas") .

    assign
      v-fld-inkas-code = BufHandle:buffer-field( "inkas-code":U )
      v-fld-inkas-date = BufHandle:buffer-field( "fact-date":U   )
      v-fld-inkas-time = BufHandle:buffer-field( "sys-time-int":U   )
      v-fld-inkas-oper = BufHandle:buffer-field( "user-name":U  )
      v-fld-obj-type   = BufHandle:buffer-field( "obj-type":U  )
      v-fld-obj-code   = BufHandle:buffer-field( "obj-code":U  )
    .
    assign
      v-inkas-code     = v-fld-inkas-code:buffer-value
      v-inkas-date     = v-fld-inkas-date:buffer-value
      v-inkas-time     = v-fld-inkas-time:buffer-value
      v-inkas-dtime    = datetime(v-inkas-date, v-inkas-time * 1000)
      v-inkas-operator = v-fld-inkas-oper:buffer-value
      v-obj-type       = v-fld-obj-type:buffer-value
      v-obj-code       = v-fld-obj-code:buffer-value
    .

    /* 17/I-2018 Operator – надо выводить ФИО пользователя */
    { gbl/usrfulnm.i
      v-inkas-operator
      v-user-name }

    /* 28/XI-2017 при выгрузке чеков надо еще запускать размаз чеков, иначе chk-pay-r нет. */
    run rep/rpychk0.p ( input "bgepych2"
                      , input v-obj-type
                      , input v-obj-code
                      ,input ? /*p-date-from*/
                      ,input ? /*p-date-to*/
                      ,input ? /*p-shift-date-from*/
                      ,input ? /*p-shift-date-to*/
                      ,input ? /*p-shift-num-start*/
                      ,input ? /*p-shift-num-end*/
                      , input v-inkas-code
                      ) .

    libFindtank = new ibs.th.str.findtank ().

    for each over_buf_chk-doc no-lock
       where over_buf_chk-doc.out-code = v-inkas-code:
      /* 19/XII-2017 выгружаем только те типы, которые указаны в протоколе */
      v-en-chktype = enum-chk-type:GetEnum(over_buf_chk-doc.chk-type) no-error .
      if not error-status:error then
        CrContentInterfaceToSW (insw, buffer over_buf_chk-doc
          , v-inkas-code, v-inkas-dtime, v-user-name) .
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
                                          , buffer p-buf_chk-doc for ub.chk-doc
                                          , input p-inkas-code     as character
                                          , input p-inkas-dtime    as datetime
                                          , input p-inkas-operator as character
                                          ) :
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
    if p-buf_chk-doc.shift-date = ? then insw:write-empty-element ( "shift-date":U ) . /* Дата смены (Дата) */
    else insw:write-data-element (  "shift-date":U,  iso-date(p-buf_chk-doc.shift-date)  ). 

    insw:write-data-element (  "shift-num":U,       string(p-buf_chk-doc.shift-num)   ). /* Номер смены (Число) */
    insw:write-data-element (  "chk-num":U,         string(p-buf_chk-doc.chk-num)     ). /* Номер чека на кассе (Число) */
    insw:write-data-element (  "cb-num":U,          string(p-buf_chk-doc.pay-desk)    ). /* Номер кассы (Число) */
    insw:write-data-element (  "chk-id":U,                 p-buf_chk-doc.doc-code     ). /* Номер чека в GC (Строка) */
    
    /* обязательность 0-1 для del-l, ext-num, direct-chk-num */
    
    /* 04/XII-2017 при удалении продажи чеки у нас не удаляются: они просто остаются непривязанными к продаже.
                   При удалении продажи надо посылать чеки с del-l = 1 (в протоколе поля del-l раньше не было) */
    /* 07/XII-2017 теперь чеки выгружаем вместе с закрытием смены, и никакое удаление продаж на них не влияет */

    /* 17/XI-2017 Добавляем поле «ext-num» в шапку.
       В поле хранятся внешние номера, в нашем случае номер карты активации, с типом платежа «Активация». */
    if p-buf_chk-doc.doc-num > "" then
    insw:write-data-element (  "ext-num":U,         p-buf_chk-doc.doc-num   ). /* Внешний номер. В случае типа платежа «активация» номер карты активации (Строка) */
    
    /* 17/XI-2017 Добавляем поле «direct-chk-num» в шапке.
       В этом поле будет номер прямого чека. */
    if p-buf_chk-doc.doc-num2 > "" then
    insw:write-data-element (  "direct-chk-num":U,  p-buf_chk-doc.doc-num2  ). /* Номер прямого чека (Строка) */
    
    /* обязательность 1-1 */
    if p-buf_chk-doc.chk-date = ? then insw:write-empty-element( "chk-date":U ). /* Дата чека (Дата) */
    else insw:write-data-element (  "chk-date":U,  iso-date(p-buf_chk-doc.chk-date)  ).
    
    insw:write-data-element (  "chk-time",     timeFormat(p-buf_chk-doc.chk-time)    ). /* Время чека (Время) */
    insw:write-data-element (  "cashier",          string(p-buf_chk-doc.cashier)     ). /* Код кассира (Строка) */
    insw:write-data-element (  "z-num",            string(p-buf_chk-doc.z-number)    ). /* Номер z-отчета (Число) */
    insw:write-data-element (  "chk-type", left-trim(string(p-buf_chk-doc.chk-type, ">9"))    ). /* Тип чека (Число, enum) */
    insw:write-data-element (  "netto",   left-trim(string(p-buf_chk-doc.netto,   "->>>>>>>>9.9<"))  ). /* Сумма чека нетто в валюте продаж. Выручка со скидками. (Число) */
    insw:write-data-element (  "tot-doc", left-trim(string(p-buf_chk-doc.tot-doc, "->>>>>>>>9.9<"))  ). /* Сумма брутто по чеку в валюте продаж. Сумма по текущей розничной цене (Число) */

    /* обязательность 0-1 */
    
    /* 28/XI-2017 term-num будет строкой, поэтому пустой можно, и необязательный. */
    if "" > "" then insw:write-data-element ( "term-num", "" ).  /* Номер терминала POS (Строка) */

    if p-buf_chk-doc.d-card > "" then do:
      insw:write-data-element (  "dc-num":U,     p-buf_chk-doc.src-d-card     ). /* Номер ДК (Строка) */
      find first buf_dis-card no-lock
           where buf_dis-card.d-card = p-buf_chk-doc.d-card no-error .
      if available buf_dis-card then do:
        /* обязательность 0-1 */
        if buf_dis-card.card-num > 0 then
      insw:write-data-element (  "dc-name":U,    string(buf_dis-card.type)  ). /* Наименование ДК (Строка) */
      end.
    end.  

    /* 16/I-2018 в каждый чек добавить поля с номером и датой документа «Продажа» в нашей системе,
                 и ФИО оператора, который оформлял документ */
    if p-inkas-operator > "" then
      insw:write-data-element (  "operator":U,   p-inkas-operator           ). /* Оператор создавший документ (Строка) */
    if p-inkas-code > "" then
      insw:write-data-element (  "prdoc-num":U,  p-inkas-code               ). /* Номер документа продажи в GC (Строка) */
    if p-inkas-dtime = ? then . else
      insw:write-data-element (  "prdoc-date":U, iso-date(p-inkas-dtime)    ). /* Дата документа продажи в GC со временем в формате ISO (Дата) */ 


    /* section1 обязательность 1-1 */
    insw:start-element ({&tag-section1}) .
    if can-find (first buf_chk-gds where buf_chk-gds.doc-code = p-buf_chk-doc.doc-code) then do:
      for each buf_chk-gds no-lock
         where buf_chk-gds.doc-code = p-buf_chk-doc.doc-code :
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
              (input p-buf_chk-doc.obj-type
              ,input p-buf_chk-doc.obj-code
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
          insw:write-data-element (  "wght",
            left-trim( string(buf_chk-gds.doc-qnty * buf_chk-gds.density, "->>>>>>>>9.999") )
          ) . /* Объем, кг (Число 15,3) */ 
        end.

        /* 18/I-2018 даже если в БД в поле sum-base лежит ? - в выгрузке всё равно должен быть 0 */
        insw:write-data-element (  "sum",
          if buf_chk-gds.sum-base = ?
          then  "0"
          else  left-trim( string(buf_chk-gds.sum-base, "->>>>>>>>9.99") )
        ) . /* Сумма (Число 15,2) */
        
        
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
            insw:write-data-element (  "operator-name",  entry(1, buf_ext-classif.charkey_two, {&delim-par})  ) . /* Наименование оператора(эмитента) (Строка) */
        end .

        /* 17/XI-2017 Добавляем поле «price» (цена до применения скидок) в секции «chk-gd». */
        insw:write-data-element (  "price",  left-trim(string(buf_chk-gds.src-price, "->>>>>>>>9.99"))  ) . /* Цена до применения скидок (Число 15,2) */

        /* 16/I-2018 Деление сбросов (тип чека 14) на два типа (Пролито и не пролито).
                     Для разделения используется специальный флаг в товарной строке чека. */
        if enum-chk-type:GetEnum(p-buf_chk-doc.chk-type) = enum-chk-type:entranscancell then do:
          if buf_chk-gds.write-off-code >= 0 then
            insw:write-data-element (  "prolito",  string(buf_chk-gds.write-off-code)  ). /* Признак для сбросов: 0 – не пролито; 1 – пролито. (Число, enum) */
        end .
 
        insw:end-element ({&tag-item1}) .
      end . /* end_of for each buf_chk-gds */
    end .
    else do:
      insw:write-empty-element ({&tag-item1}) .
    end .
    insw:end-element ({&tag-section1}) .


    /* section2 обязательность 0-1 */
    for each buf_chk-pay no-lock
       where buf_chk-pay.doc-code = p-buf_chk-doc.doc-code
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
       where buf_chk-discnt.doc-code = p-buf_chk-doc.doc-code
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
       where buf_chk-discnt.doc-code    = p-buf_chk-doc.doc-code
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


    /* section6 обязательность 0-1 */
    for each buf_chk-gds-pay no-lock
       where buf_chk-gds-pay.doc-code = p-buf_chk-doc.doc-code
    break by buf_chk-gds-pay.doc-code :
      if first-of(buf_chk-gds-pay.doc-code) then insw:start-element ({&tag-section6}) .
      insw:start-element ({&tag-item6}) .
      
      insw:write-data-element (  "pay-code",  string(buf_chk-gds-pay.pay-code)    ) . /* Код типа платежа (Число) */
      insw:write-data-element (  "line-num",  string(buf_chk-gds-pay.line-num)    ) . /* Номер строки с товарах чека (Число) */
      insw:write-data-element (  "pay-num",   string(buf_chk-gds-pay.cpline-num)  ) . /* Номер строки в оплатах чека (Число) */
      insw:write-data-element (  "sum",       left-trim(string(buf_chk-gds-pay.tot-r-b,      "->>>>>>>>9.99"))  ) . /* Сумма отнесенная на товар (либо бонус в рублевом эквиваленте) (Число 15,2) */
      /* 04/VI-2018 в чеках в chk-gds-pay сделать количество с 10 знаками после запятой */
      insw:write-data-element (  "qnty",      left-trim(string(buf_chk-gds-pay.eff-doc-qnty, "->>>>>>>>>9.9<<<<<<<<<"))  ) . /* Эффективное количество (Число 15,3) */

      /* 17/XI-2017 Добавляем поле «price-base» (цена) в секции «chk-pay-r». */
      /* обязательность 0-1 */
      if buf_chk-gds-pay.price-base > 0 then
      insw:write-data-element ( "price-base", left-trim(string(buf_chk-gds-pay.price-base, "->>>>>>>>9.99"))  ) . /* Цена (Число 15,2) */
      else insw:write-data-element ( "price-base", left-trim(string(0.0, "->>>>>>>>9.99"))  ) .

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