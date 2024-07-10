
/*------------------------------------------------------------------------
    File        : r-testasidoc.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : SSlivenko
    Created     : Tue Apr 16 14:27:47 MSK 2024
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo initial "Проверка корректности работы АСИ".

{ cmp/vssrevis.i     }

define input parameter parparentproc as handle no-undo.
define input parameter p-recid       as recid  no-undo.

function get-DD-Month-YYYY returns character (input p-dat-date as date) forward .

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

&global-define month-list-for-date 'января,февраля,марта,апреля,мая,июня,июля,августа,сентября,октября,ноября,декабря':U
/* Для вызова функции конвертации даты к виду: "01 Января 2014г" */
&scop f-l MonthNameRusCase

{ gbl/std-func.i {&f-l} }

{ cmp/str-glbl.i }
{ cmp/library.i  }
{ cmp/r-pril.i   }
{ gbl/paramls.i  }
{ gbl/prn-lib.i     }
{ rep/html-conv.i }

DEFINE TEMP-TABLE tt-result
  field gds-code                as integer
  field gds-name                as character              /*col1  Марка НП  */
  field pl-code                 as integer
  field loc1                    as character              /*col2  Номер резервура  */
  /*  Фактические замеры комиссии  */
  field state-level-total       as decimal    /*col3  Уровень по метроштоку, см  */
  field izmer-density           as decimal    /*col4 Плотность по замерам, г/см3 */
  field pomi-density            as decimal    /*col5 Плотность, приведенная к стандартной температуре, г/см3  */
  field state-temperature       as decimal    /*col6 Температура, С  */
  field state-mass              as decimal    /*col7 Масса, кг  */
  /*  Данные замеров АСИ в резервуаре  */
  field level-total             as decimal    /*col8 Уровень, см  */
  field density                 as decimal    /*col9 Плотность по уровнемеру, г/см3  */
  field temperature             as decimal    /*col10 Температура, С  */
  field mass                    as decimal    /*col11 Масса, кг  */
  /*  Результат расчета проверки  */
  field diff-density            as decimal    /*col12 Расхождение значения по плотности НП (кг/м3)  */
  field diff-mass               as decimal    /*col13 Расхождение в % по массе  */
  
  field test-asi-type           as character
  field asi-type-name           as character  /*col14 Тип проверки  */
  
  index pi 
    gds-code pl-code
. 

define stream OutStr-html.

define buffer buf_rvs-doc for ub.rvs-doc .
define buffer buf_doc-attr for ub.doc-attr .
define buffer buf_rvs-line for ub.rvs-line .
define buffer buf_rvs-line-attr for ub.rvs-line-attr . 
define buffer buf_clients for ub.clients .
define buffer buf_goods         for ub.goods .
define buffer buf_place         for ub.place .

define variable v-report-id         as character no-undo .
define variable v-file-name-rep-htm as character no-undo .
define variable v-obj-name          as character no-undo .
define variable v-test-asi-type     as character no-undo .

/* ***************************  Main Block  *************************** */
do
on error undo, return error return-value
:

  find first buf_rvs-doc no-lock where recid(buf_rvs-doc) = p-recid no-error .
  if not available buf_rvs-doc
  then do :
    message "Документ не найден!" view-as alert-box error .
    return error .
  end .
  
  for first buf_doc-attr no-lock where buf_doc-attr.doc-code  = buf_rvs-doc.rvs-code
                                   and buf_doc-attr.attr-code = "test-asi-type"
  :
    v-test-asi-type = buf_doc-attr.attr-value .
  end .
  
  run fill-tt .
  
  for first buf_clients no-lock where buf_clients.obj-type = buf_rvs-doc.obj-type
                                  and buf_clients.obj-code = buf_rvs-doc.obj-code
  :
    assign v-obj-name = buf_clients.obj-name .
  end .

/*печать*/
  run get-report-num (output v-report-id).
    
  v-file-name-rep-htm = session:temp-directory + string(v-report-id) + ".html".   
                        
  output stream OutStr-html to value(v-file-name-rep-htm) convert target 'UTF-8'.
  put stream OutStr-html unformatted
    "<!DOCTYPE HTML>" skip
    ' <html>' skip
    '  <head>' skip
    '   <meta charset="utf-8">' skip
    '    <style type="text/css">' skip
                         
    '      table ' + chr(123) + ' border-collapse: collapse;' + chr(125) skip
    '      .class1 ' + chr(123) + ' border-collapse: collapse;' + chr(125) skip
    '      tbody td, th ' + chr(123) + ' border-collapse: collapse; border: 1px solid black;' + chr(125) skip
    '   </style>' skip
    '  </head>' skip
  .
                        
                        
  put stream OutStr-html unformatted
    '<body>' skip
    '<TABLE name="1" outline_below="true" fit_to_page="true" orientation="landscape" CELLSPACING="0" BORDER="0">'skip
    '<thead>' skip
  .
  
  put stream OutStr-html unformatted
    '<tr class="set_columns">' skip
    '<td style="width: 80px;"></td>' skip
    '<td style="width: 70px;"></td>' skip
    '<td style="width: 70px;"></td>' skip
    '<td style="width: 70px;"></td>' skip
    '<td style="width: 85px;"></td>' skip
    '<td style="width: 85px;"></td>' skip
    '<td style="width: 70px;"></td>' skip
    '<td style="width: 70px;"></td>' skip
    '<td style="width: 70px;"></td>' skip
    '<td style="width: 85px;"></td>' skip
    '<td style="width: 70px;"></td>' skip
    '<td style="width: 110px;"></td>' skip
    '<td style="width: 110px;"></td>' skip
    '<td style="width: 70px;"></td>' skip
    '</tr>' skip
  .
  
  run put-empty-string .
  
  put stream OutStr-html unformatted
    '<tr>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td style="text-align: center;">АЗС/АЗК</td>' skip
    '<td colspan="2" style="text-align: center; font-weight: bold;">' + v-obj-name + '</td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td style="text-align: center;">Дата:</td>' skip
    '<td colspan="2" style="text-align: center;">' + get-DD-Month-YYYY(buf_rvs-doc.sys-date) + '</td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '</tr>' skip
  .
  
  put stream OutStr-html unformatted
    '<tr>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td style="height: 14px; text-align: center; font-weight: bold;">Акт №</td>' skip
    '<td colspan="2" style="height: 14px; text-align: center; font-weight: bold;">' + buf_rvs-doc.rvs-code + '</td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '</tr>' skip
  .
  
  put stream OutStr-html unformatted
    '<tr>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td colspan="10" style="text-align: center; font-weight: bold;">проверки корректности работы АСИ в резервуаре</td>' skip
    '<td></td>' skip
    '</tr>' skip
  .
  
  run put-empty-string .
  
  put stream OutStr-html unformatted
    '<tr>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td colspan="2" style="text-align: left;">Комиссия в составе:</td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '</tr>' skip
  .
  
  put stream OutStr-html unformatted
    '<tr>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td colspan="2" style="text-align: left;">Председатель:</td>' skip
    '<td colspan="4" style="text-align: center; font-weight: bold;">Управляющий АЗК/АЗС</td>' skip
    '<td colspan="2" style="border-bottom: 1px solid black;"></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '</tr>' skip
  .
  
  put stream OutStr-html unformatted
    '<tr>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td colspan="2" style="text-align: left;">Члены комиссии:</td>' skip
    '<td colspan="4" style="text-align: center; font-weight: bold;">Ст. смены (оператор-кассир)</td>' skip
    '<td colspan="2" style="border-bottom: 1px solid black;"></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '</tr>' skip
  .
  
  put stream OutStr-html unformatted
    '<tr>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td colspan="4" style="text-align: center; font-weight: bold;">Ст. смены (оператор-кассир)</td>' skip
    '<td colspan="2" style="border-bottom: 1px solid black;"></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '</tr>' skip
  .
  
  run put-empty-string .
  
  put stream OutStr-html unformatted
    '<tr>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td colspan="5" style="text-align: left;">составили настоящий акт о нижеследующем:</td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '</tr>' skip
    
    '</thead>' skip
  .
  
  put stream OutStr-html unformatted
    '<tbody>' skip
    '<TR>' skip
    '<TH text_wrap="true" rowspan="5" style="text-align: center; font-size: 11px; font-weight: bold;">Марка НП</TH>' skip
    '<TH text_wrap="true" rowspan="5" style="text-align: center; font-size: 11px; font-weight: bold;">№ резервура</TH>' skip
    '<TH text_wrap="true" colspan="5" style="text-align: center; font-size: 11px; font-weight: bold;">Фактические замеры комиссии</TH>' skip
    '<TH text_wrap="true" colspan="4" style="text-align: center; font-size: 11px; font-weight: bold;">Данные замеров АСИ в резервуаре</TH>' skip
    '<TH text_wrap="true" colspan="2" style="text-align: center; font-size: 11px; font-weight: bold;">Результат расчета проверки</TH>' skip
    '<TH text_wrap="true" rowspan="5" style="text-align: center; font-size: 11px; font-weight: bold;">Тип проверки</TH>' skip
    '</TR>'skip 
    
    '<TR>' skip
    '<TH text_wrap="true" rowspan="4" style="text-align: center; font-size: 9px; font-weight: bold;">Уровень по метроштоку, см</TH>' skip
    '<TH text_wrap="true" rowspan="4" style="text-align: center; font-size: 9px; font-weight: bold;">Плотность по замерам, г/см3</TH>' skip
    '<TH text_wrap="true" rowspan="4" style="text-align: center; font-size: 9px; font-weight: bold;">Плотность, приведенная к стандартной температуре, г/см3</TH>' skip
    '<TH text_wrap="true" rowspan="4" style="text-align: center; font-size: 9px; font-weight: bold;">Температура, С</TH>' skip
    '<TH text_wrap="true" rowspan="4" style="text-align: center; font-size: 9px; font-weight: bold;">Масса, кг</TH>' skip
    '<TH text_wrap="true" rowspan="4" style="text-align: center; font-size: 9px; font-weight: bold;">Уровень, см</TH>' skip
    '<TH text_wrap="true" rowspan="4" style="text-align: center; font-size: 9px; font-weight: bold;">Плотность по уровнемеру, г/см3</TH>' skip
    '<TH text_wrap="true" rowspan="4" style="text-align: center; font-size: 9px; font-weight: bold;">Температура, С</TH>' skip
    '<TH text_wrap="true" rowspan="4" style="text-align: center; font-size: 9px; font-weight: bold;">Масса, кг</TH>' skip
    '<TH text_wrap="true" rowspan="4" style="text-align: center; font-size: 9px; font-weight: bold;">Расхождение значения по плотности НП (кг/м3)</TH>' skip
    '<TH text_wrap="true" rowspan="4" style="text-align: center; font-size: 9px; font-weight: bold;">Расхождение в % по массе</TH>' skip
    '</TR>'skip  
    
    '<TR >'skip
    '</TR>'skip
    
    '<TR >'skip
    '</TR>'skip
    
    '<TR >'skip
    '</TR>'skip
    
    '<TR >'skip
    '<TH style="text-align: center; font-size: 9px; font-weight:bold; ">1</TH>'   skip
    '<TH style="text-align: center; font-size: 9px; font-weight:bold; ">2</TH>'   skip
    '<TH style="text-align: center; font-size: 9px; font-weight:bold; ">3</TH>'   skip
    '<TH style="text-align: center; font-size: 9px; font-weight:bold; ">4</TH>'   skip
    '<TH style="text-align: center; font-size: 9px; font-weight:bold; ">5</TH>'   skip
    '<TH style="text-align: center; font-size: 9px; font-weight:bold; ">6</TH>'   skip
    '<TH style="text-align: center; font-size: 9px; font-weight:bold; ">7</TH>'   skip
    '<TH style="text-align: center; font-size: 9px; font-weight:bold; ">8</TH>'   skip
    '<TH style="text-align: center; font-size: 9px; font-weight:bold; ">9</TH>'   skip
    '<TH style="text-align: center; font-size: 9px; font-weight:bold; ">10</TH>'  skip
    '<TH style="text-align: center; font-size: 9px; font-weight:bold; ">11</TH>'  skip
    '<TH style="text-align: center; font-size: 9px; font-weight:bold; ">12</TH>'  skip
    '<TH style="text-align: center; font-size: 9px; font-weight:bold; ">13</TH>'  skip
    '<TH style="text-align: center; font-size: 9px; font-weight:bold; ">14</TH>'  skip
    '</TR>'skip    
  .
  
  for each tt-result by tt-result.loc1 :
    put stream OutStr-html unformatted
      '<TR>' skip
      '<TH style="text-align: center; font-weight: normal;">' + tt-result.gds-name + '</TH>' skip
      '<TH style="text-align: center; font-weight: normal;">' + tt-result.loc1 + '</TH>' skip
      '<TH num="#,##0.0" val="'  + fDec2Str(tt-result.state-level-total, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight: normal;">' + fDec2Str(tt-result.state-level-total, "->>>>>>>>>>>9.9"  ) + '</TH>'  skip
      '<TH num="#0.0000" val="'  + fDec2Str(tt-result.izmer-density, "-9.9999") + '" style="text-align: center; font-weight: normal;">' + fDec2Str(tt-result.izmer-density, "-9.9999"  ) + '</TH>'  skip
      '<TH num="#0.0000" val="'  + fDec2Str(tt-result.pomi-density, "-9.9999") + '" style="text-align: center; font-weight: normal;">' + fDec2Str(tt-result.pomi-density, "-9.9999"  ) + '</TH>'  skip
      '<TH num="#,##0.0" val="'  + fDec2Str(tt-result.state-temperature, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight: normal;">' + fDec2Str(tt-result.state-temperature, "->>>>>>>>>>>9.9"  ) + '</TH>'  skip
      '<TH num="#,##0" val="'    + fDec2Str(tt-result.state-mass, "->>>>>>>>>>>9") + '" style="text-align: center; font-weight: normal;">' + fDec2Str(tt-result.state-mass, "->>>>>>>>>>>9"  ) + '</TH>'  skip
      '<TH num="#,##0.0" val="'  + fDec2Str(tt-result.level-total, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight: normal;">' + fDec2Str(tt-result.level-total, "->>>>>>>>>>>9.9"  ) + '</TH>'  skip
      '<TH num="#0.0000" val="'  + fDec2Str(tt-result.density, "-9.9999") + '" style="text-align: center; font-weight: normal;">' + fDec2Str(tt-result.density, "-9.9999"  ) + '</TH>'  skip
      '<TH num="#,##0.0" val="'  + fDec2Str(tt-result.temperature, "->>>>>>>>>>>9.9") + '" style="text-align: center; font-weight: normal;">' + fDec2Str(tt-result.temperature, "->>>>>>>>>>>9.9"  ) + '</TH>'  skip
      '<TH num="#,##0" val="'    + fDec2Str(tt-result.mass, "->>>>>>>>>>>9") + '" style="text-align: center; font-weight: normal;">' + fDec2Str(tt-result.mass, "->>>>>>>>>>>9"  ) + '</TH>'  skip
      '<TH num="#,##0.00" val="' + fDec2Str(tt-result.diff-density, "->>>9.99") + '" style="text-align: center; font-weight: normal;">' + fDec2Str(tt-result.diff-density, "->>>9.99"  ) + '</TH>'  skip
      '<TH num="#,##0.00" val="' + fDec2Str(tt-result.diff-mass, "->>>9.99") + '" style="text-align: center; font-weight: normal;">' + fDec2Str(tt-result.diff-mass, "->>>9.99"  ) + '</TH>'  skip
      '<TH text_wrap="true" style="text-align: center; font-weight: normal;">' + tt-result.asi-type-name + '</TH>' skip
      '</TR>'skip
    .
  end.
  
  put stream OutStr-html unformatted    
    '</tbody>' skip
    '<tfoot>' skip
  .
  
  run put-empty-string .
  
  put stream OutStr-html unformatted
    '<tr>' skip
    '<td colspan="2" style="text-align: right;">Уровнемер:</td>' skip
    '<td colspan="2" style="border-bottom: 1px solid black;"></td>' skip
    '<td style="border-bottom: 1px solid black;"></td>' skip
    '<td style="border-bottom: 1px solid black;"></td>' skip
    '<td colspan="3" style="border-bottom: 1px solid black;"></td>' skip
    '<td colspan="4" style="text-align: left; border-bottom: 1px solid black;">канал измерения плотности НП:' + fill("&nbsp;" , 6) + 'да' + fill("&nbsp;" , 3) + '/' + fill("&nbsp;" , 3) + 'нет</td>' skip
    '<td></td>' skip
    '</tr>' skip
  .
  
  put stream OutStr-html unformatted
    '<tr>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td colspan="2" style="text-align: center; font-size: 9px; vertical-align: top;">наименование</td>' skip
    '<td></td>' skip
    '<td style="text-align: center; font-size: 9px; vertical-align: top;">тип</td>' skip
    '<td colspan="3" style="text-align: center; font-size: 9px; vertical-align: top;">заводской номер</td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '</tr>' skip
  .
  
  run put-empty-string .
  
  put stream OutStr-html unformatted
    '<tr>' skip
    '<td></td>' skip
    '<td colspan="4" style="text-align: left;">Значения получены:</td>' skip
    '<td colspan="2" style="border-bottom: 1px solid black;"></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '</tr>' skip
  .
  
  run put-empty-string .
  
  put stream OutStr-html unformatted
    '<tr>' skip
    '<td></td>' skip
    '<td colspan="4" style="text-align: left;">Замеры проводились:</td>' skip
    '<td colspan="6" style="border-bottom: 1px solid black;"></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '</tr>' skip
  .
  
  run put-empty-string .
  
  put stream OutStr-html unformatted
    '<tr>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td colspan="3" style="text-align: right;">Председатель комиссии:</td>' skip
    '<td colspan="3" style="text-align: center; font-weight: bold;">Управляющий АЗК/АЗС</td>' skip
    '<td colspan="3" style="border-bottom: 1px solid black;"></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '</tr>' skip
  .
  
  run put-empty-string .
  
  put stream OutStr-html unformatted
    '<tr>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td colspan="3" style="text-align: right;">Члены комиссии:</td>' skip
    '<td colspan="3" style="text-align: center; font-weight: bold;">Ст. смены (оператор-кассир)</td>' skip
    '<td colspan="3" style="border-bottom: 1px solid black;"></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '</tr>' skip
  .
  
  run put-empty-string .
  
  put stream OutStr-html unformatted
    '<tr>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '<td colspan="3" style="text-align: center; font-weight: bold;">Ст. смены (оператор-кассир)</td>' skip
    '<td colspan="3" style="border-bottom: 1px solid black;"></td>' skip
    '<td></td>' skip
    '<td></td>' skip
    '</tr>' skip
  .
  
  put stream OutStr-html unformatted
    '</tfoot>' skip
    '</table>' skip
    '</body>' skip
    '</html>' skip
  .
                            
  output stream OutStr-html close.     

  run prn-lib-reportviewer in this-procedure (
    input this-procedure
    ,input v-file-name-rep-htm
    ,input "" 
    ) no-error.
  if error-status:error then
  do:
    message return-value view-as alert-box.
    return .
  end.

end .

function get-DD-Month-YYYY returns character (input p-dat-date as date):
    
  /* Получение даты в формате "01 Января 2014г." */
  define variable v-str-date  as character no-undo.
  define variable v-str-day   as character no-undo.
  define variable v-num-month as character no-undo.
  define variable v-str-month as character no-undo.
  define variable v-str-year  as character no-undo.

  v-str-date = string(p-dat-date).

  do: /* Получаем день в формате цифры, вида NN. */
    v-str-day = string(entry(1, v-str-date, "/")).
  end. /* Получаем день в формате цифры, вида NN. */

  do: /* Получаем прописью месяц */
    v-num-month = entry(2, v-str-date, "/").
    v-str-month = MonthNameRusCase(integer(v-num-month), 2).

  end. /* Получаем прописью месяц */

  do: /* Получаем год в формате цифры, вида "NNNN" */
    /*        v-str-year = entry(3, v-str-date, "/").*/
    v-str-year = string(year(p-dat-date)).
  end. /* Получаем год в формате цифры, вида "NNNN" */

  /* Получаем цифро-буквенную дату в одной строке */
  v-str-date = '" ' + v-str-day + ' "' + " " + v-str-month + " " + v-str-year + " г.".
  
  return v-str-date .

end function.

procedure fill-tt :
  define variable v-izmer-density     as decimal no-undo .
  define variable v-pomi-density      as decimal no-undo .
  define variable v-diff              as decimal no-undo .
  define variable v-temp-izm-vol      as decimal no-undo .

  for each buf_rvs-line no-lock where buf_rvs-line.obj-type = buf_rvs-doc.obj-type
                                  and buf_rvs-line.obj-code = buf_rvs-doc.obj-code
                                  and buf_rvs-line.rvs-code = buf_rvs-doc.rvs-code,
    first buf_goods no-lock where buf_goods.gds-code = buf_rvs-line.gds-code,
    first buf_place no-lock where buf_place.obj-type = buf_rvs-line.obj-type
                              and buf_place.obj-code = buf_rvs-line.obj-code
                              and buf_place.pl-code  = buf_rvs-line.pl-code
  :
    for first buf_rvs-line-attr no-lock where buf_rvs-line-attr.obj-code  = buf_rvs-line.obj-code
                                          and buf_rvs-line-attr.obj-type  = buf_rvs-line.obj-type
                                          and buf_rvs-line-attr.gds-code  = buf_rvs-line.gds-code
                                          and buf_rvs-line-attr.pl-code   = buf_rvs-line.pl-code
                                          and buf_rvs-line-attr.rvs-code  = buf_rvs-line.rvs-code
                                          and buf_rvs-line-attr.attr-code = "izmer-density"
    :
      assign v-izmer-density = decimal(buf_rvs-line-attr.attr-value) .
    end .
    for first buf_rvs-line-attr no-lock where buf_rvs-line-attr.obj-code  = buf_rvs-line.obj-code
                                          and buf_rvs-line-attr.obj-type  = buf_rvs-line.obj-type
                                          and buf_rvs-line-attr.gds-code  = buf_rvs-line.gds-code
                                          and buf_rvs-line-attr.pl-code   = buf_rvs-line.pl-code
                                          and buf_rvs-line-attr.rvs-code  = buf_rvs-line.rvs-code
                                          and buf_rvs-line-attr.attr-code = "pomi-density"
    :
      assign v-pomi-density = decimal(buf_rvs-line-attr.attr-value) .
    end .
    for first buf_rvs-line-attr no-lock where buf_rvs-line-attr.obj-code  = buf_rvs-line.obj-code
                                          and buf_rvs-line-attr.obj-type  = buf_rvs-line.obj-type
                                          and buf_rvs-line-attr.gds-code  = buf_rvs-line.gds-code
                                          and buf_rvs-line-attr.pl-code   = buf_rvs-line.pl-code
                                          and buf_rvs-line-attr.rvs-code  = buf_rvs-line.rvs-code
                                          and buf_rvs-line-attr.attr-code = "test-asi-diff"
    :
      assign v-diff = decimal(buf_rvs-line-attr.attr-value) .
    end .
    for first buf_rvs-line-attr no-lock where buf_rvs-line-attr.obj-code  = buf_rvs-line.obj-code
                                          and buf_rvs-line-attr.obj-type  = buf_rvs-line.obj-type
                                          and buf_rvs-line-attr.gds-code  = buf_rvs-line.gds-code
                                          and buf_rvs-line-attr.pl-code   = buf_rvs-line.pl-code
                                          and buf_rvs-line-attr.rvs-code  = buf_rvs-line.rvs-code
                                          and buf_rvs-line-attr.attr-code = "temp-izm-vol"
    :
      assign v-temp-izm-vol = decimal(buf_rvs-line-attr.attr-value) .
    end .
    
    create tt-result .
    assign
      tt-result.gds-code          = buf_goods.gds-code
      tt-result.gds-name          = buf_goods.gds-name
      tt-result.pl-code           = buf_place.pl-code
      tt-result.loc1              = buf_place.loc1
      tt-result.test-asi-type     = v-test-asi-type
    .
    case v-test-asi-type :
      when "test-asi_dens-place"
      then do :
        assign
          tt-result.state-level-total = ?
          tt-result.izmer-density     = v-izmer-density
          tt-result.pomi-density      = ?
          tt-result.state-temperature = ?
          tt-result.state-mass        = ?
          
          tt-result.level-total       = ?
          tt-result.density           = buf_rvs-line.density
          tt-result.temperature       = ?
          tt-result.mass              = ?
          
          tt-result.diff-density      = v-diff
          tt-result.diff-mass         = ?
                           
          tt-result.asi-type-name     = "Резервуар"
        .
      end .
      when "test-asi_dens-pump"
      then do :
        assign
          tt-result.state-level-total = ?
          tt-result.izmer-density     = v-izmer-density
          tt-result.pomi-density      = v-pomi-density
          tt-result.state-temperature = v-temp-izm-vol
          tt-result.state-mass        = ?
          
          tt-result.level-total       = ?
          tt-result.density           = buf_rvs-line.density
          tt-result.temperature       = buf_rvs-line.temperature
          tt-result.mass              = ?
          
          tt-result.diff-density      = v-diff
          tt-result.diff-mass         = ?
          
          tt-result.asi-type-name     = "ТРК"
        .
      end .
      when "test-asi_mass"
      then do :
        assign
          tt-result.state-level-total = buf_rvs-line.state-level-total
          tt-result.izmer-density     = v-izmer-density
          tt-result.pomi-density      = v-pomi-density
          tt-result.state-temperature = v-temp-izm-vol
          tt-result.state-mass        = buf_rvs-line.state-measure-cli-qnty
          
          tt-result.level-total       = buf_rvs-line.level-total
          tt-result.density           = buf_rvs-line.density
          tt-result.temperature       = buf_rvs-line.temperature
          tt-result.mass              = buf_rvs-line.measure-cli-qnty
          
          tt-result.diff-density      = ?
          tt-result.diff-mass         = v-diff
                           
          tt-result.asi-type-name     = "Масса"
        .
      end .
    end case .
    
  end . /* for each buf_rvs-line */
end procedure .

procedure put-empty-string :
  
  put stream OutStr-html unformatted
    '<tr>' skip
    '<td>&nbsp;</td>' skip
    '<td>&nbsp;</td>' skip
    '<td>&nbsp;</td>' skip
    '<td>&nbsp;</td>' skip
    '<td>&nbsp;</td>' skip
    '<td>&nbsp;</td>' skip
    '<td>&nbsp;</td>' skip
    '<td>&nbsp;</td>' skip
    '<td>&nbsp;</td>' skip
    '<td>&nbsp;</td>' skip
    '<td>&nbsp;</td>' skip
    '<td>&nbsp;</td>' skip
    '<td>&nbsp;</td>' skip
    '<td>&nbsp;</td>' skip
    '</tr>' skip
  .
  
end procedure .

procedure get-report-num :

  define output parameter p-report-num as integer no-undo .

  do
    on error undo, return error return-value
    :
    run gbl/getrpnum.p (output p-report-num).
  end.

end procedure .

