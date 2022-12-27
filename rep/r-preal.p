/*
$Revision$
$Author$
$Date$
$Workfile$
$Archive$
Отчет по анализу длительности пересменка (Простой реализации до первого чека)
Автор: 
Дата создания: 20/12/2014
Creation date: 20/12/2014
*/

define input parameter parparentproc      as widget-handle no-undo .
define input parameter parobj-type        like ub.trn-doc.obj-type no-undo. /*объект*/
define input parameter parobj-code        like ub.trn-doc.obj-code no-undo.
define input parameter porog-zn as INTEGER    no-undo .
define input parameter type-pos as character   no-undo .

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Отчет по анализу длительности пересменка (Простой реализации до первого чека)".

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

define buffer buf_clients         for ub.clients .
define variable v-file-name-rep-htm as character no-undo.
define variable var-report-num as int no-undo.
define variable time-chk-chr as character no-undo. /* время чека txt */
define variable kassir-chr as character no-undo. 
define variable varhost-code  like ub.trn-doc.host-code  no-undo.
define variable v-host-name   as character               no-undo. /*название фирмы*/
define variable v-obj-name    as character               no-undo. /*АЗС*/
define variable var-prev-shift-date like ub.shift-obj.shift-date no-undo.
define variable var-prev-shift-num like ub.shift-obj.shift-num   no-undo.
define variable var-shift-staff   like ub.shift-staff.name       no-undo.
define stream OutStr-html.

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
    run get-report-num in parParentProc (
    output var-report-num
        ).
        v-file-name-rep-htm = session:temp-directory + {&DF_Name} + string(var-report-num) + ".html".
        /* Создаём временные файлы. */
            output to value(v-file-name-rep-htm).
            output close.
        /* ******************** */
		/* Шапка */
 def var v-first-time as int no-undo.
 def var v-first-date as date no-undo.
 def var v-last-date as date no-undo.
 def var v-last-time as int no-undo.   
   
      output stream OutStr-html to value(v-file-name-rep-htm) convert target 'UTF-8' /*no-convert*/.
      put stream OutStr-html unformatted
        substitute ('
        <!DOCTYPE HTML>
              <html>
			     <head><meta charset="UTF-8">
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
                    <table orientation="landscape" name = "Отчет по пересменкам" fit_to_page="true">  <!-- таблица, в которой содержится весь отчет -->
                      <thead>  <!-- Шапка отчета -->
                      <!-- Обязательно создаётся строка таблицы, в которой находятся размеры колонок в px-->
                        <tr class="set_columns">
                          <td style="width:200px"></td>
                          <td style="width:85px"></td>
                          <td style="width:250px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                          <td style="width:50px"></td>
                      </tr>
                      <tr>
                        <td colspan="7"></td>
                      </tr>
                      <tr style="height:40px;">  
                        <td colspan="7"> Отчет по анализу длительности пересменка ( Простой реализации до первого чека ) </td>
                      </tr>
                      <tr>
					  <td colspan="1"> Фирма: </td>
                        <td colspan="6"> &2 </td>
                      </tr>
                      <tr>
					    <td colspan="1" > Период: </td>
                        <td colspan="6" > с &3 по &4</td>
                      </tr>
					  <tr>
					    <td colspan="1" > Фильтры: </td>
                        <td colspan="6" > </td>
                      </tr>
					  <tr>
					    <td colspan="1" > Порог: </td>
                        <td colspan="6" > &5 </td>
                      </tr>
					  
					  <tr>
					    <td colspan="1" > Типы касс: </td>
                        <td colspan="6" > &6 </td>
                      </tr>
                      <tr>
                        <td colspan="7"></td>
                      </tr>          
                    </thead>
               <tbody> <!-- Здесь начинается таблица отчета -->
                    <tr bgcolor="#C6E0B4"> <!-- Первые строки – шапка таблицы с тэгами tr -->
                    <th rowspan="2" style="text-align: center;">Наименование объекта</th>
                    <th rowspan="2" style="text-align: center;">Дата</th>
                    <th rowspan="2" colspan="5"  style="text-align: center;">Простой реализации на АЗК/АЗС</th>
                </tr>
                <tr>
                </tr>
                <tr bgcolor="#C6E0B4">
                    <th style="text-align: center;">Номер кассы</th>
                    <th style="text-align: center;">Тип кассы</th>
                    <th style="text-align: center;">Старший смены</th>
                    <th style="text-align: center;">Время последнего чека продажи</th>
                    <th style="text-align: center;">Время первого чека продажи</th>
                    <th style="text-align: center;">Время простоя реализации</th>
                    <th style="text-align: center;">Время превышения установленного порога простоя реализации</th>
                  </tr>'
                ,
                string(v-host-name),
                string(v-obj-name),
                /* string(x-Date-Start, "99.99.9999") + ' ' + string(v-first-time,"HH:MM") ,
                string(X-date-End, "99.99.9999") + ' ' + string(v-last-time,"HH:MM") */
				string(x-Date-Start, "99.99.9999") ,
                string(X-date-End, "99.99.9999"),
				porog-zn ,
				type-pos 
        ).
	
DEFINE TEMP-TABLE tt-peresmen NO-UNDO
	FIELD ob-type               LIKE  chk-doc.obj-type      /* тип объекта */
	FIELD kod-azs               like  chk-doc.obj-code      /* код объекта */
	FIELD name-azs              as character                
	FIELD kassa                 LIKE  chk-doc.pay-desk      /* касса */
	FIELD kassir                like  chk-doc.cashier       /* кассир */
	FIELD kassir2               like  chk-doc.cashier-psn-code /* кассир */
    FIELD shift-num             like  chk-doc.shift-num     /* номер смены */
    FIELD shift-date            like  chk-doc.shift-date    /*дата смены */
    FIELD shift-time-beg        like  chk-doc.chk-time      /* начало пересменки */
    FIELD shift-time-end        like  chk-doc.chk-time      /* конец пересменки */
	FIELD peresm-date           like  chk-doc.chk-date      /*дата пересменки */
    FIELD time-p                AS INT                      /* длительность */
	FIELD npp                   AS INT                      /* номер пересменки */
	FIELD shift-name            like  chk-doc.shift-name    /* номер смены */
	FIELD flg                   AS INT                      
    INDEX pi AS UNIQUE PRIMARY  kod-azs kassa peresm-date npp    
	.         
		
DEFINE TEMP-TABLE tt-tr NO-UNDO 
    FIELD npp               AS INT         /* номер строки */ 
	FIELD td_1              as character   /* значения внутри тега TD */              
	FIELD td_2              as character                
	FIELD td_3              as character                
	FIELD td_4              as character                
	FIELD td_5              as character                
	FIELD td_6              as character                
	FIELD td_7              as character                
    INDEX pi AS UNIQUE PRIMARY  npp 
 .         

define variable smena_old    as CHARACTER    no-undo. 
define variable kassa_old    as INTEGER    no-undo. 		
define variable kod-azs_old  as INTEGER    no-undo. 		
define variable shift-date_old as DATE     no-undo. 		
DEFINE VARIABLE nom_p as int init 0	 NO-UNDO.

DEFINE VARIABLE time-p-all AS INT NO-UNDO.		
DEFINE VARIABLE time-kas AS INT NO-UNDO init 0.		
DEFINE VARIABLE time-azs AS INT NO-UNDO init 0.		


DEFINE VARIABLE kassir1 AS int NO-UNDO init 0.		
DEFINE VARIABLE kod-azs2 AS int NO-UNDO init 0.		 
DEFINE VARIABLE name-azs2 AS CHARACTER NO-UNDO.		 
DEFINE VARIABLE manager AS CHARACTER NO-UNDO.	    /* Старший смены */
DEFINE VARIABLE date_it AS DATE NO-UNDO.
DEFINE VARIABLE ch-1 AS int NO-UNDO init 1.		
DEFINE VARIABLE ch-2 AS int NO-UNDO init 0.		

DEFINE VARIABLE kol-prev AS int NO-UNDO init 0.		    /* количество превышений */
DEFINE VARIABLE kol-prev-kassa AS int NO-UNDO init 0.	/* количество превышений по кассе */
DEFINE VARIABLE kol-prev-azs AS int NO-UNDO init 0.		/* количество превышений  по АЗС */

DEFINE VARIABLE kol-per AS int NO-UNDO init 0.		    /* количество превышений */
DEFINE VARIABLE kol-per-kassa AS int NO-UNDO init 0.	/* количество превышений по кассе */
DEFINE VARIABLE kol-per-azs AS int NO-UNDO init 0.		/* количество превышений  по АЗС */


DEFINE VARIABLE time-prev-kassa AS int NO-UNDO init 0.	/* время превышений*/	
DEFINE VARIABLE time-prev-azs AS int NO-UNDO init 0.	/* время превышений*/	
DEFINE VARIABLE time-prev AS int NO-UNDO init 0.	/* время превышений*/	

DEFINE VARIABLE time-pr-sv AS int NO-UNDO init 0.	/* среднее время превышений*/	

DEFINE VARIABLE prm-1 AS int NO-UNDO .		
DEFINE VARIABLE prm-2 AS int NO-UNDO .		
DEFINE VARIABLE prm-3 AS int NO-UNDO .		
DEFINE VARIABLE prm-4 AS int NO-UNDO .		
		
 FOR EACH obj-list  NO-LOCK:                       		
	FOR EACH chk-doc WHERE  chk-doc.obj-code = obj-list.obj-code
	                    AND chk-date >= x-Date-Start 
						AND chk-date <= x-Date-End
						AND	(chk-type = 13 OR chk-type = 40)
                        NO-LOCK BY chk-doc.chk-num:
						
			/* закрытие смены */
			IF chk-doc.chk-type = 13 
			THEN DO: 
			FIND FIRST cash-desk WHERE cash-desk.obj-code = chk-doc.obj-code AND cash-desk.cash-num = chk-doc.pay-desk no-lock no-error.            
            IF   cash-desk.pos-type  =  type-pos OR  type-pos = 'Все' THEN DO:     
			CREATE tt-peresmen.
			ASSIGN
			tt-peresmen.kod-azs = chk-doc.obj-code
			tt-peresmen.kassa = chk-doc.pay-desk
            tt-peresmen.shift-time-beg = chk-doc.chk-time
			tt-peresmen.shift-name = chk-doc.shift-name
			.
			END.
			END.
			/* окончачание пересменки - открытие новой смены */
			ELSE IF chk-doc.chk-type = 40 AND AVAILABLE(tt-peresmen)
			                              AND tt-peresmen.kod-azs = chk-doc.obj-code
			                              AND tt-peresmen.kassa = chk-doc.pay-desk
			THEN DO: 
			nom_p = nom_p + 1.
			ASSIGN
            tt-peresmen.shift-time-end = chk-doc.chk-time
            tt-peresmen.time-p = tt-peresmen.shift-time-end - tt-peresmen.shift-time-beg 
			tt-peresmen.shift-date = chk-doc.shift-date
			tt-peresmen.peresm-date = chk-doc.chk-date
			tt-peresmen.shift-num = chk-doc.shift-num
			tt-peresmen.npp = nom_p
			tt-peresmen.name-azs =  obj-list.obj-name
			tt-peresmen.kassir = chk-doc.cashier
			tt-peresmen.kassir2 = chk-doc.cashier-psn-code
			tt-peresmen.shift-date = chk-doc.shift-date
			tt-peresmen.flg = 1
			.
			END.
	END.
END.

FOR EACH tt-peresmen where tt-peresmen.flg = 1 NO-LOCK BREAK BY tt-peresmen.kod-azs BY tt-peresmen.kassa  BY tt-peresmen.peresm-date:   
	 
    	 FIND LAST chk-doc WHERE  chk-doc.chk-type = 1   /* последний чек продажи перед закрытием смены*/
							AND	chk-doc.obj-code = tt-peresmen.kod-azs
							AND chk-doc.shift-date = tt-peresmen.shift-date
							AND chk-doc.pay-desk = tt-peresmen.kassa 
							AND chk-doc.chk-time <= tt-peresmen.shift-time-beg no-lock no-error.
							IF AVAILABLE chk-doc THEN do: 
						    tt-peresmen.shift-time-beg = chk-doc.chk-time. 
							END.
	  
		   FIND FIRST chk-doc WHERE  chk-doc.chk-type = 1 
							AND chk-doc.obj-code = tt-peresmen.kod-azs
							AND chk-doc.shift-date = tt-peresmen.shift-date
							AND chk-doc.pay-desk = tt-peresmen.kassa 
							AND chk-doc.chk-time >= tt-peresmen.shift-time-end 
							AND tt-peresmen.shift-num = chk-doc.shift-num
							no-lock no-error.
							IF AVAILABLE chk-doc THEN do: 
							tt-peresmen.shift-time-end =  chk-doc.chk-time. 
		                    END.    
	 
		            /* Старший смены */
					FIND FIRST shift-staff WHERE tt-peresmen.shift-name = shift-staff.shift-name
											 AND tt-peresmen.kod-azs = shift-staff.obj-code
											 AND shift-staff.staff-role = yes 
											 AND shift-staff.shift-date = tt-peresmen.shift-date
											 no-lock no-error.
					IF AVAILABLE shift-staff THEN manager = shift-staff.name. 
		            /* тип кассы */
					FIND FIRST cash-desk WHERE cash-desk.obj-code =  tt-peresmen.kod-azs  
					                       AND cash-desk.cash-num = tt-peresmen.kassa no-lock no-error.
		  
		  
			time-p-all = time-p-all + tt-peresmen.time-p.
			time-kas = time-kas + tt-peresmen.time-p.
			time-azs = time-azs + tt-peresmen.time-p.
        	ch-1 = ch-1 + 1.
			
			
			kol-per-azs = kol-per-azs + 1.
		  
			if (tt-peresmen.shift-time-end - tt-peresmen.shift-time-beg) > porog-zn * 60  then do: 
		       kol-prev = kol-prev + 1. 
			   kol-prev-kassa = kol-prev-kassa + 1 .
			   kol-prev-azs = kol-prev-azs + 1 .
		       time-prev = time-prev + (tt-peresmen.shift-time-end - tt-peresmen.shift-time-beg - porog-zn * 60 ).
			   time-prev-azs = time-prev-azs  + (tt-peresmen.shift-time-end - tt-peresmen.shift-time-beg - porog-zn * 60 ) .
			end.
		  
		    CREATE tt-tr.
			ASSIGN
			tt-tr.npp =  ch-1
			tt-tr.td_1 = STRING(tt-peresmen.kassa)
			tt-tr.td_2 = cash-desk.pos-type
			tt-tr.td_3 = manager
			tt-tr.td_4 = string(tt-peresmen.shift-time-beg, "HH:MM") 
			tt-tr.td_5 = string(tt-peresmen.shift-time-end, "HH:MM")
			tt-tr.td_6 = string((tt-peresmen.shift-time-end - tt-peresmen.shift-time-beg), "HH:MM")
			tt-tr.td_7 = string((tt-peresmen.shift-time-end - tt-peresmen.shift-time-beg - porog-zn * 60 ), "HH:MM")
			.
      
		    kassir1 = tt-peresmen.kassir.
		    kod-azs2 = tt-peresmen.kod-azs.
		    name-azs2 = tt-peresmen.name-azs.
		    manager = ''.
			
           IF LAST-OF( tt-peresmen.peresm-date ) THEN DO:
		      RUN itog_date.
		   END. 
		   
		   IF LAST-OF( tt-peresmen.kassa ) THEN DO:
		      RUN itog_azs.
		   END. 
		  
END.
        
/* итог по отчету */
put stream OutStr-html unformatted          
		   /* '<tr>' skip
            '<td>ИТОГО:</td><td></td><td></td><td></td><td></td><td></td>' skip
            '</td><td style="text-align:center;">' 
		   string(time-p-all, "HH:MM") '</td>' skip
         '</tr>' skip */
         '</table>'skip
        .
put stream OutStr-html unformatted '</body></html> 'skip.

PROCEDURE itog_date:
		    CREATE tt-tr.
			ASSIGN
			tt-tr.npp =  0
			tt-tr.td_1 = name-azs2
			tt-tr.td_2 = string(tt-peresmen.shift-date, "99.99.9999") 
			.
FOR EACH tt-tr NO-LOCK:
	if tt-tr.npp = 0 then do:	
	      put stream OutStr-html unformatted 
          '<tr bgcolor="#F8CBAD">' skip
                '<td style="text-align:center;">' tt-tr.td_1 '</td>' SKIP                      
                '<td style="text-align:center;">' tt-tr.td_2 '</td>' skip
                '<td style="text-align:center;">' tt-tr.td_3 '</td>' skip
				'<td style="text-align:center;">' tt-tr.td_4 '</td>' skip
				'<td style="text-align:center;">' tt-tr.td_5 '</td>' skip
				'<td style="text-align:center;">' tt-tr.td_6 '</td>' skip
				'<td style="text-align:center;">' tt-tr.td_7 '</td>' skip 
          '</tr>' skip
          . 
		  end.
		  else if tt-tr.npp <> 0 then do:	
	      put stream OutStr-html unformatted 
          '<tr >' skip
                '<td style="text-align:center;">' tt-tr.td_1 '</td>' SKIP                      
                '<td style="text-align:center;">' tt-tr.td_2 '</td>' skip
                '<td style="text-align:center;">' tt-tr.td_3 '</td>' skip
				'<td style="text-align:center;">' tt-tr.td_4 '</td>' skip
				'<td style="text-align:center;">' tt-tr.td_5 '</td>' skip
				'<td style="text-align:center;">' tt-tr.td_6 '</td>' skip
				'<td style="text-align:center;">' tt-tr.td_7 '</td>' skip 
          '</tr>' skip
          . 
		  end. 
end.
EMPTY TEMP-TABLE tt-tr.		  
END PROCEDURE.


PROCEDURE itog_azs:
time-pr-sv = time-azs / kol-per-azs.
prm-1 = kol-prev-azs / kol-per-azs * 100 .

	      put stream OutStr-html unformatted 
          '<tr>' skip
                '<td style="text-align:center;" rowspan="2">' 'Итого по ' '</td>' SKIP                      
                '<td style="text-align:center;" rowspan="2" bgcolor="#F8CBAD">' name-azs2 '</td>' skip
                '<td style="text-align:center;">' 'Средняя длительность простоя' '</td>' skip
				'<td style="text-align:center;">' 'Количество случаев с превышением порога простоя' '</td>' skip
				'<td style="text-align:center;">' 'Общая длительность превышения порога простоя' '</td>' skip
				'<td style="text-align:center;">' 'Средняя  длительность превышения порога простоя' '</td>' skip
				'<td style="text-align:center;">' 'Процент случаев простоя с превышением порогового значения от общего  кол-ва простоев' '</td>' skip
          '</tr>' skip
		  
		  '<tr >' skip
                '<td style="text-align:center;">' string(time-pr-sv, "HH:MM") '</td>' skip
				'<td style="text-align:center;">' kol-prev-azs '</td>' skip
				'<td style="text-align:center;">' string(time-prev-azs, "HH:MM") '</td>' skip  
				'<td style="text-align:center;">' string(time-pr-sv, "HH:MM") '</td>' skip
				'<td style="text-align:center;">' prm-1  '</td>' skip 
          '</tr>' skip
		    . 
			kol-prev-azs = 0.
			kol-per-azs  = 0.
			time-azs = 0.
		 
END PROCEDURE.

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
