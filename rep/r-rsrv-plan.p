/*

$Revision: 8f5f559ebdb3, 2359, rls $
$Author: EShklyar $
$Date: Ср июн 10 21:13:34 2020 +0300 $
$Workfile: r-rsrv-plan.p $
$Archive: rep/r-rsrv-plan.p $

Отчет по планированию заказов

Автор: Бахтадзе Наталья Викторовна
Дата создания: 10/18/05
Author: Bakhtadze Natalya
Creation date: 10/18/05

*/
{ rep/tt-date.i }

define input parameter parparentproc    as handle no-undo .
define input parameter pRecidClients as character no-undo .
define input parameter pDateOrder as date no-undo .
define input parameter rPeriodZakaz as integer no-undo .
define input parameter pDateStart as date no-undo .
define input parameter pDateEnd as date no-undo .
define input parameter rDaySale as integer no-undo .
define input parameter pDaySale as integer no-undo .
define input parameter pGarantDay as integer no-undo .
define input parameter pDelDayGoods as logical no-undo .
define input parameter table for tt-typeDocChoose .
define input parameter table for tt-dateZakaz .
define input parameter table for gds-list .


define variable vss-revision    as character no-undo init "$Revision: 8f5f559ebdb3, 2359, rls $":U .
define variable vss-author      as character no-undo init "$Author: EShklyar $":U .
define variable vss-date        as character no-undo init "$Date: Ср июн 10 21:13:34 2020 +0300 $":U .
define variable vss-workfile    as character no-undo init "$Workfile: r-rsrv-plan.p $":U .
define variable vss-archive     as character no-undo init "$Archive: rep/r-rsrv-plan.p $":U .
define variable vss-description as character no-undo init "Отчет по планированию заказов".
{ cmp/vssrevis.i }
{ gbl/waitfram.i }
{ rep/html-conv.i }
{ cmp/str-glbl.i  }
{ cmp/library.i }
{ cmp/r-pril.i new }
{ gbl/prn-lib.i }
{ trg/factord.i    }
{ gbl/getcntxt.i def }
{ gbl/getcntxt.i get }
{ trg/prdoclib.i   }

define variable ii                  as integer   no-undo .
define variable kk                  as integer   no-undo .
define variable zakazDate           as date      no-undo .
define variable v-fact-order-start  as decimal   no-undo .
define variable v-fact-order-end    as decimal   no-undo .
define variable ostatok             as decimal   no-undo .
define variable v-full-path-RepView as character no-undo.   /* Полный путь к файлу Просмотровщика (отчётов) */
define variable v-file-name-rep-htm as character no-undo.   /* Полный путь к файлу отчёта */
define variable g#report-num        as integer   no-undo.            /* Номер отчёта (получим стандартной процедурой ТН) */
define variable v-report-name       as character no-undo.         /* Наименование отчёта */
define variable v-period            as character no-undo.              /* Период за который формируется отчёт */
define variable vDocType            as character no-undo .
define variable vDaySale            as integer   no-undo .
define variable vDateStart          as date      no-undo .
define variable vDateEnd            as date      no-undo .
define variable v-fact-orderStart   as decimal   no-undo .
define variable v-fact-orderEnd     as decimal   no-undo .
define variable periodDate          as date      no-undo .
define variable qntyPeriod          as integer   no-undo .

define stream OutStr-html.

define buffer buf_goods           for ub.goods .
define buffer buf_clients         for ub.clients .
define buffer bf_clients          for ub.clients .
define buffer buf_contract-specif for ub.contract-specif .
define buffer buf_cli-gds         for ub.cli-gds .
define buffer buf_doc-line        for ub.doc-line .
define buffer buf_PromoGoogs      for ub.PromoGoods .
define buffer buf_PromoAction     for ub.PromoAction .
define buffer buf_stk-line        for ub.stk-line .
define buffer buf_trn-doc         for ub.trn-doc .

find first buf_clients no-lock where recid (buf_clients) = integer(pRecidClients) no-error .

function round-maxInt returns decimal
  (input p-dec as decimal) forward.

function round-maxDec returns decimal
  (input p-dec as decimal) forward.
  
function round-minInt returns decimal
  (input p-dec as decimal) forward.
  
function round-minDec returns decimal
  (input p-dec as decimal) forward.
      
function fnc-DD-MM-YYYY returns character
  (input p-dat-date as date) forward.

define temp-table tt-zakaz no-undo 
  field artic        as character
  field gds-code     as integer
  field gds-name     as character
  field prod-type    as character
  field prod-code    as integer
  field ostatokToday as decimal
  field tempSale     as decimal
  field minZapas     as decimal
  field volTemp      as integer
  field volSale      as decimal
  field volMinZapas  as integer
  field volMinGarant as integer
  field ostatokDay   as decimal
  field promo        as logical 
  field qntyDaySale  as integer
  field qntyDayGoods as integer
  field garantZapas  as integer
  field ostatokGoods as decimal
  field qntyDay      as integer
  field contract     as character
  index pi    gds-code contract
  index artic artic    prod-type prod-code 
  index contr contract.

define temp-table temp-gds-qnty no-undo
  field day      as date
  field ost      as decimal
  field gds-code as integer
  index pi is unique primary day gds-code
  index by-ost               ost .
  
 
define variable qnty-lib-v-fact-order-2 as decimal no-undo .
define buffer buf_temp-gds-qnty for temp-gds-qnty .

/* Период продаж */
find first tt-dateZakaz no-error .
if not available (tt-dateZakaz) then 
do:
  create tt-dateZakaz .
  assign
    tt-dateZakaz.id        = 1 
    tt-dateZakaz.dateStart = pDateStart
    tt-dateZakaz.dateEnd   = pDateEnd
    .
end.

/* Обеспечение продаж за период в днях */

case rDaySale:
  when 1 then 
    vDaySale = 7 .
  when 2 then 
    vDaySale = 14 .
  when 3 then 
    vDaySale = 21 .
  when 4 then 
    vDaySale = 28 .
  when 5 then 
    vDaySale = pDaySale .
end.

/* найдем наименьшую дату и наибольшую дату периода анализа */
for each tt-dateZakaz:
  qntyPeriod = qntyPeriod + 1 . /* Посчитать кол-во дней всего */ 
  if tt-dateZakaz.dateStart < vDateStart or vDateStart = ? then vDateStart = tt-dateZakaz.dateStart .
  if tt-dateZakaz.dateEnd > vDateEnd or vDateEnd = ? then vDateEnd = tt-dateZakaz.dateEnd .
end.
 
/*Поиск нач fact-order*/
run day-begin-fact-order in this-procedure ( input vdateStart
  , output v-fact-orderStart
  ).
/*Поиск посл fact-order*/
run factord-end-day in this-procedure ( input vdateEnd
  , output v-fact-orderEnd
  ).  

/* Сбор данных */
for each gds-list:
  find first tt-zakaz no-lock where tt-zakaz.gds-code = gds-list.gds-code no-error .
  if available (tt-zakaz) then next .
  create tt-zakaz .
  assign
    tt-zakaz.gds-code     = gds-list.gds-code
    tt-zakaz.artic        = gds-list.artic
    tt-zakaz.gds-name     = gds-list.gds-name
    tt-zakaz.prod-code    = gds-list.prod-code
    tt-zakaz.prod-type    = gds-list.prod-type
    tt-zakaz.garantZapas  = 0
    tt-zakaz.minZapas     = gds-list.minZapas
    tt-zakaz.ostatokDay   = 0
    tt-zakaz.ostatokGoods = 0
    tt-zakaz.ostatokToday = 0
    tt-zakaz.qntyDay      = qntyPeriod
    tt-zakaz.qntyDaySale  = 0
    tt-zakaz.tempSale     = 0
    tt-zakaz.volMinGarant = 0
    tt-zakaz.volMinZapas  = 0
    tt-zakaz.volSale      = 0
    tt-zakaz.volTemp      = 0
    tt-zakaz.contract     = gds-list.contract
    .
  
  /*Остаток на текущий день*/
  for each buf_cli-gds no-lock where buf_cli-gds.artic = gds-list.artic and
    buf_cli-gds.prod-code = gds-list.prod-code and
    buf_cli-gds.prod-type = gds-list.prod-type:
    tt-zakaz.ostatokToday = tt-zakaz.ostatokToday + buf_cli-gds.supp-qnty .
  end.
  
  /* Собираем таблицу с остатками по периодам */
  empty temp-table temp-gds-qnty .
  if pDelDayGoods then run ost-gds-day(vDateStart, vDateEnd, gds-list.gds-code, v-cntxt-obj-type, v-cntxt-obj-code, tt-zakaz.ostatokToday) .  
  
  /* Документы по датам */
  for each tt-dateZakaz:
    /*    do zakazDate = tt-dateZakaz.dateStart to tt-dateZakaz.dateEnd:*/
      
    /*Поиск нач fact-order*/
    run day-begin-fact-order in this-procedure ( input tt-dateZakaz.dateStart
      , output v-fact-order-start
      ).
    /*Поиск посл fact-order*/
    run factord-end-day in this-procedure ( input tt-dateZakaz.dateEnd
      , output v-fact-order-end
      ).     
    /* Посчитать кол-во дней если с Исключить дни без товара */    
    if pDelDayGoods then 
    do:
      for each buf_temp-gds-qnty where buf_temp-gds-qnty.gds-code = gds-list.gds-code and
        buf_temp-gds-qnty.ost > 0 and
        buf_temp-gds-qnty.day >= tt-dateZakaz.dateStart and
        buf_temp-gds-qnty.day <= tt-dateZakaz.dateEnd:
        tt-zakaz.qntyDayGoods = tt-zakaz.qntyDayGoods + 1 .
      end.
    end.
    else tt-zakaz.qntyDayGoods = tt-dateZakaz.dateEnd - tt-dateZakaz.dateStart + 1.

    for each tt-typeDocChoose:
      for each buf_doc-line no-lock 
        where 
        buf_doc-line.ext-doc-type = tt-typeDocChoose.type-code and
        buf_doc-line.obj-code = v-cntxt-obj-code and
        buf_doc-line.obj-type = v-cntxt-obj-type and
        buf_doc-line.artic = gds-list.artic and
        buf_doc-line.prod-code = gds-list.prod-code and
        buf_doc-line.prod-type = gds-list.prod-type and
        buf_doc-line.fact-order >= v-fact-order-start and
        buf_doc-line.fact-order <= v-fact-order-end :
        tt-zakaz.qntyDaySale = tt-zakaz.qntyDaySale + 1 .
        case tt-typeDocChoose.type-code:
          /* разбивка по типам документов */
          /* приход */
          when   {&tdedt_pri_vnesh}  or
          when   {&tdedt_pri_prvo  }     then
            do:
              tt-zakaz.volSale = tt-zakaz.volSale + buf_doc-line.fact-qnty .
            end.

          /* расход */
          when  {&tdedt_spi_vnesh}      then 
            tt-zakaz.volSale = tt-zakaz.volSale + buf_doc-line.fact-qnty .
          when  {&tdedt_spi_prvo}       then 
            tt-zakaz.volSale = tt-zakaz.volSale + buf_doc-line.fact-qnty .
          when  {&tdedt_ras_prvo}       then 
            tt-zakaz.volSale = tt-zakaz.volSale + buf_doc-line.fact-qnty .
          when  {&tdedt_ras_perem}      then 
            tt-zakaz.volSale = tt-zakaz.volSale + buf_doc-line.fact-qnty .
          when  {&tdedt_vozvrat_perem}  then 
            tt-zakaz.volSale = tt-zakaz.volSale - buf_doc-line.fact-qnty .
          when  {&tdedt_ras_vnesh}      then 
            tt-zakaz.volSale = tt-zakaz.volSale + buf_doc-line.fact-qnty .
          when  {&tdedt_vozvrat_vnesh}  then 
            tt-zakaz.volSale = tt-zakaz.volSale - buf_doc-line.fact-qnty .
          when  {&tdedt_ras_vnesh_kass}     then 
            tt-zakaz.volSale = tt-zakaz.volSale + buf_doc-line.fact-qnty .
          when  {&tdedt_vozvrat_vnesh_kass} then 
            tt-zakaz.volSale = tt-zakaz.volSale - buf_doc-line.fact-qnty .
          when  {&TDEDT_Spi_Vnesh} then 
            tt-zakaz.volSale = tt-zakaz.volSale - buf_doc-line.fact-qnty .
        end case.            

      end.
    end.

  /*    end.*/
  end.

  if tt-zakaz.qntyDayGoods <> 0 then tt-zakaz.tempSale = round-maxDec(tt-zakaz.volSale / tt-zakaz.qntyDayGoods) . /* Тпр */
  if tt-zakaz.qntyDayGoods <> 0 then
  do:
    if tt-zakaz.ostatokToday > -1 then 
    do:
      tt-zakaz.ostatokDay = tt-zakaz.ostatokToday - ((integer(pDateOrder - date(today)) * tt-zakaz.tempSale)) . /* Ост */
      if tt-zakaz.ostatokDay < 0 then tt-zakaz.volTemp = round-maxInt(tt-zakaz.tempSale * vDaySale). /* Vз */
      else tt-zakaz.volTemp = round-maxInt(tt-zakaz.tempSale * vDaySale - tt-zakaz.ostatokDay) .
    end.
    else tt-zakaz.volTemp = round-maxInt(tt-zakaz.tempSale * vDaySale - tt-zakaz.ostatokToday). /* Vз */
    if tt-zakaz.qntyDaySale <> 0 then 
    do:   
      tt-zakaz.volMinZapas = round-maxInt(tt-zakaz.volTemp + tt-zakaz.minZapas) . /* Vзм */
      tt-zakaz.garantZapas = pGarantDay * tt-zakaz.tempSale . /* G */
      tt-zakaz.volMinGarant = round-maxInt(tt-zakaz.volTemp + tt-zakaz.minZapas + tt-zakaz.garantZapas) . /* Vзг */

      if tt-zakaz.tempSale <> 0 then tt-zakaz.ostatokGoods = round-minInt(tt-zakaz.ostatokToday / tt-zakaz.tempSale) . /* Од */
    end.
    else tt-zakaz.volTemp = 0 .
  end.
  for each buf_PromoGoogs no-lock where buf_PromoGoogs.gds-code = gds-list.gds-code,
    first buf_PromoAction no-lock where buf_PromoAction.id = buf_PromoGoogs.idAction and
    buf_PromoAction.end-date >= today and buf_PromoAction.beg-date <= today and buf_PromoAction.Status_ = 1:
    tt-zakaz.promo = true .
  end.
  
end.


run get-full-path-RepViewer(output v-full-path-RepView).    /* Перед работой с "Просмотровщиком отчёта" (main.exe) - убедимся, что он существует и получим полный путь к нему. */

run get-report-num in parParentProc(output g#report-num).   /* Получим СТАНДАРТНЫМ МЕТОДОМ ТН номер файла отчёта. */

run define-full-path-Report(input g#report-num, output v-file-name-rep-htm).   /* Сформируем стандартизованное в ТН имя файла отчёта. */

run create-file(v-file-name-rep-htm).   /* Создадим на диске пустой файл со сформированным по стандарту именем файла. */


run waitfram-show in this-procedure ("Подождите ...").

&scoped-define css_page1tit      text-align:center; font-weight:bold;
&scoped-define css_align_righit  text-align:right; padding-right:4px;
&scoped-define css_align_center  text-align:center;
&scoped-define css_table_border  border-style:solid; border-width:thin;
&scoped-define css_cell_border   border: 1px solid black;
&scoped-define css_border_bottom border-bottom: 1px solid black;

output stream OutStr-html to value(v-file-name-rep-htm) convert target 'UTF-8' .


/* Системная шапка HTML */
put stream OutStr-html unformatted
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

put stream OutStr-html unformatted
  '<body>' skip
  '<TABLE name="zakaz"  fit_to_page="true" orientation="landscape" CELLSPACING="0" BORDER="0">'skip
  '<thead>' skip
  .
put stream OutStr-html unformatted
  '<tr class="set_columns">' skip
  '<td style="width: 100px;"></td>' skip
  '<td style="width: 120px;"></td>' skip
  '<td style="width: 140px;"></td>' skip
  '<td style="width: 90px;"></td>' skip
  '<td style="width: 90px;"></td>' skip
  '<td style="width: 140px;"></td>' skip
  '<td style="width: 120px;"></td>' skip
  '<td style="width: 100px;"></td>' skip
  '<td style="width: 120px;"></td>' skip
  '<td style="width: 100px;"></td>' skip
  '</tr>' skip
  .

find first bf_clients no-lock where bf_clients.obj-code = v-cntxt-obj-code and
  bf_clients.obj-type = v-cntxt-obj-type no-error .

put stream OutStr-html unformatted
  '<tr>' skip
  '<td colspan="10" style="text-align: center; font-weight:bold;">Отчет по планированию заказов</td>' skip
  '</tr>' skip
  '<tr>' skip
  '<td colspan="10" style="text-align: left;">на ' + string(pDateOrder,"99/99/9999") + '</td>' skip
  '</tr>' skip
  '<tr>' skip
  '<td colspan="10" style="text-align: left;">объект: ' + bf_clients.obj-name + '</td>' skip
  '</tr>' skip
  '<tr>' skip
  '<td colspan="10" style="text-align: left;">контрагент: ' + buf_clients.obj-name + '</td>' skip
  '</tr>' skip
  .
for each tt-typeDocChoose:
  vDocType = vDocType + ", " + tt-typeDocChoose.typeName .
end.
vDocType = trim (vDocType,", ") .
put stream OutStr-html unformatted
  '<tr>' skip
  '<td colspan="10" style="text-align: left;">по документам: ' + vDocType + '</td>' skip
  '</tr>' skip 
  '<tr>' skip
  '<td colspan="10" style="text-align: left;">заказ формируется на : ' + string(vDaySale) + ' дней(дня), с учетом гарантийного заказа на ' + string(pGarantDay) + ' дней(дня)</td>' skip
  '</tr>' skip .
  
for each tt-dateZakaz:
  v-period = v-period + ", " + "c " + string(tt-dateZakaz.dateStart,"99/99/9999") + " по " + string (tt-dateZakaz.dateEnd,"99/99/9999") .
end.
v-period = trim (v-period,", ") .
  
put stream OutStr-html unformatted   
  '<tr>' skip
  '<td colspan="10" style="text-align: left;">период анализа : ' + v-period + '</td>' skip
  '</tr>' skip .
  
if pDelDayGoods then 
do:
  put stream OutStr-html unformatted   
    '<tr>' skip
    '<td colspan="10" style="text-align: left;">исключены дни, когда товара не было на остатках</td>' skip
    '</tr>' skip .
end.  
  
put stream OutStr-html unformatted   
  '<tr>' skip
  '<td colspan="10" style="text-align: left; font-weight:bold;"><br></td>' skip
  '</tr>' skip
  '<tr>' skip
  '<td colspan="10" style="text-align: left; font-weight:bold;"><br></td>' skip
  '</tr>' skip
  '</thead>' skip
  .

put stream OutStr-html unformatted
  '     <tbody>' skip
  '       <tr>' skip
  '         <th style="text-align: center; font-weight:bold; background-color: silver; height: 30px">Код</th>' skip
  '         <th style="text-align: center; font-weight:bold; background-color: silver;">Артикул</th>' skip
  '         <th style="text-align: center; font-weight:bold; background-color: silver;">Название товара</th>' skip
  '         <th style="text-align: center; font-weight:bold; background-color: silver;">Остаток товара, шт.</th>' skip
  '         <th style="text-align: center; font-weight:bold; background-color: silver;">Остаток товара в днях</th>' skip
  '         <th style="text-align: center; font-weight:bold; background-color: silver;">Темп продаж за указанный период</th>' skip
  '         <th style="text-align: center; font-weight:bold; background-color: silver;">Расчетный объем заказа с учетом темпа продаж</th>' skip
  '         <th style="text-align: center; font-weight:bold; background-color: silver;">Расчетный объем заказа с учетом минимального запаса</th>' skip
  '         <th style="text-align: center; font-weight:bold; background-color: silver;">Рекомендованный объем заказа с учетом минимального и гарантийного запасов</th>' skip
  '         <th style="text-align: center; font-weight:bold; background-color: silver;">Товар участвует в промоакции</th>' skip
  '       </tr>' skip
  '       <tr>' skip
  '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">1</th>' skip
  '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">2</th>' skip
  '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">3</th>' skip
  '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">4</th>' skip
  '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">5</th>' skip
  '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">6</th>' skip
  '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">7</th>' skip
  '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">8</th>' skip
  '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">9</th>' skip
  '         <th num="" style="text-align: center;  font-weight:bold; background-color: silver;">10</th>' skip
  '       </tr>' skip
  . 

for each tt-zakaz no-lock break by tt-zakaz.contract by tt-zakaz.gds-code:

  put stream OutStr-html unformatted
    '     <tbody>' skip
    .
  if first-of (tt-zakaz.contract) then 
  do:
    put stream OutStr-html unformatted
      '<tr>' skip
      '<td colspan="10" style="text-align: left; font-weight:bold;"><br>' + if tt-zakaz.contract = "" then '   БЕЗ ДОГОВОРА' else '   ' + tt-zakaz.contract + '<br></td>' skip
      '</tr>' skip      
      .
  end.
  if tt-zakaz.qntyDayGoods = 0 or tt-zakaz.qntyDaySale = 0 then 
  do:
    put stream OutStr-html unformatted
      '       <tr>' skip
      '         <td text_wrap="true" style="text-align: center; color:#808080;">' + string(tt-zakaz.gds-code) + '</td>' skip
      '         <td text_wrap="true" style="text-align: center; color:#808080;">' + string(tt-zakaz.artic) + '</td>' skip
      '         <td text_wrap="true" style="text-align: center; color:#808080;">' + string(tt-zakaz.gds-name) + '</td>' skip
      '         <td text_wrap="true" style="text-align: center; color:#808080;">' + string(tt-zakaz.ostatokToday,"->>>>>>>>>>>9.99") + '</td>' skip
      '         <td text_wrap="true" style="text-align: center; color:#808080;">' + if tt-zakaz.tempSale = 0 and tt-zakaz.ostatokDay <> 0 then "-" + '</td>' else string(tt-zakaz.ostatokGoods) + '</td>' skip    
      '         <td text_wrap="true" style="text-align: center; color:#808080;">' + string(tt-zakaz.tempSale,"->>>>>>>>>>>9.9") + '</TD>' skip
      '         <td text_wrap="true" style="text-align: center; color:#808080;">' + string(tt-zakaz.volTemp) + '</td>' skip
      '         <td text_wrap="true" style="text-align: center; color:#808080;">' + string(tt-zakaz.volMinZapas) + '</td>' skip
      '         <td text_wrap="true" style="text-align: center; color:#808080;">' + string(tt-zakaz.volMinGarant) + '</td>' skip   
      '         <td text_wrap="true" style="text-align: center; color:#808080;">' + (if tt-zakaz.promo then "да" else "нет") + '</td>' skip
      /*    '         <td text_wrap="true" style="text-align: center;">' + string(tt-zakaz.ostatokDay) + '</td>' skip */
      /*    '         <td text_wrap="true" style="text-align: center;">' + string(tt-zakaz.garantZapas) + '</td>' skip*/
      /*    '         <td text_wrap="true" style="text-align: center;">' + string(tt-zakaz.minZapas) + '</td>' skip   */
      '       </tr>' skip
      . 
  end.
  else 
  do:
    put stream OutStr-html unformatted
      '       <tr>' skip
      '         <td text_wrap="true" style="text-align: center;">' + string(tt-zakaz.gds-code) + '</td>' skip
      '         <td text_wrap="true" style="text-align: center;">' + string(tt-zakaz.artic) + '</td>' skip
      '         <td text_wrap="true" style="text-align: center;">' + string(tt-zakaz.gds-name) + '</td>' skip
      '         <td text_wrap="true" style="text-align: center;">' + string(tt-zakaz.ostatokToday,"->>>>>>>>>>>9.99") + '</td>' skip
      '         <td text_wrap="true" style="text-align: center;">' + string(tt-zakaz.ostatokGoods) + '</td>' skip    
      '         <td text_wrap="true" style="text-align: center;">' + string(tt-zakaz.tempSale,"->>>>>>>>>>>9.9") + '</TD>' skip
      '         <td text_wrap="true" style="text-align: center;">' + string(tt-zakaz.volTemp) + '</td>' skip
      '         <td text_wrap="true" style="text-align: center;">' + string(tt-zakaz.volMinZapas) + '</td>' skip
      '         <td text_wrap="true" style="text-align: center;">' + string(tt-zakaz.volMinGarant) + '</td>' skip   
      '         <td text_wrap="true" style="text-align: center;">' + (if tt-zakaz.promo then "да" else "нет") + '</td>' skip
      /*    '         <td text_wrap="true" style="text-align: center;">' + string(tt-zakaz.ostatokDay) + '</td>' skip */
      /*    '         <td text_wrap="true" style="text-align: center;">' + string(tt-zakaz.garantZapas) + '</td>' skip*/
      /*    '         <td text_wrap="true" style="text-align: center;">' + string(tt-zakaz.minZapas) + '</td>' skip   */
      '       </tr>' skip
      . 
  end.
end.

run prn-lib-reportviewer-report-name in this-procedure (
  input THIS-PROCEDURE
  ,input v-file-name-rep-htm
  ).

procedure get-full-path-RepViewer:
  /* Получение полного пути к exe-файлу просмотровщика отчётов */
  define output parameter p-fill-path-RepView as character no-undo.

  if search("exe\ReportViewer\reportviewer.exe") <> ? then
  do:
    p-fill-path-RepView = search("exe\ReportViewer\reportviewer.exe").
  end.
  else
  do:
    message "Не найдена программа просмотра отчёта!" view-as alert-box error.
  end.
end procedure.

procedure define-full-path-Report:
  /* Получение полного пути к отчёту html */
  define input parameter p-rep-num as integer no-undo.
  define output parameter p-file-name-rep-htm as character no-undo.

  p-file-name-rep-htm = session:temp-directory + {&DF_Name} + string(p-rep-num) + ".html".

end procedure.

procedure search-full-path-Report:
  /* Поиск файла */
  define input parameter p-file-name as character no-undo.

  if search(p-file-name) = ? then
  do:
    message "Не найден файл отчёта: " p-file-name view-as alert-box error.
  end.
  else
  do:
    p-file-name = search(p-file-name).
  end.

end procedure.

procedure Report-Viewer:
  /* Запуск программы "Просмотровщик Отчётов" - ReportViewer. */
  define input parameter p-full-path-RepView as character no-undo.
  define input parameter p-file-name-rep-htm as character no-undo.

  os-command no-wait value(p-full-path-RepView + " " + search(p-file-name-rep-htm)).

end procedure.

procedure create-file:
  /* Создание пустого файла (во входном параметре: полный путь и имя файла) */
  define input parameter p-file-name as character no-undo.
  output to value(string(p-file-name)).
  output close.

end procedure.

function round-maxInt returns decimal  /* Округление число до целого в большую сторону*/
  (input p-dec as decimal):
  define variable p-int as decimal no-undo .  
  if absolute(p-dec - TRUNCATE (p-dec, 0)) < 0.5
    then 
  do:
    if p-dec > 0 then p-int = integer (p-dec + 0.4) .
    else p-int = integer(p-dec) .
  end .
  else 
  do:
    if p-dec < 0 then p-int = integer (p-dec + 0.4) .
    else p-int = integer(p-dec) .    
  end.

  return p-int .
end function. /* round */

function round-minInt returns decimal  /* Округление число до целого в меньшую сторону*/
  (input p-dec as decimal):
  define variable p-int as decimal no-undo . 
  
  if absolute(p-dec - TRUNCATE (p-dec, 0)) > 0.5
    then 
  do:
    if p-dec > 0 then p-int = integer (p-dec - 0.4) .
    else p-int = integer(p-dec) .
  end .
  else 
  do:
    if p-dec < 0 then p-int = integer (p-dec - 0.4) .
    else p-int = integer(p-dec) .    
  end.
  return p-int .
end function. /* round */

function round-maxDec returns decimal  /* Округление число до целого в большую сторону*/
  (input p-dec as decimal):
  define variable p-int as decimal no-undo .  
  if p-dec - TRUNCATE (p-dec, 1) > 0
    then 
  do:
    if TRUNCATE (p-dec, 1) = 0 then p-int = TRUNCATE (p-dec, 1) .
    else p-int = TRUNCATE (p-dec, 1) + 0.1 .
  end.
  else 
  do:

    if p-dec - TRUNCATE (p-dec, 1) > 0
      then 
    do:
      p-int = TRUNCATE (p-dec, 1) - 0.1.
    end.
    else 
    do:
      assign
        p-int = TRUNCATE (p-dec, 1) .
      .
    end.
  end.

  return p-int .
end function. /* round */

function round-minDec returns decimal  /* Округление число до целого в меньшую сторону*/
  (input p-dec as decimal):
  define variable p-int as decimal no-undo .  
  if p-dec - TRUNCATE (p-dec, 1) < 0
    then 
  do:
    if TRUNCATE (p-dec, 1) = 0 then p-int = TRUNCATE (p-dec, 1) .
    else p-int = TRUNCATE (p-dec, 1) - 0.1 .
  end.
  else 
  do:
    if p-dec - TRUNCATE (p-dec, 1) > 0
      then 
    do:
      p-int = TRUNCATE (p-dec, 1) - 0.1.
    end.
    else 
    do:
      assign
        p-int = p-dec
        .
    end.
  end.
  return p-int .
end function. /* round */

function fnc-DD-MM-YYYY returns character
  (input p-dat-date as date):
  /* Преобразование даты в формат: "01.01.2014" */

  define variable result     as character no-undo.
  define variable p-str-date as character no-undo.

  p-str-date = replace(string(p-dat-date,'99.99.9999'), "/", ".").

  return p-str-date.

end function.

procedure ost-gds-day :
  do
    on error undo, return error return-value
    :
    define input parameter p-dateStart as decimal no-undo . /*начало периода*/
    define input parameter p-dateEnd as decimal no-undo . /*конец периода*/
    define input parameter p-gds-code like ub.goods.gds-code no-undo .
    define input parameter p-obj-type as character no-undo .
    define input parameter p-obj-code as integer no-undo .
    define input parameter p-ost-today as decimal no-undo .
    
    define variable vOst as decimal no-undo .
    define buffer p_goods     for ub.goods .
    define buffer p-doc-line  for ub.doc-line .
    define buffer pc-gds-obj  for ub.c-gds-obj .
    define buffer pc-gds-obj2 for ub.c-gds-obj .
    
    find first p_goods no-lock where p_goods.gds-code = p-gds-code no-error .
    if error-status :error then return error .

    do periodDate = vDateStart to vDateEnd:   
      create temp-gds-qnty .                                                        
      assign
        temp-gds-qnty.day      = periodDate
        temp-gds-qnty.gds-code = p_goods.gds-code  
        .
      find first pc-gds-obj no-lock where pc-gds-obj.gds-code = p_goods.gds-code and
        pc-gds-obj.obj-code = p-obj-code and
        pc-gds-obj.obj-type = p-obj-type and
        pc-gds-obj.corr-date = periodDate no-error .
      if not available (pc-gds-obj) then 
      do:
        find last pc-gds-obj2 no-lock where pc-gds-obj2.gds-code = p_goods.gds-code and
          pc-gds-obj2.obj-code = p-obj-code and
          pc-gds-obj2.obj-type = p-obj-type and
          pc-gds-obj2.corr-date < periodDate no-error .
        if available (pc-gds-obj2) then temp-gds-qnty.ost = pc-gds-obj2.fact-qnty .
      end.
      else temp-gds-qnty.ost = pc-gds-obj.fact-qnty .
    end.  
  end.  

end procedure. /* qnty-lib-create-tt */

