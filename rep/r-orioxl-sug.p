/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Инвентаризационная описись СУГ

Автор: Уханов Дмитрий Юрьевич
Дата создания: 10/06/06
Author: Dmitry Ukhanov
Creation date: 10/06/06

create: Булгаков Андрей Николаевич
Дата создания: 05/23/06

*/

define input parameter p-parent-proc as widget-handle no-undo .
define input parameter p-rec-invent  as recid         no-undo .


define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo initial "Инвентаризационная описись СУГ":U .

{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ str/lib-calc.i }
{ str/lib-trn.i  }
{ cmp/r-pril.i   }
{ gbl/waitfram.i }
{ ref/gds-attr.i }
{ gbl/prn-lib.i     }
{ rep/html-conv.i }
{ str/is-sug.i }
{ str/placelib.i }

define variable g#report-num  as integer no-undo .
define variable g#quest-print as logical no-undo initial yes .
define variable g#log         as logical no-undo .

{ gbl/paramls.i  }

define variable v-host-name   as character no-undo .
define variable p-host-code   as integer   no-undo .
define variable v-doc-num     as character no-undo .
define variable dprice-sale   as decimal   no-undo .
define variable droad-tax     as decimal   no-undo .
define variable dexcise       as decimal   no-undo .
define variable dcurr-price   as decimal   no-undo .
define variable dWaterQnty    as decimal   no-undo .
define variable dWaterCliQnty as decimal   no-undo .
define variable dAddCliQnty   as decimal   no-undo .
define variable dOverCliQnty  as decimal   no-undo .
define variable dOverSum      as decimal   no-undo .
define variable dBookSum      as decimal   no-undo .
define variable dExtraQnty    as decimal   no-undo .
define variable dExtraSum     as decimal   no-undo .
define variable dMissQnty     as decimal   no-undo .
define variable dMissSum      as decimal   no-undo .
define variable t_inv-date    as date      no-undo .
define variable j_LineCount   as integer   no-undo .
define variable v-pl-code     as character no-undo .
define stream Out-Stream.
define stream OutStr-html.
define VARIABLE p-report-id         as character no-undo .
define variable v-file-name-rep-htm as character no-undo .

define temp-table tt-sug
  field gds-code as integer
  field gds-name as character
  field pl-code  as integer
  field pl-code_ as character
  field pl-type  as character
  field level    as decimal
  field volue    as decimal
  field density  as decimal
  field temp     as decimal
  field qnty     as decimal
  field delta    as decimal
  field density1 as decimal
  field temp1    as decimal
  field qnty1    as decimal
  field delta1   as decimal
  field name-pl  as character
  field volue-pl as decimal
  field log-pl   as character 
  index pi gds-code pl-code .


define buffer bf_trn-doc  for ub.trn-doc  .
define buffer bf_rvs-doc  for ub.rvs-doc  .
define buffer bf_rvs-line for ub.rvs-line .
define buffer bf_goods    for ub.goods    .
define buffer bf_object   for ub.clients  .
define buffer bf_place    for ub.place    .
define buffer bf_doc-line for ub.doc-line.

&scop f-l MonthNameRusCase,Sparse

do
  on error undo, return error return-value
  :
  run WaitFram-Show in this-procedure
    ( input 'Идет формирование отчета, ждите...'
    ) .
  run get-report-num  in p-parent-proc
    (
    output g#report-num
    ) .
  run get-quest-print in p-parent-proc
    (
    output g#quest-print
    ) .
  find first bf_trn-doc no-lock where
    recid( bf_trn-doc ) = p-rec-invent no-error .
  if not available bf_trn-doc
    then 
  do:
    run waitfram-hide in this-procedure .
    message substitute( 'Не найден документ с идентификатором &1.'
      , p-rec-invent
      )
      view-as alert-box error .
    undo, return error .
  end.
  if bf_trn-doc.doc-type     <> {&inventory} or
    bf_trn-doc.ext-doc-type <> {&TDEDT_Inv}
    then 
  do:
    run waitfram-hide in this-procedure .
    message
      'Данная форма только для печати инвентаризации.'
      view-as alert-box error .
    undo, return error .
  end.
  find first bf_rvs-doc no-lock where
    bf_rvs-doc.rvs-code = bf_trn-doc.out-code no-error .
  if not available bf_rvs-doc
    then 
  do:
    run waitfram-hide in this-procedure .
    message substitute( 'Не найдена сверка к документу "&1".'
      , bf_trn-doc.doc-code
      )
      view-as alert-box error .
    undo, return error .
  end.
  if bf_rvs-doc.rvs-type <> {&rvs-control}
    then 
  do:
    run waitfram-hide in this-procedure .
    message substitute( 'Сверка имеет тип "&1", а должен быть "&2".'
      , bf_rvs-doc.rvs-type
      , {&rvs-control}
      )
      view-as alert-box error .
    undo, return error .
  end.
  find first bf_object no-lock where
    bf_object.obj-type = bf_trn-doc.obj-type and
    bf_object.obj-code = bf_trn-doc.obj-code .
    { gbl/hostname.i
      bf_trn-doc.obj-type
      bf_trn-doc.obj-code
      p-host-code
      v-host-name
      no-error
  }
  if error-status :error
    then 
  do:
    run waitfram-hide in this-procedure .
    message
      'Не могу определить текущую фирму.'
      view-as alert-box error .
    undo, return error .
  end.
  if bf_trn-doc.host-code <> p-host-code
    then 
  do:
    run waitfram-hide in this-procedure .
    message
      'Ошибка определения текущей фирмы.'
      view-as alert-box error .
    undo, return error .
  end.
  assign
    t_inv-date = ( if bf_trn-doc.status_ = {&fact} then bf_trn-doc.fact-date else bf_trn-doc.doc-date )
    .

  /*печать*/
  run get-report-num (output p-report-id).
    
  v-file-name-rep-htm = session:temp-directory + string(p-report-id) + ".html".   
  output stream OutStr-html to value(v-file-name-rep-htm) convert target 'UTF-8'.
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

  { rep/r-orioxl-sug.i }                      
  run shapka-inv .
  run data-print .
  run table-inv .
  run foot-inv .

  put stream OutStr-html unformatted
    '</tfoot>' skip
    '</table>' skip
    '</body>' skip
    '</html>' skip
    .
  output stream OutStr-html close.     
                                                                                                                
  run prn-lib-reportviewer-report-name in this-procedure (
    input THIS-PROCEDURE
    ,input v-file-name-rep-htm
    ).
                
procedure data-print :
  for each  bf_rvs-line no-lock where
    bf_rvs-line.rvs-code = bf_rvs-doc.rvs-code  and
    bf_rvs-line.obj-type = bf_rvs-doc.obj-type  and
    bf_rvs-line.obj-code = bf_rvs-doc.obj-code
       
    , first bf_goods    no-lock where
    bf_goods.gds-code = bf_rvs-line.gds-code 
    , first bf_doc-line no-lock where
    bf_trn-doc.doc-code = bf_doc-line.doc-code and
    bf_goods.prod-code = bf_doc-line.prod-code and
    bf_goods.prod-type = bf_doc-line.prod-type and
    bf_goods.artic =  bf_doc-line.artic

    break 
    by bf_rvs-line.gds-code
    by bf_rvs-line.pl-code
    :
    if is-sug(bf_goods.gds-code) then 
    do:          
      if first-of( bf_rvs-line.gds-code )
        then 
      do:
        { gbl/bcodeprc.i
          bf_rvs-line.obj-type
          bf_rvs-line.obj-code
          bf_rvs-line.gds-code
          0
          bf_trn-doc.fact-order
          v-doc-num
          dprice-sale
          droad-tax
          dexcise
          no-error
      }
        if error-status :error
          then 
        do:
          run waitfram-hide in this-procedure .
          message
            'Не могу определить текущие продажные цены.'
            view-as alert-box error .
          undo, return error .
        end.
      end. /* if first-of( bf_rvs-line.gds-code ) */
    end.
    /* **************************************************************************************** *\
     *                                                                                          *
     * state-measure- (state-measure-qnty, state-measure-cli-qnty) - фактический отстаток;      *
     * system-        (system-qnty,        system-cli-qnty)        - расчетно-книжный остаток; *
     *                                                                                          *
    \* **************************************************************************************** */
    find first bf_place no-lock where
      bf_place.obj-type = bf_rvs-line.obj-type and
      bf_place.obj-code = bf_rvs-line.obj-code and
      bf_place.pl-code  = bf_rvs-line.pl-code  .
    find first tt-sug where tt-sug.gds-code = bf_goods.gds-code and tt-sug.pl-code = bf_rvs-line.pl-code no-error .
    if not available (tt-sug) then 
    do:
    end.         

    create tt-sug .
    assign
      tt-sug.gds-code = bf_goods.gds-code
      tt-sug.gds-name = bf_goods.gds-name
      tt-sug.pl-code  = bf_rvs-line.pl-code
      tt-sug.level    = (bf_rvs-line.state-level-petrol + bf_rvs-line.state-level-water) / bf_rvs-line.state-level-total * 100  
      
/*      tt-sug.level   = "ЗАПОЛНЕН"*/ /*ИЗ АТРИБУТА, КОТОРЫЙ ДОЛЖЕН Сережа добавить*/
      tt-sug.volue    = bf_rvs-line.state-measure-qnty
      tt-sug.density  = bf_rvs-line.state-density
      tt-sug.temp     = bf_rvs-line.state-temperature
      tt-sug.qnty     = bf_rvs-line.state-measure-cli-qnty
      tt-sug.volue-pl = bf_place.add-qnty
      tt-sug.qnty1 = tt-sug.volue-pl * tt-sug.density
      tt-sug.pl-type  = "трубопровод"
      .
    tt-sug.log-pl = if tt-sug.volue-pl <> 0 then "заполнено" else "не заполнено" .
    tt-sug.delta  = (tt-sug.qnty * 0.65)/ 100 .
    tt-sug.delta1  = (tt-sug.qnty1 * 0.3)/ 100 .
    define variable v-value as character no-undo.
    define variable v-ok    as logical   no-undo.
      
    run placelib_get-attr  ( input {&place-twice-code}
      ,input bf_rvs-line.obj-code
      ,input bf_rvs-line.obj-type
      ,input bf_rvs-line.pl-code
      ,output v-value
      ,output v-ok      ) no-error.
    if v-value <> "" then  tt-sug.pl-code_ = string(bf_place.loc1) + "," + v-value .
    else tt-sug.pl-code_ = string(bf_place.loc1) .

  /*    for first ub.rvs-line-attr no-lock where ub.rvs-line-attr.gds-code = bf_goods.gds-code*/
  /*      and ub.rvs-line-attr.attr-code = "abs-delta-mass-qnty"                              */
  /*      and ub.rvs-line-attr.obj-code = bf_rvs-line.obj-code                                */
  /*      and ub.rvs-line-attr.obj-type = bf_rvs-line.obj-type                                */
  /*      and ub.rvs-line-attr.pl-code = bf_rvs-line.pl-code:                                 */
  /*      tt-sug.delta = decimal(ub.rvs-line-attr.attr-value) .                               */
  /*    end.                                                                                  */
  end. /* for each bf_rvs-line */
end procedure .
  run waitfram-hide  in this-procedure .
end. /* on error */

procedure table-inv:
  put stream OutStr-html unformatted
    '<Thead>' skip
    '<TR><TD colspan="86" style="height: 14px;"></TD></TR>' skip
    '<TR><TD colspan="86">При инвентаризации в резервуарах АГЗС установлено следующее:</TD></TR>' skip
    '</Thead>' skip
    .  
  put stream OutStr-html unformatted
    '<TR style="height: 35px">' skip
    '<TD text_wrap="true" colspan = "4" rowspan = "2" style="text-align: center; border: 1px solid black;">№</TD>' skip
    '<TD text_wrap="true" colspan = "14" style="text-align: center; border: 1px solid black;">СУГ</TD>' skip
    '<TD text_wrap="true" colspan = "8" rowspan = "2" style="text-align: center; border: 1px solid black;">Тип, номер резервуара</TD>' skip
    '<TD text_wrap="true" colspan = "10" rowspan = "2" style="text-align: center; border: 1px solid black;">Уровень наполнения резервуара, %</TD>' skip
    '<TD text_wrap="true" colspan = "10" rowspan = "2" style="text-align: center; border: 1px solid black;">Объем СУГ, л</TD>' skip
    '<TD text_wrap="true" colspan = "10" rowspan = "2" style="text-align: center; border: 1px solid black;">Плотность СУГ, г/см3</TD>' skip
    '<TD text_wrap="true" colspan = "10" rowspan = "2" style="text-align: center; border: 1px solid black;">Температура СУГ, °С</TD>' skip
    '<TD text_wrap="true" colspan = "10" rowspan = "2" style="text-align: center; border: 1px solid black;">Масса СУГ, кг</TD>' skip
    '<TD text_wrap="true" colspan = "10" rowspan = "2" style="text-align: center; border: 1px solid black;">Погрешность измерения, кг</TD>' skip
    '</TR>'skip       

    '<TR style="height: 35px">' skip
    '<TD text_wrap="true" colspan = "9" style="text-align: center; border: 1px solid black;">наимен.</TD>' skip
    '<TD text_wrap="true" colspan = "5" style="text-align: center; border: 1px solid black;">код</TD>' skip
    '</TR>'skip                           
    
    '<TR>' skip
    '<TD colspan = "4" style="text-align: center; border: 1px solid black;">1</TD>' skip
    '<TD colspan = "9" style="text-align: center; border: 1px solid black;">2</TD>' skip
    '<TD colspan = "5" style="text-align: center; border: 1px solid black;">3</TD>' skip
    '<TD colspan = "8" style="text-align: center; border: 1px solid black;">4</TD>' skip
    '<TD colspan = "10" style="text-align: center; border: 1px solid black;">5</TD>' skip
    '<TD colspan = "10" style="text-align: center; border: 1px solid black;">6</TD>' skip
    '<TD colspan = "10" style="text-align: center; border: 1px solid black;">7</TD>' skip
    '<TD colspan = "10" style="text-align: center; border: 1px solid black;">8</TD>' skip
    '<TD colspan = "10" style="text-align: center; border: 1px solid black;">9</TD>' skip
    '<TD colspan = "10" style="text-align: center; border: 1px solid black;">10</TD>' skip
    '</TR>'skip     
    .
  for each tt-sug:
    assign
      j_LineCount = 0
      .
    put stream OutStr-html unformatted
      '<TR>' skip
      '<TD colspan = "4" text_wrap="true" style="text-align: center; border: 1px solid black;">' + string(j_LineCount + 1) + '</TD>' skip
      '<TD colspan = "9" text_wrap="true" style="text-align: center; border: 1px solid black;">' + tt-sug.gds-name + '</TD>' skip
      '<TD colspan = "5" text_wrap="true" style="text-align: center; border: 1px solid black;">' + string(tt-sug.gds-code) + '</TD>' skip
      '<TD colspan = "8" text_wrap="true" style="text-align: center; border: 1px solid black;">' + string(tt-sug.pl-code_) + '</TD>' skip
      '<TD colspan = "10" text_wrap="true" num="0.000" val="' + fnc-convert-dot-to-colon(tt-sug.level,"->>>>>>>>>>>9.999",3) + '" style="text-align: center; border: 1px solid black;">' + fnc-convert-dot-to-colon(tt-sug.level,"->>>>>>>>>>>9.999",3) + '</TD>' skip
      '<TD colspan = "10" text_wrap="true" num="0.000" val="' + fnc-convert-dot-to-colon(tt-sug.volue,"->>>>>>>>>>>9.999",3) + '" style="text-align: center; border: 1px solid black;">' + fnc-convert-dot-to-colon(tt-sug.volue,"->>>>>>>>>>>9.999",3) + '</TD>' skip
      '<TD colspan = "10" text_wrap="true" num="0.0000" val="' + fnc-convert-dot-to-colon(tt-sug.density,"->>>>>>>>>>>9.9999",4) + '" style="text-align: center; border: 1px solid black;">' + fnc-convert-dot-to-colon(tt-sug.density,"->>>>>>>>>>>9.9999",4) + '</TD>' skip
      '<TD colspan = "10" text_wrap="true" num="0.000" val="' + fnc-convert-dot-to-colon(tt-sug.temp,"->>>>>>>>>>>9.999",3) + '" style="text-align: center; border: 1px solid black;">' + fnc-convert-dot-to-colon(tt-sug.temp,"->>>>>>>>>>>9.999",3) + '</TD>' skip
      '<TD colspan = "10" text_wrap="true" num="0.000" val="' + fnc-convert-dot-to-colon(tt-sug.qnty,"->>>>>>>>>>>9.999",3) + '" style="text-align: center; border: 1px solid black;">' + fnc-convert-dot-to-colon(tt-sug.qnty,"->>>>>>>>>>>9.999",3) + '</TD>' skip
      '<TD colspan = "10" text_wrap="true" num="0.000" val="' + fnc-convert-dot-to-colon(tt-sug.delta,"->>>>>>>>>>>9.999",3) + '" style="text-align: center; border: 1px solid black;">' + fnc-convert-dot-to-colon(tt-sug.delta,"->>>>>>>>>>>9.999",3) + '</TD>' skip
      '</TR>'skip     
      .
  end.
  
  put stream OutStr-html unformatted
    '<Thead>' skip
    '<TR><TD colspan="86" style="height: 14px;"></TD></TR>' skip
    '<TR><TD colspan="86">Наличие СУГ  технологических трубопроводах и оборудовании:</TD></TR>' skip
    '</Thead>' skip
    .

  put stream OutStr-html unformatted
    '<TR style="height: 65px">' skip
    '<TD text_wrap="true" colspan = "4" rowspan = "2" style="text-align: center; border: 1px solid black;">№</TD>' skip
    '<TD text_wrap="true" colspan = "14" style="text-align: center; border: 1px solid black;">СУГ</TD>' skip
    '<TD text_wrap="true" colspan = "8" rowspan = "2" style="text-align: center; border: 1px solid black;">Наим. участка техн. трубопровода (оборуд)</TD>' skip
    '<TD text_wrap="true" colspan = "10" rowspan = "2" style="text-align: center; border: 1px solid black;">Вместимость (объем) участка трубопровода (оборуд), л</TD>' skip
    '<TD text_wrap="true" colspan = "10" rowspan = "2" style="text-align: center; border: 1px solid black;">Факт заполнения на момент инвентар (заполнено/ не заполнено)</TD>' skip
    '<TD text_wrap="true" colspan = "10" rowspan = "2" style="text-align: center; border: 1px solid black;">Плотность СУГ, кг/м3</TD>' skip
    '<TD text_wrap="true" colspan = "10" rowspan = "2" style="text-align: center; border: 1px solid black;">Температура СУГ, °С</TD>' skip
    '<TD text_wrap="true" colspan = "10" rowspan = "2" style="text-align: center; border: 1px solid black;">Масса СУГ, кг</TD>' skip
    '<TD text_wrap="true" colspan = "10" rowspan = "2" style="text-align: center; border: 1px solid black;">Погрешность измерения, кг</TD>' skip
    '</TR>'skip       

    '<TR style="height: 65px">' skip
    '<TD text_wrap="true" colspan = "9" style="text-align: center; border: 1px solid black;">наимен.</TD>' skip
    '<TD text_wrap="true" colspan = "5" style="text-align: center; border: 1px solid black;">код</TD>' skip
    '</TR>'skip                           
    
    '<TR>' skip
    '<TD colspan = "4" style="text-align: center; border: 1px solid black;">1</TD>' skip
    '<TD colspan = "9" style="text-align: center; border: 1px solid black;">2</TD>' skip
    '<TD colspan = "5" style="text-align: center; border: 1px solid black;">3</TD>' skip
    '<TD colspan = "8" style="text-align: center; border: 1px solid black;">4</TD>' skip
    '<TD colspan = "10" style="text-align: center; border: 1px solid black;">5</TD>' skip
    '<TD colspan = "10" style="text-align: center; border: 1px solid black;">6</TD>' skip
    '<TD colspan = "10" style="text-align: center; border: 1px solid black;">7</TD>' skip
    '<TD colspan = "10" style="text-align: center; border: 1px solid black;">8</TD>' skip
    '<TD colspan = "10" style="text-align: center; border: 1px solid black;">9</TD>' skip
    '<TD colspan = "10" style="text-align: center; border: 1px solid black;">10</TD>' skip
    '</TR>'skip     
    .
  for each tt-sug:
    assign
      j_LineCount = 0
      .
    put stream OutStr-html unformatted
      '<TR>' skip
      '<TD colspan = "4" text_wrap="true" style="text-align: center; border: 1px solid black;">' + string(j_LineCount + 1) + '</TD>' skip
      '<TD colspan = "9" text_wrap="true" style="text-align: center; border: 1px solid black;">' + tt-sug.gds-name + '</TD>' skip
      '<TD colspan = "5" text_wrap="true" style="text-align: center; border: 1px solid black;">' + string(tt-sug.gds-code) + '</TD>' skip
      '<TD colspan = "8" text_wrap="true" style="text-align: center; border: 1px solid black;">' + string(tt-sug.pl-type) + '</TD>' skip
      '<TD colspan = "10" text_wrap="true" num="0.000" val="' + fnc-convert-dot-to-colon(tt-sug.volue-pl,"->>>>>>>>>>>9.999",3) + '" style="text-align: center; border: 1px solid black;">' + fnc-convert-dot-to-colon(tt-sug.volue-pl,"->>>>>>>>>>>9.999",3) + '</TD>' skip
      '<TD colspan = "10" text_wrap="true" style="text-align: center; border: 1px solid black;">' + string(tt-sug.log-pl) + '</TD>' skip
      '<TD colspan = "10" text_wrap="true" num="0.0000" val="' + fnc-convert-dot-to-colon(tt-sug.density,"->>>>>>>>>>>9.9999",4) + '" style="text-align: center; border: 1px solid black;">' + fnc-convert-dot-to-colon(tt-sug.density,"->>>>>>>>>>>9.9999",4) + '</TD>' skip
      '<TD colspan = "10" text_wrap="true" num="0.000" val="' + fnc-convert-dot-to-colon(tt-sug.temp,"->>>>>>>>>>>9.999",3) + '" style="text-align: center; border: 1px solid black;">' + fnc-convert-dot-to-colon(tt-sug.temp,"->>>>>>>>>>>9.999",3) + '</TD>' skip
      '<TD colspan = "10" text_wrap="true" num="0.000" val="' + fnc-convert-dot-to-colon(tt-sug.qnty1,"->>>>>>>>>>>9.999",3) + '" style="text-align: center; border: 1px solid black;">' + fnc-convert-dot-to-colon(tt-sug.qnty1,"->>>>>>>>>>>9.999",3) + '</TD>' skip
      '<TD colspan = "10" text_wrap="true" num="0.000" val="' + fnc-convert-dot-to-colon(tt-sug.delta1,"->>>>>>>>>>>9.999",3) + '" style="text-align: center; border: 1px solid black;">' + fnc-convert-dot-to-colon(tt-sug.delta1,"->>>>>>>>>>>9.999",3) + '</TD>' skip
      '</TR>'skip     
      .
  end.  
end procedure .

PROCEDURE get-report-num :

  define output parameter p-report-num as integer no-undo .

  do
    on error undo, return error return-value
    :
    run gbl/getrpnum.p (output p-report-num).
  end.

END PROCEDURE.                                     