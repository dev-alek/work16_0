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

define input parameter parparentproc    as widget-handle  no-undo.
define input parameter p-Date-start     as date           no-undo .
define input parameter p-Date-end       as date           no-undo .
define input parameter p-Time-start     as datetime      no-undo .
define input parameter p-Time-end       as datetime      no-undo .
define input parameter p-namePk         as character      no-undo .
define input parameter p-ModelDisk      as character      no-undo .
define input parameter p-AttrName       as character      no-undo .
define input parameter p-AttrType       as character      no-undo .
define input parameter p-ChangeRaw      as logical        no-undo .
define input parameter p-ChangeValue    as logical        no-undo .
define input parameter p-obj-list       as character      no-undo .
define input parameter p-RawValue       as decimal        no-undo .
define input parameter p-TreshDisk      as decimal        no-undo .
define input parameter p-ValueDisk      as decimal        no-undo .

{ cmp/str-glbl.i }
{ cmp/library.i  }
{ cmp/r-pril.i   }
{ str/lib-trn.i  }
{ str/getctxtp.i def }
{ str/getctxtp.i get }
{ gbl/prn-lib.i     }
{ rep/html-conv.i }

define temp-table tt-devicePC no-undo
  field id          as integer
  field modeldevice like ub.devisPC.modeldevice
  field ModelPC     like ub.devisPC.ModelPC
  field namepc      like ub.devisPC.namepc
  field date_start  as character
  field time_start  as character
  field date_end    as character
  field time_end    as character
  field ProcDisk    as decimal
  field UserProc    as decimal
  field status_     as character
  field db-num      as integer 
  index pi id .
  
define temp-table tt-devicePCAttr no-undo
  field id        as integer
  field date_     as date
  field time_     as integer
  field name_     as character
  field value_    as decimal
  field tresh     as decimal
  field type_     as character
  field raw_value as decimal
  field ch_raw    as decimal
  field ch_val    as decimal
  field strok     as integer
  index pi id
  .
define temp-table tt-attrDevis like ub.devisPC-attr .        
define buffer buf_devisPC        for ub.devisPC .
define buffer buf_devisPCAttr    for ub.devisPC-attr .
define buffer bf_devisPCAttr     for ub.devisPC-attr .
define buffer bt_devisPCAttr     for ub.devisPC-attr .
define buffer buf_devisPC-attr   for ub.devisPC-attr .
define buffer buf_tt-devisPCAttr for tt-devicePCAttr .

define stream Out-Stream.
define stream OutStr-html.
define VARIABLE p-report-id         as character no-undo .
define variable v-file-name-rep-htm as character no-undo .
define variable ii                  as integer   no-undo .
define variable jj                  as integer   no-undo .
define variable v-change-Raw        as decimal   no-undo .
define variable v-change-Value      as decimal   no-undo .
define variable v-ok-Raw            as decimal   no-undo .
define variable v-ok-Value          as decimal   no-undo .

define variable v-delta             as decimal   no-undo .
define variable v-time-start        as integer   no-undo .
define variable v-time-end          as integer   no-undo .
define variable v-time-start1       as character no-undo .
define variable v-time-end1         as character no-undo .
define variable v-date-start        as date      no-undo .
define variable v-date-end          as date      no-undo .
do
  on error undo, return error return-value
  :
  p-obj-list = trim(p-obj-list,",") .  
  v-delta = p-ValueDisk - p-TreshDisk .
  v-time-start = mtime (p-Time-start) / 1000 .
  v-time-end  = mtime (p-Time-end) / 1000 .
  if p-obj-list = "" then p-obj-list = string(v-cntxp-db-num) .      
  do ii = 1 to num-entries (p-obj-list, {&comma-char}):
    for each buf_devisPC no-lock where buf_devisPC.DB-num = integer(entry(ii, p-obj-list, {&comma-char})):
      if buf_devisPC.namepc begins p-namePk and buf_devisPC.modeldevice begins p-ModelDisk then 
      do:
        create tt-devicePC .
        assign
          tt-devicePC.id          = buf_devisPC.id
          tt-devicePC.db-num      = buf_devisPC.DB-num
          tt-devicePC.modeldevice = buf_devisPC.modeldevice
          tt-devicePC.ModelPC     = buf_devisPC.ModelPC
          tt-devicePC.namepc      = buf_devisPC.namepc
          .
      end.
      RAW_:
      for each buf_devisPCAttr no-lock where buf_devisPCAttr.id = buf_devisPC.id and buf_devisPCAttr.attr-code begins p-AttrName and buf_devisPCAttr.type begins p-AttrType
        and buf_devisPCAttr.attr-code <> "ProcDisk" and buf_devisPCAttr.attr-code <> "UserProc" and buf_devisPCAttr.attr-code <> "testStatus" and buf_devisPCAttr.date >= p-Date-start
        and buf_devisPCAttr.date <= p-Date-end break by buf_devisPCAttr.attr-code by buf_devisPCAttr.date by buf_devisPCAttr.time_:
        if buf_devisPCAttr.date = p-Date-start and buf_devisPCAttr.time_ < v-time-start then next RAW_.
        if buf_devisPCAttr.date = p-Date-end and buf_devisPCAttr.time_ > v-time-end then next RAW_.
        create tt-attrDevis .
        buffer-copy buf_devisPCAttr to tt-attrDevis . 
      end.
      for each tt-attrDevis break by tt-attrDevis.attr-code by tt-attrDevis.date by tt-attrDevis.time_:
        if first-of (tt-attrDevis.date) then 
        do: 
          if v-time-start1 = "" then v-time-start1  = string(truncate (tt-attrDevis.time_ / 3600, 0)) + ":" + string((tt-attrDevis.time_ modulo 3600) / 60,"99") .
          if v-date-start = ? then v-date-start = tt-attrDevis.date . 
        end.          
        if p-RawValue <> 0 then 
        do:
          if decimal(tt-attrDevis.attr-Raw-value) <> p-RawValue then do:
            delete tt-attrDevis .
          end.  
        end.
        if p-TreshDisk <> 0 then 
        do:
          if decimal(tt-attrDevis.tresh) <> p-TreshDisk then do:
            delete tt-attrDevis .
          end.  
        end.  
        if p-ValueDisk <> 0 then 
        do:
          if decimal(tt-attrDevis.attr-value) <> p-ValueDisk then do:
            delete tt-attrDevis .
          end.  
        end.  
        find first tt-devicePCAttr where tt-devicePCAttr.name_ = tt-attrDevis.attr-code and
          tt-devicePCAttr.id = tt-attrDevis.id no-error .
                v-ok-Raw = 0 .
                v-ok-Value = 0 .  
        if available (tt-devicePCAttr) then 
        do:
          for last buf_tt-devisPCAttr exclusive-lock where tt-attrDevis.id = buf_tt-devisPCAttr.id
            and buf_tt-devisPCAttr.name_ = tt-attrDevis.attr-code:

            if buf_tt-devisPCAttr.raw_value <> decimal(tt-attrDevis.attr-Raw-value) then v-ok-Raw = abs(buf_tt-devisPCAttr.raw_value - decimal(tt-attrDevis.attr-Raw-value)) . 
            else v-ok-Raw = 0 .
            if p-ChangeRaw then do:
              if v-ok-Raw = 0 then do:
                delete tt-attrDevis .
              end.  
            end.   
            if buf_tt-devisPCAttr.value_ <> decimal(tt-attrDevis.attr-value) then v-ok-Value = abs(buf_tt-devisPCAttr.value_ - decimal(tt-attrDevis.attr-value)) . 
            else v-ok-Value = 0 .
            if p-ChangeValue then do:
              if v-ok-Value = 0 then do:
                delete tt-attrDevis .
              end.  
            end.  
          end.    
        end.   
        else 
        do:
          if decimal(tt-attrDevis.attr-Raw-value) <> 0 then v-ok-Raw = decimal(tt-attrDevis.attr-Raw-value) .
          if p-ChangeRaw then do: 
            if v-ok-Raw = 0 then do:
              delete tt-attrDevis .
            end.  
          end.  
          if decimal(tt-attrDevis.attr-value) <> 0 then v-ok-Value = decimal(tt-attrDevis.attr-value) .
          if p-ChangeValue then do:
            if v-ok-Value = 0 then do:
              delete tt-attrDevis .
            end.  
          end.  
        end.     

        create tt-devicePCAttr .
        assign
          tt-devicePCAttr.id        = tt-attrDevis.id
          tt-devicePCAttr.name_     = tt-attrDevis.attr-code
          tt-devicePCAttr.raw_value = decimal(tt-attrDevis.attr-Raw-value)
          tt-devicePCAttr.tresh     = decimal(tt-attrDevis.tresh)
          tt-devicePCAttr.value_    = decimal(tt-attrDevis.attr-value)
          tt-devicePCAttr.type_     = tt-attrDevis.type 
          tt-devicePCAttr.ch_raw    = v-ok-Raw
          tt-devicePCAttr.ch_val    = v-ok-Value
          .
        find first tt-devicePC where      
          tt-devicePC.id          = buf_devisPC.id and
          tt-devicePC.db-num      = buf_devisPC.DB-num and
          tt-devicePC.modeldevice = buf_devisPC.modeldevice and
          tt-devicePC.ModelPC     = buf_devisPC.ModelPC and
          tt-devicePC.namepc      = buf_devisPC.namepc
          
          no-error  .
        if available (tt-devicePC) then 
        do:
          if last-of (tt-attrDevis.date) then 
          do:
            tt-devicePC.time_end = string(truncate (tt-attrDevis.time_ / 3600, 0)) + ":" + string((tt-attrDevis.time_ modulo 3600) / 60,"99") .
            tt-devicePC.date_end = string(tt-attrDevis.date) .
            tt-devicePC.time_start = v-time-start1 .
            tt-devicePC.date_start = string(v-date-start) .
          end.
        end.
      end.
      
    end.
    find first tt-devicePCAttr no-error .   
    if not available (tt-devicePCAttr) then 
    do:
      message "По АЗК №" + entry(ii, p-obj-list, {&comma-char}) + " отсутствуют данные за выбранный период"
        view-as alert-box.
    end.

  end.

  find first tt-devicePCAttr no-error .
  if not available (tt-devicePCAttr) then return .
  find first tt-devicePC no-error .   
  if not available (tt-devicePC) then 
  do:
    message "По АЗК №" + p-obj-list + " отсутствуют данные за выбранный период"
      view-as alert-box.
    return .
  end.  
  find first tt-devicePC no-error .
  
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
    '<TD text_wrap="true" rowspan="2" style="text-align: center;">Дата и время первого теста за период</TD>' skip
    '<TD text_wrap="true" rowspan="2" style="text-align: center;">Дата и время последнего теста за период</TD>' skip
    '<TD text_wrap="true" rowspan="2" style="text-align: center;">Имя ПК</TD>' skip
    '<TD text_wrap="true" rowspan="2" style="text-align: center;">Модель диска</TD>' skip
    '<TD text_wrap="true" colspan="7" style="text-align: center;">Атрибуты диска</TD>' skip
    '</TR>' skip .
  put stream OutStr-html unformatted  
    '<TD text_wrap="true" style="text-align: center;">Название</TD>' skip
    '<TD text_wrap="true" style="text-align: center;">Value</TD>' skip
    '<TD text_wrap="true" style="text-align: center;">Tresh</TD>' skip
    '<TD text_wrap="true" style="text-align: center;">Тип</TD>' skip
    '<TD text_wrap="true" style="text-align: center;">Raw_value</TD>' skip
    '<TD text_wrap="true" style="text-align: center;">Изменение Raw_value</TD>' skip
    '<TD text_wrap="true" style="text-align: center;">Изменение Value</TD>' skip
    '</TR>'skip       
    .
    
  for each tt-devicePC no-lock:
    find first tt-devicePCAttr no-lock where tt-devicePCAttr.id = tt-devicePC.id no-error .
    if not available (tt-devicePCAttr) then next .
    put stream OutStr-html unformatted
      '<TR>' skip
      '<TD text_wrap="true" style="text-align: center;">' + string(tt-devicePC.db-num) + '</TD>' skip
      '<TD text_wrap="true" style="text-align: center;">' + string(tt-devicePC.date_start + " " + tt-devicePC.time_start) + '</TD>' skip
      '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePC.date_end + " " + tt-devicePC.time_end) + '</TD>' skip
      '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePC.namepc) + '</TD>' skip
      '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePC.modeldevice) + '</TD>' skip
      .                     
    for each tt-devicePCAttr no-lock where tt-devicePCAttr.id = tt-devicePC.id break by tt-devicePCAttr.id
      :
      if first-of (tt-devicePCAttr.id ) then 
      do:         
        put stream OutStr-html unformatted
          '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePCAttr.name_) + '</TD>' skip
          '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePCAttr.value_) + '</TD>' skip
          '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePCAttr.tresh) + '</TD>' skip
          '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePCAttr.type_) + '</TD>' skip
          '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePCAttr.raw_value) + '</TD>' skip
          '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePCAttr.ch_raw) + '</TD>' skip
          '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePCAttr.ch_val) + '</TD>' skip
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
          '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePCAttr.ch_raw) + '</TD>' skip
          '<TD text_wrap="true" style="text-align: center;">' + string (tt-devicePCAttr.ch_val) + '</TD>' skip
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
                                                                                                                
  run prn-lib-reportviewer-report-name in this-procedure (
    input THIS-PROCEDURE
    ,input v-file-name-rep-htm
    ).

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