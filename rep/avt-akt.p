/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Печать акта формирования продажной цены

Автор: Демин Алексей Сергеевич
Дата создания: 09/15/05
Author: Alexey Demin
Creation date: 09/15/05

Input:

Output:

*/
define input parameter p-mainmenu-handle    as handle           no-undo.
define input parameter rec_id               as recid            no-undo .
define input parameter prod-price           as logical          no-undo .
define input parameter pskov                as logical          no-undo .  /* Для Пскова */

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Печать акта формирования продажной цены".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ gbl/cur-time.i }
{ str/lib-trn.i }
{ str/get-pr.i def }
{ cmp/r-pril.i   }
{ str/in-vatp.i def }
{ cmp/library.i  }
{ str/trdcalib.i }
{ str/getctxtp.i def }
{ rep/fmtcli.i   }
{ rep/torgconf.i }

/*дорожный налог объявим один лишь раз в базовой валюте*/

&scop rate-calc-rubl-base * 1
&scop temp-road-tax {&road-tax-cur}
&glob SLT-calc-ov (price-lst - ~{&road-tax-cur}) * t-doc-line.SLT-pc / (100 + t-doc-line.SLT-pc)
&scop slt-temp {&slt-calc}

def buffer t-doc for trn-doc.
define buffer buf_clients for ub.clients.

def temp-table t-doc-line no-undo like doc-line.

define temp-table tt-tax no-undo
  field vat-pc      as decimal
  field fact-qnty   as decimal
  field sum-no-nds  as decimal
  field doc-sum     as decimal
  field obj-sum     as decimal
  field slt-sum     as decimal
  field vat-sum     as decimal
index pi is primary unique
  vat-pc
.

define variable sum-no-NDS              as decimal     no-undo.
define variable doc-sum                 as decimal     no-undo.
define variable obj-sum                 as decimal     no-undo.
define variable v-tax-sum               as decimal     no-undo. /*Третий налог (road-tax)*/
define variable SLT-sum                 as decimal     no-undo.
define variable VAT-sum                 as decimal     no-undo.
define variable VAT-gds                 as decimal     no-undo.
define variable marg                    as decimal     no-undo.
define variable price-doc               as decimal     no-undo.
define variable price-lst               as decimal     no-undo.
define variable v-sum-sale              as decimal     no-undo.
define variable v-sum-cost-without-vat  as decimal     no-undo.
define variable v-nids                  as character   no-undo.
define variable v-parameter-type        as character   no-undo.

define variable v-vat-pc        like doc-line.vat-pc    no-undo.
define variable v-slt-pc        like doc-line.slt-pc    no-undo.
define variable v-host-code     like sysconf.host-code  no-undo.


define variable propis          as character        no-undo.
define variable abbr            as character        no-undo.
define variable UpFact          as character        no-undo.
define variable Delt            as character        no-undo.

define variable Lines_Counter   as integer          no-undo.
define variable Line            as character        no-undo.

define variable sym1       as character init ":"    no-undo.
define variable sym2       as character init ":"    no-undo.
define variable tb-code    as character             no-undo.

define variable tdoc-date  like    trn-doc.doc-date no-undo.
define variable tdoc-code  like trn-doc.doc-code    no-undo.

define variable v-curr-r-b as character         no-undo.

define variable g#report-num    as integer      no-undo.
define variable g#quest-print   as logical      no-undo.
define variable g#log           as logical      no-undo.
define variable v-obj-name      as character no-undo .

def buffer Our_Host for clients.

{ gbl/curr-r-b.i v-curr-r-b }

DEFINE FRAME Akt
        sym1 column-label ":!:" format "X(1)" space(0)
        tb-code column-label "Код! " format "x({&BarCode_Length})"
        gds-dtl.artic column-label "Артикул! " format "X(16)"
        goods.gds-name column-label "Название товара! " format "X(33)"
        gds-dtl.fact-qnty column-label "Количество ! " format ">>>>>>9.<<<"
        price-doc column-label "Цена без!НДС" format ">>>>>>9.99"
        sum-no-NDS column-label "Сумма без!НДС" format "->>>>>>>>9.99"
        doc-sum column-label "Сумма по!докум." format "->>>>>>>>9.99"
        price-lst column-label "Цена по!объекту" format ">>>>>>9.99"
        obj-sum column-label "Сумма по!объекту" format "->>>>>>>>9.99"
       /* SLT-sum column-label "Налог с!прод." format "->>>>>9.99" */
        UpFact column-label "Торговая!наценка" format "X(8)"
        Delt column-label "Процент!разницы" format "X(8)"
        t-doc-line.vat-pc column-label "Ставка!НДС" format ">>9.<<%"
        VAT-sum column-label "Сумма НДС от!прод.цен" format "->>>>>>>>9.99" space(0)
        sym2 column-label ":!:" format "X(1)" space(0)
    HEADER
            cur-time-print() AT 5 format "X(35)"
            string( "Акт формирования прод. цены по документу N " + tdoc-code + " от " + string( tdoc-date,"99/99/9999" ) ) AT 40 format "X(80)"
            string( (if prod-price then "(Прод. цена на момент печати)" else "" ) ) AT 125 format "X(35)"
            string( "Страница " + string(PAGE-NUMBER) ) AT 164 format "X(15)" SKIP
        Line format "X(180)" AT 1
    with width {&DOS_CW} stream-io.

{ str/getctxtp.i get p-mainmenu-handle }
run get-report-num in p-mainmenu-handle (
    output g#report-num
).
run get-quest-print in p-mainmenu-handle (
    output g#quest-print
).
FIND t-doc WHERE recid(t-doc) = rec_id  NO-LOCK.

{ gbl/hostcode.i t-doc.obj-type t-doc.obj-code v-host-code }
run torgconf-read in this-procedure(
     input "akt_sl"
   , input v-host-code
   , input t-doc.doc-type
   , input tdoc-code
   ).

run torgconf-get-self-param in this-procedure (
          input  t-doc.obj-type
        , input  t-doc.obj-code
        , input  0
).
run torgconf-get-form-header in this-procedure (
          input no
        , input t-doc.doc-code
        , input yes
        , input tdoc-date
        , input t-doc.fact-date
        , input t-doc.doc-type
        , input t-doc.status_
        , input no
        , input no
    ).

Line = fill("-", 200).
assign
    tdoc-date = IF t-doc.fact-date = ? THEN t-doc.doc-date ELSE t-doc.fact-date
    tdoc-code    = t-doc.doc-code
.
FIND Our_Host WHERE Our_Host.obj-type = {&cmp} AND
                                        Our_Host.obj-code = t-doc.host-code NO-LOCK.

define variable FullGdsName as logical   no-undo .
/*define variable par-type as character no-undo.*/
define variable tmp-var  as character no-undo .
{ gbl/getsect.i run t-doc.obj-type t-doc.obj-code {&attr-prt-obj} }
for each thbjattr_thbj-attr :
    if thbjattr_thbj-attr.prop-code = 'FGdsNinD' then tmp-var =  string(thbjattr_thbj-attr.property-value-logical) .
end.

{ cmp/open-out.i " " " " " " {&LS_PS_A4} }

find first buf_clients no-lock
  where buf_clients.obj-type = t-doc.obj-type
    and buf_clients.obj-code = t-doc.obj-code
no-error .
if available buf_clients
then do:
  assign
    v-obj-name = substitute("&1" , buf_clients.obj-name)
  .
end.

PUT SPACE(90) Our_Host.obj-name format "x(40)" skip
    SPACE(90) v-obj-name        format "x(40)" skip(2)
        SPACE(20) "А К Т  формирования продажной цены по документу  N " format "x(80)"
        t-doc.doc-code format "X(10)"
        "  от  " t-doc.doc-date format "99.99.9999" SKIP(1).

if t-doc.doc-type = {&income}
and not t-doc.internal
then do:
    { str/tdat-val.i t-doc.doc-code
                 {&trdcattr-nids}
                 v-nids
                 v-parameter-type }
    if v-nids <> ""
    and v-nids <> ?
    then do:
        put
                    space(20)   "Основание: накладная поставщика N: "
                                v-nids format "x(110)"
            skip(1)
        .
    end.
end.

if t-doc.doc-type = {&income} OR
   ( t-doc.ext-doc-type = {&TDEDT_Ras_Vnesh_VP} ) OR
   ( t-doc.doc-type = {&expense} AND ( NOT t-doc.internal ) ) then
    do:
        PUT SPACE(20) string( "ПОСТАВЩИК : " + t-doc.cli-name ) format "x(90)" SKIP(1) .
    end.

FORM HEADER
    Line format "X(180)" AT 1 SKIP
    "Продолжение - на следующей странице" AT 30 SKIP
    with FRAME BottomFrame width {&DOS_CW} PAGE-BOTTOM NO-LABELS NO-BOX .
VIEW FRAME BottomFrame .

empty temp-table tt-tax.

FOR EACH doc-line WHERE doc-line.doc-code = t-doc.doc-code NO-LOCK ,
        EACH gds-dtl WHERE gds-dtl.doc-code = t-doc.doc-code AND
                                            gds-dtl.prod-type = doc-line.prod-type AND
                                            gds-dtl.prod-code = doc-line.prod-code AND
                                            gds-dtl.artic = doc-line.artic NO-LOCK,
        EACH goods WHERE goods.prod-type = gds-dtl.prod-type AND
                                           goods.prod-code = gds-dtl.prod-code AND
                                           goods.artic = gds-dtl.artic NO-LOCK
            BREAK BY gds-dtl.artic BY gds-dtl.prt-code with FRAME Akt :

       FOR EACH t-doc-line :
          delete t-doc-line.
       END.


       CREATE t-doc-line.
       BUFFER-COPY doc-line TO t-doc-line.
       { gbl/hostcode.i doc-line.obj-type doc-line.obj-code v-host-code }
        if prod-price = yes
        then do:
            { gbl/pftxvalg.i
                goods.gds-code
                {&vat-tax-code}
                ?
                v-host-code
                doc-line.obj-type
                doc-line.obj-code
                v-vat-pc
                no-error
            }
            { gbl/pftxvalg.i
                    goods.gds-code
                    {&slt-tax-code}
                    ?
                    v-host-code
                    doc-line.obj-type
                    doc-line.obj-code
                    v-slt-pc
                    no-error
            }
        end.
        else do:
            { gbl/pftxvalg.i
                goods.gds-code
                {&vat-tax-code}
                t-doc.fact-date
                v-host-code
                doc-line.obj-type
                doc-line.obj-code
                v-vat-pc
                no-error
            }
            { gbl/pftxvalg.i
                    goods.gds-code
                    {&slt-tax-code}
                    t-doc.fact-date
                    v-host-code
                    doc-line.obj-type
                    doc-line.obj-code
                    v-slt-pc
                    no-error
            }
        end.
        assign
            t-doc-line.vat-pc = v-vat-pc
            t-doc-line.slt-pc = v-slt-pc
        .
       FIND bar-code WHERE bar-code.gds-code = goods.gds-code
                       AND bar-code.unit-cli = goods.unit-base
                       AND bar-code.node-code = gds-dtl.prt-code
                       AND bar-code.part-code = ""
                       AND bar-code.in-code = ""
                           NO-LOCK no-error.

        if prod-price = yes
        then do:
                { str/get-pr.i calc t-doc.obj-type t-doc.obj-code goods.gds-code bar-code.node-code }
                assign price-lst = gp-price-sale.
            end.
        else do:
            assign price-lst = gds-dtl.cur-base.
        end.

        if t-doc.doc-type = {&income}
        then do:
            { str/in-vatp.i calc doc-line. t-doc. g }
            if road-tax-rubl-loc = ? then assign road-tax-rubl-loc = 0.
            if road-tax-base-loc = ? then assign road-tax-base-loc = 0.
            assign
                price-doc = ( if v-curr-r-b = {&r-b-base}
                              then ( price-base-with-tax-loc - vat-base-loc )
                              else ( price-rubl-with-tax-loc - vat-rubl-loc ) )
                v-tax-sum = ( if v-curr-r-b = {&r-b-base}
                              then road-tax-base-loc
                              else road-tax-rubl-loc )
            .
        end.
        else do:
            if v-curr-r-b = {&r-b-base}
            then do:
                assign
                    price-doc = gds-dtl.price-base - (ub.gds-dtl.price-base - ub.gds-dtl.discnt-base - ub.doc-line.road-tax * 1 - (ub.gds-dtl.price-base - ub.gds-dtl.discnt-base - ub.doc-line.road-tax * 1)                           * ub.doc-line.SLT-pc / (100 + ub.doc-line.SLT-pc))                           * ub.doc-line.VAT-pc / (100 + ub.doc-line.VAT-pc)
                .
            end.
            else do:
                assign
                    price-doc = gds-dtl.price-rubl - (ub.gds-dtl.price-rubl - ub.gds-dtl.discnt-rubl - ub.doc-line.road-tax * 1 - (ub.gds-dtl.price-rubl - ub.gds-dtl.discnt-rubl - ub.doc-line.road-tax * 1)                           * ub.doc-line.SLT-pc / (100 + ub.doc-line.SLT-pc))                           * ub.doc-line.VAT-pc / (100 + ub.doc-line.VAT-pc)
                .
            end.
        end.
        assign
            Vat-gds = ( price-lst - {&SLT-calc-ov} - v-tax-sum) * t-doc-line.vat-pc / ( 100 + t-doc-line.vat-pc )
            marg = price-lst - price-doc - Vat-gds - {&SLT-calc-ov}
        .

        ACCUMULATE
            bar-code.b-code ( COUNT )
            gds-dtl.fact-qnty ( TOTAL )
            marg * gds-dtl.fact-qnty ( TOTAL )
            gds-dtl.fact-qnty * {&SLT-calc-ov} ( TOTAL )
            gds-dtl.fact-qnty * VAT-gds ( TOTAL )
            ( gds-dtl.fact-qnty * price-lst ) ( TOTAL )
            ( gds-dtl.fact-qnty * price-doc ) ( TOTAL )
        .
        if v-curr-r-b = {&r-b-base}
        then do:
            ACCUMULATE
                ( gds-dtl.fact-qnty * gds-dtl.price-base ) ( TOTAL )
                ( ( price-lst - gds-dtl.price-base ) * gds-dtl.fact-qnty ) ( TOTAL )
            .
        end.
        else do:
            ACCUMULATE
                ( gds-dtl.fact-qnty * gds-dtl.price-rubl ) ( TOTAL )
                ( ( price-lst - gds-dtl.price-rubl ) * gds-dtl.fact-qnty ) ( TOTAL )
            .
        end.
        assign
             delt = ( if v-curr-r-b = {&r-b-base}
                      then string( ( price-lst - gds-dtl.price-base ) / gds-dtl.price-base * 100, "->>>9.9" )
                      else string( ( price-lst - gds-dtl.price-rubl ) / gds-dtl.price-rubl * 100, "->>>9.9" )
                    ) + "%"
        .
        DISPLAY sym1
                trim( string( bar-code.b-code ) ) @ tb-code
                gds-dtl.artic
                goods.gds-name
                gds-dtl.fact-qnty
                price-doc
                ( gds-dtl.fact-qnty * price-doc ) @ sum-no-NDS
                ( gds-dtl.fact-qnty * ( if v-curr-r-b = {&r-b-base} then gds-dtl.price-base else gds-dtl.price-rubl ) ) @ doc-sum
                price-lst
                ( gds-dtl.fact-qnty * price-lst ) @ obj-sum
                t-doc-line.vat-pc
                ( gds-dtl.fact-qnty * VAT-gds ) @ VAT-sum
                string( string( marg / price-doc * 100, "->>>9.9" ) + "%" ) @ UpFact
                Delt
                sym2
        .
        IF LENGTH(goods.gds-name, "CHARACTER") > 33 and FullGdsName  THEN  do:
          assign propis = SUBSTRING(goods.gds-name,34) .
          DOWN 1 .
          DISPLAY sym1 propis @ goods.gds-name  sym2     .
        end.

        /* собираем суммы по % НДС */
        find first tt-tax exclusive-lock
          where tt-tax.vat-pc = t-doc-line.vat-pc
        no-error .
        if not available tt-tax
        then do:
          create tt-tax no-error .
          assign
            tt-tax.vat-pc = t-doc-line.vat-pc
          .
        end.
        assign
          tt-tax.sum-no-nds = tt-tax.sum-no-nds + ( gds-dtl.fact-qnty * price-doc )
          tt-tax.doc-sum    = tt-tax.doc-sum    + ( gds-dtl.fact-qnty * ( if v-curr-r-b = {&r-b-base} then gds-dtl.price-base else gds-dtl.price-rubl ) )
          tt-tax.obj-sum    = tt-tax.obj-sum    + ( gds-dtl.fact-qnty * price-lst )
          /*tt-tax.slt-sum    = tt-tax.slt-sum    + ( gds-dtl.fact-qnty * {&SLT-calc-ov} )*/
          tt-tax.vat-sum    = tt-tax.vat-sum    + ( gds-dtl.fact-qnty * VAT-gds )
          tt-tax.fact-qnty  = tt-tax.fact-qnty  + gds-dtl.fact-qnty
        no-error .

        if LAST( gds-dtl.artic ) then
            do:
                DOWN 1 .
                PUT Line format "X(180)" SKIP .

                assign
                    v-sum-cost-without-vat = ACCUM TOTAL ( gds-dtl.fact-qnty * price-doc )
                    v-sum-sale             = ACCUM TOTAL ( gds-dtl.fact-qnty * price-lst )
                .
                assign
                    Delt = ( if v-curr-r-b = {&r-b-base}
                            then string( ( ACCUM TOTAL ( ( price-lst - gds-dtl.price-base ) * gds-dtl.fact-qnty ) )
                                       / ( ACCUM TOTAL ( gds-dtl.fact-qnty * gds-dtl.price-base ) ) * 100, "->>>9.9" ) + "%"
                            else string( ( ACCUM TOTAL ( ( price-lst - gds-dtl.price-rubl ) * gds-dtl.fact-qnty ) )
                                       / ( ACCUM TOTAL ( gds-dtl.fact-qnty * gds-dtl.price-rubl ) ) * 100, "->>>9.9" ) + "%"
                           )
                .
                for each tt-tax
                  by tt-tax.vat-pc
                :
                  display
                    substitute("  ИТОГО по НДС &1%", tt-tax.vat-pc ) @ goods.gds-name
                    tt-tax.fact-qnty                                 @ gds-dtl.fact-qnty
                    tt-tax.sum-no-nds                                @ sum-no-NDS
                    tt-tax.doc-sum                                   @ doc-sum
                    tt-tax.obj-sum                                   @ obj-sum
                    tt-tax.vat-sum                                   @ VAT-sum
                  with frame Akt.
                  down 1 with frame Akt.
                end.

                DISPLAY "  ИТОГО"    @ goods.gds-name
                    ACCUM TOTAL gds-dtl.fact-qnty @ gds-dtl.fact-qnty
                    ACCUM TOTAL ( gds-dtl.fact-qnty * price-doc )   @ sum-no-NDS
                    ( if v-curr-r-b = {&r-b-base}
                      then ACCUM TOTAL ( gds-dtl.fact-qnty * gds-dtl.price-base )
                      else ACCUM TOTAL ( gds-dtl.fact-qnty * gds-dtl.price-rubl )
                    )                                               @ doc-sum
                    ACCUM TOTAL ( gds-dtl.fact-qnty * price-lst ) @ obj-sum
                    /*ACCUM TOTAL ( gds-dtl.fact-qnty * {&SLT-calc-ov} ) @ SLT-sum */
                    ACCUM TOTAL ( gds-dtl.fact-qnty * VAT-gds ) @ VAT-sum
                    string( string( ( ACCUM TOTAL ( marg * gds-dtl.fact-qnty ) ) /
                                           ( ACCUM TOTAL ( gds-dtl.fact-qnty * price-doc ) ) * 100, "->>>9.9" ) + "%" )
                                    @ UpFact
                    Delt .
                /*UNDERLINE goods.gds-name gds-dtl.fact-qnty sum-no-NDS obj-sum SLT-sum UpFact .*/
                DOWN 2 .
            end.
END.                  /* FOR EACH price-list WHERE ... */

empty temp-table tt-tax.

HIDE FRAME BottomFrame .

if v-curr-r-b = {&r-b-base}
then do:
    run rep/wp.p ( input p-mainmenu-handle, input absolute( ACCUM TOTAL ( marg * gds-dtl.fact-qnty ) ), output propis, output abbr ) .
end.
else do:
    run rep/wp-rub.p ( input absolute( ACCUM TOTAL ( marg * gds-dtl.fact-qnty ) ), output propis, output abbr ) .
end.

PUT SPACE(10) "Всего  " ( ACCUM COUNT bar-code.b-code ) format ">>>>9"
    " наименований." format "X(15)"
    SKIP(1)
    SPACE(10)
    string( "Сумма цен по объекту составила : "
               + trim( string( ACCUM TOTAL ( gds-dtl.fact-qnty * price-lst ), "->>>,>>>,>>>,>>>,>>9.99" ) )
               + " " + trim( abbr )
               + ", в том числе налог с продаж : "
               + trim( string( ACCUM TOTAL ( gds-dtl.fact-qnty * {&SLT-calc-ov} ), "->>>,>>>,>>>,>>>,>>9.99" ) )
               + " " + trim( abbr )
               + ", НДС : "
               + trim( string( ACCUM TOTAL ( gds-dtl.fact-qnty * VAT-gds ), "->>>,>>>,>>>,>>>,>>9.99" ) )
               + " " + trim( abbr )
              ) format "X(126)"
    skip(1)
    space(10) "Разница между суммой в продажных ценах по объекту и суммой в ценах документа без НДС составила: "
               + trim( string( v-sum-sale - v-sum-cost-without-vat, "->>>,>>>,>>>,>>>,>>9.99" ) )
               + " " + trim( abbr )
                                                        format "X(126)"
    skip(1)
    space(10) string( "Торговая наценка составила : "
               + trim( string( ACCUM TOTAL ( marg * gds-dtl.fact-qnty ), "->>>,>>>,>>>,>>>,>>9.99" ) )
               + " " + trim( abbr )
              ) format "X(126)"
    SKIP(1)
    .

if line-counter + 4 > page-size then
    PAGE .
if ( ACCUM TOTAL ( marg * gds-dtl.fact-qnty ) ) <> 0
then do:
    PUT SPACE(10)
            ( if trim(propis) begins trim( abbr ) then string( "0 " + propis ) else propis )
            format "X(120)" SKIP(2).
end.
if trim(v-torgconf-ogr-post) = ""
then do:
    v-torgconf-ogr-post = fill("_",30).
end.
if trim(v-torgconf-ogr-name) = ""
then do:
    v-torgconf-ogr-name = fill("_",30).
end.

PUT SPACE(20) "Зав. складом/Зав. секцией :  " format "X(30)" v-torgconf-ogr-post  format "X(30)" "   " fill("_",30) format "X(30)" "   " v-torgconf-ogr-name format "X(30)" SKIP
space(58) "(должность)" space(25) "(подпись)" space(18) "(расшифровка подписи)"
SKIP.

output CLOSE.
{ rep/q-print.i 8}