/*
$Revision$
$Author$
$Date$
$Workfile$
$Archive$
Количество работающих ККМ на АЗК/АЗС за период
Автор: 
Дата создания: 20/12/2014
Creation date: 20/12/2014
*/
define input parameter parparentproc      as widget-handle no-undo .
define input parameter parobj-type        like ub.trn-doc.obj-type no-undo. /*объект*/
define input parameter parobj-code        like ub.trn-doc.obj-code no-undo.
define input parameter type-pos     as character    no-undo .

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Количество работающих ККМ на АЗК/АЗС за период".

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


define variable porog-zn as int no-undo. 

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
        <!DOCTYPE HTML><html>
              
              <head>
              <meta charset="UTF-8" />
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
                    <table orientation="landscape" name = "Количество работающих ККМ" fit_to_page="true">  <!-- таблица, в которой содержится весь отчет -->
                      <thead>  <!-- Шапка отчета -->
                      <!-- Обязательно создаётся строка таблицы, в которой находятся размеры колонок в px-->
                      <tr class="set_columns">
                      
                          <td style="width:260px"></td>
                          <td style="width:180px"></td>
                          <td style="width:220px"></td>
                          <td style="width:85px"></td>
                          <td style="width:85px"></td>
                          <td style="width:250px"></td>
                      </tr>
                      
                      <tr>
                        <td colspan="6"></td>
                      </tr>
                      
                      <tr style="height:30px;">  
                        <td colspan="6">Количество работающих ККМ на АЗК/АЗС за период </td>
                      </tr>    
                      
                      <tr>  
                        <td colspan="1" style="border-bottom: 1px solid black; font-size:16px;font-weight:bold;" >Фирма:</td>
                        <td colspan="5" style="border-bottom: 1px solid black; font-size:16px;font-weight:bold;" >&1</td>
                      </tr>
                      
                      <tr>
                        <td colspan="6" style="font-size:16px;font-weight:bold;">  </td>
                      </tr>
                      
                      <tr>
                        <td colspan="1" > период:</td>
                        <td colspan="5" > с &3 по &4</td>
                      </tr>
                      
                      <tr>
                        <td colspan="1" > Фильтры</td>
                        <td colspan="5" > </td>
                      </tr>
                      
                      <tr>  
                        <td colspan="1" > Типы касс </td>
                        <td colspan="5" > &5 </td>
                      </tr>          
                      
                    </thead>
              <tbody> <!-- Здесь начинается таблица отчета -->
              
           				<tr bgcolor="#C6E0B4">
							<!-- Первые строки – шапка таблицы с тэгами tr -->
							<td rowspan="1" style="text-align: center;"> АЗК </td>
							<td rowspan="1" colspan="3" style="text-align: center;"> Длительность </td>
							<td rowspan="1" style="text-align: center;"> Количество касс </td>
                            <td rowspan="1" style="text-align: center;"> Максимальное количество работающих касс за период отчета </td>
						</tr>
                        
						<tr bgcolor="#C6E0B4">
							<td style="text-align: center;"> </td>
							<td style="text-align: center;"> с </td>
							<td style="text-align: center;"> по </td>
							<td style="text-align: center;"> всего </td>
							<td style="text-align: center;"> </td>
							<td style="text-align: center;"> </td>
						
						</tr>'
                ,
                string(v-host-name),
                string(v-obj-name),
                /* string(x-Date-Start, "99.99.9999") + ' ' + string(v-first-time,"HH:MM") ,
                string(X-date-End, "99.99.9999") + ' ' + string(v-last-time,"HH:MM") */
				string(x-Date-Start, "99.99.9999") ,
                string(X-date-End, "99.99.9999"),
                type-pos
        ).
	
DEFINE TEMP-TABLE tt-chk NO-UNDO
	FIELD ob-type           LIKE  chk-doc.obj-type        /* тип объекта */
	FIELD ob-code           LIKE  chk-doc.obj-code        /* код объекта */
	FIELD kassa             LIKE  chk-doc.pay-desk        /* касса */
    FIELD smena             LIKE  chk-doc.src-shift-name  /* смена */
    FIELD chk-date          LIKE  chk-doc.chk-date        /* дата */
    FIELD chk-time          LIKE  chk-doc.chk-time        
    FIELD chk-type          LIKE  chk-doc.chk-type
    INDEX pi AS UNIQUE PRIMARY  ob-code kassa chk-date chk-time
 .         
 
 DEFINE TEMP-TABLE tt-period NO-UNDO
	FIELD ob-type           LIKE  chk-doc.obj-type        /* тип объекта */
	FIELD ob-code           LIKE  chk-doc.obj-code        /* код объекта */
	FIELD kassa             LIKE  chk-doc.pay-desk        /* касса */
    FIELD smena             LIKE  chk-doc.src-shift-name  /* смена */
    FIELD date-beg          LIKE  chk-doc.chk-date        /* дата */
    FIELD date-end          LIKE  chk-doc.chk-date        /* дата */    
    FIELD time-beg          LIKE  chk-doc.chk-time        
    FIELD time-end          LIKE  chk-doc.chk-time        
    FIELD FLG               AS INT   
    INDEX pi AS UNIQUE PRIMARY  ob-code kassa date-beg time-beg date-end time-end
 .         
 
DEFINE TEMP-TABLE tt-tr NO-UNDO 
    FIELD npp               AS INT        /* номер строки */ 
	FIELD td_1              as character  /* значения внутри тега TD */              
	FIELD td_2              as character                
	FIELD td_3              as character                
	FIELD td_4              as character                
	FIELD td_5              as character                
	FIELD td_6              as character                
	INDEX pi AS UNIQUE PRIMARY npp 
 .         

 FOR EACH obj-list  NO-LOCK:                       		
	FOR EACH chk-doc WHERE chk-doc.obj-code = obj-list.obj-code
	                    AND chk-doc.chk-date <= x-Date-End
                        AND chk-doc.chk-date >= x-Date-Start 
                        AND	(chk-doc.chk-type = 13 OR chk-doc.chk-type = 40)
                        NO-LOCK :
            /* тип кассы */
		    FIND FIRST cash-desk WHERE cash-desk.obj-code = chk-doc.obj-code AND cash-desk.cash-num = chk-doc.pay-desk no-lock no-error.            
            IF   cash-desk.pos-type  =  type-pos OR  type-pos = 'Все' THEN DO:       
            CREATE tt-chk.
			ASSIGN
			tt-chk.ob-code = chk-doc.obj-code
			tt-chk.kassa = chk-doc.pay-desk
            tt-chk.chk-date = chk-doc.chk-date
            tt-chk.chk-time = chk-doc.chk-time        
            tt-chk.smena = chk-doc.src-shift-name
            tt-chk.chk-type = chk-doc.chk-type
            .           
            END.
	END.
END.
		
     FOR EACH tt-chk NO-LOCK :
	 		/* начало периода работы кассы */
			IF tt-chk.chk-type = 40 THEN DO: 
			CREATE tt-period.
			ASSIGN
			tt-period.ob-code = tt-chk.ob-code
			tt-period.kassa = tt-chk.kassa
            tt-period.date-beg = tt-chk.chk-date
            tt-period.time-beg = tt-chk.chk-time        
            tt-period.smena = tt-chk.smena
			.
            END.
            /* конец периода работы кассы */
			ELSE IF tt-chk.chk-type = 13 AND AVAILABLE(tt-period)
                AND tt-period.ob-code = tt-chk.ob-code
                AND tt-period.kassa = tt-chk.kassa
                AND tt-period.smena = tt-chk.smena
                AND ((tt-period.date-beg = tt-chk.chk-date AND tt-period.time-beg < tt-chk.chk-time) 
                 OR ( tt-period.date-beg < tt-chk.chk-date AND tt-period.time-beg > tt-chk.chk-time))
			THEN DO: 
			ASSIGN
            tt-period.date-end = tt-chk.chk-date
            tt-period.time-end = tt-chk.chk-time
            FLG = 1
            .
			END. 
     END.

DEFINE VARIABLE kol-kass AS INTEGER NO-UNDO.
DEFINE VARIABLE kass AS INTEGER NO-UNDO.
DEFINE VARIABLE kol-kass2 AS INTEGER NO-UNDO.
DEFINE VARIABLE beg-p-date AS DATE NO-UNDO.
DEFINE VARIABLE end-p-date AS DATE NO-UNDO.
DEFINE VARIABLE beg-p-time AS INTEGER NO-UNDO.
DEFINE VARIABLE end-p-time AS INTEGER NO-UNDO.
DEFINE VARIABLE dl-time AS INTEGER NO-UNDO.

DEFINE VARIABLE ch-l AS INTEGER NO-UNDO INITIAL 0.
DEFINE VARIABLE ch-2 AS INTEGER NO-UNDO INITIAL 0 .
DEFINE VARIABLE nach-txt AS CHARACTER NO-UNDO .
DEFINE VARIABLE nach-txt2 AS CHARACTER NO-UNDO .



DEFINE BUFFER buf_tt-chk FOR tt-chk.

FOR EACH obj-list  NO-LOCK:                       		

   /* put stream OutStr-html unformatted 
             '<tr>' skip
                '<td bgcolor="#F8CBAD">'obj-list.obj-name '</td>' SKIP                      
                '<td>' '</td>' skip
                '<td>' '</td>' skip
				'<td>' '</td>' skip
                '<td>' '</td>' skip
				'<td>' '</td>' skip
            '</tr>' SKIP. */
FOR EACH tt-chk NO-LOCK:

    FIND FIRST buf_tt-chk WHERE buf_tt-chk.chk-date = tt-chk.chk-date AND buf_tt-chk.chk-time > tt-chk.chk-time NO-ERROR.
        IF AVAILABLE  buf_tt-chk THEN DO:
         end-p-date = buf_tt-chk.chk-date.
         end-p-time = buf_tt-chk.chk-time.
        END.

       kol-kass = 0.       
       FOR EACH tt-period WHERE tt-chk.chk-date >= tt-period.date-beg
                            AND tt-chk.chk-time >= tt-period.time-beg
                            AND tt-chk.chk-date <= tt-period.date-end 
                            AND tt-chk.chk-time <= tt-period.time-end
                            NO-LOCK:
                            
                kol-kass = kol-kass + 1 .
                IF kol-kass2 <= kol-kass THEN  kol-kass2 = kol-kass.
                
                
                beg-p-date = tt-period.date-beg.
                beg-p-time = tt-period.time-beg.    
       END.
       
       dl-time = DATETIME(end-p-date, end-p-time) - DATETIME(tt-chk.chk-date, tt-chk.chk-time) .

       /* put stream OutStr-html unformatted 
             '<tr>' skip
                '<td></td>' SKIP                      
                '<td style="text-align:center;">' tt-chk.chk-date ' ' string(tt-chk.chk-time, "HH:MM") '</td>' skip
                '<td style="text-align:center;">' end-p-date ' ' string(end-p-time, "HH:MM") '</td>' skip
				'<td style="text-align:center;">' string(dl-time, "HH:MM") '</td>' skip
                '<td style="text-align:center;">' kol-kass  '</td>' skip
				'<td>'  '</td>' skip
            '</tr>' SKIP. */
            
            
            ch-l = ch-l + 1.
           
            
            
            /* IF ch-2 = kol-kass THEN nach-txt2 = nach-txt.
            
            ELSE IF ch-2 <> kol-kass THEN DO: 
            nach-txt2 = STRING(tt-chk.chk-date, "99.99.9999") + ' ' + string(tt-chk.chk-time, "HH:MM").
            ch-l = ch-l + 1.
            END. */
            
            CREATE tt-tr.
            ASSIGN
			tt-tr.npp = ch-l
			tt-tr.td_2 = STRING(tt-chk.chk-date, "99.99.9999") + ' ' + string(tt-chk.chk-time, "HH:MM")
            tt-tr.td_3 = STRING(end-p-date, "99.99.9999") + ' ' + STRING(end-p-time, "HH:MM")
            tt-tr.td_4 = STRING(dl-time, "HH:MM")
            tt-tr.td_5 = STRING(kol-kass)
			.            
            
            ch-2 = kol-kass.
            nach-txt = STRING(tt-chk.chk-date, "99.99.9999") + ' ' + string(tt-chk.chk-time, "HH:MM").
            
            
            
            
            
END.
/* put stream OutStr-html unformatted          
		 '<tr>' skip
            '<td>ИТОГО:</td>' skip
            '<td></td>' skip
            '<td></td>' skip
            '<td></td>' skip
            '<td></td>' skip
            '<td  style="text-align:center;">' kol-kass2 '</td>' skip
         '</tr>' skip
         . */
         
            CREATE tt-tr.
            ASSIGN
			tt-tr.npp = 0
            tt-tr.td_1 = obj-list.obj-name
            tt-tr.td_6 = STRING(kol-kass2)
			.            
            
            RUN itog_azs.

END.

/* итог по отчету */
/* put stream OutStr-html unformatted          
		 '<tr>' skip
            '<td>ИТОГО:</td>' skip
            '<td></td>' skip
            '<td></td>' skip
            '<td></td>' skip
            '<td></td>' skip
            '<td  style="text-align:center;">' kol-kass2 '</td>' skip
         '</tr>' skip
         '</table>'skip
        . */
        
        
put stream OutStr-html unformatted '</tbody> 'skip
'</table>'skip
' </body>'skip
' </html> 'skip.
 
PROCEDURE itog_azs:

FOR EACH tt-tr NO-LOCK:
	if tt-tr.npp = 0 then do:	
	      put stream OutStr-html unformatted 
            '<tr>' skip
                '<td bgcolor="#F8CBAD" style="text-align:center;">' tt-tr.td_1 '</td>' skip
                '<td style="text-align:center;">' tt-tr.td_2 '</td>' skip
                '<td style="text-align:center;">' tt-tr.td_3 '</td>' skip
				'<td style="text-align:center;">' tt-tr.td_4 '</td>' skip
                '<td style="text-align:center;">' tt-tr.td_5 '</td>' skip
                '<td style="text-align:center;">' tt-tr.td_6 '</td>' skip
            '</tr>' skip
          . 
		  end.
		  else if tt-tr.npp <> 0 then do:	
	      put stream OutStr-html unformatted
          '<tr >' skip
                '<td style="text-align:center;">' tt-tr.td_1 '</td>' skip
                '<td style="text-align:center;">' tt-tr.td_2 '</td>' skip
                '<td style="text-align:center;">' tt-tr.td_3 '</td>' skip
				'<td style="text-align:center;">' tt-tr.td_4 '</td>' skip
                '<td style="text-align:center;">' tt-tr.td_5 '</td>' skip
                '<td style="text-align:center;">' tt-tr.td_6 '</td>' skip          
          '</tr>' skip
          . 
		  end. 
end.
EMPTY TEMP-TABLE tt-tr.
		  
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
    
    
