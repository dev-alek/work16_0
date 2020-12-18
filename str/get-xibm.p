/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Программа приема чеков с касс IBM-XML, MAGIA-XML, AUTOTANK

Автор: Бахтадзе Наталья Викторовна
Дата создания: 10/13/05
Author: Bakhtadze Natalya
Creation date: 10/13/05

На объекте:

 читает поочередно полученные спул-файлы

*/

define input parameter parparentproc as handle no-undo . /* в тексте get-xibm.p не встречается */
define input parameter p-log-handle  as handle no-undo .
define input parameter p-obj-type like ub.clients.obj-type no-undo .
define input parameter p-obj-code like ub.clients.obj-code no-undo .
define input parameter p-host-code like ub.sysconf.host-code no-undo .
define input parameter p-pos-type as character no-undo .
define input parameter p-encoding as character no-undo .
DEFINE INPUT PARAMETER file_ as character no-undo.
define input parameter p-spool-or-data as character no-undo .
define input-output parameter p-view-log as logical  no-undo .

DEFINE VARIABLE vss-revision    as character no-undo init "$Revision$":u .
DEFINE VARIABLE vss-author      as character no-undo init "$Author$":u .
DEFINE VARIABLE vss-date        as character no-undo init "$Date$":u .
DEFINE VARIABLE vss-workfile    as character no-undo init "$Workfile$":u .
DEFINE VARIABLE vss-archive     as character no-undo init "$Archive$":u .
DEFINE VARIABLE vss-description as character no-undo init "Программа приема чеков с касс IBM-XML" .
{ cmp/vssrevis.i }
{ str/get-chk.i }
/*общие для кассовой части и чековой*/


{ str/get-chkc.i def }
{ gbl/key-rec.i }
/*только чековая часть*/
{ gbl/xmlparse.i }
{ gbl/xmlvalid.i }
{ str/chkdocat.i }
define stream stmXMLOut.
{ str/cd-xml.i }
{ cmp/bitoper.i }
{ str/magiachk.i }
{ str/magiachk.i -line " extent 2 "}
{ str/magiachk.i proc }
/*{ gbl/thbj-def.i } 14/II-2019 - подключается внутри str/get-chkc.i */

DEFINE VARIABLE n-entry                    as   char no-undo extent 20.
DEFINE VARIABLE accept-types               as   character no-undo .
define variable v-flag-salesman            as   logical   no-undo .
define variable v-flag-card              as   logical   no-undo .
define variable cstype_                    as   integer   no-undo .
define variable v-start-check as integer no-undo .
define variable v-record-name as character no-undo .
define variable v-last-date as date no-undo .
define variable v-last-time as integer no-undo .
define variable v-last-shift-num as integer no-undo .
define variable v-last-z-count as integer no-undo .
define variable v-last-chk-num as integer no-undo .
define variable v-exit-processing as logical no-undo .
define variable v-create-return-write-off as logical no-undo .
define variable v-write-off-code-2 as integer   no-undo .
define variable v-is-without-payment as logical no-undo .
define variable v-chk-type as integer no-undo extent 2.
define variable v-to-delete as logical no-undo extent 2.
define variable ret-chk as character no-undo .
define variable kriv3 as logical no-undo .
define variable p-second-mode as character no-undo .
define variable v-is-petrol-check          as logical no-undo .
define variable autotank-pay-list as character no-undo .
define variable autotank-sum-return as decimal no-undo .
define variable v-doc-code like ub.chk-doc.doc-code no-undo .
define variable spool-date_ as date no-undo .
define variable spool-time_ as integer no-undo .
define variable v-eff-date as date no-undo .
define variable v-eff-time as integer no-undo .
define variable v-oss-code as character no-undo init "".
define variable price-old as decimal no-undo .
define variable disc-d-card as character no-undo.
define variable ibm-ccm as integer no-undo.

define buffer buf_ext-classif for ub.ext-classif.

define temp-table temp-cash-desk no-undo
field last-date like ub.chk-doc.chk-date
field last-time like ub.chk-doc.chk-time
field last-shift-num like ub.chk-doc.shift-num
field last-z-count like ub.chk-doc.z-number
field last-chk-num like ub.chk-doc.chk-num
field cash-num like ub.cash-desk.cash-num
index pi is unique primary
cash-num.

define temp-table achd no-undo
field num as integer
field chk-date as date
field chk-time as integer
field obj-type as character
field obj-code as integer
field pay-desk as integer
field src-code as character
field pump as integer
field nozzle-code as integer
field src-qnty as decimal
field trans-num as integer
index pi is unique primary
num.

define temp-table ache no-undo
field chk-date as date
field chk-time as integer
field total-exp as decimal
field month-exp as decimal
field day-exp as decimal
field src-code as character
index pi is unique primary
src-code
.
{ str/cd-xmlg.i spool data }

FUNCTION fdecimal returns decimal
                                          ( input p-str-value as character
                                          ) :
define variable v-dec as decimal no-undo .
  CASE v-dec-sep:
    when {&comma-char} then do:
      assign
      v-dec = decimal(replace(p-str-value, {&comma-char}, ".":U))
      no-error
      .
    end.
    when ".":U then do:
      assign
      v-dec = decimal(p-str-value)
      no-error
      .
    end.
    otherwise  do:
      assign
      v-dec = ?
      .
    end.
  END CASE.
  return v-dec.
END FUNCTION.


FUNCTION convert-pay-code returns integer
                                          ( input p-pos-type as character
                                           ,input p-pos-pay-code as integer
                                           ,output p-curr-code as integer
                                          ) :
define variable v-pay-code as integer no-undo .
define variable v-ii as integer no-undo .
define variable v-entry as character no-undo .
define buffer buf_currency for ub.currency.
define buffer buf_cash-pay for ub.cash-pay.
case p-pos-type:
  when {&cd-type-autotank} then do:
    do v-ii = 1 to num-entries(autotank-pay-list, ";"):
      v-entry = entry(v-ii, autotank-pay-list, ";").
      if entry(1, entry(1, v-entry, {&slash-char}), {&comma-char}) = string(p-pos-pay-code) then do:
        assign
        v-pay-code = integer(entry(1, entry(2, v-entry, {&slash-char}), {&comma-char}))
        p-curr-code = integer(entry(2, entry(2, v-entry, {&slash-char}), {&comma-char}))
        .
        return v-pay-code.
      end.
    end.
    return v-pay-code.
  end.
  when {&cd-type-magia-xml} then do:
/*очевидно см putc-31.i*/
    if p-pos-pay-code < 1000 then do:
      if p-pos-pay-code = 1 then do:
    assign
    p-curr-code = 0
     .
        return p-pos-pay-code.
  end.
  find first buf_currency no-lock where
                buf_currency.okv-code = p-pos-pay-code no-error .
  if not avail buf_currency then do:
    assign
    p-curr-code = - 1
    .
    return (- 1).
  end.
  assign
  p-curr-code = buf_currency.curr-code
  .
  return 1.
end.
else do:
  assign
      v-pay-code = p-pos-pay-code - 10000
  .
  find buf_cash-pay no-lock where
       buf_cash-pay.cdpay-code = v-pay-code no-error .
  if not available buf_cash-pay then do:
    assign
    p-curr-code = - 1
    .
    return (- 1).
  end.
  assign
  p-curr-code = buf_cash-pay.curr-code
  .
  return buf_cash-pay.cdpay-code.
end.
  end. /*when cd-type-magia-xml*/
end case.
END FUNCTION.

assign
shop-type = p-obj-type
shop-code = p-obj-code
.

if num-entries(p-spool-or-data, {&delim-par} ) > 1 then do:
  assign
  p-second-mode = entry(2, p-spool-or-data, {&delim-par} )
  p-spool-or-data = entry(1, p-spool-or-data, {&delim-par} )
  .
 end.
{ str/get-chkc.i run }
get-chkc_context.pos-type = p-pos-type.

process events.
RUN get-xml-ibm-c(input file_) no-error .
if error-status :error
then do:
    run write-log-and-file in p-log-handle (
          input 1
        , input log-file-name
        , input 1
        , input substitute( "!!!Ошибка при обработке файла &1: &2"
                            , file_
                            , return-value
                          )
                                         ).
  assign
  p-view-log = yes
  .
  undo, return .
end.
if entry(1, p-second-mode) = "version" then do:
  do transaction:
  define variable v-rowid as rowid no-undo .
  define variable v-tbl-name as character no-undo .
  define buffer locked_cash-desk for ub.cash-desk.
  run gen-row-keyr in this-procedure
      ( input  replace(p-second-mode, "version,", "")
       ,input ?
       ,input "ub":U
       ,input ?
       ,input share-lock
       ,output v-rowid
       ,output v-tbl-name
      ) no-error .

  find first locked_cash-desk share-lock where
        rowid(locked_cash-desk) = v-rowid.
  if v-from <> substitute('&1&2_касса&3', {&shop}, locked_cash-desk.obj-code, locked_cash-desk.cash-num) then do:
      run write-log-and-file in p-log-handle (
            input 1
          , input log-file-name
          , input 1
          , input substitute("!!!ОШИБКА! Запрашивалась версия ПО &1&2_касса&3, а получена версия ПО для &4."
                            , {&shop}
                            , locked_cash-desk.obj-code
                            , locked_cash-desk.cash-num
                            , v-from
                              )).
      assign
      p-view-log = yes
      .
  end.
  else  if locked_cash-desk.version <> v-pos-version then do:
    assign
    locked_cash-desk.version = v-pos-version
    .
    release locked_cash-desk no-error .
    if not error-status:error then do:
      run write-log-and-file in p-log-handle (
            input 1
          , input log-file-name
          , input 1
          , input substitute("!!!Внимание! Для &1 версия ПО принимается равной &2."
                            , v-from
                            , v-pos-version
                              )).
      assign
      p-view-log = yes
      .
    end.
  end.
  end. /*transa*/
end.


PROCEDURE get-ibm-parameters:
define variable ret-item as character no-undo .
define variable wro-item as character no-undo .
define variable wro-chk as character no-undo .
define variable ret-ord as character no-undo .
define variable wro-ord as character no-undo .
define variable ii as integer no-undo .
define variable v-param-type as character no-undo .
define variable v-value-character as character no-undo .
define variable v-value-date as date no-undo .
define variable v-value-decimal as decimal no-undo .
define variable v-value-integer as INTEGER no-undo .
define variable v-value-logical AS LOGICAL no-undo .
define variable v-tth as handle no-undo .
assign
v-tth = buffer thbjattr_thbj-attr:table-handle .

define buffer buf_tt-sum-grp for tt-sum-grp.
if get-chkc_context.shift-on and not get-chkc_context.cas-shft then do:
  run write-log-and-file in p-log-handle (
        input 1
      , input log-file-name
      , input 1
      , input substitute("!!!Внимание! На объекте &1&2 требуется использование смен, а настройка СМЕНЫ НА КАССЕ выключена - это недопустимо."
                         , get-chkc_context.obj-type
                         , get-chkc_context.obj-code
                          )).
  assign
  p-view-log = yes
  .
  undo, return .
end.

get-chkc_context.ibmgroup = ibmgroup.
if get-chkc_context.t-shft > 0 and get-chkc_context.shift-on = yes then do:
  run write-log-and-file in p-log-handle (
        input 1
      , input log-file-name
      , input 1
      , input substitute("!!!Внимание! На объекте &1&2 требуется использование смен,&3" +
                          "а настройка СМЕЩЕННЫЕ СМЕНЫ НА КАССЕ&3" +
                          "(АРМ Администратор - Справочники - Магазины - Параметры - время начала пересменки)&3" +
                          "включена - это недопустимо."
                         , get-chkc_context.obj-type
                         , get-chkc_context.obj-code
                         , {&new-line}
                          )).
  assign
  p-view-log = yes
  .
  undo, return .
end.
if get-chkc_context.is-wth = yes then do:
  accept-types =  "1,2,3,4,5,6,7,13,40,43,44":U.
end.
else do:
  accept-types =  "1,6,13,40,43,44":U.
end.
dflt-cd = p-pos-type.
if get-chkc_context.is-ptrl
and get-chkc_context.ptrl-check then
assign
accept-types = accept-types + ",14,15,16,17":U.

if is-ptrl and ptrl-check 
and (p-pos-type = {&cd-type-ibm-xml} or p-pos-type = {&cd-type-Autotank})
then
assign
accept-types = accept-types + ",36":U.

if p-pos-type = {&cd-type-MAGIA-XML}
or get-chkc_context.annu-check then
assign
accept-types = accept-types + ",8":U
. /*аннулированный чек*/
if get-chkc_context.z-check then
assign
accept-types = accept-types + ",12":U
. /*чек z-отчета*/

if get-chkc_context.is-cdinv then accept-types = accept-types + ",11":U.
if p-pos-type = {&cd-type-magia-XML} then do:
for each thbjattr_thbj-attr:
  delete thbjattr_thbj-attr.
end.
run adm/shattri.p (
    input "get":U
    ,input  p-obj-type
    ,input  p-obj-code
    ,input  {&attr-cd-type-magia-xml}
    ,input  '':U /*p-param-code*/
    ,output v-value-character
    ,output v-value-date
    ,output v-value-decimal
    ,output v-value-integer
    ,output v-value-logical
    ,output v-param-type
    ,INPUT-OUTPUT table-handle v-tth
    ) no-error .
IF error-status:error then do:
  run write-log-and-file in p-log-handle (
        input 1
      , input log-file-name
      , input 1
      , input  substitute(
                        "Не удалось получить настройки для  POS типа &1 для маг&2"
                        , {&cd-type-magia-xml}
                        , p-obj-code)
                                        ).
  assign
  v-cd-fatal-error = yes
  v-cd-fatal-message = "неверные настройки"
  p-view-log = yes
  .
  return "error".
end.
for each thbjattr_thbj-attr where
        thbjattr_thbj-attr.obj-type = p-obj-type
    and thbjattr_thbj-attr.obj-code = p-obj-code
    and thbjattr_thbj-attr.upper-prop-code =  {&attr-cd-type-magia-xml}
on error undo, return error :
  case thbjattr_thbj-attr.prop-code :
    when {&attr-cd-type-magia-xml_ret-item} then do:
      assign
      ret-item = thbjattr_thbj-attr.property-value-character.
    end.
    when {&attr-cd-type-magia-xml_wro-item} then do:
      assign
      wro-item = thbjattr_thbj-attr.property-value-character.
    end.
    when {&attr-cd-type-magia-xml_wro-chk} then do:
      assign
      wro-chk = thbjattr_thbj-attr.property-value-character.
    end.
    when {&attr-cd-type-magia-xml_ret-chk} then do:
      assign
      ret-chk = thbjattr_thbj-attr.property-value-character.
    end.
    when {&attr-cd-type-magia-xml_wro-ord} then do:
      assign
      wro-ord = thbjattr_thbj-attr.property-value-character.
    end.
    when {&attr-cd-type-magia-xml_ret-ord} then do:
      assign
      ret-ord = thbjattr_thbj-attr.property-value-character.
    end.
  end case.
end.
  run create-temp-ivs-ibs-line in this-procedure (
                                                    input ret-item
                                                   ,input wro-item
                                                   ,input ret-chk
                                                   ,input wro-chk
                                                   ,input ret-ord
                                                   ,input wro-ord ) .
/*
output to jj.txt.
for each temp-ivs-ibs:
export temp-ivs-ibs.
end.
output close.
*/


end.
if p-pos-type = {&cd-type-ibm-xml} then do :
    run adm/shattri.p (
        input "get":U
        ,input  p-obj-type
        ,input  p-obj-code
        ,input  {&attr-cd-type-ibm-xml}
        ,input  {&attr-cd-type-ibm-xml_ibm-ccm} /*p-param-code*/
        ,output v-value-character
        ,output v-value-date
        ,output v-value-decimal
        ,output v-value-integer
        ,output v-value-logical
        ,output v-param-type
        ,INPUT-OUTPUT table-handle v-tth
        ) no-error .
    IF not error-status:error then do:
      delete object v-tth.
      ibm-ccm = v-value-integer.
    end.
    else do:
      ibm-ccm = ?.
      delete object v-tth.
      return error return-value .
    end.
end.
if (p-pos-type = {&cd-type-ibm-xml} or p-pos-type = {&cd-type-Autotank}) and get-chkc_context.ibmgroup then do:
  for each buf_tt-sum-grp:
    delete buf_tt-sum-grp.
  end.
  do ii = 1 to num-entries(specgrp, ';'):
    create buf_tt-sum-grp.
    assign
    buf_tt-sum-grp.grp-code = integer(entry(1, entry(ii, specgrp, ';'), '-':U))
    buf_tt-sum-grp.code-2 = integer(entry(2, entry(ii, specgrp, ';'), '-':U))
    no-error
    .
    if error-status:error then do:
      delete buf_tt-sum-grp.
    end.
  end.
end.
if p-pos-type = {&cd-type-autotank} then do:
  for each thbjattr_thbj-attr:
    delete thbjattr_thbj-attr.
  end.
  run adm/shattri.p (
      input "get":U
      ,input  p-obj-type
      ,input  p-obj-code
      ,input  {&attr-cd-type-autotank}
      ,input  '':U /*p-param-code*/
      ,output v-value-character
      ,output v-value-date
      ,output v-value-decimal
      ,output v-value-integer
      ,output v-value-logical
      ,output v-param-type
      ,INPUT-OUTPUT table-handle v-tth
      ) no-error .
  IF error-status:error then do:
    run write-log-and-file in p-log-handle (
          input 1
        , input log-file-name
        , input 1
        , input  substitute(
                          "Не удалось получить настройки для  POS типа &1 для маг&2"
                          , {&cd-type-magia-xml}
                          , p-obj-code)
                                          ).
    assign
    v-cd-fatal-error = yes
    v-cd-fatal-message = "неверные настройки"
    p-view-log = yes
    .
    return "error".
  end.
  for each thbjattr_thbj-attr where
          thbjattr_thbj-attr.obj-type = p-obj-type
      and thbjattr_thbj-attr.obj-code = p-obj-code
      and thbjattr_thbj-attr.upper-prop-code =  {&attr-cd-type-autotank}
  on error undo, return error :
    case thbjattr_thbj-attr.prop-code :
      when {&attr-cd-type-Autotank_cash-pay-list} then do:
        assign
        autotank-pay-list = thbjattr_thbj-attr.property-value-character.
      end.
    end case.
  end.
end. /*if p-pos-type = {&cd-type-autotank} then do:*/
END PROCEDURE.



procedure proc-00 :
define variable is-shift-date as logical no-undo .
define variable prev-code2 like ub.chk-doc.doc-code no-undo .
define variable netto-sum2_ as decimal no-undo .
define variable iexist as integer no-undo .
define variable v-new as character no-undo .
define variable v-old as character no-undo .
define variable v-step as integer   no-undo .
define buffer buf_temp-temp for temp-temp.
define buffer buf_chk-doc for ub.chk-doc.
define variable vCHNumberKKT       as character no-undo.
define variable vCHFiscalDocSign   as character no-undo . /* Фискальный признак документа. Тег 1077. Строка из 6 символов. */
define variable vCHFiscalDocNumber as integer no-undo .   /* Номер фискального документа. Тег 1040. Целое число, порядковый номер ФД с момента регистрации (перерегистрации) ККТ. */

do
on error undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
:

  find first buf_temp-temp no-lock where
            buf_temp-temp.record-name = "CHead"
        AND buf_temp-temp.field-name = "CHType"
        AND buf_temp-temp.id = v-id
        no-error .
  if not available buf_temp-temp then do:
    assign
    v-start-check = 0
    .
    return.
  end.
  assign
  prev-gbl-type = ''
  gbl-type = string(integer(buf_temp-temp.field-value))
  no-error .
  if error-status:error then do:
    {&error-in-file-format}
  end.
  /*перепишем в переменные общие для всех  обрабатываемых нами типов чеков данные!!!!*/
  if can-do(accept-types,  gbl-type ) then do:
    assign
    chk-date_ = 01/01/1990
    chk-time_ = 0
    shift-date_ = chk-date_
    shift-num_ = 0
    shift-name_ = ''
    shift-open-time_ = 0
    shop-code = p-obj-code
    shop-type = {&shop}
    sales-man_ = 0
    cashier_ = 0
    pay-desk_ = 0
    z-num_ = 0
    cash-rate_ = 0
    d-card_ = "":U
    d-mask_ = "":U
    tot-d-pcnt = 0
    doc-num_ = "":U
    doc-num2_ = "":U
    chk-num_ = 0
    netto-sum_ = 0
    AuthType_ = 0
    qr-alchol_ = "":u
    brutto-sum_ = 0
    v-flag-salesman  = no
    v-flag-card = no
    d-mask_ = "":U
    cli-type_ = "":U
	price-old = 0
    cli-code_ = 0
    v-chk-type[1] = 0
    v-chk-type[2] = 0
    v-is-petrol-check = no
    cstCode = ""
    cstValue = 0
    no-error
    .
    _buf_temp:
    for each buf_temp-temp no-lock where
            buf_temp-temp.record-name = "CHead":U
       AND buf_temp-temp.id = v-id:
      CASE buf_temp-temp.field-name:
        when "CHMode":U then do:
          assign
          iexist = int(buf_temp-temp.field-value)
          no-error .
          if not error-status:error
          and (not (iexist = 1
                  or
                  (iexist = 2 and get-chkc_context.annu-check)
               ))
          then do:
            assign
            exist = yes
            mc-exist = yes
            .
            return .
          end.
          if iexist = 2 then do:
            assign
            prev-gbl-type = gbl-type
            gbl-type = '8'.
          end.
        end.
        when "CHNum":U then do:
          assign
          chk-num_ = integer(buf_temp-temp.field-value)
          no-error .
        end.
        when "CHDate":U then do:
          assign
          chk-date_ =  cb-xmlparse-get-date( buf_temp-temp.field-value)
          chk-time_ =  cb-xmlparse-get-time( buf_temp-temp.field-value)
          no-error .
        end.
        when "CHShop":U then do:
          assign
          shop-code = if get-chkc_context.hnum
                      then int(buf_temp-temp.field-value)
                      else shop-code
          shop-type = {&shop}
          no-error .
        end.
        when "CHCashNum":U then do:
          assign
          pay-desk_ = int(buf_temp-temp.field-value)
          no-error
          .
        end.
        when "CHCashier":U then do:
          assign
          cashier_ = int(buf_temp-temp.field-value)
          no-error
          .
        end.
        when "CHZcount":U then do:
          assign
          z-num_ = integer(buf_temp-temp.field-value)
          no-error
          .
        end.
        when "CHSBeg":U then do:
          assign
          shift-date_ = cb-xmlparse-get-date(buf_temp-temp.field-value)
          is-shift-date = yes
          shift-open-time_ = cb-xmlparse-get-time( buf_temp-temp.field-value)
          no-error .
        end.
        when "CHSNum":U then do:
          assign
          shift-name_ = buf_temp-temp.field-value
          shift-num_ = integer(buf_temp-temp.field-value)
          no-error
          . /*здесь оставляем sift-num_!!! чтобы проверить на int*/
        end.
        when "CHRate":U then do:
          assign
          cash-rate_ = fdecimal(buf_temp-temp.field-value)
          no-error
          .
        end.
        when "CHDoc":U then do:
            run xmlchar-decode in this-procedure (
                  input trim(buf_temp-temp.field-value)
                , output doc-num_
            ) no-error.
        end.
        when "CHBrutto":U then do:
          assign
          brutto-sum_ = fdecimal(buf_temp-temp.field-value)
          no-error .
        end.
        when "CHNetto":U then do:
          assign
          netto-sum_ = fdecimal(buf_temp-temp.field-value)
          no-error .
        end.
        when "CAuthorization":U then do:
          CASE buf_temp-temp.field-name:
              when "CAuthType mes":U then do:
                assign
                AuthType_ = fdecimal(buf_temp-temp.field-value)
                no-error .
              end.
              when "CAuthUrl mes":U then do:
                run xmlchar-decode in this-procedure (
                      input trim(buf_temp-temp.field-value)
                    , output qr-alchol_
                ) no-error.
              end.
          end case.
        end.
        when "CSClient":U then do:
          if p-pos-type = {&cd-type-magia-xml} then
          assign
          cli-code_ = integer(buf_temp-temp.field-value)
          cli-type_ = if cli-code_ > 9999999999 then {&cmp} else {&prs}
          no-error .
        end.
        when "CSCCardN":U then do:
          if p-pos-type = {&cd-type-magia-xml} then
          assign
          d-card_ = (if buf_temp-temp.field-value = "0" then "":u else buf_temp-temp.field-value)
          no-error .
        end.
        when "CHAgreement":U then do:
          if p-pos-type = {&cd-type-ibm-xml} OR p-pos-type = {&cd-type-Autotank} then
          assign
          doc-num2_ = (if buf_temp-temp.field-value = "0" then "":u else buf_temp-temp.field-value)
          no-error .
        end.
        when "CHNumberKKT":U then do:
          vCHNumberKKT = buf_temp-temp.field-value no-error .
        end.
        when "CHFiscalDocSign":U then do :
          vCHFiscalDocSign = buf_temp-temp.field-value no-error .
        end .
        when "CHFiscalDocNumber":U then do :
          vCHFiscalDocNumber = integer(buf_temp-temp.field-value) no-error .
        end .
        /*    todo
        when "CHSEnd":U then do:
        end.
        */
        /*
        todo - см proc-02-gds
        when "CHDiscnt":U then do:
          if p-pos-type = {&cd-type-MAGIA-XML} then
          run proc-02-gds in this-procedure (decimal(buf_temp-temp.field-value)) no-error .
        end.
        */
        otherwise do:
          error-status:error = no.
        end.
      END CASE.
      if error-status:error then do:
        {&error-in-file-format}
      end.
    END.
  end. /*если 1,2,3,4,5,6,7,12,13*/
  else do:
    /*какие-то неизвестные нам виды чеков*/
    assign
    exist = yes
    mc-exist = yes
    . /* Предпологаем что уже есть в базе */
    return.
  end.
  /* 14/II-2019 следущие три проверки выглядят избыточными
  assign
  shift-date_ = (if cas-shft
                 then shift-date_
                 else chk-date_)
  shift-num_ = (if cas-shft
                then shift-num_
                else 0)
  shift-open-time_ = (if cas-shft
                     then shift-open-time_
                     else 0)
  .
  */
  if cas-shft then . else assign
    shift-date_      = chk-date_
    shift-num_       = 0
    shift-open-time_ = 0
  .

   find first ub.cash-desk no-lock where
                ub.cash-desk.cash-num = pay-desk_
          AND ub.cash-desk.obj-code = p-obj-code no-error.
  If not available  ub.cash-desk
  then do:
      assign
          p-view-log = yes
          .
      run write-log-and-file in p-log-handle (
                input 1
              , input log-file-name
              , input 1
              , input substitute( "!!!При обработке файла произошла ошибка. На объекте &1 нет кассы с номером &2", p-obj-code, pay-desk_
                                                                  
                                )
                                                ).
          undo, return .
  end.
              
  If available  ub.cash-desk and   cash-desk.pos-type = p-pos-type then.
  else do:       
      p-pos-type =  ub.cash-desk.pos-type. 
      run get-ibm-parameters in this-procedure no-error.
      if error-status:error then do:
          assign
          p-view-log = yes
          .
          run write-log-and-file in p-log-handle (
                input 1
              , input log-file-name
              , input 1
              , input substitute( "!!!При обработке файла &1 произошла ошибка при получении значений настроечных параметров"
                                                                  
                                )
                                                ).
          undo, return .
        end.
  end.
  find first temp-cash-desk where
           temp-cash-desk.cash-num = (if p-pos-type = {&cd-type-autotank} then 0 else pay-desk_) no-error.
  if not available temp-cash-desk then do:

    if p-pos-type = {&cd-type-magia-xml} then
    run get-last-check-date-time in this-procedure (
                                                            input g#db-num
                                                            ,input p-obj-code
                                                            ,input p-pos-type
                                                            ,input pay-desk_
                                                            ,output v-last-date
                                                            ,output v-last-time) no-error.
    else
    run get-last-check-params in this-procedure (
                                                            input g#db-num
                                                            ,input p-obj-code
                                                            ,input p-pos-type
                                                            ,input (if p-pos-type = {&cd-type-autotank} then 0 else pay-desk_)
                                                            ,output v-last-date
                                                            ,output v-last-time
                                                            ,output v-last-shift-num
                                                            ,output v-last-z-count
                                                            ,output v-last-chk-num
                                                            ) no-error.

    create temp-cash-desk.
    assign
    temp-cash-desk.cash-num = (if p-pos-type = {&cd-type-autotank} then 0 else pay-desk_)
    temp-cash-desk.last-date = v-last-date
    temp-cash-desk.last-time = v-last-time
    temp-cash-desk.last-shift-num = v-last-shift-num
    temp-cash-desk.last-z-count = v-last-z-count
    temp-cash-desk.last-chk-num = v-last-chk-num
    .
  end.
  /*сотворим составную переменную*/
  assign
  v-old = string(year(temp-cash-desk.last-date), "9999") +
          string(month(temp-cash-desk.last-date), "99") +
          string(day(temp-cash-desk.last-date), "99") +
          string(temp-cash-desk.last-time, "HH:MM:SS") +
          string(temp-cash-desk.last-shift-num, "99") +
          string(temp-cash-desk.last-z-count, "99999") +
          string(temp-cash-desk.last-chk-num, "-999999999")
  .
  define variable vTimestring as character no-undo.
  define variable veffDate as date no-undo.
  define variable veffTime as integer  no-undo.
  Vtimestring = string(chk-time_, "HH:MM:SS").
  veffDate = chk-date_ .
  entry(1,Vtimestring,":") = string(int(entry(1,Vtimestring,":")) - 1,"99") no-error. 
  if    vTimestring begins "?"
     or error-status:error
  then do:
     entry(1,Vtimestring,":") = "00".
     veffDate = chk-date_ - 1. 
  end.
  else
     veffTime = chk-time_ - 1 * 60 * 60. 
  assign
  v-new = string(year(veffDate), "9999") +
          string(month(veffDate), "99") +
          string(day(veffDate), "99") +
          Vtimestring +    /* В связи с тем, что стали появляться запросы о том, что последний чек не всегда корректно закачивается, сделаем так, чтобы время последнего принятого чека фиксировалось на час раньще, также надо обновить не завершенные чеки пришедшие с ТСО */ 
          string(integer(shift-name_), "99") +
          string(z-num_, "99999") +
          string(chk-num_, "-999999999")
  .
  if v-new > v-old then do:
    assign
    temp-cash-desk.last-date       = veffDate
    temp-cash-desk.last-time       = veffTime
    temp-cash-desk.last-shift-num  = integer(shift-name_)
    temp-cash-desk.last-z-count    = z-num_
    temp-cash-desk.last-chk-num    = chk-num_
    .

  end.

  if can-do("13":U,  gbl-type) then do:
    /*закрыть смену на кассе*/
    run proc-13 in this-procedure no-error .
  end.
  if get-chkc_context.is-wth and can-do("2,3,4,5,7":U ,  gbl-type) then do:
    /*инициируем переменные для приема чеков-МЦ*/
    assign
    mc-for-chk-type = ""
    mc-exist = yes /* Предполагаем что уже есть в базе */
    .
    FIND  ub.chk-doc where
          ub.chk-doc.obj-type = shop-type and
          ub.chk-doc.obj-code = shop-code and
          ub.chk-doc.chk-date = chk-date_ and
          ub.chk-doc.pay-desk = pay-desk_ and
          ub.chk-doc.chk-time = chk-time_ and
          ub.chk-doc.chk-num  = chk-num_ and
          ub.chk-doc.sales-man = sales-man_
          NO-ERROR NO-WAIT.
    IF NOT AVAIL ub.chk-doc AND NOT LOCKED ub.chk-doc  AND NOT AMBIGUOUS ub.chk-doc then do:
      /*установить смены на кассе*/
      assign
      mc-exist = no
      lll = lll + 1 .
      CREATE ub.chk-doc.
      assign
      ub.chk-doc.chk-type = 0
      ub.chk-doc.office = ?
      lng = 0
      lnp = 0
      lnc = 0
      var-discnt-id = 0
      ub.chk-doc.chk-id = v-id
      ub.chk-doc.correct = yes
      ub.chk-doc.obj-code = shop-code
      ub.chk-doc.obj-type = shop-type
      ub.chk-doc.doc-code = (if get-chkc_context.db-num = 0
                            then string(next-value(s-chk, {&db-name_schema} ))
                            else string( shop-code ) + {&slash-char} + string( next-value( s-chk, {&db-name_schema} ) ))
      ub.chk-doc.chk-num = chk-num_
      ub.chk-doc.chk-date = chk-date_
      ub.chk-doc.chk-time = chk-time_
      ub.chk-doc.sales-man = (if sales-man_ = ? then 0 else sales-man_)
      ub.chk-doc.pay-desk = pay-desk_
      ub.chk-doc.cashier = cashier_
      ub.chk-doc.src-shift-date = shift-date_
      shift-name_ = if cas-shft then string(shift-num_) else '':U
      shift-num_ = if get-chkc_context.shift-on then 0 else shift-num_
      ub.chk-doc.shift-num = shift-num_
      ub.chk-doc.src-shift-name = shift-name_
      ub.chk-doc.shift-name = shift-name_
      ub.chk-doc.z-number = z-num_
      ub.chk-doc.chk-type = int(gbl-type)
      ub.chk-doc.prev-chk-type = int(prev-gbl-type)
      ub.chk-doc.cash-rate = cash-rate_
      ub.chk-doc.cash-scale = 1
      ub.chk-doc.doc-num = doc-num_
      ub.chk-doc.tot-doc = 0
      ub.chk-doc.netto = 0
      ub.chk-doc.discnt = 0
      ub.chk-doc.d-pcnt = 0
      ub.chk-doc.src-d-pcnt = 0
      ub.chk-doc.doc-qnty = 0
      ub.chk-doc.src-tot-doc = 0
      ub.chk-doc.src-d-mask = ''
      ub.chk-doc.d-mask = ''
      ub.chk-doc.d-card = ''
      ub.chk-doc.src-d-card = ''
      ub.chk-doc.src-cli-type = ?
      ub.chk-doc.src-cli-code = ?
      ub.chk-doc.cli-type = ?
      ub.chk-doc.cli-code = ?
      ub.chk-doc.doc-num2 = ?
      ub.chk-doc.out-2-code = ?
      no-error
      .
      if error-status:error then do:
        assign
        ub.chk-doc.correct = no
        .
      end.
      if vCHNumberKKT ne ""
      then do:
        create chk-doc-attr.
        assign
           chk-doc-attr.doc-code   = chk-doc.doc-code
           chk-doc-attr.attr-code  = "CHNumberKKT"
           chk-doc-attr.attr-value = vCHNumberKKT
        .
      end.
      if vCHFiscalDocSign > "" then do:
        create chk-doc-attr.
        assign
           chk-doc-attr.doc-code   = chk-doc.doc-code
           chk-doc-attr.attr-code  = "CHFiscalDocSign"
           chk-doc-attr.attr-value = vCHFiscalDocSign
        .
      end.
      if vCHFiscalDocNumber > 0 then do:
        create chk-doc-attr.
        assign
           chk-doc-attr.doc-code   = chk-doc.doc-code
           chk-doc-attr.attr-code  = "CHFiscalDocNumber"
           chk-doc-attr.attr-value = string(vCHFiscalDocNumber)
        .
      end.
        
      mc-prev-code = ub.chk-doc.doc-code.
    end. /* not(can-find) */
    else
    mc-curr-chk-type = 0 .
    return. /*не стирать!!*/
  end.
  if lookup(gbl-type, accept-types) > 0
  or (p-pos-type = {&cd-type-magia-XML} and integer(gbl-type) = 8)
  then do:
    /*инициируем переменные для приема товарных чеков*/

    assign
    for-chk-type = ""
    exist = yes  /* Предполагаем что уже есть в базе */
    v-create-return-write-off = no
    v-is-without-payment = no
    v-to-delete[1] = no
    v-to-delete[2] = no
    .
    FIND  ub.chk-doc where
          ub.chk-doc.obj-type = shop-type and
          ub.chk-doc.obj-code = shop-code and
          ub.chk-doc.chk-date = chk-date_ and
          ub.chk-doc.pay-desk = pay-desk_ and
          ub.chk-doc.chk-time = chk-time_ and
          ub.chk-doc.chk-num = chk-num_ and
          (p-pos-type = {&cd-type-magia-xml}
           or ub.chk-doc.cashier = cashier_
           ) NO-ERROR NO-WAIT.
    IF NOT AVAILABLE ub.chk-doc
    AND NOT LOCKED ub.chk-doc
    AND NOT AMBIGUOUS ub.chk-doc
    or (p-pos-type = {&cd-type-magia-xml}
       AND
       (AVAILABLE ub.chk-doc
       and
       NOT AMBIGUOUS ub.chk-doc)
       )  then do:
      v-chk-type[1] = integer(gbl-type).
       if p-pos-type = {&cd-type-magia-xml} then do:
        for each temp-ivs-ibs where
                  temp-ivs-ibs.chtype = gbl-type
              AND temp-ivs-ibs.positive-num-chk = (chk-num_ > 0)
              AND temp-ivs-ibs.positive-netto-sum = ((netto-sum_ > 0) or (netto-sum_ = 0  and chk-num_ < 0))
              and temp-ivs-ibs.main-record = yes:
           if temp-ivs-ibs.step_ = 1 then v-chk-type[1] = integer(temp-ivs-ibs.rcpt-type-1).
           if temp-ivs-ibs.step_ = 2 then do:
            assign
            v-chk-type[2] = integer(temp-ivs-ibs.rcpt-type-1)
            v-create-return-write-off = temp-ivs-ibs.create-return-write-off
            v-write-off-code-2 = integer(temp-ivs-ibs.wro-code)
            .
          end.
        end.
        if v-chk-type[1] = 0 then do:
          assign
          exist = yes.
          run write-log-and-file in p-log-handle (
                input 1
              , input log-file-name
              , input 1
              , input substitute( "!!!Неизвестный тип чека:&1" +
                                  "код типа чека &2 сумма нетто &3 номер чека на кассе &4 касса &5"
                                  , {&new-line}
                                  , gbl-type
                                  , netto-sum_
                                  , chk-num_
                                  , pay-desk_
                                )
                                              ).
          assign
          p-view-log = yes
          .
          return.
        end.
        if AMBIGUOUS ub.chk-doc
        or available ub.chk-doc then do:
            /*второго чека не предполгаеатся а первый уже есть*/
          if v-chk-type[2] = 0 then return.
          do v-step = 2 to 1 by -1:
            FIND  buf_chk-doc no-lock where
                  buf_chk-doc.obj-type = shop-type and
                  buf_chk-doc.obj-code = shop-code and
                  buf_chk-doc.chk-date = chk-date_ and
                  buf_chk-doc.pay-desk = pay-desk_ and
                  buf_chk-doc.chk-time = chk-time_ and
                  buf_chk-doc.chk-num = chk-num_ and
                  buf_chk-doc.chk-type = integer(v-chk-type[v-step])
                  NO-ERROR NO-WAIT.
            if available buf_chk-doc then do:
              assign
              v-to-delete[v-step] = yes
              .
              if v-step = 1 then do:
                prev-code = buf_chk-doc.doc-code.
              end.
            end.
          end.
          if v-to-delete[1] = yes
          and v-to-delete[2] = yes then return.
          if v-create-return-write-off
          and v-to-delete[1]
          and not v-to-delete[2]
          then do:
            exist = yes.
            return.
          end.
        end. /*if AMBIGUOUS ub.chk-doc then do:*/
        else do:
            /*дальше идем*/
        end.
      end. /*magia*/
      for each temp-ivs-ibs-line:
        delete temp-ivs-ibs-line.
      end.
      assign
      exist = no
      lll = lll + 1 .
      create ub.chk-doc.
      assign
      ub.chk-doc.office = ?
      v-to-delete[1] = no
      v-to-delete[1] = no
      kriv3 = no
      lng = 0
      lnp = 0
      lnc = 0
      sub-d = 0
      var-discnt-id = 0
      lng-sub-d = 0
      netto-for-sub-d = 0
      accum-src-for-sub-d = 0
      ub.chk-doc.chk-id = v-id
      ub.chk-doc.obj-code = shop-code
      ub.chk-doc.obj-type = shop-type
      ub.chk-doc.doc-code = (if get-chkc_context.db-num = 0
                          then string(next-value(s-chk, {&db-name_schema} ))
                          else string( shop-code ) + {&slash-char} + string( next-value( s-chk, {&db-name_schema} ) ))
      ub.chk-doc.chk-num =  chk-num_
      ub.chk-doc.chk-date = chk-date_
      ub.chk-doc.chk-time = chk-time_
      ub.chk-doc.sales-man = (if sales-man_ = ? then 0 else sales-man_)
      ub.chk-doc.pay-desk = pay-desk_
      ub.chk-doc.cashier = cashier_
      ub.chk-doc.discnt = 0
      ub.chk-doc.src-d-card =  (if d-card_ <> "":U then d-card_ else ?)
      ub.chk-doc.src-d-pcnt = - tot-d-pcnt
      ub.chk-doc.src-cli-type = (if cli-type_ = "":u then ? else cli-type_)
      ub.chk-doc.src-cli-code = (if cli-code_ = 0    then ? else cli-code_)
      ub.chk-doc.src-shift-date = (if is-shift-date then shift-date_ else chk-date_)
      shift-name_ = if cas-shft then string(shift-num_) else '':U
      shift-num_ = if get-chkc_context.shift-on then 0 else shift-num_
      ub.chk-doc.shift-num = shift-num_
      ub.chk-doc.src-shift-name = shift-name_
      ub.chk-doc.shift-name = shift-name_
      ub.chk-doc.cash-rate = cash-rate_
      ub.chk-doc.cash-scale = 1
      ub.chk-doc.z-number = z-num_
      ub.chk-doc.doc-num = doc-num_
      ub.chk-doc.chk-type = v-chk-type[1]
      ub.chk-doc.prev-chk-type = int(prev-gbl-type)
      v-is-petrol-check = lookup(string(chk-doc.chk-type) , {&petrol-receipt-codes}) > 0
      ub.chk-doc.correct = yes
      no-error
      .
      if error-status:error then do:
        ub.chk-doc.correct = no.
      end.
      if vCHNumberKKT ne ""
      then do:
        create chk-doc-attr.
        assign
           chk-doc-attr.doc-code   = chk-doc.doc-code
           chk-doc-attr.attr-code  = "CHNumberKKT"
           chk-doc-attr.attr-value = vCHNumberKKT
        .
      end.
      if vCHFiscalDocSign > "" then do:
        create chk-doc-attr.
        assign
           chk-doc-attr.doc-code   = chk-doc.doc-code
           chk-doc-attr.attr-code  = "CHFiscalDocSign"
           chk-doc-attr.attr-value = vCHFiscalDocSign
        .
      end.
      if vCHFiscalDocNumber > 0 then do:
        create chk-doc-attr.
        assign
           chk-doc-attr.doc-code   = chk-doc.doc-code
           chk-doc-attr.attr-code  = "CHFiscalDocNumber"
           chk-doc-attr.attr-value = string(vCHFiscalDocNumber)
        .
      end.
      if ub.chk-doc.chk-type = integer({&income-corr}) or ub.chk-doc.chk-type = integer({&expense-corr})
      then do :
        assign
          ub.chk-doc.tot-doc = brutto-sum_
          ub.chk-doc.netto   = netto-sum_
        .
      end.
      prev-code = ub.chk-doc.doc-code.


      if v-chk-type[1] = integer({&rcpt-annu})
      then do:
        assign
        netto-sum_ = 0
        .
      end.
      if gbl-type = "12" then do: /*временная затычка пока карпов не сделает запись*/
        define variable v-curr-abbr as character no-undo .
        { gbl/exchrate.i get-chkc_context.base-code ub.chk-doc.chk-date bank-rate_ bank-scale_ v-curr-abbr }
        create ub.chk-pay.
        assign
        lnp = lnp + 1
        ub.chk-pay.doc-code = ub.chk-doc.doc-code
        ub.chk-pay.line-num = lnp
        ub.chk-pay.chk-date = ub.chk-doc.chk-date
        ub.chk-pay.obj-code = shop-code
        ub.chk-pay.obj-type = shop-type
        ub.chk-pay.tot-rubl = 0
        ub.chk-pay.tot-sum = 0
        ub.chk-pay.tot-base = 0
        ub.chk-pay.pay-code = 0
        ub.chk-pay.curr-code = 0
        ub.chk-pay.time-oper = time-oper_
        ub.chk-pay.cash-rate = ub.chk-doc.cash-rate
        ub.chk-pay.bank-rate = 1
        ub.chk-pay.bank-scale = 1
        ub.chk-pay.pass-pay =  0
        ub.chk-pay.pay-card = '':U
        ub.chk-pay.line-type = "":U
        ub.chk-pay.line-sign = yes
        ub.chk-pay.is-error = no
        .
      end. /*if gbl-type = "12" then do:*/
    end. /* not(can-find) */
  end. /*товарные чеки*/
end.
end procedure .

procedure proc-CAuthorization :
define buffer buf_temp-temp for temp-temp.
define buffer buf_chk-doc for ub.chk-doc.
define buffer buf_shift-obj for ub.shift-obj.

do
on error undo, return error
:

    assign
    AuthType_ = 0
    qr-alchol_ = "":u
    no-error
    .
    _buf_temp:
    for each buf_temp-temp no-lock where
            buf_temp-temp.record-name = "CAuthorization":U
       AND buf_temp-temp.id = v-id:
      CASE buf_temp-temp.field-name:
              when "CAuthType":U then do:
                assign
                AuthType_ = fdecimal(buf_temp-temp.field-value)
                no-error .
              end.
              when "CAuthUrl":U then do:
                run xmlchar-decode in this-procedure (
                      input trim(buf_temp-temp.field-value)
                    , output qr-alchol_
                ) no-error.
              end.
        otherwise do:
          error-status:error = no.
        end.
      END CASE.
      if error-status:error then do:
        {&error-in-file-format}
      end.
    END.
  
define variable v-value as character no-undo .
define variable v-type  as character no-undo .



    if AuthType_ = 2 then do: /*пиво*/
      run chkdocat-write IN THIS-PROCEDURE(
        input chk-doc.doc-code
        ,INPUT "qr-alchol-pv"
        ,INPUT qr-alchol_ ) NO-ERROR.

    end.  
    if AuthType_ <> 2 and AuthType_ <> 0 then do: /*алкоголь*/
      run chkdocat-write IN THIS-PROCEDURE(
        input chk-doc.doc-code
        ,INPUT "qr-alchol"
        ,INPUT qr-alchol_ ) NO-ERROR.
    end.  
  end.
  

  
end procedure. /* proc-00 */
/*procedure proc-01-tax :
  define output parameter oCSTTaxValue as decimal no-undo.
  define output parameter oCSTValue    as decimal no-undo.
  
define buffer buf_temp-temp for temp-temp.
   do
   on error undo, return error
   :
         for each buf_temp-temp where
                  buf_temp-temp.record-name = "CSTax":U
              AND buf_temp-temp.id = v-id:
            CASE buf_temp-temp.field-name:
               when "CSTValue":U then do:
                  assign
                      oCSTValue = decimal (buf_temp-temp.field-value)
                  no-error .
               end.
               when "CSTTaxValue":U then do:
                  assign
                      oCSTTaxValue = decimal (buf_temp-temp.field-value)
                  no-error .
               end.
               otherwise do:
                  error-status:error = no.
               end.
            end case.
            delete buf_temp-temp.
         end.
             
   end.
end procedure .*/
procedure proc-01-gds :
DEFINE VARIABLE no-add-price as logical no-undo .
define variable vCSTValue as decimal no-undo.
define variable vCSTaxValue as decimal no-undo.
define variable lng-spl as integer no-undo .
define variable depart-id_ as integer no-undo .
define variable v-d-pcnt-categ as decimal no-undo .
define variable v-d-sum-categ as decimal no-undo .
define variable v-d-pcnt-time as decimal no-undo .
define variable v-d-sum-time as decimal no-undo .
define variable v-d-pcnt-qnty as decimal no-undo .
define variable v-d-sum-qnty as decimal no-undo .
define variable v-d-pcnt-manual as decimal no-undo .
define variable v-d-sum-manual as decimal no-undo .
define variable write-off-reason-code_ as integer no-undo .
define variable v-is-modificator as logical no-undo .
define variable D-CARD2_ as character no-undo .
define variable v-step as integer   no-undo .
define variable v-line-type as character no-undo .
define buffer buf_chk-gds for ub.chk-gds.

define buffer buf_temp-temp for temp-temp.
define buffer buf_tt-sum-grp for tt-sum-grp.
do
on error undo, return error
:
    assign
    d-card_ = "":U
    d-mask_ = "":U
    cli-type_ = "":U
    cli-code_ = 0
    b-c = 0
    nozzle_ = 0
    place_ = 0
   
    pump_ = 0
    .
    
    if not exist
    or (v-to-delete[1] = yes
        and
        v-to-delete[2] = no)
    then  do:
      for each buf_temp-temp where
            buf_temp-temp.record-name = "CSale":U
       AND buf_temp-temp.id = v-id:
      CASE buf_temp-temp.field-name:
        when "CSType":U then do:
           assign
           cstype_ = integer(buf_temp-temp.field-value)
           no-error .
        end.
        when "CSCode":U then do:
          assign
          bc-buf = buf_temp-temp.field-value
          no-error
          .
        end.
        when "CSLocal":U then do:

          integer(buf_temp-temp.field-value) no-error .
          if error-status:error = no then
          do:
             assign
              b-c = integer(buf_temp-temp.field-value)
             .
          end.
        
        end.
        when "CSPriceOrig":u then do:
          assign
          price-old = dec(buf_temp-temp.field-value)
          no-error
          .
        end.        
        when "CSPrice":u then do:
          assign
          price-from-check = dec(buf_temp-temp.field-value)
          no-error
          .
        end.
        when "CSQty":u then do:
          assign
          curr-string-qnty = dec(buf_temp-temp.field-value)
          no-error
          .
        end.
        when "CSTrk":u then do:
          assign
          pump_ = int(buf_temp-temp.field-value)
          no-error
          .
        end.
        when "CSSaleman":U or
        when "CSGarcon":U then do:
          assign
          sales-man_ = int(buf_temp-temp.field-value)
          no-error .
        end.
        when "CSCCard":U then do:
          assign
          d-card2_ = buf_temp-temp.field-value
          no-error .
        end.
        /* непонятно работает ли*/
        when "CSCNum":U then do:
          assign
          d-card_ = buf_temp-temp.field-value
          no-error .
        end.
        when "CSCMask":U then do:
          assign
          d-mask_ = buf_temp-temp.field-value
          no-error .
        end.
        when "CSCCode":U then do:
          assign
          cli-code_ = integer(buf_temp-temp.field-value)
          cli-type_ = if cli-code_ > 9999999999 then {&cmp} else {&prs}
          no-error .
        end.
        when "CSString":U then do:
          assign
          lng-spl = integer(buf_temp-temp.field-value)
          no-error .
        end.
        when "CSTotal":u then do:
          assign
          sum-from-check = fdecimal(buf_temp-temp.field-value)
          no-error .
        end.
        when "CSTValue":U then do:
          assign
          cstValue = fdecimal(buf_temp-temp.field-value)
          vCSTValue = fdecimal (buf_temp-temp.field-value)
          no-error .
        end.
        when "CSTCode":U then do:
          run xmlchar-decode in this-procedure (
                input trim(buf_temp-temp.field-value)
              , output cstCode
          ) no-error.
        end.
        when "CSSNoTotal":U then do:
          /*составной товар не добавлять к сумме продажи*/
          if p-pos-type <> {&cd-type-magia-xml} then
          assign
          no-add-price = if integer(buf_temp-temp.field-value) = 1
                         then yes
                         else no
          no-error .
          else do:
            assign
            error-status:error = no.
          end.
        end.
        when "CSTValue":U then do:
                  assign
                      vCSTValue = decimal (buf_temp-temp.field-value)
                  no-error .
               end.
               when "CSTTaxValue":U then do:
                  assign
                      vCSTaxValue = decimal (buf_temp-temp.field-value)
                  no-error .
               end.
               
        when "CSSHandCode":u then do:
          assign
          pass-gds_ =   (if integer(buf_temp-temp.field-value) = 1
                        then 1
                        else 0)
          no-error .
        end.
        when "CSGcode":U then do:
          if p-pos-type = {&cd-type-MAGIA-XML} then do:
            assign
            depart-id_ = integer(buf_temp-temp.field-value)
            no-error .
          end.
          else do:
            if buf_temp-temp.field-value <> string(0) then do:
              If cstype_ = 37 then v-oss-code =  buf_temp-temp.field-value.  /* Если пополнение, то берем из этого поля код оператора*/
              else do:
                  for each buf_tt-sum-grp where string (buf_tt-sum-grp.grp-code) = buf_temp-temp.field-value:    
                      /* Перевод ОСС по старому */
                    find first ub.goods-attr where ub.goods-attr.gds-code = buf_tt-sum-grp.code-2
                            and ub.goods-attr.attr-code = {&attr-office-type} and ub.goods-attr.attr-value = {&attr-office-type_oss-pay} no-error.
                    if available ub.goods-attr
                        then assign v-oss-code = bc-buf.
                  end.
                  assign
                  bc-buf = buf_temp-temp.field-value
                  v-line-type = 'grp'
                  no-error
                  .
              end.
            end.
            else do:
              assign
              error-status:error = no.
            end.
          end.
        end.
        /*
        when "CSPriceList":u then do:
        end.
        */
        /*далее может быть только для MAGIA*/
        when "CSDiscnt1Pcnt":U then do:
          assign
          v-d-pcnt-categ = fdecimal(buf_temp-temp.field-value)
          no-error .
        end.
        when "CSDiscnt1Sum":U then do:
          assign
          v-d-sum-categ = fdecimal(buf_temp-temp.field-value)
          no-error .
        end.
        when "CSDiscnt2Pcnt":U then do:
          assign
          v-d-pcnt-time = fdecimal(buf_temp-temp.field-value)
          no-error .
        end.
        when "CSDiscnt2Sum":U then do:
          assign
          v-d-sum-time = fdecimal(buf_temp-temp.field-value)
          no-error .
        end.
        when "CSDiscnt3Pcnt":U then do:
          assign
          v-d-pcnt-qnty = fdecimal(buf_temp-temp.field-value)
          no-error .
        end.
        when "CSDiscnt3Sum":U then do:
          assign
          v-d-sum-qnty = fdecimal(buf_temp-temp.field-value)
          no-error .
        end.
        when "CSDiscnt4Pcnt":U then do:
          assign
          v-d-pcnt-manual = fdecimal(buf_temp-temp.field-value)
          no-error .
        end.
        when "CSDiscnt4Sum":U then do:
          assign
          v-d-sum-manual = fdecimal(buf_temp-temp.field-value)
          no-error .
        end.
        when "CSSModificator":U then do:
          assign
          v-is-modificator = if integer(buf_temp-temp.field-value) = 1
                             then yes
                             else no
          no-error .
        end.
        when "CSSModificatorNullPrice":U then do:
          assign
          no-add-price = if integer(buf_temp-temp.field-value) = 1
                         then yes
                         else no
          no-error .
        end.
        when "CSSCancelCode":U then do:
          assign
          write-off-reason-code_ = integer(buf_temp-temp.field-value)
          no-error
          .
        end.
        when "CSNozzle":U then do:
          assign
          nozzle_ = integer(buf_temp-temp.field-value)
          no-error .
        end.
        when "CSTank":U then do:
          assign
          place_ = integer(buf_temp-temp.field-value)
          no-error .
        end.
        when "CSTankCode":U then do:
          assign
          pl-code_ = integer(buf_temp-temp.field-value)
          no-error .
        end.
        when "CHBrutto":U then do:
          assign
          v-src-tot-doc = decimal(buf_temp-temp.field-value)
          no-error .
        end.
        /*when "cstax":U then do:
          
        end.*/
        otherwise do:
          error-status:error = no.
        end.
      END CASE.
      if error-status:error then do:
        {&error-in-file-format}
      end.
      /*продажи по группе*/
      if (p-pos-type = {&cd-type-IBM-xml}
        or p-pos-type = {&cd-type-autotank})
      and  LOOKUP(string(cstype_), "6,7,8":U) > 0
      and not get-chkc_context.ibmgroup
      then return.
      delete buf_temp-temp.
    end. /*for each buf_temp-temp*/
    if error-status:error then do:
      {&error-in-file-format}
    end.
    if cstype_ = 18 then do: /*регистрация карты*/
      assign
      d-card_ = (if d-card_ = ""
                and d-mask_ <> ""
                then d-mask_
                else d-card_)
      ub.chk-doc.src-d-card       = (if d-card_ = "":U
                                or ub.chk-doc.src-d-card = d-card_
                                then ub.chk-doc.src-d-card
                                else (if not v-flag-card
                                      and (ub.chk-doc.src-d-card = ? or ub.chk-doc.src-d-card = "":U)
                                      then d-card_
                                      else d-card_
                                      )
                                )
      ub.chk-doc.src-cli-type   = (if cli-type_ = "":U
                                or ub.chk-doc.src-cli-type = cli-type_
                                then ub.chk-doc.src-cli-type
                                else (if not v-flag-card
                                      and (ub.chk-doc.src-cli-type = ? or ub.chk-doc.src-cli-type = "":U)
                                      then cli-type_
                                      else ?)
                              )
      ub.chk-doc.src-cli-code   = (if cli-code_ = 0
                                or ub.chk-doc.src-cli-code = cli-code_
                                then ub.chk-doc.src-cli-code
                                else (if not v-flag-card
                                      and (ub.chk-doc.src-cli-code = ? or ub.chk-doc.src-cli-code = 0)
                                      then cli-code_
                                      else ?)
                              )
      ub.chk-doc.d-card = if d-CARD2_ <> "":U then d-CARD2_ else ub.chk-doc.d-card
      v-flag-card         = (if not v-flag-card  and d-card_ <> "":U
                          then yes
                          else v-flag-card)
      .
      return.
    end. /*регистрация карты*/
    assign
    time-oper_ =  (if p-pos-type = {&cd-type-magia-xml}
                   then (v-time modulo 86400)
                   else string-IS0-8601-to-sec(v-time-char))
    /*
    road-tax_ = (if ii > 8 and ibmspool = "3":U then dec(n-entry[9]) else 0 )
    */
    no-error
    .
    if p-pos-type = {&cd-type-magia-XML}
    then do:
      /*кривулька которую надо попросит переписать*/
      if gbl-type = "8"
      and cstype_ = 6
      and lookup(string(write-off-reason-code_), ret-chk) > 0 then do:
        run recalc-write-off in this-procedure(buffer ub.chk-doc, input gbl-type, input "6").
        if v-to-delete[1] = yes
        and v-to-delete[2] = yes then do:
          assign
          v-to-delete[1] = no
          v-to-delete[2] = no
          .
          return.
        end.
        /*выяснилось что все таки оба таких чека есть*/
      end. /*кривулька*/
      do v-step = 1 to (if v-create-return-write-off then 2 else 1):
        if v-is-modificator = ? then
        v-is-modificator = no.
        if v-is-modificator
        and not no-add-price then v-is-modificator = no.
        find first temp-ivs-ibs where
                  temp-ivs-ibs.chtype = gbl-type
              AND temp-ivs-ibs.cstype = string(cstype_)
              and temp-ivs-ibs.cancelcode = string(write-off-reason-code_)
              and temp-ivs-ibs.positive-num-chk = (chk-num_ > 0)
              and temp-ivs-ibs.positive-netto-sum = (netto-sum_ >= 0)
              and temp-ivs-ibs.modificator = v-is-modificator
              and (v-is-modificator = no or temp-ivs-ibs.modificator-np = no-add-price)
              and temp-ivs-ibs.step_ = v-step no-error .
        if not available temp-ivs-ibs then do:
          assign
          exist = yes.
          run write-log-and-file in p-log-handle (
                input 1
              , input log-file-name
              , input 1
              , input substitute( "!!!Неизвестный тип строки чека:&1" +
                                  "код типа чека &2 код типа строки чека &3 код списания &4&1" +
                                  "&7&1" +
                                  "номер чека на кассе &5 касса &6"
                                  , {&new-line}
                                  , gbl-type
                                  , cstype_
                                  , write-off-reason-code_
                                  , chk-num_
                                  , pay-desk_
                                  , (if v-is-modificator
                                    then ('модификатор' + {&space-char} + (if no-add-price
                                                                           then 'без цены'
                                                                           else '':U))
                                    else '')
                                )
                                              ).
          assign
          p-view-log = yes
          .
          return.
        end.
        if available temp-ivs-ibs then do:
          if v-step = 1 then
          create
          temp-ivs-ibs-line
          .
          if v-step  = 1 then do:
            assign
            temp-ivs-ibs-line.chtype = temp-ivs-ibs.chtype
            temp-ivs-ibs-line.cstype = temp-ivs-ibs.cstype
            temp-ivs-ibs-line.cancelcode = temp-ivs-ibs.cancelcode
            temp-ivs-ibs-line.modificator = temp-ivs-ibs.modificator
            temp-ivs-ibs-line.modificator-np = temp-ivs-ibs.modificator-np
            temp-ivs-ibs-line.create-return-write-off =  temp-ivs-ibs.create-return-write-off
            temp-ivs-ibs-line.return-line = temp-ivs-ibs.return-line
            temp-ivs-ibs-line.line-num = (if lng-spl = 0 then - lng else lng-spl)
            temp-ivs-ibs-line.rcpt-type-1                        = temp-ivs-ibs.rcpt-type-1
            temp-ivs-ibs-line.wro-code[v-step]                   = temp-ivs-ibs.wro-code
            temp-ivs-ibs-line.qnty-sign[v-step]                  = temp-ivs-ibs.qnty-sign
            temp-ivs-ibs-line.step_[v-step]                      = temp-ivs-ibs.step_
            .
          end.
          if v-step = 2
          and available temp-ivs-ibs-line
          and available temp-ivs-ibs then do:
            assign
            temp-ivs-ibs-line.rcpt-type-2                        = temp-ivs-ibs.rcpt-type-2
            temp-ivs-ibs-line.wro-code[v-step]                   = temp-ivs-ibs.wro-code
            temp-ivs-ibs-line.qnty-sign[v-step]                  = temp-ivs-ibs.qnty-sign
            temp-ivs-ibs-line.step_[v-step]                      = temp-ivs-ibs.step_
            .
          end.
        end. /*avaial temp-ovs-ibm*/
      end. /*do v-step*/
    end. /*magia*/
    if v-to-delete[1] = yes then return.
    if (p-pos-type = {&cd-type-ibm-xml}
    or p-pos-type = {&cd-type-Autotank})
    and v-line-type = 'grp':U
    and get-chkc_context.ibmgroup
    and can-find(first tt-sum-grp)
    and gbl-type <> "43" and gbl-type <> "44"
    then do:
      find first buf_tt-sum-grp no-lock where
              buf_tt-sum-grp.grp-code = integer(bc-buf)
      no-error .
      if not available buf_tt-sum-grp then do:
        assign
        bc-buf = {&delim-par} + bc-buf.
      end.
      else do:
        assign
        bc-buf = string(buf_tt-sum-grp.code-2) + {&delim-par} + bc-buf.
      end.
      v-line-type = '':U.
      assign
      curr-string-qnty = sum-from-check
      price-from-check = 1
      .
    end.
    if p-pos-type = {&cd-type-autotank} and lng-spl = 2 then /* товарная строка всегда одна */
    do:
       if sum-from-check > 0 then
       do:
        assign
          autotank-sum-return = - sum-from-check
          netto-sum_ = netto-sum_ + autotank-sum-return
          .


       end.

       return .
    end.
    If cstype_ = 37 and (p-pos-type = {&cd-type-ibm-xml} OR p-pos-type = {&cd-type-Autotank}) then for first ub.goods-attr no-lock where ub.goods-attr.gds-code = int(bc-buf)
                            and ub.goods-attr.attr-code = {&attr-office-type} and ub.goods-attr.attr-value = {&attr-office-type_oss-pay}:
         assign    /* Если чек пополнения, то считаем, что количество равно сумме при стоимости 1 руб */
        curr-string-qnty = sum-from-check
        price-from-check = 1.
    end.


    CREATE chk-gds.
    assign
    chk-gds.doc-code = chk-doc.doc-code
    lng = lng + 1
    chk-gds.line-num = (if lng-spl = 0 then - lng else lng-spl)
    ub.chk-gds.grp-code = 0
    ub.chk-gds.chk-date = ub.chk-doc.chk-date
    ub.chk-gds.b-code = b-c
    ub.chk-gds.src-code = bc-buf
    ub.chk-gds.src-price = price-from-check
    ub.chk-gds.src-sum   = sum-from-check
    ub.chk-gds.src-qnty = curr-string-qnty
    ub.chk-gds.src-discnt = 0
    ub.chk-gds.doc-qnty = 0
    ub.chk-gds.price-service = 0
    ub.chk-gds.time-oper = time-oper_
    ub.chk-gds.pass-gds = pass-gds_
    ub.chk-gds.is-error = no
    ub.chk-gds.doc-qnty = 0
    ub.chk-gds.pump = (if pump_ > 0 then pump_ else 0)
    ub.chk-gds.nozzle = (if nozzle_ > 0 then nozzle_ else 0)
    ub.chk-gds.loc1 = (if place_ > 0 then string(place_) else '':U)
    ub.chk-gds.src-pl-code = (if pl-code_ > 0 then pl-code_ else 0)
    ub.chk-gds.road-tax = road-tax_
    ub.chk-gds.line-sign = (if ub.chk-doc.chk-type = integer({&rcpt-sale})
                        then (chk-gds.src-qnty >= 0)
                        else (chk-gds.src-qnty <= 0)
                        )
    ub.chk-gds.line-type = v-line-type
    ub.chk-gds.src-d-card = (if d-card_ <> "":U then d-card_ else ?)
    ub.chk-gds.src-d-mask = (if d-mask_ <> "":U then d-mask_ else ?)
    ub.chk-gds.src-cli-type = (if cli-type_ = "":u then ? else cli-type_)
    ub.chk-gds.src-cli-code = (if cli-code_ = 0 then ? else cli-code_)
    ub.chk-gds.d-card = if d-CARD2_ <> "":U then d-CARD2_ else ub.chk-gds.d-card
    ub.chk-doc.src-d-card       = (if d-card_ = "":U
                               or ub.chk-doc.src-d-card = d-card_
                               then ub.chk-doc.src-d-card
                               else (if not v-flag-card
                                    and (chk-doc.src-d-card = ? or ub.chk-doc.src-d-card = "":U)
                                    then d-card_
                                    else d-card_
                                    )
                               )
    ub.chk-doc.src-d-mask       = (if d-mask_ = "":U
                               or ub.chk-doc.src-d-mask = d-mask_
                               then ub.chk-doc.src-d-mask
                               else (if not v-flag-card
                                    and (chk-doc.src-d-mask = ? or ub.chk-doc.src-d-mask = "":U)
                                    then d-mask_
                                    else "-0":U
                                    )
                               )
    ub.chk-doc.src-cli-type   = (if cli-type_ = "":U
                              or ub.chk-doc.src-cli-type = cli-type_
                              then ub.chk-doc.src-cli-type
                              else (if not v-flag-card
                                    and (chk-doc.src-cli-type = ? or ub.chk-doc.src-cli-type = "":U)
                                    then cli-type_
                                    else ?)
                             )
    ub.chk-doc.src-cli-code   = (if cli-code_ = 0
                              or ub.chk-doc.src-cli-code = cli-code_
                              then ub.chk-doc.src-cli-code
                              else (if not v-flag-card
                                    and (chk-doc.src-cli-code = ? or ub.chk-doc.src-cli-code = 0)
                                    then cli-code_
                                    else ?)
                             )
    ub.chk-doc.d-card = if d-CARD2_ <> "":U then d-CARD2_ else ub.chk-doc.d-card
    v-flag-card         = (if not v-flag-card  and d-card_ <> "":U
                        then yes
                        else v-flag-card)
    ub.chk-gds.depart-id = depart-id_
    ub.chk-gds.sales-man  = sales-man_
    ub.chk-doc.sales-man = (if not v-flag-salesman
                         and
                         (
                         ub.chk-doc.sales-man = 0
                         or ub.chk-doc.sales-man = sales-man_
                         or sales-man_ = 0
                         )
                         then sales-man_
                         else 0)
    ub.chk-doc.sales-man = (if ub.chk-doc.sales-man = ? then 0 else ub.chk-doc.sales-man)
    v-flag-salesman   = (if not v-flag-salesman
                         and (sales-man_ <> 0 and sales-man_ <> ub.chk-doc.sales-man)
                         then yes
                         else v-flag-salesman)
    ub.chk-doc.src-tot-doc = v-src-tot-doc
    ub.chk-gds.VAT-pc = vCSTaxValue
    ub.chk-gds.VAT-sum-rubl = vCSTValue
    .
    /*define variable vCSTValue as decimal no-undo.
    define variable vCSTaxValue as decimal no-undo.*/
   // run proc-01-tax in this-procedure (output ub.chk-gds.VAT-pc, output ub.chk-gds.VAT-sum-rubl).
    
    if v-oss-code <> "" then do:
      case p-pos-type:
        when {&cd-type-autotank} then do:
          find first buf_ext-classif where buf_ext-classif.CharKey_One = v-oss-code no-error.
          if available buf_ext-classif then do:
            assign
              v-oss-code = string (buf_ext-classif.Key#_One)
            .
          end.
        end.
      end case.
      create ub.chk-gds-attr.
      assign
        ub.chk-gds-attr.doc-code = ub.chk-gds.doc-code
        ub.chk-gds-attr.line-num = ub.chk-gds.line-num
        ub.chk-gds-attr.attr-code = "oss-code"
        ub.chk-gds-attr.attr-value =  v-oss-code
      .
      v-oss-code = "".
    end.
    
      
      create ub.chk-gds-attr.
      assign
        ub.chk-gds-attr.doc-code = ub.chk-gds.doc-code
        ub.chk-gds-attr.line-num = ub.chk-gds.line-num
        ub.chk-gds-attr.attr-code = "cstype"
        ub.chk-gds-attr.attr-value =  string(cstype_)
      .
      
    
    if price-old <> 0 then do:
     create ub.chk-gds-attr.
      assign
        ub.chk-gds-attr.doc-code = ub.chk-gds.doc-code
        ub.chk-gds-attr.line-num = ub.chk-gds.line-num
        ub.chk-gds-attr.attr-code = "CSPriceOrig"
        ub.chk-gds-attr.attr-value =  string(price-old)
      .
    end.  
    if p-pos-type = {&cd-type-ibm-xml}
    or p-pos-type = {&cd-type-autotank}
    then do:
      if ub.chk-doc.chk-type = integer({&income-corr}) or ub.chk-doc.chk-type = integer({&expense-corr})
      then do :
        ub.chk-gds.road-tax = cstValue .
        ub.chk-gds.depart-type = cstCode .
      end.
      if ub.chk-doc.chk-type = integer({&rcpt-tech-refuell}) then do:
        assign
        ub.chk-gds.write-off-code =  integer({&wro-r-tech-refuell})
        netto-for-sub-d = netto-for-sub-d + (if v-is-petrol-check then 0
                                            else (chk-gds.src-price - ub.chk-gds.src-discnt) * ub.chk-gds.src-qnty)
        .
      end.
      else  do:
        assign
        ub.chk-gds.write-off-code = (if no-add-price
                                  then (if lookup(string(chk-doc.chk-type), {&sale-out-receipt-codes}) > 0
                                        then integer({&wro-without-payment})
                                        else integer({&wro-cancell-item})
                                      )
                                  else 0
                                )
        netto-for-sub-d = netto-for-sub-d + (if (chk-gds.write-off-code = ?
                                            or ub.chk-gds.write-off-code <= 0)
                                            and not v-is-petrol-check
                                            then
                                            ((chk-gds.src-price - ub.chk-gds.src-discnt) * ub.chk-gds.src-qnty)
                                            else 0)
        accum-src-for-sub-d = accum-src-for-sub-d + ub.chk-gds.src-qnty
        .
      end.
      
      chk-doc.doc-num2 = doc-num2_. /* "№ заказа" */
          
    end.
    else do:
      assign
      ub.chk-gds.write-off-code = integer(temp-ivs-ibs-line.wro-code[1])
      netto-for-sub-d = netto-for-sub-d + if temp-ivs-ibs-line.return-line
                                          then 0
                                          else (
                                                (if ub.chk-gds.write-off-code = ?
                                                or ub.chk-gds.write-off-code <= 0
                                                then
                                                ((chk-gds.src-price - ub.chk-gds.src-discnt) * ub.chk-gds.src-qnty)
                                                else 0)
                                                )
      accum-src-for-sub-d = accum-src-for-sub-d + (if temp-ivs-ibs-line.return-line then 0 else ub.chk-gds.src-qnty)
      .
      if temp-ivs-ibs-line.return-line then do:
        create buf_chk-gds.
        buffer-copy ub.chk-gds to buf_chk-gds
        assign
        buf_chk-gds.src-sum   = - ub.chk-gds.src-sum
        buf_chk-gds.src-qnty  = - ub.chk-gds.src-qnty
        buf_chk-gds.src-discnt = - ub.chk-gds.src-discnt
        buf_chk-gds.doc-qnty = - ub.chk-gds.doc-qnty
        buf_chk-gds.line-sign = (not ub.chk-gds.line-sign)
        buf_chk-gds.line-num = - ub.chk-gds.line-num
        .
        return.
      end.
      release temp-ivs-ibs-line.
      if v-d-pcnt-categ <> 0 or
        v-d-sum-categ <> 0 then do:
        run proc-magia-discnt in this-procedure (v-d-pcnt-categ, v-d-sum-categ, integer({&discnt-t-categ})) no-error .
      end.
      if v-d-pcnt-time <> 0 or
        v-d-sum-time <> 0 then do:
        run proc-magia-discnt in this-procedure (v-d-pcnt-time, v-d-sum-time, integer({&discnt-t-time})) no-error .
      end.
      if v-d-pcnt-qnty <> 0 or
        v-d-sum-qnty <> 0 then do:
        run proc-magia-discnt in this-procedure (v-d-pcnt-qnty, v-d-sum-qnty, integer({&discnt-t-qnty})) no-error .
      end.
      if v-d-pcnt-manual <> 0 or
        v-d-sum-manual <> 0 then do:
        run proc-magia-discnt in this-procedure (v-d-pcnt-manual, v-d-sum-manual, integer({&discnt-t-manual})) no-error .
      end.
    end.
  end. /* if not exist */
end.

end procedure. /* proc-01 */


procedure proc-02-gds :
define variable v-attr-code as character no-undo .
define buffer buf_chk-gds for ub.chk-gds.
define buffer buf_temp-temp for temp-temp.
define buffer buf_tt-sum-grp for tt-sum-grp.
define buffer buf_marking-chk for ub.marking-chk .
do
on error undo, return error
:

    for each buf_temp-temp where
            buf_temp-temp.record-name = "CBarCode":U
       AND buf_temp-temp.id = v-id:
      CASE buf_temp-temp.field-name:
        when "CBCType":U then do:
                CBCType_ = fdecimal(buf_temp-temp.field-value) no-error .
              end.
              when "CBCString":U then do:
                CBCString_ = fdecimal(buf_temp-temp.field-value) no-error .
              end.
              when "CBCBarcode":U then do:
                run xmlchar-decode in this-procedure (
                      input trim(buf_temp-temp.field-value)
                    , output CBCBarcode_
                ) no-error.
              end.
        otherwise do:
          error-status:error = no.
        end.
      END CASE.
      if error-status:error then do:
        {&error-in-file-format}
      end.
    end. /*for each buf_temp-temp*/
    if error-status:error then do:
      {&error-in-file-format}
    end.
    if CBCType_ <> 0 and 
        (not exist
        or (v-to-delete[1] = yes
            and
            v-to-delete[2] = no))
    then do:
      if CBCType_ = 32768 then do :
        /* сертификаты автопомощи (для товаров pay-agent-gd) */
        v-attr-code = "agent-gd-code":U .
      end .
      else
      if CBCType_ = 65536
      or CBCType_ = 65537
      then do :
        /* табачные марки */
        v-attr-code = "tobacco-mark":U .
      end . 
      else do :
        /* аксцизные марки */
        v-attr-code = "mark-code":U .
      end .
      
      if v-attr-code = "tobacco-mark"
      then do :
        find first buf_marking-chk exclusive-lock where buf_marking-chk.mark      = CBCBarcode_
                                                    and buf_marking-chk.doc-code  = ub.chk-doc.doc-code
                                                    and buf_marking-chk.line-num  = CBCString_
                                                    no-error .
        if not available buf_marking-chk
        then do :
          create buf_marking-chk .
          assign
            buf_marking-chk.mark      = CBCBarcode_         
            buf_marking-chk.doc-code  = ub.chk-doc.doc-code 
            buf_marking-chk.line-num  = CBCString_          
          .
        end .
        assign
          buf_marking-chk.date-modify = today
          buf_marking-chk.time-modify = time
        .                                                
      end .
      else do :
        find first ub.chk-gds-attr exclusive-lock
             where ub.chk-gds-attr.doc-code  = ub.chk-doc.doc-code
               and ub.chk-gds-attr.line-num  = CBCString_
               and ub.chk-gds-attr.attr-code = v-attr-code no-error.
        if available ub.chk-gds-attr then do:
          CBCBarcode_ = ub.chk-gds-attr.attr-value + "," + CBCBarcode_ .
          ub.chk-gds-attr.attr-value =  CBCBarcode_ .
        end.  
        else do:
        create ub.chk-gds-attr.
        assign
          ub.chk-gds-attr.doc-code = ub.chk-doc.doc-code
          ub.chk-gds-attr.line-num = CBCString_
          ub.chk-gds-attr.attr-code = v-attr-code
          ub.chk-gds-attr.attr-value =  CBCBarcode_ 
        .
        end.
      end .

    end.
    CBCType_ = 0.

end.

end procedure. /* proc-01 */
/*
todo поскольку КАЖЕТСЯ сумма ручной скидки входит  одноверемнно в шапку чека и в строки  то пока закоментарим!!!
procedure proc-02-gds :
define input parameter p-sub-d as decimal no-undo .
do
on error undo, return error
:
  if exist then return.
  /*
  assign
  var-sub-d =  - dec( n-entry[2] )  /* "+" - т.к. скидка  идет со знаком "-" */
  lng-sub-d = 0
  no-error
  .
  */
  if error-status:error then dO:
    {&error-in-file-format}
  end.
  if p-sub-d = 0 then return.
  create chk-discnt.
  assign
  chk-discnt.doc-code = ub.chk-doc.doc-code
  chk-discnt.record-type = 0
  chk-discnt.discnt-id = (var-discnt-id + 1)
  chk-discnt.line-num = 0
  chk-discnt.time-oper = v-time
  chk-discnt.line-type = integer({&discnt-sub-total})
  chk-discnt.line-sign = yes
  chk-discnt.pass-discnt = integer({&discnt-p-manual})
  chk-discnt.value-type = integer({&discnt-v-abs})
  chk-discnt.discnt-type = if ub.chk-doc.src-d-card <> ""
                            then integer({&discnt-t-d-card})
                            else integer({&discnt-t-sum})
  chk-discnt.src-d-card = ub.chk-doc.src-d-card
  chk-discnt.discnt-value-abs = p-sub-d
  chk-discnt.discnt-value-pcnt = if netto-for-sub-d = 0
                                  then 0
                                  else p-sub-d * 100 / netto-for-sub-d
  chk-discnt.object-line-num = 0
  chk-discnt.object-sum = netto-for-sub-d
  chk-discnt.object-qnty = accum-src-for-sub-d
  chk-discnt.pay-desk = ub.chk-doc.pay-desk
  chk-discnt.obj-code = ub.chk-doc.obj-code
  chk-discnt.obj-type = ub.chk-doc.obj-type
  chk-discnt.chk-date = ub.chk-doc.chk-date
  chk-discnt.chk-time = ub.chk-doc.chk-time
  var-discnt-id = var-discnt-id + 1
  sub-d = sub-d + p-sub-d
  netto-for-sub-d = netto-for-sub-d - sub-d
  .
  release chk-discnt.
end. /*doe*/

end procedure. /* proc-02 */
*/

procedure proc-13 :

do
on error undo, return error
:
  /*чек закрытия смены на кассе слава богу состоит из одной строки!!!!*/
  if get-chkc_context.cas-shft then do:
    /*на кассах есть смены*/
    if current-pay-desk <> pay-desk_
    or NOT (current-cas-shift-name =  shift-name_
        AND current-cas-shift-date = shift-date_)
    OR not avail buf_shift-cash then do:
      { str/libchkvl_get-cash-shift.i
      "buffer get-chkc_context:handle"
      buf_shift-cash
      pay-desk_
      shift-date_
      shift-name_
      z-num_
      chk-date_
      chk-time_
      shift-open-time_
      no-error
      }
      if available buf_shift-cash then do:
        assign
        current-pay-desk = buf_shift-cash.cash-num
        current-cas-shift-name = buf_shift-cash.shift-name
        current-cas-shift-date = buf_shift-cash.shift-date
        .
      end.
      else do:
        current-pay-desk = -1.
      end.
    end.
  end. /*if cas-shft*/
end. /*doe*/
end procedure. /* proc-13 */

procedure proc-shift-open :

do
on error undo, return error
:
 
  if get-chkc_context.cas-shft then do:
    /*на кассах есть смены*/
  
      { str/libchkvl_get-cash-shift.i
      "buffer get-chkc_context:handle"
      buf_shift-cash
      pay-desk_
      shift-date_
      shift-name_
      ?
      shift-date_
      shift-open-time_
      0
      no-error
      }
      
    
  end. /*if cas-shft*/
end. /*doe*/
end procedure. /* proc-shift-open */

procedure proc-end :

do
on error undo, return error
:
define variable  prev-code2 as character no-undo .
define variable netto-sum2_ as decimal no-undo .
    /*ппроверка всего что только что приняли*/
    if p-pos-type = {&cd-type-magia-XML}
    and v-create-return-write-off
    and prev-code <> "":U then do:
      release ub.chk-doc.
      if v-to-delete[2] = no
      then
      run proc-create-return-write-off (input prev-code
                                      , input integer(v-chk-type[2])
                                      , input v-write-off-code-2
                                      , output prev-code2
                                      , output netto-sum2_
                                        ).
    end.
    if v-to-delete[1] = no then do:
     run  proc-shift-open.
     get-chkc_context.ll = lll.
    { str/libchkvl_getcheck.i
      "buffer get-chkc_context:handle"
      ~{&add-def~}
      ''
      yes
      yes
      netto-sum_
      lng-sub-d
      sub-d
      var-discnt-id
      prev-code
      no-error
     }
     assign
     p-view-log = (p-view-log or get-chkc_context.view-log)
     lll = get-chkc_context.ll
     .

    end.
    if p-pos-type = {&cd-type-magia-XML}
    and v-create-return-write-off
    and prev-code2 <> "":U
    then do:
      run proc-netto-2 in this-procedure (input prev-code
                                            ,input prev-code2
                                            ,output netto-sum2_).
    { str/libchkvl_getcheck.i
      "buffer get-chkc_context:handle"
      ~{&add-def~}
      ''
      yes
      yes
      netto-sum2_
      lng-sub-d
      sub-d
      var-discnt-id
      prev-code2
      no-error
     }
     assign
     p-view-log = (p-view-log or get-chkc_context.view-log)
     lll = get-chkc_context.ll
     .
    end.
    { str/libchkvl_getwcheck.i
    "buffer get-chkc_context:handle"
    ~{&add-def~}
    ''
    yes
    yes
    netto-sum_
    mc-prev-code
    no-error
    }
    assign
    p-view-log = (p-view-log or get-chkc_context.view-log)
    lll = get-chkc_context.ll
    .
    assign
    prev-code = "":U
    prev-code2 = "":U
    mc-prev-code = "":U
    .
end.

end procedure. /* proc-end */


procedure proc-inv :
define variable i-code_ as character no-undo .
define variable i-qnty_ as decimal no-undo .
define variable i-place_ as integer no-undo .
define variable lng-spl as integer no-undo .
define variable v-line-type as character no-undo .
define buffer buf_chk-gds for ub.chk-gds.
define buffer buf_temp-temp for temp-temp.

do
on error undo, return error return-value
:
  /*инвентаризация*/
if not exist then do:
  if get-chkc_context.is-cdinv = yes then do:


    for each buf_temp-temp where
            buf_temp-temp.record-name = "Invent":U
      AND buf_temp-temp.id = v-id:
      CASE buf_temp-temp.field-name:
        when "ICode":U then do:
          assign
          i-code_ = buf_temp-temp.field-value
          no-error .
        end.
        when "IQty":U then do:
          assign
          i-qnty_ = fdecimal(buf_temp-temp.field-value)
          no-error .
        end.
        when "IPlace":U then do:
          assign
          i-place_ = integer(buf_temp-temp.field-value)
          no-error .
        end.
        when "IString":U then do:
          assign
          lng-spl = integer(buf_temp-temp.field-value)
          no-error .
        end.
        otherwise do:
          error-status:error = no.
        end.
      END CASE.
      if error-status:error then do:
        {&error-in-file-format}
      end.
      delete buf_temp-temp.
    end.
  end.
  assign
  time-oper_ =  (if p-pos-type = {&cd-type-magia-xml}
                  then (v-time modulo 86400)
                  else string-IS0-8601-to-sec(v-time-char))
  no-error
  .
  CREATE ub.chk-gds.
  assign
  ub.chk-gds.doc-code = ub.chk-doc.doc-code
  lng = lng + 1
  ub.chk-gds.line-num = (if lng-spl = 0 then - lng else lng-spl)
  ub.chk-gds.grp-code = 0
  ub.chk-gds.chk-date = ub.chk-doc.chk-date
  ub.chk-gds.src-code = i-code_
  ub.chk-gds.src-qnty = i-qnty_
  ub.chk-gds.src-discnt = 0
  ub.chk-gds.src-price = 0
  ub.chk-gds.doc-qnty = 0
  ub.chk-gds.price-service = 0
  ub.chk-gds.time-oper = time-oper_
  ub.chk-gds.is-error = no
  ub.chk-gds.doc-qnty = 0
  ub.chk-gds.pump = 0
  ub.chk-gds.road-tax = 0
  ub.chk-gds.line-sign = ub.chk-gds.src-qnty >= 0
  ub.chk-gds.line-type =  '':U
  .
end.
end.

end procedure. /* proc-inv */

procedure proc-bonus :
/*
тип объекта выполнившего начисление                                                     BAObj
идентификатор транзакции предоставленный внешней системой                               BATransID
номер карты                                                                             BACardNo
код валюты бонуса                                                                       BACurr
количество единицы бонуcов/компенсации                                                  BAQty
номер бонусной схемы                                                                    BAReason
вид бонуса - привяза к товару, к чеку, не определено                                    BAMode Ltype
номер строки продажи для которой выполнено начисление                                   BAString
код товара есди бонус привязан к товару                                                 BARelation
*/
define variable  bonus-obj_         as integer no-undo .
define variable  bonus-trans-id_    as integer no-undo .
define variable  bonus-card-no      as character no-undo .
define variable  bonus-curr-code_   as integer no-undo .
define variable  bonus-qty_         as decimal no-undo .
define variable  bonus-reason_      as integer no-undo .
define variable  bonus-type-chr_    as character no-undo .
define variable  bonus-string       as integer no-undo .
define variable  bonus-src-code_    as decimal no-undo .
define variable  bonus-src-code-chr as character no-undo .
define variable  bonus-relation     as character no-undo . 
define buffer buf_temp-temp for temp-temp .
define buffer buf_chk-gds for ub.chk-gds.
define variable local-netto-for-sub-d as decimal no-undo .
  do
  on error undo, return error
  :
    if not exist then do:
      for each buf_temp-temp where
              buf_temp-temp.record-name = "BonusAdd":U
        AND buf_temp-temp.id = v-id:
        CASE buf_temp-temp.field-name:
          when "BAString":U then do:
            assign
            bonus-string = integer(buf_temp-temp.field-value)
            no-error .
          end.
          when "BAobj":U then do:
            assign
            bonus-obj_ = integer(buf_temp-temp.field-value)
            no-error .
          end.
          when "BATransID":U then do:
            assign
            bonus-trans-id_ = integer(buf_temp-temp.field-value)
            no-error .
          end.
          when "BACurr":U then do:
            assign
            bonus-curr-code_ = integer(buf_temp-temp.field-value)
            no-error .
          end.
          when "BAReason":U then do:
            assign
            bonus-reason_ = integer(buf_temp-temp.field-value)
            no-error .
          end.
          when "Ltype":U then do: /*BAMode*/
            assign
            bonus-type-chr_ = buf_temp-temp.field-value
            no-error .
          end.
          when "BAQty":U then do:
            assign
            bonus-qty_ = fdecimal(buf_temp-temp.field-value) / 100
            no-error .
          end.
          when "BACardNo":U then do:
            assign
            bonus-card-no = buf_temp-temp.field-value
            no-error .
          end.
          when "BARelation":U then do:
            assign
            bonus-relation = buf_temp-temp.field-value
            no-error .
          end.          
          otherwise do:
            error-status:error = no.
          end.
        END CASE.
        if error-status:error then do:
          {&error-in-file-format}
        end.
        delete buf_temp-temp.
      end.
      create ub.chk-discnt.
      assign
      ub.chk-discnt.doc-code = ub.chk-doc.doc-code
      ub.chk-discnt.record-type = 4
      ub.chk-discnt.line-num = ub.chk-gds.line-num
      ub.chk-discnt.discnt-id = (if bonus-trans-id_ = 0 then ub.chk-discnt.line-num else bonus-trans-id_)
      chk-discnt.time-oper = chk-gds.time-oper
      chk-discnt.line-type = (if bonus-type-chr_ = 'I' or bonus-type-chr_ = '0'
                              then integer({&discnt-gds})
                              else (if bonus-type-chr_ = 'T'
                                    then integer({&discnt-sub-total})
                                    else integer({&discnt-unknown})
                                   )
                              )
      chk-discnt.pass-discnt = bonus-obj_
      chk-discnt.value-type = integer({&discnt-v-bonus})
      chk-discnt.src-d-card = bonus-card-no
      chk-discnt.d-card = bonus-card-no
      chk-discnt.discnt-value-abs = bonus-qty_
      chk-discnt.discnt-value-pcnt = (if chk-discnt.line-type = integer({&discnt-gds})
                                      then bonus-src-code_
                                      else 0)
      chk-discnt.discnt-type = bonus-reason_
      chk-discnt.kateg = (if bonus-curr-code_ > 0
                          then bonus-curr-code_
                          else (if bonus-curr-code_ = kassa-rub-code
                                then 0
                                else -1 )
                          )
      chk-discnt.object-line-num = (if bonus-string <= 0
                                    then bonus-string
                                    else chk-gds.line-num)
      chk-discnt.pay-desk = chk-doc.pay-desk
      chk-discnt.obj-code = chk-doc.obj-code
      chk-discnt.obj-type = chk-doc.obj-type
      chk-discnt.chk-date = chk-doc.chk-date
      chk-discnt.chk-time = chk-doc.chk-time
      .
      if bonus-relation <> "" then do:
          find first chk-discnt-attr EXCLUSIVE-LOCK where chk-discnt-attr.attr-code = "RRN-bonus"
                                       and chk-discnt-attr.line-num = chk-discnt.line-num
                                       and chk-discnt-attr.doc-code = chk-discnt.doc-code
                                       and chk-discnt-attr.discnt-id = chk-discnt.discnt-id 
                                       and chk-discnt-attr.object-line-num = chk-discnt.object-line-num no-error .
          if AVAILABLE chk-discnt-attr then do:
            chk-discnt-attr.attr-value = bonus-relation .
          end. 
          
          else do:
            create chk-discnt-attr .
            assign
            chk-discnt-attr.attr-code = "RRN-bonus"
            chk-discnt-attr.line-num = chk-discnt.line-num
            chk-discnt-attr.doc-code = chk-discnt.doc-code
            chk-discnt-attr.discnt-id = chk-discnt.discnt-id
            chk-discnt-attr.object-line-num = chk-discnt.object-line-num
            chk-discnt-attr.attr-value = bonus-relation
            .
          end.  
      end.                                   
      if chk-discnt.line-type = integer({&discnt-gds}) then do:
        if available chk-gds
        and (bonus-src-code-chr = chk-gds.src-code
            or bonus-string  = chk-gds.line-num ) then do:
        end.
        else do:
          for each buf_chk-gds no-lock where
                  buf_Chk-gds.doc-code = chk-doc.doc-code:
            if buf_chk-gds.src-code = bonus-src-code-chr then do:
              chk-discnt.object-line-num = buf_chk-gds.line-num.
              leave.
            end.
          end.
        end.
      end.
      if chk-discnt.line-type = integer({&discnt-sub-total})
      and available chk-gds
      and chk-discnt.object-line-num = chk-gds.line-num then do:
        assign
        chk-discnt.object-sum = local-netto-for-sub-d
        chk-discnt.discnt-value-pcnt = (if local-netto-for-sub-d <> 0
                                       and (chk-discnt.kateg = - 1
                                       or chk-discnt.kateg <> - 1
                                       and (
                                            (chk-discnt.kateg = 0
                                            and v-curr-r-b = {&r-b-rubl}
                                            )
                                            or
                                            (chk-discnt.kateg = v-base-code
                                            and v-curr-r-b = {&r-b-base})
                                           ))
                                       then bonus-qty_ / chk-gds.src-sum 
                                       else chk-discnt.discnt-value-pcnt)
        .
      end.      
    end. /*if exist*/
  end.

end procedure. /* proc-bonus */

procedure proc-promo :
/*

идентификатор акции        cPromoId
количество срабатываний    cPromoCount
доп. инфо                  cPromoMisc

*/
define variable  Promo-Id        as char no-undo .
define variable  promo-count     as integer no-undo .
define variable  promo-misc      as character no-undo .

define buffer buf_temp-temp for temp-temp .
define buffer buf_chk-gds for ub.chk-gds.
define variable local-netto-for-sub-d as decimal no-undo .
/* run gbl\inidebug.p. */
  do
  on error undo, return error
  :
    if not exist then do:
      for each buf_temp-temp where
              buf_temp-temp.record-name = "CPromo":U
        AND buf_temp-temp.id = v-id:
        CASE buf_temp-temp.field-name:
          when "cPromoId":U then do:
            assign
            Promo-Id = buf_temp-temp.field-value
            no-error .
          end.
          when "cPromoCount":U then do:
            assign
            promo-count = integer(buf_temp-temp.field-value)
            no-error .
          end.
          when "cPromoMisc":U then do:
            assign
            promo-misc = buf_temp-temp.field-value
            no-error .
          end.
          
          otherwise do:
            error-status:error = no.
          end.
        END CASE.
        if error-status:error then do:
          {&error-in-file-format}
        end.
        delete buf_temp-temp.
      end.
      find first ub.chk-discnt where   ub.chk-discnt.doc-code = ub.chk-doc.doc-code
      and ub.chk-discnt.record-type = 5
      and ub.chk-discnt.promo-id = Promo-Id no-error.
      if available ub.chk-discnt then do:
          ub.chk-discnt.object-sum = ub.chk-discnt.object-sum + promo-count.
      end.    
      else do:
          create ub.chk-discnt.
          assign
          ub.chk-discnt.doc-code = ub.chk-doc.doc-code
          ub.chk-discnt.record-type = 5
          ub.chk-discnt.promo-id = Promo-Id
          ub.chk-discnt.line-num = 0
          ub.chk-discnt.object-sum = promo-count
          ub.chk-discnt.discnt-id = (var-discnt-id + 1)
         /* ub.chk-discnt.discnt-id = (if bonus-trans-id_ = 0 then ub.chk-discnt.line-num else bonus-trans-id_) 
          chk-discnt.time-oper = chk-gds.time-oper
          chk-discnt.line-type = (if bonus-type-chr_ = 'I' or bonus-type-chr_ = '0'
                                  then integer({&discnt-gds})
                                  else (if bonus-type-chr_ = 'T'
                                        then integer({&discnt-sub-total})
                                        else integer({&discnt-unknown})
                                       )
                                  )
          chk-discnt.pass-discnt = bonus-obj_
          chk-discnt.value-type = integer({&discnt-v-bonus})
          chk-discnt.src-d-card = bonus-card-no
          chk-discnt.d-card = bonus-card-no
          chk-discnt.discnt-value-abs = bonus-qty_
          chk-discnt.discnt-value-pcnt = (if chk-discnt.line-type = integer({&discnt-gds})
                                          then bonus-src-code_
                                          else 0)
          chk-discnt.discnt-type = bonus-reason_
          chk-discnt.kateg = (if bonus-curr-code_ > 0
                              then bonus-curr-code_
                              else (if bonus-curr-code_ = kassa-rub-code
                                    then 0
                                    else -1 )
                              )
          chk-discnt.object-line-num = (if bonus-string <= 0
                                        then bonus-string
                                        else chk-gds.line-num)
                                        */
          chk-discnt.object-line-num = 0                              
          chk-discnt.pay-desk = chk-doc.pay-desk
          chk-discnt.obj-code = chk-doc.obj-code
          chk-discnt.obj-type = chk-doc.obj-type
          chk-discnt.chk-date = chk-doc.chk-date
          chk-discnt.shift-date = chk-doc.shift-date
          chk-discnt.shift-num = chk-doc.shift-num
          chk-discnt.chk-time = chk-doc.chk-time
          .
          var-discnt-id = var-discnt-id + 1.
      end.
    end. /*if exist*/
  end.

end procedure. /* proc-bonus */

procedure proc-disc :
define variable lnd-spl as integer no-undo .
define buffer buf_temp-temp for temp-temp .
define variable disc-sum_ as decimal no-undo .
define variable disc-pcnt_ as decimal no-undo .
define variable disc-reason_ as integer no-undo .
define variable disc-vtype_ as integer no-undo .
define variable disc-type_ as integer no-undo .
define variable disc-mode_ as character no-undo .
define variable disc-promo-id_ as character no-undo .
define variable disc-sign_ as logical no-undo .
define variable local-netto-for-sub-d as decimal no-undo .
define buffer buf_chk-gds for ub.chk-gds.
define buffer buf_chk-discnt for ub.chk-discnt.
define variable disc-gds-reason as int no-undo .

  do
  on error undo, return error
  :
    if not exist then do:
      if ub.chk-doc.chk-type = integer({&rcpt-annu}) then return.  /* Для аннулированных чеков не будет закачивать скидки, а то дальше куча ошибок лезет */     
  
      for each buf_temp-temp where
              buf_temp-temp.record-name = "CDisc":U
        AND buf_temp-temp.id = v-id:
        CASE buf_temp-temp.field-name:
          when "CDSum":U then do:
            assign
            disc-sum_ = fdecimal(buf_temp-temp.field-value)
            no-error .
          end.
          when "CDPersent":U then do:
            assign
            disc-pcnt_ = fdecimal(buf_temp-temp.field-value)
            no-error .
          end.
          when "CDString":U then do:
            assign
            lnd-spl = integer(buf_temp-temp.field-value)
            no-error .
          end.
          when "CDReason":U then do:
            assign
            disc-reason_ = integer(buf_temp-temp.field-value)
            no-error .
          end.
          when "CDRank":U then do:
            assign
            disc-type_ = integer(buf_temp-temp.field-value)
            no-error .
          end.
          when "CDType":U then do:
            assign
            disc-sign_ = if integer(buf_temp-temp.field-value) = 1
                         or integer(buf_temp-temp.field-value) = 3
                         then no
                         else yes
            no-error .
          end.
          when "CDVType":U then do:
            assign
            disc-vtype_ = (if buf_temp-temp.field-value = "P":U
                           then integer({&discnt-v-pcnt})
                           else (if buf_temp-temp.field-value = "A":U
                                 then integer({&discnt-v-abs})
                                 else (if buf_temp-temp.field-value = "G":U
                                 then integer({&discnt-v-gift}) 
                                 else integer({&discnt-v-unknown})
                                      )
                                )
                           )
            no-error .
          end.
          when "CDMode":U then do:
            assign
            disc-mode_ = buf_temp-temp.field-value
            no-error .
          end.
          when "CDCard":U then do:
            assign
            disc-d-card = buf_temp-temp.field-value
            no-error .
          end.
          when "CDDoc":U then do:
            assign
            disc-gds-reason = int(buf_temp-temp.field-value) 
            no-error .
            error-status:error = no.
          end.
          otherwise do:
            error-status:error = no.
          end.
        END CASE.
        if error-status:error then do:
          {&error-in-file-format}
        end.
        delete buf_temp-temp.
      end.
      if disc-mode_ = "B":U  then return.  /* Игнорируем тип скидки B, который используется для хранения бонусов на кассе */ 
      if disc-mode_ <> 'T':U then do:
        find first buf_chk-gds where
                  buf_chk-gds.doc-code = chk-doc.doc-code
              AND buf_chk-gds.line-num = lnd-spl no-error .
        if disc-mode_ = 'I':U then do:
          if not Available buf_chk-gds then do:
              
            assign
            p-view-log = yes.
            run write-log-and-file in p-log-handle (
                  input 1
                , input log-file-name
                , input 1
                , input substitute( "!!!Несуществующая строка чека &1 для скидки:&2" +
                                    "номер чека на кассе &5 касса &6"
                                    , lnd-spl
                                    , {&new-line}
                                    , chk-num_
                                    , pay-desk_
                                                )).
            return.
           
          end.
        end.
        else if not (disc-mode_ = 'C':U or disc-mode_ = 'P':U) then do:
            assign
            p-view-log = yes.
            run write-log-and-file in p-log-handle (
                  input 1
                , input log-file-name
                , input 1
                , input substitute( "!!!Неопределенный тип скидки с № строки &1 в чеке:&2" +
                                    "номер чека на кассе &3 касса &4&2" +
                                    "скидка не будет обработана"
                                    , lnd-spl
                                    , {&new-line}
                                    , chk-num_
                                    , pay-desk_
                                                )).
            return.
        end.
      end.
      if disc-mode_ = "T":U
      and lng > lnd-spl
      and (p-pos-type = {&cd-type-ibm-xml}
           or
           p-pos-type = {&cd-type-autotank}
           )
      then do:
        for each buf_chk-gds no-lock where
                buf_chk-gds.doc-code = ub.chk-doc.doc-code
            and buf_chk-gds.line-num <= lnd-spl:
          if ub.chk-doc.chk-type = integer({&rcpt-tech-refuell}) then do:
            assign
            local-netto-for-sub-d = local-netto-for-sub-d + (if v-is-petrol-check then 0
                                                else (buf_chk-gds.src-price - buf_chk-gds.src-discnt) * buf_chk-gds.src-qnty)
            .
          end.
          else  do:
            assign
            local-netto-for-sub-d = local-netto-for-sub-d + (if (buf_chk-gds.write-off-code = ?
                                                or buf_chk-gds.write-off-code <= 0)
                                                and not v-is-petrol-check
                                                then
                                                ((buf_chk-gds.src-price - buf_chk-gds.src-discnt) * buf_chk-gds.src-qnty)
                                                else 0)
            .
          end.
        end.
      end.
      else do:
        local-netto-for-sub-d = netto-for-sub-d.
      end.
      if disc-reason_ = 15 then do:
          disc-promo-id_ = disc-d-card.
          disc-d-card  = '':U.
      end.    
      create chk-discnt.
      assign
      ub.chk-discnt.doc-code = ub.chk-doc.doc-code
      ub.chk-discnt.record-type = if disc-mode_ = "C":U then 10 else 0
      ub.chk-discnt.discnt-id = (var-discnt-id + 1)
      ub.chk-discnt.time-oper = v-time
      ub.chk-discnt.line-type = (if disc-mode_ = "I":U
                             then integer({&discnt-gds})
                             else (if disc-mode_ = "T":U or (disc-mode_ = "P":U and disc-reason_ = 16)
                                   then integer({&discnt-sub-total})
                                   else integer({&discnt-unknown})
                                   )
                             )
      kriv3 = (if disc-mode_ = "T"
               and p-pos-type = {&cd-type-ibm-xml}
               then yes
               else kriv3 )
      ub.chk-discnt.line-sign =   disc-sign_
      ub.chk-discnt.pass-discnt = integer({&discnt-p-auto})
      ub.chk-discnt.value-type = if disc-vtype_ = 0
                              then integer({&discnt-v-unknown})
                              else disc-vtype_
      ub.chk-discnt.src-d-card = (if available buf_chk-gds
                                  then buf_chk-gds.src-d-card
                               else (if available ub.chk-gds
                                     then ub.chk-gds.src-d-card
                                     else '')
                                     )
      chk-discnt.d-card = (if available buf_chk-gds
                              then  buf_chk-gds.d-card
                          else (if available ub.chk-gds
                                then ub.chk-gds.d-card
                                else '')
                                )
      chk-discnt.d-card = (if disc-d-card = "" or disc-d-card = ? then ub.chk-discnt.d-card else disc-d-card)
      chk-discnt.discnt-value-abs = - disc-sum_ /*скидка идет со знаком минус*/
      chk-discnt.discnt-value-pcnt = (if p-pos-type = {&cd-type-ibm-xml} then (- disc-pcnt_) else disc-pcnt_)
      chk-discnt.object-line-num = lnd-spl
      chk-discnt.pay-desk = chk-doc.pay-desk
      chk-discnt.obj-code = chk-doc.obj-code
      chk-discnt.obj-type = chk-doc.obj-type
      chk-discnt.chk-date = chk-doc.chk-date
      chk-discnt.chk-time = chk-doc.chk-time
      chk-discnt.shift-date = chk-doc.shift-date
      chk-discnt.shift-num = chk-doc.shift-num
      chk-discnt.object-qnty = (if chk-discnt.line-type = integer({&discnt-sub-total})
                                   or not available buf_chk-gds
                                then accum-src-for-sub-d
                                else buf_chk-gds.src-qnty)
      ub.chk-discnt.object-sum = (if ub.chk-discnt.line-type = integer({&discnt-sub-total})
                                     or not available buf_chk-gds
                               then  local-netto-for-sub-d
                               else buf_chk-gds.src-sum)
      var-discnt-id = var-discnt-id + 1
      sub-d = (if chk-discnt.line-type = integer({&discnt-sub-total}) then (sub-d - disc-sum_) else sub-d)
      chk-discnt.promo-id = disc-promo-id_ 
      chk-discnt.templ-rl-root = disc-gds-reason
      .
      
      if ub.chk-discnt.line-type = integer({&discnt-sub-total}) then do:

      ub.chk-discnt.line-num = (if p-pos-type = {&cd-type-ibm-xml}
                                then lnd-spl
                                else (if available ub.chk-gds then ub.chk-gds.line-num else 0)
                                ).
      end.
      else do:
      ub.chk-discnt.line-num = (if p-pos-type = {&cd-type-ibm-xml}
                                then lnd-spl
                                else (if available ub.chk-gds then ub.chk-gds.line-num else 0)
                                ).
      end.                                  
      if chk-discnt.record-type <> 10 then netto-for-sub-d =  netto-for-sub-d - chk-discnt.discnt-value-abs
      .
      if available buf_chk-gds  and chk-discnt.record-type <> 10 then
      assign
      buf_chk-gds.src-discnt =  (if ub.chk-discnt.line-type <> integer({&discnt-sub-total})
                                 and ub.chk-discnt.value-type = integer({&discnt-v-pcnt})
                                 and ub.chk-discnt.discnt-value-pcnt = 100
                                 then buf_chk-gds.src-price
                                 else (buf_chk-gds.src-discnt + (if ub.chk-discnt.line-type <> integer({&discnt-sub-total})
                                                                  then ub.chk-discnt.discnt-value-abs / buf_chk-gds.src-qnty
                                                                  else 0)
                                       )
                                 )
      .

      assign
      ub.chk-discnt.discnt-type = if disc-reason_ > 0 or disc-type_ > 0
                               then convert-discount(disc-reason_, disc-type_, ub.chk-discnt.line-type)
                               else integer({&discnt-t-unknown})
      .
      if chk-discnt.record-type = 10 then chk-discnt.rank = disc-type_.
      if kriv3 = yes
      and disc-mode_ = "I" then do:
        /*должны пройти по всем скидка на итог и скинуть object-sum*/
        for each buf_chk-discnt where
                buf_chk-discnt.doc-code = ub.chk-discnt.doc-code
            AND buf_chk-discnt.line-type = integer({&discnt-sub-total})
            and buf_chk-discnt.line-num >= ub.chk-discnt.object-line-num:
           assign
           buf_chk-discnt.object-sum = buf_chk-discnt.object-sum - ub.chk-discnt.discnt-value-abs.
        end.
      end.
    end. /*if exist*/
    assign
      disc-d-card = "".
  end.

end procedure. /* proc-disc */

procedure proc-magia-discnt :
define input parameter p-d-pcnt as decimal no-undo .
define input parameter p-d-sum as decimal no-undo .
define input parameter p-type as integer no-undo .

  do
  on error undo, return error
  :
    create ub.chk-discnt.
    assign
    ub.chk-discnt.doc-code = ub.chk-doc.doc-code
    ub.chk-discnt.record-type = 0
    ub.chk-discnt.discnt-id = (var-discnt-id + 1)
    ub.chk-discnt.line-num = ub.chk-gds.line-num
    ub.chk-discnt.time-oper = ub.chk-doc.chk-time
    ub.chk-discnt.line-type = integer({&discnt-gds})
    ub.chk-discnt.line-sign =  (chk-gds.src-qnty >= 0 ) NE (chk-gds.src-discnt > 0 )
    ub.chk-discnt.pass-discnt = integer({&discnt-p-auto})
    ub.chk-discnt.value-type = integer({&discnt-v-unknown})
    ub.chk-discnt.discnt-type = p-type
    ub.chk-discnt.src-d-card = ub.chk-doc.src-d-card
    ub.chk-discnt.discnt-value-abs = (if p-d-sum <> 0
                                  then p-d-sum
                                  else 0)
    ub.chk-discnt.object-qnty = ub.chk-gds.src-qnty
    ub.chk-discnt.object-sum = ub.chk-gds.src-sum
    ub.chk-discnt.discnt-value-pcnt =
                                    if ub.chk-gds.src-sum <> 0 and p-d-pcnt <> 0
                                    then  p-d-pcnt
                                    else (if ub.chk-gds.src-sum <> 0
                                          then ub.chk-discnt.discnt-value-abs / ub.chk-gds.src-sum * 100
                                          else 0)
    ub.chk-discnt.object-line-num = ub.chk-gds.line-num
    ub.chk-discnt.pay-desk = ub.chk-doc.pay-desk
    ub.chk-discnt.obj-code = ub.chk-doc.obj-code
    ub.chk-discnt.obj-type = ub.chk-doc.obj-type
    ub.chk-discnt.chk-date = ub.chk-doc.chk-date
    ub.chk-discnt.chk-time = ub.chk-doc.chk-time
    ub.chk-gds.src-discnt =   ub.chk-gds.src-discnt + ub.chk-discnt.discnt-value-abs / ub.chk-gds.src-qnty
    var-discnt-id = var-discnt-id + 1
    .
  end.

end procedure. /* proc-magia-discnt */

{ str/getxibm3.i }

procedure cb-xmlparse-tag-start-check :
define input parameter p-parameter as character no-undo .
/* обработка события "начало Check"*/

do
on error undo, return error
:
  if v-is-spool-file
  and
  v-start-check = 0 then do:
    assign
    v-start-check = v-start-check + 1
    .
  end.
  else do:
    if v-is-spool-file then do:
      /*
      assign
      v-start-check = 0
      .
      */
      run write-log-and-file in p-log-handle (
            input 1
          , input log-file-name
          , input 1
          , input substitute( "!!!Тэг Check не закрыт - чек не завершен перед строкой &1", var-file-line-num)).
      assign
      p-view-log = yes
      .
    end.
  end.
end.

end procedure. /* cb-xmlparse-tag-start-check */

procedure cb-xmlparse-tag-end-check :
define input parameter p-parameter as character no-undo .
/* обработка события "конец check"*/

do
on error undo, return error
:
  /*если мы здесь то кончился чек !!!*/
  if v-start-check =  1 then do:
    assign
    v-start-check = 0
    .
    /*надо уладить все дела со принятыми чеками!!!*/
    run proc-end in this-procedure no-error .
  end.
  else do:
    assign
    v-start-check = v-start-check - 1
    .
    /*todo ошибка*/
  end.
end.

end procedure. /* cb-xmlparse-tag-end-check */



PROCEDURE cb-xmlvalid-procedure-not-found :
do
on error undo, return error
:
define input parameter p-type       as character    no-undo.
define input parameter p-value      as character    no-undo.
define input parameter p-parameters as character    no-undo.
define variable v-id-loc as character no-undo .
define variable v-time-loc as integer no-undo .
define variable v-time-loc-char as character no-undo .
  case p-type
  :
    when "tag-end" then do:
      CASE p-value:
        /*
        when "Err":U then do:
           run proc-get-error in this-procedure no-error .
        end.
        */
    /*    when "CSTax":U then do:
          /*session:debug-alert = yes.
          message "CSTax"
          view-as alert-box.
          run proc-01-tax in this-procedure .*/. 
        end.*/
        when "CHead":U then do:
          if v-start-check = 1 then
          run proc-00 in this-procedure no-error .
        end.
        when "CACHistory":U then do:
          run proc-ach in this-procedure ( input exist) no-error .
        end.  
        when "CBarCode":U then do:
          CBCType_= 0.
          CBCString_ = 0.
          CBCBarcode_ = "".
          if v-start-check = 1 then
          run proc-02-gds in this-procedure no-error .
        end.
        when "CAuthorization":U then do:
          AuthType_ = 0.
          qr-alchol_ = "".
          if v-start-check = 1 then
          run proc-CAuthorization in this-procedure no-error .
        end.
        when "ACHData":U then do:
          run proc-ach-data in this-procedure no-error.
        end.
        when "ACHExp":U then do:
          run proc-ach-exp in this-procedure no-error.
        end.
        when "CFReg":U then do:
          if get-chkc_context.z-check then do:
            run proc-cfreg in this-procedure no-error.
          end.
          else do:
            error-status:error = no.
          end.
        end.
        when "CSale":U then do:
          if v-start-check = 1 then
          CASE gbl-type:
            when "1" or
            when "6" or
            when "8" or
            when "14" or
            when "15" or
            when "16" or
            when "17" or
            when "36" or
            when "43" or
            when "44"
            then do:
              run proc-01-gds in this-procedure no-error .
            end.
            when "4" then do:
              run proc-01-wth in this-procedure no-error .
            end.
            otherwise do:
              /* ошибка */
            end.
          END CASE.
        end.
        when "CPay":U then do:
          if v-start-check = 1 then
          do:
            run proc-03 in this-procedure (input (if gbl-type = "4" then 1 else 0)
                                       , input (if gbl-type = "4" then mc-exist else exist)
                                       ) no-error .
            if p-pos-type = {&cd-type-autotank} and autotank-sum-return < 0  then /* товарная строка всегда одна */
            do:
               run create-temp-table-record( input v-record-name, input "CPCode", input  "0")  .
               run create-temp-table-record( input v-record-name, input "CPTotal", input  string(autotank-sum-return))  .
               run create-temp-table-record( input v-record-name, input "CPString", input  "2")  .

               run proc-03 in this-procedure (input (if gbl-type = "4" then 1 else 0)
                                       , input (if gbl-type = "4" then mc-exist else exist)
                                       ) no-error .
               create ub.chk-pay-attr.
               assign ub.chk-pay-attr.doc-code = ub.chk-pay.doc-code
                      ub.chk-pay-attr.line-num = 2
                      ub.chk-pay-attr.attr-code = "autotank-sum-return"
                      ub.chk-pay-attr.attr-value = string(autotank-sum-return)
                      autotank-sum-return = 0
                      .

            end .
          end .
        end.  
        when "BonusAdd":U then do:
          if v-start-check = 1 then
          run proc-bonus in this-procedure no-error .
        end.
        when "CPromo":U then do:
          if v-start-check = 1 then
          run proc-promo in this-procedure no-error .
        end.
        when "CDisc":U then do:
          if v-start-check = 1 then
          run proc-disc in this-procedure no-error .
        end.
        when "Invent":U then do:
          if v-start-check = 1 then
          run proc-inv in this-procedure no-error .
        end.
        when "Cash":U then do:
          if v-start-check = 1 then
          run proc-cash in this-procedure (input mc-exist) no-error .
        end.
        when "CFiscal":U then do:
          if v-start-check = 1 then do:
            if get-chkc_context.z-check then do:
              run proc-cfiscal in this-procedure ( input exist) no-error .
            end.
            else do:
              error-status:error = no.
            end.
          end.
        end.
        when "Advance":U then do:
        end.
        when "DocumentName":U
        or
        when "DateFormat":U
        or
        when "DocumentVersion":U
        or
        when "objList":U then do:
          run fill-doc-property in this-procedure (
                input p-value                 /* имя прочитанного тэга */
              , input v-xmlvalid-tag-value    /* значение прочитанного тэга */
          ) no-error .
          if error-status :error
          then do:
            assign
            p-view-log = yes
            .
            run write-log-and-file in p-log-handle (
                  input 1
                , input log-file-name
                , input 1
                , input substitute( "!!!При обработке файла &1 произошла ошибка при чтении свойств документа XML: &2"
                                    , file_
                                    , return-value
                                  )
                                                  ).
            assign
            p-view-log = yes
            .
            return "error":U.
          end.
        end.
        otherwise do:
          run create-temp-table-record( input v-record-name, input p-value, input  v-xmlvalid-tag-value) no-error .
          if error-status :error
          then do:
            run write-log-and-file in p-log-handle (
                  input 1
                , input log-file-name
                , input 1
                , input substitute( "!!!При обработке файла &1 произошла ошибка при чтении записей документа XML: &2"
                                    , file_
                                    , return-value
                                  )
                                                  ).
            assign
            p-view-log = yes
            .
            return "error":U.
          end.
        end.
      end CASE.
    end.
    when "tag-start" then do:
      CASE p-value:
        when "CHead":U
        or
        when "CBarCode":U
        or
        when "CAuthorization":U
        or
        when "CSale":U
        or
        when "CPay":U
        or
        when "CDisc":U
        or
        when "BonusAdd":U
        or
        when "CPromo":U
        or
        when "BonusAdd":U
        or
        when "Invent":U
        or
        when "Cash":U
        or
        when "Advance":U
        or
        when "CACHistory"
        or
        when "ACHData"
        or
        when "ACHExp"
        or
        when "CFReg"
        or
        when "CFiscal"
        /*or
        when "Cstax" */
        then do:
          if p-value = "CACHistory" then do:
            define buffer buf_achd for achd.
            define buffer buf_ache for ache.
            for each buf_achd:
              delete buf_achd.
            end.
            for each buf_ache:
              delete buf_ache.
            end.
          end.
          if v-start-check = 1 then do:
            assign
            v-record-name = p-value
            .
            if  not (p-value = "ACHData"
                     or
                     p-value = "ACHExp"
                     or
                     p-value = "CFReg"
                    /* or
                     p-value = "CSTax"*/
                    ) then do:
             assign
             CRI = 0
             CRAI = 0
             .
              assign
              v-id-loc = ?
              v-time-loc = ?
              v-time-loc-char = ?
              v-id-loc = cb-xmlparse-get-attr(
                                            input this-procedure:handle
                                          ,input p-value
                                          ,input p-parameters
                                          ,input "id":U
                                          ,input yes)
              v-time-loc-char = cb-xmlparse-get-attr(
                                            input this-procedure:handle
                                          ,input p-value
                                          ,input p-parameters
                                          ,input "time":U
                                          ,input no)
              v-time-loc   = if p-pos-type = {&cd-type-MAGIA-XML} then integer(v-time-loc-char) else v-time-loc
              no-error
              .
            end.
            if (p-value <> "CHead":U
                and
                v-id-loc <> v-id
                and p-value <> "ACHData" and p-value <> "ACHExp" and p-value <> "CFReg" /* and p-value <> "Cstax" */
                ) then do:
              assign
              v-start-check = v-start-check - 1
              .
              run write-log-and-file in p-log-handle (
                    input 1
                  , input log-file-name
                  , input 1
                  , input substitute( "!!!Тэг &1 - атрибут id=&2 не равен соответствующему атрибуту тэга Check - нарушен порядок данных"
                                      ,p-value
                                      ,v-id-loc
                                      )
                                                    ).
              assign
              v-cd-fatal-error = yes
              v-cd-fatal-message = "нарушение протокола обмена"
              p-view-log = yes
              .
              return "error".
            end.
            if  (v-id-loc = ?
                and
                not (p-value = "ACHData"
                     or
                     p-value = "ACHExp"
                     or
                     p-value = "CFReg"
                    /* or
                     p-value = "CSTax"*/
                    )
               )
            or (v-time-loc-char = ?
            and p-value = "CHead":U)
            then do:
              message p-value
              view-as alert-box.
              assign
              v-start-check = v-start-check - 1
              .
              run write-log-and-file in p-log-handle (
                    input 1
                  , input log-file-name
                  , input 1
                  , input substitute( "!!!Тэг &1 - отсутствует необходимый атрибут &2"
                                      , p-value
                                      , (if v-id-loc = ? then "id" else "time")
                                      )
                                                    ).
              assign
              v-cd-fatal-error = yes
              v-cd-fatal-message = "нарушение протокола обмена"
              p-view-log = yes
              .
              return "error".
            end.
            else do:
               if
                not (p-value = "ACHData"
                     or
                     p-value = "ACHExp"
                     or
                     p-value = "CFReg"
                   /*  or
                     p-value = "CSTax" */
                    )
              then
              assign
              v-id = v-id-loc
              v-time = v-time-loc
              v-time-char = v-time-loc-char
              .
            end.
          end. /*if v-start-check*/
        end.
        
         
        otherwise do:
          error-status:error = no.
        end.
      END CASE.
    end.
    when "text"
    then do:
        /* */
    end.
    otherwise do:
        /* */
    end.
  end case.
end.
END PROCEDURE. /* cb-xmlvalid-procedure-not-found */

procedure proc-create-return-write-off :
define input parameter p-doc-code like ub.chk-doc.doc-code no-undo .
define input parameter p-chk-type like ub.chk-doc.chk-type no-undo .
define input  parameter p-write-off-code-2 like ub.chk-gds.write-off-code  no-undo .
define output parameter p-doc-code2 like ub.chk-doc.doc-code no-undo .
define output parameter p-netto-sum as decimal no-undo .
define buffer buf_chk-doc for ub.chk-doc.
define buffer first_chk-doc for ub.chk-doc.
define buffer buf_chk-gds for ub.chk-gds.
define buffer buf_chk-pay for ub.chk-pay.
define buffer buf_chk-discnt for ub.chk-discnt.

  do
  on error undo, return error
  :
    find first first_chk-doc where first_chk-doc.doc-code = p-doc-code no-lock no-error.
    if not available first_chk-doc then do:
      return.
    end.
    FIND  buf_chk-doc where
          buf_chk-doc.obj-type = first_chk-doc.obj-type and
          buf_chk-doc.obj-code = first_chk-doc.obj-code  and
          buf_chk-doc.chk-date = first_chk-doc.chk-date and
          buf_chk-doc.pay-desk = first_chk-doc.pay-desk and
          buf_chk-doc.chk-time = first_chk-doc.chk-time and
          buf_chk-doc.chk-num =  first_chk-doc.chk-num and
          buf_chk-doc.sales-man = first_chk-doc.sales-man and
          buf_chk-doc.chk-type = p-chk-type   NO-ERROR NO-WAIT.
    IF NOT AVAIL buf_chk-doc AND NOT LOCKED buf_chk-doc  AND NOT AMBIGUOUS buf_chk-doc then do:

      CREATE buf_chk-doc .
      assign
      lll = lll + 1
      buf_chk-doc.chk-date = first_chk-doc.chk-date
      buf_chk-doc.chk-time = first_chk-doc.chk-time
      buf_chk-doc.chk-num = first_chk-doc.chk-num
      buf_chk-doc.sales-man = first_chk-doc.sales-man
      buf_chk-doc.pay-desk = first_chk-doc.pay-desk
      buf_chk-doc.cashier = first_chk-doc.cashier
      buf_chk-doc.office = first_chk-doc.office
      buf_chk-doc.obj-type = first_chk-doc.obj-type
      buf_chk-doc.obj-code = first_chk-doc.obj-code
      buf_chk-doc.tot-doc =  0
      buf_chk-doc.discnt = 0
      p-doc-code2 = (if get-chkc_context.db-num = 0
                          then string(next-value(s-chk, {&db-name_schema} ))
                          else string( shop-code ) + {&slash-char} + string( next-value( s-chk, {&db-name_schema} ) ))
      buf_chk-doc.doc-code = p-doc-code2
      buf_chk-doc.netto = 0
      p-netto-sum = - first_chk-doc.netto
      buf_chk-doc.shift-date = first_chk-doc.shift-date
      buf_chk-doc.shift-num = first_chk-doc.shift-num
      buf_chk-doc.src-d-card = first_chk-doc.src-d-card
      buf_chk-doc.src-shift-date = first_chk-doc.src-shift-date
      buf_chk-doc.cash-rate = first_chk-doc.cash-rate
      buf_chk-doc.cash-scale = first_chk-doc.cash-scale
      buf_chk-doc.z-number = first_chk-doc.z-number
      buf_chk-doc.correct = first_chk-doc.correct
      buf_chk-doc.chk-type = p-chk-type
      buf_chk-doc.src-d-pcnt = first_chk-doc.src-d-pcnt
      .
      FOR EACH ub.chk-pay WHERE
              ub.chk-pay.doc-code = first_chk-doc.doc-code :
        BUFFER-COPY ub.chk-pay TO buf_chk-pay
        assign
        buf_chk-pay.tot-sum = - ub.chk-pay.tot-sum
        buf_chk-pay.tot-rubl = - ub.chk-pay.tot-rubl
        buf_chk-pay.tot-base = - ub.chk-pay.tot-base
        buf_chk-pay.doc-code = buf_chk-doc.doc-code
        .
      END.
      assign
      netto-for-sub-d = 0
      accum-src-for-sub-d = 0
      .
      FOR EACH ub.chk-gds WHERE
              ub.chk-gds.doc-code = first_chk-doc.doc-code :
        find first temp-ivs-ibs-line where
                  temp-ivs-ibs-line.line-num = abs(chk-gds.line-num) no-error .
        BUFFER-COPY ub.chk-gds TO buf_chk-gds
        assign
        buf_chk-gds.src-qnty = (if available temp-ivs-ibs-line
                                then (if temp-ivs-ibs-line.qnty-sign[2] = 0
                                      then 0
                                      else  - ub.chk-gds.src-qnty)
                                else - ub.chk-gds.src-qnty)
        buf_chk-gds.src-sum = - (if temp-ivs-ibs-line.qnty-sign[2] = 0
                                then 0
                                else  ub.chk-gds.src-sum)
        buf_chk-gds.doc-code = buf_chk-doc.doc-code
        buf_chk-gds.write-off-code = (if available temp-ivs-ibs-line
                                      then integer(temp-ivs-ibs-line.wro-code[2])
                                      else p-write-off-code-2)
        netto-for-sub-d = netto-for-sub-d + if temp-ivs-ibs-line.return-line
                                            or buf_chk-gds.doc-qnty = 0
                                            then 0
                                            else (
                                                  (if buf_chk-gds.write-off-code = ?
                                                  or buf_chk-gds.write-off-code <= 0
                                                  then
                                                  ((buf_chk-gds.src-price - buf_chk-gds.src-discnt) * buf_chk-gds.src-qnty)
                                                  else 0)
                                                  )
        accum-src-for-sub-d = accum-src-for-sub-d + (if temp-ivs-ibs-line.return-line then 0 else buf_chk-gds.src-qnty)
        .
      END.
      var-discnt-id = 0.
      FOR EACH ub.chk-discnt WHERE
              ub.chk-discnt.doc-code = first_chk-doc.doc-code
          AND ub.chk-discnt.record-type = 0:
        BUFFER-COPY ub.chk-discnt TO buf_chk-discnt
        assign
        buf_chk-discnt.discnt-value-abs = - ub.chk-discnt.discnt-value-abs
        buf_chk-discnt.discnt-value-pcnt = - ub.chk-discnt.discnt-value-pcnt
        buf_chk-discnt.object-qnty = - ub.chk-discnt.object-qnty
        buf_chk-discnt.object-sum = - ub.chk-discnt.object-sum
        buf_chk-discnt.doc-code = buf_chk-doc.doc-code
        var-discnt-id = (if buf_chk-discnt.discnt-id > var-discnt-id
                         then buf_chk-discnt.discnt-id
                         else var-discnt-id)
        .
      END.
    end.
  end.

end procedure. /* proc-create-return-write-off */

procedure proc-netto-2 :
define input parameter p-doc-code like ub.chk-doc.doc-code no-undo .
define input parameter p-doc-code2 like ub.chk-doc.doc-code no-undo .
define output parameter p-netto-sum as decimal no-undo .
define buffer buf1_chk-doc for ub.chk-doc.
define buffer buf_chk-doc for ub.chk-doc.

  do
  on error undo, return error
  :

    find first buf1_chk-doc where buf1_chk-doc.doc-code = p-doc-code no-lock no-error.
    if not available buf1_chk-doc then do:
      return.
    end.
    find first buf_chk-doc where buf_chk-doc.doc-code = p-doc-code2 no-error.
    if not available buf_chk-doc then do:
      return.
    end.
    assign
    buf_chk-doc.netto = - buf1_chk-doc.netto
    p-netto-sum = buf_chk-doc.netto.
    .
  end.

end procedure. /* proc-netto-2 */


procedure recalc-write-off :
define parameter buffer buf_chk-doc for ub.chk-doc.
define input  parameter p-old-gbl-type as character no-undo .
define input  parameter p-gbl-type as character no-undo .
define variable old-chk-type as integer   no-undo extent 2.
define variable old-create-return-write-off as logical   no-undo .
define variable old-return-line as logical   no-undo .
define variable v-step as integer   no-undo .
define variable v-is-modificator as logical   no-undo .
define buffer find_chk-doc for ub.chk-doc.
define buffer buf_chk-gds for ub.chk-gds.
define buffer return_chk-gds for ub.chk-gds.
define buffer buf_temp-ivs-ibs-line for temp-ivs-ibs-line.


  do
  on error undo, return error return-value
  :
    assign
    gbl-type = p-gbl-type.
    for each temp-ivs-ibs where
              temp-ivs-ibs.chtype = gbl-type
          AND temp-ivs-ibs.positive-num-chk = (chk-num_ > 0)
          AND temp-ivs-ibs.positive-netto-sum = (netto-sum_ > 0)
          and temp-ivs-ibs.main-record = yes:
      if temp-ivs-ibs.step_ = 1 then do:
        assign
        old-chk-type[1] = v-chk-type[1]
        v-chk-type[1] = integer(temp-ivs-ibs.rcpt-type-1).
        v-step = temp-ivs-ibs.step.
      end.
      if temp-ivs-ibs.step_ = 2 then do:
        assign
        old-chk-type[2] = v-chk-type[2]
        v-chk-type[2] = integer(temp-ivs-ibs.rcpt-type-1)
        old-create-return-write-off = v-create-return-write-off
        v-create-return-write-off = temp-ivs-ibs.create-return-write-off
        v-write-off-code-2 = integer(temp-ivs-ibs.wro-code)
        v-step = temp-ivs-ibs.step.
        .
      end.
      if v-step = 2
      or (old-chk-type[v-step] <> v-chk-type[v-step]
      and v-step = 1)
      then do:
        FIND  find_chk-doc no-lock where
              find_chk-doc.obj-type = shop-type and
              find_chk-doc.obj-code = shop-code and
              find_chk-doc.chk-date = chk-date_ and
              find_chk-doc.pay-desk = pay-desk_ and
              find_chk-doc.chk-time = chk-time_ and
              find_chk-doc.chk-num = chk-num_ and
              find_chk-doc.chk-type = integer(v-chk-type[v-step])
              NO-ERROR NO-WAIT.
        if available find_chk-doc
        then do:
          if v-step <> 1
          or find_chk-doc.doc-code <> buf_chk-doc.doc-code then
          v-to-delete[v-step] = yes.
        end.
        else do:
          v-to-delete[v-step] = no.
        end.
      end.
    end. /*for each temp-ivs-ibs*/
    /*если чек уже был раньше то его не меняем - считаем его правильным*/
    if v-to-delete[1] = yes then return.
    assign
    sub-d = 0
    var-discnt-id = 0
    lng-sub-d = 0
    netto-for-sub-d = 0
    accum-src-for-sub-d = 0
    buf_chk-doc.chk-type = v-chk-type[1]
    .
    for each buf_chk-gds where buf_chk-gds.doc-code = buf_chk-doc.doc-code:
      if buf_chk-gds.line-num < 0 then next.
      &scop wro-code string(buf_chk-gds.write-off-code)
      v-is-modificator = {&wro-is-modificator}.
      do v-step = 1 to (if v-create-return-write-off then 2 else 1):
        find first buf_temp-ivs-ibs-line where
                  buf_temp-ivs-ibs-line.line-num = abs(buf_chk-gds.line-num).
        find first temp-ivs-ibs where
                  temp-ivs-ibs.chtype = gbl-type
              AND temp-ivs-ibs.cstype = buf_temp-ivs-ibs-line.cstype
              and temp-ivs-ibs.cancelcode = buf_temp-ivs-ibs-line.cancelcode
              and temp-ivs-ibs.positive-num-chk = (buf_chk-doc.chk-num > 0)
              and temp-ivs-ibs.positive-netto-sum = (netto-sum_ > 0)
              and temp-ivs-ibs.modificator = buf_temp-ivs-ibs-line.modificator
              and (v-is-modificator = no or temp-ivs-ibs.modificator-np = buf_temp-ivs-ibs-line.modificator-np)
              and temp-ivs-ibs.step_ = v-step no-error .
        if available temp-ivs-ibs then do:
          if v-step  = 1 then do:
            assign
            temp-ivs-ibs-line.chtype = temp-ivs-ibs.chtype
            temp-ivs-ibs-line.create-return-write-off =  temp-ivs-ibs.create-return-write-off
            old-return-line = buf_temp-ivs-ibs-line.return-line
            temp-ivs-ibs-line.return-line = temp-ivs-ibs.return-line
            temp-ivs-ibs-line.rcpt-type-1                        = temp-ivs-ibs.rcpt-type-1
            temp-ivs-ibs-line.wro-code[v-step]                   = temp-ivs-ibs.wro-code
            temp-ivs-ibs-line.qnty-sign[v-step]                  = temp-ivs-ibs.qnty-sign
            .
          end.
          if v-step = 2
          and available buf_temp-ivs-ibs-line
          and available temp-ivs-ibs then do:
            assign
            buf_temp-ivs-ibs-line.rcpt-type-2                        = temp-ivs-ibs.rcpt-type-1
            buf_temp-ivs-ibs-line.wro-code[v-step]                   = temp-ivs-ibs.wro-code
            buf_temp-ivs-ibs-line.qnty-sign[v-step]                  = temp-ivs-ibs.qnty-sign
            .
          end.
        end. /*avaial temp-ovs-ibm*/
      end. /*do v-step*/
      if old-return-line = no
      and buf_temp-ivs-ibs-line.return-line = no then do:
        /*сотрем*/
        find first return_chk-gds where
                  return_chk-gds.doc-code = buf_chk-doc.doc-code
              AND return_chk-gds.line-num = - buf_chk-gds.line-num no-error .
        if available return_chk-gds then delete return_chk-gds.
      end.
      assign
      buf_chk-gds.write-off-code = integer(buf_temp-ivs-ibs-line.wro-code[1])
      netto-for-sub-d = netto-for-sub-d + if buf_temp-ivs-ibs-line.return-line
                                        then 0
                                        else (
                                              (if buf_chk-gds.write-off-code = ?
                                              or buf_chk-gds.write-off-code <= 0
                                              then
                                              ((buf_chk-gds.src-price - buf_chk-gds.src-discnt) * buf_chk-gds.src-qnty)
                                              else 0)
                                              )
      accum-src-for-sub-d = accum-src-for-sub-d + (if buf_temp-ivs-ibs-line.return-line then 0 else buf_chk-gds.src-qnty)
      .
      if old-return-line  = no
      and buf_temp-ivs-ibs-line.return-line = yes then do:
        create return_chk-gds.
        buffer-copy buf_chk-gds to return_chk-gds
        assign
        return_chk-gds.src-sum   = - buf_chk-gds.src-sum
        return_chk-gds.src-qnty  = - buf_chk-gds.src-qnty
        return_chk-gds.src-discnt = - buf_chk-gds.src-discnt
        return_chk-gds.doc-qnty = - buf_chk-gds.doc-qnty
        return_chk-gds.line-sign = (not buf_chk-gds.line-sign)
        return_chk-gds.line-num = - buf_chk-gds.line-num
        .
        return.
      end.


    end. /*for each buf_chk-gds*/
  end. /*doe*/

end procedure. /* recalc-write-off */

{ str/cd-trans.i ach }
{ str/cd-trans.i achexp }
{ str/cd-trans.i achdata }


procedure proc-ach-data :
define variable num_ as integer no-undo .
define variable loc-shop-code as integer no-undo .
define variable trans-num_ as integer no-undo .
define buffer buf_temp-temp for temp-temp.
define buffer buf_achd for achd.

do
on error undo, return error
:
  assign
  chk-date_ = ?
  chk-time_ = 0
  pay-desk_ = 0
  bc-buf = ""
  pump_ = 0
  nozzle_ = 0
  curr-string-qnty = 0
  .
  for each buf_temp-temp where
          buf_temp-temp.record-name = "ACHData":U
      AND buf_temp-temp.id = v-id:
    CASE buf_temp-temp.field-name:
      when "ACHDNum":U then do:
        assign
        num_ =  integer( buf_temp-temp.field-value)
        no-error .
      end.
      when "ACHDDate":U then do:
        assign
        chk-date_ =  cb-xmlparse-get-date( buf_temp-temp.field-value)
        chk-time_ =  cb-xmlparse-get-time( buf_temp-temp.field-value)
        no-error .
      end.
      when "ACHDShop" then do:
        assign
        loc-shop-code = integer(buf_temp-temp.field-value)
        no-error.
      end.
      when "ACHDCashNum" then do:
        assign
        pay-desk_ = integer(buf_temp-temp.field-value)
        no-error .
      end.
      when "ACHDCode" then do:
        assign
        bc-buf = buf_temp-temp.field-value
        no-error .
      end.
      when "ACHDTRNum" then do:
        assign
        trans-num_ = integer(buf_temp-temp.field-value)
        no-error .
      end.
      when "ACHDTRK" then do:
        assign
        pump_ = integer(buf_temp-temp.field-value)
        no-error .
      end.
      when "ACHDNozzle" then do:
        assign
        nozzle_ = integer(buf_temp-temp.field-value)
        no-error .
      end.
      when "ACHDVol" then do:
        assign
        curr-string-qnty = decimal(buf_temp-temp.field-value)
        no-error .
      end.
      otherwise do:
        error-status:error = no.
      end.
    END CASE.
    if error-status:error then do:
      {&error-in-file-format}
    end.
    delete buf_temp-temp.
  end. /*for each buf_temp-temp*/
  find first buf_achd where
            buf_achd.num = num_ no-error.
  if not available buf_achd then do:
    create buf_achd.
    assign
    buf_achd.num = num_.
  end.
  assign
  buf_achd.chk-date = chk-date_
  buf_achd.chk-time = chk-time_
  buf_achd.obj-type = {&shop}
  buf_achd.obj-code = loc-shop-code
  buf_achd.pay-desk = pay-desk_
  buf_achd.src-code = bc-buf
  buf_achd.pump = pump_
  buf_achd.nozzle-code = nozzle_
  buf_achd.src-qnty = curr-string-qnty
  buf_achd.trans-num = trans-num_
  .
end.

end procedure. /* porc-ach-data */


procedure proc-ach-exp :
define variable bc-buf_e as character no-undo .
define variable total-exp as decimal no-undo .
define variable month-exp as decimal no-undo .
define variable day-exp as decimal no-undo .
define variable chk-date_el as date no-undo .
define variable chk-time_el as integer no-undo .
define buffer buf_temp-temp for temp-temp.
define buffer buf_ache for ache.

do
on error undo, return error
:
  for each buf_temp-temp where
          buf_temp-temp.record-name = "ACHExp":U
      AND buf_temp-temp.id = v-id:
    CASE buf_temp-temp.field-name:
      when "ACHECode" then do:
        assign
        bc-buf_e = buf_temp-temp.field-value
        no-error
        .
      end.
      when "ACHEExp" then do:
        assign
        total-exp = decimal(buf_temp-temp.field-value)
        no-error
        .
      end.
      when "ACHEMonthExp" then do:
        assign
        month-exp = decimal(buf_temp-temp.field-value)
        no-error
        .
      end.
      when "ACHEDayExp" then do:
        assign
        day-exp = decimal(buf_temp-temp.field-value)
        no-error
        .
      end.
      when "ACHELastDate" then do:
        assign
        chk-date_el =  cb-xmlparse-get-date( buf_temp-temp.field-value)
        chk-time_el =  cb-xmlparse-get-time( buf_temp-temp.field-value)
        no-error .
      end.
      otherwise do:
        error-status:error = no.
      end.
    END CASE.
    if error-status:error then do:
      {&error-in-file-format}
    end.
    delete buf_temp-temp.
  end. /*for each buf_temp-temp*/
  find first buf_ache where
            buf_ache.src-code = bc-buf_e no-error.
  if not available buf_ache then do:
    create buf_ache.
    assign
    buf_ache.src-code = bc-buf_e
    .
  end.
  assign
  buf_ache.{&achelastdate} = chk-date_el
  buf_ache.chk-time = chk-time_el
  buf_ache.total-exp = total-exp
  buf_ache.month-exp = month-exp
  buf_ache.day-exp = day-exp
  .
end.

end procedure. /* porc-ach-exp */

procedure proc-ach :
define input parameter loc-exist as logical no-undo .
define variable status-int as integer no-undo .
define variable error-code-int as integer no-undo .
define variable error-code-char as character no-undo .
define variable curr-string-qnty-2 as decimal no-undo .
define variable ret-flag-log as logical no-undo .
define variable trans-num_ as integer no-undo .
define variable dur-int as integer no-undo .
define variable bc-buf_e as character no-undo .
define variable total-exp as decimal no-undo .
define variable month-exp as decimal no-undo .
define variable day-exp as decimal no-undo .
define variable chk-date_el as date no-undo .
define variable chk-time_el as integer no-undo .
define variable v-ach-id as character no-undo .

define buffer buf_temp-temp for temp-temp.
define buffer buf_cd-trans for ub.cd-trans.
define buffer buf2_cd-trans for ub.cd-trans.
define buffer buf3_cd-trans for ub.cd-trans.
define buffer buf_achd for achd.
define buffer buf_ache for ache.
do
on error undo, return error
:

  assign
  bc-buf = ""
  price-from-check = 0
  curr-string-qnty = 0
  chk-id_ = ""
  d-card_ = ""
  pump_ = 0
  v-ach-id = ''
  .
  if loc-exist then return.
  for each buf_temp-temp where
          buf_temp-temp.record-name = "CACHistory":U
      AND buf_temp-temp.id = v-id:
    CASE buf_temp-temp.field-name:
      when "CACHDate":U then do:
        assign
        chk-date_ =  cb-xmlparse-get-date( buf_temp-temp.field-value)
        chk-time_ =  cb-xmlparse-get-time( buf_temp-temp.field-value)
        no-error .
      end.
      when "CACHCardNum" then do:
        assign
        d-card_ = buf_temp-temp.field-value
        no-error.
      end.
      when "CACHStatus" then do:
        assign
        status-int = integer(buf_temp-temp.field-value)
        no-error .
      end.
      when "CACHErrCode" then do:
        assign
        error-code-int = integer(buf_temp-temp.field-value)
        no-error .
      end.
      when "CACHErrMess" then do:
        assign
        error-code-char = buf_temp-temp.field-value
        no-error .
      end.
      when "CACHTRKNum" then do:
        assign
        pump_ = integer(buf_temp-temp.field-value)
        no-error .
      end.
      when "CACHCode" then do:
        assign
        bc-buf = buf_temp-temp.field-value
        no-error .
      end.
      when "CACHOrderVol" then do:
        assign
        curr-string-qnty = decimal(buf_temp-temp.field-value)
        no-error .
      end.
      when "CACHTakeVol" then do:
        assign
        curr-string-qnty-2 = decimal(buf_temp-temp.field-value)
        no-error .
      end.
      when "CACHRet" then do:
        assign
        ret-flag-log = logical(buf_temp-temp.field-value)
        no-error .
      end.
      when "CACHTranzNum" then do:
        assign
        trans-num_ = integer(buf_temp-temp.field-value)
        no-error .
      end.
      when "CACHTime" then do:
        assign
        dur-int = integer(buf_temp-temp.field-value)
        no-error .
      end.
      when "CACHPrice" then do:
        assign
        price-from-check = decimal(buf_temp-temp.field-value)
        no-error .
      end.
      when "CACHCheckID" then do:
        assign
        chk-id_ = buf_temp-temp.field-value
        no-error .
      end.
      when "CACHistoryID" then do:
        assign
        v-ach-id = buf_temp-temp.field-value
        no-error .
      end.
      otherwise do:
        error-status:error = no.
      end.
    END CASE.
    if error-status:error then do:
      {&error-in-file-format}
    end.
    delete buf_temp-temp.
  end. /*for each buf_temp-temp*/
  find first buf_cd-trans share-lock where
            buf_cd-trans.trans-id-chr = v-ach-id
       and buf_cd-trans.trans-type  = integer({&cdt-ach})
       and buf_cd-trans.obj-type = shop-type
       and buf_cd-trans.obj-code = shop-code
       and buf_cd-trans.{&achdate} = chk-date_
       and buf_cd-trans.chk-time = chk-time_
       no-error.
  if not available buf_cd-trans then do:
    create buf_cd-trans.
    assign
    buf_cd-trans.db-num   = g#db-num
    buf_cd-trans.trans-id = next-value(s-cd-trans, {&db-name_schema})
    buf_cd-trans.trans-type  = integer({&cdt-ach})
    buf_cd-trans.obj-type = shop-type
    buf_cd-trans.obj-code = shop-code
    buf_cd-trans.trans-id-chr = v-ach-id
    buf_cd-trans.{&achdate} = chk-date_
    buf_cd-trans.chk-time = chk-time_
    .
  end.
  assign
  buf_cd-trans.src-shift-date = ub.chk-doc.src-shift-date
  buf_cd-trans.src-shift-name = ub.chk-doc.src-shift-name
  buf_cd-trans.pay-desk = ub.chk-doc.pay-desk
  buf_cd-trans.{&achcheckid} = chk-id_
  buf_cd-trans.{&achcardnum} = d-card_
  buf_cd-trans.{&achcode} = bc-buf
  buf_cd-trans.{&acherrmess} = error-code-char
  buf_cd-trans.{&achordervol} = curr-string-qnty
  buf_cd-trans.{&achtakevol} = curr-string-qnty-2
  buf_cd-trans.{&achprice} = price-from-check
  buf_cd-trans.{&achstatus} = status-int
  buf_cd-trans.{&acherrcode} = error-code-int
  buf_cd-trans.{&achtranznum} = trans-num_
  buf_cd-trans.{&achtime} = dur-int
  buf_cd-trans.{&achtrknum} = pump_
  buf_cd-trans.{&achret} = ret-flag-log
  .
  for each buf_ache:
    find first buf2_cd-trans share-lock where
              buf2_cd-trans.trans-id-chr = v-ach-id
        and buf2_cd-trans.trans-type  = integer({&cdt-achexp})
        and buf2_cd-trans.obj-type = shop-type
        and buf2_cd-trans.obj-code = shop-code
        and buf2_cd-trans.{&achecode} = buf_ache.src-code
        no-error.
    if not available buf2_cd-trans then do:
      create buf2_cd-trans.
      assign
      buf2_cd-trans.db-num   = g#db-num
      buf2_cd-trans.trans-id = next-value(s-cd-trans, {&db-name_schema})
      buf2_cd-trans.trans-type  = integer({&cdt-achexp})
      buf2_cd-trans.obj-type = shop-type
      buf2_cd-trans.obj-code = shop-code
      buf2_cd-trans.trans-id-chr = v-ach-id
      buf2_cd-trans.{&achecode} = buf_ache.src-code
      .
    end.
    assign
    buf2_cd-trans.{&achecardnum} = d-card_
    buf2_cd-trans.{&acheexp} = buf_ache.total-exp
    buf2_cd-trans.{&achemonthexp} = buf_ache.month-exp
    buf2_cd-trans.{&achedayexp} = buf_ache.day-exp
    buf2_cd-trans.{&achelastdate} = buf_ache.chk-date
    buf2_cd-trans.chk-time = buf_ache.chk-time
    .
  end.
  for each buf_achd:
    find first buf2_cd-trans share-lock where
              buf2_cd-trans.trans-id-chr = v-ach-id
        and buf2_cd-trans.trans-type  = integer({&cdt-achdata})
        and buf2_cd-trans.obj-type = buf_achd.obj-type
        and buf2_cd-trans.{&achdshop} = buf_achd.obj-code
        and buf2_cd-trans.{&achddate} = buf_achd.chk-date
        and buf2_cd-trans.chk-time = buf_achd.chk-time
        and buf2_cd-trans.{&achdnum} = buf_achd.num
        no-error.
     if not available buf2_cd-trans then do:
       create buf2_cd-trans.
       assign
        buf2_cd-trans.db-num   = g#db-num
        buf2_cd-trans.trans-id = next-value(s-cd-trans, {&db-name_schema})
        buf2_cd-trans.trans-type  = integer({&cdt-achdata})
        buf2_cd-trans.trans-id-chr = v-ach-id
        buf2_cd-trans.obj-type = buf_achd.obj-type
        buf2_cd-trans.{&achdshop} = buf_achd.obj-code
        buf2_cd-trans.{&achddate} = buf_achd.chk-date
        buf2_cd-trans.chk-time = buf_achd.chk-time
        buf2_cd-trans.{&achdnum} = buf_achd.num
        buf2_cd-trans.{&achdcashnum} = buf_achd.pay-desk
        buf2_cd-trans.{&achdcardnum} = d-card
        buf2_cd-trans.{&achdcode} = buf_achd.src-code
        buf2_cd-trans.{&achdtrk} = buf_achd.pump
        buf2_cd-trans.{&achdnozzle} = buf_achd.nozzle-code
        buf2_cd-trans.{&achdtrnum} = buf_achd.trans-num
        buf2_cd-trans.{&achdvol} = buf_achd.src-qnty
        .
     end.
  end.
end. /*doe*/

end procedure. /* proc-ach */

{ str/cd-trans.i cfserial }
{ str/cd-trans.i cfregnum }
{ str/cd-trans.i cfowner }
{ str/cd-trans.i cfeklzserial }
{ str/cd-trans.i cfzcount }
{ str/cd-trans.i cfdate }
{ str/cd-trans.i cfxcount }
{ str/cd-trans.i cfejcount }
{ str/cd-trans.i cfcash }
{ str/cd-trans.i cfdoccount }
{ str/cd-trans.i cfsalesaccum }
{ str/cd-trans.i cfretaccum }
{ str/cd-trans.i cfreg }

procedure proc-cfiscal :
define input parameter loc-exist as logical no-undo .
define variable v-field-name as character no-undo .
define variable v-datatype as character no-undo .
define variable v-int-trans-type as integer no-undo .
define buffer buf_temp-temp for temp-temp.
define buffer buf_cd-trans for ub.cd-trans .

do
on error undo, return error
:
  if not loc-exist then do:
    assign
    tot_sum = 0
    z-num_ = 0
    .
    for each buf_temp-temp where
            buf_temp-temp.record-name = "CFiscal":U
        AND buf_temp-temp.id = v-id:
      v-field-name = ''.
      CASE buf_temp-temp.field-name:
        when "CFSalesAccum" then do:
          assign
          v-field-name = "{&cfsalesaccum}"
          v-datatype = {&abl-datatype-decimal}
          v-int-trans-type = integer({&cdt-cfsalesaccum})
          tot_sum = decimal(buf_temp-temp.field-value)
          no-error .
        end.
        when "CFRetAccum" then do:
          assign
          v-field-name = "{&cfretaccum}"
          v-datatype = {&abl-datatype-decimal}
          v-int-trans-type = integer({&cdt-cfretaccum})
          no-error .
        end.
        when "CFZCount" then do:
          assign
          v-field-name = "{&cfzcount}"
          v-datatype = {&abl-datatype-integer}
          v-int-trans-type = integer({&cdt-cfzcount})
          z-num_ = integer(buf_temp-temp.field-value)
          no-error .
        end.
        when "CFSerial" then do:
          assign
          v-field-name = "{&cfserial}"
          v-datatype = {&abl-datatype-character}
          v-int-trans-type = integer({&cdt-cfserial})
          no-error .
        end.
        when "CFRegNum" then do:
          assign
          v-field-name = "{&cfregnum}"
          v-datatype = {&abl-datatype-character}
          v-int-trans-type = integer({&cdt-cfregnum})
          no-error .
        end.
        when "CFOwner" then do:
          assign
          v-field-name = "{&cfowner}"
          v-datatype = {&abl-datatype-character}
          v-int-trans-type = integer({&cdt-cfowner})
          no-error .
        end.
        when "CFEKLZSerial" then do:
          assign
          v-field-name = "{&cfeklzserial}"
          v-datatype = {&abl-datatype-character}
          v-int-trans-type = integer({&cdt-cfeklzserial})
          no-error .
        end.
        when "CFDate" then do:
          assign
          v-field-name = "{&cfdate}"
          v-datatype = {&abl-datatype-character}
          v-int-trans-type = integer({&cdt-cfdate})
          no-error .
        end.
        when "CFXCount" then do:
          assign
          v-field-name = "{&cfxcount}"
          v-datatype = {&abl-datatype-integer}
          v-int-trans-type = integer({&cdt-cfxcount})
          no-error .
        end.
        when "CFEJCount" then do:
          assign
          v-field-name = "{&cfejcount}"
          v-datatype = {&abl-datatype-integer}
          v-int-trans-type = integer({&cdt-cfejcount})
          no-error .
        end.
        when "CFCash" then do:
          assign
          v-field-name = "{&cfcash}"
          v-datatype = {&abl-datatype-decimal}
          v-int-trans-type = integer({&cdt-cfcash})
          no-error .
        end.
        when "CFDocCount" then do:
          assign
          v-field-name = "{&cfdoccount}"
          v-datatype = {&abl-datatype-integer}
          v-int-trans-type = integer({&cdt-cfdoccount})
          no-error .
        end.
        otherwise do:
          error-status:error = no.
        end.
      END CASE.
      if error-status:error then do:
        {&error-in-file-format}
      end.
      if v-field-name > '' then do:
        find first buf_cd-trans share-lock where
              buf_cd-trans.trans-type = v-int-trans-type
            and buf_cd-trans.obj-type = shop-type
            and buf_cd-trans.obj-code = shop-code
            and buf_cd-trans.chk-date = chk-date_
            and buf_cd-trans.chk-time = chk-time_
            and buf_cd-trans.pay-desk = ub.chk-doc.pay-desk
            and buf_cd-trans.chk-id = v-id
            no-error.
        if not available buf_cd-trans then do:
          create buf_cd-trans.
          assign
          buf_cd-trans.db-num   = g#db-num
          buf_cd-trans.trans-id = next-value(s-cd-trans, {&db-name_schema})
          buf_cd-trans.trans-type = v-int-trans-type
          buf_cd-trans.obj-type = shop-type
          buf_cd-trans.obj-code = shop-code
          buf_cd-trans.chk-date = chk-date_
          buf_cd-trans.chk-time = chk-time_
          buf_cd-trans.chk-id = v-id
          buf_cd-trans.z-number = ub.chk-doc.z-number
          buf_cd-trans.doc-code = ub.chk-doc.doc-code
          buf_cd-trans.src-shift-date = ub.chk-doc.src-shift-date
          buf_cd-trans.src-shift-name = ub.chk-doc.src-shift-name
          buf_cd-trans.pay-desk = ub.chk-doc.pay-desk
          buf_cd-trans.chk-num = ub.chk-doc.chk-num
          .
        end.
        assign
        buf_cd-trans.doc-code = ub.chk-doc.doc-code
        .
        case v-datatype:
          when {&abl-datatype-character} then do:
            buffer buf_cd-trans:handle:buffer-field(v-field-name):buffer-value = string(buf_temp-temp.field-value)
            no-error .
          end.
          when {&abl-datatype-date} then do:
            buffer buf_cd-trans:handle:buffer-field(v-field-name):buffer-value = date(buf_temp-temp.field-value)
            no-error .
          end.
          when {&abl-datatype-decimal} then do:
            buffer buf_cd-trans:handle:buffer-field(v-field-name):buffer-value = decimal(buf_temp-temp.field-value)
            no-error .
          end.
          when {&abl-datatype-integer} then do:
            buffer buf_cd-trans:handle:buffer-field(v-field-name):buffer-value = integer(buf_temp-temp.field-value)
            no-error .
          end.
          when {&abl-datatype-logical} then do:
            buffer buf_cd-trans:handle:buffer-field(v-field-name):buffer-value = logical(buf_temp-temp.field-value)
            no-error .
          end.
        end.
        if error-status:error then do:
          {&error-in-file-format}
        end.
      end. /*if v-field-name > '' then do:*/
      delete buf_temp-temp.
    end. /*for each buf_temp-temp*/
    FIND ub.chk-pay WHERE
          ub.chk-pay.doc-code = ub.chk-doc.doc-code
      AND ub.chk-pay.curr-code = 0
      AND ub.chk-pay.pay-code = 0
      NO-ERROR.
    if NOT available ub.chk-pay
    then  do:
      create ub.chk-pay.
      assign
      lnp = lnp + 1
      ub.chk-pay.doc-code = ub.chk-doc.doc-code
      ub.chk-pay.line-num = lnp
      ub.chk-pay.chk-date = ub.chk-doc.chk-date
      ub.chk-pay.obj-code = shop-code
      ub.chk-pay.obj-type = shop-type
      ub.chk-pay.tot-rubl = 0
      ub.chk-pay.tot-sum = 0
      ub.chk-pay.tot-base = 0
      ub.chk-pay.pay-code = 0
      ub.chk-pay.curr-code = 0
      ub.chk-pay.time-oper = ub.chk-doc.chk-time
      ub.chk-pay.cash-rate = ub.chk-doc.cash-rate
      ub.chk-pay.bank-rate = 1
      ub.chk-pay.bank-scale = 1
      ub.chk-pay.pass-pay =  0
      ub.chk-pay.pay-card = '':U
      ub.chk-pay.line-type = "":U
      ub.chk-pay.line-sign = yes
      ub.chk-pay.is-error = no
      ub.chk-doc.z-number = ( if z-num_ < ub.chk-doc.z-number
                           and z-num_ > 0
                           then z-num_ else ub.chk-doc.z-number)
      .
    end.
    assign
    ub.chk-pay.tot-sum = ub.chk-pay.tot-sum + tot_sum
    .

  end.
end.

end procedure. /* proc-cfiscal */

procedure proc-cfreg :
define variable v-cfrtype as character no-undo .
define variable v-cframount as decimal no-undo .
define variable v-cfrcount as integer no-undo .
define buffer buf_temp-temp for temp-temp.
define buffer buf_cd-trans for ub.cd-trans.
do
on error undo, return error
:
  for each buf_temp-temp where
          buf_temp-temp.record-name = "CFReg":U
      AND buf_temp-temp.id = v-id:
    CASE buf_temp-temp.field-name:
      when "CFRType" then do:
        assign
        v-cfrtype = buf_temp-temp.field-value
        no-error
        .
      end.
      when "CFRCount" then do:
        assign
        v-cfrcount = integer(buf_temp-temp.field-value)
        no-error
        .
      end.
      when "CFRAmount" then do:
        assign
        v-cframount = decimal(buf_temp-temp.field-value)
        no-error
        .
      end.
      otherwise do:
        error-status:error = no.
      end.
    END CASE.
    if error-status:error then do:
      {&error-in-file-format}
    end.
    delete buf_temp-temp.
  end. /*for each buf_temp-temp*/
  find first buf_cd-trans share-lock where
        buf_cd-trans.trans-type = integer({&cdt-cfreg})
      and buf_cd-trans.obj-type = shop-type
      and buf_cd-trans.charkey_one = v-cfrtype
      and buf_cd-trans.obj-code = shop-code
      and buf_cd-trans.chk-date = chk-date_
      and buf_cd-trans.chk-time = chk-time_
      and buf_cd-trans.chk-id = v-id
      and buf_cd-trans.doc-code = ub.chk-doc.doc-code
      no-error.
  if not available buf_cd-trans then do:
    create buf_cd-trans.
    assign
    buf_cd-trans.db-num   = g#db-num
    buf_cd-trans.trans-id = next-value(s-cd-trans, {&db-name_schema})
    buf_cd-trans.trans-type = integer({&cdt-cfreg})
    buf_cd-trans.obj-type = shop-type
    buf_cd-trans.obj-code = shop-code
    buf_cd-trans.chk-date = chk-date_
    buf_cd-trans.chk-time = chk-time_
    buf_cd-trans.chk-id = v-id
    buf_cd-trans.z-number = ub.chk-doc.z-number
    buf_cd-trans.doc-code = ub.chk-doc.doc-code
    buf_cd-trans.src-shift-date = ub.chk-doc.src-shift-date
    buf_cd-trans.src-shift-name = ub.chk-doc.src-shift-name
    buf_cd-trans.pay-desk = ub.chk-doc.pay-desk
    buf_cd-trans.chk-num = ub.chk-doc.chk-num
    buf_cd-trans.chk-num = ub.chk-doc.chk-num
    buf_cd-trans.{&cfreg_cfrtype} = v-cfrtype
    buf_cd-trans.{&cfreg_cfrcount} = v-cfrcount
    buf_cd-trans.{&cfreg_cframount} = v-cframount
    .
  end.
end.

end procedure. /* porc-cfreg */
