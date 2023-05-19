/*
$Revision$
$Author$
$Date$
$Workfile$
$Archive$
Отчет по анализу параметров АРМ Кассира
Автор: 
Дата 
Author: 
Creation date: 
*/

define variable vss-revision as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет по анализу параметров АРМ Кассира".
{cmp\vssrevis.i }
{cmp\trg-def.i}
/*{gbl\cd-attr.i}*/
{ cmp/r-page1.i  }
{ gbl/prn-lib.i }
{ gbl/tmprecid.i "shared"}
{ gbl/cash-list.i }

FUNCTION getColor RETURNS CHARACTER
  ( isflag as char, istatus as int, isdiff as logical  )  FORWARD.
   
define temp-table tt-param  
  field CashNum          as integer
  field ParamGroup       as character case-sensitive 
  field ParamName        as character case-sensitive
  field CurrentParamName as character
  field Device           as character
  field DeviceName       as character
  field DateTime         as decimal
  field ParamSection     as character
  field SectionName      as character
  field EtalonValue      as character
  field CurrentValue     as character
  field EtalonValue_dop  as character
  field CurrentValue_dop as character
  field obj-code         as integer
  field obj-type         as character
  field obj-name         as character
  field flag             as character
  field diff             as logical
  field status_          as integer
  index pi is primary unique ParamName obj-code obj-type ParamGroup Device ParamSection CashNum
  .
  
define temp-table tt-choose-code
  field ParamName as character
  .
   
define stream OutStr-html.
define input  parameter parparentproc as handle no-undo.
define input parameter parDesk as character no-undo .
define input parameter parParam as character no-undo .
define input parameter parSource as character no-undo .
define input parameter table for tmprecid .
define input parameter table for cash-list .

define buffer buf_param for tt-param .
define buffer buf_code  for ub.Code .

define variable v-report-name-html-list as character no-undo init "cash-par.html".
define variable v-sort                  as character no-undo .
function fConvetDateTime returns character 
  (input iTStamp as dec):
   
  define variable vDateTime as datetime no-undo.
  define variable vDate     as date     no-undo.
  define variable vDays     as int64    no-undo.
  define variable vSec      as integer  no-undo.

  vDays = truncate(int64(iTStamp) / 3600 / 24, 0).
  vDate = date("01/01/1970") + vDays.
  vSec = (int64(iTStamp) - vDays * 3600 * 24).
  return string(vDate,"99/99/9999") + " " + string(vSec, "HH:MM:SS").
   
end function.

output stream OutStr-html to value(v-report-name-html-list) convert target 'UTF-8' /*no-convert*/.
put stream OutStr-html unformatted
{rep/htmlhead.i}
  '<body>' skip
  '<TABLE name="1"  fit_to_page="true" orientation="landscape" CELLSPACING="0" BORDER="0">'skip
  '<thead>' skip
  ' <tr class="set_columns">' skip
  ' <td style="width:80px"></td>' skip
  ' <td style="width:80px"></td>' skip
  ' <td style="width:80px"></td>' skip
  ' <td style="width:80px"></td>' skip
  ' <td style="width:80px"></td>' skip
  ' <td style="width:80px"></td>' skip
  ' <td style="width:80px"></td>' skip
  ' <td style="width:80px"></td>' skip
  ' <td style="width:80px"></td>' skip
  ' <td style="width:80px"></td>' skip
  '</tr>' skip
  '<tr><!-- шапка таблицы -->' skip
  '<td colspan="10" style="text-align: right;"></td>' skip
  '</tr>' skip
  '<tr>' skip
  '<td colspan="10" style="font-weight: bold; text-align: center;">Отчет по анализу параметров АРМ Кассира</td>' skip
  '</tr>' skip
  '</thead>' skip
  '<tr>' skip
  '<td text_wrap="true" style="text-align: center; border: 1px solid black;">Название АЗК/АЗС</td>' skip
  '<td text_wrap="true" style="text-align: center; border: 1px solid black;">Признак исполнения кассы</td>' skip
  '<td text_wrap="true" style="text-align: center; border: 1px solid black;">Номер кассы</td>' skip
  '<td text_wrap="true" style="text-align: center; border: 1px solid black;">Дата и время актуальной сверки</td>' skip
  '<td text_wrap="true" style="text-align: center; border: 1px solid black;">Наименование источника</td>' skip
  '<td text_wrap="true" style="text-align: center; border: 1px solid black;">Раздел/Наименование функции клавиши</td>' skip
  '<td text_wrap="true" style="text-align: center; border: 1px solid black;">Наименование параметра/Дополнительное значение эталон</td>' skip
  '<td text_wrap="true" style="text-align: center; border: 1px solid black;">Наименование параметра/Дополнительное значение текущее</td>' skip
  '<td text_wrap="true" style="text-align: center; border: 1px solid black;">Значение параметра/Степень защиты эталон</td>' skip
  '<td text_wrap="true" style="text-align: center; border: 1px solid black;">Значение параметра/Степень защиты текущее</td>' skip
  '</tr>' skip
  '<tbody>' 
  .
  
define buffer code-section        for ub.code. /*Параметры или клавиатура*/
define buffer code-group          for ub.code. /*Группы*/
define buffer code-device         for ub.code. /*Справочники*/
define buffer code-param          for ub.code. /*Параметры*/
define buffer buf_cash-param-hist for ub.cash-param-hist.   
define buffer clients             for ub.clients.   

define variable v-attr-value   as character no-undo.
define variable v-attr-type    as character no-undo.
define variable vDeviceKind    as character no-undo.
define variable cb-device-kind as integer   no-undo.
define variable mdevice        as class     ibs.th.str.cash.CashDevice
  no-undo.
define variable msection       as class     ibs.th.str.cash.CashSection
  no-undo.
mdevice = new ibs.th.str.cash.CashDevice().
msection = new ibs.th.str.cash.CashSection().

if parParam = "choose" then 
do:
  for each tmprecid no-lock where tmprecid.fTable = "code":
    for first ub.Code no-lock where recid(ub.Code) = tmprecid.Frecid:
      create tt-choose-code.
      tt-choose-code.ParamName = ub.Code.code .
    end.
  end.
end. 
        
for each obj-list:
  for each cash-list no-lock where cash-list.obj-code = obj-list.obj-code:
    for each buf_cash-param-hist where buf_cash-param-hist.obj-code = obj-list.obj-code and
      buf_cash-param-hist.obj-type = obj-list.obj-type and
      buf_cash-param-hist.cash-num = cash-list.cash-num:
      if parDesk <> "-1" then 
        if lookup(string(buf_cash-param-hist.device), parDesk, ",") = 0 then next .
      if parParam = "choose" then 
      do:
        if not can-find (first tt-choose-code where tt-choose-code.ParamName = buf_cash-param-hist.param_name) then next . 
      end.  
      create tt-param .
      assign
        tt-param.obj-code     = buf_cash-param-hist.obj-code
        tt-param.obj-type     = buf_cash-param-hist.obj-type
        tt-param.CashNum      = buf_cash-param-hist.cash-num
        tt-param.ParamGroup   = buf_cash-param-hist.param_group
        tt-param.ParamName    = buf_cash-param-hist.param_name
        tt-param.CurrentValue = buf_cash-param-hist.param_value
        tt-param.Device       = string(buf_cash-param-hist.device)
        tt-param.ParamSection = buf_cash-param-hist.param_section
        tt-param.DateTime     = buf_cash-param-hist.tstamp
        tt-param.flag         = "current"
        tt-param.DateTime     = buf_cash-param-hist.tstamp
        .
      tt-param.DeviceName   = mdevice:GetLabel(buf_cash-param-hist.device).
      tt-param.SectionName   = msection:GetLabel(int(buf_cash-param-hist.param_section)).
      tt-param.CurrentValue_dop = buf_cash-param-hist.param_value_dop.
      tt-param.CurrentParamName = buf_cash-param-hist.param_name .
    
      find first clients no-lock where clients.obj-code = tt-param.obj-code and
        clients.obj-type = tt-param.obj-type no-error .
      if available (clients) then tt-param.obj-name = clients.obj-name .
    end.
  end.
end.

/* Признаки исполнения кассы */
for each code-device where code-device.parent = "cash-param" no-lock:
  if parDesk <> "-1" then 
    if lookup(string(code-device.code), parDesk, ",") = 0 then next .
  /* Параметры или клавиатура */
  for each code-section where code-section.parent = code-device.parent + {&delim-par} + code-device.code no-lock:
    /*Группы*/
    for each code-group where code-group.parent = code-section.parent + {&delim-par} + code-section.code no-lock:
      /* Параметры детально */
      for each code-param where code-param.parent = code-group.parent + {&delim-par} + code-group.code no-lock:
        if parParam = "choose" then 
        do:
          if not can-find (first tt-choose-code where tt-choose-code.ParamName = code-param.code) then next . 
        end. 
        for each obj-list:
          for each cash-list where cash-list.obj-code = obj-list.obj-code:
            find first tt-param exclusive-lock where tt-param.ParamGroup = code-group.code and 
              tt-param.Device =  code-device.code and
              tt-param.obj-code = obj-list.obj-code and
              tt-param.obj-type = obj-list.obj-type and
              tt-param.ParamName = code-param.code and
              tt-param.ParamSection = code-section.code and
              tt-param.CashNum = cash-list.cash-num no-error .
            if not available (tt-param) then 
            do:
              create tt-param .
              assign
                tt-param.obj-code     = obj-list.obj-code
                tt-param.obj-type     = obj-list.obj-type
                tt-param.ParamGroup   = code-group.code
                tt-param.Device       = code-device.code
                tt-param.ParamSection = code-section.code
                tt-param.ParamName    = code-param.code
                tt-param.flag         = "etalon"
                tt-param.diff         = true
                tt-param.CashNum      = cash-list.cash-num
                .
              tt-param.DeviceName   = mdevice:GetLabel(int(code-device.code)) .      
              tt-param.SectionName  =  msection:GetLabel(int(code-section.code)).   
            end.
            else tt-param.flag = "" .
            assign
              tt-param.EtalonValue     = code-param.CodeValue
              tt-param.EtalonValue_dop = code-param.code
              tt-param.status_         = code-param.status_
              .
            if tt-param.CurrentValue <> tt-param.EtalonValue and tt-param.flag = "" then tt-param.diff = true .
            if tt-param.SectionName <> "Параметры" then 
            do:
              for first buf_code exclusive-lock where buf_code.code = tt-param.ParamGroup and buf_code.parent = "cashFunKey":
                tt-param.ParamGroup = buf_code.code + " " + buf_code.misc1 + " " + buf_code.CodeName .
              end.
            end.
            find first clients no-lock where clients.obj-code = tt-param.obj-code and
              clients.obj-type = tt-param.obj-type no-error .
            if available (clients) then tt-param.obj-name = clients.obj-name .
          end.
        end.  
      end.
    end.   
  end.
end.

case parParam:
  when "mandatory" then 
    do:
      for each tt-param exclusive-lock where tt-param.flag = "current" or (tt-param.status_ = {&bef-deleted-status-int} and tt-param.flag <> "current"):
        delete tt-param .
      end. 
    end.
  when "optional" then 
    do:
      for each tt-param exclusive-lock where tt-param.flag = "current" or (tt-param.status_ = {&bef-current-status-int} and tt-param.flag <> "current"):
        delete tt-param .
      end.     
    end.
end.

define variable v-first as logical   no-undo .
define variable v-color as character no-undo .

if parSource <> "keyboard" then 
do:
  for each tt-param no-lock where tt-param.SectionName = "Параметры" by tt-param.SectionName by tt-param.obj-code  by tt-param.DateTime by tt-param.cashNum:
    if not v-first then 
    do:
      put stream OutStr-html unformatted
        '<tr>' skip
        '<td colspan="10" text_wrap="true" style="">' tt-param.SectionName '</td>' skip 
        '</tr>' skip
        .    
    end.
    v-first = true .
    v-color = getColor(tt-param.flag, tt-param.status_, tt-param.diff) .
    put stream OutStr-html unformatted
      '<tr>' skip
      '<td text_wrap="true" style="background-color: ' + v-color + ';">' tt-param.obj-name  '</td>' skip
      '<td text_wrap="true" style="background-color: ' + v-color + ';">' tt-param.DeviceName '</td>' skip
      '<td text_wrap="true" style="background-color: ' + v-color + ';">' tt-param.CashNum '</td>' skip
      '<td text_wrap="true" style="background-color: ' + v-color + ';">' fConvetDateTime(tt-param.DateTime) '</td>' skip
      '<td text_wrap="true" style="background-color: ' + v-color + ';">' tt-param.SectionName '</td>' skip
      '<td text_wrap="true" style="background-color: ' + v-color + ';">' tt-param.ParamGroup '</td>' skip
      '<td text_wrap="true" style="background-color: ' + v-color + ';">' tt-param.EtalonValue_dop '</td>' skip
      '<td text_wrap="true" style="background-color: ' + v-color + ';">' tt-param.CurrentParamName '</td>' skip   
      '<td text_wrap="true" style="background-color: ' + v-color + ';">' tt-param.EtalonValue '</td>' skip
      '<td text_wrap="true" style="background-color: ' + v-color + ';">' if v-color = "orange" then "Параметр отсутствует" else tt-param.CurrentValue '</td>' skip   
      /*        '<td text_wrap="true" style="">' tt-param.flag '</td>' skip   */
      /*        '<td text_wrap="true" style="">' tt-param.diff '</td>' skip   */
      /*        '<td text_wrap="true" style="">' tt-param.status_ '</td>' skip*/
      '</tr>' skip
      .
  end.
end.
v-first = false .
if parSource <> "param" then 
do:
  for each tt-param no-lock where tt-param.SectionName <> "Параметры" by tt-param.SectionName by tt-param.obj-code  by tt-param.DateTime by tt-param.cashNum:
    if not v-first then 
    do:
      put stream OutStr-html unformatted
        '<tr>' skip
        '<td colspan="10" text_wrap="true" style="">' tt-param.SectionName '</td>' skip 
        '</tr>' skip
        .    
    end.  
    v-first = true .
    v-color = getColor(tt-param.flag, tt-param.status_, tt-param.diff) .
    put stream OutStr-html unformatted
      '<tr>' skip
      '<td text_wrap="true" style="background-color: ' + v-color + ';">' tt-param.obj-name  '</td>' skip
      '<td text_wrap="true" style="background-color: ' + v-color + ';">' tt-param.DeviceName '</td>' skip
      '<td text_wrap="true" style="background-color: ' + v-color + ';">' tt-param.CashNum '</td>' skip
      '<td text_wrap="true" style="background-color: ' + v-color + ';">' fConvetDateTime(tt-param.DateTime) '</td>' skip
      '<td text_wrap="true" style="background-color: ' + v-color + ';">' tt-param.SectionName '</td>' skip
      '<td text_wrap="true" style="background-color: ' + v-color + ';">' tt-param.ParamGroup '</td>' skip
      '<td text_wrap="true" style="background-color: ' + v-color + ';">' tt-param.EtalonValue_dop '</td>' skip
      '<td text_wrap="true" style="background-color: ' + v-color + ';">' tt-param.CurrentValue_dop '</td>' skip   
      '<td text_wrap="true" style="background-color: ' + v-color + ';">' tt-param.EtalonValue '</td>' skip
      '<td text_wrap="true" style="background-color: ' + v-color + ';">' if v-color = "orange" then "Параметр отсутствует" else tt-param.CurrentValue '</td>' skip   
      /*        '<td text_wrap="true" style="">' tt-param.flag '</td>' skip   */
      /*        '<td text_wrap="true" style="">' tt-param.diff '</td>' skip   */
      /*        '<td text_wrap="true" style="">' tt-param.status_ '</td>' skip*/
      '</tr>' skip
      .

  end.    
end.

put stream OutStr-html unformatted
  '<tbody>' skip
  '</table>'
  .

output stream OutStr-html close.   
run prn-lib-reportviewer in this-procedure (
  input parparentproc
  ,input v-report-name-html-list
  ,input "" 
  ) no-error.
if error-status:error then
do:
  message return-value view-as alert-box.
  return .
end.



FUNCTION getColor RETURNS CHARACTER
  ( isflag as char, istatus as int, isdiff as logical ):
  case istatus:
    when {&bef-deleted-status-int} then /*обязательный*/ 
      do:
        if isflag = "etalon" then return "orange" .
        else if isdiff then return "red" .
          else return "white" .
      end.
    when {&bef-current-status-int} then 
      do:
        if isflag = "etalon" then return "red" .
        else if isflag = "current" then return "yellow" .
          else return "white" .
      end.
  end case.
end.

/*output to tt-param.txt .*/
/*                        */
/*for each tt-param:      */
/*  export tt-param .     */
/*end.                    */
/*output close .          */