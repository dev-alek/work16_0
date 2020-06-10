/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Результаты проверки HDD

Автор: Шкляр Елена 
Дата создания: 08/07/14
Author: Elena Shklyar
Creation date: 08/07/14

*/

using ibs.th.str.*.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Результаты проверки HDD".
{ cmp/vssrevis.i }

define input parameter parparentproc    as widget-handle           no-undo.
define input parameter p-Date-start     as date no-undo .
define input parameter p-Date-end     as date no-undo .
define input parameter p-obj-list  as character no-undo .
define input parameter p-folder  as character no-undo .
define input parameter p-file  as character no-undo .

{ cmp/str-glbl.i }
{ cmp/library.i  }
{ cmp/r-pril.i   }
{ str/lib-trn.i  }
/*{ str/getctxtp.i get }*/
/*{ str/getctxtp.i def }*/

{ gbl/prn-lib.i     }
{ rep/html-conv.i }

define temp-table tt-devicePC no-undo
  field id          as integer
  field modeldevice like ub.devisPC.modeldevice
  field ModelPC     like ub.devisPC.ModelPC
  field namepc      like ub.devisPC.namepc
  field date_       as character
  field time_       as character
  field ProcDisk    as decimal
  field UserProc    as decimal
  field status_     as character
  field db-num      as integer 
  index pi id .
  
define temp-table tt-devicePCAttr no-undo
  field id        as integer
  field name_     as character
  field value_    as decimal
  field tresh     as decimal
  field type_     as character
  field raw_value as decimal
  field ch_raw    as character
  field ch_val    as character
  index pi id
  .
        
define buffer buf_devisPC      for ub.devisPC .
define buffer buf_tt-devisPC   for tt-devicePC .
define buffer buf_devisPCAttr  for ub.devisPC-attr .
define buffer bf_devisPCAttr   for ub.devisPC-attr .
define buffer bt_devisPCAttr   for ub.devisPC-attr .
define buffer buf_devisPC-attr for ub.devisPC-attr .
define stream Out-Stream.
define stream OutStr-html.

define stream Outhtmllog.
define VARIABLE p-report-id         as character no-undo .
define variable v-file-name-rep-htm as character no-undo .
define variable ii                  as integer   no-undo .
define variable v-change-Raw        as decimal   no-undo .
define variable v-change-Value      as decimal   no-undo .
define variable v-ok-Raw            as decimal   no-undo .
define variable v-ok-Value          as decimal   no-undo .

define variable v-delta             as decimal   no-undo .
    

do
  on error undo, return error return-value
  :
  if p-obj-list = "" then p-obj-list = "0" .      
  do ii = 1 to num-entries (p-obj-list, {&comma-char}):
    for each buf_devisPC no-lock where buf_devisPC.DB-num = integer(entry(ii, p-obj-list, {&comma-char})) and buf_devisPC.modeldevice <> ?:
      find first tt-devicePC where tt-devicePC.id          = buf_devisPC.id and
        tt-devicePC.modeldevice = buf_devisPC.modeldevice and 
        tt-devicePC.ModelPC     = (buf_devisPC.ModelPC) and
        tt-devicePC.namepc      = buf_devisPC.namepc and
        tt-devicePC.date_       = string(p-Date-start) and
        tt-devicePC.time_       = string(p-Date-end) and
        tt-devicePC.db-num      = buf_devisPC.DB-num no-error .
      if not available (tt-devicePC) then 
      do:  
        create tt-devicePC .
        assign
          tt-devicePC.id          = buf_devisPC.id
          tt-devicePC.modeldevice = buf_devisPC.modeldevice
          tt-devicePC.ModelPC     = buf_devisPC.ModelPC
          tt-devicePC.namepc      = buf_devisPC.namepc
          tt-devicePC.date_       = string(p-Date-start)
          tt-devicePC.time_       = string(p-Date-end)
          tt-devicePC.db-num      = buf_devisPC.DB-num
          .
      end.
    for each buf_devisPCAttr no-lock where buf_devisPCAttr.id = tt-devicePC.id
      and buf_devisPCAttr.attr-code <> "ProcDisk" and buf_devisPCAttr.attr-code <> "UserProc" and buf_devisPCAttr.attr-code <> "testStatus"
      and buf_devisPCAttr.date >= p-Date-start and buf_devisPCAttr.date <= p-Date-end: 
          
      /*            v-change-Raw = decimal(buf_devisPCAttr.attr-Raw-value) .                  */
      /*                                                                                      */
      /*            if v-change-Raw <> 0 and v-change-Raw <> ? then do:                       */
      /*              v-ok-Raw = abs(v-change-Raw - decimal(buf_devisPCAttr.attr-Raw-value)) .*/
      /*            end.                                                                      */
      /*                                                                                      */
      /*            v-change-Value = decimal(buf_devisPCAttr.attr-value) .                    */
      /*                                                                                      */
      /*            if v-change-Value <> 0 and v-change-Value <> ? then do:                   */
      /*              v-ok-Value = abs(v-change-Value - decimal(buf_devisPCAttr.attr-value)) .*/
      /*            end.                                                                      */
              
      create tt-devicePCAttr .
      assign
        tt-devicePCAttr.id        = buf_devisPCAttr.id
        tt-devicePCAttr.name_     = buf_devisPCAttr.attr-code
        tt-devicePCAttr.raw_value = decimal(buf_devisPCAttr.attr-Raw-value)
        tt-devicePCAttr.tresh     = decimal(buf_devisPCAttr.tresh)
        tt-devicePCAttr.value_    = decimal(buf_devisPCAttr.attr-value)
        tt-devicePCAttr.type_     = buf_devisPCAttr.type 
        .  
    end.     
    end.  
    output stream Outhtmllog to value(p-folder + "\" + p-file + ".txt") append convert target 'UTF-8'.
  
    if not available (tt-devicePCAttr) then 
    do:
      put stream Outhtmllog unformatted
        "По АЗК №" + entry(ii, p-obj-list, {&comma-char}) + " отсутствуют данные за выбранный период c " + string(p-Date-start,"99/99/9999") + " по "  + string(p-Date-end,"99/99/9999") skip .
      return .
    end.
    else 
    do:
      put stream Outhtmllog unformatted
        "По АЗК №" + entry(ii, p-obj-list, {&comma-char}) + " данные за выбранный период c " + string(p-Date-start,"99/99/9999") + " по "  + string(p-Date-end,"99/99/9999") + "выгружены" skip .
    end.    
    output stream Outhtmllog close.    
  end.
 
  /*печать*/
  run get-report-num (output p-report-id).
    
  v-file-name-rep-htm = p-folder + "\" + string(p-file) + string(p-Date-end,"99999999") + string (time) + ".html".   
                        
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
                        
                        
  put stream OutStr-html unformatted
    '<body>' skip
    '<TABLE name="1"  fit_to_page="true" orientation="portrait" CELLSPACING="0" BORDER="0">'skip
    '<thead>' skip
    .
  put stream OutStr-html unformatted
    '<tr>' skip
    '<td style="width: 50px;"></td>' skip
    '<td style="width: 50px;"></td>' skip
    '<td style="width: 50px;"></td>' skip
    '<td style="width: 50px;"></td>' skip
    '<td style="width: 50px;"></td>' skip
    '<td style="width: 50px;"></td>' skip
    '<td style="width: 50px;"></td>' skip
    '<td style="width: 50px;"></td>' skip
    '<td style="width: 50px;"></td>' skip
    '<td style="width: 50px;"></td>' skip
    '</tr>' skip
    .
                        
 
  put stream OutStr-html unformatted
    '<TR><TD colspan="9"></TD></TR>' skip
    '</thead>' skip
    '<tbody>' skip
    .
  put stream OutStr-html unformatted
    '<TR>' skip
    '<TD text_wrap="true" rowspan="2" style="text-align: center;">АЗК</TD>' skip
    '<TD text_wrap="true" rowspan="2" style="text-align: center;">Начало периода</TD>' skip
    '<TD text_wrap="true" rowspan="2" style="text-align: center;">Конец периода</TD>' skip
    '<TD text_wrap="true" rowspan="2" style="text-align: center;">Имя ПК</TD>' skip
    '<TD text_wrap="true" rowspan="2" style="text-align: center;">Модель диска</TD>' skip
    '<TD text_wrap="true" colspan="5" style="text-align: center;">Атрибуты диска</TD>' skip
    '</TR>' skip .
  put stream OutStr-html unformatted  
    '<TD text_wrap="true" style="text-align: center;">Название</TD>' skip
    '<TD text_wrap="true" style="text-align: center;">Value</TD>' skip
    '<TD text_wrap="true" style="text-align: center;">Tresh</TD>' skip
    '<TD text_wrap="true" style="text-align: center;">Тип</TD>' skip
    '<TD text_wrap="true" style="text-align: center;">Raw_value</TD>' skip
    '</TR>'skip       
    .
  for each tt-devicePC:
    put stream OutStr-html unformatted
      '<TR>' skip
      '<TD text_wrap="true" style="text-align: center;">' + string(tt-devicePC.db-num) + '</TD>' skip
      '<TD text_wrap="true" style="text-align: center;">' + string(tt-devicePC.date_) + '</TD>' skip
      '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePC.time_) + '</TD>' skip
      '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePC.namepc) + '</TD>' skip
      '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePC.modeldevice) + '</TD>' skip
      .                     

    for each tt-devicePCAttr no-lock where tt-devicePCAttr.id = tt-devicePC.id break by tt-devicePCAttr.id:
      if first-of (tt-devicePCAttr.id ) then 
      do:         
        put stream OutStr-html unformatted
          '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePCAttr.name_) + '</TD>' skip
          '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePCAttr.value_) + '</TD>' skip
          '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePCAttr.tresh) + '</TD>' skip
          '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePCAttr.type_) + '</TD>' skip
          '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePCAttr.raw_value) + '</TD>' skip
          '</tr>'                          
          .
      end.
      else 
      do:
        put stream OutStr-html unformatted
          '<TR>' skip
          '<TD text_wrap="true" colspan="5" style="text-align: center;"></TD>' skip
          '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePCAttr.name_) + '</TD>' skip
          '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePCAttr.value_) + '</TD>' skip
          '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePCAttr.tresh) + '</TD>' skip
          '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePCAttr.type_) + '</TD>' skip
          '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePCAttr.raw_value) + '</TD>' skip
          '</tr>'                          
          .                           
      end.  
    end. 
  end.
  put stream OutStr-html unformatted
    '</tbody>' skip
    '<tfoot>' skip.
                            
  put stream OutStr-html unformatted
    '</tfoot>' skip
    '</table>' skip
    '</body>' skip
    '</html>' skip
    .
                            
  output stream OutStr-html close.     
                                                                                                                
/*  run prn-lib-reportviewer-report-name in this-procedure (*/
/*    input THIS-PROCEDURE                                  */
/*    ,input v-file-name-rep-htm                            */
/*    ).                                                    */

end.



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