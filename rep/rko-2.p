/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Печать платежа  типа расход наличные

Автор: Бахтадзе Наталья Викторовна
Дата создания: 11/20/03
Author: Bakhtadze Natalya
Creation date: 11/20/03

*/

DEFINE INPUT PARAMETER parParentProc  AS WIDGET-HANDLE NO-UNDO.
define parameter buffer buf_fin-doc for ub.fin-doc.
define input parameter p-append as logical no-undo .
define input parameter p-is-last as logical no-undo .
define input parameter p-from-forms as logical no-undo .
define input-output parameter p-format as integer no-undo .
/*1 - Landscape 0 -portrait*/

&SCOP f-l MonthNameRusGen

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Печать платежа  типа расход наличные".

{ cmp/vssrevis.i }
{ cmp/str-glbl.i  }
{ cmp/library.i }
{ gbl/cur-time.i }
{ cmp/r-pril.i new }
{ gbl/prn-lib.i }
{ rep/frmlib.i }
{ gbl/paramls.i }
define variable g#report-num  as integer no-undo .
define variable g#quest-print   as logical      no-undo.
{ rep/rko2xl.i  }

define variable Line              as character no-undo .
define variable v-enclosure-1     as character no-undo .
define variable v-enclosure-2     as character no-undo .
define variable v-doc-date-f      as character no-undo .
define variable v-date-create     as date      no-undo .
define variable v-str-podr-name   as character no-undo .
define variable num-lines         as integer   no-undo .
define variable v-fill            as character no-undo init "_".
define variable v-sum-doc-v1      as character no-undo .
define variable v-sum-doc-v2      as character no-undo .
define variable v-sum-doc-n1      as character no-undo .
define variable v-sum-doc-n2      as character no-undo .
define variable v-sum-kop-p       as character no-undo .
define variable v-dops            as character no-undo .
define variable v-head-position   as character no-undo .
define variable v-sign1           as character no-undo .
define variable v-passport-1      as character no-undo .
define variable v-passport-2      as character no-undo .
define variable v-rub             as character no-undo .
define variable v-kop             as character no-undo .
define variable v-title-rub       as character no-undo .
define variable v-line3           as integer   no-undo .
define variable v-line2           as integer   no-undo .
define variable v-okv-code        as character no-undo .
define variable v-chernovik       as character no-undo .
define variable v-naznach-plat-1  as character no-undo .
define variable v-naznach-plat-2  as character no-undo .
define variable g#log             as logical   no-undo .

define variable v-uchet as character no-undo .
define variable v-value-date as date no-undo .
define variable v-value-decimal as decimal no-undo .
define variable v-value-integer as INTEGER no-undo .
define variable v-value-logical AS LOGICAL no-undo .
define variable par-type as character no-undo .
define variable v-tth as handle no-undo .


define buffer buf_currency for ub.currency.


do
on error undo, return error return-value
:
 run adm/shattri.p (
        input "get":U
        ,input buf_fin-doc.obj-type
        ,input buf_fin-doc.obj-code
        ,input {&attr-fin-doc}
        ,input  {&attr-fin-doc_uchet}
        ,output v-uchet
        ,output v-value-date
        ,output v-value-decimal
        ,output v-value-integer
        ,output v-value-logical
        ,output par-type
        ,INPUT-OUTPUT table-handle v-tth
        ) no-error .
  if error-status :error  then v-uchet = "smen" .

  delete object v-tth no-error.

    run get-report-num  in parParentProc(output g#report-num).
    run get-quest-print in parParentProc(output g#quest-print).
    output to value( string( session:temp-directory + "$" + string( g#report-num ) ) + ".txl" ) .
    output close.
    run rko2xl-init in this-procedure .

 if p-format <> 0
 and p-format <> ?
 and p-append
 then do:
    assign
    p-format = ?
    .
   return.
 end.
  assign
  Line = fill("_":U, 136)
  .
  assign
  v-chernovik = if buf_fin-doc.status_ = {&fin-new}
                then "Ч Е Р Н О В И К"
                else (fill( {&space-char}, 15))
  .
  if buf_fin-doc.curr-code = 0 then do:
    assign
    v-rub = " {&abbr_rub}.":U
    v-kop = " {&abbr_kop}.":U
    v-title-rub = v-rub + v-kop + {&space-char} + {&space-char}
    .
  end.
  else do:
    find first buf_currency no-lock where
               buf_currency.curr-code = buf_fin-doc.curr-code .
    assign
    v-rub = {&space-char} + buf_currency.curr-abbr + ".":U
    v-kop = {&space-char} + buf_currency.part-abbr + ".":U
    v-title-rub = "       инвалюты       ":U
    v-okv-code = (if buf_currency.okv-code = 0
                  then "Код ОКВ?"
                  else string(buf_Currency.okv-code))
    .
  end.

  assign
  v-enclosure-1 = Break-n-line(Buf_fin-doc.enclosure, "62,73", output num-lines)
  v-enclosure-2 = if num-lines >=2
                      then entry(2, v-enclosure-1, {&delim-par})
                      else "":U
  v-enclosure-1 = entry(1, v-enclosure-1, {&delim-par})
  .
  assign
  v-passport-1 = Break-n-line(Buf_fin-doc.receiver-passport, "70,73", output num-lines)
  v-passport-2 = if num-lines >=2
                      then entry(2, v-passport-1, {&delim-par})
                      else "":U
  v-passport-1 = entry(1, v-passport-1, {&delim-par})
  .
  assign
    v-date-create = (if buf_fin-doc.shift-date = ? or v-uchet = "cal" then buf_fin-doc.doc-date else buf_fin-doc.shift-date)
    v-doc-date-f = string(v-date-create, "99.99.9999":U) + " г."
  .
  Case buf_fin-doc.str-podr-type :
    when {&shop} then do:
      find first ub.shop
      where ub.shop.obj-code = buf_fin-doc.str-podr-code
        no-error.
        if available ub.shop then do:
          assign v-str-podr-name = buf_fin-doc.str-podr-name + " " + ub.shop.addres1.
        end.
    end.
    when {&stock} then do:
      find first ub.store
      where ub.store.obj-code = buf_fin-doc.str-podr-code
        no-error.
        if available ub.store then do:
          assign v-str-podr-name = buf_fin-doc.str-podr-name + " " + ub.store.addres1.
        end.
    end.
  end case.
  if v-str-podr-name = "" then v-str-podr-name = buf_fin-doc.str-podr-name .

  assign
  v-naznach-plat-1 = Break-n-line(buf_fin-doc.naznach-plat, "125,136":U, output num-lines)
  v-naznach-plat-2 = (if num-lines >=2
                      then entry(2, v-naznach-plat-1, {&delim-par})
                      else "":U
                      )
  v-naznach-plat-1 = entry(1, v-naznach-plat-1, {&delim-par})
  .

  if buf_fin-doc.curr-code = 0 then do:
    assign
    v-dops = Sum-in-Words-Without-Dec(buf_fin-doc.sum-doc)
    .
    assign
    v-sum-kop-p = string((buf_fin-doc.sum-doc - truncate(buf_fin-doc.sum-doc, 0)) * 100, "99":U)
    .
    v-line2 = 121.
  end.
  else do:
    assign
    v-dops = Sum-in-Words-Invalut(buf_fin-doc.sum-doc, buf_fin-doc.curr-code)
    v-line2 = 136
    .
  end.

  assign
  v-sum-doc-v1 = Break-n-line(v-dops, ("128,":U + string(v-line2)), output num-lines)
  v-sum-doc-v2 = If num-lines >= 2
                 then entry(2, v-sum-doc-v1, {&delim-par})
                 else "":U
  v-sum-doc-v2 =  v-sum-doc-v2 +  fill("-":U, v-line2 - length(v-sum-doc-v2))
  v-sum-doc-v1 =  entry(1, v-sum-doc-v1, {&delim-par})
  v-sum-doc-v1 = v-sum-doc-v1 +  fill("-":U, 128 - length(v-sum-doc-v1))
  v-sum-doc-v1 = caps(substring(v-sum-doc-v1, 1, 1)) + substring(v-sum-doc-v1, 2)
  .
  assign
  v-sum-doc-n1 = Break-n-line(v-dops, ("128,":U + string(v-line2)), output num-lines)
  v-sum-doc-n2 = If num-lines >= 2
                 then entry(2, v-sum-doc-n1, {&delim-par})
                 else "":U
  v-sum-doc-n2 = v-sum-doc-n2 +  fill("-":U, v-line2 - length(v-sum-doc-n2))
  v-sum-doc-n1 = entry(1, v-sum-doc-n1, {&delim-par})
  v-sum-doc-n1 = v-sum-doc-n1 +  fill("-":U, 128 - length(v-sum-doc-n1))
  v-sum-doc-n1 = caps(substring(v-sum-doc-n1, 1, 1)) + substring(v-sum-doc-n1, 2)
  .
  assign
  v-head-position = (if num-entries(buf_fin-doc.payer-sign1, {&delim-par})  > 1
                    then entry(1, buf_fin-doc.payer-sign1, {&delim-par})
                    else "Директор")
  v-sign1         = (if num-entries(buf_fin-doc.payer-sign1, {&delim-par})  > 1
                    then entry(2, buf_fin-doc.payer-sign1, {&delim-par})
                    else entry(1, buf_fin-doc.payer-sign1, {&delim-par})
                    )

  .

  run prn-lib-open-stream  in this-procedure (
                                              input parParentProc
                                              ,input {&CS_PS}
                                              ,input yes /*p-is-stream*/
                                              ,input p-append /*p-append*/
                                              ).
if buf_fin-doc.curr-code = 0 then do:
  PUT  STREAM PrnLibStream unformatted
  Line skip
 v-chernovik    fill({&space-char}, 93)                                                                    "Унифицированная форма N КО-2" skip
                fill({&space-char}, 99)                                                           "Утверждена постановлением Госкомстата" skip
                fill({&space-char}, 110)                                                                     "России от 18.08.98 г. N 88" skip
                fill({&space-char}, 136)                                                                                                  skip
                fill({&space-char}, 125)                                                                                    "+---------+" skip
                fill({&space-char}, 125)                                                                                    "|   Код   |" skip
                fill({&space-char}, 125)                                                                                    "+---------+" skip
                fill({&space-char}, 112)                                                                       "Форма по ОКУД| 0310002 |" skip
                fill({&space-char}, 125)                                                                                    "+---------+" skip
  .
end.
else do:
  PUT  STREAM PrnLibStream unformatted
  Line skip
  fill( {&space-char} , 136)                                                                                                              skip
  fill( {&space-char} , 136)                                                                                                              skip
  fill( {&space-char} , 136)                                                                                                              skip
  fill( {&space-char} , 136)                                                                                                              skip
  fill({&space-char}, 125)                                                                                                  "+---------+" skip
  fill({&space-char}, 125)                                                                                                  "|   Код   |" skip
  fill({&space-char}, 125)                                                                                                  "+---------+" skip
  fill({&space-char}, 112)                                                                                     "Форма по ОКУД|         |" skip
  fill({&space-char}, 125)                                                                                                  "+---------+" skip
 .
end.
    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-h_organization}
        , input buf_fin-doc.payer-name
    ).
    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-h_object}
        , input v-str-podr-name
    ).
    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-h_okpo}
        , input buf_fin-doc.payer-okpo
    ).
    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-h_objectCode}
        , input if buf_fin-doc.str-podr-code = 0 then "" else string( buf_fin-doc.str-podr-code )
    ).
    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-h_docCode}
        , input buf_fin-doc.prn-doc-code
    ).
    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-h_docDate}
        , input string( v-date-create, "99.99.9999":U )
    ).

    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-h_strPodrCode}
        , input (if buf_fin-doc.str-podr-code = 0 then "-" else string( buf_fin-doc.str-podr-code ))
    ).
    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-h_corAccValue}
        , input (if buf_fin-doc.cor-acc-value = "" then "-" else buf_fin-doc.cor-acc-value)
    ).
    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-h_anUchetValue}
        , input (if buf_fin-doc.an-uchet-value = "" then "-" else buf_fin-doc.an-uchet-value)
    ).
    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-h_corAcc1Value}
        , input (if buf_fin-doc.cor-acc1-value = "" then "-" else buf_fin-doc.cor-acc1-value)
    ).
    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-h_sumDoc}
        , input string( Sum-delim-with-defis( buf_fin-doc.sum-doc, 15 ) )
    ).
    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-h_celNaznValue}
        , input (if buf_fin-doc.cel-nazn-value = "" then "-" else buf_fin-doc.cel-nazn-value)
    ).


    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-f_receiverName}
        , input buf_fin-doc.receiver-name
    ).
    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-f_reason}
        , input substitute( "&1 &2", v-naznach-plat-1, v-naznach-plat-2 )
    ).
    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-f_sumPropis1}
        , input v-sum-doc-v1
    ).
    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-f_sumPropis2}
        , input substitute( "&1 &2"
                        , v-sum-doc-v2
                        , ( if buf_fin-doc.curr-code = 0
                            then ( v-rub + {&space-char} + v-sum-kop-p + v-kop)
                            else "":U ) )
    ).
    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-f_pril1}
        , input v-enclosure-1
    ).
    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-f_pril2}
        , input v-enclosure-2
    ).
    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-f_bossPos}
        , input v-head-position
    ).
    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-f_bossName}
        , input v-sign1
    ).
    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-f_genAcc}
        , input buf_fin-doc.payer-sign2
    ).
    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-f_dateGet}
        , input substitute( '"&1" &2 &3 г.'
                        , day( v-date-create)
                        , MonthNameRusGen( Month( v-date-create ) )
                        , string( Year( v-date-create ), "9999" ) )
    ).
    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-f_passport1}
        , input v-passport-1
    ).
    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-f_passport2}
        , input v-passport-2
    ).
    run rko2xl-write-cell-data in this-procedure (
          input {&rko2xl-f_kassMan}
        , input buf_fin-doc.payer-sign3
    ).

 PUT  STREAM PrnLibStream unformatted
 center-field(buf_fin-doc.payer-name, 117, 117, v-fill)
 /*"______________________________________________________"*/
                                                                                                                    " по ОКПО|"
                                                                 center-field(buf_fin-doc.payer-okpo, 8, 9, {&space-char})
                                                                                                                                      "|" skip
center-field("организация", 125, 125, {&space-char} )                                                                       "+---------+" skip
center-field( ( if v-str-podr-name = "":U
                then fill( v-fill, 125 )
                else v-str-podr-name ) , 125, 125, v-fill)
                                                                                                                            "|"
                        center-field(if buf_fin-doc.str-podr-code = 0 then "" else string( buf_fin-doc.str-podr-code ), 9, 9, {&space-char})
                                                                                                                                      "|" skip
 center-field("структурное подразделение", 125, 125, {&space-char} )                                                        "+---------+" skip
 fill( {&space-char} , 106)                                                                              "+----------------+-----------+" skip
 fill( {&space-char} , 106)                                                                              "|      Номер     |    Дата   |" skip
 fill( {&space-char} , 106)                                                                              "|    документа   |составления|" skip
 fill( {&space-char} , 106)                                                                              "+----------------+-----------+" skip
 fill( {&space-char} , 106)                                                                              "|" center-field(buf_fin-doc.prn-doc-code, 16, 16, {&space-char})
                                                                                                                          "|"
                                                                                         center-field(v-doc-date-f, 11, 11, {&space-char})
                                                                                                                                      "|" skip
center-field("РАСХОДНЫЙ КАССОВЫЙ ОРДЕР", 106, 106, {&space-char} )                                       "+----------------+-----------+" skip
 .
if buf_fin-doc.curr-code = 0 then do:
PUT  STREAM PrnLibStream unformatted
"+-----------------------------------------------------------------+--------------------+----------------------+-----------------+------+" skip
"|                      Дебет                                      |                    |                      |                 |      |" skip
"+-----+-------------------+-------------------+-------------------+--------------------+                      |      Код        |      |" skip
"|     | код структурного  | корреспондирующий |    код аналити-   |      Кредит        |         Сумма,       |      целевого   |      |" skip
"|     |   подразделения   |     счет,         |     ческого       |                    |" fill( {&space-char} , 8) trim(v-rub) v-kop fill({&space-char}, 5)
                                                                                            /* р у б . к о п */
                                                                                                              "|   назначения    |      |" skip
"|     |                   |     субсчет       |      учета        |                    |                      |                 |      |" skip
"+-----+-------------------+-------------------+-------------------+--------------------+----------------------+-----------------+------+" skip
"|     |" center-field(if buf_fin-doc.str-podr-code = 0 then "-" else string( buf_fin-doc.str-podr-code ), 19, 19, {&space-char})
                          "|" center-field(if buf_fin-doc.cor-acc-value = "" then "-" else buf_fin-doc.cor-acc-value, 19, 19, {&space-char})
                                              "|" center-field(if buf_fin-doc.an-uchet-value = "" then "-" else buf_fin-doc.an-uchet-value, 19, 19, {&space-char})
                                                                  "|" center-field(if buf_fin-doc.cor-acc1-value = "" then "-" else buf_fin-doc.cor-acc1-value, 20, 20, {&space-char})
                                                                                       "|" center-field(Sum-delim-with-defis(buf_fin-doc.sum-doc, 15), 22, 22, {&space-char})
                                                                                                              "|" center-field(if buf_fin-doc.cel-nazn-value = "" then "-" else buf_fin-doc.cel-nazn-value, 17, 17, {&space-char})
                                                                                                                                "|      |" skip
"+-----+-------------------+-------------------+-------------------+--------------------+----------------------+-----------------+------+" skip
 .
end.
else do:
PUT  STREAM PrnLibStream unformatted
"+-----------------------------------------------------------+--------------------+------------+----------------------+-----------------+" skip
"|             Дебет                                         |                    |            |                      |                 |" skip
"+-------------------+-------------------+-------------------+--------------------+            |                      |    Код          |" skip
"|  код структурного | корреспондирующий |    код аналити-   |      Кредит        | Валюта     |        Сумма,        |  целевого       |" skip
"|   подразделения   |      счет,        |      ческого      |                    |            |" v-title-rub        /*инвалюта */
                                                                                                                     "|     значения    |" skip
"|                   |     субсчет       |       учета       |                    |            |                      |                 |" skip
"+-------------------+-------------------+-------------------+--------------------+------------+----------------------+-----------------+" skip
"|" center-field(if buf_fin-doc.str-podr-code = 0 then "-" else string( buf_fin-doc.str-podr-code ), 19, 19, {&space-char})
                    "|" center-field(if buf_fin-doc.cor-acc-value = "" then "-" else buf_fin-doc.cor-acc-value, 19, 19, {&space-char})
                                        "|" center-field(if buf_fin-doc.an-uchet-value = "" then "-" else buf_fin-doc.an-uchet-value, 19, 19, {&space-char})
                                                            "|" center-field(if buf_fin-doc.cor-acc1-value = "" then "-" else buf_fin-doc.cor-acc1-value, 20, 20, {&space-char})
                                                                                 "|" center-field(if v-okv-code = "" then "-" else v-okv-code, 12, 12, {&space-char})
                                                                                              "|" center-field(Sum-delim-with-defis(buf_fin-doc.sum-doc, 15), 22, 22, {&space-char})
                                                                                                                     "|" center-field(if buf_fin-doc.cel-nazn-value = "" then "-" else buf_fin-doc.cel-nazn-value, 17, 17, {&space-char})
                                                                                                                                       "|" skip
"+-------------------+-------------------+-------------------+--------------------+------------+----------------------+-----------------+" skip
 .
end.
PUT  STREAM PrnLibStream unformatted
 "Выдать " left-field(buf_fin-doc.receiver-name, 129, 129, v-fill)
                                                               /*"____________________________________________________________________"*/  skip

center-field(string("фамилия, имя, отчество"), 136, 136, {&space-char})                                                                    skip
"Основание: " left-field(v-naznach-plat-1, 125, 125, v-fill)                                                                               skip
left-field(v-naznach-plat-2, 136, 136, v-fill)                                                                                             skip
 "Сумма   " v-sum-doc-v1                                                                                                                   skip
center-field(string("прописью"), 136, 136, {&space-char})                                                                                  skip
v-sum-doc-v2

                                       (if buf_fin-doc.curr-code = 0
                                        then  (v-rub + {&space-char} +
                                                    /* " р у б . " */ center-field(v-sum-kop-p, 4, 4, v-fill) +
                                                             /*"____"*/
                                                                      v-kop)
                                        else "":U)
                                                                     /* "к о п." */
                                                                                                                                           skip
 "Приложение " Left-Field(v-enclosure-1, 125, 125, v-fill)
          /*"______________________________________________________________"*/
                                                                             skip
  Left-Field(v-enclosure-2, 136, 136, v-fill)
 /*"_________________________________________________________________________"*/
                                                                             skip
 "Руководитель организации "
                            center-field(v-head-position, 36, 36,  v-fill)
                                 /*"_______________"*/
                                           ( {&space-char} + fill( v-fill, 36) + {&space-char} ) center-field(v-sign1, 37, 37,  v-fill)
                                                                                                                        /*"___________________" */
                                                                                                                                                   skip
 fill( {&space-char} , 25)  center-field("должность", 36, 36,  {&space-char} )
                                          ( {&space-char} + center-field("подпись", 36, 36,  {&space-char} ) + {&space-char} )
                                                                     center-field("расшифровка подписи", 40, 40,  {&space-char} ) skip
 "Главный бухгалтер " fill( "_", 48)  fill( {&space-char} , 4) center-field(buf_fin-doc.payer-sign2, 66, 66,  v-fill) skip
 fill ( {&space-char}, 18)  center-field("подпись", 48, 48,  {&space-char}) fill( {&space-char} , 4) center-field("расшифровка подписи", 66, 66,  {&space-char}) skip
/*закоментарим прописью - пусть пишут шариковой ручкой*/
/*
 "получил " v-sum-doc-n1                                                              skip
 center-field("сумма прописью", 136, 136,  {&space-char})                             skip
 v-sum-doc-n2

                                                  (if buf_fin-doc.curr-code = 0
                                                   then (v-rub + {&space-char} +
                                                           /* " р у б . " */
                                                           center-field(v-sum-kop-p, 4, 4, v-fill) +
                                                                /*"____*/
                                                                     v-kop /* "к о п ." */ )
                                                   else "":U)
                                                                             skip
*/
"получил " fill("_", 128)                                                    skip
center-field("сумма прописью", 136, 136,  {&space-char})                     skip
fill("_", 136)                                                               skip
{&double-quote} string(day(v-date-create), "99":U) {&double-quote}
/*'"  "'*/
      Center-FIeld(MonthNameRusGen(Month(v-date-create)), 8, 22, v-fill)
      /*"  ______________      "*/
      string(Year(v-date-create), "9999")

                               " г. Подпись " fill( "_", 94)  skip
 "По " Left-Field(v-passport-1, 133, 133, v-fill)
  /*"______________________________________________________________________" */
                                                                             skip
center-field("наименование, номер, дата и место выдачи документа,", 136, 136,  {&space-char}) skip
Left-Field(v-passport-2, 136, 136, v-fill)                                                   skip
center-field("удостоверяющего личность получателя", 136, 136,  {&space-char}) skip
"Выдал кассир  " fill("_",  53) fill( {&space-char}, 4)  center-field(buf_fin-doc.payer-sign3, 65, 65, v-fill) skip
fill( {&space-char}, 14) center-field("подпись", 53, 53,  {&space-char}) center-field("расшифровка подписи", 65, 65,  {&space-char}) skip
.



  if p-append and not p-is-last then Page stream PrnLibStream .
  output  STREAM PrnLibStream CLOSE.
  assign
    p-format = 0
  .
    run rko2xl-close in this-procedure .
    if p-from-forms then do:
      { rep/q-print.i 0 }
    end. /*if from-forms*/
    else do:
    if not p-append
    then do:
        os-delete
            value( string( session:temp-directory ) + {&DF_Name} + string( g#report-num ) + ".txl" )
        .
        os-rename
            value( string( session:temp-directory ) + "$" + string( g#report-num ) + ".txl" )
            value( string( session:temp-directory ) + {&DF_Name} + string( g#report-num ) + ".txl" )
        .
        run prn-lib-prn-file in this-procedure (
            input parParentProc
            , input 0
        ).
        os-delete
            value( string( session:temp-directory ) + {&DF_Name} + string( g#report-num ) + ".txl" )
        .
        os-delete
            value( v-rko2xl-cell-file-name )
        .
    end.
    end. /*else if from-forms*/
end.