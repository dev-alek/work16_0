/*
$Revision$
$Author$
$Date$
$Workfile$
$Archive$
Отчет по всем сухим чекам продажи и возврата с топливом
Автор: 
Дата создания: 20/12/2014
Creation date: 20/12/2014
*/

define input parameter parparentproc      as widget-handle no-undo .
define input parameter parobj-type        like ub.trn-doc.obj-type no-undo. /*объект*/
define input parameter parobj-code        like ub.trn-doc.obj-code no-undo.
define input parameter p-tog-with-tot-day as logical            no-undo .

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Отчет по всем сухим чекам продажи и возврата с топливом".

{ cmp/vssrevis.i    }
{ cmp/str-glbl.i    }
{ cmp/library.i     }
{ cmp/r-page1.i     }
{ cmp/r-pril.i new  }
{ gbl/prn-lib.i     }
{ gbl/lastdate.i    }
{ gbl/cur-time.i    }
{ gbl/waitfram.i }
{ gbl/sys-time.i }   
{ ref/chk-type-desc.i }   

/* define buffer previous-rvs-doc    for ub.rvs-doc.
define buffer buf_rvs-doc         for ub.rvs-doc .
define buffer bef-rvs-line        for ub.rvs-line.
define buffer buf_rvs-line        for ub.rvs-line .
define buffer start-date-rvs-doc  for ub.rvs-doc.
define buffer end-date-rvs-doc    for ub.rvs-doc.
define buffer start-date-rvs-line for ub.rvs-line.
define buffer end-date-rvs-line   for ub.rvs-line.
define buffer bef-doc-rvs-doc     for ub.rvs-doc.
define buffer aft-doc-rvs-doc     for ub.rvs-doc.
define buffer bef-doc-rvs-line    for ub.rvs-line.
define buffer aft-doc-rvs-line    for ub.rvs-line.
define buffer buf_doc-pl          for ub.doc-pl .
define buffer buf_goods           for ub.goods . */
define buffer buf_clients         for ub.clients .
define buffer previous-shift-obj  for ub.shift-obj. 
/*define buffer buf_icnt-doc for ub.icnt-doc .
define buffer buf_icnt-line for ub.icnt-line . */

define variable v-file-name-rep-htm as character no-undo.
define variable var-report-num as int no-undo.

define variable gds_chk as int no-undo.
define variable gds_chk1 as character no-undo.
define variable produkt as character no-undo.
define variable t-chk-chr as character no-undo.
define variable time-chk-chr as character no-undo. /* время чека txt */
define variable kassir-chr as character no-undo. 
define variable trnz-chr as character no-undo. 
define variable opl-chr as character no-undo.    /*тип оплаты*/
define variable opl-sum as int no-undo.          /*сумма по типу опл*/
define variable kd-tv as character no-undo.      /*код товара */
define variable vCHFlag1 as character no-undo.   /*признак сухого чека    */
define variable vCHMgrKey as character no-undo.  /*ключ оператора*/
define variable vozvrtrn as character no-undo.  /*возврат по транзакции */


define variable o-qnt-chk as int no-undo.       /* Всего сухих чеков по объекту */
define variable o-qnt-pchk as int no-undo.      /* Всего сухих чеков продажи по объекту */
define variable o-qnt-vchk as int no-undo.      /* Всего сухих чеков возврата по объекту */
define variable o-sum-ob as int no-undo.        /* Сумма по обороту по объекту */
define variable o-sum-it as int no-undo.        /* Итоговая сумма по объекту */

define variable qnt-chk as int no-undo.       /* Всего сухих чеков */
define variable qnt-pchk as int no-undo.      /* Всего сухих чеков покупки */
define variable qnt-vchk as int no-undo.      /* Всего сухих чеков возврата */

define variable qnt-vschk-all as int no-undo.  /* Всего сухих чеков возврата*/
define variable qnt-vcchk-all as int no-undo.  /* Всего чеков частично возврата */
define variable qnt-vnchk-all as int no-undo.  /* Всего возвратов по номеру чека */ 
define variable qnt-vpchk-all as int no-undo.  /* Всего возвратов полных по транзакции */ 

define variable o-qnt-vschk-all as int no-undo.  /* Всего сухих чеков возврата по объекту*/
define variable o-qnt-vcchk-all as int no-undo.  /* Всего чеков частично возврата  по объекту*/
define variable o-qnt-vnchk-all as int no-undo.  /* Всего возвратов по номеру чека  по объекту*/ 
define variable o-qnt-vpchk-all as int no-undo.  /* Всего возвратов полных по транзакции  по объекту*/ 

define variable pr-qnt-vp as int no-undo.    /* % чеков возврата к общему количеству чеков продажи */
define variable pr-qnt-co as int no-undo.    /* % чеков частичного возврата к общему */
define variable pr-qnt-pvov as int no-undo.  /* % всех возвратов по номеру полных  к общему колву возврата*/
define variable pr-qnt-suhob as int no-undo. /* % всех сухих возвратов  к общему колву возврата*/
define variable pr-qnt-ostv as int no-undo. /* % остальных  возвратов  к общему колву возврата*/
define variable pr-qnt-ostp as int no-undo. /* % остальных  возвратов  к общему колву продаж*/



define variable sum-ob as int no-undo.        /* Сумма по обороту */
define variable sum-it as int no-undo.        /* Итоговая сумма */

define variable varhost-code  like ub.trn-doc.host-code  no-undo.
define variable v-host-name   as character               no-undo. /*название фирмы*/
define variable v-obj-name    as character               no-undo. /*АЗС*/

define variable var-prev-shift-date like ub.shift-obj.shift-date no-undo.
define variable var-prev-shift-num like ub.shift-obj.shift-num   no-undo.
define variable var-shift-staff   like ub.shift-staff.name       no-undo.

define stream OutStr-html.

/* define variable var-gds-rest_start_measure-kg  LIKE ub.rvs-line.state-measure-qnty  no-undo.
define variable var-gds-rest_start_book-kg     LIKE ub.rvs-line.system-qnty no-undo.
define variable var-gds-rest_start_measure-l   LIKE ub.rvs-line.state-measure-qnty no-undo.
define variable var-gds-rest_start_book-l      LIKE ub.rvs-line.system-qnty no-undo.
define variable var-gds-wayb_fact-kg           LIKE ub.trn-doc.cli-qnty no-undo.
define variable var-gds-wayb_fact-l            LIKE ub.trn-doc.fact-qnty no-undo.
define variable var-gds-exp-kg                 LIKE ub.trn-doc.cli-qnty no-undo.
define variable var-gds-exp-l                  LIKE ub.trn-doc.fact-qnty no-undo.
define variable var-gds-rest_end_measure-kg   LIKE ub.rvs-line.state-measure-cli-qnty no-undo.
define variable var-gds-rest_end_book-kg      LIKE ub.rvs-line.system-qnty no-undo.
define variable var-gds-rest_end_measure-l    LIKE ub.rvs-line.state-measure-qnty no-undo.
define variable var-gds-rest_end_book-l       LIKE ub.rvs-line.system-qnty no-undo.
define variable var-gds-rest_end_balans-kg    LIKE ub.rvs-line.state-measure-cli-qnty no-undo.
define variable var-gds-rest_end_balans-l     LIKE ub.rvs-line.system-qnty no-undo.

define variable var-pl-rest_start_measure-kg  LIKE ub.rvs-line.state-measure-qnty  no-undo.
define variable var-pl-rest_start_book-kg     LIKE ub.rvs-line.system-qnty no-undo.
define variable var-pl-rest_start_measure-l   LIKE ub.rvs-line.state-measure-qnty no-undo.
define variable var-pl-rest_start_book-l      LIKE ub.rvs-line.system-qnty no-undo.
define variable var-pl-wayb_fact-kg           LIKE ub.trn-doc.cli-qnty no-undo.
define variable var-pl-wayb_fact-l            LIKE ub.trn-doc.fact-qnty no-undo.
define variable var-pl-exp-kg                 LIKE ub.trn-doc.cli-qnty no-undo.
define variable var-pl-exp-l                  LIKE ub.trn-doc.fact-qnty no-undo. */

/*АЗС*/

find first buf_clients no-lock
  where buf_clients.obj-type = parobj-type
    and buf_clients.obj-code = parobj-code
  .
assign
  v-obj-name = buf_clients.obj-name
.

{ gbl/hostcode.i parobj-type parobj-code varhost-code}

/*Своя фирма*/
find first buf_clients no-lock
  where buf_clients.obj-type = {&cmp}
    and buf_clients.obj-code = varhost-code
  .
assign
  v-host-name = buf_clients.obj-name
.

            find last previous-shift-obj share-lock
            where previous-shift-obj.obj-type = parobj-type
            and previous-shift-obj.obj-code = parobj-code
            and (( previous-shift-obj.shift-date = X-date-Start
                   and previous-shift-obj.shift-num < X-Shift-Start
                 )
                 or previous-shift-obj.shift-date < X-date-Start
                )
            use-index pi no-error.
            if available previous-shift-obj then do:
                var-prev-shift-num = previous-shift-obj.shift-num.
                var-prev-shift-date = previous-shift-obj.shift-date.
            end.    

    

    run get-report-num in parParentProc (
    output var-report-num
        ).

        v-file-name-rep-htm = session:temp-directory + {&DF_Name} + string(var-report-num) + ".html".
        /* Создаём временные файлы. */
            output to value(v-file-name-rep-htm).
            output close.
        /* ******************** */

   
      /*Шапка*/
 def var v-first-time as int no-undo.
 def var v-first-date as date no-undo.
 def var v-last-date as date no-undo.
 def var v-last-time as int no-undo.   

      output stream OutStr-html to value(v-file-name-rep-htm) convert target 'UTF-8' /*no-convert*/.

      put stream OutStr-html unformatted
        substitute ('
      <!DOCTYPE HTML>
      <html>
          <head>
                <meta charset="UTF-8">
                    <!-- Стили документа -->
                <style>
                     table ~{
                         border-collapse: collapse; 
                     ~}
                     tbody td, th ~{
                         border: 1px solid black;
                         border-collapse: collapse;
                   height: 14px;
                     ~}
          </style>
         
          </head>
          
          <body>
             <table orientation = "landscape" name = "Отчет по сухим чекам" fit_to_page="true">  <!-- таблица, в которой содержится весь отчет -->
             <thead>  <!-- Шапка отчета -->
                      <!-- Обязательно создаётся строка таблицы, в которой находятся размеры колонок в px-->
                        <tr class="set_columns">
                          <td style="width:85px"></td>
                          <td style="width:85px"></td>
                          <td style="width:30px"></td>
                          <td style="width:15px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:60px"></td>
                        </tr>
                        <tr>
                        <td colspan="20" style="font-size:18px;font-weight:bold; text-align: left;">Отчет по всем сухим чекам продажи и возврата с топливом</td>
                        </tr>
                        
                        <tr>
                        <td colspan="5" style="font-size:11px; text-align: left;">&1</td>
                        <td colspan="15"></td>
                        </tr>
                        
                        <tr>
                        <td colspan="20" style="text-align:left;"> за период с &3 по &4</td>
                        </tr>
                        <tr>
                        <td colspan="20" style="text-align:left;">Выбор объекта: &2</td>
                        </tr>
                        <tr>
                        <td colspan="20" style="text-align:left;">Вся номенклатура</td>
                        </tr>
                        <tr>
                        <td colspan="20" style="text-align:left;">Все поставщики</td>
                        </tr>
                        <tr>
                        <td colspan="20" >Отчет по всем сухим чекам продажи и возврата с топливом</td>
                      </tr>          
                    </thead>
            
              <tbody> <!-- Здесь начинается таблица отчета -->
                    <tr> <!-- Первые строки – шапка таблицы с тэгами tr -->
                        <th rowspan="1" style="text-align: center;">ПНПО</th>
                        <th rowspan="1" style="text-align: center;">Наименование объекта</th>
                        <th rowspan="1" style="text-align: center;">Номер кассы</th>
                        <th rowspan="1" style="text-align: center;">Смена</th>
                        <th rowspan="1" style="text-align: center;">Дата смены</th>
                        <th rowspan="1" style="text-align: center;">Тип чека</th>
                        <th rowspan="1" style="text-align: center;">Номер чека</th>
                        <th rowspan="1" style="text-align: center;">Создан в ТН</th>
                        <th rowspan="1" style="text-align: center;">Дата чека</th>
                        <th rowspan="1" style="text-align: center;">Время чека</th>
                        <th rowspan="1" style="text-align: center;">Продукт</th>
                        <th rowspan="1" style="text-align: center;">ТРК</th>
                        <th rowspan="1" style="text-align: center;">Пистолет</th>
                        <th rowspan="1" style="text-align: center;">Кол-во</th>
                        <th rowspan="1" style="text-align: center;">Цена за ед.</th>
                        <th rowspan="1" style="text-align: center;">Сумма по чеку</th>
                        <th rowspan="1" style="text-align: center;">Сумма по типу оплаты</th>
                        <th rowspan="1" style="text-align: center;">Тип оплаты</th>
                        <th rowspan="1" style="text-align: center;">ФИО кассира</th>
                    </tr>'
                 ,
                string(v-host-name),
                string(v-obj-name),
                string(x-Date-Start, "99.99.9999") + ' ' + string(v-first-time,"HH:MM") ,
                string(X-date-End, "99.99.9999") + ' ' + string(v-last-time,"HH:MM")
        ).

FIND FIRST gds-list no-lock no-error .
IF NOT AVAILABLE gds-list THEN DO:
MESSAGE 'Не выбрана группа товаров!' VIEW-AS ALERT-BOX. 
END.


   FOR EACH obj-list  NO-LOCK:                       

     FOR EACH chk-doc where chk-doc.obj-code = obj-list.obj-code 
                            and chk-date >= x-Date-Start 
                            and chk-date <= x-Date-End  
                            and (chk-doc.chk-type = 1 or chk-doc.chk-type = 6) NO-LOCK:

       FOR EACH  chk-gds where chk-gds.doc-code = chk-doc.doc-code 
                 and chk-gds.pass-gds = 1 NO-LOCK:                   /*сухой чек*/

          produkt = ''.
          time-chk-chr = ''.
          gds_chk = 0.
          opl-sum = 0.

          find first bar-code where bar-code.b-code eq chk-gds.b-code no-lock no-error.
          IF AVAILABLE bar-code THEN  gds_chk = bar-code.gds-code.

          /* название товара */
          find first goods where gds_chk eq goods.gds-code no-lock no-error.
          IF AVAILABLE goods THEN  produkt = TRIM(goods.gds-name).

          /* кассир */
          find first person where person.psn-code = chk-doc.cashier-psn-code no-lock no-error.
          IF AVAILABLE person THEN  kassir-chr = person.name1 + ' ' + person.name2 + ' '. 
          find first clients where person.psn-code = clients.obj-code and clients.obj-type = 'чел' no-lock no-error.
          IF AVAILABLE clients THEN kassir-chr = kassir-chr + clients.obj-name.

          /* тип платежа*/
          find first chk-pay where chk-pay.doc-code = chk-doc.doc-code no-lock no-error.
          IF AVAILABLE chk-pay THEN DO:
            opl-sum = tot-sum.
            find first cash-pay where cash-pay.cdpay-code = chk-pay.pay-code no-lock no-error.
            IF AVAILABLE cash-pay THEN opl-chr = cash-pay.obj-name.
          END.

          IF chk-gds.time-oper <> ? THEN time-chk-chr = string(chk-gds.time-oper, "HH:MM").        /* время чека */
          t-chk-chr = ENTRY(LOOKUP(string(chk-doc.chk-type), {&CHK_CODE_LIST}),{&CHK_NAME_LIST}).  /* тип чека txt*/



          FOR EACH gds-list where gds-list.gds-code = goods.gds-code NO-LOCK:                      /* код товара из группы*/                      

          o-qnt-chk = o-qnt-chk + 1.
          IF chk-doc.chk-type = 1 THEN o-qnt-pchk = o-qnt-pchk + 1. /* продажа */
          IF chk-doc.chk-type = 6 THEN o-qnt-vchk = o-qnt-vchk + 1. /* возврат */
          o-sum-ob = o-sum-ob + ABSOLUTE(chk-gds.src-sum).          
          o-sum-it = o-sum-it + chk-gds.src-sum.

          put stream OutStr-html unformatted 
          '<tr>' skip
          '<td>' skip
            v-host-name
          '</td>' skip
          '<td>' skip
             obj-list.obj-name                            /*наименование объекта*/
          '</td>' skip
          '<td  style="text-align:center;">' skip
           chk-doc.pay-desk                               /* касса */
          '</td><td  style="text-align:center;">' skip
           chk-doc.shift-name                             /* смена */
          '</td><td>' skip
           chk-doc.shift-date                             /* дата смены */
          '</td><td style="text-align:center;">' skip    
           t-chk-chr                                      /* тип чека */
          '</td><td style="text-align:center;">' skip
           chk-doc.chk-num                                /* номер чека */
          '</td><td style="text-align:center;">' skip
           /* chk-gds.pass-gds */
          '-'
          '</td><td style="text-align:center;">' skip
           chk-gds.chk-date                                /* дата чека */
          '</td><td style="text-align:center;">' skip
           time-chk-chr                                    /* время чека */
          '</td><td>' skip
           SUBSTRING(produkt,1,50)                         /* наим.товара */
          '</td><td  style="text-align:center;">' skip
           chk-gds.pump                                    /* ТРК */
          '</td><td  style="text-align:center;">' skip
           chk-gds.nozzle-code                             /* пистолет */
          '</td><td  style="text-align:right;">' skip
           chk-gds.doc-qnty
          '</td><td style="text-align:center;">' skip
           chk-gds.price-base
          '</td>' skip
          '<td style="text-align:right;">' skip
           chk-gds.src-sum
          '</td>' skip
          '<td  style="text-align:right;">' skip
            opl-sum          
          '</td>' skip
          '<td style="text-align:center;">' skip
           opl-chr                                 /*тип оплаты */
          '</td>' skip
          '<td>' skip
           kassir-chr                             /* кассир*/
           '</td>' skip
           '</tr>' skip
          .
          END.
     END.
   END.

/* Итоги по объекту */
          if o-qnt-chk > 0 then do:
          put stream OutStr-html unformatted 
          '<tr>' skip
          '<td><b>' skip
            'Итог по '
          '</b></td>' skip
          '<td>' skip
             obj-list.obj-name 
          '</td>' skip
          '<td  style="text-align:center;">' skip
           'Всего сухих чеков:'
          '</td><td  style="text-align:center;">' skip
          o-qnt-chk 
          '</td><td>' skip
           'Всего сухих чеков продажи:'
          '</td><td style="text-align:center;">' skip
          o-qnt-pchk 
          '</td><td style="text-align:center;">' skip
           'Всего сухих чеков возврата:'
          '</td><td style="text-align:center;">' skip
           o-qnt-vchk 
          '</td><td>' skip
           'Сумма по обороту:'
          '</td><td style="text-align:center;">' skip
           o-sum-ob
          '</td><td>' skip
          'Итоговая сумма:'
          '</td><td>' skip
           o-sum-it
          '</td><td>' skip
          '</td><td>' skip
          '</td><td>' skip
          '</td>' skip
          '<td>' skip
          '</td>' skip
          '<td>' skip
          '</td>' skip
          '<td>' skip
          '</td>' skip
          '<td>' skip
          '</td>' skip
         '</tr>' skip
        .
        end.
        qnt-chk = qnt-chk + o-qnt-chk.
        qnt-pchk = qnt-pchk + o-qnt-pchk.
        qnt-vchk = qnt-vchk + o-qnt-vchk.
        sum-it = sum-it + o-sum-it.
        sum-ob = sum-ob + o-sum-ob.

        o-qnt-chk = 0.
        o-qnt-pchk = 0.
        o-qnt-vchk = 0.
        o-sum-it = 0.
        o-sum-ob = 0.

  END. 

/* итог по отчету */
put stream OutStr-html unformatted          
          '<tr>' skip
          '<td><b>' skip
            'Итог по '
          '</b></td>' skip
          '<td>' skip
          v-host-name
          '</td>' skip
          '<td  style="text-align:center;">' skip
           'Всего сухих чеков:'
          '</td><td style="text-align:center;">' skip
            qnt-chk 
          '</td><td>' skip
           'Всего сухих чеков продажи:'
          '</td><td style="text-align:center;">' skip
           qnt-pchk
          '</td><td style="text-align:center;">' skip
           'Всего сухих чеков возврата:'
          '</td><td style="text-align:center;">' skip
           qnt-vchk
          '</td><td>' skip
           'Сумма по обороту:'
          '</td><td style="text-align:center;">' skip
           sum-ob
          '</td><td>' skip
          'Итоговая сумма:'
          '</td>' skip
          '<td>' skip
            sum-it
         '</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>' skip
         '</tr>' skip
         '</tbody>' skip
         '</table>'skip
        .

/* Отчет по всем возвратным операциям */

put stream OutStr-html unformatted
   substitute (' 
<table orientation = "landscape" name = " Отчет по сухим чекам  " fit_to_page="true">  <!-- таблица, в которой содержится весь отчет -->
                      <thead>  <!-- Шапка отчета -->
                      <!-- Обязательно создаётся строка таблицы, в которой находятся размеры колонок в px-->
                        <tr class="set_columns">
                          <td style="width:85px"></td>
                          <td style="width:85px"></td>
                          <td style="width:85px"></td>
                          <td style="width:30px"></td>
                          <td style="width:15px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:60px"></td>
                        </tr>
                        <tr>
                          <td colspan="20" style="font-size:18px;font-weight:bold; text-align: left;">Отчет по всем возвратным операциям </td>
                        </tr>
                        <tr>
                          <td colspan="5" style="font-size:11px; text-align: left;">&1</td>
                          <td colspan="15"></td>
                      </tr>
                      <tr>
                        <td colspan="20" style="text-align:left;"> за период с &3 по &4</td>
                      </tr>
                      <tr>
                        <td colspan="20" style="text-align:left;">Выбор объекта: &2</td>
                      </tr>
                      <tr>
                        <td colspan="20" style="text-align:left;">Вся номенклатура</td>
                      </tr>
                      <tr>
                        <td colspan="20" style="text-align:left;">Все поставщики</td>
                      </tr>
                      <tr>
                        <td colspan="20" >Отчет по всем возвратным операциям </td>
                      </tr>          
                    </thead>
            
              <tbody> <!-- Здесь начинается таблица отчета -->
                    <tr> <!-- Первые строки – шапка таблицы с тэгами tr -->
                    <th rowspan="1" style="text-align: center;">ПНПО</th>
                    <th rowspan="1" style="text-align: center;">Наименование объекта</th>
                    <th rowspan="1" style="text-align: center;">Номер кассы</th>
                    <th rowspan="1" style="text-align: center;">Смена</th>
                    <th rowspan="1" style="text-align: center;">Дата смены</th>
                    <th rowspan="1" style="text-align: center;">Номер чека возврата</th>
                    <th rowspan="1" style="text-align: center;">Дата чека возврата</th>
                    <th rowspan="1" style="text-align: center;">Время чека возврата</th>
                    <th rowspan="1" style="text-align: center;">Товар в чеке возврата</th>
                    <th rowspan="1" style="text-align: center;">Код товара	</th>
                    <th rowspan="1" style="text-align: center;">Кол-во в чеке возврата</th>
                    <th rowspan="1" style="text-align: center;">Сумма в чеке возврата</th>
                    <th rowspan="1" style="text-align: center;">Сумма по типу оплаты</th>
                    <th rowspan="1" style="text-align: center;">Тип оплаты</th>
                    <th rowspan="1" style="text-align: center;">Номер транзакции в чеке возврата</th>
                    <th rowspan="1" style="text-align: center;">Возврат по транзакции</th>
                    <th rowspan="1" style="text-align: center;">Номер прямого чека</th>
                    <th rowspan="1" style="text-align: center;">Признак сухого чека на ККМ</th>
                    <th rowspan="1" style="text-align: center;">С ключем +/ без ключа -</th>
                    <th rowspan="1" style="text-align: center;">ФИО кассира</th>
                    </tr>',
                string(v-host-name),
                string(v-obj-name),
                string(x-Date-Start, "99.99.9999") + ' ' + string(v-first-time,"HH:MM") ,
                string(X-date-End, "99.99.9999") + ' ' + string(v-last-time,"HH:MM")
).


   FOR EACH obj-list  NO-LOCK:                       

       FOR EACH chk-doc where chk-doc.obj-code = obj-list.obj-code 
                          and chk-date >= x-Date-Start 
                          and chk-date <= x-Date-End 
                          and (chk-doc.chk-type = 1 or chk-doc.chk-type = 6) NO-LOCK:
                          qnt-pchk = qnt-pchk + 1 .     

/*message  obj-list.obj-code chk-doc.chk-type  view-as alert-box .*/

         FOR EACH chk-gds where chk-gds.doc-code = chk-doc.doc-code 
                 AND chk-doc.chk-type = 6 NO-LOCK:

          produkt = ''.
          time-chk-chr = ''.
          gds_chk = 0.
          opl-sum = 0.

          /* наименование по баркоду */
          find first bar-code where bar-code.b-code eq chk-gds.b-code no-lock no-error.
          IF AVAILABLE bar-code THEN  gds_chk = bar-code.gds-code.
          find first goods where gds_chk eq goods.gds-code no-lock no-error.
          IF AVAILABLE goods THEN  produkt = TRIM(goods.gds-name).

          /* код товара */
          /*message p-tog-with-tot-day view-as alert-box .*/
          kd-tv = string(chk-gds.b-code).


          /* код товара */
          /*message p-tog-with-tot-day view-as alert-box .*/
          kd-tv = string(chk-gds.b-code).


          /* фио кассира */
          find first person where person.psn-code = chk-doc.cashier-psn-code no-lock no-error.
          IF AVAILABLE person THEN  kassir-chr = person.name1 + ' ' + person.name2 + ' '. /* кассир */
          find first clients where person.psn-code = clients.obj-code and clients.obj-type = 'чел' no-lock no-error.
          IF AVAILABLE clients THEN kassir-chr = kassir-chr + clients.obj-name.

          /*тип платежа*/
          find first chk-pay where chk-pay.doc-code = chk-doc.doc-code no-lock no-error.
          IF AVAILABLE chk-pay THEN DO:
            opl-sum = tot-sum.
            find first cash-pay where cash-pay.cdpay-code = chk-pay.pay-code no-lock no-error.
            IF AVAILABLE cash-pay THEN opl-chr = cash-pay.obj-name.
          END.

          /* id чека */
          find first chk-doc-attr where chk-doc-attr.attr-code = 'CheckId' and chk-doc-attr.doc-code = chk-doc.doc-code no-lock no-error.
          /*message chk-doc-attr.attr-value view-as alert-box .*/
             IF AVAILABLE chk-doc-attr THEN DO: 
                find first tran-fuel  where  tran-fuel.uuid-cheq eq chk-doc-attr.attr-value no-lock no-error.
                IF AVAILABLE tran-fuel then trnz-chr = string(tran-fuel.tran-num).   
             END.
      
         IF chk-gds.time-oper <> ? THEN time-chk-chr = string(chk-gds.time-oper, "HH:MM").   /* время чека */

          
         FOR EACH gds-list where gds-list.gds-code = goods.gds-code NO-LOCK:                       

          o-qnt-chk = o-qnt-chk + 1.
          IF chk-doc.chk-type = 1 THEN o-qnt-pchk = o-qnt-pchk + 1.
          IF chk-doc.chk-type = 6 THEN o-qnt-vchk = o-qnt-vchk + 1.

          /* признак сухого чека */
          find first chk-doc-attr where chk-doc-attr.doc-code = chk-doc.doc-code
                      and chk-doc-attr.attr-code = 'CHFlag1' no-lock no-error.
                 IF AVAILABLE chk-doc-attr THEN DO:
                     if chk-doc-attr.attr-value = '0' then vCHFlag1 = 'Свободный возврат' .
                     else if chk-doc-attr.attr-value = '1' then vCHFlag1 = 'Частичный возврат' .
                     else if chk-doc-attr.attr-value = '2' then vCHFlag1 = 'Полный возврат по номеру чека' .
                     else if chk-doc-attr.attr-value = '3' then vCHFlag1 = 'Частичный возврат по номеру чека'.
                     else if chk-doc-attr.attr-value = '4' then vCHFlag1 = 'возврат полностью не пролитого топлива' .

                     if chk-doc-attr.attr-value = '1' then qnt-vcchk-all = qnt-vcchk-all + 1 . /*частичный возврат*/
                         else if chk-doc-attr.attr-value = '2' then qnt-vnchk-all = qnt-vnchk-all + 1 . /*полный возврат*/
                         else if chk-doc-attr.attr-value = '4' then qnt-vchk = qnt-vchk + 1 . /*сухие чеки */
 
                     if chk-doc-attr.attr-value = '1' then  vozvrtrn = '+' .          /*частичный возврат*/
                        else if chk-doc-attr.attr-value <> '1' then  vozvrtrn = '-' . /*частичный возврат*/
                 END.

          /* с ключем без ключа   */
          find first chk-doc-attr where chk-doc-attr.doc-code = chk-doc.doc-code
                      and chk-doc-attr.attr-code = 'CHMgrKey' no-lock no-error.
              IF AVAILABLE chk-doc-attr THEN DO: 
                  if chk-doc-attr.attr-value = '0' then vCHMgrKey = '-'. 
                  else if chk-doc-attr.attr-value = '1' then vCHMgrKey = '+'.
              END.

          put stream OutStr-html unformatted 
          '<tr>' skip
          '<td>' skip
            v-host-name
          '</td>' skip
          '<td>' skip
             obj-list.obj-name 
          '</td>' skip
          '<td  style="text-align:center;">' skip
           chk-doc.pay-desk                                /*касса*/
          '</td><td  style="text-align:center;">' skip
           chk-doc.shift-name                              /*смена*/
          '</td><td>' skip                                        
           chk-doc.shift-date                              /*дата смены*/
          '</td><td style="text-align:center;">' skip
           chk-doc.chk-num                                 /*номер чека возврата*/
          '</td><td style="text-align:center;">' skip
           chk-gds.chk-date                                /*дата чека возврата*/
          '</td><td style="text-align:center;">' skip
           time-chk-chr                                    /* время чека */
          '</td><td>' skip
           SUBSTRING(produkt,1,50)                         /*товар в чеке возврата*/
          '</td>' skip
          '<td>' skip
            kd-tv                                          /* код товара */        
          '</td>' skip
          '<td style="text-align:center;">' skip
           ABSOLUTE(chk-gds.doc-qnty)                     /*количество*/
          '</td><td style="text-align:center;">' skip
           ABSOLUTE(chk-gds.src-sum)                      /*Сумма в чеке */
          '</td><td  style="text-align:center;">' skip
           ABSOLUTE(opl-sum)                              /*Сумма по типу оплаты*/
          '</td><td  style="text-align:center;">' skip
           opl-chr                                        /*тип оплаты*/
          '</td><td  style="text-align:center;">' skip
           trnz-chr                                       /* транзакция */
          '</td><td  style="text-align:center;">' skip
           vozvrtrn                                       /*возврат по транзакции*/
          '</td>' skip
          '<td style="text-align:center;">' skip
            chk-num                                       /*номер прямого чека*/
          '</td>' skip
          '<td>' skip
            vCHFlag1                                      /* признак сухого чека на ККМ*/
          '</td>' skip
          '<td style="text-align:center;">' skip
            vCHMgrKey                       /* ключ оператора*/
          '</td>' skip
          '<td>' skip
            kassir-chr        /* кассир*/
          '</td>' skip
         '</tr>' skip
        .
        end.
      END.
     END.

/* Итоги по объекту  ---------------------------------*/
          pr-qnt-vp = ( o-qnt-chk / qnt-pchk ) * 100 .
          pr-qnt-co = ( qnt-vcchk-all / o-qnt-chk ) * 100 .
          pr-qnt-pvov = (qnt-vnchk-all / o-qnt-chk ) * 100 .
          pr-qnt-suhob = qnt-vchk / o-qnt-pchk * 100.
          pr-qnt-ostv = (o-qnt-chk - qnt-vnchk-all - qnt-vcchk-all) / o-qnt-chk * 100 .
          pr-qnt-ostp = (o-qnt-chk - qnt-vnchk-all - qnt-vcchk-all) / qnt-pchk * 100 .

          if o-qnt-chk > 0 then do:
          put stream OutStr-html unformatted 
          '<tr>' skip
          '<td><b>' skip
            'Итог по кол-ву:'
          '</b></td>' skip
          '<td>' skip
             obj-list.obj-name 
          '</td>' skip
          '<td  style="text-align:center;">' skip
           'Всего чеков возврата:'
          '</td><td  style="text-align:center;">' skip
          o-qnt-chk 
          '</td><td>' skip
           'Всего чеков с частичным возвратом:'
          '</td><td style="text-align:center;">' skip
          qnt-vcchk-all 
          '</td><td style="text-align:center;">' skip
           'Всего возвратов по номеру чека/полных по транзакции:'
          '</td><td>' skip
           qnt-vnchk-all
          '</td><td>' skip
           'Всего сухих чеков возврата:'
          '</td><td style="text-align:center;">' skip
           qnt-vchk
          '</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>' skip
         '</tr>' skip

          /* Итого по соотношению */
          '<tr>' skip
          '<td><b>' skip
            'Итого по соотношению' skip
          '</b></td>' skip
          '<td>' skip
          '</td>' skip
          '<td  style="text-align:center;">' skip
           '% чеков возврата к общему количеству чеков продажи:'
          '</td><td  style="text-align:center;">' skip
          pr-qnt-vp
          '</td><td>' skip
          ' % частичного возврата к общему количеству чеков возврата:'
          '</td><td style="text-align:center;">' skip
          pr-qnt-co
          '</td><td style="text-align:center;">' skip
          '% остальных чеков  возврата к общему количеству чеков возврата:'
          '</td>' skip
          '<td>' skip
           pr-qnt-ostv
          '</td><td>' skip
           '% остальных чеков  возврата к общему количеству чеков продажи:'
          '</td><td style="text-align:center;">' skip
          pr-qnt-ostp
          '</td>' skip
          '<td>% всех возвратов по номеру чека/полных по транзакции к общему кол-ву чеков возврата:</td>' skip
          '<td>'skip
           pr-qnt-pvov
          '</td>' skip
          '<td>% всех сухих чеков возврата к общему кол-ву чеков возврата</td>' skip
          '<td>' skip
           pr-qnt-suhob
           '</td><td></td><td></td><td></td><td></td><td></td><td></td>' skip
         '</tr> ' skip
        .
         end.
        o-qnt-chk = 0.
        o-qnt-pchk  = 0.
        o-qnt-vchk  = 0.
  END. 

put stream OutStr-html unformatted
   substitute (' 
</tbody> 
</table> 
</body> 
</html> 
 ').
      
  output stream OutStr-html close.   
      
     run prn-lib-reportviewer in this-procedure (
        input parparentproc
        ,input v-file-name-rep-htm
        ,input "" 
        ) no-error.
    if error-status:error then
    do:
        message return-value view-as alert-box.
        return .
    end.

