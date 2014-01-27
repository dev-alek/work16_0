/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Печать платежа  типа приход наличные

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
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Печать платежа  типа приход наличные".

&SCOP f-l MonthNameRusGen

{ cmp/vssrevis.i }
{ cmp/trg-def.i }
define variable g#report-num  as integer no-undo .
define variable g#quest-print   as logical      no-undo.
{ gbl/cur-time.i }
{ cmp/r-pril.i new }
{ gbl/prn-lib.i }
{ rep/frmlib.i }
{ gbl/paramls.i }
{ rep/pko1xl.i  }

define variable Line              as character no-undo .
define variable v-str-podr-name   as character no-undo .
define variable v-payer-name-p1   as character no-undo .
define variable v-payer-name-p2   as character no-undo .
define variable v-naznach-plat-p1 as character no-undo .
define variable v-naznach-plat-p2 as character no-undo .
define variable v-naznach-plat-p3 as character no-undo .
define variable v-naznach-plat-p4 as character no-undo .
define variable v-naznach-plat-l1 as character no-undo .
define variable v-naznach-plat-l2 as character no-undo .
define variable v-date-create     as date      no-undo .
define variable v-doc-date-f      as character no-undo .
define variable num-lines         as integer   no-undo .
define variable v-fill            as character no-undo init "_".
define variable v-sum-doc-p1      as character no-undo .
define variable v-sum-doc-p2      as character no-undo .
define variable v-sum-doc-p3      as character no-undo .
define variable v-sum-doc-l1      as character no-undo .
define variable v-sum-doc-l2      as character no-undo .
define variable v-sum-kop-p       as character no-undo .
define variable v-dops            as character no-undo .
define variable v-rub             as character no-undo .
define variable v-kop             as character no-undo .
define variable v-title-rub       as character no-undo .
define variable v-line3           as integer   no-undo .
define variable v-line2           as integer   no-undo .
define variable v-okv-code        as character no-undo .
define variable v-chernovik       as character no-undo .
define variable v-including       as character no-undo .
define variable v-inn             as character no-undo .
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
  run pko1xl-init in this-procedure .

 if p-format <> 1
 and p-format <> ?
 and p-append
 then do:
  assign
  p-format = ?
  .
  return.
 end.
  assign
  Line = fill("_":U, 198)
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
    v-title-rub = fill({&space-char}, 3) +  v-rub + v-kop + fill({&space-char}, 4)
    .
  end.
  else do:
    find first buf_currency no-lock where
               buf_currency.curr-code = buf_fin-doc.curr-code .
    assign
    v-rub = {&space-char} + buf_currency.curr-abbr + ".":U
    v-kop = {&space-char} + buf_currency.part-abbr + ".":U
    v-title-rub = "    инвалюты     ":U
    v-okv-code = (if buf_currency.okv-code = 0
                  then "Код ОКВ?"
                  else string(buf_Currency.okv-code))
    .
  end.
  assign
  v-payer-name-p1 = Break-n-line(Buf_fin-doc.payer-name, "72,72", output num-lines)
  v-payer-name-p2 = if num-lines >=2
                   then entry(2, v-payer-name-p1, {&delim-par})
                   else "":U
  v-payer-name-p1 = entry(1, v-payer-name-p1, {&delim-par})
  .
  assign
  v-naznach-plat-p1 = Break-n-line(Buf_fin-doc.naznach-plat, "74,85,85,85", output num-lines)
  v-naznach-plat-p4 = if num-lines >=4
                      then entry(4, v-naznach-plat-p1, {&delim-par})
                      else "":U
  v-naznach-plat-p3 = if num-lines >=3
                      then entry(3, v-naznach-plat-p1, {&delim-par})
                      else "":U
  v-naznach-plat-p2 = if num-lines >=2
                      then entry(2, v-naznach-plat-p1, {&delim-par})
                      else "":U
  v-naznach-plat-p1 = entry(1, v-naznach-plat-p1, {&delim-par})
  .
  assign
  v-naznach-plat-l1 = Break-n-line(Buf_fin-doc.naznach-plat, "95,106", output num-lines)
  v-naznach-plat-l2 = if num-lines >=2
                      then entry(2, v-naznach-plat-l1, {&delim-par})
                      else "":U
  v-naznach-plat-l1 = entry(1, v-naznach-plat-l1, {&delim-par})
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

  find first ub.firm where ub.firm.firm-code = buf_fin-doc.host-code no-error.
  if available ub.firm then do:
    assign v-inn = (if ub.firm.inn <> "" then (" ИНН " + ub.firm.inn) else "").
  end.

  if buf_fin-doc.curr-code = 0 then do:
    assign
    v-dops = Sum-in-Words-Without-Dec(buf_fin-doc.sum-doc)
    v-sum-kop-p = string((buf_fin-doc.sum-doc - truncate(buf_fin-doc.sum-doc, 0)) * 100, "99":U)
    v-line3 = 70
    v-line2 = 91
    .
  end.
  else do:
    assign
    v-dops = Sum-in-Words-Invalut(buf_fin-doc.sum-doc, buf_fin-doc.curr-code)
    v-line3 = 85
    v-line2 = 106
    .
  end.
  assign
  v-sum-doc-p1 = Break-n-line(v-dops, ("85,85,":U + string(v-line3)), output num-lines)
  v-sum-doc-p3 = If num-lines >= 3
                 then entry(3, v-sum-doc-p1, {&delim-par})
                 else "":U
  v-sum-doc-p3 = v-sum-doc-p3 +  fill("-":U, v-line3 - length(v-sum-doc-p3))
  v-sum-doc-p2 = If num-lines >= 2
                 then entry(2, v-sum-doc-p1, {&delim-par})
                 else "":U
  v-sum-doc-p2 =  v-sum-doc-p2 +  fill("-":U, 85 - length(v-sum-doc-p2))
  v-sum-doc-p1 =  entry(1, v-sum-doc-p1, {&delim-par})
  v-sum-doc-p1 = v-sum-doc-p1 +  fill("-":U, 85 - length(v-sum-doc-p1))
  v-sum-doc-p1 = caps(substring(v-sum-doc-p1, 1, 1)) + substring(v-sum-doc-p1, 2)
  .
  assign
  v-sum-doc-l1 = Break-n-line(v-dops, ("100,":U + string(v-line2)), output num-lines)
  v-sum-doc-l2 = If num-lines >= 2
                 then entry(2, v-sum-doc-l1, {&delim-par})
                 else "":U
  v-sum-doc-l2 =  v-sum-doc-l2 +  fill("-":U, v-line2 - length(v-sum-doc-l2))
  v-sum-doc-l1 =  entry(1, v-sum-doc-l1, {&delim-par})
  v-sum-doc-l1 = v-sum-doc-l1 +  fill("-":U, 100 - length(v-sum-doc-l1))
  v-sum-doc-l1 = caps(substring(v-sum-doc-l1, 1, 1)) + substring(v-sum-doc-l1, 2)
  .
  assign
  v-including = replace(buf_fin-doc.including, "@":U, "":U)
  v-including = trim(v-including, {&comma-char})
  v-including = replace(v-including, "в том числе", "")
  v-including = replace(v-including, "в т.ч.:", "")
  no-error .
  run prn-lib-open-stream  in this-procedure (
                                              input parParentProc
                                              ,input {&LS_PS_A4}
                                              ,input yes /*p-is-stream*/
                                              ,input p-append /*p-append*/
                                              ).
    define variable v-sumRubKop         as character    no-undo.
    define variable v-kop-prop          as character    no-undo.
    define variable v-date-string       as character    no-undo.

    assign
        v-sumRubKop = ( if buf_fin-doc.curr-code = 0
                        then
                        trim( Sum-Rub-Kop-Digit (  INPUT buf_fin-doc.sum-doc
                                            ,INPUT 70
                                            ,INPUT 4
                                            ,INPUT " ":U
                                            ,INPUT "":U
                                            ,INPUT v-rub
                                            ,INPUT v-kop
                                            ) )
                        else
                        Sum-Invalut-Digit ( INPUT buf_fin-doc.sum-doc
                                            ,INPUT 40
                                            ,Input buf_fin-doc.curr-code
                                            ,INPUT " ":U
                                            ,INPUT "":U
                                            ))
    .
    assign
        v-kop-prop = ( if buf_fin-doc.curr-code = 0
                       then substitute( "&1 &2&3", v-rub, v-sum-kop-p, v-kop )
                       else "":U
                     )
    .
    assign
        v-date-string = substitute( '"&1" &2 &3 г.'
                                    , string( day( v-date-create ), "99":U )
                                    , MonthNameRusGen( Month( v-date-create ) )
                                    , string( Year( v-date-create ), "9999":U )
                                  )
    .
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_organization}       , input buf_fin-doc.receiver-name                               ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_kvitOrganization}   , input (buf_fin-doc.receiver-name + v-inn)                     ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_okpo}               , input buf_fin-doc.receiver-okpo                               ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_kvitDocCode}        , input buf_fin-doc.prn-doc-code                                ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_kvitDocDateDay}     , input string( day( v-date-create ), "99":U )                  ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_kvitDocDateMonth}   , input MonthNameRusGen( Month( v-date-create ) )               ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_kvitDocDateYear}    , input string( year( v-date-create ), "9999" )                 ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_strPodr}            , input v-str-podr-name                                         ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_kvitPayerName1}     , input v-payer-name-p1                                         ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_kvitPayerName2}     , input v-payer-name-p2                                         ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_kvitNaznachPlat1}   , input v-naznach-plat-p1                                       ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_kvitNaznachPlat2}   , input v-naznach-plat-p2                                       ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_kvitNaznachPlat3}   , input v-naznach-plat-p3                                       ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_kvitNaznachPlat4}   , input v-naznach-plat-p4                                       ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_docCode}            , input buf_fin-doc.prn-doc-code                                ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_docDate}            , input v-doc-date-f                                            ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_kvitSumRubKop}      , input v-sumRubKop                                             ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_kvitSumRubProp1}    , input v-sum-doc-p1                                            ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_kvitSumRubProp2}    , input v-sum-doc-p2                                            ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_kvitSumRubProp3}    , input v-sum-doc-p3                                            ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_kvitSumKopProp}     , input v-kop-prop                                              ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_corAcc1Value}       , input trim( buf_fin-doc.cor-acc1-value )                      ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_strPodrCode}        , input trim( if buf_fin-doc.str-podr-code = 0 then "-" else string(buf_fin-doc.str-podr-code) )                  ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_corAccValue}        , input trim( if buf_fin-doc.cor-acc-value = "" then "-" else buf_fin-doc.cor-acc-value )                       ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_anUchetValue}       , input trim( if buf_fin-doc.an-uchet-value = "" then "-" else buf_fin-doc.an-uchet-value )                      ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_sumDoc}             , input trim( Sum-delim-with-defis( buf_fin-doc.sum-doc, 14 ) ) ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_celNaznValue}       , input trim( if buf_fin-doc.cel-nazn-value = "" then "-" else buf_fin-doc.cel-nazn-value )                      ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_payerName}          , input buf_fin-doc.payer-name                                  ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_kvitIncluding}      , input replace( v-including, "@":U, "":U )                     ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_naznachPlat1}       , input v-naznach-plat-l1                                       ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_naznachPlat2}       , input v-naznach-plat-l2                                       ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_kvitDateString}     , input v-date-string                                           ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_sumRubProp1}        , input v-sum-doc-l1                                            ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_sumRubProp2}        , input v-sum-doc-l2                                            ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_sumKopProp}         , input v-kop-prop                                              ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_including}          , input v-including                                             ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_enclosure}          , input buf_fin-doc.enclosure                                   ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_receiverBuh}        , input buf_fin-doc.receiver-sign2                              ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_kvitReceiverBuh}    , input buf_fin-doc.receiver-sign2                              ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_receiverKass}       , input buf_fin-doc.receiver-sign3                              ).
    run pko1xl-write-cell-data in this-procedure ( input {&pko1xl-h_kvitReceiverKass}   , input buf_fin-doc.receiver-sign3                              ).

if buf_fin-doc.curr-code = 0 then do:
  PUT  STREAM PrnLibStream unformatted
  Line skip
  v-chernovik    fill( {&space-char}, 68) "Унифицированная форма N КО-1" skip
                 fill( {&space-char}, 74)  "Утверждена постановлением Госкомстата" skip
                 fill( {&space-char}, 85)  "России от 18.08.98 г. N 88" skip
                 skip(0)
 fill( {&space-char}, 87)                                                                   "+-----------------+ |  | |"

                                                                                             center-field(buf_fin-doc.receiver-name + v-inn, 75, 85, v-fill) skip
 fill( {&space-char}, 87)                                                                   "|       Код       | |    |"
                                                                                             center-field("организация", 75, 85, {&space-char}) skip
 fill( {&space-char}, 87)                                                                   "+-----------------+ |  | |"                skip
 fill( {&space-char}, 74)                                                      "Форма по ОКУД|     0310001     | |    |"  skip
 fill( {&space-char}, 87)                                                                   "+-----------------+ |Л | |"  center-field("Квитанция", 75, 85, {&space-char}) skip
 .
end.
else do:
  PUT  STREAM PrnLibStream unformatted
  Line skip
  v-chernovik    skip(0)
                 skip(0)
                 skip(0)
                 skip(0)
 fill( {&space-char}, 87)                                                                   "+-----------------+ |  | |"

                                                                                             center-field(buf_fin-doc.receiver-name + v-inn, 75, 85, v-fill) skip
 fill( {&space-char}, 87)                                                                   "|       Код       | |    |"
                                                                                             center-field("организация", 75, 85, {&space-char}) skip
 fill( {&space-char}, 87)                                                                   "+-----------------+ |  | |"                skip
 fill( {&space-char}, 74)                                                      "Форма по ОКУД|                 | |    |"  skip
 fill( {&space-char}, 87)                                                                   "+-----------------+ |Л | |"  center-field("Квитанция", 75, 85, {&space-char}) skip
 .
end.
  PUT  STREAM PrnLibStream unformatted
  center-field(buf_fin-doc.receiver-name, 75, 80, v-fill )
                                                            "по ОКПО|"  center-field(buf_fin-doc.receiver-okpo, 10, 17, {&space-char})
                                                                                                              "| |и   | к приходному кассовому ордеру N " center-field(buf_fin-doc.prn-doc-code, 16,30, v-fill) fill( {&space-char} , 22)
                                                                                                                           /* "______________________________" */
                                                                                                                                                               skip
  center-field("организация", 87, 87, {&space-char} )                                       "+-----------------+ |н | | от " {&double-quote} string(day(v-date-create), "99":U) {&double-quote}
                                                                                                    Center-FIeld(MonthNameRusGen(Month(v-date-create)), 8, 22, v-fill)
                                                                                                    /*" _______________________"*/
                                                                                        string(Year(v-date-create), "9999")
                                                                                                                                    " г.                     " skip
  center-field((if v-str-podr-name = "":U then fill("_", 87) else v-str-podr-name) , 76, 87, v-fill)
                                                                                            "|                 | |и   |Принято от " Left-field(v-payer-name-p1, 72, 74, v-fill)

                                                                                                                                                               skip
center-field("структурное подразделение", 87, 87, {&space-char} )                           "+-----------------+ |я | |"
                                                                                              Left-field(if v-payer-name-p2 = "":U then fill("_", 85) else v-payer-name-p2, 85, 85, v-fill)
                                                                                                                                                               skip
fill( {&space-char} , 70 )                                                 "+----------------+-----------------+ |    |Основание: "
                                                                                              (if v-naznach-plat-p1 = "":U
                                                                                               then fill("_", 74)
                                                                                               else Left-field(v-naznach-plat-p1, 74, 74, v-fill))
                                                                                                                                                               skip
fill( {&space-char} , 70 )                                                 "|     Номер      |      Дата       | |  | |"
                                                                                              (if v-naznach-plat-p2 = "":U
                                                                                               then fill("_", 85)
                                                                                               else Left-field(v-naznach-plat-p2, 85, 85, v-fill))
                                                                                                                                                               skip
fill( {&space-char} , 70 )                                                 "|   документа    |  составления    | |    |"
                                                                                              (if v-naznach-plat-p3 = "":U
                                                                                               then fill("_", 85)
                                                                                               else Left-field(v-naznach-plat-p3, 85, 85, v-fill))
                                                                                                                                                               skip
fill( {&space-char} , 70 )                                                 "+----------------+-----------------+ |о | |"
                                                                                              (if v-naznach-plat-p4 = "":U
                                                                                               then fill("_", 85)
                                                                                               else Left-field(v-naznach-plat-p4, 85, 85, v-fill))
                                                                                                                                                               skip
fill( {&space-char} , 70 )                                                 "|" center-field(buf_fin-doc.prn-doc-code, 16,16, {&space-char}) "|"
                                                                                          center-field(v-doc-date-f, 16, 17, {&space-char})

  .
  Put STREAM PrnLibStream unformatted

                                                                                     "| |т   |                                                               " skip
  center-field("ПРИХОДНЫЙ КАССОВЫЙ ОРДЕР", 70, 70, {&space-char} )         "+----------------+-----------------+ |р | |Сумма "
                                                                                  (if buf_fin-doc.curr-code = 0
                                                                                  then
                                                                                  Sum-Rub-Kop-Digit ( INPUT buf_fin-doc.sum-doc
                                                                                                     ,INPUT 64
                                                                                                     ,INPUT 4
                                                                                                     ,INPUT v-fill
                                                                                                     ,INPUT ""
                                                                                                     ,INPUT v-rub
                                                                                                     ,INPUT v-kop
                                                                                                        )
                                                                                  else
                                                                                  Sum-Invalut-Digit ( INPUT buf_fin-doc.sum-doc
                                                                                                     ,INPUT 79
                                                                                                     ,Input buf_fin-doc.curr-code
                                                                                                     ,INPUT v-fill
                                                                                                     ,INPUT ""
                                                                                                        ))
                                                                                                                                                               skip
.
if buf_fin-doc.curr-code = 0 then do:
  Put STREAM PrnLibStream unformatted
  "+-------------+----------------------------------------------------+-----------------+---------------+---+ |е   |"  center-field("цифрами", 88, 88, {&space-char} )  skip
  "|   Дебет     |                  Кредит                            |                 |               |   | |з | |"  v-sum-doc-p1                                     skip
  "|             +----+---------------+---------------+---------------+                 |               |   | |а   |"  center-field("прописью", 88, 88, {&space-char} ) skip
  "|             |    |      код      |   корреспон-  |  код анали-   |     Сумма,      | Код целевого  |   | |  | |"  v-sum-doc-p2                                     skip
  "|             |    | структур-     |  дирующий     | тического     |" v-title-rub
                                                        /*" {&abbr_rub}. {&abbr_kop}.  "*/
                                                                                       "|   назначения  |   | |    |" v-sum-doc-p3    v-rub {&space-char}
                                                                                                                             /*" {&abbr-rub}. "*/
                                                                                                                     center-field(v-sum-kop-p, 4, 4, v-fill)  /*"____"*/
                                                                                                                                                        v-kop
                                                                                                                                                       /*" {&abbr_kop}."*/
                                                                                                                                                                       skip
  "|             |    | ного под-     |  счет,        | учета         |                 |               |   | |  | |"                                                                   skip
  "|             |    | разделения    |  субсчет      |               |                 |               |   | |    |"                                                                   skip
  "+-------------+----+---------------+---------------+---------------+-----------------+---------------+---+ |  | |"                                                                   skip
  "|"   center-field(buf_fin-doc.cor-acc1-value, 13, 13, {&space-char})
                "|    |" center-field(if buf_fin-doc.str-podr-code = 0 then "-" else string(buf_fin-doc.str-podr-code), 15, 15, {&space-char})
                                      "|" center-field(if buf_fin-doc.cor-acc-value = "" then "-" else buf_fin-doc.cor-acc-value, 15, 15, {&space-char})
                                                      "|" center-field(if buf_fin-doc.an-uchet-value = "" then "-" else buf_fin-doc.an-uchet-value, 15, 15, {&space-char})
                                                                     "|" center-field(Sum-delim-with-defis(buf_fin-doc.sum-doc, 14), 17, 17, {&space-char})
                                                                                       "|" center-field(if buf_fin-doc.cel-nazn-value = "" then "-" else buf_fin-doc.cel-nazn-value, 15, 15, {&space-char})
                                                                                                       "|   | |    |" skip
  "+-------------+----+---------------+---------------+---------------+-----------------+---------------+---+ |  | |" skip

.
end.
else do:
  Put STREAM PrnLibStream unformatted
  "+-------------+-----------------------------------------------+--------+-----------------+---------------+ |е   |" center-field("цифрами", 88, 88, {&space-char} )             skip
  "|    Дебет    |                   Кредит                      |        |                 |               | |з | |" v-sum-doc-p1                                                skip
  "|             +---------------+---------------+---------------+        |                 |               | |а   |" center-field("прописью", 88, 88, {&space-char} )             skip
  "|             |      код      | корреспон-    |   код анали-  | Валюта |  Сумма,         | Код  целевого | |  | |" v-sum-doc-p2                                               skip
  "|             | структурного  |  дирующий     |   тического   |        |" v-title-rub   "|  назначения   | |    |" v-sum-doc-p3                                               skip
  "|             |  подраз-      |    счет,      |    учета      |        |                 |               | |  | |"                                                            skip
  "|             | разделения    |    субсчет    |               |        |                 |               | |    |"                                                            skip
  "+-------------+---------------+---------------+---------------+--------+-----------------+---------------+ |  | |"                                                            skip
  "|"  center-field(buf_fin-doc.cor-acc1-value, 13, 13, {&space-char})
                "|" center-field(if buf_fin-doc.str-podr-code = 0 then "-" else string(buf_fin-doc.str-podr-code), 15, 15, {&space-char})
                                "|" center-field(if buf_fin-doc.cor-acc-value = "" then "-" else buf_fin-doc.cor-acc-value, 15, 15, {&space-char})
                                                "|" center-field(if buf_fin-doc.an-uchet-value = "" then "-" else buf_fin-doc.an-uchet-value, 15, 15, {&space-char})
                                                                "|" center-field(if v-okv-code = "" then "-" else v-okv-code, 8, 8, {&space-char})
                                                                         "|" center-field(Sum-delim-with-defis(buf_fin-doc.sum-doc, 14), 17, 17, {&space-char})
                                                                                           "|" center-field(if buf_fin-doc.cel-nazn-value = "" then "-" else buf_fin-doc.cel-nazn-value, 15, 15, {&space-char})
                                                                                                           "| |    |"                                                             skip
  "+-------------+---------------+---------------+---------------+--------+-----------------+---------------+ |  | |"                                                             skip

.
end.
Put STREAM PrnLibStream unformatted
"Принято от " left-field(buf_fin-doc.payer-name, 95, 95, v-fill)

                                                                                    " |    |В том числе " Left-Field(replace(v-including, "@":U, "":U), 73, 73, v-fill)                    skip
"Основание: " Left-Field(v-naznach-plat-l1, 95, 95, v-fill)                         " |  | |" {&double-quote} string(day(v-date-create), "99":U) {&double-quote} {&space-char}
                                                                                              Center-FIeld(MonthNameRusGen(Month(v-date-create)), 8, 22, v-fill)
                                                                                      string(Year(v-date-create), "9999")
                                                                                                                                  " г." skip
Left-Field(v-naznach-plat-l2, 106, 106, v-fill)
                                                                                   " |    |"                                            skip
"Сумма " v-sum-doc-l1                                                              " |  | |      М.П. (штампа)"                         skip
fill( {&space-char}, 6) center-field("прописью", 100, 100, {&space-char} )         " |    |"                                            skip
 v-sum-doc-l2  (IF buf_fin-doc.curr-code = 0
                then (v-rub + {&space-char} +
              /*" {&abbr_rub}. "*/ center-field(v-sum-kop-p, 4, 4, v-fill) +  /*"____"*/ v-kop)
              else "":U)
                                                                          /* {&abbr_kop}.*/" |  | |"                                            skip
"в том числе " Left-Field(v-including, 94, 94, v-fill)
                                                                                   " |    |  Главный бухгалтер   " fill("_", 63)        skip
"Приложение " Left-Field(buf_fin-doc.enclosure, 95, 95, v-fill)                    " |  | |" fill( {&space-char} , 22)  center-field("подпись", 63, 63, {&space-char} ) skip
"Главный бухгалтер   " fill( v-fill, 34) fill( {&space-char} , 4)
        center-field(buf_fin-doc.receiver-sign2, 48, 48, v-fill)
                                                                                    " |    |" fill( {&space-char} , 22)  center-field(buf_fin-doc.receiver-sign2, 63, 63, v-fill) skip
fill( {&space-char}, 20) center-field("подпись", 34, 34, {&space-char} )
fill( {&space-char}, 4) center-field("расшифровка подписи", 48, 48, {&space-char} ) " |  | |" fill( {&space-char} , 22)  center-field("расшифровка подписи", 63, 63, {&space-char}) skip
"Получил кассир " fill( {&space-char} , 5) fill( v-fill, 34) fill( {&space-char} , 4)
                                      center-field(buf_fin-doc.receiver-sign3, 48, 48, v-fill)
                                                                                    " |    |  Кассир " fill( {&space-char}, 13) fill(v-fill, 30) fill( {&space-char}, 3) center-field(buf_fin-doc.receiver-sign3, 30, 30, v-fill) skip
fill( {&space-char}, 20) center-field("подпись", 34, 34, {&space-char} )
fill( {&space-char}, 4) center-field("расшифровка подписи", 48, 48, {&space-char} ) " |  | | "  fill( {&space-char}, 20) center-field("подпись", 30, 30, {&space-char} ) fill( {&space-char}, 3)
                                                                                              center-field("расшифровка подписи", 30, 30, {&space-char} )   skip
.
if p-append and not p-is-last then Page stream PrnLibStream .
output  STREAM PrnLibStream CLOSE.
assign
p-format = 1
.
    run pko1xl-close in this-procedure .
    if p-from-forms then do:
      { rep/q-print.i 8 }
    end. /*if p-from-forms then do:*/
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
            , input 8
        ).
        os-delete
            value( string( session:temp-directory ) + {&DF_Name} + string( g#report-num ) + ".txl" )
        .
        os-delete
            value( v-pko1xl-cell-file-name )
        .
      end. /*if not p-append*/
    end.
end.